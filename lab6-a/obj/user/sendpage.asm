
obj/user/sendpage.debug:     file format elf64-x86-64


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
  80003c:	e8 66 02 00 00       	callq  8002a7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;

	if ((who = fork()) == 0) {
  800052:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800061:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800064:	85 c0                	test   %eax,%eax
  800066:	0f 85 09 01 00 00    	jne    800175 <umain+0x132>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  80006c:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800070:	ba 00 00 00 00       	mov    $0x0,%edx
  800075:	be 00 00 b0 00       	mov    $0xb00000,%esi
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 31 23 80 00 00 	movabs $0x802331,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
		cprintf("%x got message : %s\n", who, TEMP_ADDR_CHILD);
  800089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008c:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  800091:	89 c6                	mov    %eax,%esi
  800093:	48 bf ec 48 80 00 00 	movabs $0x8048ec,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  8000a9:	00 00 00 
  8000ac:	ff d1                	callq  *%rcx
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  8000ae:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000b5:	00 00 00 
  8000b8:	48 8b 00             	mov    (%rax),%rax
  8000bb:	48 89 c7             	mov    %rax,%rdi
  8000be:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	48 63 d0             	movslq %eax,%rdx
  8000cd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8000d4:	00 00 00 
  8000d7:	48 8b 00             	mov    (%rax),%rax
  8000da:	48 89 c6             	mov    %rax,%rsi
  8000dd:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  8000e2:	48 b8 e4 11 80 00 00 	movabs $0x8011e4,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	75 1b                	jne    80010d <umain+0xca>
			cprintf("child received correct message\n");
  8000f2:	48 bf 08 49 80 00 00 	movabs $0x804908,%rdi
  8000f9:	00 00 00 
  8000fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800101:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  800108:	00 00 00 
  80010b:	ff d2                	callq  *%rdx

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str1) + 1);
  80010d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800114:	00 00 00 
  800117:	48 8b 00             	mov    (%rax),%rax
  80011a:	48 89 c7             	mov    %rax,%rdi
  80011d:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
  800129:	83 c0 01             	add    $0x1,%eax
  80012c:	48 63 d0             	movslq %eax,%rdx
  80012f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800136:	00 00 00 
  800139:	48 8b 00             	mov    (%rax),%rax
  80013c:	48 89 c6             	mov    %rax,%rsi
  80013f:	bf 00 00 b0 00       	mov    $0xb00000,%edi
  800144:	48 b8 6a 14 80 00 00 	movabs $0x80146a,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800153:	b9 07 00 00 00       	mov    $0x7,%ecx
  800158:	ba 00 00 b0 00       	mov    $0xb00000,%edx
  80015d:	be 00 00 00 00       	mov    $0x0,%esi
  800162:	89 c7                	mov    %eax,%edi
  800164:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  80016b:	00 00 00 
  80016e:	ff d0                	callq  *%rax
		return;
  800170:	e9 30 01 00 00       	jmpq   8002a5 <umain+0x262>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800175:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80017c:	00 00 00 
  80017f:	48 8b 00             	mov    (%rax),%rax
  800182:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800188:	ba 07 00 00 00       	mov    $0x7,%edx
  80018d:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800192:	89 c7                	mov    %eax,%edi
  800194:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8001a0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001a7:	00 00 00 
  8001aa:	48 8b 00             	mov    (%rax),%rax
  8001ad:	48 89 c7             	mov    %rax,%rdi
  8001b0:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
  8001bc:	83 c0 01             	add    $0x1,%eax
  8001bf:	48 63 d0             	movslq %eax,%rdx
  8001c2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001c9:	00 00 00 
  8001cc:	48 8b 00             	mov    (%rax),%rax
  8001cf:	48 89 c6             	mov    %rax,%rsi
  8001d2:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  8001d7:	48 b8 6a 14 80 00 00 	movabs $0x80146a,%rax
  8001de:	00 00 00 
  8001e1:	ff d0                	callq  *%rax
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8001e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001eb:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  8001f0:	be 00 00 00 00       	mov    $0x0,%esi
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax

	ipc_recv(&who, TEMP_ADDR, 0);
  800203:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
  800207:	ba 00 00 00 00       	mov    $0x0,%edx
  80020c:	be 00 00 a0 00       	mov    $0xa00000,%esi
  800211:	48 89 c7             	mov    %rax,%rdi
  800214:	48 b8 31 23 80 00 00 	movabs $0x802331,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	cprintf("%x got message : %s\n", who, TEMP_ADDR);
  800220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800223:	ba 00 00 a0 00       	mov    $0xa00000,%edx
  800228:	89 c6                	mov    %eax,%esi
  80022a:	48 bf ec 48 80 00 00 	movabs $0x8048ec,%rdi
  800231:	00 00 00 
  800234:	b8 00 00 00 00       	mov    $0x0,%eax
  800239:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  800240:	00 00 00 
  800243:	ff d1                	callq  *%rcx
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800245:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80024c:	00 00 00 
  80024f:	48 8b 00             	mov    (%rax),%rax
  800252:	48 89 c7             	mov    %rax,%rdi
  800255:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  80025c:	00 00 00 
  80025f:	ff d0                	callq  *%rax
  800261:	48 63 d0             	movslq %eax,%rdx
  800264:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80026b:	00 00 00 
  80026e:	48 8b 00             	mov    (%rax),%rax
  800271:	48 89 c6             	mov    %rax,%rsi
  800274:	bf 00 00 a0 00       	mov    $0xa00000,%edi
  800279:	48 b8 e4 11 80 00 00 	movabs $0x8011e4,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
  800285:	85 c0                	test   %eax,%eax
  800287:	75 1b                	jne    8002a4 <umain+0x261>
		cprintf("parent received correct message\n");
  800289:	48 bf 28 49 80 00 00 	movabs $0x804928,%rdi
  800290:	00 00 00 
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  80029f:	00 00 00 
  8002a2:	ff d2                	callq  *%rdx
	return;
  8002a4:	90                   	nop
}
  8002a5:	c9                   	leaveq 
  8002a6:	c3                   	retq   

00000000008002a7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a7:	55                   	push   %rbp
  8002a8:	48 89 e5             	mov    %rsp,%rbp
  8002ab:	48 83 ec 10          	sub    $0x10,%rsp
  8002af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002b6:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002c7:	48 63 d0             	movslq %eax,%rdx
  8002ca:	48 89 d0             	mov    %rdx,%rax
  8002cd:	48 c1 e0 03          	shl    $0x3,%rax
  8002d1:	48 01 d0             	add    %rdx,%rax
  8002d4:	48 c1 e0 05          	shl    $0x5,%rax
  8002d8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8002df:	00 00 00 
  8002e2:	48 01 c2             	add    %rax,%rdx
  8002e5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002ec:	00 00 00 
  8002ef:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002f6:	7e 14                	jle    80030c <libmain+0x65>
		binaryname = argv[0];
  8002f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002fc:	48 8b 10             	mov    (%rax),%rdx
  8002ff:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800306:	00 00 00 
  800309:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80030c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800313:	48 89 d6             	mov    %rdx,%rsi
  800316:	89 c7                	mov    %eax,%edi
  800318:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80031f:	00 00 00 
  800322:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800324:	48 b8 32 03 80 00 00 	movabs $0x800332,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
}
  800330:	c9                   	leaveq 
  800331:	c3                   	retq   

0000000000800332 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800332:	55                   	push   %rbp
  800333:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800336:	48 b8 5c 28 80 00 00 	movabs $0x80285c,%rax
  80033d:	00 00 00 
  800340:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800342:	bf 00 00 00 00       	mov    $0x0,%edi
  800347:	48 b8 9e 18 80 00 00 	movabs $0x80189e,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax

}
  800353:	5d                   	pop    %rbp
  800354:	c3                   	retq   

0000000000800355 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800355:	55                   	push   %rbp
  800356:	48 89 e5             	mov    %rsp,%rbp
  800359:	48 83 ec 10          	sub    $0x10,%rsp
  80035d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800360:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800368:	8b 00                	mov    (%rax),%eax
  80036a:	8d 48 01             	lea    0x1(%rax),%ecx
  80036d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800371:	89 0a                	mov    %ecx,(%rdx)
  800373:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800376:	89 d1                	mov    %edx,%ecx
  800378:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037c:	48 98                	cltq   
  80037e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800386:	8b 00                	mov    (%rax),%eax
  800388:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038d:	75 2c                	jne    8003bb <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80038f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800393:	8b 00                	mov    (%rax),%eax
  800395:	48 98                	cltq   
  800397:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039b:	48 83 c2 08          	add    $0x8,%rdx
  80039f:	48 89 c6             	mov    %rax,%rsi
  8003a2:	48 89 d7             	mov    %rdx,%rdi
  8003a5:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  8003ac:	00 00 00 
  8003af:	ff d0                	callq  *%rax
        b->idx = 0;
  8003b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003bf:	8b 40 04             	mov    0x4(%rax),%eax
  8003c2:	8d 50 01             	lea    0x1(%rax),%edx
  8003c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c9:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003cc:	c9                   	leaveq 
  8003cd:	c3                   	retq   

00000000008003ce <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003ce:	55                   	push   %rbp
  8003cf:	48 89 e5             	mov    %rsp,%rbp
  8003d2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003d9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003e0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003e7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003ee:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003f5:	48 8b 0a             	mov    (%rdx),%rcx
  8003f8:	48 89 08             	mov    %rcx,(%rax)
  8003fb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003ff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800403:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800407:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80040b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800412:	00 00 00 
    b.cnt = 0;
  800415:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80041c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80041f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800426:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80042d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800434:	48 89 c6             	mov    %rax,%rsi
  800437:	48 bf 55 03 80 00 00 	movabs $0x800355,%rdi
  80043e:	00 00 00 
  800441:	48 b8 2d 08 80 00 00 	movabs $0x80082d,%rax
  800448:	00 00 00 
  80044b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80044d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800453:	48 98                	cltq   
  800455:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80045c:	48 83 c2 08          	add    $0x8,%rdx
  800460:	48 89 c6             	mov    %rax,%rsi
  800463:	48 89 d7             	mov    %rdx,%rdi
  800466:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800472:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800478:	c9                   	leaveq 
  800479:	c3                   	retq   

000000000080047a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80047a:	55                   	push   %rbp
  80047b:	48 89 e5             	mov    %rsp,%rbp
  80047e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800485:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80048c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800493:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80049a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004a1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004a8:	84 c0                	test   %al,%al
  8004aa:	74 20                	je     8004cc <cprintf+0x52>
  8004ac:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004b0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004b4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004b8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004bc:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004c0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004c4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004c8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004cc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004d3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004da:	00 00 00 
  8004dd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004e4:	00 00 00 
  8004e7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004eb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004f2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004f9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800500:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800507:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80050e:	48 8b 0a             	mov    (%rdx),%rcx
  800511:	48 89 08             	mov    %rcx,(%rax)
  800514:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800518:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80051c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800520:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800524:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80052b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800532:	48 89 d6             	mov    %rdx,%rsi
  800535:	48 89 c7             	mov    %rax,%rdi
  800538:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  80053f:	00 00 00 
  800542:	ff d0                	callq  *%rax
  800544:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80054a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800550:	c9                   	leaveq 
  800551:	c3                   	retq   

0000000000800552 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800552:	55                   	push   %rbp
  800553:	48 89 e5             	mov    %rsp,%rbp
  800556:	53                   	push   %rbx
  800557:	48 83 ec 38          	sub    $0x38,%rsp
  80055b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80055f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800563:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800567:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80056a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80056e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800572:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800575:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800579:	77 3b                	ja     8005b6 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80057b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80057e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800582:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800585:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800589:	ba 00 00 00 00       	mov    $0x0,%edx
  80058e:	48 f7 f3             	div    %rbx
  800591:	48 89 c2             	mov    %rax,%rdx
  800594:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800597:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80059a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80059e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a2:	41 89 f9             	mov    %edi,%r9d
  8005a5:	48 89 c7             	mov    %rax,%rdi
  8005a8:	48 b8 52 05 80 00 00 	movabs $0x800552,%rax
  8005af:	00 00 00 
  8005b2:	ff d0                	callq  *%rax
  8005b4:	eb 1e                	jmp    8005d4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005b6:	eb 12                	jmp    8005ca <printnum+0x78>
			putch(padc, putdat);
  8005b8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005bc:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c3:	48 89 ce             	mov    %rcx,%rsi
  8005c6:	89 d7                	mov    %edx,%edi
  8005c8:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ca:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005ce:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005d2:	7f e4                	jg     8005b8 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005d4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005db:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e0:	48 f7 f1             	div    %rcx
  8005e3:	48 89 d0             	mov    %rdx,%rax
  8005e6:	48 ba 50 4b 80 00 00 	movabs $0x804b50,%rdx
  8005ed:	00 00 00 
  8005f0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005f4:	0f be d0             	movsbl %al,%edx
  8005f7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ff:	48 89 ce             	mov    %rcx,%rsi
  800602:	89 d7                	mov    %edx,%edi
  800604:	ff d0                	callq  *%rax
}
  800606:	48 83 c4 38          	add    $0x38,%rsp
  80060a:	5b                   	pop    %rbx
  80060b:	5d                   	pop    %rbp
  80060c:	c3                   	retq   

000000000080060d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80060d:	55                   	push   %rbp
  80060e:	48 89 e5             	mov    %rsp,%rbp
  800611:	48 83 ec 1c          	sub    $0x1c,%rsp
  800615:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800619:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80061c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800620:	7e 52                	jle    800674 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	8b 00                	mov    (%rax),%eax
  800628:	83 f8 30             	cmp    $0x30,%eax
  80062b:	73 24                	jae    800651 <getuint+0x44>
  80062d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800631:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800639:	8b 00                	mov    (%rax),%eax
  80063b:	89 c0                	mov    %eax,%eax
  80063d:	48 01 d0             	add    %rdx,%rax
  800640:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800644:	8b 12                	mov    (%rdx),%edx
  800646:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800649:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064d:	89 0a                	mov    %ecx,(%rdx)
  80064f:	eb 17                	jmp    800668 <getuint+0x5b>
  800651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800655:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800659:	48 89 d0             	mov    %rdx,%rax
  80065c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800660:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800664:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800668:	48 8b 00             	mov    (%rax),%rax
  80066b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80066f:	e9 a3 00 00 00       	jmpq   800717 <getuint+0x10a>
	else if (lflag)
  800674:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800678:	74 4f                	je     8006c9 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80067a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067e:	8b 00                	mov    (%rax),%eax
  800680:	83 f8 30             	cmp    $0x30,%eax
  800683:	73 24                	jae    8006a9 <getuint+0x9c>
  800685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800689:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80068d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800691:	8b 00                	mov    (%rax),%eax
  800693:	89 c0                	mov    %eax,%eax
  800695:	48 01 d0             	add    %rdx,%rax
  800698:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069c:	8b 12                	mov    (%rdx),%edx
  80069e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a5:	89 0a                	mov    %ecx,(%rdx)
  8006a7:	eb 17                	jmp    8006c0 <getuint+0xb3>
  8006a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ad:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b1:	48 89 d0             	mov    %rdx,%rax
  8006b4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c0:	48 8b 00             	mov    (%rax),%rax
  8006c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006c7:	eb 4e                	jmp    800717 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cd:	8b 00                	mov    (%rax),%eax
  8006cf:	83 f8 30             	cmp    $0x30,%eax
  8006d2:	73 24                	jae    8006f8 <getuint+0xeb>
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e0:	8b 00                	mov    (%rax),%eax
  8006e2:	89 c0                	mov    %eax,%eax
  8006e4:	48 01 d0             	add    %rdx,%rax
  8006e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006eb:	8b 12                	mov    (%rdx),%edx
  8006ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f4:	89 0a                	mov    %ecx,(%rdx)
  8006f6:	eb 17                	jmp    80070f <getuint+0x102>
  8006f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800700:	48 89 d0             	mov    %rdx,%rax
  800703:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800707:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80070f:	8b 00                	mov    (%rax),%eax
  800711:	89 c0                	mov    %eax,%eax
  800713:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80071b:	c9                   	leaveq 
  80071c:	c3                   	retq   

000000000080071d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80071d:	55                   	push   %rbp
  80071e:	48 89 e5             	mov    %rsp,%rbp
  800721:	48 83 ec 1c          	sub    $0x1c,%rsp
  800725:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800729:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80072c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800730:	7e 52                	jle    800784 <getint+0x67>
		x=va_arg(*ap, long long);
  800732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800736:	8b 00                	mov    (%rax),%eax
  800738:	83 f8 30             	cmp    $0x30,%eax
  80073b:	73 24                	jae    800761 <getint+0x44>
  80073d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800741:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800749:	8b 00                	mov    (%rax),%eax
  80074b:	89 c0                	mov    %eax,%eax
  80074d:	48 01 d0             	add    %rdx,%rax
  800750:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800754:	8b 12                	mov    (%rdx),%edx
  800756:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800759:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075d:	89 0a                	mov    %ecx,(%rdx)
  80075f:	eb 17                	jmp    800778 <getint+0x5b>
  800761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800765:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800769:	48 89 d0             	mov    %rdx,%rax
  80076c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800770:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800774:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800778:	48 8b 00             	mov    (%rax),%rax
  80077b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077f:	e9 a3 00 00 00       	jmpq   800827 <getint+0x10a>
	else if (lflag)
  800784:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800788:	74 4f                	je     8007d9 <getint+0xbc>
		x=va_arg(*ap, long);
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078e:	8b 00                	mov    (%rax),%eax
  800790:	83 f8 30             	cmp    $0x30,%eax
  800793:	73 24                	jae    8007b9 <getint+0x9c>
  800795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800799:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80079d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a1:	8b 00                	mov    (%rax),%eax
  8007a3:	89 c0                	mov    %eax,%eax
  8007a5:	48 01 d0             	add    %rdx,%rax
  8007a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ac:	8b 12                	mov    (%rdx),%edx
  8007ae:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b5:	89 0a                	mov    %ecx,(%rdx)
  8007b7:	eb 17                	jmp    8007d0 <getint+0xb3>
  8007b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c1:	48 89 d0             	mov    %rdx,%rax
  8007c4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d0:	48 8b 00             	mov    (%rax),%rax
  8007d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d7:	eb 4e                	jmp    800827 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dd:	8b 00                	mov    (%rax),%eax
  8007df:	83 f8 30             	cmp    $0x30,%eax
  8007e2:	73 24                	jae    800808 <getint+0xeb>
  8007e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f0:	8b 00                	mov    (%rax),%eax
  8007f2:	89 c0                	mov    %eax,%eax
  8007f4:	48 01 d0             	add    %rdx,%rax
  8007f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fb:	8b 12                	mov    (%rdx),%edx
  8007fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800800:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800804:	89 0a                	mov    %ecx,(%rdx)
  800806:	eb 17                	jmp    80081f <getint+0x102>
  800808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800810:	48 89 d0             	mov    %rdx,%rax
  800813:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800817:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80081f:	8b 00                	mov    (%rax),%eax
  800821:	48 98                	cltq   
  800823:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800827:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80082b:	c9                   	leaveq 
  80082c:	c3                   	retq   

