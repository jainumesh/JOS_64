
obj/user/testkbd.debug:     file format elf64-x86-64


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
  80003c:	e8 2a 04 00 00       	callq  80046b <libmain>
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
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800059:	eb 10                	jmp    80006b <umain+0x28>
		sys_yield();
  80005b:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800067:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80006b:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  80006f:	7e ea                	jle    80005b <umain+0x18>
		sys_yield();

	close(0);
  800071:	bf 00 00 00 00       	mov    $0x0,%edi
  800076:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  80007d:	00 00 00 
  800080:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800082:	48 b8 79 02 80 00 00 	movabs $0x800279,%rax
  800089:	00 00 00 
  80008c:	ff d0                	callq  *%rax
  80008e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800091:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800095:	79 30                	jns    8000c7 <umain+0x84>
		panic("opencons: %e", r);
  800097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80009a:	89 c1                	mov    %eax,%ecx
  80009c:	48 ba 20 44 80 00 00 	movabs $0x804420,%rdx
  8000a3:	00 00 00 
  8000a6:	be 0f 00 00 00       	mov    $0xf,%esi
  8000ab:	48 bf 2d 44 80 00 00 	movabs $0x80442d,%rdi
  8000b2:	00 00 00 
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	49 b8 19 05 80 00 00 	movabs $0x800519,%r8
  8000c1:	00 00 00 
  8000c4:	41 ff d0             	callq  *%r8
	if (r != 0)
  8000c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cb:	74 30                	je     8000fd <umain+0xba>
		panic("first opencons used fd %d", r);
  8000cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 3c 44 80 00 00 	movabs $0x80443c,%rdx
  8000d9:	00 00 00 
  8000dc:	be 11 00 00 00       	mov    $0x11,%esi
  8000e1:	48 bf 2d 44 80 00 00 	movabs $0x80442d,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 19 05 80 00 00 	movabs $0x800519,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fd:	be 01 00 00 00       	mov    $0x1,%esi
  800102:	bf 00 00 00 00       	mov    $0x0,%edi
  800107:	48 b8 38 24 80 00 00 	movabs $0x802438,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
  800113:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800116:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011a:	79 30                	jns    80014c <umain+0x109>
		panic("dup: %e", r);
  80011c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80011f:	89 c1                	mov    %eax,%ecx
  800121:	48 ba 56 44 80 00 00 	movabs $0x804456,%rdx
  800128:	00 00 00 
  80012b:	be 13 00 00 00       	mov    $0x13,%esi
  800130:	48 bf 2d 44 80 00 00 	movabs $0x80442d,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	49 b8 19 05 80 00 00 	movabs $0x800519,%r8
  800146:	00 00 00 
  800149:	41 ff d0             	callq  *%r8

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80014c:	48 bf 5e 44 80 00 00 	movabs $0x80445e,%rdi
  800153:	00 00 00 
  800156:	48 b8 9b 12 80 00 00 	movabs $0x80129b,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (buf != NULL)
  800166:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80016b:	74 29                	je     800196 <umain+0x153>
			fprintf(1, "%s\n", buf);
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	48 89 c2             	mov    %rax,%rdx
  800174:	48 be 6c 44 80 00 00 	movabs $0x80446c,%rsi
  80017b:	00 00 00 
  80017e:	bf 01 00 00 00       	mov    $0x1,%edi
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	48 b9 63 32 80 00 00 	movabs $0x803263,%rcx
  80018f:	00 00 00 
  800192:	ff d1                	callq  *%rcx
		else
			fprintf(1, "(end of file received)\n");
	}
  800194:	eb b6                	jmp    80014c <umain+0x109>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  800196:	48 be 70 44 80 00 00 	movabs $0x804470,%rsi
  80019d:	00 00 00 
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	48 ba 63 32 80 00 00 	movabs $0x803263,%rdx
  8001b1:	00 00 00 
  8001b4:	ff d2                	callq  *%rdx
	}
  8001b6:	eb 94                	jmp    80014c <umain+0x109>

00000000008001b8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 20          	sub    $0x20,%rsp
  8001c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001c9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8001cd:	be 01 00 00 00       	mov    $0x1,%esi
  8001d2:	48 89 c7             	mov    %rax,%rdi
  8001d5:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <getchar>:

int
getchar(void)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001eb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8001ef:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f4:	48 89 c6             	mov    %rax,%rsi
  8001f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fc:	48 b8 e1 25 80 00 00 	movabs $0x8025e1,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
  800208:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80020b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80020f:	79 05                	jns    800216 <getchar+0x33>
		return r;
  800211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800214:	eb 14                	jmp    80022a <getchar+0x47>
	if (r < 1)
  800216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021a:	7f 07                	jg     800223 <getchar+0x40>
		return -E_EOF;
  80021c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800221:	eb 07                	jmp    80022a <getchar+0x47>
	return c;
  800223:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800227:	0f b6 c0             	movzbl %al,%eax
}
  80022a:	c9                   	leaveq 
  80022b:	c3                   	retq   

000000000080022c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	48 83 ec 20          	sub    $0x20,%rsp
  800234:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800237:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80023b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023e:	48 89 d6             	mov    %rdx,%rsi
  800241:	89 c7                	mov    %eax,%edi
  800243:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
  80024f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800256:	79 05                	jns    80025d <iscons+0x31>
		return r;
  800258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025b:	eb 1a                	jmp    800277 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80025d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800261:	8b 10                	mov    (%rax),%edx
  800263:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	39 c2                	cmp    %eax,%edx
  800271:	0f 94 c0             	sete   %al
  800274:	0f b6 c0             	movzbl %al,%eax
}
  800277:	c9                   	leaveq 
  800278:	c3                   	retq   

0000000000800279 <opencons>:

int
opencons(void)
{
  800279:	55                   	push   %rbp
  80027a:	48 89 e5             	mov    %rsp,%rbp
  80027d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800281:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800285:	48 89 c7             	mov    %rax,%rdi
  800288:	48 b8 17 21 80 00 00 	movabs $0x802117,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
  800294:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800297:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029b:	79 05                	jns    8002a2 <opencons+0x29>
		return r;
  80029d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a0:	eb 5b                	jmp    8002fd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b3:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
  8002bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c6:	79 05                	jns    8002cd <opencons+0x54>
		return r;
  8002c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cb:	eb 30                	jmp    8002fd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8002cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d1:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8002d8:	00 00 00 
  8002db:	8b 12                	mov    (%rdx),%edx
  8002dd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8002df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8002ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ee:	48 89 c7             	mov    %rax,%rdi
  8002f1:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
}
  8002fd:	c9                   	leaveq 
  8002fe:	c3                   	retq   

00000000008002ff <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002ff:	55                   	push   %rbp
  800300:	48 89 e5             	mov    %rsp,%rbp
  800303:	48 83 ec 30          	sub    $0x30,%rsp
  800307:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80030f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800313:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800318:	75 07                	jne    800321 <devcons_read+0x22>
		return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
  80031f:	eb 4b                	jmp    80036c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800321:	eb 0c                	jmp    80032f <devcons_read+0x30>
		sys_yield();
  800323:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  80032a:	00 00 00 
  80032d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80032f:	48 b8 92 1c 80 00 00 	movabs $0x801c92,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax
  80033b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80033e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800342:	74 df                	je     800323 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800348:	79 05                	jns    80034f <devcons_read+0x50>
		return c;
  80034a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034d:	eb 1d                	jmp    80036c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80034f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800353:	75 07                	jne    80035c <devcons_read+0x5d>
		return 0;
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	eb 10                	jmp    80036c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80035c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035f:	89 c2                	mov    %eax,%edx
  800361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800365:	88 10                	mov    %dl,(%rax)
	return 1;
  800367:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80036c:	c9                   	leaveq 
  80036d:	c3                   	retq   

000000000080036e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80036e:	55                   	push   %rbp
  80036f:	48 89 e5             	mov    %rsp,%rbp
  800372:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800379:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800380:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800387:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80038e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800395:	eb 76                	jmp    80040d <devcons_write+0x9f>
		m = n - tot;
  800397:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80039e:	89 c2                	mov    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a3:	29 c2                	sub    %eax,%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8003aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ad:	83 f8 7f             	cmp    $0x7f,%eax
  8003b0:	76 07                	jbe    8003b9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8003b2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8003b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003bc:	48 63 d0             	movslq %eax,%rdx
  8003bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c2:	48 63 c8             	movslq %eax,%rcx
  8003c5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8003cc:	48 01 c1             	add    %rax,%rcx
  8003cf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003d6:	48 89 ce             	mov    %rcx,%rsi
  8003d9:	48 89 c7             	mov    %rax,%rdi
  8003dc:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8003e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003eb:	48 63 d0             	movslq %eax,%rdx
  8003ee:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003f5:	48 89 d6             	mov    %rdx,%rsi
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800407:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80040d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800410:	48 98                	cltq   
  800412:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800419:	0f 82 78 ff ff ff    	jb     800397 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80041f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800422:	c9                   	leaveq 
  800423:	c3                   	retq   

0000000000800424 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 08          	sub    $0x8,%rsp
  80042c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800435:	c9                   	leaveq 
  800436:	c3                   	retq   

0000000000800437 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800437:	55                   	push   %rbp
  800438:	48 89 e5             	mov    %rsp,%rbp
  80043b:	48 83 ec 10          	sub    $0x10,%rsp
  80043f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800443:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044b:	48 be 8d 44 80 00 00 	movabs $0x80448d,%rsi
  800452:	00 00 00 
  800455:	48 89 c7             	mov    %rax,%rdi
  800458:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  80045f:	00 00 00 
  800462:	ff d0                	callq  *%rax
	return 0;
  800464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800469:	c9                   	leaveq 
  80046a:	c3                   	retq   

000000000080046b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80046b:	55                   	push   %rbp
  80046c:	48 89 e5             	mov    %rsp,%rbp
  80046f:	48 83 ec 10          	sub    $0x10,%rsp
  800473:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800476:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80047a:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
  800486:	25 ff 03 00 00       	and    $0x3ff,%eax
  80048b:	48 63 d0             	movslq %eax,%rdx
  80048e:	48 89 d0             	mov    %rdx,%rax
  800491:	48 c1 e0 03          	shl    $0x3,%rax
  800495:	48 01 d0             	add    %rdx,%rax
  800498:	48 c1 e0 05          	shl    $0x5,%rax
  80049c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8004a3:	00 00 00 
  8004a6:	48 01 c2             	add    %rax,%rdx
  8004a9:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8004b0:	00 00 00 
  8004b3:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004ba:	7e 14                	jle    8004d0 <libmain+0x65>
		binaryname = argv[0];
  8004bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c0:	48 8b 10             	mov    (%rax),%rdx
  8004c3:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8004ca:	00 00 00 
  8004cd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d7:	48 89 d6             	mov    %rdx,%rsi
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004e3:	00 00 00 
  8004e6:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8004e8:	48 b8 f6 04 80 00 00 	movabs $0x8004f6,%rax
  8004ef:	00 00 00 
  8004f2:	ff d0                	callq  *%rax
}
  8004f4:	c9                   	leaveq 
  8004f5:	c3                   	retq   

00000000008004f6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004f6:	55                   	push   %rbp
  8004f7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8004fa:	48 b8 0a 24 80 00 00 	movabs $0x80240a,%rax
  800501:	00 00 00 
  800504:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800506:	bf 00 00 00 00       	mov    $0x0,%edi
  80050b:	48 b8 d0 1c 80 00 00 	movabs $0x801cd0,%rax
  800512:	00 00 00 
  800515:	ff d0                	callq  *%rax

}
  800517:	5d                   	pop    %rbp
  800518:	c3                   	retq   

0000000000800519 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800519:	55                   	push   %rbp
  80051a:	48 89 e5             	mov    %rsp,%rbp
  80051d:	53                   	push   %rbx
  80051e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800525:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80052c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800532:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800539:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800540:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800547:	84 c0                	test   %al,%al
  800549:	74 23                	je     80056e <_panic+0x55>
  80054b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800552:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800556:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80055a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80055e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800562:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800566:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80056a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80056e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800575:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80057c:	00 00 00 
  80057f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800586:	00 00 00 
  800589:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80058d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800594:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80059b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005a2:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8005a9:	00 00 00 
  8005ac:	48 8b 18             	mov    (%rax),%rbx
  8005af:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  8005b6:	00 00 00 
  8005b9:	ff d0                	callq  *%rax
  8005bb:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005c1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005c8:	41 89 c8             	mov    %ecx,%r8d
  8005cb:	48 89 d1             	mov    %rdx,%rcx
  8005ce:	48 89 da             	mov    %rbx,%rdx
  8005d1:	89 c6                	mov    %eax,%esi
  8005d3:	48 bf a0 44 80 00 00 	movabs $0x8044a0,%rdi
  8005da:	00 00 00 
  8005dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e2:	49 b9 52 07 80 00 00 	movabs $0x800752,%r9
  8005e9:	00 00 00 
  8005ec:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005ef:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005f6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005fd:	48 89 d6             	mov    %rdx,%rsi
  800600:	48 89 c7             	mov    %rax,%rdi
  800603:	48 b8 a6 06 80 00 00 	movabs $0x8006a6,%rax
  80060a:	00 00 00 
  80060d:	ff d0                	callq  *%rax
	cprintf("\n");
  80060f:	48 bf c3 44 80 00 00 	movabs $0x8044c3,%rdi
  800616:	00 00 00 
  800619:	b8 00 00 00 00       	mov    $0x0,%eax
  80061e:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  800625:	00 00 00 
  800628:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80062a:	cc                   	int3   
  80062b:	eb fd                	jmp    80062a <_panic+0x111>

000000000080062d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80062d:	55                   	push   %rbp
  80062e:	48 89 e5             	mov    %rsp,%rbp
  800631:	48 83 ec 10          	sub    $0x10,%rsp
  800635:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800638:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80063c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800640:	8b 00                	mov    (%rax),%eax
  800642:	8d 48 01             	lea    0x1(%rax),%ecx
  800645:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800649:	89 0a                	mov    %ecx,(%rdx)
  80064b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80064e:	89 d1                	mov    %edx,%ecx
  800650:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800654:	48 98                	cltq   
  800656:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80065a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065e:	8b 00                	mov    (%rax),%eax
  800660:	3d ff 00 00 00       	cmp    $0xff,%eax
  800665:	75 2c                	jne    800693 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800667:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80066b:	8b 00                	mov    (%rax),%eax
  80066d:	48 98                	cltq   
  80066f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800673:	48 83 c2 08          	add    $0x8,%rdx
  800677:	48 89 c6             	mov    %rax,%rsi
  80067a:	48 89 d7             	mov    %rdx,%rdi
  80067d:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  800684:	00 00 00 
  800687:	ff d0                	callq  *%rax
        b->idx = 0;
  800689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800697:	8b 40 04             	mov    0x4(%rax),%eax
  80069a:	8d 50 01             	lea    0x1(%rax),%edx
  80069d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a1:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006a4:	c9                   	leaveq 
  8006a5:	c3                   	retq   

00000000008006a6 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8006a6:	55                   	push   %rbp
  8006a7:	48 89 e5             	mov    %rsp,%rbp
  8006aa:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006b1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006b8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006bf:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006c6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006cd:	48 8b 0a             	mov    (%rdx),%rcx
  8006d0:	48 89 08             	mov    %rcx,(%rax)
  8006d3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006db:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006df:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006ea:	00 00 00 
    b.cnt = 0;
  8006ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006f4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006f7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006fe:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800705:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80070c:	48 89 c6             	mov    %rax,%rsi
  80070f:	48 bf 2d 06 80 00 00 	movabs $0x80062d,%rdi
  800716:	00 00 00 
  800719:	48 b8 05 0b 80 00 00 	movabs $0x800b05,%rax
  800720:	00 00 00 
  800723:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800725:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80072b:	48 98                	cltq   
  80072d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800734:	48 83 c2 08          	add    $0x8,%rdx
  800738:	48 89 c6             	mov    %rax,%rsi
  80073b:	48 89 d7             	mov    %rdx,%rdi
  80073e:	48 b8 48 1c 80 00 00 	movabs $0x801c48,%rax
  800745:	00 00 00 
  800748:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80074a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800750:	c9                   	leaveq 
  800751:	c3                   	retq   

0000000000800752 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800752:	55                   	push   %rbp
  800753:	48 89 e5             	mov    %rsp,%rbp
  800756:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80075d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800764:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80076b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800772:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800779:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800780:	84 c0                	test   %al,%al
  800782:	74 20                	je     8007a4 <cprintf+0x52>
  800784:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800788:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80078c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800790:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800794:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800798:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80079c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007a0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007a4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007ab:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007b2:	00 00 00 
  8007b5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007bc:	00 00 00 
  8007bf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007c3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007ca:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007d1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007d8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007df:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007e6:	48 8b 0a             	mov    (%rdx),%rcx
  8007e9:	48 89 08             	mov    %rcx,(%rax)
  8007ec:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007f0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007f4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007f8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007fc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800803:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80080a:	48 89 d6             	mov    %rdx,%rsi
  80080d:	48 89 c7             	mov    %rax,%rdi
  800810:	48 b8 a6 06 80 00 00 	movabs $0x8006a6,%rax
  800817:	00 00 00 
  80081a:	ff d0                	callq  *%rax
  80081c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800822:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800828:	c9                   	leaveq 
  800829:	c3                   	retq   

000000000080082a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80082a:	55                   	push   %rbp
  80082b:	48 89 e5             	mov    %rsp,%rbp
  80082e:	53                   	push   %rbx
  80082f:	48 83 ec 38          	sub    $0x38,%rsp
  800833:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800837:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80083b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80083f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800842:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800846:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80084a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80084d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800851:	77 3b                	ja     80088e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800853:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800856:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80085a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80085d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800861:	ba 00 00 00 00       	mov    $0x0,%edx
  800866:	48 f7 f3             	div    %rbx
  800869:	48 89 c2             	mov    %rax,%rdx
  80086c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80086f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800872:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087a:	41 89 f9             	mov    %edi,%r9d
  80087d:	48 89 c7             	mov    %rax,%rdi
  800880:	48 b8 2a 08 80 00 00 	movabs $0x80082a,%rax
  800887:	00 00 00 
  80088a:	ff d0                	callq  *%rax
  80088c:	eb 1e                	jmp    8008ac <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80088e:	eb 12                	jmp    8008a2 <printnum+0x78>
			putch(padc, putdat);
  800890:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800894:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089b:	48 89 ce             	mov    %rcx,%rsi
  80089e:	89 d7                	mov    %edx,%edi
  8008a0:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a2:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008a6:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008aa:	7f e4                	jg     800890 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008ac:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b8:	48 f7 f1             	div    %rcx
  8008bb:	48 89 d0             	mov    %rdx,%rax
  8008be:	48 ba d0 46 80 00 00 	movabs $0x8046d0,%rdx
  8008c5:	00 00 00 
  8008c8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008cc:	0f be d0             	movsbl %al,%edx
  8008cf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d7:	48 89 ce             	mov    %rcx,%rsi
  8008da:	89 d7                	mov    %edx,%edi
  8008dc:	ff d0                	callq  *%rax
}
  8008de:	48 83 c4 38          	add    $0x38,%rsp
  8008e2:	5b                   	pop    %rbx
  8008e3:	5d                   	pop    %rbp
  8008e4:	c3                   	retq   

00000000008008e5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008e5:	55                   	push   %rbp
  8008e6:	48 89 e5             	mov    %rsp,%rbp
  8008e9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008f4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f8:	7e 52                	jle    80094c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fe:	8b 00                	mov    (%rax),%eax
  800900:	83 f8 30             	cmp    $0x30,%eax
  800903:	73 24                	jae    800929 <getuint+0x44>
  800905:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800909:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80090d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800911:	8b 00                	mov    (%rax),%eax
  800913:	89 c0                	mov    %eax,%eax
  800915:	48 01 d0             	add    %rdx,%rax
  800918:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091c:	8b 12                	mov    (%rdx),%edx
  80091e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800921:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800925:	89 0a                	mov    %ecx,(%rdx)
  800927:	eb 17                	jmp    800940 <getuint+0x5b>
  800929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800931:	48 89 d0             	mov    %rdx,%rax
  800934:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800938:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800940:	48 8b 00             	mov    (%rax),%rax
  800943:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800947:	e9 a3 00 00 00       	jmpq   8009ef <getuint+0x10a>
	else if (lflag)
  80094c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800950:	74 4f                	je     8009a1 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800952:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800956:	8b 00                	mov    (%rax),%eax
  800958:	83 f8 30             	cmp    $0x30,%eax
  80095b:	73 24                	jae    800981 <getuint+0x9c>
  80095d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800961:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800969:	8b 00                	mov    (%rax),%eax
  80096b:	89 c0                	mov    %eax,%eax
  80096d:	48 01 d0             	add    %rdx,%rax
  800970:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800974:	8b 12                	mov    (%rdx),%edx
  800976:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800979:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097d:	89 0a                	mov    %ecx,(%rdx)
  80097f:	eb 17                	jmp    800998 <getuint+0xb3>
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800989:	48 89 d0             	mov    %rdx,%rax
  80098c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800990:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800994:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800998:	48 8b 00             	mov    (%rax),%rax
  80099b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80099f:	eb 4e                	jmp    8009ef <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a5:	8b 00                	mov    (%rax),%eax
  8009a7:	83 f8 30             	cmp    $0x30,%eax
  8009aa:	73 24                	jae    8009d0 <getuint+0xeb>
  8009ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b8:	8b 00                	mov    (%rax),%eax
  8009ba:	89 c0                	mov    %eax,%eax
  8009bc:	48 01 d0             	add    %rdx,%rax
  8009bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c3:	8b 12                	mov    (%rdx),%edx
  8009c5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cc:	89 0a                	mov    %ecx,(%rdx)
  8009ce:	eb 17                	jmp    8009e7 <getuint+0x102>
  8009d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d8:	48 89 d0             	mov    %rdx,%rax
  8009db:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e7:	8b 00                	mov    (%rax),%eax
  8009e9:	89 c0                	mov    %eax,%eax
  8009eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f3:	c9                   	leaveq 
  8009f4:	c3                   	retq   

