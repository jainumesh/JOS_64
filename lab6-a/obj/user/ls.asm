
obj/user/ls.debug:     file format elf64-x86-64


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
  80003c:	e8 da 04 00 00       	callq  80051b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80004e:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  800055:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80005c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800063:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80006a:	48 89 d6             	mov    %rdx,%rsi
  80006d:	48 89 c7             	mov    %rax,%rdi
  800070:	48 b8 04 2c 80 00 00 	movabs $0x802c04,%rax
  800077:	00 00 00 
  80007a:	ff d0                	callq  *%rax
  80007c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800083:	79 3b                	jns    8000c0 <ls+0x7d>
		panic("stat %s: %e", path, r);
  800085:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800088:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80008f:	41 89 d0             	mov    %edx,%r8d
  800092:	48 89 c1             	mov    %rax,%rcx
  800095:	48 ba 20 49 80 00 00 	movabs $0x804920,%rdx
  80009c:	00 00 00 
  80009f:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a4:	48 bf 2c 49 80 00 00 	movabs $0x80492c,%rdi
  8000ab:	00 00 00 
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	49 b9 c9 05 80 00 00 	movabs $0x8005c9,%r9
  8000ba:	00 00 00 
  8000bd:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	74 36                	je     8000fd <ls+0xba>
  8000c7:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8000ce:	00 00 00 
  8000d1:	8b 80 90 01 00 00    	mov    0x190(%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 22                	jne    8000fd <ls+0xba>
		lsdir(path, prefix);
  8000db:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8000e2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8000e9:	48 89 d6             	mov    %rdx,%rsi
  8000ec:	48 89 c7             	mov    %rax,%rdi
  8000ef:	48 b8 27 01 80 00 00 	movabs $0x800127,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	eb 28                	jmp    800125 <ls+0xe2>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000fd:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800100:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800103:	85 c0                	test   %eax,%eax
  800105:	0f 95 c0             	setne  %al
  800108:	0f b6 c0             	movzbl %al,%eax
  80010b:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800112:	89 c6                	mov    %eax,%esi
  800114:	bf 00 00 00 00       	mov    $0x0,%edi
  800119:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
}
  800125:	c9                   	leaveq 
  800126:	c3                   	retq   

0000000000800127 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  800127:	55                   	push   %rbp
  800128:	48 89 e5             	mov    %rsp,%rbp
  80012b:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800132:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  800139:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800140:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800147:	be 00 00 00 00       	mov    $0x0,%esi
  80014c:	48 89 c7             	mov    %rax,%rdi
  80014f:	48 b8 f2 2c 80 00 00 	movabs $0x802cf2,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
  80015b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800162:	79 3b                	jns    80019f <lsdir+0x78>
		panic("open %s: %e", path, fd);
  800164:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800167:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  80016e:	41 89 d0             	mov    %edx,%r8d
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 36 49 80 00 00 	movabs $0x804936,%rdx
  80017b:	00 00 00 
  80017e:	be 1d 00 00 00       	mov    $0x1d,%esi
  800183:	48 bf 2c 49 80 00 00 	movabs $0x80492c,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 c9 05 80 00 00 	movabs $0x8005c9,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80019f:	eb 3d                	jmp    8001de <lsdir+0xb7>
		if (f.f_name[0])
  8001a1:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 32                	je     8001de <lsdir+0xb7>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8001ac:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  8001b2:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8001b8:	83 f8 01             	cmp    $0x1,%eax
  8001bb:	0f 94 c0             	sete   %al
  8001be:	0f b6 f0             	movzbl %al,%esi
  8001c1:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001c8:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001cf:	48 89 c7             	mov    %rax,%rdi
  8001d2:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  8001d9:	00 00 00 
  8001dc:	ff d0                	callq  *%rax
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001de:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e8:	ba 00 01 00 00       	mov    $0x100,%edx
  8001ed:	48 89 ce             	mov    %rcx,%rsi
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	48 b8 f1 28 80 00 00 	movabs $0x8028f1,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax
  8001fe:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800201:	81 7d f8 00 01 00 00 	cmpl   $0x100,-0x8(%rbp)
  800208:	74 97                	je     8001a1 <lsdir+0x7a>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  80020a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80020e:	7e 35                	jle    800245 <lsdir+0x11e>
		panic("short read in directory %s", path);
  800210:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800217:	48 89 c1             	mov    %rax,%rcx
  80021a:	48 ba 42 49 80 00 00 	movabs $0x804942,%rdx
  800221:	00 00 00 
  800224:	be 22 00 00 00       	mov    $0x22,%esi
  800229:	48 bf 2c 49 80 00 00 	movabs $0x80492c,%rdi
  800230:	00 00 00 
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	49 b8 c9 05 80 00 00 	movabs $0x8005c9,%r8
  80023f:	00 00 00 
  800242:	41 ff d0             	callq  *%r8
	if (n < 0)
  800245:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800249:	79 3b                	jns    800286 <lsdir+0x15f>
		panic("error reading directory %s: %e", path, n);
  80024b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80024e:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800255:	41 89 d0             	mov    %edx,%r8d
  800258:	48 89 c1             	mov    %rax,%rcx
  80025b:	48 ba 60 49 80 00 00 	movabs $0x804960,%rdx
  800262:	00 00 00 
  800265:	be 24 00 00 00       	mov    $0x24,%esi
  80026a:	48 bf 2c 49 80 00 00 	movabs $0x80492c,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b9 c9 05 80 00 00 	movabs $0x8005c9,%r9
  800280:	00 00 00 
  800283:	41 ff d1             	callq  *%r9
}
  800286:	c9                   	leaveq 
  800287:	c3                   	retq   

0000000000800288 <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
  80028c:	48 83 ec 30          	sub    $0x30,%rsp
  800290:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800294:	89 f0                	mov    %esi,%eax
  800296:	89 55 e0             	mov    %edx,-0x20(%rbp)
  800299:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  80029d:	88 45 e4             	mov    %al,-0x1c(%rbp)
	const char *sep;

	if(flag['l'])
  8002a0:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8002a7:	00 00 00 
  8002aa:	8b 80 b0 01 00 00    	mov    0x1b0(%rax),%eax
  8002b0:	85 c0                	test   %eax,%eax
  8002b2:	74 34                	je     8002e8 <ls1+0x60>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  8002b4:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  8002b8:	74 07                	je     8002c1 <ls1+0x39>
  8002ba:	b8 64 00 00 00       	mov    $0x64,%eax
  8002bf:	eb 05                	jmp    8002c6 <ls1+0x3e>
  8002c1:	b8 2d 00 00 00       	mov    $0x2d,%eax
  8002c6:	8b 4d e0             	mov    -0x20(%rbp),%ecx
  8002c9:	89 c2                	mov    %eax,%edx
  8002cb:	89 ce                	mov    %ecx,%esi
  8002cd:	48 bf 7f 49 80 00 00 	movabs $0x80497f,%rdi
  8002d4:	00 00 00 
  8002d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dc:	48 b9 56 35 80 00 00 	movabs $0x803556,%rcx
  8002e3:	00 00 00 
  8002e6:	ff d1                	callq  *%rcx
	if(prefix) {
  8002e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8002ed:	74 76                	je     800365 <ls1+0xdd>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8002ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002f3:	0f b6 00             	movzbl (%rax),%eax
  8002f6:	84 c0                	test   %al,%al
  8002f8:	74 37                	je     800331 <ls1+0xa9>
  8002fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002fe:	48 89 c7             	mov    %rax,%rdi
  800301:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  800308:	00 00 00 
  80030b:	ff d0                	callq  *%rax
  80030d:	48 98                	cltq   
  80030f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800313:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800317:	48 01 d0             	add    %rdx,%rax
  80031a:	0f b6 00             	movzbl (%rax),%eax
  80031d:	3c 2f                	cmp    $0x2f,%al
  80031f:	74 10                	je     800331 <ls1+0xa9>
			sep = "/";
  800321:	48 b8 88 49 80 00 00 	movabs $0x804988,%rax
  800328:	00 00 00 
  80032b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032f:	eb 0e                	jmp    80033f <ls1+0xb7>
		else
			sep = "";
  800331:	48 b8 8a 49 80 00 00 	movabs $0x80498a,%rax
  800338:	00 00 00 
  80033b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800347:	48 89 c6             	mov    %rax,%rsi
  80034a:	48 bf 8b 49 80 00 00 	movabs $0x80498b,%rdi
  800351:	00 00 00 
  800354:	b8 00 00 00 00       	mov    $0x0,%eax
  800359:	48 b9 56 35 80 00 00 	movabs $0x803556,%rcx
  800360:	00 00 00 
  800363:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800365:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800369:	48 89 c6             	mov    %rax,%rsi
  80036c:	48 bf 90 49 80 00 00 	movabs $0x804990,%rdi
  800373:	00 00 00 
  800376:	b8 00 00 00 00       	mov    $0x0,%eax
  80037b:	48 ba 56 35 80 00 00 	movabs $0x803556,%rdx
  800382:	00 00 00 
  800385:	ff d2                	callq  *%rdx
	if(flag['F'] && isdir)
  800387:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80038e:	00 00 00 
  800391:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800397:	85 c0                	test   %eax,%eax
  800399:	74 21                	je     8003bc <ls1+0x134>
  80039b:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039f:	74 1b                	je     8003bc <ls1+0x134>
		printf("/");
  8003a1:	48 bf 88 49 80 00 00 	movabs $0x804988,%rdi
  8003a8:	00 00 00 
  8003ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b0:	48 ba 56 35 80 00 00 	movabs $0x803556,%rdx
  8003b7:	00 00 00 
  8003ba:	ff d2                	callq  *%rdx
	printf("\n");
  8003bc:	48 bf 93 49 80 00 00 	movabs $0x804993,%rdi
  8003c3:	00 00 00 
  8003c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cb:	48 ba 56 35 80 00 00 	movabs $0x803556,%rdx
  8003d2:	00 00 00 
  8003d5:	ff d2                	callq  *%rdx
}
  8003d7:	c9                   	leaveq 
  8003d8:	c3                   	retq   

00000000008003d9 <usage>:

void
usage(void)
{
  8003d9:	55                   	push   %rbp
  8003da:	48 89 e5             	mov    %rsp,%rbp
	printf("usage: ls [-dFl] [file...]\n");
  8003dd:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  8003e4:	00 00 00 
  8003e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ec:	48 ba 56 35 80 00 00 	movabs $0x803556,%rdx
  8003f3:	00 00 00 
  8003f6:	ff d2                	callq  *%rdx
	exit();
  8003f8:	48 b8 a6 05 80 00 00 	movabs $0x8005a6,%rax
  8003ff:	00 00 00 
  800402:	ff d0                	callq  *%rax
}
  800404:	5d                   	pop    %rbp
  800405:	c3                   	retq   

0000000000800406 <umain>:

void
umain(int argc, char **argv)
{
  800406:	55                   	push   %rbp
  800407:	48 89 e5             	mov    %rsp,%rbp
  80040a:	48 83 ec 40          	sub    $0x40,%rsp
  80040e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800411:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800415:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800419:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80041d:	48 8d 45 cc          	lea    -0x34(%rbp),%rax
  800421:	48 89 ce             	mov    %rcx,%rsi
  800424:	48 89 c7             	mov    %rax,%rdi
  800427:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  800433:	eb 49                	jmp    80047e <umain+0x78>
		switch (i) {
  800435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800438:	83 f8 64             	cmp    $0x64,%eax
  80043b:	74 0a                	je     800447 <umain+0x41>
  80043d:	83 f8 6c             	cmp    $0x6c,%eax
  800440:	74 05                	je     800447 <umain+0x41>
  800442:	83 f8 46             	cmp    $0x46,%eax
  800445:	75 2b                	jne    800472 <umain+0x6c>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800447:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80044e:	00 00 00 
  800451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800454:	48 63 d2             	movslq %edx,%rdx
  800457:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  80045a:	8d 48 01             	lea    0x1(%rax),%ecx
  80045d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800464:	00 00 00 
  800467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80046a:	48 63 d2             	movslq %edx,%rdx
  80046d:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
			break;
  800470:	eb 0c                	jmp    80047e <umain+0x78>
		default:
			usage();
  800472:	48 b8 d9 03 80 00 00 	movabs $0x8003d9,%rax
  800479:	00 00 00 
  80047c:	ff d0                	callq  *%rax
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  80047e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800482:	48 89 c7             	mov    %rax,%rdi
  800485:	48 b8 83 20 80 00 00 	movabs $0x802083,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 9b                	jns    800435 <umain+0x2f>
			break;
		default:
			usage();
		}

	if (argc == 1)
  80049a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80049d:	83 f8 01             	cmp    $0x1,%eax
  8004a0:	75 22                	jne    8004c4 <umain+0xbe>
		ls("/", "");
  8004a2:	48 be 8a 49 80 00 00 	movabs $0x80498a,%rsi
  8004a9:	00 00 00 
  8004ac:	48 bf 88 49 80 00 00 	movabs $0x804988,%rdi
  8004b3:	00 00 00 
  8004b6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
  8004c2:	eb 55                	jmp    800519 <umain+0x113>
	else {
		for (i = 1; i < argc; i++)
  8004c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8004cb:	eb 44                	jmp    800511 <umain+0x10b>
			ls(argv[i], argv[i]);
  8004cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d0:	48 98                	cltq   
  8004d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004d9:	00 
  8004da:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004de:	48 01 d0             	add    %rdx,%rax
  8004e1:	48 8b 10             	mov    (%rax),%rdx
  8004e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e7:	48 98                	cltq   
  8004e9:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8004f0:	00 
  8004f1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004f5:	48 01 c8             	add    %rcx,%rax
  8004f8:	48 8b 00             	mov    (%rax),%rax
  8004fb:	48 89 d6             	mov    %rdx,%rsi
  8004fe:	48 89 c7             	mov    %rax,%rdi
  800501:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80050d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800511:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800514:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800517:	7c b4                	jl     8004cd <umain+0xc7>
			ls(argv[i], argv[i]);
	}
}
  800519:	c9                   	leaveq 
  80051a:	c3                   	retq   

000000000080051b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80051b:	55                   	push   %rbp
  80051c:	48 89 e5             	mov    %rsp,%rbp
  80051f:	48 83 ec 10          	sub    $0x10,%rsp
  800523:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800526:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80052a:	48 b8 6a 1c 80 00 00 	movabs $0x801c6a,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
  800536:	25 ff 03 00 00       	and    $0x3ff,%eax
  80053b:	48 63 d0             	movslq %eax,%rdx
  80053e:	48 89 d0             	mov    %rdx,%rax
  800541:	48 c1 e0 03          	shl    $0x3,%rax
  800545:	48 01 d0             	add    %rdx,%rax
  800548:	48 c1 e0 05          	shl    $0x5,%rax
  80054c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800553:	00 00 00 
  800556:	48 01 c2             	add    %rax,%rdx
  800559:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  800560:	00 00 00 
  800563:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800566:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80056a:	7e 14                	jle    800580 <libmain+0x65>
		binaryname = argv[0];
  80056c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800570:	48 8b 10             	mov    (%rax),%rdx
  800573:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80057a:	00 00 00 
  80057d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800580:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800584:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800587:	48 89 d6             	mov    %rdx,%rsi
  80058a:	89 c7                	mov    %eax,%edi
  80058c:	48 b8 06 04 80 00 00 	movabs $0x800406,%rax
  800593:	00 00 00 
  800596:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800598:	48 b8 a6 05 80 00 00 	movabs $0x8005a6,%rax
  80059f:	00 00 00 
  8005a2:	ff d0                	callq  *%rax
}
  8005a4:	c9                   	leaveq 
  8005a5:	c3                   	retq   

00000000008005a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005a6:	55                   	push   %rbp
  8005a7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8005aa:	48 b8 45 26 80 00 00 	movabs $0x802645,%rax
  8005b1:	00 00 00 
  8005b4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8005b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8005bb:	48 b8 26 1c 80 00 00 	movabs $0x801c26,%rax
  8005c2:	00 00 00 
  8005c5:	ff d0                	callq  *%rax

}
  8005c7:	5d                   	pop    %rbp
  8005c8:	c3                   	retq   

00000000008005c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005c9:	55                   	push   %rbp
  8005ca:	48 89 e5             	mov    %rsp,%rbp
  8005cd:	53                   	push   %rbx
  8005ce:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005d5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005dc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005e2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005e9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005f0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005f7:	84 c0                	test   %al,%al
  8005f9:	74 23                	je     80061e <_panic+0x55>
  8005fb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800602:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800606:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80060a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80060e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800612:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800616:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80061a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80061e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800625:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80062c:	00 00 00 
  80062f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800636:	00 00 00 
  800639:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80063d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800644:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80064b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800652:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800659:	00 00 00 
  80065c:	48 8b 18             	mov    (%rax),%rbx
  80065f:	48 b8 6a 1c 80 00 00 	movabs $0x801c6a,%rax
  800666:	00 00 00 
  800669:	ff d0                	callq  *%rax
  80066b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800671:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800678:	41 89 c8             	mov    %ecx,%r8d
  80067b:	48 89 d1             	mov    %rdx,%rcx
  80067e:	48 89 da             	mov    %rbx,%rdx
  800681:	89 c6                	mov    %eax,%esi
  800683:	48 bf c0 49 80 00 00 	movabs $0x8049c0,%rdi
  80068a:	00 00 00 
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	49 b9 02 08 80 00 00 	movabs $0x800802,%r9
  800699:	00 00 00 
  80069c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80069f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006a6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006ad:	48 89 d6             	mov    %rdx,%rsi
  8006b0:	48 89 c7             	mov    %rax,%rdi
  8006b3:	48 b8 56 07 80 00 00 	movabs $0x800756,%rax
  8006ba:	00 00 00 
  8006bd:	ff d0                	callq  *%rax
	cprintf("\n");
  8006bf:	48 bf e3 49 80 00 00 	movabs $0x8049e3,%rdi
  8006c6:	00 00 00 
  8006c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ce:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  8006d5:	00 00 00 
  8006d8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006da:	cc                   	int3   
  8006db:	eb fd                	jmp    8006da <_panic+0x111>

00000000008006dd <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006dd:	55                   	push   %rbp
  8006de:	48 89 e5             	mov    %rsp,%rbp
  8006e1:	48 83 ec 10          	sub    $0x10,%rsp
  8006e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f0:	8b 00                	mov    (%rax),%eax
  8006f2:	8d 48 01             	lea    0x1(%rax),%ecx
  8006f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f9:	89 0a                	mov    %ecx,(%rdx)
  8006fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006fe:	89 d1                	mov    %edx,%ecx
  800700:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800704:	48 98                	cltq   
  800706:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80070a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80070e:	8b 00                	mov    (%rax),%eax
  800710:	3d ff 00 00 00       	cmp    $0xff,%eax
  800715:	75 2c                	jne    800743 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80071b:	8b 00                	mov    (%rax),%eax
  80071d:	48 98                	cltq   
  80071f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800723:	48 83 c2 08          	add    $0x8,%rdx
  800727:	48 89 c6             	mov    %rax,%rsi
  80072a:	48 89 d7             	mov    %rdx,%rdi
  80072d:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  800734:	00 00 00 
  800737:	ff d0                	callq  *%rax
        b->idx = 0;
  800739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80073d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800743:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800747:	8b 40 04             	mov    0x4(%rax),%eax
  80074a:	8d 50 01             	lea    0x1(%rax),%edx
  80074d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800751:	89 50 04             	mov    %edx,0x4(%rax)
}
  800754:	c9                   	leaveq 
  800755:	c3                   	retq   

0000000000800756 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800756:	55                   	push   %rbp
  800757:	48 89 e5             	mov    %rsp,%rbp
  80075a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800761:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800768:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80076f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800776:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80077d:	48 8b 0a             	mov    (%rdx),%rcx
  800780:	48 89 08             	mov    %rcx,(%rax)
  800783:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800787:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80078b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80078f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800793:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80079a:	00 00 00 
    b.cnt = 0;
  80079d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007a4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8007a7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007ae:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007b5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007bc:	48 89 c6             	mov    %rax,%rsi
  8007bf:	48 bf dd 06 80 00 00 	movabs $0x8006dd,%rdi
  8007c6:	00 00 00 
  8007c9:	48 b8 b5 0b 80 00 00 	movabs $0x800bb5,%rax
  8007d0:	00 00 00 
  8007d3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007d5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007e4:	48 83 c2 08          	add    $0x8,%rdx
  8007e8:	48 89 c6             	mov    %rax,%rsi
  8007eb:	48 89 d7             	mov    %rdx,%rdi
  8007ee:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  8007f5:	00 00 00 
  8007f8:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007fa:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80080d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800814:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80081b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800822:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800829:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800830:	84 c0                	test   %al,%al
  800832:	74 20                	je     800854 <cprintf+0x52>
  800834:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800838:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80083c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800840:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800844:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800848:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80084c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800850:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800854:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80085b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800862:	00 00 00 
  800865:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80086c:	00 00 00 
  80086f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800873:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80087a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800881:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800888:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80088f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800896:	48 8b 0a             	mov    (%rdx),%rcx
  800899:	48 89 08             	mov    %rcx,(%rax)
  80089c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008a0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008a4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008a8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008ac:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008b3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008ba:	48 89 d6             	mov    %rdx,%rsi
  8008bd:	48 89 c7             	mov    %rax,%rdi
  8008c0:	48 b8 56 07 80 00 00 	movabs $0x800756,%rax
  8008c7:	00 00 00 
  8008ca:	ff d0                	callq  *%rax
  8008cc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008d2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008d8:	c9                   	leaveq 
  8008d9:	c3                   	retq   

00000000008008da <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008da:	55                   	push   %rbp
  8008db:	48 89 e5             	mov    %rsp,%rbp
  8008de:	53                   	push   %rbx
  8008df:	48 83 ec 38          	sub    $0x38,%rsp
  8008e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8008eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8008ef:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8008f2:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8008f6:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008fa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8008fd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800901:	77 3b                	ja     80093e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800903:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800906:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80090a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80090d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800911:	ba 00 00 00 00       	mov    $0x0,%edx
  800916:	48 f7 f3             	div    %rbx
  800919:	48 89 c2             	mov    %rax,%rdx
  80091c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80091f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800922:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800926:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092a:	41 89 f9             	mov    %edi,%r9d
  80092d:	48 89 c7             	mov    %rax,%rdi
  800930:	48 b8 da 08 80 00 00 	movabs $0x8008da,%rax
  800937:	00 00 00 
  80093a:	ff d0                	callq  *%rax
  80093c:	eb 1e                	jmp    80095c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80093e:	eb 12                	jmp    800952 <printnum+0x78>
			putch(padc, putdat);
  800940:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800944:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094b:	48 89 ce             	mov    %rcx,%rsi
  80094e:	89 d7                	mov    %edx,%edi
  800950:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800952:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800956:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80095a:	7f e4                	jg     800940 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80095c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80095f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800963:	ba 00 00 00 00       	mov    $0x0,%edx
  800968:	48 f7 f1             	div    %rcx
  80096b:	48 89 d0             	mov    %rdx,%rax
  80096e:	48 ba f0 4b 80 00 00 	movabs $0x804bf0,%rdx
  800975:	00 00 00 
  800978:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80097c:	0f be d0             	movsbl %al,%edx
  80097f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800987:	48 89 ce             	mov    %rcx,%rsi
  80098a:	89 d7                	mov    %edx,%edi
  80098c:	ff d0                	callq  *%rax
}
  80098e:	48 83 c4 38          	add    $0x38,%rsp
  800992:	5b                   	pop    %rbx
  800993:	5d                   	pop    %rbp
  800994:	c3                   	retq   

