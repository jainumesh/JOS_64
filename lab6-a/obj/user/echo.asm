
obj/user/echo.debug:     file format elf64-x86-64


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
  80003c:	e8 11 01 00 00       	callq  800152 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, nflag;

	nflag = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80005d:	7e 38                	jle    800097 <umain+0x54>
  80005f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800063:	48 83 c0 08          	add    $0x8,%rax
  800067:	48 8b 00             	mov    (%rax),%rax
  80006a:	48 be 60 3f 80 00 00 	movabs $0x803f60,%rsi
  800071:	00 00 00 
  800074:	48 89 c7             	mov    %rax,%rdi
  800077:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
  800083:	85 c0                	test   %eax,%eax
  800085:	75 10                	jne    800097 <umain+0x54>
		nflag = 1;
  800087:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
		argc--;
  80008e:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
		argv++;
  800092:	48 83 45 e0 08       	addq   $0x8,-0x20(%rbp)
	}
	for (i = 1; i < argc; i++) {
  800097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80009e:	eb 7e                	jmp    80011e <umain+0xdb>
		if (i > 1)
  8000a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  8000a4:	7e 20                	jle    8000c6 <umain+0x83>
			write(1, " ", 1);
  8000a6:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ab:	48 be 63 3f 80 00 00 	movabs $0x803f63,%rsi
  8000b2:	00 00 00 
  8000b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ba:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
		write(1, argv[i], strlen(argv[i]));
  8000c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c9:	48 98                	cltq   
  8000cb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8000d2:	00 
  8000d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d7:	48 01 d0             	add    %rdx,%rax
  8000da:	48 8b 00             	mov    (%rax),%rax
  8000dd:	48 89 c7             	mov    %rax,%rdi
  8000e0:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
  8000ec:	48 63 d0             	movslq %eax,%rdx
  8000ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000f2:	48 98                	cltq   
  8000f4:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8000fb:	00 
  8000fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800100:	48 01 c8             	add    %rcx,%rax
  800103:	48 8b 00             	mov    (%rax),%rax
  800106:	48 89 c6             	mov    %rax,%rsi
  800109:	bf 01 00 00 00       	mov    $0x1,%edi
  80010e:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800121:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800124:	0f 8c 76 ff ff ff    	jl     8000a0 <umain+0x5d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  80012a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80012e:	75 20                	jne    800150 <umain+0x10d>
		write(1, "\n", 1);
  800130:	ba 01 00 00 00       	mov    $0x1,%edx
  800135:	48 be 65 3f 80 00 00 	movabs $0x803f65,%rsi
  80013c:	00 00 00 
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi
  800144:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
}
  800150:	c9                   	leaveq 
  800151:	c3                   	retq   

0000000000800152 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800152:	55                   	push   %rbp
  800153:	48 89 e5             	mov    %rsp,%rbp
  800156:	48 83 ec 10          	sub    $0x10,%rsp
  80015a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800161:	48 b8 1f 0b 80 00 00 	movabs $0x800b1f,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800172:	48 63 d0             	movslq %eax,%rdx
  800175:	48 89 d0             	mov    %rdx,%rax
  800178:	48 c1 e0 03          	shl    $0x3,%rax
  80017c:	48 01 d0             	add    %rdx,%rax
  80017f:	48 c1 e0 05          	shl    $0x5,%rax
  800183:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80018a:	00 00 00 
  80018d:	48 01 c2             	add    %rax,%rdx
  800190:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800197:	00 00 00 
  80019a:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a1:	7e 14                	jle    8001b7 <libmain+0x65>
		binaryname = argv[0];
  8001a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a7:	48 8b 10             	mov    (%rax),%rdx
  8001aa:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001b1:	00 00 00 
  8001b4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001be:	48 89 d6             	mov    %rdx,%rsi
  8001c1:	89 c7                	mov    %eax,%edi
  8001c3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8001cf:	48 b8 dd 01 80 00 00 	movabs $0x8001dd,%rax
  8001d6:	00 00 00 
  8001d9:	ff d0                	callq  *%rax
}
  8001db:	c9                   	leaveq 
  8001dc:	c3                   	retq   

00000000008001dd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001dd:	55                   	push   %rbp
  8001de:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001e1:	48 b8 15 12 80 00 00 	movabs $0x801215,%rax
  8001e8:	00 00 00 
  8001eb:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f2:	48 b8 db 0a 80 00 00 	movabs $0x800adb,%rax
  8001f9:	00 00 00 
  8001fc:	ff d0                	callq  *%rax

}
  8001fe:	5d                   	pop    %rbp
  8001ff:	c3                   	retq   

0000000000800200 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800200:	55                   	push   %rbp
  800201:	48 89 e5             	mov    %rsp,%rbp
  800204:	48 83 ec 18          	sub    $0x18,%rsp
  800208:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80020c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800213:	eb 09                	jmp    80021e <strlen+0x1e>
		n++;
  800215:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800219:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80021e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800222:	0f b6 00             	movzbl (%rax),%eax
  800225:	84 c0                	test   %al,%al
  800227:	75 ec                	jne    800215 <strlen+0x15>
		n++;
	return n;
  800229:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80022c:	c9                   	leaveq 
  80022d:	c3                   	retq   

000000000080022e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80022e:	55                   	push   %rbp
  80022f:	48 89 e5             	mov    %rsp,%rbp
  800232:	48 83 ec 20          	sub    $0x20,%rsp
  800236:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80023a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80023e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800245:	eb 0e                	jmp    800255 <strnlen+0x27>
		n++;
  800247:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80024b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800250:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800255:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80025a:	74 0b                	je     800267 <strnlen+0x39>
  80025c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800260:	0f b6 00             	movzbl (%rax),%eax
  800263:	84 c0                	test   %al,%al
  800265:	75 e0                	jne    800247 <strnlen+0x19>
		n++;
	return n;
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80026a:	c9                   	leaveq 
  80026b:	c3                   	retq   

000000000080026c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80026c:	55                   	push   %rbp
  80026d:	48 89 e5             	mov    %rsp,%rbp
  800270:	48 83 ec 20          	sub    $0x20,%rsp
  800274:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800278:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80027c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800280:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800284:	90                   	nop
  800285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800289:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80028d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800291:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800295:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800299:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80029d:	0f b6 12             	movzbl (%rdx),%edx
  8002a0:	88 10                	mov    %dl,(%rax)
  8002a2:	0f b6 00             	movzbl (%rax),%eax
  8002a5:	84 c0                	test   %al,%al
  8002a7:	75 dc                	jne    800285 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8002a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8002ad:	c9                   	leaveq 
  8002ae:	c3                   	retq   

00000000008002af <strcat>:

char *
strcat(char *dst, const char *src)
{
  8002af:	55                   	push   %rbp
  8002b0:	48 89 e5             	mov    %rsp,%rbp
  8002b3:	48 83 ec 20          	sub    $0x20,%rsp
  8002b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8002bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002c3:	48 89 c7             	mov    %rax,%rdi
  8002c6:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  8002cd:	00 00 00 
  8002d0:	ff d0                	callq  *%rax
  8002d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8002d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002d8:	48 63 d0             	movslq %eax,%rdx
  8002db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002df:	48 01 c2             	add    %rax,%rdx
  8002e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002e6:	48 89 c6             	mov    %rax,%rsi
  8002e9:	48 89 d7             	mov    %rdx,%rdi
  8002ec:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  8002f3:	00 00 00 
  8002f6:	ff d0                	callq  *%rax
	return dst;
  8002f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8002fc:	c9                   	leaveq 
  8002fd:	c3                   	retq   

00000000008002fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8002fe:	55                   	push   %rbp
  8002ff:	48 89 e5             	mov    %rsp,%rbp
  800302:	48 83 ec 28          	sub    $0x28,%rsp
  800306:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80030e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800316:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80031a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800321:	00 
  800322:	eb 2a                	jmp    80034e <strncpy+0x50>
		*dst++ = *src;
  800324:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800328:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80032c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800330:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800334:	0f b6 12             	movzbl (%rdx),%edx
  800337:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800339:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80033d:	0f b6 00             	movzbl (%rax),%eax
  800340:	84 c0                	test   %al,%al
  800342:	74 05                	je     800349 <strncpy+0x4b>
			src++;
  800344:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800349:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80034e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800352:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800356:	72 cc                	jb     800324 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80035c:	c9                   	leaveq 
  80035d:	c3                   	retq   

000000000080035e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80035e:	55                   	push   %rbp
  80035f:	48 89 e5             	mov    %rsp,%rbp
  800362:	48 83 ec 28          	sub    $0x28,%rsp
  800366:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80036a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80036e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800376:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80037a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80037f:	74 3d                	je     8003be <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800381:	eb 1d                	jmp    8003a0 <strlcpy+0x42>
			*dst++ = *src++;
  800383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800387:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80038b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80038f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800393:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800397:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80039b:	0f b6 12             	movzbl (%rdx),%edx
  80039e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8003a0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8003a5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003aa:	74 0b                	je     8003b7 <strlcpy+0x59>
  8003ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003b0:	0f b6 00             	movzbl (%rax),%eax
  8003b3:	84 c0                	test   %al,%al
  8003b5:	75 cc                	jne    800383 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8003b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003bb:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8003be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003c6:	48 29 c2             	sub    %rax,%rdx
  8003c9:	48 89 d0             	mov    %rdx,%rax
}
  8003cc:	c9                   	leaveq 
  8003cd:	c3                   	retq   

00000000008003ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003ce:	55                   	push   %rbp
  8003cf:	48 89 e5             	mov    %rsp,%rbp
  8003d2:	48 83 ec 10          	sub    $0x10,%rsp
  8003d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8003de:	eb 0a                	jmp    8003ea <strcmp+0x1c>
		p++, q++;
  8003e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003e5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8003ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003ee:	0f b6 00             	movzbl (%rax),%eax
  8003f1:	84 c0                	test   %al,%al
  8003f3:	74 12                	je     800407 <strcmp+0x39>
  8003f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f9:	0f b6 10             	movzbl (%rax),%edx
  8003fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800400:	0f b6 00             	movzbl (%rax),%eax
  800403:	38 c2                	cmp    %al,%dl
  800405:	74 d9                	je     8003e0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80040b:	0f b6 00             	movzbl (%rax),%eax
  80040e:	0f b6 d0             	movzbl %al,%edx
  800411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800415:	0f b6 00             	movzbl (%rax),%eax
  800418:	0f b6 c0             	movzbl %al,%eax
  80041b:	29 c2                	sub    %eax,%edx
  80041d:	89 d0                	mov    %edx,%eax
}
  80041f:	c9                   	leaveq 
  800420:	c3                   	retq   

0000000000800421 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800421:	55                   	push   %rbp
  800422:	48 89 e5             	mov    %rsp,%rbp
  800425:	48 83 ec 18          	sub    $0x18,%rsp
  800429:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80042d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800431:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800435:	eb 0f                	jmp    800446 <strncmp+0x25>
		n--, p++, q++;
  800437:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80043c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800441:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800446:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80044b:	74 1d                	je     80046a <strncmp+0x49>
  80044d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800451:	0f b6 00             	movzbl (%rax),%eax
  800454:	84 c0                	test   %al,%al
  800456:	74 12                	je     80046a <strncmp+0x49>
  800458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80045c:	0f b6 10             	movzbl (%rax),%edx
  80045f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800463:	0f b6 00             	movzbl (%rax),%eax
  800466:	38 c2                	cmp    %al,%dl
  800468:	74 cd                	je     800437 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80046a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80046f:	75 07                	jne    800478 <strncmp+0x57>
		return 0;
  800471:	b8 00 00 00 00       	mov    $0x0,%eax
  800476:	eb 18                	jmp    800490 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800478:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80047c:	0f b6 00             	movzbl (%rax),%eax
  80047f:	0f b6 d0             	movzbl %al,%edx
  800482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800486:	0f b6 00             	movzbl (%rax),%eax
  800489:	0f b6 c0             	movzbl %al,%eax
  80048c:	29 c2                	sub    %eax,%edx
  80048e:	89 d0                	mov    %edx,%eax
}
  800490:	c9                   	leaveq 
  800491:	c3                   	retq   

0000000000800492 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800492:	55                   	push   %rbp
  800493:	48 89 e5             	mov    %rsp,%rbp
  800496:	48 83 ec 0c          	sub    $0xc,%rsp
  80049a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80049e:	89 f0                	mov    %esi,%eax
  8004a0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004a3:	eb 17                	jmp    8004bc <strchr+0x2a>
		if (*s == c)
  8004a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004a9:	0f b6 00             	movzbl (%rax),%eax
  8004ac:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004af:	75 06                	jne    8004b7 <strchr+0x25>
			return (char *) s;
  8004b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004b5:	eb 15                	jmp    8004cc <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c0:	0f b6 00             	movzbl (%rax),%eax
  8004c3:	84 c0                	test   %al,%al
  8004c5:	75 de                	jne    8004a5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004cc:	c9                   	leaveq 
  8004cd:	c3                   	retq   

00000000008004ce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004ce:	55                   	push   %rbp
  8004cf:	48 89 e5             	mov    %rsp,%rbp
  8004d2:	48 83 ec 0c          	sub    $0xc,%rsp
  8004d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004da:	89 f0                	mov    %esi,%eax
  8004dc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004df:	eb 13                	jmp    8004f4 <strfind+0x26>
		if (*s == c)
  8004e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e5:	0f b6 00             	movzbl (%rax),%eax
  8004e8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004eb:	75 02                	jne    8004ef <strfind+0x21>
			break;
  8004ed:	eb 10                	jmp    8004ff <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f8:	0f b6 00             	movzbl (%rax),%eax
  8004fb:	84 c0                	test   %al,%al
  8004fd:	75 e2                	jne    8004e1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8004ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800503:	c9                   	leaveq 
  800504:	c3                   	retq   

0000000000800505 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800505:	55                   	push   %rbp
  800506:	48 89 e5             	mov    %rsp,%rbp
  800509:	48 83 ec 18          	sub    $0x18,%rsp
  80050d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800511:	89 75 f4             	mov    %esi,-0xc(%rbp)
  800514:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  800518:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80051d:	75 06                	jne    800525 <memset+0x20>
		return v;
  80051f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800523:	eb 69                	jmp    80058e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  800525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800529:	83 e0 03             	and    $0x3,%eax
  80052c:	48 85 c0             	test   %rax,%rax
  80052f:	75 48                	jne    800579 <memset+0x74>
  800531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800535:	83 e0 03             	and    $0x3,%eax
  800538:	48 85 c0             	test   %rax,%rax
  80053b:	75 3c                	jne    800579 <memset+0x74>
		c &= 0xFF;
  80053d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800544:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800547:	c1 e0 18             	shl    $0x18,%eax
  80054a:	89 c2                	mov    %eax,%edx
  80054c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80054f:	c1 e0 10             	shl    $0x10,%eax
  800552:	09 c2                	or     %eax,%edx
  800554:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800557:	c1 e0 08             	shl    $0x8,%eax
  80055a:	09 d0                	or     %edx,%eax
  80055c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80055f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800563:	48 c1 e8 02          	shr    $0x2,%rax
  800567:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80056a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80056e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800571:	48 89 d7             	mov    %rdx,%rdi
  800574:	fc                   	cld    
  800575:	f3 ab                	rep stos %eax,%es:(%rdi)
  800577:	eb 11                	jmp    80058a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800579:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80057d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800580:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800584:	48 89 d7             	mov    %rdx,%rdi
  800587:	fc                   	cld    
  800588:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80058a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80058e:	c9                   	leaveq 
  80058f:	c3                   	retq   

0000000000800590 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800590:	55                   	push   %rbp
  800591:	48 89 e5             	mov    %rsp,%rbp
  800594:	48 83 ec 28          	sub    $0x28,%rsp
  800598:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80059c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8005a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8005ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8005b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005bc:	0f 83 88 00 00 00    	jae    80064a <memmove+0xba>
  8005c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005ca:	48 01 d0             	add    %rdx,%rax
  8005cd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005d1:	76 77                	jbe    80064a <memmove+0xba>
		s += n;
  8005d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8005db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005df:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005e7:	83 e0 03             	and    $0x3,%eax
  8005ea:	48 85 c0             	test   %rax,%rax
  8005ed:	75 3b                	jne    80062a <memmove+0x9a>
  8005ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005f3:	83 e0 03             	and    $0x3,%eax
  8005f6:	48 85 c0             	test   %rax,%rax
  8005f9:	75 2f                	jne    80062a <memmove+0x9a>
  8005fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ff:	83 e0 03             	and    $0x3,%eax
  800602:	48 85 c0             	test   %rax,%rax
  800605:	75 23                	jne    80062a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80060b:	48 83 e8 04          	sub    $0x4,%rax
  80060f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800613:	48 83 ea 04          	sub    $0x4,%rdx
  800617:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80061b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80061f:	48 89 c7             	mov    %rax,%rdi
  800622:	48 89 d6             	mov    %rdx,%rsi
  800625:	fd                   	std    
  800626:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800628:	eb 1d                	jmp    800647 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80062a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800632:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800636:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80063a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063e:	48 89 d7             	mov    %rdx,%rdi
  800641:	48 89 c1             	mov    %rax,%rcx
  800644:	fd                   	std    
  800645:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800647:	fc                   	cld    
  800648:	eb 57                	jmp    8006a1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80064a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80064e:	83 e0 03             	and    $0x3,%eax
  800651:	48 85 c0             	test   %rax,%rax
  800654:	75 36                	jne    80068c <memmove+0xfc>
  800656:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065a:	83 e0 03             	and    $0x3,%eax
  80065d:	48 85 c0             	test   %rax,%rax
  800660:	75 2a                	jne    80068c <memmove+0xfc>
  800662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800666:	83 e0 03             	and    $0x3,%eax
  800669:	48 85 c0             	test   %rax,%rax
  80066c:	75 1e                	jne    80068c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80066e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800672:	48 c1 e8 02          	shr    $0x2,%rax
  800676:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800681:	48 89 c7             	mov    %rax,%rdi
  800684:	48 89 d6             	mov    %rdx,%rsi
  800687:	fc                   	cld    
  800688:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80068a:	eb 15                	jmp    8006a1 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80068c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800690:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800694:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800698:	48 89 c7             	mov    %rax,%rdi
  80069b:	48 89 d6             	mov    %rdx,%rsi
  80069e:	fc                   	cld    
  80069f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8006a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8006a5:	c9                   	leaveq 
  8006a6:	c3                   	retq   

00000000008006a7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8006a7:	55                   	push   %rbp
  8006a8:	48 89 e5             	mov    %rsp,%rbp
  8006ab:	48 83 ec 18          	sub    $0x18,%rsp
  8006af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8006bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006c7:	48 89 ce             	mov    %rcx,%rsi
  8006ca:	48 89 c7             	mov    %rax,%rdi
  8006cd:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8006d4:	00 00 00 
  8006d7:	ff d0                	callq  *%rax
}
  8006d9:	c9                   	leaveq 
  8006da:	c3                   	retq   

00000000008006db <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8006db:	55                   	push   %rbp
  8006dc:	48 89 e5             	mov    %rsp,%rbp
  8006df:	48 83 ec 28          	sub    $0x28,%rsp
  8006e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8006f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8006ff:	eb 36                	jmp    800737 <memcmp+0x5c>
		if (*s1 != *s2)
  800701:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800705:	0f b6 10             	movzbl (%rax),%edx
  800708:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80070c:	0f b6 00             	movzbl (%rax),%eax
  80070f:	38 c2                	cmp    %al,%dl
  800711:	74 1a                	je     80072d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  800713:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800717:	0f b6 00             	movzbl (%rax),%eax
  80071a:	0f b6 d0             	movzbl %al,%edx
  80071d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800721:	0f b6 00             	movzbl (%rax),%eax
  800724:	0f b6 c0             	movzbl %al,%eax
  800727:	29 c2                	sub    %eax,%edx
  800729:	89 d0                	mov    %edx,%eax
  80072b:	eb 20                	jmp    80074d <memcmp+0x72>
		s1++, s2++;
  80072d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800732:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80073b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80073f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800743:	48 85 c0             	test   %rax,%rax
  800746:	75 b9                	jne    800701 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80074d:	c9                   	leaveq 
  80074e:	c3                   	retq   

000000000080074f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80074f:	55                   	push   %rbp
  800750:	48 89 e5             	mov    %rsp,%rbp
  800753:	48 83 ec 28          	sub    $0x28,%rsp
  800757:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80075e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  800762:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076a:	48 01 d0             	add    %rdx,%rax
  80076d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  800771:	eb 15                	jmp    800788 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  800773:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800777:	0f b6 10             	movzbl (%rax),%edx
  80077a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80077d:	38 c2                	cmp    %al,%dl
  80077f:	75 02                	jne    800783 <memfind+0x34>
			break;
  800781:	eb 0f                	jmp    800792 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800783:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800790:	72 e1                	jb     800773 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  800792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800796:	c9                   	leaveq 
  800797:	c3                   	retq   