00000000008009f5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009f5:	55                   	push   %rbp
  8009f6:	48 89 e5             	mov    %rsp,%rbp
  8009f9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a01:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a04:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a08:	7e 52                	jle    800a5c <getint+0x67>
		x=va_arg(*ap, long long);
  800a0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0e:	8b 00                	mov    (%rax),%eax
  800a10:	83 f8 30             	cmp    $0x30,%eax
  800a13:	73 24                	jae    800a39 <getint+0x44>
  800a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a19:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a21:	8b 00                	mov    (%rax),%eax
  800a23:	89 c0                	mov    %eax,%eax
  800a25:	48 01 d0             	add    %rdx,%rax
  800a28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2c:	8b 12                	mov    (%rdx),%edx
  800a2e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a35:	89 0a                	mov    %ecx,(%rdx)
  800a37:	eb 17                	jmp    800a50 <getint+0x5b>
  800a39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a41:	48 89 d0             	mov    %rdx,%rax
  800a44:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a50:	48 8b 00             	mov    (%rax),%rax
  800a53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a57:	e9 a3 00 00 00       	jmpq   800aff <getint+0x10a>
	else if (lflag)
  800a5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a60:	74 4f                	je     800ab1 <getint+0xbc>
		x=va_arg(*ap, long);
  800a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a66:	8b 00                	mov    (%rax),%eax
  800a68:	83 f8 30             	cmp    $0x30,%eax
  800a6b:	73 24                	jae    800a91 <getint+0x9c>
  800a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a71:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a79:	8b 00                	mov    (%rax),%eax
  800a7b:	89 c0                	mov    %eax,%eax
  800a7d:	48 01 d0             	add    %rdx,%rax
  800a80:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a84:	8b 12                	mov    (%rdx),%edx
  800a86:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a89:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8d:	89 0a                	mov    %ecx,(%rdx)
  800a8f:	eb 17                	jmp    800aa8 <getint+0xb3>
  800a91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a95:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a99:	48 89 d0             	mov    %rdx,%rax
  800a9c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aa0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa8:	48 8b 00             	mov    (%rax),%rax
  800aab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aaf:	eb 4e                	jmp    800aff <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ab1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab5:	8b 00                	mov    (%rax),%eax
  800ab7:	83 f8 30             	cmp    $0x30,%eax
  800aba:	73 24                	jae    800ae0 <getint+0xeb>
  800abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ac4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac8:	8b 00                	mov    (%rax),%eax
  800aca:	89 c0                	mov    %eax,%eax
  800acc:	48 01 d0             	add    %rdx,%rax
  800acf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad3:	8b 12                	mov    (%rdx),%edx
  800ad5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800adc:	89 0a                	mov    %ecx,(%rdx)
  800ade:	eb 17                	jmp    800af7 <getint+0x102>
  800ae0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ae8:	48 89 d0             	mov    %rdx,%rax
  800aeb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800af7:	8b 00                	mov    (%rax),%eax
  800af9:	48 98                	cltq   
  800afb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800aff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b03:	c9                   	leaveq 
  800b04:	c3                   	retq   

0000000000800b05 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b05:	55                   	push   %rbp
  800b06:	48 89 e5             	mov    %rsp,%rbp
  800b09:	41 54                	push   %r12
  800b0b:	53                   	push   %rbx
  800b0c:	48 83 ec 60          	sub    $0x60,%rsp
  800b10:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b14:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b18:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b1c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b20:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b24:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b28:	48 8b 0a             	mov    (%rdx),%rcx
  800b2b:	48 89 08             	mov    %rcx,(%rax)
  800b2e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b32:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b36:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b3a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3e:	eb 17                	jmp    800b57 <vprintfmt+0x52>
			if (ch == '\0')
  800b40:	85 db                	test   %ebx,%ebx
  800b42:	0f 84 cc 04 00 00    	je     801014 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800b48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b50:	48 89 d6             	mov    %rdx,%rsi
  800b53:	89 df                	mov    %ebx,%edi
  800b55:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b57:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b5b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b5f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b63:	0f b6 00             	movzbl (%rax),%eax
  800b66:	0f b6 d8             	movzbl %al,%ebx
  800b69:	83 fb 25             	cmp    $0x25,%ebx
  800b6c:	75 d2                	jne    800b40 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b6e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b72:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b79:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b80:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b87:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b8e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b92:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b96:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b9a:	0f b6 00             	movzbl (%rax),%eax
  800b9d:	0f b6 d8             	movzbl %al,%ebx
  800ba0:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800ba3:	83 f8 55             	cmp    $0x55,%eax
  800ba6:	0f 87 34 04 00 00    	ja     800fe0 <vprintfmt+0x4db>
  800bac:	89 c0                	mov    %eax,%eax
  800bae:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bb5:	00 
  800bb6:	48 b8 f8 46 80 00 00 	movabs $0x8046f8,%rax
  800bbd:	00 00 00 
  800bc0:	48 01 d0             	add    %rdx,%rax
  800bc3:	48 8b 00             	mov    (%rax),%rax
  800bc6:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bc8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bcc:	eb c0                	jmp    800b8e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bce:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bd2:	eb ba                	jmp    800b8e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bd4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bdb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bde:	89 d0                	mov    %edx,%eax
  800be0:	c1 e0 02             	shl    $0x2,%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	01 c0                	add    %eax,%eax
  800be7:	01 d8                	add    %ebx,%eax
  800be9:	83 e8 30             	sub    $0x30,%eax
  800bec:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bef:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bf3:	0f b6 00             	movzbl (%rax),%eax
  800bf6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bf9:	83 fb 2f             	cmp    $0x2f,%ebx
  800bfc:	7e 0c                	jle    800c0a <vprintfmt+0x105>
  800bfe:	83 fb 39             	cmp    $0x39,%ebx
  800c01:	7f 07                	jg     800c0a <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c03:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c08:	eb d1                	jmp    800bdb <vprintfmt+0xd6>
			goto process_precision;
  800c0a:	eb 58                	jmp    800c64 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c0f:	83 f8 30             	cmp    $0x30,%eax
  800c12:	73 17                	jae    800c2b <vprintfmt+0x126>
  800c14:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1b:	89 c0                	mov    %eax,%eax
  800c1d:	48 01 d0             	add    %rdx,%rax
  800c20:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c23:	83 c2 08             	add    $0x8,%edx
  800c26:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c29:	eb 0f                	jmp    800c3a <vprintfmt+0x135>
  800c2b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c2f:	48 89 d0             	mov    %rdx,%rax
  800c32:	48 83 c2 08          	add    $0x8,%rdx
  800c36:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c3a:	8b 00                	mov    (%rax),%eax
  800c3c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c3f:	eb 23                	jmp    800c64 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c45:	79 0c                	jns    800c53 <vprintfmt+0x14e>
				width = 0;
  800c47:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c4e:	e9 3b ff ff ff       	jmpq   800b8e <vprintfmt+0x89>
  800c53:	e9 36 ff ff ff       	jmpq   800b8e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c58:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c5f:	e9 2a ff ff ff       	jmpq   800b8e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c64:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c68:	79 12                	jns    800c7c <vprintfmt+0x177>
				width = precision, precision = -1;
  800c6a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c6d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c70:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c77:	e9 12 ff ff ff       	jmpq   800b8e <vprintfmt+0x89>
  800c7c:	e9 0d ff ff ff       	jmpq   800b8e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c81:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c85:	e9 04 ff ff ff       	jmpq   800b8e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8d:	83 f8 30             	cmp    $0x30,%eax
  800c90:	73 17                	jae    800ca9 <vprintfmt+0x1a4>
  800c92:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c99:	89 c0                	mov    %eax,%eax
  800c9b:	48 01 d0             	add    %rdx,%rax
  800c9e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca1:	83 c2 08             	add    $0x8,%edx
  800ca4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ca7:	eb 0f                	jmp    800cb8 <vprintfmt+0x1b3>
  800ca9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cad:	48 89 d0             	mov    %rdx,%rax
  800cb0:	48 83 c2 08          	add    $0x8,%rdx
  800cb4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb8:	8b 10                	mov    (%rax),%edx
  800cba:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc2:	48 89 ce             	mov    %rcx,%rsi
  800cc5:	89 d7                	mov    %edx,%edi
  800cc7:	ff d0                	callq  *%rax
			break;
  800cc9:	e9 40 03 00 00       	jmpq   80100e <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd1:	83 f8 30             	cmp    $0x30,%eax
  800cd4:	73 17                	jae    800ced <vprintfmt+0x1e8>
  800cd6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cda:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cdd:	89 c0                	mov    %eax,%eax
  800cdf:	48 01 d0             	add    %rdx,%rax
  800ce2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce5:	83 c2 08             	add    $0x8,%edx
  800ce8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ceb:	eb 0f                	jmp    800cfc <vprintfmt+0x1f7>
  800ced:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf1:	48 89 d0             	mov    %rdx,%rax
  800cf4:	48 83 c2 08          	add    $0x8,%rdx
  800cf8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cfc:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cfe:	85 db                	test   %ebx,%ebx
  800d00:	79 02                	jns    800d04 <vprintfmt+0x1ff>
				err = -err;
  800d02:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d04:	83 fb 15             	cmp    $0x15,%ebx
  800d07:	7f 16                	jg     800d1f <vprintfmt+0x21a>
  800d09:	48 b8 20 46 80 00 00 	movabs $0x804620,%rax
  800d10:	00 00 00 
  800d13:	48 63 d3             	movslq %ebx,%rdx
  800d16:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d1a:	4d 85 e4             	test   %r12,%r12
  800d1d:	75 2e                	jne    800d4d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d1f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d27:	89 d9                	mov    %ebx,%ecx
  800d29:	48 ba e1 46 80 00 00 	movabs $0x8046e1,%rdx
  800d30:	00 00 00 
  800d33:	48 89 c7             	mov    %rax,%rdi
  800d36:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3b:	49 b8 1d 10 80 00 00 	movabs $0x80101d,%r8
  800d42:	00 00 00 
  800d45:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d48:	e9 c1 02 00 00       	jmpq   80100e <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d4d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d55:	4c 89 e1             	mov    %r12,%rcx
  800d58:	48 ba ea 46 80 00 00 	movabs $0x8046ea,%rdx
  800d5f:	00 00 00 
  800d62:	48 89 c7             	mov    %rax,%rdi
  800d65:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6a:	49 b8 1d 10 80 00 00 	movabs $0x80101d,%r8
  800d71:	00 00 00 
  800d74:	41 ff d0             	callq  *%r8
			break;
  800d77:	e9 92 02 00 00       	jmpq   80100e <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d7f:	83 f8 30             	cmp    $0x30,%eax
  800d82:	73 17                	jae    800d9b <vprintfmt+0x296>
  800d84:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8b:	89 c0                	mov    %eax,%eax
  800d8d:	48 01 d0             	add    %rdx,%rax
  800d90:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d93:	83 c2 08             	add    $0x8,%edx
  800d96:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d99:	eb 0f                	jmp    800daa <vprintfmt+0x2a5>
  800d9b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d9f:	48 89 d0             	mov    %rdx,%rax
  800da2:	48 83 c2 08          	add    $0x8,%rdx
  800da6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800daa:	4c 8b 20             	mov    (%rax),%r12
  800dad:	4d 85 e4             	test   %r12,%r12
  800db0:	75 0a                	jne    800dbc <vprintfmt+0x2b7>
				p = "(null)";
  800db2:	49 bc ed 46 80 00 00 	movabs $0x8046ed,%r12
  800db9:	00 00 00 
			if (width > 0 && padc != '-')
  800dbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dc0:	7e 3f                	jle    800e01 <vprintfmt+0x2fc>
  800dc2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dc6:	74 39                	je     800e01 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dcb:	48 98                	cltq   
  800dcd:	48 89 c6             	mov    %rax,%rsi
  800dd0:	4c 89 e7             	mov    %r12,%rdi
  800dd3:	48 b8 23 14 80 00 00 	movabs $0x801423,%rax
  800dda:	00 00 00 
  800ddd:	ff d0                	callq  *%rax
  800ddf:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800de2:	eb 17                	jmp    800dfb <vprintfmt+0x2f6>
					putch(padc, putdat);
  800de4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800de8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df0:	48 89 ce             	mov    %rcx,%rsi
  800df3:	89 d7                	mov    %edx,%edi
  800df5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dfb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dff:	7f e3                	jg     800de4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e01:	eb 37                	jmp    800e3a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e03:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e07:	74 1e                	je     800e27 <vprintfmt+0x322>
  800e09:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0c:	7e 05                	jle    800e13 <vprintfmt+0x30e>
  800e0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800e11:	7e 14                	jle    800e27 <vprintfmt+0x322>
					putch('?', putdat);
  800e13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1b:	48 89 d6             	mov    %rdx,%rsi
  800e1e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e23:	ff d0                	callq  *%rax
  800e25:	eb 0f                	jmp    800e36 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2f:	48 89 d6             	mov    %rdx,%rsi
  800e32:	89 df                	mov    %ebx,%edi
  800e34:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e36:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e3a:	4c 89 e0             	mov    %r12,%rax
  800e3d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e41:	0f b6 00             	movzbl (%rax),%eax
  800e44:	0f be d8             	movsbl %al,%ebx
  800e47:	85 db                	test   %ebx,%ebx
  800e49:	74 10                	je     800e5b <vprintfmt+0x356>
  800e4b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e4f:	78 b2                	js     800e03 <vprintfmt+0x2fe>
  800e51:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e55:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e59:	79 a8                	jns    800e03 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5b:	eb 16                	jmp    800e73 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e65:	48 89 d6             	mov    %rdx,%rsi
  800e68:	bf 20 00 00 00       	mov    $0x20,%edi
  800e6d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e6f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e73:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e77:	7f e4                	jg     800e5d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800e79:	e9 90 01 00 00       	jmpq   80100e <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e7e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e82:	be 03 00 00 00       	mov    $0x3,%esi
  800e87:	48 89 c7             	mov    %rax,%rdi
  800e8a:	48 b8 f5 09 80 00 00 	movabs $0x8009f5,%rax
  800e91:	00 00 00 
  800e94:	ff d0                	callq  *%rax
  800e96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9e:	48 85 c0             	test   %rax,%rax
  800ea1:	79 1d                	jns    800ec0 <vprintfmt+0x3bb>
				putch('-', putdat);
  800ea3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eab:	48 89 d6             	mov    %rdx,%rsi
  800eae:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800eb3:	ff d0                	callq  *%rax
				num = -(long long) num;
  800eb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb9:	48 f7 d8             	neg    %rax
  800ebc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ec0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ec7:	e9 d5 00 00 00       	jmpq   800fa1 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ecc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ed0:	be 03 00 00 00       	mov    $0x3,%esi
  800ed5:	48 89 c7             	mov    %rax,%rdi
  800ed8:	48 b8 e5 08 80 00 00 	movabs $0x8008e5,%rax
  800edf:	00 00 00 
  800ee2:	ff d0                	callq  *%rax
  800ee4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ee8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eef:	e9 ad 00 00 00       	jmpq   800fa1 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800ef4:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800ef7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800efb:	89 d6                	mov    %edx,%esi
  800efd:	48 89 c7             	mov    %rax,%rdi
  800f00:	48 b8 f5 09 80 00 00 	movabs $0x8009f5,%rax
  800f07:	00 00 00 
  800f0a:	ff d0                	callq  *%rax
  800f0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f10:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f17:	e9 85 00 00 00       	jmpq   800fa1 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800f1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f24:	48 89 d6             	mov    %rdx,%rsi
  800f27:	bf 30 00 00 00       	mov    $0x30,%edi
  800f2c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f36:	48 89 d6             	mov    %rdx,%rsi
  800f39:	bf 78 00 00 00       	mov    $0x78,%edi
  800f3e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f43:	83 f8 30             	cmp    $0x30,%eax
  800f46:	73 17                	jae    800f5f <vprintfmt+0x45a>
  800f48:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f4c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f4f:	89 c0                	mov    %eax,%eax
  800f51:	48 01 d0             	add    %rdx,%rax
  800f54:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f57:	83 c2 08             	add    $0x8,%edx
  800f5a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f5d:	eb 0f                	jmp    800f6e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f5f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f63:	48 89 d0             	mov    %rdx,%rax
  800f66:	48 83 c2 08          	add    $0x8,%rdx
  800f6a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f6e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f75:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f7c:	eb 23                	jmp    800fa1 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f7e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f82:	be 03 00 00 00       	mov    $0x3,%esi
  800f87:	48 89 c7             	mov    %rax,%rdi
  800f8a:	48 b8 e5 08 80 00 00 	movabs $0x8008e5,%rax
  800f91:	00 00 00 
  800f94:	ff d0                	callq  *%rax
  800f96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f9a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fa1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fa6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fa9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb8:	45 89 c1             	mov    %r8d,%r9d
  800fbb:	41 89 f8             	mov    %edi,%r8d
  800fbe:	48 89 c7             	mov    %rax,%rdi
  800fc1:	48 b8 2a 08 80 00 00 	movabs $0x80082a,%rax
  800fc8:	00 00 00 
  800fcb:	ff d0                	callq  *%rax
			break;
  800fcd:	eb 3f                	jmp    80100e <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fcf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd7:	48 89 d6             	mov    %rdx,%rsi
  800fda:	89 df                	mov    %ebx,%edi
  800fdc:	ff d0                	callq  *%rax
			break;
  800fde:	eb 2e                	jmp    80100e <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe8:	48 89 d6             	mov    %rdx,%rsi
  800feb:	bf 25 00 00 00       	mov    $0x25,%edi
  800ff0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ff7:	eb 05                	jmp    800ffe <vprintfmt+0x4f9>
  800ff9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ffe:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801002:	48 83 e8 01          	sub    $0x1,%rax
  801006:	0f b6 00             	movzbl (%rax),%eax
  801009:	3c 25                	cmp    $0x25,%al
  80100b:	75 ec                	jne    800ff9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80100d:	90                   	nop
		}
	}
  80100e:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80100f:	e9 43 fb ff ff       	jmpq   800b57 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801014:	48 83 c4 60          	add    $0x60,%rsp
  801018:	5b                   	pop    %rbx
  801019:	41 5c                	pop    %r12
  80101b:	5d                   	pop    %rbp
  80101c:	c3                   	retq   

000000000080101d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80101d:	55                   	push   %rbp
  80101e:	48 89 e5             	mov    %rsp,%rbp
  801021:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801028:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80102f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801036:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80103d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801044:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80104b:	84 c0                	test   %al,%al
  80104d:	74 20                	je     80106f <printfmt+0x52>
  80104f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801053:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801057:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80105b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80105f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801063:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801067:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80106b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80106f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801076:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80107d:	00 00 00 
  801080:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801087:	00 00 00 
  80108a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80108e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801095:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80109c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010a3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010aa:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010b1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010b8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010bf:	48 89 c7             	mov    %rax,%rdi
  8010c2:	48 b8 05 0b 80 00 00 	movabs $0x800b05,%rax
  8010c9:	00 00 00 
  8010cc:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010ce:	c9                   	leaveq 
  8010cf:	c3                   	retq   

00000000008010d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010d0:	55                   	push   %rbp
  8010d1:	48 89 e5             	mov    %rsp,%rbp
  8010d4:	48 83 ec 10          	sub    $0x10,%rsp
  8010d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e3:	8b 40 10             	mov    0x10(%rax),%eax
  8010e6:	8d 50 01             	lea    0x1(%rax),%edx
  8010e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ed:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f4:	48 8b 10             	mov    (%rax),%rdx
  8010f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010ff:	48 39 c2             	cmp    %rax,%rdx
  801102:	73 17                	jae    80111b <sprintputch+0x4b>
		*b->buf++ = ch;
  801104:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801108:	48 8b 00             	mov    (%rax),%rax
  80110b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80110f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801113:	48 89 0a             	mov    %rcx,(%rdx)
  801116:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801119:	88 10                	mov    %dl,(%rax)
}
  80111b:	c9                   	leaveq 
  80111c:	c3                   	retq   

000000000080111d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80111d:	55                   	push   %rbp
  80111e:	48 89 e5             	mov    %rsp,%rbp
  801121:	48 83 ec 50          	sub    $0x50,%rsp
  801125:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801129:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80112c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801130:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801134:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801138:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80113c:	48 8b 0a             	mov    (%rdx),%rcx
  80113f:	48 89 08             	mov    %rcx,(%rax)
  801142:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801146:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80114a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80114e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801152:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801156:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80115a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80115d:	48 98                	cltq   
  80115f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801163:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801167:	48 01 d0             	add    %rdx,%rax
  80116a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80116e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801175:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80117a:	74 06                	je     801182 <vsnprintf+0x65>
  80117c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801180:	7f 07                	jg     801189 <vsnprintf+0x6c>
		return -E_INVAL;
  801182:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801187:	eb 2f                	jmp    8011b8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801189:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80118d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801191:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801195:	48 89 c6             	mov    %rax,%rsi
  801198:	48 bf d0 10 80 00 00 	movabs $0x8010d0,%rdi
  80119f:	00 00 00 
  8011a2:	48 b8 05 0b 80 00 00 	movabs $0x800b05,%rax
  8011a9:	00 00 00 
  8011ac:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011b2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011b5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011b8:	c9                   	leaveq 
  8011b9:	c3                   	retq   

00000000008011ba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011ba:	55                   	push   %rbp
  8011bb:	48 89 e5             	mov    %rsp,%rbp
  8011be:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011c5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011cc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011d2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011d9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011e0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011e7:	84 c0                	test   %al,%al
  8011e9:	74 20                	je     80120b <snprintf+0x51>
  8011eb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011ef:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011f3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011f7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011fb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011ff:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801203:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801207:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80120b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801212:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801219:	00 00 00 
  80121c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801223:	00 00 00 
  801226:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80122a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801231:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801238:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80123f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801246:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80124d:	48 8b 0a             	mov    (%rdx),%rcx
  801250:	48 89 08             	mov    %rcx,(%rax)
  801253:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801257:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80125b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80125f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801263:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80126a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801271:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801277:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80127e:	48 89 c7             	mov    %rax,%rdi
  801281:	48 b8 1d 11 80 00 00 	movabs $0x80111d,%rax
  801288:	00 00 00 
  80128b:	ff d0                	callq  *%rax
  80128d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801293:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801299:	c9                   	leaveq 
  80129a:	c3                   	retq   