000000000080082d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082d:	55                   	push   %rbp
  80082e:	48 89 e5             	mov    %rsp,%rbp
  800831:	41 54                	push   %r12
  800833:	53                   	push   %rbx
  800834:	48 83 ec 60          	sub    $0x60,%rsp
  800838:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80083c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800840:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800844:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800848:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80084c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800850:	48 8b 0a             	mov    (%rdx),%rcx
  800853:	48 89 08             	mov    %rcx,(%rax)
  800856:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80085a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80085e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800862:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800866:	eb 17                	jmp    80087f <vprintfmt+0x52>
			if (ch == '\0')
  800868:	85 db                	test   %ebx,%ebx
  80086a:	0f 84 cc 04 00 00    	je     800d3c <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800870:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800874:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800878:	48 89 d6             	mov    %rdx,%rsi
  80087b:	89 df                	mov    %ebx,%edi
  80087d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800883:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800887:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80088b:	0f b6 00             	movzbl (%rax),%eax
  80088e:	0f b6 d8             	movzbl %al,%ebx
  800891:	83 fb 25             	cmp    $0x25,%ebx
  800894:	75 d2                	jne    800868 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800896:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80089a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008a1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008af:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008be:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008c2:	0f b6 00             	movzbl (%rax),%eax
  8008c5:	0f b6 d8             	movzbl %al,%ebx
  8008c8:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008cb:	83 f8 55             	cmp    $0x55,%eax
  8008ce:	0f 87 34 04 00 00    	ja     800d08 <vprintfmt+0x4db>
  8008d4:	89 c0                	mov    %eax,%eax
  8008d6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008dd:	00 
  8008de:	48 b8 78 4b 80 00 00 	movabs $0x804b78,%rax
  8008e5:	00 00 00 
  8008e8:	48 01 d0             	add    %rdx,%rax
  8008eb:	48 8b 00             	mov    (%rax),%rax
  8008ee:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008f0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008f4:	eb c0                	jmp    8008b6 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008fa:	eb ba                	jmp    8008b6 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008fc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800903:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800906:	89 d0                	mov    %edx,%eax
  800908:	c1 e0 02             	shl    $0x2,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	01 c0                	add    %eax,%eax
  80090f:	01 d8                	add    %ebx,%eax
  800911:	83 e8 30             	sub    $0x30,%eax
  800914:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800917:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80091b:	0f b6 00             	movzbl (%rax),%eax
  80091e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800921:	83 fb 2f             	cmp    $0x2f,%ebx
  800924:	7e 0c                	jle    800932 <vprintfmt+0x105>
  800926:	83 fb 39             	cmp    $0x39,%ebx
  800929:	7f 07                	jg     800932 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80092b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800930:	eb d1                	jmp    800903 <vprintfmt+0xd6>
			goto process_precision;
  800932:	eb 58                	jmp    80098c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800934:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800937:	83 f8 30             	cmp    $0x30,%eax
  80093a:	73 17                	jae    800953 <vprintfmt+0x126>
  80093c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800940:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800943:	89 c0                	mov    %eax,%eax
  800945:	48 01 d0             	add    %rdx,%rax
  800948:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80094b:	83 c2 08             	add    $0x8,%edx
  80094e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800951:	eb 0f                	jmp    800962 <vprintfmt+0x135>
  800953:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800957:	48 89 d0             	mov    %rdx,%rax
  80095a:	48 83 c2 08          	add    $0x8,%rdx
  80095e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800962:	8b 00                	mov    (%rax),%eax
  800964:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800967:	eb 23                	jmp    80098c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800969:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80096d:	79 0c                	jns    80097b <vprintfmt+0x14e>
				width = 0;
  80096f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800976:	e9 3b ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>
  80097b:	e9 36 ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800980:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800987:	e9 2a ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80098c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800990:	79 12                	jns    8009a4 <vprintfmt+0x177>
				width = precision, precision = -1;
  800992:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800995:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800998:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80099f:	e9 12 ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>
  8009a4:	e9 0d ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009a9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009ad:	e9 04 ff ff ff       	jmpq   8008b6 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009b2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b5:	83 f8 30             	cmp    $0x30,%eax
  8009b8:	73 17                	jae    8009d1 <vprintfmt+0x1a4>
  8009ba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c1:	89 c0                	mov    %eax,%eax
  8009c3:	48 01 d0             	add    %rdx,%rax
  8009c6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009c9:	83 c2 08             	add    $0x8,%edx
  8009cc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009cf:	eb 0f                	jmp    8009e0 <vprintfmt+0x1b3>
  8009d1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009d5:	48 89 d0             	mov    %rdx,%rax
  8009d8:	48 83 c2 08          	add    $0x8,%rdx
  8009dc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e0:	8b 10                	mov    (%rax),%edx
  8009e2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009e6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ea:	48 89 ce             	mov    %rcx,%rsi
  8009ed:	89 d7                	mov    %edx,%edi
  8009ef:	ff d0                	callq  *%rax
			break;
  8009f1:	e9 40 03 00 00       	jmpq   800d36 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009f6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f9:	83 f8 30             	cmp    $0x30,%eax
  8009fc:	73 17                	jae    800a15 <vprintfmt+0x1e8>
  8009fe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a05:	89 c0                	mov    %eax,%eax
  800a07:	48 01 d0             	add    %rdx,%rax
  800a0a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0d:	83 c2 08             	add    $0x8,%edx
  800a10:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a13:	eb 0f                	jmp    800a24 <vprintfmt+0x1f7>
  800a15:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a19:	48 89 d0             	mov    %rdx,%rax
  800a1c:	48 83 c2 08          	add    $0x8,%rdx
  800a20:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a24:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a26:	85 db                	test   %ebx,%ebx
  800a28:	79 02                	jns    800a2c <vprintfmt+0x1ff>
				err = -err;
  800a2a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a2c:	83 fb 15             	cmp    $0x15,%ebx
  800a2f:	7f 16                	jg     800a47 <vprintfmt+0x21a>
  800a31:	48 b8 a0 4a 80 00 00 	movabs $0x804aa0,%rax
  800a38:	00 00 00 
  800a3b:	48 63 d3             	movslq %ebx,%rdx
  800a3e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a42:	4d 85 e4             	test   %r12,%r12
  800a45:	75 2e                	jne    800a75 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a47:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4f:	89 d9                	mov    %ebx,%ecx
  800a51:	48 ba 61 4b 80 00 00 	movabs $0x804b61,%rdx
  800a58:	00 00 00 
  800a5b:	48 89 c7             	mov    %rax,%rdi
  800a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a63:	49 b8 45 0d 80 00 00 	movabs $0x800d45,%r8
  800a6a:	00 00 00 
  800a6d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a70:	e9 c1 02 00 00       	jmpq   800d36 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a75:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a7d:	4c 89 e1             	mov    %r12,%rcx
  800a80:	48 ba 6a 4b 80 00 00 	movabs $0x804b6a,%rdx
  800a87:	00 00 00 
  800a8a:	48 89 c7             	mov    %rax,%rdi
  800a8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a92:	49 b8 45 0d 80 00 00 	movabs $0x800d45,%r8
  800a99:	00 00 00 
  800a9c:	41 ff d0             	callq  *%r8
			break;
  800a9f:	e9 92 02 00 00       	jmpq   800d36 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800aa4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa7:	83 f8 30             	cmp    $0x30,%eax
  800aaa:	73 17                	jae    800ac3 <vprintfmt+0x296>
  800aac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ab0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab3:	89 c0                	mov    %eax,%eax
  800ab5:	48 01 d0             	add    %rdx,%rax
  800ab8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800abb:	83 c2 08             	add    $0x8,%edx
  800abe:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac1:	eb 0f                	jmp    800ad2 <vprintfmt+0x2a5>
  800ac3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac7:	48 89 d0             	mov    %rdx,%rax
  800aca:	48 83 c2 08          	add    $0x8,%rdx
  800ace:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad2:	4c 8b 20             	mov    (%rax),%r12
  800ad5:	4d 85 e4             	test   %r12,%r12
  800ad8:	75 0a                	jne    800ae4 <vprintfmt+0x2b7>
				p = "(null)";
  800ada:	49 bc 6d 4b 80 00 00 	movabs $0x804b6d,%r12
  800ae1:	00 00 00 
			if (width > 0 && padc != '-')
  800ae4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ae8:	7e 3f                	jle    800b29 <vprintfmt+0x2fc>
  800aea:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800aee:	74 39                	je     800b29 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800af0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800af3:	48 98                	cltq   
  800af5:	48 89 c6             	mov    %rax,%rsi
  800af8:	4c 89 e7             	mov    %r12,%rdi
  800afb:	48 b8 f1 0f 80 00 00 	movabs $0x800ff1,%rax
  800b02:	00 00 00 
  800b05:	ff d0                	callq  *%rax
  800b07:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b0a:	eb 17                	jmp    800b23 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b0c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b10:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b18:	48 89 ce             	mov    %rcx,%rsi
  800b1b:	89 d7                	mov    %edx,%edi
  800b1d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b1f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b23:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b27:	7f e3                	jg     800b0c <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b29:	eb 37                	jmp    800b62 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b2f:	74 1e                	je     800b4f <vprintfmt+0x322>
  800b31:	83 fb 1f             	cmp    $0x1f,%ebx
  800b34:	7e 05                	jle    800b3b <vprintfmt+0x30e>
  800b36:	83 fb 7e             	cmp    $0x7e,%ebx
  800b39:	7e 14                	jle    800b4f <vprintfmt+0x322>
					putch('?', putdat);
  800b3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b43:	48 89 d6             	mov    %rdx,%rsi
  800b46:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b4b:	ff d0                	callq  *%rax
  800b4d:	eb 0f                	jmp    800b5e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b57:	48 89 d6             	mov    %rdx,%rsi
  800b5a:	89 df                	mov    %ebx,%edi
  800b5c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b62:	4c 89 e0             	mov    %r12,%rax
  800b65:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b69:	0f b6 00             	movzbl (%rax),%eax
  800b6c:	0f be d8             	movsbl %al,%ebx
  800b6f:	85 db                	test   %ebx,%ebx
  800b71:	74 10                	je     800b83 <vprintfmt+0x356>
  800b73:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b77:	78 b2                	js     800b2b <vprintfmt+0x2fe>
  800b79:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b7d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b81:	79 a8                	jns    800b2b <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b83:	eb 16                	jmp    800b9b <vprintfmt+0x36e>
				putch(' ', putdat);
  800b85:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8d:	48 89 d6             	mov    %rdx,%rsi
  800b90:	bf 20 00 00 00       	mov    $0x20,%edi
  800b95:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b97:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b9b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b9f:	7f e4                	jg     800b85 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800ba1:	e9 90 01 00 00       	jmpq   800d36 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ba6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800baa:	be 03 00 00 00       	mov    $0x3,%esi
  800baf:	48 89 c7             	mov    %rax,%rdi
  800bb2:	48 b8 1d 07 80 00 00 	movabs $0x80071d,%rax
  800bb9:	00 00 00 
  800bbc:	ff d0                	callq  *%rax
  800bbe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc6:	48 85 c0             	test   %rax,%rax
  800bc9:	79 1d                	jns    800be8 <vprintfmt+0x3bb>
				putch('-', putdat);
  800bcb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bcf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd3:	48 89 d6             	mov    %rdx,%rsi
  800bd6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bdb:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be1:	48 f7 d8             	neg    %rax
  800be4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800be8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bef:	e9 d5 00 00 00       	jmpq   800cc9 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bf4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf8:	be 03 00 00 00       	mov    $0x3,%esi
  800bfd:	48 89 c7             	mov    %rax,%rdi
  800c00:	48 b8 0d 06 80 00 00 	movabs $0x80060d,%rax
  800c07:	00 00 00 
  800c0a:	ff d0                	callq  *%rax
  800c0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c10:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c17:	e9 ad 00 00 00       	jmpq   800cc9 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800c1c:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800c1f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c23:	89 d6                	mov    %edx,%esi
  800c25:	48 89 c7             	mov    %rax,%rdi
  800c28:	48 b8 1d 07 80 00 00 	movabs $0x80071d,%rax
  800c2f:	00 00 00 
  800c32:	ff d0                	callq  *%rax
  800c34:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c38:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c3f:	e9 85 00 00 00       	jmpq   800cc9 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800c44:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4c:	48 89 d6             	mov    %rdx,%rsi
  800c4f:	bf 30 00 00 00       	mov    $0x30,%edi
  800c54:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5e:	48 89 d6             	mov    %rdx,%rsi
  800c61:	bf 78 00 00 00       	mov    $0x78,%edi
  800c66:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6b:	83 f8 30             	cmp    $0x30,%eax
  800c6e:	73 17                	jae    800c87 <vprintfmt+0x45a>
  800c70:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c77:	89 c0                	mov    %eax,%eax
  800c79:	48 01 d0             	add    %rdx,%rax
  800c7c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c7f:	83 c2 08             	add    $0x8,%edx
  800c82:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c85:	eb 0f                	jmp    800c96 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800c87:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c8b:	48 89 d0             	mov    %rdx,%rax
  800c8e:	48 83 c2 08          	add    $0x8,%rdx
  800c92:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c96:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c99:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c9d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ca4:	eb 23                	jmp    800cc9 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ca6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800caa:	be 03 00 00 00       	mov    $0x3,%esi
  800caf:	48 89 c7             	mov    %rax,%rdi
  800cb2:	48 b8 0d 06 80 00 00 	movabs $0x80060d,%rax
  800cb9:	00 00 00 
  800cbc:	ff d0                	callq  *%rax
  800cbe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cc2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc9:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cce:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cd1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cd4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cd8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce0:	45 89 c1             	mov    %r8d,%r9d
  800ce3:	41 89 f8             	mov    %edi,%r8d
  800ce6:	48 89 c7             	mov    %rax,%rdi
  800ce9:	48 b8 52 05 80 00 00 	movabs $0x800552,%rax
  800cf0:	00 00 00 
  800cf3:	ff d0                	callq  *%rax
			break;
  800cf5:	eb 3f                	jmp    800d36 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cf7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cff:	48 89 d6             	mov    %rdx,%rsi
  800d02:	89 df                	mov    %ebx,%edi
  800d04:	ff d0                	callq  *%rax
			break;
  800d06:	eb 2e                	jmp    800d36 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d10:	48 89 d6             	mov    %rdx,%rsi
  800d13:	bf 25 00 00 00       	mov    $0x25,%edi
  800d18:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d1a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d1f:	eb 05                	jmp    800d26 <vprintfmt+0x4f9>
  800d21:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d26:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d2a:	48 83 e8 01          	sub    $0x1,%rax
  800d2e:	0f b6 00             	movzbl (%rax),%eax
  800d31:	3c 25                	cmp    $0x25,%al
  800d33:	75 ec                	jne    800d21 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d35:	90                   	nop
		}
	}
  800d36:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d37:	e9 43 fb ff ff       	jmpq   80087f <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d3c:	48 83 c4 60          	add    $0x60,%rsp
  800d40:	5b                   	pop    %rbx
  800d41:	41 5c                	pop    %r12
  800d43:	5d                   	pop    %rbp
  800d44:	c3                   	retq   

0000000000800d45 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d45:	55                   	push   %rbp
  800d46:	48 89 e5             	mov    %rsp,%rbp
  800d49:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d50:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d57:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d5e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d65:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d6c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d73:	84 c0                	test   %al,%al
  800d75:	74 20                	je     800d97 <printfmt+0x52>
  800d77:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d7b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d7f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d83:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d87:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d8b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d8f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d93:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d97:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d9e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800da5:	00 00 00 
  800da8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800daf:	00 00 00 
  800db2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800db6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dbd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dc4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dcb:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dd2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dd9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800de0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800de7:	48 89 c7             	mov    %rax,%rdi
  800dea:	48 b8 2d 08 80 00 00 	movabs $0x80082d,%rax
  800df1:	00 00 00 
  800df4:	ff d0                	callq  *%rax
	va_end(ap);
}
  800df6:	c9                   	leaveq 
  800df7:	c3                   	retq   

0000000000800df8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800df8:	55                   	push   %rbp
  800df9:	48 89 e5             	mov    %rsp,%rbp
  800dfc:	48 83 ec 10          	sub    $0x10,%rsp
  800e00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0b:	8b 40 10             	mov    0x10(%rax),%eax
  800e0e:	8d 50 01             	lea    0x1(%rax),%edx
  800e11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e15:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1c:	48 8b 10             	mov    (%rax),%rdx
  800e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e23:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e27:	48 39 c2             	cmp    %rax,%rdx
  800e2a:	73 17                	jae    800e43 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e30:	48 8b 00             	mov    (%rax),%rax
  800e33:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e3b:	48 89 0a             	mov    %rcx,(%rdx)
  800e3e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e41:	88 10                	mov    %dl,(%rax)
}
  800e43:	c9                   	leaveq 
  800e44:	c3                   	retq   

0000000000800e45 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e45:	55                   	push   %rbp
  800e46:	48 89 e5             	mov    %rsp,%rbp
  800e49:	48 83 ec 50          	sub    $0x50,%rsp
  800e4d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e51:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e54:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e58:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e5c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e60:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e64:	48 8b 0a             	mov    (%rdx),%rcx
  800e67:	48 89 08             	mov    %rcx,(%rax)
  800e6a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e6e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e72:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e76:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e7a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e7e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e82:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e85:	48 98                	cltq   
  800e87:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e8b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e8f:	48 01 d0             	add    %rdx,%rax
  800e92:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e96:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e9d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ea2:	74 06                	je     800eaa <vsnprintf+0x65>
  800ea4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ea8:	7f 07                	jg     800eb1 <vsnprintf+0x6c>
		return -E_INVAL;
  800eaa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eaf:	eb 2f                	jmp    800ee0 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800eb1:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800eb5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800eb9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ebd:	48 89 c6             	mov    %rax,%rsi
  800ec0:	48 bf f8 0d 80 00 00 	movabs $0x800df8,%rdi
  800ec7:	00 00 00 
  800eca:	48 b8 2d 08 80 00 00 	movabs $0x80082d,%rax
  800ed1:	00 00 00 
  800ed4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ed6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eda:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800edd:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ee0:	c9                   	leaveq 
  800ee1:	c3                   	retq   

0000000000800ee2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ee2:	55                   	push   %rbp
  800ee3:	48 89 e5             	mov    %rsp,%rbp
  800ee6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800eed:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ef4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800efa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f01:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f08:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f0f:	84 c0                	test   %al,%al
  800f11:	74 20                	je     800f33 <snprintf+0x51>
  800f13:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f17:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f1b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f1f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f23:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f27:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f2b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f2f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f33:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f3a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f41:	00 00 00 
  800f44:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f4b:	00 00 00 
  800f4e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f52:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f59:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f60:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f67:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f6e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f75:	48 8b 0a             	mov    (%rdx),%rcx
  800f78:	48 89 08             	mov    %rcx,(%rax)
  800f7b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f7f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f83:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f87:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f8b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f92:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f99:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f9f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fa6:	48 89 c7             	mov    %rax,%rdi
  800fa9:	48 b8 45 0e 80 00 00 	movabs $0x800e45,%rax
  800fb0:	00 00 00 
  800fb3:	ff d0                	callq  *%rax
  800fb5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fbb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fc1:	c9                   	leaveq 
  800fc2:	c3                   	retq   

0000000000800fc3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fc3:	55                   	push   %rbp
  800fc4:	48 89 e5             	mov    %rsp,%rbp
  800fc7:	48 83 ec 18          	sub    $0x18,%rsp
  800fcb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fd6:	eb 09                	jmp    800fe1 <strlen+0x1e>
		n++;
  800fd8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fdc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fe1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe5:	0f b6 00             	movzbl (%rax),%eax
  800fe8:	84 c0                	test   %al,%al
  800fea:	75 ec                	jne    800fd8 <strlen+0x15>
		n++;
	return n;
  800fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fef:	c9                   	leaveq 
  800ff0:	c3                   	retq   

0000000000800ff1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ff1:	55                   	push   %rbp
  800ff2:	48 89 e5             	mov    %rsp,%rbp
  800ff5:	48 83 ec 20          	sub    $0x20,%rsp
  800ff9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ffd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801001:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801008:	eb 0e                	jmp    801018 <strnlen+0x27>
		n++;
  80100a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80100e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801013:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801018:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80101d:	74 0b                	je     80102a <strnlen+0x39>
  80101f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801023:	0f b6 00             	movzbl (%rax),%eax
  801026:	84 c0                	test   %al,%al
  801028:	75 e0                	jne    80100a <strnlen+0x19>
		n++;
	return n;
  80102a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80102d:	c9                   	leaveq 
  80102e:	c3                   	retq   

000000000080102f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80102f:	55                   	push   %rbp
  801030:	48 89 e5             	mov    %rsp,%rbp
  801033:	48 83 ec 20          	sub    $0x20,%rsp
  801037:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80103f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801043:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801047:	90                   	nop
  801048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801050:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801054:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801058:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80105c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801060:	0f b6 12             	movzbl (%rdx),%edx
  801063:	88 10                	mov    %dl,(%rax)
  801065:	0f b6 00             	movzbl (%rax),%eax
  801068:	84 c0                	test   %al,%al
  80106a:	75 dc                	jne    801048 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80106c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801070:	c9                   	leaveq 
  801071:	c3                   	retq   

0000000000801072 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801072:	55                   	push   %rbp
  801073:	48 89 e5             	mov    %rsp,%rbp
  801076:	48 83 ec 20          	sub    $0x20,%rsp
  80107a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801082:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801086:	48 89 c7             	mov    %rax,%rdi
  801089:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  801090:	00 00 00 
  801093:	ff d0                	callq  *%rax
  801095:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80109b:	48 63 d0             	movslq %eax,%rdx
  80109e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a2:	48 01 c2             	add    %rax,%rdx
  8010a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010a9:	48 89 c6             	mov    %rax,%rsi
  8010ac:	48 89 d7             	mov    %rdx,%rdi
  8010af:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  8010b6:	00 00 00 
  8010b9:	ff d0                	callq  *%rax
	return dst;
  8010bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010bf:	c9                   	leaveq 
  8010c0:	c3                   	retq   

00000000008010c1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010c1:	55                   	push   %rbp
  8010c2:	48 89 e5             	mov    %rsp,%rbp
  8010c5:	48 83 ec 28          	sub    $0x28,%rsp
  8010c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010dd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010e4:	00 
  8010e5:	eb 2a                	jmp    801111 <strncpy+0x50>
		*dst++ = *src;
  8010e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010eb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010f3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010f7:	0f b6 12             	movzbl (%rdx),%edx
  8010fa:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801100:	0f b6 00             	movzbl (%rax),%eax
  801103:	84 c0                	test   %al,%al
  801105:	74 05                	je     80110c <strncpy+0x4b>
			src++;
  801107:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80110c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801111:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801115:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801119:	72 cc                	jb     8010e7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80111b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80111f:	c9                   	leaveq 
  801120:	c3                   	retq   

0000000000801121 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801121:	55                   	push   %rbp
  801122:	48 89 e5             	mov    %rsp,%rbp
  801125:	48 83 ec 28          	sub    $0x28,%rsp
  801129:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80112d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801131:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801135:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801139:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80113d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801142:	74 3d                	je     801181 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801144:	eb 1d                	jmp    801163 <strlcpy+0x42>
			*dst++ = *src++;
  801146:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80114e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801152:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801156:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80115a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80115e:	0f b6 12             	movzbl (%rdx),%edx
  801161:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801163:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801168:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80116d:	74 0b                	je     80117a <strlcpy+0x59>
  80116f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801173:	0f b6 00             	movzbl (%rax),%eax
  801176:	84 c0                	test   %al,%al
  801178:	75 cc                	jne    801146 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80117a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801181:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801185:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801189:	48 29 c2             	sub    %rax,%rdx
  80118c:	48 89 d0             	mov    %rdx,%rax
}
  80118f:	c9                   	leaveq 
  801190:	c3                   	retq   

0000000000801191 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801191:	55                   	push   %rbp
  801192:	48 89 e5             	mov    %rsp,%rbp
  801195:	48 83 ec 10          	sub    $0x10,%rsp
  801199:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80119d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011a1:	eb 0a                	jmp    8011ad <strcmp+0x1c>
		p++, q++;
  8011a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011a8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b1:	0f b6 00             	movzbl (%rax),%eax
  8011b4:	84 c0                	test   %al,%al
  8011b6:	74 12                	je     8011ca <strcmp+0x39>
  8011b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bc:	0f b6 10             	movzbl (%rax),%edx
  8011bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c3:	0f b6 00             	movzbl (%rax),%eax
  8011c6:	38 c2                	cmp    %al,%dl
  8011c8:	74 d9                	je     8011a3 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ce:	0f b6 00             	movzbl (%rax),%eax
  8011d1:	0f b6 d0             	movzbl %al,%edx
  8011d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d8:	0f b6 00             	movzbl (%rax),%eax
  8011db:	0f b6 c0             	movzbl %al,%eax
  8011de:	29 c2                	sub    %eax,%edx
  8011e0:	89 d0                	mov    %edx,%eax
}
  8011e2:	c9                   	leaveq 
  8011e3:	c3                   	retq   

00000000008011e4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011e4:	55                   	push   %rbp
  8011e5:	48 89 e5             	mov    %rsp,%rbp
  8011e8:	48 83 ec 18          	sub    $0x18,%rsp
  8011ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011f8:	eb 0f                	jmp    801209 <strncmp+0x25>
		n--, p++, q++;
  8011fa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011ff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801204:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801209:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80120e:	74 1d                	je     80122d <strncmp+0x49>
  801210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801214:	0f b6 00             	movzbl (%rax),%eax
  801217:	84 c0                	test   %al,%al
  801219:	74 12                	je     80122d <strncmp+0x49>
  80121b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121f:	0f b6 10             	movzbl (%rax),%edx
  801222:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801226:	0f b6 00             	movzbl (%rax),%eax
  801229:	38 c2                	cmp    %al,%dl
  80122b:	74 cd                	je     8011fa <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80122d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801232:	75 07                	jne    80123b <strncmp+0x57>
		return 0;
  801234:	b8 00 00 00 00       	mov    $0x0,%eax
  801239:	eb 18                	jmp    801253 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80123b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123f:	0f b6 00             	movzbl (%rax),%eax
  801242:	0f b6 d0             	movzbl %al,%edx
  801245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801249:	0f b6 00             	movzbl (%rax),%eax
  80124c:	0f b6 c0             	movzbl %al,%eax
  80124f:	29 c2                	sub    %eax,%edx
  801251:	89 d0                	mov    %edx,%eax
}
  801253:	c9                   	leaveq 
  801254:	c3                   	retq   

0000000000801255 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801255:	55                   	push   %rbp
  801256:	48 89 e5             	mov    %rsp,%rbp
  801259:	48 83 ec 0c          	sub    $0xc,%rsp
  80125d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801261:	89 f0                	mov    %esi,%eax
  801263:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801266:	eb 17                	jmp    80127f <strchr+0x2a>
		if (*s == c)
  801268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126c:	0f b6 00             	movzbl (%rax),%eax
  80126f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801272:	75 06                	jne    80127a <strchr+0x25>
			return (char *) s;
  801274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801278:	eb 15                	jmp    80128f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80127a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80127f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801283:	0f b6 00             	movzbl (%rax),%eax
  801286:	84 c0                	test   %al,%al
  801288:	75 de                	jne    801268 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80128a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128f:	c9                   	leaveq 
  801290:	c3                   	retq   

0000000000801291 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801291:	55                   	push   %rbp
  801292:	48 89 e5             	mov    %rsp,%rbp
  801295:	48 83 ec 0c          	sub    $0xc,%rsp
  801299:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80129d:	89 f0                	mov    %esi,%eax
  80129f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012a2:	eb 13                	jmp    8012b7 <strfind+0x26>
		if (*s == c)
  8012a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a8:	0f b6 00             	movzbl (%rax),%eax
  8012ab:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012ae:	75 02                	jne    8012b2 <strfind+0x21>
			break;
  8012b0:	eb 10                	jmp    8012c2 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bb:	0f b6 00             	movzbl (%rax),%eax
  8012be:	84 c0                	test   %al,%al
  8012c0:	75 e2                	jne    8012a4 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012c6:	c9                   	leaveq 
  8012c7:	c3                   	retq   