0000000000800995 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800995:	55                   	push   %rbp
  800996:	48 89 e5             	mov    %rsp,%rbp
  800999:	48 83 ec 1c          	sub    $0x1c,%rsp
  80099d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009a1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8009a4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009a8:	7e 52                	jle    8009fc <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ae:	8b 00                	mov    (%rax),%eax
  8009b0:	83 f8 30             	cmp    $0x30,%eax
  8009b3:	73 24                	jae    8009d9 <getuint+0x44>
  8009b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c1:	8b 00                	mov    (%rax),%eax
  8009c3:	89 c0                	mov    %eax,%eax
  8009c5:	48 01 d0             	add    %rdx,%rax
  8009c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cc:	8b 12                	mov    (%rdx),%edx
  8009ce:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d5:	89 0a                	mov    %ecx,(%rdx)
  8009d7:	eb 17                	jmp    8009f0 <getuint+0x5b>
  8009d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e1:	48 89 d0             	mov    %rdx,%rax
  8009e4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f0:	48 8b 00             	mov    (%rax),%rax
  8009f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009f7:	e9 a3 00 00 00       	jmpq   800a9f <getuint+0x10a>
	else if (lflag)
  8009fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a00:	74 4f                	je     800a51 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a06:	8b 00                	mov    (%rax),%eax
  800a08:	83 f8 30             	cmp    $0x30,%eax
  800a0b:	73 24                	jae    800a31 <getuint+0x9c>
  800a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a11:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a19:	8b 00                	mov    (%rax),%eax
  800a1b:	89 c0                	mov    %eax,%eax
  800a1d:	48 01 d0             	add    %rdx,%rax
  800a20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a24:	8b 12                	mov    (%rdx),%edx
  800a26:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2d:	89 0a                	mov    %ecx,(%rdx)
  800a2f:	eb 17                	jmp    800a48 <getuint+0xb3>
  800a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a35:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a39:	48 89 d0             	mov    %rdx,%rax
  800a3c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a44:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a48:	48 8b 00             	mov    (%rax),%rax
  800a4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a4f:	eb 4e                	jmp    800a9f <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a55:	8b 00                	mov    (%rax),%eax
  800a57:	83 f8 30             	cmp    $0x30,%eax
  800a5a:	73 24                	jae    800a80 <getuint+0xeb>
  800a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a60:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a68:	8b 00                	mov    (%rax),%eax
  800a6a:	89 c0                	mov    %eax,%eax
  800a6c:	48 01 d0             	add    %rdx,%rax
  800a6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a73:	8b 12                	mov    (%rdx),%edx
  800a75:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7c:	89 0a                	mov    %ecx,(%rdx)
  800a7e:	eb 17                	jmp    800a97 <getuint+0x102>
  800a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a84:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a88:	48 89 d0             	mov    %rdx,%rax
  800a8b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a93:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a97:	8b 00                	mov    (%rax),%eax
  800a99:	89 c0                	mov    %eax,%eax
  800a9b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800aa3:	c9                   	leaveq 
  800aa4:	c3                   	retq   

0000000000800aa5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800aa5:	55                   	push   %rbp
  800aa6:	48 89 e5             	mov    %rsp,%rbp
  800aa9:	48 83 ec 1c          	sub    $0x1c,%rsp
  800aad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ab1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800ab4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ab8:	7e 52                	jle    800b0c <getint+0x67>
		x=va_arg(*ap, long long);
  800aba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abe:	8b 00                	mov    (%rax),%eax
  800ac0:	83 f8 30             	cmp    $0x30,%eax
  800ac3:	73 24                	jae    800ae9 <getint+0x44>
  800ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800acd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad1:	8b 00                	mov    (%rax),%eax
  800ad3:	89 c0                	mov    %eax,%eax
  800ad5:	48 01 d0             	add    %rdx,%rax
  800ad8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800adc:	8b 12                	mov    (%rdx),%edx
  800ade:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ae1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae5:	89 0a                	mov    %ecx,(%rdx)
  800ae7:	eb 17                	jmp    800b00 <getint+0x5b>
  800ae9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800af1:	48 89 d0             	mov    %rdx,%rax
  800af4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800afc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b00:	48 8b 00             	mov    (%rax),%rax
  800b03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b07:	e9 a3 00 00 00       	jmpq   800baf <getint+0x10a>
	else if (lflag)
  800b0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b10:	74 4f                	je     800b61 <getint+0xbc>
		x=va_arg(*ap, long);
  800b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b16:	8b 00                	mov    (%rax),%eax
  800b18:	83 f8 30             	cmp    $0x30,%eax
  800b1b:	73 24                	jae    800b41 <getint+0x9c>
  800b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b21:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b29:	8b 00                	mov    (%rax),%eax
  800b2b:	89 c0                	mov    %eax,%eax
  800b2d:	48 01 d0             	add    %rdx,%rax
  800b30:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b34:	8b 12                	mov    (%rdx),%edx
  800b36:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b3d:	89 0a                	mov    %ecx,(%rdx)
  800b3f:	eb 17                	jmp    800b58 <getint+0xb3>
  800b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b45:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b49:	48 89 d0             	mov    %rdx,%rax
  800b4c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b54:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b58:	48 8b 00             	mov    (%rax),%rax
  800b5b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b5f:	eb 4e                	jmp    800baf <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b65:	8b 00                	mov    (%rax),%eax
  800b67:	83 f8 30             	cmp    $0x30,%eax
  800b6a:	73 24                	jae    800b90 <getint+0xeb>
  800b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b70:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b78:	8b 00                	mov    (%rax),%eax
  800b7a:	89 c0                	mov    %eax,%eax
  800b7c:	48 01 d0             	add    %rdx,%rax
  800b7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b83:	8b 12                	mov    (%rdx),%edx
  800b85:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b8c:	89 0a                	mov    %ecx,(%rdx)
  800b8e:	eb 17                	jmp    800ba7 <getint+0x102>
  800b90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b94:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b98:	48 89 d0             	mov    %rdx,%rax
  800b9b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ba7:	8b 00                	mov    (%rax),%eax
  800ba9:	48 98                	cltq   
  800bab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800baf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bb3:	c9                   	leaveq 
  800bb4:	c3                   	retq   

0000000000800bb5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb5:	55                   	push   %rbp
  800bb6:	48 89 e5             	mov    %rsp,%rbp
  800bb9:	41 54                	push   %r12
  800bbb:	53                   	push   %rbx
  800bbc:	48 83 ec 60          	sub    $0x60,%rsp
  800bc0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bc4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bc8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bcc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bd0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bd4:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bd8:	48 8b 0a             	mov    (%rdx),%rcx
  800bdb:	48 89 08             	mov    %rcx,(%rax)
  800bde:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800be2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800be6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bea:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bee:	eb 17                	jmp    800c07 <vprintfmt+0x52>
			if (ch == '\0')
  800bf0:	85 db                	test   %ebx,%ebx
  800bf2:	0f 84 cc 04 00 00    	je     8010c4 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800bf8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c00:	48 89 d6             	mov    %rdx,%rsi
  800c03:	89 df                	mov    %ebx,%edi
  800c05:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c07:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c0b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c0f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c13:	0f b6 00             	movzbl (%rax),%eax
  800c16:	0f b6 d8             	movzbl %al,%ebx
  800c19:	83 fb 25             	cmp    $0x25,%ebx
  800c1c:	75 d2                	jne    800bf0 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c1e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c22:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c29:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c30:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c37:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c42:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c46:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c4a:	0f b6 00             	movzbl (%rax),%eax
  800c4d:	0f b6 d8             	movzbl %al,%ebx
  800c50:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c53:	83 f8 55             	cmp    $0x55,%eax
  800c56:	0f 87 34 04 00 00    	ja     801090 <vprintfmt+0x4db>
  800c5c:	89 c0                	mov    %eax,%eax
  800c5e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c65:	00 
  800c66:	48 b8 18 4c 80 00 00 	movabs $0x804c18,%rax
  800c6d:	00 00 00 
  800c70:	48 01 d0             	add    %rdx,%rax
  800c73:	48 8b 00             	mov    (%rax),%rax
  800c76:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c78:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c7c:	eb c0                	jmp    800c3e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c7e:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c82:	eb ba                	jmp    800c3e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c84:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c8b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c8e:	89 d0                	mov    %edx,%eax
  800c90:	c1 e0 02             	shl    $0x2,%eax
  800c93:	01 d0                	add    %edx,%eax
  800c95:	01 c0                	add    %eax,%eax
  800c97:	01 d8                	add    %ebx,%eax
  800c99:	83 e8 30             	sub    $0x30,%eax
  800c9c:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c9f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ca3:	0f b6 00             	movzbl (%rax),%eax
  800ca6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ca9:	83 fb 2f             	cmp    $0x2f,%ebx
  800cac:	7e 0c                	jle    800cba <vprintfmt+0x105>
  800cae:	83 fb 39             	cmp    $0x39,%ebx
  800cb1:	7f 07                	jg     800cba <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cb8:	eb d1                	jmp    800c8b <vprintfmt+0xd6>
			goto process_precision;
  800cba:	eb 58                	jmp    800d14 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800cbc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cbf:	83 f8 30             	cmp    $0x30,%eax
  800cc2:	73 17                	jae    800cdb <vprintfmt+0x126>
  800cc4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cc8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccb:	89 c0                	mov    %eax,%eax
  800ccd:	48 01 d0             	add    %rdx,%rax
  800cd0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd3:	83 c2 08             	add    $0x8,%edx
  800cd6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cd9:	eb 0f                	jmp    800cea <vprintfmt+0x135>
  800cdb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cdf:	48 89 d0             	mov    %rdx,%rax
  800ce2:	48 83 c2 08          	add    $0x8,%rdx
  800ce6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cea:	8b 00                	mov    (%rax),%eax
  800cec:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cef:	eb 23                	jmp    800d14 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800cf1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf5:	79 0c                	jns    800d03 <vprintfmt+0x14e>
				width = 0;
  800cf7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800cfe:	e9 3b ff ff ff       	jmpq   800c3e <vprintfmt+0x89>
  800d03:	e9 36 ff ff ff       	jmpq   800c3e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d08:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d0f:	e9 2a ff ff ff       	jmpq   800c3e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d14:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d18:	79 12                	jns    800d2c <vprintfmt+0x177>
				width = precision, precision = -1;
  800d1a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d1d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d20:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d27:	e9 12 ff ff ff       	jmpq   800c3e <vprintfmt+0x89>
  800d2c:	e9 0d ff ff ff       	jmpq   800c3e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d31:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d35:	e9 04 ff ff ff       	jmpq   800c3e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3d:	83 f8 30             	cmp    $0x30,%eax
  800d40:	73 17                	jae    800d59 <vprintfmt+0x1a4>
  800d42:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d49:	89 c0                	mov    %eax,%eax
  800d4b:	48 01 d0             	add    %rdx,%rax
  800d4e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d51:	83 c2 08             	add    $0x8,%edx
  800d54:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d57:	eb 0f                	jmp    800d68 <vprintfmt+0x1b3>
  800d59:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d5d:	48 89 d0             	mov    %rdx,%rax
  800d60:	48 83 c2 08          	add    $0x8,%rdx
  800d64:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d68:	8b 10                	mov    (%rax),%edx
  800d6a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d72:	48 89 ce             	mov    %rcx,%rsi
  800d75:	89 d7                	mov    %edx,%edi
  800d77:	ff d0                	callq  *%rax
			break;
  800d79:	e9 40 03 00 00       	jmpq   8010be <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d81:	83 f8 30             	cmp    $0x30,%eax
  800d84:	73 17                	jae    800d9d <vprintfmt+0x1e8>
  800d86:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8d:	89 c0                	mov    %eax,%eax
  800d8f:	48 01 d0             	add    %rdx,%rax
  800d92:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d95:	83 c2 08             	add    $0x8,%edx
  800d98:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d9b:	eb 0f                	jmp    800dac <vprintfmt+0x1f7>
  800d9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da1:	48 89 d0             	mov    %rdx,%rax
  800da4:	48 83 c2 08          	add    $0x8,%rdx
  800da8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dac:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800dae:	85 db                	test   %ebx,%ebx
  800db0:	79 02                	jns    800db4 <vprintfmt+0x1ff>
				err = -err;
  800db2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800db4:	83 fb 15             	cmp    $0x15,%ebx
  800db7:	7f 16                	jg     800dcf <vprintfmt+0x21a>
  800db9:	48 b8 40 4b 80 00 00 	movabs $0x804b40,%rax
  800dc0:	00 00 00 
  800dc3:	48 63 d3             	movslq %ebx,%rdx
  800dc6:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800dca:	4d 85 e4             	test   %r12,%r12
  800dcd:	75 2e                	jne    800dfd <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800dcf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd7:	89 d9                	mov    %ebx,%ecx
  800dd9:	48 ba 01 4c 80 00 00 	movabs $0x804c01,%rdx
  800de0:	00 00 00 
  800de3:	48 89 c7             	mov    %rax,%rdi
  800de6:	b8 00 00 00 00       	mov    $0x0,%eax
  800deb:	49 b8 cd 10 80 00 00 	movabs $0x8010cd,%r8
  800df2:	00 00 00 
  800df5:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800df8:	e9 c1 02 00 00       	jmpq   8010be <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dfd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e05:	4c 89 e1             	mov    %r12,%rcx
  800e08:	48 ba 0a 4c 80 00 00 	movabs $0x804c0a,%rdx
  800e0f:	00 00 00 
  800e12:	48 89 c7             	mov    %rax,%rdi
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	49 b8 cd 10 80 00 00 	movabs $0x8010cd,%r8
  800e21:	00 00 00 
  800e24:	41 ff d0             	callq  *%r8
			break;
  800e27:	e9 92 02 00 00       	jmpq   8010be <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e2c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e2f:	83 f8 30             	cmp    $0x30,%eax
  800e32:	73 17                	jae    800e4b <vprintfmt+0x296>
  800e34:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e3b:	89 c0                	mov    %eax,%eax
  800e3d:	48 01 d0             	add    %rdx,%rax
  800e40:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e43:	83 c2 08             	add    $0x8,%edx
  800e46:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e49:	eb 0f                	jmp    800e5a <vprintfmt+0x2a5>
  800e4b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e4f:	48 89 d0             	mov    %rdx,%rax
  800e52:	48 83 c2 08          	add    $0x8,%rdx
  800e56:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e5a:	4c 8b 20             	mov    (%rax),%r12
  800e5d:	4d 85 e4             	test   %r12,%r12
  800e60:	75 0a                	jne    800e6c <vprintfmt+0x2b7>
				p = "(null)";
  800e62:	49 bc 0d 4c 80 00 00 	movabs $0x804c0d,%r12
  800e69:	00 00 00 
			if (width > 0 && padc != '-')
  800e6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e70:	7e 3f                	jle    800eb1 <vprintfmt+0x2fc>
  800e72:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e76:	74 39                	je     800eb1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e78:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e7b:	48 98                	cltq   
  800e7d:	48 89 c6             	mov    %rax,%rsi
  800e80:	4c 89 e7             	mov    %r12,%rdi
  800e83:	48 b8 79 13 80 00 00 	movabs $0x801379,%rax
  800e8a:	00 00 00 
  800e8d:	ff d0                	callq  *%rax
  800e8f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e92:	eb 17                	jmp    800eab <vprintfmt+0x2f6>
					putch(padc, putdat);
  800e94:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e98:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea0:	48 89 ce             	mov    %rcx,%rsi
  800ea3:	89 d7                	mov    %edx,%edi
  800ea5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eaf:	7f e3                	jg     800e94 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb1:	eb 37                	jmp    800eea <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800eb3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800eb7:	74 1e                	je     800ed7 <vprintfmt+0x322>
  800eb9:	83 fb 1f             	cmp    $0x1f,%ebx
  800ebc:	7e 05                	jle    800ec3 <vprintfmt+0x30e>
  800ebe:	83 fb 7e             	cmp    $0x7e,%ebx
  800ec1:	7e 14                	jle    800ed7 <vprintfmt+0x322>
					putch('?', putdat);
  800ec3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ecb:	48 89 d6             	mov    %rdx,%rsi
  800ece:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ed3:	ff d0                	callq  *%rax
  800ed5:	eb 0f                	jmp    800ee6 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800ed7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800edb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edf:	48 89 d6             	mov    %rdx,%rsi
  800ee2:	89 df                	mov    %ebx,%edi
  800ee4:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ee6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eea:	4c 89 e0             	mov    %r12,%rax
  800eed:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ef1:	0f b6 00             	movzbl (%rax),%eax
  800ef4:	0f be d8             	movsbl %al,%ebx
  800ef7:	85 db                	test   %ebx,%ebx
  800ef9:	74 10                	je     800f0b <vprintfmt+0x356>
  800efb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800eff:	78 b2                	js     800eb3 <vprintfmt+0x2fe>
  800f01:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f05:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f09:	79 a8                	jns    800eb3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f0b:	eb 16                	jmp    800f23 <vprintfmt+0x36e>
				putch(' ', putdat);
  800f0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f15:	48 89 d6             	mov    %rdx,%rsi
  800f18:	bf 20 00 00 00       	mov    $0x20,%edi
  800f1d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f1f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f23:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f27:	7f e4                	jg     800f0d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800f29:	e9 90 01 00 00       	jmpq   8010be <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f2e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f32:	be 03 00 00 00       	mov    $0x3,%esi
  800f37:	48 89 c7             	mov    %rax,%rdi
  800f3a:	48 b8 a5 0a 80 00 00 	movabs $0x800aa5,%rax
  800f41:	00 00 00 
  800f44:	ff d0                	callq  *%rax
  800f46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4e:	48 85 c0             	test   %rax,%rax
  800f51:	79 1d                	jns    800f70 <vprintfmt+0x3bb>
				putch('-', putdat);
  800f53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f5b:	48 89 d6             	mov    %rdx,%rsi
  800f5e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f63:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f69:	48 f7 d8             	neg    %rax
  800f6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f70:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f77:	e9 d5 00 00 00       	jmpq   801051 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f7c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f80:	be 03 00 00 00       	mov    $0x3,%esi
  800f85:	48 89 c7             	mov    %rax,%rdi
  800f88:	48 b8 95 09 80 00 00 	movabs $0x800995,%rax
  800f8f:	00 00 00 
  800f92:	ff d0                	callq  *%rax
  800f94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f98:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f9f:	e9 ad 00 00 00       	jmpq   801051 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800fa4:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800fa7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fab:	89 d6                	mov    %edx,%esi
  800fad:	48 89 c7             	mov    %rax,%rdi
  800fb0:	48 b8 a5 0a 80 00 00 	movabs $0x800aa5,%rax
  800fb7:	00 00 00 
  800fba:	ff d0                	callq  *%rax
  800fbc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800fc0:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800fc7:	e9 85 00 00 00       	jmpq   801051 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800fcc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd4:	48 89 d6             	mov    %rdx,%rsi
  800fd7:	bf 30 00 00 00       	mov    $0x30,%edi
  800fdc:	ff d0                	callq  *%rax
			putch('x', putdat);
  800fde:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe6:	48 89 d6             	mov    %rdx,%rsi
  800fe9:	bf 78 00 00 00       	mov    $0x78,%edi
  800fee:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ff0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ff3:	83 f8 30             	cmp    $0x30,%eax
  800ff6:	73 17                	jae    80100f <vprintfmt+0x45a>
  800ff8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ffc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fff:	89 c0                	mov    %eax,%eax
  801001:	48 01 d0             	add    %rdx,%rax
  801004:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801007:	83 c2 08             	add    $0x8,%edx
  80100a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80100d:	eb 0f                	jmp    80101e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80100f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801013:	48 89 d0             	mov    %rdx,%rax
  801016:	48 83 c2 08          	add    $0x8,%rdx
  80101a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80101e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801021:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801025:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80102c:	eb 23                	jmp    801051 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80102e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801032:	be 03 00 00 00       	mov    $0x3,%esi
  801037:	48 89 c7             	mov    %rax,%rdi
  80103a:	48 b8 95 09 80 00 00 	movabs $0x800995,%rax
  801041:	00 00 00 
  801044:	ff d0                	callq  *%rax
  801046:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80104a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801051:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801056:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801059:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80105c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801060:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801064:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801068:	45 89 c1             	mov    %r8d,%r9d
  80106b:	41 89 f8             	mov    %edi,%r8d
  80106e:	48 89 c7             	mov    %rax,%rdi
  801071:	48 b8 da 08 80 00 00 	movabs $0x8008da,%rax
  801078:	00 00 00 
  80107b:	ff d0                	callq  *%rax
			break;
  80107d:	eb 3f                	jmp    8010be <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80107f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801083:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801087:	48 89 d6             	mov    %rdx,%rsi
  80108a:	89 df                	mov    %ebx,%edi
  80108c:	ff d0                	callq  *%rax
			break;
  80108e:	eb 2e                	jmp    8010be <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801090:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801094:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801098:	48 89 d6             	mov    %rdx,%rsi
  80109b:	bf 25 00 00 00       	mov    $0x25,%edi
  8010a0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010a2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010a7:	eb 05                	jmp    8010ae <vprintfmt+0x4f9>
  8010a9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8010ae:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010b2:	48 83 e8 01          	sub    $0x1,%rax
  8010b6:	0f b6 00             	movzbl (%rax),%eax
  8010b9:	3c 25                	cmp    $0x25,%al
  8010bb:	75 ec                	jne    8010a9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8010bd:	90                   	nop
		}
	}
  8010be:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010bf:	e9 43 fb ff ff       	jmpq   800c07 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8010c4:	48 83 c4 60          	add    $0x60,%rsp
  8010c8:	5b                   	pop    %rbx
  8010c9:	41 5c                	pop    %r12
  8010cb:	5d                   	pop    %rbp
  8010cc:	c3                   	retq   

00000000008010cd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010cd:	55                   	push   %rbp
  8010ce:	48 89 e5             	mov    %rsp,%rbp
  8010d1:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010d8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010df:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010e6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010ed:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010f4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 20                	je     80111f <printfmt+0x52>
  8010ff:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801103:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801107:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80110b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80110f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801113:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801117:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80111b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80111f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801126:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80112d:	00 00 00 
  801130:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801137:	00 00 00 
  80113a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80113e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801145:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80114c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801153:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80115a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801161:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801168:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80116f:	48 89 c7             	mov    %rax,%rdi
  801172:	48 b8 b5 0b 80 00 00 	movabs $0x800bb5,%rax
  801179:	00 00 00 
  80117c:	ff d0                	callq  *%rax
	va_end(ap);
}
  80117e:	c9                   	leaveq 
  80117f:	c3                   	retq   

0000000000801180 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801180:	55                   	push   %rbp
  801181:	48 89 e5             	mov    %rsp,%rbp
  801184:	48 83 ec 10          	sub    $0x10,%rsp
  801188:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80118b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80118f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801193:	8b 40 10             	mov    0x10(%rax),%eax
  801196:	8d 50 01             	lea    0x1(%rax),%edx
  801199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119d:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a4:	48 8b 10             	mov    (%rax),%rdx
  8011a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ab:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011af:	48 39 c2             	cmp    %rax,%rdx
  8011b2:	73 17                	jae    8011cb <sprintputch+0x4b>
		*b->buf++ = ch;
  8011b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b8:	48 8b 00             	mov    (%rax),%rax
  8011bb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011c3:	48 89 0a             	mov    %rcx,(%rdx)
  8011c6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011c9:	88 10                	mov    %dl,(%rax)
}
  8011cb:	c9                   	leaveq 
  8011cc:	c3                   	retq   

00000000008011cd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011cd:	55                   	push   %rbp
  8011ce:	48 89 e5             	mov    %rsp,%rbp
  8011d1:	48 83 ec 50          	sub    $0x50,%rsp
  8011d5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011d9:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011dc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011e0:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011e4:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011e8:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011ec:	48 8b 0a             	mov    (%rdx),%rcx
  8011ef:	48 89 08             	mov    %rcx,(%rax)
  8011f2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011f6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011fa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011fe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801202:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801206:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80120a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80120d:	48 98                	cltq   
  80120f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801213:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801217:	48 01 d0             	add    %rdx,%rax
  80121a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80121e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801225:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80122a:	74 06                	je     801232 <vsnprintf+0x65>
  80122c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801230:	7f 07                	jg     801239 <vsnprintf+0x6c>
		return -E_INVAL;
  801232:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801237:	eb 2f                	jmp    801268 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801239:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80123d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801241:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801245:	48 89 c6             	mov    %rax,%rsi
  801248:	48 bf 80 11 80 00 00 	movabs $0x801180,%rdi
  80124f:	00 00 00 
  801252:	48 b8 b5 0b 80 00 00 	movabs $0x800bb5,%rax
  801259:	00 00 00 
  80125c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80125e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801262:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801265:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801268:	c9                   	leaveq 
  801269:	c3                   	retq   

000000000080126a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80126a:	55                   	push   %rbp
  80126b:	48 89 e5             	mov    %rsp,%rbp
  80126e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801275:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80127c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801282:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801289:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801290:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801297:	84 c0                	test   %al,%al
  801299:	74 20                	je     8012bb <snprintf+0x51>
  80129b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80129f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8012a3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8012a7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8012ab:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8012af:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012b3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012b7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012bb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012c2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012c9:	00 00 00 
  8012cc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012d3:	00 00 00 
  8012d6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012da:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012e1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012e8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012ef:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012f6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012fd:	48 8b 0a             	mov    (%rdx),%rcx
  801300:	48 89 08             	mov    %rcx,(%rax)
  801303:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801307:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80130b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80130f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801313:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80131a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801321:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801327:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80132e:	48 89 c7             	mov    %rax,%rdi
  801331:	48 b8 cd 11 80 00 00 	movabs $0x8011cd,%rax
  801338:	00 00 00 
  80133b:	ff d0                	callq  *%rax
  80133d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801343:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801349:	c9                   	leaveq 
  80134a:	c3                   	retq   

