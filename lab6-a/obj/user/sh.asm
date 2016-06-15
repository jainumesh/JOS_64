
obj/user/sh.debug:     file format elf64-x86-64


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
  80003c:	e8 35 11 00 00       	callq  801176 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 60 05 00 00 	sub    $0x560,%rsp
  80004e:	48 89 bd a8 fa ff ff 	mov    %rdi,-0x558(%rbp)
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	gettoken(s, 0);
  80005c:	48 8b 85 a8 fa ff ff 	mov    -0x558(%rbp),%rax
  800063:	be 00 00 00 00       	mov    $0x0,%esi
  800068:	48 89 c7             	mov    %rax,%rdi
  80006b:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800072:	00 00 00 
  800075:	ff d0                	callq  *%rax

again:
	argc = 0;
  800077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80007e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800085:	48 89 c6             	mov    %rax,%rsi
  800088:	bf 00 00 00 00       	mov    $0x0,%edi
  80008d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
  800099:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80009c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80009f:	83 f8 3e             	cmp    $0x3e,%eax
  8000a2:	0f 84 4c 01 00 00    	je     8001f4 <runcmd+0x1b1>
  8000a8:	83 f8 3e             	cmp    $0x3e,%eax
  8000ab:	7f 12                	jg     8000bf <runcmd+0x7c>
  8000ad:	85 c0                	test   %eax,%eax
  8000af:	0f 84 b9 03 00 00    	je     80046e <runcmd+0x42b>
  8000b5:	83 f8 3c             	cmp    $0x3c,%eax
  8000b8:	74 64                	je     80011e <runcmd+0xdb>
  8000ba:	e9 7a 03 00 00       	jmpq   800439 <runcmd+0x3f6>
  8000bf:	83 f8 77             	cmp    $0x77,%eax
  8000c2:	74 0e                	je     8000d2 <runcmd+0x8f>
  8000c4:	83 f8 7c             	cmp    $0x7c,%eax
  8000c7:	0f 84 fd 01 00 00    	je     8002ca <runcmd+0x287>
  8000cd:	e9 67 03 00 00       	jmpq   800439 <runcmd+0x3f6>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8000d2:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
  8000d6:	75 27                	jne    8000ff <runcmd+0xbc>
				cprintf("too many arguments\n");
  8000d8:	48 bf e8 67 80 00 00 	movabs $0x8067e8,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  8000ee:	00 00 00 
  8000f1:	ff d2                	callq  *%rdx
				exit();
  8000f3:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	callq  *%rax
			}
			argv[argc++] = t;
  8000ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800102:	8d 50 01             	lea    0x1(%rax),%edx
  800105:	89 55 fc             	mov    %edx,-0x4(%rbp)
  800108:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80010f:	48 98                	cltq   
  800111:	48 89 94 c5 60 ff ff 	mov    %rdx,-0xa0(%rbp,%rax,8)
  800118:	ff 
			break;
  800119:	e9 4b 03 00 00       	jmpq   800469 <runcmd+0x426>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80011e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800125:	48 89 c6             	mov    %rax,%rsi
  800128:	bf 00 00 00 00       	mov    $0x0,%edi
  80012d:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	83 f8 77             	cmp    $0x77,%eax
  80013c:	74 27                	je     800165 <runcmd+0x122>
				cprintf("syntax error: < not followed by word\n");
  80013e:	48 bf 00 68 80 00 00 	movabs $0x806800,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  800165:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	48 89 c7             	mov    %rax,%rdi
  800174:	48 b8 41 41 80 00 00 	movabs $0x804141,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800187:	79 34                	jns    8001bd <runcmd+0x17a>
				cprintf("open %s for read: %e", t, fd);
  800189:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800190:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 bf 26 68 80 00 00 	movabs $0x806826,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx
				exit();
  8001b1:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  8001b8:	00 00 00 
  8001bb:	ff d0                	callq  *%rax
			}
			if (fd != 0) {
  8001bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001c1:	74 2c                	je     8001ef <runcmd+0x1ac>
				dup(fd, 0);
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	be 00 00 00 00       	mov    $0x0,%esi
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 c2 3a 80 00 00 	movabs $0x803ac2,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
				close(fd);
  8001d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
			}
			break;
  8001ea:	e9 7a 02 00 00       	jmpq   800469 <runcmd+0x426>
  8001ef:	e9 75 02 00 00       	jmpq   800469 <runcmd+0x426>

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8001f4:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  8001fb:	48 89 c6             	mov    %rax,%rsi
  8001fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800203:	48 b8 5b 0a 80 00 00 	movabs $0x800a5b,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	callq  *%rax
  80020f:	83 f8 77             	cmp    $0x77,%eax
  800212:	74 27                	je     80023b <runcmd+0x1f8>
				cprintf("syntax error: > not followed by word\n");
  800214:	48 bf 40 68 80 00 00 	movabs $0x806840,%rdi
  80021b:	00 00 00 
  80021e:	b8 00 00 00 00       	mov    $0x0,%eax
  800223:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  80022a:	00 00 00 
  80022d:	ff d2                	callq  *%rdx
				exit();
  80022f:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80023b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800242:	be 01 03 00 00       	mov    $0x301,%esi
  800247:	48 89 c7             	mov    %rax,%rdi
  80024a:	48 b8 41 41 80 00 00 	movabs $0x804141,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
  800256:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025d:	79 34                	jns    800293 <runcmd+0x250>
				cprintf("open %s for write: %e", t, fd);
  80025f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800266:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800269:	48 89 c6             	mov    %rax,%rsi
  80026c:	48 bf 66 68 80 00 00 	movabs $0x806866,%rdi
  800273:	00 00 00 
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  800282:	00 00 00 
  800285:	ff d1                	callq  *%rcx
				exit();
  800287:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
			}
			if (fd != 1) {
  800293:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  800297:	74 2c                	je     8002c5 <runcmd+0x282>
				dup(fd, 1);
  800299:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80029c:	be 01 00 00 00       	mov    $0x1,%esi
  8002a1:	89 c7                	mov    %eax,%edi
  8002a3:	48 b8 c2 3a 80 00 00 	movabs $0x803ac2,%rax
  8002aa:	00 00 00 
  8002ad:	ff d0                	callq  *%rax
				close(fd);
  8002af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b2:	89 c7                	mov    %eax,%edi
  8002b4:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
			}
			break;
  8002c0:	e9 a4 01 00 00       	jmpq   800469 <runcmd+0x426>
  8002c5:	e9 9f 01 00 00       	jmpq   800469 <runcmd+0x426>

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8002ca:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002d1:	48 89 c7             	mov    %rax,%rdi
  8002d4:	48 b8 bb 5d 80 00 00 	movabs $0x805dbb,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
  8002e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e7:	79 2c                	jns    800315 <runcmd+0x2d2>
				cprintf("pipe: %e", r);
  8002e9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002ec:	89 c6                	mov    %eax,%esi
  8002ee:	48 bf 7c 68 80 00 00 	movabs $0x80687c,%rdi
  8002f5:	00 00 00 
  8002f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fd:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800304:	00 00 00 
  800307:	ff d2                	callq  *%rdx
				exit();
  800309:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
			}
			if (debug)
  800315:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80031c:	00 00 00 
  80031f:	8b 00                	mov    (%rax),%eax
  800321:	85 c0                	test   %eax,%eax
  800323:	74 29                	je     80034e <runcmd+0x30b>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800325:	8b 95 44 fb ff ff    	mov    -0x4bc(%rbp),%edx
  80032b:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800331:	89 c6                	mov    %eax,%esi
  800333:	48 bf 85 68 80 00 00 	movabs $0x806885,%rdi
  80033a:	00 00 00 
  80033d:	b8 00 00 00 00       	mov    $0x0,%eax
  800342:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  800349:	00 00 00 
  80034c:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034e:	48 b8 bd 31 80 00 00 	movabs $0x8031bd,%rax
  800355:	00 00 00 
  800358:	ff d0                	callq  *%rax
  80035a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800361:	79 2c                	jns    80038f <runcmd+0x34c>
				cprintf("fork: %e", r);
  800363:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf 92 68 80 00 00 	movabs $0x806892,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  80037e:	00 00 00 
  800381:	ff d2                	callq  *%rdx
				exit();
  800383:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  80038a:	00 00 00 
  80038d:	ff d0                	callq  *%rax
			}
			if (r == 0) {
  80038f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800393:	75 50                	jne    8003e5 <runcmd+0x3a2>
				if (p[0] != 0) {
  800395:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  80039b:	85 c0                	test   %eax,%eax
  80039d:	74 2d                	je     8003cc <runcmd+0x389>
					dup(p[0], 0);
  80039f:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003a5:	be 00 00 00 00       	mov    $0x0,%esi
  8003aa:	89 c7                	mov    %eax,%edi
  8003ac:	48 b8 c2 3a 80 00 00 	movabs $0x803ac2,%rax
  8003b3:	00 00 00 
  8003b6:	ff d0                	callq  *%rax
					close(p[0]);
  8003b8:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003be:	89 c7                	mov    %eax,%edi
  8003c0:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  8003c7:	00 00 00 
  8003ca:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003cc:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003d2:	89 c7                	mov    %eax,%edi
  8003d4:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  8003db:	00 00 00 
  8003de:	ff d0                	callq  *%rax
				goto again;
  8003e0:	e9 92 fc ff ff       	jmpq   800077 <runcmd+0x34>
			} else {
				pipe_child = r;
  8003e5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%rbp)
				if (p[1] != 1) {
  8003eb:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003f1:	83 f8 01             	cmp    $0x1,%eax
  8003f4:	74 2d                	je     800423 <runcmd+0x3e0>
					dup(p[1], 1);
  8003f6:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003fc:	be 01 00 00 00       	mov    $0x1,%esi
  800401:	89 c7                	mov    %eax,%edi
  800403:	48 b8 c2 3a 80 00 00 	movabs $0x803ac2,%rax
  80040a:	00 00 00 
  80040d:	ff d0                	callq  *%rax
					close(p[1]);
  80040f:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800415:	89 c7                	mov    %eax,%edi
  800417:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  80041e:	00 00 00 
  800421:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800423:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800429:	89 c7                	mov    %eax,%edi
  80042b:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  800432:	00 00 00 
  800435:	ff d0                	callq  *%rax
				goto runit;
  800437:	eb 36                	jmp    80046f <runcmd+0x42c>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800439:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80043c:	89 c1                	mov    %eax,%ecx
  80043e:	48 ba 9b 68 80 00 00 	movabs $0x80689b,%rdx
  800445:	00 00 00 
  800448:	be 6f 00 00 00       	mov    $0x6f,%esi
  80044d:	48 bf b7 68 80 00 00 	movabs $0x8068b7,%rdi
  800454:	00 00 00 
  800457:	b8 00 00 00 00       	mov    $0x0,%eax
  80045c:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  800463:	00 00 00 
  800466:	41 ff d0             	callq  *%r8
			break;

		}
	}
  800469:	e9 10 fc ff ff       	jmpq   80007e <runcmd+0x3b>
			panic("| not implemented");
			break;

		case 0:		// String is complete
			// Run the current command!
			goto runit;
  80046e:	90                   	nop
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  80046f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800473:	75 34                	jne    8004a9 <runcmd+0x466>
		if (debug)
  800475:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80047c:	00 00 00 
  80047f:	8b 00                	mov    (%rax),%eax
  800481:	85 c0                	test   %eax,%eax
  800483:	0f 84 79 03 00 00    	je     800802 <runcmd+0x7bf>
			cprintf("EMPTY COMMAND\n");
  800489:	48 bf c1 68 80 00 00 	movabs $0x8068c1,%rdi
  800490:	00 00 00 
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  80049f:	00 00 00 
  8004a2:	ff d2                	callq  *%rdx
		return;
  8004a4:	e9 59 03 00 00       	jmpq   800802 <runcmd+0x7bf>
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  8004a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004b0:	e9 8a 00 00 00       	jmpq   80053f <runcmd+0x4fc>
		strcpy(argv0buf, PATH[i]);
  8004b5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8004bc:	00 00 00 
  8004bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8004c2:	48 63 d2             	movslq %edx,%rdx
  8004c5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004c9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004d0:	48 89 d6             	mov    %rdx,%rsi
  8004d3:	48 89 c7             	mov    %rax,%rdi
  8004d6:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8004dd:	00 00 00 
  8004e0:	ff d0                	callq  *%rax
		strcat(argv0buf, argv[0]);
  8004e2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004e9:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f0:	48 89 d6             	mov    %rdx,%rsi
  8004f3:	48 89 c7             	mov    %rax,%rdi
  8004f6:	48 b8 af 21 80 00 00 	movabs $0x8021af,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
		r = stat(argv0buf, &st);
  800502:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  800509:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800510:	48 89 d6             	mov    %rdx,%rsi
  800513:	48 89 c7             	mov    %rax,%rdi
  800516:	48 b8 53 40 80 00 00 	movabs $0x804053,%rax
  80051d:	00 00 00 
  800520:	ff d0                	callq  *%rax
  800522:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r==0) {
  800525:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800529:	75 10                	jne    80053b <runcmd+0x4f8>
			argv[0] = argv0buf;
  80052b:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800532:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
			break; 
  800539:	eb 19                	jmp    800554 <runcmd+0x511>
		return;
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  80053b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80053f:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  800546:	00 00 00 
  800549:	8b 00                	mov    (%rax),%eax
  80054b:	39 45 f8             	cmp    %eax,-0x8(%rbp)
  80054e:	0f 8c 61 ff ff ff    	jl     8004b5 <runcmd+0x472>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800554:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80055b:	0f b6 00             	movzbl (%rax),%eax
  80055e:	3c 2f                	cmp    $0x2f,%al
  800560:	74 39                	je     80059b <runcmd+0x558>
		argv0buf[0] = '/';
  800562:	c6 85 50 fb ff ff 2f 	movb   $0x2f,-0x4b0(%rbp)
		strcpy(argv0buf + 1, argv[0]);
  800569:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800570:	48 8d 95 50 fb ff ff 	lea    -0x4b0(%rbp),%rdx
  800577:	48 83 c2 01          	add    $0x1,%rdx
  80057b:	48 89 c6             	mov    %rax,%rsi
  80057e:	48 89 d7             	mov    %rdx,%rdi
  800581:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  800588:	00 00 00 
  80058b:	ff d0                	callq  *%rax
		argv[0] = argv0buf;
  80058d:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800594:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
	}
	argv[argc] = 0;
  80059b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80059e:	48 98                	cltq   
  8005a0:	48 c7 84 c5 60 ff ff 	movq   $0x0,-0xa0(%rbp,%rax,8)
  8005a7:	ff 00 00 00 00 

	// Print the command.
	if (debug) {
  8005ac:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8005b3:	00 00 00 
  8005b6:	8b 00                	mov    (%rax),%eax
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	0f 84 95 00 00 00    	je     800655 <runcmd+0x612>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8005c0:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8005c7:	00 00 00 
  8005ca:	48 8b 00             	mov    (%rax),%rax
  8005cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8005d3:	89 c6                	mov    %eax,%esi
  8005d5:	48 bf d0 68 80 00 00 	movabs $0x8068d0,%rdi
  8005dc:	00 00 00 
  8005df:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e4:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  8005eb:	00 00 00 
  8005ee:	ff d2                	callq  *%rdx
		for (i = 0; argv[i]; i++)
  8005f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8005f7:	eb 2f                	jmp    800628 <runcmd+0x5e5>
			cprintf(" %s", argv[i]);
  8005f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8005fc:	48 98                	cltq   
  8005fe:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800605:	ff 
  800606:	48 89 c6             	mov    %rax,%rsi
  800609:	48 bf de 68 80 00 00 	movabs $0x8068de,%rdi
  800610:	00 00 00 
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  80061f:	00 00 00 
  800622:	ff d2                	callq  *%rdx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800624:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800628:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80062b:	48 98                	cltq   
  80062d:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800634:	ff 
  800635:	48 85 c0             	test   %rax,%rax
  800638:	75 bf                	jne    8005f9 <runcmd+0x5b6>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80063a:	48 bf e2 68 80 00 00 	movabs $0x8068e2,%rdi
  800641:	00 00 00 
  800644:	b8 00 00 00 00       	mov    $0x0,%eax
  800649:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800650:	00 00 00 
  800653:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800655:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80065c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800663:	48 89 d6             	mov    %rdx,%rsi
  800666:	48 89 c7             	mov    %rax,%rdi
  800669:	48 b8 5b 4a 80 00 00 	movabs $0x804a5b,%rax
  800670:	00 00 00 
  800673:	ff d0                	callq  *%rax
  800675:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800678:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80067c:	79 28                	jns    8006a6 <runcmd+0x663>
		cprintf("spawn %s: %e\n", argv[0], r);
  80067e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800685:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800688:	48 89 c6             	mov    %rax,%rsi
  80068b:	48 bf e4 68 80 00 00 	movabs $0x8068e4,%rdi
  800692:	00 00 00 
  800695:	b8 00 00 00 00       	mov    $0x0,%eax
  80069a:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  8006a1:	00 00 00 
  8006a4:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006a6:	48 b8 94 3a 80 00 00 	movabs $0x803a94,%rax
  8006ad:	00 00 00 
  8006b0:	ff d0                	callq  *%rax
	if (r >= 0) {
  8006b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8006b6:	0f 88 9c 00 00 00    	js     800758 <runcmd+0x715>
		if (debug)
  8006bc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8006c3:	00 00 00 
  8006c6:	8b 00                	mov    (%rax),%eax
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	74 3b                	je     800707 <runcmd+0x6c4>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8006cc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8006d3:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8006da:	00 00 00 
  8006dd:	48 8b 00             	mov    (%rax),%rax
  8006e0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8006e6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8006e9:	89 c6                	mov    %eax,%esi
  8006eb:	48 bf f2 68 80 00 00 	movabs $0x8068f2,%rdi
  8006f2:	00 00 00 
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006fa:	49 b8 5d 14 80 00 00 	movabs $0x80145d,%r8
  800701:	00 00 00 
  800704:	41 ff d0             	callq  *%r8
		wait(r);
  800707:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070a:	89 c7                	mov    %eax,%edi
  80070c:	48 b8 84 63 80 00 00 	movabs $0x806384,%rax
  800713:	00 00 00 
  800716:	ff d0                	callq  *%rax
		if (debug)
  800718:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80071f:	00 00 00 
  800722:	8b 00                	mov    (%rax),%eax
  800724:	85 c0                	test   %eax,%eax
  800726:	74 30                	je     800758 <runcmd+0x715>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800728:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80072f:	00 00 00 
  800732:	48 8b 00             	mov    (%rax),%rax
  800735:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80073b:	89 c6                	mov    %eax,%esi
  80073d:	48 bf 07 69 80 00 00 	movabs $0x806907,%rdi
  800744:	00 00 00 
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800753:	00 00 00 
  800756:	ff d2                	callq  *%rdx
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  800758:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80075c:	0f 84 94 00 00 00    	je     8007f6 <runcmd+0x7b3>
		if (debug)
  800762:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800769:	00 00 00 
  80076c:	8b 00                	mov    (%rax),%eax
  80076e:	85 c0                	test   %eax,%eax
  800770:	74 33                	je     8007a5 <runcmd+0x762>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800772:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  800779:	00 00 00 
  80077c:	48 8b 00             	mov    (%rax),%rax
  80077f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800785:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800788:	89 c6                	mov    %eax,%esi
  80078a:	48 bf 1d 69 80 00 00 	movabs $0x80691d,%rdi
  800791:	00 00 00 
  800794:	b8 00 00 00 00       	mov    $0x0,%eax
  800799:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  8007a0:	00 00 00 
  8007a3:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007a8:	89 c7                	mov    %eax,%edi
  8007aa:	48 b8 84 63 80 00 00 	movabs $0x806384,%rax
  8007b1:	00 00 00 
  8007b4:	ff d0                	callq  *%rax
		if (debug)
  8007b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8007bd:	00 00 00 
  8007c0:	8b 00                	mov    (%rax),%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	74 30                	je     8007f6 <runcmd+0x7b3>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8007c6:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8007cd:	00 00 00 
  8007d0:	48 8b 00             	mov    (%rax),%rax
  8007d3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8007d9:	89 c6                	mov    %eax,%esi
  8007db:	48 bf 07 69 80 00 00 	movabs $0x806907,%rdi
  8007e2:	00 00 00 
  8007e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ea:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  8007f1:	00 00 00 
  8007f4:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007f6:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  8007fd:	00 00 00 
  800800:	ff d0                	callq  *%rax
}
  800802:	c9                   	leaveq 
  800803:	c3                   	retq   

0000000000800804 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800804:	55                   	push   %rbp
  800805:	48 89 e5             	mov    %rsp,%rbp
  800808:	48 83 ec 30          	sub    $0x30,%rsp
  80080c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800810:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800814:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int t;

	if (s == 0) {
  800818:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80081d:	75 36                	jne    800855 <_gettoken+0x51>
		if (debug > 1)
  80081f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800826:	00 00 00 
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	83 f8 01             	cmp    $0x1,%eax
  80082e:	7e 1b                	jle    80084b <_gettoken+0x47>
			cprintf("GETTOKEN NULL\n");
  800830:	48 bf 3a 69 80 00 00 	movabs $0x80693a,%rdi
  800837:	00 00 00 
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800846:	00 00 00 
  800849:	ff d2                	callq  *%rdx
		return 0;
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	e9 04 02 00 00       	jmpq   800a59 <_gettoken+0x255>
	}

	if (debug > 1)
  800855:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80085c:	00 00 00 
  80085f:	8b 00                	mov    (%rax),%eax
  800861:	83 f8 01             	cmp    $0x1,%eax
  800864:	7e 22                	jle    800888 <_gettoken+0x84>
		cprintf("GETTOKEN: %s\n", s);
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	48 89 c6             	mov    %rax,%rsi
  80086d:	48 bf 49 69 80 00 00 	movabs $0x806949,%rdi
  800874:	00 00 00 
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800883:	00 00 00 
  800886:	ff d2                	callq  *%rdx

	*p1 = 0;
  800888:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80088c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*p2 = 0;
  800893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800897:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	while (strchr(WHITESPACE, *s))
  80089e:	eb 0f                	jmp    8008af <_gettoken+0xab>
		*s++ = 0;
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008a8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008ac:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8008af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b3:	0f b6 00             	movzbl (%rax),%eax
  8008b6:	0f be c0             	movsbl %al,%eax
  8008b9:	89 c6                	mov    %eax,%esi
  8008bb:	48 bf 57 69 80 00 00 	movabs $0x806957,%rdi
  8008c2:	00 00 00 
  8008c5:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
  8008d1:	48 85 c0             	test   %rax,%rax
  8008d4:	75 ca                	jne    8008a0 <_gettoken+0x9c>
		*s++ = 0;
	if (*s == 0) {
  8008d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008da:	0f b6 00             	movzbl (%rax),%eax
  8008dd:	84 c0                	test   %al,%al
  8008df:	75 36                	jne    800917 <_gettoken+0x113>
		if (debug > 1)
  8008e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8008e8:	00 00 00 
  8008eb:	8b 00                	mov    (%rax),%eax
  8008ed:	83 f8 01             	cmp    $0x1,%eax
  8008f0:	7e 1b                	jle    80090d <_gettoken+0x109>
			cprintf("EOL\n");
  8008f2:	48 bf 5c 69 80 00 00 	movabs $0x80695c,%rdi
  8008f9:	00 00 00 
  8008fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800901:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800908:	00 00 00 
  80090b:	ff d2                	callq  *%rdx
		return 0;
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	e9 42 01 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	if (strchr(SYMBOLS, *s)) {
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	0f be c0             	movsbl %al,%eax
  800921:	89 c6                	mov    %eax,%esi
  800923:	48 bf 61 69 80 00 00 	movabs $0x806961,%rdi
  80092a:	00 00 00 
  80092d:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  800934:	00 00 00 
  800937:	ff d0                	callq  *%rax
  800939:	48 85 c0             	test   %rax,%rax
  80093c:	74 6b                	je     8009a9 <_gettoken+0x1a5>
		t = *s;
  80093e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800942:	0f b6 00             	movzbl (%rax),%eax
  800945:	0f be c0             	movsbl %al,%eax
  800948:	89 45 fc             	mov    %eax,-0x4(%rbp)
		*p1 = s;
  80094b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80094f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800953:	48 89 10             	mov    %rdx,(%rax)
		*s++ = 0;
  800956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80095e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800962:	c6 00 00             	movb   $0x0,(%rax)
		*p2 = s;
  800965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800969:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096d:	48 89 10             	mov    %rdx,(%rax)
		if (debug > 1)
  800970:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800977:	00 00 00 
  80097a:	8b 00                	mov    (%rax),%eax
  80097c:	83 f8 01             	cmp    $0x1,%eax
  80097f:	7e 20                	jle    8009a1 <_gettoken+0x19d>
			cprintf("TOK %c\n", t);
  800981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800984:	89 c6                	mov    %eax,%esi
  800986:	48 bf 69 69 80 00 00 	movabs $0x806969,%rdi
  80098d:	00 00 00 
  800990:	b8 00 00 00 00       	mov    $0x0,%eax
  800995:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  80099c:	00 00 00 
  80099f:	ff d2                	callq  *%rdx
		return t;
  8009a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009a4:	e9 b0 00 00 00       	jmpq   800a59 <_gettoken+0x255>
	}
	*p1 = s;
  8009a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b1:	48 89 10             	mov    %rdx,(%rax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009b4:	eb 05                	jmp    8009bb <_gettoken+0x1b7>
		s++;
  8009b6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	0f b6 00             	movzbl (%rax),%eax
  8009c2:	84 c0                	test   %al,%al
  8009c4:	74 27                	je     8009ed <_gettoken+0x1e9>
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	0f b6 00             	movzbl (%rax),%eax
  8009cd:	0f be c0             	movsbl %al,%eax
  8009d0:	89 c6                	mov    %eax,%esi
  8009d2:	48 bf 71 69 80 00 00 	movabs $0x806971,%rdi
  8009d9:	00 00 00 
  8009dc:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  8009e3:	00 00 00 
  8009e6:	ff d0                	callq  *%rax
  8009e8:	48 85 c0             	test   %rax,%rax
  8009eb:	74 c9                	je     8009b6 <_gettoken+0x1b2>
		s++;
	*p2 = s;
  8009ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	48 89 10             	mov    %rdx,(%rax)
	if (debug > 1) {
  8009f8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8009ff:	00 00 00 
  800a02:	8b 00                	mov    (%rax),%eax
  800a04:	83 f8 01             	cmp    $0x1,%eax
  800a07:	7e 4b                	jle    800a54 <_gettoken+0x250>
		t = **p2;
  800a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a0d:	48 8b 00             	mov    (%rax),%rax
  800a10:	0f b6 00             	movzbl (%rax),%eax
  800a13:	0f be c0             	movsbl %al,%eax
  800a16:	89 45 fc             	mov    %eax,-0x4(%rbp)
		**p2 = 0;
  800a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1d:	48 8b 00             	mov    (%rax),%rax
  800a20:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("WORD: %s\n", *p1);
  800a23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a27:	48 8b 00             	mov    (%rax),%rax
  800a2a:	48 89 c6             	mov    %rax,%rsi
  800a2d:	48 bf 7d 69 80 00 00 	movabs $0x80697d,%rdi
  800a34:	00 00 00 
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800a43:	00 00 00 
  800a46:	ff d2                	callq  *%rdx
		**p2 = t;
  800a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a4c:	48 8b 00             	mov    (%rax),%rax
  800a4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a52:	88 10                	mov    %dl,(%rax)
	}
	return 'w';
  800a54:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800a59:	c9                   	leaveq 
  800a5a:	c3                   	retq   

0000000000800a5b <gettoken>:

int
gettoken(char *s, char **p1)
{
  800a5b:	55                   	push   %rbp
  800a5c:	48 89 e5             	mov    %rsp,%rbp
  800a5f:	48 83 ec 10          	sub    $0x10,%rsp
  800a63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800a6b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800a70:	74 3a                	je     800aac <gettoken+0x51>
		nc = _gettoken(s, &np1, &np2);
  800a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a76:	48 ba 10 a0 80 00 00 	movabs $0x80a010,%rdx
  800a7d:	00 00 00 
  800a80:	48 be 08 a0 80 00 00 	movabs $0x80a008,%rsi
  800a87:	00 00 00 
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
  800a99:	48 ba 18 a0 80 00 00 	movabs $0x80a018,%rdx
  800aa0:	00 00 00 
  800aa3:	89 02                	mov    %eax,(%rdx)
		return 0;
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaa:	eb 74                	jmp    800b20 <gettoken+0xc5>
	}
	c = nc;
  800aac:	48 b8 18 a0 80 00 00 	movabs $0x80a018,%rax
  800ab3:	00 00 00 
  800ab6:	8b 10                	mov    (%rax),%edx
  800ab8:	48 b8 1c a0 80 00 00 	movabs $0x80a01c,%rax
  800abf:	00 00 00 
  800ac2:	89 10                	mov    %edx,(%rax)
	*p1 = np1;
  800ac4:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  800acb:	00 00 00 
  800ace:	48 8b 10             	mov    (%rax),%rdx
  800ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ad5:	48 89 10             	mov    %rdx,(%rax)
	nc = _gettoken(np2, &np1, &np2);
  800ad8:	48 b8 10 a0 80 00 00 	movabs $0x80a010,%rax
  800adf:	00 00 00 
  800ae2:	48 8b 00             	mov    (%rax),%rax
  800ae5:	48 ba 10 a0 80 00 00 	movabs $0x80a010,%rdx
  800aec:	00 00 00 
  800aef:	48 be 08 a0 80 00 00 	movabs $0x80a008,%rsi
  800af6:	00 00 00 
  800af9:	48 89 c7             	mov    %rax,%rdi
  800afc:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800b03:	00 00 00 
  800b06:	ff d0                	callq  *%rax
  800b08:	48 ba 18 a0 80 00 00 	movabs $0x80a018,%rdx
  800b0f:	00 00 00 
  800b12:	89 02                	mov    %eax,(%rdx)
	return c;
  800b14:	48 b8 1c a0 80 00 00 	movabs $0x80a01c,%rax
  800b1b:	00 00 00 
  800b1e:	8b 00                	mov    (%rax),%eax
}
  800b20:	c9                   	leaveq 
  800b21:	c3                   	retq   

0000000000800b22 <usage>:


void
usage(void)
{
  800b22:	55                   	push   %rbp
  800b23:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: sh [-dix] [command-file]\n");
  800b26:	48 bf 88 69 80 00 00 	movabs $0x806988,%rdi
  800b2d:	00 00 00 
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800b3c:	00 00 00 
  800b3f:	ff d2                	callq  *%rdx
	exit();
  800b41:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800b48:	00 00 00 
  800b4b:	ff d0                	callq  *%rax
}
  800b4d:	5d                   	pop    %rbp
  800b4e:	c3                   	retq   

0000000000800b4f <umain>:

void
umain(int argc, char **argv)
{
  800b4f:	55                   	push   %rbp
  800b50:	48 89 e5             	mov    %rsp,%rbp
  800b53:	48 83 ec 50          	sub    $0x50,%rsp
  800b57:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800b5a:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int r, interactive, echocmds;
	struct Argstate args;
	interactive = '?';
  800b5e:	c7 45 fc 3f 00 00 00 	movl   $0x3f,-0x4(%rbp)
	echocmds = 0;
  800b65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	argstart(&argc, argv, &args);
  800b6c:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  800b70:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800b74:	48 8d 45 bc          	lea    -0x44(%rbp),%rax
  800b78:	48 89 ce             	mov    %rcx,%rsi
  800b7b:	48 89 c7             	mov    %rax,%rdi
  800b7e:	48 b8 6e 34 80 00 00 	movabs $0x80346e,%rax
  800b85:	00 00 00 
  800b88:	ff d0                	callq  *%rax
	while ((r = argnext(&args)) >= 0)
  800b8a:	eb 4d                	jmp    800bd9 <umain+0x8a>
		switch (r) {
  800b8c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800b8f:	83 f8 69             	cmp    $0x69,%eax
  800b92:	74 27                	je     800bbb <umain+0x6c>
  800b94:	83 f8 78             	cmp    $0x78,%eax
  800b97:	74 2b                	je     800bc4 <umain+0x75>
  800b99:	83 f8 64             	cmp    $0x64,%eax
  800b9c:	75 2f                	jne    800bcd <umain+0x7e>
		case 'd':
			debug++;
  800b9e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800ba5:	00 00 00 
  800ba8:	8b 00                	mov    (%rax),%eax
  800baa:	8d 50 01             	lea    0x1(%rax),%edx
  800bad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800bb4:	00 00 00 
  800bb7:	89 10                	mov    %edx,(%rax)
			break;
  800bb9:	eb 1e                	jmp    800bd9 <umain+0x8a>
		case 'i':
			interactive = 1;
  800bbb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
			break;
  800bc2:	eb 15                	jmp    800bd9 <umain+0x8a>
		case 'x':
			echocmds = 1;
  800bc4:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
			break;
  800bcb:	eb 0c                	jmp    800bd9 <umain+0x8a>
		default:
			usage();
  800bcd:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800bd4:	00 00 00 
  800bd7:	ff d0                	callq  *%rax
	int r, interactive, echocmds;
	struct Argstate args;
	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800bd9:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  800bdd:	48 89 c7             	mov    %rax,%rdi
  800be0:	48 b8 d2 34 80 00 00 	movabs $0x8034d2,%rax
  800be7:	00 00 00 
  800bea:	ff d0                	callq  *%rax
  800bec:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800bf3:	79 97                	jns    800b8c <umain+0x3d>
			echocmds = 1;
			break;
		default:
			usage();
		}
	if (argc > 2)
  800bf5:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800bf8:	83 f8 02             	cmp    $0x2,%eax
  800bfb:	7e 0c                	jle    800c09 <umain+0xba>
		usage();
  800bfd:	48 b8 22 0b 80 00 00 	movabs $0x800b22,%rax
  800c04:	00 00 00 
  800c07:	ff d0                	callq  *%rax
	if (argc == 2) {
  800c09:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800c0c:	83 f8 02             	cmp    $0x2,%eax
  800c0f:	0f 85 b3 00 00 00    	jne    800cc8 <umain+0x179>
		close(0);
  800c15:	bf 00 00 00 00       	mov    $0x0,%edi
  800c1a:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800c26:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c2a:	48 83 c0 08          	add    $0x8,%rax
  800c2e:	48 8b 00             	mov    (%rax),%rax
  800c31:	be 00 00 00 00       	mov    $0x0,%esi
  800c36:	48 89 c7             	mov    %rax,%rdi
  800c39:	48 b8 41 41 80 00 00 	movabs $0x804141,%rax
  800c40:	00 00 00 
  800c43:	ff d0                	callq  *%rax
  800c45:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800c48:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c4c:	79 3f                	jns    800c8d <umain+0x13e>
			panic("open %s: %e", argv[1], r);
  800c4e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800c52:	48 83 c0 08          	add    $0x8,%rax
  800c56:	48 8b 00             	mov    (%rax),%rax
  800c59:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800c5c:	41 89 d0             	mov    %edx,%r8d
  800c5f:	48 89 c1             	mov    %rax,%rcx
  800c62:	48 ba a9 69 80 00 00 	movabs $0x8069a9,%rdx
  800c69:	00 00 00 
  800c6c:	be 29 01 00 00       	mov    $0x129,%esi
  800c71:	48 bf b7 68 80 00 00 	movabs $0x8068b7,%rdi
  800c78:	00 00 00 
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c80:	49 b9 24 12 80 00 00 	movabs $0x801224,%r9
  800c87:	00 00 00 
  800c8a:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800c91:	74 35                	je     800cc8 <umain+0x179>
  800c93:	48 b9 b5 69 80 00 00 	movabs $0x8069b5,%rcx
  800c9a:	00 00 00 
  800c9d:	48 ba bc 69 80 00 00 	movabs $0x8069bc,%rdx
  800ca4:	00 00 00 
  800ca7:	be 2a 01 00 00       	mov    $0x12a,%esi
  800cac:	48 bf b7 68 80 00 00 	movabs $0x8068b7,%rdi
  800cb3:	00 00 00 
  800cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbb:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  800cc2:	00 00 00 
  800cc5:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800cc8:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800ccc:	75 14                	jne    800ce2 <umain+0x193>
		interactive = iscons(0);
  800cce:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd3:	48 b8 37 0f 80 00 00 	movabs $0x800f37,%rax
  800cda:	00 00 00 
  800cdd:	ff d0                	callq  *%rax
  800cdf:	89 45 fc             	mov    %eax,-0x4(%rbp)

	while (1) {
		char *buf;
		buf = readline(interactive ? "$ " : NULL);
  800ce2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce6:	74 0c                	je     800cf4 <umain+0x1a5>
  800ce8:	48 b8 d1 69 80 00 00 	movabs $0x8069d1,%rax
  800cef:	00 00 00 
  800cf2:	eb 05                	jmp    800cf9 <umain+0x1aa>
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf9:	48 89 c7             	mov    %rax,%rdi
  800cfc:	48 b8 a6 1f 80 00 00 	movabs $0x801fa6,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
  800d08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		if (buf == NULL) {
  800d0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800d11:	75 37                	jne    800d4a <umain+0x1fb>
			if (debug)
  800d13:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800d1a:	00 00 00 
  800d1d:	8b 00                	mov    (%rax),%eax
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	74 1b                	je     800d3e <umain+0x1ef>
				cprintf("EXITING\n");
  800d23:	48 bf d4 69 80 00 00 	movabs $0x8069d4,%rdi
  800d2a:	00 00 00 
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800d39:	00 00 00 
  800d3c:	ff d2                	callq  *%rdx
			exit();	// end of file
  800d3e:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
		}
		if(strcmp(buf, "quit")==0)
  800d4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d4e:	48 be dd 69 80 00 00 	movabs $0x8069dd,%rsi
  800d55:	00 00 00 
  800d58:	48 89 c7             	mov    %rax,%rdi
  800d5b:	48 b8 ce 22 80 00 00 	movabs $0x8022ce,%rax
  800d62:	00 00 00 
  800d65:	ff d0                	callq  *%rax
  800d67:	85 c0                	test   %eax,%eax
  800d69:	75 0c                	jne    800d77 <umain+0x228>
			exit();
  800d6b:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800d72:	00 00 00 
  800d75:	ff d0                	callq  *%rax
		if (debug)
  800d77:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800d7e:	00 00 00 
  800d81:	8b 00                	mov    (%rax),%eax
  800d83:	85 c0                	test   %eax,%eax
  800d85:	74 22                	je     800da9 <umain+0x25a>
			cprintf("LINE: %s\n", buf);
  800d87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8b:	48 89 c6             	mov    %rax,%rsi
  800d8e:	48 bf e2 69 80 00 00 	movabs $0x8069e2,%rdi
  800d95:	00 00 00 
  800d98:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9d:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800da4:	00 00 00 
  800da7:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800da9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dad:	0f b6 00             	movzbl (%rax),%eax
  800db0:	3c 23                	cmp    $0x23,%al
  800db2:	75 05                	jne    800db9 <umain+0x26a>
			continue;
  800db4:	e9 05 01 00 00       	jmpq   800ebe <umain+0x36f>
		if (echocmds)
  800db9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800dbd:	74 22                	je     800de1 <umain+0x292>
			printf("# %s\n", buf);
  800dbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc3:	48 89 c6             	mov    %rax,%rsi
  800dc6:	48 bf ec 69 80 00 00 	movabs $0x8069ec,%rdi
  800dcd:	00 00 00 
  800dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd5:	48 ba a5 49 80 00 00 	movabs $0x8049a5,%rdx
  800ddc:	00 00 00 
  800ddf:	ff d2                	callq  *%rdx
			//fprintf(1, "# %s\n", buf);
		if (debug)
  800de1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800de8:	00 00 00 
  800deb:	8b 00                	mov    (%rax),%eax
  800ded:	85 c0                	test   %eax,%eax
  800def:	74 1b                	je     800e0c <umain+0x2bd>
			cprintf("BEFORE FORK\n");
  800df1:	48 bf f2 69 80 00 00 	movabs $0x8069f2,%rdi
  800df8:	00 00 00 
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800e00:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800e07:	00 00 00 
  800e0a:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800e0c:	48 b8 bd 31 80 00 00 	movabs $0x8031bd,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
  800e18:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800e1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e1f:	79 30                	jns    800e51 <umain+0x302>
			panic("fork: %e", r);
  800e21:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e24:	89 c1                	mov    %eax,%ecx
  800e26:	48 ba 92 68 80 00 00 	movabs $0x806892,%rdx
  800e2d:	00 00 00 
  800e30:	be 43 01 00 00       	mov    $0x143,%esi
  800e35:	48 bf b7 68 80 00 00 	movabs $0x8068b7,%rdi
  800e3c:	00 00 00 
  800e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e44:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  800e4b:	00 00 00 
  800e4e:	41 ff d0             	callq  *%r8
		if (debug)
  800e51:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800e58:	00 00 00 
  800e5b:	8b 00                	mov    (%rax),%eax
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	74 20                	je     800e81 <umain+0x332>
			cprintf("FORK: %d\n", r);
  800e61:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800e64:	89 c6                	mov    %eax,%esi
  800e66:	48 bf ff 69 80 00 00 	movabs $0x8069ff,%rdi
  800e6d:	00 00 00 
  800e70:	b8 00 00 00 00       	mov    $0x0,%eax
  800e75:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  800e7c:	00 00 00 
  800e7f:	ff d2                	callq  *%rdx
		if (r == 0) {
  800e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800e85:	75 21                	jne    800ea8 <umain+0x359>
			runcmd(buf);
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	48 89 c7             	mov    %rax,%rdi
  800e8e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
			exit();
  800e9a:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  800ea1:	00 00 00 
  800ea4:	ff d0                	callq  *%rax
  800ea6:	eb 16                	jmp    800ebe <umain+0x36f>
		} else {
			wait(r);
  800ea8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800eab:	89 c7                	mov    %eax,%edi
  800ead:	48 b8 84 63 80 00 00 	movabs $0x806384,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
		}
	}
  800eb9:	e9 24 fe ff ff       	jmpq   800ce2 <umain+0x193>
  800ebe:	e9 1f fe ff ff       	jmpq   800ce2 <umain+0x193>

0000000000800ec3 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800ec3:	55                   	push   %rbp
  800ec4:	48 89 e5             	mov    %rsp,%rbp
  800ec7:	48 83 ec 20          	sub    $0x20,%rsp
  800ecb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800ece:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ed1:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800ed4:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800ed8:	be 01 00 00 00       	mov    $0x1,%esi
  800edd:	48 89 c7             	mov    %rax,%rdi
  800ee0:	48 b8 53 29 80 00 00 	movabs $0x802953,%rax
  800ee7:	00 00 00 
  800eea:	ff d0                	callq  *%rax
}
  800eec:	c9                   	leaveq 
  800eed:	c3                   	retq   

0000000000800eee <getchar>:

int
getchar(void)
{
  800eee:	55                   	push   %rbp
  800eef:	48 89 e5             	mov    %rsp,%rbp
  800ef2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800ef6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  800efa:	ba 01 00 00 00       	mov    $0x1,%edx
  800eff:	48 89 c6             	mov    %rax,%rsi
  800f02:	bf 00 00 00 00       	mov    $0x0,%edi
  800f07:	48 b8 6b 3c 80 00 00 	movabs $0x803c6b,%rax
  800f0e:	00 00 00 
  800f11:	ff d0                	callq  *%rax
  800f13:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  800f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f1a:	79 05                	jns    800f21 <getchar+0x33>
		return r;
  800f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f1f:	eb 14                	jmp    800f35 <getchar+0x47>
	if (r < 1)
  800f21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f25:	7f 07                	jg     800f2e <getchar+0x40>
		return -E_EOF;
  800f27:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800f2c:	eb 07                	jmp    800f35 <getchar+0x47>
	return c;
  800f2e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
}
  800f35:	c9                   	leaveq 
  800f36:	c3                   	retq   

0000000000800f37 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800f37:	55                   	push   %rbp
  800f38:	48 89 e5             	mov    %rsp,%rbp
  800f3b:	48 83 ec 20          	sub    $0x20,%rsp
  800f3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f42:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f46:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f49:	48 89 d6             	mov    %rdx,%rsi
  800f4c:	89 c7                	mov    %eax,%edi
  800f4e:	48 b8 39 38 80 00 00 	movabs $0x803839,%rax
  800f55:	00 00 00 
  800f58:	ff d0                	callq  *%rax
  800f5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f61:	79 05                	jns    800f68 <iscons+0x31>
		return r;
  800f63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f66:	eb 1a                	jmp    800f82 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6c:	8b 10                	mov    (%rax),%edx
  800f6e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800f75:	00 00 00 
  800f78:	8b 00                	mov    (%rax),%eax
  800f7a:	39 c2                	cmp    %eax,%edx
  800f7c:	0f 94 c0             	sete   %al
  800f7f:	0f b6 c0             	movzbl %al,%eax
}
  800f82:	c9                   	leaveq 
  800f83:	c3                   	retq   

0000000000800f84 <opencons>:

int
opencons(void)
{
  800f84:	55                   	push   %rbp
  800f85:	48 89 e5             	mov    %rsp,%rbp
  800f88:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800f8c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f90:	48 89 c7             	mov    %rax,%rdi
  800f93:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  800f9a:	00 00 00 
  800f9d:	ff d0                	callq  *%rax
  800f9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa6:	79 05                	jns    800fad <opencons+0x29>
		return r;
  800fa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fab:	eb 5b                	jmp    801008 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb1:	ba 07 04 00 00       	mov    $0x407,%edx
  800fb6:	48 89 c6             	mov    %rax,%rsi
  800fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800fbe:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  800fc5:	00 00 00 
  800fc8:	ff d0                	callq  *%rax
  800fca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fd1:	79 05                	jns    800fd8 <opencons+0x54>
		return r;
  800fd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd6:	eb 30                	jmp    801008 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdc:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  800fe3:	00 00 00 
  800fe6:	8b 12                	mov    (%rdx),%edx
  800fe8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  800fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fee:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  800ff5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff9:	48 89 c7             	mov    %rax,%rdi
  800ffc:	48 b8 53 37 80 00 00 	movabs $0x803753,%rax
  801003:	00 00 00 
  801006:	ff d0                	callq  *%rax
}
  801008:	c9                   	leaveq 
  801009:	c3                   	retq   

000000000080100a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80100a:	55                   	push   %rbp
  80100b:	48 89 e5             	mov    %rsp,%rbp
  80100e:	48 83 ec 30          	sub    $0x30,%rsp
  801012:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801016:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80101a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80101e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801023:	75 07                	jne    80102c <devcons_read+0x22>
		return 0;
  801025:	b8 00 00 00 00       	mov    $0x0,%eax
  80102a:	eb 4b                	jmp    801077 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80102c:	eb 0c                	jmp    80103a <devcons_read+0x30>
		sys_yield();
  80102e:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  801035:	00 00 00 
  801038:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80103a:	48 b8 9d 29 80 00 00 	movabs $0x80299d,%rax
  801041:	00 00 00 
  801044:	ff d0                	callq  *%rax
  801046:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801049:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80104d:	74 df                	je     80102e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80104f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801053:	79 05                	jns    80105a <devcons_read+0x50>
		return c;
  801055:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801058:	eb 1d                	jmp    801077 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80105a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80105e:	75 07                	jne    801067 <devcons_read+0x5d>
		return 0;
  801060:	b8 00 00 00 00       	mov    $0x0,%eax
  801065:	eb 10                	jmp    801077 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801067:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80106a:	89 c2                	mov    %eax,%edx
  80106c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801070:	88 10                	mov    %dl,(%rax)
	return 1;
  801072:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801077:	c9                   	leaveq 
  801078:	c3                   	retq   

0000000000801079 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801079:	55                   	push   %rbp
  80107a:	48 89 e5             	mov    %rsp,%rbp
  80107d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801084:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80108b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801092:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801099:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a0:	eb 76                	jmp    801118 <devcons_write+0x9f>
		m = n - tot;
  8010a2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8010a9:	89 c2                	mov    %eax,%edx
  8010ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ae:	29 c2                	sub    %eax,%edx
  8010b0:	89 d0                	mov    %edx,%eax
  8010b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8010b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010b8:	83 f8 7f             	cmp    $0x7f,%eax
  8010bb:	76 07                	jbe    8010c4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8010bd:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8010c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010c7:	48 63 d0             	movslq %eax,%rdx
  8010ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010cd:	48 63 c8             	movslq %eax,%rcx
  8010d0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8010d7:	48 01 c1             	add    %rax,%rcx
  8010da:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8010e1:	48 89 ce             	mov    %rcx,%rsi
  8010e4:	48 89 c7             	mov    %rax,%rdi
  8010e7:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8010ee:	00 00 00 
  8010f1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8010f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8010f6:	48 63 d0             	movslq %eax,%rdx
  8010f9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801100:	48 89 d6             	mov    %rdx,%rsi
  801103:	48 89 c7             	mov    %rax,%rdi
  801106:	48 b8 53 29 80 00 00 	movabs $0x802953,%rax
  80110d:	00 00 00 
  801110:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801112:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801115:	01 45 fc             	add    %eax,-0x4(%rbp)
  801118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80111b:	48 98                	cltq   
  80111d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801124:	0f 82 78 ff ff ff    	jb     8010a2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80112a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80112d:	c9                   	leaveq 
  80112e:	c3                   	retq   

000000000080112f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80112f:	55                   	push   %rbp
  801130:	48 89 e5             	mov    %rsp,%rbp
  801133:	48 83 ec 08          	sub    $0x8,%rsp
  801137:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80113b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801140:	c9                   	leaveq 
  801141:	c3                   	retq   

0000000000801142 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801142:	55                   	push   %rbp
  801143:	48 89 e5             	mov    %rsp,%rbp
  801146:	48 83 ec 10          	sub    $0x10,%rsp
  80114a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801152:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801156:	48 be 0e 6a 80 00 00 	movabs $0x806a0e,%rsi
  80115d:	00 00 00 
  801160:	48 89 c7             	mov    %rax,%rdi
  801163:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  80116a:	00 00 00 
  80116d:	ff d0                	callq  *%rax
	return 0;
  80116f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801174:	c9                   	leaveq 
  801175:	c3                   	retq   

0000000000801176 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801176:	55                   	push   %rbp
  801177:	48 89 e5             	mov    %rsp,%rbp
  80117a:	48 83 ec 10          	sub    $0x10,%rsp
  80117e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801181:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801185:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  80118c:	00 00 00 
  80118f:	ff d0                	callq  *%rax
  801191:	25 ff 03 00 00       	and    $0x3ff,%eax
  801196:	48 63 d0             	movslq %eax,%rdx
  801199:	48 89 d0             	mov    %rdx,%rax
  80119c:	48 c1 e0 03          	shl    $0x3,%rax
  8011a0:	48 01 d0             	add    %rdx,%rax
  8011a3:	48 c1 e0 05          	shl    $0x5,%rax
  8011a7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8011ae:	00 00 00 
  8011b1:	48 01 c2             	add    %rax,%rdx
  8011b4:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8011bb:	00 00 00 
  8011be:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011c5:	7e 14                	jle    8011db <libmain+0x65>
		binaryname = argv[0];
  8011c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cb:	48 8b 10             	mov    (%rax),%rdx
  8011ce:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8011d5:	00 00 00 
  8011d8:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8011db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011e2:	48 89 d6             	mov    %rdx,%rsi
  8011e5:	89 c7                	mov    %eax,%edi
  8011e7:	48 b8 4f 0b 80 00 00 	movabs $0x800b4f,%rax
  8011ee:	00 00 00 
  8011f1:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8011f3:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  8011fa:	00 00 00 
  8011fd:	ff d0                	callq  *%rax
}
  8011ff:	c9                   	leaveq 
  801200:	c3                   	retq   

0000000000801201 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801201:	55                   	push   %rbp
  801202:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  801205:	48 b8 94 3a 80 00 00 	movabs $0x803a94,%rax
  80120c:	00 00 00 
  80120f:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  801211:	bf 00 00 00 00       	mov    $0x0,%edi
  801216:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  80121d:	00 00 00 
  801220:	ff d0                	callq  *%rax

}
  801222:	5d                   	pop    %rbp
  801223:	c3                   	retq   