00000000008012c8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012c8:	55                   	push   %rbp
  8012c9:	48 89 e5             	mov    %rsp,%rbp
  8012cc:	48 83 ec 18          	sub    $0x18,%rsp
  8012d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d4:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e0:	75 06                	jne    8012e8 <memset+0x20>
		return v;
  8012e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e6:	eb 69                	jmp    801351 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ec:	83 e0 03             	and    $0x3,%eax
  8012ef:	48 85 c0             	test   %rax,%rax
  8012f2:	75 48                	jne    80133c <memset+0x74>
  8012f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f8:	83 e0 03             	and    $0x3,%eax
  8012fb:	48 85 c0             	test   %rax,%rax
  8012fe:	75 3c                	jne    80133c <memset+0x74>
		c &= 0xFF;
  801300:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801307:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130a:	c1 e0 18             	shl    $0x18,%eax
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801312:	c1 e0 10             	shl    $0x10,%eax
  801315:	09 c2                	or     %eax,%edx
  801317:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80131a:	c1 e0 08             	shl    $0x8,%eax
  80131d:	09 d0                	or     %edx,%eax
  80131f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	48 c1 e8 02          	shr    $0x2,%rax
  80132a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80132d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801331:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801334:	48 89 d7             	mov    %rdx,%rdi
  801337:	fc                   	cld    
  801338:	f3 ab                	rep stos %eax,%es:(%rdi)
  80133a:	eb 11                	jmp    80134d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80133c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801340:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801343:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801347:	48 89 d7             	mov    %rdx,%rdi
  80134a:	fc                   	cld    
  80134b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801351:	c9                   	leaveq 
  801352:	c3                   	retq   

0000000000801353 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801353:	55                   	push   %rbp
  801354:	48 89 e5             	mov    %rsp,%rbp
  801357:	48 83 ec 28          	sub    $0x28,%rsp
  80135b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80135f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801363:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801367:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80136f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801373:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80137f:	0f 83 88 00 00 00    	jae    80140d <memmove+0xba>
  801385:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801389:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80138d:	48 01 d0             	add    %rdx,%rax
  801390:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801394:	76 77                	jbe    80140d <memmove+0xba>
		s += n;
  801396:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80139e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013aa:	83 e0 03             	and    $0x3,%eax
  8013ad:	48 85 c0             	test   %rax,%rax
  8013b0:	75 3b                	jne    8013ed <memmove+0x9a>
  8013b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b6:	83 e0 03             	and    $0x3,%eax
  8013b9:	48 85 c0             	test   %rax,%rax
  8013bc:	75 2f                	jne    8013ed <memmove+0x9a>
  8013be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c2:	83 e0 03             	and    $0x3,%eax
  8013c5:	48 85 c0             	test   %rax,%rax
  8013c8:	75 23                	jne    8013ed <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ce:	48 83 e8 04          	sub    $0x4,%rax
  8013d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d6:	48 83 ea 04          	sub    $0x4,%rdx
  8013da:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013de:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013e2:	48 89 c7             	mov    %rax,%rdi
  8013e5:	48 89 d6             	mov    %rdx,%rsi
  8013e8:	fd                   	std    
  8013e9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013eb:	eb 1d                	jmp    80140a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f9:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801401:	48 89 d7             	mov    %rdx,%rdi
  801404:	48 89 c1             	mov    %rax,%rcx
  801407:	fd                   	std    
  801408:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80140a:	fc                   	cld    
  80140b:	eb 57                	jmp    801464 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80140d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801411:	83 e0 03             	and    $0x3,%eax
  801414:	48 85 c0             	test   %rax,%rax
  801417:	75 36                	jne    80144f <memmove+0xfc>
  801419:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141d:	83 e0 03             	and    $0x3,%eax
  801420:	48 85 c0             	test   %rax,%rax
  801423:	75 2a                	jne    80144f <memmove+0xfc>
  801425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801429:	83 e0 03             	and    $0x3,%eax
  80142c:	48 85 c0             	test   %rax,%rax
  80142f:	75 1e                	jne    80144f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801435:	48 c1 e8 02          	shr    $0x2,%rax
  801439:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80143c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801440:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801444:	48 89 c7             	mov    %rax,%rdi
  801447:	48 89 d6             	mov    %rdx,%rsi
  80144a:	fc                   	cld    
  80144b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80144d:	eb 15                	jmp    801464 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80144f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801453:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801457:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80145b:	48 89 c7             	mov    %rax,%rdi
  80145e:	48 89 d6             	mov    %rdx,%rsi
  801461:	fc                   	cld    
  801462:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801468:	c9                   	leaveq 
  801469:	c3                   	retq   

000000000080146a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80146a:	55                   	push   %rbp
  80146b:	48 89 e5             	mov    %rsp,%rbp
  80146e:	48 83 ec 18          	sub    $0x18,%rsp
  801472:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801476:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80147a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80147e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801482:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148a:	48 89 ce             	mov    %rcx,%rsi
  80148d:	48 89 c7             	mov    %rax,%rdi
  801490:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  801497:	00 00 00 
  80149a:	ff d0                	callq  *%rax
}
  80149c:	c9                   	leaveq 
  80149d:	c3                   	retq   

000000000080149e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80149e:	55                   	push   %rbp
  80149f:	48 89 e5             	mov    %rsp,%rbp
  8014a2:	48 83 ec 28          	sub    $0x28,%rsp
  8014a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014c2:	eb 36                	jmp    8014fa <memcmp+0x5c>
		if (*s1 != *s2)
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	0f b6 10             	movzbl (%rax),%edx
  8014cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cf:	0f b6 00             	movzbl (%rax),%eax
  8014d2:	38 c2                	cmp    %al,%dl
  8014d4:	74 1a                	je     8014f0 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014da:	0f b6 00             	movzbl (%rax),%eax
  8014dd:	0f b6 d0             	movzbl %al,%edx
  8014e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e4:	0f b6 00             	movzbl (%rax),%eax
  8014e7:	0f b6 c0             	movzbl %al,%eax
  8014ea:	29 c2                	sub    %eax,%edx
  8014ec:	89 d0                	mov    %edx,%eax
  8014ee:	eb 20                	jmp    801510 <memcmp+0x72>
		s1++, s2++;
  8014f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014f5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801502:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801506:	48 85 c0             	test   %rax,%rax
  801509:	75 b9                	jne    8014c4 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801510:	c9                   	leaveq 
  801511:	c3                   	retq   

0000000000801512 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801512:	55                   	push   %rbp
  801513:	48 89 e5             	mov    %rsp,%rbp
  801516:	48 83 ec 28          	sub    $0x28,%rsp
  80151a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80151e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801521:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801525:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801529:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80152d:	48 01 d0             	add    %rdx,%rax
  801530:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801534:	eb 15                	jmp    80154b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801536:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153a:	0f b6 10             	movzbl (%rax),%edx
  80153d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801540:	38 c2                	cmp    %al,%dl
  801542:	75 02                	jne    801546 <memfind+0x34>
			break;
  801544:	eb 0f                	jmp    801555 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801546:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80154b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801553:	72 e1                	jb     801536 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801559:	c9                   	leaveq 
  80155a:	c3                   	retq   

000000000080155b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80155b:	55                   	push   %rbp
  80155c:	48 89 e5             	mov    %rsp,%rbp
  80155f:	48 83 ec 34          	sub    $0x34,%rsp
  801563:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801567:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80156b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80156e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801575:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80157c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80157d:	eb 05                	jmp    801584 <strtol+0x29>
		s++;
  80157f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801588:	0f b6 00             	movzbl (%rax),%eax
  80158b:	3c 20                	cmp    $0x20,%al
  80158d:	74 f0                	je     80157f <strtol+0x24>
  80158f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801593:	0f b6 00             	movzbl (%rax),%eax
  801596:	3c 09                	cmp    $0x9,%al
  801598:	74 e5                	je     80157f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80159a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	3c 2b                	cmp    $0x2b,%al
  8015a3:	75 07                	jne    8015ac <strtol+0x51>
		s++;
  8015a5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015aa:	eb 17                	jmp    8015c3 <strtol+0x68>
	else if (*s == '-')
  8015ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b0:	0f b6 00             	movzbl (%rax),%eax
  8015b3:	3c 2d                	cmp    $0x2d,%al
  8015b5:	75 0c                	jne    8015c3 <strtol+0x68>
		s++, neg = 1;
  8015b7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015c7:	74 06                	je     8015cf <strtol+0x74>
  8015c9:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015cd:	75 28                	jne    8015f7 <strtol+0x9c>
  8015cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d3:	0f b6 00             	movzbl (%rax),%eax
  8015d6:	3c 30                	cmp    $0x30,%al
  8015d8:	75 1d                	jne    8015f7 <strtol+0x9c>
  8015da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015de:	48 83 c0 01          	add    $0x1,%rax
  8015e2:	0f b6 00             	movzbl (%rax),%eax
  8015e5:	3c 78                	cmp    $0x78,%al
  8015e7:	75 0e                	jne    8015f7 <strtol+0x9c>
		s += 2, base = 16;
  8015e9:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015ee:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015f5:	eb 2c                	jmp    801623 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015f7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015fb:	75 19                	jne    801616 <strtol+0xbb>
  8015fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801601:	0f b6 00             	movzbl (%rax),%eax
  801604:	3c 30                	cmp    $0x30,%al
  801606:	75 0e                	jne    801616 <strtol+0xbb>
		s++, base = 8;
  801608:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80160d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801614:	eb 0d                	jmp    801623 <strtol+0xc8>
	else if (base == 0)
  801616:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80161a:	75 07                	jne    801623 <strtol+0xc8>
		base = 10;
  80161c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801627:	0f b6 00             	movzbl (%rax),%eax
  80162a:	3c 2f                	cmp    $0x2f,%al
  80162c:	7e 1d                	jle    80164b <strtol+0xf0>
  80162e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801632:	0f b6 00             	movzbl (%rax),%eax
  801635:	3c 39                	cmp    $0x39,%al
  801637:	7f 12                	jg     80164b <strtol+0xf0>
			dig = *s - '0';
  801639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163d:	0f b6 00             	movzbl (%rax),%eax
  801640:	0f be c0             	movsbl %al,%eax
  801643:	83 e8 30             	sub    $0x30,%eax
  801646:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801649:	eb 4e                	jmp    801699 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80164b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164f:	0f b6 00             	movzbl (%rax),%eax
  801652:	3c 60                	cmp    $0x60,%al
  801654:	7e 1d                	jle    801673 <strtol+0x118>
  801656:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165a:	0f b6 00             	movzbl (%rax),%eax
  80165d:	3c 7a                	cmp    $0x7a,%al
  80165f:	7f 12                	jg     801673 <strtol+0x118>
			dig = *s - 'a' + 10;
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	0f b6 00             	movzbl (%rax),%eax
  801668:	0f be c0             	movsbl %al,%eax
  80166b:	83 e8 57             	sub    $0x57,%eax
  80166e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801671:	eb 26                	jmp    801699 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	3c 40                	cmp    $0x40,%al
  80167c:	7e 48                	jle    8016c6 <strtol+0x16b>
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	3c 5a                	cmp    $0x5a,%al
  801687:	7f 3d                	jg     8016c6 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	0f be c0             	movsbl %al,%eax
  801693:	83 e8 37             	sub    $0x37,%eax
  801696:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801699:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80169c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80169f:	7c 02                	jl     8016a3 <strtol+0x148>
			break;
  8016a1:	eb 23                	jmp    8016c6 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016a3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016a8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016ab:	48 98                	cltq   
  8016ad:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016b2:	48 89 c2             	mov    %rax,%rdx
  8016b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016b8:	48 98                	cltq   
  8016ba:	48 01 d0             	add    %rdx,%rax
  8016bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016c1:	e9 5d ff ff ff       	jmpq   801623 <strtol+0xc8>

	if (endptr)
  8016c6:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016cb:	74 0b                	je     8016d8 <strtol+0x17d>
		*endptr = (char *) s;
  8016cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016d1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016d5:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016dc:	74 09                	je     8016e7 <strtol+0x18c>
  8016de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e2:	48 f7 d8             	neg    %rax
  8016e5:	eb 04                	jmp    8016eb <strtol+0x190>
  8016e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016eb:	c9                   	leaveq 
  8016ec:	c3                   	retq   

00000000008016ed <strstr>:

char * strstr(const char *in, const char *str)
{
  8016ed:	55                   	push   %rbp
  8016ee:	48 89 e5             	mov    %rsp,%rbp
  8016f1:	48 83 ec 30          	sub    $0x30,%rsp
  8016f5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016f9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801701:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801705:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801709:	0f b6 00             	movzbl (%rax),%eax
  80170c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80170f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801713:	75 06                	jne    80171b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801719:	eb 6b                	jmp    801786 <strstr+0x99>

	len = strlen(str);
  80171b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80171f:	48 89 c7             	mov    %rax,%rdi
  801722:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  801729:	00 00 00 
  80172c:	ff d0                	callq  *%rax
  80172e:	48 98                	cltq   
  801730:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80173c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801740:	0f b6 00             	movzbl (%rax),%eax
  801743:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801746:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80174a:	75 07                	jne    801753 <strstr+0x66>
				return (char *) 0;
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
  801751:	eb 33                	jmp    801786 <strstr+0x99>
		} while (sc != c);
  801753:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801757:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80175a:	75 d8                	jne    801734 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80175c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801760:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801764:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801768:	48 89 ce             	mov    %rcx,%rsi
  80176b:	48 89 c7             	mov    %rax,%rdi
  80176e:	48 b8 e4 11 80 00 00 	movabs $0x8011e4,%rax
  801775:	00 00 00 
  801778:	ff d0                	callq  *%rax
  80177a:	85 c0                	test   %eax,%eax
  80177c:	75 b6                	jne    801734 <strstr+0x47>

	return (char *) (in - 1);
  80177e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801782:	48 83 e8 01          	sub    $0x1,%rax
}
  801786:	c9                   	leaveq 
  801787:	c3                   	retq   

0000000000801788 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801788:	55                   	push   %rbp
  801789:	48 89 e5             	mov    %rsp,%rbp
  80178c:	53                   	push   %rbx
  80178d:	48 83 ec 48          	sub    $0x48,%rsp
  801791:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801794:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801797:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80179b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80179f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017a3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017aa:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017ae:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017b2:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017b6:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017ba:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017be:	4c 89 c3             	mov    %r8,%rbx
  8017c1:	cd 30                	int    $0x30
  8017c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017cb:	74 3e                	je     80180b <syscall+0x83>
  8017cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017d2:	7e 37                	jle    80180b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017db:	49 89 d0             	mov    %rdx,%r8
  8017de:	89 c1                	mov    %eax,%ecx
  8017e0:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  8017e7:	00 00 00 
  8017ea:	be 23 00 00 00       	mov    $0x23,%esi
  8017ef:	48 bf 45 4e 80 00 00 	movabs $0x804e45,%rdi
  8017f6:	00 00 00 
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fe:	49 b9 a7 45 80 00 00 	movabs $0x8045a7,%r9
  801805:	00 00 00 
  801808:	41 ff d1             	callq  *%r9

	return ret;
  80180b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80180f:	48 83 c4 48          	add    $0x48,%rsp
  801813:	5b                   	pop    %rbx
  801814:	5d                   	pop    %rbp
  801815:	c3                   	retq   

0000000000801816 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801816:	55                   	push   %rbp
  801817:	48 89 e5             	mov    %rsp,%rbp
  80181a:	48 83 ec 20          	sub    $0x20,%rsp
  80181e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801822:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801826:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80182e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801835:	00 
  801836:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80183c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801842:	48 89 d1             	mov    %rdx,%rcx
  801845:	48 89 c2             	mov    %rax,%rdx
  801848:	be 00 00 00 00       	mov    $0x0,%esi
  80184d:	bf 00 00 00 00       	mov    $0x0,%edi
  801852:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801859:	00 00 00 
  80185c:	ff d0                	callq  *%rax
}
  80185e:	c9                   	leaveq 
  80185f:	c3                   	retq   

0000000000801860 <sys_cgetc>:

int
sys_cgetc(void)
{
  801860:	55                   	push   %rbp
  801861:	48 89 e5             	mov    %rsp,%rbp
  801864:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801868:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80186f:	00 
  801870:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801876:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80187c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801881:	ba 00 00 00 00       	mov    $0x0,%edx
  801886:	be 00 00 00 00       	mov    $0x0,%esi
  80188b:	bf 01 00 00 00       	mov    $0x1,%edi
  801890:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801897:	00 00 00 
  80189a:	ff d0                	callq  *%rax
}
  80189c:	c9                   	leaveq 
  80189d:	c3                   	retq   

000000000080189e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80189e:	55                   	push   %rbp
  80189f:	48 89 e5             	mov    %rsp,%rbp
  8018a2:	48 83 ec 10          	sub    $0x10,%rsp
  8018a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ac:	48 98                	cltq   
  8018ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b5:	00 
  8018b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c7:	48 89 c2             	mov    %rax,%rdx
  8018ca:	be 01 00 00 00       	mov    $0x1,%esi
  8018cf:	bf 03 00 00 00       	mov    $0x3,%edi
  8018d4:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  8018db:	00 00 00 
  8018de:	ff d0                	callq  *%rax
}
  8018e0:	c9                   	leaveq 
  8018e1:	c3                   	retq   

00000000008018e2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018e2:	55                   	push   %rbp
  8018e3:	48 89 e5             	mov    %rsp,%rbp
  8018e6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f1:	00 
  8018f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801903:	ba 00 00 00 00       	mov    $0x0,%edx
  801908:	be 00 00 00 00       	mov    $0x0,%esi
  80190d:	bf 02 00 00 00       	mov    $0x2,%edi
  801912:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801919:	00 00 00 
  80191c:	ff d0                	callq  *%rax
}
  80191e:	c9                   	leaveq 
  80191f:	c3                   	retq   

0000000000801920 <sys_yield>:

void
sys_yield(void)
{
  801920:	55                   	push   %rbp
  801921:	48 89 e5             	mov    %rsp,%rbp
  801924:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801928:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80192f:	00 
  801930:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801936:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80193c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801941:	ba 00 00 00 00       	mov    $0x0,%edx
  801946:	be 00 00 00 00       	mov    $0x0,%esi
  80194b:	bf 0b 00 00 00       	mov    $0xb,%edi
  801950:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801957:	00 00 00 
  80195a:	ff d0                	callq  *%rax
}
  80195c:	c9                   	leaveq 
  80195d:	c3                   	retq   

000000000080195e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80195e:	55                   	push   %rbp
  80195f:	48 89 e5             	mov    %rsp,%rbp
  801962:	48 83 ec 20          	sub    $0x20,%rsp
  801966:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801969:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80196d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801970:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801973:	48 63 c8             	movslq %eax,%rcx
  801976:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80197a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197d:	48 98                	cltq   
  80197f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801986:	00 
  801987:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198d:	49 89 c8             	mov    %rcx,%r8
  801990:	48 89 d1             	mov    %rdx,%rcx
  801993:	48 89 c2             	mov    %rax,%rdx
  801996:	be 01 00 00 00       	mov    $0x1,%esi
  80199b:	bf 04 00 00 00       	mov    $0x4,%edi
  8019a0:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  8019a7:	00 00 00 
  8019aa:	ff d0                	callq  *%rax
}
  8019ac:	c9                   	leaveq 
  8019ad:	c3                   	retq   

00000000008019ae <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019ae:	55                   	push   %rbp
  8019af:	48 89 e5             	mov    %rsp,%rbp
  8019b2:	48 83 ec 30          	sub    $0x30,%rsp
  8019b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019bd:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019c0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019c4:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019c8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019cb:	48 63 c8             	movslq %eax,%rcx
  8019ce:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019d5:	48 63 f0             	movslq %eax,%rsi
  8019d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019df:	48 98                	cltq   
  8019e1:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019e5:	49 89 f9             	mov    %rdi,%r9
  8019e8:	49 89 f0             	mov    %rsi,%r8
  8019eb:	48 89 d1             	mov    %rdx,%rcx
  8019ee:	48 89 c2             	mov    %rax,%rdx
  8019f1:	be 01 00 00 00       	mov    $0x1,%esi
  8019f6:	bf 05 00 00 00       	mov    $0x5,%edi
  8019fb:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801a02:	00 00 00 
  801a05:	ff d0                	callq  *%rax
}
  801a07:	c9                   	leaveq 
  801a08:	c3                   	retq   

0000000000801a09 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a09:	55                   	push   %rbp
  801a0a:	48 89 e5             	mov    %rsp,%rbp
  801a0d:	48 83 ec 20          	sub    $0x20,%rsp
  801a11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a1f:	48 98                	cltq   
  801a21:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a28:	00 
  801a29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a35:	48 89 d1             	mov    %rdx,%rcx
  801a38:	48 89 c2             	mov    %rax,%rdx
  801a3b:	be 01 00 00 00       	mov    $0x1,%esi
  801a40:	bf 06 00 00 00       	mov    $0x6,%edi
  801a45:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801a4c:	00 00 00 
  801a4f:	ff d0                	callq  *%rax
}
  801a51:	c9                   	leaveq 
  801a52:	c3                   	retq   

0000000000801a53 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a53:	55                   	push   %rbp
  801a54:	48 89 e5             	mov    %rsp,%rbp
  801a57:	48 83 ec 10          	sub    $0x10,%rsp
  801a5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a5e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a64:	48 63 d0             	movslq %eax,%rdx
  801a67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6a:	48 98                	cltq   
  801a6c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a73:	00 
  801a74:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a80:	48 89 d1             	mov    %rdx,%rcx
  801a83:	48 89 c2             	mov    %rax,%rdx
  801a86:	be 01 00 00 00       	mov    $0x1,%esi
  801a8b:	bf 08 00 00 00       	mov    $0x8,%edi
  801a90:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801a97:	00 00 00 
  801a9a:	ff d0                	callq  *%rax
}
  801a9c:	c9                   	leaveq 
  801a9d:	c3                   	retq   

0000000000801a9e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a9e:	55                   	push   %rbp
  801a9f:	48 89 e5             	mov    %rsp,%rbp
  801aa2:	48 83 ec 20          	sub    $0x20,%rsp
  801aa6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801aad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab4:	48 98                	cltq   
  801ab6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801abd:	00 
  801abe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aca:	48 89 d1             	mov    %rdx,%rcx
  801acd:	48 89 c2             	mov    %rax,%rdx
  801ad0:	be 01 00 00 00       	mov    $0x1,%esi
  801ad5:	bf 09 00 00 00       	mov    $0x9,%edi
  801ada:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801ae1:	00 00 00 
  801ae4:	ff d0                	callq  *%rax
}
  801ae6:	c9                   	leaveq 
  801ae7:	c3                   	retq   

0000000000801ae8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ae8:	55                   	push   %rbp
  801ae9:	48 89 e5             	mov    %rsp,%rbp
  801aec:	48 83 ec 20          	sub    $0x20,%rsp
  801af0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801af7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801afe:	48 98                	cltq   
  801b00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b07:	00 
  801b08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b14:	48 89 d1             	mov    %rdx,%rcx
  801b17:	48 89 c2             	mov    %rax,%rdx
  801b1a:	be 01 00 00 00       	mov    $0x1,%esi
  801b1f:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b24:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801b2b:	00 00 00 
  801b2e:	ff d0                	callq  *%rax
}
  801b30:	c9                   	leaveq 
  801b31:	c3                   	retq   

0000000000801b32 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b32:	55                   	push   %rbp
  801b33:	48 89 e5             	mov    %rsp,%rbp
  801b36:	48 83 ec 20          	sub    $0x20,%rsp
  801b3a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b41:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b45:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b48:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b4b:	48 63 f0             	movslq %eax,%rsi
  801b4e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b55:	48 98                	cltq   
  801b57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b62:	00 
  801b63:	49 89 f1             	mov    %rsi,%r9
  801b66:	49 89 c8             	mov    %rcx,%r8
  801b69:	48 89 d1             	mov    %rdx,%rcx
  801b6c:	48 89 c2             	mov    %rax,%rdx
  801b6f:	be 00 00 00 00       	mov    $0x0,%esi
  801b74:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b79:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801b80:	00 00 00 
  801b83:	ff d0                	callq  *%rax
}
  801b85:	c9                   	leaveq 
  801b86:	c3                   	retq   