000000000080129b <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  80129b:	55                   	push   %rbp
  80129c:	48 89 e5             	mov    %rsp,%rbp
  80129f:	48 83 ec 20          	sub    $0x20,%rsp
  8012a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8012a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ac:	74 27                	je     8012d5 <readline+0x3a>
		fprintf(1, "%s", prompt);
  8012ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b2:	48 89 c2             	mov    %rax,%rdx
  8012b5:	48 be a8 49 80 00 00 	movabs $0x8049a8,%rsi
  8012bc:	00 00 00 
  8012bf:	bf 01 00 00 00       	mov    $0x1,%edi
  8012c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c9:	48 b9 63 32 80 00 00 	movabs $0x803263,%rcx
  8012d0:	00 00 00 
  8012d3:	ff d1                	callq  *%rcx
#endif

	i = 0;
  8012d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8012dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8012e1:	48 b8 2c 02 80 00 00 	movabs $0x80022c,%rax
  8012e8:	00 00 00 
  8012eb:	ff d0                	callq  *%rax
  8012ed:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8012f0:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  8012f7:	00 00 00 
  8012fa:	ff d0                	callq  *%rax
  8012fc:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8012ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801303:	79 30                	jns    801335 <readline+0x9a>
			if (c != -E_EOF)
  801305:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  801309:	74 20                	je     80132b <readline+0x90>
				cprintf("read error: %e\n", c);
  80130b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130e:	89 c6                	mov    %eax,%esi
  801310:	48 bf ab 49 80 00 00 	movabs $0x8049ab,%rdi
  801317:	00 00 00 
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
  80131f:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  801326:	00 00 00 
  801329:	ff d2                	callq  *%rdx
			return NULL;
  80132b:	b8 00 00 00 00       	mov    $0x0,%eax
  801330:	e9 be 00 00 00       	jmpq   8013f3 <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801335:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  801339:	74 06                	je     801341 <readline+0xa6>
  80133b:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  80133f:	75 26                	jne    801367 <readline+0xcc>
  801341:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801345:	7e 20                	jle    801367 <readline+0xcc>
			if (echoing)
  801347:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80134b:	74 11                	je     80135e <readline+0xc3>
				cputchar('\b');
  80134d:	bf 08 00 00 00       	mov    $0x8,%edi
  801352:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801359:	00 00 00 
  80135c:	ff d0                	callq  *%rax
			i--;
  80135e:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  801362:	e9 87 00 00 00       	jmpq   8013ee <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801367:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  80136b:	7e 3f                	jle    8013ac <readline+0x111>
  80136d:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  801374:	7f 36                	jg     8013ac <readline+0x111>
			if (echoing)
  801376:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80137a:	74 11                	je     80138d <readline+0xf2>
				cputchar(c);
  80137c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137f:	89 c7                	mov    %eax,%edi
  801381:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801388:	00 00 00 
  80138b:	ff d0                	callq  *%rax
			buf[i++] = c;
  80138d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801390:	8d 50 01             	lea    0x1(%rax),%edx
  801393:	89 55 fc             	mov    %edx,-0x4(%rbp)
  801396:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801399:	89 d1                	mov    %edx,%ecx
  80139b:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8013a2:	00 00 00 
  8013a5:	48 98                	cltq   
  8013a7:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8013aa:	eb 42                	jmp    8013ee <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8013ac:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8013b0:	74 06                	je     8013b8 <readline+0x11d>
  8013b2:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8013b6:	75 36                	jne    8013ee <readline+0x153>
			if (echoing)
  8013b8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8013bc:	74 11                	je     8013cf <readline+0x134>
				cputchar('\n');
  8013be:	bf 0a 00 00 00       	mov    $0xa,%edi
  8013c3:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  8013ca:	00 00 00 
  8013cd:	ff d0                	callq  *%rax
			buf[i] = 0;
  8013cf:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8013d6:	00 00 00 
  8013d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013dc:	48 98                	cltq   
  8013de:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8013e2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8013e9:	00 00 00 
  8013ec:	eb 05                	jmp    8013f3 <readline+0x158>
		}
	}
  8013ee:	e9 fd fe ff ff       	jmpq   8012f0 <readline+0x55>
}
  8013f3:	c9                   	leaveq 
  8013f4:	c3                   	retq   

00000000008013f5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013f5:	55                   	push   %rbp
  8013f6:	48 89 e5             	mov    %rsp,%rbp
  8013f9:	48 83 ec 18          	sub    $0x18,%rsp
  8013fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801401:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801408:	eb 09                	jmp    801413 <strlen+0x1e>
		n++;
  80140a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80140e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801417:	0f b6 00             	movzbl (%rax),%eax
  80141a:	84 c0                	test   %al,%al
  80141c:	75 ec                	jne    80140a <strlen+0x15>
		n++;
	return n;
  80141e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801421:	c9                   	leaveq 
  801422:	c3                   	retq   

0000000000801423 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801423:	55                   	push   %rbp
  801424:	48 89 e5             	mov    %rsp,%rbp
  801427:	48 83 ec 20          	sub    $0x20,%rsp
  80142b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801433:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80143a:	eb 0e                	jmp    80144a <strnlen+0x27>
		n++;
  80143c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801440:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801445:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80144a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80144f:	74 0b                	je     80145c <strnlen+0x39>
  801451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	84 c0                	test   %al,%al
  80145a:	75 e0                	jne    80143c <strnlen+0x19>
		n++;
	return n;
  80145c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80145f:	c9                   	leaveq 
  801460:	c3                   	retq   

0000000000801461 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801461:	55                   	push   %rbp
  801462:	48 89 e5             	mov    %rsp,%rbp
  801465:	48 83 ec 20          	sub    $0x20,%rsp
  801469:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80146d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801475:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801479:	90                   	nop
  80147a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801482:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801486:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80148a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80148e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801492:	0f b6 12             	movzbl (%rdx),%edx
  801495:	88 10                	mov    %dl,(%rax)
  801497:	0f b6 00             	movzbl (%rax),%eax
  80149a:	84 c0                	test   %al,%al
  80149c:	75 dc                	jne    80147a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80149e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014a2:	c9                   	leaveq 
  8014a3:	c3                   	retq   

00000000008014a4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8014a4:	55                   	push   %rbp
  8014a5:	48 89 e5             	mov    %rsp,%rbp
  8014a8:	48 83 ec 20          	sub    $0x20,%rsp
  8014ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8014b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b8:	48 89 c7             	mov    %rax,%rdi
  8014bb:	48 b8 f5 13 80 00 00 	movabs $0x8013f5,%rax
  8014c2:	00 00 00 
  8014c5:	ff d0                	callq  *%rax
  8014c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8014ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014cd:	48 63 d0             	movslq %eax,%rdx
  8014d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d4:	48 01 c2             	add    %rax,%rdx
  8014d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014db:	48 89 c6             	mov    %rax,%rsi
  8014de:	48 89 d7             	mov    %rdx,%rdi
  8014e1:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  8014e8:	00 00 00 
  8014eb:	ff d0                	callq  *%rax
	return dst;
  8014ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014f1:	c9                   	leaveq 
  8014f2:	c3                   	retq   

00000000008014f3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014f3:	55                   	push   %rbp
  8014f4:	48 89 e5             	mov    %rsp,%rbp
  8014f7:	48 83 ec 28          	sub    $0x28,%rsp
  8014fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801503:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80150f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801516:	00 
  801517:	eb 2a                	jmp    801543 <strncpy+0x50>
		*dst++ = *src;
  801519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801521:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801525:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801529:	0f b6 12             	movzbl (%rdx),%edx
  80152c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80152e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801532:	0f b6 00             	movzbl (%rax),%eax
  801535:	84 c0                	test   %al,%al
  801537:	74 05                	je     80153e <strncpy+0x4b>
			src++;
  801539:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80153e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801547:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80154b:	72 cc                	jb     801519 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80154d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801551:	c9                   	leaveq 
  801552:	c3                   	retq   

0000000000801553 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801553:	55                   	push   %rbp
  801554:	48 89 e5             	mov    %rsp,%rbp
  801557:	48 83 ec 28          	sub    $0x28,%rsp
  80155b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80155f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801563:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80156f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801574:	74 3d                	je     8015b3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801576:	eb 1d                	jmp    801595 <strlcpy+0x42>
			*dst++ = *src++;
  801578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801580:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801584:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801588:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80158c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801590:	0f b6 12             	movzbl (%rdx),%edx
  801593:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801595:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80159a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80159f:	74 0b                	je     8015ac <strlcpy+0x59>
  8015a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015a5:	0f b6 00             	movzbl (%rax),%eax
  8015a8:	84 c0                	test   %al,%al
  8015aa:	75 cc                	jne    801578 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8015ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8015b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bb:	48 29 c2             	sub    %rax,%rdx
  8015be:	48 89 d0             	mov    %rdx,%rax
}
  8015c1:	c9                   	leaveq 
  8015c2:	c3                   	retq   

00000000008015c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015c3:	55                   	push   %rbp
  8015c4:	48 89 e5             	mov    %rsp,%rbp
  8015c7:	48 83 ec 10          	sub    $0x10,%rsp
  8015cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8015d3:	eb 0a                	jmp    8015df <strcmp+0x1c>
		p++, q++;
  8015d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015da:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e3:	0f b6 00             	movzbl (%rax),%eax
  8015e6:	84 c0                	test   %al,%al
  8015e8:	74 12                	je     8015fc <strcmp+0x39>
  8015ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ee:	0f b6 10             	movzbl (%rax),%edx
  8015f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	38 c2                	cmp    %al,%dl
  8015fa:	74 d9                	je     8015d5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801600:	0f b6 00             	movzbl (%rax),%eax
  801603:	0f b6 d0             	movzbl %al,%edx
  801606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160a:	0f b6 00             	movzbl (%rax),%eax
  80160d:	0f b6 c0             	movzbl %al,%eax
  801610:	29 c2                	sub    %eax,%edx
  801612:	89 d0                	mov    %edx,%eax
}
  801614:	c9                   	leaveq 
  801615:	c3                   	retq   

0000000000801616 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801616:	55                   	push   %rbp
  801617:	48 89 e5             	mov    %rsp,%rbp
  80161a:	48 83 ec 18          	sub    $0x18,%rsp
  80161e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801622:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801626:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80162a:	eb 0f                	jmp    80163b <strncmp+0x25>
		n--, p++, q++;
  80162c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801631:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801636:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80163b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801640:	74 1d                	je     80165f <strncmp+0x49>
  801642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801646:	0f b6 00             	movzbl (%rax),%eax
  801649:	84 c0                	test   %al,%al
  80164b:	74 12                	je     80165f <strncmp+0x49>
  80164d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801651:	0f b6 10             	movzbl (%rax),%edx
  801654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801658:	0f b6 00             	movzbl (%rax),%eax
  80165b:	38 c2                	cmp    %al,%dl
  80165d:	74 cd                	je     80162c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80165f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801664:	75 07                	jne    80166d <strncmp+0x57>
		return 0;
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
  80166b:	eb 18                	jmp    801685 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80166d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801671:	0f b6 00             	movzbl (%rax),%eax
  801674:	0f b6 d0             	movzbl %al,%edx
  801677:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167b:	0f b6 00             	movzbl (%rax),%eax
  80167e:	0f b6 c0             	movzbl %al,%eax
  801681:	29 c2                	sub    %eax,%edx
  801683:	89 d0                	mov    %edx,%eax
}
  801685:	c9                   	leaveq 
  801686:	c3                   	retq   

0000000000801687 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801687:	55                   	push   %rbp
  801688:	48 89 e5             	mov    %rsp,%rbp
  80168b:	48 83 ec 0c          	sub    $0xc,%rsp
  80168f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801693:	89 f0                	mov    %esi,%eax
  801695:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801698:	eb 17                	jmp    8016b1 <strchr+0x2a>
		if (*s == c)
  80169a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169e:	0f b6 00             	movzbl (%rax),%eax
  8016a1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016a4:	75 06                	jne    8016ac <strchr+0x25>
			return (char *) s;
  8016a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016aa:	eb 15                	jmp    8016c1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8016ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b5:	0f b6 00             	movzbl (%rax),%eax
  8016b8:	84 c0                	test   %al,%al
  8016ba:	75 de                	jne    80169a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c1:	c9                   	leaveq 
  8016c2:	c3                   	retq   

00000000008016c3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016c3:	55                   	push   %rbp
  8016c4:	48 89 e5             	mov    %rsp,%rbp
  8016c7:	48 83 ec 0c          	sub    $0xc,%rsp
  8016cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016cf:	89 f0                	mov    %esi,%eax
  8016d1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016d4:	eb 13                	jmp    8016e9 <strfind+0x26>
		if (*s == c)
  8016d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016da:	0f b6 00             	movzbl (%rax),%eax
  8016dd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016e0:	75 02                	jne    8016e4 <strfind+0x21>
			break;
  8016e2:	eb 10                	jmp    8016f4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ed:	0f b6 00             	movzbl (%rax),%eax
  8016f0:	84 c0                	test   %al,%al
  8016f2:	75 e2                	jne    8016d6 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8016f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016f8:	c9                   	leaveq 
  8016f9:	c3                   	retq   

00000000008016fa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016fa:	55                   	push   %rbp
  8016fb:	48 89 e5             	mov    %rsp,%rbp
  8016fe:	48 83 ec 18          	sub    $0x18,%rsp
  801702:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801706:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801709:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80170d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801712:	75 06                	jne    80171a <memset+0x20>
		return v;
  801714:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801718:	eb 69                	jmp    801783 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80171a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171e:	83 e0 03             	and    $0x3,%eax
  801721:	48 85 c0             	test   %rax,%rax
  801724:	75 48                	jne    80176e <memset+0x74>
  801726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172a:	83 e0 03             	and    $0x3,%eax
  80172d:	48 85 c0             	test   %rax,%rax
  801730:	75 3c                	jne    80176e <memset+0x74>
		c &= 0xFF;
  801732:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801739:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80173c:	c1 e0 18             	shl    $0x18,%eax
  80173f:	89 c2                	mov    %eax,%edx
  801741:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801744:	c1 e0 10             	shl    $0x10,%eax
  801747:	09 c2                	or     %eax,%edx
  801749:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80174c:	c1 e0 08             	shl    $0x8,%eax
  80174f:	09 d0                	or     %edx,%eax
  801751:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801758:	48 c1 e8 02          	shr    $0x2,%rax
  80175c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80175f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801763:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801766:	48 89 d7             	mov    %rdx,%rdi
  801769:	fc                   	cld    
  80176a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80176c:	eb 11                	jmp    80177f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80176e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801772:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801775:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801779:	48 89 d7             	mov    %rdx,%rdi
  80177c:	fc                   	cld    
  80177d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80177f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801783:	c9                   	leaveq 
  801784:	c3                   	retq   

0000000000801785 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801785:	55                   	push   %rbp
  801786:	48 89 e5             	mov    %rsp,%rbp
  801789:	48 83 ec 28          	sub    $0x28,%rsp
  80178d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801791:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801795:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801799:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80179d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8017a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8017a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ad:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017b1:	0f 83 88 00 00 00    	jae    80183f <memmove+0xba>
  8017b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017bf:	48 01 d0             	add    %rdx,%rax
  8017c2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017c6:	76 77                	jbe    80183f <memmove+0xba>
		s += n;
  8017c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8017d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017dc:	83 e0 03             	and    $0x3,%eax
  8017df:	48 85 c0             	test   %rax,%rax
  8017e2:	75 3b                	jne    80181f <memmove+0x9a>
  8017e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017e8:	83 e0 03             	and    $0x3,%eax
  8017eb:	48 85 c0             	test   %rax,%rax
  8017ee:	75 2f                	jne    80181f <memmove+0x9a>
  8017f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f4:	83 e0 03             	and    $0x3,%eax
  8017f7:	48 85 c0             	test   %rax,%rax
  8017fa:	75 23                	jne    80181f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801800:	48 83 e8 04          	sub    $0x4,%rax
  801804:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801808:	48 83 ea 04          	sub    $0x4,%rdx
  80180c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801810:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801814:	48 89 c7             	mov    %rax,%rdi
  801817:	48 89 d6             	mov    %rdx,%rsi
  80181a:	fd                   	std    
  80181b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80181d:	eb 1d                	jmp    80183c <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80181f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801823:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801827:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80182f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801833:	48 89 d7             	mov    %rdx,%rdi
  801836:	48 89 c1             	mov    %rax,%rcx
  801839:	fd                   	std    
  80183a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80183c:	fc                   	cld    
  80183d:	eb 57                	jmp    801896 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80183f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801843:	83 e0 03             	and    $0x3,%eax
  801846:	48 85 c0             	test   %rax,%rax
  801849:	75 36                	jne    801881 <memmove+0xfc>
  80184b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80184f:	83 e0 03             	and    $0x3,%eax
  801852:	48 85 c0             	test   %rax,%rax
  801855:	75 2a                	jne    801881 <memmove+0xfc>
  801857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185b:	83 e0 03             	and    $0x3,%eax
  80185e:	48 85 c0             	test   %rax,%rax
  801861:	75 1e                	jne    801881 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801867:	48 c1 e8 02          	shr    $0x2,%rax
  80186b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80186e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801872:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801876:	48 89 c7             	mov    %rax,%rdi
  801879:	48 89 d6             	mov    %rdx,%rsi
  80187c:	fc                   	cld    
  80187d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80187f:	eb 15                	jmp    801896 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801881:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801885:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801889:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80188d:	48 89 c7             	mov    %rax,%rdi
  801890:	48 89 d6             	mov    %rdx,%rsi
  801893:	fc                   	cld    
  801894:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80189a:	c9                   	leaveq 
  80189b:	c3                   	retq   

000000000080189c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80189c:	55                   	push   %rbp
  80189d:	48 89 e5             	mov    %rsp,%rbp
  8018a0:	48 83 ec 18          	sub    $0x18,%rsp
  8018a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018ac:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8018b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018b4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018bc:	48 89 ce             	mov    %rcx,%rsi
  8018bf:	48 89 c7             	mov    %rax,%rdi
  8018c2:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  8018c9:	00 00 00 
  8018cc:	ff d0                	callq  *%rax
}
  8018ce:	c9                   	leaveq 
  8018cf:	c3                   	retq   

00000000008018d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018d0:	55                   	push   %rbp
  8018d1:	48 89 e5             	mov    %rsp,%rbp
  8018d4:	48 83 ec 28          	sub    $0x28,%rsp
  8018d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8018e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8018e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8018ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018f4:	eb 36                	jmp    80192c <memcmp+0x5c>
		if (*s1 != *s2)
  8018f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018fa:	0f b6 10             	movzbl (%rax),%edx
  8018fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801901:	0f b6 00             	movzbl (%rax),%eax
  801904:	38 c2                	cmp    %al,%dl
  801906:	74 1a                	je     801922 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801908:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80190c:	0f b6 00             	movzbl (%rax),%eax
  80190f:	0f b6 d0             	movzbl %al,%edx
  801912:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801916:	0f b6 00             	movzbl (%rax),%eax
  801919:	0f b6 c0             	movzbl %al,%eax
  80191c:	29 c2                	sub    %eax,%edx
  80191e:	89 d0                	mov    %edx,%eax
  801920:	eb 20                	jmp    801942 <memcmp+0x72>
		s1++, s2++;
  801922:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801927:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80192c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801930:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801934:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801938:	48 85 c0             	test   %rax,%rax
  80193b:	75 b9                	jne    8018f6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80193d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801942:	c9                   	leaveq 
  801943:	c3                   	retq   

0000000000801944 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801944:	55                   	push   %rbp
  801945:	48 89 e5             	mov    %rsp,%rbp
  801948:	48 83 ec 28          	sub    $0x28,%rsp
  80194c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801950:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801953:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801957:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80195f:	48 01 d0             	add    %rdx,%rax
  801962:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801966:	eb 15                	jmp    80197d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80196c:	0f b6 10             	movzbl (%rax),%edx
  80196f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801972:	38 c2                	cmp    %al,%dl
  801974:	75 02                	jne    801978 <memfind+0x34>
			break;
  801976:	eb 0f                	jmp    801987 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801978:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80197d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801981:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801985:	72 e1                	jb     801968 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80198b:	c9                   	leaveq 
  80198c:	c3                   	retq   