0000000000800798 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800798:	55                   	push   %rbp
  800799:	48 89 e5             	mov    %rsp,%rbp
  80079c:	48 83 ec 34          	sub    $0x34,%rsp
  8007a0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8007a8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8007ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8007b2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8007b9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007ba:	eb 05                	jmp    8007c1 <strtol+0x29>
		s++;
  8007bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c5:	0f b6 00             	movzbl (%rax),%eax
  8007c8:	3c 20                	cmp    $0x20,%al
  8007ca:	74 f0                	je     8007bc <strtol+0x24>
  8007cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d0:	0f b6 00             	movzbl (%rax),%eax
  8007d3:	3c 09                	cmp    $0x9,%al
  8007d5:	74 e5                	je     8007bc <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8007d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007db:	0f b6 00             	movzbl (%rax),%eax
  8007de:	3c 2b                	cmp    $0x2b,%al
  8007e0:	75 07                	jne    8007e9 <strtol+0x51>
		s++;
  8007e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007e7:	eb 17                	jmp    800800 <strtol+0x68>
	else if (*s == '-')
  8007e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ed:	0f b6 00             	movzbl (%rax),%eax
  8007f0:	3c 2d                	cmp    $0x2d,%al
  8007f2:	75 0c                	jne    800800 <strtol+0x68>
		s++, neg = 1;
  8007f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800800:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800804:	74 06                	je     80080c <strtol+0x74>
  800806:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80080a:	75 28                	jne    800834 <strtol+0x9c>
  80080c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800810:	0f b6 00             	movzbl (%rax),%eax
  800813:	3c 30                	cmp    $0x30,%al
  800815:	75 1d                	jne    800834 <strtol+0x9c>
  800817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80081b:	48 83 c0 01          	add    $0x1,%rax
  80081f:	0f b6 00             	movzbl (%rax),%eax
  800822:	3c 78                	cmp    $0x78,%al
  800824:	75 0e                	jne    800834 <strtol+0x9c>
		s += 2, base = 16;
  800826:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80082b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  800832:	eb 2c                	jmp    800860 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  800834:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800838:	75 19                	jne    800853 <strtol+0xbb>
  80083a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80083e:	0f b6 00             	movzbl (%rax),%eax
  800841:	3c 30                	cmp    $0x30,%al
  800843:	75 0e                	jne    800853 <strtol+0xbb>
		s++, base = 8;
  800845:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80084a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800851:	eb 0d                	jmp    800860 <strtol+0xc8>
	else if (base == 0)
  800853:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800857:	75 07                	jne    800860 <strtol+0xc8>
		base = 10;
  800859:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800860:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800864:	0f b6 00             	movzbl (%rax),%eax
  800867:	3c 2f                	cmp    $0x2f,%al
  800869:	7e 1d                	jle    800888 <strtol+0xf0>
  80086b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80086f:	0f b6 00             	movzbl (%rax),%eax
  800872:	3c 39                	cmp    $0x39,%al
  800874:	7f 12                	jg     800888 <strtol+0xf0>
			dig = *s - '0';
  800876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80087a:	0f b6 00             	movzbl (%rax),%eax
  80087d:	0f be c0             	movsbl %al,%eax
  800880:	83 e8 30             	sub    $0x30,%eax
  800883:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800886:	eb 4e                	jmp    8008d6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  800888:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80088c:	0f b6 00             	movzbl (%rax),%eax
  80088f:	3c 60                	cmp    $0x60,%al
  800891:	7e 1d                	jle    8008b0 <strtol+0x118>
  800893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800897:	0f b6 00             	movzbl (%rax),%eax
  80089a:	3c 7a                	cmp    $0x7a,%al
  80089c:	7f 12                	jg     8008b0 <strtol+0x118>
			dig = *s - 'a' + 10;
  80089e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a2:	0f b6 00             	movzbl (%rax),%eax
  8008a5:	0f be c0             	movsbl %al,%eax
  8008a8:	83 e8 57             	sub    $0x57,%eax
  8008ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8008ae:	eb 26                	jmp    8008d6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8008b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b4:	0f b6 00             	movzbl (%rax),%eax
  8008b7:	3c 40                	cmp    $0x40,%al
  8008b9:	7e 48                	jle    800903 <strtol+0x16b>
  8008bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008bf:	0f b6 00             	movzbl (%rax),%eax
  8008c2:	3c 5a                	cmp    $0x5a,%al
  8008c4:	7f 3d                	jg     800903 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8008c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008ca:	0f b6 00             	movzbl (%rax),%eax
  8008cd:	0f be c0             	movsbl %al,%eax
  8008d0:	83 e8 37             	sub    $0x37,%eax
  8008d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8008d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008d9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8008dc:	7c 02                	jl     8008e0 <strtol+0x148>
			break;
  8008de:	eb 23                	jmp    800903 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8008e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8008e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008e8:	48 98                	cltq   
  8008ea:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8008ef:	48 89 c2             	mov    %rax,%rdx
  8008f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008f5:	48 98                	cltq   
  8008f7:	48 01 d0             	add    %rdx,%rax
  8008fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8008fe:	e9 5d ff ff ff       	jmpq   800860 <strtol+0xc8>

	if (endptr)
  800903:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800908:	74 0b                	je     800915 <strtol+0x17d>
		*endptr = (char *) s;
  80090a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80090e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800912:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  800915:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800919:	74 09                	je     800924 <strtol+0x18c>
  80091b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80091f:	48 f7 d8             	neg    %rax
  800922:	eb 04                	jmp    800928 <strtol+0x190>
  800924:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800928:	c9                   	leaveq 
  800929:	c3                   	retq   

000000000080092a <strstr>:

char * strstr(const char *in, const char *str)
{
  80092a:	55                   	push   %rbp
  80092b:	48 89 e5             	mov    %rsp,%rbp
  80092e:	48 83 ec 30          	sub    $0x30,%rsp
  800932:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800936:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80093a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80093e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800942:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800946:	0f b6 00             	movzbl (%rax),%eax
  800949:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80094c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800950:	75 06                	jne    800958 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  800952:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800956:	eb 6b                	jmp    8009c3 <strstr+0x99>

	len = strlen(str);
  800958:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80095c:	48 89 c7             	mov    %rax,%rdi
  80095f:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  800966:	00 00 00 
  800969:	ff d0                	callq  *%rax
  80096b:	48 98                	cltq   
  80096d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  800971:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800975:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800979:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80097d:	0f b6 00             	movzbl (%rax),%eax
  800980:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  800983:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  800987:	75 07                	jne    800990 <strstr+0x66>
				return (char *) 0;
  800989:	b8 00 00 00 00       	mov    $0x0,%eax
  80098e:	eb 33                	jmp    8009c3 <strstr+0x99>
		} while (sc != c);
  800990:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800994:	3a 45 ff             	cmp    -0x1(%rbp),%al
  800997:	75 d8                	jne    800971 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  800999:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80099d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8009a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009a5:	48 89 ce             	mov    %rcx,%rsi
  8009a8:	48 89 c7             	mov    %rax,%rdi
  8009ab:	48 b8 21 04 80 00 00 	movabs $0x800421,%rax
  8009b2:	00 00 00 
  8009b5:	ff d0                	callq  *%rax
  8009b7:	85 c0                	test   %eax,%eax
  8009b9:	75 b6                	jne    800971 <strstr+0x47>

	return (char *) (in - 1);
  8009bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009bf:	48 83 e8 01          	sub    $0x1,%rax
}
  8009c3:	c9                   	leaveq 
  8009c4:	c3                   	retq   

00000000008009c5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8009c5:	55                   	push   %rbp
  8009c6:	48 89 e5             	mov    %rsp,%rbp
  8009c9:	53                   	push   %rbx
  8009ca:	48 83 ec 48          	sub    $0x48,%rsp
  8009ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8009d1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8009d4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009d8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8009dc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8009e0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009e4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009e7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8009eb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009ef:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8009f3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8009f7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8009fb:	4c 89 c3             	mov    %r8,%rbx
  8009fe:	cd 30                	int    $0x30
  800a00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a04:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a08:	74 3e                	je     800a48 <syscall+0x83>
  800a0a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800a0f:	7e 37                	jle    800a48 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a15:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a18:	49 89 d0             	mov    %rdx,%r8
  800a1b:	89 c1                	mov    %eax,%ecx
  800a1d:	48 ba 71 3f 80 00 00 	movabs $0x803f71,%rdx
  800a24:	00 00 00 
  800a27:	be 23 00 00 00       	mov    $0x23,%esi
  800a2c:	48 bf 8e 3f 80 00 00 	movabs $0x803f8e,%rdi
  800a33:	00 00 00 
  800a36:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3b:	49 b9 60 2f 80 00 00 	movabs $0x802f60,%r9
  800a42:	00 00 00 
  800a45:	41 ff d1             	callq  *%r9

	return ret;
  800a48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a4c:	48 83 c4 48          	add    $0x48,%rsp
  800a50:	5b                   	pop    %rbx
  800a51:	5d                   	pop    %rbp
  800a52:	c3                   	retq   

0000000000800a53 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a53:	55                   	push   %rbp
  800a54:	48 89 e5             	mov    %rsp,%rbp
  800a57:	48 83 ec 20          	sub    $0x20,%rsp
  800a5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a67:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800a72:	00 
  800a73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a7f:	48 89 d1             	mov    %rdx,%rcx
  800a82:	48 89 c2             	mov    %rax,%rdx
  800a85:	be 00 00 00 00       	mov    $0x0,%esi
  800a8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8f:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800a96:	00 00 00 
  800a99:	ff d0                	callq  *%rax
}
  800a9b:	c9                   	leaveq 
  800a9c:	c3                   	retq   

0000000000800a9d <sys_cgetc>:

int
sys_cgetc(void)
{
  800a9d:	55                   	push   %rbp
  800a9e:	48 89 e5             	mov    %rsp,%rbp
  800aa1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800aa5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800aac:	00 
  800aad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ab3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ab9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800abe:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac3:	be 00 00 00 00       	mov    $0x0,%esi
  800ac8:	bf 01 00 00 00       	mov    $0x1,%edi
  800acd:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800ad4:	00 00 00 
  800ad7:	ff d0                	callq  *%rax
}
  800ad9:	c9                   	leaveq 
  800ada:	c3                   	retq   

0000000000800adb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800adb:	55                   	push   %rbp
  800adc:	48 89 e5             	mov    %rsp,%rbp
  800adf:	48 83 ec 10          	sub    $0x10,%rsp
  800ae3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800ae6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ae9:	48 98                	cltq   
  800aeb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800af2:	00 
  800af3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800af9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800aff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b04:	48 89 c2             	mov    %rax,%rdx
  800b07:	be 01 00 00 00       	mov    $0x1,%esi
  800b0c:	bf 03 00 00 00       	mov    $0x3,%edi
  800b11:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800b18:	00 00 00 
  800b1b:	ff d0                	callq  *%rax
}
  800b1d:	c9                   	leaveq 
  800b1e:	c3                   	retq   

0000000000800b1f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b1f:	55                   	push   %rbp
  800b20:	48 89 e5             	mov    %rsp,%rbp
  800b23:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b2e:	00 
  800b2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b40:	ba 00 00 00 00       	mov    $0x0,%edx
  800b45:	be 00 00 00 00       	mov    $0x0,%esi
  800b4a:	bf 02 00 00 00       	mov    $0x2,%edi
  800b4f:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800b56:	00 00 00 
  800b59:	ff d0                	callq  *%rax
}
  800b5b:	c9                   	leaveq 
  800b5c:	c3                   	retq   

0000000000800b5d <sys_yield>:

void
sys_yield(void)
{
  800b5d:	55                   	push   %rbp
  800b5e:	48 89 e5             	mov    %rsp,%rbp
  800b61:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800b6c:	00 
  800b6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b79:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b83:	be 00 00 00 00       	mov    $0x0,%esi
  800b88:	bf 0b 00 00 00       	mov    $0xb,%edi
  800b8d:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800b94:	00 00 00 
  800b97:	ff d0                	callq  *%rax
}
  800b99:	c9                   	leaveq 
  800b9a:	c3                   	retq   

0000000000800b9b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b9b:	55                   	push   %rbp
  800b9c:	48 89 e5             	mov    %rsp,%rbp
  800b9f:	48 83 ec 20          	sub    $0x20,%rsp
  800ba3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ba6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800baa:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800bad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bb0:	48 63 c8             	movslq %eax,%rcx
  800bb3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bba:	48 98                	cltq   
  800bbc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800bc3:	00 
  800bc4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800bca:	49 89 c8             	mov    %rcx,%r8
  800bcd:	48 89 d1             	mov    %rdx,%rcx
  800bd0:	48 89 c2             	mov    %rax,%rdx
  800bd3:	be 01 00 00 00       	mov    $0x1,%esi
  800bd8:	bf 04 00 00 00       	mov    $0x4,%edi
  800bdd:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800be4:	00 00 00 
  800be7:	ff d0                	callq  *%rax
}
  800be9:	c9                   	leaveq 
  800bea:	c3                   	retq   

0000000000800beb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800beb:	55                   	push   %rbp
  800bec:	48 89 e5             	mov    %rsp,%rbp
  800bef:	48 83 ec 30          	sub    $0x30,%rsp
  800bf3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bf6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bfa:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800bfd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c01:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800c05:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c08:	48 63 c8             	movslq %eax,%rcx
  800c0b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c12:	48 63 f0             	movslq %eax,%rsi
  800c15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c1c:	48 98                	cltq   
  800c1e:	48 89 0c 24          	mov    %rcx,(%rsp)
  800c22:	49 89 f9             	mov    %rdi,%r9
  800c25:	49 89 f0             	mov    %rsi,%r8
  800c28:	48 89 d1             	mov    %rdx,%rcx
  800c2b:	48 89 c2             	mov    %rax,%rdx
  800c2e:	be 01 00 00 00       	mov    $0x1,%esi
  800c33:	bf 05 00 00 00       	mov    $0x5,%edi
  800c38:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800c3f:	00 00 00 
  800c42:	ff d0                	callq  *%rax
}
  800c44:	c9                   	leaveq 
  800c45:	c3                   	retq   

0000000000800c46 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c46:	55                   	push   %rbp
  800c47:	48 89 e5             	mov    %rsp,%rbp
  800c4a:	48 83 ec 20          	sub    $0x20,%rsp
  800c4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c5c:	48 98                	cltq   
  800c5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800c65:	00 
  800c66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c72:	48 89 d1             	mov    %rdx,%rcx
  800c75:	48 89 c2             	mov    %rax,%rdx
  800c78:	be 01 00 00 00       	mov    $0x1,%esi
  800c7d:	bf 06 00 00 00       	mov    $0x6,%edi
  800c82:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800c89:	00 00 00 
  800c8c:	ff d0                	callq  *%rax
}
  800c8e:	c9                   	leaveq 
  800c8f:	c3                   	retq   

0000000000800c90 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c90:	55                   	push   %rbp
  800c91:	48 89 e5             	mov    %rsp,%rbp
  800c94:	48 83 ec 10          	sub    $0x10,%rsp
  800c98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c9b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800c9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ca1:	48 63 d0             	movslq %eax,%rdx
  800ca4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ca7:	48 98                	cltq   
  800ca9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cb0:	00 
  800cb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800cb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cbd:	48 89 d1             	mov    %rdx,%rcx
  800cc0:	48 89 c2             	mov    %rax,%rdx
  800cc3:	be 01 00 00 00       	mov    $0x1,%esi
  800cc8:	bf 08 00 00 00       	mov    $0x8,%edi
  800ccd:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800cd4:	00 00 00 
  800cd7:	ff d0                	callq  *%rax
}
  800cd9:	c9                   	leaveq 
  800cda:	c3                   	retq   

0000000000800cdb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cdb:	55                   	push   %rbp
  800cdc:	48 89 e5             	mov    %rsp,%rbp
  800cdf:	48 83 ec 20          	sub    $0x20,%rsp
  800ce3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ce6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800cea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cf1:	48 98                	cltq   
  800cf3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800cfa:	00 
  800cfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d07:	48 89 d1             	mov    %rdx,%rcx
  800d0a:	48 89 c2             	mov    %rax,%rdx
  800d0d:	be 01 00 00 00       	mov    $0x1,%esi
  800d12:	bf 09 00 00 00       	mov    $0x9,%edi
  800d17:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800d1e:	00 00 00 
  800d21:	ff d0                	callq  *%rax
}
  800d23:	c9                   	leaveq 
  800d24:	c3                   	retq   

0000000000800d25 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d25:	55                   	push   %rbp
  800d26:	48 89 e5             	mov    %rsp,%rbp
  800d29:	48 83 ec 20          	sub    $0x20,%rsp
  800d2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800d34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d3b:	48 98                	cltq   
  800d3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d44:	00 
  800d45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d51:	48 89 d1             	mov    %rdx,%rcx
  800d54:	48 89 c2             	mov    %rax,%rdx
  800d57:	be 01 00 00 00       	mov    $0x1,%esi
  800d5c:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d61:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800d68:	00 00 00 
  800d6b:	ff d0                	callq  *%rax
}
  800d6d:	c9                   	leaveq 
  800d6e:	c3                   	retq   

0000000000800d6f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800d6f:	55                   	push   %rbp
  800d70:	48 89 e5             	mov    %rsp,%rbp
  800d73:	48 83 ec 20          	sub    $0x20,%rsp
  800d77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d7e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d82:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800d85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d88:	48 63 f0             	movslq %eax,%rsi
  800d8b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d92:	48 98                	cltq   
  800d94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800d9f:	00 
  800da0:	49 89 f1             	mov    %rsi,%r9
  800da3:	49 89 c8             	mov    %rcx,%r8
  800da6:	48 89 d1             	mov    %rdx,%rcx
  800da9:	48 89 c2             	mov    %rax,%rdx
  800dac:	be 00 00 00 00       	mov    $0x0,%esi
  800db1:	bf 0c 00 00 00       	mov    $0xc,%edi
  800db6:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800dbd:	00 00 00 
  800dc0:	ff d0                	callq  *%rax
}
  800dc2:	c9                   	leaveq 
  800dc3:	c3                   	retq   

0000000000800dc4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc4:	55                   	push   %rbp
  800dc5:	48 89 e5             	mov    %rsp,%rbp
  800dc8:	48 83 ec 10          	sub    $0x10,%rsp
  800dcc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800dd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800dd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ddb:	00 
  800ddc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800de2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800de8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ded:	48 89 c2             	mov    %rax,%rdx
  800df0:	be 01 00 00 00       	mov    $0x1,%esi
  800df5:	bf 0d 00 00 00       	mov    $0xd,%edi
  800dfa:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800e01:	00 00 00 
  800e04:	ff d0                	callq  *%rax
}
  800e06:	c9                   	leaveq 
  800e07:	c3                   	retq   

0000000000800e08 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  800e08:	55                   	push   %rbp
  800e09:	48 89 e5             	mov    %rsp,%rbp
  800e0c:	48 83 ec 20          	sub    $0x20,%rsp
  800e10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  800e18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e27:	00 
  800e28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e34:	48 89 d1             	mov    %rdx,%rcx
  800e37:	48 89 c2             	mov    %rax,%rdx
  800e3a:	be 01 00 00 00       	mov    $0x1,%esi
  800e3f:	bf 0f 00 00 00       	mov    $0xf,%edi
  800e44:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800e4b:	00 00 00 
  800e4e:	ff d0                	callq  *%rax
}
  800e50:	c9                   	leaveq 
  800e51:	c3                   	retq   

0000000000800e52 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  800e52:	55                   	push   %rbp
  800e53:	48 89 e5             	mov    %rsp,%rbp
  800e56:	48 83 ec 10          	sub    $0x10,%rsp
  800e5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  800e5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e62:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800e69:	00 
  800e6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e70:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e76:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e7b:	48 89 c2             	mov    %rax,%rdx
  800e7e:	be 00 00 00 00       	mov    $0x0,%esi
  800e83:	bf 10 00 00 00       	mov    $0x10,%edi
  800e88:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800e8f:	00 00 00 
  800e92:	ff d0                	callq  *%rax
}
  800e94:	c9                   	leaveq 
  800e95:	c3                   	retq   

0000000000800e96 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800e96:	55                   	push   %rbp
  800e97:	48 89 e5             	mov    %rsp,%rbp
  800e9a:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800e9e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800ea5:	00 
  800ea6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800eac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800eb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ebc:	be 00 00 00 00       	mov    $0x0,%esi
  800ec1:	bf 0e 00 00 00       	mov    $0xe,%edi
  800ec6:	48 b8 c5 09 80 00 00 	movabs $0x8009c5,%rax
  800ecd:	00 00 00 
  800ed0:	ff d0                	callq  *%rax
}
  800ed2:	c9                   	leaveq 
  800ed3:	c3                   	retq   

0000000000800ed4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800ed4:	55                   	push   %rbp
  800ed5:	48 89 e5             	mov    %rsp,%rbp
  800ed8:	48 83 ec 08          	sub    $0x8,%rsp
  800edc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ee0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800ee4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800eeb:	ff ff ff 
  800eee:	48 01 d0             	add    %rdx,%rax
  800ef1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  800ef5:	c9                   	leaveq 
  800ef6:	c3                   	retq   

0000000000800ef7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ef7:	55                   	push   %rbp
  800ef8:	48 89 e5             	mov    %rsp,%rbp
  800efb:	48 83 ec 08          	sub    $0x8,%rsp
  800eff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f07:	48 89 c7             	mov    %rax,%rdi
  800f0a:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  800f11:	00 00 00 
  800f14:	ff d0                	callq  *%rax
  800f16:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800f1c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800f20:	c9                   	leaveq 
  800f21:	c3                   	retq   

