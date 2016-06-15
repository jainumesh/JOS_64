
obj/user/faultregs.debug:     file format elf64-x86-64


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
  80003c:	e8 f5 09 00 00       	callq  800a36 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800053:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800057:	48 89 4d d0          	mov    %rcx,-0x30(%rbp)
  80005b:	4c 89 45 c8          	mov    %r8,-0x38(%rbp)
	int mismatch = 0;
  80005f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800066:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80006a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80006e:	48 89 d1             	mov    %rdx,%rcx
  800071:	48 89 c2             	mov    %rax,%rdx
  800074:	48 be 80 49 80 00 00 	movabs $0x804980,%rsi
  80007b:	00 00 00 
  80007e:	48 bf 81 49 80 00 00 	movabs $0x804981,%rdi
  800085:	00 00 00 
  800088:	b8 00 00 00 00       	mov    $0x0,%eax
  80008d:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800094:	00 00 00 
  800097:	41 ff d0             	callq  *%r8
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_rdi);
  80009a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80009e:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000a6:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000aa:	48 89 d1             	mov    %rdx,%rcx
  8000ad:	48 89 c2             	mov    %rax,%rdx
  8000b0:	48 be 91 49 80 00 00 	movabs $0x804991,%rsi
  8000b7:	00 00 00 
  8000ba:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  8000c1:	00 00 00 
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  8000d0:	00 00 00 
  8000d3:	41 ff d0             	callq  *%r8
  8000d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8000da:	48 8b 50 48          	mov    0x48(%rax),%rdx
  8000de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8000e2:	48 8b 40 48          	mov    0x48(%rax),%rax
  8000e6:	48 39 c2             	cmp    %rax,%rdx
  8000e9:	75 1d                	jne    800108 <check_regs+0xc5>
  8000eb:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800101:	00 00 00 
  800104:	ff d2                	callq  *%rdx
  800106:	eb 22                	jmp    80012a <check_regs+0xe7>
  800108:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80010f:	00 00 00 
  800112:	b8 00 00 00 00       	mov    $0x0,%eax
  800117:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80011e:	00 00 00 
  800121:	ff d2                	callq  *%rdx
  800123:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esi, regs.reg_rsi);
  80012a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80012e:	48 8b 50 40          	mov    0x40(%rax),%rdx
  800132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800136:	48 8b 40 40          	mov    0x40(%rax),%rax
  80013a:	48 89 d1             	mov    %rdx,%rcx
  80013d:	48 89 c2             	mov    %rax,%rdx
  800140:	48 be b3 49 80 00 00 	movabs $0x8049b3,%rsi
  800147:	00 00 00 
  80014a:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800151:	00 00 00 
  800154:	b8 00 00 00 00       	mov    $0x0,%eax
  800159:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800160:	00 00 00 
  800163:	41 ff d0             	callq  *%r8
  800166:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80016a:	48 8b 50 40          	mov    0x40(%rax),%rdx
  80016e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800172:	48 8b 40 40          	mov    0x40(%rax),%rax
  800176:	48 39 c2             	cmp    %rax,%rdx
  800179:	75 1d                	jne    800198 <check_regs+0x155>
  80017b:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800191:	00 00 00 
  800194:	ff d2                	callq  *%rdx
  800196:	eb 22                	jmp    8001ba <check_regs+0x177>
  800198:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8001ae:	00 00 00 
  8001b1:	ff d2                	callq  *%rdx
  8001b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebp, regs.reg_rbp);
  8001ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8001be:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001c6:	48 8b 40 50          	mov    0x50(%rax),%rax
  8001ca:	48 89 d1             	mov    %rdx,%rcx
  8001cd:	48 89 c2             	mov    %rax,%rdx
  8001d0:	48 be b7 49 80 00 00 	movabs $0x8049b7,%rsi
  8001d7:	00 00 00 
  8001da:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  8001f0:	00 00 00 
  8001f3:	41 ff d0             	callq  *%r8
  8001f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8001fa:	48 8b 50 50          	mov    0x50(%rax),%rdx
  8001fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800202:	48 8b 40 50          	mov    0x50(%rax),%rax
  800206:	48 39 c2             	cmp    %rax,%rdx
  800209:	75 1d                	jne    800228 <check_regs+0x1e5>
  80020b:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800221:	00 00 00 
  800224:	ff d2                	callq  *%rdx
  800226:	eb 22                	jmp    80024a <check_regs+0x207>
  800228:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80023e:	00 00 00 
  800241:	ff d2                	callq  *%rdx
  800243:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ebx, regs.reg_rbx);
  80024a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80024e:	48 8b 50 68          	mov    0x68(%rax),%rdx
  800252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800256:	48 8b 40 68          	mov    0x68(%rax),%rax
  80025a:	48 89 d1             	mov    %rdx,%rcx
  80025d:	48 89 c2             	mov    %rax,%rdx
  800260:	48 be bb 49 80 00 00 	movabs $0x8049bb,%rsi
  800267:	00 00 00 
  80026a:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800280:	00 00 00 
  800283:	41 ff d0             	callq  *%r8
  800286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80028a:	48 8b 50 68          	mov    0x68(%rax),%rdx
  80028e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800292:	48 8b 40 68          	mov    0x68(%rax),%rax
  800296:	48 39 c2             	cmp    %rax,%rdx
  800299:	75 1d                	jne    8002b8 <check_regs+0x275>
  80029b:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  8002a2:	00 00 00 
  8002a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002aa:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8002b1:	00 00 00 
  8002b4:	ff d2                	callq  *%rdx
  8002b6:	eb 22                	jmp    8002da <check_regs+0x297>
  8002b8:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  8002bf:	00 00 00 
  8002c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c7:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8002ce:	00 00 00 
  8002d1:	ff d2                	callq  *%rdx
  8002d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(edx, regs.reg_rdx);
  8002da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8002de:	48 8b 50 58          	mov    0x58(%rax),%rdx
  8002e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002e6:	48 8b 40 58          	mov    0x58(%rax),%rax
  8002ea:	48 89 d1             	mov    %rdx,%rcx
  8002ed:	48 89 c2             	mov    %rax,%rdx
  8002f0:	48 be bf 49 80 00 00 	movabs $0x8049bf,%rsi
  8002f7:	00 00 00 
  8002fa:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800301:	00 00 00 
  800304:	b8 00 00 00 00       	mov    $0x0,%eax
  800309:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800310:	00 00 00 
  800313:	41 ff d0             	callq  *%r8
  800316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80031a:	48 8b 50 58          	mov    0x58(%rax),%rdx
  80031e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800322:	48 8b 40 58          	mov    0x58(%rax),%rax
  800326:	48 39 c2             	cmp    %rax,%rdx
  800329:	75 1d                	jne    800348 <check_regs+0x305>
  80032b:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  800332:	00 00 00 
  800335:	b8 00 00 00 00       	mov    $0x0,%eax
  80033a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800341:	00 00 00 
  800344:	ff d2                	callq  *%rdx
  800346:	eb 22                	jmp    80036a <check_regs+0x327>
  800348:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80035e:	00 00 00 
  800361:	ff d2                	callq  *%rdx
  800363:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(ecx, regs.reg_rcx);
  80036a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80036e:	48 8b 50 60          	mov    0x60(%rax),%rdx
  800372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800376:	48 8b 40 60          	mov    0x60(%rax),%rax
  80037a:	48 89 d1             	mov    %rdx,%rcx
  80037d:	48 89 c2             	mov    %rax,%rdx
  800380:	48 be c3 49 80 00 00 	movabs $0x8049c3,%rsi
  800387:	00 00 00 
  80038a:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800391:	00 00 00 
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  8003a0:	00 00 00 
  8003a3:	41 ff d0             	callq  *%r8
  8003a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003aa:	48 8b 50 60          	mov    0x60(%rax),%rdx
  8003ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b2:	48 8b 40 60          	mov    0x60(%rax),%rax
  8003b6:	48 39 c2             	cmp    %rax,%rdx
  8003b9:	75 1d                	jne    8003d8 <check_regs+0x395>
  8003bb:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  8003c2:	00 00 00 
  8003c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ca:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8003d1:	00 00 00 
  8003d4:	ff d2                	callq  *%rdx
  8003d6:	eb 22                	jmp    8003fa <check_regs+0x3b7>
  8003d8:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  8003df:	00 00 00 
  8003e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e7:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8003ee:	00 00 00 
  8003f1:	ff d2                	callq  *%rdx
  8003f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eax, regs.reg_rax);
  8003fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003fe:	48 8b 50 70          	mov    0x70(%rax),%rdx
  800402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800406:	48 8b 40 70          	mov    0x70(%rax),%rax
  80040a:	48 89 d1             	mov    %rdx,%rcx
  80040d:	48 89 c2             	mov    %rax,%rdx
  800410:	48 be c7 49 80 00 00 	movabs $0x8049c7,%rsi
  800417:	00 00 00 
  80041a:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800421:	00 00 00 
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
  800429:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800430:	00 00 00 
  800433:	41 ff d0             	callq  *%r8
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 8b 50 70          	mov    0x70(%rax),%rdx
  80043e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800442:	48 8b 40 70          	mov    0x70(%rax),%rax
  800446:	48 39 c2             	cmp    %rax,%rdx
  800449:	75 1d                	jne    800468 <check_regs+0x425>
  80044b:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800461:	00 00 00 
  800464:	ff d2                	callq  *%rdx
  800466:	eb 22                	jmp    80048a <check_regs+0x447>
  800468:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80046f:	00 00 00 
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
  800477:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80047e:	00 00 00 
  800481:	ff d2                	callq  *%rdx
  800483:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eip, eip);
  80048a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80048e:	48 8b 50 78          	mov    0x78(%rax),%rdx
  800492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800496:	48 8b 40 78          	mov    0x78(%rax),%rax
  80049a:	48 89 d1             	mov    %rdx,%rcx
  80049d:	48 89 c2             	mov    %rax,%rdx
  8004a0:	48 be cb 49 80 00 00 	movabs $0x8049cb,%rsi
  8004a7:	00 00 00 
  8004aa:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  8004b1:	00 00 00 
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  8004c0:	00 00 00 
  8004c3:	41 ff d0             	callq  *%r8
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8004ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004d2:	48 8b 40 78          	mov    0x78(%rax),%rax
  8004d6:	48 39 c2             	cmp    %rax,%rdx
  8004d9:	75 1d                	jne    8004f8 <check_regs+0x4b5>
  8004db:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  8004e2:	00 00 00 
  8004e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ea:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8004f1:	00 00 00 
  8004f4:	ff d2                	callq  *%rdx
  8004f6:	eb 22                	jmp    80051a <check_regs+0x4d7>
  8004f8:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  8004ff:	00 00 00 
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80050e:	00 00 00 
  800511:	ff d2                	callq  *%rdx
  800513:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(eflags, eflags);
  80051a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80051e:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800530:	48 89 d1             	mov    %rdx,%rcx
  800533:	48 89 c2             	mov    %rax,%rdx
  800536:	48 be cf 49 80 00 00 	movabs $0x8049cf,%rsi
  80053d:	00 00 00 
  800540:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  800547:	00 00 00 
  80054a:	b8 00 00 00 00       	mov    $0x0,%eax
  80054f:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  800556:	00 00 00 
  800559:	41 ff d0             	callq  *%r8
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
  800567:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80056b:	48 8b 80 80 00 00 00 	mov    0x80(%rax),%rax
  800572:	48 39 c2             	cmp    %rax,%rdx
  800575:	75 1d                	jne    800594 <check_regs+0x551>
  800577:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  80057e:	00 00 00 
  800581:	b8 00 00 00 00       	mov    $0x0,%eax
  800586:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80058d:	00 00 00 
  800590:	ff d2                	callq  *%rdx
  800592:	eb 22                	jmp    8005b6 <check_regs+0x573>
  800594:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  80059b:	00 00 00 
  80059e:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a3:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8005aa:	00 00 00 
  8005ad:	ff d2                	callq  *%rdx
  8005af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	CHECK(esp, esp);
  8005b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ba:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8005c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c5:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  8005cc:	48 89 d1             	mov    %rdx,%rcx
  8005cf:	48 89 c2             	mov    %rax,%rdx
  8005d2:	48 be d6 49 80 00 00 	movabs $0x8049d6,%rsi
  8005d9:	00 00 00 
  8005dc:	48 bf 95 49 80 00 00 	movabs $0x804995,%rdi
  8005e3:	00 00 00 
  8005e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005eb:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  8005f2:	00 00 00 
  8005f5:	41 ff d0             	callq  *%r8
  8005f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fc:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800607:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  80060e:	48 39 c2             	cmp    %rax,%rdx
  800611:	75 1d                	jne    800630 <check_regs+0x5ed>
  800613:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  80061a:	00 00 00 
  80061d:	b8 00 00 00 00       	mov    $0x0,%eax
  800622:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800629:	00 00 00 
  80062c:	ff d2                	callq  *%rdx
  80062e:	eb 22                	jmp    800652 <check_regs+0x60f>
  800630:	48 bf a9 49 80 00 00 	movabs $0x8049a9,%rdi
  800637:	00 00 00 
  80063a:	b8 00 00 00 00       	mov    $0x0,%eax
  80063f:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800646:	00 00 00 
  800649:	ff d2                	callq  *%rdx
  80064b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

#undef CHECK


	if (!mismatch)
  800652:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800656:	75 24                	jne    80067c <check_regs+0x639>
		cprintf("Registers %s OK\n", testname);
  800658:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80065c:	48 89 c6             	mov    %rax,%rsi
  80065f:	48 bf da 49 80 00 00 	movabs $0x8049da,%rdi
  800666:	00 00 00 
  800669:	b8 00 00 00 00       	mov    $0x0,%eax
  80066e:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800675:	00 00 00 
  800678:	ff d2                	callq  *%rdx
  80067a:	eb 22                	jmp    80069e <check_regs+0x65b>
	else
		cprintf("Registers %s MISMATCH\n", testname);
  80067c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800680:	48 89 c6             	mov    %rax,%rsi
  800683:	48 bf eb 49 80 00 00 	movabs $0x8049eb,%rdi
  80068a:	00 00 00 
  80068d:	b8 00 00 00 00       	mov    $0x0,%eax
  800692:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800699:	00 00 00 
  80069c:	ff d2                	callq  *%rdx
}
  80069e:	c9                   	leaveq 
  80069f:	c3                   	retq   

00000000008006a0 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8006a0:	55                   	push   %rbp
  8006a1:	48 89 e5             	mov    %rsp,%rbp
  8006a4:	48 83 ec 20          	sub    $0x20,%rsp
  8006a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (utf->utf_fault_va != (uint64_t)UTEMP)
  8006ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b0:	48 8b 00             	mov    (%rax),%rax
  8006b3:	48 3d 00 00 40 00    	cmp    $0x400000,%rax
  8006b9:	74 43                	je     8006fe <pgfault+0x5e>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 8b 00             	mov    (%rax),%rax
  8006cd:	49 89 d0             	mov    %rdx,%r8
  8006d0:	48 89 c1             	mov    %rax,%rcx
  8006d3:	48 ba 08 4a 80 00 00 	movabs $0x804a08,%rdx
  8006da:	00 00 00 
  8006dd:	be 5f 00 00 00       	mov    $0x5f,%esi
  8006e2:	48 bf 39 4a 80 00 00 	movabs $0x804a39,%rdi
  8006e9:	00 00 00 
  8006ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f1:	49 b9 e4 0a 80 00 00 	movabs $0x800ae4,%r9
  8006f8:	00 00 00 
  8006fb:	41 ff d1             	callq  *%r9
		      utf->utf_fault_va, utf->utf_rip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8006fe:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  800705:	00 00 00 
  800708:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070c:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  800710:	48 89 08             	mov    %rcx,(%rax)
  800713:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  800717:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071b:	48 8b 4a 20          	mov    0x20(%rdx),%rcx
  80071f:	48 89 48 10          	mov    %rcx,0x10(%rax)
  800723:	48 8b 4a 28          	mov    0x28(%rdx),%rcx
  800727:	48 89 48 18          	mov    %rcx,0x18(%rax)
  80072b:	48 8b 4a 30          	mov    0x30(%rdx),%rcx
  80072f:	48 89 48 20          	mov    %rcx,0x20(%rax)
  800733:	48 8b 4a 38          	mov    0x38(%rdx),%rcx
  800737:	48 89 48 28          	mov    %rcx,0x28(%rax)
  80073b:	48 8b 4a 40          	mov    0x40(%rdx),%rcx
  80073f:	48 89 48 30          	mov    %rcx,0x30(%rax)
  800743:	48 8b 4a 48          	mov    0x48(%rdx),%rcx
  800747:	48 89 48 38          	mov    %rcx,0x38(%rax)
  80074b:	48 8b 4a 50          	mov    0x50(%rdx),%rcx
  80074f:	48 89 48 40          	mov    %rcx,0x40(%rax)
  800753:	48 8b 4a 58          	mov    0x58(%rdx),%rcx
  800757:	48 89 48 48          	mov    %rcx,0x48(%rax)
  80075b:	48 8b 4a 60          	mov    0x60(%rdx),%rcx
  80075f:	48 89 48 50          	mov    %rcx,0x50(%rax)
  800763:	48 8b 4a 68          	mov    0x68(%rdx),%rcx
  800767:	48 89 48 58          	mov    %rcx,0x58(%rax)
  80076b:	48 8b 4a 70          	mov    0x70(%rdx),%rcx
  80076f:	48 89 48 60          	mov    %rcx,0x60(%rax)
  800773:	48 8b 4a 78          	mov    0x78(%rdx),%rcx
  800777:	48 89 48 68          	mov    %rcx,0x68(%rax)
  80077b:	48 8b 92 80 00 00 00 	mov    0x80(%rdx),%rdx
  800782:	48 89 50 70          	mov    %rdx,0x70(%rax)
	during.eip = utf->utf_rip;
  800786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078a:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  800791:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  800798:	00 00 00 
  80079b:	48 89 50 78          	mov    %rdx,0x78(%rax)
	during.eflags = utf->utf_eflags & 0xfff;
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
  8007aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  8007af:	48 89 c2             	mov    %rax,%rdx
  8007b2:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  8007b9:	00 00 00 
  8007bc:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
	during.esp = utf->utf_rsp;
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
  8007ce:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  8007d5:	00 00 00 
  8007d8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  8007df:	49 b8 4a 4a 80 00 00 	movabs $0x804a4a,%r8
  8007e6:	00 00 00 
  8007e9:	48 b9 58 4a 80 00 00 	movabs $0x804a58,%rcx
  8007f0:	00 00 00 
  8007f3:	48 ba a0 80 80 00 00 	movabs $0x8080a0,%rdx
  8007fa:	00 00 00 
  8007fd:	48 be 5f 4a 80 00 00 	movabs $0x804a5f,%rsi
  800804:	00 00 00 
  800807:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80080e:	00 00 00 
  800811:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800818:	00 00 00 
  80081b:	ff d0                	callq  *%rax

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  80081d:	ba 07 00 00 00       	mov    $0x7,%edx
  800822:	be 00 00 40 00       	mov    $0x400000,%esi
  800827:	bf 00 00 00 00       	mov    $0x0,%edi
  80082c:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  800833:	00 00 00 
  800836:	ff d0                	callq  *%rax
  800838:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80083b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80083f:	79 30                	jns    800871 <pgfault+0x1d1>
		panic("sys_page_alloc: %e", r);
  800841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800844:	89 c1                	mov    %eax,%ecx
  800846:	48 ba 66 4a 80 00 00 	movabs $0x804a66,%rdx
  80084d:	00 00 00 
  800850:	be 6a 00 00 00       	mov    $0x6a,%esi
  800855:	48 bf 39 4a 80 00 00 	movabs $0x804a39,%rdi
  80085c:	00 00 00 
  80085f:	b8 00 00 00 00       	mov    $0x0,%eax
  800864:	49 b8 e4 0a 80 00 00 	movabs $0x800ae4,%r8
  80086b:	00 00 00 
  80086e:	41 ff d0             	callq  *%r8
}
  800871:	c9                   	leaveq 
  800872:	c3                   	retq   

0000000000800873 <umain>:

void
umain(int argc, char **argv)
{
  800873:	55                   	push   %rbp
  800874:	48 89 e5             	mov    %rsp,%rbp
  800877:	48 83 ec 10          	sub    $0x10,%rsp
  80087b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80087e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(pgfault);
  800882:	48 bf a0 06 80 00 00 	movabs $0x8006a0,%rdi
  800889:	00 00 00 
  80088c:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  800893:	00 00 00 
  800896:	ff d0                	callq  *%rax

	__asm __volatile(
  800898:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80089f:	00 00 00 
  8008a2:	48 ba 40 81 80 00 00 	movabs $0x808140,%rdx
  8008a9:	00 00 00 
  8008ac:	50                   	push   %rax
  8008ad:	52                   	push   %rdx
  8008ae:	50                   	push   %rax
  8008af:	9c                   	pushfq 
  8008b0:	58                   	pop    %rax
  8008b1:	48 0d d4 08 00 00    	or     $0x8d4,%rax
  8008b7:	50                   	push   %rax
  8008b8:	9d                   	popfq  
  8008b9:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
  8008be:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8008c5:	48 8d 04 25 11 09 80 	lea    0x800911,%rax
  8008cc:	00 
  8008cd:	49 89 47 78          	mov    %rax,0x78(%r15)
  8008d1:	58                   	pop    %rax
  8008d2:	4d 89 77 08          	mov    %r14,0x8(%r15)
  8008d6:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  8008da:	4d 89 67 18          	mov    %r12,0x18(%r15)
  8008de:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  8008e2:	4d 89 57 28          	mov    %r10,0x28(%r15)
  8008e6:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  8008ea:	4d 89 47 38          	mov    %r8,0x38(%r15)
  8008ee:	49 89 77 40          	mov    %rsi,0x40(%r15)
  8008f2:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  8008f6:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  8008fa:	49 89 57 58          	mov    %rdx,0x58(%r15)
  8008fe:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800902:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800906:	49 89 47 70          	mov    %rax,0x70(%r15)
  80090a:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  800911:	c7 04 25 00 00 40 00 	movl   $0x2a,0x400000
  800918:	2a 00 00 00 
  80091c:	4c 8b 3c 24          	mov    (%rsp),%r15
  800920:	4d 89 77 08          	mov    %r14,0x8(%r15)
  800924:	4d 89 6f 10          	mov    %r13,0x10(%r15)
  800928:	4d 89 67 18          	mov    %r12,0x18(%r15)
  80092c:	4d 89 5f 20          	mov    %r11,0x20(%r15)
  800930:	4d 89 57 28          	mov    %r10,0x28(%r15)
  800934:	4d 89 4f 30          	mov    %r9,0x30(%r15)
  800938:	4d 89 47 38          	mov    %r8,0x38(%r15)
  80093c:	49 89 77 40          	mov    %rsi,0x40(%r15)
  800940:	49 89 7f 48          	mov    %rdi,0x48(%r15)
  800944:	49 89 6f 50          	mov    %rbp,0x50(%r15)
  800948:	49 89 57 58          	mov    %rdx,0x58(%r15)
  80094c:	49 89 4f 60          	mov    %rcx,0x60(%r15)
  800950:	49 89 5f 68          	mov    %rbx,0x68(%r15)
  800954:	49 89 47 70          	mov    %rax,0x70(%r15)
  800958:	49 89 a7 88 00 00 00 	mov    %rsp,0x88(%r15)
  80095f:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  800964:	4d 8b 77 08          	mov    0x8(%r15),%r14
  800968:	4d 8b 6f 10          	mov    0x10(%r15),%r13
  80096c:	4d 8b 67 18          	mov    0x18(%r15),%r12
  800970:	4d 8b 5f 20          	mov    0x20(%r15),%r11
  800974:	4d 8b 57 28          	mov    0x28(%r15),%r10
  800978:	4d 8b 4f 30          	mov    0x30(%r15),%r9
  80097c:	4d 8b 47 38          	mov    0x38(%r15),%r8
  800980:	49 8b 77 40          	mov    0x40(%r15),%rsi
  800984:	49 8b 7f 48          	mov    0x48(%r15),%rdi
  800988:	49 8b 6f 50          	mov    0x50(%r15),%rbp
  80098c:	49 8b 57 58          	mov    0x58(%r15),%rdx
  800990:	49 8b 4f 60          	mov    0x60(%r15),%rcx
  800994:	49 8b 5f 68          	mov    0x68(%r15),%rbx
  800998:	49 8b 47 70          	mov    0x70(%r15),%rax
  80099c:	49 8b a7 88 00 00 00 	mov    0x88(%r15),%rsp
  8009a3:	50                   	push   %rax
  8009a4:	9c                   	pushfq 
  8009a5:	58                   	pop    %rax
  8009a6:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  8009ab:	49 89 87 80 00 00 00 	mov    %rax,0x80(%r15)
  8009b2:	58                   	pop    %rax
		: : "r" (&before), "r" (&after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  8009b3:	b8 00 00 40 00       	mov    $0x400000,%eax
  8009b8:	8b 00                	mov    (%rax),%eax
  8009ba:	83 f8 2a             	cmp    $0x2a,%eax
  8009bd:	74 1b                	je     8009da <umain+0x167>
		cprintf("EIP after page-fault MISMATCH\n");
  8009bf:	48 bf 80 4a 80 00 00 	movabs $0x804a80,%rdi
  8009c6:	00 00 00 
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ce:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8009d5:	00 00 00 
  8009d8:	ff d2                	callq  *%rdx
	after.eip = before.eip;
  8009da:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8009e1:	00 00 00 
  8009e4:	48 8b 50 78          	mov    0x78(%rax),%rdx
  8009e8:	48 b8 40 81 80 00 00 	movabs $0x808140,%rax
  8009ef:	00 00 00 
  8009f2:	48 89 50 78          	mov    %rdx,0x78(%rax)

	check_regs(&before, "before", &after, "after", "after page-fault");
  8009f6:	49 b8 9f 4a 80 00 00 	movabs $0x804a9f,%r8
  8009fd:	00 00 00 
  800a00:	48 b9 b0 4a 80 00 00 	movabs $0x804ab0,%rcx
  800a07:	00 00 00 
  800a0a:	48 ba 40 81 80 00 00 	movabs $0x808140,%rdx
  800a11:	00 00 00 
  800a14:	48 be 5f 4a 80 00 00 	movabs $0x804a5f,%rsi
  800a1b:	00 00 00 
  800a1e:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  800a25:	00 00 00 
  800a28:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800a2f:	00 00 00 
  800a32:	ff d0                	callq  *%rax
}
  800a34:	c9                   	leaveq 
  800a35:	c3                   	retq   

0000000000800a36 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a36:	55                   	push   %rbp
  800a37:	48 89 e5             	mov    %rsp,%rbp
  800a3a:	48 83 ec 10          	sub    $0x10,%rsp
  800a3e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a45:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  800a4c:	00 00 00 
  800a4f:	ff d0                	callq  *%rax
  800a51:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a56:	48 63 d0             	movslq %eax,%rdx
  800a59:	48 89 d0             	mov    %rdx,%rax
  800a5c:	48 c1 e0 03          	shl    $0x3,%rax
  800a60:	48 01 d0             	add    %rdx,%rax
  800a63:	48 c1 e0 05          	shl    $0x5,%rax
  800a67:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800a6e:	00 00 00 
  800a71:	48 01 c2             	add    %rax,%rdx
  800a74:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  800a7b:	00 00 00 
  800a7e:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a85:	7e 14                	jle    800a9b <libmain+0x65>
		binaryname = argv[0];
  800a87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a8b:	48 8b 10             	mov    (%rax),%rdx
  800a8e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800a95:	00 00 00 
  800a98:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800a9b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aa2:	48 89 d6             	mov    %rdx,%rsi
  800aa5:	89 c7                	mov    %eax,%edi
  800aa7:	48 b8 73 08 80 00 00 	movabs $0x800873,%rax
  800aae:	00 00 00 
  800ab1:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800ab3:	48 b8 c1 0a 80 00 00 	movabs $0x800ac1,%rax
  800aba:	00 00 00 
  800abd:	ff d0                	callq  *%rax
}
  800abf:	c9                   	leaveq 
  800ac0:	c3                   	retq   

0000000000800ac1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800ac1:	55                   	push   %rbp
  800ac2:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800ac5:	48 b8 bb 29 80 00 00 	movabs $0x8029bb,%rax
  800acc:	00 00 00 
  800acf:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800ad1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad6:	48 b8 41 21 80 00 00 	movabs $0x802141,%rax
  800add:	00 00 00 
  800ae0:	ff d0                	callq  *%rax

}
  800ae2:	5d                   	pop    %rbp
  800ae3:	c3                   	retq   