0000000000801224 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801224:	55                   	push   %rbp
  801225:	48 89 e5             	mov    %rsp,%rbp
  801228:	53                   	push   %rbx
  801229:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801230:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801237:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80123d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801244:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80124b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801252:	84 c0                	test   %al,%al
  801254:	74 23                	je     801279 <_panic+0x55>
  801256:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80125d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801261:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801265:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801269:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80126d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801271:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801275:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801279:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801280:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801287:	00 00 00 
  80128a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801291:	00 00 00 
  801294:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801298:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80129f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8012a6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8012ad:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8012b4:	00 00 00 
  8012b7:	48 8b 18             	mov    (%rax),%rbx
  8012ba:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  8012c1:	00 00 00 
  8012c4:	ff d0                	callq  *%rax
  8012c6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8012cc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8012d3:	41 89 c8             	mov    %ecx,%r8d
  8012d6:	48 89 d1             	mov    %rdx,%rcx
  8012d9:	48 89 da             	mov    %rbx,%rdx
  8012dc:	89 c6                	mov    %eax,%esi
  8012de:	48 bf 20 6a 80 00 00 	movabs $0x806a20,%rdi
  8012e5:	00 00 00 
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ed:	49 b9 5d 14 80 00 00 	movabs $0x80145d,%r9
  8012f4:	00 00 00 
  8012f7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8012fa:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801301:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801308:	48 89 d6             	mov    %rdx,%rsi
  80130b:	48 89 c7             	mov    %rax,%rdi
  80130e:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  801315:	00 00 00 
  801318:	ff d0                	callq  *%rax
	cprintf("\n");
  80131a:	48 bf 43 6a 80 00 00 	movabs $0x806a43,%rdi
  801321:	00 00 00 
  801324:	b8 00 00 00 00       	mov    $0x0,%eax
  801329:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  801330:	00 00 00 
  801333:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801335:	cc                   	int3   
  801336:	eb fd                	jmp    801335 <_panic+0x111>

0000000000801338 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801338:	55                   	push   %rbp
  801339:	48 89 e5             	mov    %rsp,%rbp
  80133c:	48 83 ec 10          	sub    $0x10,%rsp
  801340:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801343:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134b:	8b 00                	mov    (%rax),%eax
  80134d:	8d 48 01             	lea    0x1(%rax),%ecx
  801350:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801354:	89 0a                	mov    %ecx,(%rdx)
  801356:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801359:	89 d1                	mov    %edx,%ecx
  80135b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80135f:	48 98                	cltq   
  801361:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801365:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801369:	8b 00                	mov    (%rax),%eax
  80136b:	3d ff 00 00 00       	cmp    $0xff,%eax
  801370:	75 2c                	jne    80139e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801372:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801376:	8b 00                	mov    (%rax),%eax
  801378:	48 98                	cltq   
  80137a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80137e:	48 83 c2 08          	add    $0x8,%rdx
  801382:	48 89 c6             	mov    %rax,%rsi
  801385:	48 89 d7             	mov    %rdx,%rdi
  801388:	48 b8 53 29 80 00 00 	movabs $0x802953,%rax
  80138f:	00 00 00 
  801392:	ff d0                	callq  *%rax
        b->idx = 0;
  801394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801398:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80139e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a2:	8b 40 04             	mov    0x4(%rax),%eax
  8013a5:	8d 50 01             	lea    0x1(%rax),%edx
  8013a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ac:	89 50 04             	mov    %edx,0x4(%rax)
}
  8013af:	c9                   	leaveq 
  8013b0:	c3                   	retq   

00000000008013b1 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8013b1:	55                   	push   %rbp
  8013b2:	48 89 e5             	mov    %rsp,%rbp
  8013b5:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8013bc:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8013c3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8013ca:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8013d1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8013d8:	48 8b 0a             	mov    (%rdx),%rcx
  8013db:	48 89 08             	mov    %rcx,(%rax)
  8013de:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8013e2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8013e6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8013ea:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8013ee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8013f5:	00 00 00 
    b.cnt = 0;
  8013f8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8013ff:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801402:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801409:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801410:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801417:	48 89 c6             	mov    %rax,%rsi
  80141a:	48 bf 38 13 80 00 00 	movabs $0x801338,%rdi
  801421:	00 00 00 
  801424:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  80142b:	00 00 00 
  80142e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  801430:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801436:	48 98                	cltq   
  801438:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80143f:	48 83 c2 08          	add    $0x8,%rdx
  801443:	48 89 c6             	mov    %rax,%rsi
  801446:	48 89 d7             	mov    %rdx,%rdi
  801449:	48 b8 53 29 80 00 00 	movabs $0x802953,%rax
  801450:	00 00 00 
  801453:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  801455:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80145b:	c9                   	leaveq 
  80145c:	c3                   	retq   

000000000080145d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80145d:	55                   	push   %rbp
  80145e:	48 89 e5             	mov    %rsp,%rbp
  801461:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801468:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80146f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801476:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80147d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801484:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80148b:	84 c0                	test   %al,%al
  80148d:	74 20                	je     8014af <cprintf+0x52>
  80148f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801493:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801497:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80149b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80149f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8014a3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8014a7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8014ab:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8014af:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8014b6:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8014bd:	00 00 00 
  8014c0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8014c7:	00 00 00 
  8014ca:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8014ce:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8014d5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8014dc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8014e3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8014ea:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8014f1:	48 8b 0a             	mov    (%rdx),%rcx
  8014f4:	48 89 08             	mov    %rcx,(%rax)
  8014f7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014fb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014ff:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801503:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  801507:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80150e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801515:	48 89 d6             	mov    %rdx,%rsi
  801518:	48 89 c7             	mov    %rax,%rdi
  80151b:	48 b8 b1 13 80 00 00 	movabs $0x8013b1,%rax
  801522:	00 00 00 
  801525:	ff d0                	callq  *%rax
  801527:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80152d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801533:	c9                   	leaveq 
  801534:	c3                   	retq   

0000000000801535 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801535:	55                   	push   %rbp
  801536:	48 89 e5             	mov    %rsp,%rbp
  801539:	53                   	push   %rbx
  80153a:	48 83 ec 38          	sub    $0x38,%rsp
  80153e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801542:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801546:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80154a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80154d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  801551:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801555:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801558:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80155c:	77 3b                	ja     801599 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80155e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801561:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801565:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156c:	ba 00 00 00 00       	mov    $0x0,%edx
  801571:	48 f7 f3             	div    %rbx
  801574:	48 89 c2             	mov    %rax,%rdx
  801577:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80157a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80157d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	41 89 f9             	mov    %edi,%r9d
  801588:	48 89 c7             	mov    %rax,%rdi
  80158b:	48 b8 35 15 80 00 00 	movabs $0x801535,%rax
  801592:	00 00 00 
  801595:	ff d0                	callq  *%rax
  801597:	eb 1e                	jmp    8015b7 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801599:	eb 12                	jmp    8015ad <printnum+0x78>
			putch(padc, putdat);
  80159b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80159f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8015a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a6:	48 89 ce             	mov    %rcx,%rsi
  8015a9:	89 d7                	mov    %edx,%edi
  8015ab:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015ad:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8015b1:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8015b5:	7f e4                	jg     80159b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015b7:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8015ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015be:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c3:	48 f7 f1             	div    %rcx
  8015c6:	48 89 d0             	mov    %rdx,%rax
  8015c9:	48 ba 50 6c 80 00 00 	movabs $0x806c50,%rdx
  8015d0:	00 00 00 
  8015d3:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8015d7:	0f be d0             	movsbl %al,%edx
  8015da:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8015de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e2:	48 89 ce             	mov    %rcx,%rsi
  8015e5:	89 d7                	mov    %edx,%edi
  8015e7:	ff d0                	callq  *%rax
}
  8015e9:	48 83 c4 38          	add    $0x38,%rsp
  8015ed:	5b                   	pop    %rbx
  8015ee:	5d                   	pop    %rbp
  8015ef:	c3                   	retq   

00000000008015f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8015f0:	55                   	push   %rbp
  8015f1:	48 89 e5             	mov    %rsp,%rbp
  8015f4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8015f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015fc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8015ff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801603:	7e 52                	jle    801657 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801609:	8b 00                	mov    (%rax),%eax
  80160b:	83 f8 30             	cmp    $0x30,%eax
  80160e:	73 24                	jae    801634 <getuint+0x44>
  801610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801614:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161c:	8b 00                	mov    (%rax),%eax
  80161e:	89 c0                	mov    %eax,%eax
  801620:	48 01 d0             	add    %rdx,%rax
  801623:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801627:	8b 12                	mov    (%rdx),%edx
  801629:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80162c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801630:	89 0a                	mov    %ecx,(%rdx)
  801632:	eb 17                	jmp    80164b <getuint+0x5b>
  801634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801638:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80163c:	48 89 d0             	mov    %rdx,%rax
  80163f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801643:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801647:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80164b:	48 8b 00             	mov    (%rax),%rax
  80164e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801652:	e9 a3 00 00 00       	jmpq   8016fa <getuint+0x10a>
	else if (lflag)
  801657:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80165b:	74 4f                	je     8016ac <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80165d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801661:	8b 00                	mov    (%rax),%eax
  801663:	83 f8 30             	cmp    $0x30,%eax
  801666:	73 24                	jae    80168c <getuint+0x9c>
  801668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801674:	8b 00                	mov    (%rax),%eax
  801676:	89 c0                	mov    %eax,%eax
  801678:	48 01 d0             	add    %rdx,%rax
  80167b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167f:	8b 12                	mov    (%rdx),%edx
  801681:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801684:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801688:	89 0a                	mov    %ecx,(%rdx)
  80168a:	eb 17                	jmp    8016a3 <getuint+0xb3>
  80168c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801690:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801694:	48 89 d0             	mov    %rdx,%rax
  801697:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80169b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80169f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016a3:	48 8b 00             	mov    (%rax),%rax
  8016a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8016aa:	eb 4e                	jmp    8016fa <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8016ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b0:	8b 00                	mov    (%rax),%eax
  8016b2:	83 f8 30             	cmp    $0x30,%eax
  8016b5:	73 24                	jae    8016db <getuint+0xeb>
  8016b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8016bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c3:	8b 00                	mov    (%rax),%eax
  8016c5:	89 c0                	mov    %eax,%eax
  8016c7:	48 01 d0             	add    %rdx,%rax
  8016ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ce:	8b 12                	mov    (%rdx),%edx
  8016d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8016d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016d7:	89 0a                	mov    %ecx,(%rdx)
  8016d9:	eb 17                	jmp    8016f2 <getuint+0x102>
  8016db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016df:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8016e3:	48 89 d0             	mov    %rdx,%rax
  8016e6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8016ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ee:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8016f2:	8b 00                	mov    (%rax),%eax
  8016f4:	89 c0                	mov    %eax,%eax
  8016f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8016fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016fe:	c9                   	leaveq 
  8016ff:	c3                   	retq   

0000000000801700 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801700:	55                   	push   %rbp
  801701:	48 89 e5             	mov    %rsp,%rbp
  801704:	48 83 ec 1c          	sub    $0x1c,%rsp
  801708:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80170c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80170f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801713:	7e 52                	jle    801767 <getint+0x67>
		x=va_arg(*ap, long long);
  801715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801719:	8b 00                	mov    (%rax),%eax
  80171b:	83 f8 30             	cmp    $0x30,%eax
  80171e:	73 24                	jae    801744 <getint+0x44>
  801720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801724:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172c:	8b 00                	mov    (%rax),%eax
  80172e:	89 c0                	mov    %eax,%eax
  801730:	48 01 d0             	add    %rdx,%rax
  801733:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801737:	8b 12                	mov    (%rdx),%edx
  801739:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80173c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801740:	89 0a                	mov    %ecx,(%rdx)
  801742:	eb 17                	jmp    80175b <getint+0x5b>
  801744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801748:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80174c:	48 89 d0             	mov    %rdx,%rax
  80174f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801753:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801757:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80175b:	48 8b 00             	mov    (%rax),%rax
  80175e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801762:	e9 a3 00 00 00       	jmpq   80180a <getint+0x10a>
	else if (lflag)
  801767:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80176b:	74 4f                	je     8017bc <getint+0xbc>
		x=va_arg(*ap, long);
  80176d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801771:	8b 00                	mov    (%rax),%eax
  801773:	83 f8 30             	cmp    $0x30,%eax
  801776:	73 24                	jae    80179c <getint+0x9c>
  801778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801784:	8b 00                	mov    (%rax),%eax
  801786:	89 c0                	mov    %eax,%eax
  801788:	48 01 d0             	add    %rdx,%rax
  80178b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80178f:	8b 12                	mov    (%rdx),%edx
  801791:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801794:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801798:	89 0a                	mov    %ecx,(%rdx)
  80179a:	eb 17                	jmp    8017b3 <getint+0xb3>
  80179c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017a4:	48 89 d0             	mov    %rdx,%rax
  8017a7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017b3:	48 8b 00             	mov    (%rax),%rax
  8017b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8017ba:	eb 4e                	jmp    80180a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8017bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017c0:	8b 00                	mov    (%rax),%eax
  8017c2:	83 f8 30             	cmp    $0x30,%eax
  8017c5:	73 24                	jae    8017eb <getint+0xeb>
  8017c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d3:	8b 00                	mov    (%rax),%eax
  8017d5:	89 c0                	mov    %eax,%eax
  8017d7:	48 01 d0             	add    %rdx,%rax
  8017da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017de:	8b 12                	mov    (%rdx),%edx
  8017e0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e7:	89 0a                	mov    %ecx,(%rdx)
  8017e9:	eb 17                	jmp    801802 <getint+0x102>
  8017eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ef:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8017f3:	48 89 d0             	mov    %rdx,%rax
  8017f6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8017fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801802:	8b 00                	mov    (%rax),%eax
  801804:	48 98                	cltq   
  801806:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80180a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80180e:	c9                   	leaveq 
  80180f:	c3                   	retq   