000000000080134b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80134b:	55                   	push   %rbp
  80134c:	48 89 e5             	mov    %rsp,%rbp
  80134f:	48 83 ec 18          	sub    $0x18,%rsp
  801353:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801357:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80135e:	eb 09                	jmp    801369 <strlen+0x1e>
		n++;
  801360:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801364:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136d:	0f b6 00             	movzbl (%rax),%eax
  801370:	84 c0                	test   %al,%al
  801372:	75 ec                	jne    801360 <strlen+0x15>
		n++;
	return n;
  801374:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801377:	c9                   	leaveq 
  801378:	c3                   	retq   

0000000000801379 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801379:	55                   	push   %rbp
  80137a:	48 89 e5             	mov    %rsp,%rbp
  80137d:	48 83 ec 20          	sub    $0x20,%rsp
  801381:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801385:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801389:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801390:	eb 0e                	jmp    8013a0 <strnlen+0x27>
		n++;
  801392:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801396:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80139b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013a0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8013a5:	74 0b                	je     8013b2 <strnlen+0x39>
  8013a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ab:	0f b6 00             	movzbl (%rax),%eax
  8013ae:	84 c0                	test   %al,%al
  8013b0:	75 e0                	jne    801392 <strnlen+0x19>
		n++;
	return n;
  8013b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013b5:	c9                   	leaveq 
  8013b6:	c3                   	retq   

00000000008013b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013b7:	55                   	push   %rbp
  8013b8:	48 89 e5             	mov    %rsp,%rbp
  8013bb:	48 83 ec 20          	sub    $0x20,%rsp
  8013bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013cf:	90                   	nop
  8013d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013dc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013e0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013e4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013e8:	0f b6 12             	movzbl (%rdx),%edx
  8013eb:	88 10                	mov    %dl,(%rax)
  8013ed:	0f b6 00             	movzbl (%rax),%eax
  8013f0:	84 c0                	test   %al,%al
  8013f2:	75 dc                	jne    8013d0 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013f8:	c9                   	leaveq 
  8013f9:	c3                   	retq   

00000000008013fa <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013fa:	55                   	push   %rbp
  8013fb:	48 89 e5             	mov    %rsp,%rbp
  8013fe:	48 83 ec 20          	sub    $0x20,%rsp
  801402:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801406:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80140a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140e:	48 89 c7             	mov    %rax,%rdi
  801411:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  801418:	00 00 00 
  80141b:	ff d0                	callq  *%rax
  80141d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801420:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801423:	48 63 d0             	movslq %eax,%rdx
  801426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142a:	48 01 c2             	add    %rax,%rdx
  80142d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801431:	48 89 c6             	mov    %rax,%rsi
  801434:	48 89 d7             	mov    %rdx,%rdi
  801437:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  80143e:	00 00 00 
  801441:	ff d0                	callq  *%rax
	return dst;
  801443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801447:	c9                   	leaveq 
  801448:	c3                   	retq   

0000000000801449 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801449:	55                   	push   %rbp
  80144a:	48 89 e5             	mov    %rsp,%rbp
  80144d:	48 83 ec 28          	sub    $0x28,%rsp
  801451:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801455:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801459:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80145d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801461:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801465:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80146c:	00 
  80146d:	eb 2a                	jmp    801499 <strncpy+0x50>
		*dst++ = *src;
  80146f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801473:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801477:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80147b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80147f:	0f b6 12             	movzbl (%rdx),%edx
  801482:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801484:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801488:	0f b6 00             	movzbl (%rax),%eax
  80148b:	84 c0                	test   %al,%al
  80148d:	74 05                	je     801494 <strncpy+0x4b>
			src++;
  80148f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801494:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014a1:	72 cc                	jb     80146f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014a7:	c9                   	leaveq 
  8014a8:	c3                   	retq   

00000000008014a9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8014a9:	55                   	push   %rbp
  8014aa:	48 89 e5             	mov    %rsp,%rbp
  8014ad:	48 83 ec 28          	sub    $0x28,%rsp
  8014b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014c5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014ca:	74 3d                	je     801509 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014cc:	eb 1d                	jmp    8014eb <strlcpy+0x42>
			*dst++ = *src++;
  8014ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014de:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014e2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014e6:	0f b6 12             	movzbl (%rdx),%edx
  8014e9:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014eb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014f0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014f5:	74 0b                	je     801502 <strlcpy+0x59>
  8014f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014fb:	0f b6 00             	movzbl (%rax),%eax
  8014fe:	84 c0                	test   %al,%al
  801500:	75 cc                	jne    8014ce <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801502:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801506:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801509:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80150d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801511:	48 29 c2             	sub    %rax,%rdx
  801514:	48 89 d0             	mov    %rdx,%rax
}
  801517:	c9                   	leaveq 
  801518:	c3                   	retq   

0000000000801519 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801519:	55                   	push   %rbp
  80151a:	48 89 e5             	mov    %rsp,%rbp
  80151d:	48 83 ec 10          	sub    $0x10,%rsp
  801521:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801525:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801529:	eb 0a                	jmp    801535 <strcmp+0x1c>
		p++, q++;
  80152b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801530:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801535:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801539:	0f b6 00             	movzbl (%rax),%eax
  80153c:	84 c0                	test   %al,%al
  80153e:	74 12                	je     801552 <strcmp+0x39>
  801540:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801544:	0f b6 10             	movzbl (%rax),%edx
  801547:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	38 c2                	cmp    %al,%dl
  801550:	74 d9                	je     80152b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	0f b6 d0             	movzbl %al,%edx
  80155c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801560:	0f b6 00             	movzbl (%rax),%eax
  801563:	0f b6 c0             	movzbl %al,%eax
  801566:	29 c2                	sub    %eax,%edx
  801568:	89 d0                	mov    %edx,%eax
}
  80156a:	c9                   	leaveq 
  80156b:	c3                   	retq   

000000000080156c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80156c:	55                   	push   %rbp
  80156d:	48 89 e5             	mov    %rsp,%rbp
  801570:	48 83 ec 18          	sub    $0x18,%rsp
  801574:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801578:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80157c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801580:	eb 0f                	jmp    801591 <strncmp+0x25>
		n--, p++, q++;
  801582:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801587:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801591:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801596:	74 1d                	je     8015b5 <strncmp+0x49>
  801598:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159c:	0f b6 00             	movzbl (%rax),%eax
  80159f:	84 c0                	test   %al,%al
  8015a1:	74 12                	je     8015b5 <strncmp+0x49>
  8015a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a7:	0f b6 10             	movzbl (%rax),%edx
  8015aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ae:	0f b6 00             	movzbl (%rax),%eax
  8015b1:	38 c2                	cmp    %al,%dl
  8015b3:	74 cd                	je     801582 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015b5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ba:	75 07                	jne    8015c3 <strncmp+0x57>
		return 0;
  8015bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c1:	eb 18                	jmp    8015db <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c7:	0f b6 00             	movzbl (%rax),%eax
  8015ca:	0f b6 d0             	movzbl %al,%edx
  8015cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	0f b6 c0             	movzbl %al,%eax
  8015d7:	29 c2                	sub    %eax,%edx
  8015d9:	89 d0                	mov    %edx,%eax
}
  8015db:	c9                   	leaveq 
  8015dc:	c3                   	retq   

00000000008015dd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015dd:	55                   	push   %rbp
  8015de:	48 89 e5             	mov    %rsp,%rbp
  8015e1:	48 83 ec 0c          	sub    $0xc,%rsp
  8015e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015e9:	89 f0                	mov    %esi,%eax
  8015eb:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015ee:	eb 17                	jmp    801607 <strchr+0x2a>
		if (*s == c)
  8015f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f4:	0f b6 00             	movzbl (%rax),%eax
  8015f7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015fa:	75 06                	jne    801602 <strchr+0x25>
			return (char *) s;
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801600:	eb 15                	jmp    801617 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801602:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80160b:	0f b6 00             	movzbl (%rax),%eax
  80160e:	84 c0                	test   %al,%al
  801610:	75 de                	jne    8015f0 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801612:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801617:	c9                   	leaveq 
  801618:	c3                   	retq   

0000000000801619 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801619:	55                   	push   %rbp
  80161a:	48 89 e5             	mov    %rsp,%rbp
  80161d:	48 83 ec 0c          	sub    $0xc,%rsp
  801621:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801625:	89 f0                	mov    %esi,%eax
  801627:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80162a:	eb 13                	jmp    80163f <strfind+0x26>
		if (*s == c)
  80162c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801630:	0f b6 00             	movzbl (%rax),%eax
  801633:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801636:	75 02                	jne    80163a <strfind+0x21>
			break;
  801638:	eb 10                	jmp    80164a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80163a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80163f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801643:	0f b6 00             	movzbl (%rax),%eax
  801646:	84 c0                	test   %al,%al
  801648:	75 e2                	jne    80162c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80164a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80164e:	c9                   	leaveq 
  80164f:	c3                   	retq   

0000000000801650 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801650:	55                   	push   %rbp
  801651:	48 89 e5             	mov    %rsp,%rbp
  801654:	48 83 ec 18          	sub    $0x18,%rsp
  801658:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80165c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80165f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801663:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801668:	75 06                	jne    801670 <memset+0x20>
		return v;
  80166a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166e:	eb 69                	jmp    8016d9 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801670:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801674:	83 e0 03             	and    $0x3,%eax
  801677:	48 85 c0             	test   %rax,%rax
  80167a:	75 48                	jne    8016c4 <memset+0x74>
  80167c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801680:	83 e0 03             	and    $0x3,%eax
  801683:	48 85 c0             	test   %rax,%rax
  801686:	75 3c                	jne    8016c4 <memset+0x74>
		c &= 0xFF;
  801688:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80168f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801692:	c1 e0 18             	shl    $0x18,%eax
  801695:	89 c2                	mov    %eax,%edx
  801697:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80169a:	c1 e0 10             	shl    $0x10,%eax
  80169d:	09 c2                	or     %eax,%edx
  80169f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016a2:	c1 e0 08             	shl    $0x8,%eax
  8016a5:	09 d0                	or     %edx,%eax
  8016a7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8016aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ae:	48 c1 e8 02          	shr    $0x2,%rax
  8016b2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016bc:	48 89 d7             	mov    %rdx,%rdi
  8016bf:	fc                   	cld    
  8016c0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016c2:	eb 11                	jmp    8016d5 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016cb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016cf:	48 89 d7             	mov    %rdx,%rdi
  8016d2:	fc                   	cld    
  8016d3:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8016d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016d9:	c9                   	leaveq 
  8016da:	c3                   	retq   

00000000008016db <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016db:	55                   	push   %rbp
  8016dc:	48 89 e5             	mov    %rsp,%rbp
  8016df:	48 83 ec 28          	sub    $0x28,%rsp
  8016e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801703:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801707:	0f 83 88 00 00 00    	jae    801795 <memmove+0xba>
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801715:	48 01 d0             	add    %rdx,%rax
  801718:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80171c:	76 77                	jbe    801795 <memmove+0xba>
		s += n;
  80171e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801722:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801726:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80172e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801732:	83 e0 03             	and    $0x3,%eax
  801735:	48 85 c0             	test   %rax,%rax
  801738:	75 3b                	jne    801775 <memmove+0x9a>
  80173a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80173e:	83 e0 03             	and    $0x3,%eax
  801741:	48 85 c0             	test   %rax,%rax
  801744:	75 2f                	jne    801775 <memmove+0x9a>
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	83 e0 03             	and    $0x3,%eax
  80174d:	48 85 c0             	test   %rax,%rax
  801750:	75 23                	jne    801775 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801752:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801756:	48 83 e8 04          	sub    $0x4,%rax
  80175a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80175e:	48 83 ea 04          	sub    $0x4,%rdx
  801762:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801766:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80176a:	48 89 c7             	mov    %rax,%rdi
  80176d:	48 89 d6             	mov    %rdx,%rsi
  801770:	fd                   	std    
  801771:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801773:	eb 1d                	jmp    801792 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801775:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801779:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80177d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801781:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801789:	48 89 d7             	mov    %rdx,%rdi
  80178c:	48 89 c1             	mov    %rax,%rcx
  80178f:	fd                   	std    
  801790:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801792:	fc                   	cld    
  801793:	eb 57                	jmp    8017ec <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801795:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801799:	83 e0 03             	and    $0x3,%eax
  80179c:	48 85 c0             	test   %rax,%rax
  80179f:	75 36                	jne    8017d7 <memmove+0xfc>
  8017a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a5:	83 e0 03             	and    $0x3,%eax
  8017a8:	48 85 c0             	test   %rax,%rax
  8017ab:	75 2a                	jne    8017d7 <memmove+0xfc>
  8017ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b1:	83 e0 03             	and    $0x3,%eax
  8017b4:	48 85 c0             	test   %rax,%rax
  8017b7:	75 1e                	jne    8017d7 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bd:	48 c1 e8 02          	shr    $0x2,%rax
  8017c1:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017cc:	48 89 c7             	mov    %rax,%rdi
  8017cf:	48 89 d6             	mov    %rdx,%rsi
  8017d2:	fc                   	cld    
  8017d3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017d5:	eb 15                	jmp    8017ec <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017df:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017e3:	48 89 c7             	mov    %rax,%rdi
  8017e6:	48 89 d6             	mov    %rdx,%rsi
  8017e9:	fc                   	cld    
  8017ea:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017f0:	c9                   	leaveq 
  8017f1:	c3                   	retq   

00000000008017f2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017f2:	55                   	push   %rbp
  8017f3:	48 89 e5             	mov    %rsp,%rbp
  8017f6:	48 83 ec 18          	sub    $0x18,%rsp
  8017fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801802:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801806:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80180e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801812:	48 89 ce             	mov    %rcx,%rsi
  801815:	48 89 c7             	mov    %rax,%rdi
  801818:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  80181f:	00 00 00 
  801822:	ff d0                	callq  *%rax
}
  801824:	c9                   	leaveq 
  801825:	c3                   	retq   

0000000000801826 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801826:	55                   	push   %rbp
  801827:	48 89 e5             	mov    %rsp,%rbp
  80182a:	48 83 ec 28          	sub    $0x28,%rsp
  80182e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801832:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801836:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80183a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801842:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801846:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80184a:	eb 36                	jmp    801882 <memcmp+0x5c>
		if (*s1 != *s2)
  80184c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801850:	0f b6 10             	movzbl (%rax),%edx
  801853:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801857:	0f b6 00             	movzbl (%rax),%eax
  80185a:	38 c2                	cmp    %al,%dl
  80185c:	74 1a                	je     801878 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80185e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801862:	0f b6 00             	movzbl (%rax),%eax
  801865:	0f b6 d0             	movzbl %al,%edx
  801868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80186c:	0f b6 00             	movzbl (%rax),%eax
  80186f:	0f b6 c0             	movzbl %al,%eax
  801872:	29 c2                	sub    %eax,%edx
  801874:	89 d0                	mov    %edx,%eax
  801876:	eb 20                	jmp    801898 <memcmp+0x72>
		s1++, s2++;
  801878:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80187d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801882:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801886:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80188a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80188e:	48 85 c0             	test   %rax,%rax
  801891:	75 b9                	jne    80184c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801893:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801898:	c9                   	leaveq 
  801899:	c3                   	retq   

000000000080189a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80189a:	55                   	push   %rbp
  80189b:	48 89 e5             	mov    %rsp,%rbp
  80189e:	48 83 ec 28          	sub    $0x28,%rsp
  8018a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018a6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8018a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8018ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018b5:	48 01 d0             	add    %rdx,%rax
  8018b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018bc:	eb 15                	jmp    8018d3 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c2:	0f b6 10             	movzbl (%rax),%edx
  8018c5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018c8:	38 c2                	cmp    %al,%dl
  8018ca:	75 02                	jne    8018ce <memfind+0x34>
			break;
  8018cc:	eb 0f                	jmp    8018dd <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018ce:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018d7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018db:	72 e1                	jb     8018be <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8018dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018e1:	c9                   	leaveq 
  8018e2:	c3                   	retq   

00000000008018e3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018e3:	55                   	push   %rbp
  8018e4:	48 89 e5             	mov    %rsp,%rbp
  8018e7:	48 83 ec 34          	sub    $0x34,%rsp
  8018eb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018ef:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018f3:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018fd:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801904:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801905:	eb 05                	jmp    80190c <strtol+0x29>
		s++;
  801907:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80190c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801910:	0f b6 00             	movzbl (%rax),%eax
  801913:	3c 20                	cmp    $0x20,%al
  801915:	74 f0                	je     801907 <strtol+0x24>
  801917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191b:	0f b6 00             	movzbl (%rax),%eax
  80191e:	3c 09                	cmp    $0x9,%al
  801920:	74 e5                	je     801907 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801922:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801926:	0f b6 00             	movzbl (%rax),%eax
  801929:	3c 2b                	cmp    $0x2b,%al
  80192b:	75 07                	jne    801934 <strtol+0x51>
		s++;
  80192d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801932:	eb 17                	jmp    80194b <strtol+0x68>
	else if (*s == '-')
  801934:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801938:	0f b6 00             	movzbl (%rax),%eax
  80193b:	3c 2d                	cmp    $0x2d,%al
  80193d:	75 0c                	jne    80194b <strtol+0x68>
		s++, neg = 1;
  80193f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801944:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80194b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80194f:	74 06                	je     801957 <strtol+0x74>
  801951:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801955:	75 28                	jne    80197f <strtol+0x9c>
  801957:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195b:	0f b6 00             	movzbl (%rax),%eax
  80195e:	3c 30                	cmp    $0x30,%al
  801960:	75 1d                	jne    80197f <strtol+0x9c>
  801962:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801966:	48 83 c0 01          	add    $0x1,%rax
  80196a:	0f b6 00             	movzbl (%rax),%eax
  80196d:	3c 78                	cmp    $0x78,%al
  80196f:	75 0e                	jne    80197f <strtol+0x9c>
		s += 2, base = 16;
  801971:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801976:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80197d:	eb 2c                	jmp    8019ab <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80197f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801983:	75 19                	jne    80199e <strtol+0xbb>
  801985:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801989:	0f b6 00             	movzbl (%rax),%eax
  80198c:	3c 30                	cmp    $0x30,%al
  80198e:	75 0e                	jne    80199e <strtol+0xbb>
		s++, base = 8;
  801990:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801995:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80199c:	eb 0d                	jmp    8019ab <strtol+0xc8>
	else if (base == 0)
  80199e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019a2:	75 07                	jne    8019ab <strtol+0xc8>
		base = 10;
  8019a4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019af:	0f b6 00             	movzbl (%rax),%eax
  8019b2:	3c 2f                	cmp    $0x2f,%al
  8019b4:	7e 1d                	jle    8019d3 <strtol+0xf0>
  8019b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ba:	0f b6 00             	movzbl (%rax),%eax
  8019bd:	3c 39                	cmp    $0x39,%al
  8019bf:	7f 12                	jg     8019d3 <strtol+0xf0>
			dig = *s - '0';
  8019c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c5:	0f b6 00             	movzbl (%rax),%eax
  8019c8:	0f be c0             	movsbl %al,%eax
  8019cb:	83 e8 30             	sub    $0x30,%eax
  8019ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019d1:	eb 4e                	jmp    801a21 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d7:	0f b6 00             	movzbl (%rax),%eax
  8019da:	3c 60                	cmp    $0x60,%al
  8019dc:	7e 1d                	jle    8019fb <strtol+0x118>
  8019de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e2:	0f b6 00             	movzbl (%rax),%eax
  8019e5:	3c 7a                	cmp    $0x7a,%al
  8019e7:	7f 12                	jg     8019fb <strtol+0x118>
			dig = *s - 'a' + 10;
  8019e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ed:	0f b6 00             	movzbl (%rax),%eax
  8019f0:	0f be c0             	movsbl %al,%eax
  8019f3:	83 e8 57             	sub    $0x57,%eax
  8019f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019f9:	eb 26                	jmp    801a21 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ff:	0f b6 00             	movzbl (%rax),%eax
  801a02:	3c 40                	cmp    $0x40,%al
  801a04:	7e 48                	jle    801a4e <strtol+0x16b>
  801a06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0a:	0f b6 00             	movzbl (%rax),%eax
  801a0d:	3c 5a                	cmp    $0x5a,%al
  801a0f:	7f 3d                	jg     801a4e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a15:	0f b6 00             	movzbl (%rax),%eax
  801a18:	0f be c0             	movsbl %al,%eax
  801a1b:	83 e8 37             	sub    $0x37,%eax
  801a1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a21:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a24:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a27:	7c 02                	jl     801a2b <strtol+0x148>
			break;
  801a29:	eb 23                	jmp    801a4e <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a2b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a30:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a33:	48 98                	cltq   
  801a35:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a3a:	48 89 c2             	mov    %rax,%rdx
  801a3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a40:	48 98                	cltq   
  801a42:	48 01 d0             	add    %rdx,%rax
  801a45:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a49:	e9 5d ff ff ff       	jmpq   8019ab <strtol+0xc8>

	if (endptr)
  801a4e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a53:	74 0b                	je     801a60 <strtol+0x17d>
		*endptr = (char *) s;
  801a55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a59:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a5d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a64:	74 09                	je     801a6f <strtol+0x18c>
  801a66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6a:	48 f7 d8             	neg    %rax
  801a6d:	eb 04                	jmp    801a73 <strtol+0x190>
  801a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a73:	c9                   	leaveq 
  801a74:	c3                   	retq   

0000000000801a75 <strstr>:

char * strstr(const char *in, const char *str)
{
  801a75:	55                   	push   %rbp
  801a76:	48 89 e5             	mov    %rsp,%rbp
  801a79:	48 83 ec 30          	sub    $0x30,%rsp
  801a7d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a81:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a89:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a8d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a91:	0f b6 00             	movzbl (%rax),%eax
  801a94:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a97:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a9b:	75 06                	jne    801aa3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801a9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa1:	eb 6b                	jmp    801b0e <strstr+0x99>

	len = strlen(str);
  801aa3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aa7:	48 89 c7             	mov    %rax,%rdi
  801aaa:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
  801ab6:	48 98                	cltq   
  801ab8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801abc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ac4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ac8:	0f b6 00             	movzbl (%rax),%eax
  801acb:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801ace:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ad2:	75 07                	jne    801adb <strstr+0x66>
				return (char *) 0;
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad9:	eb 33                	jmp    801b0e <strstr+0x99>
		} while (sc != c);
  801adb:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801adf:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ae2:	75 d8                	jne    801abc <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801ae4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801aec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af0:	48 89 ce             	mov    %rcx,%rsi
  801af3:	48 89 c7             	mov    %rax,%rdi
  801af6:	48 b8 6c 15 80 00 00 	movabs $0x80156c,%rax
  801afd:	00 00 00 
  801b00:	ff d0                	callq  *%rax
  801b02:	85 c0                	test   %eax,%eax
  801b04:	75 b6                	jne    801abc <strstr+0x47>

	return (char *) (in - 1);
  801b06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0a:	48 83 e8 01          	sub    $0x1,%rax
}
  801b0e:	c9                   	leaveq 
  801b0f:	c3                   	retq   

0000000000801b10 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b10:	55                   	push   %rbp
  801b11:	48 89 e5             	mov    %rsp,%rbp
  801b14:	53                   	push   %rbx
  801b15:	48 83 ec 48          	sub    $0x48,%rsp
  801b19:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b1c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b1f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b23:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b27:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b2b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b2f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b32:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b36:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b3a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b3e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b42:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b46:	4c 89 c3             	mov    %r8,%rbx
  801b49:	cd 30                	int    $0x30
  801b4b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b4f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b53:	74 3e                	je     801b93 <syscall+0x83>
  801b55:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b5a:	7e 37                	jle    801b93 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b60:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b63:	49 89 d0             	mov    %rdx,%r8
  801b66:	89 c1                	mov    %eax,%ecx
  801b68:	48 ba c8 4e 80 00 00 	movabs $0x804ec8,%rdx
  801b6f:	00 00 00 
  801b72:	be 23 00 00 00       	mov    $0x23,%esi
  801b77:	48 bf e5 4e 80 00 00 	movabs $0x804ee5,%rdi
  801b7e:	00 00 00 
  801b81:	b8 00 00 00 00       	mov    $0x0,%eax
  801b86:	49 b9 c9 05 80 00 00 	movabs $0x8005c9,%r9
  801b8d:	00 00 00 
  801b90:	41 ff d1             	callq  *%r9

	return ret;
  801b93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b97:	48 83 c4 48          	add    $0x48,%rsp
  801b9b:	5b                   	pop    %rbx
  801b9c:	5d                   	pop    %rbp
  801b9d:	c3                   	retq   