0000000000800ae4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ae4:	55                   	push   %rbp
  800ae5:	48 89 e5             	mov    %rsp,%rbp
  800ae8:	53                   	push   %rbx
  800ae9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800af0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800af7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800afd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b04:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b0b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b12:	84 c0                	test   %al,%al
  800b14:	74 23                	je     800b39 <_panic+0x55>
  800b16:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b1d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b21:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b25:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b29:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b2d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b31:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b35:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800b39:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b40:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b47:	00 00 00 
  800b4a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b51:	00 00 00 
  800b54:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b58:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b5f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b66:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b6d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800b74:	00 00 00 
  800b77:	48 8b 18             	mov    (%rax),%rbx
  800b7a:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  800b81:	00 00 00 
  800b84:	ff d0                	callq  *%rax
  800b86:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800b8c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b93:	41 89 c8             	mov    %ecx,%r8d
  800b96:	48 89 d1             	mov    %rdx,%rcx
  800b99:	48 89 da             	mov    %rbx,%rdx
  800b9c:	89 c6                	mov    %eax,%esi
  800b9e:	48 bf c0 4a 80 00 00 	movabs $0x804ac0,%rdi
  800ba5:	00 00 00 
  800ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bad:	49 b9 1d 0d 80 00 00 	movabs $0x800d1d,%r9
  800bb4:	00 00 00 
  800bb7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bba:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bc1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bc8:	48 89 d6             	mov    %rdx,%rsi
  800bcb:	48 89 c7             	mov    %rax,%rdi
  800bce:	48 b8 71 0c 80 00 00 	movabs $0x800c71,%rax
  800bd5:	00 00 00 
  800bd8:	ff d0                	callq  *%rax
	cprintf("\n");
  800bda:	48 bf e3 4a 80 00 00 	movabs $0x804ae3,%rdi
  800be1:	00 00 00 
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
  800be9:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  800bf0:	00 00 00 
  800bf3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800bf5:	cc                   	int3   
  800bf6:	eb fd                	jmp    800bf5 <_panic+0x111>

0000000000800bf8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800bf8:	55                   	push   %rbp
  800bf9:	48 89 e5             	mov    %rsp,%rbp
  800bfc:	48 83 ec 10          	sub    $0x10,%rsp
  800c00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800c07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0b:	8b 00                	mov    (%rax),%eax
  800c0d:	8d 48 01             	lea    0x1(%rax),%ecx
  800c10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c14:	89 0a                	mov    %ecx,(%rdx)
  800c16:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c19:	89 d1                	mov    %edx,%ecx
  800c1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c1f:	48 98                	cltq   
  800c21:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800c25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c29:	8b 00                	mov    (%rax),%eax
  800c2b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c30:	75 2c                	jne    800c5e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800c32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c36:	8b 00                	mov    (%rax),%eax
  800c38:	48 98                	cltq   
  800c3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c3e:	48 83 c2 08          	add    $0x8,%rdx
  800c42:	48 89 c6             	mov    %rax,%rsi
  800c45:	48 89 d7             	mov    %rdx,%rdi
  800c48:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  800c4f:	00 00 00 
  800c52:	ff d0                	callq  *%rax
        b->idx = 0;
  800c54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c58:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800c5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c62:	8b 40 04             	mov    0x4(%rax),%eax
  800c65:	8d 50 01             	lea    0x1(%rax),%edx
  800c68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6c:	89 50 04             	mov    %edx,0x4(%rax)
}
  800c6f:	c9                   	leaveq 
  800c70:	c3                   	retq   

0000000000800c71 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800c71:	55                   	push   %rbp
  800c72:	48 89 e5             	mov    %rsp,%rbp
  800c75:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800c7c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800c83:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800c8a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800c91:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800c98:	48 8b 0a             	mov    (%rdx),%rcx
  800c9b:	48 89 08             	mov    %rcx,(%rax)
  800c9e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ca2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ca6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800caa:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800cae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800cb5:	00 00 00 
    b.cnt = 0;
  800cb8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800cbf:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800cc2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800cc9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800cd0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800cd7:	48 89 c6             	mov    %rax,%rsi
  800cda:	48 bf f8 0b 80 00 00 	movabs $0x800bf8,%rdi
  800ce1:	00 00 00 
  800ce4:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  800ceb:	00 00 00 
  800cee:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800cf0:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800cf6:	48 98                	cltq   
  800cf8:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800cff:	48 83 c2 08          	add    $0x8,%rdx
  800d03:	48 89 c6             	mov    %rax,%rsi
  800d06:	48 89 d7             	mov    %rdx,%rdi
  800d09:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  800d10:	00 00 00 
  800d13:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800d15:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d1b:	c9                   	leaveq 
  800d1c:	c3                   	retq   

0000000000800d1d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800d1d:	55                   	push   %rbp
  800d1e:	48 89 e5             	mov    %rsp,%rbp
  800d21:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d28:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d2f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d36:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d3d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d44:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 20                	je     800d6f <cprintf+0x52>
  800d4f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d53:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d57:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d5b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d5f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d63:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d67:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d6b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d6f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800d76:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800d7d:	00 00 00 
  800d80:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d87:	00 00 00 
  800d8a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d8e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d95:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d9c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800da3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800daa:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800db1:	48 8b 0a             	mov    (%rdx),%rcx
  800db4:	48 89 08             	mov    %rcx,(%rax)
  800db7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dbb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dbf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dc3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800dc7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800dce:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dd5:	48 89 d6             	mov    %rdx,%rsi
  800dd8:	48 89 c7             	mov    %rax,%rdi
  800ddb:	48 b8 71 0c 80 00 00 	movabs $0x800c71,%rax
  800de2:	00 00 00 
  800de5:	ff d0                	callq  *%rax
  800de7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800ded:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800df3:	c9                   	leaveq 
  800df4:	c3                   	retq   

0000000000800df5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800df5:	55                   	push   %rbp
  800df6:	48 89 e5             	mov    %rsp,%rbp
  800df9:	53                   	push   %rbx
  800dfa:	48 83 ec 38          	sub    $0x38,%rsp
  800dfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e06:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800e0a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800e0d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800e11:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e15:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800e18:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800e1c:	77 3b                	ja     800e59 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e1e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800e21:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e25:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800e28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e31:	48 f7 f3             	div    %rbx
  800e34:	48 89 c2             	mov    %rax,%rdx
  800e37:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800e3a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e3d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800e41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e45:	41 89 f9             	mov    %edi,%r9d
  800e48:	48 89 c7             	mov    %rax,%rdi
  800e4b:	48 b8 f5 0d 80 00 00 	movabs $0x800df5,%rax
  800e52:	00 00 00 
  800e55:	ff d0                	callq  *%rax
  800e57:	eb 1e                	jmp    800e77 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e59:	eb 12                	jmp    800e6d <printnum+0x78>
			putch(padc, putdat);
  800e5b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800e5f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800e62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e66:	48 89 ce             	mov    %rcx,%rsi
  800e69:	89 d7                	mov    %edx,%edi
  800e6b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e6d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800e71:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800e75:	7f e4                	jg     800e5b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e77:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800e7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e83:	48 f7 f1             	div    %rcx
  800e86:	48 89 d0             	mov    %rdx,%rax
  800e89:	48 ba f0 4c 80 00 00 	movabs $0x804cf0,%rdx
  800e90:	00 00 00 
  800e93:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800e97:	0f be d0             	movsbl %al,%edx
  800e9a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea2:	48 89 ce             	mov    %rcx,%rsi
  800ea5:	89 d7                	mov    %edx,%edi
  800ea7:	ff d0                	callq  *%rax
}
  800ea9:	48 83 c4 38          	add    $0x38,%rsp
  800ead:	5b                   	pop    %rbx
  800eae:	5d                   	pop    %rbp
  800eaf:	c3                   	retq   

0000000000800eb0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800eb0:	55                   	push   %rbp
  800eb1:	48 89 e5             	mov    %rsp,%rbp
  800eb4:	48 83 ec 1c          	sub    $0x1c,%rsp
  800eb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ebc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800ebf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ec3:	7e 52                	jle    800f17 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec9:	8b 00                	mov    (%rax),%eax
  800ecb:	83 f8 30             	cmp    $0x30,%eax
  800ece:	73 24                	jae    800ef4 <getuint+0x44>
  800ed0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edc:	8b 00                	mov    (%rax),%eax
  800ede:	89 c0                	mov    %eax,%eax
  800ee0:	48 01 d0             	add    %rdx,%rax
  800ee3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ee7:	8b 12                	mov    (%rdx),%edx
  800ee9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800eec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ef0:	89 0a                	mov    %ecx,(%rdx)
  800ef2:	eb 17                	jmp    800f0b <getuint+0x5b>
  800ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800efc:	48 89 d0             	mov    %rdx,%rax
  800eff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f07:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f0b:	48 8b 00             	mov    (%rax),%rax
  800f0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f12:	e9 a3 00 00 00       	jmpq   800fba <getuint+0x10a>
	else if (lflag)
  800f17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f1b:	74 4f                	je     800f6c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f21:	8b 00                	mov    (%rax),%eax
  800f23:	83 f8 30             	cmp    $0x30,%eax
  800f26:	73 24                	jae    800f4c <getuint+0x9c>
  800f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f34:	8b 00                	mov    (%rax),%eax
  800f36:	89 c0                	mov    %eax,%eax
  800f38:	48 01 d0             	add    %rdx,%rax
  800f3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f3f:	8b 12                	mov    (%rdx),%edx
  800f41:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f44:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f48:	89 0a                	mov    %ecx,(%rdx)
  800f4a:	eb 17                	jmp    800f63 <getuint+0xb3>
  800f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f50:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f54:	48 89 d0             	mov    %rdx,%rax
  800f57:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f5f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f63:	48 8b 00             	mov    (%rax),%rax
  800f66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f6a:	eb 4e                	jmp    800fba <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800f6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f70:	8b 00                	mov    (%rax),%eax
  800f72:	83 f8 30             	cmp    $0x30,%eax
  800f75:	73 24                	jae    800f9b <getuint+0xeb>
  800f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f83:	8b 00                	mov    (%rax),%eax
  800f85:	89 c0                	mov    %eax,%eax
  800f87:	48 01 d0             	add    %rdx,%rax
  800f8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f8e:	8b 12                	mov    (%rdx),%edx
  800f90:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f97:	89 0a                	mov    %ecx,(%rdx)
  800f99:	eb 17                	jmp    800fb2 <getuint+0x102>
  800f9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fa3:	48 89 d0             	mov    %rdx,%rax
  800fa6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800faa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fb2:	8b 00                	mov    (%rax),%eax
  800fb4:	89 c0                	mov    %eax,%eax
  800fb6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fbe:	c9                   	leaveq 
  800fbf:	c3                   	retq   

0000000000800fc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fc0:	55                   	push   %rbp
  800fc1:	48 89 e5             	mov    %rsp,%rbp
  800fc4:	48 83 ec 1c          	sub    $0x1c,%rsp
  800fc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fcc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800fcf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fd3:	7e 52                	jle    801027 <getint+0x67>
		x=va_arg(*ap, long long);
  800fd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd9:	8b 00                	mov    (%rax),%eax
  800fdb:	83 f8 30             	cmp    $0x30,%eax
  800fde:	73 24                	jae    801004 <getint+0x44>
  800fe0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fe8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fec:	8b 00                	mov    (%rax),%eax
  800fee:	89 c0                	mov    %eax,%eax
  800ff0:	48 01 d0             	add    %rdx,%rax
  800ff3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ff7:	8b 12                	mov    (%rdx),%edx
  800ff9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ffc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801000:	89 0a                	mov    %ecx,(%rdx)
  801002:	eb 17                	jmp    80101b <getint+0x5b>
  801004:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801008:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80100c:	48 89 d0             	mov    %rdx,%rax
  80100f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801013:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801017:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80101b:	48 8b 00             	mov    (%rax),%rax
  80101e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801022:	e9 a3 00 00 00       	jmpq   8010ca <getint+0x10a>
	else if (lflag)
  801027:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80102b:	74 4f                	je     80107c <getint+0xbc>
		x=va_arg(*ap, long);
  80102d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801031:	8b 00                	mov    (%rax),%eax
  801033:	83 f8 30             	cmp    $0x30,%eax
  801036:	73 24                	jae    80105c <getint+0x9c>
  801038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801040:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801044:	8b 00                	mov    (%rax),%eax
  801046:	89 c0                	mov    %eax,%eax
  801048:	48 01 d0             	add    %rdx,%rax
  80104b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80104f:	8b 12                	mov    (%rdx),%edx
  801051:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801054:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801058:	89 0a                	mov    %ecx,(%rdx)
  80105a:	eb 17                	jmp    801073 <getint+0xb3>
  80105c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801060:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801064:	48 89 d0             	mov    %rdx,%rax
  801067:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80106b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80106f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801073:	48 8b 00             	mov    (%rax),%rax
  801076:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80107a:	eb 4e                	jmp    8010ca <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80107c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801080:	8b 00                	mov    (%rax),%eax
  801082:	83 f8 30             	cmp    $0x30,%eax
  801085:	73 24                	jae    8010ab <getint+0xeb>
  801087:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80108f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801093:	8b 00                	mov    (%rax),%eax
  801095:	89 c0                	mov    %eax,%eax
  801097:	48 01 d0             	add    %rdx,%rax
  80109a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80109e:	8b 12                	mov    (%rdx),%edx
  8010a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010a7:	89 0a                	mov    %ecx,(%rdx)
  8010a9:	eb 17                	jmp    8010c2 <getint+0x102>
  8010ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010b3:	48 89 d0             	mov    %rdx,%rax
  8010b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010c2:	8b 00                	mov    (%rax),%eax
  8010c4:	48 98                	cltq   
  8010c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010ce:	c9                   	leaveq 
  8010cf:	c3                   	retq   

