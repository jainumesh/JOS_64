
obj/user/dumbfork.debug:     file format elf64-x86-64


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
  80003c:	e8 1c 03 00 00       	callq  80035d <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  800052:	48 b8 03 02 80 00 00 	movabs $0x800203,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 4f                	jmp    8000b9 <umain+0x76>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80006a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80006e:	74 0c                	je     80007c <umain+0x39>
  800070:	48 b8 60 41 80 00 00 	movabs $0x804160,%rax
  800077:	00 00 00 
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
  80007c:	48 b8 67 41 80 00 00 	movabs $0x804167,%rax
  800083:	00 00 00 
  800086:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800089:	48 89 c2             	mov    %rax,%rdx
  80008c:	89 ce                	mov    %ecx,%esi
  80008e:	48 bf 6d 41 80 00 00 	movabs $0x80416d,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  8000a4:	00 00 00 
  8000a7:	ff d1                	callq  *%rcx
		sys_yield();
  8000a9:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  8000b0:	00 00 00 
  8000b3:	ff d0                	callq  *%rax

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  8000b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000bd:	74 07                	je     8000c6 <umain+0x83>
  8000bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8000c4:	eb 05                	jmp    8000cb <umain+0x88>
  8000c6:	b8 14 00 00 00       	mov    $0x14,%eax
  8000cb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000ce:	7f 9a                	jg     80006a <umain+0x27>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  8000d0:	c9                   	leaveq 
  8000d1:	c3                   	retq   

00000000008000d2 <duppage>:

void
duppage(envid_t dstenv, void *addr)
{
  8000d2:	55                   	push   %rbp
  8000d3:	48 89 e5             	mov    %rsp,%rbp
  8000d6:	48 83 ec 20          	sub    $0x20,%rsp
  8000da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  8000e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8000e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e8:	ba 07 00 00 00       	mov    $0x7,%edx
  8000ed:	48 89 ce             	mov    %rcx,%rsi
  8000f0:	89 c7                	mov    %eax,%edi
  8000f2:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  8000f9:	00 00 00 
  8000fc:	ff d0                	callq  *%rax
  8000fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800101:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800105:	79 30                	jns    800137 <duppage+0x65>
		panic("sys_page_alloc: %e", r);
  800107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010a:	89 c1                	mov    %eax,%ecx
  80010c:	48 ba 7f 41 80 00 00 	movabs $0x80417f,%rdx
  800113:	00 00 00 
  800116:	be 20 00 00 00       	mov    $0x20,%esi
  80011b:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
  800122:	00 00 00 
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
  80012a:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  800131:	00 00 00 
  800134:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800137:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80013b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80013e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  800144:	b9 00 00 40 00       	mov    $0x400000,%ecx
  800149:	ba 00 00 00 00       	mov    $0x0,%edx
  80014e:	89 c7                	mov    %eax,%edi
  800150:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
  80015c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800163:	79 30                	jns    800195 <duppage+0xc3>
		panic("sys_page_map: %e", r);
  800165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800168:	89 c1                	mov    %eax,%ecx
  80016a:	48 ba a2 41 80 00 00 	movabs $0x8041a2,%rdx
  800171:	00 00 00 
  800174:	be 22 00 00 00       	mov    $0x22,%esi
  800179:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
  800180:	00 00 00 
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  80018f:	00 00 00 
  800192:	41 ff d0             	callq  *%r8
	memmove(UTEMP, addr, PGSIZE);
  800195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800199:	ba 00 10 00 00       	mov    $0x1000,%edx
  80019e:	48 89 c6             	mov    %rax,%rsi
  8001a1:	bf 00 00 40 00       	mov    $0x400000,%edi
  8001a6:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8001b2:	be 00 00 40 00       	mov    $0x400000,%esi
  8001b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001bc:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
  8001c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001cf:	79 30                	jns    800201 <duppage+0x12f>
		panic("sys_page_unmap: %e", r);
  8001d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d4:	89 c1                	mov    %eax,%ecx
  8001d6:	48 ba b3 41 80 00 00 	movabs $0x8041b3,%rdx
  8001dd:	00 00 00 
  8001e0:	be 25 00 00 00       	mov    $0x25,%esi
  8001e5:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
  8001ec:	00 00 00 
  8001ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f4:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  8001fb:	00 00 00 
  8001fe:	41 ff d0             	callq  *%r8
}
  800201:	c9                   	leaveq 
  800202:	c3                   	retq   

0000000000800203 <dumbfork>:

envid_t
dumbfork(void)
{
  800203:	55                   	push   %rbp
  800204:	48 89 e5             	mov    %rsp,%rbp
  800207:	48 83 ec 20          	sub    $0x20,%rsp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80020b:	b8 07 00 00 00       	mov    $0x7,%eax
  800210:	cd 30                	int    $0x30
  800212:	89 45 e8             	mov    %eax,-0x18(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  800215:	8b 45 e8             	mov    -0x18(%rbp),%eax
	// Allocate a new child environment.
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
  800218:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (envid < 0)
  80021b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021f:	79 30                	jns    800251 <dumbfork+0x4e>
		panic("sys_exofork: %e", envid);
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	89 c1                	mov    %eax,%ecx
  800226:	48 ba c6 41 80 00 00 	movabs $0x8041c6,%rdx
  80022d:	00 00 00 
  800230:	be 37 00 00 00       	mov    $0x37,%esi
  800235:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
  80023c:	00 00 00 
  80023f:	b8 00 00 00 00       	mov    $0x0,%eax
  800244:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  80024b:	00 00 00 
  80024e:	41 ff d0             	callq  *%r8
	if (envid == 0) {
  800251:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800255:	75 46                	jne    80029d <dumbfork+0x9a>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  800257:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax
  800263:	25 ff 03 00 00       	and    $0x3ff,%eax
  800268:	48 63 d0             	movslq %eax,%rdx
  80026b:	48 89 d0             	mov    %rdx,%rax
  80026e:	48 c1 e0 03          	shl    $0x3,%rax
  800272:	48 01 d0             	add    %rdx,%rax
  800275:	48 c1 e0 05          	shl    $0x5,%rax
  800279:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800280:	00 00 00 
  800283:	48 01 c2             	add    %rax,%rdx
  800286:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80028d:	00 00 00 
  800290:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  800293:	b8 00 00 00 00       	mov    $0x0,%eax
  800298:	e9 be 00 00 00       	jmpq   80035b <dumbfork+0x158>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80029d:	48 c7 45 e0 00 00 80 	movq   $0x800000,-0x20(%rbp)
  8002a4:	00 
  8002a5:	eb 26                	jmp    8002cd <dumbfork+0xca>
		duppage(envid, addr);
  8002a7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	48 89 d6             	mov    %rdx,%rsi
  8002b1:	89 c7                	mov    %eax,%edi
  8002b3:	48 b8 d2 00 80 00 00 	movabs $0x8000d2,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8002bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002c3:	48 05 00 10 00 00    	add    $0x1000,%rax
  8002c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8002cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8002d1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8002d8:	00 00 00 
  8002db:	48 39 c2             	cmp    %rax,%rdx
  8002de:	72 c7                	jb     8002a7 <dumbfork+0xa4>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8002e0:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8002e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8002e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ec:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8002f2:	48 89 c2             	mov    %rax,%rdx
  8002f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f8:	48 89 d6             	mov    %rdx,%rsi
  8002fb:	89 c7                	mov    %eax,%edi
  8002fd:	48 b8 d2 00 80 00 00 	movabs $0x8000d2,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030c:	be 02 00 00 00       	mov    $0x2,%esi
  800311:	89 c7                	mov    %eax,%edi
  800313:	48 b8 1d 1c 80 00 00 	movabs $0x801c1d,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
  80031f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800322:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800326:	79 30                	jns    800358 <dumbfork+0x155>
		panic("sys_env_set_status: %e", r);
  800328:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	48 ba d6 41 80 00 00 	movabs $0x8041d6,%rdx
  800334:	00 00 00 
  800337:	be 4c 00 00 00       	mov    $0x4c,%esi
  80033c:	48 bf 92 41 80 00 00 	movabs $0x804192,%rdi
  800343:	00 00 00 
  800346:	b8 00 00 00 00       	mov    $0x0,%eax
  80034b:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  800352:	00 00 00 
  800355:	41 ff d0             	callq  *%r8

	return envid;
  800358:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80035b:	c9                   	leaveq 
  80035c:	c3                   	retq   

000000000080035d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80035d:	55                   	push   %rbp
  80035e:	48 89 e5             	mov    %rsp,%rbp
  800361:	48 83 ec 10          	sub    $0x10,%rsp
  800365:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800368:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80036c:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
  800378:	25 ff 03 00 00       	and    $0x3ff,%eax
  80037d:	48 63 d0             	movslq %eax,%rdx
  800380:	48 89 d0             	mov    %rdx,%rax
  800383:	48 c1 e0 03          	shl    $0x3,%rax
  800387:	48 01 d0             	add    %rdx,%rax
  80038a:	48 c1 e0 05          	shl    $0x5,%rax
  80038e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800395:	00 00 00 
  800398:	48 01 c2             	add    %rax,%rdx
  80039b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8003a2:	00 00 00 
  8003a5:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003ac:	7e 14                	jle    8003c2 <libmain+0x65>
		binaryname = argv[0];
  8003ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b2:	48 8b 10             	mov    (%rax),%rdx
  8003b5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003bc:	00 00 00 
  8003bf:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c9:	48 89 d6             	mov    %rdx,%rsi
  8003cc:	89 c7                	mov    %eax,%edi
  8003ce:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003d5:	00 00 00 
  8003d8:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8003da:	48 b8 e8 03 80 00 00 	movabs $0x8003e8,%rax
  8003e1:	00 00 00 
  8003e4:	ff d0                	callq  *%rax
}
  8003e6:	c9                   	leaveq 
  8003e7:	c3                   	retq   

00000000008003e8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003e8:	55                   	push   %rbp
  8003e9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003ec:	48 b8 a2 21 80 00 00 	movabs $0x8021a2,%rax
  8003f3:	00 00 00 
  8003f6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8003fd:	48 b8 68 1a 80 00 00 	movabs $0x801a68,%rax
  800404:	00 00 00 
  800407:	ff d0                	callq  *%rax

}
  800409:	5d                   	pop    %rbp
  80040a:	c3                   	retq   

000000000080040b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80040b:	55                   	push   %rbp
  80040c:	48 89 e5             	mov    %rsp,%rbp
  80040f:	53                   	push   %rbx
  800410:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800417:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80041e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800424:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80042b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800432:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800439:	84 c0                	test   %al,%al
  80043b:	74 23                	je     800460 <_panic+0x55>
  80043d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800444:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800448:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80044c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800450:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800454:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800458:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80045c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800460:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800467:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80046e:	00 00 00 
  800471:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800478:	00 00 00 
  80047b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80047f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800486:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80048d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800494:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80049b:	00 00 00 
  80049e:	48 8b 18             	mov    (%rax),%rbx
  8004a1:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  8004a8:	00 00 00 
  8004ab:	ff d0                	callq  *%rax
  8004ad:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004b3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004ba:	41 89 c8             	mov    %ecx,%r8d
  8004bd:	48 89 d1             	mov    %rdx,%rcx
  8004c0:	48 89 da             	mov    %rbx,%rdx
  8004c3:	89 c6                	mov    %eax,%esi
  8004c5:	48 bf f8 41 80 00 00 	movabs $0x8041f8,%rdi
  8004cc:	00 00 00 
  8004cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d4:	49 b9 44 06 80 00 00 	movabs $0x800644,%r9
  8004db:	00 00 00 
  8004de:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004e1:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004e8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004ef:	48 89 d6             	mov    %rdx,%rsi
  8004f2:	48 89 c7             	mov    %rax,%rdi
  8004f5:	48 b8 98 05 80 00 00 	movabs $0x800598,%rax
  8004fc:	00 00 00 
  8004ff:	ff d0                	callq  *%rax
	cprintf("\n");
  800501:	48 bf 1b 42 80 00 00 	movabs $0x80421b,%rdi
  800508:	00 00 00 
  80050b:	b8 00 00 00 00       	mov    $0x0,%eax
  800510:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  800517:	00 00 00 
  80051a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80051c:	cc                   	int3   
  80051d:	eb fd                	jmp    80051c <_panic+0x111>

000000000080051f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80051f:	55                   	push   %rbp
  800520:	48 89 e5             	mov    %rsp,%rbp
  800523:	48 83 ec 10          	sub    $0x10,%rsp
  800527:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80052a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80052e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800532:	8b 00                	mov    (%rax),%eax
  800534:	8d 48 01             	lea    0x1(%rax),%ecx
  800537:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80053b:	89 0a                	mov    %ecx,(%rdx)
  80053d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800540:	89 d1                	mov    %edx,%ecx
  800542:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800546:	48 98                	cltq   
  800548:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80054c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800550:	8b 00                	mov    (%rax),%eax
  800552:	3d ff 00 00 00       	cmp    $0xff,%eax
  800557:	75 2c                	jne    800585 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800559:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055d:	8b 00                	mov    (%rax),%eax
  80055f:	48 98                	cltq   
  800561:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800565:	48 83 c2 08          	add    $0x8,%rdx
  800569:	48 89 c6             	mov    %rax,%rsi
  80056c:	48 89 d7             	mov    %rdx,%rdi
  80056f:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  800576:	00 00 00 
  800579:	ff d0                	callq  *%rax
        b->idx = 0;
  80057b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800585:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800589:	8b 40 04             	mov    0x4(%rax),%eax
  80058c:	8d 50 01             	lea    0x1(%rax),%edx
  80058f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800593:	89 50 04             	mov    %edx,0x4(%rax)
}
  800596:	c9                   	leaveq 
  800597:	c3                   	retq   

0000000000800598 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800598:	55                   	push   %rbp
  800599:	48 89 e5             	mov    %rsp,%rbp
  80059c:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005a3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005aa:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005b1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005b8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005bf:	48 8b 0a             	mov    (%rdx),%rcx
  8005c2:	48 89 08             	mov    %rcx,(%rax)
  8005c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005dc:	00 00 00 
    b.cnt = 0;
  8005df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005e6:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005e9:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005f0:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005f7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005fe:	48 89 c6             	mov    %rax,%rsi
  800601:	48 bf 1f 05 80 00 00 	movabs $0x80051f,%rdi
  800608:	00 00 00 
  80060b:	48 b8 f7 09 80 00 00 	movabs $0x8009f7,%rax
  800612:	00 00 00 
  800615:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800617:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80061d:	48 98                	cltq   
  80061f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800626:	48 83 c2 08          	add    $0x8,%rdx
  80062a:	48 89 c6             	mov    %rax,%rsi
  80062d:	48 89 d7             	mov    %rdx,%rdi
  800630:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  800637:	00 00 00 
  80063a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80063c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80064f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800656:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80065d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800664:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80066b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800672:	84 c0                	test   %al,%al
  800674:	74 20                	je     800696 <cprintf+0x52>
  800676:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80067a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80067e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800682:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800686:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80068a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80068e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800692:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800696:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80069d:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006a4:	00 00 00 
  8006a7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006ae:	00 00 00 
  8006b1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006b5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006bc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006c3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006ca:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006d1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006d8:	48 8b 0a             	mov    (%rdx),%rcx
  8006db:	48 89 08             	mov    %rcx,(%rax)
  8006de:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006ea:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006ee:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006f5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006fc:	48 89 d6             	mov    %rdx,%rsi
  8006ff:	48 89 c7             	mov    %rax,%rdi
  800702:	48 b8 98 05 80 00 00 	movabs $0x800598,%rax
  800709:	00 00 00 
  80070c:	ff d0                	callq  *%rax
  80070e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800714:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80071a:	c9                   	leaveq 
  80071b:	c3                   	retq   

000000000080071c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80071c:	55                   	push   %rbp
  80071d:	48 89 e5             	mov    %rsp,%rbp
  800720:	53                   	push   %rbx
  800721:	48 83 ec 38          	sub    $0x38,%rsp
  800725:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800729:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80072d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800731:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800734:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800738:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80073c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80073f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800743:	77 3b                	ja     800780 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800745:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800748:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80074c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80074f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800753:	ba 00 00 00 00       	mov    $0x0,%edx
  800758:	48 f7 f3             	div    %rbx
  80075b:	48 89 c2             	mov    %rax,%rdx
  80075e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800761:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800764:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076c:	41 89 f9             	mov    %edi,%r9d
  80076f:	48 89 c7             	mov    %rax,%rdi
  800772:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800779:	00 00 00 
  80077c:	ff d0                	callq  *%rax
  80077e:	eb 1e                	jmp    80079e <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800780:	eb 12                	jmp    800794 <printnum+0x78>
			putch(padc, putdat);
  800782:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800786:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078d:	48 89 ce             	mov    %rcx,%rsi
  800790:	89 d7                	mov    %edx,%edi
  800792:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800794:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800798:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80079c:	7f e4                	jg     800782 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80079e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8007a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007aa:	48 f7 f1             	div    %rcx
  8007ad:	48 89 d0             	mov    %rdx,%rax
  8007b0:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  8007b7:	00 00 00 
  8007ba:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007be:	0f be d0             	movsbl %al,%edx
  8007c1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8007c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c9:	48 89 ce             	mov    %rcx,%rsi
  8007cc:	89 d7                	mov    %edx,%edi
  8007ce:	ff d0                	callq  *%rax
}
  8007d0:	48 83 c4 38          	add    $0x38,%rsp
  8007d4:	5b                   	pop    %rbx
  8007d5:	5d                   	pop    %rbp
  8007d6:	c3                   	retq   

00000000008007d7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d7:	55                   	push   %rbp
  8007d8:	48 89 e5             	mov    %rsp,%rbp
  8007db:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007e6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007ea:	7e 52                	jle    80083e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f0:	8b 00                	mov    (%rax),%eax
  8007f2:	83 f8 30             	cmp    $0x30,%eax
  8007f5:	73 24                	jae    80081b <getuint+0x44>
  8007f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800803:	8b 00                	mov    (%rax),%eax
  800805:	89 c0                	mov    %eax,%eax
  800807:	48 01 d0             	add    %rdx,%rax
  80080a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080e:	8b 12                	mov    (%rdx),%edx
  800810:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800813:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800817:	89 0a                	mov    %ecx,(%rdx)
  800819:	eb 17                	jmp    800832 <getuint+0x5b>
  80081b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800823:	48 89 d0             	mov    %rdx,%rax
  800826:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800832:	48 8b 00             	mov    (%rax),%rax
  800835:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800839:	e9 a3 00 00 00       	jmpq   8008e1 <getuint+0x10a>
	else if (lflag)
  80083e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800842:	74 4f                	je     800893 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800844:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800848:	8b 00                	mov    (%rax),%eax
  80084a:	83 f8 30             	cmp    $0x30,%eax
  80084d:	73 24                	jae    800873 <getuint+0x9c>
  80084f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800853:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085b:	8b 00                	mov    (%rax),%eax
  80085d:	89 c0                	mov    %eax,%eax
  80085f:	48 01 d0             	add    %rdx,%rax
  800862:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800866:	8b 12                	mov    (%rdx),%edx
  800868:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80086b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086f:	89 0a                	mov    %ecx,(%rdx)
  800871:	eb 17                	jmp    80088a <getuint+0xb3>
  800873:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800877:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80087b:	48 89 d0             	mov    %rdx,%rax
  80087e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800882:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800886:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088a:	48 8b 00             	mov    (%rax),%rax
  80088d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800891:	eb 4e                	jmp    8008e1 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800893:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800897:	8b 00                	mov    (%rax),%eax
  800899:	83 f8 30             	cmp    $0x30,%eax
  80089c:	73 24                	jae    8008c2 <getuint+0xeb>
  80089e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008aa:	8b 00                	mov    (%rax),%eax
  8008ac:	89 c0                	mov    %eax,%eax
  8008ae:	48 01 d0             	add    %rdx,%rax
  8008b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b5:	8b 12                	mov    (%rdx),%edx
  8008b7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008be:	89 0a                	mov    %ecx,(%rdx)
  8008c0:	eb 17                	jmp    8008d9 <getuint+0x102>
  8008c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008ca:	48 89 d0             	mov    %rdx,%rax
  8008cd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d9:	8b 00                	mov    (%rax),%eax
  8008db:	89 c0                	mov    %eax,%eax
  8008dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008e5:	c9                   	leaveq 
  8008e6:	c3                   	retq   