0000000000801b9e <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b9e:	55                   	push   %rbp
  801b9f:	48 89 e5             	mov    %rsp,%rbp
  801ba2:	48 83 ec 20          	sub    $0x20,%rsp
  801ba6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801baa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801bae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bbd:	00 
  801bbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bca:	48 89 d1             	mov    %rdx,%rcx
  801bcd:	48 89 c2             	mov    %rax,%rdx
  801bd0:	be 00 00 00 00       	mov    $0x0,%esi
  801bd5:	bf 00 00 00 00       	mov    $0x0,%edi
  801bda:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801be1:	00 00 00 
  801be4:	ff d0                	callq  *%rax
}
  801be6:	c9                   	leaveq 
  801be7:	c3                   	retq   

0000000000801be8 <sys_cgetc>:

int
sys_cgetc(void)
{
  801be8:	55                   	push   %rbp
  801be9:	48 89 e5             	mov    %rsp,%rbp
  801bec:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801bf0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf7:	00 
  801bf8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c04:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c09:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0e:	be 00 00 00 00       	mov    $0x0,%esi
  801c13:	bf 01 00 00 00       	mov    $0x1,%edi
  801c18:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801c1f:	00 00 00 
  801c22:	ff d0                	callq  *%rax
}
  801c24:	c9                   	leaveq 
  801c25:	c3                   	retq   

0000000000801c26 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c26:	55                   	push   %rbp
  801c27:	48 89 e5             	mov    %rsp,%rbp
  801c2a:	48 83 ec 10          	sub    $0x10,%rsp
  801c2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c34:	48 98                	cltq   
  801c36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c3d:	00 
  801c3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c4f:	48 89 c2             	mov    %rax,%rdx
  801c52:	be 01 00 00 00       	mov    $0x1,%esi
  801c57:	bf 03 00 00 00       	mov    $0x3,%edi
  801c5c:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801c63:	00 00 00 
  801c66:	ff d0                	callq  *%rax
}
  801c68:	c9                   	leaveq 
  801c69:	c3                   	retq   

0000000000801c6a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c6a:	55                   	push   %rbp
  801c6b:	48 89 e5             	mov    %rsp,%rbp
  801c6e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c72:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c79:	00 
  801c7a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c80:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c86:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c90:	be 00 00 00 00       	mov    $0x0,%esi
  801c95:	bf 02 00 00 00       	mov    $0x2,%edi
  801c9a:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801ca1:	00 00 00 
  801ca4:	ff d0                	callq  *%rax
}
  801ca6:	c9                   	leaveq 
  801ca7:	c3                   	retq   

0000000000801ca8 <sys_yield>:

void
sys_yield(void)
{
  801ca8:	55                   	push   %rbp
  801ca9:	48 89 e5             	mov    %rsp,%rbp
  801cac:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801cb0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb7:	00 
  801cb8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cce:	be 00 00 00 00       	mov    $0x0,%esi
  801cd3:	bf 0b 00 00 00       	mov    $0xb,%edi
  801cd8:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801cdf:	00 00 00 
  801ce2:	ff d0                	callq  *%rax
}
  801ce4:	c9                   	leaveq 
  801ce5:	c3                   	retq   

0000000000801ce6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801ce6:	55                   	push   %rbp
  801ce7:	48 89 e5             	mov    %rsp,%rbp
  801cea:	48 83 ec 20          	sub    $0x20,%rsp
  801cee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cf5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801cf8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cfb:	48 63 c8             	movslq %eax,%rcx
  801cfe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d05:	48 98                	cltq   
  801d07:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d0e:	00 
  801d0f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d15:	49 89 c8             	mov    %rcx,%r8
  801d18:	48 89 d1             	mov    %rdx,%rcx
  801d1b:	48 89 c2             	mov    %rax,%rdx
  801d1e:	be 01 00 00 00       	mov    $0x1,%esi
  801d23:	bf 04 00 00 00       	mov    $0x4,%edi
  801d28:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801d2f:	00 00 00 
  801d32:	ff d0                	callq  *%rax
}
  801d34:	c9                   	leaveq 
  801d35:	c3                   	retq   

0000000000801d36 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d36:	55                   	push   %rbp
  801d37:	48 89 e5             	mov    %rsp,%rbp
  801d3a:	48 83 ec 30          	sub    $0x30,%rsp
  801d3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d45:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d48:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d4c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d50:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d53:	48 63 c8             	movslq %eax,%rcx
  801d56:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d5d:	48 63 f0             	movslq %eax,%rsi
  801d60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d67:	48 98                	cltq   
  801d69:	48 89 0c 24          	mov    %rcx,(%rsp)
  801d6d:	49 89 f9             	mov    %rdi,%r9
  801d70:	49 89 f0             	mov    %rsi,%r8
  801d73:	48 89 d1             	mov    %rdx,%rcx
  801d76:	48 89 c2             	mov    %rax,%rdx
  801d79:	be 01 00 00 00       	mov    $0x1,%esi
  801d7e:	bf 05 00 00 00       	mov    $0x5,%edi
  801d83:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
}
  801d8f:	c9                   	leaveq 
  801d90:	c3                   	retq   

0000000000801d91 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d91:	55                   	push   %rbp
  801d92:	48 89 e5             	mov    %rsp,%rbp
  801d95:	48 83 ec 20          	sub    $0x20,%rsp
  801d99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801da0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da7:	48 98                	cltq   
  801da9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db0:	00 
  801db1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dbd:	48 89 d1             	mov    %rdx,%rcx
  801dc0:	48 89 c2             	mov    %rax,%rdx
  801dc3:	be 01 00 00 00       	mov    $0x1,%esi
  801dc8:	bf 06 00 00 00       	mov    $0x6,%edi
  801dcd:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801dd4:	00 00 00 
  801dd7:	ff d0                	callq  *%rax
}
  801dd9:	c9                   	leaveq 
  801dda:	c3                   	retq   

0000000000801ddb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ddb:	55                   	push   %rbp
  801ddc:	48 89 e5             	mov    %rsp,%rbp
  801ddf:	48 83 ec 10          	sub    $0x10,%rsp
  801de3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801de9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dec:	48 63 d0             	movslq %eax,%rdx
  801def:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df2:	48 98                	cltq   
  801df4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dfb:	00 
  801dfc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e02:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e08:	48 89 d1             	mov    %rdx,%rcx
  801e0b:	48 89 c2             	mov    %rax,%rdx
  801e0e:	be 01 00 00 00       	mov    $0x1,%esi
  801e13:	bf 08 00 00 00       	mov    $0x8,%edi
  801e18:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801e1f:	00 00 00 
  801e22:	ff d0                	callq  *%rax
}
  801e24:	c9                   	leaveq 
  801e25:	c3                   	retq   

0000000000801e26 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e26:	55                   	push   %rbp
  801e27:	48 89 e5             	mov    %rsp,%rbp
  801e2a:	48 83 ec 20          	sub    $0x20,%rsp
  801e2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e3c:	48 98                	cltq   
  801e3e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e45:	00 
  801e46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e52:	48 89 d1             	mov    %rdx,%rcx
  801e55:	48 89 c2             	mov    %rax,%rdx
  801e58:	be 01 00 00 00       	mov    $0x1,%esi
  801e5d:	bf 09 00 00 00       	mov    $0x9,%edi
  801e62:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801e69:	00 00 00 
  801e6c:	ff d0                	callq  *%rax
}
  801e6e:	c9                   	leaveq 
  801e6f:	c3                   	retq   

0000000000801e70 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e70:	55                   	push   %rbp
  801e71:	48 89 e5             	mov    %rsp,%rbp
  801e74:	48 83 ec 20          	sub    $0x20,%rsp
  801e78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e86:	48 98                	cltq   
  801e88:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e8f:	00 
  801e90:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e96:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e9c:	48 89 d1             	mov    %rdx,%rcx
  801e9f:	48 89 c2             	mov    %rax,%rdx
  801ea2:	be 01 00 00 00       	mov    $0x1,%esi
  801ea7:	bf 0a 00 00 00       	mov    $0xa,%edi
  801eac:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801eb3:	00 00 00 
  801eb6:	ff d0                	callq  *%rax
}
  801eb8:	c9                   	leaveq 
  801eb9:	c3                   	retq   

0000000000801eba <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801eba:	55                   	push   %rbp
  801ebb:	48 89 e5             	mov    %rsp,%rbp
  801ebe:	48 83 ec 20          	sub    $0x20,%rsp
  801ec2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ec5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ec9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ecd:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ed0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ed3:	48 63 f0             	movslq %eax,%rsi
  801ed6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801eda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801edd:	48 98                	cltq   
  801edf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ee3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eea:	00 
  801eeb:	49 89 f1             	mov    %rsi,%r9
  801eee:	49 89 c8             	mov    %rcx,%r8
  801ef1:	48 89 d1             	mov    %rdx,%rcx
  801ef4:	48 89 c2             	mov    %rax,%rdx
  801ef7:	be 00 00 00 00       	mov    $0x0,%esi
  801efc:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f01:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801f08:	00 00 00 
  801f0b:	ff d0                	callq  *%rax
}
  801f0d:	c9                   	leaveq 
  801f0e:	c3                   	retq   

0000000000801f0f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f0f:	55                   	push   %rbp
  801f10:	48 89 e5             	mov    %rsp,%rbp
  801f13:	48 83 ec 10          	sub    $0x10,%rsp
  801f17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f26:	00 
  801f27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f33:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f38:	48 89 c2             	mov    %rax,%rdx
  801f3b:	be 01 00 00 00       	mov    $0x1,%esi
  801f40:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f45:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801f4c:	00 00 00 
  801f4f:	ff d0                	callq  *%rax
}
  801f51:	c9                   	leaveq 
  801f52:	c3                   	retq   

0000000000801f53 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801f53:	55                   	push   %rbp
  801f54:	48 89 e5             	mov    %rsp,%rbp
  801f57:	48 83 ec 20          	sub    $0x20,%rsp
  801f5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801f63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f72:	00 
  801f73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f7f:	48 89 d1             	mov    %rdx,%rcx
  801f82:	48 89 c2             	mov    %rax,%rdx
  801f85:	be 01 00 00 00       	mov    $0x1,%esi
  801f8a:	bf 0f 00 00 00       	mov    $0xf,%edi
  801f8f:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801f96:	00 00 00 
  801f99:	ff d0                	callq  *%rax
}
  801f9b:	c9                   	leaveq 
  801f9c:	c3                   	retq   

0000000000801f9d <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801f9d:	55                   	push   %rbp
  801f9e:	48 89 e5             	mov    %rsp,%rbp
  801fa1:	48 83 ec 10          	sub    $0x10,%rsp
  801fa5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801fa9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fb4:	00 
  801fb5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fc6:	48 89 c2             	mov    %rax,%rdx
  801fc9:	be 00 00 00 00       	mov    $0x0,%esi
  801fce:	bf 10 00 00 00       	mov    $0x10,%edi
  801fd3:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  801fda:	00 00 00 
  801fdd:	ff d0                	callq  *%rax
}
  801fdf:	c9                   	leaveq 
  801fe0:	c3                   	retq   

0000000000801fe1 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801fe1:	55                   	push   %rbp
  801fe2:	48 89 e5             	mov    %rsp,%rbp
  801fe5:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801fe9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ff0:	00 
  801ff1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ff7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ffd:	b9 00 00 00 00       	mov    $0x0,%ecx
  802002:	ba 00 00 00 00       	mov    $0x0,%edx
  802007:	be 00 00 00 00       	mov    $0x0,%esi
  80200c:	bf 0e 00 00 00       	mov    $0xe,%edi
  802011:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  802018:	00 00 00 
  80201b:	ff d0                	callq  *%rax
}
  80201d:	c9                   	leaveq 
  80201e:	c3                   	retq   

000000000080201f <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80201f:	55                   	push   %rbp
  802020:	48 89 e5             	mov    %rsp,%rbp
  802023:	48 83 ec 18          	sub    $0x18,%rsp
  802027:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80202b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80202f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  802033:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802037:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80203b:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  80203e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802042:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802046:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  80204a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204e:	8b 00                	mov    (%rax),%eax
  802050:	83 f8 01             	cmp    $0x1,%eax
  802053:	7e 13                	jle    802068 <argstart+0x49>
  802055:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80205a:	74 0c                	je     802068 <argstart+0x49>
  80205c:	48 b8 f3 4e 80 00 00 	movabs $0x804ef3,%rax
  802063:	00 00 00 
  802066:	eb 05                	jmp    80206d <argstart+0x4e>
  802068:	b8 00 00 00 00       	mov    $0x0,%eax
  80206d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802071:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  802075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802079:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802080:	00 
}
  802081:	c9                   	leaveq 
  802082:	c3                   	retq   

0000000000802083 <argnext>:

int
argnext(struct Argstate *args)
{
  802083:	55                   	push   %rbp
  802084:	48 89 e5             	mov    %rsp,%rbp
  802087:	48 83 ec 20          	sub    $0x20,%rsp
  80208b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  80208f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802093:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80209a:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80209b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209f:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020a3:	48 85 c0             	test   %rax,%rax
  8020a6:	75 0a                	jne    8020b2 <argnext+0x2f>
		return -1;
  8020a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8020ad:	e9 25 01 00 00       	jmpq   8021d7 <argnext+0x154>

	if (!*args->curarg) {
  8020b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020ba:	0f b6 00             	movzbl (%rax),%eax
  8020bd:	84 c0                	test   %al,%al
  8020bf:	0f 85 d7 00 00 00    	jne    80219c <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8020c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c9:	48 8b 00             	mov    (%rax),%rax
  8020cc:	8b 00                	mov    (%rax),%eax
  8020ce:	83 f8 01             	cmp    $0x1,%eax
  8020d1:	0f 84 ef 00 00 00    	je     8021c6 <argnext+0x143>
		    || args->argv[1][0] != '-'
  8020d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020db:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020df:	48 83 c0 08          	add    $0x8,%rax
  8020e3:	48 8b 00             	mov    (%rax),%rax
  8020e6:	0f b6 00             	movzbl (%rax),%eax
  8020e9:	3c 2d                	cmp    $0x2d,%al
  8020eb:	0f 85 d5 00 00 00    	jne    8021c6 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  8020f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020f9:	48 83 c0 08          	add    $0x8,%rax
  8020fd:	48 8b 00             	mov    (%rax),%rax
  802100:	48 83 c0 01          	add    $0x1,%rax
  802104:	0f b6 00             	movzbl (%rax),%eax
  802107:	84 c0                	test   %al,%al
  802109:	0f 84 b7 00 00 00    	je     8021c6 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80210f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802113:	48 8b 40 08          	mov    0x8(%rax),%rax
  802117:	48 83 c0 08          	add    $0x8,%rax
  80211b:	48 8b 00             	mov    (%rax),%rax
  80211e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802126:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80212a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212e:	48 8b 00             	mov    (%rax),%rax
  802131:	8b 00                	mov    (%rax),%eax
  802133:	83 e8 01             	sub    $0x1,%eax
  802136:	48 98                	cltq   
  802138:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80213f:	00 
  802140:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802144:	48 8b 40 08          	mov    0x8(%rax),%rax
  802148:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80214c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802150:	48 8b 40 08          	mov    0x8(%rax),%rax
  802154:	48 83 c0 08          	add    $0x8,%rax
  802158:	48 89 ce             	mov    %rcx,%rsi
  80215b:	48 89 c7             	mov    %rax,%rdi
  80215e:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  802165:	00 00 00 
  802168:	ff d0                	callq  *%rax
		(*args->argc)--;
  80216a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216e:	48 8b 00             	mov    (%rax),%rax
  802171:	8b 10                	mov    (%rax),%edx
  802173:	83 ea 01             	sub    $0x1,%edx
  802176:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  802178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802180:	0f b6 00             	movzbl (%rax),%eax
  802183:	3c 2d                	cmp    $0x2d,%al
  802185:	75 15                	jne    80219c <argnext+0x119>
  802187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80218f:	48 83 c0 01          	add    $0x1,%rax
  802193:	0f b6 00             	movzbl (%rax),%eax
  802196:	84 c0                	test   %al,%al
  802198:	75 02                	jne    80219c <argnext+0x119>
			goto endofargs;
  80219a:	eb 2a                	jmp    8021c6 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  80219c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021a4:	0f b6 00             	movzbl (%rax),%eax
  8021a7:	0f b6 c0             	movzbl %al,%eax
  8021aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8021ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  8021c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c4:	eb 11                	jmp    8021d7 <argnext+0x154>

endofargs:
	args->curarg = 0;
  8021c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ca:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8021d1:	00 
	return -1;
  8021d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8021d7:	c9                   	leaveq 
  8021d8:	c3                   	retq   

00000000008021d9 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  8021d9:	55                   	push   %rbp
  8021da:	48 89 e5             	mov    %rsp,%rbp
  8021dd:	48 83 ec 10          	sub    $0x10,%rsp
  8021e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8021e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021ed:	48 85 c0             	test   %rax,%rax
  8021f0:	74 0a                	je     8021fc <argvalue+0x23>
  8021f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021fa:	eb 13                	jmp    80220f <argvalue+0x36>
  8021fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802200:	48 89 c7             	mov    %rax,%rdi
  802203:	48 b8 11 22 80 00 00 	movabs $0x802211,%rax
  80220a:	00 00 00 
  80220d:	ff d0                	callq  *%rax
}
  80220f:	c9                   	leaveq 
  802210:	c3                   	retq   

0000000000802211 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  802211:	55                   	push   %rbp
  802212:	48 89 e5             	mov    %rsp,%rbp
  802215:	53                   	push   %rbx
  802216:	48 83 ec 18          	sub    $0x18,%rsp
  80221a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  80221e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802222:	48 8b 40 10          	mov    0x10(%rax),%rax
  802226:	48 85 c0             	test   %rax,%rax
  802229:	75 0a                	jne    802235 <argnextvalue+0x24>
		return 0;
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
  802230:	e9 c8 00 00 00       	jmpq   8022fd <argnextvalue+0xec>
	if (*args->curarg) {
  802235:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802239:	48 8b 40 10          	mov    0x10(%rax),%rax
  80223d:	0f b6 00             	movzbl (%rax),%eax
  802240:	84 c0                	test   %al,%al
  802242:	74 27                	je     80226b <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  802244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802248:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80224c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802250:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  802254:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802258:	48 bb f3 4e 80 00 00 	movabs $0x804ef3,%rbx
  80225f:	00 00 00 
  802262:	48 89 58 10          	mov    %rbx,0x10(%rax)
  802266:	e9 8a 00 00 00       	jmpq   8022f5 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  80226b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226f:	48 8b 00             	mov    (%rax),%rax
  802272:	8b 00                	mov    (%rax),%eax
  802274:	83 f8 01             	cmp    $0x1,%eax
  802277:	7e 64                	jle    8022dd <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  802279:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227d:	48 8b 40 08          	mov    0x8(%rax),%rax
  802281:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802289:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80228d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802291:	48 8b 00             	mov    (%rax),%rax
  802294:	8b 00                	mov    (%rax),%eax
  802296:	83 e8 01             	sub    $0x1,%eax
  802299:	48 98                	cltq   
  80229b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8022a2:	00 
  8022a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022ab:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8022af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022b7:	48 83 c0 08          	add    $0x8,%rax
  8022bb:	48 89 ce             	mov    %rcx,%rsi
  8022be:	48 89 c7             	mov    %rax,%rdi
  8022c1:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  8022c8:	00 00 00 
  8022cb:	ff d0                	callq  *%rax
		(*args->argc)--;
  8022cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d1:	48 8b 00             	mov    (%rax),%rax
  8022d4:	8b 10                	mov    (%rax),%edx
  8022d6:	83 ea 01             	sub    $0x1,%edx
  8022d9:	89 10                	mov    %edx,(%rax)
  8022db:	eb 18                	jmp    8022f5 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  8022dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e1:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8022e8:	00 
		args->curarg = 0;
  8022e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ed:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  8022f4:	00 
	}
	return (char*) args->argvalue;
  8022f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f9:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  8022fd:	48 83 c4 18          	add    $0x18,%rsp
  802301:	5b                   	pop    %rbx
  802302:	5d                   	pop    %rbp
  802303:	c3                   	retq   

0000000000802304 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802304:	55                   	push   %rbp
  802305:	48 89 e5             	mov    %rsp,%rbp
  802308:	48 83 ec 08          	sub    $0x8,%rsp
  80230c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802310:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802314:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80231b:	ff ff ff 
  80231e:	48 01 d0             	add    %rdx,%rax
  802321:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802325:	c9                   	leaveq 
  802326:	c3                   	retq   

0000000000802327 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802327:	55                   	push   %rbp
  802328:	48 89 e5             	mov    %rsp,%rbp
  80232b:	48 83 ec 08          	sub    $0x8,%rsp
  80232f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802333:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802337:	48 89 c7             	mov    %rax,%rdi
  80233a:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  802341:	00 00 00 
  802344:	ff d0                	callq  *%rax
  802346:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80234c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802350:	c9                   	leaveq 
  802351:	c3                   	retq   

0000000000802352 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802352:	55                   	push   %rbp
  802353:	48 89 e5             	mov    %rsp,%rbp
  802356:	48 83 ec 18          	sub    $0x18,%rsp
  80235a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80235e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802365:	eb 6b                	jmp    8023d2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802367:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236a:	48 98                	cltq   
  80236c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802372:	48 c1 e0 0c          	shl    $0xc,%rax
  802376:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80237a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80237e:	48 c1 e8 15          	shr    $0x15,%rax
  802382:	48 89 c2             	mov    %rax,%rdx
  802385:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80238c:	01 00 00 
  80238f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802393:	83 e0 01             	and    $0x1,%eax
  802396:	48 85 c0             	test   %rax,%rax
  802399:	74 21                	je     8023bc <fd_alloc+0x6a>
  80239b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239f:	48 c1 e8 0c          	shr    $0xc,%rax
  8023a3:	48 89 c2             	mov    %rax,%rdx
  8023a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023ad:	01 00 00 
  8023b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b4:	83 e0 01             	and    $0x1,%eax
  8023b7:	48 85 c0             	test   %rax,%rax
  8023ba:	75 12                	jne    8023ce <fd_alloc+0x7c>
			*fd_store = fd;
  8023bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023c4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cc:	eb 1a                	jmp    8023e8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023ce:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023d2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8023d6:	7e 8f                	jle    802367 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8023d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023dc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8023e3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8023e8:	c9                   	leaveq 
  8023e9:	c3                   	retq   

00000000008023ea <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8023ea:	55                   	push   %rbp
  8023eb:	48 89 e5             	mov    %rsp,%rbp
  8023ee:	48 83 ec 20          	sub    $0x20,%rsp
  8023f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8023f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023fd:	78 06                	js     802405 <fd_lookup+0x1b>
  8023ff:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802403:	7e 07                	jle    80240c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802405:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80240a:	eb 6c                	jmp    802478 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80240c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80240f:	48 98                	cltq   
  802411:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802417:	48 c1 e0 0c          	shl    $0xc,%rax
  80241b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80241f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802423:	48 c1 e8 15          	shr    $0x15,%rax
  802427:	48 89 c2             	mov    %rax,%rdx
  80242a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802431:	01 00 00 
  802434:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802438:	83 e0 01             	and    $0x1,%eax
  80243b:	48 85 c0             	test   %rax,%rax
  80243e:	74 21                	je     802461 <fd_lookup+0x77>
  802440:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802444:	48 c1 e8 0c          	shr    $0xc,%rax
  802448:	48 89 c2             	mov    %rax,%rdx
  80244b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802452:	01 00 00 
  802455:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802459:	83 e0 01             	and    $0x1,%eax
  80245c:	48 85 c0             	test   %rax,%rax
  80245f:	75 07                	jne    802468 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802461:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802466:	eb 10                	jmp    802478 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802468:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80246c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802470:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802478:	c9                   	leaveq 
  802479:	c3                   	retq   

000000000080247a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80247a:	55                   	push   %rbp
  80247b:	48 89 e5             	mov    %rsp,%rbp
  80247e:	48 83 ec 30          	sub    $0x30,%rsp
  802482:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802486:	89 f0                	mov    %esi,%eax
  802488:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80248b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80248f:	48 89 c7             	mov    %rax,%rdi
  802492:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  802499:	00 00 00 
  80249c:	ff d0                	callq  *%rax
  80249e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a2:	48 89 d6             	mov    %rdx,%rsi
  8024a5:	89 c7                	mov    %eax,%edi
  8024a7:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  8024ae:	00 00 00 
  8024b1:	ff d0                	callq  *%rax
  8024b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ba:	78 0a                	js     8024c6 <fd_close+0x4c>
	    || fd != fd2)
  8024bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8024c4:	74 12                	je     8024d8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8024c6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8024ca:	74 05                	je     8024d1 <fd_close+0x57>
  8024cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cf:	eb 05                	jmp    8024d6 <fd_close+0x5c>
  8024d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d6:	eb 69                	jmp    802541 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8024d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024dc:	8b 00                	mov    (%rax),%eax
  8024de:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024e2:	48 89 d6             	mov    %rdx,%rsi
  8024e5:	89 c7                	mov    %eax,%edi
  8024e7:	48 b8 43 25 80 00 00 	movabs $0x802543,%rax
  8024ee:	00 00 00 
  8024f1:	ff d0                	callq  *%rax
  8024f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fa:	78 2a                	js     802526 <fd_close+0xac>
		if (dev->dev_close)
  8024fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802500:	48 8b 40 20          	mov    0x20(%rax),%rax
  802504:	48 85 c0             	test   %rax,%rax
  802507:	74 16                	je     80251f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802511:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802515:	48 89 d7             	mov    %rdx,%rdi
  802518:	ff d0                	callq  *%rax
  80251a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251d:	eb 07                	jmp    802526 <fd_close+0xac>
		else
			r = 0;
  80251f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80252a:	48 89 c6             	mov    %rax,%rsi
  80252d:	bf 00 00 00 00       	mov    $0x0,%edi
  802532:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  802539:	00 00 00 
  80253c:	ff d0                	callq  *%rax
	return r;
  80253e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802541:	c9                   	leaveq 
  802542:	c3                   	retq   