00000000008010d0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d0:	55                   	push   %rbp
  8010d1:	48 89 e5             	mov    %rsp,%rbp
  8010d4:	41 54                	push   %r12
  8010d6:	53                   	push   %rbx
  8010d7:	48 83 ec 60          	sub    $0x60,%rsp
  8010db:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8010df:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8010e3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8010e7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8010eb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010ef:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8010f3:	48 8b 0a             	mov    (%rdx),%rcx
  8010f6:	48 89 08             	mov    %rcx,(%rax)
  8010f9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010fd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801101:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801105:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801109:	eb 17                	jmp    801122 <vprintfmt+0x52>
			if (ch == '\0')
  80110b:	85 db                	test   %ebx,%ebx
  80110d:	0f 84 cc 04 00 00    	je     8015df <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801113:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801117:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80111b:	48 89 d6             	mov    %rdx,%rsi
  80111e:	89 df                	mov    %ebx,%edi
  801120:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801122:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80112a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80112e:	0f b6 00             	movzbl (%rax),%eax
  801131:	0f b6 d8             	movzbl %al,%ebx
  801134:	83 fb 25             	cmp    $0x25,%ebx
  801137:	75 d2                	jne    80110b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801139:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80113d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801144:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80114b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  801152:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801159:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80115d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801161:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801165:	0f b6 00             	movzbl (%rax),%eax
  801168:	0f b6 d8             	movzbl %al,%ebx
  80116b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80116e:	83 f8 55             	cmp    $0x55,%eax
  801171:	0f 87 34 04 00 00    	ja     8015ab <vprintfmt+0x4db>
  801177:	89 c0                	mov    %eax,%eax
  801179:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801180:	00 
  801181:	48 b8 18 4d 80 00 00 	movabs $0x804d18,%rax
  801188:	00 00 00 
  80118b:	48 01 d0             	add    %rdx,%rax
  80118e:	48 8b 00             	mov    (%rax),%rax
  801191:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  801193:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  801197:	eb c0                	jmp    801159 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801199:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80119d:	eb ba                	jmp    801159 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80119f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8011a6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8011a9:	89 d0                	mov    %edx,%eax
  8011ab:	c1 e0 02             	shl    $0x2,%eax
  8011ae:	01 d0                	add    %edx,%eax
  8011b0:	01 c0                	add    %eax,%eax
  8011b2:	01 d8                	add    %ebx,%eax
  8011b4:	83 e8 30             	sub    $0x30,%eax
  8011b7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8011ba:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011be:	0f b6 00             	movzbl (%rax),%eax
  8011c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8011c7:	7e 0c                	jle    8011d5 <vprintfmt+0x105>
  8011c9:	83 fb 39             	cmp    $0x39,%ebx
  8011cc:	7f 07                	jg     8011d5 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011ce:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011d3:	eb d1                	jmp    8011a6 <vprintfmt+0xd6>
			goto process_precision;
  8011d5:	eb 58                	jmp    80122f <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8011d7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011da:	83 f8 30             	cmp    $0x30,%eax
  8011dd:	73 17                	jae    8011f6 <vprintfmt+0x126>
  8011df:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8011e3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011e6:	89 c0                	mov    %eax,%eax
  8011e8:	48 01 d0             	add    %rdx,%rax
  8011eb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011ee:	83 c2 08             	add    $0x8,%edx
  8011f1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011f4:	eb 0f                	jmp    801205 <vprintfmt+0x135>
  8011f6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8011fa:	48 89 d0             	mov    %rdx,%rax
  8011fd:	48 83 c2 08          	add    $0x8,%rdx
  801201:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801205:	8b 00                	mov    (%rax),%eax
  801207:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80120a:	eb 23                	jmp    80122f <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80120c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801210:	79 0c                	jns    80121e <vprintfmt+0x14e>
				width = 0;
  801212:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801219:	e9 3b ff ff ff       	jmpq   801159 <vprintfmt+0x89>
  80121e:	e9 36 ff ff ff       	jmpq   801159 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801223:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80122a:	e9 2a ff ff ff       	jmpq   801159 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80122f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801233:	79 12                	jns    801247 <vprintfmt+0x177>
				width = precision, precision = -1;
  801235:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801238:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80123b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801242:	e9 12 ff ff ff       	jmpq   801159 <vprintfmt+0x89>
  801247:	e9 0d ff ff ff       	jmpq   801159 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80124c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801250:	e9 04 ff ff ff       	jmpq   801159 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801255:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801258:	83 f8 30             	cmp    $0x30,%eax
  80125b:	73 17                	jae    801274 <vprintfmt+0x1a4>
  80125d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801261:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801264:	89 c0                	mov    %eax,%eax
  801266:	48 01 d0             	add    %rdx,%rax
  801269:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80126c:	83 c2 08             	add    $0x8,%edx
  80126f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801272:	eb 0f                	jmp    801283 <vprintfmt+0x1b3>
  801274:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801278:	48 89 d0             	mov    %rdx,%rax
  80127b:	48 83 c2 08          	add    $0x8,%rdx
  80127f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801283:	8b 10                	mov    (%rax),%edx
  801285:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801289:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80128d:	48 89 ce             	mov    %rcx,%rsi
  801290:	89 d7                	mov    %edx,%edi
  801292:	ff d0                	callq  *%rax
			break;
  801294:	e9 40 03 00 00       	jmpq   8015d9 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801299:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80129c:	83 f8 30             	cmp    $0x30,%eax
  80129f:	73 17                	jae    8012b8 <vprintfmt+0x1e8>
  8012a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012a8:	89 c0                	mov    %eax,%eax
  8012aa:	48 01 d0             	add    %rdx,%rax
  8012ad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012b0:	83 c2 08             	add    $0x8,%edx
  8012b3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012b6:	eb 0f                	jmp    8012c7 <vprintfmt+0x1f7>
  8012b8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012bc:	48 89 d0             	mov    %rdx,%rax
  8012bf:	48 83 c2 08          	add    $0x8,%rdx
  8012c3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012c7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8012c9:	85 db                	test   %ebx,%ebx
  8012cb:	79 02                	jns    8012cf <vprintfmt+0x1ff>
				err = -err;
  8012cd:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012cf:	83 fb 15             	cmp    $0x15,%ebx
  8012d2:	7f 16                	jg     8012ea <vprintfmt+0x21a>
  8012d4:	48 b8 40 4c 80 00 00 	movabs $0x804c40,%rax
  8012db:	00 00 00 
  8012de:	48 63 d3             	movslq %ebx,%rdx
  8012e1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012e5:	4d 85 e4             	test   %r12,%r12
  8012e8:	75 2e                	jne    801318 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8012ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012f2:	89 d9                	mov    %ebx,%ecx
  8012f4:	48 ba 01 4d 80 00 00 	movabs $0x804d01,%rdx
  8012fb:	00 00 00 
  8012fe:	48 89 c7             	mov    %rax,%rdi
  801301:	b8 00 00 00 00       	mov    $0x0,%eax
  801306:	49 b8 e8 15 80 00 00 	movabs $0x8015e8,%r8
  80130d:	00 00 00 
  801310:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801313:	e9 c1 02 00 00       	jmpq   8015d9 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801318:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80131c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801320:	4c 89 e1             	mov    %r12,%rcx
  801323:	48 ba 0a 4d 80 00 00 	movabs $0x804d0a,%rdx
  80132a:	00 00 00 
  80132d:	48 89 c7             	mov    %rax,%rdi
  801330:	b8 00 00 00 00       	mov    $0x0,%eax
  801335:	49 b8 e8 15 80 00 00 	movabs $0x8015e8,%r8
  80133c:	00 00 00 
  80133f:	41 ff d0             	callq  *%r8
			break;
  801342:	e9 92 02 00 00       	jmpq   8015d9 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801347:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80134a:	83 f8 30             	cmp    $0x30,%eax
  80134d:	73 17                	jae    801366 <vprintfmt+0x296>
  80134f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801353:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801356:	89 c0                	mov    %eax,%eax
  801358:	48 01 d0             	add    %rdx,%rax
  80135b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80135e:	83 c2 08             	add    $0x8,%edx
  801361:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801364:	eb 0f                	jmp    801375 <vprintfmt+0x2a5>
  801366:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80136a:	48 89 d0             	mov    %rdx,%rax
  80136d:	48 83 c2 08          	add    $0x8,%rdx
  801371:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801375:	4c 8b 20             	mov    (%rax),%r12
  801378:	4d 85 e4             	test   %r12,%r12
  80137b:	75 0a                	jne    801387 <vprintfmt+0x2b7>
				p = "(null)";
  80137d:	49 bc 0d 4d 80 00 00 	movabs $0x804d0d,%r12
  801384:	00 00 00 
			if (width > 0 && padc != '-')
  801387:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80138b:	7e 3f                	jle    8013cc <vprintfmt+0x2fc>
  80138d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801391:	74 39                	je     8013cc <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801393:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801396:	48 98                	cltq   
  801398:	48 89 c6             	mov    %rax,%rsi
  80139b:	4c 89 e7             	mov    %r12,%rdi
  80139e:	48 b8 94 18 80 00 00 	movabs $0x801894,%rax
  8013a5:	00 00 00 
  8013a8:	ff d0                	callq  *%rax
  8013aa:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8013ad:	eb 17                	jmp    8013c6 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8013af:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8013b3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8013b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013bb:	48 89 ce             	mov    %rcx,%rsi
  8013be:	89 d7                	mov    %edx,%edi
  8013c0:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013c2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013ca:	7f e3                	jg     8013af <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013cc:	eb 37                	jmp    801405 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8013ce:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8013d2:	74 1e                	je     8013f2 <vprintfmt+0x322>
  8013d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8013d7:	7e 05                	jle    8013de <vprintfmt+0x30e>
  8013d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8013dc:	7e 14                	jle    8013f2 <vprintfmt+0x322>
					putch('?', putdat);
  8013de:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013e6:	48 89 d6             	mov    %rdx,%rsi
  8013e9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8013ee:	ff d0                	callq  *%rax
  8013f0:	eb 0f                	jmp    801401 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8013f2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013fa:	48 89 d6             	mov    %rdx,%rsi
  8013fd:	89 df                	mov    %ebx,%edi
  8013ff:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801401:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801405:	4c 89 e0             	mov    %r12,%rax
  801408:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80140c:	0f b6 00             	movzbl (%rax),%eax
  80140f:	0f be d8             	movsbl %al,%ebx
  801412:	85 db                	test   %ebx,%ebx
  801414:	74 10                	je     801426 <vprintfmt+0x356>
  801416:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80141a:	78 b2                	js     8013ce <vprintfmt+0x2fe>
  80141c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801420:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801424:	79 a8                	jns    8013ce <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801426:	eb 16                	jmp    80143e <vprintfmt+0x36e>
				putch(' ', putdat);
  801428:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80142c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801430:	48 89 d6             	mov    %rdx,%rsi
  801433:	bf 20 00 00 00       	mov    $0x20,%edi
  801438:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80143a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80143e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801442:	7f e4                	jg     801428 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801444:	e9 90 01 00 00       	jmpq   8015d9 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801449:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80144d:	be 03 00 00 00       	mov    $0x3,%esi
  801452:	48 89 c7             	mov    %rax,%rdi
  801455:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  80145c:	00 00 00 
  80145f:	ff d0                	callq  *%rax
  801461:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801469:	48 85 c0             	test   %rax,%rax
  80146c:	79 1d                	jns    80148b <vprintfmt+0x3bb>
				putch('-', putdat);
  80146e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801472:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801476:	48 89 d6             	mov    %rdx,%rsi
  801479:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80147e:	ff d0                	callq  *%rax
				num = -(long long) num;
  801480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801484:	48 f7 d8             	neg    %rax
  801487:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80148b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801492:	e9 d5 00 00 00       	jmpq   80156c <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801497:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80149b:	be 03 00 00 00       	mov    $0x3,%esi
  8014a0:	48 89 c7             	mov    %rax,%rdi
  8014a3:	48 b8 b0 0e 80 00 00 	movabs $0x800eb0,%rax
  8014aa:	00 00 00 
  8014ad:	ff d0                	callq  *%rax
  8014af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8014b3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014ba:	e9 ad 00 00 00       	jmpq   80156c <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8014bf:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8014c2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014c6:	89 d6                	mov    %edx,%esi
  8014c8:	48 89 c7             	mov    %rax,%rdi
  8014cb:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  8014d2:	00 00 00 
  8014d5:	ff d0                	callq  *%rax
  8014d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8014db:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8014e2:	e9 85 00 00 00       	jmpq   80156c <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8014e7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014ef:	48 89 d6             	mov    %rdx,%rsi
  8014f2:	bf 30 00 00 00       	mov    $0x30,%edi
  8014f7:	ff d0                	callq  *%rax
			putch('x', putdat);
  8014f9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801501:	48 89 d6             	mov    %rdx,%rsi
  801504:	bf 78 00 00 00       	mov    $0x78,%edi
  801509:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80150b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80150e:	83 f8 30             	cmp    $0x30,%eax
  801511:	73 17                	jae    80152a <vprintfmt+0x45a>
  801513:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801517:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80151a:	89 c0                	mov    %eax,%eax
  80151c:	48 01 d0             	add    %rdx,%rax
  80151f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801522:	83 c2 08             	add    $0x8,%edx
  801525:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801528:	eb 0f                	jmp    801539 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80152a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80152e:	48 89 d0             	mov    %rdx,%rax
  801531:	48 83 c2 08          	add    $0x8,%rdx
  801535:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801539:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80153c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801540:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801547:	eb 23                	jmp    80156c <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801549:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80154d:	be 03 00 00 00       	mov    $0x3,%esi
  801552:	48 89 c7             	mov    %rax,%rdi
  801555:	48 b8 b0 0e 80 00 00 	movabs $0x800eb0,%rax
  80155c:	00 00 00 
  80155f:	ff d0                	callq  *%rax
  801561:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801565:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80156c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801571:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801574:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801577:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80157b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80157f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801583:	45 89 c1             	mov    %r8d,%r9d
  801586:	41 89 f8             	mov    %edi,%r8d
  801589:	48 89 c7             	mov    %rax,%rdi
  80158c:	48 b8 f5 0d 80 00 00 	movabs $0x800df5,%rax
  801593:	00 00 00 
  801596:	ff d0                	callq  *%rax
			break;
  801598:	eb 3f                	jmp    8015d9 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80159a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80159e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015a2:	48 89 d6             	mov    %rdx,%rsi
  8015a5:	89 df                	mov    %ebx,%edi
  8015a7:	ff d0                	callq  *%rax
			break;
  8015a9:	eb 2e                	jmp    8015d9 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015ab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015b3:	48 89 d6             	mov    %rdx,%rsi
  8015b6:	bf 25 00 00 00       	mov    $0x25,%edi
  8015bb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015bd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015c2:	eb 05                	jmp    8015c9 <vprintfmt+0x4f9>
  8015c4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015c9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015cd:	48 83 e8 01          	sub    $0x1,%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	3c 25                	cmp    $0x25,%al
  8015d6:	75 ec                	jne    8015c4 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8015d8:	90                   	nop
		}
	}
  8015d9:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8015da:	e9 43 fb ff ff       	jmpq   801122 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8015df:	48 83 c4 60          	add    $0x60,%rsp
  8015e3:	5b                   	pop    %rbx
  8015e4:	41 5c                	pop    %r12
  8015e6:	5d                   	pop    %rbp
  8015e7:	c3                   	retq   

00000000008015e8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015e8:	55                   	push   %rbp
  8015e9:	48 89 e5             	mov    %rsp,%rbp
  8015ec:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8015f3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8015fa:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801601:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801608:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80160f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801616:	84 c0                	test   %al,%al
  801618:	74 20                	je     80163a <printfmt+0x52>
  80161a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80161e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801622:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801626:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80162a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80162e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801632:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801636:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80163a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801641:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801648:	00 00 00 
  80164b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801652:	00 00 00 
  801655:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801659:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801660:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801667:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80166e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801675:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80167c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801683:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80168a:	48 89 c7             	mov    %rax,%rdi
  80168d:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  801694:	00 00 00 
  801697:	ff d0                	callq  *%rax
	va_end(ap);
}
  801699:	c9                   	leaveq 
  80169a:	c3                   	retq   

000000000080169b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80169b:	55                   	push   %rbp
  80169c:	48 89 e5             	mov    %rsp,%rbp
  80169f:	48 83 ec 10          	sub    $0x10,%rsp
  8016a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8016a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ae:	8b 40 10             	mov    0x10(%rax),%eax
  8016b1:	8d 50 01             	lea    0x1(%rax),%edx
  8016b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8016bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016bf:	48 8b 10             	mov    (%rax),%rdx
  8016c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8016ca:	48 39 c2             	cmp    %rax,%rdx
  8016cd:	73 17                	jae    8016e6 <sprintputch+0x4b>
		*b->buf++ = ch;
  8016cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d3:	48 8b 00             	mov    (%rax),%rax
  8016d6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016de:	48 89 0a             	mov    %rcx,(%rdx)
  8016e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8016e4:	88 10                	mov    %dl,(%rax)
}
  8016e6:	c9                   	leaveq 
  8016e7:	c3                   	retq   

00000000008016e8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016e8:	55                   	push   %rbp
  8016e9:	48 89 e5             	mov    %rsp,%rbp
  8016ec:	48 83 ec 50          	sub    $0x50,%rsp
  8016f0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8016f4:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8016f7:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8016fb:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8016ff:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801703:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801707:	48 8b 0a             	mov    (%rdx),%rcx
  80170a:	48 89 08             	mov    %rcx,(%rax)
  80170d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801711:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801715:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801719:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80171d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801721:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801725:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801728:	48 98                	cltq   
  80172a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80172e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801732:	48 01 d0             	add    %rdx,%rax
  801735:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801739:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801740:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801745:	74 06                	je     80174d <vsnprintf+0x65>
  801747:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80174b:	7f 07                	jg     801754 <vsnprintf+0x6c>
		return -E_INVAL;
  80174d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801752:	eb 2f                	jmp    801783 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801754:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801758:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80175c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801760:	48 89 c6             	mov    %rax,%rsi
  801763:	48 bf 9b 16 80 00 00 	movabs $0x80169b,%rdi
  80176a:	00 00 00 
  80176d:	48 b8 d0 10 80 00 00 	movabs $0x8010d0,%rax
  801774:	00 00 00 
  801777:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801779:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80177d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801780:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801783:	c9                   	leaveq 
  801784:	c3                   	retq   

0000000000801785 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801785:	55                   	push   %rbp
  801786:	48 89 e5             	mov    %rsp,%rbp
  801789:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801790:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801797:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80179d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017a4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017ab:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017b2:	84 c0                	test   %al,%al
  8017b4:	74 20                	je     8017d6 <snprintf+0x51>
  8017b6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017ba:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8017be:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8017c2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017c6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8017ca:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8017ce:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8017d2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8017d6:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8017dd:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8017e4:	00 00 00 
  8017e7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8017ee:	00 00 00 
  8017f1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8017f5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8017fc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801803:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80180a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801811:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801818:	48 8b 0a             	mov    (%rdx),%rcx
  80181b:	48 89 08             	mov    %rcx,(%rax)
  80181e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801822:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801826:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80182a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80182e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801835:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80183c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801842:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801849:	48 89 c7             	mov    %rax,%rdi
  80184c:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  801853:	00 00 00 
  801856:	ff d0                	callq  *%rax
  801858:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80185e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801864:	c9                   	leaveq 
  801865:	c3                   	retq   

0000000000801866 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801866:	55                   	push   %rbp
  801867:	48 89 e5             	mov    %rsp,%rbp
  80186a:	48 83 ec 18          	sub    $0x18,%rsp
  80186e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801872:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801879:	eb 09                	jmp    801884 <strlen+0x1e>
		n++;
  80187b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80187f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801888:	0f b6 00             	movzbl (%rax),%eax
  80188b:	84 c0                	test   %al,%al
  80188d:	75 ec                	jne    80187b <strlen+0x15>
		n++;
	return n;
  80188f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801892:	c9                   	leaveq 
  801893:	c3                   	retq   

0000000000801894 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801894:	55                   	push   %rbp
  801895:	48 89 e5             	mov    %rsp,%rbp
  801898:	48 83 ec 20          	sub    $0x20,%rsp
  80189c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018ab:	eb 0e                	jmp    8018bb <strnlen+0x27>
		n++;
  8018ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018b1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018b6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8018bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8018c0:	74 0b                	je     8018cd <strnlen+0x39>
  8018c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c6:	0f b6 00             	movzbl (%rax),%eax
  8018c9:	84 c0                	test   %al,%al
  8018cb:	75 e0                	jne    8018ad <strnlen+0x19>
		n++;
	return n;
  8018cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018d0:	c9                   	leaveq 
  8018d1:	c3                   	retq   

00000000008018d2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018d2:	55                   	push   %rbp
  8018d3:	48 89 e5             	mov    %rsp,%rbp
  8018d6:	48 83 ec 20          	sub    $0x20,%rsp
  8018da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8018e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8018ea:	90                   	nop
  8018eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ef:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018f7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8018fb:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8018ff:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801903:	0f b6 12             	movzbl (%rdx),%edx
  801906:	88 10                	mov    %dl,(%rax)
  801908:	0f b6 00             	movzbl (%rax),%eax
  80190b:	84 c0                	test   %al,%al
  80190d:	75 dc                	jne    8018eb <strcpy+0x19>
		/* do nothing */;
	return ret;
  80190f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801913:	c9                   	leaveq 
  801914:	c3                   	retq   

0000000000801915 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801915:	55                   	push   %rbp
  801916:	48 89 e5             	mov    %rsp,%rbp
  801919:	48 83 ec 20          	sub    $0x20,%rsp
  80191d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801921:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801929:	48 89 c7             	mov    %rax,%rdi
  80192c:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  801933:	00 00 00 
  801936:	ff d0                	callq  *%rax
  801938:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80193b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193e:	48 63 d0             	movslq %eax,%rdx
  801941:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801945:	48 01 c2             	add    %rax,%rdx
  801948:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80194c:	48 89 c6             	mov    %rax,%rsi
  80194f:	48 89 d7             	mov    %rdx,%rdi
  801952:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  801959:	00 00 00 
  80195c:	ff d0                	callq  *%rax
	return dst;
  80195e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801962:	c9                   	leaveq 
  801963:	c3                   	retq   

0000000000801964 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	48 83 ec 28          	sub    $0x28,%rsp
  80196c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801970:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801974:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801978:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80197c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801980:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801987:	00 
  801988:	eb 2a                	jmp    8019b4 <strncpy+0x50>
		*dst++ = *src;
  80198a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80198e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801992:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801996:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80199a:	0f b6 12             	movzbl (%rdx),%edx
  80199d:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80199f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019a3:	0f b6 00             	movzbl (%rax),%eax
  8019a6:	84 c0                	test   %al,%al
  8019a8:	74 05                	je     8019af <strncpy+0x4b>
			src++;
  8019aa:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019bc:	72 cc                	jb     80198a <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019c2:	c9                   	leaveq 
  8019c3:	c3                   	retq   

00000000008019c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
  8019c8:	48 83 ec 28          	sub    $0x28,%rsp
  8019cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8019d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8019e0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019e5:	74 3d                	je     801a24 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8019e7:	eb 1d                	jmp    801a06 <strlcpy+0x42>
			*dst++ = *src++;
  8019e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019f5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019f9:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8019fd:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801a01:	0f b6 12             	movzbl (%rdx),%edx
  801a04:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a06:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a0b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a10:	74 0b                	je     801a1d <strlcpy+0x59>
  801a12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a16:	0f b6 00             	movzbl (%rax),%eax
  801a19:	84 c0                	test   %al,%al
  801a1b:	75 cc                	jne    8019e9 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a21:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a24:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a2c:	48 29 c2             	sub    %rax,%rdx
  801a2f:	48 89 d0             	mov    %rdx,%rax
}
  801a32:	c9                   	leaveq 
  801a33:	c3                   	retq   

0000000000801a34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a34:	55                   	push   %rbp
  801a35:	48 89 e5             	mov    %rsp,%rbp
  801a38:	48 83 ec 10          	sub    $0x10,%rsp
  801a3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a44:	eb 0a                	jmp    801a50 <strcmp+0x1c>
		p++, q++;
  801a46:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a4b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a54:	0f b6 00             	movzbl (%rax),%eax
  801a57:	84 c0                	test   %al,%al
  801a59:	74 12                	je     801a6d <strcmp+0x39>
  801a5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5f:	0f b6 10             	movzbl (%rax),%edx
  801a62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a66:	0f b6 00             	movzbl (%rax),%eax
  801a69:	38 c2                	cmp    %al,%dl
  801a6b:	74 d9                	je     801a46 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a71:	0f b6 00             	movzbl (%rax),%eax
  801a74:	0f b6 d0             	movzbl %al,%edx
  801a77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a7b:	0f b6 00             	movzbl (%rax),%eax
  801a7e:	0f b6 c0             	movzbl %al,%eax
  801a81:	29 c2                	sub    %eax,%edx
  801a83:	89 d0                	mov    %edx,%eax
}
  801a85:	c9                   	leaveq 
  801a86:	c3                   	retq   

0000000000801a87 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a87:	55                   	push   %rbp
  801a88:	48 89 e5             	mov    %rsp,%rbp
  801a8b:	48 83 ec 18          	sub    $0x18,%rsp
  801a8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a97:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801a9b:	eb 0f                	jmp    801aac <strncmp+0x25>
		n--, p++, q++;
  801a9d:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801aa2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801aa7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801aac:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ab1:	74 1d                	je     801ad0 <strncmp+0x49>
  801ab3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab7:	0f b6 00             	movzbl (%rax),%eax
  801aba:	84 c0                	test   %al,%al
  801abc:	74 12                	je     801ad0 <strncmp+0x49>
  801abe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac2:	0f b6 10             	movzbl (%rax),%edx
  801ac5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac9:	0f b6 00             	movzbl (%rax),%eax
  801acc:	38 c2                	cmp    %al,%dl
  801ace:	74 cd                	je     801a9d <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801ad0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ad5:	75 07                	jne    801ade <strncmp+0x57>
		return 0;
  801ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  801adc:	eb 18                	jmp    801af6 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ade:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae2:	0f b6 00             	movzbl (%rax),%eax
  801ae5:	0f b6 d0             	movzbl %al,%edx
  801ae8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aec:	0f b6 00             	movzbl (%rax),%eax
  801aef:	0f b6 c0             	movzbl %al,%eax
  801af2:	29 c2                	sub    %eax,%edx
  801af4:	89 d0                	mov    %edx,%eax
}
  801af6:	c9                   	leaveq 
  801af7:	c3                   	retq   

0000000000801af8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801af8:	55                   	push   %rbp
  801af9:	48 89 e5             	mov    %rsp,%rbp
  801afc:	48 83 ec 0c          	sub    $0xc,%rsp
  801b00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b04:	89 f0                	mov    %esi,%eax
  801b06:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b09:	eb 17                	jmp    801b22 <strchr+0x2a>
		if (*s == c)
  801b0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0f:	0f b6 00             	movzbl (%rax),%eax
  801b12:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b15:	75 06                	jne    801b1d <strchr+0x25>
			return (char *) s;
  801b17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1b:	eb 15                	jmp    801b32 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b1d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b26:	0f b6 00             	movzbl (%rax),%eax
  801b29:	84 c0                	test   %al,%al
  801b2b:	75 de                	jne    801b0b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b32:	c9                   	leaveq 
  801b33:	c3                   	retq   

0000000000801b34 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b34:	55                   	push   %rbp
  801b35:	48 89 e5             	mov    %rsp,%rbp
  801b38:	48 83 ec 0c          	sub    $0xc,%rsp
  801b3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b40:	89 f0                	mov    %esi,%eax
  801b42:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b45:	eb 13                	jmp    801b5a <strfind+0x26>
		if (*s == c)
  801b47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b4b:	0f b6 00             	movzbl (%rax),%eax
  801b4e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b51:	75 02                	jne    801b55 <strfind+0x21>
			break;
  801b53:	eb 10                	jmp    801b65 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b55:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5e:	0f b6 00             	movzbl (%rax),%eax
  801b61:	84 c0                	test   %al,%al
  801b63:	75 e2                	jne    801b47 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801b65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b69:	c9                   	leaveq 
  801b6a:	c3                   	retq   

0000000000801b6b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b6b:	55                   	push   %rbp
  801b6c:	48 89 e5             	mov    %rsp,%rbp
  801b6f:	48 83 ec 18          	sub    $0x18,%rsp
  801b73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b77:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801b7a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801b7e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b83:	75 06                	jne    801b8b <memset+0x20>
		return v;
  801b85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b89:	eb 69                	jmp    801bf4 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801b8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b8f:	83 e0 03             	and    $0x3,%eax
  801b92:	48 85 c0             	test   %rax,%rax
  801b95:	75 48                	jne    801bdf <memset+0x74>
  801b97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b9b:	83 e0 03             	and    $0x3,%eax
  801b9e:	48 85 c0             	test   %rax,%rax
  801ba1:	75 3c                	jne    801bdf <memset+0x74>
		c &= 0xFF;
  801ba3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801baa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bad:	c1 e0 18             	shl    $0x18,%eax
  801bb0:	89 c2                	mov    %eax,%edx
  801bb2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bb5:	c1 e0 10             	shl    $0x10,%eax
  801bb8:	09 c2                	or     %eax,%edx
  801bba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bbd:	c1 e0 08             	shl    $0x8,%eax
  801bc0:	09 d0                	or     %edx,%eax
  801bc2:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc9:	48 c1 e8 02          	shr    $0x2,%rax
  801bcd:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801bd0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bd4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bd7:	48 89 d7             	mov    %rdx,%rdi
  801bda:	fc                   	cld    
  801bdb:	f3 ab                	rep stos %eax,%es:(%rdi)
  801bdd:	eb 11                	jmp    801bf0 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801bdf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801be3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801be6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bea:	48 89 d7             	mov    %rdx,%rdi
  801bed:	fc                   	cld    
  801bee:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801bf4:	c9                   	leaveq 
  801bf5:	c3                   	retq   