00000000008008e7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008e7:	55                   	push   %rbp
  8008e8:	48 89 e5             	mov    %rsp,%rbp
  8008eb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008f3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008f6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008fa:	7e 52                	jle    80094e <getint+0x67>
		x=va_arg(*ap, long long);
  8008fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800900:	8b 00                	mov    (%rax),%eax
  800902:	83 f8 30             	cmp    $0x30,%eax
  800905:	73 24                	jae    80092b <getint+0x44>
  800907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80090f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800913:	8b 00                	mov    (%rax),%eax
  800915:	89 c0                	mov    %eax,%eax
  800917:	48 01 d0             	add    %rdx,%rax
  80091a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091e:	8b 12                	mov    (%rdx),%edx
  800920:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800923:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800927:	89 0a                	mov    %ecx,(%rdx)
  800929:	eb 17                	jmp    800942 <getint+0x5b>
  80092b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800933:	48 89 d0             	mov    %rdx,%rax
  800936:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80093a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80093e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800942:	48 8b 00             	mov    (%rax),%rax
  800945:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800949:	e9 a3 00 00 00       	jmpq   8009f1 <getint+0x10a>
	else if (lflag)
  80094e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800952:	74 4f                	je     8009a3 <getint+0xbc>
		x=va_arg(*ap, long);
  800954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800958:	8b 00                	mov    (%rax),%eax
  80095a:	83 f8 30             	cmp    $0x30,%eax
  80095d:	73 24                	jae    800983 <getint+0x9c>
  80095f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800963:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096b:	8b 00                	mov    (%rax),%eax
  80096d:	89 c0                	mov    %eax,%eax
  80096f:	48 01 d0             	add    %rdx,%rax
  800972:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800976:	8b 12                	mov    (%rdx),%edx
  800978:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80097b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097f:	89 0a                	mov    %ecx,(%rdx)
  800981:	eb 17                	jmp    80099a <getint+0xb3>
  800983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800987:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80098b:	48 89 d0             	mov    %rdx,%rax
  80098e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800992:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800996:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80099a:	48 8b 00             	mov    (%rax),%rax
  80099d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a1:	eb 4e                	jmp    8009f1 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a7:	8b 00                	mov    (%rax),%eax
  8009a9:	83 f8 30             	cmp    $0x30,%eax
  8009ac:	73 24                	jae    8009d2 <getint+0xeb>
  8009ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ba:	8b 00                	mov    (%rax),%eax
  8009bc:	89 c0                	mov    %eax,%eax
  8009be:	48 01 d0             	add    %rdx,%rax
  8009c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c5:	8b 12                	mov    (%rdx),%edx
  8009c7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ce:	89 0a                	mov    %ecx,(%rdx)
  8009d0:	eb 17                	jmp    8009e9 <getint+0x102>
  8009d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009da:	48 89 d0             	mov    %rdx,%rax
  8009dd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e9:	8b 00                	mov    (%rax),%eax
  8009eb:	48 98                	cltq   
  8009ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009f5:	c9                   	leaveq 
  8009f6:	c3                   	retq   

00000000008009f7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009f7:	55                   	push   %rbp
  8009f8:	48 89 e5             	mov    %rsp,%rbp
  8009fb:	41 54                	push   %r12
  8009fd:	53                   	push   %rbx
  8009fe:	48 83 ec 60          	sub    $0x60,%rsp
  800a02:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a06:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a0a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a0e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a12:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a16:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a1a:	48 8b 0a             	mov    (%rdx),%rcx
  800a1d:	48 89 08             	mov    %rcx,(%rax)
  800a20:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a24:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a28:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a2c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a30:	eb 17                	jmp    800a49 <vprintfmt+0x52>
			if (ch == '\0')
  800a32:	85 db                	test   %ebx,%ebx
  800a34:	0f 84 cc 04 00 00    	je     800f06 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800a3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a42:	48 89 d6             	mov    %rdx,%rsi
  800a45:	89 df                	mov    %ebx,%edi
  800a47:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a49:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a4d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a51:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a55:	0f b6 00             	movzbl (%rax),%eax
  800a58:	0f b6 d8             	movzbl %al,%ebx
  800a5b:	83 fb 25             	cmp    $0x25,%ebx
  800a5e:	75 d2                	jne    800a32 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a60:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a64:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a6b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a72:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a79:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a80:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a84:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a88:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a8c:	0f b6 00             	movzbl (%rax),%eax
  800a8f:	0f b6 d8             	movzbl %al,%ebx
  800a92:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a95:	83 f8 55             	cmp    $0x55,%eax
  800a98:	0f 87 34 04 00 00    	ja     800ed2 <vprintfmt+0x4db>
  800a9e:	89 c0                	mov    %eax,%eax
  800aa0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800aa7:	00 
  800aa8:	48 b8 38 44 80 00 00 	movabs $0x804438,%rax
  800aaf:	00 00 00 
  800ab2:	48 01 d0             	add    %rdx,%rax
  800ab5:	48 8b 00             	mov    (%rax),%rax
  800ab8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800aba:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800abe:	eb c0                	jmp    800a80 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ac4:	eb ba                	jmp    800a80 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800acd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ad0:	89 d0                	mov    %edx,%eax
  800ad2:	c1 e0 02             	shl    $0x2,%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	01 c0                	add    %eax,%eax
  800ad9:	01 d8                	add    %ebx,%eax
  800adb:	83 e8 30             	sub    $0x30,%eax
  800ade:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ae1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ae5:	0f b6 00             	movzbl (%rax),%eax
  800ae8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aeb:	83 fb 2f             	cmp    $0x2f,%ebx
  800aee:	7e 0c                	jle    800afc <vprintfmt+0x105>
  800af0:	83 fb 39             	cmp    $0x39,%ebx
  800af3:	7f 07                	jg     800afc <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800afa:	eb d1                	jmp    800acd <vprintfmt+0xd6>
			goto process_precision;
  800afc:	eb 58                	jmp    800b56 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800afe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b01:	83 f8 30             	cmp    $0x30,%eax
  800b04:	73 17                	jae    800b1d <vprintfmt+0x126>
  800b06:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b0a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0d:	89 c0                	mov    %eax,%eax
  800b0f:	48 01 d0             	add    %rdx,%rax
  800b12:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b15:	83 c2 08             	add    $0x8,%edx
  800b18:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b1b:	eb 0f                	jmp    800b2c <vprintfmt+0x135>
  800b1d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b21:	48 89 d0             	mov    %rdx,%rax
  800b24:	48 83 c2 08          	add    $0x8,%rdx
  800b28:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2c:	8b 00                	mov    (%rax),%eax
  800b2e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b31:	eb 23                	jmp    800b56 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800b33:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b37:	79 0c                	jns    800b45 <vprintfmt+0x14e>
				width = 0;
  800b39:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b40:	e9 3b ff ff ff       	jmpq   800a80 <vprintfmt+0x89>
  800b45:	e9 36 ff ff ff       	jmpq   800a80 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b4a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b51:	e9 2a ff ff ff       	jmpq   800a80 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b56:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5a:	79 12                	jns    800b6e <vprintfmt+0x177>
				width = precision, precision = -1;
  800b5c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b5f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b62:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b69:	e9 12 ff ff ff       	jmpq   800a80 <vprintfmt+0x89>
  800b6e:	e9 0d ff ff ff       	jmpq   800a80 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b73:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b77:	e9 04 ff ff ff       	jmpq   800a80 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b7c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7f:	83 f8 30             	cmp    $0x30,%eax
  800b82:	73 17                	jae    800b9b <vprintfmt+0x1a4>
  800b84:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b88:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8b:	89 c0                	mov    %eax,%eax
  800b8d:	48 01 d0             	add    %rdx,%rax
  800b90:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b93:	83 c2 08             	add    $0x8,%edx
  800b96:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b99:	eb 0f                	jmp    800baa <vprintfmt+0x1b3>
  800b9b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b9f:	48 89 d0             	mov    %rdx,%rax
  800ba2:	48 83 c2 08          	add    $0x8,%rdx
  800ba6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800baa:	8b 10                	mov    (%rax),%edx
  800bac:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb4:	48 89 ce             	mov    %rcx,%rsi
  800bb7:	89 d7                	mov    %edx,%edi
  800bb9:	ff d0                	callq  *%rax
			break;
  800bbb:	e9 40 03 00 00       	jmpq   800f00 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800bc0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc3:	83 f8 30             	cmp    $0x30,%eax
  800bc6:	73 17                	jae    800bdf <vprintfmt+0x1e8>
  800bc8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bcc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcf:	89 c0                	mov    %eax,%eax
  800bd1:	48 01 d0             	add    %rdx,%rax
  800bd4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd7:	83 c2 08             	add    $0x8,%edx
  800bda:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bdd:	eb 0f                	jmp    800bee <vprintfmt+0x1f7>
  800bdf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be3:	48 89 d0             	mov    %rdx,%rax
  800be6:	48 83 c2 08          	add    $0x8,%rdx
  800bea:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bee:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bf0:	85 db                	test   %ebx,%ebx
  800bf2:	79 02                	jns    800bf6 <vprintfmt+0x1ff>
				err = -err;
  800bf4:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bf6:	83 fb 15             	cmp    $0x15,%ebx
  800bf9:	7f 16                	jg     800c11 <vprintfmt+0x21a>
  800bfb:	48 b8 60 43 80 00 00 	movabs $0x804360,%rax
  800c02:	00 00 00 
  800c05:	48 63 d3             	movslq %ebx,%rdx
  800c08:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c0c:	4d 85 e4             	test   %r12,%r12
  800c0f:	75 2e                	jne    800c3f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800c11:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c19:	89 d9                	mov    %ebx,%ecx
  800c1b:	48 ba 21 44 80 00 00 	movabs $0x804421,%rdx
  800c22:	00 00 00 
  800c25:	48 89 c7             	mov    %rax,%rdi
  800c28:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2d:	49 b8 0f 0f 80 00 00 	movabs $0x800f0f,%r8
  800c34:	00 00 00 
  800c37:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c3a:	e9 c1 02 00 00       	jmpq   800f00 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c3f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c47:	4c 89 e1             	mov    %r12,%rcx
  800c4a:	48 ba 2a 44 80 00 00 	movabs $0x80442a,%rdx
  800c51:	00 00 00 
  800c54:	48 89 c7             	mov    %rax,%rdi
  800c57:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5c:	49 b8 0f 0f 80 00 00 	movabs $0x800f0f,%r8
  800c63:	00 00 00 
  800c66:	41 ff d0             	callq  *%r8
			break;
  800c69:	e9 92 02 00 00       	jmpq   800f00 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c6e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c71:	83 f8 30             	cmp    $0x30,%eax
  800c74:	73 17                	jae    800c8d <vprintfmt+0x296>
  800c76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7d:	89 c0                	mov    %eax,%eax
  800c7f:	48 01 d0             	add    %rdx,%rax
  800c82:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c85:	83 c2 08             	add    $0x8,%edx
  800c88:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c8b:	eb 0f                	jmp    800c9c <vprintfmt+0x2a5>
  800c8d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c91:	48 89 d0             	mov    %rdx,%rax
  800c94:	48 83 c2 08          	add    $0x8,%rdx
  800c98:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c9c:	4c 8b 20             	mov    (%rax),%r12
  800c9f:	4d 85 e4             	test   %r12,%r12
  800ca2:	75 0a                	jne    800cae <vprintfmt+0x2b7>
				p = "(null)";
  800ca4:	49 bc 2d 44 80 00 00 	movabs $0x80442d,%r12
  800cab:	00 00 00 
			if (width > 0 && padc != '-')
  800cae:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb2:	7e 3f                	jle    800cf3 <vprintfmt+0x2fc>
  800cb4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cb8:	74 39                	je     800cf3 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cba:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cbd:	48 98                	cltq   
  800cbf:	48 89 c6             	mov    %rax,%rsi
  800cc2:	4c 89 e7             	mov    %r12,%rdi
  800cc5:	48 b8 bb 11 80 00 00 	movabs $0x8011bb,%rax
  800ccc:	00 00 00 
  800ccf:	ff d0                	callq  *%rax
  800cd1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cd4:	eb 17                	jmp    800ced <vprintfmt+0x2f6>
					putch(padc, putdat);
  800cd6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cda:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce2:	48 89 ce             	mov    %rcx,%rsi
  800ce5:	89 d7                	mov    %edx,%edi
  800ce7:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ced:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf1:	7f e3                	jg     800cd6 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf3:	eb 37                	jmp    800d2c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800cf5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cf9:	74 1e                	je     800d19 <vprintfmt+0x322>
  800cfb:	83 fb 1f             	cmp    $0x1f,%ebx
  800cfe:	7e 05                	jle    800d05 <vprintfmt+0x30e>
  800d00:	83 fb 7e             	cmp    $0x7e,%ebx
  800d03:	7e 14                	jle    800d19 <vprintfmt+0x322>
					putch('?', putdat);
  800d05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0d:	48 89 d6             	mov    %rdx,%rsi
  800d10:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d15:	ff d0                	callq  *%rax
  800d17:	eb 0f                	jmp    800d28 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800d19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d21:	48 89 d6             	mov    %rdx,%rsi
  800d24:	89 df                	mov    %ebx,%edi
  800d26:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d28:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d2c:	4c 89 e0             	mov    %r12,%rax
  800d2f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d33:	0f b6 00             	movzbl (%rax),%eax
  800d36:	0f be d8             	movsbl %al,%ebx
  800d39:	85 db                	test   %ebx,%ebx
  800d3b:	74 10                	je     800d4d <vprintfmt+0x356>
  800d3d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d41:	78 b2                	js     800cf5 <vprintfmt+0x2fe>
  800d43:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d47:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d4b:	79 a8                	jns    800cf5 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d4d:	eb 16                	jmp    800d65 <vprintfmt+0x36e>
				putch(' ', putdat);
  800d4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d57:	48 89 d6             	mov    %rdx,%rsi
  800d5a:	bf 20 00 00 00       	mov    $0x20,%edi
  800d5f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d61:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d65:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d69:	7f e4                	jg     800d4f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800d6b:	e9 90 01 00 00       	jmpq   800f00 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d74:	be 03 00 00 00       	mov    $0x3,%esi
  800d79:	48 89 c7             	mov    %rax,%rdi
  800d7c:	48 b8 e7 08 80 00 00 	movabs $0x8008e7,%rax
  800d83:	00 00 00 
  800d86:	ff d0                	callq  *%rax
  800d88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d90:	48 85 c0             	test   %rax,%rax
  800d93:	79 1d                	jns    800db2 <vprintfmt+0x3bb>
				putch('-', putdat);
  800d95:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d99:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9d:	48 89 d6             	mov    %rdx,%rsi
  800da0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800da5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800da7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dab:	48 f7 d8             	neg    %rax
  800dae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800db2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800db9:	e9 d5 00 00 00       	jmpq   800e93 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dbe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dc2:	be 03 00 00 00       	mov    $0x3,%esi
  800dc7:	48 89 c7             	mov    %rax,%rdi
  800dca:	48 b8 d7 07 80 00 00 	movabs $0x8007d7,%rax
  800dd1:	00 00 00 
  800dd4:	ff d0                	callq  *%rax
  800dd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dda:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de1:	e9 ad 00 00 00       	jmpq   800e93 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  800de6:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800de9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ded:	89 d6                	mov    %edx,%esi
  800def:	48 89 c7             	mov    %rax,%rdi
  800df2:	48 b8 e7 08 80 00 00 	movabs $0x8008e7,%rax
  800df9:	00 00 00 
  800dfc:	ff d0                	callq  *%rax
  800dfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e02:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e09:	e9 85 00 00 00       	jmpq   800e93 <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  800e0e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e16:	48 89 d6             	mov    %rdx,%rsi
  800e19:	bf 30 00 00 00       	mov    $0x30,%edi
  800e1e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e28:	48 89 d6             	mov    %rdx,%rsi
  800e2b:	bf 78 00 00 00       	mov    $0x78,%edi
  800e30:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e32:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e35:	83 f8 30             	cmp    $0x30,%eax
  800e38:	73 17                	jae    800e51 <vprintfmt+0x45a>
  800e3a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e41:	89 c0                	mov    %eax,%eax
  800e43:	48 01 d0             	add    %rdx,%rax
  800e46:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e49:	83 c2 08             	add    $0x8,%edx
  800e4c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e4f:	eb 0f                	jmp    800e60 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800e51:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e55:	48 89 d0             	mov    %rdx,%rax
  800e58:	48 83 c2 08          	add    $0x8,%rdx
  800e5c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e60:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e67:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e6e:	eb 23                	jmp    800e93 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e74:	be 03 00 00 00       	mov    $0x3,%esi
  800e79:	48 89 c7             	mov    %rax,%rdi
  800e7c:	48 b8 d7 07 80 00 00 	movabs $0x8007d7,%rax
  800e83:	00 00 00 
  800e86:	ff d0                	callq  *%rax
  800e88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e8c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e93:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e98:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e9b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ea6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eaa:	45 89 c1             	mov    %r8d,%r9d
  800ead:	41 89 f8             	mov    %edi,%r8d
  800eb0:	48 89 c7             	mov    %rax,%rdi
  800eb3:	48 b8 1c 07 80 00 00 	movabs $0x80071c,%rax
  800eba:	00 00 00 
  800ebd:	ff d0                	callq  *%rax
			break;
  800ebf:	eb 3f                	jmp    800f00 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ec1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ec5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ec9:	48 89 d6             	mov    %rdx,%rsi
  800ecc:	89 df                	mov    %ebx,%edi
  800ece:	ff d0                	callq  *%rax
			break;
  800ed0:	eb 2e                	jmp    800f00 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ed2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eda:	48 89 d6             	mov    %rdx,%rsi
  800edd:	bf 25 00 00 00       	mov    $0x25,%edi
  800ee2:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ee4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ee9:	eb 05                	jmp    800ef0 <vprintfmt+0x4f9>
  800eeb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ef0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ef4:	48 83 e8 01          	sub    $0x1,%rax
  800ef8:	0f b6 00             	movzbl (%rax),%eax
  800efb:	3c 25                	cmp    $0x25,%al
  800efd:	75 ec                	jne    800eeb <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800eff:	90                   	nop
		}
	}
  800f00:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f01:	e9 43 fb ff ff       	jmpq   800a49 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f06:	48 83 c4 60          	add    $0x60,%rsp
  800f0a:	5b                   	pop    %rbx
  800f0b:	41 5c                	pop    %r12
  800f0d:	5d                   	pop    %rbp
  800f0e:	c3                   	retq   

0000000000800f0f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0f:	55                   	push   %rbp
  800f10:	48 89 e5             	mov    %rsp,%rbp
  800f13:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f1a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f21:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f28:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f2f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f36:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f3d:	84 c0                	test   %al,%al
  800f3f:	74 20                	je     800f61 <printfmt+0x52>
  800f41:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f45:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f49:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f4d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f51:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f55:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f59:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f5d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f61:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f68:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f6f:	00 00 00 
  800f72:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f79:	00 00 00 
  800f7c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f80:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f87:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f8e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f95:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f9c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fa3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800faa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fb1:	48 89 c7             	mov    %rax,%rdi
  800fb4:	48 b8 f7 09 80 00 00 	movabs $0x8009f7,%rax
  800fbb:	00 00 00 
  800fbe:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fc0:	c9                   	leaveq 
  800fc1:	c3                   	retq   

0000000000800fc2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fc2:	55                   	push   %rbp
  800fc3:	48 89 e5             	mov    %rsp,%rbp
  800fc6:	48 83 ec 10          	sub    $0x10,%rsp
  800fca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fcd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd5:	8b 40 10             	mov    0x10(%rax),%eax
  800fd8:	8d 50 01             	lea    0x1(%rax),%edx
  800fdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdf:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe6:	48 8b 10             	mov    (%rax),%rdx
  800fe9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fed:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ff1:	48 39 c2             	cmp    %rax,%rdx
  800ff4:	73 17                	jae    80100d <sprintputch+0x4b>
		*b->buf++ = ch;
  800ff6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffa:	48 8b 00             	mov    (%rax),%rax
  800ffd:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801001:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801005:	48 89 0a             	mov    %rcx,(%rdx)
  801008:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80100b:	88 10                	mov    %dl,(%rax)
}
  80100d:	c9                   	leaveq 
  80100e:	c3                   	retq   

000000000080100f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100f:	55                   	push   %rbp
  801010:	48 89 e5             	mov    %rsp,%rbp
  801013:	48 83 ec 50          	sub    $0x50,%rsp
  801017:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80101b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80101e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801022:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801026:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80102a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80102e:	48 8b 0a             	mov    (%rdx),%rcx
  801031:	48 89 08             	mov    %rcx,(%rax)
  801034:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801038:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80103c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801040:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801044:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801048:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80104c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80104f:	48 98                	cltq   
  801051:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801055:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801059:	48 01 d0             	add    %rdx,%rax
  80105c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801060:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801067:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80106c:	74 06                	je     801074 <vsnprintf+0x65>
  80106e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801072:	7f 07                	jg     80107b <vsnprintf+0x6c>
		return -E_INVAL;
  801074:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801079:	eb 2f                	jmp    8010aa <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80107b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80107f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801083:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801087:	48 89 c6             	mov    %rax,%rsi
  80108a:	48 bf c2 0f 80 00 00 	movabs $0x800fc2,%rdi
  801091:	00 00 00 
  801094:	48 b8 f7 09 80 00 00 	movabs $0x8009f7,%rax
  80109b:	00 00 00 
  80109e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010a4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010a7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010aa:	c9                   	leaveq 
  8010ab:	c3                   	retq   

00000000008010ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010ac:	55                   	push   %rbp
  8010ad:	48 89 e5             	mov    %rsp,%rbp
  8010b0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010b7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010be:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010c4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010cb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010d2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010d9:	84 c0                	test   %al,%al
  8010db:	74 20                	je     8010fd <snprintf+0x51>
  8010dd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010e1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010e5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010e9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010ed:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010f1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010f5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010f9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010fd:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801104:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80110b:	00 00 00 
  80110e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801115:	00 00 00 
  801118:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80111c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801123:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80112a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801131:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801138:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80113f:	48 8b 0a             	mov    (%rdx),%rcx
  801142:	48 89 08             	mov    %rcx,(%rax)
  801145:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801149:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80114d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801151:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801155:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80115c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801163:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801169:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801170:	48 89 c7             	mov    %rax,%rdi
  801173:	48 b8 0f 10 80 00 00 	movabs $0x80100f,%rax
  80117a:	00 00 00 
  80117d:	ff d0                	callq  *%rax
  80117f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801185:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80118b:	c9                   	leaveq 
  80118c:	c3                   	retq   

000000000080118d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80118d:	55                   	push   %rbp
  80118e:	48 89 e5             	mov    %rsp,%rbp
  801191:	48 83 ec 18          	sub    $0x18,%rsp
  801195:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011a0:	eb 09                	jmp    8011ab <strlen+0x1e>
		n++;
  8011a2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011a6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011af:	0f b6 00             	movzbl (%rax),%eax
  8011b2:	84 c0                	test   %al,%al
  8011b4:	75 ec                	jne    8011a2 <strlen+0x15>
		n++;
	return n;
  8011b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011b9:	c9                   	leaveq 
  8011ba:	c3                   	retq   