0000000000802543 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802543:	55                   	push   %rbp
  802544:	48 89 e5             	mov    %rsp,%rbp
  802547:	48 83 ec 20          	sub    $0x20,%rsp
  80254b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80254e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802552:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802559:	eb 41                	jmp    80259c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80255b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802562:	00 00 00 
  802565:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802568:	48 63 d2             	movslq %edx,%rdx
  80256b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256f:	8b 00                	mov    (%rax),%eax
  802571:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802574:	75 22                	jne    802598 <dev_lookup+0x55>
			*dev = devtab[i];
  802576:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80257d:	00 00 00 
  802580:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802583:	48 63 d2             	movslq %edx,%rdx
  802586:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80258a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80258e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802591:	b8 00 00 00 00       	mov    $0x0,%eax
  802596:	eb 60                	jmp    8025f8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802598:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80259c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8025a3:	00 00 00 
  8025a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025a9:	48 63 d2             	movslq %edx,%rdx
  8025ac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025b0:	48 85 c0             	test   %rax,%rax
  8025b3:	75 a6                	jne    80255b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8025b5:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8025bc:	00 00 00 
  8025bf:	48 8b 00             	mov    (%rax),%rax
  8025c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025c8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8025cb:	89 c6                	mov    %eax,%esi
  8025cd:	48 bf f8 4e 80 00 00 	movabs $0x804ef8,%rdi
  8025d4:	00 00 00 
  8025d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dc:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  8025e3:	00 00 00 
  8025e6:	ff d1                	callq  *%rcx
	*dev = 0;
  8025e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ec:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8025f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8025f8:	c9                   	leaveq 
  8025f9:	c3                   	retq   

00000000008025fa <close>:

int
close(int fdnum)
{
  8025fa:	55                   	push   %rbp
  8025fb:	48 89 e5             	mov    %rsp,%rbp
  8025fe:	48 83 ec 20          	sub    $0x20,%rsp
  802602:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802605:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802609:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80260c:	48 89 d6             	mov    %rdx,%rsi
  80260f:	89 c7                	mov    %eax,%edi
  802611:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  802618:	00 00 00 
  80261b:	ff d0                	callq  *%rax
  80261d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802620:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802624:	79 05                	jns    80262b <close+0x31>
		return r;
  802626:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802629:	eb 18                	jmp    802643 <close+0x49>
	else
		return fd_close(fd, 1);
  80262b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80262f:	be 01 00 00 00       	mov    $0x1,%esi
  802634:	48 89 c7             	mov    %rax,%rdi
  802637:	48 b8 7a 24 80 00 00 	movabs $0x80247a,%rax
  80263e:	00 00 00 
  802641:	ff d0                	callq  *%rax
}
  802643:	c9                   	leaveq 
  802644:	c3                   	retq   

0000000000802645 <close_all>:

void
close_all(void)
{
  802645:	55                   	push   %rbp
  802646:	48 89 e5             	mov    %rsp,%rbp
  802649:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80264d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802654:	eb 15                	jmp    80266b <close_all+0x26>
		close(i);
  802656:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802659:	89 c7                	mov    %eax,%edi
  80265b:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  802662:	00 00 00 
  802665:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802667:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80266b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80266f:	7e e5                	jle    802656 <close_all+0x11>
		close(i);
}
  802671:	c9                   	leaveq 
  802672:	c3                   	retq   

0000000000802673 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802673:	55                   	push   %rbp
  802674:	48 89 e5             	mov    %rsp,%rbp
  802677:	48 83 ec 40          	sub    $0x40,%rsp
  80267b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80267e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802681:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802685:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802688:	48 89 d6             	mov    %rdx,%rsi
  80268b:	89 c7                	mov    %eax,%edi
  80268d:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  802694:	00 00 00 
  802697:	ff d0                	callq  *%rax
  802699:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026a0:	79 08                	jns    8026aa <dup+0x37>
		return r;
  8026a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a5:	e9 70 01 00 00       	jmpq   80281a <dup+0x1a7>
	close(newfdnum);
  8026aa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026ad:	89 c7                	mov    %eax,%edi
  8026af:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  8026b6:	00 00 00 
  8026b9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8026bb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8026be:	48 98                	cltq   
  8026c0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026c6:	48 c1 e0 0c          	shl    $0xc,%rax
  8026ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8026ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d2:	48 89 c7             	mov    %rax,%rdi
  8026d5:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  8026dc:	00 00 00 
  8026df:	ff d0                	callq  *%rax
  8026e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8026e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e9:	48 89 c7             	mov    %rax,%rdi
  8026ec:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  8026f3:	00 00 00 
  8026f6:	ff d0                	callq  *%rax
  8026f8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8026fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802700:	48 c1 e8 15          	shr    $0x15,%rax
  802704:	48 89 c2             	mov    %rax,%rdx
  802707:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80270e:	01 00 00 
  802711:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802715:	83 e0 01             	and    $0x1,%eax
  802718:	48 85 c0             	test   %rax,%rax
  80271b:	74 73                	je     802790 <dup+0x11d>
  80271d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802721:	48 c1 e8 0c          	shr    $0xc,%rax
  802725:	48 89 c2             	mov    %rax,%rdx
  802728:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80272f:	01 00 00 
  802732:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802736:	83 e0 01             	and    $0x1,%eax
  802739:	48 85 c0             	test   %rax,%rax
  80273c:	74 52                	je     802790 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80273e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802742:	48 c1 e8 0c          	shr    $0xc,%rax
  802746:	48 89 c2             	mov    %rax,%rdx
  802749:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802750:	01 00 00 
  802753:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802757:	25 07 0e 00 00       	and    $0xe07,%eax
  80275c:	89 c1                	mov    %eax,%ecx
  80275e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802766:	41 89 c8             	mov    %ecx,%r8d
  802769:	48 89 d1             	mov    %rdx,%rcx
  80276c:	ba 00 00 00 00       	mov    $0x0,%edx
  802771:	48 89 c6             	mov    %rax,%rsi
  802774:	bf 00 00 00 00       	mov    $0x0,%edi
  802779:	48 b8 36 1d 80 00 00 	movabs $0x801d36,%rax
  802780:	00 00 00 
  802783:	ff d0                	callq  *%rax
  802785:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802788:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278c:	79 02                	jns    802790 <dup+0x11d>
			goto err;
  80278e:	eb 57                	jmp    8027e7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802794:	48 c1 e8 0c          	shr    $0xc,%rax
  802798:	48 89 c2             	mov    %rax,%rdx
  80279b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027a2:	01 00 00 
  8027a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8027ae:	89 c1                	mov    %eax,%ecx
  8027b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027b8:	41 89 c8             	mov    %ecx,%r8d
  8027bb:	48 89 d1             	mov    %rdx,%rcx
  8027be:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c3:	48 89 c6             	mov    %rax,%rsi
  8027c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8027cb:	48 b8 36 1d 80 00 00 	movabs $0x801d36,%rax
  8027d2:	00 00 00 
  8027d5:	ff d0                	callq  *%rax
  8027d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027de:	79 02                	jns    8027e2 <dup+0x16f>
		goto err;
  8027e0:	eb 05                	jmp    8027e7 <dup+0x174>

	return newfdnum;
  8027e2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027e5:	eb 33                	jmp    80281a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8027e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027eb:	48 89 c6             	mov    %rax,%rsi
  8027ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f3:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  8027fa:	00 00 00 
  8027fd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8027ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802803:	48 89 c6             	mov    %rax,%rsi
  802806:	bf 00 00 00 00       	mov    $0x0,%edi
  80280b:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  802812:	00 00 00 
  802815:	ff d0                	callq  *%rax
	return r;
  802817:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80281a:	c9                   	leaveq 
  80281b:	c3                   	retq   

000000000080281c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80281c:	55                   	push   %rbp
  80281d:	48 89 e5             	mov    %rsp,%rbp
  802820:	48 83 ec 40          	sub    $0x40,%rsp
  802824:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802827:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80282b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80282f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802833:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802836:	48 89 d6             	mov    %rdx,%rsi
  802839:	89 c7                	mov    %eax,%edi
  80283b:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  802842:	00 00 00 
  802845:	ff d0                	callq  *%rax
  802847:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284e:	78 24                	js     802874 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802854:	8b 00                	mov    (%rax),%eax
  802856:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80285a:	48 89 d6             	mov    %rdx,%rsi
  80285d:	89 c7                	mov    %eax,%edi
  80285f:	48 b8 43 25 80 00 00 	movabs $0x802543,%rax
  802866:	00 00 00 
  802869:	ff d0                	callq  *%rax
  80286b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802872:	79 05                	jns    802879 <read+0x5d>
		return r;
  802874:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802877:	eb 76                	jmp    8028ef <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80287d:	8b 40 08             	mov    0x8(%rax),%eax
  802880:	83 e0 03             	and    $0x3,%eax
  802883:	83 f8 01             	cmp    $0x1,%eax
  802886:	75 3a                	jne    8028c2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802888:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80288f:	00 00 00 
  802892:	48 8b 00             	mov    (%rax),%rax
  802895:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80289b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80289e:	89 c6                	mov    %eax,%esi
  8028a0:	48 bf 17 4f 80 00 00 	movabs $0x804f17,%rdi
  8028a7:	00 00 00 
  8028aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8028af:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  8028b6:	00 00 00 
  8028b9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028c0:	eb 2d                	jmp    8028ef <read+0xd3>
	}
	if (!dev->dev_read)
  8028c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028ca:	48 85 c0             	test   %rax,%rax
  8028cd:	75 07                	jne    8028d6 <read+0xba>
		return -E_NOT_SUPP;
  8028cf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028d4:	eb 19                	jmp    8028ef <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8028d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028da:	48 8b 40 10          	mov    0x10(%rax),%rax
  8028de:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028e2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028e6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028ea:	48 89 cf             	mov    %rcx,%rdi
  8028ed:	ff d0                	callq  *%rax
}
  8028ef:	c9                   	leaveq 
  8028f0:	c3                   	retq   

00000000008028f1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8028f1:	55                   	push   %rbp
  8028f2:	48 89 e5             	mov    %rsp,%rbp
  8028f5:	48 83 ec 30          	sub    $0x30,%rsp
  8028f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802900:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802904:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80290b:	eb 49                	jmp    802956 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80290d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802910:	48 98                	cltq   
  802912:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802916:	48 29 c2             	sub    %rax,%rdx
  802919:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80291c:	48 63 c8             	movslq %eax,%rcx
  80291f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802923:	48 01 c1             	add    %rax,%rcx
  802926:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802929:	48 89 ce             	mov    %rcx,%rsi
  80292c:	89 c7                	mov    %eax,%edi
  80292e:	48 b8 1c 28 80 00 00 	movabs $0x80281c,%rax
  802935:	00 00 00 
  802938:	ff d0                	callq  *%rax
  80293a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80293d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802941:	79 05                	jns    802948 <readn+0x57>
			return m;
  802943:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802946:	eb 1c                	jmp    802964 <readn+0x73>
		if (m == 0)
  802948:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80294c:	75 02                	jne    802950 <readn+0x5f>
			break;
  80294e:	eb 11                	jmp    802961 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802950:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802953:	01 45 fc             	add    %eax,-0x4(%rbp)
  802956:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802959:	48 98                	cltq   
  80295b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80295f:	72 ac                	jb     80290d <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802961:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802964:	c9                   	leaveq 
  802965:	c3                   	retq   

0000000000802966 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802966:	55                   	push   %rbp
  802967:	48 89 e5             	mov    %rsp,%rbp
  80296a:	48 83 ec 40          	sub    $0x40,%rsp
  80296e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802971:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802975:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802979:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80297d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802980:	48 89 d6             	mov    %rdx,%rsi
  802983:	89 c7                	mov    %eax,%edi
  802985:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  80298c:	00 00 00 
  80298f:	ff d0                	callq  *%rax
  802991:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802994:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802998:	78 24                	js     8029be <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80299a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80299e:	8b 00                	mov    (%rax),%eax
  8029a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a4:	48 89 d6             	mov    %rdx,%rsi
  8029a7:	89 c7                	mov    %eax,%edi
  8029a9:	48 b8 43 25 80 00 00 	movabs $0x802543,%rax
  8029b0:	00 00 00 
  8029b3:	ff d0                	callq  *%rax
  8029b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bc:	79 05                	jns    8029c3 <write+0x5d>
		return r;
  8029be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c1:	eb 75                	jmp    802a38 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8029c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c7:	8b 40 08             	mov    0x8(%rax),%eax
  8029ca:	83 e0 03             	and    $0x3,%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	75 3a                	jne    802a0b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8029d1:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8029d8:	00 00 00 
  8029db:	48 8b 00             	mov    (%rax),%rax
  8029de:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029e4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029e7:	89 c6                	mov    %eax,%esi
  8029e9:	48 bf 33 4f 80 00 00 	movabs $0x804f33,%rdi
  8029f0:	00 00 00 
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  8029ff:	00 00 00 
  802a02:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a09:	eb 2d                	jmp    802a38 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802a0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a13:	48 85 c0             	test   %rax,%rax
  802a16:	75 07                	jne    802a1f <write+0xb9>
		return -E_NOT_SUPP;
  802a18:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a1d:	eb 19                	jmp    802a38 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802a1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a23:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a27:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a2b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a2f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a33:	48 89 cf             	mov    %rcx,%rdi
  802a36:	ff d0                	callq  *%rax
}
  802a38:	c9                   	leaveq 
  802a39:	c3                   	retq   

0000000000802a3a <seek>:

int
seek(int fdnum, off_t offset)
{
  802a3a:	55                   	push   %rbp
  802a3b:	48 89 e5             	mov    %rsp,%rbp
  802a3e:	48 83 ec 18          	sub    $0x18,%rsp
  802a42:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a45:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a48:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a4f:	48 89 d6             	mov    %rdx,%rsi
  802a52:	89 c7                	mov    %eax,%edi
  802a54:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  802a5b:	00 00 00 
  802a5e:	ff d0                	callq  *%rax
  802a60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a67:	79 05                	jns    802a6e <seek+0x34>
		return r;
  802a69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6c:	eb 0f                	jmp    802a7d <seek+0x43>
	fd->fd_offset = offset;
  802a6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a72:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a75:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7d:	c9                   	leaveq 
  802a7e:	c3                   	retq   

0000000000802a7f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802a7f:	55                   	push   %rbp
  802a80:	48 89 e5             	mov    %rsp,%rbp
  802a83:	48 83 ec 30          	sub    $0x30,%rsp
  802a87:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a8a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a8d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a91:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a94:	48 89 d6             	mov    %rdx,%rsi
  802a97:	89 c7                	mov    %eax,%edi
  802a99:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  802aa0:	00 00 00 
  802aa3:	ff d0                	callq  *%rax
  802aa5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aac:	78 24                	js     802ad2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802aae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab2:	8b 00                	mov    (%rax),%eax
  802ab4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ab8:	48 89 d6             	mov    %rdx,%rsi
  802abb:	89 c7                	mov    %eax,%edi
  802abd:	48 b8 43 25 80 00 00 	movabs $0x802543,%rax
  802ac4:	00 00 00 
  802ac7:	ff d0                	callq  *%rax
  802ac9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad0:	79 05                	jns    802ad7 <ftruncate+0x58>
		return r;
  802ad2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad5:	eb 72                	jmp    802b49 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ad7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802adb:	8b 40 08             	mov    0x8(%rax),%eax
  802ade:	83 e0 03             	and    $0x3,%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	75 3a                	jne    802b1f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ae5:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802aec:	00 00 00 
  802aef:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802af2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802af8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802afb:	89 c6                	mov    %eax,%esi
  802afd:	48 bf 50 4f 80 00 00 	movabs $0x804f50,%rdi
  802b04:	00 00 00 
  802b07:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0c:	48 b9 02 08 80 00 00 	movabs $0x800802,%rcx
  802b13:	00 00 00 
  802b16:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802b18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b1d:	eb 2a                	jmp    802b49 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802b1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b23:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b27:	48 85 c0             	test   %rax,%rax
  802b2a:	75 07                	jne    802b33 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802b2c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b31:	eb 16                	jmp    802b49 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b37:	48 8b 40 30          	mov    0x30(%rax),%rax
  802b3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b3f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802b42:	89 ce                	mov    %ecx,%esi
  802b44:	48 89 d7             	mov    %rdx,%rdi
  802b47:	ff d0                	callq  *%rax
}
  802b49:	c9                   	leaveq 
  802b4a:	c3                   	retq   

0000000000802b4b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802b4b:	55                   	push   %rbp
  802b4c:	48 89 e5             	mov    %rsp,%rbp
  802b4f:	48 83 ec 30          	sub    $0x30,%rsp
  802b53:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b56:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b5a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b5e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b61:	48 89 d6             	mov    %rdx,%rsi
  802b64:	89 c7                	mov    %eax,%edi
  802b66:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  802b6d:	00 00 00 
  802b70:	ff d0                	callq  *%rax
  802b72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b79:	78 24                	js     802b9f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7f:	8b 00                	mov    (%rax),%eax
  802b81:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b85:	48 89 d6             	mov    %rdx,%rsi
  802b88:	89 c7                	mov    %eax,%edi
  802b8a:	48 b8 43 25 80 00 00 	movabs $0x802543,%rax
  802b91:	00 00 00 
  802b94:	ff d0                	callq  *%rax
  802b96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9d:	79 05                	jns    802ba4 <fstat+0x59>
		return r;
  802b9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba2:	eb 5e                	jmp    802c02 <fstat+0xb7>
	if (!dev->dev_stat)
  802ba4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba8:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bac:	48 85 c0             	test   %rax,%rax
  802baf:	75 07                	jne    802bb8 <fstat+0x6d>
		return -E_NOT_SUPP;
  802bb1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bb6:	eb 4a                	jmp    802c02 <fstat+0xb7>
	stat->st_name[0] = 0;
  802bb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bbc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802bbf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bc3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802bca:	00 00 00 
	stat->st_isdir = 0;
  802bcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bd1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802bd8:	00 00 00 
	stat->st_dev = dev;
  802bdb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bdf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802be3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802bea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bee:	48 8b 40 28          	mov    0x28(%rax),%rax
  802bf2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bf6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bfa:	48 89 ce             	mov    %rcx,%rsi
  802bfd:	48 89 d7             	mov    %rdx,%rdi
  802c00:	ff d0                	callq  *%rax
}
  802c02:	c9                   	leaveq 
  802c03:	c3                   	retq   

0000000000802c04 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c04:	55                   	push   %rbp
  802c05:	48 89 e5             	mov    %rsp,%rbp
  802c08:	48 83 ec 20          	sub    $0x20,%rsp
  802c0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c18:	be 00 00 00 00       	mov    $0x0,%esi
  802c1d:	48 89 c7             	mov    %rax,%rdi
  802c20:	48 b8 f2 2c 80 00 00 	movabs $0x802cf2,%rax
  802c27:	00 00 00 
  802c2a:	ff d0                	callq  *%rax
  802c2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c33:	79 05                	jns    802c3a <stat+0x36>
		return fd;
  802c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c38:	eb 2f                	jmp    802c69 <stat+0x65>
	r = fstat(fd, stat);
  802c3a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c41:	48 89 d6             	mov    %rdx,%rsi
  802c44:	89 c7                	mov    %eax,%edi
  802c46:	48 b8 4b 2b 80 00 00 	movabs $0x802b4b,%rax
  802c4d:	00 00 00 
  802c50:	ff d0                	callq  *%rax
  802c52:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c58:	89 c7                	mov    %eax,%edi
  802c5a:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  802c61:	00 00 00 
  802c64:	ff d0                	callq  *%rax
	return r;
  802c66:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802c69:	c9                   	leaveq 
  802c6a:	c3                   	retq   

0000000000802c6b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802c6b:	55                   	push   %rbp
  802c6c:	48 89 e5             	mov    %rsp,%rbp
  802c6f:	48 83 ec 10          	sub    $0x10,%rsp
  802c73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802c7a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c81:	00 00 00 
  802c84:	8b 00                	mov    (%rax),%eax
  802c86:	85 c0                	test   %eax,%eax
  802c88:	75 1d                	jne    802ca7 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802c8a:	bf 01 00 00 00       	mov    $0x1,%edi
  802c8f:	48 b8 fc 47 80 00 00 	movabs $0x8047fc,%rax
  802c96:	00 00 00 
  802c99:	ff d0                	callq  *%rax
  802c9b:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802ca2:	00 00 00 
  802ca5:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ca7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cae:	00 00 00 
  802cb1:	8b 00                	mov    (%rax),%eax
  802cb3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802cb6:	b9 07 00 00 00       	mov    $0x7,%ecx
  802cbb:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802cc2:	00 00 00 
  802cc5:	89 c7                	mov    %eax,%edi
  802cc7:	48 b8 9a 47 80 00 00 	movabs $0x80479a,%rax
  802cce:	00 00 00 
  802cd1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd7:	ba 00 00 00 00       	mov    $0x0,%edx
  802cdc:	48 89 c6             	mov    %rax,%rsi
  802cdf:	bf 00 00 00 00       	mov    $0x0,%edi
  802ce4:	48 b8 94 46 80 00 00 	movabs $0x804694,%rax
  802ceb:	00 00 00 
  802cee:	ff d0                	callq  *%rax
}
  802cf0:	c9                   	leaveq 
  802cf1:	c3                   	retq   