0000000000801bf6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801bf6:	55                   	push   %rbp
  801bf7:	48 89 e5             	mov    %rsp,%rbp
  801bfa:	48 83 ec 28          	sub    $0x28,%rsp
  801bfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c02:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c06:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c0e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c16:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c1e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c22:	0f 83 88 00 00 00    	jae    801cb0 <memmove+0xba>
  801c28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c30:	48 01 d0             	add    %rdx,%rax
  801c33:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c37:	76 77                	jbe    801cb0 <memmove+0xba>
		s += n;
  801c39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c3d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c45:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4d:	83 e0 03             	and    $0x3,%eax
  801c50:	48 85 c0             	test   %rax,%rax
  801c53:	75 3b                	jne    801c90 <memmove+0x9a>
  801c55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c59:	83 e0 03             	and    $0x3,%eax
  801c5c:	48 85 c0             	test   %rax,%rax
  801c5f:	75 2f                	jne    801c90 <memmove+0x9a>
  801c61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c65:	83 e0 03             	and    $0x3,%eax
  801c68:	48 85 c0             	test   %rax,%rax
  801c6b:	75 23                	jne    801c90 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c71:	48 83 e8 04          	sub    $0x4,%rax
  801c75:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c79:	48 83 ea 04          	sub    $0x4,%rdx
  801c7d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801c81:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c85:	48 89 c7             	mov    %rax,%rdi
  801c88:	48 89 d6             	mov    %rdx,%rsi
  801c8b:	fd                   	std    
  801c8c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801c8e:	eb 1d                	jmp    801cad <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c94:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801c98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c9c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801ca0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca4:	48 89 d7             	mov    %rdx,%rdi
  801ca7:	48 89 c1             	mov    %rax,%rcx
  801caa:	fd                   	std    
  801cab:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801cad:	fc                   	cld    
  801cae:	eb 57                	jmp    801d07 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801cb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb4:	83 e0 03             	and    $0x3,%eax
  801cb7:	48 85 c0             	test   %rax,%rax
  801cba:	75 36                	jne    801cf2 <memmove+0xfc>
  801cbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc0:	83 e0 03             	and    $0x3,%eax
  801cc3:	48 85 c0             	test   %rax,%rax
  801cc6:	75 2a                	jne    801cf2 <memmove+0xfc>
  801cc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ccc:	83 e0 03             	and    $0x3,%eax
  801ccf:	48 85 c0             	test   %rax,%rax
  801cd2:	75 1e                	jne    801cf2 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801cd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd8:	48 c1 e8 02          	shr    $0x2,%rax
  801cdc:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ce7:	48 89 c7             	mov    %rax,%rdi
  801cea:	48 89 d6             	mov    %rdx,%rsi
  801ced:	fc                   	cld    
  801cee:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801cf0:	eb 15                	jmp    801d07 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801cf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cfa:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801cfe:	48 89 c7             	mov    %rax,%rdi
  801d01:	48 89 d6             	mov    %rdx,%rsi
  801d04:	fc                   	cld    
  801d05:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d0b:	c9                   	leaveq 
  801d0c:	c3                   	retq   

0000000000801d0d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d0d:	55                   	push   %rbp
  801d0e:	48 89 e5             	mov    %rsp,%rbp
  801d11:	48 83 ec 18          	sub    $0x18,%rsp
  801d15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d1d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d21:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d25:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d2d:	48 89 ce             	mov    %rcx,%rsi
  801d30:	48 89 c7             	mov    %rax,%rdi
  801d33:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  801d3a:	00 00 00 
  801d3d:	ff d0                	callq  *%rax
}
  801d3f:	c9                   	leaveq 
  801d40:	c3                   	retq   

0000000000801d41 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d41:	55                   	push   %rbp
  801d42:	48 89 e5             	mov    %rsp,%rbp
  801d45:	48 83 ec 28          	sub    $0x28,%rsp
  801d49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d4d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d51:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d65:	eb 36                	jmp    801d9d <memcmp+0x5c>
		if (*s1 != *s2)
  801d67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6b:	0f b6 10             	movzbl (%rax),%edx
  801d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d72:	0f b6 00             	movzbl (%rax),%eax
  801d75:	38 c2                	cmp    %al,%dl
  801d77:	74 1a                	je     801d93 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801d79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d7d:	0f b6 00             	movzbl (%rax),%eax
  801d80:	0f b6 d0             	movzbl %al,%edx
  801d83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d87:	0f b6 00             	movzbl (%rax),%eax
  801d8a:	0f b6 c0             	movzbl %al,%eax
  801d8d:	29 c2                	sub    %eax,%edx
  801d8f:	89 d0                	mov    %edx,%eax
  801d91:	eb 20                	jmp    801db3 <memcmp+0x72>
		s1++, s2++;
  801d93:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d98:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801da1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801da5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801da9:	48 85 c0             	test   %rax,%rax
  801dac:	75 b9                	jne    801d67 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db3:	c9                   	leaveq 
  801db4:	c3                   	retq   

0000000000801db5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801db5:	55                   	push   %rbp
  801db6:	48 89 e5             	mov    %rsp,%rbp
  801db9:	48 83 ec 28          	sub    $0x28,%rsp
  801dbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dc1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801dc4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801dc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dcc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801dd0:	48 01 d0             	add    %rdx,%rax
  801dd3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801dd7:	eb 15                	jmp    801dee <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ddd:	0f b6 10             	movzbl (%rax),%edx
  801de0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801de3:	38 c2                	cmp    %al,%dl
  801de5:	75 02                	jne    801de9 <memfind+0x34>
			break;
  801de7:	eb 0f                	jmp    801df8 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801de9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801dee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801df6:	72 e1                	jb     801dd9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801df8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801dfc:	c9                   	leaveq 
  801dfd:	c3                   	retq   

0000000000801dfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801dfe:	55                   	push   %rbp
  801dff:	48 89 e5             	mov    %rsp,%rbp
  801e02:	48 83 ec 34          	sub    $0x34,%rsp
  801e06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e0a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e0e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e18:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e1f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e20:	eb 05                	jmp    801e27 <strtol+0x29>
		s++;
  801e22:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2b:	0f b6 00             	movzbl (%rax),%eax
  801e2e:	3c 20                	cmp    $0x20,%al
  801e30:	74 f0                	je     801e22 <strtol+0x24>
  801e32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e36:	0f b6 00             	movzbl (%rax),%eax
  801e39:	3c 09                	cmp    $0x9,%al
  801e3b:	74 e5                	je     801e22 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e41:	0f b6 00             	movzbl (%rax),%eax
  801e44:	3c 2b                	cmp    $0x2b,%al
  801e46:	75 07                	jne    801e4f <strtol+0x51>
		s++;
  801e48:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e4d:	eb 17                	jmp    801e66 <strtol+0x68>
	else if (*s == '-')
  801e4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e53:	0f b6 00             	movzbl (%rax),%eax
  801e56:	3c 2d                	cmp    $0x2d,%al
  801e58:	75 0c                	jne    801e66 <strtol+0x68>
		s++, neg = 1;
  801e5a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e5f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e66:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e6a:	74 06                	je     801e72 <strtol+0x74>
  801e6c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801e70:	75 28                	jne    801e9a <strtol+0x9c>
  801e72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e76:	0f b6 00             	movzbl (%rax),%eax
  801e79:	3c 30                	cmp    $0x30,%al
  801e7b:	75 1d                	jne    801e9a <strtol+0x9c>
  801e7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e81:	48 83 c0 01          	add    $0x1,%rax
  801e85:	0f b6 00             	movzbl (%rax),%eax
  801e88:	3c 78                	cmp    $0x78,%al
  801e8a:	75 0e                	jne    801e9a <strtol+0x9c>
		s += 2, base = 16;
  801e8c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801e91:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801e98:	eb 2c                	jmp    801ec6 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801e9a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e9e:	75 19                	jne    801eb9 <strtol+0xbb>
  801ea0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea4:	0f b6 00             	movzbl (%rax),%eax
  801ea7:	3c 30                	cmp    $0x30,%al
  801ea9:	75 0e                	jne    801eb9 <strtol+0xbb>
		s++, base = 8;
  801eab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801eb0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801eb7:	eb 0d                	jmp    801ec6 <strtol+0xc8>
	else if (base == 0)
  801eb9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ebd:	75 07                	jne    801ec6 <strtol+0xc8>
		base = 10;
  801ebf:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ec6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eca:	0f b6 00             	movzbl (%rax),%eax
  801ecd:	3c 2f                	cmp    $0x2f,%al
  801ecf:	7e 1d                	jle    801eee <strtol+0xf0>
  801ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed5:	0f b6 00             	movzbl (%rax),%eax
  801ed8:	3c 39                	cmp    $0x39,%al
  801eda:	7f 12                	jg     801eee <strtol+0xf0>
			dig = *s - '0';
  801edc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee0:	0f b6 00             	movzbl (%rax),%eax
  801ee3:	0f be c0             	movsbl %al,%eax
  801ee6:	83 e8 30             	sub    $0x30,%eax
  801ee9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801eec:	eb 4e                	jmp    801f3c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801eee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef2:	0f b6 00             	movzbl (%rax),%eax
  801ef5:	3c 60                	cmp    $0x60,%al
  801ef7:	7e 1d                	jle    801f16 <strtol+0x118>
  801ef9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801efd:	0f b6 00             	movzbl (%rax),%eax
  801f00:	3c 7a                	cmp    $0x7a,%al
  801f02:	7f 12                	jg     801f16 <strtol+0x118>
			dig = *s - 'a' + 10;
  801f04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f08:	0f b6 00             	movzbl (%rax),%eax
  801f0b:	0f be c0             	movsbl %al,%eax
  801f0e:	83 e8 57             	sub    $0x57,%eax
  801f11:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f14:	eb 26                	jmp    801f3c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1a:	0f b6 00             	movzbl (%rax),%eax
  801f1d:	3c 40                	cmp    $0x40,%al
  801f1f:	7e 48                	jle    801f69 <strtol+0x16b>
  801f21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f25:	0f b6 00             	movzbl (%rax),%eax
  801f28:	3c 5a                	cmp    $0x5a,%al
  801f2a:	7f 3d                	jg     801f69 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801f2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f30:	0f b6 00             	movzbl (%rax),%eax
  801f33:	0f be c0             	movsbl %al,%eax
  801f36:	83 e8 37             	sub    $0x37,%eax
  801f39:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f3f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f42:	7c 02                	jl     801f46 <strtol+0x148>
			break;
  801f44:	eb 23                	jmp    801f69 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801f46:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f4b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f4e:	48 98                	cltq   
  801f50:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801f55:	48 89 c2             	mov    %rax,%rdx
  801f58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f5b:	48 98                	cltq   
  801f5d:	48 01 d0             	add    %rdx,%rax
  801f60:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f64:	e9 5d ff ff ff       	jmpq   801ec6 <strtol+0xc8>

	if (endptr)
  801f69:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801f6e:	74 0b                	je     801f7b <strtol+0x17d>
		*endptr = (char *) s;
  801f70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f74:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f78:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801f7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f7f:	74 09                	je     801f8a <strtol+0x18c>
  801f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f85:	48 f7 d8             	neg    %rax
  801f88:	eb 04                	jmp    801f8e <strtol+0x190>
  801f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801f8e:	c9                   	leaveq 
  801f8f:	c3                   	retq   

0000000000801f90 <strstr>:

char * strstr(const char *in, const char *str)
{
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
  801f94:	48 83 ec 30          	sub    $0x30,%rsp
  801f98:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f9c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801fa0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fa4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fa8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801fac:	0f b6 00             	movzbl (%rax),%eax
  801faf:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801fb2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801fb6:	75 06                	jne    801fbe <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801fb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fbc:	eb 6b                	jmp    802029 <strstr+0x99>

	len = strlen(str);
  801fbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fc2:	48 89 c7             	mov    %rax,%rdi
  801fc5:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  801fcc:	00 00 00 
  801fcf:	ff d0                	callq  *%rax
  801fd1:	48 98                	cltq   
  801fd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801fd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fdb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fdf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fe3:	0f b6 00             	movzbl (%rax),%eax
  801fe6:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801fe9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801fed:	75 07                	jne    801ff6 <strstr+0x66>
				return (char *) 0;
  801fef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff4:	eb 33                	jmp    802029 <strstr+0x99>
		} while (sc != c);
  801ff6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801ffa:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ffd:	75 d8                	jne    801fd7 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801fff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802003:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802007:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80200b:	48 89 ce             	mov    %rcx,%rsi
  80200e:	48 89 c7             	mov    %rax,%rdi
  802011:	48 b8 87 1a 80 00 00 	movabs $0x801a87,%rax
  802018:	00 00 00 
  80201b:	ff d0                	callq  *%rax
  80201d:	85 c0                	test   %eax,%eax
  80201f:	75 b6                	jne    801fd7 <strstr+0x47>

	return (char *) (in - 1);
  802021:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802025:	48 83 e8 01          	sub    $0x1,%rax
}
  802029:	c9                   	leaveq 
  80202a:	c3                   	retq   

000000000080202b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80202b:	55                   	push   %rbp
  80202c:	48 89 e5             	mov    %rsp,%rbp
  80202f:	53                   	push   %rbx
  802030:	48 83 ec 48          	sub    $0x48,%rsp
  802034:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802037:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80203a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80203e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802042:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802046:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80204a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80204d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802051:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802055:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802059:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80205d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802061:	4c 89 c3             	mov    %r8,%rbx
  802064:	cd 30                	int    $0x30
  802066:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80206a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80206e:	74 3e                	je     8020ae <syscall+0x83>
  802070:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802075:	7e 37                	jle    8020ae <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802077:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80207b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80207e:	49 89 d0             	mov    %rdx,%r8
  802081:	89 c1                	mov    %eax,%ecx
  802083:	48 ba c8 4f 80 00 00 	movabs $0x804fc8,%rdx
  80208a:	00 00 00 
  80208d:	be 23 00 00 00       	mov    $0x23,%esi
  802092:	48 bf e5 4f 80 00 00 	movabs $0x804fe5,%rdi
  802099:	00 00 00 
  80209c:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a1:	49 b9 e4 0a 80 00 00 	movabs $0x800ae4,%r9
  8020a8:	00 00 00 
  8020ab:	41 ff d1             	callq  *%r9

	return ret;
  8020ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8020b2:	48 83 c4 48          	add    $0x48,%rsp
  8020b6:	5b                   	pop    %rbx
  8020b7:	5d                   	pop    %rbp
  8020b8:	c3                   	retq   

00000000008020b9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8020b9:	55                   	push   %rbp
  8020ba:	48 89 e5             	mov    %rsp,%rbp
  8020bd:	48 83 ec 20          	sub    $0x20,%rsp
  8020c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8020c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020d8:	00 
  8020d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020e5:	48 89 d1             	mov    %rdx,%rcx
  8020e8:	48 89 c2             	mov    %rax,%rdx
  8020eb:	be 00 00 00 00       	mov    $0x0,%esi
  8020f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f5:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8020fc:	00 00 00 
  8020ff:	ff d0                	callq  *%rax
}
  802101:	c9                   	leaveq 
  802102:	c3                   	retq   

0000000000802103 <sys_cgetc>:

int
sys_cgetc(void)
{
  802103:	55                   	push   %rbp
  802104:	48 89 e5             	mov    %rsp,%rbp
  802107:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80210b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802112:	00 
  802113:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802119:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80211f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802124:	ba 00 00 00 00       	mov    $0x0,%edx
  802129:	be 00 00 00 00       	mov    $0x0,%esi
  80212e:	bf 01 00 00 00       	mov    $0x1,%edi
  802133:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax
}
  80213f:	c9                   	leaveq 
  802140:	c3                   	retq   

0000000000802141 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802141:	55                   	push   %rbp
  802142:	48 89 e5             	mov    %rsp,%rbp
  802145:	48 83 ec 10          	sub    $0x10,%rsp
  802149:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80214c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214f:	48 98                	cltq   
  802151:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802158:	00 
  802159:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80215f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802165:	b9 00 00 00 00       	mov    $0x0,%ecx
  80216a:	48 89 c2             	mov    %rax,%rdx
  80216d:	be 01 00 00 00       	mov    $0x1,%esi
  802172:	bf 03 00 00 00       	mov    $0x3,%edi
  802177:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80217e:	00 00 00 
  802181:	ff d0                	callq  *%rax
}
  802183:	c9                   	leaveq 
  802184:	c3                   	retq   

0000000000802185 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802185:	55                   	push   %rbp
  802186:	48 89 e5             	mov    %rsp,%rbp
  802189:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80218d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802194:	00 
  802195:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80219b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ab:	be 00 00 00 00       	mov    $0x0,%esi
  8021b0:	bf 02 00 00 00       	mov    $0x2,%edi
  8021b5:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8021bc:	00 00 00 
  8021bf:	ff d0                	callq  *%rax
}
  8021c1:	c9                   	leaveq 
  8021c2:	c3                   	retq   

00000000008021c3 <sys_yield>:

void
sys_yield(void)
{
  8021c3:	55                   	push   %rbp
  8021c4:	48 89 e5             	mov    %rsp,%rbp
  8021c7:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8021cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021d2:	00 
  8021d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e9:	be 00 00 00 00       	mov    $0x0,%esi
  8021ee:	bf 0b 00 00 00       	mov    $0xb,%edi
  8021f3:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8021fa:	00 00 00 
  8021fd:	ff d0                	callq  *%rax
}
  8021ff:	c9                   	leaveq 
  802200:	c3                   	retq   

0000000000802201 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802201:	55                   	push   %rbp
  802202:	48 89 e5             	mov    %rsp,%rbp
  802205:	48 83 ec 20          	sub    $0x20,%rsp
  802209:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80220c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802210:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802213:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802216:	48 63 c8             	movslq %eax,%rcx
  802219:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80221d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802220:	48 98                	cltq   
  802222:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802229:	00 
  80222a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802230:	49 89 c8             	mov    %rcx,%r8
  802233:	48 89 d1             	mov    %rdx,%rcx
  802236:	48 89 c2             	mov    %rax,%rdx
  802239:	be 01 00 00 00       	mov    $0x1,%esi
  80223e:	bf 04 00 00 00       	mov    $0x4,%edi
  802243:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80224a:	00 00 00 
  80224d:	ff d0                	callq  *%rax
}
  80224f:	c9                   	leaveq 
  802250:	c3                   	retq   

0000000000802251 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802251:	55                   	push   %rbp
  802252:	48 89 e5             	mov    %rsp,%rbp
  802255:	48 83 ec 30          	sub    $0x30,%rsp
  802259:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80225c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802260:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802263:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802267:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80226b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80226e:	48 63 c8             	movslq %eax,%rcx
  802271:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802275:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802278:	48 63 f0             	movslq %eax,%rsi
  80227b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80227f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802282:	48 98                	cltq   
  802284:	48 89 0c 24          	mov    %rcx,(%rsp)
  802288:	49 89 f9             	mov    %rdi,%r9
  80228b:	49 89 f0             	mov    %rsi,%r8
  80228e:	48 89 d1             	mov    %rdx,%rcx
  802291:	48 89 c2             	mov    %rax,%rdx
  802294:	be 01 00 00 00       	mov    $0x1,%esi
  802299:	bf 05 00 00 00       	mov    $0x5,%edi
  80229e:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8022a5:	00 00 00 
  8022a8:	ff d0                	callq  *%rax
}
  8022aa:	c9                   	leaveq 
  8022ab:	c3                   	retq   

00000000008022ac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022ac:	55                   	push   %rbp
  8022ad:	48 89 e5             	mov    %rsp,%rbp
  8022b0:	48 83 ec 20          	sub    $0x20,%rsp
  8022b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8022bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c2:	48 98                	cltq   
  8022c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022cb:	00 
  8022cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022d8:	48 89 d1             	mov    %rdx,%rcx
  8022db:	48 89 c2             	mov    %rax,%rdx
  8022de:	be 01 00 00 00       	mov    $0x1,%esi
  8022e3:	bf 06 00 00 00       	mov    $0x6,%edi
  8022e8:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8022ef:	00 00 00 
  8022f2:	ff d0                	callq  *%rax
}
  8022f4:	c9                   	leaveq 
  8022f5:	c3                   	retq   

00000000008022f6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8022f6:	55                   	push   %rbp
  8022f7:	48 89 e5             	mov    %rsp,%rbp
  8022fa:	48 83 ec 10          	sub    $0x10,%rsp
  8022fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802301:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802304:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802307:	48 63 d0             	movslq %eax,%rdx
  80230a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80230d:	48 98                	cltq   
  80230f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802316:	00 
  802317:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80231d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802323:	48 89 d1             	mov    %rdx,%rcx
  802326:	48 89 c2             	mov    %rax,%rdx
  802329:	be 01 00 00 00       	mov    $0x1,%esi
  80232e:	bf 08 00 00 00       	mov    $0x8,%edi
  802333:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80233a:	00 00 00 
  80233d:	ff d0                	callq  *%rax
}
  80233f:	c9                   	leaveq 
  802340:	c3                   	retq   

0000000000802341 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802341:	55                   	push   %rbp
  802342:	48 89 e5             	mov    %rsp,%rbp
  802345:	48 83 ec 20          	sub    $0x20,%rsp
  802349:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80234c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802350:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802357:	48 98                	cltq   
  802359:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802360:	00 
  802361:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802367:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80236d:	48 89 d1             	mov    %rdx,%rcx
  802370:	48 89 c2             	mov    %rax,%rdx
  802373:	be 01 00 00 00       	mov    $0x1,%esi
  802378:	bf 09 00 00 00       	mov    $0x9,%edi
  80237d:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802384:	00 00 00 
  802387:	ff d0                	callq  *%rax
}
  802389:	c9                   	leaveq 
  80238a:	c3                   	retq   

000000000080238b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80238b:	55                   	push   %rbp
  80238c:	48 89 e5             	mov    %rsp,%rbp
  80238f:	48 83 ec 20          	sub    $0x20,%rsp
  802393:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802396:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80239a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80239e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a1:	48 98                	cltq   
  8023a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023aa:	00 
  8023ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023b7:	48 89 d1             	mov    %rdx,%rcx
  8023ba:	48 89 c2             	mov    %rax,%rdx
  8023bd:	be 01 00 00 00       	mov    $0x1,%esi
  8023c2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8023c7:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8023ce:	00 00 00 
  8023d1:	ff d0                	callq  *%rax
}
  8023d3:	c9                   	leaveq 
  8023d4:	c3                   	retq   

00000000008023d5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8023d5:	55                   	push   %rbp
  8023d6:	48 89 e5             	mov    %rsp,%rbp
  8023d9:	48 83 ec 20          	sub    $0x20,%rsp
  8023dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8023e8:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8023eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023ee:	48 63 f0             	movslq %eax,%rsi
  8023f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f8:	48 98                	cltq   
  8023fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802405:	00 
  802406:	49 89 f1             	mov    %rsi,%r9
  802409:	49 89 c8             	mov    %rcx,%r8
  80240c:	48 89 d1             	mov    %rdx,%rcx
  80240f:	48 89 c2             	mov    %rax,%rdx
  802412:	be 00 00 00 00       	mov    $0x0,%esi
  802417:	bf 0c 00 00 00       	mov    $0xc,%edi
  80241c:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802423:	00 00 00 
  802426:	ff d0                	callq  *%rax
}
  802428:	c9                   	leaveq 
  802429:	c3                   	retq   

000000000080242a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80242a:	55                   	push   %rbp
  80242b:	48 89 e5             	mov    %rsp,%rbp
  80242e:	48 83 ec 10          	sub    $0x10,%rsp
  802432:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80243a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802441:	00 
  802442:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802448:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80244e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802453:	48 89 c2             	mov    %rax,%rdx
  802456:	be 01 00 00 00       	mov    $0x1,%esi
  80245b:	bf 0d 00 00 00       	mov    $0xd,%edi
  802460:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802467:	00 00 00 
  80246a:	ff d0                	callq  *%rax
}
  80246c:	c9                   	leaveq 
  80246d:	c3                   	retq   

000000000080246e <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  80246e:	55                   	push   %rbp
  80246f:	48 89 e5             	mov    %rsp,%rbp
  802472:	48 83 ec 20          	sub    $0x20,%rsp
  802476:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80247a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  80247e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802482:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802486:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80248d:	00 
  80248e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802494:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80249a:	48 89 d1             	mov    %rdx,%rcx
  80249d:	48 89 c2             	mov    %rax,%rdx
  8024a0:	be 01 00 00 00       	mov    $0x1,%esi
  8024a5:	bf 0f 00 00 00       	mov    $0xf,%edi
  8024aa:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8024b1:	00 00 00 
  8024b4:	ff d0                	callq  *%rax
}
  8024b6:	c9                   	leaveq 
  8024b7:	c3                   	retq   

00000000008024b8 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  8024b8:	55                   	push   %rbp
  8024b9:	48 89 e5             	mov    %rsp,%rbp
  8024bc:	48 83 ec 10          	sub    $0x10,%rsp
  8024c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  8024c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024cf:	00 
  8024d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8024e1:	48 89 c2             	mov    %rax,%rdx
  8024e4:	be 00 00 00 00       	mov    $0x0,%esi
  8024e9:	bf 10 00 00 00       	mov    $0x10,%edi
  8024ee:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8024f5:	00 00 00 
  8024f8:	ff d0                	callq  *%rax
}
  8024fa:	c9                   	leaveq 
  8024fb:	c3                   	retq   

00000000008024fc <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8024fc:	55                   	push   %rbp
  8024fd:	48 89 e5             	mov    %rsp,%rbp
  802500:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802504:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80250b:	00 
  80250c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802512:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802518:	b9 00 00 00 00       	mov    $0x0,%ecx
  80251d:	ba 00 00 00 00       	mov    $0x0,%edx
  802522:	be 00 00 00 00       	mov    $0x0,%esi
  802527:	bf 0e 00 00 00       	mov    $0xe,%edi
  80252c:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802533:	00 00 00 
  802536:	ff d0                	callq  *%rax
}
  802538:	c9                   	leaveq 
  802539:	c3                   	retq   