000000000080198d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80198d:	55                   	push   %rbp
  80198e:	48 89 e5             	mov    %rsp,%rbp
  801991:	48 83 ec 34          	sub    $0x34,%rsp
  801995:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801999:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80199d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8019a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8019a7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8019ae:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019af:	eb 05                	jmp    8019b6 <strtol+0x29>
		s++;
  8019b1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ba:	0f b6 00             	movzbl (%rax),%eax
  8019bd:	3c 20                	cmp    $0x20,%al
  8019bf:	74 f0                	je     8019b1 <strtol+0x24>
  8019c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c5:	0f b6 00             	movzbl (%rax),%eax
  8019c8:	3c 09                	cmp    $0x9,%al
  8019ca:	74 e5                	je     8019b1 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d0:	0f b6 00             	movzbl (%rax),%eax
  8019d3:	3c 2b                	cmp    $0x2b,%al
  8019d5:	75 07                	jne    8019de <strtol+0x51>
		s++;
  8019d7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019dc:	eb 17                	jmp    8019f5 <strtol+0x68>
	else if (*s == '-')
  8019de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e2:	0f b6 00             	movzbl (%rax),%eax
  8019e5:	3c 2d                	cmp    $0x2d,%al
  8019e7:	75 0c                	jne    8019f5 <strtol+0x68>
		s++, neg = 1;
  8019e9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019ee:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019f5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019f9:	74 06                	je     801a01 <strtol+0x74>
  8019fb:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019ff:	75 28                	jne    801a29 <strtol+0x9c>
  801a01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a05:	0f b6 00             	movzbl (%rax),%eax
  801a08:	3c 30                	cmp    $0x30,%al
  801a0a:	75 1d                	jne    801a29 <strtol+0x9c>
  801a0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a10:	48 83 c0 01          	add    $0x1,%rax
  801a14:	0f b6 00             	movzbl (%rax),%eax
  801a17:	3c 78                	cmp    $0x78,%al
  801a19:	75 0e                	jne    801a29 <strtol+0x9c>
		s += 2, base = 16;
  801a1b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a20:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a27:	eb 2c                	jmp    801a55 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a29:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a2d:	75 19                	jne    801a48 <strtol+0xbb>
  801a2f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a33:	0f b6 00             	movzbl (%rax),%eax
  801a36:	3c 30                	cmp    $0x30,%al
  801a38:	75 0e                	jne    801a48 <strtol+0xbb>
		s++, base = 8;
  801a3a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a3f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a46:	eb 0d                	jmp    801a55 <strtol+0xc8>
	else if (base == 0)
  801a48:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a4c:	75 07                	jne    801a55 <strtol+0xc8>
		base = 10;
  801a4e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a59:	0f b6 00             	movzbl (%rax),%eax
  801a5c:	3c 2f                	cmp    $0x2f,%al
  801a5e:	7e 1d                	jle    801a7d <strtol+0xf0>
  801a60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a64:	0f b6 00             	movzbl (%rax),%eax
  801a67:	3c 39                	cmp    $0x39,%al
  801a69:	7f 12                	jg     801a7d <strtol+0xf0>
			dig = *s - '0';
  801a6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6f:	0f b6 00             	movzbl (%rax),%eax
  801a72:	0f be c0             	movsbl %al,%eax
  801a75:	83 e8 30             	sub    $0x30,%eax
  801a78:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a7b:	eb 4e                	jmp    801acb <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a81:	0f b6 00             	movzbl (%rax),%eax
  801a84:	3c 60                	cmp    $0x60,%al
  801a86:	7e 1d                	jle    801aa5 <strtol+0x118>
  801a88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a8c:	0f b6 00             	movzbl (%rax),%eax
  801a8f:	3c 7a                	cmp    $0x7a,%al
  801a91:	7f 12                	jg     801aa5 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a97:	0f b6 00             	movzbl (%rax),%eax
  801a9a:	0f be c0             	movsbl %al,%eax
  801a9d:	83 e8 57             	sub    $0x57,%eax
  801aa0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801aa3:	eb 26                	jmp    801acb <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa9:	0f b6 00             	movzbl (%rax),%eax
  801aac:	3c 40                	cmp    $0x40,%al
  801aae:	7e 48                	jle    801af8 <strtol+0x16b>
  801ab0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab4:	0f b6 00             	movzbl (%rax),%eax
  801ab7:	3c 5a                	cmp    $0x5a,%al
  801ab9:	7f 3d                	jg     801af8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801abb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abf:	0f b6 00             	movzbl (%rax),%eax
  801ac2:	0f be c0             	movsbl %al,%eax
  801ac5:	83 e8 37             	sub    $0x37,%eax
  801ac8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801acb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ace:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801ad1:	7c 02                	jl     801ad5 <strtol+0x148>
			break;
  801ad3:	eb 23                	jmp    801af8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801ad5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ada:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801add:	48 98                	cltq   
  801adf:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801ae4:	48 89 c2             	mov    %rax,%rdx
  801ae7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801aea:	48 98                	cltq   
  801aec:	48 01 d0             	add    %rdx,%rax
  801aef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801af3:	e9 5d ff ff ff       	jmpq   801a55 <strtol+0xc8>

	if (endptr)
  801af8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801afd:	74 0b                	je     801b0a <strtol+0x17d>
		*endptr = (char *) s;
  801aff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b03:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b07:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801b0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b0e:	74 09                	je     801b19 <strtol+0x18c>
  801b10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b14:	48 f7 d8             	neg    %rax
  801b17:	eb 04                	jmp    801b1d <strtol+0x190>
  801b19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b1d:	c9                   	leaveq 
  801b1e:	c3                   	retq   

0000000000801b1f <strstr>:

char * strstr(const char *in, const char *str)
{
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 30          	sub    $0x30,%rsp
  801b27:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b2b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b33:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b37:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b3b:	0f b6 00             	movzbl (%rax),%eax
  801b3e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801b41:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b45:	75 06                	jne    801b4d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4b:	eb 6b                	jmp    801bb8 <strstr+0x99>

	len = strlen(str);
  801b4d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b51:	48 89 c7             	mov    %rax,%rdi
  801b54:	48 b8 f5 13 80 00 00 	movabs $0x8013f5,%rax
  801b5b:	00 00 00 
  801b5e:	ff d0                	callq  *%rax
  801b60:	48 98                	cltq   
  801b62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b6e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b72:	0f b6 00             	movzbl (%rax),%eax
  801b75:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b78:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b7c:	75 07                	jne    801b85 <strstr+0x66>
				return (char *) 0;
  801b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b83:	eb 33                	jmp    801bb8 <strstr+0x99>
		} while (sc != c);
  801b85:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b89:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b8c:	75 d8                	jne    801b66 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b92:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b9a:	48 89 ce             	mov    %rcx,%rsi
  801b9d:	48 89 c7             	mov    %rax,%rdi
  801ba0:	48 b8 16 16 80 00 00 	movabs $0x801616,%rax
  801ba7:	00 00 00 
  801baa:	ff d0                	callq  *%rax
  801bac:	85 c0                	test   %eax,%eax
  801bae:	75 b6                	jne    801b66 <strstr+0x47>

	return (char *) (in - 1);
  801bb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bb4:	48 83 e8 01          	sub    $0x1,%rax
}
  801bb8:	c9                   	leaveq 
  801bb9:	c3                   	retq   

0000000000801bba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801bba:	55                   	push   %rbp
  801bbb:	48 89 e5             	mov    %rsp,%rbp
  801bbe:	53                   	push   %rbx
  801bbf:	48 83 ec 48          	sub    $0x48,%rsp
  801bc3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801bc6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801bc9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801bcd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801bd1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801bd5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bd9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bdc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801be0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801be4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801be8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801bec:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801bf0:	4c 89 c3             	mov    %r8,%rbx
  801bf3:	cd 30                	int    $0x30
  801bf5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801bf9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bfd:	74 3e                	je     801c3d <syscall+0x83>
  801bff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c04:	7e 37                	jle    801c3d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c0a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c0d:	49 89 d0             	mov    %rdx,%r8
  801c10:	89 c1                	mov    %eax,%ecx
  801c12:	48 ba bb 49 80 00 00 	movabs $0x8049bb,%rdx
  801c19:	00 00 00 
  801c1c:	be 23 00 00 00       	mov    $0x23,%esi
  801c21:	48 bf d8 49 80 00 00 	movabs $0x8049d8,%rdi
  801c28:	00 00 00 
  801c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c30:	49 b9 19 05 80 00 00 	movabs $0x800519,%r9
  801c37:	00 00 00 
  801c3a:	41 ff d1             	callq  *%r9

	return ret;
  801c3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c41:	48 83 c4 48          	add    $0x48,%rsp
  801c45:	5b                   	pop    %rbx
  801c46:	5d                   	pop    %rbp
  801c47:	c3                   	retq   

0000000000801c48 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c48:	55                   	push   %rbp
  801c49:	48 89 e5             	mov    %rsp,%rbp
  801c4c:	48 83 ec 20          	sub    $0x20,%rsp
  801c50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c54:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c60:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c67:	00 
  801c68:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c74:	48 89 d1             	mov    %rdx,%rcx
  801c77:	48 89 c2             	mov    %rax,%rdx
  801c7a:	be 00 00 00 00       	mov    $0x0,%esi
  801c7f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c84:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801c8b:	00 00 00 
  801c8e:	ff d0                	callq  *%rax
}
  801c90:	c9                   	leaveq 
  801c91:	c3                   	retq   

0000000000801c92 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c92:	55                   	push   %rbp
  801c93:	48 89 e5             	mov    %rsp,%rbp
  801c96:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca1:	00 
  801ca2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cae:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb3:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb8:	be 00 00 00 00       	mov    $0x0,%esi
  801cbd:	bf 01 00 00 00       	mov    $0x1,%edi
  801cc2:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801cc9:	00 00 00 
  801ccc:	ff d0                	callq  *%rax
}
  801cce:	c9                   	leaveq 
  801ccf:	c3                   	retq   

0000000000801cd0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801cd0:	55                   	push   %rbp
  801cd1:	48 89 e5             	mov    %rsp,%rbp
  801cd4:	48 83 ec 10          	sub    $0x10,%rsp
  801cd8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801cdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cde:	48 98                	cltq   
  801ce0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce7:	00 
  801ce8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf9:	48 89 c2             	mov    %rax,%rdx
  801cfc:	be 01 00 00 00       	mov    $0x1,%esi
  801d01:	bf 03 00 00 00       	mov    $0x3,%edi
  801d06:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801d0d:	00 00 00 
  801d10:	ff d0                	callq  *%rax
}
  801d12:	c9                   	leaveq 
  801d13:	c3                   	retq   

0000000000801d14 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d14:	55                   	push   %rbp
  801d15:	48 89 e5             	mov    %rsp,%rbp
  801d18:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d1c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d23:	00 
  801d24:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d30:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d35:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3a:	be 00 00 00 00       	mov    $0x0,%esi
  801d3f:	bf 02 00 00 00       	mov    $0x2,%edi
  801d44:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801d4b:	00 00 00 
  801d4e:	ff d0                	callq  *%rax
}
  801d50:	c9                   	leaveq 
  801d51:	c3                   	retq   

0000000000801d52 <sys_yield>:

void
sys_yield(void)
{
  801d52:	55                   	push   %rbp
  801d53:	48 89 e5             	mov    %rsp,%rbp
  801d56:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d61:	00 
  801d62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d73:	ba 00 00 00 00       	mov    $0x0,%edx
  801d78:	be 00 00 00 00       	mov    $0x0,%esi
  801d7d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d82:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801d89:	00 00 00 
  801d8c:	ff d0                	callq  *%rax
}
  801d8e:	c9                   	leaveq 
  801d8f:	c3                   	retq   

0000000000801d90 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d90:	55                   	push   %rbp
  801d91:	48 89 e5             	mov    %rsp,%rbp
  801d94:	48 83 ec 20          	sub    $0x20,%rsp
  801d98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d9f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801da2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801da5:	48 63 c8             	movslq %eax,%rcx
  801da8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801daf:	48 98                	cltq   
  801db1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db8:	00 
  801db9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbf:	49 89 c8             	mov    %rcx,%r8
  801dc2:	48 89 d1             	mov    %rdx,%rcx
  801dc5:	48 89 c2             	mov    %rax,%rdx
  801dc8:	be 01 00 00 00       	mov    $0x1,%esi
  801dcd:	bf 04 00 00 00       	mov    $0x4,%edi
  801dd2:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801dd9:	00 00 00 
  801ddc:	ff d0                	callq  *%rax
}
  801dde:	c9                   	leaveq 
  801ddf:	c3                   	retq   

0000000000801de0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801de0:	55                   	push   %rbp
  801de1:	48 89 e5             	mov    %rsp,%rbp
  801de4:	48 83 ec 30          	sub    $0x30,%rsp
  801de8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801deb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801def:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801df2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801df6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801dfa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dfd:	48 63 c8             	movslq %eax,%rcx
  801e00:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e04:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e07:	48 63 f0             	movslq %eax,%rsi
  801e0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e11:	48 98                	cltq   
  801e13:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e17:	49 89 f9             	mov    %rdi,%r9
  801e1a:	49 89 f0             	mov    %rsi,%r8
  801e1d:	48 89 d1             	mov    %rdx,%rcx
  801e20:	48 89 c2             	mov    %rax,%rdx
  801e23:	be 01 00 00 00       	mov    $0x1,%esi
  801e28:	bf 05 00 00 00       	mov    $0x5,%edi
  801e2d:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801e34:	00 00 00 
  801e37:	ff d0                	callq  *%rax
}
  801e39:	c9                   	leaveq 
  801e3a:	c3                   	retq   

0000000000801e3b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e3b:	55                   	push   %rbp
  801e3c:	48 89 e5             	mov    %rsp,%rbp
  801e3f:	48 83 ec 20          	sub    $0x20,%rsp
  801e43:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e51:	48 98                	cltq   
  801e53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e5a:	00 
  801e5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e67:	48 89 d1             	mov    %rdx,%rcx
  801e6a:	48 89 c2             	mov    %rax,%rdx
  801e6d:	be 01 00 00 00       	mov    $0x1,%esi
  801e72:	bf 06 00 00 00       	mov    $0x6,%edi
  801e77:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801e7e:	00 00 00 
  801e81:	ff d0                	callq  *%rax
}
  801e83:	c9                   	leaveq 
  801e84:	c3                   	retq   

0000000000801e85 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e85:	55                   	push   %rbp
  801e86:	48 89 e5             	mov    %rsp,%rbp
  801e89:	48 83 ec 10          	sub    $0x10,%rsp
  801e8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e90:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e96:	48 63 d0             	movslq %eax,%rdx
  801e99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e9c:	48 98                	cltq   
  801e9e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea5:	00 
  801ea6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb2:	48 89 d1             	mov    %rdx,%rcx
  801eb5:	48 89 c2             	mov    %rax,%rdx
  801eb8:	be 01 00 00 00       	mov    $0x1,%esi
  801ebd:	bf 08 00 00 00       	mov    $0x8,%edi
  801ec2:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801ec9:	00 00 00 
  801ecc:	ff d0                	callq  *%rax
}
  801ece:	c9                   	leaveq 
  801ecf:	c3                   	retq   

0000000000801ed0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ed0:	55                   	push   %rbp
  801ed1:	48 89 e5             	mov    %rsp,%rbp
  801ed4:	48 83 ec 20          	sub    $0x20,%rsp
  801ed8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801edb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801edf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ee3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee6:	48 98                	cltq   
  801ee8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eef:	00 
  801ef0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801efc:	48 89 d1             	mov    %rdx,%rcx
  801eff:	48 89 c2             	mov    %rax,%rdx
  801f02:	be 01 00 00 00       	mov    $0x1,%esi
  801f07:	bf 09 00 00 00       	mov    $0x9,%edi
  801f0c:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801f13:	00 00 00 
  801f16:	ff d0                	callq  *%rax
}
  801f18:	c9                   	leaveq 
  801f19:	c3                   	retq   

0000000000801f1a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f1a:	55                   	push   %rbp
  801f1b:	48 89 e5             	mov    %rsp,%rbp
  801f1e:	48 83 ec 20          	sub    $0x20,%rsp
  801f22:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f25:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f30:	48 98                	cltq   
  801f32:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f39:	00 
  801f3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f40:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f46:	48 89 d1             	mov    %rdx,%rcx
  801f49:	48 89 c2             	mov    %rax,%rdx
  801f4c:	be 01 00 00 00       	mov    $0x1,%esi
  801f51:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f56:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801f5d:	00 00 00 
  801f60:	ff d0                	callq  *%rax
}
  801f62:	c9                   	leaveq 
  801f63:	c3                   	retq   

0000000000801f64 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f64:	55                   	push   %rbp
  801f65:	48 89 e5             	mov    %rsp,%rbp
  801f68:	48 83 ec 20          	sub    $0x20,%rsp
  801f6c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f73:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f77:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f7d:	48 63 f0             	movslq %eax,%rsi
  801f80:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f87:	48 98                	cltq   
  801f89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f94:	00 
  801f95:	49 89 f1             	mov    %rsi,%r9
  801f98:	49 89 c8             	mov    %rcx,%r8
  801f9b:	48 89 d1             	mov    %rdx,%rcx
  801f9e:	48 89 c2             	mov    %rax,%rdx
  801fa1:	be 00 00 00 00       	mov    $0x0,%esi
  801fa6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801fab:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801fb2:	00 00 00 
  801fb5:	ff d0                	callq  *%rax
}
  801fb7:	c9                   	leaveq 
  801fb8:	c3                   	retq   

0000000000801fb9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801fb9:	55                   	push   %rbp
  801fba:	48 89 e5             	mov    %rsp,%rbp
  801fbd:	48 83 ec 10          	sub    $0x10,%rsp
  801fc1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801fc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fd0:	00 
  801fd1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fdd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fe2:	48 89 c2             	mov    %rax,%rdx
  801fe5:	be 01 00 00 00       	mov    $0x1,%esi
  801fea:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fef:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  801ff6:	00 00 00 
  801ff9:	ff d0                	callq  *%rax
}
  801ffb:	c9                   	leaveq 
  801ffc:	c3                   	retq   

0000000000801ffd <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801ffd:	55                   	push   %rbp
  801ffe:	48 89 e5             	mov    %rsp,%rbp
  802001:	48 83 ec 20          	sub    $0x20,%rsp
  802005:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802009:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  80200d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802011:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802015:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80201c:	00 
  80201d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802023:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802029:	48 89 d1             	mov    %rdx,%rcx
  80202c:	48 89 c2             	mov    %rax,%rdx
  80202f:	be 01 00 00 00       	mov    $0x1,%esi
  802034:	bf 0f 00 00 00       	mov    $0xf,%edi
  802039:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  802040:	00 00 00 
  802043:	ff d0                	callq  *%rax
}
  802045:	c9                   	leaveq 
  802046:	c3                   	retq   

0000000000802047 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  802047:	55                   	push   %rbp
  802048:	48 89 e5             	mov    %rsp,%rbp
  80204b:	48 83 ec 10          	sub    $0x10,%rsp
  80204f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  802053:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802057:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80205e:	00 
  80205f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802065:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80206b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802070:	48 89 c2             	mov    %rax,%rdx
  802073:	be 00 00 00 00       	mov    $0x0,%esi
  802078:	bf 10 00 00 00       	mov    $0x10,%edi
  80207d:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  802084:	00 00 00 
  802087:	ff d0                	callq  *%rax
}
  802089:	c9                   	leaveq 
  80208a:	c3                   	retq   

000000000080208b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80208b:	55                   	push   %rbp
  80208c:	48 89 e5             	mov    %rsp,%rbp
  80208f:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802093:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80209a:	00 
  80209b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020a1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b1:	be 00 00 00 00       	mov    $0x0,%esi
  8020b6:	bf 0e 00 00 00       	mov    $0xe,%edi
  8020bb:	48 b8 ba 1b 80 00 00 	movabs $0x801bba,%rax
  8020c2:	00 00 00 
  8020c5:	ff d0                	callq  *%rax
}
  8020c7:	c9                   	leaveq 
  8020c8:	c3                   	retq   

00000000008020c9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8020c9:	55                   	push   %rbp
  8020ca:	48 89 e5             	mov    %rsp,%rbp
  8020cd:	48 83 ec 08          	sub    $0x8,%rsp
  8020d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8020d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020d9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8020e0:	ff ff ff 
  8020e3:	48 01 d0             	add    %rdx,%rax
  8020e6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8020ea:	c9                   	leaveq 
  8020eb:	c3                   	retq   

00000000008020ec <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8020ec:	55                   	push   %rbp
  8020ed:	48 89 e5             	mov    %rsp,%rbp
  8020f0:	48 83 ec 08          	sub    $0x8,%rsp
  8020f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8020f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020fc:	48 89 c7             	mov    %rax,%rdi
  8020ff:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  802106:	00 00 00 
  802109:	ff d0                	callq  *%rax
  80210b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802111:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802115:	c9                   	leaveq 
  802116:	c3                   	retq   

0000000000802117 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802117:	55                   	push   %rbp
  802118:	48 89 e5             	mov    %rsp,%rbp
  80211b:	48 83 ec 18          	sub    $0x18,%rsp
  80211f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80212a:	eb 6b                	jmp    802197 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80212c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80212f:	48 98                	cltq   
  802131:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802137:	48 c1 e0 0c          	shl    $0xc,%rax
  80213b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80213f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802143:	48 c1 e8 15          	shr    $0x15,%rax
  802147:	48 89 c2             	mov    %rax,%rdx
  80214a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802151:	01 00 00 
  802154:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802158:	83 e0 01             	and    $0x1,%eax
  80215b:	48 85 c0             	test   %rax,%rax
  80215e:	74 21                	je     802181 <fd_alloc+0x6a>
  802160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802164:	48 c1 e8 0c          	shr    $0xc,%rax
  802168:	48 89 c2             	mov    %rax,%rdx
  80216b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802172:	01 00 00 
  802175:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802179:	83 e0 01             	and    $0x1,%eax
  80217c:	48 85 c0             	test   %rax,%rax
  80217f:	75 12                	jne    802193 <fd_alloc+0x7c>
			*fd_store = fd;
  802181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802185:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802189:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80218c:	b8 00 00 00 00       	mov    $0x0,%eax
  802191:	eb 1a                	jmp    8021ad <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802193:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802197:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80219b:	7e 8f                	jle    80212c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80219d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8021a8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8021ad:	c9                   	leaveq 
  8021ae:	c3                   	retq   

00000000008021af <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8021af:	55                   	push   %rbp
  8021b0:	48 89 e5             	mov    %rsp,%rbp
  8021b3:	48 83 ec 20          	sub    $0x20,%rsp
  8021b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8021be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8021c2:	78 06                	js     8021ca <fd_lookup+0x1b>
  8021c4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8021c8:	7e 07                	jle    8021d1 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8021ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021cf:	eb 6c                	jmp    80223d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8021d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021d4:	48 98                	cltq   
  8021d6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021dc:	48 c1 e0 0c          	shl    $0xc,%rax
  8021e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8021e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e8:	48 c1 e8 15          	shr    $0x15,%rax
  8021ec:	48 89 c2             	mov    %rax,%rdx
  8021ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021f6:	01 00 00 
  8021f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021fd:	83 e0 01             	and    $0x1,%eax
  802200:	48 85 c0             	test   %rax,%rax
  802203:	74 21                	je     802226 <fd_lookup+0x77>
  802205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802209:	48 c1 e8 0c          	shr    $0xc,%rax
  80220d:	48 89 c2             	mov    %rax,%rdx
  802210:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802217:	01 00 00 
  80221a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221e:	83 e0 01             	and    $0x1,%eax
  802221:	48 85 c0             	test   %rax,%rax
  802224:	75 07                	jne    80222d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802226:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80222b:	eb 10                	jmp    80223d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80222d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802231:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802235:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802238:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223d:	c9                   	leaveq 
  80223e:	c3                   	retq   