0000000000801b87 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b87:	55                   	push   %rbp
  801b88:	48 89 e5             	mov    %rsp,%rbp
  801b8b:	48 83 ec 10          	sub    $0x10,%rsp
  801b8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b97:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b9e:	00 
  801b9f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bab:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb0:	48 89 c2             	mov    %rax,%rdx
  801bb3:	be 01 00 00 00       	mov    $0x1,%esi
  801bb8:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bbd:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801bc4:	00 00 00 
  801bc7:	ff d0                	callq  *%rax
}
  801bc9:	c9                   	leaveq 
  801bca:	c3                   	retq   

0000000000801bcb <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801bcb:	55                   	push   %rbp
  801bcc:	48 89 e5             	mov    %rsp,%rbp
  801bcf:	48 83 ec 20          	sub    $0x20,%rsp
  801bd3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801bdb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bea:	00 
  801beb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf7:	48 89 d1             	mov    %rdx,%rcx
  801bfa:	48 89 c2             	mov    %rax,%rdx
  801bfd:	be 01 00 00 00       	mov    $0x1,%esi
  801c02:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c07:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801c0e:	00 00 00 
  801c11:	ff d0                	callq  *%rax
}
  801c13:	c9                   	leaveq 
  801c14:	c3                   	retq   

0000000000801c15 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801c15:	55                   	push   %rbp
  801c16:	48 89 e5             	mov    %rsp,%rbp
  801c19:	48 83 ec 10          	sub    $0x10,%rsp
  801c1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801c21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c2c:	00 
  801c2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c39:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c3e:	48 89 c2             	mov    %rax,%rdx
  801c41:	be 00 00 00 00       	mov    $0x0,%esi
  801c46:	bf 10 00 00 00       	mov    $0x10,%edi
  801c4b:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801c52:	00 00 00 
  801c55:	ff d0                	callq  *%rax
}
  801c57:	c9                   	leaveq 
  801c58:	c3                   	retq   

0000000000801c59 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801c59:	55                   	push   %rbp
  801c5a:	48 89 e5             	mov    %rsp,%rbp
  801c5d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c61:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c68:	00 
  801c69:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c75:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c7f:	be 00 00 00 00       	mov    $0x0,%esi
  801c84:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c89:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801c90:	00 00 00 
  801c93:	ff d0                	callq  *%rax
}
  801c95:	c9                   	leaveq 
  801c96:	c3                   	retq   

0000000000801c97 <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  801c97:	55                   	push   %rbp
  801c98:	48 89 e5             	mov    %rsp,%rbp
  801c9b:	48 83 ec 30          	sub    $0x30,%rsp
  801c9f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801ca3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca7:	48 8b 00             	mov    (%rax),%rax
  801caa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801cae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb2:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cb6:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  801cb9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cbc:	83 e0 02             	and    $0x2,%eax
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	75 4d                	jne    801d10 <pgfault+0x79>
  801cc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc7:	48 c1 e8 0c          	shr    $0xc,%rax
  801ccb:	48 89 c2             	mov    %rax,%rdx
  801cce:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cd5:	01 00 00 
  801cd8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cdc:	25 00 08 00 00       	and    $0x800,%eax
  801ce1:	48 85 c0             	test   %rax,%rax
  801ce4:	74 2a                	je     801d10 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  801ce6:	48 ba 58 4e 80 00 00 	movabs $0x804e58,%rdx
  801ced:	00 00 00 
  801cf0:	be 23 00 00 00       	mov    $0x23,%esi
  801cf5:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801cfc:	00 00 00 
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax
  801d04:	48 b9 a7 45 80 00 00 	movabs $0x8045a7,%rcx
  801d0b:	00 00 00 
  801d0e:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  801d10:	ba 07 00 00 00       	mov    $0x7,%edx
  801d15:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1f:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  801d26:	00 00 00 
  801d29:	ff d0                	callq  *%rax
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	0f 85 cd 00 00 00    	jne    801e00 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  801d33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d37:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801d3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d3f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d45:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  801d49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d4d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d52:	48 89 c6             	mov    %rax,%rsi
  801d55:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d5a:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  801d61:	00 00 00 
  801d64:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  801d66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d6a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d70:	48 89 c1             	mov    %rax,%rcx
  801d73:	ba 00 00 00 00       	mov    $0x0,%edx
  801d78:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d82:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801d89:	00 00 00 
  801d8c:	ff d0                	callq  *%rax
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	79 2a                	jns    801dbc <pgfault+0x125>
				panic("Page map at temp address failed");
  801d92:	48 ba 98 4e 80 00 00 	movabs $0x804e98,%rdx
  801d99:	00 00 00 
  801d9c:	be 30 00 00 00       	mov    $0x30,%esi
  801da1:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801da8:	00 00 00 
  801dab:	b8 00 00 00 00       	mov    $0x0,%eax
  801db0:	48 b9 a7 45 80 00 00 	movabs $0x8045a7,%rcx
  801db7:	00 00 00 
  801dba:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  801dbc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801dc1:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc6:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  801dcd:	00 00 00 
  801dd0:	ff d0                	callq  *%rax
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	79 54                	jns    801e2a <pgfault+0x193>
				panic("Page unmap from temp location failed");
  801dd6:	48 ba b8 4e 80 00 00 	movabs $0x804eb8,%rdx
  801ddd:	00 00 00 
  801de0:	be 32 00 00 00       	mov    $0x32,%esi
  801de5:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801dec:	00 00 00 
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
  801df4:	48 b9 a7 45 80 00 00 	movabs $0x8045a7,%rcx
  801dfb:	00 00 00 
  801dfe:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  801e00:	48 ba e0 4e 80 00 00 	movabs $0x804ee0,%rdx
  801e07:	00 00 00 
  801e0a:	be 34 00 00 00       	mov    $0x34,%esi
  801e0f:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801e16:	00 00 00 
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1e:	48 b9 a7 45 80 00 00 	movabs $0x8045a7,%rcx
  801e25:	00 00 00 
  801e28:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  801e2a:	c9                   	leaveq 
  801e2b:	c3                   	retq   

0000000000801e2c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e2c:	55                   	push   %rbp
  801e2d:	48 89 e5             	mov    %rsp,%rbp
  801e30:	48 83 ec 20          	sub    $0x20,%rsp
  801e34:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e37:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  801e3a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e41:	01 00 00 
  801e44:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e47:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e4b:	25 07 0e 00 00       	and    $0xe07,%eax
  801e50:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  801e53:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e56:	48 c1 e0 0c          	shl    $0xc,%rax
  801e5a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  801e5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e61:	25 00 04 00 00       	and    $0x400,%eax
  801e66:	85 c0                	test   %eax,%eax
  801e68:	74 57                	je     801ec1 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801e6a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801e6d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e71:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e78:	41 89 f0             	mov    %esi,%r8d
  801e7b:	48 89 c6             	mov    %rax,%rsi
  801e7e:	bf 00 00 00 00       	mov    $0x0,%edi
  801e83:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801e8a:	00 00 00 
  801e8d:	ff d0                	callq  *%rax
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	0f 8e 52 01 00 00    	jle    801fe9 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801e97:	48 ba 12 4f 80 00 00 	movabs $0x804f12,%rdx
  801e9e:	00 00 00 
  801ea1:	be 4e 00 00 00       	mov    $0x4e,%esi
  801ea6:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801ead:	00 00 00 
  801eb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb5:	48 b9 a7 45 80 00 00 	movabs $0x8045a7,%rcx
  801ebc:	00 00 00 
  801ebf:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  801ec1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec4:	83 e0 02             	and    $0x2,%eax
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	75 10                	jne    801edb <duppage+0xaf>
  801ecb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ece:	25 00 08 00 00       	and    $0x800,%eax
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	0f 84 bb 00 00 00    	je     801f96 <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  801edb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ede:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  801ee3:	80 cc 08             	or     $0x8,%ah
  801ee6:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801ee9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801eec:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ef0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ef3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef7:	41 89 f0             	mov    %esi,%r8d
  801efa:	48 89 c6             	mov    %rax,%rsi
  801efd:	bf 00 00 00 00       	mov    $0x0,%edi
  801f02:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801f09:	00 00 00 
  801f0c:	ff d0                	callq  *%rax
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	7e 2a                	jle    801f3c <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  801f12:	48 ba 12 4f 80 00 00 	movabs $0x804f12,%rdx
  801f19:	00 00 00 
  801f1c:	be 55 00 00 00       	mov    $0x55,%esi
  801f21:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801f28:	00 00 00 
  801f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f30:	48 b9 a7 45 80 00 00 	movabs $0x8045a7,%rcx
  801f37:	00 00 00 
  801f3a:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f3c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f47:	41 89 c8             	mov    %ecx,%r8d
  801f4a:	48 89 d1             	mov    %rdx,%rcx
  801f4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f52:	48 89 c6             	mov    %rax,%rsi
  801f55:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5a:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801f61:	00 00 00 
  801f64:	ff d0                	callq  *%rax
  801f66:	85 c0                	test   %eax,%eax
  801f68:	7e 2a                	jle    801f94 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  801f6a:	48 ba 12 4f 80 00 00 	movabs $0x804f12,%rdx
  801f71:	00 00 00 
  801f74:	be 57 00 00 00       	mov    $0x57,%esi
  801f79:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801f80:	00 00 00 
  801f83:	b8 00 00 00 00       	mov    $0x0,%eax
  801f88:	48 b9 a7 45 80 00 00 	movabs $0x8045a7,%rcx
  801f8f:	00 00 00 
  801f92:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  801f94:	eb 53                	jmp    801fe9 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  801f96:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801f99:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801f9d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa4:	41 89 f0             	mov    %esi,%r8d
  801fa7:	48 89 c6             	mov    %rax,%rsi
  801faa:	bf 00 00 00 00       	mov    $0x0,%edi
  801faf:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801fb6:	00 00 00 
  801fb9:	ff d0                	callq  *%rax
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	7e 2a                	jle    801fe9 <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  801fbf:	48 ba 12 4f 80 00 00 	movabs $0x804f12,%rdx
  801fc6:	00 00 00 
  801fc9:	be 5b 00 00 00       	mov    $0x5b,%esi
  801fce:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  801fd5:	00 00 00 
  801fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdd:	48 b9 a7 45 80 00 00 	movabs $0x8045a7,%rcx
  801fe4:	00 00 00 
  801fe7:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fee:	c9                   	leaveq 
  801fef:	c3                   	retq   

0000000000801ff0 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  801ff0:	55                   	push   %rbp
  801ff1:	48 89 e5             	mov    %rsp,%rbp
  801ff4:	48 83 ec 18          	sub    $0x18,%rsp
  801ff8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  801ffc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802000:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802004:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802008:	48 c1 e8 27          	shr    $0x27,%rax
  80200c:	48 89 c2             	mov    %rax,%rdx
  80200f:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802016:	01 00 00 
  802019:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80201d:	83 e0 01             	and    $0x1,%eax
  802020:	48 85 c0             	test   %rax,%rax
  802023:	74 51                	je     802076 <pt_is_mapped+0x86>
  802025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802029:	48 c1 e0 0c          	shl    $0xc,%rax
  80202d:	48 c1 e8 1e          	shr    $0x1e,%rax
  802031:	48 89 c2             	mov    %rax,%rdx
  802034:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80203b:	01 00 00 
  80203e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802042:	83 e0 01             	and    $0x1,%eax
  802045:	48 85 c0             	test   %rax,%rax
  802048:	74 2c                	je     802076 <pt_is_mapped+0x86>
  80204a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204e:	48 c1 e0 0c          	shl    $0xc,%rax
  802052:	48 c1 e8 15          	shr    $0x15,%rax
  802056:	48 89 c2             	mov    %rax,%rdx
  802059:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802060:	01 00 00 
  802063:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802067:	83 e0 01             	and    $0x1,%eax
  80206a:	48 85 c0             	test   %rax,%rax
  80206d:	74 07                	je     802076 <pt_is_mapped+0x86>
  80206f:	b8 01 00 00 00       	mov    $0x1,%eax
  802074:	eb 05                	jmp    80207b <pt_is_mapped+0x8b>
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
  80207b:	83 e0 01             	and    $0x1,%eax
}
  80207e:	c9                   	leaveq 
  80207f:	c3                   	retq   

0000000000802080 <fork>:

envid_t
fork(void)
{
  802080:	55                   	push   %rbp
  802081:	48 89 e5             	mov    %rsp,%rbp
  802084:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  802088:	48 bf 97 1c 80 00 00 	movabs $0x801c97,%rdi
  80208f:	00 00 00 
  802092:	48 b8 bb 46 80 00 00 	movabs $0x8046bb,%rax
  802099:	00 00 00 
  80209c:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80209e:	b8 07 00 00 00       	mov    $0x7,%eax
  8020a3:	cd 30                	int    $0x30
  8020a5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8020a8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8020ab:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8020ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020b2:	79 30                	jns    8020e4 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8020b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020b7:	89 c1                	mov    %eax,%ecx
  8020b9:	48 ba 30 4f 80 00 00 	movabs $0x804f30,%rdx
  8020c0:	00 00 00 
  8020c3:	be 86 00 00 00       	mov    $0x86,%esi
  8020c8:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  8020cf:	00 00 00 
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d7:	49 b8 a7 45 80 00 00 	movabs $0x8045a7,%r8
  8020de:	00 00 00 
  8020e1:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8020e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020e8:	75 46                	jne    802130 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8020ea:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  8020f1:	00 00 00 
  8020f4:	ff d0                	callq  *%rax
  8020f6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8020fb:	48 63 d0             	movslq %eax,%rdx
  8020fe:	48 89 d0             	mov    %rdx,%rax
  802101:	48 c1 e0 03          	shl    $0x3,%rax
  802105:	48 01 d0             	add    %rdx,%rax
  802108:	48 c1 e0 05          	shl    $0x5,%rax
  80210c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802113:	00 00 00 
  802116:	48 01 c2             	add    %rax,%rdx
  802119:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802120:	00 00 00 
  802123:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802126:	b8 00 00 00 00       	mov    $0x0,%eax
  80212b:	e9 d1 01 00 00       	jmpq   802301 <fork+0x281>
	}
	uint64_t ad = 0;
  802130:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802137:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802138:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  80213d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802141:	e9 df 00 00 00       	jmpq   802225 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80214a:	48 c1 e8 27          	shr    $0x27,%rax
  80214e:	48 89 c2             	mov    %rax,%rdx
  802151:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802158:	01 00 00 
  80215b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215f:	83 e0 01             	and    $0x1,%eax
  802162:	48 85 c0             	test   %rax,%rax
  802165:	0f 84 9e 00 00 00    	je     802209 <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  80216b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80216f:	48 c1 e8 1e          	shr    $0x1e,%rax
  802173:	48 89 c2             	mov    %rax,%rdx
  802176:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80217d:	01 00 00 
  802180:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802184:	83 e0 01             	and    $0x1,%eax
  802187:	48 85 c0             	test   %rax,%rax
  80218a:	74 73                	je     8021ff <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  80218c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802190:	48 c1 e8 15          	shr    $0x15,%rax
  802194:	48 89 c2             	mov    %rax,%rdx
  802197:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80219e:	01 00 00 
  8021a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a5:	83 e0 01             	and    $0x1,%eax
  8021a8:	48 85 c0             	test   %rax,%rax
  8021ab:	74 48                	je     8021f5 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  8021ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021b1:	48 c1 e8 0c          	shr    $0xc,%rax
  8021b5:	48 89 c2             	mov    %rax,%rdx
  8021b8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021bf:	01 00 00 
  8021c2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8021ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ce:	83 e0 01             	and    $0x1,%eax
  8021d1:	48 85 c0             	test   %rax,%rax
  8021d4:	74 47                	je     80221d <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  8021d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021da:	48 c1 e8 0c          	shr    $0xc,%rax
  8021de:	89 c2                	mov    %eax,%edx
  8021e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8021e3:	89 d6                	mov    %edx,%esi
  8021e5:	89 c7                	mov    %eax,%edi
  8021e7:	48 b8 2c 1e 80 00 00 	movabs $0x801e2c,%rax
  8021ee:	00 00 00 
  8021f1:	ff d0                	callq  *%rax
  8021f3:	eb 28                	jmp    80221d <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  8021f5:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  8021fc:	00 
  8021fd:	eb 1e                	jmp    80221d <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  8021ff:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802206:	40 
  802207:	eb 14                	jmp    80221d <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802209:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80220d:	48 c1 e8 27          	shr    $0x27,%rax
  802211:	48 83 c0 01          	add    $0x1,%rax
  802215:	48 c1 e0 27          	shl    $0x27,%rax
  802219:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  80221d:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802224:	00 
  802225:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  80222c:	00 
  80222d:	0f 87 13 ff ff ff    	ja     802146 <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802233:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802236:	ba 07 00 00 00       	mov    $0x7,%edx
  80223b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802240:	89 c7                	mov    %eax,%edi
  802242:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  802249:	00 00 00 
  80224c:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  80224e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802251:	ba 07 00 00 00       	mov    $0x7,%edx
  802256:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80225b:	89 c7                	mov    %eax,%edi
  80225d:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  802264:	00 00 00 
  802267:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802269:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80226c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802272:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802277:	ba 00 00 00 00       	mov    $0x0,%edx
  80227c:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802281:	89 c7                	mov    %eax,%edi
  802283:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  80228a:	00 00 00 
  80228d:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  80228f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802294:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802299:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80229e:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  8022a5:	00 00 00 
  8022a8:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  8022aa:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8022af:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b4:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  8022bb:	00 00 00 
  8022be:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  8022c0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8022c7:	00 00 00 
  8022ca:	48 8b 00             	mov    (%rax),%rax
  8022cd:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8022d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022d7:	48 89 d6             	mov    %rdx,%rsi
  8022da:	89 c7                	mov    %eax,%edi
  8022dc:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  8022e3:	00 00 00 
  8022e6:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  8022e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8022eb:	be 02 00 00 00       	mov    $0x2,%esi
  8022f0:	89 c7                	mov    %eax,%edi
  8022f2:	48 b8 53 1a 80 00 00 	movabs $0x801a53,%rax
  8022f9:	00 00 00 
  8022fc:	ff d0                	callq  *%rax

	return envid;
  8022fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802301:	c9                   	leaveq 
  802302:	c3                   	retq   

0000000000802303 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802303:	55                   	push   %rbp
  802304:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802307:	48 ba 48 4f 80 00 00 	movabs $0x804f48,%rdx
  80230e:	00 00 00 
  802311:	be bf 00 00 00       	mov    $0xbf,%esi
  802316:	48 bf 8d 4e 80 00 00 	movabs $0x804e8d,%rdi
  80231d:	00 00 00 
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
  802325:	48 b9 a7 45 80 00 00 	movabs $0x8045a7,%rcx
  80232c:	00 00 00 
  80232f:	ff d1                	callq  *%rcx

0000000000802331 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802331:	55                   	push   %rbp
  802332:	48 89 e5             	mov    %rsp,%rbp
  802335:	48 83 ec 30          	sub    $0x30,%rsp
  802339:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80233d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802341:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802345:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80234c:	00 00 00 
  80234f:	48 8b 00             	mov    (%rax),%rax
  802352:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  802358:	85 c0                	test   %eax,%eax
  80235a:	75 3c                	jne    802398 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  80235c:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  802363:	00 00 00 
  802366:	ff d0                	callq  *%rax
  802368:	25 ff 03 00 00       	and    $0x3ff,%eax
  80236d:	48 63 d0             	movslq %eax,%rdx
  802370:	48 89 d0             	mov    %rdx,%rax
  802373:	48 c1 e0 03          	shl    $0x3,%rax
  802377:	48 01 d0             	add    %rdx,%rax
  80237a:	48 c1 e0 05          	shl    $0x5,%rax
  80237e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802385:	00 00 00 
  802388:	48 01 c2             	add    %rax,%rdx
  80238b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802392:	00 00 00 
  802395:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  802398:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80239d:	75 0e                	jne    8023ad <ipc_recv+0x7c>
		pg = (void*) UTOP;
  80239f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023a6:	00 00 00 
  8023a9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  8023ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b1:	48 89 c7             	mov    %rax,%rdi
  8023b4:	48 b8 87 1b 80 00 00 	movabs $0x801b87,%rax
  8023bb:	00 00 00 
  8023be:	ff d0                	callq  *%rax
  8023c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  8023c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c7:	79 19                	jns    8023e2 <ipc_recv+0xb1>
		*from_env_store = 0;
  8023c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023cd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  8023d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023d7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  8023dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e0:	eb 53                	jmp    802435 <ipc_recv+0x104>
	}
	if(from_env_store)
  8023e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8023e7:	74 19                	je     802402 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  8023e9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023f0:	00 00 00 
  8023f3:	48 8b 00             	mov    (%rax),%rax
  8023f6:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8023fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802400:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802402:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802407:	74 19                	je     802422 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  802409:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802410:	00 00 00 
  802413:	48 8b 00             	mov    (%rax),%rax
  802416:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80241c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802420:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802422:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802429:	00 00 00 
  80242c:	48 8b 00             	mov    (%rax),%rax
  80242f:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802435:	c9                   	leaveq 
  802436:	c3                   	retq   

0000000000802437 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802437:	55                   	push   %rbp
  802438:	48 89 e5             	mov    %rsp,%rbp
  80243b:	48 83 ec 30          	sub    $0x30,%rsp
  80243f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802442:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802445:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802449:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  80244c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802451:	75 0e                	jne    802461 <ipc_send+0x2a>
		pg = (void*)UTOP;
  802453:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80245a:	00 00 00 
  80245d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  802461:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802464:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802467:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80246b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80246e:	89 c7                	mov    %eax,%edi
  802470:	48 b8 32 1b 80 00 00 	movabs $0x801b32,%rax
  802477:	00 00 00 
  80247a:	ff d0                	callq  *%rax
  80247c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80247f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802483:	75 0c                	jne    802491 <ipc_send+0x5a>
			sys_yield();
  802485:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  80248c:	00 00 00 
  80248f:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802491:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802495:	74 ca                	je     802461 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  802497:	c9                   	leaveq 
  802498:	c3                   	retq   

0000000000802499 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802499:	55                   	push   %rbp
  80249a:	48 89 e5             	mov    %rsp,%rbp
  80249d:	48 83 ec 14          	sub    $0x14,%rsp
  8024a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8024a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024ab:	eb 5e                	jmp    80250b <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8024ad:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8024b4:	00 00 00 
  8024b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ba:	48 63 d0             	movslq %eax,%rdx
  8024bd:	48 89 d0             	mov    %rdx,%rax
  8024c0:	48 c1 e0 03          	shl    $0x3,%rax
  8024c4:	48 01 d0             	add    %rdx,%rax
  8024c7:	48 c1 e0 05          	shl    $0x5,%rax
  8024cb:	48 01 c8             	add    %rcx,%rax
  8024ce:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8024d4:	8b 00                	mov    (%rax),%eax
  8024d6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024d9:	75 2c                	jne    802507 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8024db:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8024e2:	00 00 00 
  8024e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e8:	48 63 d0             	movslq %eax,%rdx
  8024eb:	48 89 d0             	mov    %rdx,%rax
  8024ee:	48 c1 e0 03          	shl    $0x3,%rax
  8024f2:	48 01 d0             	add    %rdx,%rax
  8024f5:	48 c1 e0 05          	shl    $0x5,%rax
  8024f9:	48 01 c8             	add    %rcx,%rax
  8024fc:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802502:	8b 40 08             	mov    0x8(%rax),%eax
  802505:	eb 12                	jmp    802519 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802507:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80250b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802512:	7e 99                	jle    8024ad <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802514:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802519:	c9                   	leaveq 
  80251a:	c3                   	retq   