000000000080253a <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80253a:	55                   	push   %rbp
  80253b:	48 89 e5             	mov    %rsp,%rbp
  80253e:	48 83 ec 10          	sub    $0x10,%rsp
  802542:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  802546:	48 b8 e0 81 80 00 00 	movabs $0x8081e0,%rax
  80254d:	00 00 00 
  802550:	48 8b 00             	mov    (%rax),%rax
  802553:	48 85 c0             	test   %rax,%rax
  802556:	0f 85 84 00 00 00    	jne    8025e0 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  80255c:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  802563:	00 00 00 
  802566:	48 8b 00             	mov    (%rax),%rax
  802569:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80256f:	ba 07 00 00 00       	mov    $0x7,%edx
  802574:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802579:	89 c7                	mov    %eax,%edi
  80257b:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  802582:	00 00 00 
  802585:	ff d0                	callq  *%rax
  802587:	85 c0                	test   %eax,%eax
  802589:	79 2a                	jns    8025b5 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80258b:	48 ba f8 4f 80 00 00 	movabs $0x804ff8,%rdx
  802592:	00 00 00 
  802595:	be 23 00 00 00       	mov    $0x23,%esi
  80259a:	48 bf 1f 50 80 00 00 	movabs $0x80501f,%rdi
  8025a1:	00 00 00 
  8025a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a9:	48 b9 e4 0a 80 00 00 	movabs $0x800ae4,%rcx
  8025b0:	00 00 00 
  8025b3:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  8025b5:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  8025bc:	00 00 00 
  8025bf:	48 8b 00             	mov    (%rax),%rax
  8025c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025c8:	48 be f3 25 80 00 00 	movabs $0x8025f3,%rsi
  8025cf:	00 00 00 
  8025d2:	89 c7                	mov    %eax,%edi
  8025d4:	48 b8 8b 23 80 00 00 	movabs $0x80238b,%rax
  8025db:	00 00 00 
  8025de:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  8025e0:	48 b8 e0 81 80 00 00 	movabs $0x8081e0,%rax
  8025e7:	00 00 00 
  8025ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025ee:	48 89 10             	mov    %rdx,(%rax)
}
  8025f1:	c9                   	leaveq 
  8025f2:	c3                   	retq   

00000000008025f3 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8025f3:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8025f6:	48 a1 e0 81 80 00 00 	movabs 0x8081e0,%rax
  8025fd:	00 00 00 
call *%rax
  802600:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  802602:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802609:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80260a:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  802611:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  802612:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  802616:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  802619:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  802620:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  802621:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  802625:	4c 8b 3c 24          	mov    (%rsp),%r15
  802629:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80262e:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  802633:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802638:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80263d:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802642:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802647:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80264c:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  802651:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802656:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80265b:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  802660:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  802665:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80266a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80266f:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  802673:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  802677:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  802678:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802679:	c3                   	retq   

000000000080267a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80267a:	55                   	push   %rbp
  80267b:	48 89 e5             	mov    %rsp,%rbp
  80267e:	48 83 ec 08          	sub    $0x8,%rsp
  802682:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802686:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80268a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802691:	ff ff ff 
  802694:	48 01 d0             	add    %rdx,%rax
  802697:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80269b:	c9                   	leaveq 
  80269c:	c3                   	retq   

000000000080269d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80269d:	55                   	push   %rbp
  80269e:	48 89 e5             	mov    %rsp,%rbp
  8026a1:	48 83 ec 08          	sub    $0x8,%rsp
  8026a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8026a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026ad:	48 89 c7             	mov    %rax,%rdi
  8026b0:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  8026b7:	00 00 00 
  8026ba:	ff d0                	callq  *%rax
  8026bc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8026c2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8026c6:	c9                   	leaveq 
  8026c7:	c3                   	retq   

00000000008026c8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8026c8:	55                   	push   %rbp
  8026c9:	48 89 e5             	mov    %rsp,%rbp
  8026cc:	48 83 ec 18          	sub    $0x18,%rsp
  8026d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026db:	eb 6b                	jmp    802748 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8026dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e0:	48 98                	cltq   
  8026e2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026e8:	48 c1 e0 0c          	shl    $0xc,%rax
  8026ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8026f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f4:	48 c1 e8 15          	shr    $0x15,%rax
  8026f8:	48 89 c2             	mov    %rax,%rdx
  8026fb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802702:	01 00 00 
  802705:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802709:	83 e0 01             	and    $0x1,%eax
  80270c:	48 85 c0             	test   %rax,%rax
  80270f:	74 21                	je     802732 <fd_alloc+0x6a>
  802711:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802715:	48 c1 e8 0c          	shr    $0xc,%rax
  802719:	48 89 c2             	mov    %rax,%rdx
  80271c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802723:	01 00 00 
  802726:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80272a:	83 e0 01             	and    $0x1,%eax
  80272d:	48 85 c0             	test   %rax,%rax
  802730:	75 12                	jne    802744 <fd_alloc+0x7c>
			*fd_store = fd;
  802732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802736:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80273a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80273d:	b8 00 00 00 00       	mov    $0x0,%eax
  802742:	eb 1a                	jmp    80275e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802744:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802748:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80274c:	7e 8f                	jle    8026dd <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80274e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802752:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802759:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80275e:	c9                   	leaveq 
  80275f:	c3                   	retq   

0000000000802760 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802760:	55                   	push   %rbp
  802761:	48 89 e5             	mov    %rsp,%rbp
  802764:	48 83 ec 20          	sub    $0x20,%rsp
  802768:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80276b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80276f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802773:	78 06                	js     80277b <fd_lookup+0x1b>
  802775:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802779:	7e 07                	jle    802782 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80277b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802780:	eb 6c                	jmp    8027ee <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802782:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802785:	48 98                	cltq   
  802787:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80278d:	48 c1 e0 0c          	shl    $0xc,%rax
  802791:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802795:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802799:	48 c1 e8 15          	shr    $0x15,%rax
  80279d:	48 89 c2             	mov    %rax,%rdx
  8027a0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027a7:	01 00 00 
  8027aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027ae:	83 e0 01             	and    $0x1,%eax
  8027b1:	48 85 c0             	test   %rax,%rax
  8027b4:	74 21                	je     8027d7 <fd_lookup+0x77>
  8027b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ba:	48 c1 e8 0c          	shr    $0xc,%rax
  8027be:	48 89 c2             	mov    %rax,%rdx
  8027c1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027c8:	01 00 00 
  8027cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027cf:	83 e0 01             	and    $0x1,%eax
  8027d2:	48 85 c0             	test   %rax,%rax
  8027d5:	75 07                	jne    8027de <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027dc:	eb 10                	jmp    8027ee <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8027de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027e6:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8027e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ee:	c9                   	leaveq 
  8027ef:	c3                   	retq   

00000000008027f0 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8027f0:	55                   	push   %rbp
  8027f1:	48 89 e5             	mov    %rsp,%rbp
  8027f4:	48 83 ec 30          	sub    $0x30,%rsp
  8027f8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027fc:	89 f0                	mov    %esi,%eax
  8027fe:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802801:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802805:	48 89 c7             	mov    %rax,%rdi
  802808:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  80280f:	00 00 00 
  802812:	ff d0                	callq  *%rax
  802814:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802818:	48 89 d6             	mov    %rdx,%rsi
  80281b:	89 c7                	mov    %eax,%edi
  80281d:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  802824:	00 00 00 
  802827:	ff d0                	callq  *%rax
  802829:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802830:	78 0a                	js     80283c <fd_close+0x4c>
	    || fd != fd2)
  802832:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802836:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80283a:	74 12                	je     80284e <fd_close+0x5e>
		return (must_exist ? r : 0);
  80283c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802840:	74 05                	je     802847 <fd_close+0x57>
  802842:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802845:	eb 05                	jmp    80284c <fd_close+0x5c>
  802847:	b8 00 00 00 00       	mov    $0x0,%eax
  80284c:	eb 69                	jmp    8028b7 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80284e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802852:	8b 00                	mov    (%rax),%eax
  802854:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802858:	48 89 d6             	mov    %rdx,%rsi
  80285b:	89 c7                	mov    %eax,%edi
  80285d:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  802864:	00 00 00 
  802867:	ff d0                	callq  *%rax
  802869:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802870:	78 2a                	js     80289c <fd_close+0xac>
		if (dev->dev_close)
  802872:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802876:	48 8b 40 20          	mov    0x20(%rax),%rax
  80287a:	48 85 c0             	test   %rax,%rax
  80287d:	74 16                	je     802895 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80287f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802883:	48 8b 40 20          	mov    0x20(%rax),%rax
  802887:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80288b:	48 89 d7             	mov    %rdx,%rdi
  80288e:	ff d0                	callq  *%rax
  802890:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802893:	eb 07                	jmp    80289c <fd_close+0xac>
		else
			r = 0;
  802895:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80289c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a0:	48 89 c6             	mov    %rax,%rsi
  8028a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a8:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  8028af:	00 00 00 
  8028b2:	ff d0                	callq  *%rax
	return r;
  8028b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028b7:	c9                   	leaveq 
  8028b8:	c3                   	retq   

00000000008028b9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8028b9:	55                   	push   %rbp
  8028ba:	48 89 e5             	mov    %rsp,%rbp
  8028bd:	48 83 ec 20          	sub    $0x20,%rsp
  8028c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8028c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8028cf:	eb 41                	jmp    802912 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8028d1:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8028d8:	00 00 00 
  8028db:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028de:	48 63 d2             	movslq %edx,%rdx
  8028e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028e5:	8b 00                	mov    (%rax),%eax
  8028e7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8028ea:	75 22                	jne    80290e <dev_lookup+0x55>
			*dev = devtab[i];
  8028ec:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8028f3:	00 00 00 
  8028f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028f9:	48 63 d2             	movslq %edx,%rdx
  8028fc:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802900:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802904:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802907:	b8 00 00 00 00       	mov    $0x0,%eax
  80290c:	eb 60                	jmp    80296e <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80290e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802912:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802919:	00 00 00 
  80291c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80291f:	48 63 d2             	movslq %edx,%rdx
  802922:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802926:	48 85 c0             	test   %rax,%rax
  802929:	75 a6                	jne    8028d1 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80292b:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  802932:	00 00 00 
  802935:	48 8b 00             	mov    (%rax),%rax
  802938:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80293e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802941:	89 c6                	mov    %eax,%esi
  802943:	48 bf 30 50 80 00 00 	movabs $0x805030,%rdi
  80294a:	00 00 00 
  80294d:	b8 00 00 00 00       	mov    $0x0,%eax
  802952:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  802959:	00 00 00 
  80295c:	ff d1                	callq  *%rcx
	*dev = 0;
  80295e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802962:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802969:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80296e:	c9                   	leaveq 
  80296f:	c3                   	retq   

0000000000802970 <close>:

int
close(int fdnum)
{
  802970:	55                   	push   %rbp
  802971:	48 89 e5             	mov    %rsp,%rbp
  802974:	48 83 ec 20          	sub    $0x20,%rsp
  802978:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80297b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80297f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802982:	48 89 d6             	mov    %rdx,%rsi
  802985:	89 c7                	mov    %eax,%edi
  802987:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  80298e:	00 00 00 
  802991:	ff d0                	callq  *%rax
  802993:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802996:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299a:	79 05                	jns    8029a1 <close+0x31>
		return r;
  80299c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299f:	eb 18                	jmp    8029b9 <close+0x49>
	else
		return fd_close(fd, 1);
  8029a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a5:	be 01 00 00 00       	mov    $0x1,%esi
  8029aa:	48 89 c7             	mov    %rax,%rdi
  8029ad:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  8029b4:	00 00 00 
  8029b7:	ff d0                	callq  *%rax
}
  8029b9:	c9                   	leaveq 
  8029ba:	c3                   	retq   

00000000008029bb <close_all>:

void
close_all(void)
{
  8029bb:	55                   	push   %rbp
  8029bc:	48 89 e5             	mov    %rsp,%rbp
  8029bf:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8029c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029ca:	eb 15                	jmp    8029e1 <close_all+0x26>
		close(i);
  8029cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cf:	89 c7                	mov    %eax,%edi
  8029d1:	48 b8 70 29 80 00 00 	movabs $0x802970,%rax
  8029d8:	00 00 00 
  8029db:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8029dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8029e1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8029e5:	7e e5                	jle    8029cc <close_all+0x11>
		close(i);
}
  8029e7:	c9                   	leaveq 
  8029e8:	c3                   	retq   

00000000008029e9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8029e9:	55                   	push   %rbp
  8029ea:	48 89 e5             	mov    %rsp,%rbp
  8029ed:	48 83 ec 40          	sub    $0x40,%rsp
  8029f1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8029f4:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8029f7:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8029fb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8029fe:	48 89 d6             	mov    %rdx,%rsi
  802a01:	89 c7                	mov    %eax,%edi
  802a03:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  802a0a:	00 00 00 
  802a0d:	ff d0                	callq  *%rax
  802a0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a16:	79 08                	jns    802a20 <dup+0x37>
		return r;
  802a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1b:	e9 70 01 00 00       	jmpq   802b90 <dup+0x1a7>
	close(newfdnum);
  802a20:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a23:	89 c7                	mov    %eax,%edi
  802a25:	48 b8 70 29 80 00 00 	movabs $0x802970,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a31:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a34:	48 98                	cltq   
  802a36:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a3c:	48 c1 e0 0c          	shl    $0xc,%rax
  802a40:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a48:	48 89 c7             	mov    %rax,%rdi
  802a4b:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  802a52:	00 00 00 
  802a55:	ff d0                	callq  *%rax
  802a57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802a5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5f:	48 89 c7             	mov    %rax,%rdi
  802a62:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  802a69:	00 00 00 
  802a6c:	ff d0                	callq  *%rax
  802a6e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a76:	48 c1 e8 15          	shr    $0x15,%rax
  802a7a:	48 89 c2             	mov    %rax,%rdx
  802a7d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a84:	01 00 00 
  802a87:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a8b:	83 e0 01             	and    $0x1,%eax
  802a8e:	48 85 c0             	test   %rax,%rax
  802a91:	74 73                	je     802b06 <dup+0x11d>
  802a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a97:	48 c1 e8 0c          	shr    $0xc,%rax
  802a9b:	48 89 c2             	mov    %rax,%rdx
  802a9e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802aa5:	01 00 00 
  802aa8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aac:	83 e0 01             	and    $0x1,%eax
  802aaf:	48 85 c0             	test   %rax,%rax
  802ab2:	74 52                	je     802b06 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab8:	48 c1 e8 0c          	shr    $0xc,%rax
  802abc:	48 89 c2             	mov    %rax,%rdx
  802abf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ac6:	01 00 00 
  802ac9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802acd:	25 07 0e 00 00       	and    $0xe07,%eax
  802ad2:	89 c1                	mov    %eax,%ecx
  802ad4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ad8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802adc:	41 89 c8             	mov    %ecx,%r8d
  802adf:	48 89 d1             	mov    %rdx,%rcx
  802ae2:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae7:	48 89 c6             	mov    %rax,%rsi
  802aea:	bf 00 00 00 00       	mov    $0x0,%edi
  802aef:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax
  802afb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802afe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b02:	79 02                	jns    802b06 <dup+0x11d>
			goto err;
  802b04:	eb 57                	jmp    802b5d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b0a:	48 c1 e8 0c          	shr    $0xc,%rax
  802b0e:	48 89 c2             	mov    %rax,%rdx
  802b11:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b18:	01 00 00 
  802b1b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b1f:	25 07 0e 00 00       	and    $0xe07,%eax
  802b24:	89 c1                	mov    %eax,%ecx
  802b26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b2e:	41 89 c8             	mov    %ecx,%r8d
  802b31:	48 89 d1             	mov    %rdx,%rcx
  802b34:	ba 00 00 00 00       	mov    $0x0,%edx
  802b39:	48 89 c6             	mov    %rax,%rsi
  802b3c:	bf 00 00 00 00       	mov    $0x0,%edi
  802b41:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  802b48:	00 00 00 
  802b4b:	ff d0                	callq  *%rax
  802b4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b54:	79 02                	jns    802b58 <dup+0x16f>
		goto err;
  802b56:	eb 05                	jmp    802b5d <dup+0x174>

	return newfdnum;
  802b58:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b5b:	eb 33                	jmp    802b90 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802b5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b61:	48 89 c6             	mov    %rax,%rsi
  802b64:	bf 00 00 00 00       	mov    $0x0,%edi
  802b69:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  802b70:	00 00 00 
  802b73:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802b75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b79:	48 89 c6             	mov    %rax,%rsi
  802b7c:	bf 00 00 00 00       	mov    $0x0,%edi
  802b81:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  802b88:	00 00 00 
  802b8b:	ff d0                	callq  *%rax
	return r;
  802b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b90:	c9                   	leaveq 
  802b91:	c3                   	retq   

0000000000802b92 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802b92:	55                   	push   %rbp
  802b93:	48 89 e5             	mov    %rsp,%rbp
  802b96:	48 83 ec 40          	sub    $0x40,%rsp
  802b9a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b9d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ba1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ba5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ba9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bac:	48 89 d6             	mov    %rdx,%rsi
  802baf:	89 c7                	mov    %eax,%edi
  802bb1:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  802bb8:	00 00 00 
  802bbb:	ff d0                	callq  *%rax
  802bbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc4:	78 24                	js     802bea <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bca:	8b 00                	mov    (%rax),%eax
  802bcc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bd0:	48 89 d6             	mov    %rdx,%rsi
  802bd3:	89 c7                	mov    %eax,%edi
  802bd5:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  802bdc:	00 00 00 
  802bdf:	ff d0                	callq  *%rax
  802be1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be8:	79 05                	jns    802bef <read+0x5d>
		return r;
  802bea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bed:	eb 76                	jmp    802c65 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802bef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf3:	8b 40 08             	mov    0x8(%rax),%eax
  802bf6:	83 e0 03             	and    $0x3,%eax
  802bf9:	83 f8 01             	cmp    $0x1,%eax
  802bfc:	75 3a                	jne    802c38 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802bfe:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  802c05:	00 00 00 
  802c08:	48 8b 00             	mov    (%rax),%rax
  802c0b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c11:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c14:	89 c6                	mov    %eax,%esi
  802c16:	48 bf 4f 50 80 00 00 	movabs $0x80504f,%rdi
  802c1d:	00 00 00 
  802c20:	b8 00 00 00 00       	mov    $0x0,%eax
  802c25:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  802c2c:	00 00 00 
  802c2f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c36:	eb 2d                	jmp    802c65 <read+0xd3>
	}
	if (!dev->dev_read)
  802c38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c40:	48 85 c0             	test   %rax,%rax
  802c43:	75 07                	jne    802c4c <read+0xba>
		return -E_NOT_SUPP;
  802c45:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c4a:	eb 19                	jmp    802c65 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c50:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c54:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c58:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c5c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c60:	48 89 cf             	mov    %rcx,%rdi
  802c63:	ff d0                	callq  *%rax
}
  802c65:	c9                   	leaveq 
  802c66:	c3                   	retq   

0000000000802c67 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c67:	55                   	push   %rbp
  802c68:	48 89 e5             	mov    %rsp,%rbp
  802c6b:	48 83 ec 30          	sub    $0x30,%rsp
  802c6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c76:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c81:	eb 49                	jmp    802ccc <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c86:	48 98                	cltq   
  802c88:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c8c:	48 29 c2             	sub    %rax,%rdx
  802c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c92:	48 63 c8             	movslq %eax,%rcx
  802c95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c99:	48 01 c1             	add    %rax,%rcx
  802c9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c9f:	48 89 ce             	mov    %rcx,%rsi
  802ca2:	89 c7                	mov    %eax,%edi
  802ca4:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  802cab:	00 00 00 
  802cae:	ff d0                	callq  *%rax
  802cb0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802cb3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cb7:	79 05                	jns    802cbe <readn+0x57>
			return m;
  802cb9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cbc:	eb 1c                	jmp    802cda <readn+0x73>
		if (m == 0)
  802cbe:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802cc2:	75 02                	jne    802cc6 <readn+0x5f>
			break;
  802cc4:	eb 11                	jmp    802cd7 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cc9:	01 45 fc             	add    %eax,-0x4(%rbp)
  802ccc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccf:	48 98                	cltq   
  802cd1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802cd5:	72 ac                	jb     802c83 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802cd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cda:	c9                   	leaveq 
  802cdb:	c3                   	retq   

0000000000802cdc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802cdc:	55                   	push   %rbp
  802cdd:	48 89 e5             	mov    %rsp,%rbp
  802ce0:	48 83 ec 40          	sub    $0x40,%rsp
  802ce4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ce7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ceb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cf3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cf6:	48 89 d6             	mov    %rdx,%rsi
  802cf9:	89 c7                	mov    %eax,%edi
  802cfb:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  802d02:	00 00 00 
  802d05:	ff d0                	callq  *%rax
  802d07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0e:	78 24                	js     802d34 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d14:	8b 00                	mov    (%rax),%eax
  802d16:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d1a:	48 89 d6             	mov    %rdx,%rsi
  802d1d:	89 c7                	mov    %eax,%edi
  802d1f:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  802d26:	00 00 00 
  802d29:	ff d0                	callq  *%rax
  802d2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d32:	79 05                	jns    802d39 <write+0x5d>
		return r;
  802d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d37:	eb 75                	jmp    802dae <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3d:	8b 40 08             	mov    0x8(%rax),%eax
  802d40:	83 e0 03             	and    $0x3,%eax
  802d43:	85 c0                	test   %eax,%eax
  802d45:	75 3a                	jne    802d81 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d47:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  802d4e:	00 00 00 
  802d51:	48 8b 00             	mov    (%rax),%rax
  802d54:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d5a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d5d:	89 c6                	mov    %eax,%esi
  802d5f:	48 bf 6b 50 80 00 00 	movabs $0x80506b,%rdi
  802d66:	00 00 00 
  802d69:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6e:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  802d75:	00 00 00 
  802d78:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d7f:	eb 2d                	jmp    802dae <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d85:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d89:	48 85 c0             	test   %rax,%rax
  802d8c:	75 07                	jne    802d95 <write+0xb9>
		return -E_NOT_SUPP;
  802d8e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d93:	eb 19                	jmp    802dae <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802d95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d99:	48 8b 40 18          	mov    0x18(%rax),%rax
  802d9d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802da1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802da5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802da9:	48 89 cf             	mov    %rcx,%rdi
  802dac:	ff d0                	callq  *%rax
}
  802dae:	c9                   	leaveq 
  802daf:	c3                   	retq   

0000000000802db0 <seek>:

int
seek(int fdnum, off_t offset)
{
  802db0:	55                   	push   %rbp
  802db1:	48 89 e5             	mov    %rsp,%rbp
  802db4:	48 83 ec 18          	sub    $0x18,%rsp
  802db8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dbb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802dbe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dc2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dc5:	48 89 d6             	mov    %rdx,%rsi
  802dc8:	89 c7                	mov    %eax,%edi
  802dca:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  802dd1:	00 00 00 
  802dd4:	ff d0                	callq  *%rax
  802dd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ddd:	79 05                	jns    802de4 <seek+0x34>
		return r;
  802ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de2:	eb 0f                	jmp    802df3 <seek+0x43>
	fd->fd_offset = offset;
  802de4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802deb:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df3:	c9                   	leaveq 
  802df4:	c3                   	retq   

0000000000802df5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802df5:	55                   	push   %rbp
  802df6:	48 89 e5             	mov    %rsp,%rbp
  802df9:	48 83 ec 30          	sub    $0x30,%rsp
  802dfd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e00:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e03:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e07:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e0a:	48 89 d6             	mov    %rdx,%rsi
  802e0d:	89 c7                	mov    %eax,%edi
  802e0f:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  802e16:	00 00 00 
  802e19:	ff d0                	callq  *%rax
  802e1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e22:	78 24                	js     802e48 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e28:	8b 00                	mov    (%rax),%eax
  802e2a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e2e:	48 89 d6             	mov    %rdx,%rsi
  802e31:	89 c7                	mov    %eax,%edi
  802e33:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  802e3a:	00 00 00 
  802e3d:	ff d0                	callq  *%rax
  802e3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e46:	79 05                	jns    802e4d <ftruncate+0x58>
		return r;
  802e48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4b:	eb 72                	jmp    802ebf <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e51:	8b 40 08             	mov    0x8(%rax),%eax
  802e54:	83 e0 03             	and    $0x3,%eax
  802e57:	85 c0                	test   %eax,%eax
  802e59:	75 3a                	jne    802e95 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802e5b:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  802e62:	00 00 00 
  802e65:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e68:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e6e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e71:	89 c6                	mov    %eax,%esi
  802e73:	48 bf 88 50 80 00 00 	movabs $0x805088,%rdi
  802e7a:	00 00 00 
  802e7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e82:	48 b9 1d 0d 80 00 00 	movabs $0x800d1d,%rcx
  802e89:	00 00 00 
  802e8c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802e8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e93:	eb 2a                	jmp    802ebf <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802e95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e99:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e9d:	48 85 c0             	test   %rax,%rax
  802ea0:	75 07                	jne    802ea9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802ea2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ea7:	eb 16                	jmp    802ebf <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ea9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ead:	48 8b 40 30          	mov    0x30(%rax),%rax
  802eb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802eb5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802eb8:	89 ce                	mov    %ecx,%esi
  802eba:	48 89 d7             	mov    %rdx,%rdi
  802ebd:	ff d0                	callq  *%rax
}
  802ebf:	c9                   	leaveq 
  802ec0:	c3                   	retq   