0000000000802cf2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802cf2:	55                   	push   %rbp
  802cf3:	48 89 e5             	mov    %rsp,%rbp
  802cf6:	48 83 ec 30          	sub    $0x30,%rsp
  802cfa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802cfe:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802d01:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802d08:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802d0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802d16:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d1b:	75 08                	jne    802d25 <open+0x33>
	{
		return r;
  802d1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d20:	e9 f2 00 00 00       	jmpq   802e17 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802d25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d29:	48 89 c7             	mov    %rax,%rdi
  802d2c:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  802d33:	00 00 00 
  802d36:	ff d0                	callq  *%rax
  802d38:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d3b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802d42:	7e 0a                	jle    802d4e <open+0x5c>
	{
		return -E_BAD_PATH;
  802d44:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802d49:	e9 c9 00 00 00       	jmpq   802e17 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802d4e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802d55:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802d56:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802d5a:	48 89 c7             	mov    %rax,%rdi
  802d5d:	48 b8 52 23 80 00 00 	movabs $0x802352,%rax
  802d64:	00 00 00 
  802d67:	ff d0                	callq  *%rax
  802d69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d70:	78 09                	js     802d7b <open+0x89>
  802d72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d76:	48 85 c0             	test   %rax,%rax
  802d79:	75 08                	jne    802d83 <open+0x91>
		{
			return r;
  802d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7e:	e9 94 00 00 00       	jmpq   802e17 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802d83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d87:	ba 00 04 00 00       	mov    $0x400,%edx
  802d8c:	48 89 c6             	mov    %rax,%rsi
  802d8f:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802d96:	00 00 00 
  802d99:	48 b8 49 14 80 00 00 	movabs $0x801449,%rax
  802da0:	00 00 00 
  802da3:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802da5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802dac:	00 00 00 
  802daf:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802db2:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802db8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dbc:	48 89 c6             	mov    %rax,%rsi
  802dbf:	bf 01 00 00 00       	mov    $0x1,%edi
  802dc4:	48 b8 6b 2c 80 00 00 	movabs $0x802c6b,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	callq  *%rax
  802dd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd7:	79 2b                	jns    802e04 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802dd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddd:	be 00 00 00 00       	mov    $0x0,%esi
  802de2:	48 89 c7             	mov    %rax,%rdi
  802de5:	48 b8 7a 24 80 00 00 	movabs $0x80247a,%rax
  802dec:	00 00 00 
  802def:	ff d0                	callq  *%rax
  802df1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802df4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802df8:	79 05                	jns    802dff <open+0x10d>
			{
				return d;
  802dfa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dfd:	eb 18                	jmp    802e17 <open+0x125>
			}
			return r;
  802dff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e02:	eb 13                	jmp    802e17 <open+0x125>
		}	
		return fd2num(fd_store);
  802e04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e08:	48 89 c7             	mov    %rax,%rdi
  802e0b:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  802e12:	00 00 00 
  802e15:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802e17:	c9                   	leaveq 
  802e18:	c3                   	retq   

0000000000802e19 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e19:	55                   	push   %rbp
  802e1a:	48 89 e5             	mov    %rsp,%rbp
  802e1d:	48 83 ec 10          	sub    $0x10,%rsp
  802e21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e29:	8b 50 0c             	mov    0xc(%rax),%edx
  802e2c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e33:	00 00 00 
  802e36:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e38:	be 00 00 00 00       	mov    $0x0,%esi
  802e3d:	bf 06 00 00 00       	mov    $0x6,%edi
  802e42:	48 b8 6b 2c 80 00 00 	movabs $0x802c6b,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	callq  *%rax
}
  802e4e:	c9                   	leaveq 
  802e4f:	c3                   	retq   

0000000000802e50 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e50:	55                   	push   %rbp
  802e51:	48 89 e5             	mov    %rsp,%rbp
  802e54:	48 83 ec 30          	sub    $0x30,%rsp
  802e58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e60:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802e64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802e6b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e70:	74 07                	je     802e79 <devfile_read+0x29>
  802e72:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802e77:	75 07                	jne    802e80 <devfile_read+0x30>
		return -E_INVAL;
  802e79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e7e:	eb 77                	jmp    802ef7 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e84:	8b 50 0c             	mov    0xc(%rax),%edx
  802e87:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e8e:	00 00 00 
  802e91:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802e93:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e9a:	00 00 00 
  802e9d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ea1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802ea5:	be 00 00 00 00       	mov    $0x0,%esi
  802eaa:	bf 03 00 00 00       	mov    $0x3,%edi
  802eaf:	48 b8 6b 2c 80 00 00 	movabs $0x802c6b,%rax
  802eb6:	00 00 00 
  802eb9:	ff d0                	callq  *%rax
  802ebb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec2:	7f 05                	jg     802ec9 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802ec4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec7:	eb 2e                	jmp    802ef7 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802ec9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ecc:	48 63 d0             	movslq %eax,%rdx
  802ecf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed3:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802eda:	00 00 00 
  802edd:	48 89 c7             	mov    %rax,%rdi
  802ee0:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  802ee7:	00 00 00 
  802eea:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802eec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802ef4:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802ef7:	c9                   	leaveq 
  802ef8:	c3                   	retq   

0000000000802ef9 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ef9:	55                   	push   %rbp
  802efa:	48 89 e5             	mov    %rsp,%rbp
  802efd:	48 83 ec 30          	sub    $0x30,%rsp
  802f01:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f05:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f09:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802f0d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802f14:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802f19:	74 07                	je     802f22 <devfile_write+0x29>
  802f1b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802f20:	75 08                	jne    802f2a <devfile_write+0x31>
		return r;
  802f22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f25:	e9 9a 00 00 00       	jmpq   802fc4 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802f2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2e:	8b 50 0c             	mov    0xc(%rax),%edx
  802f31:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f38:	00 00 00 
  802f3b:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802f3d:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f44:	00 
  802f45:	76 08                	jbe    802f4f <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802f47:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802f4e:	00 
	}
	fsipcbuf.write.req_n = n;
  802f4f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f56:	00 00 00 
  802f59:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f5d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802f61:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f69:	48 89 c6             	mov    %rax,%rsi
  802f6c:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802f73:	00 00 00 
  802f76:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  802f7d:	00 00 00 
  802f80:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802f82:	be 00 00 00 00       	mov    $0x0,%esi
  802f87:	bf 04 00 00 00       	mov    $0x4,%edi
  802f8c:	48 b8 6b 2c 80 00 00 	movabs $0x802c6b,%rax
  802f93:	00 00 00 
  802f96:	ff d0                	callq  *%rax
  802f98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9f:	7f 20                	jg     802fc1 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802fa1:	48 bf 76 4f 80 00 00 	movabs $0x804f76,%rdi
  802fa8:	00 00 00 
  802fab:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb0:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  802fb7:	00 00 00 
  802fba:	ff d2                	callq  *%rdx
		return r;
  802fbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbf:	eb 03                	jmp    802fc4 <devfile_write+0xcb>
	}
	return r;
  802fc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802fc4:	c9                   	leaveq 
  802fc5:	c3                   	retq   

0000000000802fc6 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802fc6:	55                   	push   %rbp
  802fc7:	48 89 e5             	mov    %rsp,%rbp
  802fca:	48 83 ec 20          	sub    $0x20,%rsp
  802fce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fd2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fda:	8b 50 0c             	mov    0xc(%rax),%edx
  802fdd:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fe4:	00 00 00 
  802fe7:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802fe9:	be 00 00 00 00       	mov    $0x0,%esi
  802fee:	bf 05 00 00 00       	mov    $0x5,%edi
  802ff3:	48 b8 6b 2c 80 00 00 	movabs $0x802c6b,%rax
  802ffa:	00 00 00 
  802ffd:	ff d0                	callq  *%rax
  802fff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803002:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803006:	79 05                	jns    80300d <devfile_stat+0x47>
		return r;
  803008:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300b:	eb 56                	jmp    803063 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80300d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803011:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803018:	00 00 00 
  80301b:	48 89 c7             	mov    %rax,%rdi
  80301e:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  803025:	00 00 00 
  803028:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80302a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803031:	00 00 00 
  803034:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80303a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80303e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803044:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80304b:	00 00 00 
  80304e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803054:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803058:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80305e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803063:	c9                   	leaveq 
  803064:	c3                   	retq   

0000000000803065 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803065:	55                   	push   %rbp
  803066:	48 89 e5             	mov    %rsp,%rbp
  803069:	48 83 ec 10          	sub    $0x10,%rsp
  80306d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803071:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803074:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803078:	8b 50 0c             	mov    0xc(%rax),%edx
  80307b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803082:	00 00 00 
  803085:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803087:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80308e:	00 00 00 
  803091:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803094:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803097:	be 00 00 00 00       	mov    $0x0,%esi
  80309c:	bf 02 00 00 00       	mov    $0x2,%edi
  8030a1:	48 b8 6b 2c 80 00 00 	movabs $0x802c6b,%rax
  8030a8:	00 00 00 
  8030ab:	ff d0                	callq  *%rax
}
  8030ad:	c9                   	leaveq 
  8030ae:	c3                   	retq   

00000000008030af <remove>:

// Delete a file
int
remove(const char *path)
{
  8030af:	55                   	push   %rbp
  8030b0:	48 89 e5             	mov    %rsp,%rbp
  8030b3:	48 83 ec 10          	sub    $0x10,%rsp
  8030b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8030bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030bf:	48 89 c7             	mov    %rax,%rdi
  8030c2:	48 b8 4b 13 80 00 00 	movabs $0x80134b,%rax
  8030c9:	00 00 00 
  8030cc:	ff d0                	callq  *%rax
  8030ce:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030d3:	7e 07                	jle    8030dc <remove+0x2d>
		return -E_BAD_PATH;
  8030d5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030da:	eb 33                	jmp    80310f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8030dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030e0:	48 89 c6             	mov    %rax,%rsi
  8030e3:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8030ea:	00 00 00 
  8030ed:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  8030f4:	00 00 00 
  8030f7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8030f9:	be 00 00 00 00       	mov    $0x0,%esi
  8030fe:	bf 07 00 00 00       	mov    $0x7,%edi
  803103:	48 b8 6b 2c 80 00 00 	movabs $0x802c6b,%rax
  80310a:	00 00 00 
  80310d:	ff d0                	callq  *%rax
}
  80310f:	c9                   	leaveq 
  803110:	c3                   	retq   

0000000000803111 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803111:	55                   	push   %rbp
  803112:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803115:	be 00 00 00 00       	mov    $0x0,%esi
  80311a:	bf 08 00 00 00       	mov    $0x8,%edi
  80311f:	48 b8 6b 2c 80 00 00 	movabs $0x802c6b,%rax
  803126:	00 00 00 
  803129:	ff d0                	callq  *%rax
}
  80312b:	5d                   	pop    %rbp
  80312c:	c3                   	retq   

000000000080312d <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80312d:	55                   	push   %rbp
  80312e:	48 89 e5             	mov    %rsp,%rbp
  803131:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803138:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80313f:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803146:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80314d:	be 00 00 00 00       	mov    $0x0,%esi
  803152:	48 89 c7             	mov    %rax,%rdi
  803155:	48 b8 f2 2c 80 00 00 	movabs $0x802cf2,%rax
  80315c:	00 00 00 
  80315f:	ff d0                	callq  *%rax
  803161:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803164:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803168:	79 28                	jns    803192 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80316a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80316d:	89 c6                	mov    %eax,%esi
  80316f:	48 bf 92 4f 80 00 00 	movabs $0x804f92,%rdi
  803176:	00 00 00 
  803179:	b8 00 00 00 00       	mov    $0x0,%eax
  80317e:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  803185:	00 00 00 
  803188:	ff d2                	callq  *%rdx
		return fd_src;
  80318a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318d:	e9 74 01 00 00       	jmpq   803306 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803192:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803199:	be 01 01 00 00       	mov    $0x101,%esi
  80319e:	48 89 c7             	mov    %rax,%rdi
  8031a1:	48 b8 f2 2c 80 00 00 	movabs $0x802cf2,%rax
  8031a8:	00 00 00 
  8031ab:	ff d0                	callq  *%rax
  8031ad:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8031b0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031b4:	79 39                	jns    8031ef <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8031b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031b9:	89 c6                	mov    %eax,%esi
  8031bb:	48 bf a8 4f 80 00 00 	movabs $0x804fa8,%rdi
  8031c2:	00 00 00 
  8031c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ca:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  8031d1:	00 00 00 
  8031d4:	ff d2                	callq  *%rdx
		close(fd_src);
  8031d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d9:	89 c7                	mov    %eax,%edi
  8031db:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  8031e2:	00 00 00 
  8031e5:	ff d0                	callq  *%rax
		return fd_dest;
  8031e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ea:	e9 17 01 00 00       	jmpq   803306 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8031ef:	eb 74                	jmp    803265 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8031f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031f4:	48 63 d0             	movslq %eax,%rdx
  8031f7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8031fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803201:	48 89 ce             	mov    %rcx,%rsi
  803204:	89 c7                	mov    %eax,%edi
  803206:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  80320d:	00 00 00 
  803210:	ff d0                	callq  *%rax
  803212:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803215:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803219:	79 4a                	jns    803265 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80321b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80321e:	89 c6                	mov    %eax,%esi
  803220:	48 bf c2 4f 80 00 00 	movabs $0x804fc2,%rdi
  803227:	00 00 00 
  80322a:	b8 00 00 00 00       	mov    $0x0,%eax
  80322f:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  803236:	00 00 00 
  803239:	ff d2                	callq  *%rdx
			close(fd_src);
  80323b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323e:	89 c7                	mov    %eax,%edi
  803240:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  803247:	00 00 00 
  80324a:	ff d0                	callq  *%rax
			close(fd_dest);
  80324c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80324f:	89 c7                	mov    %eax,%edi
  803251:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  803258:	00 00 00 
  80325b:	ff d0                	callq  *%rax
			return write_size;
  80325d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803260:	e9 a1 00 00 00       	jmpq   803306 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803265:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80326c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326f:	ba 00 02 00 00       	mov    $0x200,%edx
  803274:	48 89 ce             	mov    %rcx,%rsi
  803277:	89 c7                	mov    %eax,%edi
  803279:	48 b8 1c 28 80 00 00 	movabs $0x80281c,%rax
  803280:	00 00 00 
  803283:	ff d0                	callq  *%rax
  803285:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803288:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80328c:	0f 8f 5f ff ff ff    	jg     8031f1 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803292:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803296:	79 47                	jns    8032df <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803298:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80329b:	89 c6                	mov    %eax,%esi
  80329d:	48 bf d5 4f 80 00 00 	movabs $0x804fd5,%rdi
  8032a4:	00 00 00 
  8032a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ac:	48 ba 02 08 80 00 00 	movabs $0x800802,%rdx
  8032b3:	00 00 00 
  8032b6:	ff d2                	callq  *%rdx
		close(fd_src);
  8032b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032bb:	89 c7                	mov    %eax,%edi
  8032bd:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  8032c4:	00 00 00 
  8032c7:	ff d0                	callq  *%rax
		close(fd_dest);
  8032c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032cc:	89 c7                	mov    %eax,%edi
  8032ce:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
		return read_size;
  8032da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032dd:	eb 27                	jmp    803306 <copy+0x1d9>
	}
	close(fd_src);
  8032df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e2:	89 c7                	mov    %eax,%edi
  8032e4:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  8032eb:	00 00 00 
  8032ee:	ff d0                	callq  *%rax
	close(fd_dest);
  8032f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032f3:	89 c7                	mov    %eax,%edi
  8032f5:	48 b8 fa 25 80 00 00 	movabs $0x8025fa,%rax
  8032fc:	00 00 00 
  8032ff:	ff d0                	callq  *%rax
	return 0;
  803301:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803306:	c9                   	leaveq 
  803307:	c3                   	retq   

0000000000803308 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  803308:	55                   	push   %rbp
  803309:	48 89 e5             	mov    %rsp,%rbp
  80330c:	48 83 ec 20          	sub    $0x20,%rsp
  803310:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  803314:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803318:	8b 40 0c             	mov    0xc(%rax),%eax
  80331b:	85 c0                	test   %eax,%eax
  80331d:	7e 67                	jle    803386 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80331f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803323:	8b 40 04             	mov    0x4(%rax),%eax
  803326:	48 63 d0             	movslq %eax,%rdx
  803329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80332d:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803335:	8b 00                	mov    (%rax),%eax
  803337:	48 89 ce             	mov    %rcx,%rsi
  80333a:	89 c7                	mov    %eax,%edi
  80333c:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  803343:	00 00 00 
  803346:	ff d0                	callq  *%rax
  803348:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  80334b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80334f:	7e 13                	jle    803364 <writebuf+0x5c>
			b->result += result;
  803351:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803355:	8b 50 08             	mov    0x8(%rax),%edx
  803358:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80335b:	01 c2                	add    %eax,%edx
  80335d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803361:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  803364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803368:	8b 40 04             	mov    0x4(%rax),%eax
  80336b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80336e:	74 16                	je     803386 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  803370:	b8 00 00 00 00       	mov    $0x0,%eax
  803375:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803379:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  80337d:	89 c2                	mov    %eax,%edx
  80337f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803383:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803386:	c9                   	leaveq 
  803387:	c3                   	retq   

0000000000803388 <putch>:

static void
putch(int ch, void *thunk)
{
  803388:	55                   	push   %rbp
  803389:	48 89 e5             	mov    %rsp,%rbp
  80338c:	48 83 ec 20          	sub    $0x20,%rsp
  803390:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803393:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  803397:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80339f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a3:	8b 40 04             	mov    0x4(%rax),%eax
  8033a6:	8d 48 01             	lea    0x1(%rax),%ecx
  8033a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033ad:	89 4a 04             	mov    %ecx,0x4(%rdx)
  8033b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033b3:	89 d1                	mov    %edx,%ecx
  8033b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033b9:	48 98                	cltq   
  8033bb:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  8033bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c3:	8b 40 04             	mov    0x4(%rax),%eax
  8033c6:	3d 00 01 00 00       	cmp    $0x100,%eax
  8033cb:	75 1e                	jne    8033eb <putch+0x63>
		writebuf(b);
  8033cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033d1:	48 89 c7             	mov    %rax,%rdi
  8033d4:	48 b8 08 33 80 00 00 	movabs $0x803308,%rax
  8033db:	00 00 00 
  8033de:	ff d0                	callq  *%rax
		b->idx = 0;
  8033e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  8033eb:	c9                   	leaveq 
  8033ec:	c3                   	retq   

00000000008033ed <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8033ed:	55                   	push   %rbp
  8033ee:	48 89 e5             	mov    %rsp,%rbp
  8033f1:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8033f8:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8033fe:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  803405:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  80340c:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  803412:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  803418:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80341f:	00 00 00 
	b.result = 0;
  803422:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803429:	00 00 00 
	b.error = 1;
  80342c:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  803433:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803436:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  80343d:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  803444:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80344b:	48 89 c6             	mov    %rax,%rsi
  80344e:	48 bf 88 33 80 00 00 	movabs $0x803388,%rdi
  803455:	00 00 00 
  803458:	48 b8 b5 0b 80 00 00 	movabs $0x800bb5,%rax
  80345f:	00 00 00 
  803462:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803464:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  80346a:	85 c0                	test   %eax,%eax
  80346c:	7e 16                	jle    803484 <vfprintf+0x97>
		writebuf(&b);
  80346e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803475:	48 89 c7             	mov    %rax,%rdi
  803478:	48 b8 08 33 80 00 00 	movabs $0x803308,%rax
  80347f:	00 00 00 
  803482:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803484:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80348a:	85 c0                	test   %eax,%eax
  80348c:	74 08                	je     803496 <vfprintf+0xa9>
  80348e:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803494:	eb 06                	jmp    80349c <vfprintf+0xaf>
  803496:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80349c:	c9                   	leaveq 
  80349d:	c3                   	retq   

000000000080349e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80349e:	55                   	push   %rbp
  80349f:	48 89 e5             	mov    %rsp,%rbp
  8034a2:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8034a9:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8034af:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8034b6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8034bd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8034c4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8034cb:	84 c0                	test   %al,%al
  8034cd:	74 20                	je     8034ef <fprintf+0x51>
  8034cf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8034d3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8034d7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8034db:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8034df:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8034e3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8034e7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8034eb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8034ef:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8034f6:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8034fd:	00 00 00 
  803500:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803507:	00 00 00 
  80350a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80350e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803515:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80351c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  803523:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80352a:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  803531:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803537:	48 89 ce             	mov    %rcx,%rsi
  80353a:	89 c7                	mov    %eax,%edi
  80353c:	48 b8 ed 33 80 00 00 	movabs $0x8033ed,%rax
  803543:	00 00 00 
  803546:	ff d0                	callq  *%rax
  803548:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80354e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803554:	c9                   	leaveq 
  803555:	c3                   	retq   

0000000000803556 <printf>:

int
printf(const char *fmt, ...)
{
  803556:	55                   	push   %rbp
  803557:	48 89 e5             	mov    %rsp,%rbp
  80355a:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803561:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803568:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80356f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803576:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80357d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803584:	84 c0                	test   %al,%al
  803586:	74 20                	je     8035a8 <printf+0x52>
  803588:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80358c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803590:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803594:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803598:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80359c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8035a0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8035a4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8035a8:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8035af:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8035b6:	00 00 00 
  8035b9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8035c0:	00 00 00 
  8035c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8035c7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8035ce:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8035d5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8035dc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8035e3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8035ea:	48 89 c6             	mov    %rax,%rsi
  8035ed:	bf 01 00 00 00       	mov    $0x1,%edi
  8035f2:	48 b8 ed 33 80 00 00 	movabs $0x8033ed,%rax
  8035f9:	00 00 00 
  8035fc:	ff d0                	callq  *%rax
  8035fe:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803604:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80360a:	c9                   	leaveq 
  80360b:	c3                   	retq   

000000000080360c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80360c:	55                   	push   %rbp
  80360d:	48 89 e5             	mov    %rsp,%rbp
  803610:	48 83 ec 20          	sub    $0x20,%rsp
  803614:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803617:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80361b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80361e:	48 89 d6             	mov    %rdx,%rsi
  803621:	89 c7                	mov    %eax,%edi
  803623:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  80362a:	00 00 00 
  80362d:	ff d0                	callq  *%rax
  80362f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803632:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803636:	79 05                	jns    80363d <fd2sockid+0x31>
		return r;
  803638:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363b:	eb 24                	jmp    803661 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80363d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803641:	8b 10                	mov    (%rax),%edx
  803643:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80364a:	00 00 00 
  80364d:	8b 00                	mov    (%rax),%eax
  80364f:	39 c2                	cmp    %eax,%edx
  803651:	74 07                	je     80365a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803653:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803658:	eb 07                	jmp    803661 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80365a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80365e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803661:	c9                   	leaveq 
  803662:	c3                   	retq   

0000000000803663 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803663:	55                   	push   %rbp
  803664:	48 89 e5             	mov    %rsp,%rbp
  803667:	48 83 ec 20          	sub    $0x20,%rsp
  80366b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80366e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803672:	48 89 c7             	mov    %rax,%rdi
  803675:	48 b8 52 23 80 00 00 	movabs $0x802352,%rax
  80367c:	00 00 00 
  80367f:	ff d0                	callq  *%rax
  803681:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803684:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803688:	78 26                	js     8036b0 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80368a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368e:	ba 07 04 00 00       	mov    $0x407,%edx
  803693:	48 89 c6             	mov    %rax,%rsi
  803696:	bf 00 00 00 00       	mov    $0x0,%edi
  80369b:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  8036a2:	00 00 00 
  8036a5:	ff d0                	callq  *%rax
  8036a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ae:	79 16                	jns    8036c6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8036b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036b3:	89 c7                	mov    %eax,%edi
  8036b5:	48 b8 70 3b 80 00 00 	movabs $0x803b70,%rax
  8036bc:	00 00 00 
  8036bf:	ff d0                	callq  *%rax
		return r;
  8036c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c4:	eb 3a                	jmp    803700 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8036c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ca:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8036d1:	00 00 00 
  8036d4:	8b 12                	mov    (%rdx),%edx
  8036d6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8036d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036dc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8036e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036ea:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8036ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f1:	48 89 c7             	mov    %rax,%rdi
  8036f4:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  8036fb:	00 00 00 
  8036fe:	ff d0                	callq  *%rax
}
  803700:	c9                   	leaveq 
  803701:	c3                   	retq   

0000000000803702 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803702:	55                   	push   %rbp
  803703:	48 89 e5             	mov    %rsp,%rbp
  803706:	48 83 ec 30          	sub    $0x30,%rsp
  80370a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80370d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803711:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803715:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803718:	89 c7                	mov    %eax,%edi
  80371a:	48 b8 0c 36 80 00 00 	movabs $0x80360c,%rax
  803721:	00 00 00 
  803724:	ff d0                	callq  *%rax
  803726:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803729:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80372d:	79 05                	jns    803734 <accept+0x32>
		return r;
  80372f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803732:	eb 3b                	jmp    80376f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803734:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803738:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80373c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373f:	48 89 ce             	mov    %rcx,%rsi
  803742:	89 c7                	mov    %eax,%edi
  803744:	48 b8 4d 3a 80 00 00 	movabs $0x803a4d,%rax
  80374b:	00 00 00 
  80374e:	ff d0                	callq  *%rax
  803750:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803753:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803757:	79 05                	jns    80375e <accept+0x5c>
		return r;
  803759:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375c:	eb 11                	jmp    80376f <accept+0x6d>
	return alloc_sockfd(r);
  80375e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803761:	89 c7                	mov    %eax,%edi
  803763:	48 b8 63 36 80 00 00 	movabs $0x803663,%rax
  80376a:	00 00 00 
  80376d:	ff d0                	callq  *%rax
}
  80376f:	c9                   	leaveq 
  803770:	c3                   	retq   