0000000000801810 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801810:	55                   	push   %rbp
  801811:	48 89 e5             	mov    %rsp,%rbp
  801814:	41 54                	push   %r12
  801816:	53                   	push   %rbx
  801817:	48 83 ec 60          	sub    $0x60,%rsp
  80181b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80181f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801823:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801827:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80182b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80182f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801833:	48 8b 0a             	mov    (%rdx),%rcx
  801836:	48 89 08             	mov    %rcx,(%rax)
  801839:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80183d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801841:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801845:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801849:	eb 17                	jmp    801862 <vprintfmt+0x52>
			if (ch == '\0')
  80184b:	85 db                	test   %ebx,%ebx
  80184d:	0f 84 cc 04 00 00    	je     801d1f <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801853:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801857:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80185b:	48 89 d6             	mov    %rdx,%rsi
  80185e:	89 df                	mov    %ebx,%edi
  801860:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801862:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801866:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80186a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80186e:	0f b6 00             	movzbl (%rax),%eax
  801871:	0f b6 d8             	movzbl %al,%ebx
  801874:	83 fb 25             	cmp    $0x25,%ebx
  801877:	75 d2                	jne    80184b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801879:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80187d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801884:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80188b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801892:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801899:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80189d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018a1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8018a5:	0f b6 00             	movzbl (%rax),%eax
  8018a8:	0f b6 d8             	movzbl %al,%ebx
  8018ab:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8018ae:	83 f8 55             	cmp    $0x55,%eax
  8018b1:	0f 87 34 04 00 00    	ja     801ceb <vprintfmt+0x4db>
  8018b7:	89 c0                	mov    %eax,%eax
  8018b9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8018c0:	00 
  8018c1:	48 b8 78 6c 80 00 00 	movabs $0x806c78,%rax
  8018c8:	00 00 00 
  8018cb:	48 01 d0             	add    %rdx,%rax
  8018ce:	48 8b 00             	mov    (%rax),%rax
  8018d1:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8018d3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8018d7:	eb c0                	jmp    801899 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8018d9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8018dd:	eb ba                	jmp    801899 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018df:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8018e6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8018e9:	89 d0                	mov    %edx,%eax
  8018eb:	c1 e0 02             	shl    $0x2,%eax
  8018ee:	01 d0                	add    %edx,%eax
  8018f0:	01 c0                	add    %eax,%eax
  8018f2:	01 d8                	add    %ebx,%eax
  8018f4:	83 e8 30             	sub    $0x30,%eax
  8018f7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8018fa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8018fe:	0f b6 00             	movzbl (%rax),%eax
  801901:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801904:	83 fb 2f             	cmp    $0x2f,%ebx
  801907:	7e 0c                	jle    801915 <vprintfmt+0x105>
  801909:	83 fb 39             	cmp    $0x39,%ebx
  80190c:	7f 07                	jg     801915 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80190e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801913:	eb d1                	jmp    8018e6 <vprintfmt+0xd6>
			goto process_precision;
  801915:	eb 58                	jmp    80196f <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  801917:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80191a:	83 f8 30             	cmp    $0x30,%eax
  80191d:	73 17                	jae    801936 <vprintfmt+0x126>
  80191f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801923:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801926:	89 c0                	mov    %eax,%eax
  801928:	48 01 d0             	add    %rdx,%rax
  80192b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80192e:	83 c2 08             	add    $0x8,%edx
  801931:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801934:	eb 0f                	jmp    801945 <vprintfmt+0x135>
  801936:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80193a:	48 89 d0             	mov    %rdx,%rax
  80193d:	48 83 c2 08          	add    $0x8,%rdx
  801941:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801945:	8b 00                	mov    (%rax),%eax
  801947:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80194a:	eb 23                	jmp    80196f <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80194c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801950:	79 0c                	jns    80195e <vprintfmt+0x14e>
				width = 0;
  801952:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801959:	e9 3b ff ff ff       	jmpq   801899 <vprintfmt+0x89>
  80195e:	e9 36 ff ff ff       	jmpq   801899 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801963:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80196a:	e9 2a ff ff ff       	jmpq   801899 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80196f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801973:	79 12                	jns    801987 <vprintfmt+0x177>
				width = precision, precision = -1;
  801975:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801978:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80197b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801982:	e9 12 ff ff ff       	jmpq   801899 <vprintfmt+0x89>
  801987:	e9 0d ff ff ff       	jmpq   801899 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80198c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801990:	e9 04 ff ff ff       	jmpq   801899 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801995:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801998:	83 f8 30             	cmp    $0x30,%eax
  80199b:	73 17                	jae    8019b4 <vprintfmt+0x1a4>
  80199d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8019a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019a4:	89 c0                	mov    %eax,%eax
  8019a6:	48 01 d0             	add    %rdx,%rax
  8019a9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019ac:	83 c2 08             	add    $0x8,%edx
  8019af:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019b2:	eb 0f                	jmp    8019c3 <vprintfmt+0x1b3>
  8019b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8019b8:	48 89 d0             	mov    %rdx,%rax
  8019bb:	48 83 c2 08          	add    $0x8,%rdx
  8019bf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8019c3:	8b 10                	mov    (%rax),%edx
  8019c5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8019c9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019cd:	48 89 ce             	mov    %rcx,%rsi
  8019d0:	89 d7                	mov    %edx,%edi
  8019d2:	ff d0                	callq  *%rax
			break;
  8019d4:	e9 40 03 00 00       	jmpq   801d19 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8019d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019dc:	83 f8 30             	cmp    $0x30,%eax
  8019df:	73 17                	jae    8019f8 <vprintfmt+0x1e8>
  8019e1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8019e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8019e8:	89 c0                	mov    %eax,%eax
  8019ea:	48 01 d0             	add    %rdx,%rax
  8019ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8019f0:	83 c2 08             	add    $0x8,%edx
  8019f3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8019f6:	eb 0f                	jmp    801a07 <vprintfmt+0x1f7>
  8019f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8019fc:	48 89 d0             	mov    %rdx,%rax
  8019ff:	48 83 c2 08          	add    $0x8,%rdx
  801a03:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801a07:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801a09:	85 db                	test   %ebx,%ebx
  801a0b:	79 02                	jns    801a0f <vprintfmt+0x1ff>
				err = -err;
  801a0d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801a0f:	83 fb 15             	cmp    $0x15,%ebx
  801a12:	7f 16                	jg     801a2a <vprintfmt+0x21a>
  801a14:	48 b8 a0 6b 80 00 00 	movabs $0x806ba0,%rax
  801a1b:	00 00 00 
  801a1e:	48 63 d3             	movslq %ebx,%rdx
  801a21:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801a25:	4d 85 e4             	test   %r12,%r12
  801a28:	75 2e                	jne    801a58 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  801a2a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a32:	89 d9                	mov    %ebx,%ecx
  801a34:	48 ba 61 6c 80 00 00 	movabs $0x806c61,%rdx
  801a3b:	00 00 00 
  801a3e:	48 89 c7             	mov    %rax,%rdi
  801a41:	b8 00 00 00 00       	mov    $0x0,%eax
  801a46:	49 b8 28 1d 80 00 00 	movabs $0x801d28,%r8
  801a4d:	00 00 00 
  801a50:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a53:	e9 c1 02 00 00       	jmpq   801d19 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a58:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801a5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801a60:	4c 89 e1             	mov    %r12,%rcx
  801a63:	48 ba 6a 6c 80 00 00 	movabs $0x806c6a,%rdx
  801a6a:	00 00 00 
  801a6d:	48 89 c7             	mov    %rax,%rdi
  801a70:	b8 00 00 00 00       	mov    $0x0,%eax
  801a75:	49 b8 28 1d 80 00 00 	movabs $0x801d28,%r8
  801a7c:	00 00 00 
  801a7f:	41 ff d0             	callq  *%r8
			break;
  801a82:	e9 92 02 00 00       	jmpq   801d19 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801a87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a8a:	83 f8 30             	cmp    $0x30,%eax
  801a8d:	73 17                	jae    801aa6 <vprintfmt+0x296>
  801a8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801a93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a96:	89 c0                	mov    %eax,%eax
  801a98:	48 01 d0             	add    %rdx,%rax
  801a9b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a9e:	83 c2 08             	add    $0x8,%edx
  801aa1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801aa4:	eb 0f                	jmp    801ab5 <vprintfmt+0x2a5>
  801aa6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801aaa:	48 89 d0             	mov    %rdx,%rax
  801aad:	48 83 c2 08          	add    $0x8,%rdx
  801ab1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801ab5:	4c 8b 20             	mov    (%rax),%r12
  801ab8:	4d 85 e4             	test   %r12,%r12
  801abb:	75 0a                	jne    801ac7 <vprintfmt+0x2b7>
				p = "(null)";
  801abd:	49 bc 6d 6c 80 00 00 	movabs $0x806c6d,%r12
  801ac4:	00 00 00 
			if (width > 0 && padc != '-')
  801ac7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801acb:	7e 3f                	jle    801b0c <vprintfmt+0x2fc>
  801acd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801ad1:	74 39                	je     801b0c <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801ad3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801ad6:	48 98                	cltq   
  801ad8:	48 89 c6             	mov    %rax,%rsi
  801adb:	4c 89 e7             	mov    %r12,%rdi
  801ade:	48 b8 2e 21 80 00 00 	movabs $0x80212e,%rax
  801ae5:	00 00 00 
  801ae8:	ff d0                	callq  *%rax
  801aea:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801aed:	eb 17                	jmp    801b06 <vprintfmt+0x2f6>
					putch(padc, putdat);
  801aef:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801af3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801af7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801afb:	48 89 ce             	mov    %rcx,%rsi
  801afe:	89 d7                	mov    %edx,%edi
  801b00:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801b02:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b06:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b0a:	7f e3                	jg     801aef <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b0c:	eb 37                	jmp    801b45 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801b0e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801b12:	74 1e                	je     801b32 <vprintfmt+0x322>
  801b14:	83 fb 1f             	cmp    $0x1f,%ebx
  801b17:	7e 05                	jle    801b1e <vprintfmt+0x30e>
  801b19:	83 fb 7e             	cmp    $0x7e,%ebx
  801b1c:	7e 14                	jle    801b32 <vprintfmt+0x322>
					putch('?', putdat);
  801b1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b26:	48 89 d6             	mov    %rdx,%rsi
  801b29:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801b2e:	ff d0                	callq  *%rax
  801b30:	eb 0f                	jmp    801b41 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801b32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b3a:	48 89 d6             	mov    %rdx,%rsi
  801b3d:	89 df                	mov    %ebx,%edi
  801b3f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b41:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b45:	4c 89 e0             	mov    %r12,%rax
  801b48:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801b4c:	0f b6 00             	movzbl (%rax),%eax
  801b4f:	0f be d8             	movsbl %al,%ebx
  801b52:	85 db                	test   %ebx,%ebx
  801b54:	74 10                	je     801b66 <vprintfmt+0x356>
  801b56:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b5a:	78 b2                	js     801b0e <vprintfmt+0x2fe>
  801b5c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801b60:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b64:	79 a8                	jns    801b0e <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b66:	eb 16                	jmp    801b7e <vprintfmt+0x36e>
				putch(' ', putdat);
  801b68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801b6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b70:	48 89 d6             	mov    %rdx,%rsi
  801b73:	bf 20 00 00 00       	mov    $0x20,%edi
  801b78:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b7a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801b7e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801b82:	7f e4                	jg     801b68 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801b84:	e9 90 01 00 00       	jmpq   801d19 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801b89:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801b8d:	be 03 00 00 00       	mov    $0x3,%esi
  801b92:	48 89 c7             	mov    %rax,%rdi
  801b95:	48 b8 00 17 80 00 00 	movabs $0x801700,%rax
  801b9c:	00 00 00 
  801b9f:	ff d0                	callq  *%rax
  801ba1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba9:	48 85 c0             	test   %rax,%rax
  801bac:	79 1d                	jns    801bcb <vprintfmt+0x3bb>
				putch('-', putdat);
  801bae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801bb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801bb6:	48 89 d6             	mov    %rdx,%rsi
  801bb9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801bbe:	ff d0                	callq  *%rax
				num = -(long long) num;
  801bc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc4:	48 f7 d8             	neg    %rax
  801bc7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801bcb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801bd2:	e9 d5 00 00 00       	jmpq   801cac <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801bd7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801bdb:	be 03 00 00 00       	mov    $0x3,%esi
  801be0:	48 89 c7             	mov    %rax,%rdi
  801be3:	48 b8 f0 15 80 00 00 	movabs $0x8015f0,%rax
  801bea:	00 00 00 
  801bed:	ff d0                	callq  *%rax
  801bef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801bf3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801bfa:	e9 ad 00 00 00       	jmpq   801cac <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  801bff:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801c02:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c06:	89 d6                	mov    %edx,%esi
  801c08:	48 89 c7             	mov    %rax,%rdi
  801c0b:	48 b8 00 17 80 00 00 	movabs $0x801700,%rax
  801c12:	00 00 00 
  801c15:	ff d0                	callq  *%rax
  801c17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801c1b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801c22:	e9 85 00 00 00       	jmpq   801cac <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  801c27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c2f:	48 89 d6             	mov    %rdx,%rsi
  801c32:	bf 30 00 00 00       	mov    $0x30,%edi
  801c37:	ff d0                	callq  *%rax
			putch('x', putdat);
  801c39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c41:	48 89 d6             	mov    %rdx,%rsi
  801c44:	bf 78 00 00 00       	mov    $0x78,%edi
  801c49:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801c4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c4e:	83 f8 30             	cmp    $0x30,%eax
  801c51:	73 17                	jae    801c6a <vprintfmt+0x45a>
  801c53:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801c57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801c5a:	89 c0                	mov    %eax,%eax
  801c5c:	48 01 d0             	add    %rdx,%rax
  801c5f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801c62:	83 c2 08             	add    $0x8,%edx
  801c65:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c68:	eb 0f                	jmp    801c79 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  801c6a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801c6e:	48 89 d0             	mov    %rdx,%rax
  801c71:	48 83 c2 08          	add    $0x8,%rdx
  801c75:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801c79:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801c7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801c80:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801c87:	eb 23                	jmp    801cac <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801c89:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c8d:	be 03 00 00 00       	mov    $0x3,%esi
  801c92:	48 89 c7             	mov    %rax,%rdi
  801c95:	48 b8 f0 15 80 00 00 	movabs $0x8015f0,%rax
  801c9c:	00 00 00 
  801c9f:	ff d0                	callq  *%rax
  801ca1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801ca5:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801cac:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801cb1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801cb4:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801cb7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801cbb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801cbf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cc3:	45 89 c1             	mov    %r8d,%r9d
  801cc6:	41 89 f8             	mov    %edi,%r8d
  801cc9:	48 89 c7             	mov    %rax,%rdi
  801ccc:	48 b8 35 15 80 00 00 	movabs $0x801535,%rax
  801cd3:	00 00 00 
  801cd6:	ff d0                	callq  *%rax
			break;
  801cd8:	eb 3f                	jmp    801d19 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801cda:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ce2:	48 89 d6             	mov    %rdx,%rsi
  801ce5:	89 df                	mov    %ebx,%edi
  801ce7:	ff d0                	callq  *%rax
			break;
  801ce9:	eb 2e                	jmp    801d19 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ceb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cf3:	48 89 d6             	mov    %rdx,%rsi
  801cf6:	bf 25 00 00 00       	mov    $0x25,%edi
  801cfb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801cfd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801d02:	eb 05                	jmp    801d09 <vprintfmt+0x4f9>
  801d04:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801d09:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801d0d:	48 83 e8 01          	sub    $0x1,%rax
  801d11:	0f b6 00             	movzbl (%rax),%eax
  801d14:	3c 25                	cmp    $0x25,%al
  801d16:	75 ec                	jne    801d04 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801d18:	90                   	nop
		}
	}
  801d19:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801d1a:	e9 43 fb ff ff       	jmpq   801862 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801d1f:	48 83 c4 60          	add    $0x60,%rsp
  801d23:	5b                   	pop    %rbx
  801d24:	41 5c                	pop    %r12
  801d26:	5d                   	pop    %rbp
  801d27:	c3                   	retq   

0000000000801d28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801d28:	55                   	push   %rbp
  801d29:	48 89 e5             	mov    %rsp,%rbp
  801d2c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801d33:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801d3a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801d41:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801d48:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801d4f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801d56:	84 c0                	test   %al,%al
  801d58:	74 20                	je     801d7a <printfmt+0x52>
  801d5a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801d5e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801d62:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801d66:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801d6a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801d6e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801d72:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801d76:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801d7a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801d81:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801d88:	00 00 00 
  801d8b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801d92:	00 00 00 
  801d95:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801d99:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801da0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801da7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801dae:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801db5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801dbc:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801dc3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801dca:	48 89 c7             	mov    %rax,%rdi
  801dcd:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  801dd4:	00 00 00 
  801dd7:	ff d0                	callq  *%rax
	va_end(ap);
}
  801dd9:	c9                   	leaveq 
  801dda:	c3                   	retq   

0000000000801ddb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ddb:	55                   	push   %rbp
  801ddc:	48 89 e5             	mov    %rsp,%rbp
  801ddf:	48 83 ec 10          	sub    $0x10,%rsp
  801de3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dee:	8b 40 10             	mov    0x10(%rax),%eax
  801df1:	8d 50 01             	lea    0x1(%rax),%edx
  801df4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801dfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dff:	48 8b 10             	mov    (%rax),%rdx
  801e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e06:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e0a:	48 39 c2             	cmp    %rax,%rdx
  801e0d:	73 17                	jae    801e26 <sprintputch+0x4b>
		*b->buf++ = ch;
  801e0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e13:	48 8b 00             	mov    (%rax),%rax
  801e16:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801e1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e1e:	48 89 0a             	mov    %rcx,(%rdx)
  801e21:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e24:	88 10                	mov    %dl,(%rax)
}
  801e26:	c9                   	leaveq 
  801e27:	c3                   	retq   

0000000000801e28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e28:	55                   	push   %rbp
  801e29:	48 89 e5             	mov    %rsp,%rbp
  801e2c:	48 83 ec 50          	sub    $0x50,%rsp
  801e30:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801e34:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801e37:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801e3b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801e3f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801e43:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801e47:	48 8b 0a             	mov    (%rdx),%rcx
  801e4a:	48 89 08             	mov    %rcx,(%rax)
  801e4d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801e51:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801e55:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801e59:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e5d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e61:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801e65:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801e68:	48 98                	cltq   
  801e6a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e6e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801e72:	48 01 d0             	add    %rdx,%rax
  801e75:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801e79:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801e80:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801e85:	74 06                	je     801e8d <vsnprintf+0x65>
  801e87:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801e8b:	7f 07                	jg     801e94 <vsnprintf+0x6c>
		return -E_INVAL;
  801e8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e92:	eb 2f                	jmp    801ec3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801e94:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801e98:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801e9c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801ea0:	48 89 c6             	mov    %rax,%rsi
  801ea3:	48 bf db 1d 80 00 00 	movabs $0x801ddb,%rdi
  801eaa:	00 00 00 
  801ead:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  801eb4:	00 00 00 
  801eb7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801eb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ebd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801ec0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801ec3:	c9                   	leaveq 
  801ec4:	c3                   	retq   

0000000000801ec5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ec5:	55                   	push   %rbp
  801ec6:	48 89 e5             	mov    %rsp,%rbp
  801ec9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801ed0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801ed7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801edd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801ee4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801eeb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801ef2:	84 c0                	test   %al,%al
  801ef4:	74 20                	je     801f16 <snprintf+0x51>
  801ef6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801efa:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801efe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801f02:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801f06:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801f0a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801f0e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801f12:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801f16:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801f1d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801f24:	00 00 00 
  801f27:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801f2e:	00 00 00 
  801f31:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801f35:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801f3c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801f43:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801f4a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801f51:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801f58:	48 8b 0a             	mov    (%rdx),%rcx
  801f5b:	48 89 08             	mov    %rcx,(%rax)
  801f5e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f62:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f66:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f6a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801f6e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801f75:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801f7c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801f82:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801f89:	48 89 c7             	mov    %rax,%rdi
  801f8c:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  801f93:	00 00 00 
  801f96:	ff d0                	callq  *%rax
  801f98:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801f9e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801fa4:	c9                   	leaveq 
  801fa5:	c3                   	retq   

0000000000801fa6 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801fa6:	55                   	push   %rbp
  801fa7:	48 89 e5             	mov    %rsp,%rbp
  801faa:	48 83 ec 20          	sub    $0x20,%rsp
  801fae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801fb2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801fb7:	74 27                	je     801fe0 <readline+0x3a>
		fprintf(1, "%s", prompt);
  801fb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fbd:	48 89 c2             	mov    %rax,%rdx
  801fc0:	48 be 28 6f 80 00 00 	movabs $0x806f28,%rsi
  801fc7:	00 00 00 
  801fca:	bf 01 00 00 00       	mov    $0x1,%edi
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	48 b9 ed 48 80 00 00 	movabs $0x8048ed,%rcx
  801fdb:	00 00 00 
  801fde:	ff d1                	callq  *%rcx
#endif

	i = 0;
  801fe0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  801fe7:	bf 00 00 00 00       	mov    $0x0,%edi
  801fec:	48 b8 37 0f 80 00 00 	movabs $0x800f37,%rax
  801ff3:	00 00 00 
  801ff6:	ff d0                	callq  *%rax
  801ff8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  801ffb:	48 b8 ee 0e 80 00 00 	movabs $0x800eee,%rax
  802002:	00 00 00 
  802005:	ff d0                	callq  *%rax
  802007:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  80200a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80200e:	79 30                	jns    802040 <readline+0x9a>
			if (c != -E_EOF)
  802010:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  802014:	74 20                	je     802036 <readline+0x90>
				cprintf("read error: %e\n", c);
  802016:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802019:	89 c6                	mov    %eax,%esi
  80201b:	48 bf 2b 6f 80 00 00 	movabs $0x806f2b,%rdi
  802022:	00 00 00 
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
  80202a:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  802031:	00 00 00 
  802034:	ff d2                	callq  *%rdx
			return NULL;
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
  80203b:	e9 be 00 00 00       	jmpq   8020fe <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  802040:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  802044:	74 06                	je     80204c <readline+0xa6>
  802046:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  80204a:	75 26                	jne    802072 <readline+0xcc>
  80204c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802050:	7e 20                	jle    802072 <readline+0xcc>
			if (echoing)
  802052:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802056:	74 11                	je     802069 <readline+0xc3>
				cputchar('\b');
  802058:	bf 08 00 00 00       	mov    $0x8,%edi
  80205d:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  802064:	00 00 00 
  802067:	ff d0                	callq  *%rax
			i--;
  802069:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  80206d:	e9 87 00 00 00       	jmpq   8020f9 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  802072:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  802076:	7e 3f                	jle    8020b7 <readline+0x111>
  802078:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  80207f:	7f 36                	jg     8020b7 <readline+0x111>
			if (echoing)
  802081:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802085:	74 11                	je     802098 <readline+0xf2>
				cputchar(c);
  802087:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80208a:	89 c7                	mov    %eax,%edi
  80208c:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  802093:	00 00 00 
  802096:	ff d0                	callq  *%rax
			buf[i++] = c;
  802098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209b:	8d 50 01             	lea    0x1(%rax),%edx
  80209e:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8020a1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8020a4:	89 d1                	mov    %edx,%ecx
  8020a6:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  8020ad:	00 00 00 
  8020b0:	48 98                	cltq   
  8020b2:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8020b5:	eb 42                	jmp    8020f9 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8020b7:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8020bb:	74 06                	je     8020c3 <readline+0x11d>
  8020bd:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8020c1:	75 36                	jne    8020f9 <readline+0x153>
			if (echoing)
  8020c3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020c7:	74 11                	je     8020da <readline+0x134>
				cputchar('\n');
  8020c9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8020ce:	48 b8 c3 0e 80 00 00 	movabs $0x800ec3,%rax
  8020d5:	00 00 00 
  8020d8:	ff d0                	callq  *%rax
			buf[i] = 0;
  8020da:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  8020e1:	00 00 00 
  8020e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e7:	48 98                	cltq   
  8020e9:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8020ed:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8020f4:	00 00 00 
  8020f7:	eb 05                	jmp    8020fe <readline+0x158>
		}
	}
  8020f9:	e9 fd fe ff ff       	jmpq   801ffb <readline+0x55>
}
  8020fe:	c9                   	leaveq 
  8020ff:	c3                   	retq   

0000000000802100 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802100:	55                   	push   %rbp
  802101:	48 89 e5             	mov    %rsp,%rbp
  802104:	48 83 ec 18          	sub    $0x18,%rsp
  802108:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80210c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802113:	eb 09                	jmp    80211e <strlen+0x1e>
		n++;
  802115:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802119:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80211e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802122:	0f b6 00             	movzbl (%rax),%eax
  802125:	84 c0                	test   %al,%al
  802127:	75 ec                	jne    802115 <strlen+0x15>
		n++;
	return n;
  802129:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80212c:	c9                   	leaveq 
  80212d:	c3                   	retq   

000000000080212e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80212e:	55                   	push   %rbp
  80212f:	48 89 e5             	mov    %rsp,%rbp
  802132:	48 83 ec 20          	sub    $0x20,%rsp
  802136:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80213a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80213e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802145:	eb 0e                	jmp    802155 <strnlen+0x27>
		n++;
  802147:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80214b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802150:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802155:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80215a:	74 0b                	je     802167 <strnlen+0x39>
  80215c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802160:	0f b6 00             	movzbl (%rax),%eax
  802163:	84 c0                	test   %al,%al
  802165:	75 e0                	jne    802147 <strnlen+0x19>
		n++;
	return n;
  802167:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80216a:	c9                   	leaveq 
  80216b:	c3                   	retq   

000000000080216c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80216c:	55                   	push   %rbp
  80216d:	48 89 e5             	mov    %rsp,%rbp
  802170:	48 83 ec 20          	sub    $0x20,%rsp
  802174:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80217c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802180:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802184:	90                   	nop
  802185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802189:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80218d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802191:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802195:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802199:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80219d:	0f b6 12             	movzbl (%rdx),%edx
  8021a0:	88 10                	mov    %dl,(%rax)
  8021a2:	0f b6 00             	movzbl (%rax),%eax
  8021a5:	84 c0                	test   %al,%al
  8021a7:	75 dc                	jne    802185 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8021a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8021ad:	c9                   	leaveq 
  8021ae:	c3                   	retq   

00000000008021af <strcat>:

char *
strcat(char *dst, const char *src)
{
  8021af:	55                   	push   %rbp
  8021b0:	48 89 e5             	mov    %rsp,%rbp
  8021b3:	48 83 ec 20          	sub    $0x20,%rsp
  8021b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8021bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8021bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c3:	48 89 c7             	mov    %rax,%rdi
  8021c6:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  8021cd:	00 00 00 
  8021d0:	ff d0                	callq  *%rax
  8021d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8021d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d8:	48 63 d0             	movslq %eax,%rdx
  8021db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021df:	48 01 c2             	add    %rax,%rdx
  8021e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021e6:	48 89 c6             	mov    %rax,%rsi
  8021e9:	48 89 d7             	mov    %rdx,%rdi
  8021ec:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8021f3:	00 00 00 
  8021f6:	ff d0                	callq  *%rax
	return dst;
  8021f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8021fc:	c9                   	leaveq 
  8021fd:	c3                   	retq   

00000000008021fe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8021fe:	55                   	push   %rbp
  8021ff:	48 89 e5             	mov    %rsp,%rbp
  802202:	48 83 ec 28          	sub    $0x28,%rsp
  802206:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80220a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80220e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802216:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80221a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802221:	00 
  802222:	eb 2a                	jmp    80224e <strncpy+0x50>
		*dst++ = *src;
  802224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802228:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80222c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802230:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802234:	0f b6 12             	movzbl (%rdx),%edx
  802237:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802239:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80223d:	0f b6 00             	movzbl (%rax),%eax
  802240:	84 c0                	test   %al,%al
  802242:	74 05                	je     802249 <strncpy+0x4b>
			src++;
  802244:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802249:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80224e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802252:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802256:	72 cc                	jb     802224 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80225c:	c9                   	leaveq 
  80225d:	c3                   	retq   

000000000080225e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80225e:	55                   	push   %rbp
  80225f:	48 89 e5             	mov    %rsp,%rbp
  802262:	48 83 ec 28          	sub    $0x28,%rsp
  802266:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80226a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80226e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802276:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80227a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80227f:	74 3d                	je     8022be <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802281:	eb 1d                	jmp    8022a0 <strlcpy+0x42>
			*dst++ = *src++;
  802283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802287:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80228b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80228f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802293:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802297:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80229b:	0f b6 12             	movzbl (%rdx),%edx
  80229e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8022a0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8022a5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022aa:	74 0b                	je     8022b7 <strlcpy+0x59>
  8022ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022b0:	0f b6 00             	movzbl (%rax),%eax
  8022b3:	84 c0                	test   %al,%al
  8022b5:	75 cc                	jne    802283 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8022b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bb:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8022be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c6:	48 29 c2             	sub    %rax,%rdx
  8022c9:	48 89 d0             	mov    %rdx,%rax
}
  8022cc:	c9                   	leaveq 
  8022cd:	c3                   	retq   

00000000008022ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8022ce:	55                   	push   %rbp
  8022cf:	48 89 e5             	mov    %rsp,%rbp
  8022d2:	48 83 ec 10          	sub    $0x10,%rsp
  8022d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8022de:	eb 0a                	jmp    8022ea <strcmp+0x1c>
		p++, q++;
  8022e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8022e5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8022ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ee:	0f b6 00             	movzbl (%rax),%eax
  8022f1:	84 c0                	test   %al,%al
  8022f3:	74 12                	je     802307 <strcmp+0x39>
  8022f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f9:	0f b6 10             	movzbl (%rax),%edx
  8022fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802300:	0f b6 00             	movzbl (%rax),%eax
  802303:	38 c2                	cmp    %al,%dl
  802305:	74 d9                	je     8022e0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80230b:	0f b6 00             	movzbl (%rax),%eax
  80230e:	0f b6 d0             	movzbl %al,%edx
  802311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802315:	0f b6 00             	movzbl (%rax),%eax
  802318:	0f b6 c0             	movzbl %al,%eax
  80231b:	29 c2                	sub    %eax,%edx
  80231d:	89 d0                	mov    %edx,%eax
}
  80231f:	c9                   	leaveq 
  802320:	c3                   	retq   

0000000000802321 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802321:	55                   	push   %rbp
  802322:	48 89 e5             	mov    %rsp,%rbp
  802325:	48 83 ec 18          	sub    $0x18,%rsp
  802329:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80232d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802331:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802335:	eb 0f                	jmp    802346 <strncmp+0x25>
		n--, p++, q++;
  802337:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80233c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802341:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802346:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80234b:	74 1d                	je     80236a <strncmp+0x49>
  80234d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802351:	0f b6 00             	movzbl (%rax),%eax
  802354:	84 c0                	test   %al,%al
  802356:	74 12                	je     80236a <strncmp+0x49>
  802358:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80235c:	0f b6 10             	movzbl (%rax),%edx
  80235f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802363:	0f b6 00             	movzbl (%rax),%eax
  802366:	38 c2                	cmp    %al,%dl
  802368:	74 cd                	je     802337 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80236a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80236f:	75 07                	jne    802378 <strncmp+0x57>
		return 0;
  802371:	b8 00 00 00 00       	mov    $0x0,%eax
  802376:	eb 18                	jmp    802390 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80237c:	0f b6 00             	movzbl (%rax),%eax
  80237f:	0f b6 d0             	movzbl %al,%edx
  802382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802386:	0f b6 00             	movzbl (%rax),%eax
  802389:	0f b6 c0             	movzbl %al,%eax
  80238c:	29 c2                	sub    %eax,%edx
  80238e:	89 d0                	mov    %edx,%eax
}
  802390:	c9                   	leaveq 
  802391:	c3                   	retq   

0000000000802392 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802392:	55                   	push   %rbp
  802393:	48 89 e5             	mov    %rsp,%rbp
  802396:	48 83 ec 0c          	sub    $0xc,%rsp
  80239a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80239e:	89 f0                	mov    %esi,%eax
  8023a0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023a3:	eb 17                	jmp    8023bc <strchr+0x2a>
		if (*s == c)
  8023a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a9:	0f b6 00             	movzbl (%rax),%eax
  8023ac:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8023af:	75 06                	jne    8023b7 <strchr+0x25>
			return (char *) s;
  8023b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b5:	eb 15                	jmp    8023cc <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8023b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c0:	0f b6 00             	movzbl (%rax),%eax
  8023c3:	84 c0                	test   %al,%al
  8023c5:	75 de                	jne    8023a5 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cc:	c9                   	leaveq 
  8023cd:	c3                   	retq   

00000000008023ce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8023ce:	55                   	push   %rbp
  8023cf:	48 89 e5             	mov    %rsp,%rbp
  8023d2:	48 83 ec 0c          	sub    $0xc,%rsp
  8023d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023da:	89 f0                	mov    %esi,%eax
  8023dc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8023df:	eb 13                	jmp    8023f4 <strfind+0x26>
		if (*s == c)
  8023e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e5:	0f b6 00             	movzbl (%rax),%eax
  8023e8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8023eb:	75 02                	jne    8023ef <strfind+0x21>
			break;
  8023ed:	eb 10                	jmp    8023ff <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8023ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f8:	0f b6 00             	movzbl (%rax),%eax
  8023fb:	84 c0                	test   %al,%al
  8023fd:	75 e2                	jne    8023e1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8023ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802403:	c9                   	leaveq 
  802404:	c3                   	retq   

0000000000802405 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802405:	55                   	push   %rbp
  802406:	48 89 e5             	mov    %rsp,%rbp
  802409:	48 83 ec 18          	sub    $0x18,%rsp
  80240d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802411:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802414:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802418:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80241d:	75 06                	jne    802425 <memset+0x20>
		return v;
  80241f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802423:	eb 69                	jmp    80248e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802429:	83 e0 03             	and    $0x3,%eax
  80242c:	48 85 c0             	test   %rax,%rax
  80242f:	75 48                	jne    802479 <memset+0x74>
  802431:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802435:	83 e0 03             	and    $0x3,%eax
  802438:	48 85 c0             	test   %rax,%rax
  80243b:	75 3c                	jne    802479 <memset+0x74>
		c &= 0xFF;
  80243d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802444:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802447:	c1 e0 18             	shl    $0x18,%eax
  80244a:	89 c2                	mov    %eax,%edx
  80244c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80244f:	c1 e0 10             	shl    $0x10,%eax
  802452:	09 c2                	or     %eax,%edx
  802454:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802457:	c1 e0 08             	shl    $0x8,%eax
  80245a:	09 d0                	or     %edx,%eax
  80245c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80245f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802463:	48 c1 e8 02          	shr    $0x2,%rax
  802467:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80246a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80246e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802471:	48 89 d7             	mov    %rdx,%rdi
  802474:	fc                   	cld    
  802475:	f3 ab                	rep stos %eax,%es:(%rdi)
  802477:	eb 11                	jmp    80248a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802479:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80247d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802480:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802484:	48 89 d7             	mov    %rdx,%rdi
  802487:	fc                   	cld    
  802488:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80248a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80248e:	c9                   	leaveq 
  80248f:	c3                   	retq   

0000000000802490 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802490:	55                   	push   %rbp
  802491:	48 89 e5             	mov    %rsp,%rbp
  802494:	48 83 ec 28          	sub    $0x28,%rsp
  802498:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80249c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8024a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8024ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8024b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024b8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024bc:	0f 83 88 00 00 00    	jae    80254a <memmove+0xba>
  8024c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024ca:	48 01 d0             	add    %rdx,%rax
  8024cd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8024d1:	76 77                	jbe    80254a <memmove+0xba>
		s += n;
  8024d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8024db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024df:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8024e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e7:	83 e0 03             	and    $0x3,%eax
  8024ea:	48 85 c0             	test   %rax,%rax
  8024ed:	75 3b                	jne    80252a <memmove+0x9a>
  8024ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f3:	83 e0 03             	and    $0x3,%eax
  8024f6:	48 85 c0             	test   %rax,%rax
  8024f9:	75 2f                	jne    80252a <memmove+0x9a>
  8024fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024ff:	83 e0 03             	and    $0x3,%eax
  802502:	48 85 c0             	test   %rax,%rax
  802505:	75 23                	jne    80252a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250b:	48 83 e8 04          	sub    $0x4,%rax
  80250f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802513:	48 83 ea 04          	sub    $0x4,%rdx
  802517:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80251b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80251f:	48 89 c7             	mov    %rax,%rdi
  802522:	48 89 d6             	mov    %rdx,%rsi
  802525:	fd                   	std    
  802526:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802528:	eb 1d                	jmp    802547 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80252a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802536:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80253a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80253e:	48 89 d7             	mov    %rdx,%rdi
  802541:	48 89 c1             	mov    %rax,%rcx
  802544:	fd                   	std    
  802545:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802547:	fc                   	cld    
  802548:	eb 57                	jmp    8025a1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80254a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254e:	83 e0 03             	and    $0x3,%eax
  802551:	48 85 c0             	test   %rax,%rax
  802554:	75 36                	jne    80258c <memmove+0xfc>
  802556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255a:	83 e0 03             	and    $0x3,%eax
  80255d:	48 85 c0             	test   %rax,%rax
  802560:	75 2a                	jne    80258c <memmove+0xfc>
  802562:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802566:	83 e0 03             	and    $0x3,%eax
  802569:	48 85 c0             	test   %rax,%rax
  80256c:	75 1e                	jne    80258c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80256e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802572:	48 c1 e8 02          	shr    $0x2,%rax
  802576:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802581:	48 89 c7             	mov    %rax,%rdi
  802584:	48 89 d6             	mov    %rdx,%rsi
  802587:	fc                   	cld    
  802588:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80258a:	eb 15                	jmp    8025a1 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80258c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802590:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802594:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802598:	48 89 c7             	mov    %rax,%rdi
  80259b:	48 89 d6             	mov    %rdx,%rsi
  80259e:	fc                   	cld    
  80259f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8025a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8025a5:	c9                   	leaveq 
  8025a6:	c3                   	retq   

00000000008025a7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8025a7:	55                   	push   %rbp
  8025a8:	48 89 e5             	mov    %rsp,%rbp
  8025ab:	48 83 ec 18          	sub    $0x18,%rsp
  8025af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8025b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8025bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025bf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8025c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c7:	48 89 ce             	mov    %rcx,%rsi
  8025ca:	48 89 c7             	mov    %rax,%rdi
  8025cd:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	callq  *%rax
}
  8025d9:	c9                   	leaveq 
  8025da:	c3                   	retq   

00000000008025db <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8025db:	55                   	push   %rbp
  8025dc:	48 89 e5             	mov    %rsp,%rbp
  8025df:	48 83 ec 28          	sub    $0x28,%rsp
  8025e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8025ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8025f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8025ff:	eb 36                	jmp    802637 <memcmp+0x5c>
		if (*s1 != *s2)
  802601:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802605:	0f b6 10             	movzbl (%rax),%edx
  802608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260c:	0f b6 00             	movzbl (%rax),%eax
  80260f:	38 c2                	cmp    %al,%dl
  802611:	74 1a                	je     80262d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  802613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802617:	0f b6 00             	movzbl (%rax),%eax
  80261a:	0f b6 d0             	movzbl %al,%edx
  80261d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802621:	0f b6 00             	movzbl (%rax),%eax
  802624:	0f b6 c0             	movzbl %al,%eax
  802627:	29 c2                	sub    %eax,%edx
  802629:	89 d0                	mov    %edx,%eax
  80262b:	eb 20                	jmp    80264d <memcmp+0x72>
		s1++, s2++;
  80262d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802632:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80263b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80263f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802643:	48 85 c0             	test   %rax,%rax
  802646:	75 b9                	jne    802601 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264d:	c9                   	leaveq 
  80264e:	c3                   	retq   

000000000080264f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80264f:	55                   	push   %rbp
  802650:	48 89 e5             	mov    %rsp,%rbp
  802653:	48 83 ec 28          	sub    $0x28,%rsp
  802657:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80265b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80265e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80266a:	48 01 d0             	add    %rdx,%rax
  80266d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802671:	eb 15                	jmp    802688 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802677:	0f b6 10             	movzbl (%rax),%edx
  80267a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80267d:	38 c2                	cmp    %al,%dl
  80267f:	75 02                	jne    802683 <memfind+0x34>
			break;
  802681:	eb 0f                	jmp    802692 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802683:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802688:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802690:	72 e1                	jb     802673 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802696:	c9                   	leaveq 
  802697:	c3                   	retq   