0000000000802ec1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ec1:	55                   	push   %rbp
  802ec2:	48 89 e5             	mov    %rsp,%rbp
  802ec5:	48 83 ec 30          	sub    $0x30,%rsp
  802ec9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ecc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ed0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ed4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ed7:	48 89 d6             	mov    %rdx,%rsi
  802eda:	89 c7                	mov    %eax,%edi
  802edc:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  802ee3:	00 00 00 
  802ee6:	ff d0                	callq  *%rax
  802ee8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eeb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eef:	78 24                	js     802f15 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef5:	8b 00                	mov    (%rax),%eax
  802ef7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802efb:	48 89 d6             	mov    %rdx,%rsi
  802efe:	89 c7                	mov    %eax,%edi
  802f00:	48 b8 b9 28 80 00 00 	movabs $0x8028b9,%rax
  802f07:	00 00 00 
  802f0a:	ff d0                	callq  *%rax
  802f0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f13:	79 05                	jns    802f1a <fstat+0x59>
		return r;
  802f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f18:	eb 5e                	jmp    802f78 <fstat+0xb7>
	if (!dev->dev_stat)
  802f1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f22:	48 85 c0             	test   %rax,%rax
  802f25:	75 07                	jne    802f2e <fstat+0x6d>
		return -E_NOT_SUPP;
  802f27:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f2c:	eb 4a                	jmp    802f78 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f2e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f32:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f39:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f40:	00 00 00 
	stat->st_isdir = 0;
  802f43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f47:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f4e:	00 00 00 
	stat->st_dev = dev;
  802f51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f55:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f59:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802f60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f64:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f6c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802f70:	48 89 ce             	mov    %rcx,%rsi
  802f73:	48 89 d7             	mov    %rdx,%rdi
  802f76:	ff d0                	callq  *%rax
}
  802f78:	c9                   	leaveq 
  802f79:	c3                   	retq   

0000000000802f7a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f7a:	55                   	push   %rbp
  802f7b:	48 89 e5             	mov    %rsp,%rbp
  802f7e:	48 83 ec 20          	sub    $0x20,%rsp
  802f82:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f86:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8e:	be 00 00 00 00       	mov    $0x0,%esi
  802f93:	48 89 c7             	mov    %rax,%rdi
  802f96:	48 b8 68 30 80 00 00 	movabs $0x803068,%rax
  802f9d:	00 00 00 
  802fa0:	ff d0                	callq  *%rax
  802fa2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa9:	79 05                	jns    802fb0 <stat+0x36>
		return fd;
  802fab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fae:	eb 2f                	jmp    802fdf <stat+0x65>
	r = fstat(fd, stat);
  802fb0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802fb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb7:	48 89 d6             	mov    %rdx,%rsi
  802fba:	89 c7                	mov    %eax,%edi
  802fbc:	48 b8 c1 2e 80 00 00 	movabs $0x802ec1,%rax
  802fc3:	00 00 00 
  802fc6:	ff d0                	callq  *%rax
  802fc8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802fcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fce:	89 c7                	mov    %eax,%edi
  802fd0:	48 b8 70 29 80 00 00 	movabs $0x802970,%rax
  802fd7:	00 00 00 
  802fda:	ff d0                	callq  *%rax
	return r;
  802fdc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802fdf:	c9                   	leaveq 
  802fe0:	c3                   	retq   

0000000000802fe1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802fe1:	55                   	push   %rbp
  802fe2:	48 89 e5             	mov    %rsp,%rbp
  802fe5:	48 83 ec 10          	sub    $0x10,%rsp
  802fe9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802ff0:	48 b8 d0 81 80 00 00 	movabs $0x8081d0,%rax
  802ff7:	00 00 00 
  802ffa:	8b 00                	mov    (%rax),%eax
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	75 1d                	jne    80301d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803000:	bf 01 00 00 00       	mov    $0x1,%edi
  803005:	48 b8 6e 48 80 00 00 	movabs $0x80486e,%rax
  80300c:	00 00 00 
  80300f:	ff d0                	callq  *%rax
  803011:	48 ba d0 81 80 00 00 	movabs $0x8081d0,%rdx
  803018:	00 00 00 
  80301b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80301d:	48 b8 d0 81 80 00 00 	movabs $0x8081d0,%rax
  803024:	00 00 00 
  803027:	8b 00                	mov    (%rax),%eax
  803029:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80302c:	b9 07 00 00 00       	mov    $0x7,%ecx
  803031:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803038:	00 00 00 
  80303b:	89 c7                	mov    %eax,%edi
  80303d:	48 b8 0c 48 80 00 00 	movabs $0x80480c,%rax
  803044:	00 00 00 
  803047:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803049:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304d:	ba 00 00 00 00       	mov    $0x0,%edx
  803052:	48 89 c6             	mov    %rax,%rsi
  803055:	bf 00 00 00 00       	mov    $0x0,%edi
  80305a:	48 b8 06 47 80 00 00 	movabs $0x804706,%rax
  803061:	00 00 00 
  803064:	ff d0                	callq  *%rax
}
  803066:	c9                   	leaveq 
  803067:	c3                   	retq   

0000000000803068 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803068:	55                   	push   %rbp
  803069:	48 89 e5             	mov    %rsp,%rbp
  80306c:	48 83 ec 30          	sub    $0x30,%rsp
  803070:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803074:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  803077:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  80307e:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  803085:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  80308c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803091:	75 08                	jne    80309b <open+0x33>
	{
		return r;
  803093:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803096:	e9 f2 00 00 00       	jmpq   80318d <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  80309b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80309f:	48 89 c7             	mov    %rax,%rdi
  8030a2:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  8030a9:	00 00 00 
  8030ac:	ff d0                	callq  *%rax
  8030ae:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8030b1:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8030b8:	7e 0a                	jle    8030c4 <open+0x5c>
	{
		return -E_BAD_PATH;
  8030ba:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030bf:	e9 c9 00 00 00       	jmpq   80318d <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8030c4:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8030cb:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8030cc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8030d0:	48 89 c7             	mov    %rax,%rdi
  8030d3:	48 b8 c8 26 80 00 00 	movabs $0x8026c8,%rax
  8030da:	00 00 00 
  8030dd:	ff d0                	callq  *%rax
  8030df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e6:	78 09                	js     8030f1 <open+0x89>
  8030e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ec:	48 85 c0             	test   %rax,%rax
  8030ef:	75 08                	jne    8030f9 <open+0x91>
		{
			return r;
  8030f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f4:	e9 94 00 00 00       	jmpq   80318d <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8030f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030fd:	ba 00 04 00 00       	mov    $0x400,%edx
  803102:	48 89 c6             	mov    %rax,%rsi
  803105:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80310c:	00 00 00 
  80310f:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  803116:	00 00 00 
  803119:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  80311b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803122:	00 00 00 
  803125:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  803128:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  80312e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803132:	48 89 c6             	mov    %rax,%rsi
  803135:	bf 01 00 00 00       	mov    $0x1,%edi
  80313a:	48 b8 e1 2f 80 00 00 	movabs $0x802fe1,%rax
  803141:	00 00 00 
  803144:	ff d0                	callq  *%rax
  803146:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803149:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314d:	79 2b                	jns    80317a <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  80314f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803153:	be 00 00 00 00       	mov    $0x0,%esi
  803158:	48 89 c7             	mov    %rax,%rdi
  80315b:	48 b8 f0 27 80 00 00 	movabs $0x8027f0,%rax
  803162:	00 00 00 
  803165:	ff d0                	callq  *%rax
  803167:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80316a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80316e:	79 05                	jns    803175 <open+0x10d>
			{
				return d;
  803170:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803173:	eb 18                	jmp    80318d <open+0x125>
			}
			return r;
  803175:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803178:	eb 13                	jmp    80318d <open+0x125>
		}	
		return fd2num(fd_store);
  80317a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80317e:	48 89 c7             	mov    %rax,%rdi
  803181:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  803188:	00 00 00 
  80318b:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80318d:	c9                   	leaveq 
  80318e:	c3                   	retq   

000000000080318f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80318f:	55                   	push   %rbp
  803190:	48 89 e5             	mov    %rsp,%rbp
  803193:	48 83 ec 10          	sub    $0x10,%rsp
  803197:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80319b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80319f:	8b 50 0c             	mov    0xc(%rax),%edx
  8031a2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031a9:	00 00 00 
  8031ac:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031ae:	be 00 00 00 00       	mov    $0x0,%esi
  8031b3:	bf 06 00 00 00       	mov    $0x6,%edi
  8031b8:	48 b8 e1 2f 80 00 00 	movabs $0x802fe1,%rax
  8031bf:	00 00 00 
  8031c2:	ff d0                	callq  *%rax
}
  8031c4:	c9                   	leaveq 
  8031c5:	c3                   	retq   

00000000008031c6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031c6:	55                   	push   %rbp
  8031c7:	48 89 e5             	mov    %rsp,%rbp
  8031ca:	48 83 ec 30          	sub    $0x30,%rsp
  8031ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8031da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8031e1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8031e6:	74 07                	je     8031ef <devfile_read+0x29>
  8031e8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8031ed:	75 07                	jne    8031f6 <devfile_read+0x30>
		return -E_INVAL;
  8031ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031f4:	eb 77                	jmp    80326d <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8031f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031fa:	8b 50 0c             	mov    0xc(%rax),%edx
  8031fd:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803204:	00 00 00 
  803207:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803209:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803210:	00 00 00 
  803213:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803217:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  80321b:	be 00 00 00 00       	mov    $0x0,%esi
  803220:	bf 03 00 00 00       	mov    $0x3,%edi
  803225:	48 b8 e1 2f 80 00 00 	movabs $0x802fe1,%rax
  80322c:	00 00 00 
  80322f:	ff d0                	callq  *%rax
  803231:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803234:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803238:	7f 05                	jg     80323f <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80323a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80323d:	eb 2e                	jmp    80326d <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  80323f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803242:	48 63 d0             	movslq %eax,%rdx
  803245:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803249:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803250:	00 00 00 
  803253:	48 89 c7             	mov    %rax,%rdi
  803256:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803262:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803266:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80326a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80326d:	c9                   	leaveq 
  80326e:	c3                   	retq   

000000000080326f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80326f:	55                   	push   %rbp
  803270:	48 89 e5             	mov    %rsp,%rbp
  803273:	48 83 ec 30          	sub    $0x30,%rsp
  803277:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80327b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80327f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803283:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80328a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80328f:	74 07                	je     803298 <devfile_write+0x29>
  803291:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803296:	75 08                	jne    8032a0 <devfile_write+0x31>
		return r;
  803298:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329b:	e9 9a 00 00 00       	jmpq   80333a <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8032a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032a4:	8b 50 0c             	mov    0xc(%rax),%edx
  8032a7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032ae:	00 00 00 
  8032b1:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8032b3:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8032ba:	00 
  8032bb:	76 08                	jbe    8032c5 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8032bd:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8032c4:	00 
	}
	fsipcbuf.write.req_n = n;
  8032c5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032cc:	00 00 00 
  8032cf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032d3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  8032d7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032df:	48 89 c6             	mov    %rax,%rsi
  8032e2:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  8032e9:	00 00 00 
  8032ec:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  8032f3:	00 00 00 
  8032f6:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  8032f8:	be 00 00 00 00       	mov    $0x0,%esi
  8032fd:	bf 04 00 00 00       	mov    $0x4,%edi
  803302:	48 b8 e1 2f 80 00 00 	movabs $0x802fe1,%rax
  803309:	00 00 00 
  80330c:	ff d0                	callq  *%rax
  80330e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803311:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803315:	7f 20                	jg     803337 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803317:	48 bf ae 50 80 00 00 	movabs $0x8050ae,%rdi
  80331e:	00 00 00 
  803321:	b8 00 00 00 00       	mov    $0x0,%eax
  803326:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  80332d:	00 00 00 
  803330:	ff d2                	callq  *%rdx
		return r;
  803332:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803335:	eb 03                	jmp    80333a <devfile_write+0xcb>
	}
	return r;
  803337:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80333a:	c9                   	leaveq 
  80333b:	c3                   	retq   

000000000080333c <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80333c:	55                   	push   %rbp
  80333d:	48 89 e5             	mov    %rsp,%rbp
  803340:	48 83 ec 20          	sub    $0x20,%rsp
  803344:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803348:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80334c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803350:	8b 50 0c             	mov    0xc(%rax),%edx
  803353:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80335a:	00 00 00 
  80335d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80335f:	be 00 00 00 00       	mov    $0x0,%esi
  803364:	bf 05 00 00 00       	mov    $0x5,%edi
  803369:	48 b8 e1 2f 80 00 00 	movabs $0x802fe1,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
  803375:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803378:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337c:	79 05                	jns    803383 <devfile_stat+0x47>
		return r;
  80337e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803381:	eb 56                	jmp    8033d9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803383:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803387:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80338e:	00 00 00 
  803391:	48 89 c7             	mov    %rax,%rdi
  803394:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  80339b:	00 00 00 
  80339e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8033a0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033a7:	00 00 00 
  8033aa:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8033b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8033ba:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033c1:	00 00 00 
  8033c4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8033ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033ce:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8033d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d9:	c9                   	leaveq 
  8033da:	c3                   	retq   

00000000008033db <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8033db:	55                   	push   %rbp
  8033dc:	48 89 e5             	mov    %rsp,%rbp
  8033df:	48 83 ec 10          	sub    $0x10,%rsp
  8033e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033e7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033ee:	8b 50 0c             	mov    0xc(%rax),%edx
  8033f1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033f8:	00 00 00 
  8033fb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8033fd:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803404:	00 00 00 
  803407:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80340a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80340d:	be 00 00 00 00       	mov    $0x0,%esi
  803412:	bf 02 00 00 00       	mov    $0x2,%edi
  803417:	48 b8 e1 2f 80 00 00 	movabs $0x802fe1,%rax
  80341e:	00 00 00 
  803421:	ff d0                	callq  *%rax
}
  803423:	c9                   	leaveq 
  803424:	c3                   	retq   

0000000000803425 <remove>:

// Delete a file
int
remove(const char *path)
{
  803425:	55                   	push   %rbp
  803426:	48 89 e5             	mov    %rsp,%rbp
  803429:	48 83 ec 10          	sub    $0x10,%rsp
  80342d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803435:	48 89 c7             	mov    %rax,%rdi
  803438:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  80343f:	00 00 00 
  803442:	ff d0                	callq  *%rax
  803444:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803449:	7e 07                	jle    803452 <remove+0x2d>
		return -E_BAD_PATH;
  80344b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803450:	eb 33                	jmp    803485 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803452:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803456:	48 89 c6             	mov    %rax,%rsi
  803459:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803460:	00 00 00 
  803463:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  80346a:	00 00 00 
  80346d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80346f:	be 00 00 00 00       	mov    $0x0,%esi
  803474:	bf 07 00 00 00       	mov    $0x7,%edi
  803479:	48 b8 e1 2f 80 00 00 	movabs $0x802fe1,%rax
  803480:	00 00 00 
  803483:	ff d0                	callq  *%rax
}
  803485:	c9                   	leaveq 
  803486:	c3                   	retq   

0000000000803487 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803487:	55                   	push   %rbp
  803488:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80348b:	be 00 00 00 00       	mov    $0x0,%esi
  803490:	bf 08 00 00 00       	mov    $0x8,%edi
  803495:	48 b8 e1 2f 80 00 00 	movabs $0x802fe1,%rax
  80349c:	00 00 00 
  80349f:	ff d0                	callq  *%rax
}
  8034a1:	5d                   	pop    %rbp
  8034a2:	c3                   	retq   

00000000008034a3 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8034a3:	55                   	push   %rbp
  8034a4:	48 89 e5             	mov    %rsp,%rbp
  8034a7:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8034ae:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8034b5:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8034bc:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8034c3:	be 00 00 00 00       	mov    $0x0,%esi
  8034c8:	48 89 c7             	mov    %rax,%rdi
  8034cb:	48 b8 68 30 80 00 00 	movabs $0x803068,%rax
  8034d2:	00 00 00 
  8034d5:	ff d0                	callq  *%rax
  8034d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8034da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034de:	79 28                	jns    803508 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8034e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e3:	89 c6                	mov    %eax,%esi
  8034e5:	48 bf ca 50 80 00 00 	movabs $0x8050ca,%rdi
  8034ec:	00 00 00 
  8034ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f4:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8034fb:	00 00 00 
  8034fe:	ff d2                	callq  *%rdx
		return fd_src;
  803500:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803503:	e9 74 01 00 00       	jmpq   80367c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803508:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80350f:	be 01 01 00 00       	mov    $0x101,%esi
  803514:	48 89 c7             	mov    %rax,%rdi
  803517:	48 b8 68 30 80 00 00 	movabs $0x803068,%rax
  80351e:	00 00 00 
  803521:	ff d0                	callq  *%rax
  803523:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803526:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80352a:	79 39                	jns    803565 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80352c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80352f:	89 c6                	mov    %eax,%esi
  803531:	48 bf e0 50 80 00 00 	movabs $0x8050e0,%rdi
  803538:	00 00 00 
  80353b:	b8 00 00 00 00       	mov    $0x0,%eax
  803540:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  803547:	00 00 00 
  80354a:	ff d2                	callq  *%rdx
		close(fd_src);
  80354c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354f:	89 c7                	mov    %eax,%edi
  803551:	48 b8 70 29 80 00 00 	movabs $0x802970,%rax
  803558:	00 00 00 
  80355b:	ff d0                	callq  *%rax
		return fd_dest;
  80355d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803560:	e9 17 01 00 00       	jmpq   80367c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803565:	eb 74                	jmp    8035db <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803567:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80356a:	48 63 d0             	movslq %eax,%rdx
  80356d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803574:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803577:	48 89 ce             	mov    %rcx,%rsi
  80357a:	89 c7                	mov    %eax,%edi
  80357c:	48 b8 dc 2c 80 00 00 	movabs $0x802cdc,%rax
  803583:	00 00 00 
  803586:	ff d0                	callq  *%rax
  803588:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80358b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80358f:	79 4a                	jns    8035db <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803591:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803594:	89 c6                	mov    %eax,%esi
  803596:	48 bf fa 50 80 00 00 	movabs $0x8050fa,%rdi
  80359d:	00 00 00 
  8035a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a5:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  8035ac:	00 00 00 
  8035af:	ff d2                	callq  *%rdx
			close(fd_src);
  8035b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b4:	89 c7                	mov    %eax,%edi
  8035b6:	48 b8 70 29 80 00 00 	movabs $0x802970,%rax
  8035bd:	00 00 00 
  8035c0:	ff d0                	callq  *%rax
			close(fd_dest);
  8035c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035c5:	89 c7                	mov    %eax,%edi
  8035c7:	48 b8 70 29 80 00 00 	movabs $0x802970,%rax
  8035ce:	00 00 00 
  8035d1:	ff d0                	callq  *%rax
			return write_size;
  8035d3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035d6:	e9 a1 00 00 00       	jmpq   80367c <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8035db:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e5:	ba 00 02 00 00       	mov    $0x200,%edx
  8035ea:	48 89 ce             	mov    %rcx,%rsi
  8035ed:	89 c7                	mov    %eax,%edi
  8035ef:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  8035f6:	00 00 00 
  8035f9:	ff d0                	callq  *%rax
  8035fb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8035fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803602:	0f 8f 5f ff ff ff    	jg     803567 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803608:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80360c:	79 47                	jns    803655 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80360e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803611:	89 c6                	mov    %eax,%esi
  803613:	48 bf 0d 51 80 00 00 	movabs $0x80510d,%rdi
  80361a:	00 00 00 
  80361d:	b8 00 00 00 00       	mov    $0x0,%eax
  803622:	48 ba 1d 0d 80 00 00 	movabs $0x800d1d,%rdx
  803629:	00 00 00 
  80362c:	ff d2                	callq  *%rdx
		close(fd_src);
  80362e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803631:	89 c7                	mov    %eax,%edi
  803633:	48 b8 70 29 80 00 00 	movabs $0x802970,%rax
  80363a:	00 00 00 
  80363d:	ff d0                	callq  *%rax
		close(fd_dest);
  80363f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803642:	89 c7                	mov    %eax,%edi
  803644:	48 b8 70 29 80 00 00 	movabs $0x802970,%rax
  80364b:	00 00 00 
  80364e:	ff d0                	callq  *%rax
		return read_size;
  803650:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803653:	eb 27                	jmp    80367c <copy+0x1d9>
	}
	close(fd_src);
  803655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803658:	89 c7                	mov    %eax,%edi
  80365a:	48 b8 70 29 80 00 00 	movabs $0x802970,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
	close(fd_dest);
  803666:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803669:	89 c7                	mov    %eax,%edi
  80366b:	48 b8 70 29 80 00 00 	movabs $0x802970,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
	return 0;
  803677:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80367c:	c9                   	leaveq 
  80367d:	c3                   	retq   

000000000080367e <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80367e:	55                   	push   %rbp
  80367f:	48 89 e5             	mov    %rsp,%rbp
  803682:	48 83 ec 20          	sub    $0x20,%rsp
  803686:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803689:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80368d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803690:	48 89 d6             	mov    %rdx,%rsi
  803693:	89 c7                	mov    %eax,%edi
  803695:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  80369c:	00 00 00 
  80369f:	ff d0                	callq  *%rax
  8036a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a8:	79 05                	jns    8036af <fd2sockid+0x31>
		return r;
  8036aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ad:	eb 24                	jmp    8036d3 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8036af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b3:	8b 10                	mov    (%rax),%edx
  8036b5:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8036bc:	00 00 00 
  8036bf:	8b 00                	mov    (%rax),%eax
  8036c1:	39 c2                	cmp    %eax,%edx
  8036c3:	74 07                	je     8036cc <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8036c5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8036ca:	eb 07                	jmp    8036d3 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8036cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d0:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8036d3:	c9                   	leaveq 
  8036d4:	c3                   	retq   

00000000008036d5 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8036d5:	55                   	push   %rbp
  8036d6:	48 89 e5             	mov    %rsp,%rbp
  8036d9:	48 83 ec 20          	sub    $0x20,%rsp
  8036dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8036e0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036e4:	48 89 c7             	mov    %rax,%rdi
  8036e7:	48 b8 c8 26 80 00 00 	movabs $0x8026c8,%rax
  8036ee:	00 00 00 
  8036f1:	ff d0                	callq  *%rax
  8036f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036fa:	78 26                	js     803722 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8036fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803700:	ba 07 04 00 00       	mov    $0x407,%edx
  803705:	48 89 c6             	mov    %rax,%rsi
  803708:	bf 00 00 00 00       	mov    $0x0,%edi
  80370d:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  803714:	00 00 00 
  803717:	ff d0                	callq  *%rax
  803719:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80371c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803720:	79 16                	jns    803738 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803722:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803725:	89 c7                	mov    %eax,%edi
  803727:	48 b8 e2 3b 80 00 00 	movabs $0x803be2,%rax
  80372e:	00 00 00 
  803731:	ff d0                	callq  *%rax
		return r;
  803733:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803736:	eb 3a                	jmp    803772 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803738:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373c:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803743:	00 00 00 
  803746:	8b 12                	mov    (%rdx),%edx
  803748:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80374a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803759:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80375c:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80375f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803763:	48 89 c7             	mov    %rax,%rdi
  803766:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  80376d:	00 00 00 
  803770:	ff d0                	callq  *%rax
}
  803772:	c9                   	leaveq 
  803773:	c3                   	retq   