000000000080223f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80223f:	55                   	push   %rbp
  802240:	48 89 e5             	mov    %rsp,%rbp
  802243:	48 83 ec 30          	sub    $0x30,%rsp
  802247:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80224b:	89 f0                	mov    %esi,%eax
  80224d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802250:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802254:	48 89 c7             	mov    %rax,%rdi
  802257:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  80225e:	00 00 00 
  802261:	ff d0                	callq  *%rax
  802263:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802267:	48 89 d6             	mov    %rdx,%rsi
  80226a:	89 c7                	mov    %eax,%edi
  80226c:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  802273:	00 00 00 
  802276:	ff d0                	callq  *%rax
  802278:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80227b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227f:	78 0a                	js     80228b <fd_close+0x4c>
	    || fd != fd2)
  802281:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802285:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802289:	74 12                	je     80229d <fd_close+0x5e>
		return (must_exist ? r : 0);
  80228b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80228f:	74 05                	je     802296 <fd_close+0x57>
  802291:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802294:	eb 05                	jmp    80229b <fd_close+0x5c>
  802296:	b8 00 00 00 00       	mov    $0x0,%eax
  80229b:	eb 69                	jmp    802306 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80229d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022a1:	8b 00                	mov    (%rax),%eax
  8022a3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022a7:	48 89 d6             	mov    %rdx,%rsi
  8022aa:	89 c7                	mov    %eax,%edi
  8022ac:	48 b8 08 23 80 00 00 	movabs $0x802308,%rax
  8022b3:	00 00 00 
  8022b6:	ff d0                	callq  *%rax
  8022b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022bf:	78 2a                	js     8022eb <fd_close+0xac>
		if (dev->dev_close)
  8022c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022c9:	48 85 c0             	test   %rax,%rax
  8022cc:	74 16                	je     8022e4 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8022ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8022d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022da:	48 89 d7             	mov    %rdx,%rdi
  8022dd:	ff d0                	callq  *%rax
  8022df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e2:	eb 07                	jmp    8022eb <fd_close+0xac>
		else
			r = 0;
  8022e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8022eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ef:	48 89 c6             	mov    %rax,%rsi
  8022f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f7:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  8022fe:	00 00 00 
  802301:	ff d0                	callq  *%rax
	return r;
  802303:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802306:	c9                   	leaveq 
  802307:	c3                   	retq   

0000000000802308 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802308:	55                   	push   %rbp
  802309:	48 89 e5             	mov    %rsp,%rbp
  80230c:	48 83 ec 20          	sub    $0x20,%rsp
  802310:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802313:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802317:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80231e:	eb 41                	jmp    802361 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802320:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802327:	00 00 00 
  80232a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80232d:	48 63 d2             	movslq %edx,%rdx
  802330:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802334:	8b 00                	mov    (%rax),%eax
  802336:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802339:	75 22                	jne    80235d <dev_lookup+0x55>
			*dev = devtab[i];
  80233b:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802342:	00 00 00 
  802345:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802348:	48 63 d2             	movslq %edx,%rdx
  80234b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80234f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802353:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802356:	b8 00 00 00 00       	mov    $0x0,%eax
  80235b:	eb 60                	jmp    8023bd <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80235d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802361:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802368:	00 00 00 
  80236b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80236e:	48 63 d2             	movslq %edx,%rdx
  802371:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802375:	48 85 c0             	test   %rax,%rax
  802378:	75 a6                	jne    802320 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80237a:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802381:	00 00 00 
  802384:	48 8b 00             	mov    (%rax),%rax
  802387:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80238d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802390:	89 c6                	mov    %eax,%esi
  802392:	48 bf e8 49 80 00 00 	movabs $0x8049e8,%rdi
  802399:	00 00 00 
  80239c:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a1:	48 b9 52 07 80 00 00 	movabs $0x800752,%rcx
  8023a8:	00 00 00 
  8023ab:	ff d1                	callq  *%rcx
	*dev = 0;
  8023ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8023b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8023bd:	c9                   	leaveq 
  8023be:	c3                   	retq   

00000000008023bf <close>:

int
close(int fdnum)
{
  8023bf:	55                   	push   %rbp
  8023c0:	48 89 e5             	mov    %rsp,%rbp
  8023c3:	48 83 ec 20          	sub    $0x20,%rsp
  8023c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023d1:	48 89 d6             	mov    %rdx,%rsi
  8023d4:	89 c7                	mov    %eax,%edi
  8023d6:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  8023dd:	00 00 00 
  8023e0:	ff d0                	callq  *%rax
  8023e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e9:	79 05                	jns    8023f0 <close+0x31>
		return r;
  8023eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ee:	eb 18                	jmp    802408 <close+0x49>
	else
		return fd_close(fd, 1);
  8023f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f4:	be 01 00 00 00       	mov    $0x1,%esi
  8023f9:	48 89 c7             	mov    %rax,%rdi
  8023fc:	48 b8 3f 22 80 00 00 	movabs $0x80223f,%rax
  802403:	00 00 00 
  802406:	ff d0                	callq  *%rax
}
  802408:	c9                   	leaveq 
  802409:	c3                   	retq   

000000000080240a <close_all>:

void
close_all(void)
{
  80240a:	55                   	push   %rbp
  80240b:	48 89 e5             	mov    %rsp,%rbp
  80240e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802412:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802419:	eb 15                	jmp    802430 <close_all+0x26>
		close(i);
  80241b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241e:	89 c7                	mov    %eax,%edi
  802420:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  802427:	00 00 00 
  80242a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80242c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802430:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802434:	7e e5                	jle    80241b <close_all+0x11>
		close(i);
}
  802436:	c9                   	leaveq 
  802437:	c3                   	retq   

0000000000802438 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802438:	55                   	push   %rbp
  802439:	48 89 e5             	mov    %rsp,%rbp
  80243c:	48 83 ec 40          	sub    $0x40,%rsp
  802440:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802443:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802446:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80244a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80244d:	48 89 d6             	mov    %rdx,%rsi
  802450:	89 c7                	mov    %eax,%edi
  802452:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  802459:	00 00 00 
  80245c:	ff d0                	callq  *%rax
  80245e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802461:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802465:	79 08                	jns    80246f <dup+0x37>
		return r;
  802467:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246a:	e9 70 01 00 00       	jmpq   8025df <dup+0x1a7>
	close(newfdnum);
  80246f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802472:	89 c7                	mov    %eax,%edi
  802474:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  80247b:	00 00 00 
  80247e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802480:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802483:	48 98                	cltq   
  802485:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80248b:	48 c1 e0 0c          	shl    $0xc,%rax
  80248f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802493:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802497:	48 89 c7             	mov    %rax,%rdi
  80249a:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  8024a1:	00 00 00 
  8024a4:	ff d0                	callq  *%rax
  8024a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8024aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ae:	48 89 c7             	mov    %rax,%rdi
  8024b1:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  8024b8:	00 00 00 
  8024bb:	ff d0                	callq  *%rax
  8024bd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8024c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c5:	48 c1 e8 15          	shr    $0x15,%rax
  8024c9:	48 89 c2             	mov    %rax,%rdx
  8024cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024d3:	01 00 00 
  8024d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024da:	83 e0 01             	and    $0x1,%eax
  8024dd:	48 85 c0             	test   %rax,%rax
  8024e0:	74 73                	je     802555 <dup+0x11d>
  8024e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e6:	48 c1 e8 0c          	shr    $0xc,%rax
  8024ea:	48 89 c2             	mov    %rax,%rdx
  8024ed:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024f4:	01 00 00 
  8024f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fb:	83 e0 01             	and    $0x1,%eax
  8024fe:	48 85 c0             	test   %rax,%rax
  802501:	74 52                	je     802555 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802503:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802507:	48 c1 e8 0c          	shr    $0xc,%rax
  80250b:	48 89 c2             	mov    %rax,%rdx
  80250e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802515:	01 00 00 
  802518:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80251c:	25 07 0e 00 00       	and    $0xe07,%eax
  802521:	89 c1                	mov    %eax,%ecx
  802523:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252b:	41 89 c8             	mov    %ecx,%r8d
  80252e:	48 89 d1             	mov    %rdx,%rcx
  802531:	ba 00 00 00 00       	mov    $0x0,%edx
  802536:	48 89 c6             	mov    %rax,%rsi
  802539:	bf 00 00 00 00       	mov    $0x0,%edi
  80253e:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  802545:	00 00 00 
  802548:	ff d0                	callq  *%rax
  80254a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80254d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802551:	79 02                	jns    802555 <dup+0x11d>
			goto err;
  802553:	eb 57                	jmp    8025ac <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802555:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802559:	48 c1 e8 0c          	shr    $0xc,%rax
  80255d:	48 89 c2             	mov    %rax,%rdx
  802560:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802567:	01 00 00 
  80256a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256e:	25 07 0e 00 00       	and    $0xe07,%eax
  802573:	89 c1                	mov    %eax,%ecx
  802575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802579:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80257d:	41 89 c8             	mov    %ecx,%r8d
  802580:	48 89 d1             	mov    %rdx,%rcx
  802583:	ba 00 00 00 00       	mov    $0x0,%edx
  802588:	48 89 c6             	mov    %rax,%rsi
  80258b:	bf 00 00 00 00       	mov    $0x0,%edi
  802590:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  802597:	00 00 00 
  80259a:	ff d0                	callq  *%rax
  80259c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a3:	79 02                	jns    8025a7 <dup+0x16f>
		goto err;
  8025a5:	eb 05                	jmp    8025ac <dup+0x174>

	return newfdnum;
  8025a7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025aa:	eb 33                	jmp    8025df <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8025ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b0:	48 89 c6             	mov    %rax,%rsi
  8025b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b8:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  8025bf:	00 00 00 
  8025c2:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8025c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025c8:	48 89 c6             	mov    %rax,%rsi
  8025cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8025d0:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  8025d7:	00 00 00 
  8025da:	ff d0                	callq  *%rax
	return r;
  8025dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025df:	c9                   	leaveq 
  8025e0:	c3                   	retq   

00000000008025e1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8025e1:	55                   	push   %rbp
  8025e2:	48 89 e5             	mov    %rsp,%rbp
  8025e5:	48 83 ec 40          	sub    $0x40,%rsp
  8025e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8025f0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025f4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025fb:	48 89 d6             	mov    %rdx,%rsi
  8025fe:	89 c7                	mov    %eax,%edi
  802600:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  802607:	00 00 00 
  80260a:	ff d0                	callq  *%rax
  80260c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80260f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802613:	78 24                	js     802639 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802619:	8b 00                	mov    (%rax),%eax
  80261b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80261f:	48 89 d6             	mov    %rdx,%rsi
  802622:	89 c7                	mov    %eax,%edi
  802624:	48 b8 08 23 80 00 00 	movabs $0x802308,%rax
  80262b:	00 00 00 
  80262e:	ff d0                	callq  *%rax
  802630:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802633:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802637:	79 05                	jns    80263e <read+0x5d>
		return r;
  802639:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263c:	eb 76                	jmp    8026b4 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80263e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802642:	8b 40 08             	mov    0x8(%rax),%eax
  802645:	83 e0 03             	and    $0x3,%eax
  802648:	83 f8 01             	cmp    $0x1,%eax
  80264b:	75 3a                	jne    802687 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80264d:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802654:	00 00 00 
  802657:	48 8b 00             	mov    (%rax),%rax
  80265a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802660:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802663:	89 c6                	mov    %eax,%esi
  802665:	48 bf 07 4a 80 00 00 	movabs $0x804a07,%rdi
  80266c:	00 00 00 
  80266f:	b8 00 00 00 00       	mov    $0x0,%eax
  802674:	48 b9 52 07 80 00 00 	movabs $0x800752,%rcx
  80267b:	00 00 00 
  80267e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802680:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802685:	eb 2d                	jmp    8026b4 <read+0xd3>
	}
	if (!dev->dev_read)
  802687:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80268f:	48 85 c0             	test   %rax,%rax
  802692:	75 07                	jne    80269b <read+0xba>
		return -E_NOT_SUPP;
  802694:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802699:	eb 19                	jmp    8026b4 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80269b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269f:	48 8b 40 10          	mov    0x10(%rax),%rax
  8026a3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026a7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026ab:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026af:	48 89 cf             	mov    %rcx,%rdi
  8026b2:	ff d0                	callq  *%rax
}
  8026b4:	c9                   	leaveq 
  8026b5:	c3                   	retq   

00000000008026b6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8026b6:	55                   	push   %rbp
  8026b7:	48 89 e5             	mov    %rsp,%rbp
  8026ba:	48 83 ec 30          	sub    $0x30,%rsp
  8026be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8026c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026d0:	eb 49                	jmp    80271b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8026d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d5:	48 98                	cltq   
  8026d7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026db:	48 29 c2             	sub    %rax,%rdx
  8026de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e1:	48 63 c8             	movslq %eax,%rcx
  8026e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026e8:	48 01 c1             	add    %rax,%rcx
  8026eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026ee:	48 89 ce             	mov    %rcx,%rsi
  8026f1:	89 c7                	mov    %eax,%edi
  8026f3:	48 b8 e1 25 80 00 00 	movabs $0x8025e1,%rax
  8026fa:	00 00 00 
  8026fd:	ff d0                	callq  *%rax
  8026ff:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802702:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802706:	79 05                	jns    80270d <readn+0x57>
			return m;
  802708:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80270b:	eb 1c                	jmp    802729 <readn+0x73>
		if (m == 0)
  80270d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802711:	75 02                	jne    802715 <readn+0x5f>
			break;
  802713:	eb 11                	jmp    802726 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802715:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802718:	01 45 fc             	add    %eax,-0x4(%rbp)
  80271b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271e:	48 98                	cltq   
  802720:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802724:	72 ac                	jb     8026d2 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802726:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802729:	c9                   	leaveq 
  80272a:	c3                   	retq   

000000000080272b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80272b:	55                   	push   %rbp
  80272c:	48 89 e5             	mov    %rsp,%rbp
  80272f:	48 83 ec 40          	sub    $0x40,%rsp
  802733:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802736:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80273a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80273e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802742:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802745:	48 89 d6             	mov    %rdx,%rsi
  802748:	89 c7                	mov    %eax,%edi
  80274a:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  802751:	00 00 00 
  802754:	ff d0                	callq  *%rax
  802756:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802759:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80275d:	78 24                	js     802783 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80275f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802763:	8b 00                	mov    (%rax),%eax
  802765:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802769:	48 89 d6             	mov    %rdx,%rsi
  80276c:	89 c7                	mov    %eax,%edi
  80276e:	48 b8 08 23 80 00 00 	movabs $0x802308,%rax
  802775:	00 00 00 
  802778:	ff d0                	callq  *%rax
  80277a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802781:	79 05                	jns    802788 <write+0x5d>
		return r;
  802783:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802786:	eb 75                	jmp    8027fd <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278c:	8b 40 08             	mov    0x8(%rax),%eax
  80278f:	83 e0 03             	and    $0x3,%eax
  802792:	85 c0                	test   %eax,%eax
  802794:	75 3a                	jne    8027d0 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802796:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80279d:	00 00 00 
  8027a0:	48 8b 00             	mov    (%rax),%rax
  8027a3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027a9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027ac:	89 c6                	mov    %eax,%esi
  8027ae:	48 bf 23 4a 80 00 00 	movabs $0x804a23,%rdi
  8027b5:	00 00 00 
  8027b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bd:	48 b9 52 07 80 00 00 	movabs $0x800752,%rcx
  8027c4:	00 00 00 
  8027c7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027ce:	eb 2d                	jmp    8027fd <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8027d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027d8:	48 85 c0             	test   %rax,%rax
  8027db:	75 07                	jne    8027e4 <write+0xb9>
		return -E_NOT_SUPP;
  8027dd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027e2:	eb 19                	jmp    8027fd <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8027e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e8:	48 8b 40 18          	mov    0x18(%rax),%rax
  8027ec:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8027f0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027f4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8027f8:	48 89 cf             	mov    %rcx,%rdi
  8027fb:	ff d0                	callq  *%rax
}
  8027fd:	c9                   	leaveq 
  8027fe:	c3                   	retq   

00000000008027ff <seek>:

int
seek(int fdnum, off_t offset)
{
  8027ff:	55                   	push   %rbp
  802800:	48 89 e5             	mov    %rsp,%rbp
  802803:	48 83 ec 18          	sub    $0x18,%rsp
  802807:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80280a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80280d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802811:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802814:	48 89 d6             	mov    %rdx,%rsi
  802817:	89 c7                	mov    %eax,%edi
  802819:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  802820:	00 00 00 
  802823:	ff d0                	callq  *%rax
  802825:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802828:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282c:	79 05                	jns    802833 <seek+0x34>
		return r;
  80282e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802831:	eb 0f                	jmp    802842 <seek+0x43>
	fd->fd_offset = offset;
  802833:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802837:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80283a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80283d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802842:	c9                   	leaveq 
  802843:	c3                   	retq   

0000000000802844 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802844:	55                   	push   %rbp
  802845:	48 89 e5             	mov    %rsp,%rbp
  802848:	48 83 ec 30          	sub    $0x30,%rsp
  80284c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80284f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802852:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802856:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802859:	48 89 d6             	mov    %rdx,%rsi
  80285c:	89 c7                	mov    %eax,%edi
  80285e:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  802865:	00 00 00 
  802868:	ff d0                	callq  *%rax
  80286a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802871:	78 24                	js     802897 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802873:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802877:	8b 00                	mov    (%rax),%eax
  802879:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80287d:	48 89 d6             	mov    %rdx,%rsi
  802880:	89 c7                	mov    %eax,%edi
  802882:	48 b8 08 23 80 00 00 	movabs $0x802308,%rax
  802889:	00 00 00 
  80288c:	ff d0                	callq  *%rax
  80288e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802891:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802895:	79 05                	jns    80289c <ftruncate+0x58>
		return r;
  802897:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80289a:	eb 72                	jmp    80290e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80289c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a0:	8b 40 08             	mov    0x8(%rax),%eax
  8028a3:	83 e0 03             	and    $0x3,%eax
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	75 3a                	jne    8028e4 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8028aa:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8028b1:	00 00 00 
  8028b4:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8028b7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028bd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028c0:	89 c6                	mov    %eax,%esi
  8028c2:	48 bf 40 4a 80 00 00 	movabs $0x804a40,%rdi
  8028c9:	00 00 00 
  8028cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d1:	48 b9 52 07 80 00 00 	movabs $0x800752,%rcx
  8028d8:	00 00 00 
  8028db:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8028dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028e2:	eb 2a                	jmp    80290e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8028e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e8:	48 8b 40 30          	mov    0x30(%rax),%rax
  8028ec:	48 85 c0             	test   %rax,%rax
  8028ef:	75 07                	jne    8028f8 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8028f1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028f6:	eb 16                	jmp    80290e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8028f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028fc:	48 8b 40 30          	mov    0x30(%rax),%rax
  802900:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802904:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802907:	89 ce                	mov    %ecx,%esi
  802909:	48 89 d7             	mov    %rdx,%rdi
  80290c:	ff d0                	callq  *%rax
}
  80290e:	c9                   	leaveq 
  80290f:	c3                   	retq   

0000000000802910 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802910:	55                   	push   %rbp
  802911:	48 89 e5             	mov    %rsp,%rbp
  802914:	48 83 ec 30          	sub    $0x30,%rsp
  802918:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80291b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80291f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802923:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802926:	48 89 d6             	mov    %rdx,%rsi
  802929:	89 c7                	mov    %eax,%edi
  80292b:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  802932:	00 00 00 
  802935:	ff d0                	callq  *%rax
  802937:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293e:	78 24                	js     802964 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802944:	8b 00                	mov    (%rax),%eax
  802946:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80294a:	48 89 d6             	mov    %rdx,%rsi
  80294d:	89 c7                	mov    %eax,%edi
  80294f:	48 b8 08 23 80 00 00 	movabs $0x802308,%rax
  802956:	00 00 00 
  802959:	ff d0                	callq  *%rax
  80295b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802962:	79 05                	jns    802969 <fstat+0x59>
		return r;
  802964:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802967:	eb 5e                	jmp    8029c7 <fstat+0xb7>
	if (!dev->dev_stat)
  802969:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80296d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802971:	48 85 c0             	test   %rax,%rax
  802974:	75 07                	jne    80297d <fstat+0x6d>
		return -E_NOT_SUPP;
  802976:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80297b:	eb 4a                	jmp    8029c7 <fstat+0xb7>
	stat->st_name[0] = 0;
  80297d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802981:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802984:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802988:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80298f:	00 00 00 
	stat->st_isdir = 0;
  802992:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802996:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80299d:	00 00 00 
	stat->st_dev = dev;
  8029a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029a8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8029af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b3:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029bb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029bf:	48 89 ce             	mov    %rcx,%rsi
  8029c2:	48 89 d7             	mov    %rdx,%rdi
  8029c5:	ff d0                	callq  *%rax
}
  8029c7:	c9                   	leaveq 
  8029c8:	c3                   	retq   

00000000008029c9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8029c9:	55                   	push   %rbp
  8029ca:	48 89 e5             	mov    %rsp,%rbp
  8029cd:	48 83 ec 20          	sub    $0x20,%rsp
  8029d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8029d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029dd:	be 00 00 00 00       	mov    $0x0,%esi
  8029e2:	48 89 c7             	mov    %rax,%rdi
  8029e5:	48 b8 b7 2a 80 00 00 	movabs $0x802ab7,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax
  8029f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f8:	79 05                	jns    8029ff <stat+0x36>
		return fd;
  8029fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fd:	eb 2f                	jmp    802a2e <stat+0x65>
	r = fstat(fd, stat);
  8029ff:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a06:	48 89 d6             	mov    %rdx,%rsi
  802a09:	89 c7                	mov    %eax,%edi
  802a0b:	48 b8 10 29 80 00 00 	movabs $0x802910,%rax
  802a12:	00 00 00 
  802a15:	ff d0                	callq  *%rax
  802a17:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1d:	89 c7                	mov    %eax,%edi
  802a1f:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  802a26:	00 00 00 
  802a29:	ff d0                	callq  *%rax
	return r;
  802a2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802a2e:	c9                   	leaveq 
  802a2f:	c3                   	retq   

0000000000802a30 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802a30:	55                   	push   %rbp
  802a31:	48 89 e5             	mov    %rsp,%rbp
  802a34:	48 83 ec 10          	sub    $0x10,%rsp
  802a38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802a3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802a3f:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802a46:	00 00 00 
  802a49:	8b 00                	mov    (%rax),%eax
  802a4b:	85 c0                	test   %eax,%eax
  802a4d:	75 1d                	jne    802a6c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802a4f:	bf 01 00 00 00       	mov    $0x1,%edi
  802a54:	48 b8 0e 43 80 00 00 	movabs $0x80430e,%rax
  802a5b:	00 00 00 
  802a5e:	ff d0                	callq  *%rax
  802a60:	48 ba 00 74 80 00 00 	movabs $0x807400,%rdx
  802a67:	00 00 00 
  802a6a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802a6c:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802a73:	00 00 00 
  802a76:	8b 00                	mov    (%rax),%eax
  802a78:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802a7b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802a80:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802a87:	00 00 00 
  802a8a:	89 c7                	mov    %eax,%edi
  802a8c:	48 b8 ac 42 80 00 00 	movabs $0x8042ac,%rax
  802a93:	00 00 00 
  802a96:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802aa1:	48 89 c6             	mov    %rax,%rsi
  802aa4:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa9:	48 b8 a6 41 80 00 00 	movabs $0x8041a6,%rax
  802ab0:	00 00 00 
  802ab3:	ff d0                	callq  *%rax
}
  802ab5:	c9                   	leaveq 
  802ab6:	c3                   	retq   