0000000000802698 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802698:	55                   	push   %rbp
  802699:	48 89 e5             	mov    %rsp,%rbp
  80269c:	48 83 ec 34          	sub    $0x34,%rsp
  8026a0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026a4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026a8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8026ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8026b2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8026b9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026ba:	eb 05                	jmp    8026c1 <strtol+0x29>
		s++;
  8026bc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8026c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c5:	0f b6 00             	movzbl (%rax),%eax
  8026c8:	3c 20                	cmp    $0x20,%al
  8026ca:	74 f0                	je     8026bc <strtol+0x24>
  8026cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026d0:	0f b6 00             	movzbl (%rax),%eax
  8026d3:	3c 09                	cmp    $0x9,%al
  8026d5:	74 e5                	je     8026bc <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8026d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026db:	0f b6 00             	movzbl (%rax),%eax
  8026de:	3c 2b                	cmp    $0x2b,%al
  8026e0:	75 07                	jne    8026e9 <strtol+0x51>
		s++;
  8026e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8026e7:	eb 17                	jmp    802700 <strtol+0x68>
	else if (*s == '-')
  8026e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ed:	0f b6 00             	movzbl (%rax),%eax
  8026f0:	3c 2d                	cmp    $0x2d,%al
  8026f2:	75 0c                	jne    802700 <strtol+0x68>
		s++, neg = 1;
  8026f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8026f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802700:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802704:	74 06                	je     80270c <strtol+0x74>
  802706:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80270a:	75 28                	jne    802734 <strtol+0x9c>
  80270c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802710:	0f b6 00             	movzbl (%rax),%eax
  802713:	3c 30                	cmp    $0x30,%al
  802715:	75 1d                	jne    802734 <strtol+0x9c>
  802717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80271b:	48 83 c0 01          	add    $0x1,%rax
  80271f:	0f b6 00             	movzbl (%rax),%eax
  802722:	3c 78                	cmp    $0x78,%al
  802724:	75 0e                	jne    802734 <strtol+0x9c>
		s += 2, base = 16;
  802726:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80272b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802732:	eb 2c                	jmp    802760 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802734:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802738:	75 19                	jne    802753 <strtol+0xbb>
  80273a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80273e:	0f b6 00             	movzbl (%rax),%eax
  802741:	3c 30                	cmp    $0x30,%al
  802743:	75 0e                	jne    802753 <strtol+0xbb>
		s++, base = 8;
  802745:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80274a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802751:	eb 0d                	jmp    802760 <strtol+0xc8>
	else if (base == 0)
  802753:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802757:	75 07                	jne    802760 <strtol+0xc8>
		base = 10;
  802759:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802764:	0f b6 00             	movzbl (%rax),%eax
  802767:	3c 2f                	cmp    $0x2f,%al
  802769:	7e 1d                	jle    802788 <strtol+0xf0>
  80276b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276f:	0f b6 00             	movzbl (%rax),%eax
  802772:	3c 39                	cmp    $0x39,%al
  802774:	7f 12                	jg     802788 <strtol+0xf0>
			dig = *s - '0';
  802776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80277a:	0f b6 00             	movzbl (%rax),%eax
  80277d:	0f be c0             	movsbl %al,%eax
  802780:	83 e8 30             	sub    $0x30,%eax
  802783:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802786:	eb 4e                	jmp    8027d6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802788:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80278c:	0f b6 00             	movzbl (%rax),%eax
  80278f:	3c 60                	cmp    $0x60,%al
  802791:	7e 1d                	jle    8027b0 <strtol+0x118>
  802793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802797:	0f b6 00             	movzbl (%rax),%eax
  80279a:	3c 7a                	cmp    $0x7a,%al
  80279c:	7f 12                	jg     8027b0 <strtol+0x118>
			dig = *s - 'a' + 10;
  80279e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027a2:	0f b6 00             	movzbl (%rax),%eax
  8027a5:	0f be c0             	movsbl %al,%eax
  8027a8:	83 e8 57             	sub    $0x57,%eax
  8027ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8027ae:	eb 26                	jmp    8027d6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8027b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b4:	0f b6 00             	movzbl (%rax),%eax
  8027b7:	3c 40                	cmp    $0x40,%al
  8027b9:	7e 48                	jle    802803 <strtol+0x16b>
  8027bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027bf:	0f b6 00             	movzbl (%rax),%eax
  8027c2:	3c 5a                	cmp    $0x5a,%al
  8027c4:	7f 3d                	jg     802803 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8027c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ca:	0f b6 00             	movzbl (%rax),%eax
  8027cd:	0f be c0             	movsbl %al,%eax
  8027d0:	83 e8 37             	sub    $0x37,%eax
  8027d3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8027d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027d9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8027dc:	7c 02                	jl     8027e0 <strtol+0x148>
			break;
  8027de:	eb 23                	jmp    802803 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8027e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027e8:	48 98                	cltq   
  8027ea:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8027ef:	48 89 c2             	mov    %rax,%rdx
  8027f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027f5:	48 98                	cltq   
  8027f7:	48 01 d0             	add    %rdx,%rax
  8027fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8027fe:	e9 5d ff ff ff       	jmpq   802760 <strtol+0xc8>

	if (endptr)
  802803:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802808:	74 0b                	je     802815 <strtol+0x17d>
		*endptr = (char *) s;
  80280a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80280e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802812:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  802815:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802819:	74 09                	je     802824 <strtol+0x18c>
  80281b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80281f:	48 f7 d8             	neg    %rax
  802822:	eb 04                	jmp    802828 <strtol+0x190>
  802824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802828:	c9                   	leaveq 
  802829:	c3                   	retq   

000000000080282a <strstr>:

char * strstr(const char *in, const char *str)
{
  80282a:	55                   	push   %rbp
  80282b:	48 89 e5             	mov    %rsp,%rbp
  80282e:	48 83 ec 30          	sub    $0x30,%rsp
  802832:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802836:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80283a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80283e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802842:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802846:	0f b6 00             	movzbl (%rax),%eax
  802849:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80284c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802850:	75 06                	jne    802858 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  802852:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802856:	eb 6b                	jmp    8028c3 <strstr+0x99>

	len = strlen(str);
  802858:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80285c:	48 89 c7             	mov    %rax,%rdi
  80285f:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  802866:	00 00 00 
  802869:	ff d0                	callq  *%rax
  80286b:	48 98                	cltq   
  80286d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  802871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802875:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802879:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80287d:	0f b6 00             	movzbl (%rax),%eax
  802880:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  802883:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802887:	75 07                	jne    802890 <strstr+0x66>
				return (char *) 0;
  802889:	b8 00 00 00 00       	mov    $0x0,%eax
  80288e:	eb 33                	jmp    8028c3 <strstr+0x99>
		} while (sc != c);
  802890:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802894:	3a 45 ff             	cmp    -0x1(%rbp),%al
  802897:	75 d8                	jne    802871 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  802899:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80289d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a5:	48 89 ce             	mov    %rcx,%rsi
  8028a8:	48 89 c7             	mov    %rax,%rdi
  8028ab:	48 b8 21 23 80 00 00 	movabs $0x802321,%rax
  8028b2:	00 00 00 
  8028b5:	ff d0                	callq  *%rax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	75 b6                	jne    802871 <strstr+0x47>

	return (char *) (in - 1);
  8028bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028bf:	48 83 e8 01          	sub    $0x1,%rax
}
  8028c3:	c9                   	leaveq 
  8028c4:	c3                   	retq   

00000000008028c5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8028c5:	55                   	push   %rbp
  8028c6:	48 89 e5             	mov    %rsp,%rbp
  8028c9:	53                   	push   %rbx
  8028ca:	48 83 ec 48          	sub    $0x48,%rsp
  8028ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028d1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8028d4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8028d8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8028dc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8028e0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028e4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028e7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8028eb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8028ef:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8028f3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8028f7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8028fb:	4c 89 c3             	mov    %r8,%rbx
  8028fe:	cd 30                	int    $0x30
  802900:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802904:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802908:	74 3e                	je     802948 <syscall+0x83>
  80290a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80290f:	7e 37                	jle    802948 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802911:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802915:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802918:	49 89 d0             	mov    %rdx,%r8
  80291b:	89 c1                	mov    %eax,%ecx
  80291d:	48 ba 3b 6f 80 00 00 	movabs $0x806f3b,%rdx
  802924:	00 00 00 
  802927:	be 23 00 00 00       	mov    $0x23,%esi
  80292c:	48 bf 58 6f 80 00 00 	movabs $0x806f58,%rdi
  802933:	00 00 00 
  802936:	b8 00 00 00 00       	mov    $0x0,%eax
  80293b:	49 b9 24 12 80 00 00 	movabs $0x801224,%r9
  802942:	00 00 00 
  802945:	41 ff d1             	callq  *%r9

	return ret;
  802948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80294c:	48 83 c4 48          	add    $0x48,%rsp
  802950:	5b                   	pop    %rbx
  802951:	5d                   	pop    %rbp
  802952:	c3                   	retq   

0000000000802953 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802953:	55                   	push   %rbp
  802954:	48 89 e5             	mov    %rsp,%rbp
  802957:	48 83 ec 20          	sub    $0x20,%rsp
  80295b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80295f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802963:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802967:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80296b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802972:	00 
  802973:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802979:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80297f:	48 89 d1             	mov    %rdx,%rcx
  802982:	48 89 c2             	mov    %rax,%rdx
  802985:	be 00 00 00 00       	mov    $0x0,%esi
  80298a:	bf 00 00 00 00       	mov    $0x0,%edi
  80298f:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802996:	00 00 00 
  802999:	ff d0                	callq  *%rax
}
  80299b:	c9                   	leaveq 
  80299c:	c3                   	retq   

000000000080299d <sys_cgetc>:

int
sys_cgetc(void)
{
  80299d:	55                   	push   %rbp
  80299e:	48 89 e5             	mov    %rsp,%rbp
  8029a1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8029a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029ac:	00 
  8029ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8029b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8029b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8029be:	ba 00 00 00 00       	mov    $0x0,%edx
  8029c3:	be 00 00 00 00       	mov    $0x0,%esi
  8029c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8029cd:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  8029d4:	00 00 00 
  8029d7:	ff d0                	callq  *%rax
}
  8029d9:	c9                   	leaveq 
  8029da:	c3                   	retq   

00000000008029db <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8029db:	55                   	push   %rbp
  8029dc:	48 89 e5             	mov    %rsp,%rbp
  8029df:	48 83 ec 10          	sub    $0x10,%rsp
  8029e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8029e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e9:	48 98                	cltq   
  8029eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8029f2:	00 
  8029f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8029f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8029ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a04:	48 89 c2             	mov    %rax,%rdx
  802a07:	be 01 00 00 00       	mov    $0x1,%esi
  802a0c:	bf 03 00 00 00       	mov    $0x3,%edi
  802a11:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802a18:	00 00 00 
  802a1b:	ff d0                	callq  *%rax
}
  802a1d:	c9                   	leaveq 
  802a1e:	c3                   	retq   

0000000000802a1f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802a1f:	55                   	push   %rbp
  802a20:	48 89 e5             	mov    %rsp,%rbp
  802a23:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802a27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a2e:	00 
  802a2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a40:	ba 00 00 00 00       	mov    $0x0,%edx
  802a45:	be 00 00 00 00       	mov    $0x0,%esi
  802a4a:	bf 02 00 00 00       	mov    $0x2,%edi
  802a4f:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802a56:	00 00 00 
  802a59:	ff d0                	callq  *%rax
}
  802a5b:	c9                   	leaveq 
  802a5c:	c3                   	retq   

0000000000802a5d <sys_yield>:

void
sys_yield(void)
{
  802a5d:	55                   	push   %rbp
  802a5e:	48 89 e5             	mov    %rsp,%rbp
  802a61:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802a65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802a6c:	00 
  802a6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a79:	b9 00 00 00 00       	mov    $0x0,%ecx
  802a7e:	ba 00 00 00 00       	mov    $0x0,%edx
  802a83:	be 00 00 00 00       	mov    $0x0,%esi
  802a88:	bf 0b 00 00 00       	mov    $0xb,%edi
  802a8d:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802a94:	00 00 00 
  802a97:	ff d0                	callq  *%rax
}
  802a99:	c9                   	leaveq 
  802a9a:	c3                   	retq   

0000000000802a9b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802a9b:	55                   	push   %rbp
  802a9c:	48 89 e5             	mov    %rsp,%rbp
  802a9f:	48 83 ec 20          	sub    $0x20,%rsp
  802aa3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802aa6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802aaa:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802aad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ab0:	48 63 c8             	movslq %eax,%rcx
  802ab3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ab7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aba:	48 98                	cltq   
  802abc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802ac3:	00 
  802ac4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802aca:	49 89 c8             	mov    %rcx,%r8
  802acd:	48 89 d1             	mov    %rdx,%rcx
  802ad0:	48 89 c2             	mov    %rax,%rdx
  802ad3:	be 01 00 00 00       	mov    $0x1,%esi
  802ad8:	bf 04 00 00 00       	mov    $0x4,%edi
  802add:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802ae4:	00 00 00 
  802ae7:	ff d0                	callq  *%rax
}
  802ae9:	c9                   	leaveq 
  802aea:	c3                   	retq   

0000000000802aeb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802aeb:	55                   	push   %rbp
  802aec:	48 89 e5             	mov    %rsp,%rbp
  802aef:	48 83 ec 30          	sub    $0x30,%rsp
  802af3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802af6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802afa:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802afd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802b01:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802b05:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b08:	48 63 c8             	movslq %eax,%rcx
  802b0b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802b0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b12:	48 63 f0             	movslq %eax,%rsi
  802b15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1c:	48 98                	cltq   
  802b1e:	48 89 0c 24          	mov    %rcx,(%rsp)
  802b22:	49 89 f9             	mov    %rdi,%r9
  802b25:	49 89 f0             	mov    %rsi,%r8
  802b28:	48 89 d1             	mov    %rdx,%rcx
  802b2b:	48 89 c2             	mov    %rax,%rdx
  802b2e:	be 01 00 00 00       	mov    $0x1,%esi
  802b33:	bf 05 00 00 00       	mov    $0x5,%edi
  802b38:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
}
  802b44:	c9                   	leaveq 
  802b45:	c3                   	retq   

0000000000802b46 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802b46:	55                   	push   %rbp
  802b47:	48 89 e5             	mov    %rsp,%rbp
  802b4a:	48 83 ec 20          	sub    $0x20,%rsp
  802b4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802b55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5c:	48 98                	cltq   
  802b5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802b65:	00 
  802b66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b72:	48 89 d1             	mov    %rdx,%rcx
  802b75:	48 89 c2             	mov    %rax,%rdx
  802b78:	be 01 00 00 00       	mov    $0x1,%esi
  802b7d:	bf 06 00 00 00       	mov    $0x6,%edi
  802b82:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802b89:	00 00 00 
  802b8c:	ff d0                	callq  *%rax
}
  802b8e:	c9                   	leaveq 
  802b8f:	c3                   	retq   

0000000000802b90 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802b90:	55                   	push   %rbp
  802b91:	48 89 e5             	mov    %rsp,%rbp
  802b94:	48 83 ec 10          	sub    $0x10,%rsp
  802b98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b9b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802b9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ba1:	48 63 d0             	movslq %eax,%rdx
  802ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba7:	48 98                	cltq   
  802ba9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bb0:	00 
  802bb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802bbd:	48 89 d1             	mov    %rdx,%rcx
  802bc0:	48 89 c2             	mov    %rax,%rdx
  802bc3:	be 01 00 00 00       	mov    $0x1,%esi
  802bc8:	bf 08 00 00 00       	mov    $0x8,%edi
  802bcd:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802bd4:	00 00 00 
  802bd7:	ff d0                	callq  *%rax
}
  802bd9:	c9                   	leaveq 
  802bda:	c3                   	retq   

0000000000802bdb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802bdb:	55                   	push   %rbp
  802bdc:	48 89 e5             	mov    %rsp,%rbp
  802bdf:	48 83 ec 20          	sub    $0x20,%rsp
  802be3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802be6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802bea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf1:	48 98                	cltq   
  802bf3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802bfa:	00 
  802bfb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c07:	48 89 d1             	mov    %rdx,%rcx
  802c0a:	48 89 c2             	mov    %rax,%rdx
  802c0d:	be 01 00 00 00       	mov    $0x1,%esi
  802c12:	bf 09 00 00 00       	mov    $0x9,%edi
  802c17:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
}
  802c23:	c9                   	leaveq 
  802c24:	c3                   	retq   

0000000000802c25 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802c25:	55                   	push   %rbp
  802c26:	48 89 e5             	mov    %rsp,%rbp
  802c29:	48 83 ec 20          	sub    $0x20,%rsp
  802c2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c30:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802c34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3b:	48 98                	cltq   
  802c3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c44:	00 
  802c45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c51:	48 89 d1             	mov    %rdx,%rcx
  802c54:	48 89 c2             	mov    %rax,%rdx
  802c57:	be 01 00 00 00       	mov    $0x1,%esi
  802c5c:	bf 0a 00 00 00       	mov    $0xa,%edi
  802c61:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802c68:	00 00 00 
  802c6b:	ff d0                	callq  *%rax
}
  802c6d:	c9                   	leaveq 
  802c6e:	c3                   	retq   

0000000000802c6f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802c6f:	55                   	push   %rbp
  802c70:	48 89 e5             	mov    %rsp,%rbp
  802c73:	48 83 ec 20          	sub    $0x20,%rsp
  802c77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c7e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c82:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802c85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c88:	48 63 f0             	movslq %eax,%rsi
  802c8b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c92:	48 98                	cltq   
  802c94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c98:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802c9f:	00 
  802ca0:	49 89 f1             	mov    %rsi,%r9
  802ca3:	49 89 c8             	mov    %rcx,%r8
  802ca6:	48 89 d1             	mov    %rdx,%rcx
  802ca9:	48 89 c2             	mov    %rax,%rdx
  802cac:	be 00 00 00 00       	mov    $0x0,%esi
  802cb1:	bf 0c 00 00 00       	mov    $0xc,%edi
  802cb6:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802cbd:	00 00 00 
  802cc0:	ff d0                	callq  *%rax
}
  802cc2:	c9                   	leaveq 
  802cc3:	c3                   	retq   

0000000000802cc4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802cc4:	55                   	push   %rbp
  802cc5:	48 89 e5             	mov    %rsp,%rbp
  802cc8:	48 83 ec 10          	sub    $0x10,%rsp
  802ccc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802cd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802cdb:	00 
  802cdc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ce2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ce8:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ced:	48 89 c2             	mov    %rax,%rdx
  802cf0:	be 01 00 00 00       	mov    $0x1,%esi
  802cf5:	bf 0d 00 00 00       	mov    $0xd,%edi
  802cfa:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802d01:	00 00 00 
  802d04:	ff d0                	callq  *%rax
}
  802d06:	c9                   	leaveq 
  802d07:	c3                   	retq   

0000000000802d08 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  802d08:	55                   	push   %rbp
  802d09:	48 89 e5             	mov    %rsp,%rbp
  802d0c:	48 83 ec 20          	sub    $0x20,%rsp
  802d10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  802d18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d20:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d27:	00 
  802d28:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d2e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d34:	48 89 d1             	mov    %rdx,%rcx
  802d37:	48 89 c2             	mov    %rax,%rdx
  802d3a:	be 01 00 00 00       	mov    $0x1,%esi
  802d3f:	bf 0f 00 00 00       	mov    $0xf,%edi
  802d44:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802d4b:	00 00 00 
  802d4e:	ff d0                	callq  *%rax
}
  802d50:	c9                   	leaveq 
  802d51:	c3                   	retq   

0000000000802d52 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  802d52:	55                   	push   %rbp
  802d53:	48 89 e5             	mov    %rsp,%rbp
  802d56:	48 83 ec 10          	sub    $0x10,%rsp
  802d5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  802d5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d62:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802d69:	00 
  802d6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d70:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d76:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d7b:	48 89 c2             	mov    %rax,%rdx
  802d7e:	be 00 00 00 00       	mov    $0x0,%esi
  802d83:	bf 10 00 00 00       	mov    $0x10,%edi
  802d88:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802d8f:	00 00 00 
  802d92:	ff d0                	callq  *%rax
}
  802d94:	c9                   	leaveq 
  802d95:	c3                   	retq   

0000000000802d96 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802d96:	55                   	push   %rbp
  802d97:	48 89 e5             	mov    %rsp,%rbp
  802d9a:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802d9e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802da5:	00 
  802da6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802dac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802db2:	b9 00 00 00 00       	mov    $0x0,%ecx
  802db7:	ba 00 00 00 00       	mov    $0x0,%edx
  802dbc:	be 00 00 00 00       	mov    $0x0,%esi
  802dc1:	bf 0e 00 00 00       	mov    $0xe,%edi
  802dc6:	48 b8 c5 28 80 00 00 	movabs $0x8028c5,%rax
  802dcd:	00 00 00 
  802dd0:	ff d0                	callq  *%rax
}
  802dd2:	c9                   	leaveq 
  802dd3:	c3                   	retq   

0000000000802dd4 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  802dd4:	55                   	push   %rbp
  802dd5:	48 89 e5             	mov    %rsp,%rbp
  802dd8:	48 83 ec 30          	sub    $0x30,%rsp
  802ddc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802de0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802de4:	48 8b 00             	mov    (%rax),%rax
  802de7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802deb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802def:	48 8b 40 08          	mov    0x8(%rax),%rax
  802df3:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  802df6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802df9:	83 e0 02             	and    $0x2,%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	75 4d                	jne    802e4d <pgfault+0x79>
  802e00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e04:	48 c1 e8 0c          	shr    $0xc,%rax
  802e08:	48 89 c2             	mov    %rax,%rdx
  802e0b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e12:	01 00 00 
  802e15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e19:	25 00 08 00 00       	and    $0x800,%eax
  802e1e:	48 85 c0             	test   %rax,%rax
  802e21:	74 2a                	je     802e4d <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  802e23:	48 ba 68 6f 80 00 00 	movabs $0x806f68,%rdx
  802e2a:	00 00 00 
  802e2d:	be 23 00 00 00       	mov    $0x23,%esi
  802e32:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  802e39:	00 00 00 
  802e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e41:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  802e48:	00 00 00 
  802e4b:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  802e4d:	ba 07 00 00 00       	mov    $0x7,%edx
  802e52:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802e57:	bf 00 00 00 00       	mov    $0x0,%edi
  802e5c:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	0f 85 cd 00 00 00    	jne    802f3d <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  802e70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802e78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802e82:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  802e86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e8a:	ba 00 10 00 00       	mov    $0x1000,%edx
  802e8f:	48 89 c6             	mov    %rax,%rsi
  802e92:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802e97:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  802ea3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ea7:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802ead:	48 89 c1             	mov    %rax,%rcx
  802eb0:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb5:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802eba:	bf 00 00 00 00       	mov    $0x0,%edi
  802ebf:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802ec6:	00 00 00 
  802ec9:	ff d0                	callq  *%rax
  802ecb:	85 c0                	test   %eax,%eax
  802ecd:	79 2a                	jns    802ef9 <pgfault+0x125>
				panic("Page map at temp address failed");
  802ecf:	48 ba a8 6f 80 00 00 	movabs $0x806fa8,%rdx
  802ed6:	00 00 00 
  802ed9:	be 30 00 00 00       	mov    $0x30,%esi
  802ede:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  802ee5:	00 00 00 
  802ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  802eed:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  802ef4:	00 00 00 
  802ef7:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802ef9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802efe:	bf 00 00 00 00       	mov    $0x0,%edi
  802f03:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  802f0a:	00 00 00 
  802f0d:	ff d0                	callq  *%rax
  802f0f:	85 c0                	test   %eax,%eax
  802f11:	79 54                	jns    802f67 <pgfault+0x193>
				panic("Page unmap from temp location failed");
  802f13:	48 ba c8 6f 80 00 00 	movabs $0x806fc8,%rdx
  802f1a:	00 00 00 
  802f1d:	be 32 00 00 00       	mov    $0x32,%esi
  802f22:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  802f29:	00 00 00 
  802f2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f31:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  802f38:	00 00 00 
  802f3b:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  802f3d:	48 ba f0 6f 80 00 00 	movabs $0x806ff0,%rdx
  802f44:	00 00 00 
  802f47:	be 34 00 00 00       	mov    $0x34,%esi
  802f4c:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  802f53:	00 00 00 
  802f56:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5b:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  802f62:	00 00 00 
  802f65:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  802f67:	c9                   	leaveq 
  802f68:	c3                   	retq   

0000000000802f69 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802f69:	55                   	push   %rbp
  802f6a:	48 89 e5             	mov    %rsp,%rbp
  802f6d:	48 83 ec 20          	sub    $0x20,%rsp
  802f71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f74:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  802f77:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f7e:	01 00 00 
  802f81:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f84:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f88:	25 07 0e 00 00       	and    $0xe07,%eax
  802f8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802f90:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f93:	48 c1 e0 0c          	shl    $0xc,%rax
  802f97:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802f9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9e:	25 00 04 00 00       	and    $0x400,%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	74 57                	je     802ffe <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  802fa7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802faa:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802fae:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fb1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb5:	41 89 f0             	mov    %esi,%r8d
  802fb8:	48 89 c6             	mov    %rax,%rsi
  802fbb:	bf 00 00 00 00       	mov    $0x0,%edi
  802fc0:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  802fc7:	00 00 00 
  802fca:	ff d0                	callq  *%rax
  802fcc:	85 c0                	test   %eax,%eax
  802fce:	0f 8e 52 01 00 00    	jle    803126 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802fd4:	48 ba 22 70 80 00 00 	movabs $0x807022,%rdx
  802fdb:	00 00 00 
  802fde:	be 4e 00 00 00       	mov    $0x4e,%esi
  802fe3:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  802fea:	00 00 00 
  802fed:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff2:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  802ff9:	00 00 00 
  802ffc:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802ffe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803001:	83 e0 02             	and    $0x2,%eax
  803004:	85 c0                	test   %eax,%eax
  803006:	75 10                	jne    803018 <duppage+0xaf>
  803008:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300b:	25 00 08 00 00       	and    $0x800,%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	0f 84 bb 00 00 00    	je     8030d3 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  803018:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80301b:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  803020:	80 cc 08             	or     $0x8,%ah
  803023:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  803026:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803029:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80302d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803030:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803034:	41 89 f0             	mov    %esi,%r8d
  803037:	48 89 c6             	mov    %rax,%rsi
  80303a:	bf 00 00 00 00       	mov    $0x0,%edi
  80303f:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  803046:	00 00 00 
  803049:	ff d0                	callq  *%rax
  80304b:	85 c0                	test   %eax,%eax
  80304d:	7e 2a                	jle    803079 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  80304f:	48 ba 22 70 80 00 00 	movabs $0x807022,%rdx
  803056:	00 00 00 
  803059:	be 55 00 00 00       	mov    $0x55,%esi
  80305e:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  803065:	00 00 00 
  803068:	b8 00 00 00 00       	mov    $0x0,%eax
  80306d:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  803074:	00 00 00 
  803077:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  803079:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80307c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803080:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803084:	41 89 c8             	mov    %ecx,%r8d
  803087:	48 89 d1             	mov    %rdx,%rcx
  80308a:	ba 00 00 00 00       	mov    $0x0,%edx
  80308f:	48 89 c6             	mov    %rax,%rsi
  803092:	bf 00 00 00 00       	mov    $0x0,%edi
  803097:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  80309e:	00 00 00 
  8030a1:	ff d0                	callq  *%rax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	7e 2a                	jle    8030d1 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  8030a7:	48 ba 22 70 80 00 00 	movabs $0x807022,%rdx
  8030ae:	00 00 00 
  8030b1:	be 57 00 00 00       	mov    $0x57,%esi
  8030b6:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  8030bd:	00 00 00 
  8030c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c5:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  8030cc:	00 00 00 
  8030cf:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8030d1:	eb 53                	jmp    803126 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8030d3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8030d6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8030da:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e1:	41 89 f0             	mov    %esi,%r8d
  8030e4:	48 89 c6             	mov    %rax,%rsi
  8030e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ec:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  8030f3:	00 00 00 
  8030f6:	ff d0                	callq  *%rax
  8030f8:	85 c0                	test   %eax,%eax
  8030fa:	7e 2a                	jle    803126 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8030fc:	48 ba 22 70 80 00 00 	movabs $0x807022,%rdx
  803103:	00 00 00 
  803106:	be 5b 00 00 00       	mov    $0x5b,%esi
  80310b:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  803112:	00 00 00 
  803115:	b8 00 00 00 00       	mov    $0x0,%eax
  80311a:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  803121:	00 00 00 
  803124:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  803126:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80312b:	c9                   	leaveq 
  80312c:	c3                   	retq   

000000000080312d <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  80312d:	55                   	push   %rbp
  80312e:	48 89 e5             	mov    %rsp,%rbp
  803131:	48 83 ec 18          	sub    $0x18,%rsp
  803135:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  803139:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80313d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  803141:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803145:	48 c1 e8 27          	shr    $0x27,%rax
  803149:	48 89 c2             	mov    %rax,%rdx
  80314c:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803153:	01 00 00 
  803156:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80315a:	83 e0 01             	and    $0x1,%eax
  80315d:	48 85 c0             	test   %rax,%rax
  803160:	74 51                	je     8031b3 <pt_is_mapped+0x86>
  803162:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803166:	48 c1 e0 0c          	shl    $0xc,%rax
  80316a:	48 c1 e8 1e          	shr    $0x1e,%rax
  80316e:	48 89 c2             	mov    %rax,%rdx
  803171:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803178:	01 00 00 
  80317b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80317f:	83 e0 01             	and    $0x1,%eax
  803182:	48 85 c0             	test   %rax,%rax
  803185:	74 2c                	je     8031b3 <pt_is_mapped+0x86>
  803187:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80318b:	48 c1 e0 0c          	shl    $0xc,%rax
  80318f:	48 c1 e8 15          	shr    $0x15,%rax
  803193:	48 89 c2             	mov    %rax,%rdx
  803196:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80319d:	01 00 00 
  8031a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031a4:	83 e0 01             	and    $0x1,%eax
  8031a7:	48 85 c0             	test   %rax,%rax
  8031aa:	74 07                	je     8031b3 <pt_is_mapped+0x86>
  8031ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8031b1:	eb 05                	jmp    8031b8 <pt_is_mapped+0x8b>
  8031b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b8:	83 e0 01             	and    $0x1,%eax
}
  8031bb:	c9                   	leaveq 
  8031bc:	c3                   	retq   

00000000008031bd <fork>:

envid_t
fork(void)
{
  8031bd:	55                   	push   %rbp
  8031be:	48 89 e5             	mov    %rsp,%rbp
  8031c1:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  8031c5:	48 bf d4 2d 80 00 00 	movabs $0x802dd4,%rdi
  8031cc:	00 00 00 
  8031cf:	48 b8 21 64 80 00 00 	movabs $0x806421,%rax
  8031d6:	00 00 00 
  8031d9:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8031db:	b8 07 00 00 00       	mov    $0x7,%eax
  8031e0:	cd 30                	int    $0x30
  8031e2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8031e5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8031e8:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8031eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8031ef:	79 30                	jns    803221 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8031f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031f4:	89 c1                	mov    %eax,%ecx
  8031f6:	48 ba 40 70 80 00 00 	movabs $0x807040,%rdx
  8031fd:	00 00 00 
  803200:	be 86 00 00 00       	mov    $0x86,%esi
  803205:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  80320c:	00 00 00 
  80320f:	b8 00 00 00 00       	mov    $0x0,%eax
  803214:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  80321b:	00 00 00 
  80321e:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  803221:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803225:	75 46                	jne    80326d <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  803227:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  80322e:	00 00 00 
  803231:	ff d0                	callq  *%rax
  803233:	25 ff 03 00 00       	and    $0x3ff,%eax
  803238:	48 63 d0             	movslq %eax,%rdx
  80323b:	48 89 d0             	mov    %rdx,%rax
  80323e:	48 c1 e0 03          	shl    $0x3,%rax
  803242:	48 01 d0             	add    %rdx,%rax
  803245:	48 c1 e0 05          	shl    $0x5,%rax
  803249:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803250:	00 00 00 
  803253:	48 01 c2             	add    %rax,%rdx
  803256:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80325d:	00 00 00 
  803260:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  803263:	b8 00 00 00 00       	mov    $0x0,%eax
  803268:	e9 d1 01 00 00       	jmpq   80343e <fork+0x281>
	}
	uint64_t ad = 0;
  80326d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803274:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  803275:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80327a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80327e:	e9 df 00 00 00       	jmpq   803362 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  803283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803287:	48 c1 e8 27          	shr    $0x27,%rax
  80328b:	48 89 c2             	mov    %rax,%rdx
  80328e:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803295:	01 00 00 
  803298:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80329c:	83 e0 01             	and    $0x1,%eax
  80329f:	48 85 c0             	test   %rax,%rax
  8032a2:	0f 84 9e 00 00 00    	je     803346 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8032a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ac:	48 c1 e8 1e          	shr    $0x1e,%rax
  8032b0:	48 89 c2             	mov    %rax,%rdx
  8032b3:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8032ba:	01 00 00 
  8032bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032c1:	83 e0 01             	and    $0x1,%eax
  8032c4:	48 85 c0             	test   %rax,%rax
  8032c7:	74 73                	je     80333c <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  8032c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032cd:	48 c1 e8 15          	shr    $0x15,%rax
  8032d1:	48 89 c2             	mov    %rax,%rdx
  8032d4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8032db:	01 00 00 
  8032de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032e2:	83 e0 01             	and    $0x1,%eax
  8032e5:	48 85 c0             	test   %rax,%rax
  8032e8:	74 48                	je     803332 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8032ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8032f2:	48 89 c2             	mov    %rax,%rdx
  8032f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8032fc:	01 00 00 
  8032ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803303:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80330b:	83 e0 01             	and    $0x1,%eax
  80330e:	48 85 c0             	test   %rax,%rax
  803311:	74 47                	je     80335a <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  803313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803317:	48 c1 e8 0c          	shr    $0xc,%rax
  80331b:	89 c2                	mov    %eax,%edx
  80331d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803320:	89 d6                	mov    %edx,%esi
  803322:	89 c7                	mov    %eax,%edi
  803324:	48 b8 69 2f 80 00 00 	movabs $0x802f69,%rax
  80332b:	00 00 00 
  80332e:	ff d0                	callq  *%rax
  803330:	eb 28                	jmp    80335a <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  803332:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  803339:	00 
  80333a:	eb 1e                	jmp    80335a <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  80333c:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  803343:	40 
  803344:	eb 14                	jmp    80335a <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  803346:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80334a:	48 c1 e8 27          	shr    $0x27,%rax
  80334e:	48 83 c0 01          	add    $0x1,%rax
  803352:	48 c1 e0 27          	shl    $0x27,%rax
  803356:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80335a:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  803361:	00 
  803362:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  803369:	00 
  80336a:	0f 87 13 ff ff ff    	ja     803283 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  803370:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803373:	ba 07 00 00 00       	mov    $0x7,%edx
  803378:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80337d:	89 c7                	mov    %eax,%edi
  80337f:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  803386:	00 00 00 
  803389:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80338b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80338e:	ba 07 00 00 00       	mov    $0x7,%edx
  803393:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  803398:	89 c7                	mov    %eax,%edi
  80339a:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  8033a1:	00 00 00 
  8033a4:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8033a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033a9:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8033af:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  8033b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8033b9:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8033be:	89 c7                	mov    %eax,%edi
  8033c0:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  8033c7:	00 00 00 
  8033ca:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  8033cc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8033d1:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8033d6:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8033db:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8033e7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8033ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8033f1:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  8033f8:	00 00 00 
  8033fb:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8033fd:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803404:	00 00 00 
  803407:	48 8b 00             	mov    (%rax),%rax
  80340a:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  803411:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803414:	48 89 d6             	mov    %rdx,%rsi
  803417:	89 c7                	mov    %eax,%edi
  803419:	48 b8 25 2c 80 00 00 	movabs $0x802c25,%rax
  803420:	00 00 00 
  803423:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  803425:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803428:	be 02 00 00 00       	mov    $0x2,%esi
  80342d:	89 c7                	mov    %eax,%edi
  80342f:	48 b8 90 2b 80 00 00 	movabs $0x802b90,%rax
  803436:	00 00 00 
  803439:	ff d0                	callq  *%rax

	return envid;
  80343b:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  80343e:	c9                   	leaveq 
  80343f:	c3                   	retq   