0000000000800f22 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f22:	55                   	push   %rbp
  800f23:	48 89 e5             	mov    %rsp,%rbp
  800f26:	48 83 ec 18          	sub    $0x18,%rsp
  800f2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f35:	eb 6b                	jmp    800fa2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800f37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f3a:	48 98                	cltq   
  800f3c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800f42:	48 c1 e0 0c          	shl    $0xc,%rax
  800f46:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f4e:	48 c1 e8 15          	shr    $0x15,%rax
  800f52:	48 89 c2             	mov    %rax,%rdx
  800f55:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800f5c:	01 00 00 
  800f5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f63:	83 e0 01             	and    $0x1,%eax
  800f66:	48 85 c0             	test   %rax,%rax
  800f69:	74 21                	je     800f8c <fd_alloc+0x6a>
  800f6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6f:	48 c1 e8 0c          	shr    $0xc,%rax
  800f73:	48 89 c2             	mov    %rax,%rdx
  800f76:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800f7d:	01 00 00 
  800f80:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800f84:	83 e0 01             	and    $0x1,%eax
  800f87:	48 85 c0             	test   %rax,%rax
  800f8a:	75 12                	jne    800f9e <fd_alloc+0x7c>
			*fd_store = fd;
  800f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f94:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800f97:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9c:	eb 1a                	jmp    800fb8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f9e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fa2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800fa6:	7e 8f                	jle    800f37 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fac:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800fb3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800fb8:	c9                   	leaveq 
  800fb9:	c3                   	retq   

0000000000800fba <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fba:	55                   	push   %rbp
  800fbb:	48 89 e5             	mov    %rsp,%rbp
  800fbe:	48 83 ec 20          	sub    $0x20,%rsp
  800fc2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800fc5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fc9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800fcd:	78 06                	js     800fd5 <fd_lookup+0x1b>
  800fcf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800fd3:	7e 07                	jle    800fdc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fda:	eb 6c                	jmp    801048 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800fdc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800fdf:	48 98                	cltq   
  800fe1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800fe7:	48 c1 e0 0c          	shl    $0xc,%rax
  800feb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff3:	48 c1 e8 15          	shr    $0x15,%rax
  800ff7:	48 89 c2             	mov    %rax,%rdx
  800ffa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801001:	01 00 00 
  801004:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801008:	83 e0 01             	and    $0x1,%eax
  80100b:	48 85 c0             	test   %rax,%rax
  80100e:	74 21                	je     801031 <fd_lookup+0x77>
  801010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801014:	48 c1 e8 0c          	shr    $0xc,%rax
  801018:	48 89 c2             	mov    %rax,%rdx
  80101b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801022:	01 00 00 
  801025:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801029:	83 e0 01             	and    $0x1,%eax
  80102c:	48 85 c0             	test   %rax,%rax
  80102f:	75 07                	jne    801038 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801031:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801036:	eb 10                	jmp    801048 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801038:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80103c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801040:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801043:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801048:	c9                   	leaveq 
  801049:	c3                   	retq   

000000000080104a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80104a:	55                   	push   %rbp
  80104b:	48 89 e5             	mov    %rsp,%rbp
  80104e:	48 83 ec 30          	sub    $0x30,%rsp
  801052:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801056:	89 f0                	mov    %esi,%eax
  801058:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80105b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80105f:	48 89 c7             	mov    %rax,%rdi
  801062:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  801069:	00 00 00 
  80106c:	ff d0                	callq  *%rax
  80106e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801072:	48 89 d6             	mov    %rdx,%rsi
  801075:	89 c7                	mov    %eax,%edi
  801077:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  80107e:	00 00 00 
  801081:	ff d0                	callq  *%rax
  801083:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801086:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80108a:	78 0a                	js     801096 <fd_close+0x4c>
	    || fd != fd2)
  80108c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801090:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801094:	74 12                	je     8010a8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801096:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80109a:	74 05                	je     8010a1 <fd_close+0x57>
  80109c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80109f:	eb 05                	jmp    8010a6 <fd_close+0x5c>
  8010a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a6:	eb 69                	jmp    801111 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010ac:	8b 00                	mov    (%rax),%eax
  8010ae:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8010b2:	48 89 d6             	mov    %rdx,%rsi
  8010b5:	89 c7                	mov    %eax,%edi
  8010b7:	48 b8 13 11 80 00 00 	movabs $0x801113,%rax
  8010be:	00 00 00 
  8010c1:	ff d0                	callq  *%rax
  8010c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010ca:	78 2a                	js     8010f6 <fd_close+0xac>
		if (dev->dev_close)
  8010cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8010d4:	48 85 c0             	test   %rax,%rax
  8010d7:	74 16                	je     8010ef <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8010d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dd:	48 8b 40 20          	mov    0x20(%rax),%rax
  8010e1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8010e5:	48 89 d7             	mov    %rdx,%rdi
  8010e8:	ff d0                	callq  *%rax
  8010ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010ed:	eb 07                	jmp    8010f6 <fd_close+0xac>
		else
			r = 0;
  8010ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010fa:	48 89 c6             	mov    %rax,%rsi
  8010fd:	bf 00 00 00 00       	mov    $0x0,%edi
  801102:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  801109:	00 00 00 
  80110c:	ff d0                	callq  *%rax
	return r;
  80110e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801111:	c9                   	leaveq 
  801112:	c3                   	retq   

0000000000801113 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801113:	55                   	push   %rbp
  801114:	48 89 e5             	mov    %rsp,%rbp
  801117:	48 83 ec 20          	sub    $0x20,%rsp
  80111b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80111e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801122:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801129:	eb 41                	jmp    80116c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80112b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801132:	00 00 00 
  801135:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801138:	48 63 d2             	movslq %edx,%rdx
  80113b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80113f:	8b 00                	mov    (%rax),%eax
  801141:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801144:	75 22                	jne    801168 <dev_lookup+0x55>
			*dev = devtab[i];
  801146:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80114d:	00 00 00 
  801150:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801153:	48 63 d2             	movslq %edx,%rdx
  801156:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80115a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801161:	b8 00 00 00 00       	mov    $0x0,%eax
  801166:	eb 60                	jmp    8011c8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801168:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80116c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801173:	00 00 00 
  801176:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801179:	48 63 d2             	movslq %edx,%rdx
  80117c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801180:	48 85 c0             	test   %rax,%rax
  801183:	75 a6                	jne    80112b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801185:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80118c:	00 00 00 
  80118f:	48 8b 00             	mov    (%rax),%rax
  801192:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801198:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80119b:	89 c6                	mov    %eax,%esi
  80119d:	48 bf a0 3f 80 00 00 	movabs $0x803fa0,%rdi
  8011a4:	00 00 00 
  8011a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ac:	48 b9 99 31 80 00 00 	movabs $0x803199,%rcx
  8011b3:	00 00 00 
  8011b6:	ff d1                	callq  *%rcx
	*dev = 0;
  8011b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011bc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8011c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011c8:	c9                   	leaveq 
  8011c9:	c3                   	retq   

00000000008011ca <close>:

int
close(int fdnum)
{
  8011ca:	55                   	push   %rbp
  8011cb:	48 89 e5             	mov    %rsp,%rbp
  8011ce:	48 83 ec 20          	sub    $0x20,%rsp
  8011d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8011d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8011dc:	48 89 d6             	mov    %rdx,%rsi
  8011df:	89 c7                	mov    %eax,%edi
  8011e1:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  8011e8:	00 00 00 
  8011eb:	ff d0                	callq  *%rax
  8011ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011f4:	79 05                	jns    8011fb <close+0x31>
		return r;
  8011f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011f9:	eb 18                	jmp    801213 <close+0x49>
	else
		return fd_close(fd, 1);
  8011fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ff:	be 01 00 00 00       	mov    $0x1,%esi
  801204:	48 89 c7             	mov    %rax,%rdi
  801207:	48 b8 4a 10 80 00 00 	movabs $0x80104a,%rax
  80120e:	00 00 00 
  801211:	ff d0                	callq  *%rax
}
  801213:	c9                   	leaveq 
  801214:	c3                   	retq   

0000000000801215 <close_all>:

void
close_all(void)
{
  801215:	55                   	push   %rbp
  801216:	48 89 e5             	mov    %rsp,%rbp
  801219:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80121d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801224:	eb 15                	jmp    80123b <close_all+0x26>
		close(i);
  801226:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801229:	89 c7                	mov    %eax,%edi
  80122b:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801232:	00 00 00 
  801235:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801237:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80123b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80123f:	7e e5                	jle    801226 <close_all+0x11>
		close(i);
}
  801241:	c9                   	leaveq 
  801242:	c3                   	retq   

0000000000801243 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801243:	55                   	push   %rbp
  801244:	48 89 e5             	mov    %rsp,%rbp
  801247:	48 83 ec 40          	sub    $0x40,%rsp
  80124b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80124e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801251:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801255:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801258:	48 89 d6             	mov    %rdx,%rsi
  80125b:	89 c7                	mov    %eax,%edi
  80125d:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  801264:	00 00 00 
  801267:	ff d0                	callq  *%rax
  801269:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80126c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801270:	79 08                	jns    80127a <dup+0x37>
		return r;
  801272:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801275:	e9 70 01 00 00       	jmpq   8013ea <dup+0x1a7>
	close(newfdnum);
  80127a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80127d:	89 c7                	mov    %eax,%edi
  80127f:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801286:	00 00 00 
  801289:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80128b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80128e:	48 98                	cltq   
  801290:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801296:	48 c1 e0 0c          	shl    $0xc,%rax
  80129a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80129e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a2:	48 89 c7             	mov    %rax,%rdi
  8012a5:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  8012ac:	00 00 00 
  8012af:	ff d0                	callq  *%rax
  8012b1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8012b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b9:	48 89 c7             	mov    %rax,%rdi
  8012bc:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  8012c3:	00 00 00 
  8012c6:	ff d0                	callq  *%rax
  8012c8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d0:	48 c1 e8 15          	shr    $0x15,%rax
  8012d4:	48 89 c2             	mov    %rax,%rdx
  8012d7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8012de:	01 00 00 
  8012e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8012e5:	83 e0 01             	and    $0x1,%eax
  8012e8:	48 85 c0             	test   %rax,%rax
  8012eb:	74 73                	je     801360 <dup+0x11d>
  8012ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f1:	48 c1 e8 0c          	shr    $0xc,%rax
  8012f5:	48 89 c2             	mov    %rax,%rdx
  8012f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8012ff:	01 00 00 
  801302:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801306:	83 e0 01             	and    $0x1,%eax
  801309:	48 85 c0             	test   %rax,%rax
  80130c:	74 52                	je     801360 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80130e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801312:	48 c1 e8 0c          	shr    $0xc,%rax
  801316:	48 89 c2             	mov    %rax,%rdx
  801319:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801320:	01 00 00 
  801323:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801327:	25 07 0e 00 00       	and    $0xe07,%eax
  80132c:	89 c1                	mov    %eax,%ecx
  80132e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801332:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801336:	41 89 c8             	mov    %ecx,%r8d
  801339:	48 89 d1             	mov    %rdx,%rcx
  80133c:	ba 00 00 00 00       	mov    $0x0,%edx
  801341:	48 89 c6             	mov    %rax,%rsi
  801344:	bf 00 00 00 00       	mov    $0x0,%edi
  801349:	48 b8 eb 0b 80 00 00 	movabs $0x800beb,%rax
  801350:	00 00 00 
  801353:	ff d0                	callq  *%rax
  801355:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801358:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80135c:	79 02                	jns    801360 <dup+0x11d>
			goto err;
  80135e:	eb 57                	jmp    8013b7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801360:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801364:	48 c1 e8 0c          	shr    $0xc,%rax
  801368:	48 89 c2             	mov    %rax,%rdx
  80136b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801372:	01 00 00 
  801375:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801379:	25 07 0e 00 00       	and    $0xe07,%eax
  80137e:	89 c1                	mov    %eax,%ecx
  801380:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801384:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801388:	41 89 c8             	mov    %ecx,%r8d
  80138b:	48 89 d1             	mov    %rdx,%rcx
  80138e:	ba 00 00 00 00       	mov    $0x0,%edx
  801393:	48 89 c6             	mov    %rax,%rsi
  801396:	bf 00 00 00 00       	mov    $0x0,%edi
  80139b:	48 b8 eb 0b 80 00 00 	movabs $0x800beb,%rax
  8013a2:	00 00 00 
  8013a5:	ff d0                	callq  *%rax
  8013a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013ae:	79 02                	jns    8013b2 <dup+0x16f>
		goto err;
  8013b0:	eb 05                	jmp    8013b7 <dup+0x174>

	return newfdnum;
  8013b2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8013b5:	eb 33                	jmp    8013ea <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8013b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013bb:	48 89 c6             	mov    %rax,%rsi
  8013be:	bf 00 00 00 00       	mov    $0x0,%edi
  8013c3:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  8013ca:	00 00 00 
  8013cd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8013cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d3:	48 89 c6             	mov    %rax,%rsi
  8013d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8013db:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  8013e2:	00 00 00 
  8013e5:	ff d0                	callq  *%rax
	return r;
  8013e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013ea:	c9                   	leaveq 
  8013eb:	c3                   	retq   

00000000008013ec <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ec:	55                   	push   %rbp
  8013ed:	48 89 e5             	mov    %rsp,%rbp
  8013f0:	48 83 ec 40          	sub    $0x40,%rsp
  8013f4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8013f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013fb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ff:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801403:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801406:	48 89 d6             	mov    %rdx,%rsi
  801409:	89 c7                	mov    %eax,%edi
  80140b:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  801412:	00 00 00 
  801415:	ff d0                	callq  *%rax
  801417:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80141a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80141e:	78 24                	js     801444 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801420:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801424:	8b 00                	mov    (%rax),%eax
  801426:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80142a:	48 89 d6             	mov    %rdx,%rsi
  80142d:	89 c7                	mov    %eax,%edi
  80142f:	48 b8 13 11 80 00 00 	movabs $0x801113,%rax
  801436:	00 00 00 
  801439:	ff d0                	callq  *%rax
  80143b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80143e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801442:	79 05                	jns    801449 <read+0x5d>
		return r;
  801444:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801447:	eb 76                	jmp    8014bf <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144d:	8b 40 08             	mov    0x8(%rax),%eax
  801450:	83 e0 03             	and    $0x3,%eax
  801453:	83 f8 01             	cmp    $0x1,%eax
  801456:	75 3a                	jne    801492 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801458:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80145f:	00 00 00 
  801462:	48 8b 00             	mov    (%rax),%rax
  801465:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80146b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80146e:	89 c6                	mov    %eax,%esi
  801470:	48 bf bf 3f 80 00 00 	movabs $0x803fbf,%rdi
  801477:	00 00 00 
  80147a:	b8 00 00 00 00       	mov    $0x0,%eax
  80147f:	48 b9 99 31 80 00 00 	movabs $0x803199,%rcx
  801486:	00 00 00 
  801489:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80148b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801490:	eb 2d                	jmp    8014bf <read+0xd3>
	}
	if (!dev->dev_read)
  801492:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801496:	48 8b 40 10          	mov    0x10(%rax),%rax
  80149a:	48 85 c0             	test   %rax,%rax
  80149d:	75 07                	jne    8014a6 <read+0xba>
		return -E_NOT_SUPP;
  80149f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8014a4:	eb 19                	jmp    8014bf <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8014a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014aa:	48 8b 40 10          	mov    0x10(%rax),%rax
  8014ae:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014b2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014b6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8014ba:	48 89 cf             	mov    %rcx,%rdi
  8014bd:	ff d0                	callq  *%rax
}
  8014bf:	c9                   	leaveq 
  8014c0:	c3                   	retq   

00000000008014c1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014c1:	55                   	push   %rbp
  8014c2:	48 89 e5             	mov    %rsp,%rbp
  8014c5:	48 83 ec 30          	sub    $0x30,%rsp
  8014c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8014cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8014db:	eb 49                	jmp    801526 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014e0:	48 98                	cltq   
  8014e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014e6:	48 29 c2             	sub    %rax,%rdx
  8014e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014ec:	48 63 c8             	movslq %eax,%rcx
  8014ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f3:	48 01 c1             	add    %rax,%rcx
  8014f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014f9:	48 89 ce             	mov    %rcx,%rsi
  8014fc:	89 c7                	mov    %eax,%edi
  8014fe:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  801505:	00 00 00 
  801508:	ff d0                	callq  *%rax
  80150a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80150d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801511:	79 05                	jns    801518 <readn+0x57>
			return m;
  801513:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801516:	eb 1c                	jmp    801534 <readn+0x73>
		if (m == 0)
  801518:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80151c:	75 02                	jne    801520 <readn+0x5f>
			break;
  80151e:	eb 11                	jmp    801531 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801520:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801523:	01 45 fc             	add    %eax,-0x4(%rbp)
  801526:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801529:	48 98                	cltq   
  80152b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80152f:	72 ac                	jb     8014dd <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  801531:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801534:	c9                   	leaveq 
  801535:	c3                   	retq   

0000000000801536 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801536:	55                   	push   %rbp
  801537:	48 89 e5             	mov    %rsp,%rbp
  80153a:	48 83 ec 40          	sub    $0x40,%rsp
  80153e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801541:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801545:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801549:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80154d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801550:	48 89 d6             	mov    %rdx,%rsi
  801553:	89 c7                	mov    %eax,%edi
  801555:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  80155c:	00 00 00 
  80155f:	ff d0                	callq  *%rax
  801561:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801564:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801568:	78 24                	js     80158e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156e:	8b 00                	mov    (%rax),%eax
  801570:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801574:	48 89 d6             	mov    %rdx,%rsi
  801577:	89 c7                	mov    %eax,%edi
  801579:	48 b8 13 11 80 00 00 	movabs $0x801113,%rax
  801580:	00 00 00 
  801583:	ff d0                	callq  *%rax
  801585:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801588:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80158c:	79 05                	jns    801593 <write+0x5d>
		return r;
  80158e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801591:	eb 75                	jmp    801608 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801593:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801597:	8b 40 08             	mov    0x8(%rax),%eax
  80159a:	83 e0 03             	and    $0x3,%eax
  80159d:	85 c0                	test   %eax,%eax
  80159f:	75 3a                	jne    8015db <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015a1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8015a8:	00 00 00 
  8015ab:	48 8b 00             	mov    (%rax),%rax
  8015ae:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8015b4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8015b7:	89 c6                	mov    %eax,%esi
  8015b9:	48 bf db 3f 80 00 00 	movabs $0x803fdb,%rdi
  8015c0:	00 00 00 
  8015c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c8:	48 b9 99 31 80 00 00 	movabs $0x803199,%rcx
  8015cf:	00 00 00 
  8015d2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8015d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d9:	eb 2d                	jmp    801608 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8015db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015df:	48 8b 40 18          	mov    0x18(%rax),%rax
  8015e3:	48 85 c0             	test   %rax,%rax
  8015e6:	75 07                	jne    8015ef <write+0xb9>
		return -E_NOT_SUPP;
  8015e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8015ed:	eb 19                	jmp    801608 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8015ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8015f7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015fb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8015ff:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801603:	48 89 cf             	mov    %rcx,%rdi
  801606:	ff d0                	callq  *%rax
}
  801608:	c9                   	leaveq 
  801609:	c3                   	retq   

000000000080160a <seek>:

int
seek(int fdnum, off_t offset)
{
  80160a:	55                   	push   %rbp
  80160b:	48 89 e5             	mov    %rsp,%rbp
  80160e:	48 83 ec 18          	sub    $0x18,%rsp
  801612:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801615:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801618:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80161c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80161f:	48 89 d6             	mov    %rdx,%rsi
  801622:	89 c7                	mov    %eax,%edi
  801624:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  80162b:	00 00 00 
  80162e:	ff d0                	callq  *%rax
  801630:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801633:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801637:	79 05                	jns    80163e <seek+0x34>
		return r;
  801639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80163c:	eb 0f                	jmp    80164d <seek+0x43>
	fd->fd_offset = offset;
  80163e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801642:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801645:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164d:	c9                   	leaveq 
  80164e:	c3                   	retq   

000000000080164f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 30          	sub    $0x30,%rsp
  801657:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80165a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80165d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801661:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801664:	48 89 d6             	mov    %rdx,%rsi
  801667:	89 c7                	mov    %eax,%edi
  801669:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  801670:	00 00 00 
  801673:	ff d0                	callq  *%rax
  801675:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801678:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80167c:	78 24                	js     8016a2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801682:	8b 00                	mov    (%rax),%eax
  801684:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801688:	48 89 d6             	mov    %rdx,%rsi
  80168b:	89 c7                	mov    %eax,%edi
  80168d:	48 b8 13 11 80 00 00 	movabs $0x801113,%rax
  801694:	00 00 00 
  801697:	ff d0                	callq  *%rax
  801699:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80169c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016a0:	79 05                	jns    8016a7 <ftruncate+0x58>
		return r;
  8016a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a5:	eb 72                	jmp    801719 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ab:	8b 40 08             	mov    0x8(%rax),%eax
  8016ae:	83 e0 03             	and    $0x3,%eax
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	75 3a                	jne    8016ef <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8016b5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8016bc:	00 00 00 
  8016bf:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8016c8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8016cb:	89 c6                	mov    %eax,%esi
  8016cd:	48 bf f8 3f 80 00 00 	movabs $0x803ff8,%rdi
  8016d4:	00 00 00 
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016dc:	48 b9 99 31 80 00 00 	movabs $0x803199,%rcx
  8016e3:	00 00 00 
  8016e6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8016e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ed:	eb 2a                	jmp    801719 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8016ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8016f7:	48 85 c0             	test   %rax,%rax
  8016fa:	75 07                	jne    801703 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8016fc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801701:	eb 16                	jmp    801719 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  801703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801707:	48 8b 40 30          	mov    0x30(%rax),%rax
  80170b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80170f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  801712:	89 ce                	mov    %ecx,%esi
  801714:	48 89 d7             	mov    %rdx,%rdi
  801717:	ff d0                	callq  *%rax
}
  801719:	c9                   	leaveq 
  80171a:	c3                   	retq   