0000000000802ab7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ab7:	55                   	push   %rbp
  802ab8:	48 89 e5             	mov    %rsp,%rbp
  802abb:	48 83 ec 30          	sub    $0x30,%rsp
  802abf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ac3:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802ac6:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802acd:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802ad4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802adb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ae0:	75 08                	jne    802aea <open+0x33>
	{
		return r;
  802ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae5:	e9 f2 00 00 00       	jmpq   802bdc <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802aea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aee:	48 89 c7             	mov    %rax,%rdi
  802af1:	48 b8 f5 13 80 00 00 	movabs $0x8013f5,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	callq  *%rax
  802afd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b00:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802b07:	7e 0a                	jle    802b13 <open+0x5c>
	{
		return -E_BAD_PATH;
  802b09:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b0e:	e9 c9 00 00 00       	jmpq   802bdc <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802b13:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802b1a:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802b1b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b1f:	48 89 c7             	mov    %rax,%rdi
  802b22:	48 b8 17 21 80 00 00 	movabs $0x802117,%rax
  802b29:	00 00 00 
  802b2c:	ff d0                	callq  *%rax
  802b2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b35:	78 09                	js     802b40 <open+0x89>
  802b37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3b:	48 85 c0             	test   %rax,%rax
  802b3e:	75 08                	jne    802b48 <open+0x91>
		{
			return r;
  802b40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b43:	e9 94 00 00 00       	jmpq   802bdc <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802b48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b4c:	ba 00 04 00 00       	mov    $0x400,%edx
  802b51:	48 89 c6             	mov    %rax,%rsi
  802b54:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b5b:	00 00 00 
  802b5e:	48 b8 f3 14 80 00 00 	movabs $0x8014f3,%rax
  802b65:	00 00 00 
  802b68:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802b6a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b71:	00 00 00 
  802b74:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802b77:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b81:	48 89 c6             	mov    %rax,%rsi
  802b84:	bf 01 00 00 00       	mov    $0x1,%edi
  802b89:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  802b90:	00 00 00 
  802b93:	ff d0                	callq  *%rax
  802b95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9c:	79 2b                	jns    802bc9 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802b9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba2:	be 00 00 00 00       	mov    $0x0,%esi
  802ba7:	48 89 c7             	mov    %rax,%rdi
  802baa:	48 b8 3f 22 80 00 00 	movabs $0x80223f,%rax
  802bb1:	00 00 00 
  802bb4:	ff d0                	callq  *%rax
  802bb6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802bb9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bbd:	79 05                	jns    802bc4 <open+0x10d>
			{
				return d;
  802bbf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc2:	eb 18                	jmp    802bdc <open+0x125>
			}
			return r;
  802bc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc7:	eb 13                	jmp    802bdc <open+0x125>
		}	
		return fd2num(fd_store);
  802bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bcd:	48 89 c7             	mov    %rax,%rdi
  802bd0:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  802bd7:	00 00 00 
  802bda:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802bdc:	c9                   	leaveq 
  802bdd:	c3                   	retq   

0000000000802bde <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802bde:	55                   	push   %rbp
  802bdf:	48 89 e5             	mov    %rsp,%rbp
  802be2:	48 83 ec 10          	sub    $0x10,%rsp
  802be6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802bea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bee:	8b 50 0c             	mov    0xc(%rax),%edx
  802bf1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bf8:	00 00 00 
  802bfb:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802bfd:	be 00 00 00 00       	mov    $0x0,%esi
  802c02:	bf 06 00 00 00       	mov    $0x6,%edi
  802c07:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  802c0e:	00 00 00 
  802c11:	ff d0                	callq  *%rax
}
  802c13:	c9                   	leaveq 
  802c14:	c3                   	retq   

0000000000802c15 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c15:	55                   	push   %rbp
  802c16:	48 89 e5             	mov    %rsp,%rbp
  802c19:	48 83 ec 30          	sub    $0x30,%rsp
  802c1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c25:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  802c29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  802c30:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c35:	74 07                	je     802c3e <devfile_read+0x29>
  802c37:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c3c:	75 07                	jne    802c45 <devfile_read+0x30>
		return -E_INVAL;
  802c3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c43:	eb 77                	jmp    802cbc <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c49:	8b 50 0c             	mov    0xc(%rax),%edx
  802c4c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c53:	00 00 00 
  802c56:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c58:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c5f:	00 00 00 
  802c62:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c66:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802c6a:	be 00 00 00 00       	mov    $0x0,%esi
  802c6f:	bf 03 00 00 00       	mov    $0x3,%edi
  802c74:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  802c7b:	00 00 00 
  802c7e:	ff d0                	callq  *%rax
  802c80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c87:	7f 05                	jg     802c8e <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802c89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8c:	eb 2e                	jmp    802cbc <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c91:	48 63 d0             	movslq %eax,%rdx
  802c94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c98:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c9f:	00 00 00 
  802ca2:	48 89 c7             	mov    %rax,%rdi
  802ca5:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  802cac:	00 00 00 
  802caf:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802cb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cb5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802cb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802cbc:	c9                   	leaveq 
  802cbd:	c3                   	retq   

0000000000802cbe <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802cbe:	55                   	push   %rbp
  802cbf:	48 89 e5             	mov    %rsp,%rbp
  802cc2:	48 83 ec 30          	sub    $0x30,%rsp
  802cc6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802cd2:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802cd9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802cde:	74 07                	je     802ce7 <devfile_write+0x29>
  802ce0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ce5:	75 08                	jne    802cef <devfile_write+0x31>
		return r;
  802ce7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cea:	e9 9a 00 00 00       	jmpq   802d89 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802cef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf3:	8b 50 0c             	mov    0xc(%rax),%edx
  802cf6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cfd:	00 00 00 
  802d00:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802d02:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d09:	00 
  802d0a:	76 08                	jbe    802d14 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802d0c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802d13:	00 
	}
	fsipcbuf.write.req_n = n;
  802d14:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d1b:	00 00 00 
  802d1e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d22:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802d26:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d2e:	48 89 c6             	mov    %rax,%rsi
  802d31:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802d38:	00 00 00 
  802d3b:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  802d42:	00 00 00 
  802d45:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802d47:	be 00 00 00 00       	mov    $0x0,%esi
  802d4c:	bf 04 00 00 00       	mov    $0x4,%edi
  802d51:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  802d58:	00 00 00 
  802d5b:	ff d0                	callq  *%rax
  802d5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d64:	7f 20                	jg     802d86 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802d66:	48 bf 66 4a 80 00 00 	movabs $0x804a66,%rdi
  802d6d:	00 00 00 
  802d70:	b8 00 00 00 00       	mov    $0x0,%eax
  802d75:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  802d7c:	00 00 00 
  802d7f:	ff d2                	callq  *%rdx
		return r;
  802d81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d84:	eb 03                	jmp    802d89 <devfile_write+0xcb>
	}
	return r;
  802d86:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802d89:	c9                   	leaveq 
  802d8a:	c3                   	retq   

0000000000802d8b <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d8b:	55                   	push   %rbp
  802d8c:	48 89 e5             	mov    %rsp,%rbp
  802d8f:	48 83 ec 20          	sub    $0x20,%rsp
  802d93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d97:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9f:	8b 50 0c             	mov    0xc(%rax),%edx
  802da2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802da9:	00 00 00 
  802dac:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802dae:	be 00 00 00 00       	mov    $0x0,%esi
  802db3:	bf 05 00 00 00       	mov    $0x5,%edi
  802db8:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  802dbf:	00 00 00 
  802dc2:	ff d0                	callq  *%rax
  802dc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dcb:	79 05                	jns    802dd2 <devfile_stat+0x47>
		return r;
  802dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd0:	eb 56                	jmp    802e28 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802dd2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dd6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ddd:	00 00 00 
  802de0:	48 89 c7             	mov    %rax,%rdi
  802de3:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802def:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802df6:	00 00 00 
  802df9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802dff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e03:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e09:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e10:	00 00 00 
  802e13:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e19:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e1d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e28:	c9                   	leaveq 
  802e29:	c3                   	retq   

0000000000802e2a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e2a:	55                   	push   %rbp
  802e2b:	48 89 e5             	mov    %rsp,%rbp
  802e2e:	48 83 ec 10          	sub    $0x10,%rsp
  802e32:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e36:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e3d:	8b 50 0c             	mov    0xc(%rax),%edx
  802e40:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e47:	00 00 00 
  802e4a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e4c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e53:	00 00 00 
  802e56:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e59:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e5c:	be 00 00 00 00       	mov    $0x0,%esi
  802e61:	bf 02 00 00 00       	mov    $0x2,%edi
  802e66:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  802e6d:	00 00 00 
  802e70:	ff d0                	callq  *%rax
}
  802e72:	c9                   	leaveq 
  802e73:	c3                   	retq   

0000000000802e74 <remove>:

// Delete a file
int
remove(const char *path)
{
  802e74:	55                   	push   %rbp
  802e75:	48 89 e5             	mov    %rsp,%rbp
  802e78:	48 83 ec 10          	sub    $0x10,%rsp
  802e7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e84:	48 89 c7             	mov    %rax,%rdi
  802e87:	48 b8 f5 13 80 00 00 	movabs $0x8013f5,%rax
  802e8e:	00 00 00 
  802e91:	ff d0                	callq  *%rax
  802e93:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e98:	7e 07                	jle    802ea1 <remove+0x2d>
		return -E_BAD_PATH;
  802e9a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e9f:	eb 33                	jmp    802ed4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ea1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea5:	48 89 c6             	mov    %rax,%rsi
  802ea8:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802eaf:	00 00 00 
  802eb2:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  802eb9:	00 00 00 
  802ebc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802ebe:	be 00 00 00 00       	mov    $0x0,%esi
  802ec3:	bf 07 00 00 00       	mov    $0x7,%edi
  802ec8:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  802ecf:	00 00 00 
  802ed2:	ff d0                	callq  *%rax
}
  802ed4:	c9                   	leaveq 
  802ed5:	c3                   	retq   

0000000000802ed6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ed6:	55                   	push   %rbp
  802ed7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802eda:	be 00 00 00 00       	mov    $0x0,%esi
  802edf:	bf 08 00 00 00       	mov    $0x8,%edi
  802ee4:	48 b8 30 2a 80 00 00 	movabs $0x802a30,%rax
  802eeb:	00 00 00 
  802eee:	ff d0                	callq  *%rax
}
  802ef0:	5d                   	pop    %rbp
  802ef1:	c3                   	retq   

0000000000802ef2 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ef2:	55                   	push   %rbp
  802ef3:	48 89 e5             	mov    %rsp,%rbp
  802ef6:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802efd:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802f04:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802f0b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802f12:	be 00 00 00 00       	mov    $0x0,%esi
  802f17:	48 89 c7             	mov    %rax,%rdi
  802f1a:	48 b8 b7 2a 80 00 00 	movabs $0x802ab7,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
  802f26:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802f29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f2d:	79 28                	jns    802f57 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802f2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f32:	89 c6                	mov    %eax,%esi
  802f34:	48 bf 82 4a 80 00 00 	movabs $0x804a82,%rdi
  802f3b:	00 00 00 
  802f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f43:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  802f4a:	00 00 00 
  802f4d:	ff d2                	callq  *%rdx
		return fd_src;
  802f4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f52:	e9 74 01 00 00       	jmpq   8030cb <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802f57:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802f5e:	be 01 01 00 00       	mov    $0x101,%esi
  802f63:	48 89 c7             	mov    %rax,%rdi
  802f66:	48 b8 b7 2a 80 00 00 	movabs $0x802ab7,%rax
  802f6d:	00 00 00 
  802f70:	ff d0                	callq  *%rax
  802f72:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802f75:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f79:	79 39                	jns    802fb4 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802f7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f7e:	89 c6                	mov    %eax,%esi
  802f80:	48 bf 98 4a 80 00 00 	movabs $0x804a98,%rdi
  802f87:	00 00 00 
  802f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8f:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  802f96:	00 00 00 
  802f99:	ff d2                	callq  *%rdx
		close(fd_src);
  802f9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9e:	89 c7                	mov    %eax,%edi
  802fa0:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  802fa7:	00 00 00 
  802faa:	ff d0                	callq  *%rax
		return fd_dest;
  802fac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802faf:	e9 17 01 00 00       	jmpq   8030cb <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802fb4:	eb 74                	jmp    80302a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802fb6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fb9:	48 63 d0             	movslq %eax,%rdx
  802fbc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802fc3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fc6:	48 89 ce             	mov    %rcx,%rsi
  802fc9:	89 c7                	mov    %eax,%edi
  802fcb:	48 b8 2b 27 80 00 00 	movabs $0x80272b,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
  802fd7:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802fda:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802fde:	79 4a                	jns    80302a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802fe0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fe3:	89 c6                	mov    %eax,%esi
  802fe5:	48 bf b2 4a 80 00 00 	movabs $0x804ab2,%rdi
  802fec:	00 00 00 
  802fef:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff4:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  802ffb:	00 00 00 
  802ffe:	ff d2                	callq  *%rdx
			close(fd_src);
  803000:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803003:	89 c7                	mov    %eax,%edi
  803005:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  80300c:	00 00 00 
  80300f:	ff d0                	callq  *%rax
			close(fd_dest);
  803011:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803014:	89 c7                	mov    %eax,%edi
  803016:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  80301d:	00 00 00 
  803020:	ff d0                	callq  *%rax
			return write_size;
  803022:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803025:	e9 a1 00 00 00       	jmpq   8030cb <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80302a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803031:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803034:	ba 00 02 00 00       	mov    $0x200,%edx
  803039:	48 89 ce             	mov    %rcx,%rsi
  80303c:	89 c7                	mov    %eax,%edi
  80303e:	48 b8 e1 25 80 00 00 	movabs $0x8025e1,%rax
  803045:	00 00 00 
  803048:	ff d0                	callq  *%rax
  80304a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80304d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803051:	0f 8f 5f ff ff ff    	jg     802fb6 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803057:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80305b:	79 47                	jns    8030a4 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80305d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803060:	89 c6                	mov    %eax,%esi
  803062:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  803069:	00 00 00 
  80306c:	b8 00 00 00 00       	mov    $0x0,%eax
  803071:	48 ba 52 07 80 00 00 	movabs $0x800752,%rdx
  803078:	00 00 00 
  80307b:	ff d2                	callq  *%rdx
		close(fd_src);
  80307d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803080:	89 c7                	mov    %eax,%edi
  803082:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  803089:	00 00 00 
  80308c:	ff d0                	callq  *%rax
		close(fd_dest);
  80308e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803091:	89 c7                	mov    %eax,%edi
  803093:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  80309a:	00 00 00 
  80309d:	ff d0                	callq  *%rax
		return read_size;
  80309f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030a2:	eb 27                	jmp    8030cb <copy+0x1d9>
	}
	close(fd_src);
  8030a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a7:	89 c7                	mov    %eax,%edi
  8030a9:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  8030b0:	00 00 00 
  8030b3:	ff d0                	callq  *%rax
	close(fd_dest);
  8030b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030b8:	89 c7                	mov    %eax,%edi
  8030ba:	48 b8 bf 23 80 00 00 	movabs $0x8023bf,%rax
  8030c1:	00 00 00 
  8030c4:	ff d0                	callq  *%rax
	return 0;
  8030c6:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8030cb:	c9                   	leaveq 
  8030cc:	c3                   	retq   

00000000008030cd <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8030cd:	55                   	push   %rbp
  8030ce:	48 89 e5             	mov    %rsp,%rbp
  8030d1:	48 83 ec 20          	sub    $0x20,%rsp
  8030d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8030d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030dd:	8b 40 0c             	mov    0xc(%rax),%eax
  8030e0:	85 c0                	test   %eax,%eax
  8030e2:	7e 67                	jle    80314b <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8030e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e8:	8b 40 04             	mov    0x4(%rax),%eax
  8030eb:	48 63 d0             	movslq %eax,%rdx
  8030ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f2:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8030f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030fa:	8b 00                	mov    (%rax),%eax
  8030fc:	48 89 ce             	mov    %rcx,%rsi
  8030ff:	89 c7                	mov    %eax,%edi
  803101:	48 b8 2b 27 80 00 00 	movabs $0x80272b,%rax
  803108:	00 00 00 
  80310b:	ff d0                	callq  *%rax
  80310d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  803110:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803114:	7e 13                	jle    803129 <writebuf+0x5c>
			b->result += result;
  803116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311a:	8b 50 08             	mov    0x8(%rax),%edx
  80311d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803120:	01 c2                	add    %eax,%edx
  803122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803126:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  803129:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312d:	8b 40 04             	mov    0x4(%rax),%eax
  803130:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803133:	74 16                	je     80314b <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  803135:	b8 00 00 00 00       	mov    $0x0,%eax
  80313a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313e:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  803142:	89 c2                	mov    %eax,%edx
  803144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803148:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  80314b:	c9                   	leaveq 
  80314c:	c3                   	retq   

000000000080314d <putch>:

static void
putch(int ch, void *thunk)
{
  80314d:	55                   	push   %rbp
  80314e:	48 89 e5             	mov    %rsp,%rbp
  803151:	48 83 ec 20          	sub    $0x20,%rsp
  803155:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803158:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  80315c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803160:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  803164:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803168:	8b 40 04             	mov    0x4(%rax),%eax
  80316b:	8d 48 01             	lea    0x1(%rax),%ecx
  80316e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803172:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803175:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803178:	89 d1                	mov    %edx,%ecx
  80317a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80317e:	48 98                	cltq   
  803180:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803184:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803188:	8b 40 04             	mov    0x4(%rax),%eax
  80318b:	3d 00 01 00 00       	cmp    $0x100,%eax
  803190:	75 1e                	jne    8031b0 <putch+0x63>
		writebuf(b);
  803192:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803196:	48 89 c7             	mov    %rax,%rdi
  803199:	48 b8 cd 30 80 00 00 	movabs $0x8030cd,%rax
  8031a0:	00 00 00 
  8031a3:	ff d0                	callq  *%rax
		b->idx = 0;
  8031a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  8031b0:	c9                   	leaveq 
  8031b1:	c3                   	retq   

00000000008031b2 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8031b2:	55                   	push   %rbp
  8031b3:	48 89 e5             	mov    %rsp,%rbp
  8031b6:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8031bd:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8031c3:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8031ca:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8031d1:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8031d7:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8031dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8031e4:	00 00 00 
	b.result = 0;
  8031e7:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8031ee:	00 00 00 
	b.error = 1;
  8031f1:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8031f8:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8031fb:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803202:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  803209:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803210:	48 89 c6             	mov    %rax,%rsi
  803213:	48 bf 4d 31 80 00 00 	movabs $0x80314d,%rdi
  80321a:	00 00 00 
  80321d:	48 b8 05 0b 80 00 00 	movabs $0x800b05,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803229:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  80322f:	85 c0                	test   %eax,%eax
  803231:	7e 16                	jle    803249 <vfprintf+0x97>
		writebuf(&b);
  803233:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80323a:	48 89 c7             	mov    %rax,%rdi
  80323d:	48 b8 cd 30 80 00 00 	movabs $0x8030cd,%rax
  803244:	00 00 00 
  803247:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803249:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80324f:	85 c0                	test   %eax,%eax
  803251:	74 08                	je     80325b <vfprintf+0xa9>
  803253:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803259:	eb 06                	jmp    803261 <vfprintf+0xaf>
  80325b:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803261:	c9                   	leaveq 
  803262:	c3                   	retq   

0000000000803263 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803263:	55                   	push   %rbp
  803264:	48 89 e5             	mov    %rsp,%rbp
  803267:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80326e:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803274:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80327b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803282:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803289:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803290:	84 c0                	test   %al,%al
  803292:	74 20                	je     8032b4 <fprintf+0x51>
  803294:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803298:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80329c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8032a0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8032a4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8032a8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8032ac:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8032b0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8032b4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8032bb:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8032c2:	00 00 00 
  8032c5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8032cc:	00 00 00 
  8032cf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032d3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8032da:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8032e1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8032e8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8032ef:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8032f6:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8032fc:	48 89 ce             	mov    %rcx,%rsi
  8032ff:	89 c7                	mov    %eax,%edi
  803301:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax
  80330d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803313:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803319:	c9                   	leaveq 
  80331a:	c3                   	retq   

000000000080331b <printf>:

int
printf(const char *fmt, ...)
{
  80331b:	55                   	push   %rbp
  80331c:	48 89 e5             	mov    %rsp,%rbp
  80331f:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803326:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80332d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803334:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80333b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803342:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803349:	84 c0                	test   %al,%al
  80334b:	74 20                	je     80336d <printf+0x52>
  80334d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803351:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803355:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803359:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80335d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803361:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803365:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803369:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80336d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803374:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80337b:	00 00 00 
  80337e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803385:	00 00 00 
  803388:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80338c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803393:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80339a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  8033a1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8033a8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8033af:	48 89 c6             	mov    %rax,%rsi
  8033b2:	bf 01 00 00 00       	mov    $0x1,%edi
  8033b7:	48 b8 b2 31 80 00 00 	movabs $0x8031b2,%rax
  8033be:	00 00 00 
  8033c1:	ff d0                	callq  *%rax
  8033c3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8033c9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8033cf:	c9                   	leaveq 
  8033d0:	c3                   	retq   

00000000008033d1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8033d1:	55                   	push   %rbp
  8033d2:	48 89 e5             	mov    %rsp,%rbp
  8033d5:	48 83 ec 20          	sub    $0x20,%rsp
  8033d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8033dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8033e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e3:	48 89 d6             	mov    %rdx,%rsi
  8033e6:	89 c7                	mov    %eax,%edi
  8033e8:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
  8033f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fb:	79 05                	jns    803402 <fd2sockid+0x31>
		return r;
  8033fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803400:	eb 24                	jmp    803426 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803406:	8b 10                	mov    (%rax),%edx
  803408:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  80340f:	00 00 00 
  803412:	8b 00                	mov    (%rax),%eax
  803414:	39 c2                	cmp    %eax,%edx
  803416:	74 07                	je     80341f <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803418:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80341d:	eb 07                	jmp    803426 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80341f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803423:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803426:	c9                   	leaveq 
  803427:	c3                   	retq   

0000000000803428 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803428:	55                   	push   %rbp
  803429:	48 89 e5             	mov    %rsp,%rbp
  80342c:	48 83 ec 20          	sub    $0x20,%rsp
  803430:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803433:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803437:	48 89 c7             	mov    %rax,%rdi
  80343a:	48 b8 17 21 80 00 00 	movabs $0x802117,%rax
  803441:	00 00 00 
  803444:	ff d0                	callq  *%rax
  803446:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803449:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80344d:	78 26                	js     803475 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80344f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803453:	ba 07 04 00 00       	mov    $0x407,%edx
  803458:	48 89 c6             	mov    %rax,%rsi
  80345b:	bf 00 00 00 00       	mov    $0x0,%edi
  803460:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  803467:	00 00 00 
  80346a:	ff d0                	callq  *%rax
  80346c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80346f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803473:	79 16                	jns    80348b <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803475:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803478:	89 c7                	mov    %eax,%edi
  80347a:	48 b8 35 39 80 00 00 	movabs $0x803935,%rax
  803481:	00 00 00 
  803484:	ff d0                	callq  *%rax
		return r;
  803486:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803489:	eb 3a                	jmp    8034c5 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80348b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80348f:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803496:	00 00 00 
  803499:	8b 12                	mov    (%rdx),%edx
  80349b:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80349d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8034a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ac:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034af:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8034b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b6:	48 89 c7             	mov    %rax,%rdi
  8034b9:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  8034c0:	00 00 00 
  8034c3:	ff d0                	callq  *%rax
}
  8034c5:	c9                   	leaveq 
  8034c6:	c3                   	retq   

00000000008034c7 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034c7:	55                   	push   %rbp
  8034c8:	48 89 e5             	mov    %rsp,%rbp
  8034cb:	48 83 ec 30          	sub    $0x30,%rsp
  8034cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034dd:	89 c7                	mov    %eax,%edi
  8034df:	48 b8 d1 33 80 00 00 	movabs $0x8033d1,%rax
  8034e6:	00 00 00 
  8034e9:	ff d0                	callq  *%rax
  8034eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f2:	79 05                	jns    8034f9 <accept+0x32>
		return r;
  8034f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f7:	eb 3b                	jmp    803534 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8034f9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034fd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803501:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803504:	48 89 ce             	mov    %rcx,%rsi
  803507:	89 c7                	mov    %eax,%edi
  803509:	48 b8 12 38 80 00 00 	movabs $0x803812,%rax
  803510:	00 00 00 
  803513:	ff d0                	callq  *%rax
  803515:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803518:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80351c:	79 05                	jns    803523 <accept+0x5c>
		return r;
  80351e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803521:	eb 11                	jmp    803534 <accept+0x6d>
	return alloc_sockfd(r);
  803523:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803526:	89 c7                	mov    %eax,%edi
  803528:	48 b8 28 34 80 00 00 	movabs $0x803428,%rax
  80352f:	00 00 00 
  803532:	ff d0                	callq  *%rax
}
  803534:	c9                   	leaveq 
  803535:	c3                   	retq   