0000000000803440 <sfork>:

	
// Challenge!
int
sfork(void)
{
  803440:	55                   	push   %rbp
  803441:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  803444:	48 ba 58 70 80 00 00 	movabs $0x807058,%rdx
  80344b:	00 00 00 
  80344e:	be bf 00 00 00       	mov    $0xbf,%esi
  803453:	48 bf 9d 6f 80 00 00 	movabs $0x806f9d,%rdi
  80345a:	00 00 00 
  80345d:	b8 00 00 00 00       	mov    $0x0,%eax
  803462:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  803469:	00 00 00 
  80346c:	ff d1                	callq  *%rcx

000000000080346e <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  80346e:	55                   	push   %rbp
  80346f:	48 89 e5             	mov    %rsp,%rbp
  803472:	48 83 ec 18          	sub    $0x18,%rsp
  803476:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80347a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80347e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  803482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803486:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80348a:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  80348d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803491:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803495:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  803499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80349d:	8b 00                	mov    (%rax),%eax
  80349f:	83 f8 01             	cmp    $0x1,%eax
  8034a2:	7e 13                	jle    8034b7 <argstart+0x49>
  8034a4:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8034a9:	74 0c                	je     8034b7 <argstart+0x49>
  8034ab:	48 b8 6e 70 80 00 00 	movabs $0x80706e,%rax
  8034b2:	00 00 00 
  8034b5:	eb 05                	jmp    8034bc <argstart+0x4e>
  8034b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034c0:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8034c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c8:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8034cf:	00 
}
  8034d0:	c9                   	leaveq 
  8034d1:	c3                   	retq   

00000000008034d2 <argnext>:

int
argnext(struct Argstate *args)
{
  8034d2:	55                   	push   %rbp
  8034d3:	48 89 e5             	mov    %rsp,%rbp
  8034d6:	48 83 ec 20          	sub    $0x20,%rsp
  8034da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  8034de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e2:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8034e9:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8034ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ee:	48 8b 40 10          	mov    0x10(%rax),%rax
  8034f2:	48 85 c0             	test   %rax,%rax
  8034f5:	75 0a                	jne    803501 <argnext+0x2f>
		return -1;
  8034f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8034fc:	e9 25 01 00 00       	jmpq   803626 <argnext+0x154>

	if (!*args->curarg) {
  803501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803505:	48 8b 40 10          	mov    0x10(%rax),%rax
  803509:	0f b6 00             	movzbl (%rax),%eax
  80350c:	84 c0                	test   %al,%al
  80350e:	0f 85 d7 00 00 00    	jne    8035eb <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  803514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803518:	48 8b 00             	mov    (%rax),%rax
  80351b:	8b 00                	mov    (%rax),%eax
  80351d:	83 f8 01             	cmp    $0x1,%eax
  803520:	0f 84 ef 00 00 00    	je     803615 <argnext+0x143>
		    || args->argv[1][0] != '-'
  803526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80352e:	48 83 c0 08          	add    $0x8,%rax
  803532:	48 8b 00             	mov    (%rax),%rax
  803535:	0f b6 00             	movzbl (%rax),%eax
  803538:	3c 2d                	cmp    $0x2d,%al
  80353a:	0f 85 d5 00 00 00    	jne    803615 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  803540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803544:	48 8b 40 08          	mov    0x8(%rax),%rax
  803548:	48 83 c0 08          	add    $0x8,%rax
  80354c:	48 8b 00             	mov    (%rax),%rax
  80354f:	48 83 c0 01          	add    $0x1,%rax
  803553:	0f b6 00             	movzbl (%rax),%eax
  803556:	84 c0                	test   %al,%al
  803558:	0f 84 b7 00 00 00    	je     803615 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80355e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803562:	48 8b 40 08          	mov    0x8(%rax),%rax
  803566:	48 83 c0 08          	add    $0x8,%rax
  80356a:	48 8b 00             	mov    (%rax),%rax
  80356d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803571:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803575:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357d:	48 8b 00             	mov    (%rax),%rax
  803580:	8b 00                	mov    (%rax),%eax
  803582:	83 e8 01             	sub    $0x1,%eax
  803585:	48 98                	cltq   
  803587:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80358e:	00 
  80358f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803593:	48 8b 40 08          	mov    0x8(%rax),%rax
  803597:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80359b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80359f:	48 8b 40 08          	mov    0x8(%rax),%rax
  8035a3:	48 83 c0 08          	add    $0x8,%rax
  8035a7:	48 89 ce             	mov    %rcx,%rsi
  8035aa:	48 89 c7             	mov    %rax,%rdi
  8035ad:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8035b4:	00 00 00 
  8035b7:	ff d0                	callq  *%rax
		(*args->argc)--;
  8035b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035bd:	48 8b 00             	mov    (%rax),%rax
  8035c0:	8b 10                	mov    (%rax),%edx
  8035c2:	83 ea 01             	sub    $0x1,%edx
  8035c5:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8035c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035cb:	48 8b 40 10          	mov    0x10(%rax),%rax
  8035cf:	0f b6 00             	movzbl (%rax),%eax
  8035d2:	3c 2d                	cmp    $0x2d,%al
  8035d4:	75 15                	jne    8035eb <argnext+0x119>
  8035d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035da:	48 8b 40 10          	mov    0x10(%rax),%rax
  8035de:	48 83 c0 01          	add    $0x1,%rax
  8035e2:	0f b6 00             	movzbl (%rax),%eax
  8035e5:	84 c0                	test   %al,%al
  8035e7:	75 02                	jne    8035eb <argnext+0x119>
			goto endofargs;
  8035e9:	eb 2a                	jmp    803615 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  8035eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ef:	48 8b 40 10          	mov    0x10(%rax),%rax
  8035f3:	0f b6 00             	movzbl (%rax),%eax
  8035f6:	0f b6 c0             	movzbl %al,%eax
  8035f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  8035fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803600:	48 8b 40 10          	mov    0x10(%rax),%rax
  803604:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80360c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  803610:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803613:	eb 11                	jmp    803626 <argnext+0x154>

endofargs:
	args->curarg = 0;
  803615:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803619:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803620:	00 
	return -1;
  803621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  803626:	c9                   	leaveq 
  803627:	c3                   	retq   

0000000000803628 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  803628:	55                   	push   %rbp
  803629:	48 89 e5             	mov    %rsp,%rbp
  80362c:	48 83 ec 10          	sub    $0x10,%rsp
  803630:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  803634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803638:	48 8b 40 18          	mov    0x18(%rax),%rax
  80363c:	48 85 c0             	test   %rax,%rax
  80363f:	74 0a                	je     80364b <argvalue+0x23>
  803641:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803645:	48 8b 40 18          	mov    0x18(%rax),%rax
  803649:	eb 13                	jmp    80365e <argvalue+0x36>
  80364b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80364f:	48 89 c7             	mov    %rax,%rdi
  803652:	48 b8 60 36 80 00 00 	movabs $0x803660,%rax
  803659:	00 00 00 
  80365c:	ff d0                	callq  *%rax
}
  80365e:	c9                   	leaveq 
  80365f:	c3                   	retq   

0000000000803660 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  803660:	55                   	push   %rbp
  803661:	48 89 e5             	mov    %rsp,%rbp
  803664:	53                   	push   %rbx
  803665:	48 83 ec 18          	sub    $0x18,%rsp
  803669:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (!args->curarg)
  80366d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803671:	48 8b 40 10          	mov    0x10(%rax),%rax
  803675:	48 85 c0             	test   %rax,%rax
  803678:	75 0a                	jne    803684 <argnextvalue+0x24>
		return 0;
  80367a:	b8 00 00 00 00       	mov    $0x0,%eax
  80367f:	e9 c8 00 00 00       	jmpq   80374c <argnextvalue+0xec>
	if (*args->curarg) {
  803684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803688:	48 8b 40 10          	mov    0x10(%rax),%rax
  80368c:	0f b6 00             	movzbl (%rax),%eax
  80368f:	84 c0                	test   %al,%al
  803691:	74 27                	je     8036ba <argnextvalue+0x5a>
		args->argvalue = args->curarg;
  803693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803697:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80369b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80369f:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8036a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a7:	48 bb 6e 70 80 00 00 	movabs $0x80706e,%rbx
  8036ae:	00 00 00 
  8036b1:	48 89 58 10          	mov    %rbx,0x10(%rax)
  8036b5:	e9 8a 00 00 00       	jmpq   803744 <argnextvalue+0xe4>
	} else if (*args->argc > 1) {
  8036ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036be:	48 8b 00             	mov    (%rax),%rax
  8036c1:	8b 00                	mov    (%rax),%eax
  8036c3:	83 f8 01             	cmp    $0x1,%eax
  8036c6:	7e 64                	jle    80372c <argnextvalue+0xcc>
		args->argvalue = args->argv[1];
  8036c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036cc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036d0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8036d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d8:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8036dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e0:	48 8b 00             	mov    (%rax),%rax
  8036e3:	8b 00                	mov    (%rax),%eax
  8036e5:	83 e8 01             	sub    $0x1,%eax
  8036e8:	48 98                	cltq   
  8036ea:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8036f1:	00 
  8036f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036fa:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8036fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803702:	48 8b 40 08          	mov    0x8(%rax),%rax
  803706:	48 83 c0 08          	add    $0x8,%rax
  80370a:	48 89 ce             	mov    %rcx,%rsi
  80370d:	48 89 c7             	mov    %rax,%rdi
  803710:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  803717:	00 00 00 
  80371a:	ff d0                	callq  *%rax
		(*args->argc)--;
  80371c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803720:	48 8b 00             	mov    (%rax),%rax
  803723:	8b 10                	mov    (%rax),%edx
  803725:	83 ea 01             	sub    $0x1,%edx
  803728:	89 10                	mov    %edx,(%rax)
  80372a:	eb 18                	jmp    803744 <argnextvalue+0xe4>
	} else {
		args->argvalue = 0;
  80372c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803730:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803737:	00 
		args->curarg = 0;
  803738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80373c:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803743:	00 
	}
	return (char*) args->argvalue;
  803744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803748:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  80374c:	48 83 c4 18          	add    $0x18,%rsp
  803750:	5b                   	pop    %rbx
  803751:	5d                   	pop    %rbp
  803752:	c3                   	retq   

0000000000803753 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  803753:	55                   	push   %rbp
  803754:	48 89 e5             	mov    %rsp,%rbp
  803757:	48 83 ec 08          	sub    $0x8,%rsp
  80375b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80375f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803763:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80376a:	ff ff ff 
  80376d:	48 01 d0             	add    %rdx,%rax
  803770:	48 c1 e8 0c          	shr    $0xc,%rax
}
  803774:	c9                   	leaveq 
  803775:	c3                   	retq   

0000000000803776 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  803776:	55                   	push   %rbp
  803777:	48 89 e5             	mov    %rsp,%rbp
  80377a:	48 83 ec 08          	sub    $0x8,%rsp
  80377e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  803782:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803786:	48 89 c7             	mov    %rax,%rdi
  803789:	48 b8 53 37 80 00 00 	movabs $0x803753,%rax
  803790:	00 00 00 
  803793:	ff d0                	callq  *%rax
  803795:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80379b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80379f:	c9                   	leaveq 
  8037a0:	c3                   	retq   

00000000008037a1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8037a1:	55                   	push   %rbp
  8037a2:	48 89 e5             	mov    %rsp,%rbp
  8037a5:	48 83 ec 18          	sub    $0x18,%rsp
  8037a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8037ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037b4:	eb 6b                	jmp    803821 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8037b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b9:	48 98                	cltq   
  8037bb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8037c1:	48 c1 e0 0c          	shl    $0xc,%rax
  8037c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8037c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cd:	48 c1 e8 15          	shr    $0x15,%rax
  8037d1:	48 89 c2             	mov    %rax,%rdx
  8037d4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8037db:	01 00 00 
  8037de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8037e2:	83 e0 01             	and    $0x1,%eax
  8037e5:	48 85 c0             	test   %rax,%rax
  8037e8:	74 21                	je     80380b <fd_alloc+0x6a>
  8037ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8037f2:	48 89 c2             	mov    %rax,%rdx
  8037f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8037fc:	01 00 00 
  8037ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803803:	83 e0 01             	and    $0x1,%eax
  803806:	48 85 c0             	test   %rax,%rax
  803809:	75 12                	jne    80381d <fd_alloc+0x7c>
			*fd_store = fd;
  80380b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80380f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803813:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803816:	b8 00 00 00 00       	mov    $0x0,%eax
  80381b:	eb 1a                	jmp    803837 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80381d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803821:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803825:	7e 8f                	jle    8037b6 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  803827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80382b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  803832:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  803837:	c9                   	leaveq 
  803838:	c3                   	retq   

0000000000803839 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803839:	55                   	push   %rbp
  80383a:	48 89 e5             	mov    %rsp,%rbp
  80383d:	48 83 ec 20          	sub    $0x20,%rsp
  803841:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803844:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803848:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80384c:	78 06                	js     803854 <fd_lookup+0x1b>
  80384e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  803852:	7e 07                	jle    80385b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803854:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803859:	eb 6c                	jmp    8038c7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80385b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80385e:	48 98                	cltq   
  803860:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803866:	48 c1 e0 0c          	shl    $0xc,%rax
  80386a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80386e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803872:	48 c1 e8 15          	shr    $0x15,%rax
  803876:	48 89 c2             	mov    %rax,%rdx
  803879:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803880:	01 00 00 
  803883:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803887:	83 e0 01             	and    $0x1,%eax
  80388a:	48 85 c0             	test   %rax,%rax
  80388d:	74 21                	je     8038b0 <fd_lookup+0x77>
  80388f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803893:	48 c1 e8 0c          	shr    $0xc,%rax
  803897:	48 89 c2             	mov    %rax,%rdx
  80389a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8038a1:	01 00 00 
  8038a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8038a8:	83 e0 01             	and    $0x1,%eax
  8038ab:	48 85 c0             	test   %rax,%rax
  8038ae:	75 07                	jne    8038b7 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8038b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8038b5:	eb 10                	jmp    8038c7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8038b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8038bf:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8038c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038c7:	c9                   	leaveq 
  8038c8:	c3                   	retq   

00000000008038c9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8038c9:	55                   	push   %rbp
  8038ca:	48 89 e5             	mov    %rsp,%rbp
  8038cd:	48 83 ec 30          	sub    $0x30,%rsp
  8038d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038d5:	89 f0                	mov    %esi,%eax
  8038d7:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8038da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038de:	48 89 c7             	mov    %rax,%rdi
  8038e1:	48 b8 53 37 80 00 00 	movabs $0x803753,%rax
  8038e8:	00 00 00 
  8038eb:	ff d0                	callq  *%rax
  8038ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038f1:	48 89 d6             	mov    %rdx,%rsi
  8038f4:	89 c7                	mov    %eax,%edi
  8038f6:	48 b8 39 38 80 00 00 	movabs $0x803839,%rax
  8038fd:	00 00 00 
  803900:	ff d0                	callq  *%rax
  803902:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803905:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803909:	78 0a                	js     803915 <fd_close+0x4c>
	    || fd != fd2)
  80390b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390f:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803913:	74 12                	je     803927 <fd_close+0x5e>
		return (must_exist ? r : 0);
  803915:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803919:	74 05                	je     803920 <fd_close+0x57>
  80391b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80391e:	eb 05                	jmp    803925 <fd_close+0x5c>
  803920:	b8 00 00 00 00       	mov    $0x0,%eax
  803925:	eb 69                	jmp    803990 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803927:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80392b:	8b 00                	mov    (%rax),%eax
  80392d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803931:	48 89 d6             	mov    %rdx,%rsi
  803934:	89 c7                	mov    %eax,%edi
  803936:	48 b8 92 39 80 00 00 	movabs $0x803992,%rax
  80393d:	00 00 00 
  803940:	ff d0                	callq  *%rax
  803942:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803945:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803949:	78 2a                	js     803975 <fd_close+0xac>
		if (dev->dev_close)
  80394b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394f:	48 8b 40 20          	mov    0x20(%rax),%rax
  803953:	48 85 c0             	test   %rax,%rax
  803956:	74 16                	je     80396e <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  803958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80395c:	48 8b 40 20          	mov    0x20(%rax),%rax
  803960:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803964:	48 89 d7             	mov    %rdx,%rdi
  803967:	ff d0                	callq  *%rax
  803969:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80396c:	eb 07                	jmp    803975 <fd_close+0xac>
		else
			r = 0;
  80396e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803975:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803979:	48 89 c6             	mov    %rax,%rsi
  80397c:	bf 00 00 00 00       	mov    $0x0,%edi
  803981:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  803988:	00 00 00 
  80398b:	ff d0                	callq  *%rax
	return r;
  80398d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803990:	c9                   	leaveq 
  803991:	c3                   	retq   

0000000000803992 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803992:	55                   	push   %rbp
  803993:	48 89 e5             	mov    %rsp,%rbp
  803996:	48 83 ec 20          	sub    $0x20,%rsp
  80399a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80399d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8039a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039a8:	eb 41                	jmp    8039eb <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8039aa:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  8039b1:	00 00 00 
  8039b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039b7:	48 63 d2             	movslq %edx,%rdx
  8039ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039be:	8b 00                	mov    (%rax),%eax
  8039c0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8039c3:	75 22                	jne    8039e7 <dev_lookup+0x55>
			*dev = devtab[i];
  8039c5:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  8039cc:	00 00 00 
  8039cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039d2:	48 63 d2             	movslq %edx,%rdx
  8039d5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8039d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039dd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8039e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e5:	eb 60                	jmp    803a47 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8039e7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8039eb:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  8039f2:	00 00 00 
  8039f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039f8:	48 63 d2             	movslq %edx,%rdx
  8039fb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039ff:	48 85 c0             	test   %rax,%rax
  803a02:	75 a6                	jne    8039aa <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  803a04:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803a0b:	00 00 00 
  803a0e:	48 8b 00             	mov    (%rax),%rax
  803a11:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803a17:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a1a:	89 c6                	mov    %eax,%esi
  803a1c:	48 bf 70 70 80 00 00 	movabs $0x807070,%rdi
  803a23:	00 00 00 
  803a26:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2b:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  803a32:	00 00 00 
  803a35:	ff d1                	callq  *%rcx
	*dev = 0;
  803a37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a3b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803a42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803a47:	c9                   	leaveq 
  803a48:	c3                   	retq   

0000000000803a49 <close>:

int
close(int fdnum)
{
  803a49:	55                   	push   %rbp
  803a4a:	48 89 e5             	mov    %rsp,%rbp
  803a4d:	48 83 ec 20          	sub    $0x20,%rsp
  803a51:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a54:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a5b:	48 89 d6             	mov    %rdx,%rsi
  803a5e:	89 c7                	mov    %eax,%edi
  803a60:	48 b8 39 38 80 00 00 	movabs $0x803839,%rax
  803a67:	00 00 00 
  803a6a:	ff d0                	callq  *%rax
  803a6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a73:	79 05                	jns    803a7a <close+0x31>
		return r;
  803a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a78:	eb 18                	jmp    803a92 <close+0x49>
	else
		return fd_close(fd, 1);
  803a7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7e:	be 01 00 00 00       	mov    $0x1,%esi
  803a83:	48 89 c7             	mov    %rax,%rdi
  803a86:	48 b8 c9 38 80 00 00 	movabs $0x8038c9,%rax
  803a8d:	00 00 00 
  803a90:	ff d0                	callq  *%rax
}
  803a92:	c9                   	leaveq 
  803a93:	c3                   	retq   

0000000000803a94 <close_all>:

void
close_all(void)
{
  803a94:	55                   	push   %rbp
  803a95:	48 89 e5             	mov    %rsp,%rbp
  803a98:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803a9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803aa3:	eb 15                	jmp    803aba <close_all+0x26>
		close(i);
  803aa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa8:	89 c7                	mov    %eax,%edi
  803aaa:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  803ab1:	00 00 00 
  803ab4:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803ab6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803aba:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803abe:	7e e5                	jle    803aa5 <close_all+0x11>
		close(i);
}
  803ac0:	c9                   	leaveq 
  803ac1:	c3                   	retq   

0000000000803ac2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  803ac2:	55                   	push   %rbp
  803ac3:	48 89 e5             	mov    %rsp,%rbp
  803ac6:	48 83 ec 40          	sub    $0x40,%rsp
  803aca:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803acd:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803ad0:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803ad4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803ad7:	48 89 d6             	mov    %rdx,%rsi
  803ada:	89 c7                	mov    %eax,%edi
  803adc:	48 b8 39 38 80 00 00 	movabs $0x803839,%rax
  803ae3:	00 00 00 
  803ae6:	ff d0                	callq  *%rax
  803ae8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aeb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aef:	79 08                	jns    803af9 <dup+0x37>
		return r;
  803af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af4:	e9 70 01 00 00       	jmpq   803c69 <dup+0x1a7>
	close(newfdnum);
  803af9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803afc:	89 c7                	mov    %eax,%edi
  803afe:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  803b05:	00 00 00 
  803b08:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803b0a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803b0d:	48 98                	cltq   
  803b0f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803b15:	48 c1 e0 0c          	shl    $0xc,%rax
  803b19:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803b1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b21:	48 89 c7             	mov    %rax,%rdi
  803b24:	48 b8 76 37 80 00 00 	movabs $0x803776,%rax
  803b2b:	00 00 00 
  803b2e:	ff d0                	callq  *%rax
  803b30:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803b34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b38:	48 89 c7             	mov    %rax,%rdi
  803b3b:	48 b8 76 37 80 00 00 	movabs $0x803776,%rax
  803b42:	00 00 00 
  803b45:	ff d0                	callq  *%rax
  803b47:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803b4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b4f:	48 c1 e8 15          	shr    $0x15,%rax
  803b53:	48 89 c2             	mov    %rax,%rdx
  803b56:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b5d:	01 00 00 
  803b60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b64:	83 e0 01             	and    $0x1,%eax
  803b67:	48 85 c0             	test   %rax,%rax
  803b6a:	74 73                	je     803bdf <dup+0x11d>
  803b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b70:	48 c1 e8 0c          	shr    $0xc,%rax
  803b74:	48 89 c2             	mov    %rax,%rdx
  803b77:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b7e:	01 00 00 
  803b81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b85:	83 e0 01             	and    $0x1,%eax
  803b88:	48 85 c0             	test   %rax,%rax
  803b8b:	74 52                	je     803bdf <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803b8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b91:	48 c1 e8 0c          	shr    $0xc,%rax
  803b95:	48 89 c2             	mov    %rax,%rdx
  803b98:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803b9f:	01 00 00 
  803ba2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ba6:	25 07 0e 00 00       	and    $0xe07,%eax
  803bab:	89 c1                	mov    %eax,%ecx
  803bad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803bb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bb5:	41 89 c8             	mov    %ecx,%r8d
  803bb8:	48 89 d1             	mov    %rdx,%rcx
  803bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  803bc0:	48 89 c6             	mov    %rax,%rsi
  803bc3:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc8:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  803bcf:	00 00 00 
  803bd2:	ff d0                	callq  *%rax
  803bd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bdb:	79 02                	jns    803bdf <dup+0x11d>
			goto err;
  803bdd:	eb 57                	jmp    803c36 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803bdf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803be3:	48 c1 e8 0c          	shr    $0xc,%rax
  803be7:	48 89 c2             	mov    %rax,%rdx
  803bea:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bf1:	01 00 00 
  803bf4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bf8:	25 07 0e 00 00       	and    $0xe07,%eax
  803bfd:	89 c1                	mov    %eax,%ecx
  803bff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c03:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c07:	41 89 c8             	mov    %ecx,%r8d
  803c0a:	48 89 d1             	mov    %rdx,%rcx
  803c0d:	ba 00 00 00 00       	mov    $0x0,%edx
  803c12:	48 89 c6             	mov    %rax,%rsi
  803c15:	bf 00 00 00 00       	mov    $0x0,%edi
  803c1a:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  803c21:	00 00 00 
  803c24:	ff d0                	callq  *%rax
  803c26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2d:	79 02                	jns    803c31 <dup+0x16f>
		goto err;
  803c2f:	eb 05                	jmp    803c36 <dup+0x174>

	return newfdnum;
  803c31:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803c34:	eb 33                	jmp    803c69 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3a:	48 89 c6             	mov    %rax,%rsi
  803c3d:	bf 00 00 00 00       	mov    $0x0,%edi
  803c42:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  803c49:	00 00 00 
  803c4c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803c4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c52:	48 89 c6             	mov    %rax,%rsi
  803c55:	bf 00 00 00 00       	mov    $0x0,%edi
  803c5a:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  803c61:	00 00 00 
  803c64:	ff d0                	callq  *%rax
	return r;
  803c66:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c69:	c9                   	leaveq 
  803c6a:	c3                   	retq   

0000000000803c6b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803c6b:	55                   	push   %rbp
  803c6c:	48 89 e5             	mov    %rsp,%rbp
  803c6f:	48 83 ec 40          	sub    $0x40,%rsp
  803c73:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803c76:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c7a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803c7e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803c82:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c85:	48 89 d6             	mov    %rdx,%rsi
  803c88:	89 c7                	mov    %eax,%edi
  803c8a:	48 b8 39 38 80 00 00 	movabs $0x803839,%rax
  803c91:	00 00 00 
  803c94:	ff d0                	callq  *%rax
  803c96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9d:	78 24                	js     803cc3 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca3:	8b 00                	mov    (%rax),%eax
  803ca5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ca9:	48 89 d6             	mov    %rdx,%rsi
  803cac:	89 c7                	mov    %eax,%edi
  803cae:	48 b8 92 39 80 00 00 	movabs $0x803992,%rax
  803cb5:	00 00 00 
  803cb8:	ff d0                	callq  *%rax
  803cba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc1:	79 05                	jns    803cc8 <read+0x5d>
		return r;
  803cc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc6:	eb 76                	jmp    803d3e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803cc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ccc:	8b 40 08             	mov    0x8(%rax),%eax
  803ccf:	83 e0 03             	and    $0x3,%eax
  803cd2:	83 f8 01             	cmp    $0x1,%eax
  803cd5:	75 3a                	jne    803d11 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803cd7:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803cde:	00 00 00 
  803ce1:	48 8b 00             	mov    (%rax),%rax
  803ce4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803cea:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803ced:	89 c6                	mov    %eax,%esi
  803cef:	48 bf 8f 70 80 00 00 	movabs $0x80708f,%rdi
  803cf6:	00 00 00 
  803cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cfe:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  803d05:	00 00 00 
  803d08:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803d0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803d0f:	eb 2d                	jmp    803d3e <read+0xd3>
	}
	if (!dev->dev_read)
  803d11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d15:	48 8b 40 10          	mov    0x10(%rax),%rax
  803d19:	48 85 c0             	test   %rax,%rax
  803d1c:	75 07                	jne    803d25 <read+0xba>
		return -E_NOT_SUPP;
  803d1e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803d23:	eb 19                	jmp    803d3e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803d25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d29:	48 8b 40 10          	mov    0x10(%rax),%rax
  803d2d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d31:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803d35:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803d39:	48 89 cf             	mov    %rcx,%rdi
  803d3c:	ff d0                	callq  *%rax
}
  803d3e:	c9                   	leaveq 
  803d3f:	c3                   	retq   

0000000000803d40 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803d40:	55                   	push   %rbp
  803d41:	48 89 e5             	mov    %rsp,%rbp
  803d44:	48 83 ec 30          	sub    $0x30,%rsp
  803d48:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d4f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803d53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d5a:	eb 49                	jmp    803da5 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803d5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5f:	48 98                	cltq   
  803d61:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803d65:	48 29 c2             	sub    %rax,%rdx
  803d68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6b:	48 63 c8             	movslq %eax,%rcx
  803d6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d72:	48 01 c1             	add    %rax,%rcx
  803d75:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d78:	48 89 ce             	mov    %rcx,%rsi
  803d7b:	89 c7                	mov    %eax,%edi
  803d7d:	48 b8 6b 3c 80 00 00 	movabs $0x803c6b,%rax
  803d84:	00 00 00 
  803d87:	ff d0                	callq  *%rax
  803d89:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803d8c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d90:	79 05                	jns    803d97 <readn+0x57>
			return m;
  803d92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d95:	eb 1c                	jmp    803db3 <readn+0x73>
		if (m == 0)
  803d97:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803d9b:	75 02                	jne    803d9f <readn+0x5f>
			break;
  803d9d:	eb 11                	jmp    803db0 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803d9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803da2:	01 45 fc             	add    %eax,-0x4(%rbp)
  803da5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da8:	48 98                	cltq   
  803daa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803dae:	72 ac                	jb     803d5c <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803db3:	c9                   	leaveq 
  803db4:	c3                   	retq   

0000000000803db5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803db5:	55                   	push   %rbp
  803db6:	48 89 e5             	mov    %rsp,%rbp
  803db9:	48 83 ec 40          	sub    $0x40,%rsp
  803dbd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803dc0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803dc4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803dc8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803dcc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803dcf:	48 89 d6             	mov    %rdx,%rsi
  803dd2:	89 c7                	mov    %eax,%edi
  803dd4:	48 b8 39 38 80 00 00 	movabs $0x803839,%rax
  803ddb:	00 00 00 
  803dde:	ff d0                	callq  *%rax
  803de0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de7:	78 24                	js     803e0d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803de9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ded:	8b 00                	mov    (%rax),%eax
  803def:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803df3:	48 89 d6             	mov    %rdx,%rsi
  803df6:	89 c7                	mov    %eax,%edi
  803df8:	48 b8 92 39 80 00 00 	movabs $0x803992,%rax
  803dff:	00 00 00 
  803e02:	ff d0                	callq  *%rax
  803e04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e0b:	79 05                	jns    803e12 <write+0x5d>
		return r;
  803e0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e10:	eb 75                	jmp    803e87 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803e12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e16:	8b 40 08             	mov    0x8(%rax),%eax
  803e19:	83 e0 03             	and    $0x3,%eax
  803e1c:	85 c0                	test   %eax,%eax
  803e1e:	75 3a                	jne    803e5a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803e20:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803e27:	00 00 00 
  803e2a:	48 8b 00             	mov    (%rax),%rax
  803e2d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e33:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e36:	89 c6                	mov    %eax,%esi
  803e38:	48 bf ab 70 80 00 00 	movabs $0x8070ab,%rdi
  803e3f:	00 00 00 
  803e42:	b8 00 00 00 00       	mov    $0x0,%eax
  803e47:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  803e4e:	00 00 00 
  803e51:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803e53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e58:	eb 2d                	jmp    803e87 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  803e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5e:	48 8b 40 18          	mov    0x18(%rax),%rax
  803e62:	48 85 c0             	test   %rax,%rax
  803e65:	75 07                	jne    803e6e <write+0xb9>
		return -E_NOT_SUPP;
  803e67:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803e6c:	eb 19                	jmp    803e87 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e72:	48 8b 40 18          	mov    0x18(%rax),%rax
  803e76:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e7a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803e7e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803e82:	48 89 cf             	mov    %rcx,%rdi
  803e85:	ff d0                	callq  *%rax
}
  803e87:	c9                   	leaveq 
  803e88:	c3                   	retq   

0000000000803e89 <seek>:

int
seek(int fdnum, off_t offset)
{
  803e89:	55                   	push   %rbp
  803e8a:	48 89 e5             	mov    %rsp,%rbp
  803e8d:	48 83 ec 18          	sub    $0x18,%rsp
  803e91:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e94:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e97:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e9e:	48 89 d6             	mov    %rdx,%rsi
  803ea1:	89 c7                	mov    %eax,%edi
  803ea3:	48 b8 39 38 80 00 00 	movabs $0x803839,%rax
  803eaa:	00 00 00 
  803ead:	ff d0                	callq  *%rax
  803eaf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb6:	79 05                	jns    803ebd <seek+0x34>
		return r;
  803eb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ebb:	eb 0f                	jmp    803ecc <seek+0x43>
	fd->fd_offset = offset;
  803ebd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ec4:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803ec7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ecc:	c9                   	leaveq 
  803ecd:	c3                   	retq   

0000000000803ece <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803ece:	55                   	push   %rbp
  803ecf:	48 89 e5             	mov    %rsp,%rbp
  803ed2:	48 83 ec 30          	sub    $0x30,%rsp
  803ed6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803ed9:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803edc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ee0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ee3:	48 89 d6             	mov    %rdx,%rsi
  803ee6:	89 c7                	mov    %eax,%edi
  803ee8:	48 b8 39 38 80 00 00 	movabs $0x803839,%rax
  803eef:	00 00 00 
  803ef2:	ff d0                	callq  *%rax
  803ef4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ef7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803efb:	78 24                	js     803f21 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803efd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f01:	8b 00                	mov    (%rax),%eax
  803f03:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f07:	48 89 d6             	mov    %rdx,%rsi
  803f0a:	89 c7                	mov    %eax,%edi
  803f0c:	48 b8 92 39 80 00 00 	movabs $0x803992,%rax
  803f13:	00 00 00 
  803f16:	ff d0                	callq  *%rax
  803f18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f1f:	79 05                	jns    803f26 <ftruncate+0x58>
		return r;
  803f21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f24:	eb 72                	jmp    803f98 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803f26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f2a:	8b 40 08             	mov    0x8(%rax),%eax
  803f2d:	83 e0 03             	and    $0x3,%eax
  803f30:	85 c0                	test   %eax,%eax
  803f32:	75 3a                	jne    803f6e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803f34:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803f3b:	00 00 00 
  803f3e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803f41:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f47:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f4a:	89 c6                	mov    %eax,%esi
  803f4c:	48 bf c8 70 80 00 00 	movabs $0x8070c8,%rdi
  803f53:	00 00 00 
  803f56:	b8 00 00 00 00       	mov    $0x0,%eax
  803f5b:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  803f62:	00 00 00 
  803f65:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803f67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803f6c:	eb 2a                	jmp    803f98 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803f6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f72:	48 8b 40 30          	mov    0x30(%rax),%rax
  803f76:	48 85 c0             	test   %rax,%rax
  803f79:	75 07                	jne    803f82 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803f7b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803f80:	eb 16                	jmp    803f98 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803f82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f86:	48 8b 40 30          	mov    0x30(%rax),%rax
  803f8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f8e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803f91:	89 ce                	mov    %ecx,%esi
  803f93:	48 89 d7             	mov    %rdx,%rdi
  803f96:	ff d0                	callq  *%rax
}
  803f98:	c9                   	leaveq 
  803f99:	c3                   	retq   

0000000000803f9a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803f9a:	55                   	push   %rbp
  803f9b:	48 89 e5             	mov    %rsp,%rbp
  803f9e:	48 83 ec 30          	sub    $0x30,%rsp
  803fa2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803fa5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803fa9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803fad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fb0:	48 89 d6             	mov    %rdx,%rsi
  803fb3:	89 c7                	mov    %eax,%edi
  803fb5:	48 b8 39 38 80 00 00 	movabs $0x803839,%rax
  803fbc:	00 00 00 
  803fbf:	ff d0                	callq  *%rax
  803fc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc8:	78 24                	js     803fee <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803fca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fce:	8b 00                	mov    (%rax),%eax
  803fd0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803fd4:	48 89 d6             	mov    %rdx,%rsi
  803fd7:	89 c7                	mov    %eax,%edi
  803fd9:	48 b8 92 39 80 00 00 	movabs $0x803992,%rax
  803fe0:	00 00 00 
  803fe3:	ff d0                	callq  *%rax
  803fe5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fe8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fec:	79 05                	jns    803ff3 <fstat+0x59>
		return r;
  803fee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ff1:	eb 5e                	jmp    804051 <fstat+0xb7>
	if (!dev->dev_stat)
  803ff3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff7:	48 8b 40 28          	mov    0x28(%rax),%rax
  803ffb:	48 85 c0             	test   %rax,%rax
  803ffe:	75 07                	jne    804007 <fstat+0x6d>
		return -E_NOT_SUPP;
  804000:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804005:	eb 4a                	jmp    804051 <fstat+0xb7>
	stat->st_name[0] = 0;
  804007:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80400b:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80400e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804012:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  804019:	00 00 00 
	stat->st_isdir = 0;
  80401c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804020:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804027:	00 00 00 
	stat->st_dev = dev;
  80402a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80402e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804032:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  804039:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403d:	48 8b 40 28          	mov    0x28(%rax),%rax
  804041:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804045:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  804049:	48 89 ce             	mov    %rcx,%rsi
  80404c:	48 89 d7             	mov    %rdx,%rdi
  80404f:	ff d0                	callq  *%rax
}
  804051:	c9                   	leaveq 
  804052:	c3                   	retq   