000000000080171b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80171b:	55                   	push   %rbp
  80171c:	48 89 e5             	mov    %rsp,%rbp
  80171f:	48 83 ec 30          	sub    $0x30,%rsp
  801723:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801726:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80172e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801731:	48 89 d6             	mov    %rdx,%rsi
  801734:	89 c7                	mov    %eax,%edi
  801736:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  80173d:	00 00 00 
  801740:	ff d0                	callq  *%rax
  801742:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801745:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801749:	78 24                	js     80176f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80174b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80174f:	8b 00                	mov    (%rax),%eax
  801751:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801755:	48 89 d6             	mov    %rdx,%rsi
  801758:	89 c7                	mov    %eax,%edi
  80175a:	48 b8 13 11 80 00 00 	movabs $0x801113,%rax
  801761:	00 00 00 
  801764:	ff d0                	callq  *%rax
  801766:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801769:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80176d:	79 05                	jns    801774 <fstat+0x59>
		return r;
  80176f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801772:	eb 5e                	jmp    8017d2 <fstat+0xb7>
	if (!dev->dev_stat)
  801774:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801778:	48 8b 40 28          	mov    0x28(%rax),%rax
  80177c:	48 85 c0             	test   %rax,%rax
  80177f:	75 07                	jne    801788 <fstat+0x6d>
		return -E_NOT_SUPP;
  801781:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801786:	eb 4a                	jmp    8017d2 <fstat+0xb7>
	stat->st_name[0] = 0;
  801788:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80178f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801793:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80179a:	00 00 00 
	stat->st_isdir = 0;
  80179d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8017a8:	00 00 00 
	stat->st_dev = dev;
  8017ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017b3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8017ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017be:	48 8b 40 28          	mov    0x28(%rax),%rax
  8017c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017ca:	48 89 ce             	mov    %rcx,%rsi
  8017cd:	48 89 d7             	mov    %rdx,%rdi
  8017d0:	ff d0                	callq  *%rax
}
  8017d2:	c9                   	leaveq 
  8017d3:	c3                   	retq   

00000000008017d4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017d4:	55                   	push   %rbp
  8017d5:	48 89 e5             	mov    %rsp,%rbp
  8017d8:	48 83 ec 20          	sub    $0x20,%rsp
  8017dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017e8:	be 00 00 00 00       	mov    $0x0,%esi
  8017ed:	48 89 c7             	mov    %rax,%rdi
  8017f0:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  8017f7:	00 00 00 
  8017fa:	ff d0                	callq  *%rax
  8017fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801803:	79 05                	jns    80180a <stat+0x36>
		return fd;
  801805:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801808:	eb 2f                	jmp    801839 <stat+0x65>
	r = fstat(fd, stat);
  80180a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80180e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801811:	48 89 d6             	mov    %rdx,%rsi
  801814:	89 c7                	mov    %eax,%edi
  801816:	48 b8 1b 17 80 00 00 	movabs $0x80171b,%rax
  80181d:	00 00 00 
  801820:	ff d0                	callq  *%rax
  801822:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  801825:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801828:	89 c7                	mov    %eax,%edi
  80182a:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801831:	00 00 00 
  801834:	ff d0                	callq  *%rax
	return r;
  801836:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801839:	c9                   	leaveq 
  80183a:	c3                   	retq   

000000000080183b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80183b:	55                   	push   %rbp
  80183c:	48 89 e5             	mov    %rsp,%rbp
  80183f:	48 83 ec 10          	sub    $0x10,%rsp
  801843:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801846:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80184a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801851:	00 00 00 
  801854:	8b 00                	mov    (%rax),%eax
  801856:	85 c0                	test   %eax,%eax
  801858:	75 1d                	jne    801877 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80185a:	bf 01 00 00 00       	mov    $0x1,%edi
  80185f:	48 b8 4a 3e 80 00 00 	movabs $0x803e4a,%rax
  801866:	00 00 00 
  801869:	ff d0                	callq  *%rax
  80186b:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  801872:	00 00 00 
  801875:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801877:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80187e:	00 00 00 
  801881:	8b 00                	mov    (%rax),%eax
  801883:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801886:	b9 07 00 00 00       	mov    $0x7,%ecx
  80188b:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  801892:	00 00 00 
  801895:	89 c7                	mov    %eax,%edi
  801897:	48 b8 e8 3d 80 00 00 	movabs $0x803de8,%rax
  80189e:	00 00 00 
  8018a1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8018a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ac:	48 89 c6             	mov    %rax,%rsi
  8018af:	bf 00 00 00 00       	mov    $0x0,%edi
  8018b4:	48 b8 e2 3c 80 00 00 	movabs $0x803ce2,%rax
  8018bb:	00 00 00 
  8018be:	ff d0                	callq  *%rax
}
  8018c0:	c9                   	leaveq 
  8018c1:	c3                   	retq   

00000000008018c2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018c2:	55                   	push   %rbp
  8018c3:	48 89 e5             	mov    %rsp,%rbp
  8018c6:	48 83 ec 30          	sub    $0x30,%rsp
  8018ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018ce:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8018d1:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8018d8:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8018df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8018e6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8018eb:	75 08                	jne    8018f5 <open+0x33>
	{
		return r;
  8018ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f0:	e9 f2 00 00 00       	jmpq   8019e7 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8018f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f9:	48 89 c7             	mov    %rax,%rdi
  8018fc:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  801903:	00 00 00 
  801906:	ff d0                	callq  *%rax
  801908:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80190b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  801912:	7e 0a                	jle    80191e <open+0x5c>
	{
		return -E_BAD_PATH;
  801914:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801919:	e9 c9 00 00 00       	jmpq   8019e7 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80191e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801925:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  801926:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80192a:	48 89 c7             	mov    %rax,%rdi
  80192d:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  801934:	00 00 00 
  801937:	ff d0                	callq  *%rax
  801939:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80193c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801940:	78 09                	js     80194b <open+0x89>
  801942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801946:	48 85 c0             	test   %rax,%rax
  801949:	75 08                	jne    801953 <open+0x91>
		{
			return r;
  80194b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194e:	e9 94 00 00 00       	jmpq   8019e7 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  801953:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801957:	ba 00 04 00 00       	mov    $0x400,%edx
  80195c:	48 89 c6             	mov    %rax,%rsi
  80195f:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801966:	00 00 00 
  801969:	48 b8 fe 02 80 00 00 	movabs $0x8002fe,%rax
  801970:	00 00 00 
  801973:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  801975:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80197c:	00 00 00 
  80197f:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801982:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  801988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80198c:	48 89 c6             	mov    %rax,%rsi
  80198f:	bf 01 00 00 00       	mov    $0x1,%edi
  801994:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  80199b:	00 00 00 
  80199e:	ff d0                	callq  *%rax
  8019a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019a7:	79 2b                	jns    8019d4 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  8019a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ad:	be 00 00 00 00       	mov    $0x0,%esi
  8019b2:	48 89 c7             	mov    %rax,%rdi
  8019b5:	48 b8 4a 10 80 00 00 	movabs $0x80104a,%rax
  8019bc:	00 00 00 
  8019bf:	ff d0                	callq  *%rax
  8019c1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8019c4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8019c8:	79 05                	jns    8019cf <open+0x10d>
			{
				return d;
  8019ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019cd:	eb 18                	jmp    8019e7 <open+0x125>
			}
			return r;
  8019cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d2:	eb 13                	jmp    8019e7 <open+0x125>
		}	
		return fd2num(fd_store);
  8019d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019d8:	48 89 c7             	mov    %rax,%rdi
  8019db:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  8019e2:	00 00 00 
  8019e5:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8019e7:	c9                   	leaveq 
  8019e8:	c3                   	retq   

00000000008019e9 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019e9:	55                   	push   %rbp
  8019ea:	48 89 e5             	mov    %rsp,%rbp
  8019ed:	48 83 ec 10          	sub    $0x10,%rsp
  8019f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f9:	8b 50 0c             	mov    0xc(%rax),%edx
  8019fc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a03:	00 00 00 
  801a06:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801a08:	be 00 00 00 00       	mov    $0x0,%esi
  801a0d:	bf 06 00 00 00       	mov    $0x6,%edi
  801a12:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  801a19:	00 00 00 
  801a1c:	ff d0                	callq  *%rax
}
  801a1e:	c9                   	leaveq 
  801a1f:	c3                   	retq   

0000000000801a20 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a20:	55                   	push   %rbp
  801a21:	48 89 e5             	mov    %rsp,%rbp
  801a24:	48 83 ec 30          	sub    $0x30,%rsp
  801a28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  801a34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  801a3b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a40:	74 07                	je     801a49 <devfile_read+0x29>
  801a42:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801a47:	75 07                	jne    801a50 <devfile_read+0x30>
		return -E_INVAL;
  801a49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a4e:	eb 77                	jmp    801ac7 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a54:	8b 50 0c             	mov    0xc(%rax),%edx
  801a57:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a5e:	00 00 00 
  801a61:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801a63:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801a6a:	00 00 00 
  801a6d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a71:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  801a75:	be 00 00 00 00       	mov    $0x0,%esi
  801a7a:	bf 03 00 00 00       	mov    $0x3,%edi
  801a7f:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  801a86:	00 00 00 
  801a89:	ff d0                	callq  *%rax
  801a8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a92:	7f 05                	jg     801a99 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  801a94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a97:	eb 2e                	jmp    801ac7 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  801a99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9c:	48 63 d0             	movslq %eax,%rdx
  801a9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aa3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801aaa:	00 00 00 
  801aad:	48 89 c7             	mov    %rax,%rdi
  801ab0:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  801ab7:	00 00 00 
  801aba:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  801abc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ac0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  801ac4:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801ac7:	c9                   	leaveq 
  801ac8:	c3                   	retq   

0000000000801ac9 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ac9:	55                   	push   %rbp
  801aca:	48 89 e5             	mov    %rsp,%rbp
  801acd:	48 83 ec 30          	sub    $0x30,%rsp
  801ad1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ad5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801ad9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  801add:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  801ae4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ae9:	74 07                	je     801af2 <devfile_write+0x29>
  801aeb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801af0:	75 08                	jne    801afa <devfile_write+0x31>
		return r;
  801af2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af5:	e9 9a 00 00 00       	jmpq   801b94 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801afa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801afe:	8b 50 0c             	mov    0xc(%rax),%edx
  801b01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b08:	00 00 00 
  801b0b:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  801b0d:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  801b14:	00 
  801b15:	76 08                	jbe    801b1f <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  801b17:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  801b1e:	00 
	}
	fsipcbuf.write.req_n = n;
  801b1f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b26:	00 00 00 
  801b29:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b2d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  801b31:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b39:	48 89 c6             	mov    %rax,%rsi
  801b3c:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  801b43:	00 00 00 
  801b46:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  801b4d:	00 00 00 
  801b50:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  801b52:	be 00 00 00 00       	mov    $0x0,%esi
  801b57:	bf 04 00 00 00       	mov    $0x4,%edi
  801b5c:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  801b63:	00 00 00 
  801b66:	ff d0                	callq  *%rax
  801b68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b6f:	7f 20                	jg     801b91 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  801b71:	48 bf 1e 40 80 00 00 	movabs $0x80401e,%rdi
  801b78:	00 00 00 
  801b7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b80:	48 ba 99 31 80 00 00 	movabs $0x803199,%rdx
  801b87:	00 00 00 
  801b8a:	ff d2                	callq  *%rdx
		return r;
  801b8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8f:	eb 03                	jmp    801b94 <devfile_write+0xcb>
	}
	return r;
  801b91:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  801b94:	c9                   	leaveq 
  801b95:	c3                   	retq   

0000000000801b96 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b96:	55                   	push   %rbp
  801b97:	48 89 e5             	mov    %rsp,%rbp
  801b9a:	48 83 ec 20          	sub    $0x20,%rsp
  801b9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ba2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ba6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801baa:	8b 50 0c             	mov    0xc(%rax),%edx
  801bad:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801bb4:	00 00 00 
  801bb7:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bb9:	be 00 00 00 00       	mov    $0x0,%esi
  801bbe:	bf 05 00 00 00       	mov    $0x5,%edi
  801bc3:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  801bca:	00 00 00 
  801bcd:	ff d0                	callq  *%rax
  801bcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bd6:	79 05                	jns    801bdd <devfile_stat+0x47>
		return r;
  801bd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bdb:	eb 56                	jmp    801c33 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801be1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801be8:	00 00 00 
  801beb:	48 89 c7             	mov    %rax,%rdi
  801bee:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  801bf5:	00 00 00 
  801bf8:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801bfa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801c01:	00 00 00 
  801c04:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801c0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c0e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c14:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801c1b:	00 00 00 
  801c1e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801c24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c28:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801c2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c33:	c9                   	leaveq 
  801c34:	c3                   	retq   

0000000000801c35 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c35:	55                   	push   %rbp
  801c36:	48 89 e5             	mov    %rsp,%rbp
  801c39:	48 83 ec 10          	sub    $0x10,%rsp
  801c3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c41:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c48:	8b 50 0c             	mov    0xc(%rax),%edx
  801c4b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801c52:	00 00 00 
  801c55:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801c57:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801c5e:	00 00 00 
  801c61:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801c64:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c67:	be 00 00 00 00       	mov    $0x0,%esi
  801c6c:	bf 02 00 00 00       	mov    $0x2,%edi
  801c71:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  801c78:	00 00 00 
  801c7b:	ff d0                	callq  *%rax
}
  801c7d:	c9                   	leaveq 
  801c7e:	c3                   	retq   

0000000000801c7f <remove>:

// Delete a file
int
remove(const char *path)
{
  801c7f:	55                   	push   %rbp
  801c80:	48 89 e5             	mov    %rsp,%rbp
  801c83:	48 83 ec 10          	sub    $0x10,%rsp
  801c87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801c8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c8f:	48 89 c7             	mov    %rax,%rdi
  801c92:	48 b8 00 02 80 00 00 	movabs $0x800200,%rax
  801c99:	00 00 00 
  801c9c:	ff d0                	callq  *%rax
  801c9e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ca3:	7e 07                	jle    801cac <remove+0x2d>
		return -E_BAD_PATH;
  801ca5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801caa:	eb 33                	jmp    801cdf <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801cac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb0:	48 89 c6             	mov    %rax,%rsi
  801cb3:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801cba:	00 00 00 
  801cbd:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801cc9:	be 00 00 00 00       	mov    $0x0,%esi
  801cce:	bf 07 00 00 00       	mov    $0x7,%edi
  801cd3:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  801cda:	00 00 00 
  801cdd:	ff d0                	callq  *%rax
}
  801cdf:	c9                   	leaveq 
  801ce0:	c3                   	retq   

0000000000801ce1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801ce1:	55                   	push   %rbp
  801ce2:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ce5:	be 00 00 00 00       	mov    $0x0,%esi
  801cea:	bf 08 00 00 00       	mov    $0x8,%edi
  801cef:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  801cf6:	00 00 00 
  801cf9:	ff d0                	callq  *%rax
}
  801cfb:	5d                   	pop    %rbp
  801cfc:	c3                   	retq   

0000000000801cfd <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801cfd:	55                   	push   %rbp
  801cfe:	48 89 e5             	mov    %rsp,%rbp
  801d01:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801d08:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801d0f:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801d16:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801d1d:	be 00 00 00 00       	mov    $0x0,%esi
  801d22:	48 89 c7             	mov    %rax,%rdi
  801d25:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  801d2c:	00 00 00 
  801d2f:	ff d0                	callq  *%rax
  801d31:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801d34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d38:	79 28                	jns    801d62 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801d3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3d:	89 c6                	mov    %eax,%esi
  801d3f:	48 bf 3a 40 80 00 00 	movabs $0x80403a,%rdi
  801d46:	00 00 00 
  801d49:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4e:	48 ba 99 31 80 00 00 	movabs $0x803199,%rdx
  801d55:	00 00 00 
  801d58:	ff d2                	callq  *%rdx
		return fd_src;
  801d5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d5d:	e9 74 01 00 00       	jmpq   801ed6 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801d62:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801d69:	be 01 01 00 00       	mov    $0x101,%esi
  801d6e:	48 89 c7             	mov    %rax,%rdi
  801d71:	48 b8 c2 18 80 00 00 	movabs $0x8018c2,%rax
  801d78:	00 00 00 
  801d7b:	ff d0                	callq  *%rax
  801d7d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801d80:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801d84:	79 39                	jns    801dbf <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801d86:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d89:	89 c6                	mov    %eax,%esi
  801d8b:	48 bf 50 40 80 00 00 	movabs $0x804050,%rdi
  801d92:	00 00 00 
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9a:	48 ba 99 31 80 00 00 	movabs $0x803199,%rdx
  801da1:	00 00 00 
  801da4:	ff d2                	callq  *%rdx
		close(fd_src);
  801da6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801da9:	89 c7                	mov    %eax,%edi
  801dab:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801db2:	00 00 00 
  801db5:	ff d0                	callq  *%rax
		return fd_dest;
  801db7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dba:	e9 17 01 00 00       	jmpq   801ed6 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801dbf:	eb 74                	jmp    801e35 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801dc1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dc4:	48 63 d0             	movslq %eax,%rdx
  801dc7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801dce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dd1:	48 89 ce             	mov    %rcx,%rsi
  801dd4:	89 c7                	mov    %eax,%edi
  801dd6:	48 b8 36 15 80 00 00 	movabs $0x801536,%rax
  801ddd:	00 00 00 
  801de0:	ff d0                	callq  *%rax
  801de2:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801de5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801de9:	79 4a                	jns    801e35 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  801deb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801dee:	89 c6                	mov    %eax,%esi
  801df0:	48 bf 6a 40 80 00 00 	movabs $0x80406a,%rdi
  801df7:	00 00 00 
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801dff:	48 ba 99 31 80 00 00 	movabs $0x803199,%rdx
  801e06:	00 00 00 
  801e09:	ff d2                	callq  *%rdx
			close(fd_src);
  801e0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e0e:	89 c7                	mov    %eax,%edi
  801e10:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801e17:	00 00 00 
  801e1a:	ff d0                	callq  *%rax
			close(fd_dest);
  801e1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e1f:	89 c7                	mov    %eax,%edi
  801e21:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801e28:	00 00 00 
  801e2b:	ff d0                	callq  *%rax
			return write_size;
  801e2d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801e30:	e9 a1 00 00 00       	jmpq   801ed6 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801e35:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801e3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e3f:	ba 00 02 00 00       	mov    $0x200,%edx
  801e44:	48 89 ce             	mov    %rcx,%rsi
  801e47:	89 c7                	mov    %eax,%edi
  801e49:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  801e50:	00 00 00 
  801e53:	ff d0                	callq  *%rax
  801e55:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801e58:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e5c:	0f 8f 5f ff ff ff    	jg     801dc1 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  801e62:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801e66:	79 47                	jns    801eaf <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801e68:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e6b:	89 c6                	mov    %eax,%esi
  801e6d:	48 bf 7d 40 80 00 00 	movabs $0x80407d,%rdi
  801e74:	00 00 00 
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7c:	48 ba 99 31 80 00 00 	movabs $0x803199,%rdx
  801e83:	00 00 00 
  801e86:	ff d2                	callq  *%rdx
		close(fd_src);
  801e88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8b:	89 c7                	mov    %eax,%edi
  801e8d:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801e94:	00 00 00 
  801e97:	ff d0                	callq  *%rax
		close(fd_dest);
  801e99:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e9c:	89 c7                	mov    %eax,%edi
  801e9e:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801ea5:	00 00 00 
  801ea8:	ff d0                	callq  *%rax
		return read_size;
  801eaa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ead:	eb 27                	jmp    801ed6 <copy+0x1d9>
	}
	close(fd_src);
  801eaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb2:	89 c7                	mov    %eax,%edi
  801eb4:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801ebb:	00 00 00 
  801ebe:	ff d0                	callq  *%rax
	close(fd_dest);
  801ec0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ec3:	89 c7                	mov    %eax,%edi
  801ec5:	48 b8 ca 11 80 00 00 	movabs $0x8011ca,%rax
  801ecc:	00 00 00 
  801ecf:	ff d0                	callq  *%rax
	return 0;
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801ed6:	c9                   	leaveq 
  801ed7:	c3                   	retq   

0000000000801ed8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ed8:	55                   	push   %rbp
  801ed9:	48 89 e5             	mov    %rsp,%rbp
  801edc:	48 83 ec 20          	sub    $0x20,%rsp
  801ee0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ee3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ee7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801eea:	48 89 d6             	mov    %rdx,%rsi
  801eed:	89 c7                	mov    %eax,%edi
  801eef:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  801ef6:	00 00 00 
  801ef9:	ff d0                	callq  *%rax
  801efb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801efe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f02:	79 05                	jns    801f09 <fd2sockid+0x31>
		return r;
  801f04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f07:	eb 24                	jmp    801f2d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0d:	8b 10                	mov    (%rax),%edx
  801f0f:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  801f16:	00 00 00 
  801f19:	8b 00                	mov    (%rax),%eax
  801f1b:	39 c2                	cmp    %eax,%edx
  801f1d:	74 07                	je     801f26 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801f1f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801f24:	eb 07                	jmp    801f2d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  801f26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f2a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  801f2d:	c9                   	leaveq 
  801f2e:	c3                   	retq   