0000000000803536 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803536:	55                   	push   %rbp
  803537:	48 89 e5             	mov    %rsp,%rbp
  80353a:	48 83 ec 20          	sub    $0x20,%rsp
  80353e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803541:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803545:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803548:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80354b:	89 c7                	mov    %eax,%edi
  80354d:	48 b8 d1 33 80 00 00 	movabs $0x8033d1,%rax
  803554:	00 00 00 
  803557:	ff d0                	callq  *%rax
  803559:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80355c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803560:	79 05                	jns    803567 <bind+0x31>
		return r;
  803562:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803565:	eb 1b                	jmp    803582 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803567:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80356a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80356e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803571:	48 89 ce             	mov    %rcx,%rsi
  803574:	89 c7                	mov    %eax,%edi
  803576:	48 b8 91 38 80 00 00 	movabs $0x803891,%rax
  80357d:	00 00 00 
  803580:	ff d0                	callq  *%rax
}
  803582:	c9                   	leaveq 
  803583:	c3                   	retq   

0000000000803584 <shutdown>:

int
shutdown(int s, int how)
{
  803584:	55                   	push   %rbp
  803585:	48 89 e5             	mov    %rsp,%rbp
  803588:	48 83 ec 20          	sub    $0x20,%rsp
  80358c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80358f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803592:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803595:	89 c7                	mov    %eax,%edi
  803597:	48 b8 d1 33 80 00 00 	movabs $0x8033d1,%rax
  80359e:	00 00 00 
  8035a1:	ff d0                	callq  *%rax
  8035a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035aa:	79 05                	jns    8035b1 <shutdown+0x2d>
		return r;
  8035ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035af:	eb 16                	jmp    8035c7 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8035b1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b7:	89 d6                	mov    %edx,%esi
  8035b9:	89 c7                	mov    %eax,%edi
  8035bb:	48 b8 f5 38 80 00 00 	movabs $0x8038f5,%rax
  8035c2:	00 00 00 
  8035c5:	ff d0                	callq  *%rax
}
  8035c7:	c9                   	leaveq 
  8035c8:	c3                   	retq   

00000000008035c9 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8035c9:	55                   	push   %rbp
  8035ca:	48 89 e5             	mov    %rsp,%rbp
  8035cd:	48 83 ec 10          	sub    $0x10,%rsp
  8035d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8035d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d9:	48 89 c7             	mov    %rax,%rdi
  8035dc:	48 b8 90 43 80 00 00 	movabs $0x804390,%rax
  8035e3:	00 00 00 
  8035e6:	ff d0                	callq  *%rax
  8035e8:	83 f8 01             	cmp    $0x1,%eax
  8035eb:	75 17                	jne    803604 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8035ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f1:	8b 40 0c             	mov    0xc(%rax),%eax
  8035f4:	89 c7                	mov    %eax,%edi
  8035f6:	48 b8 35 39 80 00 00 	movabs $0x803935,%rax
  8035fd:	00 00 00 
  803600:	ff d0                	callq  *%rax
  803602:	eb 05                	jmp    803609 <devsock_close+0x40>
	else
		return 0;
  803604:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803609:	c9                   	leaveq 
  80360a:	c3                   	retq   

000000000080360b <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80360b:	55                   	push   %rbp
  80360c:	48 89 e5             	mov    %rsp,%rbp
  80360f:	48 83 ec 20          	sub    $0x20,%rsp
  803613:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803616:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80361a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80361d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803620:	89 c7                	mov    %eax,%edi
  803622:	48 b8 d1 33 80 00 00 	movabs $0x8033d1,%rax
  803629:	00 00 00 
  80362c:	ff d0                	callq  *%rax
  80362e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803631:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803635:	79 05                	jns    80363c <connect+0x31>
		return r;
  803637:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363a:	eb 1b                	jmp    803657 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80363c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80363f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803643:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803646:	48 89 ce             	mov    %rcx,%rsi
  803649:	89 c7                	mov    %eax,%edi
  80364b:	48 b8 62 39 80 00 00 	movabs $0x803962,%rax
  803652:	00 00 00 
  803655:	ff d0                	callq  *%rax
}
  803657:	c9                   	leaveq 
  803658:	c3                   	retq   

0000000000803659 <listen>:

int
listen(int s, int backlog)
{
  803659:	55                   	push   %rbp
  80365a:	48 89 e5             	mov    %rsp,%rbp
  80365d:	48 83 ec 20          	sub    $0x20,%rsp
  803661:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803664:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803667:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80366a:	89 c7                	mov    %eax,%edi
  80366c:	48 b8 d1 33 80 00 00 	movabs $0x8033d1,%rax
  803673:	00 00 00 
  803676:	ff d0                	callq  *%rax
  803678:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80367b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80367f:	79 05                	jns    803686 <listen+0x2d>
		return r;
  803681:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803684:	eb 16                	jmp    80369c <listen+0x43>
	return nsipc_listen(r, backlog);
  803686:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803689:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368c:	89 d6                	mov    %edx,%esi
  80368e:	89 c7                	mov    %eax,%edi
  803690:	48 b8 c6 39 80 00 00 	movabs $0x8039c6,%rax
  803697:	00 00 00 
  80369a:	ff d0                	callq  *%rax
}
  80369c:	c9                   	leaveq 
  80369d:	c3                   	retq   

000000000080369e <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80369e:	55                   	push   %rbp
  80369f:	48 89 e5             	mov    %rsp,%rbp
  8036a2:	48 83 ec 20          	sub    $0x20,%rsp
  8036a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8036b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b6:	89 c2                	mov    %eax,%edx
  8036b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036bc:	8b 40 0c             	mov    0xc(%rax),%eax
  8036bf:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8036c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8036c8:	89 c7                	mov    %eax,%edi
  8036ca:	48 b8 06 3a 80 00 00 	movabs $0x803a06,%rax
  8036d1:	00 00 00 
  8036d4:	ff d0                	callq  *%rax
}
  8036d6:	c9                   	leaveq 
  8036d7:	c3                   	retq   

00000000008036d8 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8036d8:	55                   	push   %rbp
  8036d9:	48 89 e5             	mov    %rsp,%rbp
  8036dc:	48 83 ec 20          	sub    $0x20,%rsp
  8036e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036e8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8036ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f0:	89 c2                	mov    %eax,%edx
  8036f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f6:	8b 40 0c             	mov    0xc(%rax),%eax
  8036f9:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8036fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  803702:	89 c7                	mov    %eax,%edi
  803704:	48 b8 d2 3a 80 00 00 	movabs $0x803ad2,%rax
  80370b:	00 00 00 
  80370e:	ff d0                	callq  *%rax
}
  803710:	c9                   	leaveq 
  803711:	c3                   	retq   

0000000000803712 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803712:	55                   	push   %rbp
  803713:	48 89 e5             	mov    %rsp,%rbp
  803716:	48 83 ec 10          	sub    $0x10,%rsp
  80371a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80371e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803722:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803726:	48 be e0 4a 80 00 00 	movabs $0x804ae0,%rsi
  80372d:	00 00 00 
  803730:	48 89 c7             	mov    %rax,%rdi
  803733:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  80373a:	00 00 00 
  80373d:	ff d0                	callq  *%rax
	return 0;
  80373f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803744:	c9                   	leaveq 
  803745:	c3                   	retq   

0000000000803746 <socket>:

int
socket(int domain, int type, int protocol)
{
  803746:	55                   	push   %rbp
  803747:	48 89 e5             	mov    %rsp,%rbp
  80374a:	48 83 ec 20          	sub    $0x20,%rsp
  80374e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803751:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803754:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803757:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80375a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80375d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803760:	89 ce                	mov    %ecx,%esi
  803762:	89 c7                	mov    %eax,%edi
  803764:	48 b8 8a 3b 80 00 00 	movabs $0x803b8a,%rax
  80376b:	00 00 00 
  80376e:	ff d0                	callq  *%rax
  803770:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803773:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803777:	79 05                	jns    80377e <socket+0x38>
		return r;
  803779:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377c:	eb 11                	jmp    80378f <socket+0x49>
	return alloc_sockfd(r);
  80377e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803781:	89 c7                	mov    %eax,%edi
  803783:	48 b8 28 34 80 00 00 	movabs $0x803428,%rax
  80378a:	00 00 00 
  80378d:	ff d0                	callq  *%rax
}
  80378f:	c9                   	leaveq 
  803790:	c3                   	retq   

0000000000803791 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803791:	55                   	push   %rbp
  803792:	48 89 e5             	mov    %rsp,%rbp
  803795:	48 83 ec 10          	sub    $0x10,%rsp
  803799:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80379c:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  8037a3:	00 00 00 
  8037a6:	8b 00                	mov    (%rax),%eax
  8037a8:	85 c0                	test   %eax,%eax
  8037aa:	75 1d                	jne    8037c9 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8037ac:	bf 02 00 00 00       	mov    $0x2,%edi
  8037b1:	48 b8 0e 43 80 00 00 	movabs $0x80430e,%rax
  8037b8:	00 00 00 
  8037bb:	ff d0                	callq  *%rax
  8037bd:	48 ba 04 74 80 00 00 	movabs $0x807404,%rdx
  8037c4:	00 00 00 
  8037c7:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8037c9:	48 b8 04 74 80 00 00 	movabs $0x807404,%rax
  8037d0:	00 00 00 
  8037d3:	8b 00                	mov    (%rax),%eax
  8037d5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8037d8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8037dd:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8037e4:	00 00 00 
  8037e7:	89 c7                	mov    %eax,%edi
  8037e9:	48 b8 ac 42 80 00 00 	movabs $0x8042ac,%rax
  8037f0:	00 00 00 
  8037f3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8037f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8037fa:	be 00 00 00 00       	mov    $0x0,%esi
  8037ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803804:	48 b8 a6 41 80 00 00 	movabs $0x8041a6,%rax
  80380b:	00 00 00 
  80380e:	ff d0                	callq  *%rax
}
  803810:	c9                   	leaveq 
  803811:	c3                   	retq   

0000000000803812 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803812:	55                   	push   %rbp
  803813:	48 89 e5             	mov    %rsp,%rbp
  803816:	48 83 ec 30          	sub    $0x30,%rsp
  80381a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80381d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803821:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803825:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80382c:	00 00 00 
  80382f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803832:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803834:	bf 01 00 00 00       	mov    $0x1,%edi
  803839:	48 b8 91 37 80 00 00 	movabs $0x803791,%rax
  803840:	00 00 00 
  803843:	ff d0                	callq  *%rax
  803845:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803848:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384c:	78 3e                	js     80388c <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80384e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803855:	00 00 00 
  803858:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80385c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803860:	8b 40 10             	mov    0x10(%rax),%eax
  803863:	89 c2                	mov    %eax,%edx
  803865:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803869:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80386d:	48 89 ce             	mov    %rcx,%rsi
  803870:	48 89 c7             	mov    %rax,%rdi
  803873:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  80387a:	00 00 00 
  80387d:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80387f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803883:	8b 50 10             	mov    0x10(%rax),%edx
  803886:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80388a:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80388c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80388f:	c9                   	leaveq 
  803890:	c3                   	retq   

0000000000803891 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803891:	55                   	push   %rbp
  803892:	48 89 e5             	mov    %rsp,%rbp
  803895:	48 83 ec 10          	sub    $0x10,%rsp
  803899:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80389c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038a0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8038a3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038aa:	00 00 00 
  8038ad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038b0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8038b2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b9:	48 89 c6             	mov    %rax,%rsi
  8038bc:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8038c3:	00 00 00 
  8038c6:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  8038cd:	00 00 00 
  8038d0:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8038d2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038d9:	00 00 00 
  8038dc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038df:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8038e2:	bf 02 00 00 00       	mov    $0x2,%edi
  8038e7:	48 b8 91 37 80 00 00 	movabs $0x803791,%rax
  8038ee:	00 00 00 
  8038f1:	ff d0                	callq  *%rax
}
  8038f3:	c9                   	leaveq 
  8038f4:	c3                   	retq   

00000000008038f5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8038f5:	55                   	push   %rbp
  8038f6:	48 89 e5             	mov    %rsp,%rbp
  8038f9:	48 83 ec 10          	sub    $0x10,%rsp
  8038fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803900:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803903:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80390a:	00 00 00 
  80390d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803910:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803912:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803919:	00 00 00 
  80391c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80391f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803922:	bf 03 00 00 00       	mov    $0x3,%edi
  803927:	48 b8 91 37 80 00 00 	movabs $0x803791,%rax
  80392e:	00 00 00 
  803931:	ff d0                	callq  *%rax
}
  803933:	c9                   	leaveq 
  803934:	c3                   	retq   

0000000000803935 <nsipc_close>:

int
nsipc_close(int s)
{
  803935:	55                   	push   %rbp
  803936:	48 89 e5             	mov    %rsp,%rbp
  803939:	48 83 ec 10          	sub    $0x10,%rsp
  80393d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803940:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803947:	00 00 00 
  80394a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80394d:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80394f:	bf 04 00 00 00       	mov    $0x4,%edi
  803954:	48 b8 91 37 80 00 00 	movabs $0x803791,%rax
  80395b:	00 00 00 
  80395e:	ff d0                	callq  *%rax
}
  803960:	c9                   	leaveq 
  803961:	c3                   	retq   

0000000000803962 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803962:	55                   	push   %rbp
  803963:	48 89 e5             	mov    %rsp,%rbp
  803966:	48 83 ec 10          	sub    $0x10,%rsp
  80396a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80396d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803971:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803974:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80397b:	00 00 00 
  80397e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803981:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803983:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803986:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80398a:	48 89 c6             	mov    %rax,%rsi
  80398d:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803994:	00 00 00 
  803997:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  80399e:	00 00 00 
  8039a1:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8039a3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039aa:	00 00 00 
  8039ad:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039b0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8039b3:	bf 05 00 00 00       	mov    $0x5,%edi
  8039b8:	48 b8 91 37 80 00 00 	movabs $0x803791,%rax
  8039bf:	00 00 00 
  8039c2:	ff d0                	callq  *%rax
}
  8039c4:	c9                   	leaveq 
  8039c5:	c3                   	retq   

00000000008039c6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8039c6:	55                   	push   %rbp
  8039c7:	48 89 e5             	mov    %rsp,%rbp
  8039ca:	48 83 ec 10          	sub    $0x10,%rsp
  8039ce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039d1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8039d4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039db:	00 00 00 
  8039de:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039e1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8039e3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039ea:	00 00 00 
  8039ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039f0:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8039f3:	bf 06 00 00 00       	mov    $0x6,%edi
  8039f8:	48 b8 91 37 80 00 00 	movabs $0x803791,%rax
  8039ff:	00 00 00 
  803a02:	ff d0                	callq  *%rax
}
  803a04:	c9                   	leaveq 
  803a05:	c3                   	retq   

0000000000803a06 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803a06:	55                   	push   %rbp
  803a07:	48 89 e5             	mov    %rsp,%rbp
  803a0a:	48 83 ec 30          	sub    $0x30,%rsp
  803a0e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a15:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803a18:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803a1b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a22:	00 00 00 
  803a25:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a28:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803a2a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a31:	00 00 00 
  803a34:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a37:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803a3a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a41:	00 00 00 
  803a44:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803a47:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803a4a:	bf 07 00 00 00       	mov    $0x7,%edi
  803a4f:	48 b8 91 37 80 00 00 	movabs $0x803791,%rax
  803a56:	00 00 00 
  803a59:	ff d0                	callq  *%rax
  803a5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a62:	78 69                	js     803acd <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803a64:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803a6b:	7f 08                	jg     803a75 <nsipc_recv+0x6f>
  803a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a70:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803a73:	7e 35                	jle    803aaa <nsipc_recv+0xa4>
  803a75:	48 b9 e7 4a 80 00 00 	movabs $0x804ae7,%rcx
  803a7c:	00 00 00 
  803a7f:	48 ba fc 4a 80 00 00 	movabs $0x804afc,%rdx
  803a86:	00 00 00 
  803a89:	be 61 00 00 00       	mov    $0x61,%esi
  803a8e:	48 bf 11 4b 80 00 00 	movabs $0x804b11,%rdi
  803a95:	00 00 00 
  803a98:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9d:	49 b8 19 05 80 00 00 	movabs $0x800519,%r8
  803aa4:	00 00 00 
  803aa7:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803aaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aad:	48 63 d0             	movslq %eax,%rdx
  803ab0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ab4:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803abb:	00 00 00 
  803abe:	48 89 c7             	mov    %rax,%rdi
  803ac1:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  803ac8:	00 00 00 
  803acb:	ff d0                	callq  *%rax
	}

	return r;
  803acd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ad0:	c9                   	leaveq 
  803ad1:	c3                   	retq   

0000000000803ad2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ad2:	55                   	push   %rbp
  803ad3:	48 89 e5             	mov    %rsp,%rbp
  803ad6:	48 83 ec 20          	sub    $0x20,%rsp
  803ada:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803add:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ae1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803ae4:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803ae7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803aee:	00 00 00 
  803af1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803af4:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803af6:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803afd:	7e 35                	jle    803b34 <nsipc_send+0x62>
  803aff:	48 b9 1d 4b 80 00 00 	movabs $0x804b1d,%rcx
  803b06:	00 00 00 
  803b09:	48 ba fc 4a 80 00 00 	movabs $0x804afc,%rdx
  803b10:	00 00 00 
  803b13:	be 6c 00 00 00       	mov    $0x6c,%esi
  803b18:	48 bf 11 4b 80 00 00 	movabs $0x804b11,%rdi
  803b1f:	00 00 00 
  803b22:	b8 00 00 00 00       	mov    $0x0,%eax
  803b27:	49 b8 19 05 80 00 00 	movabs $0x800519,%r8
  803b2e:	00 00 00 
  803b31:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803b34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b37:	48 63 d0             	movslq %eax,%rdx
  803b3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3e:	48 89 c6             	mov    %rax,%rsi
  803b41:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803b48:	00 00 00 
  803b4b:	48 b8 85 17 80 00 00 	movabs $0x801785,%rax
  803b52:	00 00 00 
  803b55:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803b57:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b5e:	00 00 00 
  803b61:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b64:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803b67:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b6e:	00 00 00 
  803b71:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b74:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803b77:	bf 08 00 00 00       	mov    $0x8,%edi
  803b7c:	48 b8 91 37 80 00 00 	movabs $0x803791,%rax
  803b83:	00 00 00 
  803b86:	ff d0                	callq  *%rax
}
  803b88:	c9                   	leaveq 
  803b89:	c3                   	retq   

0000000000803b8a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803b8a:	55                   	push   %rbp
  803b8b:	48 89 e5             	mov    %rsp,%rbp
  803b8e:	48 83 ec 10          	sub    $0x10,%rsp
  803b92:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b95:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803b98:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803b9b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ba2:	00 00 00 
  803ba5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ba8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803baa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bb1:	00 00 00 
  803bb4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bb7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803bba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bc1:	00 00 00 
  803bc4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803bc7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803bca:	bf 09 00 00 00       	mov    $0x9,%edi
  803bcf:	48 b8 91 37 80 00 00 	movabs $0x803791,%rax
  803bd6:	00 00 00 
  803bd9:	ff d0                	callq  *%rax
}
  803bdb:	c9                   	leaveq 
  803bdc:	c3                   	retq   