0000000000804053 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  804053:	55                   	push   %rbp
  804054:	48 89 e5             	mov    %rsp,%rbp
  804057:	48 83 ec 20          	sub    $0x20,%rsp
  80405b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80405f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  804063:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804067:	be 00 00 00 00       	mov    $0x0,%esi
  80406c:	48 89 c7             	mov    %rax,%rdi
  80406f:	48 b8 41 41 80 00 00 	movabs $0x804141,%rax
  804076:	00 00 00 
  804079:	ff d0                	callq  *%rax
  80407b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80407e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804082:	79 05                	jns    804089 <stat+0x36>
		return fd;
  804084:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804087:	eb 2f                	jmp    8040b8 <stat+0x65>
	r = fstat(fd, stat);
  804089:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80408d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804090:	48 89 d6             	mov    %rdx,%rsi
  804093:	89 c7                	mov    %eax,%edi
  804095:	48 b8 9a 3f 80 00 00 	movabs $0x803f9a,%rax
  80409c:	00 00 00 
  80409f:	ff d0                	callq  *%rax
  8040a1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8040a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a7:	89 c7                	mov    %eax,%edi
  8040a9:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  8040b0:	00 00 00 
  8040b3:	ff d0                	callq  *%rax
	return r;
  8040b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8040b8:	c9                   	leaveq 
  8040b9:	c3                   	retq   

00000000008040ba <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8040ba:	55                   	push   %rbp
  8040bb:	48 89 e5             	mov    %rsp,%rbp
  8040be:	48 83 ec 10          	sub    $0x10,%rsp
  8040c2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8040c9:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  8040d0:	00 00 00 
  8040d3:	8b 00                	mov    (%rax),%eax
  8040d5:	85 c0                	test   %eax,%eax
  8040d7:	75 1d                	jne    8040f6 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8040d9:	bf 01 00 00 00       	mov    $0x1,%edi
  8040de:	48 b8 c9 66 80 00 00 	movabs $0x8066c9,%rax
  8040e5:	00 00 00 
  8040e8:	ff d0                	callq  *%rax
  8040ea:	48 ba 20 a4 80 00 00 	movabs $0x80a420,%rdx
  8040f1:	00 00 00 
  8040f4:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8040f6:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  8040fd:	00 00 00 
  804100:	8b 00                	mov    (%rax),%eax
  804102:	8b 75 fc             	mov    -0x4(%rbp),%esi
  804105:	b9 07 00 00 00       	mov    $0x7,%ecx
  80410a:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  804111:	00 00 00 
  804114:	89 c7                	mov    %eax,%edi
  804116:	48 b8 67 66 80 00 00 	movabs $0x806667,%rax
  80411d:	00 00 00 
  804120:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  804122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804126:	ba 00 00 00 00       	mov    $0x0,%edx
  80412b:	48 89 c6             	mov    %rax,%rsi
  80412e:	bf 00 00 00 00       	mov    $0x0,%edi
  804133:	48 b8 61 65 80 00 00 	movabs $0x806561,%rax
  80413a:	00 00 00 
  80413d:	ff d0                	callq  *%rax
}
  80413f:	c9                   	leaveq 
  804140:	c3                   	retq   

0000000000804141 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  804141:	55                   	push   %rbp
  804142:	48 89 e5             	mov    %rsp,%rbp
  804145:	48 83 ec 30          	sub    $0x30,%rsp
  804149:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80414d:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  804150:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  804157:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80415e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  804165:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80416a:	75 08                	jne    804174 <open+0x33>
	{
		return r;
  80416c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416f:	e9 f2 00 00 00       	jmpq   804266 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  804174:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804178:	48 89 c7             	mov    %rax,%rdi
  80417b:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  804182:	00 00 00 
  804185:	ff d0                	callq  *%rax
  804187:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80418a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  804191:	7e 0a                	jle    80419d <open+0x5c>
	{
		return -E_BAD_PATH;
  804193:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  804198:	e9 c9 00 00 00       	jmpq   804266 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80419d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8041a4:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8041a5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8041a9:	48 89 c7             	mov    %rax,%rdi
  8041ac:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  8041b3:	00 00 00 
  8041b6:	ff d0                	callq  *%rax
  8041b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041bf:	78 09                	js     8041ca <open+0x89>
  8041c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041c5:	48 85 c0             	test   %rax,%rax
  8041c8:	75 08                	jne    8041d2 <open+0x91>
		{
			return r;
  8041ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041cd:	e9 94 00 00 00       	jmpq   804266 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8041d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041d6:	ba 00 04 00 00       	mov    $0x400,%edx
  8041db:	48 89 c6             	mov    %rax,%rsi
  8041de:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  8041e5:	00 00 00 
  8041e8:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  8041ef:	00 00 00 
  8041f2:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8041f4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041fb:	00 00 00 
  8041fe:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  804201:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  804207:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80420b:	48 89 c6             	mov    %rax,%rsi
  80420e:	bf 01 00 00 00       	mov    $0x1,%edi
  804213:	48 b8 ba 40 80 00 00 	movabs $0x8040ba,%rax
  80421a:	00 00 00 
  80421d:	ff d0                	callq  *%rax
  80421f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804222:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804226:	79 2b                	jns    804253 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  804228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80422c:	be 00 00 00 00       	mov    $0x0,%esi
  804231:	48 89 c7             	mov    %rax,%rdi
  804234:	48 b8 c9 38 80 00 00 	movabs $0x8038c9,%rax
  80423b:	00 00 00 
  80423e:	ff d0                	callq  *%rax
  804240:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804243:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804247:	79 05                	jns    80424e <open+0x10d>
			{
				return d;
  804249:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80424c:	eb 18                	jmp    804266 <open+0x125>
			}
			return r;
  80424e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804251:	eb 13                	jmp    804266 <open+0x125>
		}	
		return fd2num(fd_store);
  804253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804257:	48 89 c7             	mov    %rax,%rdi
  80425a:	48 b8 53 37 80 00 00 	movabs $0x803753,%rax
  804261:	00 00 00 
  804264:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  804266:	c9                   	leaveq 
  804267:	c3                   	retq   

0000000000804268 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  804268:	55                   	push   %rbp
  804269:	48 89 e5             	mov    %rsp,%rbp
  80426c:	48 83 ec 10          	sub    $0x10,%rsp
  804270:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  804274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804278:	8b 50 0c             	mov    0xc(%rax),%edx
  80427b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804282:	00 00 00 
  804285:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  804287:	be 00 00 00 00       	mov    $0x0,%esi
  80428c:	bf 06 00 00 00       	mov    $0x6,%edi
  804291:	48 b8 ba 40 80 00 00 	movabs $0x8040ba,%rax
  804298:	00 00 00 
  80429b:	ff d0                	callq  *%rax
}
  80429d:	c9                   	leaveq 
  80429e:	c3                   	retq   

000000000080429f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80429f:	55                   	push   %rbp
  8042a0:	48 89 e5             	mov    %rsp,%rbp
  8042a3:	48 83 ec 30          	sub    $0x30,%rsp
  8042a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8042b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8042ba:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042bf:	74 07                	je     8042c8 <devfile_read+0x29>
  8042c1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8042c6:	75 07                	jne    8042cf <devfile_read+0x30>
		return -E_INVAL;
  8042c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8042cd:	eb 77                	jmp    804346 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8042cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042d3:	8b 50 0c             	mov    0xc(%rax),%edx
  8042d6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042dd:	00 00 00 
  8042e0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8042e2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042e9:	00 00 00 
  8042ec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8042f0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8042f4:	be 00 00 00 00       	mov    $0x0,%esi
  8042f9:	bf 03 00 00 00       	mov    $0x3,%edi
  8042fe:	48 b8 ba 40 80 00 00 	movabs $0x8040ba,%rax
  804305:	00 00 00 
  804308:	ff d0                	callq  *%rax
  80430a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80430d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804311:	7f 05                	jg     804318 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  804313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804316:	eb 2e                	jmp    804346 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  804318:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80431b:	48 63 d0             	movslq %eax,%rdx
  80431e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804322:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804329:	00 00 00 
  80432c:	48 89 c7             	mov    %rax,%rdi
  80432f:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  804336:	00 00 00 
  804339:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  80433b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80433f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  804343:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  804346:	c9                   	leaveq 
  804347:	c3                   	retq   

0000000000804348 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  804348:	55                   	push   %rbp
  804349:	48 89 e5             	mov    %rsp,%rbp
  80434c:	48 83 ec 30          	sub    $0x30,%rsp
  804350:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804354:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804358:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  80435c:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  804363:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804368:	74 07                	je     804371 <devfile_write+0x29>
  80436a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80436f:	75 08                	jne    804379 <devfile_write+0x31>
		return r;
  804371:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804374:	e9 9a 00 00 00       	jmpq   804413 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  804379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80437d:	8b 50 0c             	mov    0xc(%rax),%edx
  804380:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804387:	00 00 00 
  80438a:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80438c:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  804393:	00 
  804394:	76 08                	jbe    80439e <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  804396:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80439d:	00 
	}
	fsipcbuf.write.req_n = n;
  80439e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043a5:	00 00 00 
  8043a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8043ac:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8043b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8043b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043b8:	48 89 c6             	mov    %rax,%rsi
  8043bb:	48 bf 10 b0 80 00 00 	movabs $0x80b010,%rdi
  8043c2:	00 00 00 
  8043c5:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  8043cc:	00 00 00 
  8043cf:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8043d1:	be 00 00 00 00       	mov    $0x0,%esi
  8043d6:	bf 04 00 00 00       	mov    $0x4,%edi
  8043db:	48 b8 ba 40 80 00 00 	movabs $0x8040ba,%rax
  8043e2:	00 00 00 
  8043e5:	ff d0                	callq  *%rax
  8043e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ee:	7f 20                	jg     804410 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8043f0:	48 bf ee 70 80 00 00 	movabs $0x8070ee,%rdi
  8043f7:	00 00 00 
  8043fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ff:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  804406:	00 00 00 
  804409:	ff d2                	callq  *%rdx
		return r;
  80440b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80440e:	eb 03                	jmp    804413 <devfile_write+0xcb>
	}
	return r;
  804410:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  804413:	c9                   	leaveq 
  804414:	c3                   	retq   

0000000000804415 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  804415:	55                   	push   %rbp
  804416:	48 89 e5             	mov    %rsp,%rbp
  804419:	48 83 ec 20          	sub    $0x20,%rsp
  80441d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804421:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  804425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804429:	8b 50 0c             	mov    0xc(%rax),%edx
  80442c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804433:	00 00 00 
  804436:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  804438:	be 00 00 00 00       	mov    $0x0,%esi
  80443d:	bf 05 00 00 00       	mov    $0x5,%edi
  804442:	48 b8 ba 40 80 00 00 	movabs $0x8040ba,%rax
  804449:	00 00 00 
  80444c:	ff d0                	callq  *%rax
  80444e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804451:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804455:	79 05                	jns    80445c <devfile_stat+0x47>
		return r;
  804457:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80445a:	eb 56                	jmp    8044b2 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80445c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804460:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804467:	00 00 00 
  80446a:	48 89 c7             	mov    %rax,%rdi
  80446d:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  804474:	00 00 00 
  804477:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  804479:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804480:	00 00 00 
  804483:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  804489:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80448d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  804493:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80449a:	00 00 00 
  80449d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8044a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044a7:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8044ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044b2:	c9                   	leaveq 
  8044b3:	c3                   	retq   

00000000008044b4 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8044b4:	55                   	push   %rbp
  8044b5:	48 89 e5             	mov    %rsp,%rbp
  8044b8:	48 83 ec 10          	sub    $0x10,%rsp
  8044bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044c0:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8044c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c7:	8b 50 0c             	mov    0xc(%rax),%edx
  8044ca:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044d1:	00 00 00 
  8044d4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8044d6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044dd:	00 00 00 
  8044e0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8044e3:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8044e6:	be 00 00 00 00       	mov    $0x0,%esi
  8044eb:	bf 02 00 00 00       	mov    $0x2,%edi
  8044f0:	48 b8 ba 40 80 00 00 	movabs $0x8040ba,%rax
  8044f7:	00 00 00 
  8044fa:	ff d0                	callq  *%rax
}
  8044fc:	c9                   	leaveq 
  8044fd:	c3                   	retq   

00000000008044fe <remove>:

// Delete a file
int
remove(const char *path)
{
  8044fe:	55                   	push   %rbp
  8044ff:	48 89 e5             	mov    %rsp,%rbp
  804502:	48 83 ec 10          	sub    $0x10,%rsp
  804506:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80450a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80450e:	48 89 c7             	mov    %rax,%rdi
  804511:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  804518:	00 00 00 
  80451b:	ff d0                	callq  *%rax
  80451d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  804522:	7e 07                	jle    80452b <remove+0x2d>
		return -E_BAD_PATH;
  804524:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  804529:	eb 33                	jmp    80455e <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80452b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80452f:	48 89 c6             	mov    %rax,%rsi
  804532:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  804539:	00 00 00 
  80453c:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  804543:	00 00 00 
  804546:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  804548:	be 00 00 00 00       	mov    $0x0,%esi
  80454d:	bf 07 00 00 00       	mov    $0x7,%edi
  804552:	48 b8 ba 40 80 00 00 	movabs $0x8040ba,%rax
  804559:	00 00 00 
  80455c:	ff d0                	callq  *%rax
}
  80455e:	c9                   	leaveq 
  80455f:	c3                   	retq   

0000000000804560 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  804560:	55                   	push   %rbp
  804561:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  804564:	be 00 00 00 00       	mov    $0x0,%esi
  804569:	bf 08 00 00 00       	mov    $0x8,%edi
  80456e:	48 b8 ba 40 80 00 00 	movabs $0x8040ba,%rax
  804575:	00 00 00 
  804578:	ff d0                	callq  *%rax
}
  80457a:	5d                   	pop    %rbp
  80457b:	c3                   	retq   

000000000080457c <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80457c:	55                   	push   %rbp
  80457d:	48 89 e5             	mov    %rsp,%rbp
  804580:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  804587:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80458e:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  804595:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80459c:	be 00 00 00 00       	mov    $0x0,%esi
  8045a1:	48 89 c7             	mov    %rax,%rdi
  8045a4:	48 b8 41 41 80 00 00 	movabs $0x804141,%rax
  8045ab:	00 00 00 
  8045ae:	ff d0                	callq  *%rax
  8045b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8045b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b7:	79 28                	jns    8045e1 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8045b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045bc:	89 c6                	mov    %eax,%esi
  8045be:	48 bf 0a 71 80 00 00 	movabs $0x80710a,%rdi
  8045c5:	00 00 00 
  8045c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8045cd:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  8045d4:	00 00 00 
  8045d7:	ff d2                	callq  *%rdx
		return fd_src;
  8045d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045dc:	e9 74 01 00 00       	jmpq   804755 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8045e1:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8045e8:	be 01 01 00 00       	mov    $0x101,%esi
  8045ed:	48 89 c7             	mov    %rax,%rdi
  8045f0:	48 b8 41 41 80 00 00 	movabs $0x804141,%rax
  8045f7:	00 00 00 
  8045fa:	ff d0                	callq  *%rax
  8045fc:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8045ff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804603:	79 39                	jns    80463e <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  804605:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804608:	89 c6                	mov    %eax,%esi
  80460a:	48 bf 20 71 80 00 00 	movabs $0x807120,%rdi
  804611:	00 00 00 
  804614:	b8 00 00 00 00       	mov    $0x0,%eax
  804619:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  804620:	00 00 00 
  804623:	ff d2                	callq  *%rdx
		close(fd_src);
  804625:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804628:	89 c7                	mov    %eax,%edi
  80462a:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  804631:	00 00 00 
  804634:	ff d0                	callq  *%rax
		return fd_dest;
  804636:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804639:	e9 17 01 00 00       	jmpq   804755 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80463e:	eb 74                	jmp    8046b4 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  804640:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804643:	48 63 d0             	movslq %eax,%rdx
  804646:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80464d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804650:	48 89 ce             	mov    %rcx,%rsi
  804653:	89 c7                	mov    %eax,%edi
  804655:	48 b8 b5 3d 80 00 00 	movabs $0x803db5,%rax
  80465c:	00 00 00 
  80465f:	ff d0                	callq  *%rax
  804661:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  804664:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  804668:	79 4a                	jns    8046b4 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80466a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80466d:	89 c6                	mov    %eax,%esi
  80466f:	48 bf 3a 71 80 00 00 	movabs $0x80713a,%rdi
  804676:	00 00 00 
  804679:	b8 00 00 00 00       	mov    $0x0,%eax
  80467e:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  804685:	00 00 00 
  804688:	ff d2                	callq  *%rdx
			close(fd_src);
  80468a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80468d:	89 c7                	mov    %eax,%edi
  80468f:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  804696:	00 00 00 
  804699:	ff d0                	callq  *%rax
			close(fd_dest);
  80469b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80469e:	89 c7                	mov    %eax,%edi
  8046a0:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  8046a7:	00 00 00 
  8046aa:	ff d0                	callq  *%rax
			return write_size;
  8046ac:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8046af:	e9 a1 00 00 00       	jmpq   804755 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8046b4:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8046bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046be:	ba 00 02 00 00       	mov    $0x200,%edx
  8046c3:	48 89 ce             	mov    %rcx,%rsi
  8046c6:	89 c7                	mov    %eax,%edi
  8046c8:	48 b8 6b 3c 80 00 00 	movabs $0x803c6b,%rax
  8046cf:	00 00 00 
  8046d2:	ff d0                	callq  *%rax
  8046d4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8046d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8046db:	0f 8f 5f ff ff ff    	jg     804640 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8046e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8046e5:	79 47                	jns    80472e <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8046e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8046ea:	89 c6                	mov    %eax,%esi
  8046ec:	48 bf 4d 71 80 00 00 	movabs $0x80714d,%rdi
  8046f3:	00 00 00 
  8046f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8046fb:	48 ba 5d 14 80 00 00 	movabs $0x80145d,%rdx
  804702:	00 00 00 
  804705:	ff d2                	callq  *%rdx
		close(fd_src);
  804707:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80470a:	89 c7                	mov    %eax,%edi
  80470c:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  804713:	00 00 00 
  804716:	ff d0                	callq  *%rax
		close(fd_dest);
  804718:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80471b:	89 c7                	mov    %eax,%edi
  80471d:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  804724:	00 00 00 
  804727:	ff d0                	callq  *%rax
		return read_size;
  804729:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80472c:	eb 27                	jmp    804755 <copy+0x1d9>
	}
	close(fd_src);
  80472e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804731:	89 c7                	mov    %eax,%edi
  804733:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  80473a:	00 00 00 
  80473d:	ff d0                	callq  *%rax
	close(fd_dest);
  80473f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804742:	89 c7                	mov    %eax,%edi
  804744:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  80474b:	00 00 00 
  80474e:	ff d0                	callq  *%rax
	return 0;
  804750:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  804755:	c9                   	leaveq 
  804756:	c3                   	retq   

0000000000804757 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  804757:	55                   	push   %rbp
  804758:	48 89 e5             	mov    %rsp,%rbp
  80475b:	48 83 ec 20          	sub    $0x20,%rsp
  80475f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  804763:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804767:	8b 40 0c             	mov    0xc(%rax),%eax
  80476a:	85 c0                	test   %eax,%eax
  80476c:	7e 67                	jle    8047d5 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80476e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804772:	8b 40 04             	mov    0x4(%rax),%eax
  804775:	48 63 d0             	movslq %eax,%rdx
  804778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80477c:	48 8d 48 10          	lea    0x10(%rax),%rcx
  804780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804784:	8b 00                	mov    (%rax),%eax
  804786:	48 89 ce             	mov    %rcx,%rsi
  804789:	89 c7                	mov    %eax,%edi
  80478b:	48 b8 b5 3d 80 00 00 	movabs $0x803db5,%rax
  804792:	00 00 00 
  804795:	ff d0                	callq  *%rax
  804797:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  80479a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80479e:	7e 13                	jle    8047b3 <writebuf+0x5c>
			b->result += result;
  8047a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047a4:	8b 50 08             	mov    0x8(%rax),%edx
  8047a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047aa:	01 c2                	add    %eax,%edx
  8047ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047b0:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8047b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047b7:	8b 40 04             	mov    0x4(%rax),%eax
  8047ba:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8047bd:	74 16                	je     8047d5 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8047bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8047c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047c8:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8047cc:	89 c2                	mov    %eax,%edx
  8047ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047d2:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  8047d5:	c9                   	leaveq 
  8047d6:	c3                   	retq   

00000000008047d7 <putch>:

static void
putch(int ch, void *thunk)
{
  8047d7:	55                   	push   %rbp
  8047d8:	48 89 e5             	mov    %rsp,%rbp
  8047db:	48 83 ec 20          	sub    $0x20,%rsp
  8047df:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  8047e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  8047ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047f2:	8b 40 04             	mov    0x4(%rax),%eax
  8047f5:	8d 48 01             	lea    0x1(%rax),%ecx
  8047f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8047fc:	89 4a 04             	mov    %ecx,0x4(%rdx)
  8047ff:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804802:	89 d1                	mov    %edx,%ecx
  804804:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804808:	48 98                	cltq   
  80480a:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  80480e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804812:	8b 40 04             	mov    0x4(%rax),%eax
  804815:	3d 00 01 00 00       	cmp    $0x100,%eax
  80481a:	75 1e                	jne    80483a <putch+0x63>
		writebuf(b);
  80481c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804820:	48 89 c7             	mov    %rax,%rdi
  804823:	48 b8 57 47 80 00 00 	movabs $0x804757,%rax
  80482a:	00 00 00 
  80482d:	ff d0                	callq  *%rax
		b->idx = 0;
  80482f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804833:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  80483a:	c9                   	leaveq 
  80483b:	c3                   	retq   

000000000080483c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80483c:	55                   	push   %rbp
  80483d:	48 89 e5             	mov    %rsp,%rbp
  804840:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  804847:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80484d:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  804854:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  80485b:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  804861:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  804867:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80486e:	00 00 00 
	b.result = 0;
  804871:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  804878:	00 00 00 
	b.error = 1;
  80487b:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  804882:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  804885:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  80488c:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  804893:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80489a:	48 89 c6             	mov    %rax,%rsi
  80489d:	48 bf d7 47 80 00 00 	movabs $0x8047d7,%rdi
  8048a4:	00 00 00 
  8048a7:	48 b8 10 18 80 00 00 	movabs $0x801810,%rax
  8048ae:	00 00 00 
  8048b1:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8048b3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8048b9:	85 c0                	test   %eax,%eax
  8048bb:	7e 16                	jle    8048d3 <vfprintf+0x97>
		writebuf(&b);
  8048bd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8048c4:	48 89 c7             	mov    %rax,%rdi
  8048c7:	48 b8 57 47 80 00 00 	movabs $0x804757,%rax
  8048ce:	00 00 00 
  8048d1:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8048d3:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8048d9:	85 c0                	test   %eax,%eax
  8048db:	74 08                	je     8048e5 <vfprintf+0xa9>
  8048dd:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8048e3:	eb 06                	jmp    8048eb <vfprintf+0xaf>
  8048e5:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8048eb:	c9                   	leaveq 
  8048ec:	c3                   	retq   

00000000008048ed <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8048ed:	55                   	push   %rbp
  8048ee:	48 89 e5             	mov    %rsp,%rbp
  8048f1:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8048f8:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  8048fe:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804905:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80490c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804913:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80491a:	84 c0                	test   %al,%al
  80491c:	74 20                	je     80493e <fprintf+0x51>
  80491e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804922:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804926:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80492a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80492e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804932:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804936:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80493a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80493e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804945:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  80494c:	00 00 00 
  80494f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804956:	00 00 00 
  804959:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80495d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804964:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80496b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  804972:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804979:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  804980:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804986:	48 89 ce             	mov    %rcx,%rsi
  804989:	89 c7                	mov    %eax,%edi
  80498b:	48 b8 3c 48 80 00 00 	movabs $0x80483c,%rax
  804992:	00 00 00 
  804995:	ff d0                	callq  *%rax
  804997:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80499d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8049a3:	c9                   	leaveq 
  8049a4:	c3                   	retq   

00000000008049a5 <printf>:

int
printf(const char *fmt, ...)
{
  8049a5:	55                   	push   %rbp
  8049a6:	48 89 e5             	mov    %rsp,%rbp
  8049a9:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8049b0:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8049b7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8049be:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8049c5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8049cc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8049d3:	84 c0                	test   %al,%al
  8049d5:	74 20                	je     8049f7 <printf+0x52>
  8049d7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8049db:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8049df:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8049e3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8049e7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8049eb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8049ef:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8049f3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8049f7:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8049fe:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  804a05:	00 00 00 
  804a08:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804a0f:	00 00 00 
  804a12:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804a16:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804a1d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804a24:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  804a2b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804a32:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804a39:	48 89 c6             	mov    %rax,%rsi
  804a3c:	bf 01 00 00 00       	mov    $0x1,%edi
  804a41:	48 b8 3c 48 80 00 00 	movabs $0x80483c,%rax
  804a48:	00 00 00 
  804a4b:	ff d0                	callq  *%rax
  804a4d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804a53:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804a59:	c9                   	leaveq 
  804a5a:	c3                   	retq   

0000000000804a5b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  804a5b:	55                   	push   %rbp
  804a5c:	48 89 e5             	mov    %rsp,%rbp
  804a5f:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  804a66:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  804a6d:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  804a74:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  804a7b:	be 00 00 00 00       	mov    $0x0,%esi
  804a80:	48 89 c7             	mov    %rax,%rdi
  804a83:	48 b8 41 41 80 00 00 	movabs $0x804141,%rax
  804a8a:	00 00 00 
  804a8d:	ff d0                	callq  *%rax
  804a8f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804a92:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804a96:	79 08                	jns    804aa0 <spawn+0x45>
		return r;
  804a98:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a9b:	e9 14 03 00 00       	jmpq   804db4 <spawn+0x359>
	fd = r;
  804aa0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804aa3:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  804aa6:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  804aad:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  804ab1:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  804ab8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804abb:	ba 00 02 00 00       	mov    $0x200,%edx
  804ac0:	48 89 ce             	mov    %rcx,%rsi
  804ac3:	89 c7                	mov    %eax,%edi
  804ac5:	48 b8 40 3d 80 00 00 	movabs $0x803d40,%rax
  804acc:	00 00 00 
  804acf:	ff d0                	callq  *%rax
  804ad1:	3d 00 02 00 00       	cmp    $0x200,%eax
  804ad6:	75 0d                	jne    804ae5 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  804ad8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804adc:	8b 00                	mov    (%rax),%eax
  804ade:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  804ae3:	74 43                	je     804b28 <spawn+0xcd>
		close(fd);
  804ae5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ae8:	89 c7                	mov    %eax,%edi
  804aea:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  804af1:	00 00 00 
  804af4:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  804af6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804afa:	8b 00                	mov    (%rax),%eax
  804afc:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  804b01:	89 c6                	mov    %eax,%esi
  804b03:	48 bf 68 71 80 00 00 	movabs $0x807168,%rdi
  804b0a:	00 00 00 
  804b0d:	b8 00 00 00 00       	mov    $0x0,%eax
  804b12:	48 b9 5d 14 80 00 00 	movabs $0x80145d,%rcx
  804b19:	00 00 00 
  804b1c:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  804b1e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  804b23:	e9 8c 02 00 00       	jmpq   804db4 <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  804b28:	b8 07 00 00 00       	mov    $0x7,%eax
  804b2d:	cd 30                	int    $0x30
  804b2f:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  804b32:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804b35:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804b38:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804b3c:	79 08                	jns    804b46 <spawn+0xeb>
		return r;
  804b3e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804b41:	e9 6e 02 00 00       	jmpq   804db4 <spawn+0x359>
	child = r;
  804b46:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804b49:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	//thisenv = &envs[ENVX(sys_getenvid())];
	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  804b4c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804b4f:	25 ff 03 00 00       	and    $0x3ff,%eax
  804b54:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804b5b:	00 00 00 
  804b5e:	48 63 d0             	movslq %eax,%rdx
  804b61:	48 89 d0             	mov    %rdx,%rax
  804b64:	48 c1 e0 03          	shl    $0x3,%rax
  804b68:	48 01 d0             	add    %rdx,%rax
  804b6b:	48 c1 e0 05          	shl    $0x5,%rax
  804b6f:	48 01 c8             	add    %rcx,%rax
  804b72:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804b79:	48 89 c6             	mov    %rax,%rsi
  804b7c:	b8 18 00 00 00       	mov    $0x18,%eax
  804b81:	48 89 d7             	mov    %rdx,%rdi
  804b84:	48 89 c1             	mov    %rax,%rcx
  804b87:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  804b8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b8e:	48 8b 40 18          	mov    0x18(%rax),%rax
  804b92:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  804b99:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  804ba0:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  804ba7:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  804bae:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804bb1:	48 89 ce             	mov    %rcx,%rsi
  804bb4:	89 c7                	mov    %eax,%edi
  804bb6:	48 b8 1e 50 80 00 00 	movabs $0x80501e,%rax
  804bbd:	00 00 00 
  804bc0:	ff d0                	callq  *%rax
  804bc2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804bc5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804bc9:	79 08                	jns    804bd3 <spawn+0x178>
		return r;
  804bcb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804bce:	e9 e1 01 00 00       	jmpq   804db4 <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  804bd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bd7:	48 8b 40 20          	mov    0x20(%rax),%rax
  804bdb:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  804be2:	48 01 d0             	add    %rdx,%rax
  804be5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804be9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804bf0:	e9 a3 00 00 00       	jmpq   804c98 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  804bf5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bf9:	8b 00                	mov    (%rax),%eax
  804bfb:	83 f8 01             	cmp    $0x1,%eax
  804bfe:	74 05                	je     804c05 <spawn+0x1aa>
			continue;
  804c00:	e9 8a 00 00 00       	jmpq   804c8f <spawn+0x234>
		perm = PTE_P | PTE_U;
  804c05:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  804c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c10:	8b 40 04             	mov    0x4(%rax),%eax
  804c13:	83 e0 02             	and    $0x2,%eax
  804c16:	85 c0                	test   %eax,%eax
  804c18:	74 04                	je     804c1e <spawn+0x1c3>
			perm |= PTE_W;
  804c1a:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804c1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c22:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804c26:	41 89 c1             	mov    %eax,%r9d
  804c29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c2d:	4c 8b 40 20          	mov    0x20(%rax),%r8
  804c31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c35:	48 8b 50 28          	mov    0x28(%rax),%rdx
  804c39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c3d:	48 8b 70 10          	mov    0x10(%rax),%rsi
  804c41:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  804c44:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804c47:	8b 7d ec             	mov    -0x14(%rbp),%edi
  804c4a:	89 3c 24             	mov    %edi,(%rsp)
  804c4d:	89 c7                	mov    %eax,%edi
  804c4f:	48 b8 c7 52 80 00 00 	movabs $0x8052c7,%rax
  804c56:	00 00 00 
  804c59:	ff d0                	callq  *%rax
  804c5b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804c5e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804c62:	79 2b                	jns    804c8f <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  804c64:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804c65:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804c68:	89 c7                	mov    %eax,%edi
  804c6a:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  804c71:	00 00 00 
  804c74:	ff d0                	callq  *%rax
	close(fd);
  804c76:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804c79:	89 c7                	mov    %eax,%edi
  804c7b:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  804c82:	00 00 00 
  804c85:	ff d0                	callq  *%rax
	return r;
  804c87:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c8a:	e9 25 01 00 00       	jmpq   804db4 <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804c8f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804c93:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  804c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c9c:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  804ca0:	0f b7 c0             	movzwl %ax,%eax
  804ca3:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  804ca6:	0f 8f 49 ff ff ff    	jg     804bf5 <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  804cac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804caf:	89 c7                	mov    %eax,%edi
  804cb1:	48 b8 49 3a 80 00 00 	movabs $0x803a49,%rax
  804cb8:	00 00 00 
  804cbb:	ff d0                	callq  *%rax
	fd = -1;
  804cbd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  804cc4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804cc7:	89 c7                	mov    %eax,%edi
  804cc9:	48 b8 b3 54 80 00 00 	movabs $0x8054b3,%rax
  804cd0:	00 00 00 
  804cd3:	ff d0                	callq  *%rax
  804cd5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804cd8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804cdc:	79 30                	jns    804d0e <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  804cde:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804ce1:	89 c1                	mov    %eax,%ecx
  804ce3:	48 ba 82 71 80 00 00 	movabs $0x807182,%rdx
  804cea:	00 00 00 
  804ced:	be 82 00 00 00       	mov    $0x82,%esi
  804cf2:	48 bf 98 71 80 00 00 	movabs $0x807198,%rdi
  804cf9:	00 00 00 
  804cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  804d01:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  804d08:	00 00 00 
  804d0b:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  804d0e:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804d15:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804d18:	48 89 d6             	mov    %rdx,%rsi
  804d1b:	89 c7                	mov    %eax,%edi
  804d1d:	48 b8 db 2b 80 00 00 	movabs $0x802bdb,%rax
  804d24:	00 00 00 
  804d27:	ff d0                	callq  *%rax
  804d29:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804d2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804d30:	79 30                	jns    804d62 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  804d32:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804d35:	89 c1                	mov    %eax,%ecx
  804d37:	48 ba a4 71 80 00 00 	movabs $0x8071a4,%rdx
  804d3e:	00 00 00 
  804d41:	be 85 00 00 00       	mov    $0x85,%esi
  804d46:	48 bf 98 71 80 00 00 	movabs $0x807198,%rdi
  804d4d:	00 00 00 
  804d50:	b8 00 00 00 00       	mov    $0x0,%eax
  804d55:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  804d5c:	00 00 00 
  804d5f:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804d62:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804d65:	be 02 00 00 00       	mov    $0x2,%esi
  804d6a:	89 c7                	mov    %eax,%edi
  804d6c:	48 b8 90 2b 80 00 00 	movabs $0x802b90,%rax
  804d73:	00 00 00 
  804d76:	ff d0                	callq  *%rax
  804d78:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804d7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804d7f:	79 30                	jns    804db1 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  804d81:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804d84:	89 c1                	mov    %eax,%ecx
  804d86:	48 ba be 71 80 00 00 	movabs $0x8071be,%rdx
  804d8d:	00 00 00 
  804d90:	be 88 00 00 00       	mov    $0x88,%esi
  804d95:	48 bf 98 71 80 00 00 	movabs $0x807198,%rdi
  804d9c:	00 00 00 
  804d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  804da4:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  804dab:	00 00 00 
  804dae:	41 ff d0             	callq  *%r8

	return child;
  804db1:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  804db4:	c9                   	leaveq 
  804db5:	c3                   	retq   

0000000000804db6 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  804db6:	55                   	push   %rbp
  804db7:	48 89 e5             	mov    %rsp,%rbp
  804dba:	41 55                	push   %r13
  804dbc:	41 54                	push   %r12
  804dbe:	53                   	push   %rbx
  804dbf:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804dc6:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  804dcd:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  804dd4:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  804ddb:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  804de2:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  804de9:	84 c0                	test   %al,%al
  804deb:	74 26                	je     804e13 <spawnl+0x5d>
  804ded:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  804df4:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  804dfb:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  804dff:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  804e03:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  804e07:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  804e0b:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  804e0f:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  804e13:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804e1a:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  804e21:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804e24:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804e2b:	00 00 00 
  804e2e:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804e35:	00 00 00 
  804e38:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804e3c:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804e43:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804e4a:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  804e51:	eb 07                	jmp    804e5a <spawnl+0xa4>
		argc++;
  804e53:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  804e5a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804e60:	83 f8 30             	cmp    $0x30,%eax
  804e63:	73 23                	jae    804e88 <spawnl+0xd2>
  804e65:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804e6c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804e72:	89 c0                	mov    %eax,%eax
  804e74:	48 01 d0             	add    %rdx,%rax
  804e77:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804e7d:	83 c2 08             	add    $0x8,%edx
  804e80:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804e86:	eb 15                	jmp    804e9d <spawnl+0xe7>
  804e88:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804e8f:	48 89 d0             	mov    %rdx,%rax
  804e92:	48 83 c2 08          	add    $0x8,%rdx
  804e96:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804e9d:	48 8b 00             	mov    (%rax),%rax
  804ea0:	48 85 c0             	test   %rax,%rax
  804ea3:	75 ae                	jne    804e53 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  804ea5:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804eab:	83 c0 02             	add    $0x2,%eax
  804eae:	48 89 e2             	mov    %rsp,%rdx
  804eb1:	48 89 d3             	mov    %rdx,%rbx
  804eb4:	48 63 d0             	movslq %eax,%rdx
  804eb7:	48 83 ea 01          	sub    $0x1,%rdx
  804ebb:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  804ec2:	48 63 d0             	movslq %eax,%rdx
  804ec5:	49 89 d4             	mov    %rdx,%r12
  804ec8:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  804ece:	48 63 d0             	movslq %eax,%rdx
  804ed1:	49 89 d2             	mov    %rdx,%r10
  804ed4:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  804eda:	48 98                	cltq   
  804edc:	48 c1 e0 03          	shl    $0x3,%rax
  804ee0:	48 8d 50 07          	lea    0x7(%rax),%rdx
  804ee4:	b8 10 00 00 00       	mov    $0x10,%eax
  804ee9:	48 83 e8 01          	sub    $0x1,%rax
  804eed:	48 01 d0             	add    %rdx,%rax
  804ef0:	bf 10 00 00 00       	mov    $0x10,%edi
  804ef5:	ba 00 00 00 00       	mov    $0x0,%edx
  804efa:	48 f7 f7             	div    %rdi
  804efd:	48 6b c0 10          	imul   $0x10,%rax,%rax
  804f01:	48 29 c4             	sub    %rax,%rsp
  804f04:	48 89 e0             	mov    %rsp,%rax
  804f07:	48 83 c0 07          	add    $0x7,%rax
  804f0b:	48 c1 e8 03          	shr    $0x3,%rax
  804f0f:	48 c1 e0 03          	shl    $0x3,%rax
  804f13:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  804f1a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804f21:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  804f28:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  804f2b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804f31:	8d 50 01             	lea    0x1(%rax),%edx
  804f34:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804f3b:	48 63 d2             	movslq %edx,%rdx
  804f3e:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  804f45:	00 

	va_start(vl, arg0);
  804f46:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804f4d:	00 00 00 
  804f50:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804f57:	00 00 00 
  804f5a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804f5e:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804f65:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804f6c:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  804f73:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  804f7a:	00 00 00 
  804f7d:	eb 63                	jmp    804fe2 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  804f7f:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  804f85:	8d 70 01             	lea    0x1(%rax),%esi
  804f88:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804f8e:	83 f8 30             	cmp    $0x30,%eax
  804f91:	73 23                	jae    804fb6 <spawnl+0x200>
  804f93:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  804f9a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804fa0:	89 c0                	mov    %eax,%eax
  804fa2:	48 01 d0             	add    %rdx,%rax
  804fa5:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804fab:	83 c2 08             	add    $0x8,%edx
  804fae:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804fb4:	eb 15                	jmp    804fcb <spawnl+0x215>
  804fb6:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  804fbd:	48 89 d0             	mov    %rdx,%rax
  804fc0:	48 83 c2 08          	add    $0x8,%rdx
  804fc4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804fcb:	48 8b 08             	mov    (%rax),%rcx
  804fce:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804fd5:	89 f2                	mov    %esi,%edx
  804fd7:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  804fdb:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  804fe2:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804fe8:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  804fee:	77 8f                	ja     804f7f <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  804ff0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804ff7:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  804ffe:	48 89 d6             	mov    %rdx,%rsi
  805001:	48 89 c7             	mov    %rax,%rdi
  805004:	48 b8 5b 4a 80 00 00 	movabs $0x804a5b,%rax
  80500b:	00 00 00 
  80500e:	ff d0                	callq  *%rax
  805010:	48 89 dc             	mov    %rbx,%rsp
}
  805013:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  805017:	5b                   	pop    %rbx
  805018:	41 5c                	pop    %r12
  80501a:	41 5d                	pop    %r13
  80501c:	5d                   	pop    %rbp
  80501d:	c3                   	retq   

000000000080501e <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80501e:	55                   	push   %rbp
  80501f:	48 89 e5             	mov    %rsp,%rbp
  805022:	48 83 ec 50          	sub    $0x50,%rsp
  805026:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805029:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80502d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  805031:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805038:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  805039:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  805040:	eb 33                	jmp    805075 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  805042:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805045:	48 98                	cltq   
  805047:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80504e:	00 
  80504f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805053:	48 01 d0             	add    %rdx,%rax
  805056:	48 8b 00             	mov    (%rax),%rax
  805059:	48 89 c7             	mov    %rax,%rdi
  80505c:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  805063:	00 00 00 
  805066:	ff d0                	callq  *%rax
  805068:	83 c0 01             	add    $0x1,%eax
  80506b:	48 98                	cltq   
  80506d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  805071:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  805075:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805078:	48 98                	cltq   
  80507a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805081:	00 
  805082:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805086:	48 01 d0             	add    %rdx,%rax
  805089:	48 8b 00             	mov    (%rax),%rax
  80508c:	48 85 c0             	test   %rax,%rax
  80508f:	75 b1                	jne    805042 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  805091:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805095:	48 f7 d8             	neg    %rax
  805098:	48 05 00 10 40 00    	add    $0x401000,%rax
  80509e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8050a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8050a6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8050aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050ae:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8050b2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8050b5:	83 c2 01             	add    $0x1,%edx
  8050b8:	c1 e2 03             	shl    $0x3,%edx
  8050bb:	48 63 d2             	movslq %edx,%rdx
  8050be:	48 f7 da             	neg    %rdx
  8050c1:	48 01 d0             	add    %rdx,%rax
  8050c4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8050c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8050cc:	48 83 e8 10          	sub    $0x10,%rax
  8050d0:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8050d6:	77 0a                	ja     8050e2 <init_stack+0xc4>
		return -E_NO_MEM;
  8050d8:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8050dd:	e9 e3 01 00 00       	jmpq   8052c5 <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8050e2:	ba 07 00 00 00       	mov    $0x7,%edx
  8050e7:	be 00 00 40 00       	mov    $0x400000,%esi
  8050ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8050f1:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  8050f8:	00 00 00 
  8050fb:	ff d0                	callq  *%rax
  8050fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805100:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805104:	79 08                	jns    80510e <init_stack+0xf0>
		return r;
  805106:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805109:	e9 b7 01 00 00       	jmpq   8052c5 <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80510e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  805115:	e9 8a 00 00 00       	jmpq   8051a4 <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  80511a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80511d:	48 98                	cltq   
  80511f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805126:	00 
  805127:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80512b:	48 01 c2             	add    %rax,%rdx
  80512e:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805133:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805137:	48 01 c8             	add    %rcx,%rax
  80513a:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805140:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  805143:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805146:	48 98                	cltq   
  805148:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80514f:	00 
  805150:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805154:	48 01 d0             	add    %rdx,%rax
  805157:	48 8b 10             	mov    (%rax),%rdx
  80515a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80515e:	48 89 d6             	mov    %rdx,%rsi
  805161:	48 89 c7             	mov    %rax,%rdi
  805164:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  80516b:	00 00 00 
  80516e:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  805170:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805173:	48 98                	cltq   
  805175:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80517c:	00 
  80517d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805181:	48 01 d0             	add    %rdx,%rax
  805184:	48 8b 00             	mov    (%rax),%rax
  805187:	48 89 c7             	mov    %rax,%rdi
  80518a:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  805191:	00 00 00 
  805194:	ff d0                	callq  *%rax
  805196:	48 98                	cltq   
  805198:	48 83 c0 01          	add    $0x1,%rax
  80519c:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8051a0:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8051a4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8051a7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8051aa:	0f 8c 6a ff ff ff    	jl     80511a <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8051b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051b3:	48 98                	cltq   
  8051b5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8051bc:	00 
  8051bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8051c1:	48 01 d0             	add    %rdx,%rax
  8051c4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8051cb:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8051d2:	00 
  8051d3:	74 35                	je     80520a <init_stack+0x1ec>
  8051d5:	48 b9 d8 71 80 00 00 	movabs $0x8071d8,%rcx
  8051dc:	00 00 00 
  8051df:	48 ba fe 71 80 00 00 	movabs $0x8071fe,%rdx
  8051e6:	00 00 00 
  8051e9:	be f1 00 00 00       	mov    $0xf1,%esi
  8051ee:	48 bf 98 71 80 00 00 	movabs $0x807198,%rdi
  8051f5:	00 00 00 
  8051f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8051fd:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  805204:	00 00 00 
  805207:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80520a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80520e:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  805212:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805217:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80521b:	48 01 c8             	add    %rcx,%rax
  80521e:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805224:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  805227:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80522b:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80522f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805232:	48 98                	cltq   
  805234:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  805237:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80523c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805240:	48 01 d0             	add    %rdx,%rax
  805243:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805249:	48 89 c2             	mov    %rax,%rdx
  80524c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  805250:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  805253:	8b 45 cc             	mov    -0x34(%rbp),%eax
  805256:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80525c:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805261:	89 c2                	mov    %eax,%edx
  805263:	be 00 00 40 00       	mov    $0x400000,%esi
  805268:	bf 00 00 00 00       	mov    $0x0,%edi
  80526d:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  805274:	00 00 00 
  805277:	ff d0                	callq  *%rax
  805279:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80527c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805280:	79 02                	jns    805284 <init_stack+0x266>
		goto error;
  805282:	eb 28                	jmp    8052ac <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  805284:	be 00 00 40 00       	mov    $0x400000,%esi
  805289:	bf 00 00 00 00       	mov    $0x0,%edi
  80528e:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805295:	00 00 00 
  805298:	ff d0                	callq  *%rax
  80529a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80529d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8052a1:	79 02                	jns    8052a5 <init_stack+0x287>
		goto error;
  8052a3:	eb 07                	jmp    8052ac <init_stack+0x28e>

	return 0;
  8052a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8052aa:	eb 19                	jmp    8052c5 <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8052ac:	be 00 00 40 00       	mov    $0x400000,%esi
  8052b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8052b6:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  8052bd:	00 00 00 
  8052c0:	ff d0                	callq  *%rax
	return r;
  8052c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8052c5:	c9                   	leaveq 
  8052c6:	c3                   	retq   

00000000008052c7 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8052c7:	55                   	push   %rbp
  8052c8:	48 89 e5             	mov    %rsp,%rbp
  8052cb:	48 83 ec 50          	sub    $0x50,%rsp
  8052cf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8052d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8052d6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8052da:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8052dd:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8052e1:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8052e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8052e9:	25 ff 0f 00 00       	and    $0xfff,%eax
  8052ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8052f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8052f5:	74 21                	je     805318 <map_segment+0x51>
		va -= i;
  8052f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052fa:	48 98                	cltq   
  8052fc:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  805300:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805303:	48 98                	cltq   
  805305:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  805309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80530c:	48 98                	cltq   
  80530e:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  805312:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805315:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805318:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80531f:	e9 79 01 00 00       	jmpq   80549d <map_segment+0x1d6>
		if (i >= filesz) {
  805324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805327:	48 98                	cltq   
  805329:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  80532d:	72 3c                	jb     80536b <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80532f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805332:	48 63 d0             	movslq %eax,%rdx
  805335:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805339:	48 01 d0             	add    %rdx,%rax
  80533c:	48 89 c1             	mov    %rax,%rcx
  80533f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805342:	8b 55 10             	mov    0x10(%rbp),%edx
  805345:	48 89 ce             	mov    %rcx,%rsi
  805348:	89 c7                	mov    %eax,%edi
  80534a:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  805351:	00 00 00 
  805354:	ff d0                	callq  *%rax
  805356:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805359:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80535d:	0f 89 33 01 00 00    	jns    805496 <map_segment+0x1cf>
				return r;
  805363:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805366:	e9 46 01 00 00       	jmpq   8054b1 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80536b:	ba 07 00 00 00       	mov    $0x7,%edx
  805370:	be 00 00 40 00       	mov    $0x400000,%esi
  805375:	bf 00 00 00 00       	mov    $0x0,%edi
  80537a:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  805381:	00 00 00 
  805384:	ff d0                	callq  *%rax
  805386:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805389:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80538d:	79 08                	jns    805397 <map_segment+0xd0>
				return r;
  80538f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805392:	e9 1a 01 00 00       	jmpq   8054b1 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  805397:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80539a:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80539d:	01 c2                	add    %eax,%edx
  80539f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8053a2:	89 d6                	mov    %edx,%esi
  8053a4:	89 c7                	mov    %eax,%edi
  8053a6:	48 b8 89 3e 80 00 00 	movabs $0x803e89,%rax
  8053ad:	00 00 00 
  8053b0:	ff d0                	callq  *%rax
  8053b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8053b5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8053b9:	79 08                	jns    8053c3 <map_segment+0xfc>
				return r;
  8053bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8053be:	e9 ee 00 00 00       	jmpq   8054b1 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8053c3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8053ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053cd:	48 98                	cltq   
  8053cf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8053d3:	48 29 c2             	sub    %rax,%rdx
  8053d6:	48 89 d0             	mov    %rdx,%rax
  8053d9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8053dd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8053e0:	48 63 d0             	movslq %eax,%rdx
  8053e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053e7:	48 39 c2             	cmp    %rax,%rdx
  8053ea:	48 0f 47 d0          	cmova  %rax,%rdx
  8053ee:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8053f1:	be 00 00 40 00       	mov    $0x400000,%esi
  8053f6:	89 c7                	mov    %eax,%edi
  8053f8:	48 b8 40 3d 80 00 00 	movabs $0x803d40,%rax
  8053ff:	00 00 00 
  805402:	ff d0                	callq  *%rax
  805404:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805407:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80540b:	79 08                	jns    805415 <map_segment+0x14e>
				return r;
  80540d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805410:	e9 9c 00 00 00       	jmpq   8054b1 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  805415:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805418:	48 63 d0             	movslq %eax,%rdx
  80541b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80541f:	48 01 d0             	add    %rdx,%rax
  805422:	48 89 c2             	mov    %rax,%rdx
  805425:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805428:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80542c:	48 89 d1             	mov    %rdx,%rcx
  80542f:	89 c2                	mov    %eax,%edx
  805431:	be 00 00 40 00       	mov    $0x400000,%esi
  805436:	bf 00 00 00 00       	mov    $0x0,%edi
  80543b:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  805442:	00 00 00 
  805445:	ff d0                	callq  *%rax
  805447:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80544a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80544e:	79 30                	jns    805480 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  805450:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805453:	89 c1                	mov    %eax,%ecx
  805455:	48 ba 13 72 80 00 00 	movabs $0x807213,%rdx
  80545c:	00 00 00 
  80545f:	be 24 01 00 00       	mov    $0x124,%esi
  805464:	48 bf 98 71 80 00 00 	movabs $0x807198,%rdi
  80546b:	00 00 00 
  80546e:	b8 00 00 00 00       	mov    $0x0,%eax
  805473:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  80547a:	00 00 00 
  80547d:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  805480:	be 00 00 40 00       	mov    $0x400000,%esi
  805485:	bf 00 00 00 00       	mov    $0x0,%edi
  80548a:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805491:	00 00 00 
  805494:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805496:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80549d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054a0:	48 98                	cltq   
  8054a2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8054a6:	0f 82 78 fe ff ff    	jb     805324 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8054ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8054b1:	c9                   	leaveq 
  8054b2:	c3                   	retq   

00000000008054b3 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8054b3:	55                   	push   %rbp
  8054b4:	48 89 e5             	mov    %rsp,%rbp
  8054b7:	48 83 ec 20          	sub    $0x20,%rsp
  8054bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  8054be:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  8054c5:	00 
  8054c6:	e9 c9 00 00 00       	jmpq   805594 <copy_shared_pages+0xe1>
        {
            if(!((uvpml4e[VPML4E(addr)])&&(uvpde[VPDPE(addr)]) && (uvpd[VPD(addr)]  )))
  8054cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054cf:	48 c1 e8 27          	shr    $0x27,%rax
  8054d3:	48 89 c2             	mov    %rax,%rdx
  8054d6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8054dd:	01 00 00 
  8054e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8054e4:	48 85 c0             	test   %rax,%rax
  8054e7:	74 3c                	je     805525 <copy_shared_pages+0x72>
  8054e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054ed:	48 c1 e8 1e          	shr    $0x1e,%rax
  8054f1:	48 89 c2             	mov    %rax,%rdx
  8054f4:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8054fb:	01 00 00 
  8054fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805502:	48 85 c0             	test   %rax,%rax
  805505:	74 1e                	je     805525 <copy_shared_pages+0x72>
  805507:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80550b:	48 c1 e8 15          	shr    $0x15,%rax
  80550f:	48 89 c2             	mov    %rax,%rdx
  805512:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805519:	01 00 00 
  80551c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805520:	48 85 c0             	test   %rax,%rax
  805523:	75 02                	jne    805527 <copy_shared_pages+0x74>
                continue;
  805525:	eb 65                	jmp    80558c <copy_shared_pages+0xd9>

            if((uvpt[VPN(addr)] & PTE_SHARE) != 0)
  805527:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80552b:	48 c1 e8 0c          	shr    $0xc,%rax
  80552f:	48 89 c2             	mov    %rax,%rdx
  805532:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805539:	01 00 00 
  80553c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805540:	25 00 04 00 00       	and    $0x400,%eax
  805545:	48 85 c0             	test   %rax,%rax
  805548:	74 42                	je     80558c <copy_shared_pages+0xd9>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);
  80554a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80554e:	48 c1 e8 0c          	shr    $0xc,%rax
  805552:	48 89 c2             	mov    %rax,%rdx
  805555:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80555c:	01 00 00 
  80555f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805563:	25 07 0e 00 00       	and    $0xe07,%eax
  805568:	89 c6                	mov    %eax,%esi
  80556a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80556e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805572:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805575:	41 89 f0             	mov    %esi,%r8d
  805578:	48 89 c6             	mov    %rax,%rsi
  80557b:	bf 00 00 00 00       	mov    $0x0,%edi
  805580:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  805587:	00 00 00 
  80558a:	ff d0                	callq  *%rax
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
    uint64_t addr;
	for(addr = UTEXT;addr < UTOP; addr += PGSIZE)
  80558c:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  805593:	00 
  805594:	48 b8 ff ff 7f 00 80 	movabs $0x80007fffff,%rax
  80559b:	00 00 00 
  80559e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8055a2:	0f 86 23 ff ff ff    	jbe    8054cb <copy_shared_pages+0x18>
            {
            	sys_page_map(0, (void *)addr, child, (void *)addr, uvpt[VPN(addr)]&PTE_USER);

            }
        }
     return 0;
  8055a8:	b8 00 00 00 00       	mov    $0x0,%eax
 }
  8055ad:	c9                   	leaveq 
  8055ae:	c3                   	retq   

00000000008055af <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8055af:	55                   	push   %rbp
  8055b0:	48 89 e5             	mov    %rsp,%rbp
  8055b3:	48 83 ec 20          	sub    $0x20,%rsp
  8055b7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8055ba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8055be:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8055c1:	48 89 d6             	mov    %rdx,%rsi
  8055c4:	89 c7                	mov    %eax,%edi
  8055c6:	48 b8 39 38 80 00 00 	movabs $0x803839,%rax
  8055cd:	00 00 00 
  8055d0:	ff d0                	callq  *%rax
  8055d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8055d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8055d9:	79 05                	jns    8055e0 <fd2sockid+0x31>
		return r;
  8055db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055de:	eb 24                	jmp    805604 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8055e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8055e4:	8b 10                	mov    (%rax),%edx
  8055e6:	48 b8 e0 90 80 00 00 	movabs $0x8090e0,%rax
  8055ed:	00 00 00 
  8055f0:	8b 00                	mov    (%rax),%eax
  8055f2:	39 c2                	cmp    %eax,%edx
  8055f4:	74 07                	je     8055fd <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8055f6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8055fb:	eb 07                	jmp    805604 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8055fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805601:	8b 40 0c             	mov    0xc(%rax),%eax
}
  805604:	c9                   	leaveq 
  805605:	c3                   	retq   

0000000000805606 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  805606:	55                   	push   %rbp
  805607:	48 89 e5             	mov    %rsp,%rbp
  80560a:	48 83 ec 20          	sub    $0x20,%rsp
  80560e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  805611:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  805615:	48 89 c7             	mov    %rax,%rdi
  805618:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  80561f:	00 00 00 
  805622:	ff d0                	callq  *%rax
  805624:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805627:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80562b:	78 26                	js     805653 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80562d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805631:	ba 07 04 00 00       	mov    $0x407,%edx
  805636:	48 89 c6             	mov    %rax,%rsi
  805639:	bf 00 00 00 00       	mov    $0x0,%edi
  80563e:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  805645:	00 00 00 
  805648:	ff d0                	callq  *%rax
  80564a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80564d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805651:	79 16                	jns    805669 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  805653:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805656:	89 c7                	mov    %eax,%edi
  805658:	48 b8 13 5b 80 00 00 	movabs $0x805b13,%rax
  80565f:	00 00 00 
  805662:	ff d0                	callq  *%rax
		return r;
  805664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805667:	eb 3a                	jmp    8056a3 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  805669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80566d:	48 ba e0 90 80 00 00 	movabs $0x8090e0,%rdx
  805674:	00 00 00 
  805677:	8b 12                	mov    (%rdx),%edx
  805679:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80567b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80567f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  805686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80568a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80568d:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  805690:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805694:	48 89 c7             	mov    %rax,%rdi
  805697:	48 b8 53 37 80 00 00 	movabs $0x803753,%rax
  80569e:	00 00 00 
  8056a1:	ff d0                	callq  *%rax
}
  8056a3:	c9                   	leaveq 
  8056a4:	c3                   	retq   

00000000008056a5 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8056a5:	55                   	push   %rbp
  8056a6:	48 89 e5             	mov    %rsp,%rbp
  8056a9:	48 83 ec 30          	sub    $0x30,%rsp
  8056ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8056b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8056b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8056b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8056bb:	89 c7                	mov    %eax,%edi
  8056bd:	48 b8 af 55 80 00 00 	movabs $0x8055af,%rax
  8056c4:	00 00 00 
  8056c7:	ff d0                	callq  *%rax
  8056c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056d0:	79 05                	jns    8056d7 <accept+0x32>
		return r;
  8056d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056d5:	eb 3b                	jmp    805712 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8056d7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8056db:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8056df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056e2:	48 89 ce             	mov    %rcx,%rsi
  8056e5:	89 c7                	mov    %eax,%edi
  8056e7:	48 b8 f0 59 80 00 00 	movabs $0x8059f0,%rax
  8056ee:	00 00 00 
  8056f1:	ff d0                	callq  *%rax
  8056f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056fa:	79 05                	jns    805701 <accept+0x5c>
		return r;
  8056fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056ff:	eb 11                	jmp    805712 <accept+0x6d>
	return alloc_sockfd(r);
  805701:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805704:	89 c7                	mov    %eax,%edi
  805706:	48 b8 06 56 80 00 00 	movabs $0x805606,%rax
  80570d:	00 00 00 
  805710:	ff d0                	callq  *%rax
}
  805712:	c9                   	leaveq 
  805713:	c3                   	retq   

0000000000805714 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805714:	55                   	push   %rbp
  805715:	48 89 e5             	mov    %rsp,%rbp
  805718:	48 83 ec 20          	sub    $0x20,%rsp
  80571c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80571f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805723:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805726:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805729:	89 c7                	mov    %eax,%edi
  80572b:	48 b8 af 55 80 00 00 	movabs $0x8055af,%rax
  805732:	00 00 00 
  805735:	ff d0                	callq  *%rax
  805737:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80573a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80573e:	79 05                	jns    805745 <bind+0x31>
		return r;
  805740:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805743:	eb 1b                	jmp    805760 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  805745:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805748:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80574c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80574f:	48 89 ce             	mov    %rcx,%rsi
  805752:	89 c7                	mov    %eax,%edi
  805754:	48 b8 6f 5a 80 00 00 	movabs $0x805a6f,%rax
  80575b:	00 00 00 
  80575e:	ff d0                	callq  *%rax
}
  805760:	c9                   	leaveq 
  805761:	c3                   	retq   

0000000000805762 <shutdown>:

int
shutdown(int s, int how)
{
  805762:	55                   	push   %rbp
  805763:	48 89 e5             	mov    %rsp,%rbp
  805766:	48 83 ec 20          	sub    $0x20,%rsp
  80576a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80576d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805770:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805773:	89 c7                	mov    %eax,%edi
  805775:	48 b8 af 55 80 00 00 	movabs $0x8055af,%rax
  80577c:	00 00 00 
  80577f:	ff d0                	callq  *%rax
  805781:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805784:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805788:	79 05                	jns    80578f <shutdown+0x2d>
		return r;
  80578a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80578d:	eb 16                	jmp    8057a5 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80578f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805792:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805795:	89 d6                	mov    %edx,%esi
  805797:	89 c7                	mov    %eax,%edi
  805799:	48 b8 d3 5a 80 00 00 	movabs $0x805ad3,%rax
  8057a0:	00 00 00 
  8057a3:	ff d0                	callq  *%rax
}
  8057a5:	c9                   	leaveq 
  8057a6:	c3                   	retq   

00000000008057a7 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8057a7:	55                   	push   %rbp
  8057a8:	48 89 e5             	mov    %rsp,%rbp
  8057ab:	48 83 ec 10          	sub    $0x10,%rsp
  8057af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8057b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8057b7:	48 89 c7             	mov    %rax,%rdi
  8057ba:	48 b8 4b 67 80 00 00 	movabs $0x80674b,%rax
  8057c1:	00 00 00 
  8057c4:	ff d0                	callq  *%rax
  8057c6:	83 f8 01             	cmp    $0x1,%eax
  8057c9:	75 17                	jne    8057e2 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8057cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8057cf:	8b 40 0c             	mov    0xc(%rax),%eax
  8057d2:	89 c7                	mov    %eax,%edi
  8057d4:	48 b8 13 5b 80 00 00 	movabs $0x805b13,%rax
  8057db:	00 00 00 
  8057de:	ff d0                	callq  *%rax
  8057e0:	eb 05                	jmp    8057e7 <devsock_close+0x40>
	else
		return 0;
  8057e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8057e7:	c9                   	leaveq 
  8057e8:	c3                   	retq   

00000000008057e9 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8057e9:	55                   	push   %rbp
  8057ea:	48 89 e5             	mov    %rsp,%rbp
  8057ed:	48 83 ec 20          	sub    $0x20,%rsp
  8057f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8057f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8057f8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8057fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8057fe:	89 c7                	mov    %eax,%edi
  805800:	48 b8 af 55 80 00 00 	movabs $0x8055af,%rax
  805807:	00 00 00 
  80580a:	ff d0                	callq  *%rax
  80580c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80580f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805813:	79 05                	jns    80581a <connect+0x31>
		return r;
  805815:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805818:	eb 1b                	jmp    805835 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80581a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80581d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805821:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805824:	48 89 ce             	mov    %rcx,%rsi
  805827:	89 c7                	mov    %eax,%edi
  805829:	48 b8 40 5b 80 00 00 	movabs $0x805b40,%rax
  805830:	00 00 00 
  805833:	ff d0                	callq  *%rax
}
  805835:	c9                   	leaveq 
  805836:	c3                   	retq   

0000000000805837 <listen>:

int
listen(int s, int backlog)
{
  805837:	55                   	push   %rbp
  805838:	48 89 e5             	mov    %rsp,%rbp
  80583b:	48 83 ec 20          	sub    $0x20,%rsp
  80583f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805842:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805845:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805848:	89 c7                	mov    %eax,%edi
  80584a:	48 b8 af 55 80 00 00 	movabs $0x8055af,%rax
  805851:	00 00 00 
  805854:	ff d0                	callq  *%rax
  805856:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805859:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80585d:	79 05                	jns    805864 <listen+0x2d>
		return r;
  80585f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805862:	eb 16                	jmp    80587a <listen+0x43>
	return nsipc_listen(r, backlog);
  805864:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805867:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80586a:	89 d6                	mov    %edx,%esi
  80586c:	89 c7                	mov    %eax,%edi
  80586e:	48 b8 a4 5b 80 00 00 	movabs $0x805ba4,%rax
  805875:	00 00 00 
  805878:	ff d0                	callq  *%rax
}
  80587a:	c9                   	leaveq 
  80587b:	c3                   	retq   

000000000080587c <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80587c:	55                   	push   %rbp
  80587d:	48 89 e5             	mov    %rsp,%rbp
  805880:	48 83 ec 20          	sub    $0x20,%rsp
  805884:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805888:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80588c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  805890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805894:	89 c2                	mov    %eax,%edx
  805896:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80589a:	8b 40 0c             	mov    0xc(%rax),%eax
  80589d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8058a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8058a6:	89 c7                	mov    %eax,%edi
  8058a8:	48 b8 e4 5b 80 00 00 	movabs $0x805be4,%rax
  8058af:	00 00 00 
  8058b2:	ff d0                	callq  *%rax
}
  8058b4:	c9                   	leaveq 
  8058b5:	c3                   	retq   

00000000008058b6 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8058b6:	55                   	push   %rbp
  8058b7:	48 89 e5             	mov    %rsp,%rbp
  8058ba:	48 83 ec 20          	sub    $0x20,%rsp
  8058be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8058c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8058c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8058ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058ce:	89 c2                	mov    %eax,%edx
  8058d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8058d4:	8b 40 0c             	mov    0xc(%rax),%eax
  8058d7:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8058db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8058e0:	89 c7                	mov    %eax,%edi
  8058e2:	48 b8 b0 5c 80 00 00 	movabs $0x805cb0,%rax
  8058e9:	00 00 00 
  8058ec:	ff d0                	callq  *%rax
}
  8058ee:	c9                   	leaveq 
  8058ef:	c3                   	retq   

00000000008058f0 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8058f0:	55                   	push   %rbp
  8058f1:	48 89 e5             	mov    %rsp,%rbp
  8058f4:	48 83 ec 10          	sub    $0x10,%rsp
  8058f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8058fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  805900:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805904:	48 be 35 72 80 00 00 	movabs $0x807235,%rsi
  80590b:	00 00 00 
  80590e:	48 89 c7             	mov    %rax,%rdi
  805911:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  805918:	00 00 00 
  80591b:	ff d0                	callq  *%rax
	return 0;
  80591d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805922:	c9                   	leaveq 
  805923:	c3                   	retq   

0000000000805924 <socket>:

int
socket(int domain, int type, int protocol)
{
  805924:	55                   	push   %rbp
  805925:	48 89 e5             	mov    %rsp,%rbp
  805928:	48 83 ec 20          	sub    $0x20,%rsp
  80592c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80592f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805932:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  805935:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  805938:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80593b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80593e:	89 ce                	mov    %ecx,%esi
  805940:	89 c7                	mov    %eax,%edi
  805942:	48 b8 68 5d 80 00 00 	movabs $0x805d68,%rax
  805949:	00 00 00 
  80594c:	ff d0                	callq  *%rax
  80594e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805951:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805955:	79 05                	jns    80595c <socket+0x38>
		return r;
  805957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80595a:	eb 11                	jmp    80596d <socket+0x49>
	return alloc_sockfd(r);
  80595c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80595f:	89 c7                	mov    %eax,%edi
  805961:	48 b8 06 56 80 00 00 	movabs $0x805606,%rax
  805968:	00 00 00 
  80596b:	ff d0                	callq  *%rax
}
  80596d:	c9                   	leaveq 
  80596e:	c3                   	retq   

000000000080596f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80596f:	55                   	push   %rbp
  805970:	48 89 e5             	mov    %rsp,%rbp
  805973:	48 83 ec 10          	sub    $0x10,%rsp
  805977:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80597a:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  805981:	00 00 00 
  805984:	8b 00                	mov    (%rax),%eax
  805986:	85 c0                	test   %eax,%eax
  805988:	75 1d                	jne    8059a7 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80598a:	bf 02 00 00 00       	mov    $0x2,%edi
  80598f:	48 b8 c9 66 80 00 00 	movabs $0x8066c9,%rax
  805996:	00 00 00 
  805999:	ff d0                	callq  *%rax
  80599b:	48 ba 24 a4 80 00 00 	movabs $0x80a424,%rdx
  8059a2:	00 00 00 
  8059a5:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8059a7:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  8059ae:	00 00 00 
  8059b1:	8b 00                	mov    (%rax),%eax
  8059b3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8059b6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8059bb:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  8059c2:	00 00 00 
  8059c5:	89 c7                	mov    %eax,%edi
  8059c7:	48 b8 67 66 80 00 00 	movabs $0x806667,%rax
  8059ce:	00 00 00 
  8059d1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8059d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8059d8:	be 00 00 00 00       	mov    $0x0,%esi
  8059dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8059e2:	48 b8 61 65 80 00 00 	movabs $0x806561,%rax
  8059e9:	00 00 00 
  8059ec:	ff d0                	callq  *%rax
}
  8059ee:	c9                   	leaveq 
  8059ef:	c3                   	retq   

00000000008059f0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8059f0:	55                   	push   %rbp
  8059f1:	48 89 e5             	mov    %rsp,%rbp
  8059f4:	48 83 ec 30          	sub    $0x30,%rsp
  8059f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8059fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8059ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  805a03:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805a0a:	00 00 00 
  805a0d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805a10:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  805a12:	bf 01 00 00 00       	mov    $0x1,%edi
  805a17:	48 b8 6f 59 80 00 00 	movabs $0x80596f,%rax
  805a1e:	00 00 00 
  805a21:	ff d0                	callq  *%rax
  805a23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a2a:	78 3e                	js     805a6a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  805a2c:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805a33:	00 00 00 
  805a36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  805a3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a3e:	8b 40 10             	mov    0x10(%rax),%eax
  805a41:	89 c2                	mov    %eax,%edx
  805a43:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  805a47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a4b:	48 89 ce             	mov    %rcx,%rsi
  805a4e:	48 89 c7             	mov    %rax,%rdi
  805a51:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  805a58:	00 00 00 
  805a5b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  805a5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a61:	8b 50 10             	mov    0x10(%rax),%edx
  805a64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805a68:	89 10                	mov    %edx,(%rax)
	}
	return r;
  805a6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805a6d:	c9                   	leaveq 
  805a6e:	c3                   	retq   

0000000000805a6f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805a6f:	55                   	push   %rbp
  805a70:	48 89 e5             	mov    %rsp,%rbp
  805a73:	48 83 ec 10          	sub    $0x10,%rsp
  805a77:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805a7a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805a7e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  805a81:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805a88:	00 00 00 
  805a8b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805a8e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  805a90:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805a93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a97:	48 89 c6             	mov    %rax,%rsi
  805a9a:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  805aa1:	00 00 00 
  805aa4:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  805aab:	00 00 00 
  805aae:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  805ab0:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805ab7:	00 00 00 
  805aba:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805abd:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  805ac0:	bf 02 00 00 00       	mov    $0x2,%edi
  805ac5:	48 b8 6f 59 80 00 00 	movabs $0x80596f,%rax
  805acc:	00 00 00 
  805acf:	ff d0                	callq  *%rax
}
  805ad1:	c9                   	leaveq 
  805ad2:	c3                   	retq   