000000000080251b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80251b:	55                   	push   %rbp
  80251c:	48 89 e5             	mov    %rsp,%rbp
  80251f:	48 83 ec 08          	sub    $0x8,%rsp
  802523:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802527:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80252b:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802532:	ff ff ff 
  802535:	48 01 d0             	add    %rdx,%rax
  802538:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80253c:	c9                   	leaveq 
  80253d:	c3                   	retq   

000000000080253e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80253e:	55                   	push   %rbp
  80253f:	48 89 e5             	mov    %rsp,%rbp
  802542:	48 83 ec 08          	sub    $0x8,%rsp
  802546:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80254a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254e:	48 89 c7             	mov    %rax,%rdi
  802551:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  802558:	00 00 00 
  80255b:	ff d0                	callq  *%rax
  80255d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802563:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802567:	c9                   	leaveq 
  802568:	c3                   	retq   

0000000000802569 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802569:	55                   	push   %rbp
  80256a:	48 89 e5             	mov    %rsp,%rbp
  80256d:	48 83 ec 18          	sub    $0x18,%rsp
  802571:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802575:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80257c:	eb 6b                	jmp    8025e9 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80257e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802581:	48 98                	cltq   
  802583:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802589:	48 c1 e0 0c          	shl    $0xc,%rax
  80258d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802591:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802595:	48 c1 e8 15          	shr    $0x15,%rax
  802599:	48 89 c2             	mov    %rax,%rdx
  80259c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025a3:	01 00 00 
  8025a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025aa:	83 e0 01             	and    $0x1,%eax
  8025ad:	48 85 c0             	test   %rax,%rax
  8025b0:	74 21                	je     8025d3 <fd_alloc+0x6a>
  8025b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b6:	48 c1 e8 0c          	shr    $0xc,%rax
  8025ba:	48 89 c2             	mov    %rax,%rdx
  8025bd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025c4:	01 00 00 
  8025c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025cb:	83 e0 01             	and    $0x1,%eax
  8025ce:	48 85 c0             	test   %rax,%rax
  8025d1:	75 12                	jne    8025e5 <fd_alloc+0x7c>
			*fd_store = fd;
  8025d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025db:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025de:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e3:	eb 1a                	jmp    8025ff <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025e9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025ed:	7e 8f                	jle    80257e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8025ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025fa:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025ff:	c9                   	leaveq 
  802600:	c3                   	retq   

0000000000802601 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802601:	55                   	push   %rbp
  802602:	48 89 e5             	mov    %rsp,%rbp
  802605:	48 83 ec 20          	sub    $0x20,%rsp
  802609:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80260c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802610:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802614:	78 06                	js     80261c <fd_lookup+0x1b>
  802616:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80261a:	7e 07                	jle    802623 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80261c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802621:	eb 6c                	jmp    80268f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802623:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802626:	48 98                	cltq   
  802628:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80262e:	48 c1 e0 0c          	shl    $0xc,%rax
  802632:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802636:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80263a:	48 c1 e8 15          	shr    $0x15,%rax
  80263e:	48 89 c2             	mov    %rax,%rdx
  802641:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802648:	01 00 00 
  80264b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80264f:	83 e0 01             	and    $0x1,%eax
  802652:	48 85 c0             	test   %rax,%rax
  802655:	74 21                	je     802678 <fd_lookup+0x77>
  802657:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80265b:	48 c1 e8 0c          	shr    $0xc,%rax
  80265f:	48 89 c2             	mov    %rax,%rdx
  802662:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802669:	01 00 00 
  80266c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802670:	83 e0 01             	and    $0x1,%eax
  802673:	48 85 c0             	test   %rax,%rax
  802676:	75 07                	jne    80267f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802678:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80267d:	eb 10                	jmp    80268f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80267f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802683:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802687:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80268a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80268f:	c9                   	leaveq 
  802690:	c3                   	retq   

0000000000802691 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802691:	55                   	push   %rbp
  802692:	48 89 e5             	mov    %rsp,%rbp
  802695:	48 83 ec 30          	sub    $0x30,%rsp
  802699:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80269d:	89 f0                	mov    %esi,%eax
  80269f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8026a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026a6:	48 89 c7             	mov    %rax,%rdi
  8026a9:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  8026b0:	00 00 00 
  8026b3:	ff d0                	callq  *%rax
  8026b5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026b9:	48 89 d6             	mov    %rdx,%rsi
  8026bc:	89 c7                	mov    %eax,%edi
  8026be:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8026c5:	00 00 00 
  8026c8:	ff d0                	callq  *%rax
  8026ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d1:	78 0a                	js     8026dd <fd_close+0x4c>
	    || fd != fd2)
  8026d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d7:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026db:	74 12                	je     8026ef <fd_close+0x5e>
		return (must_exist ? r : 0);
  8026dd:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026e1:	74 05                	je     8026e8 <fd_close+0x57>
  8026e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026e6:	eb 05                	jmp    8026ed <fd_close+0x5c>
  8026e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ed:	eb 69                	jmp    802758 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8026ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026f3:	8b 00                	mov    (%rax),%eax
  8026f5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026f9:	48 89 d6             	mov    %rdx,%rsi
  8026fc:	89 c7                	mov    %eax,%edi
  8026fe:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802705:	00 00 00 
  802708:	ff d0                	callq  *%rax
  80270a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802711:	78 2a                	js     80273d <fd_close+0xac>
		if (dev->dev_close)
  802713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802717:	48 8b 40 20          	mov    0x20(%rax),%rax
  80271b:	48 85 c0             	test   %rax,%rax
  80271e:	74 16                	je     802736 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802724:	48 8b 40 20          	mov    0x20(%rax),%rax
  802728:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80272c:	48 89 d7             	mov    %rdx,%rdi
  80272f:	ff d0                	callq  *%rax
  802731:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802734:	eb 07                	jmp    80273d <fd_close+0xac>
		else
			r = 0;
  802736:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80273d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802741:	48 89 c6             	mov    %rax,%rsi
  802744:	bf 00 00 00 00       	mov    $0x0,%edi
  802749:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  802750:	00 00 00 
  802753:	ff d0                	callq  *%rax
	return r;
  802755:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802758:	c9                   	leaveq 
  802759:	c3                   	retq   

000000000080275a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80275a:	55                   	push   %rbp
  80275b:	48 89 e5             	mov    %rsp,%rbp
  80275e:	48 83 ec 20          	sub    $0x20,%rsp
  802762:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802765:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802769:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802770:	eb 41                	jmp    8027b3 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802772:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802779:	00 00 00 
  80277c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80277f:	48 63 d2             	movslq %edx,%rdx
  802782:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802786:	8b 00                	mov    (%rax),%eax
  802788:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80278b:	75 22                	jne    8027af <dev_lookup+0x55>
			*dev = devtab[i];
  80278d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802794:	00 00 00 
  802797:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80279a:	48 63 d2             	movslq %edx,%rdx
  80279d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8027a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027a5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ad:	eb 60                	jmp    80280f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8027af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027b3:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8027ba:	00 00 00 
  8027bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027c0:	48 63 d2             	movslq %edx,%rdx
  8027c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027c7:	48 85 c0             	test   %rax,%rax
  8027ca:	75 a6                	jne    802772 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8027cc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8027d3:	00 00 00 
  8027d6:	48 8b 00             	mov    (%rax),%rax
  8027d9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027df:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027e2:	89 c6                	mov    %eax,%esi
  8027e4:	48 bf 60 4f 80 00 00 	movabs $0x804f60,%rdi
  8027eb:	00 00 00 
  8027ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f3:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  8027fa:	00 00 00 
  8027fd:	ff d1                	callq  *%rcx
	*dev = 0;
  8027ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802803:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80280a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80280f:	c9                   	leaveq 
  802810:	c3                   	retq   

0000000000802811 <close>:

int
close(int fdnum)
{
  802811:	55                   	push   %rbp
  802812:	48 89 e5             	mov    %rsp,%rbp
  802815:	48 83 ec 20          	sub    $0x20,%rsp
  802819:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80281c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802820:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802823:	48 89 d6             	mov    %rdx,%rsi
  802826:	89 c7                	mov    %eax,%edi
  802828:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  80282f:	00 00 00 
  802832:	ff d0                	callq  *%rax
  802834:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802837:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283b:	79 05                	jns    802842 <close+0x31>
		return r;
  80283d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802840:	eb 18                	jmp    80285a <close+0x49>
	else
		return fd_close(fd, 1);
  802842:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802846:	be 01 00 00 00       	mov    $0x1,%esi
  80284b:	48 89 c7             	mov    %rax,%rdi
  80284e:	48 b8 91 26 80 00 00 	movabs $0x802691,%rax
  802855:	00 00 00 
  802858:	ff d0                	callq  *%rax
}
  80285a:	c9                   	leaveq 
  80285b:	c3                   	retq   

000000000080285c <close_all>:

void
close_all(void)
{
  80285c:	55                   	push   %rbp
  80285d:	48 89 e5             	mov    %rsp,%rbp
  802860:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802864:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80286b:	eb 15                	jmp    802882 <close_all+0x26>
		close(i);
  80286d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802870:	89 c7                	mov    %eax,%edi
  802872:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80287e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802882:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802886:	7e e5                	jle    80286d <close_all+0x11>
		close(i);
}
  802888:	c9                   	leaveq 
  802889:	c3                   	retq   

000000000080288a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80288a:	55                   	push   %rbp
  80288b:	48 89 e5             	mov    %rsp,%rbp
  80288e:	48 83 ec 40          	sub    $0x40,%rsp
  802892:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802895:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802898:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80289c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80289f:	48 89 d6             	mov    %rdx,%rsi
  8028a2:	89 c7                	mov    %eax,%edi
  8028a4:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8028ab:	00 00 00 
  8028ae:	ff d0                	callq  *%rax
  8028b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b7:	79 08                	jns    8028c1 <dup+0x37>
		return r;
  8028b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028bc:	e9 70 01 00 00       	jmpq   802a31 <dup+0x1a7>
	close(newfdnum);
  8028c1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028c4:	89 c7                	mov    %eax,%edi
  8028c6:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  8028cd:	00 00 00 
  8028d0:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8028d2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028d5:	48 98                	cltq   
  8028d7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028dd:	48 c1 e0 0c          	shl    $0xc,%rax
  8028e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e9:	48 89 c7             	mov    %rax,%rdi
  8028ec:	48 b8 3e 25 80 00 00 	movabs $0x80253e,%rax
  8028f3:	00 00 00 
  8028f6:	ff d0                	callq  *%rax
  8028f8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802900:	48 89 c7             	mov    %rax,%rdi
  802903:	48 b8 3e 25 80 00 00 	movabs $0x80253e,%rax
  80290a:	00 00 00 
  80290d:	ff d0                	callq  *%rax
  80290f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802917:	48 c1 e8 15          	shr    $0x15,%rax
  80291b:	48 89 c2             	mov    %rax,%rdx
  80291e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802925:	01 00 00 
  802928:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292c:	83 e0 01             	and    $0x1,%eax
  80292f:	48 85 c0             	test   %rax,%rax
  802932:	74 73                	je     8029a7 <dup+0x11d>
  802934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802938:	48 c1 e8 0c          	shr    $0xc,%rax
  80293c:	48 89 c2             	mov    %rax,%rdx
  80293f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802946:	01 00 00 
  802949:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294d:	83 e0 01             	and    $0x1,%eax
  802950:	48 85 c0             	test   %rax,%rax
  802953:	74 52                	je     8029a7 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802959:	48 c1 e8 0c          	shr    $0xc,%rax
  80295d:	48 89 c2             	mov    %rax,%rdx
  802960:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802967:	01 00 00 
  80296a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296e:	25 07 0e 00 00       	and    $0xe07,%eax
  802973:	89 c1                	mov    %eax,%ecx
  802975:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297d:	41 89 c8             	mov    %ecx,%r8d
  802980:	48 89 d1             	mov    %rdx,%rcx
  802983:	ba 00 00 00 00       	mov    $0x0,%edx
  802988:	48 89 c6             	mov    %rax,%rsi
  80298b:	bf 00 00 00 00       	mov    $0x0,%edi
  802990:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  802997:	00 00 00 
  80299a:	ff d0                	callq  *%rax
  80299c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a3:	79 02                	jns    8029a7 <dup+0x11d>
			goto err;
  8029a5:	eb 57                	jmp    8029fe <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8029a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8029af:	48 89 c2             	mov    %rax,%rdx
  8029b2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029b9:	01 00 00 
  8029bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8029c5:	89 c1                	mov    %eax,%ecx
  8029c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029cf:	41 89 c8             	mov    %ecx,%r8d
  8029d2:	48 89 d1             	mov    %rdx,%rcx
  8029d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8029da:	48 89 c6             	mov    %rax,%rsi
  8029dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8029e2:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  8029e9:	00 00 00 
  8029ec:	ff d0                	callq  *%rax
  8029ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f5:	79 02                	jns    8029f9 <dup+0x16f>
		goto err;
  8029f7:	eb 05                	jmp    8029fe <dup+0x174>

	return newfdnum;
  8029f9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029fc:	eb 33                	jmp    802a31 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8029fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a02:	48 89 c6             	mov    %rax,%rsi
  802a05:	bf 00 00 00 00       	mov    $0x0,%edi
  802a0a:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  802a11:	00 00 00 
  802a14:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a1a:	48 89 c6             	mov    %rax,%rsi
  802a1d:	bf 00 00 00 00       	mov    $0x0,%edi
  802a22:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  802a29:	00 00 00 
  802a2c:	ff d0                	callq  *%rax
	return r;
  802a2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a31:	c9                   	leaveq 
  802a32:	c3                   	retq   

0000000000802a33 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a33:	55                   	push   %rbp
  802a34:	48 89 e5             	mov    %rsp,%rbp
  802a37:	48 83 ec 40          	sub    $0x40,%rsp
  802a3b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a3e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a42:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a46:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a4a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a4d:	48 89 d6             	mov    %rdx,%rsi
  802a50:	89 c7                	mov    %eax,%edi
  802a52:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
  802a5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a65:	78 24                	js     802a8b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6b:	8b 00                	mov    (%rax),%eax
  802a6d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a71:	48 89 d6             	mov    %rdx,%rsi
  802a74:	89 c7                	mov    %eax,%edi
  802a76:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802a7d:	00 00 00 
  802a80:	ff d0                	callq  *%rax
  802a82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a89:	79 05                	jns    802a90 <read+0x5d>
		return r;
  802a8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8e:	eb 76                	jmp    802b06 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a94:	8b 40 08             	mov    0x8(%rax),%eax
  802a97:	83 e0 03             	and    $0x3,%eax
  802a9a:	83 f8 01             	cmp    $0x1,%eax
  802a9d:	75 3a                	jne    802ad9 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a9f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802aa6:	00 00 00 
  802aa9:	48 8b 00             	mov    (%rax),%rax
  802aac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ab2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ab5:	89 c6                	mov    %eax,%esi
  802ab7:	48 bf 7f 4f 80 00 00 	movabs $0x804f7f,%rdi
  802abe:	00 00 00 
  802ac1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac6:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  802acd:	00 00 00 
  802ad0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ad2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ad7:	eb 2d                	jmp    802b06 <read+0xd3>
	}
	if (!dev->dev_read)
  802ad9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802add:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ae1:	48 85 c0             	test   %rax,%rax
  802ae4:	75 07                	jne    802aed <read+0xba>
		return -E_NOT_SUPP;
  802ae6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aeb:	eb 19                	jmp    802b06 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802aed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af1:	48 8b 40 10          	mov    0x10(%rax),%rax
  802af5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802af9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802afd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b01:	48 89 cf             	mov    %rcx,%rdi
  802b04:	ff d0                	callq  *%rax
}
  802b06:	c9                   	leaveq 
  802b07:	c3                   	retq   

0000000000802b08 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b08:	55                   	push   %rbp
  802b09:	48 89 e5             	mov    %rsp,%rbp
  802b0c:	48 83 ec 30          	sub    $0x30,%rsp
  802b10:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b17:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b22:	eb 49                	jmp    802b6d <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b27:	48 98                	cltq   
  802b29:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b2d:	48 29 c2             	sub    %rax,%rdx
  802b30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b33:	48 63 c8             	movslq %eax,%rcx
  802b36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b3a:	48 01 c1             	add    %rax,%rcx
  802b3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b40:	48 89 ce             	mov    %rcx,%rsi
  802b43:	89 c7                	mov    %eax,%edi
  802b45:	48 b8 33 2a 80 00 00 	movabs $0x802a33,%rax
  802b4c:	00 00 00 
  802b4f:	ff d0                	callq  *%rax
  802b51:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b54:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b58:	79 05                	jns    802b5f <readn+0x57>
			return m;
  802b5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b5d:	eb 1c                	jmp    802b7b <readn+0x73>
		if (m == 0)
  802b5f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b63:	75 02                	jne    802b67 <readn+0x5f>
			break;
  802b65:	eb 11                	jmp    802b78 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b6a:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b70:	48 98                	cltq   
  802b72:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b76:	72 ac                	jb     802b24 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802b78:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b7b:	c9                   	leaveq 
  802b7c:	c3                   	retq   

0000000000802b7d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b7d:	55                   	push   %rbp
  802b7e:	48 89 e5             	mov    %rsp,%rbp
  802b81:	48 83 ec 40          	sub    $0x40,%rsp
  802b85:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b88:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b8c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b90:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b94:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b97:	48 89 d6             	mov    %rdx,%rsi
  802b9a:	89 c7                	mov    %eax,%edi
  802b9c:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802ba3:	00 00 00 
  802ba6:	ff d0                	callq  *%rax
  802ba8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802baf:	78 24                	js     802bd5 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb5:	8b 00                	mov    (%rax),%eax
  802bb7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bbb:	48 89 d6             	mov    %rdx,%rsi
  802bbe:	89 c7                	mov    %eax,%edi
  802bc0:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802bc7:	00 00 00 
  802bca:	ff d0                	callq  *%rax
  802bcc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd3:	79 05                	jns    802bda <write+0x5d>
		return r;
  802bd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd8:	eb 75                	jmp    802c4f <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bde:	8b 40 08             	mov    0x8(%rax),%eax
  802be1:	83 e0 03             	and    $0x3,%eax
  802be4:	85 c0                	test   %eax,%eax
  802be6:	75 3a                	jne    802c22 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802be8:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802bef:	00 00 00 
  802bf2:	48 8b 00             	mov    (%rax),%rax
  802bf5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bfb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bfe:	89 c6                	mov    %eax,%esi
  802c00:	48 bf 9b 4f 80 00 00 	movabs $0x804f9b,%rdi
  802c07:	00 00 00 
  802c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0f:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  802c16:	00 00 00 
  802c19:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c20:	eb 2d                	jmp    802c4f <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802c22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c26:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c2a:	48 85 c0             	test   %rax,%rax
  802c2d:	75 07                	jne    802c36 <write+0xb9>
		return -E_NOT_SUPP;
  802c2f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c34:	eb 19                	jmp    802c4f <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3a:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c3e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802c42:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c46:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802c4a:	48 89 cf             	mov    %rcx,%rdi
  802c4d:	ff d0                	callq  *%rax
}
  802c4f:	c9                   	leaveq 
  802c50:	c3                   	retq   

0000000000802c51 <seek>:

int
seek(int fdnum, off_t offset)
{
  802c51:	55                   	push   %rbp
  802c52:	48 89 e5             	mov    %rsp,%rbp
  802c55:	48 83 ec 18          	sub    $0x18,%rsp
  802c59:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c5c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c5f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c66:	48 89 d6             	mov    %rdx,%rsi
  802c69:	89 c7                	mov    %eax,%edi
  802c6b:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
  802c77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c7e:	79 05                	jns    802c85 <seek+0x34>
		return r;
  802c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c83:	eb 0f                	jmp    802c94 <seek+0x43>
	fd->fd_offset = offset;
  802c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c89:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c8c:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c94:	c9                   	leaveq 
  802c95:	c3                   	retq   

0000000000802c96 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c96:	55                   	push   %rbp
  802c97:	48 89 e5             	mov    %rsp,%rbp
  802c9a:	48 83 ec 30          	sub    $0x30,%rsp
  802c9e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ca1:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ca4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ca8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cab:	48 89 d6             	mov    %rdx,%rsi
  802cae:	89 c7                	mov    %eax,%edi
  802cb0:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802cb7:	00 00 00 
  802cba:	ff d0                	callq  *%rax
  802cbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc3:	78 24                	js     802ce9 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc9:	8b 00                	mov    (%rax),%eax
  802ccb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ccf:	48 89 d6             	mov    %rdx,%rsi
  802cd2:	89 c7                	mov    %eax,%edi
  802cd4:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802cdb:	00 00 00 
  802cde:	ff d0                	callq  *%rax
  802ce0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce7:	79 05                	jns    802cee <ftruncate+0x58>
		return r;
  802ce9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cec:	eb 72                	jmp    802d60 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf2:	8b 40 08             	mov    0x8(%rax),%eax
  802cf5:	83 e0 03             	and    $0x3,%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	75 3a                	jne    802d36 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802cfc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d03:	00 00 00 
  802d06:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d09:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d0f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d12:	89 c6                	mov    %eax,%esi
  802d14:	48 bf b8 4f 80 00 00 	movabs $0x804fb8,%rdi
  802d1b:	00 00 00 
  802d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d23:	48 b9 7a 04 80 00 00 	movabs $0x80047a,%rcx
  802d2a:	00 00 00 
  802d2d:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d34:	eb 2a                	jmp    802d60 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d3a:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d3e:	48 85 c0             	test   %rax,%rax
  802d41:	75 07                	jne    802d4a <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d43:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d48:	eb 16                	jmp    802d60 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d56:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802d59:	89 ce                	mov    %ecx,%esi
  802d5b:	48 89 d7             	mov    %rdx,%rdi
  802d5e:	ff d0                	callq  *%rax
}
  802d60:	c9                   	leaveq 
  802d61:	c3                   	retq   

0000000000802d62 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d62:	55                   	push   %rbp
  802d63:	48 89 e5             	mov    %rsp,%rbp
  802d66:	48 83 ec 30          	sub    $0x30,%rsp
  802d6a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d6d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d71:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d75:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d78:	48 89 d6             	mov    %rdx,%rsi
  802d7b:	89 c7                	mov    %eax,%edi
  802d7d:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802d84:	00 00 00 
  802d87:	ff d0                	callq  *%rax
  802d89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d90:	78 24                	js     802db6 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d96:	8b 00                	mov    (%rax),%eax
  802d98:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d9c:	48 89 d6             	mov    %rdx,%rsi
  802d9f:	89 c7                	mov    %eax,%edi
  802da1:	48 b8 5a 27 80 00 00 	movabs $0x80275a,%rax
  802da8:	00 00 00 
  802dab:	ff d0                	callq  *%rax
  802dad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db4:	79 05                	jns    802dbb <fstat+0x59>
		return r;
  802db6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db9:	eb 5e                	jmp    802e19 <fstat+0xb7>
	if (!dev->dev_stat)
  802dbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbf:	48 8b 40 28          	mov    0x28(%rax),%rax
  802dc3:	48 85 c0             	test   %rax,%rax
  802dc6:	75 07                	jne    802dcf <fstat+0x6d>
		return -E_NOT_SUPP;
  802dc8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dcd:	eb 4a                	jmp    802e19 <fstat+0xb7>
	stat->st_name[0] = 0;
  802dcf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd3:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802dd6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dda:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802de1:	00 00 00 
	stat->st_isdir = 0;
  802de4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802de8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802def:	00 00 00 
	stat->st_dev = dev;
  802df2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802df6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dfa:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e05:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e0d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802e11:	48 89 ce             	mov    %rcx,%rsi
  802e14:	48 89 d7             	mov    %rdx,%rdi
  802e17:	ff d0                	callq  *%rax
}
  802e19:	c9                   	leaveq 
  802e1a:	c3                   	retq   