00000000008011bb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011bb:	55                   	push   %rbp
  8011bc:	48 89 e5             	mov    %rsp,%rbp
  8011bf:	48 83 ec 20          	sub    $0x20,%rsp
  8011c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011d2:	eb 0e                	jmp    8011e2 <strnlen+0x27>
		n++;
  8011d4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011d8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011dd:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011e2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011e7:	74 0b                	je     8011f4 <strnlen+0x39>
  8011e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ed:	0f b6 00             	movzbl (%rax),%eax
  8011f0:	84 c0                	test   %al,%al
  8011f2:	75 e0                	jne    8011d4 <strnlen+0x19>
		n++;
	return n;
  8011f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011f7:	c9                   	leaveq 
  8011f8:	c3                   	retq   

00000000008011f9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011f9:	55                   	push   %rbp
  8011fa:	48 89 e5             	mov    %rsp,%rbp
  8011fd:	48 83 ec 20          	sub    $0x20,%rsp
  801201:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801205:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801211:	90                   	nop
  801212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801216:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80121a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80121e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801222:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801226:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80122a:	0f b6 12             	movzbl (%rdx),%edx
  80122d:	88 10                	mov    %dl,(%rax)
  80122f:	0f b6 00             	movzbl (%rax),%eax
  801232:	84 c0                	test   %al,%al
  801234:	75 dc                	jne    801212 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801236:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80123a:	c9                   	leaveq 
  80123b:	c3                   	retq   

000000000080123c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80123c:	55                   	push   %rbp
  80123d:	48 89 e5             	mov    %rsp,%rbp
  801240:	48 83 ec 20          	sub    $0x20,%rsp
  801244:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801248:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80124c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801250:	48 89 c7             	mov    %rax,%rdi
  801253:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  80125a:	00 00 00 
  80125d:	ff d0                	callq  *%rax
  80125f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801262:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801265:	48 63 d0             	movslq %eax,%rdx
  801268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126c:	48 01 c2             	add    %rax,%rdx
  80126f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801273:	48 89 c6             	mov    %rax,%rsi
  801276:	48 89 d7             	mov    %rdx,%rdi
  801279:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  801280:	00 00 00 
  801283:	ff d0                	callq  *%rax
	return dst;
  801285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801289:	c9                   	leaveq 
  80128a:	c3                   	retq   

000000000080128b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80128b:	55                   	push   %rbp
  80128c:	48 89 e5             	mov    %rsp,%rbp
  80128f:	48 83 ec 28          	sub    $0x28,%rsp
  801293:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801297:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80129b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012a7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012ae:	00 
  8012af:	eb 2a                	jmp    8012db <strncpy+0x50>
		*dst++ = *src;
  8012b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012bd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012c1:	0f b6 12             	movzbl (%rdx),%edx
  8012c4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	84 c0                	test   %al,%al
  8012cf:	74 05                	je     8012d6 <strncpy+0x4b>
			src++;
  8012d1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012df:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012e3:	72 cc                	jb     8012b1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012e9:	c9                   	leaveq 
  8012ea:	c3                   	retq   

00000000008012eb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012eb:	55                   	push   %rbp
  8012ec:	48 89 e5             	mov    %rsp,%rbp
  8012ef:	48 83 ec 28          	sub    $0x28,%rsp
  8012f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801303:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801307:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80130c:	74 3d                	je     80134b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80130e:	eb 1d                	jmp    80132d <strlcpy+0x42>
			*dst++ = *src++;
  801310:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801314:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801318:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80131c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801320:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801324:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801328:	0f b6 12             	movzbl (%rdx),%edx
  80132b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80132d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801332:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801337:	74 0b                	je     801344 <strlcpy+0x59>
  801339:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133d:	0f b6 00             	movzbl (%rax),%eax
  801340:	84 c0                	test   %al,%al
  801342:	75 cc                	jne    801310 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801348:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80134b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80134f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801353:	48 29 c2             	sub    %rax,%rdx
  801356:	48 89 d0             	mov    %rdx,%rax
}
  801359:	c9                   	leaveq 
  80135a:	c3                   	retq   

000000000080135b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80135b:	55                   	push   %rbp
  80135c:	48 89 e5             	mov    %rsp,%rbp
  80135f:	48 83 ec 10          	sub    $0x10,%rsp
  801363:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801367:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80136b:	eb 0a                	jmp    801377 <strcmp+0x1c>
		p++, q++;
  80136d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801372:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801377:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137b:	0f b6 00             	movzbl (%rax),%eax
  80137e:	84 c0                	test   %al,%al
  801380:	74 12                	je     801394 <strcmp+0x39>
  801382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801386:	0f b6 10             	movzbl (%rax),%edx
  801389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138d:	0f b6 00             	movzbl (%rax),%eax
  801390:	38 c2                	cmp    %al,%dl
  801392:	74 d9                	je     80136d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801398:	0f b6 00             	movzbl (%rax),%eax
  80139b:	0f b6 d0             	movzbl %al,%edx
  80139e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a2:	0f b6 00             	movzbl (%rax),%eax
  8013a5:	0f b6 c0             	movzbl %al,%eax
  8013a8:	29 c2                	sub    %eax,%edx
  8013aa:	89 d0                	mov    %edx,%eax
}
  8013ac:	c9                   	leaveq 
  8013ad:	c3                   	retq   

00000000008013ae <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013ae:	55                   	push   %rbp
  8013af:	48 89 e5             	mov    %rsp,%rbp
  8013b2:	48 83 ec 18          	sub    $0x18,%rsp
  8013b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013be:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013c2:	eb 0f                	jmp    8013d3 <strncmp+0x25>
		n--, p++, q++;
  8013c4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ce:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013d8:	74 1d                	je     8013f7 <strncmp+0x49>
  8013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013de:	0f b6 00             	movzbl (%rax),%eax
  8013e1:	84 c0                	test   %al,%al
  8013e3:	74 12                	je     8013f7 <strncmp+0x49>
  8013e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e9:	0f b6 10             	movzbl (%rax),%edx
  8013ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	38 c2                	cmp    %al,%dl
  8013f5:	74 cd                	je     8013c4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013f7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013fc:	75 07                	jne    801405 <strncmp+0x57>
		return 0;
  8013fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801403:	eb 18                	jmp    80141d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	0f b6 d0             	movzbl %al,%edx
  80140f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801413:	0f b6 00             	movzbl (%rax),%eax
  801416:	0f b6 c0             	movzbl %al,%eax
  801419:	29 c2                	sub    %eax,%edx
  80141b:	89 d0                	mov    %edx,%eax
}
  80141d:	c9                   	leaveq 
  80141e:	c3                   	retq   

000000000080141f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80141f:	55                   	push   %rbp
  801420:	48 89 e5             	mov    %rsp,%rbp
  801423:	48 83 ec 0c          	sub    $0xc,%rsp
  801427:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80142b:	89 f0                	mov    %esi,%eax
  80142d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801430:	eb 17                	jmp    801449 <strchr+0x2a>
		if (*s == c)
  801432:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801436:	0f b6 00             	movzbl (%rax),%eax
  801439:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80143c:	75 06                	jne    801444 <strchr+0x25>
			return (char *) s;
  80143e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801442:	eb 15                	jmp    801459 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801444:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144d:	0f b6 00             	movzbl (%rax),%eax
  801450:	84 c0                	test   %al,%al
  801452:	75 de                	jne    801432 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801454:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801459:	c9                   	leaveq 
  80145a:	c3                   	retq   

000000000080145b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80145b:	55                   	push   %rbp
  80145c:	48 89 e5             	mov    %rsp,%rbp
  80145f:	48 83 ec 0c          	sub    $0xc,%rsp
  801463:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801467:	89 f0                	mov    %esi,%eax
  801469:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80146c:	eb 13                	jmp    801481 <strfind+0x26>
		if (*s == c)
  80146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801472:	0f b6 00             	movzbl (%rax),%eax
  801475:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801478:	75 02                	jne    80147c <strfind+0x21>
			break;
  80147a:	eb 10                	jmp    80148c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80147c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	84 c0                	test   %al,%al
  80148a:	75 e2                	jne    80146e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80148c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801490:	c9                   	leaveq 
  801491:	c3                   	retq   

0000000000801492 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801492:	55                   	push   %rbp
  801493:	48 89 e5             	mov    %rsp,%rbp
  801496:	48 83 ec 18          	sub    $0x18,%rsp
  80149a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014a5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014aa:	75 06                	jne    8014b2 <memset+0x20>
		return v;
  8014ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b0:	eb 69                	jmp    80151b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b6:	83 e0 03             	and    $0x3,%eax
  8014b9:	48 85 c0             	test   %rax,%rax
  8014bc:	75 48                	jne    801506 <memset+0x74>
  8014be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c2:	83 e0 03             	and    $0x3,%eax
  8014c5:	48 85 c0             	test   %rax,%rax
  8014c8:	75 3c                	jne    801506 <memset+0x74>
		c &= 0xFF;
  8014ca:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d4:	c1 e0 18             	shl    $0x18,%eax
  8014d7:	89 c2                	mov    %eax,%edx
  8014d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014dc:	c1 e0 10             	shl    $0x10,%eax
  8014df:	09 c2                	or     %eax,%edx
  8014e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e4:	c1 e0 08             	shl    $0x8,%eax
  8014e7:	09 d0                	or     %edx,%eax
  8014e9:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f0:	48 c1 e8 02          	shr    $0x2,%rax
  8014f4:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fe:	48 89 d7             	mov    %rdx,%rdi
  801501:	fc                   	cld    
  801502:	f3 ab                	rep stos %eax,%es:(%rdi)
  801504:	eb 11                	jmp    801517 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801506:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80150d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801511:	48 89 d7             	mov    %rdx,%rdi
  801514:	fc                   	cld    
  801515:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80151b:	c9                   	leaveq 
  80151c:	c3                   	retq   

000000000080151d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80151d:	55                   	push   %rbp
  80151e:	48 89 e5             	mov    %rsp,%rbp
  801521:	48 83 ec 28          	sub    $0x28,%rsp
  801525:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801529:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80152d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801531:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801535:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801545:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801549:	0f 83 88 00 00 00    	jae    8015d7 <memmove+0xba>
  80154f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801553:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801557:	48 01 d0             	add    %rdx,%rax
  80155a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80155e:	76 77                	jbe    8015d7 <memmove+0xba>
		s += n;
  801560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801564:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801574:	83 e0 03             	and    $0x3,%eax
  801577:	48 85 c0             	test   %rax,%rax
  80157a:	75 3b                	jne    8015b7 <memmove+0x9a>
  80157c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801580:	83 e0 03             	and    $0x3,%eax
  801583:	48 85 c0             	test   %rax,%rax
  801586:	75 2f                	jne    8015b7 <memmove+0x9a>
  801588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158c:	83 e0 03             	and    $0x3,%eax
  80158f:	48 85 c0             	test   %rax,%rax
  801592:	75 23                	jne    8015b7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801598:	48 83 e8 04          	sub    $0x4,%rax
  80159c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a0:	48 83 ea 04          	sub    $0x4,%rdx
  8015a4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015ac:	48 89 c7             	mov    %rax,%rdi
  8015af:	48 89 d6             	mov    %rdx,%rsi
  8015b2:	fd                   	std    
  8015b3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015b5:	eb 1d                	jmp    8015d4 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cb:	48 89 d7             	mov    %rdx,%rdi
  8015ce:	48 89 c1             	mov    %rax,%rcx
  8015d1:	fd                   	std    
  8015d2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015d4:	fc                   	cld    
  8015d5:	eb 57                	jmp    80162e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015db:	83 e0 03             	and    $0x3,%eax
  8015de:	48 85 c0             	test   %rax,%rax
  8015e1:	75 36                	jne    801619 <memmove+0xfc>
  8015e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e7:	83 e0 03             	and    $0x3,%eax
  8015ea:	48 85 c0             	test   %rax,%rax
  8015ed:	75 2a                	jne    801619 <memmove+0xfc>
  8015ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f3:	83 e0 03             	and    $0x3,%eax
  8015f6:	48 85 c0             	test   %rax,%rax
  8015f9:	75 1e                	jne    801619 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ff:	48 c1 e8 02          	shr    $0x2,%rax
  801603:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80160e:	48 89 c7             	mov    %rax,%rdi
  801611:	48 89 d6             	mov    %rdx,%rsi
  801614:	fc                   	cld    
  801615:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801617:	eb 15                	jmp    80162e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801619:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801621:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801625:	48 89 c7             	mov    %rax,%rdi
  801628:	48 89 d6             	mov    %rdx,%rsi
  80162b:	fc                   	cld    
  80162c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80162e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801632:	c9                   	leaveq 
  801633:	c3                   	retq   

0000000000801634 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801634:	55                   	push   %rbp
  801635:	48 89 e5             	mov    %rsp,%rbp
  801638:	48 83 ec 18          	sub    $0x18,%rsp
  80163c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801640:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801644:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801648:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80164c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801650:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801654:	48 89 ce             	mov    %rcx,%rsi
  801657:	48 89 c7             	mov    %rax,%rdi
  80165a:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  801661:	00 00 00 
  801664:	ff d0                	callq  *%rax
}
  801666:	c9                   	leaveq 
  801667:	c3                   	retq   

0000000000801668 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801668:	55                   	push   %rbp
  801669:	48 89 e5             	mov    %rsp,%rbp
  80166c:	48 83 ec 28          	sub    $0x28,%rsp
  801670:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801674:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801678:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80167c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801680:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801684:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801688:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80168c:	eb 36                	jmp    8016c4 <memcmp+0x5c>
		if (*s1 != *s2)
  80168e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801692:	0f b6 10             	movzbl (%rax),%edx
  801695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801699:	0f b6 00             	movzbl (%rax),%eax
  80169c:	38 c2                	cmp    %al,%dl
  80169e:	74 1a                	je     8016ba <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	0f b6 d0             	movzbl %al,%edx
  8016aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ae:	0f b6 00             	movzbl (%rax),%eax
  8016b1:	0f b6 c0             	movzbl %al,%eax
  8016b4:	29 c2                	sub    %eax,%edx
  8016b6:	89 d0                	mov    %edx,%eax
  8016b8:	eb 20                	jmp    8016da <memcmp+0x72>
		s1++, s2++;
  8016ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016bf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016d0:	48 85 c0             	test   %rax,%rax
  8016d3:	75 b9                	jne    80168e <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016da:	c9                   	leaveq 
  8016db:	c3                   	retq   

00000000008016dc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016dc:	55                   	push   %rbp
  8016dd:	48 89 e5             	mov    %rsp,%rbp
  8016e0:	48 83 ec 28          	sub    $0x28,%rsp
  8016e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016f7:	48 01 d0             	add    %rdx,%rax
  8016fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016fe:	eb 15                	jmp    801715 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801704:	0f b6 10             	movzbl (%rax),%edx
  801707:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80170a:	38 c2                	cmp    %al,%dl
  80170c:	75 02                	jne    801710 <memfind+0x34>
			break;
  80170e:	eb 0f                	jmp    80171f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801710:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801719:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80171d:	72 e1                	jb     801700 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80171f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801723:	c9                   	leaveq 
  801724:	c3                   	retq   

0000000000801725 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801725:	55                   	push   %rbp
  801726:	48 89 e5             	mov    %rsp,%rbp
  801729:	48 83 ec 34          	sub    $0x34,%rsp
  80172d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801731:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801735:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801738:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80173f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801746:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801747:	eb 05                	jmp    80174e <strtol+0x29>
		s++;
  801749:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	0f b6 00             	movzbl (%rax),%eax
  801755:	3c 20                	cmp    $0x20,%al
  801757:	74 f0                	je     801749 <strtol+0x24>
  801759:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175d:	0f b6 00             	movzbl (%rax),%eax
  801760:	3c 09                	cmp    $0x9,%al
  801762:	74 e5                	je     801749 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801764:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801768:	0f b6 00             	movzbl (%rax),%eax
  80176b:	3c 2b                	cmp    $0x2b,%al
  80176d:	75 07                	jne    801776 <strtol+0x51>
		s++;
  80176f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801774:	eb 17                	jmp    80178d <strtol+0x68>
	else if (*s == '-')
  801776:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177a:	0f b6 00             	movzbl (%rax),%eax
  80177d:	3c 2d                	cmp    $0x2d,%al
  80177f:	75 0c                	jne    80178d <strtol+0x68>
		s++, neg = 1;
  801781:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801786:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80178d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801791:	74 06                	je     801799 <strtol+0x74>
  801793:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801797:	75 28                	jne    8017c1 <strtol+0x9c>
  801799:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179d:	0f b6 00             	movzbl (%rax),%eax
  8017a0:	3c 30                	cmp    $0x30,%al
  8017a2:	75 1d                	jne    8017c1 <strtol+0x9c>
  8017a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a8:	48 83 c0 01          	add    $0x1,%rax
  8017ac:	0f b6 00             	movzbl (%rax),%eax
  8017af:	3c 78                	cmp    $0x78,%al
  8017b1:	75 0e                	jne    8017c1 <strtol+0x9c>
		s += 2, base = 16;
  8017b3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017b8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017bf:	eb 2c                	jmp    8017ed <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017c1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c5:	75 19                	jne    8017e0 <strtol+0xbb>
  8017c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cb:	0f b6 00             	movzbl (%rax),%eax
  8017ce:	3c 30                	cmp    $0x30,%al
  8017d0:	75 0e                	jne    8017e0 <strtol+0xbb>
		s++, base = 8;
  8017d2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017d7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017de:	eb 0d                	jmp    8017ed <strtol+0xc8>
	else if (base == 0)
  8017e0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e4:	75 07                	jne    8017ed <strtol+0xc8>
		base = 10;
  8017e6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f1:	0f b6 00             	movzbl (%rax),%eax
  8017f4:	3c 2f                	cmp    $0x2f,%al
  8017f6:	7e 1d                	jle    801815 <strtol+0xf0>
  8017f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fc:	0f b6 00             	movzbl (%rax),%eax
  8017ff:	3c 39                	cmp    $0x39,%al
  801801:	7f 12                	jg     801815 <strtol+0xf0>
			dig = *s - '0';
  801803:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801807:	0f b6 00             	movzbl (%rax),%eax
  80180a:	0f be c0             	movsbl %al,%eax
  80180d:	83 e8 30             	sub    $0x30,%eax
  801810:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801813:	eb 4e                	jmp    801863 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801819:	0f b6 00             	movzbl (%rax),%eax
  80181c:	3c 60                	cmp    $0x60,%al
  80181e:	7e 1d                	jle    80183d <strtol+0x118>
  801820:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801824:	0f b6 00             	movzbl (%rax),%eax
  801827:	3c 7a                	cmp    $0x7a,%al
  801829:	7f 12                	jg     80183d <strtol+0x118>
			dig = *s - 'a' + 10;
  80182b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182f:	0f b6 00             	movzbl (%rax),%eax
  801832:	0f be c0             	movsbl %al,%eax
  801835:	83 e8 57             	sub    $0x57,%eax
  801838:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80183b:	eb 26                	jmp    801863 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80183d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801841:	0f b6 00             	movzbl (%rax),%eax
  801844:	3c 40                	cmp    $0x40,%al
  801846:	7e 48                	jle    801890 <strtol+0x16b>
  801848:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184c:	0f b6 00             	movzbl (%rax),%eax
  80184f:	3c 5a                	cmp    $0x5a,%al
  801851:	7f 3d                	jg     801890 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801853:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801857:	0f b6 00             	movzbl (%rax),%eax
  80185a:	0f be c0             	movsbl %al,%eax
  80185d:	83 e8 37             	sub    $0x37,%eax
  801860:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801863:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801866:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801869:	7c 02                	jl     80186d <strtol+0x148>
			break;
  80186b:	eb 23                	jmp    801890 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80186d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801872:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801875:	48 98                	cltq   
  801877:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80187c:	48 89 c2             	mov    %rax,%rdx
  80187f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801882:	48 98                	cltq   
  801884:	48 01 d0             	add    %rdx,%rax
  801887:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80188b:	e9 5d ff ff ff       	jmpq   8017ed <strtol+0xc8>

	if (endptr)
  801890:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801895:	74 0b                	je     8018a2 <strtol+0x17d>
		*endptr = (char *) s;
  801897:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80189b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80189f:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018a6:	74 09                	je     8018b1 <strtol+0x18c>
  8018a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ac:	48 f7 d8             	neg    %rax
  8018af:	eb 04                	jmp    8018b5 <strtol+0x190>
  8018b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018b5:	c9                   	leaveq 
  8018b6:	c3                   	retq   

00000000008018b7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018b7:	55                   	push   %rbp
  8018b8:	48 89 e5             	mov    %rsp,%rbp
  8018bb:	48 83 ec 30          	sub    $0x30,%rsp
  8018bf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018cb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018cf:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018d3:	0f b6 00             	movzbl (%rax),%eax
  8018d6:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018d9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018dd:	75 06                	jne    8018e5 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	eb 6b                	jmp    801950 <strstr+0x99>

	len = strlen(str);
  8018e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e9:	48 89 c7             	mov    %rax,%rdi
  8018ec:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  8018f3:	00 00 00 
  8018f6:	ff d0                	callq  *%rax
  8018f8:	48 98                	cltq   
  8018fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801902:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801906:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80190a:	0f b6 00             	movzbl (%rax),%eax
  80190d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801910:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801914:	75 07                	jne    80191d <strstr+0x66>
				return (char *) 0;
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
  80191b:	eb 33                	jmp    801950 <strstr+0x99>
		} while (sc != c);
  80191d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801921:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801924:	75 d8                	jne    8018fe <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801926:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80192e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801932:	48 89 ce             	mov    %rcx,%rsi
  801935:	48 89 c7             	mov    %rax,%rdi
  801938:	48 b8 ae 13 80 00 00 	movabs $0x8013ae,%rax
  80193f:	00 00 00 
  801942:	ff d0                	callq  *%rax
  801944:	85 c0                	test   %eax,%eax
  801946:	75 b6                	jne    8018fe <strstr+0x47>

	return (char *) (in - 1);
  801948:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194c:	48 83 e8 01          	sub    $0x1,%rax
}
  801950:	c9                   	leaveq 
  801951:	c3                   	retq   