0000000000803771 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803771:	55                   	push   %rbp
  803772:	48 89 e5             	mov    %rsp,%rbp
  803775:	48 83 ec 20          	sub    $0x20,%rsp
  803779:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80377c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803780:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803783:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803786:	89 c7                	mov    %eax,%edi
  803788:	48 b8 0c 36 80 00 00 	movabs $0x80360c,%rax
  80378f:	00 00 00 
  803792:	ff d0                	callq  *%rax
  803794:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803797:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379b:	79 05                	jns    8037a2 <bind+0x31>
		return r;
  80379d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a0:	eb 1b                	jmp    8037bd <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8037a2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037a5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ac:	48 89 ce             	mov    %rcx,%rsi
  8037af:	89 c7                	mov    %eax,%edi
  8037b1:	48 b8 cc 3a 80 00 00 	movabs $0x803acc,%rax
  8037b8:	00 00 00 
  8037bb:	ff d0                	callq  *%rax
}
  8037bd:	c9                   	leaveq 
  8037be:	c3                   	retq   

00000000008037bf <shutdown>:

int
shutdown(int s, int how)
{
  8037bf:	55                   	push   %rbp
  8037c0:	48 89 e5             	mov    %rsp,%rbp
  8037c3:	48 83 ec 20          	sub    $0x20,%rsp
  8037c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037ca:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037d0:	89 c7                	mov    %eax,%edi
  8037d2:	48 b8 0c 36 80 00 00 	movabs $0x80360c,%rax
  8037d9:	00 00 00 
  8037dc:	ff d0                	callq  *%rax
  8037de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e5:	79 05                	jns    8037ec <shutdown+0x2d>
		return r;
  8037e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ea:	eb 16                	jmp    803802 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8037ec:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f2:	89 d6                	mov    %edx,%esi
  8037f4:	89 c7                	mov    %eax,%edi
  8037f6:	48 b8 30 3b 80 00 00 	movabs $0x803b30,%rax
  8037fd:	00 00 00 
  803800:	ff d0                	callq  *%rax
}
  803802:	c9                   	leaveq 
  803803:	c3                   	retq   

0000000000803804 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803804:	55                   	push   %rbp
  803805:	48 89 e5             	mov    %rsp,%rbp
  803808:	48 83 ec 10          	sub    $0x10,%rsp
  80380c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803810:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803814:	48 89 c7             	mov    %rax,%rdi
  803817:	48 b8 7e 48 80 00 00 	movabs $0x80487e,%rax
  80381e:	00 00 00 
  803821:	ff d0                	callq  *%rax
  803823:	83 f8 01             	cmp    $0x1,%eax
  803826:	75 17                	jne    80383f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803828:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382c:	8b 40 0c             	mov    0xc(%rax),%eax
  80382f:	89 c7                	mov    %eax,%edi
  803831:	48 b8 70 3b 80 00 00 	movabs $0x803b70,%rax
  803838:	00 00 00 
  80383b:	ff d0                	callq  *%rax
  80383d:	eb 05                	jmp    803844 <devsock_close+0x40>
	else
		return 0;
  80383f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803844:	c9                   	leaveq 
  803845:	c3                   	retq   

0000000000803846 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803846:	55                   	push   %rbp
  803847:	48 89 e5             	mov    %rsp,%rbp
  80384a:	48 83 ec 20          	sub    $0x20,%rsp
  80384e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803851:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803855:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803858:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80385b:	89 c7                	mov    %eax,%edi
  80385d:	48 b8 0c 36 80 00 00 	movabs $0x80360c,%rax
  803864:	00 00 00 
  803867:	ff d0                	callq  *%rax
  803869:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803870:	79 05                	jns    803877 <connect+0x31>
		return r;
  803872:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803875:	eb 1b                	jmp    803892 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803877:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80387a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80387e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803881:	48 89 ce             	mov    %rcx,%rsi
  803884:	89 c7                	mov    %eax,%edi
  803886:	48 b8 9d 3b 80 00 00 	movabs $0x803b9d,%rax
  80388d:	00 00 00 
  803890:	ff d0                	callq  *%rax
}
  803892:	c9                   	leaveq 
  803893:	c3                   	retq   

0000000000803894 <listen>:

int
listen(int s, int backlog)
{
  803894:	55                   	push   %rbp
  803895:	48 89 e5             	mov    %rsp,%rbp
  803898:	48 83 ec 20          	sub    $0x20,%rsp
  80389c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80389f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a5:	89 c7                	mov    %eax,%edi
  8038a7:	48 b8 0c 36 80 00 00 	movabs $0x80360c,%rax
  8038ae:	00 00 00 
  8038b1:	ff d0                	callq  *%rax
  8038b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ba:	79 05                	jns    8038c1 <listen+0x2d>
		return r;
  8038bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038bf:	eb 16                	jmp    8038d7 <listen+0x43>
	return nsipc_listen(r, backlog);
  8038c1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c7:	89 d6                	mov    %edx,%esi
  8038c9:	89 c7                	mov    %eax,%edi
  8038cb:	48 b8 01 3c 80 00 00 	movabs $0x803c01,%rax
  8038d2:	00 00 00 
  8038d5:	ff d0                	callq  *%rax
}
  8038d7:	c9                   	leaveq 
  8038d8:	c3                   	retq   

00000000008038d9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8038d9:	55                   	push   %rbp
  8038da:	48 89 e5             	mov    %rsp,%rbp
  8038dd:	48 83 ec 20          	sub    $0x20,%rsp
  8038e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038e9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8038ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038f1:	89 c2                	mov    %eax,%edx
  8038f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f7:	8b 40 0c             	mov    0xc(%rax),%eax
  8038fa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  803903:	89 c7                	mov    %eax,%edi
  803905:	48 b8 41 3c 80 00 00 	movabs $0x803c41,%rax
  80390c:	00 00 00 
  80390f:	ff d0                	callq  *%rax
}
  803911:	c9                   	leaveq 
  803912:	c3                   	retq   

0000000000803913 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803913:	55                   	push   %rbp
  803914:	48 89 e5             	mov    %rsp,%rbp
  803917:	48 83 ec 20          	sub    $0x20,%rsp
  80391b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80391f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803923:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803927:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80392b:	89 c2                	mov    %eax,%edx
  80392d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803931:	8b 40 0c             	mov    0xc(%rax),%eax
  803934:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803938:	b9 00 00 00 00       	mov    $0x0,%ecx
  80393d:	89 c7                	mov    %eax,%edi
  80393f:	48 b8 0d 3d 80 00 00 	movabs $0x803d0d,%rax
  803946:	00 00 00 
  803949:	ff d0                	callq  *%rax
}
  80394b:	c9                   	leaveq 
  80394c:	c3                   	retq   

000000000080394d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80394d:	55                   	push   %rbp
  80394e:	48 89 e5             	mov    %rsp,%rbp
  803951:	48 83 ec 10          	sub    $0x10,%rsp
  803955:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803959:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80395d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803961:	48 be f0 4f 80 00 00 	movabs $0x804ff0,%rsi
  803968:	00 00 00 
  80396b:	48 89 c7             	mov    %rax,%rdi
  80396e:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  803975:	00 00 00 
  803978:	ff d0                	callq  *%rax
	return 0;
  80397a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80397f:	c9                   	leaveq 
  803980:	c3                   	retq   

0000000000803981 <socket>:

int
socket(int domain, int type, int protocol)
{
  803981:	55                   	push   %rbp
  803982:	48 89 e5             	mov    %rsp,%rbp
  803985:	48 83 ec 20          	sub    $0x20,%rsp
  803989:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80398c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80398f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803992:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803995:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803998:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80399b:	89 ce                	mov    %ecx,%esi
  80399d:	89 c7                	mov    %eax,%edi
  80399f:	48 b8 c5 3d 80 00 00 	movabs $0x803dc5,%rax
  8039a6:	00 00 00 
  8039a9:	ff d0                	callq  *%rax
  8039ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b2:	79 05                	jns    8039b9 <socket+0x38>
		return r;
  8039b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b7:	eb 11                	jmp    8039ca <socket+0x49>
	return alloc_sockfd(r);
  8039b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039bc:	89 c7                	mov    %eax,%edi
  8039be:	48 b8 63 36 80 00 00 	movabs $0x803663,%rax
  8039c5:	00 00 00 
  8039c8:	ff d0                	callq  *%rax
}
  8039ca:	c9                   	leaveq 
  8039cb:	c3                   	retq   

00000000008039cc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8039cc:	55                   	push   %rbp
  8039cd:	48 89 e5             	mov    %rsp,%rbp
  8039d0:	48 83 ec 10          	sub    $0x10,%rsp
  8039d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8039d7:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039de:	00 00 00 
  8039e1:	8b 00                	mov    (%rax),%eax
  8039e3:	85 c0                	test   %eax,%eax
  8039e5:	75 1d                	jne    803a04 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8039e7:	bf 02 00 00 00       	mov    $0x2,%edi
  8039ec:	48 b8 fc 47 80 00 00 	movabs $0x8047fc,%rax
  8039f3:	00 00 00 
  8039f6:	ff d0                	callq  *%rax
  8039f8:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  8039ff:	00 00 00 
  803a02:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a04:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a0b:	00 00 00 
  803a0e:	8b 00                	mov    (%rax),%eax
  803a10:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a13:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a18:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803a1f:	00 00 00 
  803a22:	89 c7                	mov    %eax,%edi
  803a24:	48 b8 9a 47 80 00 00 	movabs $0x80479a,%rax
  803a2b:	00 00 00 
  803a2e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803a30:	ba 00 00 00 00       	mov    $0x0,%edx
  803a35:	be 00 00 00 00       	mov    $0x0,%esi
  803a3a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a3f:	48 b8 94 46 80 00 00 	movabs $0x804694,%rax
  803a46:	00 00 00 
  803a49:	ff d0                	callq  *%rax
}
  803a4b:	c9                   	leaveq 
  803a4c:	c3                   	retq   

0000000000803a4d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a4d:	55                   	push   %rbp
  803a4e:	48 89 e5             	mov    %rsp,%rbp
  803a51:	48 83 ec 30          	sub    $0x30,%rsp
  803a55:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a5c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803a60:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a67:	00 00 00 
  803a6a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a6d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a6f:	bf 01 00 00 00       	mov    $0x1,%edi
  803a74:	48 b8 cc 39 80 00 00 	movabs $0x8039cc,%rax
  803a7b:	00 00 00 
  803a7e:	ff d0                	callq  *%rax
  803a80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a87:	78 3e                	js     803ac7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803a89:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a90:	00 00 00 
  803a93:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803a97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a9b:	8b 40 10             	mov    0x10(%rax),%eax
  803a9e:	89 c2                	mov    %eax,%edx
  803aa0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803aa4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aa8:	48 89 ce             	mov    %rcx,%rsi
  803aab:	48 89 c7             	mov    %rax,%rdi
  803aae:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  803ab5:	00 00 00 
  803ab8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803aba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abe:	8b 50 10             	mov    0x10(%rax),%edx
  803ac1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803ac7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803aca:	c9                   	leaveq 
  803acb:	c3                   	retq   

0000000000803acc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803acc:	55                   	push   %rbp
  803acd:	48 89 e5             	mov    %rsp,%rbp
  803ad0:	48 83 ec 10          	sub    $0x10,%rsp
  803ad4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ad7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803adb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803ade:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ae5:	00 00 00 
  803ae8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803aeb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803aed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803af0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af4:	48 89 c6             	mov    %rax,%rsi
  803af7:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803afe:	00 00 00 
  803b01:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  803b08:	00 00 00 
  803b0b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b0d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b14:	00 00 00 
  803b17:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b1a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803b1d:	bf 02 00 00 00       	mov    $0x2,%edi
  803b22:	48 b8 cc 39 80 00 00 	movabs $0x8039cc,%rax
  803b29:	00 00 00 
  803b2c:	ff d0                	callq  *%rax
}
  803b2e:	c9                   	leaveq 
  803b2f:	c3                   	retq   

0000000000803b30 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803b30:	55                   	push   %rbp
  803b31:	48 89 e5             	mov    %rsp,%rbp
  803b34:	48 83 ec 10          	sub    $0x10,%rsp
  803b38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b3b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803b3e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b45:	00 00 00 
  803b48:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b4b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803b4d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b54:	00 00 00 
  803b57:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b5a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803b5d:	bf 03 00 00 00       	mov    $0x3,%edi
  803b62:	48 b8 cc 39 80 00 00 	movabs $0x8039cc,%rax
  803b69:	00 00 00 
  803b6c:	ff d0                	callq  *%rax
}
  803b6e:	c9                   	leaveq 
  803b6f:	c3                   	retq   

0000000000803b70 <nsipc_close>:

int
nsipc_close(int s)
{
  803b70:	55                   	push   %rbp
  803b71:	48 89 e5             	mov    %rsp,%rbp
  803b74:	48 83 ec 10          	sub    $0x10,%rsp
  803b78:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803b7b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b82:	00 00 00 
  803b85:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b88:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803b8a:	bf 04 00 00 00       	mov    $0x4,%edi
  803b8f:	48 b8 cc 39 80 00 00 	movabs $0x8039cc,%rax
  803b96:	00 00 00 
  803b99:	ff d0                	callq  *%rax
}
  803b9b:	c9                   	leaveq 
  803b9c:	c3                   	retq   

0000000000803b9d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b9d:	55                   	push   %rbp
  803b9e:	48 89 e5             	mov    %rsp,%rbp
  803ba1:	48 83 ec 10          	sub    $0x10,%rsp
  803ba5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ba8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bac:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803baf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bb6:	00 00 00 
  803bb9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bbc:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803bbe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc5:	48 89 c6             	mov    %rax,%rsi
  803bc8:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803bcf:	00 00 00 
  803bd2:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  803bd9:	00 00 00 
  803bdc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803bde:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803be5:	00 00 00 
  803be8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803beb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803bee:	bf 05 00 00 00       	mov    $0x5,%edi
  803bf3:	48 b8 cc 39 80 00 00 	movabs $0x8039cc,%rax
  803bfa:	00 00 00 
  803bfd:	ff d0                	callq  *%rax
}
  803bff:	c9                   	leaveq 
  803c00:	c3                   	retq   

0000000000803c01 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803c01:	55                   	push   %rbp
  803c02:	48 89 e5             	mov    %rsp,%rbp
  803c05:	48 83 ec 10          	sub    $0x10,%rsp
  803c09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c0c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c0f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c16:	00 00 00 
  803c19:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c1c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803c1e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c25:	00 00 00 
  803c28:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c2b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803c2e:	bf 06 00 00 00       	mov    $0x6,%edi
  803c33:	48 b8 cc 39 80 00 00 	movabs $0x8039cc,%rax
  803c3a:	00 00 00 
  803c3d:	ff d0                	callq  *%rax
}
  803c3f:	c9                   	leaveq 
  803c40:	c3                   	retq   

0000000000803c41 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803c41:	55                   	push   %rbp
  803c42:	48 89 e5             	mov    %rsp,%rbp
  803c45:	48 83 ec 30          	sub    $0x30,%rsp
  803c49:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c50:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803c53:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803c56:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c5d:	00 00 00 
  803c60:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c63:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803c65:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c6c:	00 00 00 
  803c6f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c72:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803c75:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7c:	00 00 00 
  803c7f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c82:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803c85:	bf 07 00 00 00       	mov    $0x7,%edi
  803c8a:	48 b8 cc 39 80 00 00 	movabs $0x8039cc,%rax
  803c91:	00 00 00 
  803c94:	ff d0                	callq  *%rax
  803c96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9d:	78 69                	js     803d08 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803c9f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803ca6:	7f 08                	jg     803cb0 <nsipc_recv+0x6f>
  803ca8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cab:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803cae:	7e 35                	jle    803ce5 <nsipc_recv+0xa4>
  803cb0:	48 b9 f7 4f 80 00 00 	movabs $0x804ff7,%rcx
  803cb7:	00 00 00 
  803cba:	48 ba 0c 50 80 00 00 	movabs $0x80500c,%rdx
  803cc1:	00 00 00 
  803cc4:	be 61 00 00 00       	mov    $0x61,%esi
  803cc9:	48 bf 21 50 80 00 00 	movabs $0x805021,%rdi
  803cd0:	00 00 00 
  803cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd8:	49 b8 c9 05 80 00 00 	movabs $0x8005c9,%r8
  803cdf:	00 00 00 
  803ce2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce8:	48 63 d0             	movslq %eax,%rdx
  803ceb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cef:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803cf6:	00 00 00 
  803cf9:	48 89 c7             	mov    %rax,%rdi
  803cfc:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  803d03:	00 00 00 
  803d06:	ff d0                	callq  *%rax
	}

	return r;
  803d08:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d0b:	c9                   	leaveq 
  803d0c:	c3                   	retq   

0000000000803d0d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d0d:	55                   	push   %rbp
  803d0e:	48 89 e5             	mov    %rsp,%rbp
  803d11:	48 83 ec 20          	sub    $0x20,%rsp
  803d15:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d1c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803d1f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803d22:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d29:	00 00 00 
  803d2c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d2f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803d31:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803d38:	7e 35                	jle    803d6f <nsipc_send+0x62>
  803d3a:	48 b9 2d 50 80 00 00 	movabs $0x80502d,%rcx
  803d41:	00 00 00 
  803d44:	48 ba 0c 50 80 00 00 	movabs $0x80500c,%rdx
  803d4b:	00 00 00 
  803d4e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803d53:	48 bf 21 50 80 00 00 	movabs $0x805021,%rdi
  803d5a:	00 00 00 
  803d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d62:	49 b8 c9 05 80 00 00 	movabs $0x8005c9,%r8
  803d69:	00 00 00 
  803d6c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803d6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d72:	48 63 d0             	movslq %eax,%rdx
  803d75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d79:	48 89 c6             	mov    %rax,%rsi
  803d7c:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803d83:	00 00 00 
  803d86:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  803d8d:	00 00 00 
  803d90:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803d92:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d99:	00 00 00 
  803d9c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d9f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803da2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803da9:	00 00 00 
  803dac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803daf:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803db2:	bf 08 00 00 00       	mov    $0x8,%edi
  803db7:	48 b8 cc 39 80 00 00 	movabs $0x8039cc,%rax
  803dbe:	00 00 00 
  803dc1:	ff d0                	callq  *%rax
}
  803dc3:	c9                   	leaveq 
  803dc4:	c3                   	retq   

0000000000803dc5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803dc5:	55                   	push   %rbp
  803dc6:	48 89 e5             	mov    %rsp,%rbp
  803dc9:	48 83 ec 10          	sub    $0x10,%rsp
  803dcd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803dd0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803dd3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803dd6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ddd:	00 00 00 
  803de0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803de3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803de5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dec:	00 00 00 
  803def:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803df2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803df5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dfc:	00 00 00 
  803dff:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e02:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e05:	bf 09 00 00 00       	mov    $0x9,%edi
  803e0a:	48 b8 cc 39 80 00 00 	movabs $0x8039cc,%rax
  803e11:	00 00 00 
  803e14:	ff d0                	callq  *%rax
}
  803e16:	c9                   	leaveq 
  803e17:	c3                   	retq   

0000000000803e18 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e18:	55                   	push   %rbp
  803e19:	48 89 e5             	mov    %rsp,%rbp
  803e1c:	53                   	push   %rbx
  803e1d:	48 83 ec 38          	sub    $0x38,%rsp
  803e21:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e25:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e29:	48 89 c7             	mov    %rax,%rdi
  803e2c:	48 b8 52 23 80 00 00 	movabs $0x802352,%rax
  803e33:	00 00 00 
  803e36:	ff d0                	callq  *%rax
  803e38:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e3f:	0f 88 bf 01 00 00    	js     804004 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e49:	ba 07 04 00 00       	mov    $0x407,%edx
  803e4e:	48 89 c6             	mov    %rax,%rsi
  803e51:	bf 00 00 00 00       	mov    $0x0,%edi
  803e56:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  803e5d:	00 00 00 
  803e60:	ff d0                	callq  *%rax
  803e62:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e65:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e69:	0f 88 95 01 00 00    	js     804004 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e6f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e73:	48 89 c7             	mov    %rax,%rdi
  803e76:	48 b8 52 23 80 00 00 	movabs $0x802352,%rax
  803e7d:	00 00 00 
  803e80:	ff d0                	callq  *%rax
  803e82:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e89:	0f 88 5d 01 00 00    	js     803fec <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e93:	ba 07 04 00 00       	mov    $0x407,%edx
  803e98:	48 89 c6             	mov    %rax,%rsi
  803e9b:	bf 00 00 00 00       	mov    $0x0,%edi
  803ea0:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  803ea7:	00 00 00 
  803eaa:	ff d0                	callq  *%rax
  803eac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803eaf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eb3:	0f 88 33 01 00 00    	js     803fec <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803eb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ebd:	48 89 c7             	mov    %rax,%rdi
  803ec0:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  803ec7:	00 00 00 
  803eca:	ff d0                	callq  *%rax
  803ecc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ed0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ed4:	ba 07 04 00 00       	mov    $0x407,%edx
  803ed9:	48 89 c6             	mov    %rax,%rsi
  803edc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ee1:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  803ee8:	00 00 00 
  803eeb:	ff d0                	callq  *%rax
  803eed:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ef0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ef4:	79 05                	jns    803efb <pipe+0xe3>
		goto err2;
  803ef6:	e9 d9 00 00 00       	jmpq   803fd4 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803efb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eff:	48 89 c7             	mov    %rax,%rdi
  803f02:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  803f09:	00 00 00 
  803f0c:	ff d0                	callq  *%rax
  803f0e:	48 89 c2             	mov    %rax,%rdx
  803f11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f15:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f1b:	48 89 d1             	mov    %rdx,%rcx
  803f1e:	ba 00 00 00 00       	mov    $0x0,%edx
  803f23:	48 89 c6             	mov    %rax,%rsi
  803f26:	bf 00 00 00 00       	mov    $0x0,%edi
  803f2b:	48 b8 36 1d 80 00 00 	movabs $0x801d36,%rax
  803f32:	00 00 00 
  803f35:	ff d0                	callq  *%rax
  803f37:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f3e:	79 1b                	jns    803f5b <pipe+0x143>
		goto err3;
  803f40:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803f41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f45:	48 89 c6             	mov    %rax,%rsi
  803f48:	bf 00 00 00 00       	mov    $0x0,%edi
  803f4d:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  803f54:	00 00 00 
  803f57:	ff d0                	callq  *%rax
  803f59:	eb 79                	jmp    803fd4 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f5f:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f66:	00 00 00 
  803f69:	8b 12                	mov    (%rdx),%edx
  803f6b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f7c:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f83:	00 00 00 
  803f86:	8b 12                	mov    (%rdx),%edx
  803f88:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f8a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f8e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f99:	48 89 c7             	mov    %rax,%rdi
  803f9c:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  803fa3:	00 00 00 
  803fa6:	ff d0                	callq  *%rax
  803fa8:	89 c2                	mov    %eax,%edx
  803faa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fae:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803fb0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803fb4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803fb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fbc:	48 89 c7             	mov    %rax,%rdi
  803fbf:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  803fc6:	00 00 00 
  803fc9:	ff d0                	callq  *%rax
  803fcb:	89 03                	mov    %eax,(%rbx)
	return 0;
  803fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803fd2:	eb 33                	jmp    804007 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803fd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd8:	48 89 c6             	mov    %rax,%rsi
  803fdb:	bf 00 00 00 00       	mov    $0x0,%edi
  803fe0:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  803fe7:	00 00 00 
  803fea:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803fec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff0:	48 89 c6             	mov    %rax,%rsi
  803ff3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ff8:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  803fff:	00 00 00 
  804002:	ff d0                	callq  *%rax
err:
	return r;
  804004:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804007:	48 83 c4 38          	add    $0x38,%rsp
  80400b:	5b                   	pop    %rbx
  80400c:	5d                   	pop    %rbp
  80400d:	c3                   	retq   