0000000000802e1b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e1b:	55                   	push   %rbp
  802e1c:	48 89 e5             	mov    %rsp,%rbp
  802e1f:	48 83 ec 20          	sub    $0x20,%rsp
  802e23:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e27:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2f:	be 00 00 00 00       	mov    $0x0,%esi
  802e34:	48 89 c7             	mov    %rax,%rdi
  802e37:	48 b8 09 2f 80 00 00 	movabs $0x802f09,%rax
  802e3e:	00 00 00 
  802e41:	ff d0                	callq  *%rax
  802e43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4a:	79 05                	jns    802e51 <stat+0x36>
		return fd;
  802e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4f:	eb 2f                	jmp    802e80 <stat+0x65>
	r = fstat(fd, stat);
  802e51:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e58:	48 89 d6             	mov    %rdx,%rsi
  802e5b:	89 c7                	mov    %eax,%edi
  802e5d:	48 b8 62 2d 80 00 00 	movabs $0x802d62,%rax
  802e64:	00 00 00 
  802e67:	ff d0                	callq  *%rax
  802e69:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6f:	89 c7                	mov    %eax,%edi
  802e71:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  802e78:	00 00 00 
  802e7b:	ff d0                	callq  *%rax
	return r;
  802e7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e80:	c9                   	leaveq 
  802e81:	c3                   	retq   

0000000000802e82 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e82:	55                   	push   %rbp
  802e83:	48 89 e5             	mov    %rsp,%rbp
  802e86:	48 83 ec 10          	sub    $0x10,%rsp
  802e8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e91:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e98:	00 00 00 
  802e9b:	8b 00                	mov    (%rax),%eax
  802e9d:	85 c0                	test   %eax,%eax
  802e9f:	75 1d                	jne    802ebe <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ea1:	bf 01 00 00 00       	mov    $0x1,%edi
  802ea6:	48 b8 99 24 80 00 00 	movabs $0x802499,%rax
  802ead:	00 00 00 
  802eb0:	ff d0                	callq  *%rax
  802eb2:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802eb9:	00 00 00 
  802ebc:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ebe:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ec5:	00 00 00 
  802ec8:	8b 00                	mov    (%rax),%eax
  802eca:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ecd:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ed2:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802ed9:	00 00 00 
  802edc:	89 c7                	mov    %eax,%edi
  802ede:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  802ee5:	00 00 00 
  802ee8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802eea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eee:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef3:	48 89 c6             	mov    %rax,%rsi
  802ef6:	bf 00 00 00 00       	mov    $0x0,%edi
  802efb:	48 b8 31 23 80 00 00 	movabs $0x802331,%rax
  802f02:	00 00 00 
  802f05:	ff d0                	callq  *%rax
}
  802f07:	c9                   	leaveq 
  802f08:	c3                   	retq   

0000000000802f09 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f09:	55                   	push   %rbp
  802f0a:	48 89 e5             	mov    %rsp,%rbp
  802f0d:	48 83 ec 30          	sub    $0x30,%rsp
  802f11:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f15:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  802f18:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802f1f:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  802f26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802f2d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802f32:	75 08                	jne    802f3c <open+0x33>
	{
		return r;
  802f34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f37:	e9 f2 00 00 00       	jmpq   80302e <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802f3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f40:	48 89 c7             	mov    %rax,%rdi
  802f43:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  802f4a:	00 00 00 
  802f4d:	ff d0                	callq  *%rax
  802f4f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802f52:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  802f59:	7e 0a                	jle    802f65 <open+0x5c>
	{
		return -E_BAD_PATH;
  802f5b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f60:	e9 c9 00 00 00       	jmpq   80302e <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  802f65:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802f6c:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  802f6d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802f71:	48 89 c7             	mov    %rax,%rdi
  802f74:	48 b8 69 25 80 00 00 	movabs $0x802569,%rax
  802f7b:	00 00 00 
  802f7e:	ff d0                	callq  *%rax
  802f80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f87:	78 09                	js     802f92 <open+0x89>
  802f89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8d:	48 85 c0             	test   %rax,%rax
  802f90:	75 08                	jne    802f9a <open+0x91>
		{
			return r;
  802f92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f95:	e9 94 00 00 00       	jmpq   80302e <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  802f9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f9e:	ba 00 04 00 00       	mov    $0x400,%edx
  802fa3:	48 89 c6             	mov    %rax,%rsi
  802fa6:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802fad:	00 00 00 
  802fb0:	48 b8 c1 10 80 00 00 	movabs $0x8010c1,%rax
  802fb7:	00 00 00 
  802fba:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802fbc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fc3:	00 00 00 
  802fc6:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  802fc9:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802fcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd3:	48 89 c6             	mov    %rax,%rsi
  802fd6:	bf 01 00 00 00       	mov    $0x1,%edi
  802fdb:	48 b8 82 2e 80 00 00 	movabs $0x802e82,%rax
  802fe2:	00 00 00 
  802fe5:	ff d0                	callq  *%rax
  802fe7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fee:	79 2b                	jns    80301b <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ff4:	be 00 00 00 00       	mov    $0x0,%esi
  802ff9:	48 89 c7             	mov    %rax,%rdi
  802ffc:	48 b8 91 26 80 00 00 	movabs $0x802691,%rax
  803003:	00 00 00 
  803006:	ff d0                	callq  *%rax
  803008:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80300b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80300f:	79 05                	jns    803016 <open+0x10d>
			{
				return d;
  803011:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803014:	eb 18                	jmp    80302e <open+0x125>
			}
			return r;
  803016:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803019:	eb 13                	jmp    80302e <open+0x125>
		}	
		return fd2num(fd_store);
  80301b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301f:	48 89 c7             	mov    %rax,%rdi
  803022:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  803029:	00 00 00 
  80302c:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  80302e:	c9                   	leaveq 
  80302f:	c3                   	retq   

0000000000803030 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803030:	55                   	push   %rbp
  803031:	48 89 e5             	mov    %rsp,%rbp
  803034:	48 83 ec 10          	sub    $0x10,%rsp
  803038:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80303c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803040:	8b 50 0c             	mov    0xc(%rax),%edx
  803043:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80304a:	00 00 00 
  80304d:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80304f:	be 00 00 00 00       	mov    $0x0,%esi
  803054:	bf 06 00 00 00       	mov    $0x6,%edi
  803059:	48 b8 82 2e 80 00 00 	movabs $0x802e82,%rax
  803060:	00 00 00 
  803063:	ff d0                	callq  *%rax
}
  803065:	c9                   	leaveq 
  803066:	c3                   	retq   

0000000000803067 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803067:	55                   	push   %rbp
  803068:	48 89 e5             	mov    %rsp,%rbp
  80306b:	48 83 ec 30          	sub    $0x30,%rsp
  80306f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803073:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803077:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80307b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803082:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803087:	74 07                	je     803090 <devfile_read+0x29>
  803089:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80308e:	75 07                	jne    803097 <devfile_read+0x30>
		return -E_INVAL;
  803090:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803095:	eb 77                	jmp    80310e <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80309b:	8b 50 0c             	mov    0xc(%rax),%edx
  80309e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030a5:	00 00 00 
  8030a8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8030aa:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030b1:	00 00 00 
  8030b4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030b8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8030bc:	be 00 00 00 00       	mov    $0x0,%esi
  8030c1:	bf 03 00 00 00       	mov    $0x3,%edi
  8030c6:	48 b8 82 2e 80 00 00 	movabs $0x802e82,%rax
  8030cd:	00 00 00 
  8030d0:	ff d0                	callq  *%rax
  8030d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d9:	7f 05                	jg     8030e0 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8030db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030de:	eb 2e                	jmp    80310e <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8030e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e3:	48 63 d0             	movslq %eax,%rdx
  8030e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ea:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8030f1:	00 00 00 
  8030f4:	48 89 c7             	mov    %rax,%rdi
  8030f7:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  8030fe:	00 00 00 
  803101:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803103:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803107:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80310b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80310e:	c9                   	leaveq 
  80310f:	c3                   	retq   

0000000000803110 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803110:	55                   	push   %rbp
  803111:	48 89 e5             	mov    %rsp,%rbp
  803114:	48 83 ec 30          	sub    $0x30,%rsp
  803118:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80311c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803120:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803124:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  80312b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803130:	74 07                	je     803139 <devfile_write+0x29>
  803132:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803137:	75 08                	jne    803141 <devfile_write+0x31>
		return r;
  803139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313c:	e9 9a 00 00 00       	jmpq   8031db <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803141:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803145:	8b 50 0c             	mov    0xc(%rax),%edx
  803148:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80314f:	00 00 00 
  803152:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803154:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80315b:	00 
  80315c:	76 08                	jbe    803166 <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  80315e:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803165:	00 
	}
	fsipcbuf.write.req_n = n;
  803166:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80316d:	00 00 00 
  803170:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803174:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803178:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80317c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803180:	48 89 c6             	mov    %rax,%rsi
  803183:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80318a:	00 00 00 
  80318d:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803199:	be 00 00 00 00       	mov    $0x0,%esi
  80319e:	bf 04 00 00 00       	mov    $0x4,%edi
  8031a3:	48 b8 82 2e 80 00 00 	movabs $0x802e82,%rax
  8031aa:	00 00 00 
  8031ad:	ff d0                	callq  *%rax
  8031af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b6:	7f 20                	jg     8031d8 <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  8031b8:	48 bf de 4f 80 00 00 	movabs $0x804fde,%rdi
  8031bf:	00 00 00 
  8031c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c7:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  8031ce:	00 00 00 
  8031d1:	ff d2                	callq  *%rdx
		return r;
  8031d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d6:	eb 03                	jmp    8031db <devfile_write+0xcb>
	}
	return r;
  8031d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  8031db:	c9                   	leaveq 
  8031dc:	c3                   	retq   

00000000008031dd <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8031dd:	55                   	push   %rbp
  8031de:	48 89 e5             	mov    %rsp,%rbp
  8031e1:	48 83 ec 20          	sub    $0x20,%rsp
  8031e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8031ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f1:	8b 50 0c             	mov    0xc(%rax),%edx
  8031f4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031fb:	00 00 00 
  8031fe:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803200:	be 00 00 00 00       	mov    $0x0,%esi
  803205:	bf 05 00 00 00       	mov    $0x5,%edi
  80320a:	48 b8 82 2e 80 00 00 	movabs $0x802e82,%rax
  803211:	00 00 00 
  803214:	ff d0                	callq  *%rax
  803216:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803219:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321d:	79 05                	jns    803224 <devfile_stat+0x47>
		return r;
  80321f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803222:	eb 56                	jmp    80327a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803224:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803228:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80322f:	00 00 00 
  803232:	48 89 c7             	mov    %rax,%rdi
  803235:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803241:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803248:	00 00 00 
  80324b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803251:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803255:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80325b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803262:	00 00 00 
  803265:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80326b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80326f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803275:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80327a:	c9                   	leaveq 
  80327b:	c3                   	retq   

000000000080327c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80327c:	55                   	push   %rbp
  80327d:	48 89 e5             	mov    %rsp,%rbp
  803280:	48 83 ec 10          	sub    $0x10,%rsp
  803284:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803288:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80328b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80328f:	8b 50 0c             	mov    0xc(%rax),%edx
  803292:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803299:	00 00 00 
  80329c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80329e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032a5:	00 00 00 
  8032a8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8032ab:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8032ae:	be 00 00 00 00       	mov    $0x0,%esi
  8032b3:	bf 02 00 00 00       	mov    $0x2,%edi
  8032b8:	48 b8 82 2e 80 00 00 	movabs $0x802e82,%rax
  8032bf:	00 00 00 
  8032c2:	ff d0                	callq  *%rax
}
  8032c4:	c9                   	leaveq 
  8032c5:	c3                   	retq   

00000000008032c6 <remove>:

// Delete a file
int
remove(const char *path)
{
  8032c6:	55                   	push   %rbp
  8032c7:	48 89 e5             	mov    %rsp,%rbp
  8032ca:	48 83 ec 10          	sub    $0x10,%rsp
  8032ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8032d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032d6:	48 89 c7             	mov    %rax,%rdi
  8032d9:	48 b8 c3 0f 80 00 00 	movabs $0x800fc3,%rax
  8032e0:	00 00 00 
  8032e3:	ff d0                	callq  *%rax
  8032e5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032ea:	7e 07                	jle    8032f3 <remove+0x2d>
		return -E_BAD_PATH;
  8032ec:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8032f1:	eb 33                	jmp    803326 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8032f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032f7:	48 89 c6             	mov    %rax,%rsi
  8032fa:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803301:	00 00 00 
  803304:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  80330b:	00 00 00 
  80330e:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803310:	be 00 00 00 00       	mov    $0x0,%esi
  803315:	bf 07 00 00 00       	mov    $0x7,%edi
  80331a:	48 b8 82 2e 80 00 00 	movabs $0x802e82,%rax
  803321:	00 00 00 
  803324:	ff d0                	callq  *%rax
}
  803326:	c9                   	leaveq 
  803327:	c3                   	retq   

0000000000803328 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803328:	55                   	push   %rbp
  803329:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80332c:	be 00 00 00 00       	mov    $0x0,%esi
  803331:	bf 08 00 00 00       	mov    $0x8,%edi
  803336:	48 b8 82 2e 80 00 00 	movabs $0x802e82,%rax
  80333d:	00 00 00 
  803340:	ff d0                	callq  *%rax
}
  803342:	5d                   	pop    %rbp
  803343:	c3                   	retq   

0000000000803344 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803344:	55                   	push   %rbp
  803345:	48 89 e5             	mov    %rsp,%rbp
  803348:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80334f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803356:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80335d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803364:	be 00 00 00 00       	mov    $0x0,%esi
  803369:	48 89 c7             	mov    %rax,%rdi
  80336c:	48 b8 09 2f 80 00 00 	movabs $0x802f09,%rax
  803373:	00 00 00 
  803376:	ff d0                	callq  *%rax
  803378:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80337b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337f:	79 28                	jns    8033a9 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803384:	89 c6                	mov    %eax,%esi
  803386:	48 bf fa 4f 80 00 00 	movabs $0x804ffa,%rdi
  80338d:	00 00 00 
  803390:	b8 00 00 00 00       	mov    $0x0,%eax
  803395:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  80339c:	00 00 00 
  80339f:	ff d2                	callq  *%rdx
		return fd_src;
  8033a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a4:	e9 74 01 00 00       	jmpq   80351d <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8033a9:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8033b0:	be 01 01 00 00       	mov    $0x101,%esi
  8033b5:	48 89 c7             	mov    %rax,%rdi
  8033b8:	48 b8 09 2f 80 00 00 	movabs $0x802f09,%rax
  8033bf:	00 00 00 
  8033c2:	ff d0                	callq  *%rax
  8033c4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8033c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033cb:	79 39                	jns    803406 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8033cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033d0:	89 c6                	mov    %eax,%esi
  8033d2:	48 bf 10 50 80 00 00 	movabs $0x805010,%rdi
  8033d9:	00 00 00 
  8033dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e1:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  8033e8:	00 00 00 
  8033eb:	ff d2                	callq  *%rdx
		close(fd_src);
  8033ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f0:	89 c7                	mov    %eax,%edi
  8033f2:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  8033f9:	00 00 00 
  8033fc:	ff d0                	callq  *%rax
		return fd_dest;
  8033fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803401:	e9 17 01 00 00       	jmpq   80351d <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803406:	eb 74                	jmp    80347c <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803408:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80340b:	48 63 d0             	movslq %eax,%rdx
  80340e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803415:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803418:	48 89 ce             	mov    %rcx,%rsi
  80341b:	89 c7                	mov    %eax,%edi
  80341d:	48 b8 7d 2b 80 00 00 	movabs $0x802b7d,%rax
  803424:	00 00 00 
  803427:	ff d0                	callq  *%rax
  803429:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80342c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803430:	79 4a                	jns    80347c <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803432:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803435:	89 c6                	mov    %eax,%esi
  803437:	48 bf 2a 50 80 00 00 	movabs $0x80502a,%rdi
  80343e:	00 00 00 
  803441:	b8 00 00 00 00       	mov    $0x0,%eax
  803446:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  80344d:	00 00 00 
  803450:	ff d2                	callq  *%rdx
			close(fd_src);
  803452:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803455:	89 c7                	mov    %eax,%edi
  803457:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  80345e:	00 00 00 
  803461:	ff d0                	callq  *%rax
			close(fd_dest);
  803463:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803466:	89 c7                	mov    %eax,%edi
  803468:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  80346f:	00 00 00 
  803472:	ff d0                	callq  *%rax
			return write_size;
  803474:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803477:	e9 a1 00 00 00       	jmpq   80351d <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80347c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803486:	ba 00 02 00 00       	mov    $0x200,%edx
  80348b:	48 89 ce             	mov    %rcx,%rsi
  80348e:	89 c7                	mov    %eax,%edi
  803490:	48 b8 33 2a 80 00 00 	movabs $0x802a33,%rax
  803497:	00 00 00 
  80349a:	ff d0                	callq  *%rax
  80349c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80349f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034a3:	0f 8f 5f ff ff ff    	jg     803408 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8034a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8034ad:	79 47                	jns    8034f6 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8034af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034b2:	89 c6                	mov    %eax,%esi
  8034b4:	48 bf 3d 50 80 00 00 	movabs $0x80503d,%rdi
  8034bb:	00 00 00 
  8034be:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c3:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  8034ca:	00 00 00 
  8034cd:	ff d2                	callq  *%rdx
		close(fd_src);
  8034cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d2:	89 c7                	mov    %eax,%edi
  8034d4:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  8034db:	00 00 00 
  8034de:	ff d0                	callq  *%rax
		close(fd_dest);
  8034e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034e3:	89 c7                	mov    %eax,%edi
  8034e5:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  8034ec:	00 00 00 
  8034ef:	ff d0                	callq  *%rax
		return read_size;
  8034f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034f4:	eb 27                	jmp    80351d <copy+0x1d9>
	}
	close(fd_src);
  8034f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f9:	89 c7                	mov    %eax,%edi
  8034fb:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  803502:	00 00 00 
  803505:	ff d0                	callq  *%rax
	close(fd_dest);
  803507:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80350a:	89 c7                	mov    %eax,%edi
  80350c:	48 b8 11 28 80 00 00 	movabs $0x802811,%rax
  803513:	00 00 00 
  803516:	ff d0                	callq  *%rax
	return 0;
  803518:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80351d:	c9                   	leaveq 
  80351e:	c3                   	retq   

000000000080351f <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80351f:	55                   	push   %rbp
  803520:	48 89 e5             	mov    %rsp,%rbp
  803523:	48 83 ec 20          	sub    $0x20,%rsp
  803527:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80352a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80352e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803531:	48 89 d6             	mov    %rdx,%rsi
  803534:	89 c7                	mov    %eax,%edi
  803536:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  80353d:	00 00 00 
  803540:	ff d0                	callq  *%rax
  803542:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803545:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803549:	79 05                	jns    803550 <fd2sockid+0x31>
		return r;
  80354b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354e:	eb 24                	jmp    803574 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803550:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803554:	8b 10                	mov    (%rax),%edx
  803556:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80355d:	00 00 00 
  803560:	8b 00                	mov    (%rax),%eax
  803562:	39 c2                	cmp    %eax,%edx
  803564:	74 07                	je     80356d <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803566:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80356b:	eb 07                	jmp    803574 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80356d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803571:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803574:	c9                   	leaveq 
  803575:	c3                   	retq   

0000000000803576 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803576:	55                   	push   %rbp
  803577:	48 89 e5             	mov    %rsp,%rbp
  80357a:	48 83 ec 20          	sub    $0x20,%rsp
  80357e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803581:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803585:	48 89 c7             	mov    %rax,%rdi
  803588:	48 b8 69 25 80 00 00 	movabs $0x802569,%rax
  80358f:	00 00 00 
  803592:	ff d0                	callq  *%rax
  803594:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803597:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80359b:	78 26                	js     8035c3 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80359d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a1:	ba 07 04 00 00       	mov    $0x407,%edx
  8035a6:	48 89 c6             	mov    %rax,%rsi
  8035a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ae:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  8035b5:	00 00 00 
  8035b8:	ff d0                	callq  *%rax
  8035ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035c1:	79 16                	jns    8035d9 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8035c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035c6:	89 c7                	mov    %eax,%edi
  8035c8:	48 b8 83 3a 80 00 00 	movabs $0x803a83,%rax
  8035cf:	00 00 00 
  8035d2:	ff d0                	callq  *%rax
		return r;
  8035d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d7:	eb 3a                	jmp    803613 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8035d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035dd:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8035e4:	00 00 00 
  8035e7:	8b 12                	mov    (%rdx),%edx
  8035e9:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8035eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ef:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8035f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fa:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035fd:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803600:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803604:	48 89 c7             	mov    %rax,%rdi
  803607:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  80360e:	00 00 00 
  803611:	ff d0                	callq  *%rax
}
  803613:	c9                   	leaveq 
  803614:	c3                   	retq   

0000000000803615 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803615:	55                   	push   %rbp
  803616:	48 89 e5             	mov    %rsp,%rbp
  803619:	48 83 ec 30          	sub    $0x30,%rsp
  80361d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803620:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803624:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803628:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80362b:	89 c7                	mov    %eax,%edi
  80362d:	48 b8 1f 35 80 00 00 	movabs $0x80351f,%rax
  803634:	00 00 00 
  803637:	ff d0                	callq  *%rax
  803639:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80363c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803640:	79 05                	jns    803647 <accept+0x32>
		return r;
  803642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803645:	eb 3b                	jmp    803682 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803647:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80364b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80364f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803652:	48 89 ce             	mov    %rcx,%rsi
  803655:	89 c7                	mov    %eax,%edi
  803657:	48 b8 60 39 80 00 00 	movabs $0x803960,%rax
  80365e:	00 00 00 
  803661:	ff d0                	callq  *%rax
  803663:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803666:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366a:	79 05                	jns    803671 <accept+0x5c>
		return r;
  80366c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366f:	eb 11                	jmp    803682 <accept+0x6d>
	return alloc_sockfd(r);
  803671:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803674:	89 c7                	mov    %eax,%edi
  803676:	48 b8 76 35 80 00 00 	movabs $0x803576,%rax
  80367d:	00 00 00 
  803680:	ff d0                	callq  *%rax
}
  803682:	c9                   	leaveq 
  803683:	c3                   	retq   

0000000000803684 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803684:	55                   	push   %rbp
  803685:	48 89 e5             	mov    %rsp,%rbp
  803688:	48 83 ec 20          	sub    $0x20,%rsp
  80368c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80368f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803693:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803696:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803699:	89 c7                	mov    %eax,%edi
  80369b:	48 b8 1f 35 80 00 00 	movabs $0x80351f,%rax
  8036a2:	00 00 00 
  8036a5:	ff d0                	callq  *%rax
  8036a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ae:	79 05                	jns    8036b5 <bind+0x31>
		return r;
  8036b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b3:	eb 1b                	jmp    8036d0 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8036b5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036b8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bf:	48 89 ce             	mov    %rcx,%rsi
  8036c2:	89 c7                	mov    %eax,%edi
  8036c4:	48 b8 df 39 80 00 00 	movabs $0x8039df,%rax
  8036cb:	00 00 00 
  8036ce:	ff d0                	callq  *%rax
}
  8036d0:	c9                   	leaveq 
  8036d1:	c3                   	retq   

00000000008036d2 <shutdown>:

int
shutdown(int s, int how)
{
  8036d2:	55                   	push   %rbp
  8036d3:	48 89 e5             	mov    %rsp,%rbp
  8036d6:	48 83 ec 20          	sub    $0x20,%rsp
  8036da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036dd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036e3:	89 c7                	mov    %eax,%edi
  8036e5:	48 b8 1f 35 80 00 00 	movabs $0x80351f,%rax
  8036ec:	00 00 00 
  8036ef:	ff d0                	callq  *%rax
  8036f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f8:	79 05                	jns    8036ff <shutdown+0x2d>
		return r;
  8036fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fd:	eb 16                	jmp    803715 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8036ff:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803702:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803705:	89 d6                	mov    %edx,%esi
  803707:	89 c7                	mov    %eax,%edi
  803709:	48 b8 43 3a 80 00 00 	movabs $0x803a43,%rax
  803710:	00 00 00 
  803713:	ff d0                	callq  *%rax
}
  803715:	c9                   	leaveq 
  803716:	c3                   	retq   