0000000000801f2f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f2f:	55                   	push   %rbp
  801f30:	48 89 e5             	mov    %rsp,%rbp
  801f33:	48 83 ec 20          	sub    $0x20,%rsp
  801f37:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f3a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801f3e:	48 89 c7             	mov    %rax,%rdi
  801f41:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  801f48:	00 00 00 
  801f4b:	ff d0                	callq  *%rax
  801f4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f54:	78 26                	js     801f7c <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f5a:	ba 07 04 00 00       	mov    $0x407,%edx
  801f5f:	48 89 c6             	mov    %rax,%rsi
  801f62:	bf 00 00 00 00       	mov    $0x0,%edi
  801f67:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  801f6e:	00 00 00 
  801f71:	ff d0                	callq  *%rax
  801f73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f7a:	79 16                	jns    801f92 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  801f7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f7f:	89 c7                	mov    %eax,%edi
  801f81:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  801f88:	00 00 00 
  801f8b:	ff d0                	callq  *%rax
		return r;
  801f8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f90:	eb 3a                	jmp    801fcc <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f96:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  801f9d:	00 00 00 
  801fa0:	8b 12                	mov    (%rdx),%edx
  801fa2:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  801fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  801faf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fb6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801fb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fbd:	48 89 c7             	mov    %rax,%rdi
  801fc0:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  801fc7:	00 00 00 
  801fca:	ff d0                	callq  *%rax
}
  801fcc:	c9                   	leaveq 
  801fcd:	c3                   	retq   

0000000000801fce <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fce:	55                   	push   %rbp
  801fcf:	48 89 e5             	mov    %rsp,%rbp
  801fd2:	48 83 ec 30          	sub    $0x30,%rsp
  801fd6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fd9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fdd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fe1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fe4:	89 c7                	mov    %eax,%edi
  801fe6:	48 b8 d8 1e 80 00 00 	movabs $0x801ed8,%rax
  801fed:	00 00 00 
  801ff0:	ff d0                	callq  *%rax
  801ff2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ff5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ff9:	79 05                	jns    802000 <accept+0x32>
		return r;
  801ffb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ffe:	eb 3b                	jmp    80203b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802000:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802004:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802008:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200b:	48 89 ce             	mov    %rcx,%rsi
  80200e:	89 c7                	mov    %eax,%edi
  802010:	48 b8 19 23 80 00 00 	movabs $0x802319,%rax
  802017:	00 00 00 
  80201a:	ff d0                	callq  *%rax
  80201c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80201f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802023:	79 05                	jns    80202a <accept+0x5c>
		return r;
  802025:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802028:	eb 11                	jmp    80203b <accept+0x6d>
	return alloc_sockfd(r);
  80202a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80202d:	89 c7                	mov    %eax,%edi
  80202f:	48 b8 2f 1f 80 00 00 	movabs $0x801f2f,%rax
  802036:	00 00 00 
  802039:	ff d0                	callq  *%rax
}
  80203b:	c9                   	leaveq 
  80203c:	c3                   	retq   

000000000080203d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80203d:	55                   	push   %rbp
  80203e:	48 89 e5             	mov    %rsp,%rbp
  802041:	48 83 ec 20          	sub    $0x20,%rsp
  802045:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802048:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80204c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80204f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802052:	89 c7                	mov    %eax,%edi
  802054:	48 b8 d8 1e 80 00 00 	movabs $0x801ed8,%rax
  80205b:	00 00 00 
  80205e:	ff d0                	callq  *%rax
  802060:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802063:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802067:	79 05                	jns    80206e <bind+0x31>
		return r;
  802069:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206c:	eb 1b                	jmp    802089 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80206e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802071:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802075:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802078:	48 89 ce             	mov    %rcx,%rsi
  80207b:	89 c7                	mov    %eax,%edi
  80207d:	48 b8 98 23 80 00 00 	movabs $0x802398,%rax
  802084:	00 00 00 
  802087:	ff d0                	callq  *%rax
}
  802089:	c9                   	leaveq 
  80208a:	c3                   	retq   

000000000080208b <shutdown>:

int
shutdown(int s, int how)
{
  80208b:	55                   	push   %rbp
  80208c:	48 89 e5             	mov    %rsp,%rbp
  80208f:	48 83 ec 20          	sub    $0x20,%rsp
  802093:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802096:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802099:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80209c:	89 c7                	mov    %eax,%edi
  80209e:	48 b8 d8 1e 80 00 00 	movabs $0x801ed8,%rax
  8020a5:	00 00 00 
  8020a8:	ff d0                	callq  *%rax
  8020aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020b1:	79 05                	jns    8020b8 <shutdown+0x2d>
		return r;
  8020b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b6:	eb 16                	jmp    8020ce <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8020b8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8020bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020be:	89 d6                	mov    %edx,%esi
  8020c0:	89 c7                	mov    %eax,%edi
  8020c2:	48 b8 fc 23 80 00 00 	movabs $0x8023fc,%rax
  8020c9:	00 00 00 
  8020cc:	ff d0                	callq  *%rax
}
  8020ce:	c9                   	leaveq 
  8020cf:	c3                   	retq   

00000000008020d0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8020d0:	55                   	push   %rbp
  8020d1:	48 89 e5             	mov    %rsp,%rbp
  8020d4:	48 83 ec 10          	sub    $0x10,%rsp
  8020d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8020dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020e0:	48 89 c7             	mov    %rax,%rdi
  8020e3:	48 b8 cc 3e 80 00 00 	movabs $0x803ecc,%rax
  8020ea:	00 00 00 
  8020ed:	ff d0                	callq  *%rax
  8020ef:	83 f8 01             	cmp    $0x1,%eax
  8020f2:	75 17                	jne    80210b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8020f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020f8:	8b 40 0c             	mov    0xc(%rax),%eax
  8020fb:	89 c7                	mov    %eax,%edi
  8020fd:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  802104:	00 00 00 
  802107:	ff d0                	callq  *%rax
  802109:	eb 05                	jmp    802110 <devsock_close+0x40>
	else
		return 0;
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802110:	c9                   	leaveq 
  802111:	c3                   	retq   

0000000000802112 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802112:	55                   	push   %rbp
  802113:	48 89 e5             	mov    %rsp,%rbp
  802116:	48 83 ec 20          	sub    $0x20,%rsp
  80211a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80211d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802121:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802124:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802127:	89 c7                	mov    %eax,%edi
  802129:	48 b8 d8 1e 80 00 00 	movabs $0x801ed8,%rax
  802130:	00 00 00 
  802133:	ff d0                	callq  *%rax
  802135:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802138:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80213c:	79 05                	jns    802143 <connect+0x31>
		return r;
  80213e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802141:	eb 1b                	jmp    80215e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802143:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802146:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80214a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214d:	48 89 ce             	mov    %rcx,%rsi
  802150:	89 c7                	mov    %eax,%edi
  802152:	48 b8 69 24 80 00 00 	movabs $0x802469,%rax
  802159:	00 00 00 
  80215c:	ff d0                	callq  *%rax
}
  80215e:	c9                   	leaveq 
  80215f:	c3                   	retq   

0000000000802160 <listen>:

int
listen(int s, int backlog)
{
  802160:	55                   	push   %rbp
  802161:	48 89 e5             	mov    %rsp,%rbp
  802164:	48 83 ec 20          	sub    $0x20,%rsp
  802168:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80216b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80216e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802171:	89 c7                	mov    %eax,%edi
  802173:	48 b8 d8 1e 80 00 00 	movabs $0x801ed8,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	callq  *%rax
  80217f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802182:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802186:	79 05                	jns    80218d <listen+0x2d>
		return r;
  802188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80218b:	eb 16                	jmp    8021a3 <listen+0x43>
	return nsipc_listen(r, backlog);
  80218d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802190:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802193:	89 d6                	mov    %edx,%esi
  802195:	89 c7                	mov    %eax,%edi
  802197:	48 b8 cd 24 80 00 00 	movabs $0x8024cd,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	callq  *%rax
}
  8021a3:	c9                   	leaveq 
  8021a4:	c3                   	retq   

00000000008021a5 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8021a5:	55                   	push   %rbp
  8021a6:	48 89 e5             	mov    %rsp,%rbp
  8021a9:	48 83 ec 20          	sub    $0x20,%rsp
  8021ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8021b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8021b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bd:	89 c2                	mov    %eax,%edx
  8021bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021c3:	8b 40 0c             	mov    0xc(%rax),%eax
  8021c6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8021ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021cf:	89 c7                	mov    %eax,%edi
  8021d1:	48 b8 0d 25 80 00 00 	movabs $0x80250d,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
}
  8021dd:	c9                   	leaveq 
  8021de:	c3                   	retq   

00000000008021df <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8021df:	55                   	push   %rbp
  8021e0:	48 89 e5             	mov    %rsp,%rbp
  8021e3:	48 83 ec 20          	sub    $0x20,%rsp
  8021e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8021eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8021f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f7:	89 c2                	mov    %eax,%edx
  8021f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021fd:	8b 40 0c             	mov    0xc(%rax),%eax
  802200:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802204:	b9 00 00 00 00       	mov    $0x0,%ecx
  802209:	89 c7                	mov    %eax,%edi
  80220b:	48 b8 d9 25 80 00 00 	movabs $0x8025d9,%rax
  802212:	00 00 00 
  802215:	ff d0                	callq  *%rax
}
  802217:	c9                   	leaveq 
  802218:	c3                   	retq   

0000000000802219 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802219:	55                   	push   %rbp
  80221a:	48 89 e5             	mov    %rsp,%rbp
  80221d:	48 83 ec 10          	sub    $0x10,%rsp
  802221:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802225:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222d:	48 be 98 40 80 00 00 	movabs $0x804098,%rsi
  802234:	00 00 00 
  802237:	48 89 c7             	mov    %rax,%rdi
  80223a:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  802241:	00 00 00 
  802244:	ff d0                	callq  *%rax
	return 0;
  802246:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224b:	c9                   	leaveq 
  80224c:	c3                   	retq   

000000000080224d <socket>:

int
socket(int domain, int type, int protocol)
{
  80224d:	55                   	push   %rbp
  80224e:	48 89 e5             	mov    %rsp,%rbp
  802251:	48 83 ec 20          	sub    $0x20,%rsp
  802255:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802258:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80225b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80225e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802261:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802264:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802267:	89 ce                	mov    %ecx,%esi
  802269:	89 c7                	mov    %eax,%edi
  80226b:	48 b8 91 26 80 00 00 	movabs $0x802691,%rax
  802272:	00 00 00 
  802275:	ff d0                	callq  *%rax
  802277:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80227a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227e:	79 05                	jns    802285 <socket+0x38>
		return r;
  802280:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802283:	eb 11                	jmp    802296 <socket+0x49>
	return alloc_sockfd(r);
  802285:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802288:	89 c7                	mov    %eax,%edi
  80228a:	48 b8 2f 1f 80 00 00 	movabs $0x801f2f,%rax
  802291:	00 00 00 
  802294:	ff d0                	callq  *%rax
}
  802296:	c9                   	leaveq 
  802297:	c3                   	retq   

0000000000802298 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802298:	55                   	push   %rbp
  802299:	48 89 e5             	mov    %rsp,%rbp
  80229c:	48 83 ec 10          	sub    $0x10,%rsp
  8022a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8022a3:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8022aa:	00 00 00 
  8022ad:	8b 00                	mov    (%rax),%eax
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	75 1d                	jne    8022d0 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022b3:	bf 02 00 00 00       	mov    $0x2,%edi
  8022b8:	48 b8 4a 3e 80 00 00 	movabs $0x803e4a,%rax
  8022bf:	00 00 00 
  8022c2:	ff d0                	callq  *%rax
  8022c4:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  8022cb:	00 00 00 
  8022ce:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022d0:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8022d7:	00 00 00 
  8022da:	8b 00                	mov    (%rax),%eax
  8022dc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8022df:	b9 07 00 00 00       	mov    $0x7,%ecx
  8022e4:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8022eb:	00 00 00 
  8022ee:	89 c7                	mov    %eax,%edi
  8022f0:	48 b8 e8 3d 80 00 00 	movabs $0x803de8,%rax
  8022f7:	00 00 00 
  8022fa:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8022fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802301:	be 00 00 00 00       	mov    $0x0,%esi
  802306:	bf 00 00 00 00       	mov    $0x0,%edi
  80230b:	48 b8 e2 3c 80 00 00 	movabs $0x803ce2,%rax
  802312:	00 00 00 
  802315:	ff d0                	callq  *%rax
}
  802317:	c9                   	leaveq 
  802318:	c3                   	retq   

0000000000802319 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802319:	55                   	push   %rbp
  80231a:	48 89 e5             	mov    %rsp,%rbp
  80231d:	48 83 ec 30          	sub    $0x30,%rsp
  802321:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802324:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802328:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80232c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802333:	00 00 00 
  802336:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802339:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80233b:	bf 01 00 00 00       	mov    $0x1,%edi
  802340:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  802347:	00 00 00 
  80234a:	ff d0                	callq  *%rax
  80234c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802353:	78 3e                	js     802393 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802355:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80235c:	00 00 00 
  80235f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802363:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802367:	8b 40 10             	mov    0x10(%rax),%eax
  80236a:	89 c2                	mov    %eax,%edx
  80236c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802370:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802374:	48 89 ce             	mov    %rcx,%rsi
  802377:	48 89 c7             	mov    %rax,%rdi
  80237a:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  802381:	00 00 00 
  802384:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238a:	8b 50 10             	mov    0x10(%rax),%edx
  80238d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802391:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802393:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802396:	c9                   	leaveq 
  802397:	c3                   	retq   

0000000000802398 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802398:	55                   	push   %rbp
  802399:	48 89 e5             	mov    %rsp,%rbp
  80239c:	48 83 ec 10          	sub    $0x10,%rsp
  8023a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023a7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8023aa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8023b1:	00 00 00 
  8023b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023b7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8023b9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8023bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c0:	48 89 c6             	mov    %rax,%rsi
  8023c3:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8023ca:	00 00 00 
  8023cd:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8023d4:	00 00 00 
  8023d7:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8023d9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8023e0:	00 00 00 
  8023e3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8023e6:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8023e9:	bf 02 00 00 00       	mov    $0x2,%edi
  8023ee:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  8023f5:	00 00 00 
  8023f8:	ff d0                	callq  *%rax
}
  8023fa:	c9                   	leaveq 
  8023fb:	c3                   	retq   

00000000008023fc <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8023fc:	55                   	push   %rbp
  8023fd:	48 89 e5             	mov    %rsp,%rbp
  802400:	48 83 ec 10          	sub    $0x10,%rsp
  802404:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802407:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80240a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802411:	00 00 00 
  802414:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802417:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802419:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802420:	00 00 00 
  802423:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802426:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802429:	bf 03 00 00 00       	mov    $0x3,%edi
  80242e:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  802435:	00 00 00 
  802438:	ff d0                	callq  *%rax
}
  80243a:	c9                   	leaveq 
  80243b:	c3                   	retq   

000000000080243c <nsipc_close>:

int
nsipc_close(int s)
{
  80243c:	55                   	push   %rbp
  80243d:	48 89 e5             	mov    %rsp,%rbp
  802440:	48 83 ec 10          	sub    $0x10,%rsp
  802444:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802447:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80244e:	00 00 00 
  802451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802454:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802456:	bf 04 00 00 00       	mov    $0x4,%edi
  80245b:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  802462:	00 00 00 
  802465:	ff d0                	callq  *%rax
}
  802467:	c9                   	leaveq 
  802468:	c3                   	retq   

0000000000802469 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802469:	55                   	push   %rbp
  80246a:	48 89 e5             	mov    %rsp,%rbp
  80246d:	48 83 ec 10          	sub    $0x10,%rsp
  802471:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802474:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802478:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80247b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802482:	00 00 00 
  802485:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802488:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80248a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80248d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802491:	48 89 c6             	mov    %rax,%rsi
  802494:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80249b:	00 00 00 
  80249e:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8024a5:	00 00 00 
  8024a8:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8024aa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8024b1:	00 00 00 
  8024b4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8024b7:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8024ba:	bf 05 00 00 00       	mov    $0x5,%edi
  8024bf:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  8024c6:	00 00 00 
  8024c9:	ff d0                	callq  *%rax
}
  8024cb:	c9                   	leaveq 
  8024cc:	c3                   	retq   

00000000008024cd <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8024cd:	55                   	push   %rbp
  8024ce:	48 89 e5             	mov    %rsp,%rbp
  8024d1:	48 83 ec 10          	sub    $0x10,%rsp
  8024d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024d8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8024db:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8024e2:	00 00 00 
  8024e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024e8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8024ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8024f1:	00 00 00 
  8024f4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8024f7:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8024fa:	bf 06 00 00 00       	mov    $0x6,%edi
  8024ff:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  802506:	00 00 00 
  802509:	ff d0                	callq  *%rax
}
  80250b:	c9                   	leaveq 
  80250c:	c3                   	retq   

000000000080250d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80250d:	55                   	push   %rbp
  80250e:	48 89 e5             	mov    %rsp,%rbp
  802511:	48 83 ec 30          	sub    $0x30,%rsp
  802515:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802518:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80251c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80251f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802522:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802529:	00 00 00 
  80252c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80252f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802531:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802538:	00 00 00 
  80253b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80253e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802541:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802548:	00 00 00 
  80254b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80254e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802551:	bf 07 00 00 00       	mov    $0x7,%edi
  802556:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  80255d:	00 00 00 
  802560:	ff d0                	callq  *%rax
  802562:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802565:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802569:	78 69                	js     8025d4 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80256b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802572:	7f 08                	jg     80257c <nsipc_recv+0x6f>
  802574:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802577:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80257a:	7e 35                	jle    8025b1 <nsipc_recv+0xa4>
  80257c:	48 b9 9f 40 80 00 00 	movabs $0x80409f,%rcx
  802583:	00 00 00 
  802586:	48 ba b4 40 80 00 00 	movabs $0x8040b4,%rdx
  80258d:	00 00 00 
  802590:	be 61 00 00 00       	mov    $0x61,%esi
  802595:	48 bf c9 40 80 00 00 	movabs $0x8040c9,%rdi
  80259c:	00 00 00 
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a4:	49 b8 60 2f 80 00 00 	movabs $0x802f60,%r8
  8025ab:	00 00 00 
  8025ae:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8025b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b4:	48 63 d0             	movslq %eax,%rdx
  8025b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025bb:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8025c2:	00 00 00 
  8025c5:	48 89 c7             	mov    %rax,%rdi
  8025c8:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8025cf:	00 00 00 
  8025d2:	ff d0                	callq  *%rax
	}

	return r;
  8025d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025d7:	c9                   	leaveq 
  8025d8:	c3                   	retq   

00000000008025d9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8025d9:	55                   	push   %rbp
  8025da:	48 89 e5             	mov    %rsp,%rbp
  8025dd:	48 83 ec 20          	sub    $0x20,%rsp
  8025e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025e8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8025eb:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8025ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8025f5:	00 00 00 
  8025f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025fb:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8025fd:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  802604:	7e 35                	jle    80263b <nsipc_send+0x62>
  802606:	48 b9 d5 40 80 00 00 	movabs $0x8040d5,%rcx
  80260d:	00 00 00 
  802610:	48 ba b4 40 80 00 00 	movabs $0x8040b4,%rdx
  802617:	00 00 00 
  80261a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80261f:	48 bf c9 40 80 00 00 	movabs $0x8040c9,%rdi
  802626:	00 00 00 
  802629:	b8 00 00 00 00       	mov    $0x0,%eax
  80262e:	49 b8 60 2f 80 00 00 	movabs $0x802f60,%r8
  802635:	00 00 00 
  802638:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80263b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80263e:	48 63 d0             	movslq %eax,%rdx
  802641:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802645:	48 89 c6             	mov    %rax,%rsi
  802648:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80264f:	00 00 00 
  802652:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  802659:	00 00 00 
  80265c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80265e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802665:	00 00 00 
  802668:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80266b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80266e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802675:	00 00 00 
  802678:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80267b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80267e:	bf 08 00 00 00       	mov    $0x8,%edi
  802683:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  80268a:	00 00 00 
  80268d:	ff d0                	callq  *%rax
}
  80268f:	c9                   	leaveq 
  802690:	c3                   	retq   

0000000000802691 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802691:	55                   	push   %rbp
  802692:	48 89 e5             	mov    %rsp,%rbp
  802695:	48 83 ec 10          	sub    $0x10,%rsp
  802699:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80269c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80269f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8026a2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8026a9:	00 00 00 
  8026ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026af:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8026b1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8026b8:	00 00 00 
  8026bb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8026be:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8026c1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8026c8:	00 00 00 
  8026cb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8026ce:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8026d1:	bf 09 00 00 00       	mov    $0x9,%edi
  8026d6:	48 b8 98 22 80 00 00 	movabs $0x802298,%rax
  8026dd:	00 00 00 
  8026e0:	ff d0                	callq  *%rax
}
  8026e2:	c9                   	leaveq 
  8026e3:	c3                   	retq   