0000000000803774 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803774:	55                   	push   %rbp
  803775:	48 89 e5             	mov    %rsp,%rbp
  803778:	48 83 ec 30          	sub    $0x30,%rsp
  80377c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80377f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803783:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803787:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80378a:	89 c7                	mov    %eax,%edi
  80378c:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  803793:	00 00 00 
  803796:	ff d0                	callq  *%rax
  803798:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80379b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379f:	79 05                	jns    8037a6 <accept+0x32>
		return r;
  8037a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a4:	eb 3b                	jmp    8037e1 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8037a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8037aa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b1:	48 89 ce             	mov    %rcx,%rsi
  8037b4:	89 c7                	mov    %eax,%edi
  8037b6:	48 b8 bf 3a 80 00 00 	movabs $0x803abf,%rax
  8037bd:	00 00 00 
  8037c0:	ff d0                	callq  *%rax
  8037c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c9:	79 05                	jns    8037d0 <accept+0x5c>
		return r;
  8037cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ce:	eb 11                	jmp    8037e1 <accept+0x6d>
	return alloc_sockfd(r);
  8037d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d3:	89 c7                	mov    %eax,%edi
  8037d5:	48 b8 d5 36 80 00 00 	movabs $0x8036d5,%rax
  8037dc:	00 00 00 
  8037df:	ff d0                	callq  *%rax
}
  8037e1:	c9                   	leaveq 
  8037e2:	c3                   	retq   

00000000008037e3 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037e3:	55                   	push   %rbp
  8037e4:	48 89 e5             	mov    %rsp,%rbp
  8037e7:	48 83 ec 20          	sub    $0x20,%rsp
  8037eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037f2:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037f8:	89 c7                	mov    %eax,%edi
  8037fa:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  803801:	00 00 00 
  803804:	ff d0                	callq  *%rax
  803806:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803809:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80380d:	79 05                	jns    803814 <bind+0x31>
		return r;
  80380f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803812:	eb 1b                	jmp    80382f <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803814:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803817:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80381b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381e:	48 89 ce             	mov    %rcx,%rsi
  803821:	89 c7                	mov    %eax,%edi
  803823:	48 b8 3e 3b 80 00 00 	movabs $0x803b3e,%rax
  80382a:	00 00 00 
  80382d:	ff d0                	callq  *%rax
}
  80382f:	c9                   	leaveq 
  803830:	c3                   	retq   

0000000000803831 <shutdown>:

int
shutdown(int s, int how)
{
  803831:	55                   	push   %rbp
  803832:	48 89 e5             	mov    %rsp,%rbp
  803835:	48 83 ec 20          	sub    $0x20,%rsp
  803839:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80383c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80383f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803842:	89 c7                	mov    %eax,%edi
  803844:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  80384b:	00 00 00 
  80384e:	ff d0                	callq  *%rax
  803850:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803853:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803857:	79 05                	jns    80385e <shutdown+0x2d>
		return r;
  803859:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385c:	eb 16                	jmp    803874 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80385e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803861:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803864:	89 d6                	mov    %edx,%esi
  803866:	89 c7                	mov    %eax,%edi
  803868:	48 b8 a2 3b 80 00 00 	movabs $0x803ba2,%rax
  80386f:	00 00 00 
  803872:	ff d0                	callq  *%rax
}
  803874:	c9                   	leaveq 
  803875:	c3                   	retq   

0000000000803876 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803876:	55                   	push   %rbp
  803877:	48 89 e5             	mov    %rsp,%rbp
  80387a:	48 83 ec 10          	sub    $0x10,%rsp
  80387e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803882:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803886:	48 89 c7             	mov    %rax,%rdi
  803889:	48 b8 f0 48 80 00 00 	movabs $0x8048f0,%rax
  803890:	00 00 00 
  803893:	ff d0                	callq  *%rax
  803895:	83 f8 01             	cmp    $0x1,%eax
  803898:	75 17                	jne    8038b1 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80389a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80389e:	8b 40 0c             	mov    0xc(%rax),%eax
  8038a1:	89 c7                	mov    %eax,%edi
  8038a3:	48 b8 e2 3b 80 00 00 	movabs $0x803be2,%rax
  8038aa:	00 00 00 
  8038ad:	ff d0                	callq  *%rax
  8038af:	eb 05                	jmp    8038b6 <devsock_close+0x40>
	else
		return 0;
  8038b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038b6:	c9                   	leaveq 
  8038b7:	c3                   	retq   

00000000008038b8 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038b8:	55                   	push   %rbp
  8038b9:	48 89 e5             	mov    %rsp,%rbp
  8038bc:	48 83 ec 20          	sub    $0x20,%rsp
  8038c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038c7:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038cd:	89 c7                	mov    %eax,%edi
  8038cf:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
  8038db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038e2:	79 05                	jns    8038e9 <connect+0x31>
		return r;
  8038e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e7:	eb 1b                	jmp    803904 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8038e9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038ec:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f3:	48 89 ce             	mov    %rcx,%rsi
  8038f6:	89 c7                	mov    %eax,%edi
  8038f8:	48 b8 0f 3c 80 00 00 	movabs $0x803c0f,%rax
  8038ff:	00 00 00 
  803902:	ff d0                	callq  *%rax
}
  803904:	c9                   	leaveq 
  803905:	c3                   	retq   

0000000000803906 <listen>:

int
listen(int s, int backlog)
{
  803906:	55                   	push   %rbp
  803907:	48 89 e5             	mov    %rsp,%rbp
  80390a:	48 83 ec 20          	sub    $0x20,%rsp
  80390e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803911:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803914:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803917:	89 c7                	mov    %eax,%edi
  803919:	48 b8 7e 36 80 00 00 	movabs $0x80367e,%rax
  803920:	00 00 00 
  803923:	ff d0                	callq  *%rax
  803925:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803928:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392c:	79 05                	jns    803933 <listen+0x2d>
		return r;
  80392e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803931:	eb 16                	jmp    803949 <listen+0x43>
	return nsipc_listen(r, backlog);
  803933:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803936:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803939:	89 d6                	mov    %edx,%esi
  80393b:	89 c7                	mov    %eax,%edi
  80393d:	48 b8 73 3c 80 00 00 	movabs $0x803c73,%rax
  803944:	00 00 00 
  803947:	ff d0                	callq  *%rax
}
  803949:	c9                   	leaveq 
  80394a:	c3                   	retq   

000000000080394b <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80394b:	55                   	push   %rbp
  80394c:	48 89 e5             	mov    %rsp,%rbp
  80394f:	48 83 ec 20          	sub    $0x20,%rsp
  803953:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803957:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80395b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80395f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803963:	89 c2                	mov    %eax,%edx
  803965:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803969:	8b 40 0c             	mov    0xc(%rax),%eax
  80396c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803970:	b9 00 00 00 00       	mov    $0x0,%ecx
  803975:	89 c7                	mov    %eax,%edi
  803977:	48 b8 b3 3c 80 00 00 	movabs $0x803cb3,%rax
  80397e:	00 00 00 
  803981:	ff d0                	callq  *%rax
}
  803983:	c9                   	leaveq 
  803984:	c3                   	retq   

0000000000803985 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803985:	55                   	push   %rbp
  803986:	48 89 e5             	mov    %rsp,%rbp
  803989:	48 83 ec 20          	sub    $0x20,%rsp
  80398d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803991:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803995:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80399d:	89 c2                	mov    %eax,%edx
  80399f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a3:	8b 40 0c             	mov    0xc(%rax),%eax
  8039a6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039af:	89 c7                	mov    %eax,%edi
  8039b1:	48 b8 7f 3d 80 00 00 	movabs $0x803d7f,%rax
  8039b8:	00 00 00 
  8039bb:	ff d0                	callq  *%rax
}
  8039bd:	c9                   	leaveq 
  8039be:	c3                   	retq   

00000000008039bf <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8039bf:	55                   	push   %rbp
  8039c0:	48 89 e5             	mov    %rsp,%rbp
  8039c3:	48 83 ec 10          	sub    $0x10,%rsp
  8039c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8039cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d3:	48 be 28 51 80 00 00 	movabs $0x805128,%rsi
  8039da:	00 00 00 
  8039dd:	48 89 c7             	mov    %rax,%rdi
  8039e0:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8039e7:	00 00 00 
  8039ea:	ff d0                	callq  *%rax
	return 0;
  8039ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039f1:	c9                   	leaveq 
  8039f2:	c3                   	retq   

00000000008039f3 <socket>:

int
socket(int domain, int type, int protocol)
{
  8039f3:	55                   	push   %rbp
  8039f4:	48 89 e5             	mov    %rsp,%rbp
  8039f7:	48 83 ec 20          	sub    $0x20,%rsp
  8039fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039fe:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a01:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a04:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a07:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a0d:	89 ce                	mov    %ecx,%esi
  803a0f:	89 c7                	mov    %eax,%edi
  803a11:	48 b8 37 3e 80 00 00 	movabs $0x803e37,%rax
  803a18:	00 00 00 
  803a1b:	ff d0                	callq  *%rax
  803a1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a24:	79 05                	jns    803a2b <socket+0x38>
		return r;
  803a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a29:	eb 11                	jmp    803a3c <socket+0x49>
	return alloc_sockfd(r);
  803a2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a2e:	89 c7                	mov    %eax,%edi
  803a30:	48 b8 d5 36 80 00 00 	movabs $0x8036d5,%rax
  803a37:	00 00 00 
  803a3a:	ff d0                	callq  *%rax
}
  803a3c:	c9                   	leaveq 
  803a3d:	c3                   	retq   

0000000000803a3e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a3e:	55                   	push   %rbp
  803a3f:	48 89 e5             	mov    %rsp,%rbp
  803a42:	48 83 ec 10          	sub    $0x10,%rsp
  803a46:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803a49:	48 b8 d4 81 80 00 00 	movabs $0x8081d4,%rax
  803a50:	00 00 00 
  803a53:	8b 00                	mov    (%rax),%eax
  803a55:	85 c0                	test   %eax,%eax
  803a57:	75 1d                	jne    803a76 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803a59:	bf 02 00 00 00       	mov    $0x2,%edi
  803a5e:	48 b8 6e 48 80 00 00 	movabs $0x80486e,%rax
  803a65:	00 00 00 
  803a68:	ff d0                	callq  *%rax
  803a6a:	48 ba d4 81 80 00 00 	movabs $0x8081d4,%rdx
  803a71:	00 00 00 
  803a74:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a76:	48 b8 d4 81 80 00 00 	movabs $0x8081d4,%rax
  803a7d:	00 00 00 
  803a80:	8b 00                	mov    (%rax),%eax
  803a82:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a85:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a8a:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803a91:	00 00 00 
  803a94:	89 c7                	mov    %eax,%edi
  803a96:	48 b8 0c 48 80 00 00 	movabs $0x80480c,%rax
  803a9d:	00 00 00 
  803aa0:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  803aa7:	be 00 00 00 00       	mov    $0x0,%esi
  803aac:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab1:	48 b8 06 47 80 00 00 	movabs $0x804706,%rax
  803ab8:	00 00 00 
  803abb:	ff d0                	callq  *%rax
}
  803abd:	c9                   	leaveq 
  803abe:	c3                   	retq   

0000000000803abf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803abf:	55                   	push   %rbp
  803ac0:	48 89 e5             	mov    %rsp,%rbp
  803ac3:	48 83 ec 30          	sub    $0x30,%rsp
  803ac7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803aca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ace:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803ad2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ad9:	00 00 00 
  803adc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803adf:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803ae1:	bf 01 00 00 00       	mov    $0x1,%edi
  803ae6:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803aed:	00 00 00 
  803af0:	ff d0                	callq  *%rax
  803af2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803af5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af9:	78 3e                	js     803b39 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803afb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b02:	00 00 00 
  803b05:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0d:	8b 40 10             	mov    0x10(%rax),%eax
  803b10:	89 c2                	mov    %eax,%edx
  803b12:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b1a:	48 89 ce             	mov    %rcx,%rsi
  803b1d:	48 89 c7             	mov    %rax,%rdi
  803b20:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803b27:	00 00 00 
  803b2a:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803b2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b30:	8b 50 10             	mov    0x10(%rax),%edx
  803b33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b37:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803b39:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b3c:	c9                   	leaveq 
  803b3d:	c3                   	retq   

0000000000803b3e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b3e:	55                   	push   %rbp
  803b3f:	48 89 e5             	mov    %rsp,%rbp
  803b42:	48 83 ec 10          	sub    $0x10,%rsp
  803b46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b4d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803b50:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b57:	00 00 00 
  803b5a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b5d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803b5f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b66:	48 89 c6             	mov    %rax,%rsi
  803b69:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b70:	00 00 00 
  803b73:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803b7a:	00 00 00 
  803b7d:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b7f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b86:	00 00 00 
  803b89:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b8c:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803b8f:	bf 02 00 00 00       	mov    $0x2,%edi
  803b94:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803b9b:	00 00 00 
  803b9e:	ff d0                	callq  *%rax
}
  803ba0:	c9                   	leaveq 
  803ba1:	c3                   	retq   

0000000000803ba2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803ba2:	55                   	push   %rbp
  803ba3:	48 89 e5             	mov    %rsp,%rbp
  803ba6:	48 83 ec 10          	sub    $0x10,%rsp
  803baa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bad:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803bb0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bb7:	00 00 00 
  803bba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bbd:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803bbf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bc6:	00 00 00 
  803bc9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bcc:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803bcf:	bf 03 00 00 00       	mov    $0x3,%edi
  803bd4:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803bdb:	00 00 00 
  803bde:	ff d0                	callq  *%rax
}
  803be0:	c9                   	leaveq 
  803be1:	c3                   	retq   

0000000000803be2 <nsipc_close>:

int
nsipc_close(int s)
{
  803be2:	55                   	push   %rbp
  803be3:	48 89 e5             	mov    %rsp,%rbp
  803be6:	48 83 ec 10          	sub    $0x10,%rsp
  803bea:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803bed:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bf4:	00 00 00 
  803bf7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bfa:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803bfc:	bf 04 00 00 00       	mov    $0x4,%edi
  803c01:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803c08:	00 00 00 
  803c0b:	ff d0                	callq  *%rax
}
  803c0d:	c9                   	leaveq 
  803c0e:	c3                   	retq   

0000000000803c0f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c0f:	55                   	push   %rbp
  803c10:	48 89 e5             	mov    %rsp,%rbp
  803c13:	48 83 ec 10          	sub    $0x10,%rsp
  803c17:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c1e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803c21:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c28:	00 00 00 
  803c2b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c2e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803c30:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c37:	48 89 c6             	mov    %rax,%rsi
  803c3a:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c41:	00 00 00 
  803c44:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803c4b:	00 00 00 
  803c4e:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803c50:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c57:	00 00 00 
  803c5a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c5d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803c60:	bf 05 00 00 00       	mov    $0x5,%edi
  803c65:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803c6c:	00 00 00 
  803c6f:	ff d0                	callq  *%rax
}
  803c71:	c9                   	leaveq 
  803c72:	c3                   	retq   

0000000000803c73 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803c73:	55                   	push   %rbp
  803c74:	48 89 e5             	mov    %rsp,%rbp
  803c77:	48 83 ec 10          	sub    $0x10,%rsp
  803c7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c7e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c81:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c88:	00 00 00 
  803c8b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c8e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803c90:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c97:	00 00 00 
  803c9a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c9d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803ca0:	bf 06 00 00 00       	mov    $0x6,%edi
  803ca5:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803cac:	00 00 00 
  803caf:	ff d0                	callq  *%rax
}
  803cb1:	c9                   	leaveq 
  803cb2:	c3                   	retq   

0000000000803cb3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803cb3:	55                   	push   %rbp
  803cb4:	48 89 e5             	mov    %rsp,%rbp
  803cb7:	48 83 ec 30          	sub    $0x30,%rsp
  803cbb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803cbe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cc2:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803cc5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803cc8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ccf:	00 00 00 
  803cd2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cd5:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803cd7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cde:	00 00 00 
  803ce1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ce4:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803ce7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cee:	00 00 00 
  803cf1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803cf4:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803cf7:	bf 07 00 00 00       	mov    $0x7,%edi
  803cfc:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803d03:	00 00 00 
  803d06:	ff d0                	callq  *%rax
  803d08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d0f:	78 69                	js     803d7a <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d11:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d18:	7f 08                	jg     803d22 <nsipc_recv+0x6f>
  803d1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d1d:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803d20:	7e 35                	jle    803d57 <nsipc_recv+0xa4>
  803d22:	48 b9 2f 51 80 00 00 	movabs $0x80512f,%rcx
  803d29:	00 00 00 
  803d2c:	48 ba 44 51 80 00 00 	movabs $0x805144,%rdx
  803d33:	00 00 00 
  803d36:	be 61 00 00 00       	mov    $0x61,%esi
  803d3b:	48 bf 59 51 80 00 00 	movabs $0x805159,%rdi
  803d42:	00 00 00 
  803d45:	b8 00 00 00 00       	mov    $0x0,%eax
  803d4a:	49 b8 e4 0a 80 00 00 	movabs $0x800ae4,%r8
  803d51:	00 00 00 
  803d54:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803d57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5a:	48 63 d0             	movslq %eax,%rdx
  803d5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d61:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803d68:	00 00 00 
  803d6b:	48 89 c7             	mov    %rax,%rdi
  803d6e:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803d75:	00 00 00 
  803d78:	ff d0                	callq  *%rax
	}

	return r;
  803d7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d7d:	c9                   	leaveq 
  803d7e:	c3                   	retq   

0000000000803d7f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d7f:	55                   	push   %rbp
  803d80:	48 89 e5             	mov    %rsp,%rbp
  803d83:	48 83 ec 20          	sub    $0x20,%rsp
  803d87:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d8a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d8e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803d91:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803d94:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d9b:	00 00 00 
  803d9e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803da1:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803da3:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803daa:	7e 35                	jle    803de1 <nsipc_send+0x62>
  803dac:	48 b9 65 51 80 00 00 	movabs $0x805165,%rcx
  803db3:	00 00 00 
  803db6:	48 ba 44 51 80 00 00 	movabs $0x805144,%rdx
  803dbd:	00 00 00 
  803dc0:	be 6c 00 00 00       	mov    $0x6c,%esi
  803dc5:	48 bf 59 51 80 00 00 	movabs $0x805159,%rdi
  803dcc:	00 00 00 
  803dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd4:	49 b8 e4 0a 80 00 00 	movabs $0x800ae4,%r8
  803ddb:	00 00 00 
  803dde:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803de1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803de4:	48 63 d0             	movslq %eax,%rdx
  803de7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803deb:	48 89 c6             	mov    %rax,%rsi
  803dee:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803df5:	00 00 00 
  803df8:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  803dff:	00 00 00 
  803e02:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e04:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e0b:	00 00 00 
  803e0e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e11:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e14:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e1b:	00 00 00 
  803e1e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e21:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803e24:	bf 08 00 00 00       	mov    $0x8,%edi
  803e29:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803e30:	00 00 00 
  803e33:	ff d0                	callq  *%rax
}
  803e35:	c9                   	leaveq 
  803e36:	c3                   	retq   

0000000000803e37 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803e37:	55                   	push   %rbp
  803e38:	48 89 e5             	mov    %rsp,%rbp
  803e3b:	48 83 ec 10          	sub    $0x10,%rsp
  803e3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e42:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803e45:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803e48:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e4f:	00 00 00 
  803e52:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e55:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803e57:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e5e:	00 00 00 
  803e61:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e64:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803e67:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e6e:	00 00 00 
  803e71:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e74:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e77:	bf 09 00 00 00       	mov    $0x9,%edi
  803e7c:	48 b8 3e 3a 80 00 00 	movabs $0x803a3e,%rax
  803e83:	00 00 00 
  803e86:	ff d0                	callq  *%rax
}
  803e88:	c9                   	leaveq 
  803e89:	c3                   	retq   

0000000000803e8a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e8a:	55                   	push   %rbp
  803e8b:	48 89 e5             	mov    %rsp,%rbp
  803e8e:	53                   	push   %rbx
  803e8f:	48 83 ec 38          	sub    $0x38,%rsp
  803e93:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e97:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e9b:	48 89 c7             	mov    %rax,%rdi
  803e9e:	48 b8 c8 26 80 00 00 	movabs $0x8026c8,%rax
  803ea5:	00 00 00 
  803ea8:	ff d0                	callq  *%rax
  803eaa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ead:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eb1:	0f 88 bf 01 00 00    	js     804076 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803eb7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ebb:	ba 07 04 00 00       	mov    $0x407,%edx
  803ec0:	48 89 c6             	mov    %rax,%rsi
  803ec3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ec8:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  803ecf:	00 00 00 
  803ed2:	ff d0                	callq  *%rax
  803ed4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ed7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803edb:	0f 88 95 01 00 00    	js     804076 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803ee1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803ee5:	48 89 c7             	mov    %rax,%rdi
  803ee8:	48 b8 c8 26 80 00 00 	movabs $0x8026c8,%rax
  803eef:	00 00 00 
  803ef2:	ff d0                	callq  *%rax
  803ef4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ef7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803efb:	0f 88 5d 01 00 00    	js     80405e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f05:	ba 07 04 00 00       	mov    $0x407,%edx
  803f0a:	48 89 c6             	mov    %rax,%rsi
  803f0d:	bf 00 00 00 00       	mov    $0x0,%edi
  803f12:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  803f19:	00 00 00 
  803f1c:	ff d0                	callq  *%rax
  803f1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f25:	0f 88 33 01 00 00    	js     80405e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f2f:	48 89 c7             	mov    %rax,%rdi
  803f32:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  803f39:	00 00 00 
  803f3c:	ff d0                	callq  *%rax
  803f3e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f46:	ba 07 04 00 00       	mov    $0x407,%edx
  803f4b:	48 89 c6             	mov    %rax,%rsi
  803f4e:	bf 00 00 00 00       	mov    $0x0,%edi
  803f53:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  803f5a:	00 00 00 
  803f5d:	ff d0                	callq  *%rax
  803f5f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f62:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f66:	79 05                	jns    803f6d <pipe+0xe3>
		goto err2;
  803f68:	e9 d9 00 00 00       	jmpq   804046 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f6d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f71:	48 89 c7             	mov    %rax,%rdi
  803f74:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  803f7b:	00 00 00 
  803f7e:	ff d0                	callq  *%rax
  803f80:	48 89 c2             	mov    %rax,%rdx
  803f83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f87:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f8d:	48 89 d1             	mov    %rdx,%rcx
  803f90:	ba 00 00 00 00       	mov    $0x0,%edx
  803f95:	48 89 c6             	mov    %rax,%rsi
  803f98:	bf 00 00 00 00       	mov    $0x0,%edi
  803f9d:	48 b8 51 22 80 00 00 	movabs $0x802251,%rax
  803fa4:	00 00 00 
  803fa7:	ff d0                	callq  *%rax
  803fa9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fb0:	79 1b                	jns    803fcd <pipe+0x143>
		goto err3;
  803fb2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803fb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fb7:	48 89 c6             	mov    %rax,%rsi
  803fba:	bf 00 00 00 00       	mov    $0x0,%edi
  803fbf:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  803fc6:	00 00 00 
  803fc9:	ff d0                	callq  *%rax
  803fcb:	eb 79                	jmp    804046 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803fcd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fd1:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803fd8:	00 00 00 
  803fdb:	8b 12                	mov    (%rdx),%edx
  803fdd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803fdf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fe3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803fea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fee:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803ff5:	00 00 00 
  803ff8:	8b 12                	mov    (%rdx),%edx
  803ffa:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803ffc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804000:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804007:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80400b:	48 89 c7             	mov    %rax,%rdi
  80400e:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  804015:	00 00 00 
  804018:	ff d0                	callq  *%rax
  80401a:	89 c2                	mov    %eax,%edx
  80401c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804020:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804022:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804026:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80402a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80402e:	48 89 c7             	mov    %rax,%rdi
  804031:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  804038:	00 00 00 
  80403b:	ff d0                	callq  *%rax
  80403d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80403f:	b8 00 00 00 00       	mov    $0x0,%eax
  804044:	eb 33                	jmp    804079 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804046:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80404a:	48 89 c6             	mov    %rax,%rsi
  80404d:	bf 00 00 00 00       	mov    $0x0,%edi
  804052:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  804059:	00 00 00 
  80405c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80405e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804062:	48 89 c6             	mov    %rax,%rsi
  804065:	bf 00 00 00 00       	mov    $0x0,%edi
  80406a:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  804071:	00 00 00 
  804074:	ff d0                	callq  *%rax
err:
	return r;
  804076:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804079:	48 83 c4 38          	add    $0x38,%rsp
  80407d:	5b                   	pop    %rbx
  80407e:	5d                   	pop    %rbp
  80407f:	c3                   	retq   