0000000000805ad3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  805ad3:	55                   	push   %rbp
  805ad4:	48 89 e5             	mov    %rsp,%rbp
  805ad7:	48 83 ec 10          	sub    $0x10,%rsp
  805adb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805ade:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  805ae1:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805ae8:	00 00 00 
  805aeb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805aee:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  805af0:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805af7:	00 00 00 
  805afa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805afd:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  805b00:	bf 03 00 00 00       	mov    $0x3,%edi
  805b05:	48 b8 6f 59 80 00 00 	movabs $0x80596f,%rax
  805b0c:	00 00 00 
  805b0f:	ff d0                	callq  *%rax
}
  805b11:	c9                   	leaveq 
  805b12:	c3                   	retq   

0000000000805b13 <nsipc_close>:

int
nsipc_close(int s)
{
  805b13:	55                   	push   %rbp
  805b14:	48 89 e5             	mov    %rsp,%rbp
  805b17:	48 83 ec 10          	sub    $0x10,%rsp
  805b1b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  805b1e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b25:	00 00 00 
  805b28:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805b2b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  805b2d:	bf 04 00 00 00       	mov    $0x4,%edi
  805b32:	48 b8 6f 59 80 00 00 	movabs $0x80596f,%rax
  805b39:	00 00 00 
  805b3c:	ff d0                	callq  *%rax
}
  805b3e:	c9                   	leaveq 
  805b3f:	c3                   	retq   

0000000000805b40 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805b40:	55                   	push   %rbp
  805b41:	48 89 e5             	mov    %rsp,%rbp
  805b44:	48 83 ec 10          	sub    $0x10,%rsp
  805b48:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805b4b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805b4f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  805b52:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b59:	00 00 00 
  805b5c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805b5f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  805b61:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805b64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b68:	48 89 c6             	mov    %rax,%rsi
  805b6b:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  805b72:	00 00 00 
  805b75:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  805b7c:	00 00 00 
  805b7f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  805b81:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b88:	00 00 00 
  805b8b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805b8e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  805b91:	bf 05 00 00 00       	mov    $0x5,%edi
  805b96:	48 b8 6f 59 80 00 00 	movabs $0x80596f,%rax
  805b9d:	00 00 00 
  805ba0:	ff d0                	callq  *%rax
}
  805ba2:	c9                   	leaveq 
  805ba3:	c3                   	retq   

0000000000805ba4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  805ba4:	55                   	push   %rbp
  805ba5:	48 89 e5             	mov    %rsp,%rbp
  805ba8:	48 83 ec 10          	sub    $0x10,%rsp
  805bac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805baf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  805bb2:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805bb9:	00 00 00 
  805bbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805bbf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  805bc1:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805bc8:	00 00 00 
  805bcb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805bce:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  805bd1:	bf 06 00 00 00       	mov    $0x6,%edi
  805bd6:	48 b8 6f 59 80 00 00 	movabs $0x80596f,%rax
  805bdd:	00 00 00 
  805be0:	ff d0                	callq  *%rax
}
  805be2:	c9                   	leaveq 
  805be3:	c3                   	retq   

0000000000805be4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  805be4:	55                   	push   %rbp
  805be5:	48 89 e5             	mov    %rsp,%rbp
  805be8:	48 83 ec 30          	sub    $0x30,%rsp
  805bec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805bef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805bf3:	89 55 e8             	mov    %edx,-0x18(%rbp)
  805bf6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  805bf9:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805c00:	00 00 00 
  805c03:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805c06:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  805c08:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805c0f:	00 00 00 
  805c12:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805c15:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  805c18:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805c1f:	00 00 00 
  805c22:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805c25:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  805c28:	bf 07 00 00 00       	mov    $0x7,%edi
  805c2d:	48 b8 6f 59 80 00 00 	movabs $0x80596f,%rax
  805c34:	00 00 00 
  805c37:	ff d0                	callq  *%rax
  805c39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805c3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c40:	78 69                	js     805cab <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  805c42:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  805c49:	7f 08                	jg     805c53 <nsipc_recv+0x6f>
  805c4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c4e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  805c51:	7e 35                	jle    805c88 <nsipc_recv+0xa4>
  805c53:	48 b9 3c 72 80 00 00 	movabs $0x80723c,%rcx
  805c5a:	00 00 00 
  805c5d:	48 ba 51 72 80 00 00 	movabs $0x807251,%rdx
  805c64:	00 00 00 
  805c67:	be 61 00 00 00       	mov    $0x61,%esi
  805c6c:	48 bf 66 72 80 00 00 	movabs $0x807266,%rdi
  805c73:	00 00 00 
  805c76:	b8 00 00 00 00       	mov    $0x0,%eax
  805c7b:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  805c82:	00 00 00 
  805c85:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  805c88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c8b:	48 63 d0             	movslq %eax,%rdx
  805c8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805c92:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  805c99:	00 00 00 
  805c9c:	48 89 c7             	mov    %rax,%rdi
  805c9f:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  805ca6:	00 00 00 
  805ca9:	ff d0                	callq  *%rax
	}

	return r;
  805cab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805cae:	c9                   	leaveq 
  805caf:	c3                   	retq   

0000000000805cb0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  805cb0:	55                   	push   %rbp
  805cb1:	48 89 e5             	mov    %rsp,%rbp
  805cb4:	48 83 ec 20          	sub    $0x20,%rsp
  805cb8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805cbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805cbf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  805cc2:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  805cc5:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805ccc:	00 00 00 
  805ccf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805cd2:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  805cd4:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  805cdb:	7e 35                	jle    805d12 <nsipc_send+0x62>
  805cdd:	48 b9 72 72 80 00 00 	movabs $0x807272,%rcx
  805ce4:	00 00 00 
  805ce7:	48 ba 51 72 80 00 00 	movabs $0x807251,%rdx
  805cee:	00 00 00 
  805cf1:	be 6c 00 00 00       	mov    $0x6c,%esi
  805cf6:	48 bf 66 72 80 00 00 	movabs $0x807266,%rdi
  805cfd:	00 00 00 
  805d00:	b8 00 00 00 00       	mov    $0x0,%eax
  805d05:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  805d0c:	00 00 00 
  805d0f:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  805d12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805d15:	48 63 d0             	movslq %eax,%rdx
  805d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805d1c:	48 89 c6             	mov    %rax,%rsi
  805d1f:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  805d26:	00 00 00 
  805d29:	48 b8 90 24 80 00 00 	movabs $0x802490,%rax
  805d30:	00 00 00 
  805d33:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  805d35:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d3c:	00 00 00 
  805d3f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805d42:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  805d45:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d4c:	00 00 00 
  805d4f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805d52:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  805d55:	bf 08 00 00 00       	mov    $0x8,%edi
  805d5a:	48 b8 6f 59 80 00 00 	movabs $0x80596f,%rax
  805d61:	00 00 00 
  805d64:	ff d0                	callq  *%rax
}
  805d66:	c9                   	leaveq 
  805d67:	c3                   	retq   

0000000000805d68 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  805d68:	55                   	push   %rbp
  805d69:	48 89 e5             	mov    %rsp,%rbp
  805d6c:	48 83 ec 10          	sub    $0x10,%rsp
  805d70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805d73:	89 75 f8             	mov    %esi,-0x8(%rbp)
  805d76:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  805d79:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d80:	00 00 00 
  805d83:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805d86:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  805d88:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d8f:	00 00 00 
  805d92:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805d95:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  805d98:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d9f:	00 00 00 
  805da2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805da5:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  805da8:	bf 09 00 00 00       	mov    $0x9,%edi
  805dad:	48 b8 6f 59 80 00 00 	movabs $0x80596f,%rax
  805db4:	00 00 00 
  805db7:	ff d0                	callq  *%rax
}
  805db9:	c9                   	leaveq 
  805dba:	c3                   	retq   

0000000000805dbb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  805dbb:	55                   	push   %rbp
  805dbc:	48 89 e5             	mov    %rsp,%rbp
  805dbf:	53                   	push   %rbx
  805dc0:	48 83 ec 38          	sub    $0x38,%rsp
  805dc4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805dc8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  805dcc:	48 89 c7             	mov    %rax,%rdi
  805dcf:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  805dd6:	00 00 00 
  805dd9:	ff d0                	callq  *%rax
  805ddb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805dde:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805de2:	0f 88 bf 01 00 00    	js     805fa7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805de8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805dec:	ba 07 04 00 00       	mov    $0x407,%edx
  805df1:	48 89 c6             	mov    %rax,%rsi
  805df4:	bf 00 00 00 00       	mov    $0x0,%edi
  805df9:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  805e00:	00 00 00 
  805e03:	ff d0                	callq  *%rax
  805e05:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805e08:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805e0c:	0f 88 95 01 00 00    	js     805fa7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805e12:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805e16:	48 89 c7             	mov    %rax,%rdi
  805e19:	48 b8 a1 37 80 00 00 	movabs $0x8037a1,%rax
  805e20:	00 00 00 
  805e23:	ff d0                	callq  *%rax
  805e25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805e28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805e2c:	0f 88 5d 01 00 00    	js     805f8f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805e32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805e36:	ba 07 04 00 00       	mov    $0x407,%edx
  805e3b:	48 89 c6             	mov    %rax,%rsi
  805e3e:	bf 00 00 00 00       	mov    $0x0,%edi
  805e43:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  805e4a:	00 00 00 
  805e4d:	ff d0                	callq  *%rax
  805e4f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805e52:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805e56:	0f 88 33 01 00 00    	js     805f8f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805e5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805e60:	48 89 c7             	mov    %rax,%rdi
  805e63:	48 b8 76 37 80 00 00 	movabs $0x803776,%rax
  805e6a:	00 00 00 
  805e6d:	ff d0                	callq  *%rax
  805e6f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805e73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805e77:	ba 07 04 00 00       	mov    $0x407,%edx
  805e7c:	48 89 c6             	mov    %rax,%rsi
  805e7f:	bf 00 00 00 00       	mov    $0x0,%edi
  805e84:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  805e8b:	00 00 00 
  805e8e:	ff d0                	callq  *%rax
  805e90:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805e93:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805e97:	79 05                	jns    805e9e <pipe+0xe3>
		goto err2;
  805e99:	e9 d9 00 00 00       	jmpq   805f77 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805e9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805ea2:	48 89 c7             	mov    %rax,%rdi
  805ea5:	48 b8 76 37 80 00 00 	movabs $0x803776,%rax
  805eac:	00 00 00 
  805eaf:	ff d0                	callq  *%rax
  805eb1:	48 89 c2             	mov    %rax,%rdx
  805eb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805eb8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  805ebe:	48 89 d1             	mov    %rdx,%rcx
  805ec1:	ba 00 00 00 00       	mov    $0x0,%edx
  805ec6:	48 89 c6             	mov    %rax,%rsi
  805ec9:	bf 00 00 00 00       	mov    $0x0,%edi
  805ece:	48 b8 eb 2a 80 00 00 	movabs $0x802aeb,%rax
  805ed5:	00 00 00 
  805ed8:	ff d0                	callq  *%rax
  805eda:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805edd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805ee1:	79 1b                	jns    805efe <pipe+0x143>
		goto err3;
  805ee3:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  805ee4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805ee8:	48 89 c6             	mov    %rax,%rsi
  805eeb:	bf 00 00 00 00       	mov    $0x0,%edi
  805ef0:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805ef7:	00 00 00 
  805efa:	ff d0                	callq  *%rax
  805efc:	eb 79                	jmp    805f77 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  805efe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f02:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  805f09:	00 00 00 
  805f0c:	8b 12                	mov    (%rdx),%edx
  805f0e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  805f10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  805f1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f1f:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  805f26:	00 00 00 
  805f29:	8b 12                	mov    (%rdx),%edx
  805f2b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  805f2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f31:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  805f38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f3c:	48 89 c7             	mov    %rax,%rdi
  805f3f:	48 b8 53 37 80 00 00 	movabs $0x803753,%rax
  805f46:	00 00 00 
  805f49:	ff d0                	callq  *%rax
  805f4b:	89 c2                	mov    %eax,%edx
  805f4d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805f51:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  805f53:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805f57:	48 8d 58 04          	lea    0x4(%rax),%rbx
  805f5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f5f:	48 89 c7             	mov    %rax,%rdi
  805f62:	48 b8 53 37 80 00 00 	movabs $0x803753,%rax
  805f69:	00 00 00 
  805f6c:	ff d0                	callq  *%rax
  805f6e:	89 03                	mov    %eax,(%rbx)
	return 0;
  805f70:	b8 00 00 00 00       	mov    $0x0,%eax
  805f75:	eb 33                	jmp    805faa <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  805f77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805f7b:	48 89 c6             	mov    %rax,%rsi
  805f7e:	bf 00 00 00 00       	mov    $0x0,%edi
  805f83:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805f8a:	00 00 00 
  805f8d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  805f8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f93:	48 89 c6             	mov    %rax,%rsi
  805f96:	bf 00 00 00 00       	mov    $0x0,%edi
  805f9b:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  805fa2:	00 00 00 
  805fa5:	ff d0                	callq  *%rax
err:
	return r;
  805fa7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  805faa:	48 83 c4 38          	add    $0x38,%rsp
  805fae:	5b                   	pop    %rbx
  805faf:	5d                   	pop    %rbp
  805fb0:	c3                   	retq   

0000000000805fb1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  805fb1:	55                   	push   %rbp
  805fb2:	48 89 e5             	mov    %rsp,%rbp
  805fb5:	53                   	push   %rbx
  805fb6:	48 83 ec 28          	sub    $0x28,%rsp
  805fba:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805fbe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  805fc2:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  805fc9:	00 00 00 
  805fcc:	48 8b 00             	mov    (%rax),%rax
  805fcf:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  805fd5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  805fd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805fdc:	48 89 c7             	mov    %rax,%rdi
  805fdf:	48 b8 4b 67 80 00 00 	movabs $0x80674b,%rax
  805fe6:	00 00 00 
  805fe9:	ff d0                	callq  *%rax
  805feb:	89 c3                	mov    %eax,%ebx
  805fed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805ff1:	48 89 c7             	mov    %rax,%rdi
  805ff4:	48 b8 4b 67 80 00 00 	movabs $0x80674b,%rax
  805ffb:	00 00 00 
  805ffe:	ff d0                	callq  *%rax
  806000:	39 c3                	cmp    %eax,%ebx
  806002:	0f 94 c0             	sete   %al
  806005:	0f b6 c0             	movzbl %al,%eax
  806008:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80600b:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806012:	00 00 00 
  806015:	48 8b 00             	mov    (%rax),%rax
  806018:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80601e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  806021:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806024:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806027:	75 05                	jne    80602e <_pipeisclosed+0x7d>
			return ret;
  806029:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80602c:	eb 4f                	jmp    80607d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80602e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806031:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806034:	74 42                	je     806078 <_pipeisclosed+0xc7>
  806036:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80603a:	75 3c                	jne    806078 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80603c:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806043:	00 00 00 
  806046:	48 8b 00             	mov    (%rax),%rax
  806049:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80604f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806052:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806055:	89 c6                	mov    %eax,%esi
  806057:	48 bf 83 72 80 00 00 	movabs $0x807283,%rdi
  80605e:	00 00 00 
  806061:	b8 00 00 00 00       	mov    $0x0,%eax
  806066:	49 b8 5d 14 80 00 00 	movabs $0x80145d,%r8
  80606d:	00 00 00 
  806070:	41 ff d0             	callq  *%r8
	}
  806073:	e9 4a ff ff ff       	jmpq   805fc2 <_pipeisclosed+0x11>
  806078:	e9 45 ff ff ff       	jmpq   805fc2 <_pipeisclosed+0x11>
}
  80607d:	48 83 c4 28          	add    $0x28,%rsp
  806081:	5b                   	pop    %rbx
  806082:	5d                   	pop    %rbp
  806083:	c3                   	retq   

0000000000806084 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  806084:	55                   	push   %rbp
  806085:	48 89 e5             	mov    %rsp,%rbp
  806088:	48 83 ec 30          	sub    $0x30,%rsp
  80608c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80608f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  806093:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806096:	48 89 d6             	mov    %rdx,%rsi
  806099:	89 c7                	mov    %eax,%edi
  80609b:	48 b8 39 38 80 00 00 	movabs $0x803839,%rax
  8060a2:	00 00 00 
  8060a5:	ff d0                	callq  *%rax
  8060a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8060aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8060ae:	79 05                	jns    8060b5 <pipeisclosed+0x31>
		return r;
  8060b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8060b3:	eb 31                	jmp    8060e6 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8060b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8060b9:	48 89 c7             	mov    %rax,%rdi
  8060bc:	48 b8 76 37 80 00 00 	movabs $0x803776,%rax
  8060c3:	00 00 00 
  8060c6:	ff d0                	callq  *%rax
  8060c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8060cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8060d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8060d4:	48 89 d6             	mov    %rdx,%rsi
  8060d7:	48 89 c7             	mov    %rax,%rdi
  8060da:	48 b8 b1 5f 80 00 00 	movabs $0x805fb1,%rax
  8060e1:	00 00 00 
  8060e4:	ff d0                	callq  *%rax
}
  8060e6:	c9                   	leaveq 
  8060e7:	c3                   	retq   

00000000008060e8 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8060e8:	55                   	push   %rbp
  8060e9:	48 89 e5             	mov    %rsp,%rbp
  8060ec:	48 83 ec 40          	sub    $0x40,%rsp
  8060f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8060f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8060f8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8060fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806100:	48 89 c7             	mov    %rax,%rdi
  806103:	48 b8 76 37 80 00 00 	movabs $0x803776,%rax
  80610a:	00 00 00 
  80610d:	ff d0                	callq  *%rax
  80610f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806113:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806117:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80611b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806122:	00 
  806123:	e9 92 00 00 00       	jmpq   8061ba <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  806128:	eb 41                	jmp    80616b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80612a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80612f:	74 09                	je     80613a <devpipe_read+0x52>
				return i;
  806131:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806135:	e9 92 00 00 00       	jmpq   8061cc <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80613a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80613e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806142:	48 89 d6             	mov    %rdx,%rsi
  806145:	48 89 c7             	mov    %rax,%rdi
  806148:	48 b8 b1 5f 80 00 00 	movabs $0x805fb1,%rax
  80614f:	00 00 00 
  806152:	ff d0                	callq  *%rax
  806154:	85 c0                	test   %eax,%eax
  806156:	74 07                	je     80615f <devpipe_read+0x77>
				return 0;
  806158:	b8 00 00 00 00       	mov    $0x0,%eax
  80615d:	eb 6d                	jmp    8061cc <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80615f:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  806166:	00 00 00 
  806169:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80616b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80616f:	8b 10                	mov    (%rax),%edx
  806171:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806175:	8b 40 04             	mov    0x4(%rax),%eax
  806178:	39 c2                	cmp    %eax,%edx
  80617a:	74 ae                	je     80612a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80617c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806180:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806184:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  806188:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80618c:	8b 00                	mov    (%rax),%eax
  80618e:	99                   	cltd   
  80618f:	c1 ea 1b             	shr    $0x1b,%edx
  806192:	01 d0                	add    %edx,%eax
  806194:	83 e0 1f             	and    $0x1f,%eax
  806197:	29 d0                	sub    %edx,%eax
  806199:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80619d:	48 98                	cltq   
  80619f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8061a4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8061a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8061aa:	8b 00                	mov    (%rax),%eax
  8061ac:	8d 50 01             	lea    0x1(%rax),%edx
  8061af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8061b3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8061b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8061ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8061be:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8061c2:	0f 82 60 ff ff ff    	jb     806128 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8061c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8061cc:	c9                   	leaveq 
  8061cd:	c3                   	retq   

00000000008061ce <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8061ce:	55                   	push   %rbp
  8061cf:	48 89 e5             	mov    %rsp,%rbp
  8061d2:	48 83 ec 40          	sub    $0x40,%rsp
  8061d6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8061da:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8061de:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8061e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8061e6:	48 89 c7             	mov    %rax,%rdi
  8061e9:	48 b8 76 37 80 00 00 	movabs $0x803776,%rax
  8061f0:	00 00 00 
  8061f3:	ff d0                	callq  *%rax
  8061f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8061f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8061fd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806201:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806208:	00 
  806209:	e9 8e 00 00 00       	jmpq   80629c <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80620e:	eb 31                	jmp    806241 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  806210:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806214:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806218:	48 89 d6             	mov    %rdx,%rsi
  80621b:	48 89 c7             	mov    %rax,%rdi
  80621e:	48 b8 b1 5f 80 00 00 	movabs $0x805fb1,%rax
  806225:	00 00 00 
  806228:	ff d0                	callq  *%rax
  80622a:	85 c0                	test   %eax,%eax
  80622c:	74 07                	je     806235 <devpipe_write+0x67>
				return 0;
  80622e:	b8 00 00 00 00       	mov    $0x0,%eax
  806233:	eb 79                	jmp    8062ae <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806235:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  80623c:	00 00 00 
  80623f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806245:	8b 40 04             	mov    0x4(%rax),%eax
  806248:	48 63 d0             	movslq %eax,%rdx
  80624b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80624f:	8b 00                	mov    (%rax),%eax
  806251:	48 98                	cltq   
  806253:	48 83 c0 20          	add    $0x20,%rax
  806257:	48 39 c2             	cmp    %rax,%rdx
  80625a:	73 b4                	jae    806210 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80625c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806260:	8b 40 04             	mov    0x4(%rax),%eax
  806263:	99                   	cltd   
  806264:	c1 ea 1b             	shr    $0x1b,%edx
  806267:	01 d0                	add    %edx,%eax
  806269:	83 e0 1f             	and    $0x1f,%eax
  80626c:	29 d0                	sub    %edx,%eax
  80626e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806272:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  806276:	48 01 ca             	add    %rcx,%rdx
  806279:	0f b6 0a             	movzbl (%rdx),%ecx
  80627c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806280:	48 98                	cltq   
  806282:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  806286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80628a:	8b 40 04             	mov    0x4(%rax),%eax
  80628d:	8d 50 01             	lea    0x1(%rax),%edx
  806290:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806294:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806297:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80629c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062a0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8062a4:	0f 82 64 ff ff ff    	jb     80620e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8062aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8062ae:	c9                   	leaveq 
  8062af:	c3                   	retq   

00000000008062b0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8062b0:	55                   	push   %rbp
  8062b1:	48 89 e5             	mov    %rsp,%rbp
  8062b4:	48 83 ec 20          	sub    $0x20,%rsp
  8062b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8062bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8062c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8062c4:	48 89 c7             	mov    %rax,%rdi
  8062c7:	48 b8 76 37 80 00 00 	movabs $0x803776,%rax
  8062ce:	00 00 00 
  8062d1:	ff d0                	callq  *%rax
  8062d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8062d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8062db:	48 be 96 72 80 00 00 	movabs $0x807296,%rsi
  8062e2:	00 00 00 
  8062e5:	48 89 c7             	mov    %rax,%rdi
  8062e8:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  8062ef:	00 00 00 
  8062f2:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8062f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062f8:	8b 50 04             	mov    0x4(%rax),%edx
  8062fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062ff:	8b 00                	mov    (%rax),%eax
  806301:	29 c2                	sub    %eax,%edx
  806303:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806307:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80630d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806311:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806318:	00 00 00 
	stat->st_dev = &devpipe;
  80631b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80631f:	48 b9 20 91 80 00 00 	movabs $0x809120,%rcx
  806326:	00 00 00 
  806329:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  806330:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806335:	c9                   	leaveq 
  806336:	c3                   	retq   

0000000000806337 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  806337:	55                   	push   %rbp
  806338:	48 89 e5             	mov    %rsp,%rbp
  80633b:	48 83 ec 10          	sub    $0x10,%rsp
  80633f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  806343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806347:	48 89 c6             	mov    %rax,%rsi
  80634a:	bf 00 00 00 00       	mov    $0x0,%edi
  80634f:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  806356:	00 00 00 
  806359:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80635b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80635f:	48 89 c7             	mov    %rax,%rdi
  806362:	48 b8 76 37 80 00 00 	movabs $0x803776,%rax
  806369:	00 00 00 
  80636c:	ff d0                	callq  *%rax
  80636e:	48 89 c6             	mov    %rax,%rsi
  806371:	bf 00 00 00 00       	mov    $0x0,%edi
  806376:	48 b8 46 2b 80 00 00 	movabs $0x802b46,%rax
  80637d:	00 00 00 
  806380:	ff d0                	callq  *%rax
}
  806382:	c9                   	leaveq 
  806383:	c3                   	retq   

0000000000806384 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  806384:	55                   	push   %rbp
  806385:	48 89 e5             	mov    %rsp,%rbp
  806388:	48 83 ec 20          	sub    $0x20,%rsp
  80638c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80638f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806393:	75 35                	jne    8063ca <wait+0x46>
  806395:	48 b9 9d 72 80 00 00 	movabs $0x80729d,%rcx
  80639c:	00 00 00 
  80639f:	48 ba a8 72 80 00 00 	movabs $0x8072a8,%rdx
  8063a6:	00 00 00 
  8063a9:	be 09 00 00 00       	mov    $0x9,%esi
  8063ae:	48 bf bd 72 80 00 00 	movabs $0x8072bd,%rdi
  8063b5:	00 00 00 
  8063b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8063bd:	49 b8 24 12 80 00 00 	movabs $0x801224,%r8
  8063c4:	00 00 00 
  8063c7:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8063ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8063cd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8063d2:	48 63 d0             	movslq %eax,%rdx
  8063d5:	48 89 d0             	mov    %rdx,%rax
  8063d8:	48 c1 e0 03          	shl    $0x3,%rax
  8063dc:	48 01 d0             	add    %rdx,%rax
  8063df:	48 c1 e0 05          	shl    $0x5,%rax
  8063e3:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8063ea:	00 00 00 
  8063ed:	48 01 d0             	add    %rdx,%rax
  8063f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE){
  8063f4:	eb 0c                	jmp    806402 <wait+0x7e>
	//cprintf("envid is [%d]",envid);
		sys_yield();
  8063f6:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  8063fd:	00 00 00 
  806400:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE){
  806402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806406:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80640c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80640f:	75 0e                	jne    80641f <wait+0x9b>
  806411:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806415:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80641b:	85 c0                	test   %eax,%eax
  80641d:	75 d7                	jne    8063f6 <wait+0x72>
	//cprintf("envid is [%d]",envid);
		sys_yield();
	}
}
  80641f:	c9                   	leaveq 
  806420:	c3                   	retq   

0000000000806421 <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  806421:	55                   	push   %rbp
  806422:	48 89 e5             	mov    %rsp,%rbp
  806425:	48 83 ec 10          	sub    $0x10,%rsp
  806429:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  80642d:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  806434:	00 00 00 
  806437:	48 8b 00             	mov    (%rax),%rax
  80643a:	48 85 c0             	test   %rax,%rax
  80643d:	0f 85 84 00 00 00    	jne    8064c7 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  806443:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80644a:	00 00 00 
  80644d:	48 8b 00             	mov    (%rax),%rax
  806450:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  806456:	ba 07 00 00 00       	mov    $0x7,%edx
  80645b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  806460:	89 c7                	mov    %eax,%edi
  806462:	48 b8 9b 2a 80 00 00 	movabs $0x802a9b,%rax
  806469:	00 00 00 
  80646c:	ff d0                	callq  *%rax
  80646e:	85 c0                	test   %eax,%eax
  806470:	79 2a                	jns    80649c <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  806472:	48 ba c8 72 80 00 00 	movabs $0x8072c8,%rdx
  806479:	00 00 00 
  80647c:	be 23 00 00 00       	mov    $0x23,%esi
  806481:	48 bf ef 72 80 00 00 	movabs $0x8072ef,%rdi
  806488:	00 00 00 
  80648b:	b8 00 00 00 00       	mov    $0x0,%eax
  806490:	48 b9 24 12 80 00 00 	movabs $0x801224,%rcx
  806497:	00 00 00 
  80649a:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  80649c:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8064a3:	00 00 00 
  8064a6:	48 8b 00             	mov    (%rax),%rax
  8064a9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8064af:	48 be da 64 80 00 00 	movabs $0x8064da,%rsi
  8064b6:	00 00 00 
  8064b9:	89 c7                	mov    %eax,%edi
  8064bb:	48 b8 25 2c 80 00 00 	movabs $0x802c25,%rax
  8064c2:	00 00 00 
  8064c5:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8064c7:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  8064ce:	00 00 00 
  8064d1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8064d5:	48 89 10             	mov    %rdx,(%rax)
}
  8064d8:	c9                   	leaveq 
  8064d9:	c3                   	retq   

00000000008064da <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8064da:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8064dd:	48 a1 00 e0 80 00 00 	movabs 0x80e000,%rax
  8064e4:	00 00 00 
call *%rax
  8064e7:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  8064e9:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8064f0:	00 
	movq 152(%rsp), %rcx  //Load RSP
  8064f1:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  8064f8:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  8064f9:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  8064fd:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  806500:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  806507:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  806508:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  80650c:	4c 8b 3c 24          	mov    (%rsp),%r15
  806510:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  806515:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80651a:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80651f:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  806524:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  806529:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80652e:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  806533:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  806538:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80653d:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  806542:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  806547:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80654c:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  806551:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  806556:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  80655a:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  80655e:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  80655f:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  806560:	c3                   	retq   

0000000000806561 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  806561:	55                   	push   %rbp
  806562:	48 89 e5             	mov    %rsp,%rbp
  806565:	48 83 ec 30          	sub    $0x30,%rsp
  806569:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80656d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806571:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  806575:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80657c:	00 00 00 
  80657f:	48 8b 00             	mov    (%rax),%rax
  806582:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  806588:	85 c0                	test   %eax,%eax
  80658a:	75 3c                	jne    8065c8 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80658c:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  806593:	00 00 00 
  806596:	ff d0                	callq  *%rax
  806598:	25 ff 03 00 00       	and    $0x3ff,%eax
  80659d:	48 63 d0             	movslq %eax,%rdx
  8065a0:	48 89 d0             	mov    %rdx,%rax
  8065a3:	48 c1 e0 03          	shl    $0x3,%rax
  8065a7:	48 01 d0             	add    %rdx,%rax
  8065aa:	48 c1 e0 05          	shl    $0x5,%rax
  8065ae:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8065b5:	00 00 00 
  8065b8:	48 01 c2             	add    %rax,%rdx
  8065bb:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8065c2:	00 00 00 
  8065c5:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  8065c8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8065cd:	75 0e                	jne    8065dd <ipc_recv+0x7c>
		pg = (void*) UTOP;
  8065cf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8065d6:	00 00 00 
  8065d9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8065dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8065e1:	48 89 c7             	mov    %rax,%rdi
  8065e4:	48 b8 c4 2c 80 00 00 	movabs $0x802cc4,%rax
  8065eb:	00 00 00 
  8065ee:	ff d0                	callq  *%rax
  8065f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8065f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8065f7:	79 19                	jns    806612 <ipc_recv+0xb1>
		*from_env_store = 0;
  8065f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8065fd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  806603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806607:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  80660d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806610:	eb 53                	jmp    806665 <ipc_recv+0x104>
	}
	if(from_env_store)
  806612:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  806617:	74 19                	je     806632 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  806619:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806620:	00 00 00 
  806623:	48 8b 00             	mov    (%rax),%rax
  806626:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80662c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806630:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  806632:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  806637:	74 19                	je     806652 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  806639:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806640:	00 00 00 
  806643:	48 8b 00             	mov    (%rax),%rax
  806646:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80664c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806650:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  806652:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806659:	00 00 00 
  80665c:	48 8b 00             	mov    (%rax),%rax
  80665f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  806665:	c9                   	leaveq 
  806666:	c3                   	retq   

0000000000806667 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  806667:	55                   	push   %rbp
  806668:	48 89 e5             	mov    %rsp,%rbp
  80666b:	48 83 ec 30          	sub    $0x30,%rsp
  80666f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806672:	89 75 e8             	mov    %esi,-0x18(%rbp)
  806675:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  806679:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80667c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  806681:	75 0e                	jne    806691 <ipc_send+0x2a>
		pg = (void*)UTOP;
  806683:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80668a:	00 00 00 
  80668d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  806691:	8b 75 e8             	mov    -0x18(%rbp),%esi
  806694:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  806697:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80669b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80669e:	89 c7                	mov    %eax,%edi
  8066a0:	48 b8 6f 2c 80 00 00 	movabs $0x802c6f,%rax
  8066a7:	00 00 00 
  8066aa:	ff d0                	callq  *%rax
  8066ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  8066af:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8066b3:	75 0c                	jne    8066c1 <ipc_send+0x5a>
			sys_yield();
  8066b5:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  8066bc:	00 00 00 
  8066bf:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  8066c1:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8066c5:	74 ca                	je     806691 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  8066c7:	c9                   	leaveq 
  8066c8:	c3                   	retq   

00000000008066c9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8066c9:	55                   	push   %rbp
  8066ca:	48 89 e5             	mov    %rsp,%rbp
  8066cd:	48 83 ec 14          	sub    $0x14,%rsp
  8066d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8066d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8066db:	eb 5e                	jmp    80673b <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8066dd:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8066e4:	00 00 00 
  8066e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066ea:	48 63 d0             	movslq %eax,%rdx
  8066ed:	48 89 d0             	mov    %rdx,%rax
  8066f0:	48 c1 e0 03          	shl    $0x3,%rax
  8066f4:	48 01 d0             	add    %rdx,%rax
  8066f7:	48 c1 e0 05          	shl    $0x5,%rax
  8066fb:	48 01 c8             	add    %rcx,%rax
  8066fe:	48 05 d0 00 00 00    	add    $0xd0,%rax
  806704:	8b 00                	mov    (%rax),%eax
  806706:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  806709:	75 2c                	jne    806737 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80670b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  806712:	00 00 00 
  806715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806718:	48 63 d0             	movslq %eax,%rdx
  80671b:	48 89 d0             	mov    %rdx,%rax
  80671e:	48 c1 e0 03          	shl    $0x3,%rax
  806722:	48 01 d0             	add    %rdx,%rax
  806725:	48 c1 e0 05          	shl    $0x5,%rax
  806729:	48 01 c8             	add    %rcx,%rax
  80672c:	48 05 c0 00 00 00    	add    $0xc0,%rax
  806732:	8b 40 08             	mov    0x8(%rax),%eax
  806735:	eb 12                	jmp    806749 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  806737:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80673b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  806742:	7e 99                	jle    8066dd <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  806744:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806749:	c9                   	leaveq 
  80674a:	c3                   	retq   

000000000080674b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80674b:	55                   	push   %rbp
  80674c:	48 89 e5             	mov    %rsp,%rbp
  80674f:	48 83 ec 18          	sub    $0x18,%rsp
  806753:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  806757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80675b:	48 c1 e8 15          	shr    $0x15,%rax
  80675f:	48 89 c2             	mov    %rax,%rdx
  806762:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  806769:	01 00 00 
  80676c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806770:	83 e0 01             	and    $0x1,%eax
  806773:	48 85 c0             	test   %rax,%rax
  806776:	75 07                	jne    80677f <pageref+0x34>
		return 0;
  806778:	b8 00 00 00 00       	mov    $0x0,%eax
  80677d:	eb 53                	jmp    8067d2 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80677f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806783:	48 c1 e8 0c          	shr    $0xc,%rax
  806787:	48 89 c2             	mov    %rax,%rdx
  80678a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  806791:	01 00 00 
  806794:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806798:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80679c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8067a0:	83 e0 01             	and    $0x1,%eax
  8067a3:	48 85 c0             	test   %rax,%rax
  8067a6:	75 07                	jne    8067af <pageref+0x64>
		return 0;
  8067a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8067ad:	eb 23                	jmp    8067d2 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8067af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8067b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8067b7:	48 89 c2             	mov    %rax,%rdx
  8067ba:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8067c1:	00 00 00 
  8067c4:	48 c1 e2 04          	shl    $0x4,%rdx
  8067c8:	48 01 d0             	add    %rdx,%rax
  8067cb:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8067cf:	0f b7 c0             	movzwl %ax,%eax
}
  8067d2:	c9                   	leaveq 
  8067d3:	c3                   	retq   