00000000008026e4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8026e4:	55                   	push   %rbp
  8026e5:	48 89 e5             	mov    %rsp,%rbp
  8026e8:	53                   	push   %rbx
  8026e9:	48 83 ec 38          	sub    $0x38,%rsp
  8026ed:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026f1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8026f5:	48 89 c7             	mov    %rax,%rdi
  8026f8:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  8026ff:	00 00 00 
  802702:	ff d0                	callq  *%rax
  802704:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802707:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80270b:	0f 88 bf 01 00 00    	js     8028d0 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802711:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802715:	ba 07 04 00 00       	mov    $0x407,%edx
  80271a:	48 89 c6             	mov    %rax,%rsi
  80271d:	bf 00 00 00 00       	mov    $0x0,%edi
  802722:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  802729:	00 00 00 
  80272c:	ff d0                	callq  *%rax
  80272e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802731:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802735:	0f 88 95 01 00 00    	js     8028d0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80273b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80273f:	48 89 c7             	mov    %rax,%rdi
  802742:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  802749:	00 00 00 
  80274c:	ff d0                	callq  *%rax
  80274e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802751:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802755:	0f 88 5d 01 00 00    	js     8028b8 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80275b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80275f:	ba 07 04 00 00       	mov    $0x407,%edx
  802764:	48 89 c6             	mov    %rax,%rsi
  802767:	bf 00 00 00 00       	mov    $0x0,%edi
  80276c:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  802773:	00 00 00 
  802776:	ff d0                	callq  *%rax
  802778:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80277b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80277f:	0f 88 33 01 00 00    	js     8028b8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802789:	48 89 c7             	mov    %rax,%rdi
  80278c:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  802793:	00 00 00 
  802796:	ff d0                	callq  *%rax
  802798:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80279c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027a0:	ba 07 04 00 00       	mov    $0x407,%edx
  8027a5:	48 89 c6             	mov    %rax,%rsi
  8027a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ad:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  8027b4:	00 00 00 
  8027b7:	ff d0                	callq  *%rax
  8027b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027c0:	79 05                	jns    8027c7 <pipe+0xe3>
		goto err2;
  8027c2:	e9 d9 00 00 00       	jmpq   8028a0 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027cb:	48 89 c7             	mov    %rax,%rdi
  8027ce:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  8027d5:	00 00 00 
  8027d8:	ff d0                	callq  *%rax
  8027da:	48 89 c2             	mov    %rax,%rdx
  8027dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027e1:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8027e7:	48 89 d1             	mov    %rdx,%rcx
  8027ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ef:	48 89 c6             	mov    %rax,%rsi
  8027f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f7:	48 b8 eb 0b 80 00 00 	movabs $0x800beb,%rax
  8027fe:	00 00 00 
  802801:	ff d0                	callq  *%rax
  802803:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802806:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80280a:	79 1b                	jns    802827 <pipe+0x143>
		goto err3;
  80280c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80280d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802811:	48 89 c6             	mov    %rax,%rsi
  802814:	bf 00 00 00 00       	mov    $0x0,%edi
  802819:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  802820:	00 00 00 
  802823:	ff d0                	callq  *%rax
  802825:	eb 79                	jmp    8028a0 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802827:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80282b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802832:	00 00 00 
  802835:	8b 12                	mov    (%rdx),%edx
  802837:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80283d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802844:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802848:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80284f:	00 00 00 
  802852:	8b 12                	mov    (%rdx),%edx
  802854:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802856:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80285a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802865:	48 89 c7             	mov    %rax,%rdi
  802868:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  80286f:	00 00 00 
  802872:	ff d0                	callq  *%rax
  802874:	89 c2                	mov    %eax,%edx
  802876:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80287a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80287c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802880:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802884:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802888:	48 89 c7             	mov    %rax,%rdi
  80288b:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
  802897:	89 03                	mov    %eax,(%rbx)
	return 0;
  802899:	b8 00 00 00 00       	mov    $0x0,%eax
  80289e:	eb 33                	jmp    8028d3 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8028a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028a4:	48 89 c6             	mov    %rax,%rsi
  8028a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ac:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  8028b3:	00 00 00 
  8028b6:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8028b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028bc:	48 89 c6             	mov    %rax,%rsi
  8028bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8028c4:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  8028cb:	00 00 00 
  8028ce:	ff d0                	callq  *%rax
err:
	return r;
  8028d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8028d3:	48 83 c4 38          	add    $0x38,%rsp
  8028d7:	5b                   	pop    %rbx
  8028d8:	5d                   	pop    %rbp
  8028d9:	c3                   	retq   

00000000008028da <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8028da:	55                   	push   %rbp
  8028db:	48 89 e5             	mov    %rsp,%rbp
  8028de:	53                   	push   %rbx
  8028df:	48 83 ec 28          	sub    $0x28,%rsp
  8028e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8028e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8028eb:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028f2:	00 00 00 
  8028f5:	48 8b 00             	mov    (%rax),%rax
  8028f8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8028fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802901:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802905:	48 89 c7             	mov    %rax,%rdi
  802908:	48 b8 cc 3e 80 00 00 	movabs $0x803ecc,%rax
  80290f:	00 00 00 
  802912:	ff d0                	callq  *%rax
  802914:	89 c3                	mov    %eax,%ebx
  802916:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80291a:	48 89 c7             	mov    %rax,%rdi
  80291d:	48 b8 cc 3e 80 00 00 	movabs $0x803ecc,%rax
  802924:	00 00 00 
  802927:	ff d0                	callq  *%rax
  802929:	39 c3                	cmp    %eax,%ebx
  80292b:	0f 94 c0             	sete   %al
  80292e:	0f b6 c0             	movzbl %al,%eax
  802931:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802934:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80293b:	00 00 00 
  80293e:	48 8b 00             	mov    (%rax),%rax
  802941:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802947:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80294a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80294d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802950:	75 05                	jne    802957 <_pipeisclosed+0x7d>
			return ret;
  802952:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802955:	eb 4f                	jmp    8029a6 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802957:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80295a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80295d:	74 42                	je     8029a1 <_pipeisclosed+0xc7>
  80295f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802963:	75 3c                	jne    8029a1 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802965:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80296c:	00 00 00 
  80296f:	48 8b 00             	mov    (%rax),%rax
  802972:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802978:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80297b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80297e:	89 c6                	mov    %eax,%esi
  802980:	48 bf e6 40 80 00 00 	movabs $0x8040e6,%rdi
  802987:	00 00 00 
  80298a:	b8 00 00 00 00       	mov    $0x0,%eax
  80298f:	49 b8 99 31 80 00 00 	movabs $0x803199,%r8
  802996:	00 00 00 
  802999:	41 ff d0             	callq  *%r8
	}
  80299c:	e9 4a ff ff ff       	jmpq   8028eb <_pipeisclosed+0x11>
  8029a1:	e9 45 ff ff ff       	jmpq   8028eb <_pipeisclosed+0x11>
}
  8029a6:	48 83 c4 28          	add    $0x28,%rsp
  8029aa:	5b                   	pop    %rbx
  8029ab:	5d                   	pop    %rbp
  8029ac:	c3                   	retq   

00000000008029ad <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8029ad:	55                   	push   %rbp
  8029ae:	48 89 e5             	mov    %rsp,%rbp
  8029b1:	48 83 ec 30          	sub    $0x30,%rsp
  8029b5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029b8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029bf:	48 89 d6             	mov    %rdx,%rsi
  8029c2:	89 c7                	mov    %eax,%edi
  8029c4:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
  8029d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d7:	79 05                	jns    8029de <pipeisclosed+0x31>
		return r;
  8029d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029dc:	eb 31                	jmp    802a0f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8029de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e2:	48 89 c7             	mov    %rax,%rdi
  8029e5:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax
  8029f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8029f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029fd:	48 89 d6             	mov    %rdx,%rsi
  802a00:	48 89 c7             	mov    %rax,%rdi
  802a03:	48 b8 da 28 80 00 00 	movabs $0x8028da,%rax
  802a0a:	00 00 00 
  802a0d:	ff d0                	callq  *%rax
}
  802a0f:	c9                   	leaveq 
  802a10:	c3                   	retq   

0000000000802a11 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a11:	55                   	push   %rbp
  802a12:	48 89 e5             	mov    %rsp,%rbp
  802a15:	48 83 ec 40          	sub    $0x40,%rsp
  802a19:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802a1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a21:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802a25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a29:	48 89 c7             	mov    %rax,%rdi
  802a2c:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  802a33:	00 00 00 
  802a36:	ff d0                	callq  *%rax
  802a38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802a3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802a44:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802a4b:	00 
  802a4c:	e9 92 00 00 00       	jmpq   802ae3 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802a51:	eb 41                	jmp    802a94 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802a53:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802a58:	74 09                	je     802a63 <devpipe_read+0x52>
				return i;
  802a5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a5e:	e9 92 00 00 00       	jmpq   802af5 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802a63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a6b:	48 89 d6             	mov    %rdx,%rsi
  802a6e:	48 89 c7             	mov    %rax,%rdi
  802a71:	48 b8 da 28 80 00 00 	movabs $0x8028da,%rax
  802a78:	00 00 00 
  802a7b:	ff d0                	callq  *%rax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 07                	je     802a88 <devpipe_read+0x77>
				return 0;
  802a81:	b8 00 00 00 00       	mov    $0x0,%eax
  802a86:	eb 6d                	jmp    802af5 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802a88:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  802a8f:	00 00 00 
  802a92:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802a94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a98:	8b 10                	mov    (%rax),%edx
  802a9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9e:	8b 40 04             	mov    0x4(%rax),%eax
  802aa1:	39 c2                	cmp    %eax,%edx
  802aa3:	74 ae                	je     802a53 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802aa5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aa9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802aad:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802ab1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab5:	8b 00                	mov    (%rax),%eax
  802ab7:	99                   	cltd   
  802ab8:	c1 ea 1b             	shr    $0x1b,%edx
  802abb:	01 d0                	add    %edx,%eax
  802abd:	83 e0 1f             	and    $0x1f,%eax
  802ac0:	29 d0                	sub    %edx,%eax
  802ac2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ac6:	48 98                	cltq   
  802ac8:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802acd:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802acf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad3:	8b 00                	mov    (%rax),%eax
  802ad5:	8d 50 01             	lea    0x1(%rax),%edx
  802ad8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802adc:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ade:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ae3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ae7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802aeb:	0f 82 60 ff ff ff    	jb     802a51 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802af1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802af5:	c9                   	leaveq 
  802af6:	c3                   	retq   

0000000000802af7 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802af7:	55                   	push   %rbp
  802af8:	48 89 e5             	mov    %rsp,%rbp
  802afb:	48 83 ec 40          	sub    $0x40,%rsp
  802aff:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b03:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b07:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802b0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b0f:	48 89 c7             	mov    %rax,%rdi
  802b12:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  802b19:	00 00 00 
  802b1c:	ff d0                	callq  *%rax
  802b1e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802b22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802b2a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802b31:	00 
  802b32:	e9 8e 00 00 00       	jmpq   802bc5 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802b37:	eb 31                	jmp    802b6a <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802b39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b41:	48 89 d6             	mov    %rdx,%rsi
  802b44:	48 89 c7             	mov    %rax,%rdi
  802b47:	48 b8 da 28 80 00 00 	movabs $0x8028da,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
  802b53:	85 c0                	test   %eax,%eax
  802b55:	74 07                	je     802b5e <devpipe_write+0x67>
				return 0;
  802b57:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5c:	eb 79                	jmp    802bd7 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802b5e:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  802b65:	00 00 00 
  802b68:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802b6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6e:	8b 40 04             	mov    0x4(%rax),%eax
  802b71:	48 63 d0             	movslq %eax,%rdx
  802b74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b78:	8b 00                	mov    (%rax),%eax
  802b7a:	48 98                	cltq   
  802b7c:	48 83 c0 20          	add    $0x20,%rax
  802b80:	48 39 c2             	cmp    %rax,%rdx
  802b83:	73 b4                	jae    802b39 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802b85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b89:	8b 40 04             	mov    0x4(%rax),%eax
  802b8c:	99                   	cltd   
  802b8d:	c1 ea 1b             	shr    $0x1b,%edx
  802b90:	01 d0                	add    %edx,%eax
  802b92:	83 e0 1f             	and    $0x1f,%eax
  802b95:	29 d0                	sub    %edx,%eax
  802b97:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b9b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b9f:	48 01 ca             	add    %rcx,%rdx
  802ba2:	0f b6 0a             	movzbl (%rdx),%ecx
  802ba5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ba9:	48 98                	cltq   
  802bab:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802baf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb3:	8b 40 04             	mov    0x4(%rax),%eax
  802bb6:	8d 50 01             	lea    0x1(%rax),%edx
  802bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbd:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802bc0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802bc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bc9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802bcd:	0f 82 64 ff ff ff    	jb     802b37 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802bd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802bd7:	c9                   	leaveq 
  802bd8:	c3                   	retq   

0000000000802bd9 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802bd9:	55                   	push   %rbp
  802bda:	48 89 e5             	mov    %rsp,%rbp
  802bdd:	48 83 ec 20          	sub    $0x20,%rsp
  802be1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802be5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802be9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bed:	48 89 c7             	mov    %rax,%rdi
  802bf0:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  802bf7:	00 00 00 
  802bfa:	ff d0                	callq  *%rax
  802bfc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802c00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c04:	48 be f9 40 80 00 00 	movabs $0x8040f9,%rsi
  802c0b:	00 00 00 
  802c0e:	48 89 c7             	mov    %rax,%rdi
  802c11:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  802c18:	00 00 00 
  802c1b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802c1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c21:	8b 50 04             	mov    0x4(%rax),%edx
  802c24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c28:	8b 00                	mov    (%rax),%eax
  802c2a:	29 c2                	sub    %eax,%edx
  802c2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c30:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802c36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c3a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c41:	00 00 00 
	stat->st_dev = &devpipe;
  802c44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c48:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  802c4f:	00 00 00 
  802c52:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5e:	c9                   	leaveq 
  802c5f:	c3                   	retq   

0000000000802c60 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802c60:	55                   	push   %rbp
  802c61:	48 89 e5             	mov    %rsp,%rbp
  802c64:	48 83 ec 10          	sub    $0x10,%rsp
  802c68:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802c6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c70:	48 89 c6             	mov    %rax,%rsi
  802c73:	bf 00 00 00 00       	mov    $0x0,%edi
  802c78:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  802c7f:	00 00 00 
  802c82:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802c84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c88:	48 89 c7             	mov    %rax,%rdi
  802c8b:	48 b8 f7 0e 80 00 00 	movabs $0x800ef7,%rax
  802c92:	00 00 00 
  802c95:	ff d0                	callq  *%rax
  802c97:	48 89 c6             	mov    %rax,%rsi
  802c9a:	bf 00 00 00 00       	mov    $0x0,%edi
  802c9f:	48 b8 46 0c 80 00 00 	movabs $0x800c46,%rax
  802ca6:	00 00 00 
  802ca9:	ff d0                	callq  *%rax
}
  802cab:	c9                   	leaveq 
  802cac:	c3                   	retq   

0000000000802cad <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802cad:	55                   	push   %rbp
  802cae:	48 89 e5             	mov    %rsp,%rbp
  802cb1:	48 83 ec 20          	sub    $0x20,%rsp
  802cb5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802cb8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cbb:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802cbe:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802cc2:	be 01 00 00 00       	mov    $0x1,%esi
  802cc7:	48 89 c7             	mov    %rax,%rdi
  802cca:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  802cd1:	00 00 00 
  802cd4:	ff d0                	callq  *%rax
}
  802cd6:	c9                   	leaveq 
  802cd7:	c3                   	retq   

0000000000802cd8 <getchar>:

int
getchar(void)
{
  802cd8:	55                   	push   %rbp
  802cd9:	48 89 e5             	mov    %rsp,%rbp
  802cdc:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802ce0:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802ce4:	ba 01 00 00 00       	mov    $0x1,%edx
  802ce9:	48 89 c6             	mov    %rax,%rsi
  802cec:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf1:	48 b8 ec 13 80 00 00 	movabs $0x8013ec,%rax
  802cf8:	00 00 00 
  802cfb:	ff d0                	callq  *%rax
  802cfd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802d00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d04:	79 05                	jns    802d0b <getchar+0x33>
		return r;
  802d06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d09:	eb 14                	jmp    802d1f <getchar+0x47>
	if (r < 1)
  802d0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0f:	7f 07                	jg     802d18 <getchar+0x40>
		return -E_EOF;
  802d11:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802d16:	eb 07                	jmp    802d1f <getchar+0x47>
	return c;
  802d18:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802d1c:	0f b6 c0             	movzbl %al,%eax
}
  802d1f:	c9                   	leaveq 
  802d20:	c3                   	retq   

0000000000802d21 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802d21:	55                   	push   %rbp
  802d22:	48 89 e5             	mov    %rsp,%rbp
  802d25:	48 83 ec 20          	sub    $0x20,%rsp
  802d29:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d2c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d30:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d33:	48 89 d6             	mov    %rdx,%rsi
  802d36:	89 c7                	mov    %eax,%edi
  802d38:	48 b8 ba 0f 80 00 00 	movabs $0x800fba,%rax
  802d3f:	00 00 00 
  802d42:	ff d0                	callq  *%rax
  802d44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d4b:	79 05                	jns    802d52 <iscons+0x31>
		return r;
  802d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d50:	eb 1a                	jmp    802d6c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802d52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d56:	8b 10                	mov    (%rax),%edx
  802d58:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  802d5f:	00 00 00 
  802d62:	8b 00                	mov    (%rax),%eax
  802d64:	39 c2                	cmp    %eax,%edx
  802d66:	0f 94 c0             	sete   %al
  802d69:	0f b6 c0             	movzbl %al,%eax
}
  802d6c:	c9                   	leaveq 
  802d6d:	c3                   	retq   

0000000000802d6e <opencons>:

int
opencons(void)
{
  802d6e:	55                   	push   %rbp
  802d6f:	48 89 e5             	mov    %rsp,%rbp
  802d72:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802d76:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d7a:	48 89 c7             	mov    %rax,%rdi
  802d7d:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  802d84:	00 00 00 
  802d87:	ff d0                	callq  *%rax
  802d89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d90:	79 05                	jns    802d97 <opencons+0x29>
		return r;
  802d92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d95:	eb 5b                	jmp    802df2 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802d97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9b:	ba 07 04 00 00       	mov    $0x407,%edx
  802da0:	48 89 c6             	mov    %rax,%rsi
  802da3:	bf 00 00 00 00       	mov    $0x0,%edi
  802da8:	48 b8 9b 0b 80 00 00 	movabs $0x800b9b,%rax
  802daf:	00 00 00 
  802db2:	ff d0                	callq  *%rax
  802db4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbb:	79 05                	jns    802dc2 <opencons+0x54>
		return r;
  802dbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc0:	eb 30                	jmp    802df2 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802dc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc6:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  802dcd:	00 00 00 
  802dd0:	8b 12                	mov    (%rdx),%edx
  802dd2:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802dd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802ddf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de3:	48 89 c7             	mov    %rax,%rdi
  802de6:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  802ded:	00 00 00 
  802df0:	ff d0                	callq  *%rax
}
  802df2:	c9                   	leaveq 
  802df3:	c3                   	retq   

0000000000802df4 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802df4:	55                   	push   %rbp
  802df5:	48 89 e5             	mov    %rsp,%rbp
  802df8:	48 83 ec 30          	sub    $0x30,%rsp
  802dfc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e04:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802e08:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802e0d:	75 07                	jne    802e16 <devcons_read+0x22>
		return 0;
  802e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e14:	eb 4b                	jmp    802e61 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  802e16:	eb 0c                	jmp    802e24 <devcons_read+0x30>
		sys_yield();
  802e18:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  802e1f:	00 00 00 
  802e22:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802e24:	48 b8 9d 0a 80 00 00 	movabs $0x800a9d,%rax
  802e2b:	00 00 00 
  802e2e:	ff d0                	callq  *%rax
  802e30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e37:	74 df                	je     802e18 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  802e39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e3d:	79 05                	jns    802e44 <devcons_read+0x50>
		return c;
  802e3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e42:	eb 1d                	jmp    802e61 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  802e44:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802e48:	75 07                	jne    802e51 <devcons_read+0x5d>
		return 0;
  802e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4f:	eb 10                	jmp    802e61 <devcons_read+0x6d>
	*(char*)vbuf = c;
  802e51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e54:	89 c2                	mov    %eax,%edx
  802e56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e5a:	88 10                	mov    %dl,(%rax)
	return 1;
  802e5c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802e61:	c9                   	leaveq 
  802e62:	c3                   	retq   

0000000000802e63 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e63:	55                   	push   %rbp
  802e64:	48 89 e5             	mov    %rsp,%rbp
  802e67:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  802e6e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  802e75:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  802e7c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802e83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e8a:	eb 76                	jmp    802f02 <devcons_write+0x9f>
		m = n - tot;
  802e8c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  802e93:	89 c2                	mov    %eax,%edx
  802e95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e98:	29 c2                	sub    %eax,%edx
  802e9a:	89 d0                	mov    %edx,%eax
  802e9c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  802e9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ea2:	83 f8 7f             	cmp    $0x7f,%eax
  802ea5:	76 07                	jbe    802eae <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  802ea7:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  802eae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eb1:	48 63 d0             	movslq %eax,%rdx
  802eb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb7:	48 63 c8             	movslq %eax,%rcx
  802eba:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  802ec1:	48 01 c1             	add    %rax,%rcx
  802ec4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802ecb:	48 89 ce             	mov    %rcx,%rsi
  802ece:	48 89 c7             	mov    %rax,%rdi
  802ed1:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  802ed8:	00 00 00 
  802edb:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802edd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ee0:	48 63 d0             	movslq %eax,%rdx
  802ee3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802eea:	48 89 d6             	mov    %rdx,%rsi
  802eed:	48 89 c7             	mov    %rax,%rdi
  802ef0:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802efc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eff:	01 45 fc             	add    %eax,-0x4(%rbp)
  802f02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f05:	48 98                	cltq   
  802f07:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802f0e:	0f 82 78 ff ff ff    	jb     802e8c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  802f14:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f17:	c9                   	leaveq 
  802f18:	c3                   	retq   