0000000000801952 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801952:	55                   	push   %rbp
  801953:	48 89 e5             	mov    %rsp,%rbp
  801956:	53                   	push   %rbx
  801957:	48 83 ec 48          	sub    $0x48,%rsp
  80195b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80195e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801961:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801965:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801969:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80196d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801971:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801974:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801978:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80197c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801980:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801984:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801988:	4c 89 c3             	mov    %r8,%rbx
  80198b:	cd 30                	int    $0x30
  80198d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801991:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801995:	74 3e                	je     8019d5 <syscall+0x83>
  801997:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80199c:	7e 37                	jle    8019d5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80199e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019a5:	49 89 d0             	mov    %rdx,%r8
  8019a8:	89 c1                	mov    %eax,%ecx
  8019aa:	48 ba e8 46 80 00 00 	movabs $0x8046e8,%rdx
  8019b1:	00 00 00 
  8019b4:	be 23 00 00 00       	mov    $0x23,%esi
  8019b9:	48 bf 05 47 80 00 00 	movabs $0x804705,%rdi
  8019c0:	00 00 00 
  8019c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c8:	49 b9 0b 04 80 00 00 	movabs $0x80040b,%r9
  8019cf:	00 00 00 
  8019d2:	41 ff d1             	callq  *%r9

	return ret;
  8019d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019d9:	48 83 c4 48          	add    $0x48,%rsp
  8019dd:	5b                   	pop    %rbx
  8019de:	5d                   	pop    %rbp
  8019df:	c3                   	retq   

00000000008019e0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019e0:	55                   	push   %rbp
  8019e1:	48 89 e5             	mov    %rsp,%rbp
  8019e4:	48 83 ec 20          	sub    $0x20,%rsp
  8019e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ff:	00 
  801a00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0c:	48 89 d1             	mov    %rdx,%rcx
  801a0f:	48 89 c2             	mov    %rax,%rdx
  801a12:	be 00 00 00 00       	mov    $0x0,%esi
  801a17:	bf 00 00 00 00       	mov    $0x0,%edi
  801a1c:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
}
  801a28:	c9                   	leaveq 
  801a29:	c3                   	retq   

0000000000801a2a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a2a:	55                   	push   %rbp
  801a2b:	48 89 e5             	mov    %rsp,%rbp
  801a2e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a32:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a39:	00 
  801a3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a40:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a46:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a50:	be 00 00 00 00       	mov    $0x0,%esi
  801a55:	bf 01 00 00 00       	mov    $0x1,%edi
  801a5a:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801a61:	00 00 00 
  801a64:	ff d0                	callq  *%rax
}
  801a66:	c9                   	leaveq 
  801a67:	c3                   	retq   

0000000000801a68 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a68:	55                   	push   %rbp
  801a69:	48 89 e5             	mov    %rsp,%rbp
  801a6c:	48 83 ec 10          	sub    $0x10,%rsp
  801a70:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a76:	48 98                	cltq   
  801a78:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a7f:	00 
  801a80:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a86:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a91:	48 89 c2             	mov    %rax,%rdx
  801a94:	be 01 00 00 00       	mov    $0x1,%esi
  801a99:	bf 03 00 00 00       	mov    $0x3,%edi
  801a9e:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801aa5:	00 00 00 
  801aa8:	ff d0                	callq  *%rax
}
  801aaa:	c9                   	leaveq 
  801aab:	c3                   	retq   

0000000000801aac <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801aac:	55                   	push   %rbp
  801aad:	48 89 e5             	mov    %rsp,%rbp
  801ab0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ab4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801abb:	00 
  801abc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801acd:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad2:	be 00 00 00 00       	mov    $0x0,%esi
  801ad7:	bf 02 00 00 00       	mov    $0x2,%edi
  801adc:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801ae3:	00 00 00 
  801ae6:	ff d0                	callq  *%rax
}
  801ae8:	c9                   	leaveq 
  801ae9:	c3                   	retq   

0000000000801aea <sys_yield>:

void
sys_yield(void)
{
  801aea:	55                   	push   %rbp
  801aeb:	48 89 e5             	mov    %rsp,%rbp
  801aee:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801af2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af9:	00 
  801afa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b06:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b10:	be 00 00 00 00       	mov    $0x0,%esi
  801b15:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b1a:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801b21:	00 00 00 
  801b24:	ff d0                	callq  *%rax
}
  801b26:	c9                   	leaveq 
  801b27:	c3                   	retq   

0000000000801b28 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b28:	55                   	push   %rbp
  801b29:	48 89 e5             	mov    %rsp,%rbp
  801b2c:	48 83 ec 20          	sub    $0x20,%rsp
  801b30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b37:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b3d:	48 63 c8             	movslq %eax,%rcx
  801b40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b47:	48 98                	cltq   
  801b49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b50:	00 
  801b51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b57:	49 89 c8             	mov    %rcx,%r8
  801b5a:	48 89 d1             	mov    %rdx,%rcx
  801b5d:	48 89 c2             	mov    %rax,%rdx
  801b60:	be 01 00 00 00       	mov    $0x1,%esi
  801b65:	bf 04 00 00 00       	mov    $0x4,%edi
  801b6a:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801b71:	00 00 00 
  801b74:	ff d0                	callq  *%rax
}
  801b76:	c9                   	leaveq 
  801b77:	c3                   	retq   

0000000000801b78 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	48 83 ec 30          	sub    $0x30,%rsp
  801b80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b87:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b8a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b8e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b92:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b95:	48 63 c8             	movslq %eax,%rcx
  801b98:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b9f:	48 63 f0             	movslq %eax,%rsi
  801ba2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba9:	48 98                	cltq   
  801bab:	48 89 0c 24          	mov    %rcx,(%rsp)
  801baf:	49 89 f9             	mov    %rdi,%r9
  801bb2:	49 89 f0             	mov    %rsi,%r8
  801bb5:	48 89 d1             	mov    %rdx,%rcx
  801bb8:	48 89 c2             	mov    %rax,%rdx
  801bbb:	be 01 00 00 00       	mov    $0x1,%esi
  801bc0:	bf 05 00 00 00       	mov    $0x5,%edi
  801bc5:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801bcc:	00 00 00 
  801bcf:	ff d0                	callq  *%rax
}
  801bd1:	c9                   	leaveq 
  801bd2:	c3                   	retq   

0000000000801bd3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bd3:	55                   	push   %rbp
  801bd4:	48 89 e5             	mov    %rsp,%rbp
  801bd7:	48 83 ec 20          	sub    $0x20,%rsp
  801bdb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bde:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801be2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be9:	48 98                	cltq   
  801beb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf2:	00 
  801bf3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bff:	48 89 d1             	mov    %rdx,%rcx
  801c02:	48 89 c2             	mov    %rax,%rdx
  801c05:	be 01 00 00 00       	mov    $0x1,%esi
  801c0a:	bf 06 00 00 00       	mov    $0x6,%edi
  801c0f:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801c16:	00 00 00 
  801c19:	ff d0                	callq  *%rax
}
  801c1b:	c9                   	leaveq 
  801c1c:	c3                   	retq   

0000000000801c1d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c1d:	55                   	push   %rbp
  801c1e:	48 89 e5             	mov    %rsp,%rbp
  801c21:	48 83 ec 10          	sub    $0x10,%rsp
  801c25:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c28:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c2e:	48 63 d0             	movslq %eax,%rdx
  801c31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c34:	48 98                	cltq   
  801c36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c3d:	00 
  801c3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c4a:	48 89 d1             	mov    %rdx,%rcx
  801c4d:	48 89 c2             	mov    %rax,%rdx
  801c50:	be 01 00 00 00       	mov    $0x1,%esi
  801c55:	bf 08 00 00 00       	mov    $0x8,%edi
  801c5a:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801c61:	00 00 00 
  801c64:	ff d0                	callq  *%rax
}
  801c66:	c9                   	leaveq 
  801c67:	c3                   	retq   

0000000000801c68 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c68:	55                   	push   %rbp
  801c69:	48 89 e5             	mov    %rsp,%rbp
  801c6c:	48 83 ec 20          	sub    $0x20,%rsp
  801c70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c7e:	48 98                	cltq   
  801c80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c87:	00 
  801c88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c94:	48 89 d1             	mov    %rdx,%rcx
  801c97:	48 89 c2             	mov    %rax,%rdx
  801c9a:	be 01 00 00 00       	mov    $0x1,%esi
  801c9f:	bf 09 00 00 00       	mov    $0x9,%edi
  801ca4:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801cab:	00 00 00 
  801cae:	ff d0                	callq  *%rax
}
  801cb0:	c9                   	leaveq 
  801cb1:	c3                   	retq   

0000000000801cb2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cb2:	55                   	push   %rbp
  801cb3:	48 89 e5             	mov    %rsp,%rbp
  801cb6:	48 83 ec 20          	sub    $0x20,%rsp
  801cba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cbd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cc1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc8:	48 98                	cltq   
  801cca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd1:	00 
  801cd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cde:	48 89 d1             	mov    %rdx,%rcx
  801ce1:	48 89 c2             	mov    %rax,%rdx
  801ce4:	be 01 00 00 00       	mov    $0x1,%esi
  801ce9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cee:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801cf5:	00 00 00 
  801cf8:	ff d0                	callq  *%rax
}
  801cfa:	c9                   	leaveq 
  801cfb:	c3                   	retq   

0000000000801cfc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cfc:	55                   	push   %rbp
  801cfd:	48 89 e5             	mov    %rsp,%rbp
  801d00:	48 83 ec 20          	sub    $0x20,%rsp
  801d04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d0b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d0f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d15:	48 63 f0             	movslq %eax,%rsi
  801d18:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1f:	48 98                	cltq   
  801d21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d2c:	00 
  801d2d:	49 89 f1             	mov    %rsi,%r9
  801d30:	49 89 c8             	mov    %rcx,%r8
  801d33:	48 89 d1             	mov    %rdx,%rcx
  801d36:	48 89 c2             	mov    %rax,%rdx
  801d39:	be 00 00 00 00       	mov    $0x0,%esi
  801d3e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d43:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801d4a:	00 00 00 
  801d4d:	ff d0                	callq  *%rax
}
  801d4f:	c9                   	leaveq 
  801d50:	c3                   	retq   

0000000000801d51 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d51:	55                   	push   %rbp
  801d52:	48 89 e5             	mov    %rsp,%rbp
  801d55:	48 83 ec 10          	sub    $0x10,%rsp
  801d59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d61:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d68:	00 
  801d69:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d6f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d75:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d7a:	48 89 c2             	mov    %rax,%rdx
  801d7d:	be 01 00 00 00       	mov    $0x1,%esi
  801d82:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d87:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801d8e:	00 00 00 
  801d91:	ff d0                	callq  *%rax
}
  801d93:	c9                   	leaveq 
  801d94:	c3                   	retq   

0000000000801d95 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  801d95:	55                   	push   %rbp
  801d96:	48 89 e5             	mov    %rsp,%rbp
  801d99:	48 83 ec 20          	sub    $0x20,%rsp
  801d9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801da1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  801da5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db4:	00 
  801db5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc1:	48 89 d1             	mov    %rdx,%rcx
  801dc4:	48 89 c2             	mov    %rax,%rdx
  801dc7:	be 01 00 00 00       	mov    $0x1,%esi
  801dcc:	bf 0f 00 00 00       	mov    $0xf,%edi
  801dd1:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801dd8:	00 00 00 
  801ddb:	ff d0                	callq  *%rax
}
  801ddd:	c9                   	leaveq 
  801dde:	c3                   	retq   

0000000000801ddf <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  801ddf:	55                   	push   %rbp
  801de0:	48 89 e5             	mov    %rsp,%rbp
  801de3:	48 83 ec 10          	sub    $0x10,%rsp
  801de7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  801deb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801def:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801df6:	00 
  801df7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dfd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e03:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e08:	48 89 c2             	mov    %rax,%rdx
  801e0b:	be 00 00 00 00       	mov    $0x0,%esi
  801e10:	bf 10 00 00 00       	mov    $0x10,%edi
  801e15:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801e1c:	00 00 00 
  801e1f:	ff d0                	callq  *%rax
}
  801e21:	c9                   	leaveq 
  801e22:	c3                   	retq   

0000000000801e23 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801e23:	55                   	push   %rbp
  801e24:	48 89 e5             	mov    %rsp,%rbp
  801e27:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e2b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e32:	00 
  801e33:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e39:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e44:	ba 00 00 00 00       	mov    $0x0,%edx
  801e49:	be 00 00 00 00       	mov    $0x0,%esi
  801e4e:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e53:	48 b8 52 19 80 00 00 	movabs $0x801952,%rax
  801e5a:	00 00 00 
  801e5d:	ff d0                	callq  *%rax
}
  801e5f:	c9                   	leaveq 
  801e60:	c3                   	retq   

0000000000801e61 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e61:	55                   	push   %rbp
  801e62:	48 89 e5             	mov    %rsp,%rbp
  801e65:	48 83 ec 08          	sub    $0x8,%rsp
  801e69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e6d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e71:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e78:	ff ff ff 
  801e7b:	48 01 d0             	add    %rdx,%rax
  801e7e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e82:	c9                   	leaveq 
  801e83:	c3                   	retq   

0000000000801e84 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e84:	55                   	push   %rbp
  801e85:	48 89 e5             	mov    %rsp,%rbp
  801e88:	48 83 ec 08          	sub    $0x8,%rsp
  801e8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e94:	48 89 c7             	mov    %rax,%rdi
  801e97:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  801e9e:	00 00 00 
  801ea1:	ff d0                	callq  *%rax
  801ea3:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ea9:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ead:	c9                   	leaveq 
  801eae:	c3                   	retq   

0000000000801eaf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801eaf:	55                   	push   %rbp
  801eb0:	48 89 e5             	mov    %rsp,%rbp
  801eb3:	48 83 ec 18          	sub    $0x18,%rsp
  801eb7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ebb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ec2:	eb 6b                	jmp    801f2f <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ec4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec7:	48 98                	cltq   
  801ec9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ecf:	48 c1 e0 0c          	shl    $0xc,%rax
  801ed3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801edb:	48 c1 e8 15          	shr    $0x15,%rax
  801edf:	48 89 c2             	mov    %rax,%rdx
  801ee2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ee9:	01 00 00 
  801eec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef0:	83 e0 01             	and    $0x1,%eax
  801ef3:	48 85 c0             	test   %rax,%rax
  801ef6:	74 21                	je     801f19 <fd_alloc+0x6a>
  801ef8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801efc:	48 c1 e8 0c          	shr    $0xc,%rax
  801f00:	48 89 c2             	mov    %rax,%rdx
  801f03:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f0a:	01 00 00 
  801f0d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f11:	83 e0 01             	and    $0x1,%eax
  801f14:	48 85 c0             	test   %rax,%rax
  801f17:	75 12                	jne    801f2b <fd_alloc+0x7c>
			*fd_store = fd;
  801f19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f21:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f24:	b8 00 00 00 00       	mov    $0x0,%eax
  801f29:	eb 1a                	jmp    801f45 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f2b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f2f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f33:	7e 8f                	jle    801ec4 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f39:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f40:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f45:	c9                   	leaveq 
  801f46:	c3                   	retq   

0000000000801f47 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f47:	55                   	push   %rbp
  801f48:	48 89 e5             	mov    %rsp,%rbp
  801f4b:	48 83 ec 20          	sub    $0x20,%rsp
  801f4f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f56:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f5a:	78 06                	js     801f62 <fd_lookup+0x1b>
  801f5c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f60:	7e 07                	jle    801f69 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f67:	eb 6c                	jmp    801fd5 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f6c:	48 98                	cltq   
  801f6e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f74:	48 c1 e0 0c          	shl    $0xc,%rax
  801f78:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f80:	48 c1 e8 15          	shr    $0x15,%rax
  801f84:	48 89 c2             	mov    %rax,%rdx
  801f87:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f8e:	01 00 00 
  801f91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f95:	83 e0 01             	and    $0x1,%eax
  801f98:	48 85 c0             	test   %rax,%rax
  801f9b:	74 21                	je     801fbe <fd_lookup+0x77>
  801f9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa1:	48 c1 e8 0c          	shr    $0xc,%rax
  801fa5:	48 89 c2             	mov    %rax,%rdx
  801fa8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801faf:	01 00 00 
  801fb2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb6:	83 e0 01             	and    $0x1,%eax
  801fb9:	48 85 c0             	test   %rax,%rax
  801fbc:	75 07                	jne    801fc5 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fbe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fc3:	eb 10                	jmp    801fd5 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fc9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fcd:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd5:	c9                   	leaveq 
  801fd6:	c3                   	retq   

0000000000801fd7 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fd7:	55                   	push   %rbp
  801fd8:	48 89 e5             	mov    %rsp,%rbp
  801fdb:	48 83 ec 30          	sub    $0x30,%rsp
  801fdf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fe3:	89 f0                	mov    %esi,%eax
  801fe5:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fe8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fec:	48 89 c7             	mov    %rax,%rdi
  801fef:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  801ff6:	00 00 00 
  801ff9:	ff d0                	callq  *%rax
  801ffb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fff:	48 89 d6             	mov    %rdx,%rsi
  802002:	89 c7                	mov    %eax,%edi
  802004:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  80200b:	00 00 00 
  80200e:	ff d0                	callq  *%rax
  802010:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802013:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802017:	78 0a                	js     802023 <fd_close+0x4c>
	    || fd != fd2)
  802019:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80201d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802021:	74 12                	je     802035 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802023:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802027:	74 05                	je     80202e <fd_close+0x57>
  802029:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80202c:	eb 05                	jmp    802033 <fd_close+0x5c>
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
  802033:	eb 69                	jmp    80209e <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802035:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802039:	8b 00                	mov    (%rax),%eax
  80203b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80203f:	48 89 d6             	mov    %rdx,%rsi
  802042:	89 c7                	mov    %eax,%edi
  802044:	48 b8 a0 20 80 00 00 	movabs $0x8020a0,%rax
  80204b:	00 00 00 
  80204e:	ff d0                	callq  *%rax
  802050:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802053:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802057:	78 2a                	js     802083 <fd_close+0xac>
		if (dev->dev_close)
  802059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802061:	48 85 c0             	test   %rax,%rax
  802064:	74 16                	je     80207c <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80206e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802072:	48 89 d7             	mov    %rdx,%rdi
  802075:	ff d0                	callq  *%rax
  802077:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80207a:	eb 07                	jmp    802083 <fd_close+0xac>
		else
			r = 0;
  80207c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802083:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802087:	48 89 c6             	mov    %rax,%rsi
  80208a:	bf 00 00 00 00       	mov    $0x0,%edi
  80208f:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  802096:	00 00 00 
  802099:	ff d0                	callq  *%rax
	return r;
  80209b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80209e:	c9                   	leaveq 
  80209f:	c3                   	retq   

00000000008020a0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020a0:	55                   	push   %rbp
  8020a1:	48 89 e5             	mov    %rsp,%rbp
  8020a4:	48 83 ec 20          	sub    $0x20,%rsp
  8020a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020b6:	eb 41                	jmp    8020f9 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020b8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020bf:	00 00 00 
  8020c2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020c5:	48 63 d2             	movslq %edx,%rdx
  8020c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020cc:	8b 00                	mov    (%rax),%eax
  8020ce:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020d1:	75 22                	jne    8020f5 <dev_lookup+0x55>
			*dev = devtab[i];
  8020d3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020da:	00 00 00 
  8020dd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020e0:	48 63 d2             	movslq %edx,%rdx
  8020e3:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020eb:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f3:	eb 60                	jmp    802155 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020f5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020f9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802100:	00 00 00 
  802103:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802106:	48 63 d2             	movslq %edx,%rdx
  802109:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80210d:	48 85 c0             	test   %rax,%rax
  802110:	75 a6                	jne    8020b8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802112:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802119:	00 00 00 
  80211c:	48 8b 00             	mov    (%rax),%rax
  80211f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802125:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802128:	89 c6                	mov    %eax,%esi
  80212a:	48 bf 18 47 80 00 00 	movabs $0x804718,%rdi
  802131:	00 00 00 
  802134:	b8 00 00 00 00       	mov    $0x0,%eax
  802139:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  802140:	00 00 00 
  802143:	ff d1                	callq  *%rcx
	*dev = 0;
  802145:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802149:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802150:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802155:	c9                   	leaveq 
  802156:	c3                   	retq   

0000000000802157 <close>:

int
close(int fdnum)
{
  802157:	55                   	push   %rbp
  802158:	48 89 e5             	mov    %rsp,%rbp
  80215b:	48 83 ec 20          	sub    $0x20,%rsp
  80215f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802162:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802166:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802169:	48 89 d6             	mov    %rdx,%rsi
  80216c:	89 c7                	mov    %eax,%edi
  80216e:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  802175:	00 00 00 
  802178:	ff d0                	callq  *%rax
  80217a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802181:	79 05                	jns    802188 <close+0x31>
		return r;
  802183:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802186:	eb 18                	jmp    8021a0 <close+0x49>
	else
		return fd_close(fd, 1);
  802188:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80218c:	be 01 00 00 00       	mov    $0x1,%esi
  802191:	48 89 c7             	mov    %rax,%rdi
  802194:	48 b8 d7 1f 80 00 00 	movabs $0x801fd7,%rax
  80219b:	00 00 00 
  80219e:	ff d0                	callq  *%rax
}
  8021a0:	c9                   	leaveq 
  8021a1:	c3                   	retq   

00000000008021a2 <close_all>:

void
close_all(void)
{
  8021a2:	55                   	push   %rbp
  8021a3:	48 89 e5             	mov    %rsp,%rbp
  8021a6:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021b1:	eb 15                	jmp    8021c8 <close_all+0x26>
		close(i);
  8021b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b6:	89 c7                	mov    %eax,%edi
  8021b8:	48 b8 57 21 80 00 00 	movabs $0x802157,%rax
  8021bf:	00 00 00 
  8021c2:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8021c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021c8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021cc:	7e e5                	jle    8021b3 <close_all+0x11>
		close(i);
}
  8021ce:	c9                   	leaveq 
  8021cf:	c3                   	retq   

00000000008021d0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021d0:	55                   	push   %rbp
  8021d1:	48 89 e5             	mov    %rsp,%rbp
  8021d4:	48 83 ec 40          	sub    $0x40,%rsp
  8021d8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021db:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021de:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021e2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021e5:	48 89 d6             	mov    %rdx,%rsi
  8021e8:	89 c7                	mov    %eax,%edi
  8021ea:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  8021f1:	00 00 00 
  8021f4:	ff d0                	callq  *%rax
  8021f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021fd:	79 08                	jns    802207 <dup+0x37>
		return r;
  8021ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802202:	e9 70 01 00 00       	jmpq   802377 <dup+0x1a7>
	close(newfdnum);
  802207:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80220a:	89 c7                	mov    %eax,%edi
  80220c:	48 b8 57 21 80 00 00 	movabs $0x802157,%rax
  802213:	00 00 00 
  802216:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802218:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80221b:	48 98                	cltq   
  80221d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802223:	48 c1 e0 0c          	shl    $0xc,%rax
  802227:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80222b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80222f:	48 89 c7             	mov    %rax,%rdi
  802232:	48 b8 84 1e 80 00 00 	movabs $0x801e84,%rax
  802239:	00 00 00 
  80223c:	ff d0                	callq  *%rax
  80223e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802246:	48 89 c7             	mov    %rax,%rdi
  802249:	48 b8 84 1e 80 00 00 	movabs $0x801e84,%rax
  802250:	00 00 00 
  802253:	ff d0                	callq  *%rax
  802255:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225d:	48 c1 e8 15          	shr    $0x15,%rax
  802261:	48 89 c2             	mov    %rax,%rdx
  802264:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80226b:	01 00 00 
  80226e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802272:	83 e0 01             	and    $0x1,%eax
  802275:	48 85 c0             	test   %rax,%rax
  802278:	74 73                	je     8022ed <dup+0x11d>
  80227a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227e:	48 c1 e8 0c          	shr    $0xc,%rax
  802282:	48 89 c2             	mov    %rax,%rdx
  802285:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80228c:	01 00 00 
  80228f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802293:	83 e0 01             	and    $0x1,%eax
  802296:	48 85 c0             	test   %rax,%rax
  802299:	74 52                	je     8022ed <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80229b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229f:	48 c1 e8 0c          	shr    $0xc,%rax
  8022a3:	48 89 c2             	mov    %rax,%rdx
  8022a6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ad:	01 00 00 
  8022b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8022b9:	89 c1                	mov    %eax,%ecx
  8022bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c3:	41 89 c8             	mov    %ecx,%r8d
  8022c6:	48 89 d1             	mov    %rdx,%rcx
  8022c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ce:	48 89 c6             	mov    %rax,%rsi
  8022d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d6:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  8022dd:	00 00 00 
  8022e0:	ff d0                	callq  *%rax
  8022e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e9:	79 02                	jns    8022ed <dup+0x11d>
			goto err;
  8022eb:	eb 57                	jmp    802344 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8022ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022f1:	48 c1 e8 0c          	shr    $0xc,%rax
  8022f5:	48 89 c2             	mov    %rax,%rdx
  8022f8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ff:	01 00 00 
  802302:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802306:	25 07 0e 00 00       	and    $0xe07,%eax
  80230b:	89 c1                	mov    %eax,%ecx
  80230d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802311:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802315:	41 89 c8             	mov    %ecx,%r8d
  802318:	48 89 d1             	mov    %rdx,%rcx
  80231b:	ba 00 00 00 00       	mov    $0x0,%edx
  802320:	48 89 c6             	mov    %rax,%rsi
  802323:	bf 00 00 00 00       	mov    $0x0,%edi
  802328:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  80232f:	00 00 00 
  802332:	ff d0                	callq  *%rax
  802334:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802337:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80233b:	79 02                	jns    80233f <dup+0x16f>
		goto err;
  80233d:	eb 05                	jmp    802344 <dup+0x174>

	return newfdnum;
  80233f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802342:	eb 33                	jmp    802377 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802344:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802348:	48 89 c6             	mov    %rax,%rsi
  80234b:	bf 00 00 00 00       	mov    $0x0,%edi
  802350:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  802357:	00 00 00 
  80235a:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80235c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802360:	48 89 c6             	mov    %rax,%rsi
  802363:	bf 00 00 00 00       	mov    $0x0,%edi
  802368:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  80236f:	00 00 00 
  802372:	ff d0                	callq  *%rax
	return r;
  802374:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802377:	c9                   	leaveq 
  802378:	c3                   	retq   

0000000000802379 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802379:	55                   	push   %rbp
  80237a:	48 89 e5             	mov    %rsp,%rbp
  80237d:	48 83 ec 40          	sub    $0x40,%rsp
  802381:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802384:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802388:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80238c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802390:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802393:	48 89 d6             	mov    %rdx,%rsi
  802396:	89 c7                	mov    %eax,%edi
  802398:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  80239f:	00 00 00 
  8023a2:	ff d0                	callq  *%rax
  8023a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ab:	78 24                	js     8023d1 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b1:	8b 00                	mov    (%rax),%eax
  8023b3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b7:	48 89 d6             	mov    %rdx,%rsi
  8023ba:	89 c7                	mov    %eax,%edi
  8023bc:	48 b8 a0 20 80 00 00 	movabs $0x8020a0,%rax
  8023c3:	00 00 00 
  8023c6:	ff d0                	callq  *%rax
  8023c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023cf:	79 05                	jns    8023d6 <read+0x5d>
		return r;
  8023d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d4:	eb 76                	jmp    80244c <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023da:	8b 40 08             	mov    0x8(%rax),%eax
  8023dd:	83 e0 03             	and    $0x3,%eax
  8023e0:	83 f8 01             	cmp    $0x1,%eax
  8023e3:	75 3a                	jne    80241f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023e5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023ec:	00 00 00 
  8023ef:	48 8b 00             	mov    (%rax),%rax
  8023f2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023f8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023fb:	89 c6                	mov    %eax,%esi
  8023fd:	48 bf 37 47 80 00 00 	movabs $0x804737,%rdi
  802404:	00 00 00 
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
  80240c:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  802413:	00 00 00 
  802416:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802418:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80241d:	eb 2d                	jmp    80244c <read+0xd3>
	}
	if (!dev->dev_read)
  80241f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802423:	48 8b 40 10          	mov    0x10(%rax),%rax
  802427:	48 85 c0             	test   %rax,%rax
  80242a:	75 07                	jne    802433 <read+0xba>
		return -E_NOT_SUPP;
  80242c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802431:	eb 19                	jmp    80244c <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802433:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802437:	48 8b 40 10          	mov    0x10(%rax),%rax
  80243b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80243f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802443:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802447:	48 89 cf             	mov    %rcx,%rdi
  80244a:	ff d0                	callq  *%rax
}
  80244c:	c9                   	leaveq 
  80244d:	c3                   	retq   

000000000080244e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80244e:	55                   	push   %rbp
  80244f:	48 89 e5             	mov    %rsp,%rbp
  802452:	48 83 ec 30          	sub    $0x30,%rsp
  802456:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802459:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80245d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802461:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802468:	eb 49                	jmp    8024b3 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80246a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246d:	48 98                	cltq   
  80246f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802473:	48 29 c2             	sub    %rax,%rdx
  802476:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802479:	48 63 c8             	movslq %eax,%rcx
  80247c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802480:	48 01 c1             	add    %rax,%rcx
  802483:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802486:	48 89 ce             	mov    %rcx,%rsi
  802489:	89 c7                	mov    %eax,%edi
  80248b:	48 b8 79 23 80 00 00 	movabs $0x802379,%rax
  802492:	00 00 00 
  802495:	ff d0                	callq  *%rax
  802497:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80249a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80249e:	79 05                	jns    8024a5 <readn+0x57>
			return m;
  8024a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024a3:	eb 1c                	jmp    8024c1 <readn+0x73>
		if (m == 0)
  8024a5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024a9:	75 02                	jne    8024ad <readn+0x5f>
			break;
  8024ab:	eb 11                	jmp    8024be <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8024ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024b0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b6:	48 98                	cltq   
  8024b8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024bc:	72 ac                	jb     80246a <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8024be:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024c1:	c9                   	leaveq 
  8024c2:	c3                   	retq   

00000000008024c3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024c3:	55                   	push   %rbp
  8024c4:	48 89 e5             	mov    %rsp,%rbp
  8024c7:	48 83 ec 40          	sub    $0x40,%rsp
  8024cb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024d2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024d6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024da:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024dd:	48 89 d6             	mov    %rdx,%rsi
  8024e0:	89 c7                	mov    %eax,%edi
  8024e2:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  8024e9:	00 00 00 
  8024ec:	ff d0                	callq  *%rax
  8024ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f5:	78 24                	js     80251b <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fb:	8b 00                	mov    (%rax),%eax
  8024fd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802501:	48 89 d6             	mov    %rdx,%rsi
  802504:	89 c7                	mov    %eax,%edi
  802506:	48 b8 a0 20 80 00 00 	movabs $0x8020a0,%rax
  80250d:	00 00 00 
  802510:	ff d0                	callq  *%rax
  802512:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802515:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802519:	79 05                	jns    802520 <write+0x5d>
		return r;
  80251b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80251e:	eb 75                	jmp    802595 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802524:	8b 40 08             	mov    0x8(%rax),%eax
  802527:	83 e0 03             	and    $0x3,%eax
  80252a:	85 c0                	test   %eax,%eax
  80252c:	75 3a                	jne    802568 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80252e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802535:	00 00 00 
  802538:	48 8b 00             	mov    (%rax),%rax
  80253b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802541:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802544:	89 c6                	mov    %eax,%esi
  802546:	48 bf 53 47 80 00 00 	movabs $0x804753,%rdi
  80254d:	00 00 00 
  802550:	b8 00 00 00 00       	mov    $0x0,%eax
  802555:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  80255c:	00 00 00 
  80255f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802561:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802566:	eb 2d                	jmp    802595 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  802568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802570:	48 85 c0             	test   %rax,%rax
  802573:	75 07                	jne    80257c <write+0xb9>
		return -E_NOT_SUPP;
  802575:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80257a:	eb 19                	jmp    802595 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80257c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802580:	48 8b 40 18          	mov    0x18(%rax),%rax
  802584:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802588:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80258c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802590:	48 89 cf             	mov    %rcx,%rdi
  802593:	ff d0                	callq  *%rax
}
  802595:	c9                   	leaveq 
  802596:	c3                   	retq   

0000000000802597 <seek>:

int
seek(int fdnum, off_t offset)
{
  802597:	55                   	push   %rbp
  802598:	48 89 e5             	mov    %rsp,%rbp
  80259b:	48 83 ec 18          	sub    $0x18,%rsp
  80259f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025a2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025a5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025ac:	48 89 d6             	mov    %rdx,%rsi
  8025af:	89 c7                	mov    %eax,%edi
  8025b1:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  8025b8:	00 00 00 
  8025bb:	ff d0                	callq  *%rax
  8025bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c4:	79 05                	jns    8025cb <seek+0x34>
		return r;
  8025c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c9:	eb 0f                	jmp    8025da <seek+0x43>
	fd->fd_offset = offset;
  8025cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025d2:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025da:	c9                   	leaveq 
  8025db:	c3                   	retq   

00000000008025dc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025dc:	55                   	push   %rbp
  8025dd:	48 89 e5             	mov    %rsp,%rbp
  8025e0:	48 83 ec 30          	sub    $0x30,%rsp
  8025e4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025e7:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025ea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025f1:	48 89 d6             	mov    %rdx,%rsi
  8025f4:	89 c7                	mov    %eax,%edi
  8025f6:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  8025fd:	00 00 00 
  802600:	ff d0                	callq  *%rax
  802602:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802605:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802609:	78 24                	js     80262f <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80260b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260f:	8b 00                	mov    (%rax),%eax
  802611:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802615:	48 89 d6             	mov    %rdx,%rsi
  802618:	89 c7                	mov    %eax,%edi
  80261a:	48 b8 a0 20 80 00 00 	movabs $0x8020a0,%rax
  802621:	00 00 00 
  802624:	ff d0                	callq  *%rax
  802626:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802629:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80262d:	79 05                	jns    802634 <ftruncate+0x58>
		return r;
  80262f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802632:	eb 72                	jmp    8026a6 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802638:	8b 40 08             	mov    0x8(%rax),%eax
  80263b:	83 e0 03             	and    $0x3,%eax
  80263e:	85 c0                	test   %eax,%eax
  802640:	75 3a                	jne    80267c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802642:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802649:	00 00 00 
  80264c:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80264f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802655:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802658:	89 c6                	mov    %eax,%esi
  80265a:	48 bf 70 47 80 00 00 	movabs $0x804770,%rdi
  802661:	00 00 00 
  802664:	b8 00 00 00 00       	mov    $0x0,%eax
  802669:	48 b9 44 06 80 00 00 	movabs $0x800644,%rcx
  802670:	00 00 00 
  802673:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802675:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80267a:	eb 2a                	jmp    8026a6 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80267c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802680:	48 8b 40 30          	mov    0x30(%rax),%rax
  802684:	48 85 c0             	test   %rax,%rax
  802687:	75 07                	jne    802690 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802689:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80268e:	eb 16                	jmp    8026a6 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802690:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802694:	48 8b 40 30          	mov    0x30(%rax),%rax
  802698:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80269c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80269f:	89 ce                	mov    %ecx,%esi
  8026a1:	48 89 d7             	mov    %rdx,%rdi
  8026a4:	ff d0                	callq  *%rax
}
  8026a6:	c9                   	leaveq 
  8026a7:	c3                   	retq   

00000000008026a8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026a8:	55                   	push   %rbp
  8026a9:	48 89 e5             	mov    %rsp,%rbp
  8026ac:	48 83 ec 30          	sub    $0x30,%rsp
  8026b0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026b7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026bb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026be:	48 89 d6             	mov    %rdx,%rsi
  8026c1:	89 c7                	mov    %eax,%edi
  8026c3:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  8026ca:	00 00 00 
  8026cd:	ff d0                	callq  *%rax
  8026cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d6:	78 24                	js     8026fc <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026dc:	8b 00                	mov    (%rax),%eax
  8026de:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026e2:	48 89 d6             	mov    %rdx,%rsi
  8026e5:	89 c7                	mov    %eax,%edi
  8026e7:	48 b8 a0 20 80 00 00 	movabs $0x8020a0,%rax
  8026ee:	00 00 00 
  8026f1:	ff d0                	callq  *%rax
  8026f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026fa:	79 05                	jns    802701 <fstat+0x59>
		return r;
  8026fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ff:	eb 5e                	jmp    80275f <fstat+0xb7>
	if (!dev->dev_stat)
  802701:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802705:	48 8b 40 28          	mov    0x28(%rax),%rax
  802709:	48 85 c0             	test   %rax,%rax
  80270c:	75 07                	jne    802715 <fstat+0x6d>
		return -E_NOT_SUPP;
  80270e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802713:	eb 4a                	jmp    80275f <fstat+0xb7>
	stat->st_name[0] = 0;
  802715:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802719:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80271c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802720:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802727:	00 00 00 
	stat->st_isdir = 0;
  80272a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80272e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802735:	00 00 00 
	stat->st_dev = dev;
  802738:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80273c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802740:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802747:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80274f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802753:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802757:	48 89 ce             	mov    %rcx,%rsi
  80275a:	48 89 d7             	mov    %rdx,%rdi
  80275d:	ff d0                	callq  *%rax
}
  80275f:	c9                   	leaveq 
  802760:	c3                   	retq   

0000000000802761 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802761:	55                   	push   %rbp
  802762:	48 89 e5             	mov    %rsp,%rbp
  802765:	48 83 ec 20          	sub    $0x20,%rsp
  802769:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80276d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802775:	be 00 00 00 00       	mov    $0x0,%esi
  80277a:	48 89 c7             	mov    %rax,%rdi
  80277d:	48 b8 4f 28 80 00 00 	movabs $0x80284f,%rax
  802784:	00 00 00 
  802787:	ff d0                	callq  *%rax
  802789:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802790:	79 05                	jns    802797 <stat+0x36>
		return fd;
  802792:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802795:	eb 2f                	jmp    8027c6 <stat+0x65>
	r = fstat(fd, stat);
  802797:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80279b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279e:	48 89 d6             	mov    %rdx,%rsi
  8027a1:	89 c7                	mov    %eax,%edi
  8027a3:	48 b8 a8 26 80 00 00 	movabs $0x8026a8,%rax
  8027aa:	00 00 00 
  8027ad:	ff d0                	callq  *%rax
  8027af:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b5:	89 c7                	mov    %eax,%edi
  8027b7:	48 b8 57 21 80 00 00 	movabs $0x802157,%rax
  8027be:	00 00 00 
  8027c1:	ff d0                	callq  *%rax
	return r;
  8027c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027c6:	c9                   	leaveq 
  8027c7:	c3                   	retq   

00000000008027c8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027c8:	55                   	push   %rbp
  8027c9:	48 89 e5             	mov    %rsp,%rbp
  8027cc:	48 83 ec 10          	sub    $0x10,%rsp
  8027d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027d7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027de:	00 00 00 
  8027e1:	8b 00                	mov    (%rax),%eax
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	75 1d                	jne    802804 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027e7:	bf 01 00 00 00       	mov    $0x1,%edi
  8027ec:	48 b8 55 40 80 00 00 	movabs $0x804055,%rax
  8027f3:	00 00 00 
  8027f6:	ff d0                	callq  *%rax
  8027f8:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8027ff:	00 00 00 
  802802:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802804:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80280b:	00 00 00 
  80280e:	8b 00                	mov    (%rax),%eax
  802810:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802813:	b9 07 00 00 00       	mov    $0x7,%ecx
  802818:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80281f:	00 00 00 
  802822:	89 c7                	mov    %eax,%edi
  802824:	48 b8 f3 3f 80 00 00 	movabs $0x803ff3,%rax
  80282b:	00 00 00 
  80282e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802830:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802834:	ba 00 00 00 00       	mov    $0x0,%edx
  802839:	48 89 c6             	mov    %rax,%rsi
  80283c:	bf 00 00 00 00       	mov    $0x0,%edi
  802841:	48 b8 ed 3e 80 00 00 	movabs $0x803eed,%rax
  802848:	00 00 00 
  80284b:	ff d0                	callq  *%rax
}
  80284d:	c9                   	leaveq 
  80284e:	c3                   	retq   