000000000080400e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80400e:	55                   	push   %rbp
  80400f:	48 89 e5             	mov    %rsp,%rbp
  804012:	53                   	push   %rbx
  804013:	48 83 ec 28          	sub    $0x28,%rsp
  804017:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80401b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80401f:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804026:	00 00 00 
  804029:	48 8b 00             	mov    (%rax),%rax
  80402c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804032:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804035:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804039:	48 89 c7             	mov    %rax,%rdi
  80403c:	48 b8 7e 48 80 00 00 	movabs $0x80487e,%rax
  804043:	00 00 00 
  804046:	ff d0                	callq  *%rax
  804048:	89 c3                	mov    %eax,%ebx
  80404a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80404e:	48 89 c7             	mov    %rax,%rdi
  804051:	48 b8 7e 48 80 00 00 	movabs $0x80487e,%rax
  804058:	00 00 00 
  80405b:	ff d0                	callq  *%rax
  80405d:	39 c3                	cmp    %eax,%ebx
  80405f:	0f 94 c0             	sete   %al
  804062:	0f b6 c0             	movzbl %al,%eax
  804065:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804068:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80406f:	00 00 00 
  804072:	48 8b 00             	mov    (%rax),%rax
  804075:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80407b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80407e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804081:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804084:	75 05                	jne    80408b <_pipeisclosed+0x7d>
			return ret;
  804086:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804089:	eb 4f                	jmp    8040da <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80408b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80408e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804091:	74 42                	je     8040d5 <_pipeisclosed+0xc7>
  804093:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804097:	75 3c                	jne    8040d5 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804099:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8040a0:	00 00 00 
  8040a3:	48 8b 00             	mov    (%rax),%rax
  8040a6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8040ac:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8040af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040b2:	89 c6                	mov    %eax,%esi
  8040b4:	48 bf 3e 50 80 00 00 	movabs $0x80503e,%rdi
  8040bb:	00 00 00 
  8040be:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c3:	49 b8 02 08 80 00 00 	movabs $0x800802,%r8
  8040ca:	00 00 00 
  8040cd:	41 ff d0             	callq  *%r8
	}
  8040d0:	e9 4a ff ff ff       	jmpq   80401f <_pipeisclosed+0x11>
  8040d5:	e9 45 ff ff ff       	jmpq   80401f <_pipeisclosed+0x11>
}
  8040da:	48 83 c4 28          	add    $0x28,%rsp
  8040de:	5b                   	pop    %rbx
  8040df:	5d                   	pop    %rbp
  8040e0:	c3                   	retq   

00000000008040e1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8040e1:	55                   	push   %rbp
  8040e2:	48 89 e5             	mov    %rsp,%rbp
  8040e5:	48 83 ec 30          	sub    $0x30,%rsp
  8040e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040ec:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8040f0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040f3:	48 89 d6             	mov    %rdx,%rsi
  8040f6:	89 c7                	mov    %eax,%edi
  8040f8:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  8040ff:	00 00 00 
  804102:	ff d0                	callq  *%rax
  804104:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804107:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80410b:	79 05                	jns    804112 <pipeisclosed+0x31>
		return r;
  80410d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804110:	eb 31                	jmp    804143 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804112:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804116:	48 89 c7             	mov    %rax,%rdi
  804119:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  804120:	00 00 00 
  804123:	ff d0                	callq  *%rax
  804125:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804129:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80412d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804131:	48 89 d6             	mov    %rdx,%rsi
  804134:	48 89 c7             	mov    %rax,%rdi
  804137:	48 b8 0e 40 80 00 00 	movabs $0x80400e,%rax
  80413e:	00 00 00 
  804141:	ff d0                	callq  *%rax
}
  804143:	c9                   	leaveq 
  804144:	c3                   	retq   

0000000000804145 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804145:	55                   	push   %rbp
  804146:	48 89 e5             	mov    %rsp,%rbp
  804149:	48 83 ec 40          	sub    $0x40,%rsp
  80414d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804151:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804155:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804159:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80415d:	48 89 c7             	mov    %rax,%rdi
  804160:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  804167:	00 00 00 
  80416a:	ff d0                	callq  *%rax
  80416c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804170:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804174:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804178:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80417f:	00 
  804180:	e9 92 00 00 00       	jmpq   804217 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804185:	eb 41                	jmp    8041c8 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804187:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80418c:	74 09                	je     804197 <devpipe_read+0x52>
				return i;
  80418e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804192:	e9 92 00 00 00       	jmpq   804229 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804197:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80419b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80419f:	48 89 d6             	mov    %rdx,%rsi
  8041a2:	48 89 c7             	mov    %rax,%rdi
  8041a5:	48 b8 0e 40 80 00 00 	movabs $0x80400e,%rax
  8041ac:	00 00 00 
  8041af:	ff d0                	callq  *%rax
  8041b1:	85 c0                	test   %eax,%eax
  8041b3:	74 07                	je     8041bc <devpipe_read+0x77>
				return 0;
  8041b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8041ba:	eb 6d                	jmp    804229 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8041bc:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  8041c3:	00 00 00 
  8041c6:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8041c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041cc:	8b 10                	mov    (%rax),%edx
  8041ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d2:	8b 40 04             	mov    0x4(%rax),%eax
  8041d5:	39 c2                	cmp    %eax,%edx
  8041d7:	74 ae                	je     804187 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8041d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041e1:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8041e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e9:	8b 00                	mov    (%rax),%eax
  8041eb:	99                   	cltd   
  8041ec:	c1 ea 1b             	shr    $0x1b,%edx
  8041ef:	01 d0                	add    %edx,%eax
  8041f1:	83 e0 1f             	and    $0x1f,%eax
  8041f4:	29 d0                	sub    %edx,%eax
  8041f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041fa:	48 98                	cltq   
  8041fc:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804201:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804207:	8b 00                	mov    (%rax),%eax
  804209:	8d 50 01             	lea    0x1(%rax),%edx
  80420c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804210:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804212:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80421b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80421f:	0f 82 60 ff ff ff    	jb     804185 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804225:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804229:	c9                   	leaveq 
  80422a:	c3                   	retq   

000000000080422b <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80422b:	55                   	push   %rbp
  80422c:	48 89 e5             	mov    %rsp,%rbp
  80422f:	48 83 ec 40          	sub    $0x40,%rsp
  804233:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804237:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80423b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80423f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804243:	48 89 c7             	mov    %rax,%rdi
  804246:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  80424d:	00 00 00 
  804250:	ff d0                	callq  *%rax
  804252:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804256:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80425a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80425e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804265:	00 
  804266:	e9 8e 00 00 00       	jmpq   8042f9 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80426b:	eb 31                	jmp    80429e <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80426d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804271:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804275:	48 89 d6             	mov    %rdx,%rsi
  804278:	48 89 c7             	mov    %rax,%rdi
  80427b:	48 b8 0e 40 80 00 00 	movabs $0x80400e,%rax
  804282:	00 00 00 
  804285:	ff d0                	callq  *%rax
  804287:	85 c0                	test   %eax,%eax
  804289:	74 07                	je     804292 <devpipe_write+0x67>
				return 0;
  80428b:	b8 00 00 00 00       	mov    $0x0,%eax
  804290:	eb 79                	jmp    80430b <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804292:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  804299:	00 00 00 
  80429c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80429e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042a2:	8b 40 04             	mov    0x4(%rax),%eax
  8042a5:	48 63 d0             	movslq %eax,%rdx
  8042a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ac:	8b 00                	mov    (%rax),%eax
  8042ae:	48 98                	cltq   
  8042b0:	48 83 c0 20          	add    $0x20,%rax
  8042b4:	48 39 c2             	cmp    %rax,%rdx
  8042b7:	73 b4                	jae    80426d <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8042b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042bd:	8b 40 04             	mov    0x4(%rax),%eax
  8042c0:	99                   	cltd   
  8042c1:	c1 ea 1b             	shr    $0x1b,%edx
  8042c4:	01 d0                	add    %edx,%eax
  8042c6:	83 e0 1f             	and    $0x1f,%eax
  8042c9:	29 d0                	sub    %edx,%eax
  8042cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8042cf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8042d3:	48 01 ca             	add    %rcx,%rdx
  8042d6:	0f b6 0a             	movzbl (%rdx),%ecx
  8042d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042dd:	48 98                	cltq   
  8042df:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8042e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e7:	8b 40 04             	mov    0x4(%rax),%eax
  8042ea:	8d 50 01             	lea    0x1(%rax),%edx
  8042ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8042f4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042fd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804301:	0f 82 64 ff ff ff    	jb     80426b <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80430b:	c9                   	leaveq 
  80430c:	c3                   	retq   

000000000080430d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80430d:	55                   	push   %rbp
  80430e:	48 89 e5             	mov    %rsp,%rbp
  804311:	48 83 ec 20          	sub    $0x20,%rsp
  804315:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804319:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80431d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804321:	48 89 c7             	mov    %rax,%rdi
  804324:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  80432b:	00 00 00 
  80432e:	ff d0                	callq  *%rax
  804330:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804334:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804338:	48 be 51 50 80 00 00 	movabs $0x805051,%rsi
  80433f:	00 00 00 
  804342:	48 89 c7             	mov    %rax,%rdi
  804345:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  80434c:	00 00 00 
  80434f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804351:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804355:	8b 50 04             	mov    0x4(%rax),%edx
  804358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80435c:	8b 00                	mov    (%rax),%eax
  80435e:	29 c2                	sub    %eax,%edx
  804360:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804364:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80436a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80436e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804375:	00 00 00 
	stat->st_dev = &devpipe;
  804378:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80437c:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804383:	00 00 00 
  804386:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80438d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804392:	c9                   	leaveq 
  804393:	c3                   	retq   

0000000000804394 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804394:	55                   	push   %rbp
  804395:	48 89 e5             	mov    %rsp,%rbp
  804398:	48 83 ec 10          	sub    $0x10,%rsp
  80439c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8043a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043a4:	48 89 c6             	mov    %rax,%rsi
  8043a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ac:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  8043b3:	00 00 00 
  8043b6:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8043b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043bc:	48 89 c7             	mov    %rax,%rdi
  8043bf:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  8043c6:	00 00 00 
  8043c9:	ff d0                	callq  *%rax
  8043cb:	48 89 c6             	mov    %rax,%rsi
  8043ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8043d3:	48 b8 91 1d 80 00 00 	movabs $0x801d91,%rax
  8043da:	00 00 00 
  8043dd:	ff d0                	callq  *%rax
}
  8043df:	c9                   	leaveq 
  8043e0:	c3                   	retq   

00000000008043e1 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8043e1:	55                   	push   %rbp
  8043e2:	48 89 e5             	mov    %rsp,%rbp
  8043e5:	48 83 ec 20          	sub    $0x20,%rsp
  8043e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8043ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043ef:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8043f2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8043f6:	be 01 00 00 00       	mov    $0x1,%esi
  8043fb:	48 89 c7             	mov    %rax,%rdi
  8043fe:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  804405:	00 00 00 
  804408:	ff d0                	callq  *%rax
}
  80440a:	c9                   	leaveq 
  80440b:	c3                   	retq   

000000000080440c <getchar>:

int
getchar(void)
{
  80440c:	55                   	push   %rbp
  80440d:	48 89 e5             	mov    %rsp,%rbp
  804410:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804414:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804418:	ba 01 00 00 00       	mov    $0x1,%edx
  80441d:	48 89 c6             	mov    %rax,%rsi
  804420:	bf 00 00 00 00       	mov    $0x0,%edi
  804425:	48 b8 1c 28 80 00 00 	movabs $0x80281c,%rax
  80442c:	00 00 00 
  80442f:	ff d0                	callq  *%rax
  804431:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804434:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804438:	79 05                	jns    80443f <getchar+0x33>
		return r;
  80443a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80443d:	eb 14                	jmp    804453 <getchar+0x47>
	if (r < 1)
  80443f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804443:	7f 07                	jg     80444c <getchar+0x40>
		return -E_EOF;
  804445:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80444a:	eb 07                	jmp    804453 <getchar+0x47>
	return c;
  80444c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804450:	0f b6 c0             	movzbl %al,%eax
}
  804453:	c9                   	leaveq 
  804454:	c3                   	retq   

0000000000804455 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804455:	55                   	push   %rbp
  804456:	48 89 e5             	mov    %rsp,%rbp
  804459:	48 83 ec 20          	sub    $0x20,%rsp
  80445d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804460:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804464:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804467:	48 89 d6             	mov    %rdx,%rsi
  80446a:	89 c7                	mov    %eax,%edi
  80446c:	48 b8 ea 23 80 00 00 	movabs $0x8023ea,%rax
  804473:	00 00 00 
  804476:	ff d0                	callq  *%rax
  804478:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80447b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80447f:	79 05                	jns    804486 <iscons+0x31>
		return r;
  804481:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804484:	eb 1a                	jmp    8044a0 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804486:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80448a:	8b 10                	mov    (%rax),%edx
  80448c:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804493:	00 00 00 
  804496:	8b 00                	mov    (%rax),%eax
  804498:	39 c2                	cmp    %eax,%edx
  80449a:	0f 94 c0             	sete   %al
  80449d:	0f b6 c0             	movzbl %al,%eax
}
  8044a0:	c9                   	leaveq 
  8044a1:	c3                   	retq   

00000000008044a2 <opencons>:

int
opencons(void)
{
  8044a2:	55                   	push   %rbp
  8044a3:	48 89 e5             	mov    %rsp,%rbp
  8044a6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8044aa:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8044ae:	48 89 c7             	mov    %rax,%rdi
  8044b1:	48 b8 52 23 80 00 00 	movabs $0x802352,%rax
  8044b8:	00 00 00 
  8044bb:	ff d0                	callq  *%rax
  8044bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044c4:	79 05                	jns    8044cb <opencons+0x29>
		return r;
  8044c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044c9:	eb 5b                	jmp    804526 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8044cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044cf:	ba 07 04 00 00       	mov    $0x407,%edx
  8044d4:	48 89 c6             	mov    %rax,%rsi
  8044d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8044dc:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  8044e3:	00 00 00 
  8044e6:	ff d0                	callq  *%rax
  8044e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ef:	79 05                	jns    8044f6 <opencons+0x54>
		return r;
  8044f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044f4:	eb 30                	jmp    804526 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8044f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044fa:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804501:	00 00 00 
  804504:	8b 12                	mov    (%rdx),%edx
  804506:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80450c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804517:	48 89 c7             	mov    %rax,%rdi
  80451a:	48 b8 04 23 80 00 00 	movabs $0x802304,%rax
  804521:	00 00 00 
  804524:	ff d0                	callq  *%rax
}
  804526:	c9                   	leaveq 
  804527:	c3                   	retq   

0000000000804528 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804528:	55                   	push   %rbp
  804529:	48 89 e5             	mov    %rsp,%rbp
  80452c:	48 83 ec 30          	sub    $0x30,%rsp
  804530:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804534:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804538:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80453c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804541:	75 07                	jne    80454a <devcons_read+0x22>
		return 0;
  804543:	b8 00 00 00 00       	mov    $0x0,%eax
  804548:	eb 4b                	jmp    804595 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80454a:	eb 0c                	jmp    804558 <devcons_read+0x30>
		sys_yield();
  80454c:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  804553:	00 00 00 
  804556:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804558:	48 b8 e8 1b 80 00 00 	movabs $0x801be8,%rax
  80455f:	00 00 00 
  804562:	ff d0                	callq  *%rax
  804564:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804567:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80456b:	74 df                	je     80454c <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80456d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804571:	79 05                	jns    804578 <devcons_read+0x50>
		return c;
  804573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804576:	eb 1d                	jmp    804595 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804578:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80457c:	75 07                	jne    804585 <devcons_read+0x5d>
		return 0;
  80457e:	b8 00 00 00 00       	mov    $0x0,%eax
  804583:	eb 10                	jmp    804595 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804585:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804588:	89 c2                	mov    %eax,%edx
  80458a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80458e:	88 10                	mov    %dl,(%rax)
	return 1;
  804590:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804595:	c9                   	leaveq 
  804596:	c3                   	retq   

0000000000804597 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804597:	55                   	push   %rbp
  804598:	48 89 e5             	mov    %rsp,%rbp
  80459b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8045a2:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8045a9:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8045b0:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045be:	eb 76                	jmp    804636 <devcons_write+0x9f>
		m = n - tot;
  8045c0:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8045c7:	89 c2                	mov    %eax,%edx
  8045c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045cc:	29 c2                	sub    %eax,%edx
  8045ce:	89 d0                	mov    %edx,%eax
  8045d0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8045d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045d6:	83 f8 7f             	cmp    $0x7f,%eax
  8045d9:	76 07                	jbe    8045e2 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8045db:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8045e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045e5:	48 63 d0             	movslq %eax,%rdx
  8045e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045eb:	48 63 c8             	movslq %eax,%rcx
  8045ee:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8045f5:	48 01 c1             	add    %rax,%rcx
  8045f8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045ff:	48 89 ce             	mov    %rcx,%rsi
  804602:	48 89 c7             	mov    %rax,%rdi
  804605:	48 b8 db 16 80 00 00 	movabs $0x8016db,%rax
  80460c:	00 00 00 
  80460f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804611:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804614:	48 63 d0             	movslq %eax,%rdx
  804617:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80461e:	48 89 d6             	mov    %rdx,%rsi
  804621:	48 89 c7             	mov    %rax,%rdi
  804624:	48 b8 9e 1b 80 00 00 	movabs $0x801b9e,%rax
  80462b:	00 00 00 
  80462e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804630:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804633:	01 45 fc             	add    %eax,-0x4(%rbp)
  804636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804639:	48 98                	cltq   
  80463b:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804642:	0f 82 78 ff ff ff    	jb     8045c0 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804648:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80464b:	c9                   	leaveq 
  80464c:	c3                   	retq   

000000000080464d <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80464d:	55                   	push   %rbp
  80464e:	48 89 e5             	mov    %rsp,%rbp
  804651:	48 83 ec 08          	sub    $0x8,%rsp
  804655:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804659:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80465e:	c9                   	leaveq 
  80465f:	c3                   	retq   

0000000000804660 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804660:	55                   	push   %rbp
  804661:	48 89 e5             	mov    %rsp,%rbp
  804664:	48 83 ec 10          	sub    $0x10,%rsp
  804668:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80466c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804670:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804674:	48 be 5d 50 80 00 00 	movabs $0x80505d,%rsi
  80467b:	00 00 00 
  80467e:	48 89 c7             	mov    %rax,%rdi
  804681:	48 b8 b7 13 80 00 00 	movabs $0x8013b7,%rax
  804688:	00 00 00 
  80468b:	ff d0                	callq  *%rax
	return 0;
  80468d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804692:	c9                   	leaveq 
  804693:	c3                   	retq   

0000000000804694 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804694:	55                   	push   %rbp
  804695:	48 89 e5             	mov    %rsp,%rbp
  804698:	48 83 ec 30          	sub    $0x30,%rsp
  80469c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046a4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8046a8:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8046af:	00 00 00 
  8046b2:	48 8b 00             	mov    (%rax),%rax
  8046b5:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8046bb:	85 c0                	test   %eax,%eax
  8046bd:	75 3c                	jne    8046fb <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8046bf:	48 b8 6a 1c 80 00 00 	movabs $0x801c6a,%rax
  8046c6:	00 00 00 
  8046c9:	ff d0                	callq  *%rax
  8046cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8046d0:	48 63 d0             	movslq %eax,%rdx
  8046d3:	48 89 d0             	mov    %rdx,%rax
  8046d6:	48 c1 e0 03          	shl    $0x3,%rax
  8046da:	48 01 d0             	add    %rdx,%rax
  8046dd:	48 c1 e0 05          	shl    $0x5,%rax
  8046e1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8046e8:	00 00 00 
  8046eb:	48 01 c2             	add    %rax,%rdx
  8046ee:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8046f5:	00 00 00 
  8046f8:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8046fb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804700:	75 0e                	jne    804710 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804702:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804709:	00 00 00 
  80470c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804710:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804714:	48 89 c7             	mov    %rax,%rdi
  804717:	48 b8 0f 1f 80 00 00 	movabs $0x801f0f,%rax
  80471e:	00 00 00 
  804721:	ff d0                	callq  *%rax
  804723:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804726:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80472a:	79 19                	jns    804745 <ipc_recv+0xb1>
		*from_env_store = 0;
  80472c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804730:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804736:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80473a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804740:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804743:	eb 53                	jmp    804798 <ipc_recv+0x104>
	}
	if(from_env_store)
  804745:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80474a:	74 19                	je     804765 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80474c:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804753:	00 00 00 
  804756:	48 8b 00             	mov    (%rax),%rax
  804759:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80475f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804763:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804765:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80476a:	74 19                	je     804785 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80476c:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804773:	00 00 00 
  804776:	48 8b 00             	mov    (%rax),%rax
  804779:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80477f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804783:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804785:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80478c:	00 00 00 
  80478f:	48 8b 00             	mov    (%rax),%rax
  804792:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  804798:	c9                   	leaveq 
  804799:	c3                   	retq   

000000000080479a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80479a:	55                   	push   %rbp
  80479b:	48 89 e5             	mov    %rsp,%rbp
  80479e:	48 83 ec 30          	sub    $0x30,%rsp
  8047a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047a5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8047a8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8047ac:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8047af:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047b4:	75 0e                	jne    8047c4 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8047b6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8047bd:	00 00 00 
  8047c0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8047c4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8047c7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8047ca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8047ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8047d1:	89 c7                	mov    %eax,%edi
  8047d3:	48 b8 ba 1e 80 00 00 	movabs $0x801eba,%rax
  8047da:	00 00 00 
  8047dd:	ff d0                	callq  *%rax
  8047df:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8047e2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047e6:	75 0c                	jne    8047f4 <ipc_send+0x5a>
			sys_yield();
  8047e8:	48 b8 a8 1c 80 00 00 	movabs $0x801ca8,%rax
  8047ef:	00 00 00 
  8047f2:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8047f4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8047f8:	74 ca                	je     8047c4 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8047fa:	c9                   	leaveq 
  8047fb:	c3                   	retq   

00000000008047fc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8047fc:	55                   	push   %rbp
  8047fd:	48 89 e5             	mov    %rsp,%rbp
  804800:	48 83 ec 14          	sub    $0x14,%rsp
  804804:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804807:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80480e:	eb 5e                	jmp    80486e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804810:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804817:	00 00 00 
  80481a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80481d:	48 63 d0             	movslq %eax,%rdx
  804820:	48 89 d0             	mov    %rdx,%rax
  804823:	48 c1 e0 03          	shl    $0x3,%rax
  804827:	48 01 d0             	add    %rdx,%rax
  80482a:	48 c1 e0 05          	shl    $0x5,%rax
  80482e:	48 01 c8             	add    %rcx,%rax
  804831:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804837:	8b 00                	mov    (%rax),%eax
  804839:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80483c:	75 2c                	jne    80486a <ipc_find_env+0x6e>
			return envs[i].env_id;
  80483e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804845:	00 00 00 
  804848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80484b:	48 63 d0             	movslq %eax,%rdx
  80484e:	48 89 d0             	mov    %rdx,%rax
  804851:	48 c1 e0 03          	shl    $0x3,%rax
  804855:	48 01 d0             	add    %rdx,%rax
  804858:	48 c1 e0 05          	shl    $0x5,%rax
  80485c:	48 01 c8             	add    %rcx,%rax
  80485f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804865:	8b 40 08             	mov    0x8(%rax),%eax
  804868:	eb 12                	jmp    80487c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80486a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80486e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804875:	7e 99                	jle    804810 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804877:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80487c:	c9                   	leaveq 
  80487d:	c3                   	retq   

000000000080487e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80487e:	55                   	push   %rbp
  80487f:	48 89 e5             	mov    %rsp,%rbp
  804882:	48 83 ec 18          	sub    $0x18,%rsp
  804886:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80488a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80488e:	48 c1 e8 15          	shr    $0x15,%rax
  804892:	48 89 c2             	mov    %rax,%rdx
  804895:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80489c:	01 00 00 
  80489f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048a3:	83 e0 01             	and    $0x1,%eax
  8048a6:	48 85 c0             	test   %rax,%rax
  8048a9:	75 07                	jne    8048b2 <pageref+0x34>
		return 0;
  8048ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8048b0:	eb 53                	jmp    804905 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8048b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048b6:	48 c1 e8 0c          	shr    $0xc,%rax
  8048ba:	48 89 c2             	mov    %rax,%rdx
  8048bd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8048c4:	01 00 00 
  8048c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8048cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048d3:	83 e0 01             	and    $0x1,%eax
  8048d6:	48 85 c0             	test   %rax,%rax
  8048d9:	75 07                	jne    8048e2 <pageref+0x64>
		return 0;
  8048db:	b8 00 00 00 00       	mov    $0x0,%eax
  8048e0:	eb 23                	jmp    804905 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8048e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8048ea:	48 89 c2             	mov    %rax,%rdx
  8048ed:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8048f4:	00 00 00 
  8048f7:	48 c1 e2 04          	shl    $0x4,%rdx
  8048fb:	48 01 d0             	add    %rdx,%rax
  8048fe:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804902:	0f b7 c0             	movzwl %ax,%eax
}
  804905:	c9                   	leaveq 
  804906:	c3                   	retq   