0000000000803bdd <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803bdd:	55                   	push   %rbp
  803bde:	48 89 e5             	mov    %rsp,%rbp
  803be1:	53                   	push   %rbx
  803be2:	48 83 ec 38          	sub    $0x38,%rsp
  803be6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803bea:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803bee:	48 89 c7             	mov    %rax,%rdi
  803bf1:	48 b8 17 21 80 00 00 	movabs $0x802117,%rax
  803bf8:	00 00 00 
  803bfb:	ff d0                	callq  *%rax
  803bfd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c00:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c04:	0f 88 bf 01 00 00    	js     803dc9 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c0e:	ba 07 04 00 00       	mov    $0x407,%edx
  803c13:	48 89 c6             	mov    %rax,%rsi
  803c16:	bf 00 00 00 00       	mov    $0x0,%edi
  803c1b:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  803c22:	00 00 00 
  803c25:	ff d0                	callq  *%rax
  803c27:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c2e:	0f 88 95 01 00 00    	js     803dc9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803c34:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803c38:	48 89 c7             	mov    %rax,%rdi
  803c3b:	48 b8 17 21 80 00 00 	movabs $0x802117,%rax
  803c42:	00 00 00 
  803c45:	ff d0                	callq  *%rax
  803c47:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c4e:	0f 88 5d 01 00 00    	js     803db1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c58:	ba 07 04 00 00       	mov    $0x407,%edx
  803c5d:	48 89 c6             	mov    %rax,%rsi
  803c60:	bf 00 00 00 00       	mov    $0x0,%edi
  803c65:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  803c6c:	00 00 00 
  803c6f:	ff d0                	callq  *%rax
  803c71:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c74:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c78:	0f 88 33 01 00 00    	js     803db1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803c7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c82:	48 89 c7             	mov    %rax,%rdi
  803c85:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  803c8c:	00 00 00 
  803c8f:	ff d0                	callq  *%rax
  803c91:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c99:	ba 07 04 00 00       	mov    $0x407,%edx
  803c9e:	48 89 c6             	mov    %rax,%rsi
  803ca1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca6:	48 b8 90 1d 80 00 00 	movabs $0x801d90,%rax
  803cad:	00 00 00 
  803cb0:	ff d0                	callq  *%rax
  803cb2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cb5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cb9:	79 05                	jns    803cc0 <pipe+0xe3>
		goto err2;
  803cbb:	e9 d9 00 00 00       	jmpq   803d99 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cc0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cc4:	48 89 c7             	mov    %rax,%rdi
  803cc7:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  803cce:	00 00 00 
  803cd1:	ff d0                	callq  *%rax
  803cd3:	48 89 c2             	mov    %rax,%rdx
  803cd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cda:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803ce0:	48 89 d1             	mov    %rdx,%rcx
  803ce3:	ba 00 00 00 00       	mov    $0x0,%edx
  803ce8:	48 89 c6             	mov    %rax,%rsi
  803ceb:	bf 00 00 00 00       	mov    $0x0,%edi
  803cf0:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  803cf7:	00 00 00 
  803cfa:	ff d0                	callq  *%rax
  803cfc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d03:	79 1b                	jns    803d20 <pipe+0x143>
		goto err3;
  803d05:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803d06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d0a:	48 89 c6             	mov    %rax,%rsi
  803d0d:	bf 00 00 00 00       	mov    $0x0,%edi
  803d12:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  803d19:	00 00 00 
  803d1c:	ff d0                	callq  *%rax
  803d1e:	eb 79                	jmp    803d99 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803d20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d24:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803d2b:	00 00 00 
  803d2e:	8b 12                	mov    (%rdx),%edx
  803d30:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803d32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803d3d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d41:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803d48:	00 00 00 
  803d4b:	8b 12                	mov    (%rdx),%edx
  803d4d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803d4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d53:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803d5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d5e:	48 89 c7             	mov    %rax,%rdi
  803d61:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  803d68:	00 00 00 
  803d6b:	ff d0                	callq  *%rax
  803d6d:	89 c2                	mov    %eax,%edx
  803d6f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d73:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803d75:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d79:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803d7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d81:	48 89 c7             	mov    %rax,%rdi
  803d84:	48 b8 c9 20 80 00 00 	movabs $0x8020c9,%rax
  803d8b:	00 00 00 
  803d8e:	ff d0                	callq  *%rax
  803d90:	89 03                	mov    %eax,(%rbx)
	return 0;
  803d92:	b8 00 00 00 00       	mov    $0x0,%eax
  803d97:	eb 33                	jmp    803dcc <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803d99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d9d:	48 89 c6             	mov    %rax,%rsi
  803da0:	bf 00 00 00 00       	mov    $0x0,%edi
  803da5:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  803dac:	00 00 00 
  803daf:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803db1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803db5:	48 89 c6             	mov    %rax,%rsi
  803db8:	bf 00 00 00 00       	mov    $0x0,%edi
  803dbd:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  803dc4:	00 00 00 
  803dc7:	ff d0                	callq  *%rax
err:
	return r;
  803dc9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803dcc:	48 83 c4 38          	add    $0x38,%rsp
  803dd0:	5b                   	pop    %rbx
  803dd1:	5d                   	pop    %rbp
  803dd2:	c3                   	retq   

0000000000803dd3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803dd3:	55                   	push   %rbp
  803dd4:	48 89 e5             	mov    %rsp,%rbp
  803dd7:	53                   	push   %rbx
  803dd8:	48 83 ec 28          	sub    $0x28,%rsp
  803ddc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803de0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803de4:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803deb:	00 00 00 
  803dee:	48 8b 00             	mov    (%rax),%rax
  803df1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803df7:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803dfa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dfe:	48 89 c7             	mov    %rax,%rdi
  803e01:	48 b8 90 43 80 00 00 	movabs $0x804390,%rax
  803e08:	00 00 00 
  803e0b:	ff d0                	callq  *%rax
  803e0d:	89 c3                	mov    %eax,%ebx
  803e0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e13:	48 89 c7             	mov    %rax,%rdi
  803e16:	48 b8 90 43 80 00 00 	movabs $0x804390,%rax
  803e1d:	00 00 00 
  803e20:	ff d0                	callq  *%rax
  803e22:	39 c3                	cmp    %eax,%ebx
  803e24:	0f 94 c0             	sete   %al
  803e27:	0f b6 c0             	movzbl %al,%eax
  803e2a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803e2d:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803e34:	00 00 00 
  803e37:	48 8b 00             	mov    (%rax),%rax
  803e3a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e40:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803e43:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e46:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e49:	75 05                	jne    803e50 <_pipeisclosed+0x7d>
			return ret;
  803e4b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803e4e:	eb 4f                	jmp    803e9f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803e50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e53:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803e56:	74 42                	je     803e9a <_pipeisclosed+0xc7>
  803e58:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803e5c:	75 3c                	jne    803e9a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803e5e:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803e65:	00 00 00 
  803e68:	48 8b 00             	mov    (%rax),%rax
  803e6b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803e71:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e74:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e77:	89 c6                	mov    %eax,%esi
  803e79:	48 bf 2e 4b 80 00 00 	movabs $0x804b2e,%rdi
  803e80:	00 00 00 
  803e83:	b8 00 00 00 00       	mov    $0x0,%eax
  803e88:	49 b8 52 07 80 00 00 	movabs $0x800752,%r8
  803e8f:	00 00 00 
  803e92:	41 ff d0             	callq  *%r8
	}
  803e95:	e9 4a ff ff ff       	jmpq   803de4 <_pipeisclosed+0x11>
  803e9a:	e9 45 ff ff ff       	jmpq   803de4 <_pipeisclosed+0x11>
}
  803e9f:	48 83 c4 28          	add    $0x28,%rsp
  803ea3:	5b                   	pop    %rbx
  803ea4:	5d                   	pop    %rbp
  803ea5:	c3                   	retq   

0000000000803ea6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ea6:	55                   	push   %rbp
  803ea7:	48 89 e5             	mov    %rsp,%rbp
  803eaa:	48 83 ec 30          	sub    $0x30,%rsp
  803eae:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803eb1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803eb5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803eb8:	48 89 d6             	mov    %rdx,%rsi
  803ebb:	89 c7                	mov    %eax,%edi
  803ebd:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  803ec4:	00 00 00 
  803ec7:	ff d0                	callq  *%rax
  803ec9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ecc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ed0:	79 05                	jns    803ed7 <pipeisclosed+0x31>
		return r;
  803ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed5:	eb 31                	jmp    803f08 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803ed7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803edb:	48 89 c7             	mov    %rax,%rdi
  803ede:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  803ee5:	00 00 00 
  803ee8:	ff d0                	callq  *%rax
  803eea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803eee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ef2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ef6:	48 89 d6             	mov    %rdx,%rsi
  803ef9:	48 89 c7             	mov    %rax,%rdi
  803efc:	48 b8 d3 3d 80 00 00 	movabs $0x803dd3,%rax
  803f03:	00 00 00 
  803f06:	ff d0                	callq  *%rax
}
  803f08:	c9                   	leaveq 
  803f09:	c3                   	retq   

0000000000803f0a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f0a:	55                   	push   %rbp
  803f0b:	48 89 e5             	mov    %rsp,%rbp
  803f0e:	48 83 ec 40          	sub    $0x40,%rsp
  803f12:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f16:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f1a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803f1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f22:	48 89 c7             	mov    %rax,%rdi
  803f25:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  803f2c:	00 00 00 
  803f2f:	ff d0                	callq  *%rax
  803f31:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f3d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f44:	00 
  803f45:	e9 92 00 00 00       	jmpq   803fdc <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803f4a:	eb 41                	jmp    803f8d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803f4c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803f51:	74 09                	je     803f5c <devpipe_read+0x52>
				return i;
  803f53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f57:	e9 92 00 00 00       	jmpq   803fee <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803f5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f64:	48 89 d6             	mov    %rdx,%rsi
  803f67:	48 89 c7             	mov    %rax,%rdi
  803f6a:	48 b8 d3 3d 80 00 00 	movabs $0x803dd3,%rax
  803f71:	00 00 00 
  803f74:	ff d0                	callq  *%rax
  803f76:	85 c0                	test   %eax,%eax
  803f78:	74 07                	je     803f81 <devpipe_read+0x77>
				return 0;
  803f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f7f:	eb 6d                	jmp    803fee <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803f81:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  803f88:	00 00 00 
  803f8b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803f8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f91:	8b 10                	mov    (%rax),%edx
  803f93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f97:	8b 40 04             	mov    0x4(%rax),%eax
  803f9a:	39 c2                	cmp    %eax,%edx
  803f9c:	74 ae                	je     803f4c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803fa6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803faa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fae:	8b 00                	mov    (%rax),%eax
  803fb0:	99                   	cltd   
  803fb1:	c1 ea 1b             	shr    $0x1b,%edx
  803fb4:	01 d0                	add    %edx,%eax
  803fb6:	83 e0 1f             	and    $0x1f,%eax
  803fb9:	29 d0                	sub    %edx,%eax
  803fbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fbf:	48 98                	cltq   
  803fc1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803fc6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803fc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fcc:	8b 00                	mov    (%rax),%eax
  803fce:	8d 50 01             	lea    0x1(%rax),%edx
  803fd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd5:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803fd7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803fdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803fe4:	0f 82 60 ff ff ff    	jb     803f4a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803fee:	c9                   	leaveq 
  803fef:	c3                   	retq   

0000000000803ff0 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ff0:	55                   	push   %rbp
  803ff1:	48 89 e5             	mov    %rsp,%rbp
  803ff4:	48 83 ec 40          	sub    $0x40,%rsp
  803ff8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ffc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804000:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804004:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804008:	48 89 c7             	mov    %rax,%rdi
  80400b:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  804012:	00 00 00 
  804015:	ff d0                	callq  *%rax
  804017:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80401b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80401f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804023:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80402a:	00 
  80402b:	e9 8e 00 00 00       	jmpq   8040be <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804030:	eb 31                	jmp    804063 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804032:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804036:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80403a:	48 89 d6             	mov    %rdx,%rsi
  80403d:	48 89 c7             	mov    %rax,%rdi
  804040:	48 b8 d3 3d 80 00 00 	movabs $0x803dd3,%rax
  804047:	00 00 00 
  80404a:	ff d0                	callq  *%rax
  80404c:	85 c0                	test   %eax,%eax
  80404e:	74 07                	je     804057 <devpipe_write+0x67>
				return 0;
  804050:	b8 00 00 00 00       	mov    $0x0,%eax
  804055:	eb 79                	jmp    8040d0 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804057:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  80405e:	00 00 00 
  804061:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804063:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804067:	8b 40 04             	mov    0x4(%rax),%eax
  80406a:	48 63 d0             	movslq %eax,%rdx
  80406d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804071:	8b 00                	mov    (%rax),%eax
  804073:	48 98                	cltq   
  804075:	48 83 c0 20          	add    $0x20,%rax
  804079:	48 39 c2             	cmp    %rax,%rdx
  80407c:	73 b4                	jae    804032 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80407e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804082:	8b 40 04             	mov    0x4(%rax),%eax
  804085:	99                   	cltd   
  804086:	c1 ea 1b             	shr    $0x1b,%edx
  804089:	01 d0                	add    %edx,%eax
  80408b:	83 e0 1f             	and    $0x1f,%eax
  80408e:	29 d0                	sub    %edx,%eax
  804090:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804094:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804098:	48 01 ca             	add    %rcx,%rdx
  80409b:	0f b6 0a             	movzbl (%rdx),%ecx
  80409e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040a2:	48 98                	cltq   
  8040a4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8040a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ac:	8b 40 04             	mov    0x4(%rax),%eax
  8040af:	8d 50 01             	lea    0x1(%rax),%edx
  8040b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8040b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040c2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8040c6:	0f 82 64 ff ff ff    	jb     804030 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8040cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8040d0:	c9                   	leaveq 
  8040d1:	c3                   	retq   

00000000008040d2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8040d2:	55                   	push   %rbp
  8040d3:	48 89 e5             	mov    %rsp,%rbp
  8040d6:	48 83 ec 20          	sub    $0x20,%rsp
  8040da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8040e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040e6:	48 89 c7             	mov    %rax,%rdi
  8040e9:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  8040f0:	00 00 00 
  8040f3:	ff d0                	callq  *%rax
  8040f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8040f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040fd:	48 be 41 4b 80 00 00 	movabs $0x804b41,%rsi
  804104:	00 00 00 
  804107:	48 89 c7             	mov    %rax,%rdi
  80410a:	48 b8 61 14 80 00 00 	movabs $0x801461,%rax
  804111:	00 00 00 
  804114:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80411a:	8b 50 04             	mov    0x4(%rax),%edx
  80411d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804121:	8b 00                	mov    (%rax),%eax
  804123:	29 c2                	sub    %eax,%edx
  804125:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804129:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80412f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804133:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80413a:	00 00 00 
	stat->st_dev = &devpipe;
  80413d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804141:	48 b9 00 61 80 00 00 	movabs $0x806100,%rcx
  804148:	00 00 00 
  80414b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804152:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804157:	c9                   	leaveq 
  804158:	c3                   	retq   

0000000000804159 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804159:	55                   	push   %rbp
  80415a:	48 89 e5             	mov    %rsp,%rbp
  80415d:	48 83 ec 10          	sub    $0x10,%rsp
  804161:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804169:	48 89 c6             	mov    %rax,%rsi
  80416c:	bf 00 00 00 00       	mov    $0x0,%edi
  804171:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  804178:	00 00 00 
  80417b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80417d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804181:	48 89 c7             	mov    %rax,%rdi
  804184:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  80418b:	00 00 00 
  80418e:	ff d0                	callq  *%rax
  804190:	48 89 c6             	mov    %rax,%rsi
  804193:	bf 00 00 00 00       	mov    $0x0,%edi
  804198:	48 b8 3b 1e 80 00 00 	movabs $0x801e3b,%rax
  80419f:	00 00 00 
  8041a2:	ff d0                	callq  *%rax
}
  8041a4:	c9                   	leaveq 
  8041a5:	c3                   	retq   

00000000008041a6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8041a6:	55                   	push   %rbp
  8041a7:	48 89 e5             	mov    %rsp,%rbp
  8041aa:	48 83 ec 30          	sub    $0x30,%rsp
  8041ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8041ba:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8041c1:	00 00 00 
  8041c4:	48 8b 00             	mov    (%rax),%rax
  8041c7:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8041cd:	85 c0                	test   %eax,%eax
  8041cf:	75 3c                	jne    80420d <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8041d1:	48 b8 14 1d 80 00 00 	movabs $0x801d14,%rax
  8041d8:	00 00 00 
  8041db:	ff d0                	callq  *%rax
  8041dd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8041e2:	48 63 d0             	movslq %eax,%rdx
  8041e5:	48 89 d0             	mov    %rdx,%rax
  8041e8:	48 c1 e0 03          	shl    $0x3,%rax
  8041ec:	48 01 d0             	add    %rdx,%rax
  8041ef:	48 c1 e0 05          	shl    $0x5,%rax
  8041f3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8041fa:	00 00 00 
  8041fd:	48 01 c2             	add    %rax,%rdx
  804200:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804207:	00 00 00 
  80420a:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80420d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804212:	75 0e                	jne    804222 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804214:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80421b:	00 00 00 
  80421e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804222:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804226:	48 89 c7             	mov    %rax,%rdi
  804229:	48 b8 b9 1f 80 00 00 	movabs $0x801fb9,%rax
  804230:	00 00 00 
  804233:	ff d0                	callq  *%rax
  804235:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804238:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80423c:	79 19                	jns    804257 <ipc_recv+0xb1>
		*from_env_store = 0;
  80423e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804242:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  804248:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80424c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  804252:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804255:	eb 53                	jmp    8042aa <ipc_recv+0x104>
	}
	if(from_env_store)
  804257:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80425c:	74 19                	je     804277 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80425e:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804265:	00 00 00 
  804268:	48 8b 00             	mov    (%rax),%rax
  80426b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804271:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804275:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  804277:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80427c:	74 19                	je     804297 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80427e:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  804285:	00 00 00 
  804288:	48 8b 00             	mov    (%rax),%rax
  80428b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804291:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804295:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  804297:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80429e:	00 00 00 
  8042a1:	48 8b 00             	mov    (%rax),%rax
  8042a4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8042aa:	c9                   	leaveq 
  8042ab:	c3                   	retq   

00000000008042ac <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8042ac:	55                   	push   %rbp
  8042ad:	48 89 e5             	mov    %rsp,%rbp
  8042b0:	48 83 ec 30          	sub    $0x30,%rsp
  8042b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8042b7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8042ba:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8042be:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8042c1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8042c6:	75 0e                	jne    8042d6 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8042c8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8042cf:	00 00 00 
  8042d2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8042d6:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8042d9:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8042dc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8042e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042e3:	89 c7                	mov    %eax,%edi
  8042e5:	48 b8 64 1f 80 00 00 	movabs $0x801f64,%rax
  8042ec:	00 00 00 
  8042ef:	ff d0                	callq  *%rax
  8042f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8042f4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8042f8:	75 0c                	jne    804306 <ipc_send+0x5a>
			sys_yield();
  8042fa:	48 b8 52 1d 80 00 00 	movabs $0x801d52,%rax
  804301:	00 00 00 
  804304:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804306:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80430a:	74 ca                	je     8042d6 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80430c:	c9                   	leaveq 
  80430d:	c3                   	retq   

000000000080430e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80430e:	55                   	push   %rbp
  80430f:	48 89 e5             	mov    %rsp,%rbp
  804312:	48 83 ec 14          	sub    $0x14,%rsp
  804316:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804319:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804320:	eb 5e                	jmp    804380 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804322:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804329:	00 00 00 
  80432c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80432f:	48 63 d0             	movslq %eax,%rdx
  804332:	48 89 d0             	mov    %rdx,%rax
  804335:	48 c1 e0 03          	shl    $0x3,%rax
  804339:	48 01 d0             	add    %rdx,%rax
  80433c:	48 c1 e0 05          	shl    $0x5,%rax
  804340:	48 01 c8             	add    %rcx,%rax
  804343:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804349:	8b 00                	mov    (%rax),%eax
  80434b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80434e:	75 2c                	jne    80437c <ipc_find_env+0x6e>
			return envs[i].env_id;
  804350:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804357:	00 00 00 
  80435a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80435d:	48 63 d0             	movslq %eax,%rdx
  804360:	48 89 d0             	mov    %rdx,%rax
  804363:	48 c1 e0 03          	shl    $0x3,%rax
  804367:	48 01 d0             	add    %rdx,%rax
  80436a:	48 c1 e0 05          	shl    $0x5,%rax
  80436e:	48 01 c8             	add    %rcx,%rax
  804371:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804377:	8b 40 08             	mov    0x8(%rax),%eax
  80437a:	eb 12                	jmp    80438e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80437c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804380:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804387:	7e 99                	jle    804322 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804389:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80438e:	c9                   	leaveq 
  80438f:	c3                   	retq   

0000000000804390 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804390:	55                   	push   %rbp
  804391:	48 89 e5             	mov    %rsp,%rbp
  804394:	48 83 ec 18          	sub    $0x18,%rsp
  804398:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80439c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043a0:	48 c1 e8 15          	shr    $0x15,%rax
  8043a4:	48 89 c2             	mov    %rax,%rdx
  8043a7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8043ae:	01 00 00 
  8043b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043b5:	83 e0 01             	and    $0x1,%eax
  8043b8:	48 85 c0             	test   %rax,%rax
  8043bb:	75 07                	jne    8043c4 <pageref+0x34>
		return 0;
  8043bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8043c2:	eb 53                	jmp    804417 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8043c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043c8:	48 c1 e8 0c          	shr    $0xc,%rax
  8043cc:	48 89 c2             	mov    %rax,%rdx
  8043cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8043d6:	01 00 00 
  8043d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8043e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e5:	83 e0 01             	and    $0x1,%eax
  8043e8:	48 85 c0             	test   %rax,%rax
  8043eb:	75 07                	jne    8043f4 <pageref+0x64>
		return 0;
  8043ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f2:	eb 23                	jmp    804417 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8043f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043f8:	48 c1 e8 0c          	shr    $0xc,%rax
  8043fc:	48 89 c2             	mov    %rax,%rdx
  8043ff:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804406:	00 00 00 
  804409:	48 c1 e2 04          	shl    $0x4,%rdx
  80440d:	48 01 d0             	add    %rdx,%rax
  804410:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804414:	0f b7 c0             	movzwl %ax,%eax
}
  804417:	c9                   	leaveq 
  804418:	c3                   	retq   