000000000080284f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80284f:	55                   	push   %rbp
  802850:	48 89 e5             	mov    %rsp,%rbp
  802853:	48 83 ec 30          	sub    $0x30,%rsp
  802857:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80285b:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80285e:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  802865:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80286c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  802873:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802878:	75 08                	jne    802882 <open+0x33>
	{
		return r;
  80287a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287d:	e9 f2 00 00 00       	jmpq   802974 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  802882:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802886:	48 89 c7             	mov    %rax,%rdi
  802889:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  802890:	00 00 00 
  802893:	ff d0                	callq  *%rax
  802895:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802898:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80289f:	7e 0a                	jle    8028ab <open+0x5c>
	{
		return -E_BAD_PATH;
  8028a1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8028a6:	e9 c9 00 00 00       	jmpq   802974 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8028ab:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8028b2:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  8028b3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8028b7:	48 89 c7             	mov    %rax,%rdi
  8028ba:	48 b8 af 1e 80 00 00 	movabs $0x801eaf,%rax
  8028c1:	00 00 00 
  8028c4:	ff d0                	callq  *%rax
  8028c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028cd:	78 09                	js     8028d8 <open+0x89>
  8028cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d3:	48 85 c0             	test   %rax,%rax
  8028d6:	75 08                	jne    8028e0 <open+0x91>
		{
			return r;
  8028d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028db:	e9 94 00 00 00       	jmpq   802974 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8028e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e4:	ba 00 04 00 00       	mov    $0x400,%edx
  8028e9:	48 89 c6             	mov    %rax,%rsi
  8028ec:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8028f3:	00 00 00 
  8028f6:	48 b8 8b 12 80 00 00 	movabs $0x80128b,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  802902:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802909:	00 00 00 
  80290c:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80290f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  802915:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802919:	48 89 c6             	mov    %rax,%rsi
  80291c:	bf 01 00 00 00       	mov    $0x1,%edi
  802921:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
  802928:	00 00 00 
  80292b:	ff d0                	callq  *%rax
  80292d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802930:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802934:	79 2b                	jns    802961 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  802936:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80293a:	be 00 00 00 00       	mov    $0x0,%esi
  80293f:	48 89 c7             	mov    %rax,%rdi
  802942:	48 b8 d7 1f 80 00 00 	movabs $0x801fd7,%rax
  802949:	00 00 00 
  80294c:	ff d0                	callq  *%rax
  80294e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802951:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802955:	79 05                	jns    80295c <open+0x10d>
			{
				return d;
  802957:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80295a:	eb 18                	jmp    802974 <open+0x125>
			}
			return r;
  80295c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295f:	eb 13                	jmp    802974 <open+0x125>
		}	
		return fd2num(fd_store);
  802961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802965:	48 89 c7             	mov    %rax,%rdi
  802968:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  80296f:	00 00 00 
  802972:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  802974:	c9                   	leaveq 
  802975:	c3                   	retq   

0000000000802976 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802976:	55                   	push   %rbp
  802977:	48 89 e5             	mov    %rsp,%rbp
  80297a:	48 83 ec 10          	sub    $0x10,%rsp
  80297e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802982:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802986:	8b 50 0c             	mov    0xc(%rax),%edx
  802989:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802990:	00 00 00 
  802993:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802995:	be 00 00 00 00       	mov    $0x0,%esi
  80299a:	bf 06 00 00 00       	mov    $0x6,%edi
  80299f:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
  8029a6:	00 00 00 
  8029a9:	ff d0                	callq  *%rax
}
  8029ab:	c9                   	leaveq 
  8029ac:	c3                   	retq   

00000000008029ad <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8029ad:	55                   	push   %rbp
  8029ae:	48 89 e5             	mov    %rsp,%rbp
  8029b1:	48 83 ec 30          	sub    $0x30,%rsp
  8029b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  8029c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  8029c8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029cd:	74 07                	je     8029d6 <devfile_read+0x29>
  8029cf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8029d4:	75 07                	jne    8029dd <devfile_read+0x30>
		return -E_INVAL;
  8029d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029db:	eb 77                	jmp    802a54 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8029dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e1:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029eb:	00 00 00 
  8029ee:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8029f0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029f7:	00 00 00 
  8029fa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029fe:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  802a02:	be 00 00 00 00       	mov    $0x0,%esi
  802a07:	bf 03 00 00 00       	mov    $0x3,%edi
  802a0c:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
  802a13:	00 00 00 
  802a16:	ff d0                	callq  *%rax
  802a18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1f:	7f 05                	jg     802a26 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  802a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a24:	eb 2e                	jmp    802a54 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  802a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a29:	48 63 d0             	movslq %eax,%rdx
  802a2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a30:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a37:	00 00 00 
  802a3a:	48 89 c7             	mov    %rax,%rdi
  802a3d:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  802a44:	00 00 00 
  802a47:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  802a49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a4d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  802a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802a54:	c9                   	leaveq 
  802a55:	c3                   	retq   

0000000000802a56 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a56:	55                   	push   %rbp
  802a57:	48 89 e5             	mov    %rsp,%rbp
  802a5a:	48 83 ec 30          	sub    $0x30,%rsp
  802a5e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a62:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a66:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  802a6a:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  802a71:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a76:	74 07                	je     802a7f <devfile_write+0x29>
  802a78:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802a7d:	75 08                	jne    802a87 <devfile_write+0x31>
		return r;
  802a7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a82:	e9 9a 00 00 00       	jmpq   802b21 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8b:	8b 50 0c             	mov    0xc(%rax),%edx
  802a8e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a95:	00 00 00 
  802a98:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  802a9a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802aa1:	00 
  802aa2:	76 08                	jbe    802aac <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  802aa4:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802aab:	00 
	}
	fsipcbuf.write.req_n = n;
  802aac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ab3:	00 00 00 
  802ab6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802aba:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  802abe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ac2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ac6:	48 89 c6             	mov    %rax,%rsi
  802ac9:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ad0:	00 00 00 
  802ad3:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  802ada:	00 00 00 
  802add:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  802adf:	be 00 00 00 00       	mov    $0x0,%esi
  802ae4:	bf 04 00 00 00       	mov    $0x4,%edi
  802ae9:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
  802af0:	00 00 00 
  802af3:	ff d0                	callq  *%rax
  802af5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afc:	7f 20                	jg     802b1e <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  802afe:	48 bf 96 47 80 00 00 	movabs $0x804796,%rdi
  802b05:	00 00 00 
  802b08:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0d:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  802b14:	00 00 00 
  802b17:	ff d2                	callq  *%rdx
		return r;
  802b19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1c:	eb 03                	jmp    802b21 <devfile_write+0xcb>
	}
	return r;
  802b1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  802b21:	c9                   	leaveq 
  802b22:	c3                   	retq   

0000000000802b23 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802b23:	55                   	push   %rbp
  802b24:	48 89 e5             	mov    %rsp,%rbp
  802b27:	48 83 ec 20          	sub    $0x20,%rsp
  802b2b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b2f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802b33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b37:	8b 50 0c             	mov    0xc(%rax),%edx
  802b3a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b41:	00 00 00 
  802b44:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802b46:	be 00 00 00 00       	mov    $0x0,%esi
  802b4b:	bf 05 00 00 00       	mov    $0x5,%edi
  802b50:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
  802b57:	00 00 00 
  802b5a:	ff d0                	callq  *%rax
  802b5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b63:	79 05                	jns    802b6a <devfile_stat+0x47>
		return r;
  802b65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b68:	eb 56                	jmp    802bc0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b6e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b75:	00 00 00 
  802b78:	48 89 c7             	mov    %rax,%rdi
  802b7b:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  802b82:	00 00 00 
  802b85:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b87:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b8e:	00 00 00 
  802b91:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b9b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ba1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ba8:	00 00 00 
  802bab:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802bb1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bc0:	c9                   	leaveq 
  802bc1:	c3                   	retq   

0000000000802bc2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802bc2:	55                   	push   %rbp
  802bc3:	48 89 e5             	mov    %rsp,%rbp
  802bc6:	48 83 ec 10          	sub    $0x10,%rsp
  802bca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bce:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802bd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd5:	8b 50 0c             	mov    0xc(%rax),%edx
  802bd8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bdf:	00 00 00 
  802be2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802be4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802beb:	00 00 00 
  802bee:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802bf1:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802bf4:	be 00 00 00 00       	mov    $0x0,%esi
  802bf9:	bf 02 00 00 00       	mov    $0x2,%edi
  802bfe:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
  802c05:	00 00 00 
  802c08:	ff d0                	callq  *%rax
}
  802c0a:	c9                   	leaveq 
  802c0b:	c3                   	retq   

0000000000802c0c <remove>:

// Delete a file
int
remove(const char *path)
{
  802c0c:	55                   	push   %rbp
  802c0d:	48 89 e5             	mov    %rsp,%rbp
  802c10:	48 83 ec 10          	sub    $0x10,%rsp
  802c14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802c18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c1c:	48 89 c7             	mov    %rax,%rdi
  802c1f:	48 b8 8d 11 80 00 00 	movabs $0x80118d,%rax
  802c26:	00 00 00 
  802c29:	ff d0                	callq  *%rax
  802c2b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c30:	7e 07                	jle    802c39 <remove+0x2d>
		return -E_BAD_PATH;
  802c32:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c37:	eb 33                	jmp    802c6c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802c39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c3d:	48 89 c6             	mov    %rax,%rsi
  802c40:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c47:	00 00 00 
  802c4a:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802c56:	be 00 00 00 00       	mov    $0x0,%esi
  802c5b:	bf 07 00 00 00       	mov    $0x7,%edi
  802c60:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
  802c67:	00 00 00 
  802c6a:	ff d0                	callq  *%rax
}
  802c6c:	c9                   	leaveq 
  802c6d:	c3                   	retq   

0000000000802c6e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c6e:	55                   	push   %rbp
  802c6f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c72:	be 00 00 00 00       	mov    $0x0,%esi
  802c77:	bf 08 00 00 00       	mov    $0x8,%edi
  802c7c:	48 b8 c8 27 80 00 00 	movabs $0x8027c8,%rax
  802c83:	00 00 00 
  802c86:	ff d0                	callq  *%rax
}
  802c88:	5d                   	pop    %rbp
  802c89:	c3                   	retq   

0000000000802c8a <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c8a:	55                   	push   %rbp
  802c8b:	48 89 e5             	mov    %rsp,%rbp
  802c8e:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c95:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c9c:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ca3:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802caa:	be 00 00 00 00       	mov    $0x0,%esi
  802caf:	48 89 c7             	mov    %rax,%rdi
  802cb2:	48 b8 4f 28 80 00 00 	movabs $0x80284f,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	callq  *%rax
  802cbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802cc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc5:	79 28                	jns    802cef <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802cc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cca:	89 c6                	mov    %eax,%esi
  802ccc:	48 bf b2 47 80 00 00 	movabs $0x8047b2,%rdi
  802cd3:	00 00 00 
  802cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cdb:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  802ce2:	00 00 00 
  802ce5:	ff d2                	callq  *%rdx
		return fd_src;
  802ce7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cea:	e9 74 01 00 00       	jmpq   802e63 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802cef:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802cf6:	be 01 01 00 00       	mov    $0x101,%esi
  802cfb:	48 89 c7             	mov    %rax,%rdi
  802cfe:	48 b8 4f 28 80 00 00 	movabs $0x80284f,%rax
  802d05:	00 00 00 
  802d08:	ff d0                	callq  *%rax
  802d0a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802d0d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d11:	79 39                	jns    802d4c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802d13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d16:	89 c6                	mov    %eax,%esi
  802d18:	48 bf c8 47 80 00 00 	movabs $0x8047c8,%rdi
  802d1f:	00 00 00 
  802d22:	b8 00 00 00 00       	mov    $0x0,%eax
  802d27:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  802d2e:	00 00 00 
  802d31:	ff d2                	callq  *%rdx
		close(fd_src);
  802d33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d36:	89 c7                	mov    %eax,%edi
  802d38:	48 b8 57 21 80 00 00 	movabs $0x802157,%rax
  802d3f:	00 00 00 
  802d42:	ff d0                	callq  *%rax
		return fd_dest;
  802d44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d47:	e9 17 01 00 00       	jmpq   802e63 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d4c:	eb 74                	jmp    802dc2 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802d4e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d51:	48 63 d0             	movslq %eax,%rdx
  802d54:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d5e:	48 89 ce             	mov    %rcx,%rsi
  802d61:	89 c7                	mov    %eax,%edi
  802d63:	48 b8 c3 24 80 00 00 	movabs $0x8024c3,%rax
  802d6a:	00 00 00 
  802d6d:	ff d0                	callq  *%rax
  802d6f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d72:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d76:	79 4a                	jns    802dc2 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d78:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d7b:	89 c6                	mov    %eax,%esi
  802d7d:	48 bf e2 47 80 00 00 	movabs $0x8047e2,%rdi
  802d84:	00 00 00 
  802d87:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8c:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  802d93:	00 00 00 
  802d96:	ff d2                	callq  *%rdx
			close(fd_src);
  802d98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9b:	89 c7                	mov    %eax,%edi
  802d9d:	48 b8 57 21 80 00 00 	movabs $0x802157,%rax
  802da4:	00 00 00 
  802da7:	ff d0                	callq  *%rax
			close(fd_dest);
  802da9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dac:	89 c7                	mov    %eax,%edi
  802dae:	48 b8 57 21 80 00 00 	movabs $0x802157,%rax
  802db5:	00 00 00 
  802db8:	ff d0                	callq  *%rax
			return write_size;
  802dba:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802dbd:	e9 a1 00 00 00       	jmpq   802e63 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802dc2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802dc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcc:	ba 00 02 00 00       	mov    $0x200,%edx
  802dd1:	48 89 ce             	mov    %rcx,%rsi
  802dd4:	89 c7                	mov    %eax,%edi
  802dd6:	48 b8 79 23 80 00 00 	movabs $0x802379,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax
  802de2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802de5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802de9:	0f 8f 5f ff ff ff    	jg     802d4e <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802def:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802df3:	79 47                	jns    802e3c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802df5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802df8:	89 c6                	mov    %eax,%esi
  802dfa:	48 bf f5 47 80 00 00 	movabs $0x8047f5,%rdi
  802e01:	00 00 00 
  802e04:	b8 00 00 00 00       	mov    $0x0,%eax
  802e09:	48 ba 44 06 80 00 00 	movabs $0x800644,%rdx
  802e10:	00 00 00 
  802e13:	ff d2                	callq  *%rdx
		close(fd_src);
  802e15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e18:	89 c7                	mov    %eax,%edi
  802e1a:	48 b8 57 21 80 00 00 	movabs $0x802157,%rax
  802e21:	00 00 00 
  802e24:	ff d0                	callq  *%rax
		close(fd_dest);
  802e26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e29:	89 c7                	mov    %eax,%edi
  802e2b:	48 b8 57 21 80 00 00 	movabs $0x802157,%rax
  802e32:	00 00 00 
  802e35:	ff d0                	callq  *%rax
		return read_size;
  802e37:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e3a:	eb 27                	jmp    802e63 <copy+0x1d9>
	}
	close(fd_src);
  802e3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e3f:	89 c7                	mov    %eax,%edi
  802e41:	48 b8 57 21 80 00 00 	movabs $0x802157,%rax
  802e48:	00 00 00 
  802e4b:	ff d0                	callq  *%rax
	close(fd_dest);
  802e4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e50:	89 c7                	mov    %eax,%edi
  802e52:	48 b8 57 21 80 00 00 	movabs $0x802157,%rax
  802e59:	00 00 00 
  802e5c:	ff d0                	callq  *%rax
	return 0;
  802e5e:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802e63:	c9                   	leaveq 
  802e64:	c3                   	retq   

0000000000802e65 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802e65:	55                   	push   %rbp
  802e66:	48 89 e5             	mov    %rsp,%rbp
  802e69:	48 83 ec 20          	sub    $0x20,%rsp
  802e6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802e70:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e74:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e77:	48 89 d6             	mov    %rdx,%rsi
  802e7a:	89 c7                	mov    %eax,%edi
  802e7c:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  802e83:	00 00 00 
  802e86:	ff d0                	callq  *%rax
  802e88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8f:	79 05                	jns    802e96 <fd2sockid+0x31>
		return r;
  802e91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e94:	eb 24                	jmp    802eba <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9a:	8b 10                	mov    (%rax),%edx
  802e9c:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802ea3:	00 00 00 
  802ea6:	8b 00                	mov    (%rax),%eax
  802ea8:	39 c2                	cmp    %eax,%edx
  802eaa:	74 07                	je     802eb3 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802eac:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802eb1:	eb 07                	jmp    802eba <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802eb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb7:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802eba:	c9                   	leaveq 
  802ebb:	c3                   	retq   

0000000000802ebc <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802ebc:	55                   	push   %rbp
  802ebd:	48 89 e5             	mov    %rsp,%rbp
  802ec0:	48 83 ec 20          	sub    $0x20,%rsp
  802ec4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802ec7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ecb:	48 89 c7             	mov    %rax,%rdi
  802ece:	48 b8 af 1e 80 00 00 	movabs $0x801eaf,%rax
  802ed5:	00 00 00 
  802ed8:	ff d0                	callq  *%rax
  802eda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802edd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee1:	78 26                	js     802f09 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802ee3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee7:	ba 07 04 00 00       	mov    $0x407,%edx
  802eec:	48 89 c6             	mov    %rax,%rsi
  802eef:	bf 00 00 00 00       	mov    $0x0,%edi
  802ef4:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  802efb:	00 00 00 
  802efe:	ff d0                	callq  *%rax
  802f00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f07:	79 16                	jns    802f1f <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f0c:	89 c7                	mov    %eax,%edi
  802f0e:	48 b8 c9 33 80 00 00 	movabs $0x8033c9,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
		return r;
  802f1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1d:	eb 3a                	jmp    802f59 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f23:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802f2a:	00 00 00 
  802f2d:	8b 12                	mov    (%rdx),%edx
  802f2f:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802f31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f35:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f40:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f43:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802f46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4a:	48 89 c7             	mov    %rax,%rdi
  802f4d:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  802f54:	00 00 00 
  802f57:	ff d0                	callq  *%rax
}
  802f59:	c9                   	leaveq 
  802f5a:	c3                   	retq   

0000000000802f5b <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f5b:	55                   	push   %rbp
  802f5c:	48 89 e5             	mov    %rsp,%rbp
  802f5f:	48 83 ec 30          	sub    $0x30,%rsp
  802f63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f6e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f71:	89 c7                	mov    %eax,%edi
  802f73:	48 b8 65 2e 80 00 00 	movabs $0x802e65,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
  802f7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f86:	79 05                	jns    802f8d <accept+0x32>
		return r;
  802f88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8b:	eb 3b                	jmp    802fc8 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802f8d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f91:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f98:	48 89 ce             	mov    %rcx,%rsi
  802f9b:	89 c7                	mov    %eax,%edi
  802f9d:	48 b8 a6 32 80 00 00 	movabs $0x8032a6,%rax
  802fa4:	00 00 00 
  802fa7:	ff d0                	callq  *%rax
  802fa9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb0:	79 05                	jns    802fb7 <accept+0x5c>
		return r;
  802fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb5:	eb 11                	jmp    802fc8 <accept+0x6d>
	return alloc_sockfd(r);
  802fb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fba:	89 c7                	mov    %eax,%edi
  802fbc:	48 b8 bc 2e 80 00 00 	movabs $0x802ebc,%rax
  802fc3:	00 00 00 
  802fc6:	ff d0                	callq  *%rax
}
  802fc8:	c9                   	leaveq 
  802fc9:	c3                   	retq   

0000000000802fca <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fca:	55                   	push   %rbp
  802fcb:	48 89 e5             	mov    %rsp,%rbp
  802fce:	48 83 ec 20          	sub    $0x20,%rsp
  802fd2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fd5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fd9:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fdc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fdf:	89 c7                	mov    %eax,%edi
  802fe1:	48 b8 65 2e 80 00 00 	movabs $0x802e65,%rax
  802fe8:	00 00 00 
  802feb:	ff d0                	callq  *%rax
  802fed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff4:	79 05                	jns    802ffb <bind+0x31>
		return r;
  802ff6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff9:	eb 1b                	jmp    803016 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802ffb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ffe:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803002:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803005:	48 89 ce             	mov    %rcx,%rsi
  803008:	89 c7                	mov    %eax,%edi
  80300a:	48 b8 25 33 80 00 00 	movabs $0x803325,%rax
  803011:	00 00 00 
  803014:	ff d0                	callq  *%rax
}
  803016:	c9                   	leaveq 
  803017:	c3                   	retq   

0000000000803018 <shutdown>:

int
shutdown(int s, int how)
{
  803018:	55                   	push   %rbp
  803019:	48 89 e5             	mov    %rsp,%rbp
  80301c:	48 83 ec 20          	sub    $0x20,%rsp
  803020:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803023:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803026:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803029:	89 c7                	mov    %eax,%edi
  80302b:	48 b8 65 2e 80 00 00 	movabs $0x802e65,%rax
  803032:	00 00 00 
  803035:	ff d0                	callq  *%rax
  803037:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80303a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303e:	79 05                	jns    803045 <shutdown+0x2d>
		return r;
  803040:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803043:	eb 16                	jmp    80305b <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803045:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803048:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304b:	89 d6                	mov    %edx,%esi
  80304d:	89 c7                	mov    %eax,%edi
  80304f:	48 b8 89 33 80 00 00 	movabs $0x803389,%rax
  803056:	00 00 00 
  803059:	ff d0                	callq  *%rax
}
  80305b:	c9                   	leaveq 
  80305c:	c3                   	retq   

000000000080305d <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80305d:	55                   	push   %rbp
  80305e:	48 89 e5             	mov    %rsp,%rbp
  803061:	48 83 ec 10          	sub    $0x10,%rsp
  803065:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803069:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306d:	48 89 c7             	mov    %rax,%rdi
  803070:	48 b8 d7 40 80 00 00 	movabs $0x8040d7,%rax
  803077:	00 00 00 
  80307a:	ff d0                	callq  *%rax
  80307c:	83 f8 01             	cmp    $0x1,%eax
  80307f:	75 17                	jne    803098 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803081:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803085:	8b 40 0c             	mov    0xc(%rax),%eax
  803088:	89 c7                	mov    %eax,%edi
  80308a:	48 b8 c9 33 80 00 00 	movabs $0x8033c9,%rax
  803091:	00 00 00 
  803094:	ff d0                	callq  *%rax
  803096:	eb 05                	jmp    80309d <devsock_close+0x40>
	else
		return 0;
  803098:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80309d:	c9                   	leaveq 
  80309e:	c3                   	retq   

000000000080309f <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80309f:	55                   	push   %rbp
  8030a0:	48 89 e5             	mov    %rsp,%rbp
  8030a3:	48 83 ec 20          	sub    $0x20,%rsp
  8030a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030ae:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b4:	89 c7                	mov    %eax,%edi
  8030b6:	48 b8 65 2e 80 00 00 	movabs $0x802e65,%rax
  8030bd:	00 00 00 
  8030c0:	ff d0                	callq  *%rax
  8030c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030c9:	79 05                	jns    8030d0 <connect+0x31>
		return r;
  8030cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ce:	eb 1b                	jmp    8030eb <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8030d0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030d3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8030d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030da:	48 89 ce             	mov    %rcx,%rsi
  8030dd:	89 c7                	mov    %eax,%edi
  8030df:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
}
  8030eb:	c9                   	leaveq 
  8030ec:	c3                   	retq   

00000000008030ed <listen>:

int
listen(int s, int backlog)
{
  8030ed:	55                   	push   %rbp
  8030ee:	48 89 e5             	mov    %rsp,%rbp
  8030f1:	48 83 ec 20          	sub    $0x20,%rsp
  8030f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030f8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030fe:	89 c7                	mov    %eax,%edi
  803100:	48 b8 65 2e 80 00 00 	movabs $0x802e65,%rax
  803107:	00 00 00 
  80310a:	ff d0                	callq  *%rax
  80310c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80310f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803113:	79 05                	jns    80311a <listen+0x2d>
		return r;
  803115:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803118:	eb 16                	jmp    803130 <listen+0x43>
	return nsipc_listen(r, backlog);
  80311a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80311d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803120:	89 d6                	mov    %edx,%esi
  803122:	89 c7                	mov    %eax,%edi
  803124:	48 b8 5a 34 80 00 00 	movabs $0x80345a,%rax
  80312b:	00 00 00 
  80312e:	ff d0                	callq  *%rax
}
  803130:	c9                   	leaveq 
  803131:	c3                   	retq   