0000000000802f19 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802f19:	55                   	push   %rbp
  802f1a:	48 89 e5             	mov    %rsp,%rbp
  802f1d:	48 83 ec 08          	sub    $0x8,%rsp
  802f21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f2a:	c9                   	leaveq 
  802f2b:	c3                   	retq   

0000000000802f2c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802f2c:	55                   	push   %rbp
  802f2d:	48 89 e5             	mov    %rsp,%rbp
  802f30:	48 83 ec 10          	sub    $0x10,%rsp
  802f34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f38:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  802f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f40:	48 be 05 41 80 00 00 	movabs $0x804105,%rsi
  802f47:	00 00 00 
  802f4a:	48 89 c7             	mov    %rax,%rdi
  802f4d:	48 b8 6c 02 80 00 00 	movabs $0x80026c,%rax
  802f54:	00 00 00 
  802f57:	ff d0                	callq  *%rax
	return 0;
  802f59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f5e:	c9                   	leaveq 
  802f5f:	c3                   	retq   

0000000000802f60 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802f60:	55                   	push   %rbp
  802f61:	48 89 e5             	mov    %rsp,%rbp
  802f64:	53                   	push   %rbx
  802f65:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802f6c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802f73:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802f79:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802f80:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802f87:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802f8e:	84 c0                	test   %al,%al
  802f90:	74 23                	je     802fb5 <_panic+0x55>
  802f92:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802f99:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802f9d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802fa1:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802fa5:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802fa9:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802fad:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802fb1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802fb5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802fbc:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802fc3:	00 00 00 
  802fc6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802fcd:	00 00 00 
  802fd0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802fd4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802fdb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802fe2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802fe9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802ff0:	00 00 00 
  802ff3:	48 8b 18             	mov    (%rax),%rbx
  802ff6:	48 b8 1f 0b 80 00 00 	movabs $0x800b1f,%rax
  802ffd:	00 00 00 
  803000:	ff d0                	callq  *%rax
  803002:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803008:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80300f:	41 89 c8             	mov    %ecx,%r8d
  803012:	48 89 d1             	mov    %rdx,%rcx
  803015:	48 89 da             	mov    %rbx,%rdx
  803018:	89 c6                	mov    %eax,%esi
  80301a:	48 bf 10 41 80 00 00 	movabs $0x804110,%rdi
  803021:	00 00 00 
  803024:	b8 00 00 00 00       	mov    $0x0,%eax
  803029:	49 b9 99 31 80 00 00 	movabs $0x803199,%r9
  803030:	00 00 00 
  803033:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803036:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80303d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803044:	48 89 d6             	mov    %rdx,%rsi
  803047:	48 89 c7             	mov    %rax,%rdi
  80304a:	48 b8 ed 30 80 00 00 	movabs $0x8030ed,%rax
  803051:	00 00 00 
  803054:	ff d0                	callq  *%rax
	cprintf("\n");
  803056:	48 bf 33 41 80 00 00 	movabs $0x804133,%rdi
  80305d:	00 00 00 
  803060:	b8 00 00 00 00       	mov    $0x0,%eax
  803065:	48 ba 99 31 80 00 00 	movabs $0x803199,%rdx
  80306c:	00 00 00 
  80306f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803071:	cc                   	int3   
  803072:	eb fd                	jmp    803071 <_panic+0x111>

0000000000803074 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  803074:	55                   	push   %rbp
  803075:	48 89 e5             	mov    %rsp,%rbp
  803078:	48 83 ec 10          	sub    $0x10,%rsp
  80307c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80307f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  803083:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803087:	8b 00                	mov    (%rax),%eax
  803089:	8d 48 01             	lea    0x1(%rax),%ecx
  80308c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803090:	89 0a                	mov    %ecx,(%rdx)
  803092:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803095:	89 d1                	mov    %edx,%ecx
  803097:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80309b:	48 98                	cltq   
  80309d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8030a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a5:	8b 00                	mov    (%rax),%eax
  8030a7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8030ac:	75 2c                	jne    8030da <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8030ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b2:	8b 00                	mov    (%rax),%eax
  8030b4:	48 98                	cltq   
  8030b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030ba:	48 83 c2 08          	add    $0x8,%rdx
  8030be:	48 89 c6             	mov    %rax,%rsi
  8030c1:	48 89 d7             	mov    %rdx,%rdi
  8030c4:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  8030cb:	00 00 00 
  8030ce:	ff d0                	callq  *%rax
        b->idx = 0;
  8030d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8030da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030de:	8b 40 04             	mov    0x4(%rax),%eax
  8030e1:	8d 50 01             	lea    0x1(%rax),%edx
  8030e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8030eb:	c9                   	leaveq 
  8030ec:	c3                   	retq   

00000000008030ed <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8030ed:	55                   	push   %rbp
  8030ee:	48 89 e5             	mov    %rsp,%rbp
  8030f1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8030f8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8030ff:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  803106:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80310d:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  803114:	48 8b 0a             	mov    (%rdx),%rcx
  803117:	48 89 08             	mov    %rcx,(%rax)
  80311a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80311e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803122:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803126:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80312a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  803131:	00 00 00 
    b.cnt = 0;
  803134:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80313b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80313e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  803145:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80314c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803153:	48 89 c6             	mov    %rax,%rsi
  803156:	48 bf 74 30 80 00 00 	movabs $0x803074,%rdi
  80315d:	00 00 00 
  803160:	48 b8 4c 35 80 00 00 	movabs $0x80354c,%rax
  803167:	00 00 00 
  80316a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80316c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  803172:	48 98                	cltq   
  803174:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80317b:	48 83 c2 08          	add    $0x8,%rdx
  80317f:	48 89 c6             	mov    %rax,%rsi
  803182:	48 89 d7             	mov    %rdx,%rdi
  803185:	48 b8 53 0a 80 00 00 	movabs $0x800a53,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  803191:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  803197:	c9                   	leaveq 
  803198:	c3                   	retq   

0000000000803199 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  803199:	55                   	push   %rbp
  80319a:	48 89 e5             	mov    %rsp,%rbp
  80319d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8031a4:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8031ab:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8031b2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8031b9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8031c0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8031c7:	84 c0                	test   %al,%al
  8031c9:	74 20                	je     8031eb <cprintf+0x52>
  8031cb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8031cf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8031d3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8031d7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8031db:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8031df:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8031e3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8031e7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8031eb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8031f2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8031f9:	00 00 00 
  8031fc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803203:	00 00 00 
  803206:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80320a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803211:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803218:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80321f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803226:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80322d:	48 8b 0a             	mov    (%rdx),%rcx
  803230:	48 89 08             	mov    %rcx,(%rax)
  803233:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803237:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80323b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80323f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  803243:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80324a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803251:	48 89 d6             	mov    %rdx,%rsi
  803254:	48 89 c7             	mov    %rax,%rdi
  803257:	48 b8 ed 30 80 00 00 	movabs $0x8030ed,%rax
  80325e:	00 00 00 
  803261:	ff d0                	callq  *%rax
  803263:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  803269:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80326f:	c9                   	leaveq 
  803270:	c3                   	retq   

0000000000803271 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  803271:	55                   	push   %rbp
  803272:	48 89 e5             	mov    %rsp,%rbp
  803275:	53                   	push   %rbx
  803276:	48 83 ec 38          	sub    $0x38,%rsp
  80327a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80327e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803282:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803286:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  803289:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80328d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  803291:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803294:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803298:	77 3b                	ja     8032d5 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80329a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80329d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8032a1:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8032a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ad:	48 f7 f3             	div    %rbx
  8032b0:	48 89 c2             	mov    %rax,%rdx
  8032b3:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8032b6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8032b9:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8032bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c1:	41 89 f9             	mov    %edi,%r9d
  8032c4:	48 89 c7             	mov    %rax,%rdi
  8032c7:	48 b8 71 32 80 00 00 	movabs $0x803271,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
  8032d3:	eb 1e                	jmp    8032f3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8032d5:	eb 12                	jmp    8032e9 <printnum+0x78>
			putch(padc, putdat);
  8032d7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032db:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8032de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032e2:	48 89 ce             	mov    %rcx,%rsi
  8032e5:	89 d7                	mov    %edx,%edi
  8032e7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8032e9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8032ed:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8032f1:	7f e4                	jg     8032d7 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8032f3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8032f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ff:	48 f7 f1             	div    %rcx
  803302:	48 89 d0             	mov    %rdx,%rax
  803305:	48 ba 30 43 80 00 00 	movabs $0x804330,%rdx
  80330c:	00 00 00 
  80330f:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  803313:	0f be d0             	movsbl %al,%edx
  803316:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80331a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80331e:	48 89 ce             	mov    %rcx,%rsi
  803321:	89 d7                	mov    %edx,%edi
  803323:	ff d0                	callq  *%rax
}
  803325:	48 83 c4 38          	add    $0x38,%rsp
  803329:	5b                   	pop    %rbx
  80332a:	5d                   	pop    %rbp
  80332b:	c3                   	retq   

000000000080332c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80332c:	55                   	push   %rbp
  80332d:	48 89 e5             	mov    %rsp,%rbp
  803330:	48 83 ec 1c          	sub    $0x1c,%rsp
  803334:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803338:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80333b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80333f:	7e 52                	jle    803393 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  803341:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803345:	8b 00                	mov    (%rax),%eax
  803347:	83 f8 30             	cmp    $0x30,%eax
  80334a:	73 24                	jae    803370 <getuint+0x44>
  80334c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803350:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803354:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803358:	8b 00                	mov    (%rax),%eax
  80335a:	89 c0                	mov    %eax,%eax
  80335c:	48 01 d0             	add    %rdx,%rax
  80335f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803363:	8b 12                	mov    (%rdx),%edx
  803365:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803368:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80336c:	89 0a                	mov    %ecx,(%rdx)
  80336e:	eb 17                	jmp    803387 <getuint+0x5b>
  803370:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803374:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803378:	48 89 d0             	mov    %rdx,%rax
  80337b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80337f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803383:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803387:	48 8b 00             	mov    (%rax),%rax
  80338a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80338e:	e9 a3 00 00 00       	jmpq   803436 <getuint+0x10a>
	else if (lflag)
  803393:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803397:	74 4f                	je     8033e8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  803399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80339d:	8b 00                	mov    (%rax),%eax
  80339f:	83 f8 30             	cmp    $0x30,%eax
  8033a2:	73 24                	jae    8033c8 <getuint+0x9c>
  8033a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8033ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033b0:	8b 00                	mov    (%rax),%eax
  8033b2:	89 c0                	mov    %eax,%eax
  8033b4:	48 01 d0             	add    %rdx,%rax
  8033b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033bb:	8b 12                	mov    (%rdx),%edx
  8033bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8033c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033c4:	89 0a                	mov    %ecx,(%rdx)
  8033c6:	eb 17                	jmp    8033df <getuint+0xb3>
  8033c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8033d0:	48 89 d0             	mov    %rdx,%rax
  8033d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8033d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8033db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8033df:	48 8b 00             	mov    (%rax),%rax
  8033e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8033e6:	eb 4e                	jmp    803436 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8033e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ec:	8b 00                	mov    (%rax),%eax
  8033ee:	83 f8 30             	cmp    $0x30,%eax
  8033f1:	73 24                	jae    803417 <getuint+0xeb>
  8033f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8033fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ff:	8b 00                	mov    (%rax),%eax
  803401:	89 c0                	mov    %eax,%eax
  803403:	48 01 d0             	add    %rdx,%rax
  803406:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80340a:	8b 12                	mov    (%rdx),%edx
  80340c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80340f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803413:	89 0a                	mov    %ecx,(%rdx)
  803415:	eb 17                	jmp    80342e <getuint+0x102>
  803417:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80341b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80341f:	48 89 d0             	mov    %rdx,%rax
  803422:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803426:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80342a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80342e:	8b 00                	mov    (%rax),%eax
  803430:	89 c0                	mov    %eax,%eax
  803432:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80343a:	c9                   	leaveq 
  80343b:	c3                   	retq   

000000000080343c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80343c:	55                   	push   %rbp
  80343d:	48 89 e5             	mov    %rsp,%rbp
  803440:	48 83 ec 1c          	sub    $0x1c,%rsp
  803444:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803448:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80344b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80344f:	7e 52                	jle    8034a3 <getint+0x67>
		x=va_arg(*ap, long long);
  803451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803455:	8b 00                	mov    (%rax),%eax
  803457:	83 f8 30             	cmp    $0x30,%eax
  80345a:	73 24                	jae    803480 <getint+0x44>
  80345c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803460:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803468:	8b 00                	mov    (%rax),%eax
  80346a:	89 c0                	mov    %eax,%eax
  80346c:	48 01 d0             	add    %rdx,%rax
  80346f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803473:	8b 12                	mov    (%rdx),%edx
  803475:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803478:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80347c:	89 0a                	mov    %ecx,(%rdx)
  80347e:	eb 17                	jmp    803497 <getint+0x5b>
  803480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803484:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803488:	48 89 d0             	mov    %rdx,%rax
  80348b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80348f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803493:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803497:	48 8b 00             	mov    (%rax),%rax
  80349a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80349e:	e9 a3 00 00 00       	jmpq   803546 <getint+0x10a>
	else if (lflag)
  8034a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8034a7:	74 4f                	je     8034f8 <getint+0xbc>
		x=va_arg(*ap, long);
  8034a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ad:	8b 00                	mov    (%rax),%eax
  8034af:	83 f8 30             	cmp    $0x30,%eax
  8034b2:	73 24                	jae    8034d8 <getint+0x9c>
  8034b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8034bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c0:	8b 00                	mov    (%rax),%eax
  8034c2:	89 c0                	mov    %eax,%eax
  8034c4:	48 01 d0             	add    %rdx,%rax
  8034c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034cb:	8b 12                	mov    (%rdx),%edx
  8034cd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8034d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034d4:	89 0a                	mov    %ecx,(%rdx)
  8034d6:	eb 17                	jmp    8034ef <getint+0xb3>
  8034d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034dc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8034e0:	48 89 d0             	mov    %rdx,%rax
  8034e3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8034e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8034ef:	48 8b 00             	mov    (%rax),%rax
  8034f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8034f6:	eb 4e                	jmp    803546 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8034f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034fc:	8b 00                	mov    (%rax),%eax
  8034fe:	83 f8 30             	cmp    $0x30,%eax
  803501:	73 24                	jae    803527 <getint+0xeb>
  803503:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803507:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80350b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80350f:	8b 00                	mov    (%rax),%eax
  803511:	89 c0                	mov    %eax,%eax
  803513:	48 01 d0             	add    %rdx,%rax
  803516:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80351a:	8b 12                	mov    (%rdx),%edx
  80351c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80351f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803523:	89 0a                	mov    %ecx,(%rdx)
  803525:	eb 17                	jmp    80353e <getint+0x102>
  803527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80352f:	48 89 d0             	mov    %rdx,%rax
  803532:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803536:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80353a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80353e:	8b 00                	mov    (%rax),%eax
  803540:	48 98                	cltq   
  803542:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803546:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80354a:	c9                   	leaveq 
  80354b:	c3                   	retq   