0000000000803717 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803717:	55                   	push   %rbp
  803718:	48 89 e5             	mov    %rsp,%rbp
  80371b:	48 83 ec 10          	sub    $0x10,%rsp
  80371f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803723:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803727:	48 89 c7             	mov    %rax,%rdi
  80372a:	48 b8 fb 47 80 00 00 	movabs $0x8047fb,%rax
  803731:	00 00 00 
  803734:	ff d0                	callq  *%rax
  803736:	83 f8 01             	cmp    $0x1,%eax
  803739:	75 17                	jne    803752 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80373b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373f:	8b 40 0c             	mov    0xc(%rax),%eax
  803742:	89 c7                	mov    %eax,%edi
  803744:	48 b8 83 3a 80 00 00 	movabs $0x803a83,%rax
  80374b:	00 00 00 
  80374e:	ff d0                	callq  *%rax
  803750:	eb 05                	jmp    803757 <devsock_close+0x40>
	else
		return 0;
  803752:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803757:	c9                   	leaveq 
  803758:	c3                   	retq   

0000000000803759 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803759:	55                   	push   %rbp
  80375a:	48 89 e5             	mov    %rsp,%rbp
  80375d:	48 83 ec 20          	sub    $0x20,%rsp
  803761:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803764:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803768:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80376b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80376e:	89 c7                	mov    %eax,%edi
  803770:	48 b8 1f 35 80 00 00 	movabs $0x80351f,%rax
  803777:	00 00 00 
  80377a:	ff d0                	callq  *%rax
  80377c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80377f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803783:	79 05                	jns    80378a <connect+0x31>
		return r;
  803785:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803788:	eb 1b                	jmp    8037a5 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80378a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80378d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803791:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803794:	48 89 ce             	mov    %rcx,%rsi
  803797:	89 c7                	mov    %eax,%edi
  803799:	48 b8 b0 3a 80 00 00 	movabs $0x803ab0,%rax
  8037a0:	00 00 00 
  8037a3:	ff d0                	callq  *%rax
}
  8037a5:	c9                   	leaveq 
  8037a6:	c3                   	retq   

00000000008037a7 <listen>:

int
listen(int s, int backlog)
{
  8037a7:	55                   	push   %rbp
  8037a8:	48 89 e5             	mov    %rsp,%rbp
  8037ab:	48 83 ec 20          	sub    $0x20,%rsp
  8037af:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037b2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b8:	89 c7                	mov    %eax,%edi
  8037ba:	48 b8 1f 35 80 00 00 	movabs $0x80351f,%rax
  8037c1:	00 00 00 
  8037c4:	ff d0                	callq  *%rax
  8037c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037cd:	79 05                	jns    8037d4 <listen+0x2d>
		return r;
  8037cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d2:	eb 16                	jmp    8037ea <listen+0x43>
	return nsipc_listen(r, backlog);
  8037d4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037da:	89 d6                	mov    %edx,%esi
  8037dc:	89 c7                	mov    %eax,%edi
  8037de:	48 b8 14 3b 80 00 00 	movabs $0x803b14,%rax
  8037e5:	00 00 00 
  8037e8:	ff d0                	callq  *%rax
}
  8037ea:	c9                   	leaveq 
  8037eb:	c3                   	retq   

00000000008037ec <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8037ec:	55                   	push   %rbp
  8037ed:	48 89 e5             	mov    %rsp,%rbp
  8037f0:	48 83 ec 20          	sub    $0x20,%rsp
  8037f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803804:	89 c2                	mov    %eax,%edx
  803806:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80380a:	8b 40 0c             	mov    0xc(%rax),%eax
  80380d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803811:	b9 00 00 00 00       	mov    $0x0,%ecx
  803816:	89 c7                	mov    %eax,%edi
  803818:	48 b8 54 3b 80 00 00 	movabs $0x803b54,%rax
  80381f:	00 00 00 
  803822:	ff d0                	callq  *%rax
}
  803824:	c9                   	leaveq 
  803825:	c3                   	retq   

0000000000803826 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803826:	55                   	push   %rbp
  803827:	48 89 e5             	mov    %rsp,%rbp
  80382a:	48 83 ec 20          	sub    $0x20,%rsp
  80382e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803832:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803836:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80383a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80383e:	89 c2                	mov    %eax,%edx
  803840:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803844:	8b 40 0c             	mov    0xc(%rax),%eax
  803847:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80384b:	b9 00 00 00 00       	mov    $0x0,%ecx
  803850:	89 c7                	mov    %eax,%edi
  803852:	48 b8 20 3c 80 00 00 	movabs $0x803c20,%rax
  803859:	00 00 00 
  80385c:	ff d0                	callq  *%rax
}
  80385e:	c9                   	leaveq 
  80385f:	c3                   	retq   

0000000000803860 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803860:	55                   	push   %rbp
  803861:	48 89 e5             	mov    %rsp,%rbp
  803864:	48 83 ec 10          	sub    $0x10,%rsp
  803868:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80386c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803870:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803874:	48 be 58 50 80 00 00 	movabs $0x805058,%rsi
  80387b:	00 00 00 
  80387e:	48 89 c7             	mov    %rax,%rdi
  803881:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  803888:	00 00 00 
  80388b:	ff d0                	callq  *%rax
	return 0;
  80388d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803892:	c9                   	leaveq 
  803893:	c3                   	retq   

0000000000803894 <socket>:

int
socket(int domain, int type, int protocol)
{
  803894:	55                   	push   %rbp
  803895:	48 89 e5             	mov    %rsp,%rbp
  803898:	48 83 ec 20          	sub    $0x20,%rsp
  80389c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80389f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8038a2:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8038a5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8038a8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ae:	89 ce                	mov    %ecx,%esi
  8038b0:	89 c7                	mov    %eax,%edi
  8038b2:	48 b8 d8 3c 80 00 00 	movabs $0x803cd8,%rax
  8038b9:	00 00 00 
  8038bc:	ff d0                	callq  *%rax
  8038be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c5:	79 05                	jns    8038cc <socket+0x38>
		return r;
  8038c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ca:	eb 11                	jmp    8038dd <socket+0x49>
	return alloc_sockfd(r);
  8038cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038cf:	89 c7                	mov    %eax,%edi
  8038d1:	48 b8 76 35 80 00 00 	movabs $0x803576,%rax
  8038d8:	00 00 00 
  8038db:	ff d0                	callq  *%rax
}
  8038dd:	c9                   	leaveq 
  8038de:	c3                   	retq   

00000000008038df <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8038df:	55                   	push   %rbp
  8038e0:	48 89 e5             	mov    %rsp,%rbp
  8038e3:	48 83 ec 10          	sub    $0x10,%rsp
  8038e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8038ea:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8038f1:	00 00 00 
  8038f4:	8b 00                	mov    (%rax),%eax
  8038f6:	85 c0                	test   %eax,%eax
  8038f8:	75 1d                	jne    803917 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8038fa:	bf 02 00 00 00       	mov    $0x2,%edi
  8038ff:	48 b8 99 24 80 00 00 	movabs $0x802499,%rax
  803906:	00 00 00 
  803909:	ff d0                	callq  *%rax
  80390b:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  803912:	00 00 00 
  803915:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803917:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80391e:	00 00 00 
  803921:	8b 00                	mov    (%rax),%eax
  803923:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803926:	b9 07 00 00 00       	mov    $0x7,%ecx
  80392b:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803932:	00 00 00 
  803935:	89 c7                	mov    %eax,%edi
  803937:	48 b8 37 24 80 00 00 	movabs $0x802437,%rax
  80393e:	00 00 00 
  803941:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803943:	ba 00 00 00 00       	mov    $0x0,%edx
  803948:	be 00 00 00 00       	mov    $0x0,%esi
  80394d:	bf 00 00 00 00       	mov    $0x0,%edi
  803952:	48 b8 31 23 80 00 00 	movabs $0x802331,%rax
  803959:	00 00 00 
  80395c:	ff d0                	callq  *%rax
}
  80395e:	c9                   	leaveq 
  80395f:	c3                   	retq   

0000000000803960 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803960:	55                   	push   %rbp
  803961:	48 89 e5             	mov    %rsp,%rbp
  803964:	48 83 ec 30          	sub    $0x30,%rsp
  803968:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80396b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80396f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803973:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80397a:	00 00 00 
  80397d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803980:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803982:	bf 01 00 00 00       	mov    $0x1,%edi
  803987:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  80398e:	00 00 00 
  803991:	ff d0                	callq  *%rax
  803993:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803996:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80399a:	78 3e                	js     8039da <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80399c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039a3:	00 00 00 
  8039a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8039aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ae:	8b 40 10             	mov    0x10(%rax),%eax
  8039b1:	89 c2                	mov    %eax,%edx
  8039b3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8039b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039bb:	48 89 ce             	mov    %rcx,%rsi
  8039be:	48 89 c7             	mov    %rax,%rdi
  8039c1:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  8039c8:	00 00 00 
  8039cb:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8039cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d1:	8b 50 10             	mov    0x10(%rax),%edx
  8039d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d8:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8039da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039dd:	c9                   	leaveq 
  8039de:	c3                   	retq   

00000000008039df <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8039df:	55                   	push   %rbp
  8039e0:	48 89 e5             	mov    %rsp,%rbp
  8039e3:	48 83 ec 10          	sub    $0x10,%rsp
  8039e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039ee:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8039f1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039f8:	00 00 00 
  8039fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039fe:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803a00:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a07:	48 89 c6             	mov    %rax,%rsi
  803a0a:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803a11:	00 00 00 
  803a14:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803a1b:	00 00 00 
  803a1e:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803a20:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a27:	00 00 00 
  803a2a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a2d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803a30:	bf 02 00 00 00       	mov    $0x2,%edi
  803a35:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  803a3c:	00 00 00 
  803a3f:	ff d0                	callq  *%rax
}
  803a41:	c9                   	leaveq 
  803a42:	c3                   	retq   

0000000000803a43 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803a43:	55                   	push   %rbp
  803a44:	48 89 e5             	mov    %rsp,%rbp
  803a47:	48 83 ec 10          	sub    $0x10,%rsp
  803a4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a4e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803a51:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a58:	00 00 00 
  803a5b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a5e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803a60:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a67:	00 00 00 
  803a6a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a6d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803a70:	bf 03 00 00 00       	mov    $0x3,%edi
  803a75:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  803a7c:	00 00 00 
  803a7f:	ff d0                	callq  *%rax
}
  803a81:	c9                   	leaveq 
  803a82:	c3                   	retq   

0000000000803a83 <nsipc_close>:

int
nsipc_close(int s)
{
  803a83:	55                   	push   %rbp
  803a84:	48 89 e5             	mov    %rsp,%rbp
  803a87:	48 83 ec 10          	sub    $0x10,%rsp
  803a8b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a8e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a95:	00 00 00 
  803a98:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a9b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803a9d:	bf 04 00 00 00       	mov    $0x4,%edi
  803aa2:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  803aa9:	00 00 00 
  803aac:	ff d0                	callq  *%rax
}
  803aae:	c9                   	leaveq 
  803aaf:	c3                   	retq   

0000000000803ab0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803ab0:	55                   	push   %rbp
  803ab1:	48 89 e5             	mov    %rsp,%rbp
  803ab4:	48 83 ec 10          	sub    $0x10,%rsp
  803ab8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803abb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803abf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ac2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ac9:	00 00 00 
  803acc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803acf:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ad1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ad4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad8:	48 89 c6             	mov    %rax,%rsi
  803adb:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803ae2:	00 00 00 
  803ae5:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803aec:	00 00 00 
  803aef:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803af1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803af8:	00 00 00 
  803afb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803afe:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803b01:	bf 05 00 00 00       	mov    $0x5,%edi
  803b06:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  803b0d:	00 00 00 
  803b10:	ff d0                	callq  *%rax
}
  803b12:	c9                   	leaveq 
  803b13:	c3                   	retq   

0000000000803b14 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803b14:	55                   	push   %rbp
  803b15:	48 89 e5             	mov    %rsp,%rbp
  803b18:	48 83 ec 10          	sub    $0x10,%rsp
  803b1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b1f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803b22:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b29:	00 00 00 
  803b2c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b2f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803b31:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b38:	00 00 00 
  803b3b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b3e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803b41:	bf 06 00 00 00       	mov    $0x6,%edi
  803b46:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  803b4d:	00 00 00 
  803b50:	ff d0                	callq  *%rax
}
  803b52:	c9                   	leaveq 
  803b53:	c3                   	retq   

0000000000803b54 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b54:	55                   	push   %rbp
  803b55:	48 89 e5             	mov    %rsp,%rbp
  803b58:	48 83 ec 30          	sub    $0x30,%rsp
  803b5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b63:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803b66:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803b69:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b70:	00 00 00 
  803b73:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b76:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b78:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b7f:	00 00 00 
  803b82:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b85:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b88:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b8f:	00 00 00 
  803b92:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803b95:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b98:	bf 07 00 00 00       	mov    $0x7,%edi
  803b9d:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  803ba4:	00 00 00 
  803ba7:	ff d0                	callq  *%rax
  803ba9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb0:	78 69                	js     803c1b <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803bb2:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803bb9:	7f 08                	jg     803bc3 <nsipc_recv+0x6f>
  803bbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bbe:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803bc1:	7e 35                	jle    803bf8 <nsipc_recv+0xa4>
  803bc3:	48 b9 5f 50 80 00 00 	movabs $0x80505f,%rcx
  803bca:	00 00 00 
  803bcd:	48 ba 74 50 80 00 00 	movabs $0x805074,%rdx
  803bd4:	00 00 00 
  803bd7:	be 61 00 00 00       	mov    $0x61,%esi
  803bdc:	48 bf 89 50 80 00 00 	movabs $0x805089,%rdi
  803be3:	00 00 00 
  803be6:	b8 00 00 00 00       	mov    $0x0,%eax
  803beb:	49 b8 a7 45 80 00 00 	movabs $0x8045a7,%r8
  803bf2:	00 00 00 
  803bf5:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803bf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bfb:	48 63 d0             	movslq %eax,%rdx
  803bfe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c02:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803c09:	00 00 00 
  803c0c:	48 89 c7             	mov    %rax,%rdi
  803c0f:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803c16:	00 00 00 
  803c19:	ff d0                	callq  *%rax
	}

	return r;
  803c1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c1e:	c9                   	leaveq 
  803c1f:	c3                   	retq   

0000000000803c20 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803c20:	55                   	push   %rbp
  803c21:	48 89 e5             	mov    %rsp,%rbp
  803c24:	48 83 ec 20          	sub    $0x20,%rsp
  803c28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c2f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803c32:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803c35:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c3c:	00 00 00 
  803c3f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c42:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803c44:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803c4b:	7e 35                	jle    803c82 <nsipc_send+0x62>
  803c4d:	48 b9 95 50 80 00 00 	movabs $0x805095,%rcx
  803c54:	00 00 00 
  803c57:	48 ba 74 50 80 00 00 	movabs $0x805074,%rdx
  803c5e:	00 00 00 
  803c61:	be 6c 00 00 00       	mov    $0x6c,%esi
  803c66:	48 bf 89 50 80 00 00 	movabs $0x805089,%rdi
  803c6d:	00 00 00 
  803c70:	b8 00 00 00 00       	mov    $0x0,%eax
  803c75:	49 b8 a7 45 80 00 00 	movabs $0x8045a7,%r8
  803c7c:	00 00 00 
  803c7f:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c85:	48 63 d0             	movslq %eax,%rdx
  803c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c8c:	48 89 c6             	mov    %rax,%rsi
  803c8f:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803c96:	00 00 00 
  803c99:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  803ca0:	00 00 00 
  803ca3:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803ca5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cac:	00 00 00 
  803caf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cb2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803cb5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cbc:	00 00 00 
  803cbf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cc2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803cc5:	bf 08 00 00 00       	mov    $0x8,%edi
  803cca:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  803cd1:	00 00 00 
  803cd4:	ff d0                	callq  *%rax
}
  803cd6:	c9                   	leaveq 
  803cd7:	c3                   	retq   

0000000000803cd8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803cd8:	55                   	push   %rbp
  803cd9:	48 89 e5             	mov    %rsp,%rbp
  803cdc:	48 83 ec 10          	sub    $0x10,%rsp
  803ce0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ce3:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ce6:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ce9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cf0:	00 00 00 
  803cf3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cf6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803cf8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cff:	00 00 00 
  803d02:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d05:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803d08:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d0f:	00 00 00 
  803d12:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d15:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803d18:	bf 09 00 00 00       	mov    $0x9,%edi
  803d1d:	48 b8 df 38 80 00 00 	movabs $0x8038df,%rax
  803d24:	00 00 00 
  803d27:	ff d0                	callq  *%rax
}
  803d29:	c9                   	leaveq 
  803d2a:	c3                   	retq   

0000000000803d2b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803d2b:	55                   	push   %rbp
  803d2c:	48 89 e5             	mov    %rsp,%rbp
  803d2f:	53                   	push   %rbx
  803d30:	48 83 ec 38          	sub    $0x38,%rsp
  803d34:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803d38:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803d3c:	48 89 c7             	mov    %rax,%rdi
  803d3f:	48 b8 69 25 80 00 00 	movabs $0x802569,%rax
  803d46:	00 00 00 
  803d49:	ff d0                	callq  *%rax
  803d4b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d52:	0f 88 bf 01 00 00    	js     803f17 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d5c:	ba 07 04 00 00       	mov    $0x407,%edx
  803d61:	48 89 c6             	mov    %rax,%rsi
  803d64:	bf 00 00 00 00       	mov    $0x0,%edi
  803d69:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803d70:	00 00 00 
  803d73:	ff d0                	callq  *%rax
  803d75:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d78:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d7c:	0f 88 95 01 00 00    	js     803f17 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d82:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d86:	48 89 c7             	mov    %rax,%rdi
  803d89:	48 b8 69 25 80 00 00 	movabs $0x802569,%rax
  803d90:	00 00 00 
  803d93:	ff d0                	callq  *%rax
  803d95:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d98:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d9c:	0f 88 5d 01 00 00    	js     803eff <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803da2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803da6:	ba 07 04 00 00       	mov    $0x407,%edx
  803dab:	48 89 c6             	mov    %rax,%rsi
  803dae:	bf 00 00 00 00       	mov    $0x0,%edi
  803db3:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803dba:	00 00 00 
  803dbd:	ff d0                	callq  *%rax
  803dbf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dc2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dc6:	0f 88 33 01 00 00    	js     803eff <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803dcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dd0:	48 89 c7             	mov    %rax,%rdi
  803dd3:	48 b8 3e 25 80 00 00 	movabs $0x80253e,%rax
  803dda:	00 00 00 
  803ddd:	ff d0                	callq  *%rax
  803ddf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803de3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de7:	ba 07 04 00 00       	mov    $0x407,%edx
  803dec:	48 89 c6             	mov    %rax,%rsi
  803def:	bf 00 00 00 00       	mov    $0x0,%edi
  803df4:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  803dfb:	00 00 00 
  803dfe:	ff d0                	callq  *%rax
  803e00:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e03:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e07:	79 05                	jns    803e0e <pipe+0xe3>
		goto err2;
  803e09:	e9 d9 00 00 00       	jmpq   803ee7 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e12:	48 89 c7             	mov    %rax,%rdi
  803e15:	48 b8 3e 25 80 00 00 	movabs $0x80253e,%rax
  803e1c:	00 00 00 
  803e1f:	ff d0                	callq  *%rax
  803e21:	48 89 c2             	mov    %rax,%rdx
  803e24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e28:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803e2e:	48 89 d1             	mov    %rdx,%rcx
  803e31:	ba 00 00 00 00       	mov    $0x0,%edx
  803e36:	48 89 c6             	mov    %rax,%rsi
  803e39:	bf 00 00 00 00       	mov    $0x0,%edi
  803e3e:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  803e45:	00 00 00 
  803e48:	ff d0                	callq  *%rax
  803e4a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e51:	79 1b                	jns    803e6e <pipe+0x143>
		goto err3;
  803e53:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803e54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e58:	48 89 c6             	mov    %rax,%rsi
  803e5b:	bf 00 00 00 00       	mov    $0x0,%edi
  803e60:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  803e67:	00 00 00 
  803e6a:	ff d0                	callq  *%rax
  803e6c:	eb 79                	jmp    803ee7 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e72:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e79:	00 00 00 
  803e7c:	8b 12                	mov    (%rdx),%edx
  803e7e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e84:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e8f:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803e96:	00 00 00 
  803e99:	8b 12                	mov    (%rdx),%edx
  803e9b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ea1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803ea8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eac:	48 89 c7             	mov    %rax,%rdi
  803eaf:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  803eb6:	00 00 00 
  803eb9:	ff d0                	callq  *%rax
  803ebb:	89 c2                	mov    %eax,%edx
  803ebd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ec1:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803ec3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ec7:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ecb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ecf:	48 89 c7             	mov    %rax,%rdi
  803ed2:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  803ed9:	00 00 00 
  803edc:	ff d0                	callq  *%rax
  803ede:	89 03                	mov    %eax,(%rbx)
	return 0;
  803ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee5:	eb 33                	jmp    803f1a <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803ee7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eeb:	48 89 c6             	mov    %rax,%rsi
  803eee:	bf 00 00 00 00       	mov    $0x0,%edi
  803ef3:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  803efa:	00 00 00 
  803efd:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803eff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f03:	48 89 c6             	mov    %rax,%rsi
  803f06:	bf 00 00 00 00       	mov    $0x0,%edi
  803f0b:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  803f12:	00 00 00 
  803f15:	ff d0                	callq  *%rax
err:
	return r;
  803f17:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f1a:	48 83 c4 38          	add    $0x38,%rsp
  803f1e:	5b                   	pop    %rbx
  803f1f:	5d                   	pop    %rbp
  803f20:	c3                   	retq   

0000000000803f21 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803f21:	55                   	push   %rbp
  803f22:	48 89 e5             	mov    %rsp,%rbp
  803f25:	53                   	push   %rbx
  803f26:	48 83 ec 28          	sub    $0x28,%rsp
  803f2a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f2e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803f32:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f39:	00 00 00 
  803f3c:	48 8b 00             	mov    (%rax),%rax
  803f3f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f45:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803f48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f4c:	48 89 c7             	mov    %rax,%rdi
  803f4f:	48 b8 fb 47 80 00 00 	movabs $0x8047fb,%rax
  803f56:	00 00 00 
  803f59:	ff d0                	callq  *%rax
  803f5b:	89 c3                	mov    %eax,%ebx
  803f5d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f61:	48 89 c7             	mov    %rax,%rdi
  803f64:	48 b8 fb 47 80 00 00 	movabs $0x8047fb,%rax
  803f6b:	00 00 00 
  803f6e:	ff d0                	callq  *%rax
  803f70:	39 c3                	cmp    %eax,%ebx
  803f72:	0f 94 c0             	sete   %al
  803f75:	0f b6 c0             	movzbl %al,%eax
  803f78:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f7b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f82:	00 00 00 
  803f85:	48 8b 00             	mov    (%rax),%rax
  803f88:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f8e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803f91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f94:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803f97:	75 05                	jne    803f9e <_pipeisclosed+0x7d>
			return ret;
  803f99:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f9c:	eb 4f                	jmp    803fed <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803f9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fa1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fa4:	74 42                	je     803fe8 <_pipeisclosed+0xc7>
  803fa6:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803faa:	75 3c                	jne    803fe8 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803fac:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803fb3:	00 00 00 
  803fb6:	48 8b 00             	mov    (%rax),%rax
  803fb9:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803fbf:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803fc2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fc5:	89 c6                	mov    %eax,%esi
  803fc7:	48 bf a6 50 80 00 00 	movabs $0x8050a6,%rdi
  803fce:	00 00 00 
  803fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  803fd6:	49 b8 7a 04 80 00 00 	movabs $0x80047a,%r8
  803fdd:	00 00 00 
  803fe0:	41 ff d0             	callq  *%r8
	}
  803fe3:	e9 4a ff ff ff       	jmpq   803f32 <_pipeisclosed+0x11>
  803fe8:	e9 45 ff ff ff       	jmpq   803f32 <_pipeisclosed+0x11>
}
  803fed:	48 83 c4 28          	add    $0x28,%rsp
  803ff1:	5b                   	pop    %rbx
  803ff2:	5d                   	pop    %rbp
  803ff3:	c3                   	retq   