0000000000803132 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803132:	55                   	push   %rbp
  803133:	48 89 e5             	mov    %rsp,%rbp
  803136:	48 83 ec 20          	sub    $0x20,%rsp
  80313a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80313e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803142:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803146:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80314a:	89 c2                	mov    %eax,%edx
  80314c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803150:	8b 40 0c             	mov    0xc(%rax),%eax
  803153:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803157:	b9 00 00 00 00       	mov    $0x0,%ecx
  80315c:	89 c7                	mov    %eax,%edi
  80315e:	48 b8 9a 34 80 00 00 	movabs $0x80349a,%rax
  803165:	00 00 00 
  803168:	ff d0                	callq  *%rax
}
  80316a:	c9                   	leaveq 
  80316b:	c3                   	retq   

000000000080316c <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80316c:	55                   	push   %rbp
  80316d:	48 89 e5             	mov    %rsp,%rbp
  803170:	48 83 ec 20          	sub    $0x20,%rsp
  803174:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803178:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80317c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803184:	89 c2                	mov    %eax,%edx
  803186:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80318a:	8b 40 0c             	mov    0xc(%rax),%eax
  80318d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803191:	b9 00 00 00 00       	mov    $0x0,%ecx
  803196:	89 c7                	mov    %eax,%edi
  803198:	48 b8 66 35 80 00 00 	movabs $0x803566,%rax
  80319f:	00 00 00 
  8031a2:	ff d0                	callq  *%rax
}
  8031a4:	c9                   	leaveq 
  8031a5:	c3                   	retq   

00000000008031a6 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8031a6:	55                   	push   %rbp
  8031a7:	48 89 e5             	mov    %rsp,%rbp
  8031aa:	48 83 ec 10          	sub    $0x10,%rsp
  8031ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8031b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ba:	48 be 10 48 80 00 00 	movabs $0x804810,%rsi
  8031c1:	00 00 00 
  8031c4:	48 89 c7             	mov    %rax,%rdi
  8031c7:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
	return 0;
  8031d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031d8:	c9                   	leaveq 
  8031d9:	c3                   	retq   

00000000008031da <socket>:

int
socket(int domain, int type, int protocol)
{
  8031da:	55                   	push   %rbp
  8031db:	48 89 e5             	mov    %rsp,%rbp
  8031de:	48 83 ec 20          	sub    $0x20,%rsp
  8031e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031e5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8031e8:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8031eb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8031ee:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8031f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031f4:	89 ce                	mov    %ecx,%esi
  8031f6:	89 c7                	mov    %eax,%edi
  8031f8:	48 b8 1e 36 80 00 00 	movabs $0x80361e,%rax
  8031ff:	00 00 00 
  803202:	ff d0                	callq  *%rax
  803204:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803207:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80320b:	79 05                	jns    803212 <socket+0x38>
		return r;
  80320d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803210:	eb 11                	jmp    803223 <socket+0x49>
	return alloc_sockfd(r);
  803212:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803215:	89 c7                	mov    %eax,%edi
  803217:	48 b8 bc 2e 80 00 00 	movabs $0x802ebc,%rax
  80321e:	00 00 00 
  803221:	ff d0                	callq  *%rax
}
  803223:	c9                   	leaveq 
  803224:	c3                   	retq   

0000000000803225 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803225:	55                   	push   %rbp
  803226:	48 89 e5             	mov    %rsp,%rbp
  803229:	48 83 ec 10          	sub    $0x10,%rsp
  80322d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803230:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803237:	00 00 00 
  80323a:	8b 00                	mov    (%rax),%eax
  80323c:	85 c0                	test   %eax,%eax
  80323e:	75 1d                	jne    80325d <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803240:	bf 02 00 00 00       	mov    $0x2,%edi
  803245:	48 b8 55 40 80 00 00 	movabs $0x804055,%rax
  80324c:	00 00 00 
  80324f:	ff d0                	callq  *%rax
  803251:	48 ba 04 70 80 00 00 	movabs $0x807004,%rdx
  803258:	00 00 00 
  80325b:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80325d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803264:	00 00 00 
  803267:	8b 00                	mov    (%rax),%eax
  803269:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80326c:	b9 07 00 00 00       	mov    $0x7,%ecx
  803271:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803278:	00 00 00 
  80327b:	89 c7                	mov    %eax,%edi
  80327d:	48 b8 f3 3f 80 00 00 	movabs $0x803ff3,%rax
  803284:	00 00 00 
  803287:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803289:	ba 00 00 00 00       	mov    $0x0,%edx
  80328e:	be 00 00 00 00       	mov    $0x0,%esi
  803293:	bf 00 00 00 00       	mov    $0x0,%edi
  803298:	48 b8 ed 3e 80 00 00 	movabs $0x803eed,%rax
  80329f:	00 00 00 
  8032a2:	ff d0                	callq  *%rax
}
  8032a4:	c9                   	leaveq 
  8032a5:	c3                   	retq   

00000000008032a6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032a6:	55                   	push   %rbp
  8032a7:	48 89 e5             	mov    %rsp,%rbp
  8032aa:	48 83 ec 30          	sub    $0x30,%rsp
  8032ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8032b9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032c0:	00 00 00 
  8032c3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032c6:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8032c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8032cd:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  8032d4:	00 00 00 
  8032d7:	ff d0                	callq  *%rax
  8032d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e0:	78 3e                	js     803320 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8032e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032e9:	00 00 00 
  8032ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8032f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f4:	8b 40 10             	mov    0x10(%rax),%eax
  8032f7:	89 c2                	mov    %eax,%edx
  8032f9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8032fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803301:	48 89 ce             	mov    %rcx,%rsi
  803304:	48 89 c7             	mov    %rax,%rdi
  803307:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  80330e:	00 00 00 
  803311:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803313:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803317:	8b 50 10             	mov    0x10(%rax),%edx
  80331a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80331e:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803320:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803323:	c9                   	leaveq 
  803324:	c3                   	retq   

0000000000803325 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803325:	55                   	push   %rbp
  803326:	48 89 e5             	mov    %rsp,%rbp
  803329:	48 83 ec 10          	sub    $0x10,%rsp
  80332d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803330:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803334:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803337:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80333e:	00 00 00 
  803341:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803344:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803346:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803349:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80334d:	48 89 c6             	mov    %rax,%rsi
  803350:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803357:	00 00 00 
  80335a:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803361:	00 00 00 
  803364:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803366:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80336d:	00 00 00 
  803370:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803373:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803376:	bf 02 00 00 00       	mov    $0x2,%edi
  80337b:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  803382:	00 00 00 
  803385:	ff d0                	callq  *%rax
}
  803387:	c9                   	leaveq 
  803388:	c3                   	retq   

0000000000803389 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803389:	55                   	push   %rbp
  80338a:	48 89 e5             	mov    %rsp,%rbp
  80338d:	48 83 ec 10          	sub    $0x10,%rsp
  803391:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803394:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803397:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80339e:	00 00 00 
  8033a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033a4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8033a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033ad:	00 00 00 
  8033b0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033b3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8033b6:	bf 03 00 00 00       	mov    $0x3,%edi
  8033bb:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  8033c2:	00 00 00 
  8033c5:	ff d0                	callq  *%rax
}
  8033c7:	c9                   	leaveq 
  8033c8:	c3                   	retq   

00000000008033c9 <nsipc_close>:

int
nsipc_close(int s)
{
  8033c9:	55                   	push   %rbp
  8033ca:	48 89 e5             	mov    %rsp,%rbp
  8033cd:	48 83 ec 10          	sub    $0x10,%rsp
  8033d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8033d4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033db:	00 00 00 
  8033de:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033e1:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8033e3:	bf 04 00 00 00       	mov    $0x4,%edi
  8033e8:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
}
  8033f4:	c9                   	leaveq 
  8033f5:	c3                   	retq   

00000000008033f6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8033f6:	55                   	push   %rbp
  8033f7:	48 89 e5             	mov    %rsp,%rbp
  8033fa:	48 83 ec 10          	sub    $0x10,%rsp
  8033fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803401:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803405:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803408:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80340f:	00 00 00 
  803412:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803415:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803417:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80341a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341e:	48 89 c6             	mov    %rax,%rsi
  803421:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803428:	00 00 00 
  80342b:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803432:	00 00 00 
  803435:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803437:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80343e:	00 00 00 
  803441:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803444:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803447:	bf 05 00 00 00       	mov    $0x5,%edi
  80344c:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  803453:	00 00 00 
  803456:	ff d0                	callq  *%rax
}
  803458:	c9                   	leaveq 
  803459:	c3                   	retq   

000000000080345a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80345a:	55                   	push   %rbp
  80345b:	48 89 e5             	mov    %rsp,%rbp
  80345e:	48 83 ec 10          	sub    $0x10,%rsp
  803462:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803465:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803468:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80346f:	00 00 00 
  803472:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803475:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803477:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80347e:	00 00 00 
  803481:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803484:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803487:	bf 06 00 00 00       	mov    $0x6,%edi
  80348c:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  803493:	00 00 00 
  803496:	ff d0                	callq  *%rax
}
  803498:	c9                   	leaveq 
  803499:	c3                   	retq   

000000000080349a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80349a:	55                   	push   %rbp
  80349b:	48 89 e5             	mov    %rsp,%rbp
  80349e:	48 83 ec 30          	sub    $0x30,%rsp
  8034a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034a9:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8034ac:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8034af:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034b6:	00 00 00 
  8034b9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034bc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8034be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034c5:	00 00 00 
  8034c8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034cb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8034ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034d5:	00 00 00 
  8034d8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8034db:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8034de:	bf 07 00 00 00       	mov    $0x7,%edi
  8034e3:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  8034ea:	00 00 00 
  8034ed:	ff d0                	callq  *%rax
  8034ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f6:	78 69                	js     803561 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8034f8:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8034ff:	7f 08                	jg     803509 <nsipc_recv+0x6f>
  803501:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803504:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803507:	7e 35                	jle    80353e <nsipc_recv+0xa4>
  803509:	48 b9 17 48 80 00 00 	movabs $0x804817,%rcx
  803510:	00 00 00 
  803513:	48 ba 2c 48 80 00 00 	movabs $0x80482c,%rdx
  80351a:	00 00 00 
  80351d:	be 61 00 00 00       	mov    $0x61,%esi
  803522:	48 bf 41 48 80 00 00 	movabs $0x804841,%rdi
  803529:	00 00 00 
  80352c:	b8 00 00 00 00       	mov    $0x0,%eax
  803531:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  803538:	00 00 00 
  80353b:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80353e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803541:	48 63 d0             	movslq %eax,%rdx
  803544:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803548:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80354f:	00 00 00 
  803552:	48 89 c7             	mov    %rax,%rdi
  803555:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  80355c:	00 00 00 
  80355f:	ff d0                	callq  *%rax
	}

	return r;
  803561:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803564:	c9                   	leaveq 
  803565:	c3                   	retq   

0000000000803566 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803566:	55                   	push   %rbp
  803567:	48 89 e5             	mov    %rsp,%rbp
  80356a:	48 83 ec 20          	sub    $0x20,%rsp
  80356e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803571:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803575:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803578:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80357b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803582:	00 00 00 
  803585:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803588:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80358a:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803591:	7e 35                	jle    8035c8 <nsipc_send+0x62>
  803593:	48 b9 4d 48 80 00 00 	movabs $0x80484d,%rcx
  80359a:	00 00 00 
  80359d:	48 ba 2c 48 80 00 00 	movabs $0x80482c,%rdx
  8035a4:	00 00 00 
  8035a7:	be 6c 00 00 00       	mov    $0x6c,%esi
  8035ac:	48 bf 41 48 80 00 00 	movabs $0x804841,%rdi
  8035b3:	00 00 00 
  8035b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035bb:	49 b8 0b 04 80 00 00 	movabs $0x80040b,%r8
  8035c2:	00 00 00 
  8035c5:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8035c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035cb:	48 63 d0             	movslq %eax,%rdx
  8035ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d2:	48 89 c6             	mov    %rax,%rsi
  8035d5:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8035dc:	00 00 00 
  8035df:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  8035e6:	00 00 00 
  8035e9:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8035eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f2:	00 00 00 
  8035f5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035f8:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8035fb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803602:	00 00 00 
  803605:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803608:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80360b:	bf 08 00 00 00       	mov    $0x8,%edi
  803610:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  803617:	00 00 00 
  80361a:	ff d0                	callq  *%rax
}
  80361c:	c9                   	leaveq 
  80361d:	c3                   	retq   

000000000080361e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80361e:	55                   	push   %rbp
  80361f:	48 89 e5             	mov    %rsp,%rbp
  803622:	48 83 ec 10          	sub    $0x10,%rsp
  803626:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803629:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80362c:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80362f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803636:	00 00 00 
  803639:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80363c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80363e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803645:	00 00 00 
  803648:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80364b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80364e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803655:	00 00 00 
  803658:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80365b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80365e:	bf 09 00 00 00       	mov    $0x9,%edi
  803663:	48 b8 25 32 80 00 00 	movabs $0x803225,%rax
  80366a:	00 00 00 
  80366d:	ff d0                	callq  *%rax
}
  80366f:	c9                   	leaveq 
  803670:	c3                   	retq   

0000000000803671 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803671:	55                   	push   %rbp
  803672:	48 89 e5             	mov    %rsp,%rbp
  803675:	53                   	push   %rbx
  803676:	48 83 ec 38          	sub    $0x38,%rsp
  80367a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80367e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803682:	48 89 c7             	mov    %rax,%rdi
  803685:	48 b8 af 1e 80 00 00 	movabs $0x801eaf,%rax
  80368c:	00 00 00 
  80368f:	ff d0                	callq  *%rax
  803691:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803694:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803698:	0f 88 bf 01 00 00    	js     80385d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80369e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a2:	ba 07 04 00 00       	mov    $0x407,%edx
  8036a7:	48 89 c6             	mov    %rax,%rsi
  8036aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8036af:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  8036b6:	00 00 00 
  8036b9:	ff d0                	callq  *%rax
  8036bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036c2:	0f 88 95 01 00 00    	js     80385d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8036c8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8036cc:	48 89 c7             	mov    %rax,%rdi
  8036cf:	48 b8 af 1e 80 00 00 	movabs $0x801eaf,%rax
  8036d6:	00 00 00 
  8036d9:	ff d0                	callq  *%rax
  8036db:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036e2:	0f 88 5d 01 00 00    	js     803845 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ec:	ba 07 04 00 00       	mov    $0x407,%edx
  8036f1:	48 89 c6             	mov    %rax,%rsi
  8036f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8036f9:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  803700:	00 00 00 
  803703:	ff d0                	callq  *%rax
  803705:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803708:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80370c:	0f 88 33 01 00 00    	js     803845 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803712:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803716:	48 89 c7             	mov    %rax,%rdi
  803719:	48 b8 84 1e 80 00 00 	movabs $0x801e84,%rax
  803720:	00 00 00 
  803723:	ff d0                	callq  *%rax
  803725:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803729:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80372d:	ba 07 04 00 00       	mov    $0x407,%edx
  803732:	48 89 c6             	mov    %rax,%rsi
  803735:	bf 00 00 00 00       	mov    $0x0,%edi
  80373a:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
  803746:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803749:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80374d:	79 05                	jns    803754 <pipe+0xe3>
		goto err2;
  80374f:	e9 d9 00 00 00       	jmpq   80382d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803754:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803758:	48 89 c7             	mov    %rax,%rdi
  80375b:	48 b8 84 1e 80 00 00 	movabs $0x801e84,%rax
  803762:	00 00 00 
  803765:	ff d0                	callq  *%rax
  803767:	48 89 c2             	mov    %rax,%rdx
  80376a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80376e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803774:	48 89 d1             	mov    %rdx,%rcx
  803777:	ba 00 00 00 00       	mov    $0x0,%edx
  80377c:	48 89 c6             	mov    %rax,%rsi
  80377f:	bf 00 00 00 00       	mov    $0x0,%edi
  803784:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  80378b:	00 00 00 
  80378e:	ff d0                	callq  *%rax
  803790:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803793:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803797:	79 1b                	jns    8037b4 <pipe+0x143>
		goto err3;
  803799:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80379a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80379e:	48 89 c6             	mov    %rax,%rsi
  8037a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a6:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  8037ad:	00 00 00 
  8037b0:	ff d0                	callq  *%rax
  8037b2:	eb 79                	jmp    80382d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037b8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037bf:	00 00 00 
  8037c2:	8b 12                	mov    (%rdx),%edx
  8037c4:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8037c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8037d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037d5:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037dc:	00 00 00 
  8037df:	8b 12                	mov    (%rdx),%edx
  8037e1:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8037e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8037ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f2:	48 89 c7             	mov    %rax,%rdi
  8037f5:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  8037fc:	00 00 00 
  8037ff:	ff d0                	callq  *%rax
  803801:	89 c2                	mov    %eax,%edx
  803803:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803807:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803809:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80380d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803811:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803815:	48 89 c7             	mov    %rax,%rdi
  803818:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  80381f:	00 00 00 
  803822:	ff d0                	callq  *%rax
  803824:	89 03                	mov    %eax,(%rbx)
	return 0;
  803826:	b8 00 00 00 00       	mov    $0x0,%eax
  80382b:	eb 33                	jmp    803860 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80382d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803831:	48 89 c6             	mov    %rax,%rsi
  803834:	bf 00 00 00 00       	mov    $0x0,%edi
  803839:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  803840:	00 00 00 
  803843:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803845:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803849:	48 89 c6             	mov    %rax,%rsi
  80384c:	bf 00 00 00 00       	mov    $0x0,%edi
  803851:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  803858:	00 00 00 
  80385b:	ff d0                	callq  *%rax
err:
	return r;
  80385d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803860:	48 83 c4 38          	add    $0x38,%rsp
  803864:	5b                   	pop    %rbx
  803865:	5d                   	pop    %rbp
  803866:	c3                   	retq   

0000000000803867 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803867:	55                   	push   %rbp
  803868:	48 89 e5             	mov    %rsp,%rbp
  80386b:	53                   	push   %rbx
  80386c:	48 83 ec 28          	sub    $0x28,%rsp
  803870:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803874:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803878:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80387f:	00 00 00 
  803882:	48 8b 00             	mov    (%rax),%rax
  803885:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80388b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80388e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803892:	48 89 c7             	mov    %rax,%rdi
  803895:	48 b8 d7 40 80 00 00 	movabs $0x8040d7,%rax
  80389c:	00 00 00 
  80389f:	ff d0                	callq  *%rax
  8038a1:	89 c3                	mov    %eax,%ebx
  8038a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038a7:	48 89 c7             	mov    %rax,%rdi
  8038aa:	48 b8 d7 40 80 00 00 	movabs $0x8040d7,%rax
  8038b1:	00 00 00 
  8038b4:	ff d0                	callq  *%rax
  8038b6:	39 c3                	cmp    %eax,%ebx
  8038b8:	0f 94 c0             	sete   %al
  8038bb:	0f b6 c0             	movzbl %al,%eax
  8038be:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8038c1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038c8:	00 00 00 
  8038cb:	48 8b 00             	mov    (%rax),%rax
  8038ce:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038d4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8038d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038da:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038dd:	75 05                	jne    8038e4 <_pipeisclosed+0x7d>
			return ret;
  8038df:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8038e2:	eb 4f                	jmp    803933 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8038e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038e7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038ea:	74 42                	je     80392e <_pipeisclosed+0xc7>
  8038ec:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8038f0:	75 3c                	jne    80392e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8038f2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038f9:	00 00 00 
  8038fc:	48 8b 00             	mov    (%rax),%rax
  8038ff:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803905:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803908:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80390b:	89 c6                	mov    %eax,%esi
  80390d:	48 bf 5e 48 80 00 00 	movabs $0x80485e,%rdi
  803914:	00 00 00 
  803917:	b8 00 00 00 00       	mov    $0x0,%eax
  80391c:	49 b8 44 06 80 00 00 	movabs $0x800644,%r8
  803923:	00 00 00 
  803926:	41 ff d0             	callq  *%r8
	}
  803929:	e9 4a ff ff ff       	jmpq   803878 <_pipeisclosed+0x11>
  80392e:	e9 45 ff ff ff       	jmpq   803878 <_pipeisclosed+0x11>
}
  803933:	48 83 c4 28          	add    $0x28,%rsp
  803937:	5b                   	pop    %rbx
  803938:	5d                   	pop    %rbp
  803939:	c3                   	retq   

000000000080393a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80393a:	55                   	push   %rbp
  80393b:	48 89 e5             	mov    %rsp,%rbp
  80393e:	48 83 ec 30          	sub    $0x30,%rsp
  803942:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803945:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803949:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80394c:	48 89 d6             	mov    %rdx,%rsi
  80394f:	89 c7                	mov    %eax,%edi
  803951:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  803958:	00 00 00 
  80395b:	ff d0                	callq  *%rax
  80395d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803960:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803964:	79 05                	jns    80396b <pipeisclosed+0x31>
		return r;
  803966:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803969:	eb 31                	jmp    80399c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80396b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80396f:	48 89 c7             	mov    %rax,%rdi
  803972:	48 b8 84 1e 80 00 00 	movabs $0x801e84,%rax
  803979:	00 00 00 
  80397c:	ff d0                	callq  *%rax
  80397e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803982:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803986:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80398a:	48 89 d6             	mov    %rdx,%rsi
  80398d:	48 89 c7             	mov    %rax,%rdi
  803990:	48 b8 67 38 80 00 00 	movabs $0x803867,%rax
  803997:	00 00 00 
  80399a:	ff d0                	callq  *%rax
}
  80399c:	c9                   	leaveq 
  80399d:	c3                   	retq   