0000000000804080 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804080:	55                   	push   %rbp
  804081:	48 89 e5             	mov    %rsp,%rbp
  804084:	53                   	push   %rbx
  804085:	48 83 ec 28          	sub    $0x28,%rsp
  804089:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80408d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804091:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  804098:	00 00 00 
  80409b:	48 8b 00             	mov    (%rax),%rax
  80409e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8040a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040ab:	48 89 c7             	mov    %rax,%rdi
  8040ae:	48 b8 f0 48 80 00 00 	movabs $0x8048f0,%rax
  8040b5:	00 00 00 
  8040b8:	ff d0                	callq  *%rax
  8040ba:	89 c3                	mov    %eax,%ebx
  8040bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040c0:	48 89 c7             	mov    %rax,%rdi
  8040c3:	48 b8 f0 48 80 00 00 	movabs $0x8048f0,%rax
  8040ca:	00 00 00 
  8040cd:	ff d0                	callq  *%rax
  8040cf:	39 c3                	cmp    %eax,%ebx
  8040d1:	0f 94 c0             	sete   %al
  8040d4:	0f b6 c0             	movzbl %al,%eax
  8040d7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8040da:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  8040e1:	00 00 00 
  8040e4:	48 8b 00             	mov    (%rax),%rax
  8040e7:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040ed:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8040f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040f3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8040f6:	75 05                	jne    8040fd <_pipeisclosed+0x7d>
			return ret;
  8040f8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8040fb:	eb 4f                	jmp    80414c <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8040fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804100:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804103:	74 42                	je     804147 <_pipeisclosed+0xc7>
  804105:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804109:	75 3c                	jne    804147 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80410b:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  804112:	00 00 00 
  804115:	48 8b 00             	mov    (%rax),%rax
  804118:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80411e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804121:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804124:	89 c6                	mov    %eax,%esi
  804126:	48 bf 76 51 80 00 00 	movabs $0x805176,%rdi
  80412d:	00 00 00 
  804130:	b8 00 00 00 00       	mov    $0x0,%eax
  804135:	49 b8 1d 0d 80 00 00 	movabs $0x800d1d,%r8
  80413c:	00 00 00 
  80413f:	41 ff d0             	callq  *%r8
	}
  804142:	e9 4a ff ff ff       	jmpq   804091 <_pipeisclosed+0x11>
  804147:	e9 45 ff ff ff       	jmpq   804091 <_pipeisclosed+0x11>
}
  80414c:	48 83 c4 28          	add    $0x28,%rsp
  804150:	5b                   	pop    %rbx
  804151:	5d                   	pop    %rbp
  804152:	c3                   	retq   

0000000000804153 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804153:	55                   	push   %rbp
  804154:	48 89 e5             	mov    %rsp,%rbp
  804157:	48 83 ec 30          	sub    $0x30,%rsp
  80415b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80415e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804162:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804165:	48 89 d6             	mov    %rdx,%rsi
  804168:	89 c7                	mov    %eax,%edi
  80416a:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  804171:	00 00 00 
  804174:	ff d0                	callq  *%rax
  804176:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804179:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80417d:	79 05                	jns    804184 <pipeisclosed+0x31>
		return r;
  80417f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804182:	eb 31                	jmp    8041b5 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804188:	48 89 c7             	mov    %rax,%rdi
  80418b:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  804192:	00 00 00 
  804195:	ff d0                	callq  *%rax
  804197:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80419b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80419f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041a3:	48 89 d6             	mov    %rdx,%rsi
  8041a6:	48 89 c7             	mov    %rax,%rdi
  8041a9:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  8041b0:	00 00 00 
  8041b3:	ff d0                	callq  *%rax
}
  8041b5:	c9                   	leaveq 
  8041b6:	c3                   	retq   

00000000008041b7 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041b7:	55                   	push   %rbp
  8041b8:	48 89 e5             	mov    %rsp,%rbp
  8041bb:	48 83 ec 40          	sub    $0x40,%rsp
  8041bf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8041c7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8041cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041cf:	48 89 c7             	mov    %rax,%rdi
  8041d2:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  8041d9:	00 00 00 
  8041dc:	ff d0                	callq  *%rax
  8041de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8041e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8041ea:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8041f1:	00 
  8041f2:	e9 92 00 00 00       	jmpq   804289 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8041f7:	eb 41                	jmp    80423a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8041f9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8041fe:	74 09                	je     804209 <devpipe_read+0x52>
				return i;
  804200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804204:	e9 92 00 00 00       	jmpq   80429b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804209:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80420d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804211:	48 89 d6             	mov    %rdx,%rsi
  804214:	48 89 c7             	mov    %rax,%rdi
  804217:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  80421e:	00 00 00 
  804221:	ff d0                	callq  *%rax
  804223:	85 c0                	test   %eax,%eax
  804225:	74 07                	je     80422e <devpipe_read+0x77>
				return 0;
  804227:	b8 00 00 00 00       	mov    $0x0,%eax
  80422c:	eb 6d                	jmp    80429b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80422e:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  804235:	00 00 00 
  804238:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80423a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423e:	8b 10                	mov    (%rax),%edx
  804240:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804244:	8b 40 04             	mov    0x4(%rax),%eax
  804247:	39 c2                	cmp    %eax,%edx
  804249:	74 ae                	je     8041f9 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80424b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80424f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804253:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80425b:	8b 00                	mov    (%rax),%eax
  80425d:	99                   	cltd   
  80425e:	c1 ea 1b             	shr    $0x1b,%edx
  804261:	01 d0                	add    %edx,%eax
  804263:	83 e0 1f             	and    $0x1f,%eax
  804266:	29 d0                	sub    %edx,%eax
  804268:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80426c:	48 98                	cltq   
  80426e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804273:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804279:	8b 00                	mov    (%rax),%eax
  80427b:	8d 50 01             	lea    0x1(%rax),%edx
  80427e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804282:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804284:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804289:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80428d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804291:	0f 82 60 ff ff ff    	jb     8041f7 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80429b:	c9                   	leaveq 
  80429c:	c3                   	retq   

000000000080429d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80429d:	55                   	push   %rbp
  80429e:	48 89 e5             	mov    %rsp,%rbp
  8042a1:	48 83 ec 40          	sub    $0x40,%rsp
  8042a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8042ad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8042b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042b5:	48 89 c7             	mov    %rax,%rdi
  8042b8:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  8042bf:	00 00 00 
  8042c2:	ff d0                	callq  *%rax
  8042c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8042c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042cc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8042d0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8042d7:	00 
  8042d8:	e9 8e 00 00 00       	jmpq   80436b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8042dd:	eb 31                	jmp    804310 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8042df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042e7:	48 89 d6             	mov    %rdx,%rsi
  8042ea:	48 89 c7             	mov    %rax,%rdi
  8042ed:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  8042f4:	00 00 00 
  8042f7:	ff d0                	callq  *%rax
  8042f9:	85 c0                	test   %eax,%eax
  8042fb:	74 07                	je     804304 <devpipe_write+0x67>
				return 0;
  8042fd:	b8 00 00 00 00       	mov    $0x0,%eax
  804302:	eb 79                	jmp    80437d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804304:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  80430b:	00 00 00 
  80430e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804310:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804314:	8b 40 04             	mov    0x4(%rax),%eax
  804317:	48 63 d0             	movslq %eax,%rdx
  80431a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431e:	8b 00                	mov    (%rax),%eax
  804320:	48 98                	cltq   
  804322:	48 83 c0 20          	add    $0x20,%rax
  804326:	48 39 c2             	cmp    %rax,%rdx
  804329:	73 b4                	jae    8042df <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80432b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80432f:	8b 40 04             	mov    0x4(%rax),%eax
  804332:	99                   	cltd   
  804333:	c1 ea 1b             	shr    $0x1b,%edx
  804336:	01 d0                	add    %edx,%eax
  804338:	83 e0 1f             	and    $0x1f,%eax
  80433b:	29 d0                	sub    %edx,%eax
  80433d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804341:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804345:	48 01 ca             	add    %rcx,%rdx
  804348:	0f b6 0a             	movzbl (%rdx),%ecx
  80434b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80434f:	48 98                	cltq   
  804351:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804359:	8b 40 04             	mov    0x4(%rax),%eax
  80435c:	8d 50 01             	lea    0x1(%rax),%edx
  80435f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804363:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804366:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80436b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80436f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804373:	0f 82 64 ff ff ff    	jb     8042dd <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80437d:	c9                   	leaveq 
  80437e:	c3                   	retq   

000000000080437f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80437f:	55                   	push   %rbp
  804380:	48 89 e5             	mov    %rsp,%rbp
  804383:	48 83 ec 20          	sub    $0x20,%rsp
  804387:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80438b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80438f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804393:	48 89 c7             	mov    %rax,%rdi
  804396:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  80439d:	00 00 00 
  8043a0:	ff d0                	callq  *%rax
  8043a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8043a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043aa:	48 be 89 51 80 00 00 	movabs $0x805189,%rsi
  8043b1:	00 00 00 
  8043b4:	48 89 c7             	mov    %rax,%rdi
  8043b7:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8043be:	00 00 00 
  8043c1:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8043c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043c7:	8b 50 04             	mov    0x4(%rax),%edx
  8043ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043ce:	8b 00                	mov    (%rax),%eax
  8043d0:	29 c2                	sub    %eax,%edx
  8043d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043d6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8043dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043e0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8043e7:	00 00 00 
	stat->st_dev = &devpipe;
  8043ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043ee:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8043f5:	00 00 00 
  8043f8:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8043ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804404:	c9                   	leaveq 
  804405:	c3                   	retq   

0000000000804406 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804406:	55                   	push   %rbp
  804407:	48 89 e5             	mov    %rsp,%rbp
  80440a:	48 83 ec 10          	sub    $0x10,%rsp
  80440e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804412:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804416:	48 89 c6             	mov    %rax,%rsi
  804419:	bf 00 00 00 00       	mov    $0x0,%edi
  80441e:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  804425:	00 00 00 
  804428:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80442a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80442e:	48 89 c7             	mov    %rax,%rdi
  804431:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  804438:	00 00 00 
  80443b:	ff d0                	callq  *%rax
  80443d:	48 89 c6             	mov    %rax,%rsi
  804440:	bf 00 00 00 00       	mov    $0x0,%edi
  804445:	48 b8 ac 22 80 00 00 	movabs $0x8022ac,%rax
  80444c:	00 00 00 
  80444f:	ff d0                	callq  *%rax
}
  804451:	c9                   	leaveq 
  804452:	c3                   	retq   

0000000000804453 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804453:	55                   	push   %rbp
  804454:	48 89 e5             	mov    %rsp,%rbp
  804457:	48 83 ec 20          	sub    $0x20,%rsp
  80445b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80445e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804461:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804464:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804468:	be 01 00 00 00       	mov    $0x1,%esi
  80446d:	48 89 c7             	mov    %rax,%rdi
  804470:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  804477:	00 00 00 
  80447a:	ff d0                	callq  *%rax
}
  80447c:	c9                   	leaveq 
  80447d:	c3                   	retq   

000000000080447e <getchar>:

int
getchar(void)
{
  80447e:	55                   	push   %rbp
  80447f:	48 89 e5             	mov    %rsp,%rbp
  804482:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804486:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80448a:	ba 01 00 00 00       	mov    $0x1,%edx
  80448f:	48 89 c6             	mov    %rax,%rsi
  804492:	bf 00 00 00 00       	mov    $0x0,%edi
  804497:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  80449e:	00 00 00 
  8044a1:	ff d0                	callq  *%rax
  8044a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8044a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044aa:	79 05                	jns    8044b1 <getchar+0x33>
		return r;
  8044ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044af:	eb 14                	jmp    8044c5 <getchar+0x47>
	if (r < 1)
  8044b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044b5:	7f 07                	jg     8044be <getchar+0x40>
		return -E_EOF;
  8044b7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8044bc:	eb 07                	jmp    8044c5 <getchar+0x47>
	return c;
  8044be:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8044c2:	0f b6 c0             	movzbl %al,%eax
}
  8044c5:	c9                   	leaveq 
  8044c6:	c3                   	retq   

00000000008044c7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8044c7:	55                   	push   %rbp
  8044c8:	48 89 e5             	mov    %rsp,%rbp
  8044cb:	48 83 ec 20          	sub    $0x20,%rsp
  8044cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8044d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8044d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044d9:	48 89 d6             	mov    %rdx,%rsi
  8044dc:	89 c7                	mov    %eax,%edi
  8044de:	48 b8 60 27 80 00 00 	movabs $0x802760,%rax
  8044e5:	00 00 00 
  8044e8:	ff d0                	callq  *%rax
  8044ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044f1:	79 05                	jns    8044f8 <iscons+0x31>
		return r;
  8044f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044f6:	eb 1a                	jmp    804512 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8044f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044fc:	8b 10                	mov    (%rax),%edx
  8044fe:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804505:	00 00 00 
  804508:	8b 00                	mov    (%rax),%eax
  80450a:	39 c2                	cmp    %eax,%edx
  80450c:	0f 94 c0             	sete   %al
  80450f:	0f b6 c0             	movzbl %al,%eax
}
  804512:	c9                   	leaveq 
  804513:	c3                   	retq   

0000000000804514 <opencons>:

int
opencons(void)
{
  804514:	55                   	push   %rbp
  804515:	48 89 e5             	mov    %rsp,%rbp
  804518:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80451c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804520:	48 89 c7             	mov    %rax,%rdi
  804523:	48 b8 c8 26 80 00 00 	movabs $0x8026c8,%rax
  80452a:	00 00 00 
  80452d:	ff d0                	callq  *%rax
  80452f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804532:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804536:	79 05                	jns    80453d <opencons+0x29>
		return r;
  804538:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80453b:	eb 5b                	jmp    804598 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80453d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804541:	ba 07 04 00 00       	mov    $0x407,%edx
  804546:	48 89 c6             	mov    %rax,%rsi
  804549:	bf 00 00 00 00       	mov    $0x0,%edi
  80454e:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  804555:	00 00 00 
  804558:	ff d0                	callq  *%rax
  80455a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80455d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804561:	79 05                	jns    804568 <opencons+0x54>
		return r;
  804563:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804566:	eb 30                	jmp    804598 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80456c:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804573:	00 00 00 
  804576:	8b 12                	mov    (%rdx),%edx
  804578:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80457a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80457e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804589:	48 89 c7             	mov    %rax,%rdi
  80458c:	48 b8 7a 26 80 00 00 	movabs $0x80267a,%rax
  804593:	00 00 00 
  804596:	ff d0                	callq  *%rax
}
  804598:	c9                   	leaveq 
  804599:	c3                   	retq   

000000000080459a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80459a:	55                   	push   %rbp
  80459b:	48 89 e5             	mov    %rsp,%rbp
  80459e:	48 83 ec 30          	sub    $0x30,%rsp
  8045a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8045a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8045ae:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045b3:	75 07                	jne    8045bc <devcons_read+0x22>
		return 0;
  8045b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ba:	eb 4b                	jmp    804607 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8045bc:	eb 0c                	jmp    8045ca <devcons_read+0x30>
		sys_yield();
  8045be:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  8045c5:	00 00 00 
  8045c8:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8045ca:	48 b8 03 21 80 00 00 	movabs $0x802103,%rax
  8045d1:	00 00 00 
  8045d4:	ff d0                	callq  *%rax
  8045d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045dd:	74 df                	je     8045be <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8045df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045e3:	79 05                	jns    8045ea <devcons_read+0x50>
		return c;
  8045e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e8:	eb 1d                	jmp    804607 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8045ea:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8045ee:	75 07                	jne    8045f7 <devcons_read+0x5d>
		return 0;
  8045f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8045f5:	eb 10                	jmp    804607 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8045f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045fa:	89 c2                	mov    %eax,%edx
  8045fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804600:	88 10                	mov    %dl,(%rax)
	return 1;
  804602:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804607:	c9                   	leaveq 
  804608:	c3                   	retq   

0000000000804609 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804609:	55                   	push   %rbp
  80460a:	48 89 e5             	mov    %rsp,%rbp
  80460d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804614:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80461b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804622:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804629:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804630:	eb 76                	jmp    8046a8 <devcons_write+0x9f>
		m = n - tot;
  804632:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804639:	89 c2                	mov    %eax,%edx
  80463b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80463e:	29 c2                	sub    %eax,%edx
  804640:	89 d0                	mov    %edx,%eax
  804642:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804645:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804648:	83 f8 7f             	cmp    $0x7f,%eax
  80464b:	76 07                	jbe    804654 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80464d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804654:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804657:	48 63 d0             	movslq %eax,%rdx
  80465a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80465d:	48 63 c8             	movslq %eax,%rcx
  804660:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804667:	48 01 c1             	add    %rax,%rcx
  80466a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804671:	48 89 ce             	mov    %rcx,%rsi
  804674:	48 89 c7             	mov    %rax,%rdi
  804677:	48 b8 f6 1b 80 00 00 	movabs $0x801bf6,%rax
  80467e:	00 00 00 
  804681:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804683:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804686:	48 63 d0             	movslq %eax,%rdx
  804689:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804690:	48 89 d6             	mov    %rdx,%rsi
  804693:	48 89 c7             	mov    %rax,%rdi
  804696:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  80469d:	00 00 00 
  8046a0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8046a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046a5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8046a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ab:	48 98                	cltq   
  8046ad:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8046b4:	0f 82 78 ff ff ff    	jb     804632 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8046ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8046bd:	c9                   	leaveq 
  8046be:	c3                   	retq   

00000000008046bf <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8046bf:	55                   	push   %rbp
  8046c0:	48 89 e5             	mov    %rsp,%rbp
  8046c3:	48 83 ec 08          	sub    $0x8,%rsp
  8046c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8046cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046d0:	c9                   	leaveq 
  8046d1:	c3                   	retq   

00000000008046d2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8046d2:	55                   	push   %rbp
  8046d3:	48 89 e5             	mov    %rsp,%rbp
  8046d6:	48 83 ec 10          	sub    $0x10,%rsp
  8046da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8046de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8046e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046e6:	48 be 95 51 80 00 00 	movabs $0x805195,%rsi
  8046ed:	00 00 00 
  8046f0:	48 89 c7             	mov    %rax,%rdi
  8046f3:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  8046fa:	00 00 00 
  8046fd:	ff d0                	callq  *%rax
	return 0;
  8046ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804704:	c9                   	leaveq 
  804705:	c3                   	retq   

0000000000804706 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804706:	55                   	push   %rbp
  804707:	48 89 e5             	mov    %rsp,%rbp
  80470a:	48 83 ec 30          	sub    $0x30,%rsp
  80470e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804712:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804716:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  80471a:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  804721:	00 00 00 
  804724:	48 8b 00             	mov    (%rax),%rax
  804727:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80472d:	85 c0                	test   %eax,%eax
  80472f:	75 3c                	jne    80476d <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  804731:	48 b8 85 21 80 00 00 	movabs $0x802185,%rax
  804738:	00 00 00 
  80473b:	ff d0                	callq  *%rax
  80473d:	25 ff 03 00 00       	and    $0x3ff,%eax
  804742:	48 63 d0             	movslq %eax,%rdx
  804745:	48 89 d0             	mov    %rdx,%rax
  804748:	48 c1 e0 03          	shl    $0x3,%rax
  80474c:	48 01 d0             	add    %rdx,%rax
  80474f:	48 c1 e0 05          	shl    $0x5,%rax
  804753:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80475a:	00 00 00 
  80475d:	48 01 c2             	add    %rax,%rdx
  804760:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  804767:	00 00 00 
  80476a:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80476d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804772:	75 0e                	jne    804782 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  804774:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80477b:	00 00 00 
  80477e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  804782:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804786:	48 89 c7             	mov    %rax,%rdi
  804789:	48 b8 2a 24 80 00 00 	movabs $0x80242a,%rax
  804790:	00 00 00 
  804793:	ff d0                	callq  *%rax
  804795:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  804798:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80479c:	79 19                	jns    8047b7 <ipc_recv+0xb1>
		*from_env_store = 0;
  80479e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047a2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8047a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047ac:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8047b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047b5:	eb 53                	jmp    80480a <ipc_recv+0x104>
	}
	if(from_env_store)
  8047b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047bc:	74 19                	je     8047d7 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8047be:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  8047c5:	00 00 00 
  8047c8:	48 8b 00             	mov    (%rax),%rax
  8047cb:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8047d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047d5:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  8047d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047dc:	74 19                	je     8047f7 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  8047de:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  8047e5:	00 00 00 
  8047e8:	48 8b 00             	mov    (%rax),%rax
  8047eb:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8047f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047f5:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8047f7:	48 b8 d8 81 80 00 00 	movabs $0x8081d8,%rax
  8047fe:	00 00 00 
  804801:	48 8b 00             	mov    (%rax),%rax
  804804:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  80480a:	c9                   	leaveq 
  80480b:	c3                   	retq   

000000000080480c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80480c:	55                   	push   %rbp
  80480d:	48 89 e5             	mov    %rsp,%rbp
  804810:	48 83 ec 30          	sub    $0x30,%rsp
  804814:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804817:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80481a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80481e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804821:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804826:	75 0e                	jne    804836 <ipc_send+0x2a>
		pg = (void*)UTOP;
  804828:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80482f:	00 00 00 
  804832:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  804836:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804839:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80483c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804840:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804843:	89 c7                	mov    %eax,%edi
  804845:	48 b8 d5 23 80 00 00 	movabs $0x8023d5,%rax
  80484c:	00 00 00 
  80484f:	ff d0                	callq  *%rax
  804851:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  804854:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804858:	75 0c                	jne    804866 <ipc_send+0x5a>
			sys_yield();
  80485a:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  804861:	00 00 00 
  804864:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  804866:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80486a:	74 ca                	je     804836 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80486c:	c9                   	leaveq 
  80486d:	c3                   	retq   

000000000080486e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80486e:	55                   	push   %rbp
  80486f:	48 89 e5             	mov    %rsp,%rbp
  804872:	48 83 ec 14          	sub    $0x14,%rsp
  804876:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804879:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804880:	eb 5e                	jmp    8048e0 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804882:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804889:	00 00 00 
  80488c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80488f:	48 63 d0             	movslq %eax,%rdx
  804892:	48 89 d0             	mov    %rdx,%rax
  804895:	48 c1 e0 03          	shl    $0x3,%rax
  804899:	48 01 d0             	add    %rdx,%rax
  80489c:	48 c1 e0 05          	shl    $0x5,%rax
  8048a0:	48 01 c8             	add    %rcx,%rax
  8048a3:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8048a9:	8b 00                	mov    (%rax),%eax
  8048ab:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8048ae:	75 2c                	jne    8048dc <ipc_find_env+0x6e>
			return envs[i].env_id;
  8048b0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048b7:	00 00 00 
  8048ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048bd:	48 63 d0             	movslq %eax,%rdx
  8048c0:	48 89 d0             	mov    %rdx,%rax
  8048c3:	48 c1 e0 03          	shl    $0x3,%rax
  8048c7:	48 01 d0             	add    %rdx,%rax
  8048ca:	48 c1 e0 05          	shl    $0x5,%rax
  8048ce:	48 01 c8             	add    %rcx,%rax
  8048d1:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8048d7:	8b 40 08             	mov    0x8(%rax),%eax
  8048da:	eb 12                	jmp    8048ee <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8048dc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8048e0:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8048e7:	7e 99                	jle    804882 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8048e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048ee:	c9                   	leaveq 
  8048ef:	c3                   	retq   

00000000008048f0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8048f0:	55                   	push   %rbp
  8048f1:	48 89 e5             	mov    %rsp,%rbp
  8048f4:	48 83 ec 18          	sub    $0x18,%rsp
  8048f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8048fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804900:	48 c1 e8 15          	shr    $0x15,%rax
  804904:	48 89 c2             	mov    %rax,%rdx
  804907:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80490e:	01 00 00 
  804911:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804915:	83 e0 01             	and    $0x1,%eax
  804918:	48 85 c0             	test   %rax,%rax
  80491b:	75 07                	jne    804924 <pageref+0x34>
		return 0;
  80491d:	b8 00 00 00 00       	mov    $0x0,%eax
  804922:	eb 53                	jmp    804977 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804928:	48 c1 e8 0c          	shr    $0xc,%rax
  80492c:	48 89 c2             	mov    %rax,%rdx
  80492f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804936:	01 00 00 
  804939:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80493d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804941:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804945:	83 e0 01             	and    $0x1,%eax
  804948:	48 85 c0             	test   %rax,%rax
  80494b:	75 07                	jne    804954 <pageref+0x64>
		return 0;
  80494d:	b8 00 00 00 00       	mov    $0x0,%eax
  804952:	eb 23                	jmp    804977 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804954:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804958:	48 c1 e8 0c          	shr    $0xc,%rax
  80495c:	48 89 c2             	mov    %rax,%rdx
  80495f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804966:	00 00 00 
  804969:	48 c1 e2 04          	shl    $0x4,%rdx
  80496d:	48 01 d0             	add    %rdx,%rax
  804970:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804974:	0f b7 c0             	movzwl %ax,%eax
}
  804977:	c9                   	leaveq 
  804978:	c3                   	retq   