000000000080354c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80354c:	55                   	push   %rbp
  80354d:	48 89 e5             	mov    %rsp,%rbp
  803550:	41 54                	push   %r12
  803552:	53                   	push   %rbx
  803553:	48 83 ec 60          	sub    $0x60,%rsp
  803557:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80355b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80355f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803563:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803567:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80356b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80356f:	48 8b 0a             	mov    (%rdx),%rcx
  803572:	48 89 08             	mov    %rcx,(%rax)
  803575:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803579:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80357d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803581:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803585:	eb 17                	jmp    80359e <vprintfmt+0x52>
			if (ch == '\0')
  803587:	85 db                	test   %ebx,%ebx
  803589:	0f 84 cc 04 00 00    	je     803a5b <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80358f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803593:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803597:	48 89 d6             	mov    %rdx,%rsi
  80359a:	89 df                	mov    %ebx,%edi
  80359c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80359e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8035a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8035a6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8035aa:	0f b6 00             	movzbl (%rax),%eax
  8035ad:	0f b6 d8             	movzbl %al,%ebx
  8035b0:	83 fb 25             	cmp    $0x25,%ebx
  8035b3:	75 d2                	jne    803587 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8035b5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8035b9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8035c0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8035c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8035ce:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8035d5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8035d9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8035dd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8035e1:	0f b6 00             	movzbl (%rax),%eax
  8035e4:	0f b6 d8             	movzbl %al,%ebx
  8035e7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8035ea:	83 f8 55             	cmp    $0x55,%eax
  8035ed:	0f 87 34 04 00 00    	ja     803a27 <vprintfmt+0x4db>
  8035f3:	89 c0                	mov    %eax,%eax
  8035f5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8035fc:	00 
  8035fd:	48 b8 58 43 80 00 00 	movabs $0x804358,%rax
  803604:	00 00 00 
  803607:	48 01 d0             	add    %rdx,%rax
  80360a:	48 8b 00             	mov    (%rax),%rax
  80360d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80360f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  803613:	eb c0                	jmp    8035d5 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  803615:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803619:	eb ba                	jmp    8035d5 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80361b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  803622:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803625:	89 d0                	mov    %edx,%eax
  803627:	c1 e0 02             	shl    $0x2,%eax
  80362a:	01 d0                	add    %edx,%eax
  80362c:	01 c0                	add    %eax,%eax
  80362e:	01 d8                	add    %ebx,%eax
  803630:	83 e8 30             	sub    $0x30,%eax
  803633:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803636:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80363a:	0f b6 00             	movzbl (%rax),%eax
  80363d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  803640:	83 fb 2f             	cmp    $0x2f,%ebx
  803643:	7e 0c                	jle    803651 <vprintfmt+0x105>
  803645:	83 fb 39             	cmp    $0x39,%ebx
  803648:	7f 07                	jg     803651 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80364a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80364f:	eb d1                	jmp    803622 <vprintfmt+0xd6>
			goto process_precision;
  803651:	eb 58                	jmp    8036ab <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  803653:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803656:	83 f8 30             	cmp    $0x30,%eax
  803659:	73 17                	jae    803672 <vprintfmt+0x126>
  80365b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80365f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803662:	89 c0                	mov    %eax,%eax
  803664:	48 01 d0             	add    %rdx,%rax
  803667:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80366a:	83 c2 08             	add    $0x8,%edx
  80366d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803670:	eb 0f                	jmp    803681 <vprintfmt+0x135>
  803672:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803676:	48 89 d0             	mov    %rdx,%rax
  803679:	48 83 c2 08          	add    $0x8,%rdx
  80367d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803681:	8b 00                	mov    (%rax),%eax
  803683:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803686:	eb 23                	jmp    8036ab <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  803688:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80368c:	79 0c                	jns    80369a <vprintfmt+0x14e>
				width = 0;
  80368e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803695:	e9 3b ff ff ff       	jmpq   8035d5 <vprintfmt+0x89>
  80369a:	e9 36 ff ff ff       	jmpq   8035d5 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80369f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8036a6:	e9 2a ff ff ff       	jmpq   8035d5 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8036ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8036af:	79 12                	jns    8036c3 <vprintfmt+0x177>
				width = precision, precision = -1;
  8036b1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8036b4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8036b7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8036be:	e9 12 ff ff ff       	jmpq   8035d5 <vprintfmt+0x89>
  8036c3:	e9 0d ff ff ff       	jmpq   8035d5 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8036c8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8036cc:	e9 04 ff ff ff       	jmpq   8035d5 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8036d1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8036d4:	83 f8 30             	cmp    $0x30,%eax
  8036d7:	73 17                	jae    8036f0 <vprintfmt+0x1a4>
  8036d9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8036dd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8036e0:	89 c0                	mov    %eax,%eax
  8036e2:	48 01 d0             	add    %rdx,%rax
  8036e5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8036e8:	83 c2 08             	add    $0x8,%edx
  8036eb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8036ee:	eb 0f                	jmp    8036ff <vprintfmt+0x1b3>
  8036f0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8036f4:	48 89 d0             	mov    %rdx,%rax
  8036f7:	48 83 c2 08          	add    $0x8,%rdx
  8036fb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8036ff:	8b 10                	mov    (%rax),%edx
  803701:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803705:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803709:	48 89 ce             	mov    %rcx,%rsi
  80370c:	89 d7                	mov    %edx,%edi
  80370e:	ff d0                	callq  *%rax
			break;
  803710:	e9 40 03 00 00       	jmpq   803a55 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  803715:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803718:	83 f8 30             	cmp    $0x30,%eax
  80371b:	73 17                	jae    803734 <vprintfmt+0x1e8>
  80371d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803721:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803724:	89 c0                	mov    %eax,%eax
  803726:	48 01 d0             	add    %rdx,%rax
  803729:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80372c:	83 c2 08             	add    $0x8,%edx
  80372f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803732:	eb 0f                	jmp    803743 <vprintfmt+0x1f7>
  803734:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803738:	48 89 d0             	mov    %rdx,%rax
  80373b:	48 83 c2 08          	add    $0x8,%rdx
  80373f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803743:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803745:	85 db                	test   %ebx,%ebx
  803747:	79 02                	jns    80374b <vprintfmt+0x1ff>
				err = -err;
  803749:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80374b:	83 fb 15             	cmp    $0x15,%ebx
  80374e:	7f 16                	jg     803766 <vprintfmt+0x21a>
  803750:	48 b8 80 42 80 00 00 	movabs $0x804280,%rax
  803757:	00 00 00 
  80375a:	48 63 d3             	movslq %ebx,%rdx
  80375d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803761:	4d 85 e4             	test   %r12,%r12
  803764:	75 2e                	jne    803794 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  803766:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80376a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80376e:	89 d9                	mov    %ebx,%ecx
  803770:	48 ba 41 43 80 00 00 	movabs $0x804341,%rdx
  803777:	00 00 00 
  80377a:	48 89 c7             	mov    %rax,%rdi
  80377d:	b8 00 00 00 00       	mov    $0x0,%eax
  803782:	49 b8 64 3a 80 00 00 	movabs $0x803a64,%r8
  803789:	00 00 00 
  80378c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80378f:	e9 c1 02 00 00       	jmpq   803a55 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803794:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803798:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80379c:	4c 89 e1             	mov    %r12,%rcx
  80379f:	48 ba 4a 43 80 00 00 	movabs $0x80434a,%rdx
  8037a6:	00 00 00 
  8037a9:	48 89 c7             	mov    %rax,%rdi
  8037ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b1:	49 b8 64 3a 80 00 00 	movabs $0x803a64,%r8
  8037b8:	00 00 00 
  8037bb:	41 ff d0             	callq  *%r8
			break;
  8037be:	e9 92 02 00 00       	jmpq   803a55 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8037c3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8037c6:	83 f8 30             	cmp    $0x30,%eax
  8037c9:	73 17                	jae    8037e2 <vprintfmt+0x296>
  8037cb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8037cf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8037d2:	89 c0                	mov    %eax,%eax
  8037d4:	48 01 d0             	add    %rdx,%rax
  8037d7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8037da:	83 c2 08             	add    $0x8,%edx
  8037dd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8037e0:	eb 0f                	jmp    8037f1 <vprintfmt+0x2a5>
  8037e2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8037e6:	48 89 d0             	mov    %rdx,%rax
  8037e9:	48 83 c2 08          	add    $0x8,%rdx
  8037ed:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8037f1:	4c 8b 20             	mov    (%rax),%r12
  8037f4:	4d 85 e4             	test   %r12,%r12
  8037f7:	75 0a                	jne    803803 <vprintfmt+0x2b7>
				p = "(null)";
  8037f9:	49 bc 4d 43 80 00 00 	movabs $0x80434d,%r12
  803800:	00 00 00 
			if (width > 0 && padc != '-')
  803803:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803807:	7e 3f                	jle    803848 <vprintfmt+0x2fc>
  803809:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80380d:	74 39                	je     803848 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80380f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803812:	48 98                	cltq   
  803814:	48 89 c6             	mov    %rax,%rsi
  803817:	4c 89 e7             	mov    %r12,%rdi
  80381a:	48 b8 2e 02 80 00 00 	movabs $0x80022e,%rax
  803821:	00 00 00 
  803824:	ff d0                	callq  *%rax
  803826:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803829:	eb 17                	jmp    803842 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80382b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80382f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803833:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803837:	48 89 ce             	mov    %rcx,%rsi
  80383a:	89 d7                	mov    %edx,%edi
  80383c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80383e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803842:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803846:	7f e3                	jg     80382b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803848:	eb 37                	jmp    803881 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80384a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80384e:	74 1e                	je     80386e <vprintfmt+0x322>
  803850:	83 fb 1f             	cmp    $0x1f,%ebx
  803853:	7e 05                	jle    80385a <vprintfmt+0x30e>
  803855:	83 fb 7e             	cmp    $0x7e,%ebx
  803858:	7e 14                	jle    80386e <vprintfmt+0x322>
					putch('?', putdat);
  80385a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80385e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803862:	48 89 d6             	mov    %rdx,%rsi
  803865:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80386a:	ff d0                	callq  *%rax
  80386c:	eb 0f                	jmp    80387d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80386e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803872:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803876:	48 89 d6             	mov    %rdx,%rsi
  803879:	89 df                	mov    %ebx,%edi
  80387b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80387d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803881:	4c 89 e0             	mov    %r12,%rax
  803884:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803888:	0f b6 00             	movzbl (%rax),%eax
  80388b:	0f be d8             	movsbl %al,%ebx
  80388e:	85 db                	test   %ebx,%ebx
  803890:	74 10                	je     8038a2 <vprintfmt+0x356>
  803892:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803896:	78 b2                	js     80384a <vprintfmt+0x2fe>
  803898:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80389c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8038a0:	79 a8                	jns    80384a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8038a2:	eb 16                	jmp    8038ba <vprintfmt+0x36e>
				putch(' ', putdat);
  8038a4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8038a8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8038ac:	48 89 d6             	mov    %rdx,%rsi
  8038af:	bf 20 00 00 00       	mov    $0x20,%edi
  8038b4:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8038b6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8038ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8038be:	7f e4                	jg     8038a4 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8038c0:	e9 90 01 00 00       	jmpq   803a55 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8038c5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8038c9:	be 03 00 00 00       	mov    $0x3,%esi
  8038ce:	48 89 c7             	mov    %rax,%rdi
  8038d1:	48 b8 3c 34 80 00 00 	movabs $0x80343c,%rax
  8038d8:	00 00 00 
  8038db:	ff d0                	callq  *%rax
  8038dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8038e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e5:	48 85 c0             	test   %rax,%rax
  8038e8:	79 1d                	jns    803907 <vprintfmt+0x3bb>
				putch('-', putdat);
  8038ea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8038ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8038f2:	48 89 d6             	mov    %rdx,%rsi
  8038f5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8038fa:	ff d0                	callq  *%rax
				num = -(long long) num;
  8038fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803900:	48 f7 d8             	neg    %rax
  803903:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803907:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80390e:	e9 d5 00 00 00       	jmpq   8039e8 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803913:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803917:	be 03 00 00 00       	mov    $0x3,%esi
  80391c:	48 89 c7             	mov    %rax,%rdi
  80391f:	48 b8 2c 33 80 00 00 	movabs $0x80332c,%rax
  803926:	00 00 00 
  803929:	ff d0                	callq  *%rax
  80392b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80392f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803936:	e9 ad 00 00 00       	jmpq   8039e8 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  80393b:	8b 55 e0             	mov    -0x20(%rbp),%edx
  80393e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803942:	89 d6                	mov    %edx,%esi
  803944:	48 89 c7             	mov    %rax,%rdi
  803947:	48 b8 3c 34 80 00 00 	movabs $0x80343c,%rax
  80394e:	00 00 00 
  803951:	ff d0                	callq  *%rax
  803953:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803957:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80395e:	e9 85 00 00 00       	jmpq   8039e8 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  803963:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803967:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80396b:	48 89 d6             	mov    %rdx,%rsi
  80396e:	bf 30 00 00 00       	mov    $0x30,%edi
  803973:	ff d0                	callq  *%rax
			putch('x', putdat);
  803975:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803979:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80397d:	48 89 d6             	mov    %rdx,%rsi
  803980:	bf 78 00 00 00       	mov    $0x78,%edi
  803985:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803987:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80398a:	83 f8 30             	cmp    $0x30,%eax
  80398d:	73 17                	jae    8039a6 <vprintfmt+0x45a>
  80398f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803993:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803996:	89 c0                	mov    %eax,%eax
  803998:	48 01 d0             	add    %rdx,%rax
  80399b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80399e:	83 c2 08             	add    $0x8,%edx
  8039a1:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8039a4:	eb 0f                	jmp    8039b5 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  8039a6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8039aa:	48 89 d0             	mov    %rdx,%rax
  8039ad:	48 83 c2 08          	add    $0x8,%rdx
  8039b1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8039b5:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8039b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8039bc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8039c3:	eb 23                	jmp    8039e8 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8039c5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8039c9:	be 03 00 00 00       	mov    $0x3,%esi
  8039ce:	48 89 c7             	mov    %rax,%rdi
  8039d1:	48 b8 2c 33 80 00 00 	movabs $0x80332c,%rax
  8039d8:	00 00 00 
  8039db:	ff d0                	callq  *%rax
  8039dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8039e1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8039e8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8039ed:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8039f0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8039f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039f7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8039fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8039ff:	45 89 c1             	mov    %r8d,%r9d
  803a02:	41 89 f8             	mov    %edi,%r8d
  803a05:	48 89 c7             	mov    %rax,%rdi
  803a08:	48 b8 71 32 80 00 00 	movabs $0x803271,%rax
  803a0f:	00 00 00 
  803a12:	ff d0                	callq  *%rax
			break;
  803a14:	eb 3f                	jmp    803a55 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803a16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a1e:	48 89 d6             	mov    %rdx,%rsi
  803a21:	89 df                	mov    %ebx,%edi
  803a23:	ff d0                	callq  *%rax
			break;
  803a25:	eb 2e                	jmp    803a55 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803a27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a2f:	48 89 d6             	mov    %rdx,%rsi
  803a32:	bf 25 00 00 00       	mov    $0x25,%edi
  803a37:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803a39:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803a3e:	eb 05                	jmp    803a45 <vprintfmt+0x4f9>
  803a40:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803a45:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803a49:	48 83 e8 01          	sub    $0x1,%rax
  803a4d:	0f b6 00             	movzbl (%rax),%eax
  803a50:	3c 25                	cmp    $0x25,%al
  803a52:	75 ec                	jne    803a40 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  803a54:	90                   	nop
		}
	}
  803a55:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803a56:	e9 43 fb ff ff       	jmpq   80359e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803a5b:	48 83 c4 60          	add    $0x60,%rsp
  803a5f:	5b                   	pop    %rbx
  803a60:	41 5c                	pop    %r12
  803a62:	5d                   	pop    %rbp
  803a63:	c3                   	retq   

0000000000803a64 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803a64:	55                   	push   %rbp
  803a65:	48 89 e5             	mov    %rsp,%rbp
  803a68:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803a6f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803a76:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803a7d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803a84:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803a8b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803a92:	84 c0                	test   %al,%al
  803a94:	74 20                	je     803ab6 <printfmt+0x52>
  803a96:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803a9a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803a9e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803aa2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803aa6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803aaa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803aae:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803ab2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803ab6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803abd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803ac4:	00 00 00 
  803ac7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803ace:	00 00 00 
  803ad1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803ad5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803adc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803ae3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803aea:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803af1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803af8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803aff:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803b06:	48 89 c7             	mov    %rax,%rdi
  803b09:	48 b8 4c 35 80 00 00 	movabs $0x80354c,%rax
  803b10:	00 00 00 
  803b13:	ff d0                	callq  *%rax
	va_end(ap);
}
  803b15:	c9                   	leaveq 
  803b16:	c3                   	retq   

0000000000803b17 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803b17:	55                   	push   %rbp
  803b18:	48 89 e5             	mov    %rsp,%rbp
  803b1b:	48 83 ec 10          	sub    $0x10,%rsp
  803b1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803b26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2a:	8b 40 10             	mov    0x10(%rax),%eax
  803b2d:	8d 50 01             	lea    0x1(%rax),%edx
  803b30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b34:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803b37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3b:	48 8b 10             	mov    (%rax),%rdx
  803b3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b42:	48 8b 40 08          	mov    0x8(%rax),%rax
  803b46:	48 39 c2             	cmp    %rax,%rdx
  803b49:	73 17                	jae    803b62 <sprintputch+0x4b>
		*b->buf++ = ch;
  803b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b4f:	48 8b 00             	mov    (%rax),%rax
  803b52:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803b56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b5a:	48 89 0a             	mov    %rcx,(%rdx)
  803b5d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b60:	88 10                	mov    %dl,(%rax)
}
  803b62:	c9                   	leaveq 
  803b63:	c3                   	retq   

0000000000803b64 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803b64:	55                   	push   %rbp
  803b65:	48 89 e5             	mov    %rsp,%rbp
  803b68:	48 83 ec 50          	sub    $0x50,%rsp
  803b6c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803b70:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803b73:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803b77:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803b7b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803b7f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803b83:	48 8b 0a             	mov    (%rdx),%rcx
  803b86:	48 89 08             	mov    %rcx,(%rax)
  803b89:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803b8d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803b91:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803b95:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803b99:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b9d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803ba1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803ba4:	48 98                	cltq   
  803ba6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803baa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bae:	48 01 d0             	add    %rdx,%rax
  803bb1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803bb5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803bbc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803bc1:	74 06                	je     803bc9 <vsnprintf+0x65>
  803bc3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803bc7:	7f 07                	jg     803bd0 <vsnprintf+0x6c>
		return -E_INVAL;
  803bc9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803bce:	eb 2f                	jmp    803bff <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803bd0:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803bd4:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803bd8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803bdc:	48 89 c6             	mov    %rax,%rsi
  803bdf:	48 bf 17 3b 80 00 00 	movabs $0x803b17,%rdi
  803be6:	00 00 00 
  803be9:	48 b8 4c 35 80 00 00 	movabs $0x80354c,%rax
  803bf0:	00 00 00 
  803bf3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803bf5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bf9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803bfc:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803bff:	c9                   	leaveq 
  803c00:	c3                   	retq   

0000000000803c01 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803c01:	55                   	push   %rbp
  803c02:	48 89 e5             	mov    %rsp,%rbp
  803c05:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803c0c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803c13:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803c19:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803c20:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803c27:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803c2e:	84 c0                	test   %al,%al
  803c30:	74 20                	je     803c52 <snprintf+0x51>
  803c32:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803c36:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803c3a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803c3e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803c42:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803c46:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803c4a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803c4e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803c52:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803c59:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803c60:	00 00 00 
  803c63:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803c6a:	00 00 00 
  803c6d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c71:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803c78:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803c7f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803c86:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803c8d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803c94:	48 8b 0a             	mov    (%rdx),%rcx
  803c97:	48 89 08             	mov    %rcx,(%rax)
  803c9a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803c9e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803ca2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803ca6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803caa:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803cb1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803cb8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803cbe:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803cc5:	48 89 c7             	mov    %rax,%rdi
  803cc8:	48 b8 64 3b 80 00 00 	movabs $0x803b64,%rax
  803ccf:	00 00 00 
  803cd2:	ff d0                	callq  *%rax
  803cd4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803cda:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803ce0:	c9                   	leaveq 
  803ce1:	c3                   	retq   

0000000000803ce2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803ce2:	55                   	push   %rbp
  803ce3:	48 89 e5             	mov    %rsp,%rbp
  803ce6:	48 83 ec 30          	sub    $0x30,%rsp
  803cea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803cee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cf2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803cf6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803cfd:	00 00 00 
  803d00:	48 8b 00             	mov    (%rax),%rax
  803d03:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803d09:	85 c0                	test   %eax,%eax
  803d0b:	75 3c                	jne    803d49 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803d0d:	48 b8 1f 0b 80 00 00 	movabs $0x800b1f,%rax
  803d14:	00 00 00 
  803d17:	ff d0                	callq  *%rax
  803d19:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d1e:	48 63 d0             	movslq %eax,%rdx
  803d21:	48 89 d0             	mov    %rdx,%rax
  803d24:	48 c1 e0 03          	shl    $0x3,%rax
  803d28:	48 01 d0             	add    %rdx,%rax
  803d2b:	48 c1 e0 05          	shl    $0x5,%rax
  803d2f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d36:	00 00 00 
  803d39:	48 01 c2             	add    %rax,%rdx
  803d3c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d43:	00 00 00 
  803d46:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803d49:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803d4e:	75 0e                	jne    803d5e <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803d50:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803d57:	00 00 00 
  803d5a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803d5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d62:	48 89 c7             	mov    %rax,%rdi
  803d65:	48 b8 c4 0d 80 00 00 	movabs $0x800dc4,%rax
  803d6c:	00 00 00 
  803d6f:	ff d0                	callq  *%rax
  803d71:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803d74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d78:	79 19                	jns    803d93 <ipc_recv+0xb1>
		*from_env_store = 0;
  803d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d7e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803d84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d88:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d91:	eb 53                	jmp    803de6 <ipc_recv+0x104>
	}
	if(from_env_store)
  803d93:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803d98:	74 19                	je     803db3 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803d9a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803da1:	00 00 00 
  803da4:	48 8b 00             	mov    (%rax),%rax
  803da7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803dad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db1:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803db3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803db8:	74 19                	je     803dd3 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803dba:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dc1:	00 00 00 
  803dc4:	48 8b 00             	mov    (%rax),%rax
  803dc7:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803dcd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dd1:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803dd3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dda:	00 00 00 
  803ddd:	48 8b 00             	mov    (%rax),%rax
  803de0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803de6:	c9                   	leaveq 
  803de7:	c3                   	retq   

0000000000803de8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803de8:	55                   	push   %rbp
  803de9:	48 89 e5             	mov    %rsp,%rbp
  803dec:	48 83 ec 30          	sub    $0x30,%rsp
  803df0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803df3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803df6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803dfa:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  803dfd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e02:	75 0e                	jne    803e12 <ipc_send+0x2a>
		pg = (void*)UTOP;
  803e04:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803e0b:	00 00 00 
  803e0e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  803e12:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803e15:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803e18:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803e1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e1f:	89 c7                	mov    %eax,%edi
  803e21:	48 b8 6f 0d 80 00 00 	movabs $0x800d6f,%rax
  803e28:	00 00 00 
  803e2b:	ff d0                	callq  *%rax
  803e2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  803e30:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e34:	75 0c                	jne    803e42 <ipc_send+0x5a>
			sys_yield();
  803e36:	48 b8 5d 0b 80 00 00 	movabs $0x800b5d,%rax
  803e3d:	00 00 00 
  803e40:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  803e42:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803e46:	74 ca                	je     803e12 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  803e48:	c9                   	leaveq 
  803e49:	c3                   	retq   

0000000000803e4a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803e4a:	55                   	push   %rbp
  803e4b:	48 89 e5             	mov    %rsp,%rbp
  803e4e:	48 83 ec 14          	sub    $0x14,%rsp
  803e52:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803e55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e5c:	eb 5e                	jmp    803ebc <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803e5e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e65:	00 00 00 
  803e68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e6b:	48 63 d0             	movslq %eax,%rdx
  803e6e:	48 89 d0             	mov    %rdx,%rax
  803e71:	48 c1 e0 03          	shl    $0x3,%rax
  803e75:	48 01 d0             	add    %rdx,%rax
  803e78:	48 c1 e0 05          	shl    $0x5,%rax
  803e7c:	48 01 c8             	add    %rcx,%rax
  803e7f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803e85:	8b 00                	mov    (%rax),%eax
  803e87:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803e8a:	75 2c                	jne    803eb8 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803e8c:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803e93:	00 00 00 
  803e96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e99:	48 63 d0             	movslq %eax,%rdx
  803e9c:	48 89 d0             	mov    %rdx,%rax
  803e9f:	48 c1 e0 03          	shl    $0x3,%rax
  803ea3:	48 01 d0             	add    %rdx,%rax
  803ea6:	48 c1 e0 05          	shl    $0x5,%rax
  803eaa:	48 01 c8             	add    %rcx,%rax
  803ead:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803eb3:	8b 40 08             	mov    0x8(%rax),%eax
  803eb6:	eb 12                	jmp    803eca <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803eb8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ebc:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803ec3:	7e 99                	jle    803e5e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803ec5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803eca:	c9                   	leaveq 
  803ecb:	c3                   	retq   

0000000000803ecc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ecc:	55                   	push   %rbp
  803ecd:	48 89 e5             	mov    %rsp,%rbp
  803ed0:	48 83 ec 18          	sub    $0x18,%rsp
  803ed4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803edc:	48 c1 e8 15          	shr    $0x15,%rax
  803ee0:	48 89 c2             	mov    %rax,%rdx
  803ee3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803eea:	01 00 00 
  803eed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ef1:	83 e0 01             	and    $0x1,%eax
  803ef4:	48 85 c0             	test   %rax,%rax
  803ef7:	75 07                	jne    803f00 <pageref+0x34>
		return 0;
  803ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  803efe:	eb 53                	jmp    803f53 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f04:	48 c1 e8 0c          	shr    $0xc,%rax
  803f08:	48 89 c2             	mov    %rax,%rdx
  803f0b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f12:	01 00 00 
  803f15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f19:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f21:	83 e0 01             	and    $0x1,%eax
  803f24:	48 85 c0             	test   %rax,%rax
  803f27:	75 07                	jne    803f30 <pageref+0x64>
		return 0;
  803f29:	b8 00 00 00 00       	mov    $0x0,%eax
  803f2e:	eb 23                	jmp    803f53 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803f30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f34:	48 c1 e8 0c          	shr    $0xc,%rax
  803f38:	48 89 c2             	mov    %rax,%rdx
  803f3b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803f42:	00 00 00 
  803f45:	48 c1 e2 04          	shl    $0x4,%rdx
  803f49:	48 01 d0             	add    %rdx,%rax
  803f4c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f50:	0f b7 c0             	movzwl %ax,%eax
}
  803f53:	c9                   	leaveq 
  803f54:	c3                   	retq   