000000000080399e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80399e:	55                   	push   %rbp
  80399f:	48 89 e5             	mov    %rsp,%rbp
  8039a2:	48 83 ec 40          	sub    $0x40,%rsp
  8039a6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039ae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039b6:	48 89 c7             	mov    %rax,%rdi
  8039b9:	48 b8 84 1e 80 00 00 	movabs $0x801e84,%rax
  8039c0:	00 00 00 
  8039c3:	ff d0                	callq  *%rax
  8039c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039cd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039d1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039d8:	00 
  8039d9:	e9 92 00 00 00       	jmpq   803a70 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8039de:	eb 41                	jmp    803a21 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8039e0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039e5:	74 09                	je     8039f0 <devpipe_read+0x52>
				return i;
  8039e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039eb:	e9 92 00 00 00       	jmpq   803a82 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8039f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039f8:	48 89 d6             	mov    %rdx,%rsi
  8039fb:	48 89 c7             	mov    %rax,%rdi
  8039fe:	48 b8 67 38 80 00 00 	movabs $0x803867,%rax
  803a05:	00 00 00 
  803a08:	ff d0                	callq  *%rax
  803a0a:	85 c0                	test   %eax,%eax
  803a0c:	74 07                	je     803a15 <devpipe_read+0x77>
				return 0;
  803a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a13:	eb 6d                	jmp    803a82 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a15:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  803a1c:	00 00 00 
  803a1f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a25:	8b 10                	mov    (%rax),%edx
  803a27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2b:	8b 40 04             	mov    0x4(%rax),%eax
  803a2e:	39 c2                	cmp    %eax,%edx
  803a30:	74 ae                	je     8039e0 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a3a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a42:	8b 00                	mov    (%rax),%eax
  803a44:	99                   	cltd   
  803a45:	c1 ea 1b             	shr    $0x1b,%edx
  803a48:	01 d0                	add    %edx,%eax
  803a4a:	83 e0 1f             	and    $0x1f,%eax
  803a4d:	29 d0                	sub    %edx,%eax
  803a4f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a53:	48 98                	cltq   
  803a55:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a5a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a60:	8b 00                	mov    (%rax),%eax
  803a62:	8d 50 01             	lea    0x1(%rax),%edx
  803a65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a69:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a6b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a74:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a78:	0f 82 60 ff ff ff    	jb     8039de <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a82:	c9                   	leaveq 
  803a83:	c3                   	retq   

0000000000803a84 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a84:	55                   	push   %rbp
  803a85:	48 89 e5             	mov    %rsp,%rbp
  803a88:	48 83 ec 40          	sub    $0x40,%rsp
  803a8c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a90:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a94:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a9c:	48 89 c7             	mov    %rax,%rdi
  803a9f:	48 b8 84 1e 80 00 00 	movabs $0x801e84,%rax
  803aa6:	00 00 00 
  803aa9:	ff d0                	callq  *%rax
  803aab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803aaf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ab3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ab7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803abe:	00 
  803abf:	e9 8e 00 00 00       	jmpq   803b52 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ac4:	eb 31                	jmp    803af7 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ac6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803aca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ace:	48 89 d6             	mov    %rdx,%rsi
  803ad1:	48 89 c7             	mov    %rax,%rdi
  803ad4:	48 b8 67 38 80 00 00 	movabs $0x803867,%rax
  803adb:	00 00 00 
  803ade:	ff d0                	callq  *%rax
  803ae0:	85 c0                	test   %eax,%eax
  803ae2:	74 07                	je     803aeb <devpipe_write+0x67>
				return 0;
  803ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae9:	eb 79                	jmp    803b64 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803aeb:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  803af2:	00 00 00 
  803af5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803af7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803afb:	8b 40 04             	mov    0x4(%rax),%eax
  803afe:	48 63 d0             	movslq %eax,%rdx
  803b01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b05:	8b 00                	mov    (%rax),%eax
  803b07:	48 98                	cltq   
  803b09:	48 83 c0 20          	add    $0x20,%rax
  803b0d:	48 39 c2             	cmp    %rax,%rdx
  803b10:	73 b4                	jae    803ac6 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b16:	8b 40 04             	mov    0x4(%rax),%eax
  803b19:	99                   	cltd   
  803b1a:	c1 ea 1b             	shr    $0x1b,%edx
  803b1d:	01 d0                	add    %edx,%eax
  803b1f:	83 e0 1f             	and    $0x1f,%eax
  803b22:	29 d0                	sub    %edx,%eax
  803b24:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b28:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b2c:	48 01 ca             	add    %rcx,%rdx
  803b2f:	0f b6 0a             	movzbl (%rdx),%ecx
  803b32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b36:	48 98                	cltq   
  803b38:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b40:	8b 40 04             	mov    0x4(%rax),%eax
  803b43:	8d 50 01             	lea    0x1(%rax),%edx
  803b46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b4a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b4d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b56:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b5a:	0f 82 64 ff ff ff    	jb     803ac4 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b64:	c9                   	leaveq 
  803b65:	c3                   	retq   

0000000000803b66 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b66:	55                   	push   %rbp
  803b67:	48 89 e5             	mov    %rsp,%rbp
  803b6a:	48 83 ec 20          	sub    $0x20,%rsp
  803b6e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b7a:	48 89 c7             	mov    %rax,%rdi
  803b7d:	48 b8 84 1e 80 00 00 	movabs $0x801e84,%rax
  803b84:	00 00 00 
  803b87:	ff d0                	callq  *%rax
  803b89:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b91:	48 be 71 48 80 00 00 	movabs $0x804871,%rsi
  803b98:	00 00 00 
  803b9b:	48 89 c7             	mov    %rax,%rdi
  803b9e:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  803ba5:	00 00 00 
  803ba8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803baa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bae:	8b 50 04             	mov    0x4(%rax),%edx
  803bb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb5:	8b 00                	mov    (%rax),%eax
  803bb7:	29 c2                	sub    %eax,%edx
  803bb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bbd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803bc3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bc7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803bce:	00 00 00 
	stat->st_dev = &devpipe;
  803bd1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bd5:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803bdc:	00 00 00 
  803bdf:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803be6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803beb:	c9                   	leaveq 
  803bec:	c3                   	retq   

0000000000803bed <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803bed:	55                   	push   %rbp
  803bee:	48 89 e5             	mov    %rsp,%rbp
  803bf1:	48 83 ec 10          	sub    $0x10,%rsp
  803bf5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803bf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bfd:	48 89 c6             	mov    %rax,%rsi
  803c00:	bf 00 00 00 00       	mov    $0x0,%edi
  803c05:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  803c0c:	00 00 00 
  803c0f:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c15:	48 89 c7             	mov    %rax,%rdi
  803c18:	48 b8 84 1e 80 00 00 	movabs $0x801e84,%rax
  803c1f:	00 00 00 
  803c22:	ff d0                	callq  *%rax
  803c24:	48 89 c6             	mov    %rax,%rsi
  803c27:	bf 00 00 00 00       	mov    $0x0,%edi
  803c2c:	48 b8 d3 1b 80 00 00 	movabs $0x801bd3,%rax
  803c33:	00 00 00 
  803c36:	ff d0                	callq  *%rax
}
  803c38:	c9                   	leaveq 
  803c39:	c3                   	retq   

0000000000803c3a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c3a:	55                   	push   %rbp
  803c3b:	48 89 e5             	mov    %rsp,%rbp
  803c3e:	48 83 ec 20          	sub    $0x20,%rsp
  803c42:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c45:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c48:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c4b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c4f:	be 01 00 00 00       	mov    $0x1,%esi
  803c54:	48 89 c7             	mov    %rax,%rdi
  803c57:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  803c5e:	00 00 00 
  803c61:	ff d0                	callq  *%rax
}
  803c63:	c9                   	leaveq 
  803c64:	c3                   	retq   

0000000000803c65 <getchar>:

int
getchar(void)
{
  803c65:	55                   	push   %rbp
  803c66:	48 89 e5             	mov    %rsp,%rbp
  803c69:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c6d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c71:	ba 01 00 00 00       	mov    $0x1,%edx
  803c76:	48 89 c6             	mov    %rax,%rsi
  803c79:	bf 00 00 00 00       	mov    $0x0,%edi
  803c7e:	48 b8 79 23 80 00 00 	movabs $0x802379,%rax
  803c85:	00 00 00 
  803c88:	ff d0                	callq  *%rax
  803c8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c91:	79 05                	jns    803c98 <getchar+0x33>
		return r;
  803c93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c96:	eb 14                	jmp    803cac <getchar+0x47>
	if (r < 1)
  803c98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9c:	7f 07                	jg     803ca5 <getchar+0x40>
		return -E_EOF;
  803c9e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803ca3:	eb 07                	jmp    803cac <getchar+0x47>
	return c;
  803ca5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803ca9:	0f b6 c0             	movzbl %al,%eax
}
  803cac:	c9                   	leaveq 
  803cad:	c3                   	retq   

0000000000803cae <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803cae:	55                   	push   %rbp
  803caf:	48 89 e5             	mov    %rsp,%rbp
  803cb2:	48 83 ec 20          	sub    $0x20,%rsp
  803cb6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cb9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803cbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cc0:	48 89 d6             	mov    %rdx,%rsi
  803cc3:	89 c7                	mov    %eax,%edi
  803cc5:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  803ccc:	00 00 00 
  803ccf:	ff d0                	callq  *%rax
  803cd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd8:	79 05                	jns    803cdf <iscons+0x31>
		return r;
  803cda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cdd:	eb 1a                	jmp    803cf9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce3:	8b 10                	mov    (%rax),%edx
  803ce5:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803cec:	00 00 00 
  803cef:	8b 00                	mov    (%rax),%eax
  803cf1:	39 c2                	cmp    %eax,%edx
  803cf3:	0f 94 c0             	sete   %al
  803cf6:	0f b6 c0             	movzbl %al,%eax
}
  803cf9:	c9                   	leaveq 
  803cfa:	c3                   	retq   

0000000000803cfb <opencons>:

int
opencons(void)
{
  803cfb:	55                   	push   %rbp
  803cfc:	48 89 e5             	mov    %rsp,%rbp
  803cff:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d03:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d07:	48 89 c7             	mov    %rax,%rdi
  803d0a:	48 b8 af 1e 80 00 00 	movabs $0x801eaf,%rax
  803d11:	00 00 00 
  803d14:	ff d0                	callq  *%rax
  803d16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d1d:	79 05                	jns    803d24 <opencons+0x29>
		return r;
  803d1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d22:	eb 5b                	jmp    803d7f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d28:	ba 07 04 00 00       	mov    $0x407,%edx
  803d2d:	48 89 c6             	mov    %rax,%rsi
  803d30:	bf 00 00 00 00       	mov    $0x0,%edi
  803d35:	48 b8 28 1b 80 00 00 	movabs $0x801b28,%rax
  803d3c:	00 00 00 
  803d3f:	ff d0                	callq  *%rax
  803d41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d48:	79 05                	jns    803d4f <opencons+0x54>
		return r;
  803d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d4d:	eb 30                	jmp    803d7f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d53:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d5a:	00 00 00 
  803d5d:	8b 12                	mov    (%rdx),%edx
  803d5f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d65:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d70:	48 89 c7             	mov    %rax,%rdi
  803d73:	48 b8 61 1e 80 00 00 	movabs $0x801e61,%rax
  803d7a:	00 00 00 
  803d7d:	ff d0                	callq  *%rax
}
  803d7f:	c9                   	leaveq 
  803d80:	c3                   	retq   

0000000000803d81 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d81:	55                   	push   %rbp
  803d82:	48 89 e5             	mov    %rsp,%rbp
  803d85:	48 83 ec 30          	sub    $0x30,%rsp
  803d89:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d8d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d91:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d95:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d9a:	75 07                	jne    803da3 <devcons_read+0x22>
		return 0;
  803d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  803da1:	eb 4b                	jmp    803dee <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803da3:	eb 0c                	jmp    803db1 <devcons_read+0x30>
		sys_yield();
  803da5:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  803dac:	00 00 00 
  803daf:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803db1:	48 b8 2a 1a 80 00 00 	movabs $0x801a2a,%rax
  803db8:	00 00 00 
  803dbb:	ff d0                	callq  *%rax
  803dbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dc4:	74 df                	je     803da5 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803dc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dca:	79 05                	jns    803dd1 <devcons_read+0x50>
		return c;
  803dcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dcf:	eb 1d                	jmp    803dee <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803dd1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803dd5:	75 07                	jne    803dde <devcons_read+0x5d>
		return 0;
  803dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  803ddc:	eb 10                	jmp    803dee <devcons_read+0x6d>
	*(char*)vbuf = c;
  803dde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de1:	89 c2                	mov    %eax,%edx
  803de3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de7:	88 10                	mov    %dl,(%rax)
	return 1;
  803de9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803dee:	c9                   	leaveq 
  803def:	c3                   	retq   

0000000000803df0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803df0:	55                   	push   %rbp
  803df1:	48 89 e5             	mov    %rsp,%rbp
  803df4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803dfb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e02:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e09:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e17:	eb 76                	jmp    803e8f <devcons_write+0x9f>
		m = n - tot;
  803e19:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e20:	89 c2                	mov    %eax,%edx
  803e22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e25:	29 c2                	sub    %eax,%edx
  803e27:	89 d0                	mov    %edx,%eax
  803e29:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e2f:	83 f8 7f             	cmp    $0x7f,%eax
  803e32:	76 07                	jbe    803e3b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e34:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e3e:	48 63 d0             	movslq %eax,%rdx
  803e41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e44:	48 63 c8             	movslq %eax,%rcx
  803e47:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e4e:	48 01 c1             	add    %rax,%rcx
  803e51:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e58:	48 89 ce             	mov    %rcx,%rsi
  803e5b:	48 89 c7             	mov    %rax,%rdi
  803e5e:	48 b8 1d 15 80 00 00 	movabs $0x80151d,%rax
  803e65:	00 00 00 
  803e68:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e6d:	48 63 d0             	movslq %eax,%rdx
  803e70:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e77:	48 89 d6             	mov    %rdx,%rsi
  803e7a:	48 89 c7             	mov    %rax,%rdi
  803e7d:	48 b8 e0 19 80 00 00 	movabs $0x8019e0,%rax
  803e84:	00 00 00 
  803e87:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e89:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e8c:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e92:	48 98                	cltq   
  803e94:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e9b:	0f 82 78 ff ff ff    	jb     803e19 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803ea1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ea4:	c9                   	leaveq 
  803ea5:	c3                   	retq   

0000000000803ea6 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803ea6:	55                   	push   %rbp
  803ea7:	48 89 e5             	mov    %rsp,%rbp
  803eaa:	48 83 ec 08          	sub    $0x8,%rsp
  803eae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803eb7:	c9                   	leaveq 
  803eb8:	c3                   	retq   

0000000000803eb9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803eb9:	55                   	push   %rbp
  803eba:	48 89 e5             	mov    %rsp,%rbp
  803ebd:	48 83 ec 10          	sub    $0x10,%rsp
  803ec1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ec5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ec9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ecd:	48 be 7d 48 80 00 00 	movabs $0x80487d,%rsi
  803ed4:	00 00 00 
  803ed7:	48 89 c7             	mov    %rax,%rdi
  803eda:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  803ee1:	00 00 00 
  803ee4:	ff d0                	callq  *%rax
	return 0;
  803ee6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803eeb:	c9                   	leaveq 
  803eec:	c3                   	retq   

0000000000803eed <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803eed:	55                   	push   %rbp
  803eee:	48 89 e5             	mov    %rsp,%rbp
  803ef1:	48 83 ec 30          	sub    $0x30,%rsp
  803ef5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ef9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803efd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  803f01:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f08:	00 00 00 
  803f0b:	48 8b 00             	mov    (%rax),%rax
  803f0e:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803f14:	85 c0                	test   %eax,%eax
  803f16:	75 3c                	jne    803f54 <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  803f18:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  803f1f:	00 00 00 
  803f22:	ff d0                	callq  *%rax
  803f24:	25 ff 03 00 00       	and    $0x3ff,%eax
  803f29:	48 63 d0             	movslq %eax,%rdx
  803f2c:	48 89 d0             	mov    %rdx,%rax
  803f2f:	48 c1 e0 03          	shl    $0x3,%rax
  803f33:	48 01 d0             	add    %rdx,%rax
  803f36:	48 c1 e0 05          	shl    $0x5,%rax
  803f3a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f41:	00 00 00 
  803f44:	48 01 c2             	add    %rax,%rdx
  803f47:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f4e:	00 00 00 
  803f51:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  803f54:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f59:	75 0e                	jne    803f69 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  803f5b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f62:	00 00 00 
  803f65:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  803f69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f6d:	48 89 c7             	mov    %rax,%rdi
  803f70:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  803f77:	00 00 00 
  803f7a:	ff d0                	callq  *%rax
  803f7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  803f7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f83:	79 19                	jns    803f9e <ipc_recv+0xb1>
		*from_env_store = 0;
  803f85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f89:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  803f8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f93:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  803f99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f9c:	eb 53                	jmp    803ff1 <ipc_recv+0x104>
	}
	if(from_env_store)
  803f9e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803fa3:	74 19                	je     803fbe <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  803fa5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fac:	00 00 00 
  803faf:	48 8b 00             	mov    (%rax),%rax
  803fb2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803fb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fbc:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  803fbe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fc3:	74 19                	je     803fde <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  803fc5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fcc:	00 00 00 
  803fcf:	48 8b 00             	mov    (%rax),%rax
  803fd2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803fd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fdc:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  803fde:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803fe5:	00 00 00 
  803fe8:	48 8b 00             	mov    (%rax),%rax
  803feb:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  803ff1:	c9                   	leaveq 
  803ff2:	c3                   	retq   

0000000000803ff3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ff3:	55                   	push   %rbp
  803ff4:	48 89 e5             	mov    %rsp,%rbp
  803ff7:	48 83 ec 30          	sub    $0x30,%rsp
  803ffb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ffe:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804001:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804005:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  804008:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80400d:	75 0e                	jne    80401d <ipc_send+0x2a>
		pg = (void*)UTOP;
  80400f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804016:	00 00 00 
  804019:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  80401d:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804020:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804023:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804027:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80402a:	89 c7                	mov    %eax,%edi
  80402c:	48 b8 fc 1c 80 00 00 	movabs $0x801cfc,%rax
  804033:	00 00 00 
  804036:	ff d0                	callq  *%rax
  804038:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  80403b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80403f:	75 0c                	jne    80404d <ipc_send+0x5a>
			sys_yield();
  804041:	48 b8 ea 1a 80 00 00 	movabs $0x801aea,%rax
  804048:	00 00 00 
  80404b:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  80404d:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804051:	74 ca                	je     80401d <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  804053:	c9                   	leaveq 
  804054:	c3                   	retq   

0000000000804055 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804055:	55                   	push   %rbp
  804056:	48 89 e5             	mov    %rsp,%rbp
  804059:	48 83 ec 14          	sub    $0x14,%rsp
  80405d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804060:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804067:	eb 5e                	jmp    8040c7 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804069:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804070:	00 00 00 
  804073:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804076:	48 63 d0             	movslq %eax,%rdx
  804079:	48 89 d0             	mov    %rdx,%rax
  80407c:	48 c1 e0 03          	shl    $0x3,%rax
  804080:	48 01 d0             	add    %rdx,%rax
  804083:	48 c1 e0 05          	shl    $0x5,%rax
  804087:	48 01 c8             	add    %rcx,%rax
  80408a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804090:	8b 00                	mov    (%rax),%eax
  804092:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804095:	75 2c                	jne    8040c3 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804097:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80409e:	00 00 00 
  8040a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a4:	48 63 d0             	movslq %eax,%rdx
  8040a7:	48 89 d0             	mov    %rdx,%rax
  8040aa:	48 c1 e0 03          	shl    $0x3,%rax
  8040ae:	48 01 d0             	add    %rdx,%rax
  8040b1:	48 c1 e0 05          	shl    $0x5,%rax
  8040b5:	48 01 c8             	add    %rcx,%rax
  8040b8:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8040be:	8b 40 08             	mov    0x8(%rax),%eax
  8040c1:	eb 12                	jmp    8040d5 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8040c3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040c7:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040ce:	7e 99                	jle    804069 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8040d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040d5:	c9                   	leaveq 
  8040d6:	c3                   	retq   

00000000008040d7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040d7:	55                   	push   %rbp
  8040d8:	48 89 e5             	mov    %rsp,%rbp
  8040db:	48 83 ec 18          	sub    $0x18,%rsp
  8040df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040e7:	48 c1 e8 15          	shr    $0x15,%rax
  8040eb:	48 89 c2             	mov    %rax,%rdx
  8040ee:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040f5:	01 00 00 
  8040f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040fc:	83 e0 01             	and    $0x1,%eax
  8040ff:	48 85 c0             	test   %rax,%rax
  804102:	75 07                	jne    80410b <pageref+0x34>
		return 0;
  804104:	b8 00 00 00 00       	mov    $0x0,%eax
  804109:	eb 53                	jmp    80415e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80410b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80410f:	48 c1 e8 0c          	shr    $0xc,%rax
  804113:	48 89 c2             	mov    %rax,%rdx
  804116:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80411d:	01 00 00 
  804120:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804124:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804128:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80412c:	83 e0 01             	and    $0x1,%eax
  80412f:	48 85 c0             	test   %rax,%rax
  804132:	75 07                	jne    80413b <pageref+0x64>
		return 0;
  804134:	b8 00 00 00 00       	mov    $0x0,%eax
  804139:	eb 23                	jmp    80415e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80413b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80413f:	48 c1 e8 0c          	shr    $0xc,%rax
  804143:	48 89 c2             	mov    %rax,%rdx
  804146:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80414d:	00 00 00 
  804150:	48 c1 e2 04          	shl    $0x4,%rdx
  804154:	48 01 d0             	add    %rdx,%rax
  804157:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80415b:	0f b7 c0             	movzwl %ax,%eax
}
  80415e:	c9                   	leaveq 
  80415f:	c3                   	retq   