0000000000803ff4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803ff4:	55                   	push   %rbp
  803ff5:	48 89 e5             	mov    %rsp,%rbp
  803ff8:	48 83 ec 30          	sub    $0x30,%rsp
  803ffc:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fff:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804003:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804006:	48 89 d6             	mov    %rdx,%rsi
  804009:	89 c7                	mov    %eax,%edi
  80400b:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  804012:	00 00 00 
  804015:	ff d0                	callq  *%rax
  804017:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80401a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401e:	79 05                	jns    804025 <pipeisclosed+0x31>
		return r;
  804020:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804023:	eb 31                	jmp    804056 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804025:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804029:	48 89 c7             	mov    %rax,%rdi
  80402c:	48 b8 3e 25 80 00 00 	movabs $0x80253e,%rax
  804033:	00 00 00 
  804036:	ff d0                	callq  *%rax
  804038:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80403c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804040:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804044:	48 89 d6             	mov    %rdx,%rsi
  804047:	48 89 c7             	mov    %rax,%rdi
  80404a:	48 b8 21 3f 80 00 00 	movabs $0x803f21,%rax
  804051:	00 00 00 
  804054:	ff d0                	callq  *%rax
}
  804056:	c9                   	leaveq 
  804057:	c3                   	retq   

0000000000804058 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804058:	55                   	push   %rbp
  804059:	48 89 e5             	mov    %rsp,%rbp
  80405c:	48 83 ec 40          	sub    $0x40,%rsp
  804060:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804064:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804068:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80406c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804070:	48 89 c7             	mov    %rax,%rdi
  804073:	48 b8 3e 25 80 00 00 	movabs $0x80253e,%rax
  80407a:	00 00 00 
  80407d:	ff d0                	callq  *%rax
  80407f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804083:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804087:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80408b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804092:	00 
  804093:	e9 92 00 00 00       	jmpq   80412a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  804098:	eb 41                	jmp    8040db <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80409a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80409f:	74 09                	je     8040aa <devpipe_read+0x52>
				return i;
  8040a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a5:	e9 92 00 00 00       	jmpq   80413c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8040aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040b2:	48 89 d6             	mov    %rdx,%rsi
  8040b5:	48 89 c7             	mov    %rax,%rdi
  8040b8:	48 b8 21 3f 80 00 00 	movabs $0x803f21,%rax
  8040bf:	00 00 00 
  8040c2:	ff d0                	callq  *%rax
  8040c4:	85 c0                	test   %eax,%eax
  8040c6:	74 07                	je     8040cf <devpipe_read+0x77>
				return 0;
  8040c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8040cd:	eb 6d                	jmp    80413c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8040cf:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  8040d6:	00 00 00 
  8040d9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8040db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040df:	8b 10                	mov    (%rax),%edx
  8040e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e5:	8b 40 04             	mov    0x4(%rax),%eax
  8040e8:	39 c2                	cmp    %eax,%edx
  8040ea:	74 ae                	je     80409a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8040ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040f4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8040f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040fc:	8b 00                	mov    (%rax),%eax
  8040fe:	99                   	cltd   
  8040ff:	c1 ea 1b             	shr    $0x1b,%edx
  804102:	01 d0                	add    %edx,%eax
  804104:	83 e0 1f             	and    $0x1f,%eax
  804107:	29 d0                	sub    %edx,%eax
  804109:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80410d:	48 98                	cltq   
  80410f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804114:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804116:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80411a:	8b 00                	mov    (%rax),%eax
  80411c:	8d 50 01             	lea    0x1(%rax),%edx
  80411f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804123:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804125:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80412a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80412e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804132:	0f 82 60 ff ff ff    	jb     804098 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804138:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80413c:	c9                   	leaveq 
  80413d:	c3                   	retq   

000000000080413e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80413e:	55                   	push   %rbp
  80413f:	48 89 e5             	mov    %rsp,%rbp
  804142:	48 83 ec 40          	sub    $0x40,%rsp
  804146:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80414a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80414e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804152:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804156:	48 89 c7             	mov    %rax,%rdi
  804159:	48 b8 3e 25 80 00 00 	movabs $0x80253e,%rax
  804160:	00 00 00 
  804163:	ff d0                	callq  *%rax
  804165:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804169:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80416d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804171:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804178:	00 
  804179:	e9 8e 00 00 00       	jmpq   80420c <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80417e:	eb 31                	jmp    8041b1 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804180:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804184:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804188:	48 89 d6             	mov    %rdx,%rsi
  80418b:	48 89 c7             	mov    %rax,%rdi
  80418e:	48 b8 21 3f 80 00 00 	movabs $0x803f21,%rax
  804195:	00 00 00 
  804198:	ff d0                	callq  *%rax
  80419a:	85 c0                	test   %eax,%eax
  80419c:	74 07                	je     8041a5 <devpipe_write+0x67>
				return 0;
  80419e:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a3:	eb 79                	jmp    80421e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8041a5:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  8041ac:	00 00 00 
  8041af:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8041b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b5:	8b 40 04             	mov    0x4(%rax),%eax
  8041b8:	48 63 d0             	movslq %eax,%rdx
  8041bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041bf:	8b 00                	mov    (%rax),%eax
  8041c1:	48 98                	cltq   
  8041c3:	48 83 c0 20          	add    $0x20,%rax
  8041c7:	48 39 c2             	cmp    %rax,%rdx
  8041ca:	73 b4                	jae    804180 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8041cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d0:	8b 40 04             	mov    0x4(%rax),%eax
  8041d3:	99                   	cltd   
  8041d4:	c1 ea 1b             	shr    $0x1b,%edx
  8041d7:	01 d0                	add    %edx,%eax
  8041d9:	83 e0 1f             	and    $0x1f,%eax
  8041dc:	29 d0                	sub    %edx,%eax
  8041de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8041e2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8041e6:	48 01 ca             	add    %rcx,%rdx
  8041e9:	0f b6 0a             	movzbl (%rdx),%ecx
  8041ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041f0:	48 98                	cltq   
  8041f2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8041f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041fa:	8b 40 04             	mov    0x4(%rax),%eax
  8041fd:	8d 50 01             	lea    0x1(%rax),%edx
  804200:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804204:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804207:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80420c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804210:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804214:	0f 82 64 ff ff ff    	jb     80417e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80421a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80421e:	c9                   	leaveq 
  80421f:	c3                   	retq   

0000000000804220 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804220:	55                   	push   %rbp
  804221:	48 89 e5             	mov    %rsp,%rbp
  804224:	48 83 ec 20          	sub    $0x20,%rsp
  804228:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80422c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804234:	48 89 c7             	mov    %rax,%rdi
  804237:	48 b8 3e 25 80 00 00 	movabs $0x80253e,%rax
  80423e:	00 00 00 
  804241:	ff d0                	callq  *%rax
  804243:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804247:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80424b:	48 be b9 50 80 00 00 	movabs $0x8050b9,%rsi
  804252:	00 00 00 
  804255:	48 89 c7             	mov    %rax,%rdi
  804258:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  80425f:	00 00 00 
  804262:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804268:	8b 50 04             	mov    0x4(%rax),%edx
  80426b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80426f:	8b 00                	mov    (%rax),%eax
  804271:	29 c2                	sub    %eax,%edx
  804273:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804277:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80427d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804281:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804288:	00 00 00 
	stat->st_dev = &devpipe;
  80428b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80428f:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804296:	00 00 00 
  804299:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8042a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042a5:	c9                   	leaveq 
  8042a6:	c3                   	retq   

00000000008042a7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8042a7:	55                   	push   %rbp
  8042a8:	48 89 e5             	mov    %rsp,%rbp
  8042ab:	48 83 ec 10          	sub    $0x10,%rsp
  8042af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8042b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042b7:	48 89 c6             	mov    %rax,%rsi
  8042ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8042bf:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  8042c6:	00 00 00 
  8042c9:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8042cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042cf:	48 89 c7             	mov    %rax,%rdi
  8042d2:	48 b8 3e 25 80 00 00 	movabs $0x80253e,%rax
  8042d9:	00 00 00 
  8042dc:	ff d0                	callq  *%rax
  8042de:	48 89 c6             	mov    %rax,%rsi
  8042e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8042e6:	48 b8 09 1a 80 00 00 	movabs $0x801a09,%rax
  8042ed:	00 00 00 
  8042f0:	ff d0                	callq  *%rax
}
  8042f2:	c9                   	leaveq 
  8042f3:	c3                   	retq   

00000000008042f4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8042f4:	55                   	push   %rbp
  8042f5:	48 89 e5             	mov    %rsp,%rbp
  8042f8:	48 83 ec 20          	sub    $0x20,%rsp
  8042fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8042ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804302:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804305:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804309:	be 01 00 00 00       	mov    $0x1,%esi
  80430e:	48 89 c7             	mov    %rax,%rdi
  804311:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  804318:	00 00 00 
  80431b:	ff d0                	callq  *%rax
}
  80431d:	c9                   	leaveq 
  80431e:	c3                   	retq   

000000000080431f <getchar>:

int
getchar(void)
{
  80431f:	55                   	push   %rbp
  804320:	48 89 e5             	mov    %rsp,%rbp
  804323:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804327:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80432b:	ba 01 00 00 00       	mov    $0x1,%edx
  804330:	48 89 c6             	mov    %rax,%rsi
  804333:	bf 00 00 00 00       	mov    $0x0,%edi
  804338:	48 b8 33 2a 80 00 00 	movabs $0x802a33,%rax
  80433f:	00 00 00 
  804342:	ff d0                	callq  *%rax
  804344:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804347:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80434b:	79 05                	jns    804352 <getchar+0x33>
		return r;
  80434d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804350:	eb 14                	jmp    804366 <getchar+0x47>
	if (r < 1)
  804352:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804356:	7f 07                	jg     80435f <getchar+0x40>
		return -E_EOF;
  804358:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80435d:	eb 07                	jmp    804366 <getchar+0x47>
	return c;
  80435f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804363:	0f b6 c0             	movzbl %al,%eax
}
  804366:	c9                   	leaveq 
  804367:	c3                   	retq   

0000000000804368 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804368:	55                   	push   %rbp
  804369:	48 89 e5             	mov    %rsp,%rbp
  80436c:	48 83 ec 20          	sub    $0x20,%rsp
  804370:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804373:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804377:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80437a:	48 89 d6             	mov    %rdx,%rsi
  80437d:	89 c7                	mov    %eax,%edi
  80437f:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  804386:	00 00 00 
  804389:	ff d0                	callq  *%rax
  80438b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80438e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804392:	79 05                	jns    804399 <iscons+0x31>
		return r;
  804394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804397:	eb 1a                	jmp    8043b3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439d:	8b 10                	mov    (%rax),%edx
  80439f:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8043a6:	00 00 00 
  8043a9:	8b 00                	mov    (%rax),%eax
  8043ab:	39 c2                	cmp    %eax,%edx
  8043ad:	0f 94 c0             	sete   %al
  8043b0:	0f b6 c0             	movzbl %al,%eax
}
  8043b3:	c9                   	leaveq 
  8043b4:	c3                   	retq   

00000000008043b5 <opencons>:

int
opencons(void)
{
  8043b5:	55                   	push   %rbp
  8043b6:	48 89 e5             	mov    %rsp,%rbp
  8043b9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8043bd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8043c1:	48 89 c7             	mov    %rax,%rdi
  8043c4:	48 b8 69 25 80 00 00 	movabs $0x802569,%rax
  8043cb:	00 00 00 
  8043ce:	ff d0                	callq  *%rax
  8043d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043d7:	79 05                	jns    8043de <opencons+0x29>
		return r;
  8043d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043dc:	eb 5b                	jmp    804439 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8043de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043e2:	ba 07 04 00 00       	mov    $0x407,%edx
  8043e7:	48 89 c6             	mov    %rax,%rsi
  8043ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ef:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  8043f6:	00 00 00 
  8043f9:	ff d0                	callq  *%rax
  8043fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804402:	79 05                	jns    804409 <opencons+0x54>
		return r;
  804404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804407:	eb 30                	jmp    804439 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80440d:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804414:	00 00 00 
  804417:	8b 12                	mov    (%rdx),%edx
  804419:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80441b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80441f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804426:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80442a:	48 89 c7             	mov    %rax,%rdi
  80442d:	48 b8 1b 25 80 00 00 	movabs $0x80251b,%rax
  804434:	00 00 00 
  804437:	ff d0                	callq  *%rax
}
  804439:	c9                   	leaveq 
  80443a:	c3                   	retq   

000000000080443b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80443b:	55                   	push   %rbp
  80443c:	48 89 e5             	mov    %rsp,%rbp
  80443f:	48 83 ec 30          	sub    $0x30,%rsp
  804443:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804447:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80444b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80444f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804454:	75 07                	jne    80445d <devcons_read+0x22>
		return 0;
  804456:	b8 00 00 00 00       	mov    $0x0,%eax
  80445b:	eb 4b                	jmp    8044a8 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80445d:	eb 0c                	jmp    80446b <devcons_read+0x30>
		sys_yield();
  80445f:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  804466:	00 00 00 
  804469:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80446b:	48 b8 60 18 80 00 00 	movabs $0x801860,%rax
  804472:	00 00 00 
  804475:	ff d0                	callq  *%rax
  804477:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80447a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80447e:	74 df                	je     80445f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804480:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804484:	79 05                	jns    80448b <devcons_read+0x50>
		return c;
  804486:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804489:	eb 1d                	jmp    8044a8 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80448b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80448f:	75 07                	jne    804498 <devcons_read+0x5d>
		return 0;
  804491:	b8 00 00 00 00       	mov    $0x0,%eax
  804496:	eb 10                	jmp    8044a8 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804498:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80449b:	89 c2                	mov    %eax,%edx
  80449d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044a1:	88 10                	mov    %dl,(%rax)
	return 1;
  8044a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8044a8:	c9                   	leaveq 
  8044a9:	c3                   	retq   

00000000008044aa <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8044aa:	55                   	push   %rbp
  8044ab:	48 89 e5             	mov    %rsp,%rbp
  8044ae:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8044b5:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8044bc:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8044c3:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8044d1:	eb 76                	jmp    804549 <devcons_write+0x9f>
		m = n - tot;
  8044d3:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8044da:	89 c2                	mov    %eax,%edx
  8044dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044df:	29 c2                	sub    %eax,%edx
  8044e1:	89 d0                	mov    %edx,%eax
  8044e3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8044e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044e9:	83 f8 7f             	cmp    $0x7f,%eax
  8044ec:	76 07                	jbe    8044f5 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8044ee:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8044f5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044f8:	48 63 d0             	movslq %eax,%rdx
  8044fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044fe:	48 63 c8             	movslq %eax,%rcx
  804501:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804508:	48 01 c1             	add    %rax,%rcx
  80450b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804512:	48 89 ce             	mov    %rcx,%rsi
  804515:	48 89 c7             	mov    %rax,%rdi
  804518:	48 b8 53 13 80 00 00 	movabs $0x801353,%rax
  80451f:	00 00 00 
  804522:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804524:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804527:	48 63 d0             	movslq %eax,%rdx
  80452a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804531:	48 89 d6             	mov    %rdx,%rsi
  804534:	48 89 c7             	mov    %rax,%rdi
  804537:	48 b8 16 18 80 00 00 	movabs $0x801816,%rax
  80453e:	00 00 00 
  804541:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804543:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804546:	01 45 fc             	add    %eax,-0x4(%rbp)
  804549:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80454c:	48 98                	cltq   
  80454e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804555:	0f 82 78 ff ff ff    	jb     8044d3 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80455b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80455e:	c9                   	leaveq 
  80455f:	c3                   	retq   

0000000000804560 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804560:	55                   	push   %rbp
  804561:	48 89 e5             	mov    %rsp,%rbp
  804564:	48 83 ec 08          	sub    $0x8,%rsp
  804568:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80456c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804571:	c9                   	leaveq 
  804572:	c3                   	retq   

0000000000804573 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804573:	55                   	push   %rbp
  804574:	48 89 e5             	mov    %rsp,%rbp
  804577:	48 83 ec 10          	sub    $0x10,%rsp
  80457b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80457f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804587:	48 be c5 50 80 00 00 	movabs $0x8050c5,%rsi
  80458e:	00 00 00 
  804591:	48 89 c7             	mov    %rax,%rdi
  804594:	48 b8 2f 10 80 00 00 	movabs $0x80102f,%rax
  80459b:	00 00 00 
  80459e:	ff d0                	callq  *%rax
	return 0;
  8045a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045a5:	c9                   	leaveq 
  8045a6:	c3                   	retq   

00000000008045a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8045a7:	55                   	push   %rbp
  8045a8:	48 89 e5             	mov    %rsp,%rbp
  8045ab:	53                   	push   %rbx
  8045ac:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8045b3:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8045ba:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8045c0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8045c7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8045ce:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8045d5:	84 c0                	test   %al,%al
  8045d7:	74 23                	je     8045fc <_panic+0x55>
  8045d9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8045e0:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8045e4:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8045e8:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8045ec:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8045f0:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8045f4:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8045f8:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8045fc:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804603:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80460a:	00 00 00 
  80460d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804614:	00 00 00 
  804617:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80461b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  804622:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  804629:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  804630:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  804637:	00 00 00 
  80463a:	48 8b 18             	mov    (%rax),%rbx
  80463d:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  804644:	00 00 00 
  804647:	ff d0                	callq  *%rax
  804649:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80464f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804656:	41 89 c8             	mov    %ecx,%r8d
  804659:	48 89 d1             	mov    %rdx,%rcx
  80465c:	48 89 da             	mov    %rbx,%rdx
  80465f:	89 c6                	mov    %eax,%esi
  804661:	48 bf d0 50 80 00 00 	movabs $0x8050d0,%rdi
  804668:	00 00 00 
  80466b:	b8 00 00 00 00       	mov    $0x0,%eax
  804670:	49 b9 7a 04 80 00 00 	movabs $0x80047a,%r9
  804677:	00 00 00 
  80467a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80467d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804684:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80468b:	48 89 d6             	mov    %rdx,%rsi
  80468e:	48 89 c7             	mov    %rax,%rdi
  804691:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  804698:	00 00 00 
  80469b:	ff d0                	callq  *%rax
	cprintf("\n");
  80469d:	48 bf f3 50 80 00 00 	movabs $0x8050f3,%rdi
  8046a4:	00 00 00 
  8046a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ac:	48 ba 7a 04 80 00 00 	movabs $0x80047a,%rdx
  8046b3:	00 00 00 
  8046b6:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8046b8:	cc                   	int3   
  8046b9:	eb fd                	jmp    8046b8 <_panic+0x111>

00000000008046bb <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8046bb:	55                   	push   %rbp
  8046bc:	48 89 e5             	mov    %rsp,%rbp
  8046bf:	48 83 ec 10          	sub    $0x10,%rsp
  8046c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  8046c7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046ce:	00 00 00 
  8046d1:	48 8b 00             	mov    (%rax),%rax
  8046d4:	48 85 c0             	test   %rax,%rax
  8046d7:	0f 85 84 00 00 00    	jne    804761 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  8046dd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046e4:	00 00 00 
  8046e7:	48 8b 00             	mov    (%rax),%rax
  8046ea:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8046f0:	ba 07 00 00 00       	mov    $0x7,%edx
  8046f5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8046fa:	89 c7                	mov    %eax,%edi
  8046fc:	48 b8 5e 19 80 00 00 	movabs $0x80195e,%rax
  804703:	00 00 00 
  804706:	ff d0                	callq  *%rax
  804708:	85 c0                	test   %eax,%eax
  80470a:	79 2a                	jns    804736 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  80470c:	48 ba f8 50 80 00 00 	movabs $0x8050f8,%rdx
  804713:	00 00 00 
  804716:	be 23 00 00 00       	mov    $0x23,%esi
  80471b:	48 bf 1f 51 80 00 00 	movabs $0x80511f,%rdi
  804722:	00 00 00 
  804725:	b8 00 00 00 00       	mov    $0x0,%eax
  80472a:	48 b9 a7 45 80 00 00 	movabs $0x8045a7,%rcx
  804731:	00 00 00 
  804734:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804736:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80473d:	00 00 00 
  804740:	48 8b 00             	mov    (%rax),%rax
  804743:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804749:	48 be 74 47 80 00 00 	movabs $0x804774,%rsi
  804750:	00 00 00 
  804753:	89 c7                	mov    %eax,%edi
  804755:	48 b8 e8 1a 80 00 00 	movabs $0x801ae8,%rax
  80475c:	00 00 00 
  80475f:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804761:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804768:	00 00 00 
  80476b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80476f:	48 89 10             	mov    %rdx,(%rax)
}
  804772:	c9                   	leaveq 
  804773:	c3                   	retq   

0000000000804774 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804774:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804777:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  80477e:	00 00 00 
call *%rax
  804781:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804783:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80478a:	00 
	movq 152(%rsp), %rcx  //Load RSP
  80478b:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804792:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804793:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804797:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  80479a:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  8047a1:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  8047a2:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  8047a6:	4c 8b 3c 24          	mov    (%rsp),%r15
  8047aa:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8047af:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8047b4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8047b9:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8047be:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8047c3:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8047c8:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8047cd:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8047d2:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8047d7:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8047dc:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8047e1:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8047e6:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8047eb:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8047f0:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  8047f4:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8047f8:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  8047f9:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8047fa:	c3                   	retq   

00000000008047fb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8047fb:	55                   	push   %rbp
  8047fc:	48 89 e5             	mov    %rsp,%rbp
  8047ff:	48 83 ec 18          	sub    $0x18,%rsp
  804803:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80480b:	48 c1 e8 15          	shr    $0x15,%rax
  80480f:	48 89 c2             	mov    %rax,%rdx
  804812:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804819:	01 00 00 
  80481c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804820:	83 e0 01             	and    $0x1,%eax
  804823:	48 85 c0             	test   %rax,%rax
  804826:	75 07                	jne    80482f <pageref+0x34>
		return 0;
  804828:	b8 00 00 00 00       	mov    $0x0,%eax
  80482d:	eb 53                	jmp    804882 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80482f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804833:	48 c1 e8 0c          	shr    $0xc,%rax
  804837:	48 89 c2             	mov    %rax,%rdx
  80483a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804841:	01 00 00 
  804844:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804848:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80484c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804850:	83 e0 01             	and    $0x1,%eax
  804853:	48 85 c0             	test   %rax,%rax
  804856:	75 07                	jne    80485f <pageref+0x64>
		return 0;
  804858:	b8 00 00 00 00       	mov    $0x0,%eax
  80485d:	eb 23                	jmp    804882 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80485f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804863:	48 c1 e8 0c          	shr    $0xc,%rax
  804867:	48 89 c2             	mov    %rax,%rdx
  80486a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804871:	00 00 00 
  804874:	48 c1 e2 04          	shl    $0x4,%rdx
  804878:	48 01 d0             	add    %rdx,%rax
  80487b:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80487f:	0f b7 c0             	movzwl %ax,%eax
}
  804882:	c9                   	leaveq 
  804883:	c3                   	retq   
