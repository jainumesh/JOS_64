
obj/net/testoutput:     file format elf64-x86-64


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
  80003c:	e8 e6 05 00 00       	callq  800627 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 28          	sub    $0x28,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    envid_t ns_envid = sys_getenvid();
  800053:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
    int i, r;

    binaryname = "testoutput";
  800062:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800069:	00 00 00 
  80006c:	48 bb 20 4c 80 00 00 	movabs $0x804c20,%rbx
  800073:	00 00 00 
  800076:	48 89 18             	mov    %rbx,(%rax)

    output_envid = fork();
  800079:	48 b8 14 25 80 00 00 	movabs $0x802514,%rax
  800080:	00 00 00 
  800083:	ff d0                	callq  *%rax
  800085:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80008c:	00 00 00 
  80008f:	89 02                	mov    %eax,(%rdx)
    if (output_envid < 0)
  800091:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800098:	00 00 00 
  80009b:	8b 00                	mov    (%rax),%eax
  80009d:	85 c0                	test   %eax,%eax
  80009f:	79 2a                	jns    8000cb <umain+0x88>
        panic("error forking");
  8000a1:	48 ba 2b 4c 80 00 00 	movabs $0x804c2b,%rdx
  8000a8:	00 00 00 
  8000ab:	be 16 00 00 00       	mov    $0x16,%esi
  8000b0:	48 bf 39 4c 80 00 00 	movabs $0x804c39,%rdi
  8000b7:	00 00 00 
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	48 b9 d5 06 80 00 00 	movabs $0x8006d5,%rcx
  8000c6:	00 00 00 
  8000c9:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8000cb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8000d2:	00 00 00 
  8000d5:	8b 00                	mov    (%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 46                	jne    800121 <umain+0xde>
		cprintf("output enviornment %d",thisenv->env_id);
  8000db:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8000e2:	00 00 00 
  8000e5:	48 8b 00             	mov    (%rax),%rax
  8000e8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000ee:	89 c6                	mov    %eax,%esi
  8000f0:	48 bf 4a 4c 80 00 00 	movabs $0x804c4a,%rdi
  8000f7:	00 00 00 
  8000fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ff:	48 ba 0e 09 80 00 00 	movabs $0x80090e,%rdx
  800106:	00 00 00 
  800109:	ff d2                	callq  *%rdx
        output(ns_envid);
  80010b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80010e:	89 c7                	mov    %eax,%edi
  800110:	48 b8 9f 04 80 00 00 	movabs $0x80049f,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
        return;
  80011c:	e9 50 01 00 00       	jmpq   800271 <umain+0x22e>
    }

    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  800121:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  800128:	e9 1b 01 00 00       	jmpq   800248 <umain+0x205>
        if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  80012d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800134:	00 00 00 
  800137:	48 8b 00             	mov    (%rax),%rax
  80013a:	ba 07 00 00 00       	mov    $0x7,%edx
  80013f:	48 89 c6             	mov    %rax,%rsi
  800142:	bf 00 00 00 00       	mov    $0x0,%edi
  800147:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  80014e:	00 00 00 
  800151:	ff d0                	callq  *%rax
  800153:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800156:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80015a:	79 30                	jns    80018c <umain+0x149>
            panic("sys_page_alloc: %e", r);
  80015c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80015f:	89 c1                	mov    %eax,%ecx
  800161:	48 ba 60 4c 80 00 00 	movabs $0x804c60,%rdx
  800168:	00 00 00 
  80016b:	be 1f 00 00 00       	mov    $0x1f,%esi
  800170:	48 bf 39 4c 80 00 00 	movabs $0x804c39,%rdi
  800177:	00 00 00 
  80017a:	b8 00 00 00 00       	mov    $0x0,%eax
  80017f:	49 b8 d5 06 80 00 00 	movabs $0x8006d5,%r8
  800186:	00 00 00 
  800189:	41 ff d0             	callq  *%r8
        pkt->jp_len = snprintf(pkt->jp_data,
  80018c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800193:	00 00 00 
  800196:	48 8b 18             	mov    (%rax),%rbx
  800199:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001a0:	00 00 00 
  8001a3:	48 8b 00             	mov    (%rax),%rax
  8001a6:	48 8d 78 04          	lea    0x4(%rax),%rdi
  8001aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ad:	89 c1                	mov    %eax,%ecx
  8001af:	48 ba 73 4c 80 00 00 	movabs $0x804c73,%rdx
  8001b6:	00 00 00 
  8001b9:	be fc 0f 00 00       	mov    $0xffc,%esi
  8001be:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c3:	49 b8 76 13 80 00 00 	movabs $0x801376,%r8
  8001ca:	00 00 00 
  8001cd:	41 ff d0             	callq  *%r8
  8001d0:	89 03                	mov    %eax,(%rbx)
                PGSIZE - sizeof(pkt->jp_len),
                "Packet %02d", i);
        cprintf("Transmitting packet %d\n", i);
  8001d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001d5:	89 c6                	mov    %eax,%esi
  8001d7:	48 bf 7f 4c 80 00 00 	movabs $0x804c7f,%rdi
  8001de:	00 00 00 
  8001e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e6:	48 ba 0e 09 80 00 00 	movabs $0x80090e,%rdx
  8001ed:	00 00 00 
  8001f0:	ff d2                	callq  *%rdx
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001f2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001f9:	00 00 00 
  8001fc:	48 8b 10             	mov    (%rax),%rdx
  8001ff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800206:	00 00 00 
  800209:	8b 00                	mov    (%rax),%eax
  80020b:	b9 07 00 00 00       	mov    $0x7,%ecx
  800210:	be 0b 00 00 00       	mov    $0xb,%esi
  800215:	89 c7                	mov    %eax,%edi
  800217:	48 b8 cb 28 80 00 00 	movabs $0x8028cb,%rax
  80021e:	00 00 00 
  800221:	ff d0                	callq  *%rax
        sys_page_unmap(0, pkt);
  800223:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80022a:	00 00 00 
  80022d:	48 8b 00             	mov    (%rax),%rax
  800230:	48 89 c6             	mov    %rax,%rsi
  800233:	bf 00 00 00 00       	mov    $0x0,%edi
  800238:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  80023f:	00 00 00 
  800242:	ff d0                	callq  *%rax
		cprintf("output enviornment %d",thisenv->env_id);
        output(ns_envid);
        return;
    }

    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  800244:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800248:	83 7d ec 09          	cmpl   $0x9,-0x14(%rbp)
  80024c:	0f 8e db fe ff ff    	jle    80012d <umain+0xea>
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
        sys_page_unmap(0, pkt);
    }

    // Spin for a while, just in case IPC's or packets need to be flushed
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800252:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  800259:	eb 10                	jmp    80026b <umain+0x228>
        sys_yield();
  80025b:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  800262:	00 00 00 
  800265:	ff d0                	callq  *%rax
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
        sys_page_unmap(0, pkt);
    }

    // Spin for a while, just in case IPC's or packets need to be flushed
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800267:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80026b:	83 7d ec 13          	cmpl   $0x13,-0x14(%rbp)
  80026f:	7e ea                	jle    80025b <umain+0x218>
        sys_yield();
}
  800271:	48 83 c4 28          	add    $0x28,%rsp
  800275:	5b                   	pop    %rbx
  800276:	5d                   	pop    %rbp
  800277:	c3                   	retq   

0000000000800278 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800278:	55                   	push   %rbp
  800279:	48 89 e5             	mov    %rsp,%rbp
  80027c:	53                   	push   %rbx
  80027d:	48 83 ec 28          	sub    $0x28,%rsp
  800281:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800284:	89 75 d8             	mov    %esi,-0x28(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  800287:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
  800293:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800296:	01 d0                	add    %edx,%eax
  800298:	89 45 ec             	mov    %eax,-0x14(%rbp)

    binaryname = "ns_timer";
  80029b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8002a2:	00 00 00 
  8002a5:	48 bb 98 4c 80 00 00 	movabs $0x804c98,%rbx
  8002ac:	00 00 00 
  8002af:	48 89 18             	mov    %rbx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  8002b2:	eb 0c                	jmp    8002c0 <timer+0x48>
            sys_yield();
  8002b4:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  8002c0:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  8002c7:	00 00 00 
  8002ca:	ff d0                	callq  *%rax
  8002cc:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002cf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002d2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8002d5:	73 06                	jae    8002dd <timer+0x65>
  8002d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002db:	79 d7                	jns    8002b4 <timer+0x3c>
            sys_yield();
        }
        if (r < 0)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <timer+0x9b>
            panic("sys_time_msec: %e", r);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba a1 4c 80 00 00 	movabs $0x804ca1,%rdx
  8002ef:	00 00 00 
  8002f2:	be 0f 00 00 00       	mov    $0xf,%esi
  8002f7:	48 bf b3 4c 80 00 00 	movabs $0x804cb3,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	49 b8 d5 06 80 00 00 	movabs $0x8006d5,%r8
  80030d:	00 00 00 
  800310:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  800313:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800316:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031b:	ba 00 00 00 00       	mov    $0x0,%edx
  800320:	be 0c 00 00 00       	mov    $0xc,%esi
  800325:	89 c7                	mov    %eax,%edi
  800327:	48 b8 cb 28 80 00 00 	movabs $0x8028cb,%rax
  80032e:	00 00 00 
  800331:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  800333:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800337:	ba 00 00 00 00       	mov    $0x0,%edx
  80033c:	be 00 00 00 00       	mov    $0x0,%esi
  800341:	48 89 c7             	mov    %rax,%rdi
  800344:	48 b8 c5 27 80 00 00 	movabs $0x8027c5,%rax
  80034b:	00 00 00 
  80034e:	ff d0                	callq  *%rax
  800350:	89 45 e4             	mov    %eax,-0x1c(%rbp)

            if (whom != ns_envid) {
  800353:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800356:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800359:	39 c2                	cmp    %eax,%edx
  80035b:	74 22                	je     80037f <timer+0x107>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  80035d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800360:	89 c6                	mov    %eax,%esi
  800362:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  800369:	00 00 00 
  80036c:	b8 00 00 00 00       	mov    $0x0,%eax
  800371:	48 ba 0e 09 80 00 00 	movabs $0x80090e,%rdx
  800378:	00 00 00 
  80037b:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  80037d:	eb b4                	jmp    800333 <timer+0xbb>
            if (whom != ns_envid) {
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
                continue;
            }

            stop = sys_time_msec() + to;
  80037f:	48 b8 ed 20 80 00 00 	movabs $0x8020ed,%rax
  800386:	00 00 00 
  800389:	ff d0                	callq  *%rax
  80038b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80038e:	01 d0                	add    %edx,%eax
  800390:	89 45 ec             	mov    %eax,-0x14(%rbp)
            break;
        }
    }
  800393:	90                   	nop
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800394:	e9 27 ff ff ff       	jmpq   8002c0 <timer+0x48>

0000000000800399 <input>:

#define debug 0

void
input(envid_t ns_envid)
{
  800399:	55                   	push   %rbp
  80039a:	48 89 e5             	mov    %rsp,%rbp
  80039d:	53                   	push   %rbx
  80039e:	48 81 ec 28 08 00 00 	sub    $0x828,%rsp
  8003a5:	89 bd dc f7 ff ff    	mov    %edi,-0x824(%rbp)
    binaryname = "ns_input";
  8003ab:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8003b2:	00 00 00 
  8003b5:	48 bb fb 4c 80 00 00 	movabs $0x804cfb,%rbx
  8003bc:	00 00 00 
  8003bf:	48 89 18             	mov    %rbx,(%rax)
		//If allocating new page each time		
        //sys_page_unmap(0, &nsipcbuf.pkt.jp_data);
	}
#else
	char buf[2048];
	int perm = PTE_U | PTE_P | PTE_W; //This is needed for page allocation from kern to user environment. (Remember no transfer can happen (that is sys_page_map)
  8003c2:	c7 45 ec 07 00 00 00 	movl   $0x7,-0x14(%rbp)
	int len = 2047; // Buffer length
  8003c9:	c7 45 e8 ff 07 00 00 	movl   $0x7ff,-0x18(%rbp)
	int r = 0;
  8003d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	while (1) {
		while ((r = sys_net_rx(&buf)) < 0) {
  8003d7:	eb 0c                	jmp    8003e5 <input+0x4c>
			sys_yield(); //This was neat.
  8003d9:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  8003e0:	00 00 00 
  8003e3:	ff d0                	callq  *%rax
	char buf[2048];
	int perm = PTE_U | PTE_P | PTE_W; //This is needed for page allocation from kern to user environment. (Remember no transfer can happen (that is sys_page_map)
	int len = 2047; // Buffer length
	int r = 0;
	while (1) {
		while ((r = sys_net_rx(&buf)) < 0) {
  8003e5:	48 8d 85 e0 f7 ff ff 	lea    -0x820(%rbp),%rax
  8003ec:	48 89 c7             	mov    %rax,%rdi
  8003ef:	48 b8 a9 20 80 00 00 	movabs $0x8020a9,%rax
  8003f6:	00 00 00 
  8003f9:	ff d0                	callq  *%rax
  8003fb:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8003fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800402:	78 d5                	js     8003d9 <input+0x40>
			sys_yield(); //This was neat.
		}
		len = r;
  800404:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800407:	89 45 e8             	mov    %eax,-0x18(%rbp)
		// Get the page received from the PCI. (Don't use sys_page_map..use alloc)
		while ((r = sys_page_alloc(0, &nsipcbuf, perm)) < 0);
  80040a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  800416:	00 00 00 
  800419:	bf 00 00 00 00       	mov    $0x0,%edi
  80041e:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  800425:	00 00 00 
  800428:	ff d0                	callq  *%rax
  80042a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80042d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800431:	78 d7                	js     80040a <input+0x71>
		nsipcbuf.pkt.jp_len = len;
  800433:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80043a:	00 00 00 
  80043d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800440:	89 10                	mov    %edx,(%rax)
		memmove(nsipcbuf.pkt.jp_data, buf, len);
  800442:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800445:	48 63 d0             	movslq %eax,%rdx
  800448:	48 8d 85 e0 f7 ff ff 	lea    -0x820(%rbp),%rax
  80044f:	48 89 c6             	mov    %rax,%rsi
  800452:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  800459:	00 00 00 
  80045c:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  800463:	00 00 00 
  800466:	ff d0                	callq  *%rax
		while ((r = sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, perm)) < 0);
  800468:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80046b:	8b 85 dc f7 ff ff    	mov    -0x824(%rbp),%eax
  800471:	89 d1                	mov    %edx,%ecx
  800473:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  80047a:	00 00 00 
  80047d:	be 0a 00 00 00       	mov    $0xa,%esi
  800482:	89 c7                	mov    %eax,%edi
  800484:	48 b8 c6 1f 80 00 00 	movabs $0x801fc6,%rax
  80048b:	00 00 00 
  80048e:	ff d0                	callq  *%rax
  800490:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800493:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800497:	78 cf                	js     800468 <input+0xcf>
	}
  800499:	90                   	nop
	char buf[2048];
	int perm = PTE_U | PTE_P | PTE_W; //This is needed for page allocation from kern to user environment. (Remember no transfer can happen (that is sys_page_map)
	int len = 2047; // Buffer length
	int r = 0;
	while (1) {
		while ((r = sys_net_rx(&buf)) < 0) {
  80049a:	e9 46 ff ff ff       	jmpq   8003e5 <input+0x4c>

000000000080049f <output>:
// Virtual address at which to receive page mappings containing client requests.
struct jif_pkt *sendReq = (struct jif_pkt *)(0x0ffff000 - PGSIZE);

void
output(envid_t ns_envid)
{
  80049f:	55                   	push   %rbp
  8004a0:	48 89 e5             	mov    %rsp,%rbp
  8004a3:	53                   	push   %rbx
  8004a4:	48 83 ec 38          	sub    $0x38,%rsp
  8004a8:	89 7d cc             	mov    %edi,-0x34(%rbp)
    binaryname = "ns_output";
  8004ab:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8004b2:	00 00 00 
  8004b5:	48 bb 08 4d 80 00 00 	movabs $0x804d08,%rbx
  8004bc:	00 00 00 
  8004bf:	48 89 18             	mov    %rbx,(%rax)

    // LAB 6: Your code here:
    // 	- read a packet from the network server
    //	- send the packet to the device driver
#if 1
	void* buf = NULL;
  8004c2:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8004c9:	00 
	size_t len = 0;
  8004ca:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8004d1:	00 
	//struct jif_pkt *sendReq;
	uint32_t req, whom;
	int perm, r;

	while (1) {
		perm = 0;
  8004d2:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%rbp)

		cprintf("output env id %d \n", thisenv->env_id);
  8004d9:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8004e0:	00 00 00 
  8004e3:	48 8b 00             	mov    (%rax),%rax
  8004e6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8004ec:	89 c6                	mov    %eax,%esi
  8004ee:	48 bf 12 4d 80 00 00 	movabs $0x804d12,%rdi
  8004f5:	00 00 00 
  8004f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fd:	48 ba 0e 09 80 00 00 	movabs $0x80090e,%rdx
  800504:	00 00 00 
  800507:	ff d2                	callq  *%rdx

		req = ipc_recv((int32_t *) &whom, sendReq, &perm);
  800509:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800510:	00 00 00 
  800513:	48 8b 08             	mov    (%rax),%rcx
  800516:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  80051a:	48 8d 45 d4          	lea    -0x2c(%rbp),%rax
  80051e:	48 89 ce             	mov    %rcx,%rsi
  800521:	48 89 c7             	mov    %rax,%rdi
  800524:	48 b8 c5 27 80 00 00 	movabs $0x8027c5,%rax
  80052b:	00 00 00 
  80052e:	ff d0                	callq  *%rax
  800530:	89 45 dc             	mov    %eax,-0x24(%rbp)
		while(thisenv->env_ipc_recving == 1)
  800533:	eb 0c                	jmp    800541 <output+0xa2>
			sys_yield();
  800535:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  80053c:	00 00 00 
  80053f:	ff d0                	callq  *%rax
		perm = 0;

		cprintf("output env id %d \n", thisenv->env_id);

		req = ipc_recv((int32_t *) &whom, sendReq, &perm);
		while(thisenv->env_ipc_recving == 1)
  800541:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800548:	00 00 00 
  80054b:	48 8b 00             	mov    (%rax),%rax
  80054e:	0f b6 80 f8 00 00 00 	movzbl 0xf8(%rax),%eax
  800555:	84 c0                	test   %al,%al
  800557:	75 dc                	jne    800535 <output+0x96>
		if (debug)
			cprintf("net packet send req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(sendReq)], sendReq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  800559:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80055c:	83 e0 01             	and    $0x1,%eax
  80055f:	85 c0                	test   %eax,%eax
  800561:	75 26                	jne    800589 <output+0xea>
			cprintf("Invalid request from %08x: no argument page\n",
  800563:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800566:	89 c6                	mov    %eax,%esi
  800568:	48 bf 28 4d 80 00 00 	movabs $0x804d28,%rdi
  80056f:	00 00 00 
  800572:	b8 00 00 00 00       	mov    $0x0,%eax
  800577:	48 ba 0e 09 80 00 00 	movabs $0x80090e,%rdx
  80057e:	00 00 00 
  800581:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  800583:	90                   	nop
			continue;
		}
		while ((r = sys_net_tx(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0);		
		//cprintf("buffer %s len %d\n", nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
#endif		
    }
  800584:	e9 49 ff ff ff       	jmpq   8004d2 <output+0x33>
			continue; // just leave it hanging...
		}
		//if(debug)
		//	cprintf("output data %s",sendReq->jp_data);

		if(req == NSREQ_OUTPUT)
  800589:	83 7d dc 0b          	cmpl   $0xb,-0x24(%rbp)
  80058d:	75 48                	jne    8005d7 <output+0x138>
		{	
			while(sys_net_tx((void*)sendReq->jp_data, sendReq->jp_len) != 0)
  80058f:	eb 0c                	jmp    80059d <output+0xfe>
			{
				sys_yield();
  800591:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  800598:	00 00 00 
  80059b:	ff d0                	callq  *%rax
		//if(debug)
		//	cprintf("output data %s",sendReq->jp_data);

		if(req == NSREQ_OUTPUT)
		{	
			while(sys_net_tx((void*)sendReq->jp_data, sendReq->jp_len) != 0)
  80059d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8005a4:	00 00 00 
  8005a7:	48 8b 00             	mov    (%rax),%rax
  8005aa:	8b 00                	mov    (%rax),%eax
  8005ac:	48 98                	cltq   
  8005ae:	48 ba 08 70 80 00 00 	movabs $0x807008,%rdx
  8005b5:	00 00 00 
  8005b8:	48 8b 12             	mov    (%rdx),%rdx
  8005bb:	48 83 c2 04          	add    $0x4,%rdx
  8005bf:	48 89 c6             	mov    %rax,%rsi
  8005c2:	48 89 d7             	mov    %rdx,%rdi
  8005c5:	48 b8 5f 20 80 00 00 	movabs $0x80205f,%rax
  8005cc:	00 00 00 
  8005cf:	ff d0                	callq  *%rax
  8005d1:	85 c0                	test   %eax,%eax
  8005d3:	75 bc                	jne    800591 <output+0xf2>
  8005d5:	eb 2a                	jmp    800601 <output+0x162>
			{
				sys_yield();
			}
		}else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8005d7:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8005da:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8005dd:	89 c6                	mov    %eax,%esi
  8005df:	48 bf 58 4d 80 00 00 	movabs $0x804d58,%rdi
  8005e6:	00 00 00 
  8005e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ee:	48 b9 0e 09 80 00 00 	movabs $0x80090e,%rcx
  8005f5:	00 00 00 
  8005f8:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  8005fa:	c7 45 d8 fd ff ff ff 	movl   $0xfffffffd,-0x28(%rbp)
		}
		
		if(debug)
			cprintf("Net Output: Sent packet to kernel %d to %x\n", r, whom);
		sys_page_unmap(0, sendReq);
  800601:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800608:	00 00 00 
  80060b:	48 8b 00             	mov    (%rax),%rax
  80060e:	48 89 c6             	mov    %rax,%rsi
  800611:	bf 00 00 00 00       	mov    $0x0,%edi
  800616:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  80061d:	00 00 00 
  800620:	ff d0                	callq  *%rax
			continue;
		}
		while ((r = sys_net_tx(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0);		
		//cprintf("buffer %s len %d\n", nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
#endif		
    }
  800622:	e9 ab fe ff ff       	jmpq   8004d2 <output+0x33>

0000000000800627 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800627:	55                   	push   %rbp
  800628:	48 89 e5             	mov    %rsp,%rbp
  80062b:	48 83 ec 10          	sub    $0x10,%rsp
  80062f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800632:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800636:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  80063d:	00 00 00 
  800640:	ff d0                	callq  *%rax
  800642:	25 ff 03 00 00       	and    $0x3ff,%eax
  800647:	48 63 d0             	movslq %eax,%rdx
  80064a:	48 89 d0             	mov    %rdx,%rax
  80064d:	48 c1 e0 03          	shl    $0x3,%rax
  800651:	48 01 d0             	add    %rdx,%rax
  800654:	48 c1 e0 05          	shl    $0x5,%rax
  800658:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80065f:	00 00 00 
  800662:	48 01 c2             	add    %rax,%rdx
  800665:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80066c:	00 00 00 
  80066f:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800672:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800676:	7e 14                	jle    80068c <libmain+0x65>
		binaryname = argv[0];
  800678:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067c:	48 8b 10             	mov    (%rax),%rdx
  80067f:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800686:	00 00 00 
  800689:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80068c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800690:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800693:	48 89 d6             	mov    %rdx,%rsi
  800696:	89 c7                	mov    %eax,%edi
  800698:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80069f:	00 00 00 
  8006a2:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  8006a4:	48 b8 b2 06 80 00 00 	movabs $0x8006b2,%rax
  8006ab:	00 00 00 
  8006ae:	ff d0                	callq  *%rax
}
  8006b0:	c9                   	leaveq 
  8006b1:	c3                   	retq   

00000000008006b2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006b2:	55                   	push   %rbp
  8006b3:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8006b6:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  8006bd:	00 00 00 
  8006c0:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8006c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8006c7:	48 b8 32 1d 80 00 00 	movabs $0x801d32,%rax
  8006ce:	00 00 00 
  8006d1:	ff d0                	callq  *%rax

}
  8006d3:	5d                   	pop    %rbp
  8006d4:	c3                   	retq   

00000000008006d5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006d5:	55                   	push   %rbp
  8006d6:	48 89 e5             	mov    %rsp,%rbp
  8006d9:	53                   	push   %rbx
  8006da:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8006e1:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8006e8:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8006ee:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8006f5:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8006fc:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800703:	84 c0                	test   %al,%al
  800705:	74 23                	je     80072a <_panic+0x55>
  800707:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80070e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800712:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800716:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80071a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80071e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800722:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800726:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80072a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800731:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800738:	00 00 00 
  80073b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800742:	00 00 00 
  800745:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800749:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800750:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800757:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80075e:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800765:	00 00 00 
  800768:	48 8b 18             	mov    (%rax),%rbx
  80076b:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  800772:	00 00 00 
  800775:	ff d0                	callq  *%rax
  800777:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80077d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800784:	41 89 c8             	mov    %ecx,%r8d
  800787:	48 89 d1             	mov    %rdx,%rcx
  80078a:	48 89 da             	mov    %rbx,%rdx
  80078d:	89 c6                	mov    %eax,%esi
  80078f:	48 bf 88 4d 80 00 00 	movabs $0x804d88,%rdi
  800796:	00 00 00 
  800799:	b8 00 00 00 00       	mov    $0x0,%eax
  80079e:	49 b9 0e 09 80 00 00 	movabs $0x80090e,%r9
  8007a5:	00 00 00 
  8007a8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8007ab:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8007b2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007b9:	48 89 d6             	mov    %rdx,%rsi
  8007bc:	48 89 c7             	mov    %rax,%rdi
  8007bf:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  8007c6:	00 00 00 
  8007c9:	ff d0                	callq  *%rax
	cprintf("\n");
  8007cb:	48 bf ab 4d 80 00 00 	movabs $0x804dab,%rdi
  8007d2:	00 00 00 
  8007d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007da:	48 ba 0e 09 80 00 00 	movabs $0x80090e,%rdx
  8007e1:	00 00 00 
  8007e4:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8007e6:	cc                   	int3   
  8007e7:	eb fd                	jmp    8007e6 <_panic+0x111>

00000000008007e9 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8007e9:	55                   	push   %rbp
  8007ea:	48 89 e5             	mov    %rsp,%rbp
  8007ed:	48 83 ec 10          	sub    $0x10,%rsp
  8007f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8007f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8007f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007fc:	8b 00                	mov    (%rax),%eax
  8007fe:	8d 48 01             	lea    0x1(%rax),%ecx
  800801:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800805:	89 0a                	mov    %ecx,(%rdx)
  800807:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80080a:	89 d1                	mov    %edx,%ecx
  80080c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800810:	48 98                	cltq   
  800812:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800816:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80081a:	8b 00                	mov    (%rax),%eax
  80081c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800821:	75 2c                	jne    80084f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800823:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800827:	8b 00                	mov    (%rax),%eax
  800829:	48 98                	cltq   
  80082b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80082f:	48 83 c2 08          	add    $0x8,%rdx
  800833:	48 89 c6             	mov    %rax,%rsi
  800836:	48 89 d7             	mov    %rdx,%rdi
  800839:	48 b8 aa 1c 80 00 00 	movabs $0x801caa,%rax
  800840:	00 00 00 
  800843:	ff d0                	callq  *%rax
        b->idx = 0;
  800845:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800849:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80084f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800853:	8b 40 04             	mov    0x4(%rax),%eax
  800856:	8d 50 01             	lea    0x1(%rax),%edx
  800859:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80085d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800860:	c9                   	leaveq 
  800861:	c3                   	retq   

0000000000800862 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800862:	55                   	push   %rbp
  800863:	48 89 e5             	mov    %rsp,%rbp
  800866:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80086d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800874:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80087b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800882:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800889:	48 8b 0a             	mov    (%rdx),%rcx
  80088c:	48 89 08             	mov    %rcx,(%rax)
  80088f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800893:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800897:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80089b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80089f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8008a6:	00 00 00 
    b.cnt = 0;
  8008a9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8008b0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8008b3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8008ba:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8008c1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8008c8:	48 89 c6             	mov    %rax,%rsi
  8008cb:	48 bf e9 07 80 00 00 	movabs $0x8007e9,%rdi
  8008d2:	00 00 00 
  8008d5:	48 b8 c1 0c 80 00 00 	movabs $0x800cc1,%rax
  8008dc:	00 00 00 
  8008df:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8008e1:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8008e7:	48 98                	cltq   
  8008e9:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8008f0:	48 83 c2 08          	add    $0x8,%rdx
  8008f4:	48 89 c6             	mov    %rax,%rsi
  8008f7:	48 89 d7             	mov    %rdx,%rdi
  8008fa:	48 b8 aa 1c 80 00 00 	movabs $0x801caa,%rax
  800901:	00 00 00 
  800904:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800906:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80090c:	c9                   	leaveq 
  80090d:	c3                   	retq   

000000000080090e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80090e:	55                   	push   %rbp
  80090f:	48 89 e5             	mov    %rsp,%rbp
  800912:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800919:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800920:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800927:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80092e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800935:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80093c:	84 c0                	test   %al,%al
  80093e:	74 20                	je     800960 <cprintf+0x52>
  800940:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800944:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800948:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80094c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800950:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800954:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800958:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80095c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800960:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800967:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80096e:	00 00 00 
  800971:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800978:	00 00 00 
  80097b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80097f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800986:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80098d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800994:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80099b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8009a2:	48 8b 0a             	mov    (%rdx),%rcx
  8009a5:	48 89 08             	mov    %rcx,(%rax)
  8009a8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009ac:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009b0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009b4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8009b8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8009bf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009c6:	48 89 d6             	mov    %rdx,%rsi
  8009c9:	48 89 c7             	mov    %rax,%rdi
  8009cc:	48 b8 62 08 80 00 00 	movabs $0x800862,%rax
  8009d3:	00 00 00 
  8009d6:	ff d0                	callq  *%rax
  8009d8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8009de:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8009e4:	c9                   	leaveq 
  8009e5:	c3                   	retq   

00000000008009e6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009e6:	55                   	push   %rbp
  8009e7:	48 89 e5             	mov    %rsp,%rbp
  8009ea:	53                   	push   %rbx
  8009eb:	48 83 ec 38          	sub    $0x38,%rsp
  8009ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8009f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8009fb:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8009fe:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800a02:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a06:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800a09:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800a0d:	77 3b                	ja     800a4a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a0f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800a12:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800a16:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a22:	48 f7 f3             	div    %rbx
  800a25:	48 89 c2             	mov    %rax,%rdx
  800a28:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800a2b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800a2e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a36:	41 89 f9             	mov    %edi,%r9d
  800a39:	48 89 c7             	mov    %rax,%rdi
  800a3c:	48 b8 e6 09 80 00 00 	movabs $0x8009e6,%rax
  800a43:	00 00 00 
  800a46:	ff d0                	callq  *%rax
  800a48:	eb 1e                	jmp    800a68 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a4a:	eb 12                	jmp    800a5e <printnum+0x78>
			putch(padc, putdat);
  800a4c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800a50:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800a53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a57:	48 89 ce             	mov    %rcx,%rsi
  800a5a:	89 d7                	mov    %edx,%edi
  800a5c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a5e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800a62:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800a66:	7f e4                	jg     800a4c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a68:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800a6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a74:	48 f7 f1             	div    %rcx
  800a77:	48 89 d0             	mov    %rdx,%rax
  800a7a:	48 ba b0 4f 80 00 00 	movabs $0x804fb0,%rdx
  800a81:	00 00 00 
  800a84:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800a88:	0f be d0             	movsbl %al,%edx
  800a8b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a93:	48 89 ce             	mov    %rcx,%rsi
  800a96:	89 d7                	mov    %edx,%edi
  800a98:	ff d0                	callq  *%rax
}
  800a9a:	48 83 c4 38          	add    $0x38,%rsp
  800a9e:	5b                   	pop    %rbx
  800a9f:	5d                   	pop    %rbp
  800aa0:	c3                   	retq   

0000000000800aa1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aa1:	55                   	push   %rbp
  800aa2:	48 89 e5             	mov    %rsp,%rbp
  800aa5:	48 83 ec 1c          	sub    $0x1c,%rsp
  800aa9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800aad:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800ab0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ab4:	7e 52                	jle    800b08 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aba:	8b 00                	mov    (%rax),%eax
  800abc:	83 f8 30             	cmp    $0x30,%eax
  800abf:	73 24                	jae    800ae5 <getuint+0x44>
  800ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ac9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acd:	8b 00                	mov    (%rax),%eax
  800acf:	89 c0                	mov    %eax,%eax
  800ad1:	48 01 d0             	add    %rdx,%rax
  800ad4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad8:	8b 12                	mov    (%rdx),%edx
  800ada:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800add:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae1:	89 0a                	mov    %ecx,(%rdx)
  800ae3:	eb 17                	jmp    800afc <getuint+0x5b>
  800ae5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aed:	48 89 d0             	mov    %rdx,%rax
  800af0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800afc:	48 8b 00             	mov    (%rax),%rax
  800aff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b03:	e9 a3 00 00 00       	jmpq   800bab <getuint+0x10a>
	else if (lflag)
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b0c:	74 4f                	je     800b5d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800b0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b12:	8b 00                	mov    (%rax),%eax
  800b14:	83 f8 30             	cmp    $0x30,%eax
  800b17:	73 24                	jae    800b3d <getuint+0x9c>
  800b19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b25:	8b 00                	mov    (%rax),%eax
  800b27:	89 c0                	mov    %eax,%eax
  800b29:	48 01 d0             	add    %rdx,%rax
  800b2c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b30:	8b 12                	mov    (%rdx),%edx
  800b32:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b35:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b39:	89 0a                	mov    %ecx,(%rdx)
  800b3b:	eb 17                	jmp    800b54 <getuint+0xb3>
  800b3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b41:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b45:	48 89 d0             	mov    %rdx,%rax
  800b48:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b50:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b54:	48 8b 00             	mov    (%rax),%rax
  800b57:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b5b:	eb 4e                	jmp    800bab <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b61:	8b 00                	mov    (%rax),%eax
  800b63:	83 f8 30             	cmp    $0x30,%eax
  800b66:	73 24                	jae    800b8c <getuint+0xeb>
  800b68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b6c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b74:	8b 00                	mov    (%rax),%eax
  800b76:	89 c0                	mov    %eax,%eax
  800b78:	48 01 d0             	add    %rdx,%rax
  800b7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7f:	8b 12                	mov    (%rdx),%edx
  800b81:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b88:	89 0a                	mov    %ecx,(%rdx)
  800b8a:	eb 17                	jmp    800ba3 <getuint+0x102>
  800b8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b90:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b94:	48 89 d0             	mov    %rdx,%rax
  800b97:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b9f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ba3:	8b 00                	mov    (%rax),%eax
  800ba5:	89 c0                	mov    %eax,%eax
  800ba7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800baf:	c9                   	leaveq 
  800bb0:	c3                   	retq   

0000000000800bb1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bb1:	55                   	push   %rbp
  800bb2:	48 89 e5             	mov    %rsp,%rbp
  800bb5:	48 83 ec 1c          	sub    $0x1c,%rsp
  800bb9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800bbd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800bc0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800bc4:	7e 52                	jle    800c18 <getint+0x67>
		x=va_arg(*ap, long long);
  800bc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bca:	8b 00                	mov    (%rax),%eax
  800bcc:	83 f8 30             	cmp    $0x30,%eax
  800bcf:	73 24                	jae    800bf5 <getint+0x44>
  800bd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800bd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdd:	8b 00                	mov    (%rax),%eax
  800bdf:	89 c0                	mov    %eax,%eax
  800be1:	48 01 d0             	add    %rdx,%rax
  800be4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800be8:	8b 12                	mov    (%rdx),%edx
  800bea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bf1:	89 0a                	mov    %ecx,(%rdx)
  800bf3:	eb 17                	jmp    800c0c <getint+0x5b>
  800bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bfd:	48 89 d0             	mov    %rdx,%rax
  800c00:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c08:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c0c:	48 8b 00             	mov    (%rax),%rax
  800c0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c13:	e9 a3 00 00 00       	jmpq   800cbb <getint+0x10a>
	else if (lflag)
  800c18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800c1c:	74 4f                	je     800c6d <getint+0xbc>
		x=va_arg(*ap, long);
  800c1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c22:	8b 00                	mov    (%rax),%eax
  800c24:	83 f8 30             	cmp    $0x30,%eax
  800c27:	73 24                	jae    800c4d <getint+0x9c>
  800c29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c35:	8b 00                	mov    (%rax),%eax
  800c37:	89 c0                	mov    %eax,%eax
  800c39:	48 01 d0             	add    %rdx,%rax
  800c3c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c40:	8b 12                	mov    (%rdx),%edx
  800c42:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c49:	89 0a                	mov    %ecx,(%rdx)
  800c4b:	eb 17                	jmp    800c64 <getint+0xb3>
  800c4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c51:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800c55:	48 89 d0             	mov    %rdx,%rax
  800c58:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800c5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c60:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c64:	48 8b 00             	mov    (%rax),%rax
  800c67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800c6b:	eb 4e                	jmp    800cbb <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800c6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c71:	8b 00                	mov    (%rax),%eax
  800c73:	83 f8 30             	cmp    $0x30,%eax
  800c76:	73 24                	jae    800c9c <getint+0xeb>
  800c78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c7c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800c80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c84:	8b 00                	mov    (%rax),%eax
  800c86:	89 c0                	mov    %eax,%eax
  800c88:	48 01 d0             	add    %rdx,%rax
  800c8b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c8f:	8b 12                	mov    (%rdx),%edx
  800c91:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800c94:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c98:	89 0a                	mov    %ecx,(%rdx)
  800c9a:	eb 17                	jmp    800cb3 <getint+0x102>
  800c9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ca4:	48 89 d0             	mov    %rdx,%rax
  800ca7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800cab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800caf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cb3:	8b 00                	mov    (%rax),%eax
  800cb5:	48 98                	cltq   
  800cb7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800cbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800cbf:	c9                   	leaveq 
  800cc0:	c3                   	retq   

0000000000800cc1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cc1:	55                   	push   %rbp
  800cc2:	48 89 e5             	mov    %rsp,%rbp
  800cc5:	41 54                	push   %r12
  800cc7:	53                   	push   %rbx
  800cc8:	48 83 ec 60          	sub    $0x60,%rsp
  800ccc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800cd0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800cd4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800cd8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800cdc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ce4:	48 8b 0a             	mov    (%rdx),%rcx
  800ce7:	48 89 08             	mov    %rcx,(%rax)
  800cea:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cee:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cf2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cf6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cfa:	eb 17                	jmp    800d13 <vprintfmt+0x52>
			if (ch == '\0')
  800cfc:	85 db                	test   %ebx,%ebx
  800cfe:	0f 84 cc 04 00 00    	je     8011d0 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800d04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0c:	48 89 d6             	mov    %rdx,%rsi
  800d0f:	89 df                	mov    %ebx,%edi
  800d11:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d13:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d17:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d1b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d1f:	0f b6 00             	movzbl (%rax),%eax
  800d22:	0f b6 d8             	movzbl %al,%ebx
  800d25:	83 fb 25             	cmp    $0x25,%ebx
  800d28:	75 d2                	jne    800cfc <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d2a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800d2e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800d35:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800d3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800d43:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d4a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d4e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d52:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800d56:	0f b6 00             	movzbl (%rax),%eax
  800d59:	0f b6 d8             	movzbl %al,%ebx
  800d5c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800d5f:	83 f8 55             	cmp    $0x55,%eax
  800d62:	0f 87 34 04 00 00    	ja     80119c <vprintfmt+0x4db>
  800d68:	89 c0                	mov    %eax,%eax
  800d6a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800d71:	00 
  800d72:	48 b8 d8 4f 80 00 00 	movabs $0x804fd8,%rax
  800d79:	00 00 00 
  800d7c:	48 01 d0             	add    %rdx,%rax
  800d7f:	48 8b 00             	mov    (%rax),%rax
  800d82:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800d84:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800d88:	eb c0                	jmp    800d4a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d8a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800d8e:	eb ba                	jmp    800d4a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d90:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800d97:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800d9a:	89 d0                	mov    %edx,%eax
  800d9c:	c1 e0 02             	shl    $0x2,%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	01 c0                	add    %eax,%eax
  800da3:	01 d8                	add    %ebx,%eax
  800da5:	83 e8 30             	sub    $0x30,%eax
  800da8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800dab:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800daf:	0f b6 00             	movzbl (%rax),%eax
  800db2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800db5:	83 fb 2f             	cmp    $0x2f,%ebx
  800db8:	7e 0c                	jle    800dc6 <vprintfmt+0x105>
  800dba:	83 fb 39             	cmp    $0x39,%ebx
  800dbd:	7f 07                	jg     800dc6 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dbf:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dc4:	eb d1                	jmp    800d97 <vprintfmt+0xd6>
			goto process_precision;
  800dc6:	eb 58                	jmp    800e20 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800dc8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dcb:	83 f8 30             	cmp    $0x30,%eax
  800dce:	73 17                	jae    800de7 <vprintfmt+0x126>
  800dd0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dd4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dd7:	89 c0                	mov    %eax,%eax
  800dd9:	48 01 d0             	add    %rdx,%rax
  800ddc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ddf:	83 c2 08             	add    $0x8,%edx
  800de2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800de5:	eb 0f                	jmp    800df6 <vprintfmt+0x135>
  800de7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800deb:	48 89 d0             	mov    %rdx,%rax
  800dee:	48 83 c2 08          	add    $0x8,%rdx
  800df2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800df6:	8b 00                	mov    (%rax),%eax
  800df8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800dfb:	eb 23                	jmp    800e20 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800dfd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e01:	79 0c                	jns    800e0f <vprintfmt+0x14e>
				width = 0;
  800e03:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800e0a:	e9 3b ff ff ff       	jmpq   800d4a <vprintfmt+0x89>
  800e0f:	e9 36 ff ff ff       	jmpq   800d4a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800e14:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800e1b:	e9 2a ff ff ff       	jmpq   800d4a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800e20:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e24:	79 12                	jns    800e38 <vprintfmt+0x177>
				width = precision, precision = -1;
  800e26:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e29:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800e2c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800e33:	e9 12 ff ff ff       	jmpq   800d4a <vprintfmt+0x89>
  800e38:	e9 0d ff ff ff       	jmpq   800d4a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e3d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800e41:	e9 04 ff ff ff       	jmpq   800d4a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800e46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e49:	83 f8 30             	cmp    $0x30,%eax
  800e4c:	73 17                	jae    800e65 <vprintfmt+0x1a4>
  800e4e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e55:	89 c0                	mov    %eax,%eax
  800e57:	48 01 d0             	add    %rdx,%rax
  800e5a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e5d:	83 c2 08             	add    $0x8,%edx
  800e60:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e63:	eb 0f                	jmp    800e74 <vprintfmt+0x1b3>
  800e65:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e69:	48 89 d0             	mov    %rdx,%rax
  800e6c:	48 83 c2 08          	add    $0x8,%rdx
  800e70:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e74:	8b 10                	mov    (%rax),%edx
  800e76:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e7e:	48 89 ce             	mov    %rcx,%rsi
  800e81:	89 d7                	mov    %edx,%edi
  800e83:	ff d0                	callq  *%rax
			break;
  800e85:	e9 40 03 00 00       	jmpq   8011ca <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800e8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e8d:	83 f8 30             	cmp    $0x30,%eax
  800e90:	73 17                	jae    800ea9 <vprintfmt+0x1e8>
  800e92:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e99:	89 c0                	mov    %eax,%eax
  800e9b:	48 01 d0             	add    %rdx,%rax
  800e9e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ea1:	83 c2 08             	add    $0x8,%edx
  800ea4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ea7:	eb 0f                	jmp    800eb8 <vprintfmt+0x1f7>
  800ea9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ead:	48 89 d0             	mov    %rdx,%rax
  800eb0:	48 83 c2 08          	add    $0x8,%rdx
  800eb4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800eb8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800eba:	85 db                	test   %ebx,%ebx
  800ebc:	79 02                	jns    800ec0 <vprintfmt+0x1ff>
				err = -err;
  800ebe:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ec0:	83 fb 15             	cmp    $0x15,%ebx
  800ec3:	7f 16                	jg     800edb <vprintfmt+0x21a>
  800ec5:	48 b8 00 4f 80 00 00 	movabs $0x804f00,%rax
  800ecc:	00 00 00 
  800ecf:	48 63 d3             	movslq %ebx,%rdx
  800ed2:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ed6:	4d 85 e4             	test   %r12,%r12
  800ed9:	75 2e                	jne    800f09 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800edb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800edf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ee3:	89 d9                	mov    %ebx,%ecx
  800ee5:	48 ba c1 4f 80 00 00 	movabs $0x804fc1,%rdx
  800eec:	00 00 00 
  800eef:	48 89 c7             	mov    %rax,%rdi
  800ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef7:	49 b8 d9 11 80 00 00 	movabs $0x8011d9,%r8
  800efe:	00 00 00 
  800f01:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f04:	e9 c1 02 00 00       	jmpq   8011ca <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f09:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f11:	4c 89 e1             	mov    %r12,%rcx
  800f14:	48 ba ca 4f 80 00 00 	movabs $0x804fca,%rdx
  800f1b:	00 00 00 
  800f1e:	48 89 c7             	mov    %rax,%rdi
  800f21:	b8 00 00 00 00       	mov    $0x0,%eax
  800f26:	49 b8 d9 11 80 00 00 	movabs $0x8011d9,%r8
  800f2d:	00 00 00 
  800f30:	41 ff d0             	callq  *%r8
			break;
  800f33:	e9 92 02 00 00       	jmpq   8011ca <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800f38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f3b:	83 f8 30             	cmp    $0x30,%eax
  800f3e:	73 17                	jae    800f57 <vprintfmt+0x296>
  800f40:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f47:	89 c0                	mov    %eax,%eax
  800f49:	48 01 d0             	add    %rdx,%rax
  800f4c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f4f:	83 c2 08             	add    $0x8,%edx
  800f52:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800f55:	eb 0f                	jmp    800f66 <vprintfmt+0x2a5>
  800f57:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f5b:	48 89 d0             	mov    %rdx,%rax
  800f5e:	48 83 c2 08          	add    $0x8,%rdx
  800f62:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f66:	4c 8b 20             	mov    (%rax),%r12
  800f69:	4d 85 e4             	test   %r12,%r12
  800f6c:	75 0a                	jne    800f78 <vprintfmt+0x2b7>
				p = "(null)";
  800f6e:	49 bc cd 4f 80 00 00 	movabs $0x804fcd,%r12
  800f75:	00 00 00 
			if (width > 0 && padc != '-')
  800f78:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f7c:	7e 3f                	jle    800fbd <vprintfmt+0x2fc>
  800f7e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800f82:	74 39                	je     800fbd <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f84:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800f87:	48 98                	cltq   
  800f89:	48 89 c6             	mov    %rax,%rsi
  800f8c:	4c 89 e7             	mov    %r12,%rdi
  800f8f:	48 b8 85 14 80 00 00 	movabs $0x801485,%rax
  800f96:	00 00 00 
  800f99:	ff d0                	callq  *%rax
  800f9b:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800f9e:	eb 17                	jmp    800fb7 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800fa0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800fa4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800fa8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fac:	48 89 ce             	mov    %rcx,%rsi
  800faf:	89 d7                	mov    %edx,%edi
  800fb1:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800fb3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800fb7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800fbb:	7f e3                	jg     800fa0 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fbd:	eb 37                	jmp    800ff6 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800fbf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800fc3:	74 1e                	je     800fe3 <vprintfmt+0x322>
  800fc5:	83 fb 1f             	cmp    $0x1f,%ebx
  800fc8:	7e 05                	jle    800fcf <vprintfmt+0x30e>
  800fca:	83 fb 7e             	cmp    $0x7e,%ebx
  800fcd:	7e 14                	jle    800fe3 <vprintfmt+0x322>
					putch('?', putdat);
  800fcf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd7:	48 89 d6             	mov    %rdx,%rsi
  800fda:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800fdf:	ff d0                	callq  *%rax
  800fe1:	eb 0f                	jmp    800ff2 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800fe3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800feb:	48 89 d6             	mov    %rdx,%rsi
  800fee:	89 df                	mov    %ebx,%edi
  800ff0:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ff2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ff6:	4c 89 e0             	mov    %r12,%rax
  800ff9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ffd:	0f b6 00             	movzbl (%rax),%eax
  801000:	0f be d8             	movsbl %al,%ebx
  801003:	85 db                	test   %ebx,%ebx
  801005:	74 10                	je     801017 <vprintfmt+0x356>
  801007:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80100b:	78 b2                	js     800fbf <vprintfmt+0x2fe>
  80100d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801011:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801015:	79 a8                	jns    800fbf <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801017:	eb 16                	jmp    80102f <vprintfmt+0x36e>
				putch(' ', putdat);
  801019:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80101d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801021:	48 89 d6             	mov    %rdx,%rsi
  801024:	bf 20 00 00 00       	mov    $0x20,%edi
  801029:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80102b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80102f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801033:	7f e4                	jg     801019 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  801035:	e9 90 01 00 00       	jmpq   8011ca <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80103a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80103e:	be 03 00 00 00       	mov    $0x3,%esi
  801043:	48 89 c7             	mov    %rax,%rdi
  801046:	48 b8 b1 0b 80 00 00 	movabs $0x800bb1,%rax
  80104d:	00 00 00 
  801050:	ff d0                	callq  *%rax
  801052:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105a:	48 85 c0             	test   %rax,%rax
  80105d:	79 1d                	jns    80107c <vprintfmt+0x3bb>
				putch('-', putdat);
  80105f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801063:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801067:	48 89 d6             	mov    %rdx,%rsi
  80106a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80106f:	ff d0                	callq  *%rax
				num = -(long long) num;
  801071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801075:	48 f7 d8             	neg    %rax
  801078:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80107c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801083:	e9 d5 00 00 00       	jmpq   80115d <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801088:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80108c:	be 03 00 00 00       	mov    $0x3,%esi
  801091:	48 89 c7             	mov    %rax,%rdi
  801094:	48 b8 a1 0a 80 00 00 	movabs $0x800aa1,%rax
  80109b:	00 00 00 
  80109e:	ff d0                	callq  *%rax
  8010a0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8010a4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8010ab:	e9 ad 00 00 00       	jmpq   80115d <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  8010b0:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8010b3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010b7:	89 d6                	mov    %edx,%esi
  8010b9:	48 89 c7             	mov    %rax,%rdi
  8010bc:	48 b8 b1 0b 80 00 00 	movabs $0x800bb1,%rax
  8010c3:	00 00 00 
  8010c6:	ff d0                	callq  *%rax
  8010c8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8010cc:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8010d3:	e9 85 00 00 00       	jmpq   80115d <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  8010d8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010dc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010e0:	48 89 d6             	mov    %rdx,%rsi
  8010e3:	bf 30 00 00 00       	mov    $0x30,%edi
  8010e8:	ff d0                	callq  *%rax
			putch('x', putdat);
  8010ea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f2:	48 89 d6             	mov    %rdx,%rsi
  8010f5:	bf 78 00 00 00       	mov    $0x78,%edi
  8010fa:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8010fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010ff:	83 f8 30             	cmp    $0x30,%eax
  801102:	73 17                	jae    80111b <vprintfmt+0x45a>
  801104:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801108:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80110b:	89 c0                	mov    %eax,%eax
  80110d:	48 01 d0             	add    %rdx,%rax
  801110:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801113:	83 c2 08             	add    $0x8,%edx
  801116:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801119:	eb 0f                	jmp    80112a <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80111b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80111f:	48 89 d0             	mov    %rdx,%rax
  801122:	48 83 c2 08          	add    $0x8,%rdx
  801126:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80112a:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80112d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801131:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801138:	eb 23                	jmp    80115d <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80113a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80113e:	be 03 00 00 00       	mov    $0x3,%esi
  801143:	48 89 c7             	mov    %rax,%rdi
  801146:	48 b8 a1 0a 80 00 00 	movabs $0x800aa1,%rax
  80114d:	00 00 00 
  801150:	ff d0                	callq  *%rax
  801152:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801156:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80115d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801162:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801165:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801168:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80116c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801170:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801174:	45 89 c1             	mov    %r8d,%r9d
  801177:	41 89 f8             	mov    %edi,%r8d
  80117a:	48 89 c7             	mov    %rax,%rdi
  80117d:	48 b8 e6 09 80 00 00 	movabs $0x8009e6,%rax
  801184:	00 00 00 
  801187:	ff d0                	callq  *%rax
			break;
  801189:	eb 3f                	jmp    8011ca <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80118b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80118f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801193:	48 89 d6             	mov    %rdx,%rsi
  801196:	89 df                	mov    %ebx,%edi
  801198:	ff d0                	callq  *%rax
			break;
  80119a:	eb 2e                	jmp    8011ca <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80119c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011a0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011a4:	48 89 d6             	mov    %rdx,%rsi
  8011a7:	bf 25 00 00 00       	mov    $0x25,%edi
  8011ac:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011ae:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8011b3:	eb 05                	jmp    8011ba <vprintfmt+0x4f9>
  8011b5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8011ba:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011be:	48 83 e8 01          	sub    $0x1,%rax
  8011c2:	0f b6 00             	movzbl (%rax),%eax
  8011c5:	3c 25                	cmp    $0x25,%al
  8011c7:	75 ec                	jne    8011b5 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8011c9:	90                   	nop
		}
	}
  8011ca:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011cb:	e9 43 fb ff ff       	jmpq   800d13 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8011d0:	48 83 c4 60          	add    $0x60,%rsp
  8011d4:	5b                   	pop    %rbx
  8011d5:	41 5c                	pop    %r12
  8011d7:	5d                   	pop    %rbp
  8011d8:	c3                   	retq   

00000000008011d9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011d9:	55                   	push   %rbp
  8011da:	48 89 e5             	mov    %rsp,%rbp
  8011dd:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8011e4:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8011eb:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8011f2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011f9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801200:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801207:	84 c0                	test   %al,%al
  801209:	74 20                	je     80122b <printfmt+0x52>
  80120b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80120f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801213:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801217:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80121b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80121f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801223:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801227:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80122b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801232:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801239:	00 00 00 
  80123c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801243:	00 00 00 
  801246:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80124a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801251:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801258:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80125f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801266:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80126d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801274:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80127b:	48 89 c7             	mov    %rax,%rdi
  80127e:	48 b8 c1 0c 80 00 00 	movabs $0x800cc1,%rax
  801285:	00 00 00 
  801288:	ff d0                	callq  *%rax
	va_end(ap);
}
  80128a:	c9                   	leaveq 
  80128b:	c3                   	retq   

000000000080128c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80128c:	55                   	push   %rbp
  80128d:	48 89 e5             	mov    %rsp,%rbp
  801290:	48 83 ec 10          	sub    $0x10,%rsp
  801294:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801297:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80129b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129f:	8b 40 10             	mov    0x10(%rax),%eax
  8012a2:	8d 50 01             	lea    0x1(%rax),%edx
  8012a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8012ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b0:	48 8b 10             	mov    (%rax),%rdx
  8012b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8012bb:	48 39 c2             	cmp    %rax,%rdx
  8012be:	73 17                	jae    8012d7 <sprintputch+0x4b>
		*b->buf++ = ch;
  8012c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c4:	48 8b 00             	mov    (%rax),%rax
  8012c7:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8012cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8012cf:	48 89 0a             	mov    %rcx,(%rdx)
  8012d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8012d5:	88 10                	mov    %dl,(%rax)
}
  8012d7:	c9                   	leaveq 
  8012d8:	c3                   	retq   

00000000008012d9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012d9:	55                   	push   %rbp
  8012da:	48 89 e5             	mov    %rsp,%rbp
  8012dd:	48 83 ec 50          	sub    $0x50,%rsp
  8012e1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8012e5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8012e8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8012ec:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8012f0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8012f4:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8012f8:	48 8b 0a             	mov    (%rdx),%rcx
  8012fb:	48 89 08             	mov    %rcx,(%rax)
  8012fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801302:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801306:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80130a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80130e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801312:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801316:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801319:	48 98                	cltq   
  80131b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80131f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801323:	48 01 d0             	add    %rdx,%rax
  801326:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80132a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801331:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801336:	74 06                	je     80133e <vsnprintf+0x65>
  801338:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80133c:	7f 07                	jg     801345 <vsnprintf+0x6c>
		return -E_INVAL;
  80133e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801343:	eb 2f                	jmp    801374 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801345:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801349:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80134d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801351:	48 89 c6             	mov    %rax,%rsi
  801354:	48 bf 8c 12 80 00 00 	movabs $0x80128c,%rdi
  80135b:	00 00 00 
  80135e:	48 b8 c1 0c 80 00 00 	movabs $0x800cc1,%rax
  801365:	00 00 00 
  801368:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80136a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80136e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801371:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801374:	c9                   	leaveq 
  801375:	c3                   	retq   

0000000000801376 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801376:	55                   	push   %rbp
  801377:	48 89 e5             	mov    %rsp,%rbp
  80137a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801381:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801388:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80138e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801395:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80139c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8013a3:	84 c0                	test   %al,%al
  8013a5:	74 20                	je     8013c7 <snprintf+0x51>
  8013a7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8013ab:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8013af:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8013b3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8013b7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8013bb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8013bf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8013c3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8013c7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8013ce:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8013d5:	00 00 00 
  8013d8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8013df:	00 00 00 
  8013e2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8013e6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8013ed:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8013f4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8013fb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801402:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801409:	48 8b 0a             	mov    (%rdx),%rcx
  80140c:	48 89 08             	mov    %rcx,(%rax)
  80140f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801413:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801417:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80141b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80141f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801426:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80142d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801433:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80143a:	48 89 c7             	mov    %rax,%rdi
  80143d:	48 b8 d9 12 80 00 00 	movabs $0x8012d9,%rax
  801444:	00 00 00 
  801447:	ff d0                	callq  *%rax
  801449:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80144f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801455:	c9                   	leaveq 
  801456:	c3                   	retq   

0000000000801457 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801457:	55                   	push   %rbp
  801458:	48 89 e5             	mov    %rsp,%rbp
  80145b:	48 83 ec 18          	sub    $0x18,%rsp
  80145f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801463:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80146a:	eb 09                	jmp    801475 <strlen+0x1e>
		n++;
  80146c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801470:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801479:	0f b6 00             	movzbl (%rax),%eax
  80147c:	84 c0                	test   %al,%al
  80147e:	75 ec                	jne    80146c <strlen+0x15>
		n++;
	return n;
  801480:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801483:	c9                   	leaveq 
  801484:	c3                   	retq   

0000000000801485 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801485:	55                   	push   %rbp
  801486:	48 89 e5             	mov    %rsp,%rbp
  801489:	48 83 ec 20          	sub    $0x20,%rsp
  80148d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801491:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80149c:	eb 0e                	jmp    8014ac <strnlen+0x27>
		n++;
  80149e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8014a2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014a7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8014ac:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8014b1:	74 0b                	je     8014be <strnlen+0x39>
  8014b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b7:	0f b6 00             	movzbl (%rax),%eax
  8014ba:	84 c0                	test   %al,%al
  8014bc:	75 e0                	jne    80149e <strnlen+0x19>
		n++;
	return n;
  8014be:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8014c1:	c9                   	leaveq 
  8014c2:	c3                   	retq   

00000000008014c3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014c3:	55                   	push   %rbp
  8014c4:	48 89 e5             	mov    %rsp,%rbp
  8014c7:	48 83 ec 20          	sub    $0x20,%rsp
  8014cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8014d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8014db:	90                   	nop
  8014dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014ec:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014f0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014f4:	0f b6 12             	movzbl (%rdx),%edx
  8014f7:	88 10                	mov    %dl,(%rax)
  8014f9:	0f b6 00             	movzbl (%rax),%eax
  8014fc:	84 c0                	test   %al,%al
  8014fe:	75 dc                	jne    8014dc <strcpy+0x19>
		/* do nothing */;
	return ret;
  801500:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801504:	c9                   	leaveq 
  801505:	c3                   	retq   

0000000000801506 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801506:	55                   	push   %rbp
  801507:	48 89 e5             	mov    %rsp,%rbp
  80150a:	48 83 ec 20          	sub    $0x20,%rsp
  80150e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801512:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151a:	48 89 c7             	mov    %rax,%rdi
  80151d:	48 b8 57 14 80 00 00 	movabs $0x801457,%rax
  801524:	00 00 00 
  801527:	ff d0                	callq  *%rax
  801529:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80152c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80152f:	48 63 d0             	movslq %eax,%rdx
  801532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801536:	48 01 c2             	add    %rax,%rdx
  801539:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80153d:	48 89 c6             	mov    %rax,%rsi
  801540:	48 89 d7             	mov    %rdx,%rdi
  801543:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  80154a:	00 00 00 
  80154d:	ff d0                	callq  *%rax
	return dst;
  80154f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801553:	c9                   	leaveq 
  801554:	c3                   	retq   

0000000000801555 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801555:	55                   	push   %rbp
  801556:	48 89 e5             	mov    %rsp,%rbp
  801559:	48 83 ec 28          	sub    $0x28,%rsp
  80155d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801561:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801565:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80156d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801571:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801578:	00 
  801579:	eb 2a                	jmp    8015a5 <strncpy+0x50>
		*dst++ = *src;
  80157b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80157f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801583:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801587:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80158b:	0f b6 12             	movzbl (%rdx),%edx
  80158e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801590:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801594:	0f b6 00             	movzbl (%rax),%eax
  801597:	84 c0                	test   %al,%al
  801599:	74 05                	je     8015a0 <strncpy+0x4b>
			src++;
  80159b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8015a0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8015ad:	72 cc                	jb     80157b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8015af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015b3:	c9                   	leaveq 
  8015b4:	c3                   	retq   

00000000008015b5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8015b5:	55                   	push   %rbp
  8015b6:	48 89 e5             	mov    %rsp,%rbp
  8015b9:	48 83 ec 28          	sub    $0x28,%rsp
  8015bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8015c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8015d1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015d6:	74 3d                	je     801615 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8015d8:	eb 1d                	jmp    8015f7 <strlcpy+0x42>
			*dst++ = *src++;
  8015da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015de:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8015e6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015ea:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8015ee:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8015f2:	0f b6 12             	movzbl (%rdx),%edx
  8015f5:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015f7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015fc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801601:	74 0b                	je     80160e <strlcpy+0x59>
  801603:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801607:	0f b6 00             	movzbl (%rax),%eax
  80160a:	84 c0                	test   %al,%al
  80160c:	75 cc                	jne    8015da <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80160e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801612:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801615:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801619:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161d:	48 29 c2             	sub    %rax,%rdx
  801620:	48 89 d0             	mov    %rdx,%rax
}
  801623:	c9                   	leaveq 
  801624:	c3                   	retq   

0000000000801625 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801625:	55                   	push   %rbp
  801626:	48 89 e5             	mov    %rsp,%rbp
  801629:	48 83 ec 10          	sub    $0x10,%rsp
  80162d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801631:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801635:	eb 0a                	jmp    801641 <strcmp+0x1c>
		p++, q++;
  801637:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80163c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801641:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801645:	0f b6 00             	movzbl (%rax),%eax
  801648:	84 c0                	test   %al,%al
  80164a:	74 12                	je     80165e <strcmp+0x39>
  80164c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801650:	0f b6 10             	movzbl (%rax),%edx
  801653:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801657:	0f b6 00             	movzbl (%rax),%eax
  80165a:	38 c2                	cmp    %al,%dl
  80165c:	74 d9                	je     801637 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80165e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	0f b6 d0             	movzbl %al,%edx
  801668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166c:	0f b6 00             	movzbl (%rax),%eax
  80166f:	0f b6 c0             	movzbl %al,%eax
  801672:	29 c2                	sub    %eax,%edx
  801674:	89 d0                	mov    %edx,%eax
}
  801676:	c9                   	leaveq 
  801677:	c3                   	retq   

0000000000801678 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801678:	55                   	push   %rbp
  801679:	48 89 e5             	mov    %rsp,%rbp
  80167c:	48 83 ec 18          	sub    $0x18,%rsp
  801680:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801684:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801688:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80168c:	eb 0f                	jmp    80169d <strncmp+0x25>
		n--, p++, q++;
  80168e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801693:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801698:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80169d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016a2:	74 1d                	je     8016c1 <strncmp+0x49>
  8016a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a8:	0f b6 00             	movzbl (%rax),%eax
  8016ab:	84 c0                	test   %al,%al
  8016ad:	74 12                	je     8016c1 <strncmp+0x49>
  8016af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b3:	0f b6 10             	movzbl (%rax),%edx
  8016b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ba:	0f b6 00             	movzbl (%rax),%eax
  8016bd:	38 c2                	cmp    %al,%dl
  8016bf:	74 cd                	je     80168e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8016c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016c6:	75 07                	jne    8016cf <strncmp+0x57>
		return 0;
  8016c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cd:	eb 18                	jmp    8016e7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d3:	0f b6 00             	movzbl (%rax),%eax
  8016d6:	0f b6 d0             	movzbl %al,%edx
  8016d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016dd:	0f b6 00             	movzbl (%rax),%eax
  8016e0:	0f b6 c0             	movzbl %al,%eax
  8016e3:	29 c2                	sub    %eax,%edx
  8016e5:	89 d0                	mov    %edx,%eax
}
  8016e7:	c9                   	leaveq 
  8016e8:	c3                   	retq   

00000000008016e9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8016e9:	55                   	push   %rbp
  8016ea:	48 89 e5             	mov    %rsp,%rbp
  8016ed:	48 83 ec 0c          	sub    $0xc,%rsp
  8016f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016f5:	89 f0                	mov    %esi,%eax
  8016f7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016fa:	eb 17                	jmp    801713 <strchr+0x2a>
		if (*s == c)
  8016fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801700:	0f b6 00             	movzbl (%rax),%eax
  801703:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801706:	75 06                	jne    80170e <strchr+0x25>
			return (char *) s;
  801708:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80170c:	eb 15                	jmp    801723 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80170e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801713:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801717:	0f b6 00             	movzbl (%rax),%eax
  80171a:	84 c0                	test   %al,%al
  80171c:	75 de                	jne    8016fc <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801723:	c9                   	leaveq 
  801724:	c3                   	retq   

0000000000801725 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801725:	55                   	push   %rbp
  801726:	48 89 e5             	mov    %rsp,%rbp
  801729:	48 83 ec 0c          	sub    $0xc,%rsp
  80172d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801731:	89 f0                	mov    %esi,%eax
  801733:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801736:	eb 13                	jmp    80174b <strfind+0x26>
		if (*s == c)
  801738:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80173c:	0f b6 00             	movzbl (%rax),%eax
  80173f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801742:	75 02                	jne    801746 <strfind+0x21>
			break;
  801744:	eb 10                	jmp    801756 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801746:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80174b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80174f:	0f b6 00             	movzbl (%rax),%eax
  801752:	84 c0                	test   %al,%al
  801754:	75 e2                	jne    801738 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801756:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80175a:	c9                   	leaveq 
  80175b:	c3                   	retq   

000000000080175c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80175c:	55                   	push   %rbp
  80175d:	48 89 e5             	mov    %rsp,%rbp
  801760:	48 83 ec 18          	sub    $0x18,%rsp
  801764:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801768:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80176b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80176f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801774:	75 06                	jne    80177c <memset+0x20>
		return v;
  801776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80177a:	eb 69                	jmp    8017e5 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80177c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801780:	83 e0 03             	and    $0x3,%eax
  801783:	48 85 c0             	test   %rax,%rax
  801786:	75 48                	jne    8017d0 <memset+0x74>
  801788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80178c:	83 e0 03             	and    $0x3,%eax
  80178f:	48 85 c0             	test   %rax,%rax
  801792:	75 3c                	jne    8017d0 <memset+0x74>
		c &= 0xFF;
  801794:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80179b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80179e:	c1 e0 18             	shl    $0x18,%eax
  8017a1:	89 c2                	mov    %eax,%edx
  8017a3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017a6:	c1 e0 10             	shl    $0x10,%eax
  8017a9:	09 c2                	or     %eax,%edx
  8017ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017ae:	c1 e0 08             	shl    $0x8,%eax
  8017b1:	09 d0                	or     %edx,%eax
  8017b3:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8017b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ba:	48 c1 e8 02          	shr    $0x2,%rax
  8017be:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8017c1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017c8:	48 89 d7             	mov    %rdx,%rdi
  8017cb:	fc                   	cld    
  8017cc:	f3 ab                	rep stos %eax,%es:(%rdi)
  8017ce:	eb 11                	jmp    8017e1 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017d7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8017db:	48 89 d7             	mov    %rdx,%rdi
  8017de:	fc                   	cld    
  8017df:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8017e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017e5:	c9                   	leaveq 
  8017e6:	c3                   	retq   

00000000008017e7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017e7:	55                   	push   %rbp
  8017e8:	48 89 e5             	mov    %rsp,%rbp
  8017eb:	48 83 ec 28          	sub    $0x28,%rsp
  8017ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8017fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801803:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801807:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80180b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80180f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801813:	0f 83 88 00 00 00    	jae    8018a1 <memmove+0xba>
  801819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801821:	48 01 d0             	add    %rdx,%rax
  801824:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801828:	76 77                	jbe    8018a1 <memmove+0xba>
		s += n;
  80182a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801836:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80183a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183e:	83 e0 03             	and    $0x3,%eax
  801841:	48 85 c0             	test   %rax,%rax
  801844:	75 3b                	jne    801881 <memmove+0x9a>
  801846:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80184a:	83 e0 03             	and    $0x3,%eax
  80184d:	48 85 c0             	test   %rax,%rax
  801850:	75 2f                	jne    801881 <memmove+0x9a>
  801852:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801856:	83 e0 03             	and    $0x3,%eax
  801859:	48 85 c0             	test   %rax,%rax
  80185c:	75 23                	jne    801881 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80185e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801862:	48 83 e8 04          	sub    $0x4,%rax
  801866:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80186a:	48 83 ea 04          	sub    $0x4,%rdx
  80186e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801872:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801876:	48 89 c7             	mov    %rax,%rdi
  801879:	48 89 d6             	mov    %rdx,%rsi
  80187c:	fd                   	std    
  80187d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80187f:	eb 1d                	jmp    80189e <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801881:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801885:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801889:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80188d:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801891:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801895:	48 89 d7             	mov    %rdx,%rdi
  801898:	48 89 c1             	mov    %rax,%rcx
  80189b:	fd                   	std    
  80189c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80189e:	fc                   	cld    
  80189f:	eb 57                	jmp    8018f8 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8018a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018a5:	83 e0 03             	and    $0x3,%eax
  8018a8:	48 85 c0             	test   %rax,%rax
  8018ab:	75 36                	jne    8018e3 <memmove+0xfc>
  8018ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b1:	83 e0 03             	and    $0x3,%eax
  8018b4:	48 85 c0             	test   %rax,%rax
  8018b7:	75 2a                	jne    8018e3 <memmove+0xfc>
  8018b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bd:	83 e0 03             	and    $0x3,%eax
  8018c0:	48 85 c0             	test   %rax,%rax
  8018c3:	75 1e                	jne    8018e3 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c9:	48 c1 e8 02          	shr    $0x2,%rax
  8018cd:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8018d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018d8:	48 89 c7             	mov    %rax,%rdi
  8018db:	48 89 d6             	mov    %rdx,%rsi
  8018de:	fc                   	cld    
  8018df:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018e1:	eb 15                	jmp    8018f8 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8018e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018eb:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018ef:	48 89 c7             	mov    %rax,%rdi
  8018f2:	48 89 d6             	mov    %rdx,%rsi
  8018f5:	fc                   	cld    
  8018f6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8018f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018fc:	c9                   	leaveq 
  8018fd:	c3                   	retq   

00000000008018fe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018fe:	55                   	push   %rbp
  8018ff:	48 89 e5             	mov    %rsp,%rbp
  801902:	48 83 ec 18          	sub    $0x18,%rsp
  801906:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80190a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80190e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801912:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801916:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80191a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80191e:	48 89 ce             	mov    %rcx,%rsi
  801921:	48 89 c7             	mov    %rax,%rdi
  801924:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  80192b:	00 00 00 
  80192e:	ff d0                	callq  *%rax
}
  801930:	c9                   	leaveq 
  801931:	c3                   	retq   

0000000000801932 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801932:	55                   	push   %rbp
  801933:	48 89 e5             	mov    %rsp,%rbp
  801936:	48 83 ec 28          	sub    $0x28,%rsp
  80193a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80193e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801942:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801946:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80194a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80194e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801952:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801956:	eb 36                	jmp    80198e <memcmp+0x5c>
		if (*s1 != *s2)
  801958:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80195c:	0f b6 10             	movzbl (%rax),%edx
  80195f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801963:	0f b6 00             	movzbl (%rax),%eax
  801966:	38 c2                	cmp    %al,%dl
  801968:	74 1a                	je     801984 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80196a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80196e:	0f b6 00             	movzbl (%rax),%eax
  801971:	0f b6 d0             	movzbl %al,%edx
  801974:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801978:	0f b6 00             	movzbl (%rax),%eax
  80197b:	0f b6 c0             	movzbl %al,%eax
  80197e:	29 c2                	sub    %eax,%edx
  801980:	89 d0                	mov    %edx,%eax
  801982:	eb 20                	jmp    8019a4 <memcmp+0x72>
		s1++, s2++;
  801984:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801989:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80198e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801992:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801996:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80199a:	48 85 c0             	test   %rax,%rax
  80199d:	75 b9                	jne    801958 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80199f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a4:	c9                   	leaveq 
  8019a5:	c3                   	retq   

00000000008019a6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8019a6:	55                   	push   %rbp
  8019a7:	48 89 e5             	mov    %rsp,%rbp
  8019aa:	48 83 ec 28          	sub    $0x28,%rsp
  8019ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019b2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8019b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8019b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019c1:	48 01 d0             	add    %rdx,%rax
  8019c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8019c8:	eb 15                	jmp    8019df <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8019ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ce:	0f b6 10             	movzbl (%rax),%edx
  8019d1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019d4:	38 c2                	cmp    %al,%dl
  8019d6:	75 02                	jne    8019da <memfind+0x34>
			break;
  8019d8:	eb 0f                	jmp    8019e9 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019da:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8019df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8019e7:	72 e1                	jb     8019ca <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8019e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019ed:	c9                   	leaveq 
  8019ee:	c3                   	retq   

00000000008019ef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019ef:	55                   	push   %rbp
  8019f0:	48 89 e5             	mov    %rsp,%rbp
  8019f3:	48 83 ec 34          	sub    $0x34,%rsp
  8019f7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019fb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019ff:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801a02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801a09:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801a10:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a11:	eb 05                	jmp    801a18 <strtol+0x29>
		s++;
  801a13:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1c:	0f b6 00             	movzbl (%rax),%eax
  801a1f:	3c 20                	cmp    $0x20,%al
  801a21:	74 f0                	je     801a13 <strtol+0x24>
  801a23:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a27:	0f b6 00             	movzbl (%rax),%eax
  801a2a:	3c 09                	cmp    $0x9,%al
  801a2c:	74 e5                	je     801a13 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a32:	0f b6 00             	movzbl (%rax),%eax
  801a35:	3c 2b                	cmp    $0x2b,%al
  801a37:	75 07                	jne    801a40 <strtol+0x51>
		s++;
  801a39:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a3e:	eb 17                	jmp    801a57 <strtol+0x68>
	else if (*s == '-')
  801a40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a44:	0f b6 00             	movzbl (%rax),%eax
  801a47:	3c 2d                	cmp    $0x2d,%al
  801a49:	75 0c                	jne    801a57 <strtol+0x68>
		s++, neg = 1;
  801a4b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a50:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a57:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a5b:	74 06                	je     801a63 <strtol+0x74>
  801a5d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801a61:	75 28                	jne    801a8b <strtol+0x9c>
  801a63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a67:	0f b6 00             	movzbl (%rax),%eax
  801a6a:	3c 30                	cmp    $0x30,%al
  801a6c:	75 1d                	jne    801a8b <strtol+0x9c>
  801a6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a72:	48 83 c0 01          	add    $0x1,%rax
  801a76:	0f b6 00             	movzbl (%rax),%eax
  801a79:	3c 78                	cmp    $0x78,%al
  801a7b:	75 0e                	jne    801a8b <strtol+0x9c>
		s += 2, base = 16;
  801a7d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a82:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a89:	eb 2c                	jmp    801ab7 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a8b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a8f:	75 19                	jne    801aaa <strtol+0xbb>
  801a91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a95:	0f b6 00             	movzbl (%rax),%eax
  801a98:	3c 30                	cmp    $0x30,%al
  801a9a:	75 0e                	jne    801aaa <strtol+0xbb>
		s++, base = 8;
  801a9c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801aa1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801aa8:	eb 0d                	jmp    801ab7 <strtol+0xc8>
	else if (base == 0)
  801aaa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801aae:	75 07                	jne    801ab7 <strtol+0xc8>
		base = 10;
  801ab0:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ab7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abb:	0f b6 00             	movzbl (%rax),%eax
  801abe:	3c 2f                	cmp    $0x2f,%al
  801ac0:	7e 1d                	jle    801adf <strtol+0xf0>
  801ac2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac6:	0f b6 00             	movzbl (%rax),%eax
  801ac9:	3c 39                	cmp    $0x39,%al
  801acb:	7f 12                	jg     801adf <strtol+0xf0>
			dig = *s - '0';
  801acd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad1:	0f b6 00             	movzbl (%rax),%eax
  801ad4:	0f be c0             	movsbl %al,%eax
  801ad7:	83 e8 30             	sub    $0x30,%eax
  801ada:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801add:	eb 4e                	jmp    801b2d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801adf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae3:	0f b6 00             	movzbl (%rax),%eax
  801ae6:	3c 60                	cmp    $0x60,%al
  801ae8:	7e 1d                	jle    801b07 <strtol+0x118>
  801aea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aee:	0f b6 00             	movzbl (%rax),%eax
  801af1:	3c 7a                	cmp    $0x7a,%al
  801af3:	7f 12                	jg     801b07 <strtol+0x118>
			dig = *s - 'a' + 10;
  801af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af9:	0f b6 00             	movzbl (%rax),%eax
  801afc:	0f be c0             	movsbl %al,%eax
  801aff:	83 e8 57             	sub    $0x57,%eax
  801b02:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801b05:	eb 26                	jmp    801b2d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801b07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b0b:	0f b6 00             	movzbl (%rax),%eax
  801b0e:	3c 40                	cmp    $0x40,%al
  801b10:	7e 48                	jle    801b5a <strtol+0x16b>
  801b12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b16:	0f b6 00             	movzbl (%rax),%eax
  801b19:	3c 5a                	cmp    $0x5a,%al
  801b1b:	7f 3d                	jg     801b5a <strtol+0x16b>
			dig = *s - 'A' + 10;
  801b1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b21:	0f b6 00             	movzbl (%rax),%eax
  801b24:	0f be c0             	movsbl %al,%eax
  801b27:	83 e8 37             	sub    $0x37,%eax
  801b2a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801b2d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b30:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801b33:	7c 02                	jl     801b37 <strtol+0x148>
			break;
  801b35:	eb 23                	jmp    801b5a <strtol+0x16b>
		s++, val = (val * base) + dig;
  801b37:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b3c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801b3f:	48 98                	cltq   
  801b41:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801b46:	48 89 c2             	mov    %rax,%rdx
  801b49:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b4c:	48 98                	cltq   
  801b4e:	48 01 d0             	add    %rdx,%rax
  801b51:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801b55:	e9 5d ff ff ff       	jmpq   801ab7 <strtol+0xc8>

	if (endptr)
  801b5a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801b5f:	74 0b                	je     801b6c <strtol+0x17d>
		*endptr = (char *) s;
  801b61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b65:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b69:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801b6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b70:	74 09                	je     801b7b <strtol+0x18c>
  801b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b76:	48 f7 d8             	neg    %rax
  801b79:	eb 04                	jmp    801b7f <strtol+0x190>
  801b7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b7f:	c9                   	leaveq 
  801b80:	c3                   	retq   

0000000000801b81 <strstr>:

char * strstr(const char *in, const char *str)
{
  801b81:	55                   	push   %rbp
  801b82:	48 89 e5             	mov    %rsp,%rbp
  801b85:	48 83 ec 30          	sub    $0x30,%rsp
  801b89:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b8d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b95:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b99:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b9d:	0f b6 00             	movzbl (%rax),%eax
  801ba0:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801ba3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801ba7:	75 06                	jne    801baf <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801ba9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bad:	eb 6b                	jmp    801c1a <strstr+0x99>

	len = strlen(str);
  801baf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bb3:	48 89 c7             	mov    %rax,%rdi
  801bb6:	48 b8 57 14 80 00 00 	movabs $0x801457,%rax
  801bbd:	00 00 00 
  801bc0:	ff d0                	callq  *%rax
  801bc2:	48 98                	cltq   
  801bc4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801bc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bcc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801bd0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801bd4:	0f b6 00             	movzbl (%rax),%eax
  801bd7:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801bda:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801bde:	75 07                	jne    801be7 <strstr+0x66>
				return (char *) 0;
  801be0:	b8 00 00 00 00       	mov    $0x0,%eax
  801be5:	eb 33                	jmp    801c1a <strstr+0x99>
		} while (sc != c);
  801be7:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801beb:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801bee:	75 d8                	jne    801bc8 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801bf0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801bf8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bfc:	48 89 ce             	mov    %rcx,%rsi
  801bff:	48 89 c7             	mov    %rax,%rdi
  801c02:	48 b8 78 16 80 00 00 	movabs $0x801678,%rax
  801c09:	00 00 00 
  801c0c:	ff d0                	callq  *%rax
  801c0e:	85 c0                	test   %eax,%eax
  801c10:	75 b6                	jne    801bc8 <strstr+0x47>

	return (char *) (in - 1);
  801c12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c16:	48 83 e8 01          	sub    $0x1,%rax
}
  801c1a:	c9                   	leaveq 
  801c1b:	c3                   	retq   

0000000000801c1c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801c1c:	55                   	push   %rbp
  801c1d:	48 89 e5             	mov    %rsp,%rbp
  801c20:	53                   	push   %rbx
  801c21:	48 83 ec 48          	sub    $0x48,%rsp
  801c25:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c28:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801c2b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c2f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c33:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801c37:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c3b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c3e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801c42:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801c46:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801c4a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801c4e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801c52:	4c 89 c3             	mov    %r8,%rbx
  801c55:	cd 30                	int    $0x30
  801c57:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801c5b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c5f:	74 3e                	je     801c9f <syscall+0x83>
  801c61:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c66:	7e 37                	jle    801c9f <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c68:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c6c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c6f:	49 89 d0             	mov    %rdx,%r8
  801c72:	89 c1                	mov    %eax,%ecx
  801c74:	48 ba 88 52 80 00 00 	movabs $0x805288,%rdx
  801c7b:	00 00 00 
  801c7e:	be 23 00 00 00       	mov    $0x23,%esi
  801c83:	48 bf a5 52 80 00 00 	movabs $0x8052a5,%rdi
  801c8a:	00 00 00 
  801c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c92:	49 b9 d5 06 80 00 00 	movabs $0x8006d5,%r9
  801c99:	00 00 00 
  801c9c:	41 ff d1             	callq  *%r9

	return ret;
  801c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ca3:	48 83 c4 48          	add    $0x48,%rsp
  801ca7:	5b                   	pop    %rbx
  801ca8:	5d                   	pop    %rbp
  801ca9:	c3                   	retq   

0000000000801caa <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801caa:	55                   	push   %rbp
  801cab:	48 89 e5             	mov    %rsp,%rbp
  801cae:	48 83 ec 20          	sub    $0x20,%rsp
  801cb2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cb6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801cba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc9:	00 
  801cca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd6:	48 89 d1             	mov    %rdx,%rcx
  801cd9:	48 89 c2             	mov    %rax,%rdx
  801cdc:	be 00 00 00 00       	mov    $0x0,%esi
  801ce1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ce6:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801ced:	00 00 00 
  801cf0:	ff d0                	callq  *%rax
}
  801cf2:	c9                   	leaveq 
  801cf3:	c3                   	retq   

0000000000801cf4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cf4:	55                   	push   %rbp
  801cf5:	48 89 e5             	mov    %rsp,%rbp
  801cf8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801cfc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d03:	00 
  801d04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d10:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d15:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1a:	be 00 00 00 00       	mov    $0x0,%esi
  801d1f:	bf 01 00 00 00       	mov    $0x1,%edi
  801d24:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801d2b:	00 00 00 
  801d2e:	ff d0                	callq  *%rax
}
  801d30:	c9                   	leaveq 
  801d31:	c3                   	retq   

0000000000801d32 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801d32:	55                   	push   %rbp
  801d33:	48 89 e5             	mov    %rsp,%rbp
  801d36:	48 83 ec 10          	sub    $0x10,%rsp
  801d3a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801d3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d40:	48 98                	cltq   
  801d42:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d49:	00 
  801d4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d56:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d5b:	48 89 c2             	mov    %rax,%rdx
  801d5e:	be 01 00 00 00       	mov    $0x1,%esi
  801d63:	bf 03 00 00 00       	mov    $0x3,%edi
  801d68:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801d6f:	00 00 00 
  801d72:	ff d0                	callq  *%rax
}
  801d74:	c9                   	leaveq 
  801d75:	c3                   	retq   

0000000000801d76 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d76:	55                   	push   %rbp
  801d77:	48 89 e5             	mov    %rsp,%rbp
  801d7a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d85:	00 
  801d86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d92:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d97:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9c:	be 00 00 00 00       	mov    $0x0,%esi
  801da1:	bf 02 00 00 00       	mov    $0x2,%edi
  801da6:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801dad:	00 00 00 
  801db0:	ff d0                	callq  *%rax
}
  801db2:	c9                   	leaveq 
  801db3:	c3                   	retq   

0000000000801db4 <sys_yield>:

void
sys_yield(void)
{
  801db4:	55                   	push   %rbp
  801db5:	48 89 e5             	mov    %rsp,%rbp
  801db8:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801dbc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dc3:	00 
  801dc4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dd5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dda:	be 00 00 00 00       	mov    $0x0,%esi
  801ddf:	bf 0b 00 00 00       	mov    $0xb,%edi
  801de4:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801deb:	00 00 00 
  801dee:	ff d0                	callq  *%rax
}
  801df0:	c9                   	leaveq 
  801df1:	c3                   	retq   

0000000000801df2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801df2:	55                   	push   %rbp
  801df3:	48 89 e5             	mov    %rsp,%rbp
  801df6:	48 83 ec 20          	sub    $0x20,%rsp
  801dfa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dfd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e01:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801e04:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e07:	48 63 c8             	movslq %eax,%rcx
  801e0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e11:	48 98                	cltq   
  801e13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e1a:	00 
  801e1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e21:	49 89 c8             	mov    %rcx,%r8
  801e24:	48 89 d1             	mov    %rdx,%rcx
  801e27:	48 89 c2             	mov    %rax,%rdx
  801e2a:	be 01 00 00 00       	mov    $0x1,%esi
  801e2f:	bf 04 00 00 00       	mov    $0x4,%edi
  801e34:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
}
  801e40:	c9                   	leaveq 
  801e41:	c3                   	retq   

0000000000801e42 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801e42:	55                   	push   %rbp
  801e43:	48 89 e5             	mov    %rsp,%rbp
  801e46:	48 83 ec 30          	sub    $0x30,%rsp
  801e4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e51:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e54:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e58:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801e5c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e5f:	48 63 c8             	movslq %eax,%rcx
  801e62:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e66:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e69:	48 63 f0             	movslq %eax,%rsi
  801e6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e73:	48 98                	cltq   
  801e75:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e79:	49 89 f9             	mov    %rdi,%r9
  801e7c:	49 89 f0             	mov    %rsi,%r8
  801e7f:	48 89 d1             	mov    %rdx,%rcx
  801e82:	48 89 c2             	mov    %rax,%rdx
  801e85:	be 01 00 00 00       	mov    $0x1,%esi
  801e8a:	bf 05 00 00 00       	mov    $0x5,%edi
  801e8f:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801e96:	00 00 00 
  801e99:	ff d0                	callq  *%rax
}
  801e9b:	c9                   	leaveq 
  801e9c:	c3                   	retq   

0000000000801e9d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e9d:	55                   	push   %rbp
  801e9e:	48 89 e5             	mov    %rsp,%rbp
  801ea1:	48 83 ec 20          	sub    $0x20,%rsp
  801ea5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ea8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801eac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb3:	48 98                	cltq   
  801eb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ebc:	00 
  801ebd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ec3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ec9:	48 89 d1             	mov    %rdx,%rcx
  801ecc:	48 89 c2             	mov    %rax,%rdx
  801ecf:	be 01 00 00 00       	mov    $0x1,%esi
  801ed4:	bf 06 00 00 00       	mov    $0x6,%edi
  801ed9:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801ee0:	00 00 00 
  801ee3:	ff d0                	callq  *%rax
}
  801ee5:	c9                   	leaveq 
  801ee6:	c3                   	retq   

0000000000801ee7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ee7:	55                   	push   %rbp
  801ee8:	48 89 e5             	mov    %rsp,%rbp
  801eeb:	48 83 ec 10          	sub    $0x10,%rsp
  801eef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ef2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ef5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ef8:	48 63 d0             	movslq %eax,%rdx
  801efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801efe:	48 98                	cltq   
  801f00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f07:	00 
  801f08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f14:	48 89 d1             	mov    %rdx,%rcx
  801f17:	48 89 c2             	mov    %rax,%rdx
  801f1a:	be 01 00 00 00       	mov    $0x1,%esi
  801f1f:	bf 08 00 00 00       	mov    $0x8,%edi
  801f24:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801f2b:	00 00 00 
  801f2e:	ff d0                	callq  *%rax
}
  801f30:	c9                   	leaveq 
  801f31:	c3                   	retq   

0000000000801f32 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801f32:	55                   	push   %rbp
  801f33:	48 89 e5             	mov    %rsp,%rbp
  801f36:	48 83 ec 20          	sub    $0x20,%rsp
  801f3a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801f41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f48:	48 98                	cltq   
  801f4a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f51:	00 
  801f52:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f58:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f5e:	48 89 d1             	mov    %rdx,%rcx
  801f61:	48 89 c2             	mov    %rax,%rdx
  801f64:	be 01 00 00 00       	mov    $0x1,%esi
  801f69:	bf 09 00 00 00       	mov    $0x9,%edi
  801f6e:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801f75:	00 00 00 
  801f78:	ff d0                	callq  *%rax
}
  801f7a:	c9                   	leaveq 
  801f7b:	c3                   	retq   

0000000000801f7c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f7c:	55                   	push   %rbp
  801f7d:	48 89 e5             	mov    %rsp,%rbp
  801f80:	48 83 ec 20          	sub    $0x20,%rsp
  801f84:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f92:	48 98                	cltq   
  801f94:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f9b:	00 
  801f9c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fa2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa8:	48 89 d1             	mov    %rdx,%rcx
  801fab:	48 89 c2             	mov    %rax,%rdx
  801fae:	be 01 00 00 00       	mov    $0x1,%esi
  801fb3:	bf 0a 00 00 00       	mov    $0xa,%edi
  801fb8:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  801fbf:	00 00 00 
  801fc2:	ff d0                	callq  *%rax
}
  801fc4:	c9                   	leaveq 
  801fc5:	c3                   	retq   

0000000000801fc6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801fc6:	55                   	push   %rbp
  801fc7:	48 89 e5             	mov    %rsp,%rbp
  801fca:	48 83 ec 20          	sub    $0x20,%rsp
  801fce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fd1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fd5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801fd9:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801fdc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fdf:	48 63 f0             	movslq %eax,%rsi
  801fe2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801fe6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe9:	48 98                	cltq   
  801feb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ff6:	00 
  801ff7:	49 89 f1             	mov    %rsi,%r9
  801ffa:	49 89 c8             	mov    %rcx,%r8
  801ffd:	48 89 d1             	mov    %rdx,%rcx
  802000:	48 89 c2             	mov    %rax,%rdx
  802003:	be 00 00 00 00       	mov    $0x0,%esi
  802008:	bf 0c 00 00 00       	mov    $0xc,%edi
  80200d:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  802014:	00 00 00 
  802017:	ff d0                	callq  *%rax
}
  802019:	c9                   	leaveq 
  80201a:	c3                   	retq   

000000000080201b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80201b:	55                   	push   %rbp
  80201c:	48 89 e5             	mov    %rsp,%rbp
  80201f:	48 83 ec 10          	sub    $0x10,%rsp
  802023:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802027:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80202b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802032:	00 
  802033:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802039:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80203f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802044:	48 89 c2             	mov    %rax,%rdx
  802047:	be 01 00 00 00       	mov    $0x1,%esi
  80204c:	bf 0d 00 00 00       	mov    $0xd,%edi
  802051:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  802058:	00 00 00 
  80205b:	ff d0                	callq  *%rax
}
  80205d:	c9                   	leaveq 
  80205e:	c3                   	retq   

000000000080205f <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  80205f:	55                   	push   %rbp
  802060:	48 89 e5             	mov    %rsp,%rbp
  802063:	48 83 ec 20          	sub    $0x20,%rsp
  802067:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80206b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  80206f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802073:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802077:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80207e:	00 
  80207f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802085:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80208b:	48 89 d1             	mov    %rdx,%rcx
  80208e:	48 89 c2             	mov    %rax,%rdx
  802091:	be 01 00 00 00       	mov    $0x1,%esi
  802096:	bf 0f 00 00 00       	mov    $0xf,%edi
  80209b:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  8020a2:	00 00 00 
  8020a5:	ff d0                	callq  *%rax
}
  8020a7:	c9                   	leaveq 
  8020a8:	c3                   	retq   

00000000008020a9 <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  8020a9:	55                   	push   %rbp
  8020aa:	48 89 e5             	mov    %rsp,%rbp
  8020ad:	48 83 ec 10          	sub    $0x10,%rsp
  8020b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  8020b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020b9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020c0:	00 
  8020c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020d2:	48 89 c2             	mov    %rax,%rdx
  8020d5:	be 00 00 00 00       	mov    $0x0,%esi
  8020da:	bf 10 00 00 00       	mov    $0x10,%edi
  8020df:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  8020e6:	00 00 00 
  8020e9:	ff d0                	callq  *%rax
}
  8020eb:	c9                   	leaveq 
  8020ec:	c3                   	retq   

00000000008020ed <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8020ed:	55                   	push   %rbp
  8020ee:	48 89 e5             	mov    %rsp,%rbp
  8020f1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8020f5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020fc:	00 
  8020fd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802103:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802109:	b9 00 00 00 00       	mov    $0x0,%ecx
  80210e:	ba 00 00 00 00       	mov    $0x0,%edx
  802113:	be 00 00 00 00       	mov    $0x0,%esi
  802118:	bf 0e 00 00 00       	mov    $0xe,%edi
  80211d:	48 b8 1c 1c 80 00 00 	movabs $0x801c1c,%rax
  802124:	00 00 00 
  802127:	ff d0                	callq  *%rax
}
  802129:	c9                   	leaveq 
  80212a:	c3                   	retq   

000000000080212b <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
  80212f:	48 83 ec 30          	sub    $0x30,%rsp
  802133:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802137:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80213b:	48 8b 00             	mov    (%rax),%rax
  80213e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802142:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802146:	48 8b 40 08          	mov    0x8(%rax),%rax
  80214a:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  80214d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802150:	83 e0 02             	and    $0x2,%eax
  802153:	85 c0                	test   %eax,%eax
  802155:	75 4d                	jne    8021a4 <pgfault+0x79>
  802157:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80215b:	48 c1 e8 0c          	shr    $0xc,%rax
  80215f:	48 89 c2             	mov    %rax,%rdx
  802162:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802169:	01 00 00 
  80216c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802170:	25 00 08 00 00       	and    $0x800,%eax
  802175:	48 85 c0             	test   %rax,%rax
  802178:	74 2a                	je     8021a4 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  80217a:	48 ba b8 52 80 00 00 	movabs $0x8052b8,%rdx
  802181:	00 00 00 
  802184:	be 23 00 00 00       	mov    $0x23,%esi
  802189:	48 bf ed 52 80 00 00 	movabs $0x8052ed,%rdi
  802190:	00 00 00 
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	48 b9 d5 06 80 00 00 	movabs $0x8006d5,%rcx
  80219f:	00 00 00 
  8021a2:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  8021a4:	ba 07 00 00 00       	mov    $0x7,%edx
  8021a9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b3:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  8021ba:	00 00 00 
  8021bd:	ff d0                	callq  *%rax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	0f 85 cd 00 00 00    	jne    802294 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  8021c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021cb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8021cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8021d9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  8021dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021e1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021e6:	48 89 c6             	mov    %rax,%rsi
  8021e9:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8021ee:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  8021f5:	00 00 00 
  8021f8:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  8021fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021fe:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802204:	48 89 c1             	mov    %rax,%rcx
  802207:	ba 00 00 00 00       	mov    $0x0,%edx
  80220c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802211:	bf 00 00 00 00       	mov    $0x0,%edi
  802216:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  80221d:	00 00 00 
  802220:	ff d0                	callq  *%rax
  802222:	85 c0                	test   %eax,%eax
  802224:	79 2a                	jns    802250 <pgfault+0x125>
				panic("Page map at temp address failed");
  802226:	48 ba f8 52 80 00 00 	movabs $0x8052f8,%rdx
  80222d:	00 00 00 
  802230:	be 30 00 00 00       	mov    $0x30,%esi
  802235:	48 bf ed 52 80 00 00 	movabs $0x8052ed,%rdi
  80223c:	00 00 00 
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
  802244:	48 b9 d5 06 80 00 00 	movabs $0x8006d5,%rcx
  80224b:	00 00 00 
  80224e:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  802250:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802255:	bf 00 00 00 00       	mov    $0x0,%edi
  80225a:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  802261:	00 00 00 
  802264:	ff d0                	callq  *%rax
  802266:	85 c0                	test   %eax,%eax
  802268:	79 54                	jns    8022be <pgfault+0x193>
				panic("Page unmap from temp location failed");
  80226a:	48 ba 18 53 80 00 00 	movabs $0x805318,%rdx
  802271:	00 00 00 
  802274:	be 32 00 00 00       	mov    $0x32,%esi
  802279:	48 bf ed 52 80 00 00 	movabs $0x8052ed,%rdi
  802280:	00 00 00 
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
  802288:	48 b9 d5 06 80 00 00 	movabs $0x8006d5,%rcx
  80228f:	00 00 00 
  802292:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  802294:	48 ba 40 53 80 00 00 	movabs $0x805340,%rdx
  80229b:	00 00 00 
  80229e:	be 34 00 00 00       	mov    $0x34,%esi
  8022a3:	48 bf ed 52 80 00 00 	movabs $0x8052ed,%rdi
  8022aa:	00 00 00 
  8022ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b2:	48 b9 d5 06 80 00 00 	movabs $0x8006d5,%rcx
  8022b9:	00 00 00 
  8022bc:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  8022be:	c9                   	leaveq 
  8022bf:	c3                   	retq   

00000000008022c0 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8022c0:	55                   	push   %rbp
  8022c1:	48 89 e5             	mov    %rsp,%rbp
  8022c4:	48 83 ec 20          	sub    $0x20,%rsp
  8022c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022cb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  8022ce:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022d5:	01 00 00 
  8022d8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8022db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022df:	25 07 0e 00 00       	and    $0xe07,%eax
  8022e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  8022e7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022ea:	48 c1 e0 0c          	shl    $0xc,%rax
  8022ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  8022f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f5:	25 00 04 00 00       	and    $0x400,%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	74 57                	je     802355 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8022fe:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802301:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802305:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802308:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80230c:	41 89 f0             	mov    %esi,%r8d
  80230f:	48 89 c6             	mov    %rax,%rsi
  802312:	bf 00 00 00 00       	mov    $0x0,%edi
  802317:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  80231e:	00 00 00 
  802321:	ff d0                	callq  *%rax
  802323:	85 c0                	test   %eax,%eax
  802325:	0f 8e 52 01 00 00    	jle    80247d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  80232b:	48 ba 72 53 80 00 00 	movabs $0x805372,%rdx
  802332:	00 00 00 
  802335:	be 4e 00 00 00       	mov    $0x4e,%esi
  80233a:	48 bf ed 52 80 00 00 	movabs $0x8052ed,%rdi
  802341:	00 00 00 
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
  802349:	48 b9 d5 06 80 00 00 	movabs $0x8006d5,%rcx
  802350:	00 00 00 
  802353:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  802355:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802358:	83 e0 02             	and    $0x2,%eax
  80235b:	85 c0                	test   %eax,%eax
  80235d:	75 10                	jne    80236f <duppage+0xaf>
  80235f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802362:	25 00 08 00 00       	and    $0x800,%eax
  802367:	85 c0                	test   %eax,%eax
  802369:	0f 84 bb 00 00 00    	je     80242a <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  80236f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802372:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  802377:	80 cc 08             	or     $0x8,%ah
  80237a:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80237d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802380:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802384:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802387:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80238b:	41 89 f0             	mov    %esi,%r8d
  80238e:	48 89 c6             	mov    %rax,%rsi
  802391:	bf 00 00 00 00       	mov    $0x0,%edi
  802396:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	7e 2a                	jle    8023d0 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  8023a6:	48 ba 72 53 80 00 00 	movabs $0x805372,%rdx
  8023ad:	00 00 00 
  8023b0:	be 55 00 00 00       	mov    $0x55,%esi
  8023b5:	48 bf ed 52 80 00 00 	movabs $0x8052ed,%rdi
  8023bc:	00 00 00 
  8023bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c4:	48 b9 d5 06 80 00 00 	movabs $0x8006d5,%rcx
  8023cb:	00 00 00 
  8023ce:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8023d0:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8023d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023db:	41 89 c8             	mov    %ecx,%r8d
  8023de:	48 89 d1             	mov    %rdx,%rcx
  8023e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e6:	48 89 c6             	mov    %rax,%rsi
  8023e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ee:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  8023f5:	00 00 00 
  8023f8:	ff d0                	callq  *%rax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	7e 2a                	jle    802428 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  8023fe:	48 ba 72 53 80 00 00 	movabs $0x805372,%rdx
  802405:	00 00 00 
  802408:	be 57 00 00 00       	mov    $0x57,%esi
  80240d:	48 bf ed 52 80 00 00 	movabs $0x8052ed,%rdi
  802414:	00 00 00 
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
  80241c:	48 b9 d5 06 80 00 00 	movabs $0x8006d5,%rcx
  802423:	00 00 00 
  802426:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802428:	eb 53                	jmp    80247d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80242a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80242d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802431:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802438:	41 89 f0             	mov    %esi,%r8d
  80243b:	48 89 c6             	mov    %rax,%rsi
  80243e:	bf 00 00 00 00       	mov    $0x0,%edi
  802443:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  80244a:	00 00 00 
  80244d:	ff d0                	callq  *%rax
  80244f:	85 c0                	test   %eax,%eax
  802451:	7e 2a                	jle    80247d <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  802453:	48 ba 72 53 80 00 00 	movabs $0x805372,%rdx
  80245a:	00 00 00 
  80245d:	be 5b 00 00 00       	mov    $0x5b,%esi
  802462:	48 bf ed 52 80 00 00 	movabs $0x8052ed,%rdi
  802469:	00 00 00 
  80246c:	b8 00 00 00 00       	mov    $0x0,%eax
  802471:	48 b9 d5 06 80 00 00 	movabs $0x8006d5,%rcx
  802478:	00 00 00 
  80247b:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  80247d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802482:	c9                   	leaveq 
  802483:	c3                   	retq   

0000000000802484 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802484:	55                   	push   %rbp
  802485:	48 89 e5             	mov    %rsp,%rbp
  802488:	48 83 ec 18          	sub    $0x18,%rsp
  80248c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802490:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802494:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802498:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80249c:	48 c1 e8 27          	shr    $0x27,%rax
  8024a0:	48 89 c2             	mov    %rax,%rdx
  8024a3:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8024aa:	01 00 00 
  8024ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024b1:	83 e0 01             	and    $0x1,%eax
  8024b4:	48 85 c0             	test   %rax,%rax
  8024b7:	74 51                	je     80250a <pt_is_mapped+0x86>
  8024b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024bd:	48 c1 e0 0c          	shl    $0xc,%rax
  8024c1:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024c5:	48 89 c2             	mov    %rax,%rdx
  8024c8:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8024cf:	01 00 00 
  8024d2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d6:	83 e0 01             	and    $0x1,%eax
  8024d9:	48 85 c0             	test   %rax,%rax
  8024dc:	74 2c                	je     80250a <pt_is_mapped+0x86>
  8024de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e2:	48 c1 e0 0c          	shl    $0xc,%rax
  8024e6:	48 c1 e8 15          	shr    $0x15,%rax
  8024ea:	48 89 c2             	mov    %rax,%rdx
  8024ed:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024f4:	01 00 00 
  8024f7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fb:	83 e0 01             	and    $0x1,%eax
  8024fe:	48 85 c0             	test   %rax,%rax
  802501:	74 07                	je     80250a <pt_is_mapped+0x86>
  802503:	b8 01 00 00 00       	mov    $0x1,%eax
  802508:	eb 05                	jmp    80250f <pt_is_mapped+0x8b>
  80250a:	b8 00 00 00 00       	mov    $0x0,%eax
  80250f:	83 e0 01             	and    $0x1,%eax
}
  802512:	c9                   	leaveq 
  802513:	c3                   	retq   

0000000000802514 <fork>:

envid_t
fork(void)
{
  802514:	55                   	push   %rbp
  802515:	48 89 e5             	mov    %rsp,%rbp
  802518:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80251c:	48 bf 2b 21 80 00 00 	movabs $0x80212b,%rdi
  802523:	00 00 00 
  802526:	48 b8 3b 4a 80 00 00 	movabs $0x804a3b,%rax
  80252d:	00 00 00 
  802530:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802532:	b8 07 00 00 00       	mov    $0x7,%eax
  802537:	cd 30                	int    $0x30
  802539:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80253c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  80253f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  802542:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802546:	79 30                	jns    802578 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  802548:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80254b:	89 c1                	mov    %eax,%ecx
  80254d:	48 ba 90 53 80 00 00 	movabs $0x805390,%rdx
  802554:	00 00 00 
  802557:	be 86 00 00 00       	mov    $0x86,%esi
  80255c:	48 bf ed 52 80 00 00 	movabs $0x8052ed,%rdi
  802563:	00 00 00 
  802566:	b8 00 00 00 00       	mov    $0x0,%eax
  80256b:	49 b8 d5 06 80 00 00 	movabs $0x8006d5,%r8
  802572:	00 00 00 
  802575:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  802578:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80257c:	75 46                	jne    8025c4 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  80257e:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  802585:	00 00 00 
  802588:	ff d0                	callq  *%rax
  80258a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80258f:	48 63 d0             	movslq %eax,%rdx
  802592:	48 89 d0             	mov    %rdx,%rax
  802595:	48 c1 e0 03          	shl    $0x3,%rax
  802599:	48 01 d0             	add    %rdx,%rax
  80259c:	48 c1 e0 05          	shl    $0x5,%rax
  8025a0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8025a7:	00 00 00 
  8025aa:	48 01 c2             	add    %rax,%rdx
  8025ad:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8025b4:	00 00 00 
  8025b7:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8025ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bf:	e9 d1 01 00 00       	jmpq   802795 <fork+0x281>
	}
	uint64_t ad = 0;
  8025c4:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8025cb:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8025cc:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8025d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8025d5:	e9 df 00 00 00       	jmpq   8026b9 <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  8025da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025de:	48 c1 e8 27          	shr    $0x27,%rax
  8025e2:	48 89 c2             	mov    %rax,%rdx
  8025e5:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8025ec:	01 00 00 
  8025ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f3:	83 e0 01             	and    $0x1,%eax
  8025f6:	48 85 c0             	test   %rax,%rax
  8025f9:	0f 84 9e 00 00 00    	je     80269d <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  8025ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802603:	48 c1 e8 1e          	shr    $0x1e,%rax
  802607:	48 89 c2             	mov    %rax,%rdx
  80260a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802611:	01 00 00 
  802614:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802618:	83 e0 01             	and    $0x1,%eax
  80261b:	48 85 c0             	test   %rax,%rax
  80261e:	74 73                	je     802693 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802620:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802624:	48 c1 e8 15          	shr    $0x15,%rax
  802628:	48 89 c2             	mov    %rax,%rdx
  80262b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802632:	01 00 00 
  802635:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802639:	83 e0 01             	and    $0x1,%eax
  80263c:	48 85 c0             	test   %rax,%rax
  80263f:	74 48                	je     802689 <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802641:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802645:	48 c1 e8 0c          	shr    $0xc,%rax
  802649:	48 89 c2             	mov    %rax,%rdx
  80264c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802653:	01 00 00 
  802656:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80265a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80265e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802662:	83 e0 01             	and    $0x1,%eax
  802665:	48 85 c0             	test   %rax,%rax
  802668:	74 47                	je     8026b1 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  80266a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80266e:	48 c1 e8 0c          	shr    $0xc,%rax
  802672:	89 c2                	mov    %eax,%edx
  802674:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802677:	89 d6                	mov    %edx,%esi
  802679:	89 c7                	mov    %eax,%edi
  80267b:	48 b8 c0 22 80 00 00 	movabs $0x8022c0,%rax
  802682:	00 00 00 
  802685:	ff d0                	callq  *%rax
  802687:	eb 28                	jmp    8026b1 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802689:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802690:	00 
  802691:	eb 1e                	jmp    8026b1 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802693:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  80269a:	40 
  80269b:	eb 14                	jmp    8026b1 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  80269d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026a1:	48 c1 e8 27          	shr    $0x27,%rax
  8026a5:	48 83 c0 01          	add    $0x1,%rax
  8026a9:	48 c1 e0 27          	shl    $0x27,%rax
  8026ad:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  8026b1:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8026b8:	00 
  8026b9:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  8026c0:	00 
  8026c1:	0f 87 13 ff ff ff    	ja     8025da <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8026c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8026ca:	ba 07 00 00 00       	mov    $0x7,%edx
  8026cf:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8026d4:	89 c7                	mov    %eax,%edi
  8026d6:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  8026dd:	00 00 00 
  8026e0:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  8026e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8026e5:	ba 07 00 00 00       	mov    $0x7,%edx
  8026ea:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  8026ef:	89 c7                	mov    %eax,%edi
  8026f1:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  8026f8:	00 00 00 
  8026fb:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  8026fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802700:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802706:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  80270b:	ba 00 00 00 00       	mov    $0x0,%edx
  802710:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802715:	89 c7                	mov    %eax,%edi
  802717:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  80271e:	00 00 00 
  802721:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802723:	ba 00 10 00 00       	mov    $0x1000,%edx
  802728:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  80272d:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802732:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  802739:	00 00 00 
  80273c:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  80273e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802743:	bf 00 00 00 00       	mov    $0x0,%edi
  802748:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  80274f:	00 00 00 
  802752:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802754:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80275b:	00 00 00 
  80275e:	48 8b 00             	mov    (%rax),%rax
  802761:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802768:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80276b:	48 89 d6             	mov    %rdx,%rsi
  80276e:	89 c7                	mov    %eax,%edi
  802770:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802777:	00 00 00 
  80277a:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  80277c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80277f:	be 02 00 00 00       	mov    $0x2,%esi
  802784:	89 c7                	mov    %eax,%edi
  802786:	48 b8 e7 1e 80 00 00 	movabs $0x801ee7,%rax
  80278d:	00 00 00 
  802790:	ff d0                	callq  *%rax

	return envid;
  802792:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802795:	c9                   	leaveq 
  802796:	c3                   	retq   

0000000000802797 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802797:	55                   	push   %rbp
  802798:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80279b:	48 ba a8 53 80 00 00 	movabs $0x8053a8,%rdx
  8027a2:	00 00 00 
  8027a5:	be bf 00 00 00       	mov    $0xbf,%esi
  8027aa:	48 bf ed 52 80 00 00 	movabs $0x8052ed,%rdi
  8027b1:	00 00 00 
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b9:	48 b9 d5 06 80 00 00 	movabs $0x8006d5,%rcx
  8027c0:	00 00 00 
  8027c3:	ff d1                	callq  *%rcx

00000000008027c5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027c5:	55                   	push   %rbp
  8027c6:	48 89 e5             	mov    %rsp,%rbp
  8027c9:	48 83 ec 30          	sub    $0x30,%rsp
  8027cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  8027d9:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8027e0:	00 00 00 
  8027e3:	48 8b 00             	mov    (%rax),%rax
  8027e6:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	75 3c                	jne    80282c <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  8027f0:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  8027f7:	00 00 00 
  8027fa:	ff d0                	callq  *%rax
  8027fc:	25 ff 03 00 00       	and    $0x3ff,%eax
  802801:	48 63 d0             	movslq %eax,%rdx
  802804:	48 89 d0             	mov    %rdx,%rax
  802807:	48 c1 e0 03          	shl    $0x3,%rax
  80280b:	48 01 d0             	add    %rdx,%rax
  80280e:	48 c1 e0 05          	shl    $0x5,%rax
  802812:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802819:	00 00 00 
  80281c:	48 01 c2             	add    %rax,%rdx
  80281f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802826:	00 00 00 
  802829:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  80282c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802831:	75 0e                	jne    802841 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  802833:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80283a:	00 00 00 
  80283d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  802841:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802845:	48 89 c7             	mov    %rax,%rdi
  802848:	48 b8 1b 20 80 00 00 	movabs $0x80201b,%rax
  80284f:	00 00 00 
  802852:	ff d0                	callq  *%rax
  802854:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802857:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285b:	79 19                	jns    802876 <ipc_recv+0xb1>
		*from_env_store = 0;
  80285d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802861:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80286b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  802871:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802874:	eb 53                	jmp    8028c9 <ipc_recv+0x104>
	}
	if(from_env_store)
  802876:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80287b:	74 19                	je     802896 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  80287d:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802884:	00 00 00 
  802887:	48 8b 00             	mov    (%rax),%rax
  80288a:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802894:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802896:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80289b:	74 19                	je     8028b6 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  80289d:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8028a4:	00 00 00 
  8028a7:	48 8b 00             	mov    (%rax),%rax
  8028aa:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8028b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b4:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  8028b6:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8028bd:	00 00 00 
  8028c0:	48 8b 00             	mov    (%rax),%rax
  8028c3:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  8028c9:	c9                   	leaveq 
  8028ca:	c3                   	retq   

00000000008028cb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028cb:	55                   	push   %rbp
  8028cc:	48 89 e5             	mov    %rsp,%rbp
  8028cf:	48 83 ec 30          	sub    $0x30,%rsp
  8028d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028d6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8028d9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8028dd:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  8028e0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028e5:	75 0e                	jne    8028f5 <ipc_send+0x2a>
		pg = (void*)UTOP;
  8028e7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8028ee:	00 00 00 
  8028f1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  8028f5:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8028f8:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8028fb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802902:	89 c7                	mov    %eax,%edi
  802904:	48 b8 c6 1f 80 00 00 	movabs $0x801fc6,%rax
  80290b:	00 00 00 
  80290e:	ff d0                	callq  *%rax
  802910:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  802913:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802917:	75 0c                	jne    802925 <ipc_send+0x5a>
			sys_yield();
  802919:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  802920:	00 00 00 
  802923:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802925:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802929:	74 ca                	je     8028f5 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  80292b:	c9                   	leaveq 
  80292c:	c3                   	retq   

000000000080292d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80292d:	55                   	push   %rbp
  80292e:	48 89 e5             	mov    %rsp,%rbp
  802931:	48 83 ec 14          	sub    $0x14,%rsp
  802935:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802938:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80293f:	eb 5e                	jmp    80299f <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802941:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802948:	00 00 00 
  80294b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294e:	48 63 d0             	movslq %eax,%rdx
  802951:	48 89 d0             	mov    %rdx,%rax
  802954:	48 c1 e0 03          	shl    $0x3,%rax
  802958:	48 01 d0             	add    %rdx,%rax
  80295b:	48 c1 e0 05          	shl    $0x5,%rax
  80295f:	48 01 c8             	add    %rcx,%rax
  802962:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802968:	8b 00                	mov    (%rax),%eax
  80296a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80296d:	75 2c                	jne    80299b <ipc_find_env+0x6e>
			return envs[i].env_id;
  80296f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802976:	00 00 00 
  802979:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297c:	48 63 d0             	movslq %eax,%rdx
  80297f:	48 89 d0             	mov    %rdx,%rax
  802982:	48 c1 e0 03          	shl    $0x3,%rax
  802986:	48 01 d0             	add    %rdx,%rax
  802989:	48 c1 e0 05          	shl    $0x5,%rax
  80298d:	48 01 c8             	add    %rcx,%rax
  802990:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802996:	8b 40 08             	mov    0x8(%rax),%eax
  802999:	eb 12                	jmp    8029ad <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80299b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80299f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8029a6:	7e 99                	jle    802941 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8029a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ad:	c9                   	leaveq 
  8029ae:	c3                   	retq   

00000000008029af <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8029af:	55                   	push   %rbp
  8029b0:	48 89 e5             	mov    %rsp,%rbp
  8029b3:	48 83 ec 08          	sub    $0x8,%rsp
  8029b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8029bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8029bf:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8029c6:	ff ff ff 
  8029c9:	48 01 d0             	add    %rdx,%rax
  8029cc:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8029d0:	c9                   	leaveq 
  8029d1:	c3                   	retq   

00000000008029d2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8029d2:	55                   	push   %rbp
  8029d3:	48 89 e5             	mov    %rsp,%rbp
  8029d6:	48 83 ec 08          	sub    $0x8,%rsp
  8029da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8029de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029e2:	48 89 c7             	mov    %rax,%rdi
  8029e5:	48 b8 af 29 80 00 00 	movabs $0x8029af,%rax
  8029ec:	00 00 00 
  8029ef:	ff d0                	callq  *%rax
  8029f1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8029f7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8029fb:	c9                   	leaveq 
  8029fc:	c3                   	retq   

00000000008029fd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8029fd:	55                   	push   %rbp
  8029fe:	48 89 e5             	mov    %rsp,%rbp
  802a01:	48 83 ec 18          	sub    $0x18,%rsp
  802a05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a10:	eb 6b                	jmp    802a7d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802a12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a15:	48 98                	cltq   
  802a17:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a1d:	48 c1 e0 0c          	shl    $0xc,%rax
  802a21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802a25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a29:	48 c1 e8 15          	shr    $0x15,%rax
  802a2d:	48 89 c2             	mov    %rax,%rdx
  802a30:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a37:	01 00 00 
  802a3a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a3e:	83 e0 01             	and    $0x1,%eax
  802a41:	48 85 c0             	test   %rax,%rax
  802a44:	74 21                	je     802a67 <fd_alloc+0x6a>
  802a46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4a:	48 c1 e8 0c          	shr    $0xc,%rax
  802a4e:	48 89 c2             	mov    %rax,%rdx
  802a51:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a58:	01 00 00 
  802a5b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a5f:	83 e0 01             	and    $0x1,%eax
  802a62:	48 85 c0             	test   %rax,%rax
  802a65:	75 12                	jne    802a79 <fd_alloc+0x7c>
			*fd_store = fd;
  802a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a6f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a72:	b8 00 00 00 00       	mov    $0x0,%eax
  802a77:	eb 1a                	jmp    802a93 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a79:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a7d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a81:	7e 8f                	jle    802a12 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a87:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802a8e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802a93:	c9                   	leaveq 
  802a94:	c3                   	retq   

0000000000802a95 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802a95:	55                   	push   %rbp
  802a96:	48 89 e5             	mov    %rsp,%rbp
  802a99:	48 83 ec 20          	sub    $0x20,%rsp
  802a9d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802aa0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802aa4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802aa8:	78 06                	js     802ab0 <fd_lookup+0x1b>
  802aaa:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802aae:	7e 07                	jle    802ab7 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802ab0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ab5:	eb 6c                	jmp    802b23 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802ab7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aba:	48 98                	cltq   
  802abc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802ac2:	48 c1 e0 0c          	shl    $0xc,%rax
  802ac6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802aca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ace:	48 c1 e8 15          	shr    $0x15,%rax
  802ad2:	48 89 c2             	mov    %rax,%rdx
  802ad5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802adc:	01 00 00 
  802adf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ae3:	83 e0 01             	and    $0x1,%eax
  802ae6:	48 85 c0             	test   %rax,%rax
  802ae9:	74 21                	je     802b0c <fd_lookup+0x77>
  802aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aef:	48 c1 e8 0c          	shr    $0xc,%rax
  802af3:	48 89 c2             	mov    %rax,%rdx
  802af6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802afd:	01 00 00 
  802b00:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b04:	83 e0 01             	and    $0x1,%eax
  802b07:	48 85 c0             	test   %rax,%rax
  802b0a:	75 07                	jne    802b13 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b11:	eb 10                	jmp    802b23 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802b13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b17:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b1b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802b1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b23:	c9                   	leaveq 
  802b24:	c3                   	retq   

0000000000802b25 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802b25:	55                   	push   %rbp
  802b26:	48 89 e5             	mov    %rsp,%rbp
  802b29:	48 83 ec 30          	sub    $0x30,%rsp
  802b2d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b31:	89 f0                	mov    %esi,%eax
  802b33:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b3a:	48 89 c7             	mov    %rax,%rdi
  802b3d:	48 b8 af 29 80 00 00 	movabs $0x8029af,%rax
  802b44:	00 00 00 
  802b47:	ff d0                	callq  *%rax
  802b49:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b4d:	48 89 d6             	mov    %rdx,%rsi
  802b50:	89 c7                	mov    %eax,%edi
  802b52:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  802b59:	00 00 00 
  802b5c:	ff d0                	callq  *%rax
  802b5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b65:	78 0a                	js     802b71 <fd_close+0x4c>
	    || fd != fd2)
  802b67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802b6f:	74 12                	je     802b83 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802b71:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802b75:	74 05                	je     802b7c <fd_close+0x57>
  802b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7a:	eb 05                	jmp    802b81 <fd_close+0x5c>
  802b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b81:	eb 69                	jmp    802bec <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802b83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b87:	8b 00                	mov    (%rax),%eax
  802b89:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b8d:	48 89 d6             	mov    %rdx,%rsi
  802b90:	89 c7                	mov    %eax,%edi
  802b92:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
  802b9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba5:	78 2a                	js     802bd1 <fd_close+0xac>
		if (dev->dev_close)
  802ba7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bab:	48 8b 40 20          	mov    0x20(%rax),%rax
  802baf:	48 85 c0             	test   %rax,%rax
  802bb2:	74 16                	je     802bca <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802bb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb8:	48 8b 40 20          	mov    0x20(%rax),%rax
  802bbc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bc0:	48 89 d7             	mov    %rdx,%rdi
  802bc3:	ff d0                	callq  *%rax
  802bc5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc8:	eb 07                	jmp    802bd1 <fd_close+0xac>
		else
			r = 0;
  802bca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802bd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bd5:	48 89 c6             	mov    %rax,%rsi
  802bd8:	bf 00 00 00 00       	mov    $0x0,%edi
  802bdd:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  802be4:	00 00 00 
  802be7:	ff d0                	callq  *%rax
	return r;
  802be9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bec:	c9                   	leaveq 
  802bed:	c3                   	retq   

0000000000802bee <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802bee:	55                   	push   %rbp
  802bef:	48 89 e5             	mov    %rsp,%rbp
  802bf2:	48 83 ec 20          	sub    $0x20,%rsp
  802bf6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bf9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802bfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c04:	eb 41                	jmp    802c47 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802c06:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802c0d:	00 00 00 
  802c10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c13:	48 63 d2             	movslq %edx,%rdx
  802c16:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c1a:	8b 00                	mov    (%rax),%eax
  802c1c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802c1f:	75 22                	jne    802c43 <dev_lookup+0x55>
			*dev = devtab[i];
  802c21:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802c28:	00 00 00 
  802c2b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c2e:	48 63 d2             	movslq %edx,%rdx
  802c31:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802c35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c39:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c41:	eb 60                	jmp    802ca3 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802c43:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c47:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802c4e:	00 00 00 
  802c51:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c54:	48 63 d2             	movslq %edx,%rdx
  802c57:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c5b:	48 85 c0             	test   %rax,%rax
  802c5e:	75 a6                	jne    802c06 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802c60:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802c67:	00 00 00 
  802c6a:	48 8b 00             	mov    (%rax),%rax
  802c6d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c73:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c76:	89 c6                	mov    %eax,%esi
  802c78:	48 bf c0 53 80 00 00 	movabs $0x8053c0,%rdi
  802c7f:	00 00 00 
  802c82:	b8 00 00 00 00       	mov    $0x0,%eax
  802c87:	48 b9 0e 09 80 00 00 	movabs $0x80090e,%rcx
  802c8e:	00 00 00 
  802c91:	ff d1                	callq  *%rcx
	*dev = 0;
  802c93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c97:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802c9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ca3:	c9                   	leaveq 
  802ca4:	c3                   	retq   

0000000000802ca5 <close>:

int
close(int fdnum)
{
  802ca5:	55                   	push   %rbp
  802ca6:	48 89 e5             	mov    %rsp,%rbp
  802ca9:	48 83 ec 20          	sub    $0x20,%rsp
  802cad:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cb0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cb4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cb7:	48 89 d6             	mov    %rdx,%rsi
  802cba:	89 c7                	mov    %eax,%edi
  802cbc:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  802cc3:	00 00 00 
  802cc6:	ff d0                	callq  *%rax
  802cc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ccb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ccf:	79 05                	jns    802cd6 <close+0x31>
		return r;
  802cd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd4:	eb 18                	jmp    802cee <close+0x49>
	else
		return fd_close(fd, 1);
  802cd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cda:	be 01 00 00 00       	mov    $0x1,%esi
  802cdf:	48 89 c7             	mov    %rax,%rdi
  802ce2:	48 b8 25 2b 80 00 00 	movabs $0x802b25,%rax
  802ce9:	00 00 00 
  802cec:	ff d0                	callq  *%rax
}
  802cee:	c9                   	leaveq 
  802cef:	c3                   	retq   

0000000000802cf0 <close_all>:

void
close_all(void)
{
  802cf0:	55                   	push   %rbp
  802cf1:	48 89 e5             	mov    %rsp,%rbp
  802cf4:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802cf8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cff:	eb 15                	jmp    802d16 <close_all+0x26>
		close(i);
  802d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d04:	89 c7                	mov    %eax,%edi
  802d06:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  802d0d:	00 00 00 
  802d10:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802d12:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d16:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802d1a:	7e e5                	jle    802d01 <close_all+0x11>
		close(i);
}
  802d1c:	c9                   	leaveq 
  802d1d:	c3                   	retq   

0000000000802d1e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802d1e:	55                   	push   %rbp
  802d1f:	48 89 e5             	mov    %rsp,%rbp
  802d22:	48 83 ec 40          	sub    $0x40,%rsp
  802d26:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802d29:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802d2c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802d30:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802d33:	48 89 d6             	mov    %rdx,%rsi
  802d36:	89 c7                	mov    %eax,%edi
  802d38:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  802d3f:	00 00 00 
  802d42:	ff d0                	callq  *%rax
  802d44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d4b:	79 08                	jns    802d55 <dup+0x37>
		return r;
  802d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d50:	e9 70 01 00 00       	jmpq   802ec5 <dup+0x1a7>
	close(newfdnum);
  802d55:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d58:	89 c7                	mov    %eax,%edi
  802d5a:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  802d61:	00 00 00 
  802d64:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802d66:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802d69:	48 98                	cltq   
  802d6b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802d71:	48 c1 e0 0c          	shl    $0xc,%rax
  802d75:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802d79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d7d:	48 89 c7             	mov    %rax,%rdi
  802d80:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	callq  *%rax
  802d8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802d90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d94:	48 89 c7             	mov    %rax,%rdi
  802d97:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  802d9e:	00 00 00 
  802da1:	ff d0                	callq  *%rax
  802da3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802da7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dab:	48 c1 e8 15          	shr    $0x15,%rax
  802daf:	48 89 c2             	mov    %rax,%rdx
  802db2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802db9:	01 00 00 
  802dbc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dc0:	83 e0 01             	and    $0x1,%eax
  802dc3:	48 85 c0             	test   %rax,%rax
  802dc6:	74 73                	je     802e3b <dup+0x11d>
  802dc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dcc:	48 c1 e8 0c          	shr    $0xc,%rax
  802dd0:	48 89 c2             	mov    %rax,%rdx
  802dd3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802dda:	01 00 00 
  802ddd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802de1:	83 e0 01             	and    $0x1,%eax
  802de4:	48 85 c0             	test   %rax,%rax
  802de7:	74 52                	je     802e3b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802de9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ded:	48 c1 e8 0c          	shr    $0xc,%rax
  802df1:	48 89 c2             	mov    %rax,%rdx
  802df4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802dfb:	01 00 00 
  802dfe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e02:	25 07 0e 00 00       	and    $0xe07,%eax
  802e07:	89 c1                	mov    %eax,%ecx
  802e09:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e11:	41 89 c8             	mov    %ecx,%r8d
  802e14:	48 89 d1             	mov    %rdx,%rcx
  802e17:	ba 00 00 00 00       	mov    $0x0,%edx
  802e1c:	48 89 c6             	mov    %rax,%rsi
  802e1f:	bf 00 00 00 00       	mov    $0x0,%edi
  802e24:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  802e2b:	00 00 00 
  802e2e:	ff d0                	callq  *%rax
  802e30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e37:	79 02                	jns    802e3b <dup+0x11d>
			goto err;
  802e39:	eb 57                	jmp    802e92 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802e3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e3f:	48 c1 e8 0c          	shr    $0xc,%rax
  802e43:	48 89 c2             	mov    %rax,%rdx
  802e46:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e4d:	01 00 00 
  802e50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e54:	25 07 0e 00 00       	and    $0xe07,%eax
  802e59:	89 c1                	mov    %eax,%ecx
  802e5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e63:	41 89 c8             	mov    %ecx,%r8d
  802e66:	48 89 d1             	mov    %rdx,%rcx
  802e69:	ba 00 00 00 00       	mov    $0x0,%edx
  802e6e:	48 89 c6             	mov    %rax,%rsi
  802e71:	bf 00 00 00 00       	mov    $0x0,%edi
  802e76:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  802e7d:	00 00 00 
  802e80:	ff d0                	callq  *%rax
  802e82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e89:	79 02                	jns    802e8d <dup+0x16f>
		goto err;
  802e8b:	eb 05                	jmp    802e92 <dup+0x174>

	return newfdnum;
  802e8d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e90:	eb 33                	jmp    802ec5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802e92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e96:	48 89 c6             	mov    %rax,%rsi
  802e99:	bf 00 00 00 00       	mov    $0x0,%edi
  802e9e:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  802ea5:	00 00 00 
  802ea8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802eaa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eae:	48 89 c6             	mov    %rax,%rsi
  802eb1:	bf 00 00 00 00       	mov    $0x0,%edi
  802eb6:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  802ebd:	00 00 00 
  802ec0:	ff d0                	callq  *%rax
	return r;
  802ec2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ec5:	c9                   	leaveq 
  802ec6:	c3                   	retq   

0000000000802ec7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802ec7:	55                   	push   %rbp
  802ec8:	48 89 e5             	mov    %rsp,%rbp
  802ecb:	48 83 ec 40          	sub    $0x40,%rsp
  802ecf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ed2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ed6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802eda:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ede:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ee1:	48 89 d6             	mov    %rdx,%rsi
  802ee4:	89 c7                	mov    %eax,%edi
  802ee6:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  802eed:	00 00 00 
  802ef0:	ff d0                	callq  *%rax
  802ef2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef9:	78 24                	js     802f1f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802efb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eff:	8b 00                	mov    (%rax),%eax
  802f01:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f05:	48 89 d6             	mov    %rdx,%rsi
  802f08:	89 c7                	mov    %eax,%edi
  802f0a:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  802f11:	00 00 00 
  802f14:	ff d0                	callq  *%rax
  802f16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1d:	79 05                	jns    802f24 <read+0x5d>
		return r;
  802f1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f22:	eb 76                	jmp    802f9a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f28:	8b 40 08             	mov    0x8(%rax),%eax
  802f2b:	83 e0 03             	and    $0x3,%eax
  802f2e:	83 f8 01             	cmp    $0x1,%eax
  802f31:	75 3a                	jne    802f6d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802f33:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802f3a:	00 00 00 
  802f3d:	48 8b 00             	mov    (%rax),%rax
  802f40:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f46:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f49:	89 c6                	mov    %eax,%esi
  802f4b:	48 bf df 53 80 00 00 	movabs $0x8053df,%rdi
  802f52:	00 00 00 
  802f55:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5a:	48 b9 0e 09 80 00 00 	movabs $0x80090e,%rcx
  802f61:	00 00 00 
  802f64:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f66:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f6b:	eb 2d                	jmp    802f9a <read+0xd3>
	}
	if (!dev->dev_read)
  802f6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f71:	48 8b 40 10          	mov    0x10(%rax),%rax
  802f75:	48 85 c0             	test   %rax,%rax
  802f78:	75 07                	jne    802f81 <read+0xba>
		return -E_NOT_SUPP;
  802f7a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f7f:	eb 19                	jmp    802f9a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f85:	48 8b 40 10          	mov    0x10(%rax),%rax
  802f89:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f8d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f91:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f95:	48 89 cf             	mov    %rcx,%rdi
  802f98:	ff d0                	callq  *%rax
}
  802f9a:	c9                   	leaveq 
  802f9b:	c3                   	retq   

0000000000802f9c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802f9c:	55                   	push   %rbp
  802f9d:	48 89 e5             	mov    %rsp,%rbp
  802fa0:	48 83 ec 30          	sub    $0x30,%rsp
  802fa4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fa7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802faf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802fb6:	eb 49                	jmp    803001 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802fb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fbb:	48 98                	cltq   
  802fbd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fc1:	48 29 c2             	sub    %rax,%rdx
  802fc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc7:	48 63 c8             	movslq %eax,%rcx
  802fca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fce:	48 01 c1             	add    %rax,%rcx
  802fd1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fd4:	48 89 ce             	mov    %rcx,%rsi
  802fd7:	89 c7                	mov    %eax,%edi
  802fd9:	48 b8 c7 2e 80 00 00 	movabs $0x802ec7,%rax
  802fe0:	00 00 00 
  802fe3:	ff d0                	callq  *%rax
  802fe5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802fe8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802fec:	79 05                	jns    802ff3 <readn+0x57>
			return m;
  802fee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ff1:	eb 1c                	jmp    80300f <readn+0x73>
		if (m == 0)
  802ff3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ff7:	75 02                	jne    802ffb <readn+0x5f>
			break;
  802ff9:	eb 11                	jmp    80300c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ffb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ffe:	01 45 fc             	add    %eax,-0x4(%rbp)
  803001:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803004:	48 98                	cltq   
  803006:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80300a:	72 ac                	jb     802fb8 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80300c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80300f:	c9                   	leaveq 
  803010:	c3                   	retq   

0000000000803011 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803011:	55                   	push   %rbp
  803012:	48 89 e5             	mov    %rsp,%rbp
  803015:	48 83 ec 40          	sub    $0x40,%rsp
  803019:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80301c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803020:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803024:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803028:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80302b:	48 89 d6             	mov    %rdx,%rsi
  80302e:	89 c7                	mov    %eax,%edi
  803030:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  803037:	00 00 00 
  80303a:	ff d0                	callq  *%rax
  80303c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80303f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803043:	78 24                	js     803069 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803049:	8b 00                	mov    (%rax),%eax
  80304b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80304f:	48 89 d6             	mov    %rdx,%rsi
  803052:	89 c7                	mov    %eax,%edi
  803054:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  80305b:	00 00 00 
  80305e:	ff d0                	callq  *%rax
  803060:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803063:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803067:	79 05                	jns    80306e <write+0x5d>
		return r;
  803069:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306c:	eb 75                	jmp    8030e3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80306e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803072:	8b 40 08             	mov    0x8(%rax),%eax
  803075:	83 e0 03             	and    $0x3,%eax
  803078:	85 c0                	test   %eax,%eax
  80307a:	75 3a                	jne    8030b6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80307c:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803083:	00 00 00 
  803086:	48 8b 00             	mov    (%rax),%rax
  803089:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80308f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803092:	89 c6                	mov    %eax,%esi
  803094:	48 bf fb 53 80 00 00 	movabs $0x8053fb,%rdi
  80309b:	00 00 00 
  80309e:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a3:	48 b9 0e 09 80 00 00 	movabs $0x80090e,%rcx
  8030aa:	00 00 00 
  8030ad:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8030af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030b4:	eb 2d                	jmp    8030e3 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  8030b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ba:	48 8b 40 18          	mov    0x18(%rax),%rax
  8030be:	48 85 c0             	test   %rax,%rax
  8030c1:	75 07                	jne    8030ca <write+0xb9>
		return -E_NOT_SUPP;
  8030c3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030c8:	eb 19                	jmp    8030e3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8030ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ce:	48 8b 40 18          	mov    0x18(%rax),%rax
  8030d2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030d6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030da:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8030de:	48 89 cf             	mov    %rcx,%rdi
  8030e1:	ff d0                	callq  *%rax
}
  8030e3:	c9                   	leaveq 
  8030e4:	c3                   	retq   

00000000008030e5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8030e5:	55                   	push   %rbp
  8030e6:	48 89 e5             	mov    %rsp,%rbp
  8030e9:	48 83 ec 18          	sub    $0x18,%rsp
  8030ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030f0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030fa:	48 89 d6             	mov    %rdx,%rsi
  8030fd:	89 c7                	mov    %eax,%edi
  8030ff:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  803106:	00 00 00 
  803109:	ff d0                	callq  *%rax
  80310b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80310e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803112:	79 05                	jns    803119 <seek+0x34>
		return r;
  803114:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803117:	eb 0f                	jmp    803128 <seek+0x43>
	fd->fd_offset = offset;
  803119:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80311d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803120:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803123:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803128:	c9                   	leaveq 
  803129:	c3                   	retq   

000000000080312a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80312a:	55                   	push   %rbp
  80312b:	48 89 e5             	mov    %rsp,%rbp
  80312e:	48 83 ec 30          	sub    $0x30,%rsp
  803132:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803135:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803138:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80313c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80313f:	48 89 d6             	mov    %rdx,%rsi
  803142:	89 c7                	mov    %eax,%edi
  803144:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  80314b:	00 00 00 
  80314e:	ff d0                	callq  *%rax
  803150:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803153:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803157:	78 24                	js     80317d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80315d:	8b 00                	mov    (%rax),%eax
  80315f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803163:	48 89 d6             	mov    %rdx,%rsi
  803166:	89 c7                	mov    %eax,%edi
  803168:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
  803174:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803177:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80317b:	79 05                	jns    803182 <ftruncate+0x58>
		return r;
  80317d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803180:	eb 72                	jmp    8031f4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803182:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803186:	8b 40 08             	mov    0x8(%rax),%eax
  803189:	83 e0 03             	and    $0x3,%eax
  80318c:	85 c0                	test   %eax,%eax
  80318e:	75 3a                	jne    8031ca <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803190:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803197:	00 00 00 
  80319a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80319d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8031a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031a6:	89 c6                	mov    %eax,%esi
  8031a8:	48 bf 18 54 80 00 00 	movabs $0x805418,%rdi
  8031af:	00 00 00 
  8031b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b7:	48 b9 0e 09 80 00 00 	movabs $0x80090e,%rcx
  8031be:	00 00 00 
  8031c1:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8031c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031c8:	eb 2a                	jmp    8031f4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8031ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ce:	48 8b 40 30          	mov    0x30(%rax),%rax
  8031d2:	48 85 c0             	test   %rax,%rax
  8031d5:	75 07                	jne    8031de <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8031d7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031dc:	eb 16                	jmp    8031f4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8031de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031e2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8031e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8031ea:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8031ed:	89 ce                	mov    %ecx,%esi
  8031ef:	48 89 d7             	mov    %rdx,%rdi
  8031f2:	ff d0                	callq  *%rax
}
  8031f4:	c9                   	leaveq 
  8031f5:	c3                   	retq   

00000000008031f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8031f6:	55                   	push   %rbp
  8031f7:	48 89 e5             	mov    %rsp,%rbp
  8031fa:	48 83 ec 30          	sub    $0x30,%rsp
  8031fe:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803201:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803205:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803209:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80320c:	48 89 d6             	mov    %rdx,%rsi
  80320f:	89 c7                	mov    %eax,%edi
  803211:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  803218:	00 00 00 
  80321b:	ff d0                	callq  *%rax
  80321d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803220:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803224:	78 24                	js     80324a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80322a:	8b 00                	mov    (%rax),%eax
  80322c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803230:	48 89 d6             	mov    %rdx,%rsi
  803233:	89 c7                	mov    %eax,%edi
  803235:	48 b8 ee 2b 80 00 00 	movabs $0x802bee,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
  803241:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803244:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803248:	79 05                	jns    80324f <fstat+0x59>
		return r;
  80324a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324d:	eb 5e                	jmp    8032ad <fstat+0xb7>
	if (!dev->dev_stat)
  80324f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803253:	48 8b 40 28          	mov    0x28(%rax),%rax
  803257:	48 85 c0             	test   %rax,%rax
  80325a:	75 07                	jne    803263 <fstat+0x6d>
		return -E_NOT_SUPP;
  80325c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803261:	eb 4a                	jmp    8032ad <fstat+0xb7>
	stat->st_name[0] = 0;
  803263:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803267:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80326a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80326e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803275:	00 00 00 
	stat->st_isdir = 0;
  803278:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80327c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803283:	00 00 00 
	stat->st_dev = dev;
  803286:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80328a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80328e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803299:	48 8b 40 28          	mov    0x28(%rax),%rax
  80329d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032a1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8032a5:	48 89 ce             	mov    %rcx,%rsi
  8032a8:	48 89 d7             	mov    %rdx,%rdi
  8032ab:	ff d0                	callq  *%rax
}
  8032ad:	c9                   	leaveq 
  8032ae:	c3                   	retq   

00000000008032af <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8032af:	55                   	push   %rbp
  8032b0:	48 89 e5             	mov    %rsp,%rbp
  8032b3:	48 83 ec 20          	sub    $0x20,%rsp
  8032b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8032bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032c3:	be 00 00 00 00       	mov    $0x0,%esi
  8032c8:	48 89 c7             	mov    %rax,%rdi
  8032cb:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  8032d2:	00 00 00 
  8032d5:	ff d0                	callq  *%rax
  8032d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032de:	79 05                	jns    8032e5 <stat+0x36>
		return fd;
  8032e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e3:	eb 2f                	jmp    803314 <stat+0x65>
	r = fstat(fd, stat);
  8032e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8032e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ec:	48 89 d6             	mov    %rdx,%rsi
  8032ef:	89 c7                	mov    %eax,%edi
  8032f1:	48 b8 f6 31 80 00 00 	movabs $0x8031f6,%rax
  8032f8:	00 00 00 
  8032fb:	ff d0                	callq  *%rax
  8032fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803300:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803303:	89 c7                	mov    %eax,%edi
  803305:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  80330c:	00 00 00 
  80330f:	ff d0                	callq  *%rax
	return r;
  803311:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803314:	c9                   	leaveq 
  803315:	c3                   	retq   

0000000000803316 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803316:	55                   	push   %rbp
  803317:	48 89 e5             	mov    %rsp,%rbp
  80331a:	48 83 ec 10          	sub    $0x10,%rsp
  80331e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803321:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803325:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80332c:	00 00 00 
  80332f:	8b 00                	mov    (%rax),%eax
  803331:	85 c0                	test   %eax,%eax
  803333:	75 1d                	jne    803352 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803335:	bf 01 00 00 00       	mov    $0x1,%edi
  80333a:	48 b8 2d 29 80 00 00 	movabs $0x80292d,%rax
  803341:	00 00 00 
  803344:	ff d0                	callq  *%rax
  803346:	48 ba 04 80 80 00 00 	movabs $0x808004,%rdx
  80334d:	00 00 00 
  803350:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803352:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803359:	00 00 00 
  80335c:	8b 00                	mov    (%rax),%eax
  80335e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803361:	b9 07 00 00 00       	mov    $0x7,%ecx
  803366:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80336d:	00 00 00 
  803370:	89 c7                	mov    %eax,%edi
  803372:	48 b8 cb 28 80 00 00 	movabs $0x8028cb,%rax
  803379:	00 00 00 
  80337c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80337e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803382:	ba 00 00 00 00       	mov    $0x0,%edx
  803387:	48 89 c6             	mov    %rax,%rsi
  80338a:	bf 00 00 00 00       	mov    $0x0,%edi
  80338f:	48 b8 c5 27 80 00 00 	movabs $0x8027c5,%rax
  803396:	00 00 00 
  803399:	ff d0                	callq  *%rax
}
  80339b:	c9                   	leaveq 
  80339c:	c3                   	retq   

000000000080339d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80339d:	55                   	push   %rbp
  80339e:	48 89 e5             	mov    %rsp,%rbp
  8033a1:	48 83 ec 30          	sub    $0x30,%rsp
  8033a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033a9:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  8033ac:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  8033b3:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  8033ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  8033c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8033c6:	75 08                	jne    8033d0 <open+0x33>
	{
		return r;
  8033c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033cb:	e9 f2 00 00 00       	jmpq   8034c2 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  8033d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d4:	48 89 c7             	mov    %rax,%rdi
  8033d7:	48 b8 57 14 80 00 00 	movabs $0x801457,%rax
  8033de:	00 00 00 
  8033e1:	ff d0                	callq  *%rax
  8033e3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033e6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  8033ed:	7e 0a                	jle    8033f9 <open+0x5c>
	{
		return -E_BAD_PATH;
  8033ef:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8033f4:	e9 c9 00 00 00       	jmpq   8034c2 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  8033f9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803400:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803401:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803405:	48 89 c7             	mov    %rax,%rdi
  803408:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  80340f:	00 00 00 
  803412:	ff d0                	callq  *%rax
  803414:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803417:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80341b:	78 09                	js     803426 <open+0x89>
  80341d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803421:	48 85 c0             	test   %rax,%rax
  803424:	75 08                	jne    80342e <open+0x91>
		{
			return r;
  803426:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803429:	e9 94 00 00 00       	jmpq   8034c2 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  80342e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803432:	ba 00 04 00 00       	mov    $0x400,%edx
  803437:	48 89 c6             	mov    %rax,%rsi
  80343a:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803441:	00 00 00 
  803444:	48 b8 55 15 80 00 00 	movabs $0x801555,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  803450:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803457:	00 00 00 
  80345a:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  80345d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  803463:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803467:	48 89 c6             	mov    %rax,%rsi
  80346a:	bf 01 00 00 00       	mov    $0x1,%edi
  80346f:	48 b8 16 33 80 00 00 	movabs $0x803316,%rax
  803476:	00 00 00 
  803479:	ff d0                	callq  *%rax
  80347b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80347e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803482:	79 2b                	jns    8034af <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803488:	be 00 00 00 00       	mov    $0x0,%esi
  80348d:	48 89 c7             	mov    %rax,%rdi
  803490:	48 b8 25 2b 80 00 00 	movabs $0x802b25,%rax
  803497:	00 00 00 
  80349a:	ff d0                	callq  *%rax
  80349c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80349f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034a3:	79 05                	jns    8034aa <open+0x10d>
			{
				return d;
  8034a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034a8:	eb 18                	jmp    8034c2 <open+0x125>
			}
			return r;
  8034aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ad:	eb 13                	jmp    8034c2 <open+0x125>
		}	
		return fd2num(fd_store);
  8034af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b3:	48 89 c7             	mov    %rax,%rdi
  8034b6:	48 b8 af 29 80 00 00 	movabs $0x8029af,%rax
  8034bd:	00 00 00 
  8034c0:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  8034c2:	c9                   	leaveq 
  8034c3:	c3                   	retq   

00000000008034c4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8034c4:	55                   	push   %rbp
  8034c5:	48 89 e5             	mov    %rsp,%rbp
  8034c8:	48 83 ec 10          	sub    $0x10,%rsp
  8034cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8034d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d4:	8b 50 0c             	mov    0xc(%rax),%edx
  8034d7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034de:	00 00 00 
  8034e1:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8034e3:	be 00 00 00 00       	mov    $0x0,%esi
  8034e8:	bf 06 00 00 00       	mov    $0x6,%edi
  8034ed:	48 b8 16 33 80 00 00 	movabs $0x803316,%rax
  8034f4:	00 00 00 
  8034f7:	ff d0                	callq  *%rax
}
  8034f9:	c9                   	leaveq 
  8034fa:	c3                   	retq   

00000000008034fb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8034fb:	55                   	push   %rbp
  8034fc:	48 89 e5             	mov    %rsp,%rbp
  8034ff:	48 83 ec 30          	sub    $0x30,%rsp
  803503:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803507:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80350b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  80350f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803516:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80351b:	74 07                	je     803524 <devfile_read+0x29>
  80351d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803522:	75 07                	jne    80352b <devfile_read+0x30>
		return -E_INVAL;
  803524:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803529:	eb 77                	jmp    8035a2 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80352b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352f:	8b 50 0c             	mov    0xc(%rax),%edx
  803532:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803539:	00 00 00 
  80353c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80353e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803545:	00 00 00 
  803548:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80354c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  803550:	be 00 00 00 00       	mov    $0x0,%esi
  803555:	bf 03 00 00 00       	mov    $0x3,%edi
  80355a:	48 b8 16 33 80 00 00 	movabs $0x803316,%rax
  803561:	00 00 00 
  803564:	ff d0                	callq  *%rax
  803566:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803569:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80356d:	7f 05                	jg     803574 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  80356f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803572:	eb 2e                	jmp    8035a2 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  803574:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803577:	48 63 d0             	movslq %eax,%rdx
  80357a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80357e:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803585:	00 00 00 
  803588:	48 89 c7             	mov    %rax,%rdi
  80358b:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  803592:	00 00 00 
  803595:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803597:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80359b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  80359f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8035a2:	c9                   	leaveq 
  8035a3:	c3                   	retq   

00000000008035a4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8035a4:	55                   	push   %rbp
  8035a5:	48 89 e5             	mov    %rsp,%rbp
  8035a8:	48 83 ec 30          	sub    $0x30,%rsp
  8035ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  8035b8:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  8035bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8035c4:	74 07                	je     8035cd <devfile_write+0x29>
  8035c6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8035cb:	75 08                	jne    8035d5 <devfile_write+0x31>
		return r;
  8035cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d0:	e9 9a 00 00 00       	jmpq   80366f <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8035d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d9:	8b 50 0c             	mov    0xc(%rax),%edx
  8035dc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035e3:	00 00 00 
  8035e6:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  8035e8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8035ef:	00 
  8035f0:	76 08                	jbe    8035fa <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  8035f2:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8035f9:	00 
	}
	fsipcbuf.write.req_n = n;
  8035fa:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803601:	00 00 00 
  803604:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803608:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  80360c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803610:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803614:	48 89 c6             	mov    %rax,%rsi
  803617:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80361e:	00 00 00 
  803621:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  803628:	00 00 00 
  80362b:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  80362d:	be 00 00 00 00       	mov    $0x0,%esi
  803632:	bf 04 00 00 00       	mov    $0x4,%edi
  803637:	48 b8 16 33 80 00 00 	movabs $0x803316,%rax
  80363e:	00 00 00 
  803641:	ff d0                	callq  *%rax
  803643:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803646:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80364a:	7f 20                	jg     80366c <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  80364c:	48 bf 3e 54 80 00 00 	movabs $0x80543e,%rdi
  803653:	00 00 00 
  803656:	b8 00 00 00 00       	mov    $0x0,%eax
  80365b:	48 ba 0e 09 80 00 00 	movabs $0x80090e,%rdx
  803662:	00 00 00 
  803665:	ff d2                	callq  *%rdx
		return r;
  803667:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366a:	eb 03                	jmp    80366f <devfile_write+0xcb>
	}
	return r;
  80366c:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  80366f:	c9                   	leaveq 
  803670:	c3                   	retq   

0000000000803671 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803671:	55                   	push   %rbp
  803672:	48 89 e5             	mov    %rsp,%rbp
  803675:	48 83 ec 20          	sub    $0x20,%rsp
  803679:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80367d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803681:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803685:	8b 50 0c             	mov    0xc(%rax),%edx
  803688:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80368f:	00 00 00 
  803692:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803694:	be 00 00 00 00       	mov    $0x0,%esi
  803699:	bf 05 00 00 00       	mov    $0x5,%edi
  80369e:	48 b8 16 33 80 00 00 	movabs $0x803316,%rax
  8036a5:	00 00 00 
  8036a8:	ff d0                	callq  *%rax
  8036aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b1:	79 05                	jns    8036b8 <devfile_stat+0x47>
		return r;
  8036b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b6:	eb 56                	jmp    80370e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8036b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036bc:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8036c3:	00 00 00 
  8036c6:	48 89 c7             	mov    %rax,%rdi
  8036c9:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  8036d0:	00 00 00 
  8036d3:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8036d5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036dc:	00 00 00 
  8036df:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8036e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8036ef:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036f6:	00 00 00 
  8036f9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8036ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803703:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803709:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80370e:	c9                   	leaveq 
  80370f:	c3                   	retq   

0000000000803710 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803710:	55                   	push   %rbp
  803711:	48 89 e5             	mov    %rsp,%rbp
  803714:	48 83 ec 10          	sub    $0x10,%rsp
  803718:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80371c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80371f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803723:	8b 50 0c             	mov    0xc(%rax),%edx
  803726:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80372d:	00 00 00 
  803730:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803732:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803739:	00 00 00 
  80373c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80373f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803742:	be 00 00 00 00       	mov    $0x0,%esi
  803747:	bf 02 00 00 00       	mov    $0x2,%edi
  80374c:	48 b8 16 33 80 00 00 	movabs $0x803316,%rax
  803753:	00 00 00 
  803756:	ff d0                	callq  *%rax
}
  803758:	c9                   	leaveq 
  803759:	c3                   	retq   

000000000080375a <remove>:

// Delete a file
int
remove(const char *path)
{
  80375a:	55                   	push   %rbp
  80375b:	48 89 e5             	mov    %rsp,%rbp
  80375e:	48 83 ec 10          	sub    $0x10,%rsp
  803762:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803766:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376a:	48 89 c7             	mov    %rax,%rdi
  80376d:	48 b8 57 14 80 00 00 	movabs $0x801457,%rax
  803774:	00 00 00 
  803777:	ff d0                	callq  *%rax
  803779:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80377e:	7e 07                	jle    803787 <remove+0x2d>
		return -E_BAD_PATH;
  803780:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803785:	eb 33                	jmp    8037ba <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803787:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80378b:	48 89 c6             	mov    %rax,%rsi
  80378e:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803795:	00 00 00 
  803798:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  80379f:	00 00 00 
  8037a2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8037a4:	be 00 00 00 00       	mov    $0x0,%esi
  8037a9:	bf 07 00 00 00       	mov    $0x7,%edi
  8037ae:	48 b8 16 33 80 00 00 	movabs $0x803316,%rax
  8037b5:	00 00 00 
  8037b8:	ff d0                	callq  *%rax
}
  8037ba:	c9                   	leaveq 
  8037bb:	c3                   	retq   

00000000008037bc <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8037bc:	55                   	push   %rbp
  8037bd:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8037c0:	be 00 00 00 00       	mov    $0x0,%esi
  8037c5:	bf 08 00 00 00       	mov    $0x8,%edi
  8037ca:	48 b8 16 33 80 00 00 	movabs $0x803316,%rax
  8037d1:	00 00 00 
  8037d4:	ff d0                	callq  *%rax
}
  8037d6:	5d                   	pop    %rbp
  8037d7:	c3                   	retq   

00000000008037d8 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8037d8:	55                   	push   %rbp
  8037d9:	48 89 e5             	mov    %rsp,%rbp
  8037dc:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8037e3:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8037ea:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8037f1:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8037f8:	be 00 00 00 00       	mov    $0x0,%esi
  8037fd:	48 89 c7             	mov    %rax,%rdi
  803800:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  803807:	00 00 00 
  80380a:	ff d0                	callq  *%rax
  80380c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80380f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803813:	79 28                	jns    80383d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803815:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803818:	89 c6                	mov    %eax,%esi
  80381a:	48 bf 5a 54 80 00 00 	movabs $0x80545a,%rdi
  803821:	00 00 00 
  803824:	b8 00 00 00 00       	mov    $0x0,%eax
  803829:	48 ba 0e 09 80 00 00 	movabs $0x80090e,%rdx
  803830:	00 00 00 
  803833:	ff d2                	callq  *%rdx
		return fd_src;
  803835:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803838:	e9 74 01 00 00       	jmpq   8039b1 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80383d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803844:	be 01 01 00 00       	mov    $0x101,%esi
  803849:	48 89 c7             	mov    %rax,%rdi
  80384c:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  803853:	00 00 00 
  803856:	ff d0                	callq  *%rax
  803858:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80385b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80385f:	79 39                	jns    80389a <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803861:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803864:	89 c6                	mov    %eax,%esi
  803866:	48 bf 70 54 80 00 00 	movabs $0x805470,%rdi
  80386d:	00 00 00 
  803870:	b8 00 00 00 00       	mov    $0x0,%eax
  803875:	48 ba 0e 09 80 00 00 	movabs $0x80090e,%rdx
  80387c:	00 00 00 
  80387f:	ff d2                	callq  *%rdx
		close(fd_src);
  803881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803884:	89 c7                	mov    %eax,%edi
  803886:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  80388d:	00 00 00 
  803890:	ff d0                	callq  *%rax
		return fd_dest;
  803892:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803895:	e9 17 01 00 00       	jmpq   8039b1 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80389a:	eb 74                	jmp    803910 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80389c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80389f:	48 63 d0             	movslq %eax,%rdx
  8038a2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8038a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038ac:	48 89 ce             	mov    %rcx,%rsi
  8038af:	89 c7                	mov    %eax,%edi
  8038b1:	48 b8 11 30 80 00 00 	movabs $0x803011,%rax
  8038b8:	00 00 00 
  8038bb:	ff d0                	callq  *%rax
  8038bd:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8038c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8038c4:	79 4a                	jns    803910 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8038c6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038c9:	89 c6                	mov    %eax,%esi
  8038cb:	48 bf 8a 54 80 00 00 	movabs $0x80548a,%rdi
  8038d2:	00 00 00 
  8038d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8038da:	48 ba 0e 09 80 00 00 	movabs $0x80090e,%rdx
  8038e1:	00 00 00 
  8038e4:	ff d2                	callq  *%rdx
			close(fd_src);
  8038e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e9:	89 c7                	mov    %eax,%edi
  8038eb:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  8038f2:	00 00 00 
  8038f5:	ff d0                	callq  *%rax
			close(fd_dest);
  8038f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038fa:	89 c7                	mov    %eax,%edi
  8038fc:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  803903:	00 00 00 
  803906:	ff d0                	callq  *%rax
			return write_size;
  803908:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80390b:	e9 a1 00 00 00       	jmpq   8039b1 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803910:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803917:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80391a:	ba 00 02 00 00       	mov    $0x200,%edx
  80391f:	48 89 ce             	mov    %rcx,%rsi
  803922:	89 c7                	mov    %eax,%edi
  803924:	48 b8 c7 2e 80 00 00 	movabs $0x802ec7,%rax
  80392b:	00 00 00 
  80392e:	ff d0                	callq  *%rax
  803930:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803933:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803937:	0f 8f 5f ff ff ff    	jg     80389c <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80393d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803941:	79 47                	jns    80398a <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803943:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803946:	89 c6                	mov    %eax,%esi
  803948:	48 bf 9d 54 80 00 00 	movabs $0x80549d,%rdi
  80394f:	00 00 00 
  803952:	b8 00 00 00 00       	mov    $0x0,%eax
  803957:	48 ba 0e 09 80 00 00 	movabs $0x80090e,%rdx
  80395e:	00 00 00 
  803961:	ff d2                	callq  *%rdx
		close(fd_src);
  803963:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803966:	89 c7                	mov    %eax,%edi
  803968:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  80396f:	00 00 00 
  803972:	ff d0                	callq  *%rax
		close(fd_dest);
  803974:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803977:	89 c7                	mov    %eax,%edi
  803979:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  803980:	00 00 00 
  803983:	ff d0                	callq  *%rax
		return read_size;
  803985:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803988:	eb 27                	jmp    8039b1 <copy+0x1d9>
	}
	close(fd_src);
  80398a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398d:	89 c7                	mov    %eax,%edi
  80398f:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  803996:	00 00 00 
  803999:	ff d0                	callq  *%rax
	close(fd_dest);
  80399b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80399e:	89 c7                	mov    %eax,%edi
  8039a0:	48 b8 a5 2c 80 00 00 	movabs $0x802ca5,%rax
  8039a7:	00 00 00 
  8039aa:	ff d0                	callq  *%rax
	return 0;
  8039ac:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8039b1:	c9                   	leaveq 
  8039b2:	c3                   	retq   

00000000008039b3 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8039b3:	55                   	push   %rbp
  8039b4:	48 89 e5             	mov    %rsp,%rbp
  8039b7:	48 83 ec 20          	sub    $0x20,%rsp
  8039bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8039be:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8039c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039c5:	48 89 d6             	mov    %rdx,%rsi
  8039c8:	89 c7                	mov    %eax,%edi
  8039ca:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  8039d1:	00 00 00 
  8039d4:	ff d0                	callq  *%rax
  8039d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039dd:	79 05                	jns    8039e4 <fd2sockid+0x31>
		return r;
  8039df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e2:	eb 24                	jmp    803a08 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8039e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e8:	8b 10                	mov    (%rax),%edx
  8039ea:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8039f1:	00 00 00 
  8039f4:	8b 00                	mov    (%rax),%eax
  8039f6:	39 c2                	cmp    %eax,%edx
  8039f8:	74 07                	je     803a01 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8039fa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8039ff:	eb 07                	jmp    803a08 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803a01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a05:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803a08:	c9                   	leaveq 
  803a09:	c3                   	retq   

0000000000803a0a <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803a0a:	55                   	push   %rbp
  803a0b:	48 89 e5             	mov    %rsp,%rbp
  803a0e:	48 83 ec 20          	sub    $0x20,%rsp
  803a12:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803a15:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803a19:	48 89 c7             	mov    %rax,%rdi
  803a1c:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  803a23:	00 00 00 
  803a26:	ff d0                	callq  *%rax
  803a28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a2f:	78 26                	js     803a57 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803a31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a35:	ba 07 04 00 00       	mov    $0x407,%edx
  803a3a:	48 89 c6             	mov    %rax,%rsi
  803a3d:	bf 00 00 00 00       	mov    $0x0,%edi
  803a42:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  803a49:	00 00 00 
  803a4c:	ff d0                	callq  *%rax
  803a4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a55:	79 16                	jns    803a6d <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803a57:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a5a:	89 c7                	mov    %eax,%edi
  803a5c:	48 b8 17 3f 80 00 00 	movabs $0x803f17,%rax
  803a63:	00 00 00 
  803a66:	ff d0                	callq  *%rax
		return r;
  803a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a6b:	eb 3a                	jmp    803aa7 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a71:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803a78:	00 00 00 
  803a7b:	8b 12                	mov    (%rdx),%edx
  803a7d:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803a7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a83:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803a8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a8e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a91:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803a94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a98:	48 89 c7             	mov    %rax,%rdi
  803a9b:	48 b8 af 29 80 00 00 	movabs $0x8029af,%rax
  803aa2:	00 00 00 
  803aa5:	ff d0                	callq  *%rax
}
  803aa7:	c9                   	leaveq 
  803aa8:	c3                   	retq   

0000000000803aa9 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803aa9:	55                   	push   %rbp
  803aaa:	48 89 e5             	mov    %rsp,%rbp
  803aad:	48 83 ec 30          	sub    $0x30,%rsp
  803ab1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ab4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ab8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803abc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803abf:	89 c7                	mov    %eax,%edi
  803ac1:	48 b8 b3 39 80 00 00 	movabs $0x8039b3,%rax
  803ac8:	00 00 00 
  803acb:	ff d0                	callq  *%rax
  803acd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ad0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad4:	79 05                	jns    803adb <accept+0x32>
		return r;
  803ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad9:	eb 3b                	jmp    803b16 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803adb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803adf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803ae3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae6:	48 89 ce             	mov    %rcx,%rsi
  803ae9:	89 c7                	mov    %eax,%edi
  803aeb:	48 b8 f4 3d 80 00 00 	movabs $0x803df4,%rax
  803af2:	00 00 00 
  803af5:	ff d0                	callq  *%rax
  803af7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803afa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803afe:	79 05                	jns    803b05 <accept+0x5c>
		return r;
  803b00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b03:	eb 11                	jmp    803b16 <accept+0x6d>
	return alloc_sockfd(r);
  803b05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b08:	89 c7                	mov    %eax,%edi
  803b0a:	48 b8 0a 3a 80 00 00 	movabs $0x803a0a,%rax
  803b11:	00 00 00 
  803b14:	ff d0                	callq  *%rax
}
  803b16:	c9                   	leaveq 
  803b17:	c3                   	retq   

0000000000803b18 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b18:	55                   	push   %rbp
  803b19:	48 89 e5             	mov    %rsp,%rbp
  803b1c:	48 83 ec 20          	sub    $0x20,%rsp
  803b20:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b27:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b2a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b2d:	89 c7                	mov    %eax,%edi
  803b2f:	48 b8 b3 39 80 00 00 	movabs $0x8039b3,%rax
  803b36:	00 00 00 
  803b39:	ff d0                	callq  *%rax
  803b3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b42:	79 05                	jns    803b49 <bind+0x31>
		return r;
  803b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b47:	eb 1b                	jmp    803b64 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803b49:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b4c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803b50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b53:	48 89 ce             	mov    %rcx,%rsi
  803b56:	89 c7                	mov    %eax,%edi
  803b58:	48 b8 73 3e 80 00 00 	movabs $0x803e73,%rax
  803b5f:	00 00 00 
  803b62:	ff d0                	callq  *%rax
}
  803b64:	c9                   	leaveq 
  803b65:	c3                   	retq   

0000000000803b66 <shutdown>:

int
shutdown(int s, int how)
{
  803b66:	55                   	push   %rbp
  803b67:	48 89 e5             	mov    %rsp,%rbp
  803b6a:	48 83 ec 20          	sub    $0x20,%rsp
  803b6e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b71:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b74:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b77:	89 c7                	mov    %eax,%edi
  803b79:	48 b8 b3 39 80 00 00 	movabs $0x8039b3,%rax
  803b80:	00 00 00 
  803b83:	ff d0                	callq  *%rax
  803b85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b8c:	79 05                	jns    803b93 <shutdown+0x2d>
		return r;
  803b8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b91:	eb 16                	jmp    803ba9 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803b93:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b99:	89 d6                	mov    %edx,%esi
  803b9b:	89 c7                	mov    %eax,%edi
  803b9d:	48 b8 d7 3e 80 00 00 	movabs $0x803ed7,%rax
  803ba4:	00 00 00 
  803ba7:	ff d0                	callq  *%rax
}
  803ba9:	c9                   	leaveq 
  803baa:	c3                   	retq   

0000000000803bab <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803bab:	55                   	push   %rbp
  803bac:	48 89 e5             	mov    %rsp,%rbp
  803baf:	48 83 ec 10          	sub    $0x10,%rsp
  803bb3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803bb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bbb:	48 89 c7             	mov    %rax,%rdi
  803bbe:	48 b8 7b 4b 80 00 00 	movabs $0x804b7b,%rax
  803bc5:	00 00 00 
  803bc8:	ff d0                	callq  *%rax
  803bca:	83 f8 01             	cmp    $0x1,%eax
  803bcd:	75 17                	jne    803be6 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803bcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bd3:	8b 40 0c             	mov    0xc(%rax),%eax
  803bd6:	89 c7                	mov    %eax,%edi
  803bd8:	48 b8 17 3f 80 00 00 	movabs $0x803f17,%rax
  803bdf:	00 00 00 
  803be2:	ff d0                	callq  *%rax
  803be4:	eb 05                	jmp    803beb <devsock_close+0x40>
	else
		return 0;
  803be6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803beb:	c9                   	leaveq 
  803bec:	c3                   	retq   

0000000000803bed <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803bed:	55                   	push   %rbp
  803bee:	48 89 e5             	mov    %rsp,%rbp
  803bf1:	48 83 ec 20          	sub    $0x20,%rsp
  803bf5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bf8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bfc:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c02:	89 c7                	mov    %eax,%edi
  803c04:	48 b8 b3 39 80 00 00 	movabs $0x8039b3,%rax
  803c0b:	00 00 00 
  803c0e:	ff d0                	callq  *%rax
  803c10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c17:	79 05                	jns    803c1e <connect+0x31>
		return r;
  803c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1c:	eb 1b                	jmp    803c39 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803c1e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c21:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c28:	48 89 ce             	mov    %rcx,%rsi
  803c2b:	89 c7                	mov    %eax,%edi
  803c2d:	48 b8 44 3f 80 00 00 	movabs $0x803f44,%rax
  803c34:	00 00 00 
  803c37:	ff d0                	callq  *%rax
}
  803c39:	c9                   	leaveq 
  803c3a:	c3                   	retq   

0000000000803c3b <listen>:

int
listen(int s, int backlog)
{
  803c3b:	55                   	push   %rbp
  803c3c:	48 89 e5             	mov    %rsp,%rbp
  803c3f:	48 83 ec 20          	sub    $0x20,%rsp
  803c43:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c46:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c49:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c4c:	89 c7                	mov    %eax,%edi
  803c4e:	48 b8 b3 39 80 00 00 	movabs $0x8039b3,%rax
  803c55:	00 00 00 
  803c58:	ff d0                	callq  *%rax
  803c5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c61:	79 05                	jns    803c68 <listen+0x2d>
		return r;
  803c63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c66:	eb 16                	jmp    803c7e <listen+0x43>
	return nsipc_listen(r, backlog);
  803c68:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6e:	89 d6                	mov    %edx,%esi
  803c70:	89 c7                	mov    %eax,%edi
  803c72:	48 b8 a8 3f 80 00 00 	movabs $0x803fa8,%rax
  803c79:	00 00 00 
  803c7c:	ff d0                	callq  *%rax
}
  803c7e:	c9                   	leaveq 
  803c7f:	c3                   	retq   

0000000000803c80 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803c80:	55                   	push   %rbp
  803c81:	48 89 e5             	mov    %rsp,%rbp
  803c84:	48 83 ec 20          	sub    $0x20,%rsp
  803c88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c90:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c98:	89 c2                	mov    %eax,%edx
  803c9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c9e:	8b 40 0c             	mov    0xc(%rax),%eax
  803ca1:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803ca5:	b9 00 00 00 00       	mov    $0x0,%ecx
  803caa:	89 c7                	mov    %eax,%edi
  803cac:	48 b8 e8 3f 80 00 00 	movabs $0x803fe8,%rax
  803cb3:	00 00 00 
  803cb6:	ff d0                	callq  *%rax
}
  803cb8:	c9                   	leaveq 
  803cb9:	c3                   	retq   

0000000000803cba <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803cba:	55                   	push   %rbp
  803cbb:	48 89 e5             	mov    %rsp,%rbp
  803cbe:	48 83 ec 20          	sub    $0x20,%rsp
  803cc2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803cc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803cce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cd2:	89 c2                	mov    %eax,%edx
  803cd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cd8:	8b 40 0c             	mov    0xc(%rax),%eax
  803cdb:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803cdf:	b9 00 00 00 00       	mov    $0x0,%ecx
  803ce4:	89 c7                	mov    %eax,%edi
  803ce6:	48 b8 b4 40 80 00 00 	movabs $0x8040b4,%rax
  803ced:	00 00 00 
  803cf0:	ff d0                	callq  *%rax
}
  803cf2:	c9                   	leaveq 
  803cf3:	c3                   	retq   

0000000000803cf4 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803cf4:	55                   	push   %rbp
  803cf5:	48 89 e5             	mov    %rsp,%rbp
  803cf8:	48 83 ec 10          	sub    $0x10,%rsp
  803cfc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d08:	48 be b8 54 80 00 00 	movabs $0x8054b8,%rsi
  803d0f:	00 00 00 
  803d12:	48 89 c7             	mov    %rax,%rdi
  803d15:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  803d1c:	00 00 00 
  803d1f:	ff d0                	callq  *%rax
	return 0;
  803d21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d26:	c9                   	leaveq 
  803d27:	c3                   	retq   

0000000000803d28 <socket>:

int
socket(int domain, int type, int protocol)
{
  803d28:	55                   	push   %rbp
  803d29:	48 89 e5             	mov    %rsp,%rbp
  803d2c:	48 83 ec 20          	sub    $0x20,%rsp
  803d30:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d33:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803d36:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803d39:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803d3c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803d3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d42:	89 ce                	mov    %ecx,%esi
  803d44:	89 c7                	mov    %eax,%edi
  803d46:	48 b8 6c 41 80 00 00 	movabs $0x80416c,%rax
  803d4d:	00 00 00 
  803d50:	ff d0                	callq  *%rax
  803d52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d59:	79 05                	jns    803d60 <socket+0x38>
		return r;
  803d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5e:	eb 11                	jmp    803d71 <socket+0x49>
	return alloc_sockfd(r);
  803d60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d63:	89 c7                	mov    %eax,%edi
  803d65:	48 b8 0a 3a 80 00 00 	movabs $0x803a0a,%rax
  803d6c:	00 00 00 
  803d6f:	ff d0                	callq  *%rax
}
  803d71:	c9                   	leaveq 
  803d72:	c3                   	retq   

0000000000803d73 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803d73:	55                   	push   %rbp
  803d74:	48 89 e5             	mov    %rsp,%rbp
  803d77:	48 83 ec 10          	sub    $0x10,%rsp
  803d7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803d7e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803d85:	00 00 00 
  803d88:	8b 00                	mov    (%rax),%eax
  803d8a:	85 c0                	test   %eax,%eax
  803d8c:	75 1d                	jne    803dab <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803d8e:	bf 02 00 00 00       	mov    $0x2,%edi
  803d93:	48 b8 2d 29 80 00 00 	movabs $0x80292d,%rax
  803d9a:	00 00 00 
  803d9d:	ff d0                	callq  *%rax
  803d9f:	48 ba 08 80 80 00 00 	movabs $0x808008,%rdx
  803da6:	00 00 00 
  803da9:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803dab:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803db2:	00 00 00 
  803db5:	8b 00                	mov    (%rax),%eax
  803db7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803dba:	b9 07 00 00 00       	mov    $0x7,%ecx
  803dbf:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803dc6:	00 00 00 
  803dc9:	89 c7                	mov    %eax,%edi
  803dcb:	48 b8 cb 28 80 00 00 	movabs $0x8028cb,%rax
  803dd2:	00 00 00 
  803dd5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803dd7:	ba 00 00 00 00       	mov    $0x0,%edx
  803ddc:	be 00 00 00 00       	mov    $0x0,%esi
  803de1:	bf 00 00 00 00       	mov    $0x0,%edi
  803de6:	48 b8 c5 27 80 00 00 	movabs $0x8027c5,%rax
  803ded:	00 00 00 
  803df0:	ff d0                	callq  *%rax
}
  803df2:	c9                   	leaveq 
  803df3:	c3                   	retq   

0000000000803df4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803df4:	55                   	push   %rbp
  803df5:	48 89 e5             	mov    %rsp,%rbp
  803df8:	48 83 ec 30          	sub    $0x30,%rsp
  803dfc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803dff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e03:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803e07:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e0e:	00 00 00 
  803e11:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e14:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803e16:	bf 01 00 00 00       	mov    $0x1,%edi
  803e1b:	48 b8 73 3d 80 00 00 	movabs $0x803d73,%rax
  803e22:	00 00 00 
  803e25:	ff d0                	callq  *%rax
  803e27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e2e:	78 3e                	js     803e6e <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803e30:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e37:	00 00 00 
  803e3a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e42:	8b 40 10             	mov    0x10(%rax),%eax
  803e45:	89 c2                	mov    %eax,%edx
  803e47:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803e4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e4f:	48 89 ce             	mov    %rcx,%rsi
  803e52:	48 89 c7             	mov    %rax,%rdi
  803e55:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  803e5c:	00 00 00 
  803e5f:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e65:	8b 50 10             	mov    0x10(%rax),%edx
  803e68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e6c:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803e6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e71:	c9                   	leaveq 
  803e72:	c3                   	retq   

0000000000803e73 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803e73:	55                   	push   %rbp
  803e74:	48 89 e5             	mov    %rsp,%rbp
  803e77:	48 83 ec 10          	sub    $0x10,%rsp
  803e7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e82:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803e85:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e8c:	00 00 00 
  803e8f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e92:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803e94:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e9b:	48 89 c6             	mov    %rax,%rsi
  803e9e:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803ea5:	00 00 00 
  803ea8:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  803eaf:	00 00 00 
  803eb2:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803eb4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ebb:	00 00 00 
  803ebe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ec1:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803ec4:	bf 02 00 00 00       	mov    $0x2,%edi
  803ec9:	48 b8 73 3d 80 00 00 	movabs $0x803d73,%rax
  803ed0:	00 00 00 
  803ed3:	ff d0                	callq  *%rax
}
  803ed5:	c9                   	leaveq 
  803ed6:	c3                   	retq   

0000000000803ed7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803ed7:	55                   	push   %rbp
  803ed8:	48 89 e5             	mov    %rsp,%rbp
  803edb:	48 83 ec 10          	sub    $0x10,%rsp
  803edf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ee2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803ee5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803eec:	00 00 00 
  803eef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ef2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803ef4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803efb:	00 00 00 
  803efe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f01:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803f04:	bf 03 00 00 00       	mov    $0x3,%edi
  803f09:	48 b8 73 3d 80 00 00 	movabs $0x803d73,%rax
  803f10:	00 00 00 
  803f13:	ff d0                	callq  *%rax
}
  803f15:	c9                   	leaveq 
  803f16:	c3                   	retq   

0000000000803f17 <nsipc_close>:

int
nsipc_close(int s)
{
  803f17:	55                   	push   %rbp
  803f18:	48 89 e5             	mov    %rsp,%rbp
  803f1b:	48 83 ec 10          	sub    $0x10,%rsp
  803f1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803f22:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f29:	00 00 00 
  803f2c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f2f:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803f31:	bf 04 00 00 00       	mov    $0x4,%edi
  803f36:	48 b8 73 3d 80 00 00 	movabs $0x803d73,%rax
  803f3d:	00 00 00 
  803f40:	ff d0                	callq  *%rax
}
  803f42:	c9                   	leaveq 
  803f43:	c3                   	retq   

0000000000803f44 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803f44:	55                   	push   %rbp
  803f45:	48 89 e5             	mov    %rsp,%rbp
  803f48:	48 83 ec 10          	sub    $0x10,%rsp
  803f4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f53:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803f56:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f5d:	00 00 00 
  803f60:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f63:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803f65:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f6c:	48 89 c6             	mov    %rax,%rsi
  803f6f:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803f76:	00 00 00 
  803f79:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  803f80:	00 00 00 
  803f83:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803f85:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f8c:	00 00 00 
  803f8f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f92:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803f95:	bf 05 00 00 00       	mov    $0x5,%edi
  803f9a:	48 b8 73 3d 80 00 00 	movabs $0x803d73,%rax
  803fa1:	00 00 00 
  803fa4:	ff d0                	callq  *%rax
}
  803fa6:	c9                   	leaveq 
  803fa7:	c3                   	retq   

0000000000803fa8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803fa8:	55                   	push   %rbp
  803fa9:	48 89 e5             	mov    %rsp,%rbp
  803fac:	48 83 ec 10          	sub    $0x10,%rsp
  803fb0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fb3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803fb6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fbd:	00 00 00 
  803fc0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fc3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803fc5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fcc:	00 00 00 
  803fcf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fd2:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803fd5:	bf 06 00 00 00       	mov    $0x6,%edi
  803fda:	48 b8 73 3d 80 00 00 	movabs $0x803d73,%rax
  803fe1:	00 00 00 
  803fe4:	ff d0                	callq  *%rax
}
  803fe6:	c9                   	leaveq 
  803fe7:	c3                   	retq   

0000000000803fe8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803fe8:	55                   	push   %rbp
  803fe9:	48 89 e5             	mov    %rsp,%rbp
  803fec:	48 83 ec 30          	sub    $0x30,%rsp
  803ff0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ff3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ff7:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803ffa:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803ffd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804004:	00 00 00 
  804007:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80400a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80400c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804013:	00 00 00 
  804016:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804019:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80401c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804023:	00 00 00 
  804026:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804029:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80402c:	bf 07 00 00 00       	mov    $0x7,%edi
  804031:	48 b8 73 3d 80 00 00 	movabs $0x803d73,%rax
  804038:	00 00 00 
  80403b:	ff d0                	callq  *%rax
  80403d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804040:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804044:	78 69                	js     8040af <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804046:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80404d:	7f 08                	jg     804057 <nsipc_recv+0x6f>
  80404f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804052:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804055:	7e 35                	jle    80408c <nsipc_recv+0xa4>
  804057:	48 b9 bf 54 80 00 00 	movabs $0x8054bf,%rcx
  80405e:	00 00 00 
  804061:	48 ba d4 54 80 00 00 	movabs $0x8054d4,%rdx
  804068:	00 00 00 
  80406b:	be 61 00 00 00       	mov    $0x61,%esi
  804070:	48 bf e9 54 80 00 00 	movabs $0x8054e9,%rdi
  804077:	00 00 00 
  80407a:	b8 00 00 00 00       	mov    $0x0,%eax
  80407f:	49 b8 d5 06 80 00 00 	movabs $0x8006d5,%r8
  804086:	00 00 00 
  804089:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80408c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80408f:	48 63 d0             	movslq %eax,%rdx
  804092:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804096:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  80409d:	00 00 00 
  8040a0:	48 89 c7             	mov    %rax,%rdi
  8040a3:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  8040aa:	00 00 00 
  8040ad:	ff d0                	callq  *%rax
	}

	return r;
  8040af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8040b2:	c9                   	leaveq 
  8040b3:	c3                   	retq   

00000000008040b4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8040b4:	55                   	push   %rbp
  8040b5:	48 89 e5             	mov    %rsp,%rbp
  8040b8:	48 83 ec 20          	sub    $0x20,%rsp
  8040bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8040c3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8040c6:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8040c9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040d0:	00 00 00 
  8040d3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040d6:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8040d8:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8040df:	7e 35                	jle    804116 <nsipc_send+0x62>
  8040e1:	48 b9 f5 54 80 00 00 	movabs $0x8054f5,%rcx
  8040e8:	00 00 00 
  8040eb:	48 ba d4 54 80 00 00 	movabs $0x8054d4,%rdx
  8040f2:	00 00 00 
  8040f5:	be 6c 00 00 00       	mov    $0x6c,%esi
  8040fa:	48 bf e9 54 80 00 00 	movabs $0x8054e9,%rdi
  804101:	00 00 00 
  804104:	b8 00 00 00 00       	mov    $0x0,%eax
  804109:	49 b8 d5 06 80 00 00 	movabs $0x8006d5,%r8
  804110:	00 00 00 
  804113:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804116:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804119:	48 63 d0             	movslq %eax,%rdx
  80411c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804120:	48 89 c6             	mov    %rax,%rsi
  804123:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  80412a:	00 00 00 
  80412d:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  804134:	00 00 00 
  804137:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804139:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804140:	00 00 00 
  804143:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804146:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804149:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804150:	00 00 00 
  804153:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804156:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804159:	bf 08 00 00 00       	mov    $0x8,%edi
  80415e:	48 b8 73 3d 80 00 00 	movabs $0x803d73,%rax
  804165:	00 00 00 
  804168:	ff d0                	callq  *%rax
}
  80416a:	c9                   	leaveq 
  80416b:	c3                   	retq   

000000000080416c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80416c:	55                   	push   %rbp
  80416d:	48 89 e5             	mov    %rsp,%rbp
  804170:	48 83 ec 10          	sub    $0x10,%rsp
  804174:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804177:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80417a:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80417d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804184:	00 00 00 
  804187:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80418a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80418c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804193:	00 00 00 
  804196:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804199:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80419c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041a3:	00 00 00 
  8041a6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8041a9:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8041ac:	bf 09 00 00 00       	mov    $0x9,%edi
  8041b1:	48 b8 73 3d 80 00 00 	movabs $0x803d73,%rax
  8041b8:	00 00 00 
  8041bb:	ff d0                	callq  *%rax
}
  8041bd:	c9                   	leaveq 
  8041be:	c3                   	retq   

00000000008041bf <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8041bf:	55                   	push   %rbp
  8041c0:	48 89 e5             	mov    %rsp,%rbp
  8041c3:	53                   	push   %rbx
  8041c4:	48 83 ec 38          	sub    $0x38,%rsp
  8041c8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8041cc:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8041d0:	48 89 c7             	mov    %rax,%rdi
  8041d3:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  8041da:	00 00 00 
  8041dd:	ff d0                	callq  *%rax
  8041df:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8041e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8041e6:	0f 88 bf 01 00 00    	js     8043ab <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8041ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041f0:	ba 07 04 00 00       	mov    $0x407,%edx
  8041f5:	48 89 c6             	mov    %rax,%rsi
  8041f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8041fd:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  804204:	00 00 00 
  804207:	ff d0                	callq  *%rax
  804209:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80420c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804210:	0f 88 95 01 00 00    	js     8043ab <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804216:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80421a:	48 89 c7             	mov    %rax,%rdi
  80421d:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  804224:	00 00 00 
  804227:	ff d0                	callq  *%rax
  804229:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80422c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804230:	0f 88 5d 01 00 00    	js     804393 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804236:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80423a:	ba 07 04 00 00       	mov    $0x407,%edx
  80423f:	48 89 c6             	mov    %rax,%rsi
  804242:	bf 00 00 00 00       	mov    $0x0,%edi
  804247:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  80424e:	00 00 00 
  804251:	ff d0                	callq  *%rax
  804253:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804256:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80425a:	0f 88 33 01 00 00    	js     804393 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804260:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804264:	48 89 c7             	mov    %rax,%rdi
  804267:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  80426e:	00 00 00 
  804271:	ff d0                	callq  *%rax
  804273:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804277:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80427b:	ba 07 04 00 00       	mov    $0x407,%edx
  804280:	48 89 c6             	mov    %rax,%rsi
  804283:	bf 00 00 00 00       	mov    $0x0,%edi
  804288:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  80428f:	00 00 00 
  804292:	ff d0                	callq  *%rax
  804294:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804297:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80429b:	79 05                	jns    8042a2 <pipe+0xe3>
		goto err2;
  80429d:	e9 d9 00 00 00       	jmpq   80437b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042a6:	48 89 c7             	mov    %rax,%rdi
  8042a9:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  8042b0:	00 00 00 
  8042b3:	ff d0                	callq  *%rax
  8042b5:	48 89 c2             	mov    %rax,%rdx
  8042b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042bc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8042c2:	48 89 d1             	mov    %rdx,%rcx
  8042c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8042ca:	48 89 c6             	mov    %rax,%rsi
  8042cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8042d2:	48 b8 42 1e 80 00 00 	movabs $0x801e42,%rax
  8042d9:	00 00 00 
  8042dc:	ff d0                	callq  *%rax
  8042de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042e5:	79 1b                	jns    804302 <pipe+0x143>
		goto err3;
  8042e7:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8042e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042ec:	48 89 c6             	mov    %rax,%rsi
  8042ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8042f4:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  8042fb:	00 00 00 
  8042fe:	ff d0                	callq  *%rax
  804300:	eb 79                	jmp    80437b <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804306:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80430d:	00 00 00 
  804310:	8b 12                	mov    (%rdx),%edx
  804312:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804314:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804318:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80431f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804323:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80432a:	00 00 00 
  80432d:	8b 12                	mov    (%rdx),%edx
  80432f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804331:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804335:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80433c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804340:	48 89 c7             	mov    %rax,%rdi
  804343:	48 b8 af 29 80 00 00 	movabs $0x8029af,%rax
  80434a:	00 00 00 
  80434d:	ff d0                	callq  *%rax
  80434f:	89 c2                	mov    %eax,%edx
  804351:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804355:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804357:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80435b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80435f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804363:	48 89 c7             	mov    %rax,%rdi
  804366:	48 b8 af 29 80 00 00 	movabs $0x8029af,%rax
  80436d:	00 00 00 
  804370:	ff d0                	callq  *%rax
  804372:	89 03                	mov    %eax,(%rbx)
	return 0;
  804374:	b8 00 00 00 00       	mov    $0x0,%eax
  804379:	eb 33                	jmp    8043ae <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80437b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80437f:	48 89 c6             	mov    %rax,%rsi
  804382:	bf 00 00 00 00       	mov    $0x0,%edi
  804387:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  80438e:	00 00 00 
  804391:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804393:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804397:	48 89 c6             	mov    %rax,%rsi
  80439a:	bf 00 00 00 00       	mov    $0x0,%edi
  80439f:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  8043a6:	00 00 00 
  8043a9:	ff d0                	callq  *%rax
err:
	return r;
  8043ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8043ae:	48 83 c4 38          	add    $0x38,%rsp
  8043b2:	5b                   	pop    %rbx
  8043b3:	5d                   	pop    %rbp
  8043b4:	c3                   	retq   

00000000008043b5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8043b5:	55                   	push   %rbp
  8043b6:	48 89 e5             	mov    %rsp,%rbp
  8043b9:	53                   	push   %rbx
  8043ba:	48 83 ec 28          	sub    $0x28,%rsp
  8043be:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8043c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8043c6:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8043cd:	00 00 00 
  8043d0:	48 8b 00             	mov    (%rax),%rax
  8043d3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8043d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8043dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043e0:	48 89 c7             	mov    %rax,%rdi
  8043e3:	48 b8 7b 4b 80 00 00 	movabs $0x804b7b,%rax
  8043ea:	00 00 00 
  8043ed:	ff d0                	callq  *%rax
  8043ef:	89 c3                	mov    %eax,%ebx
  8043f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043f5:	48 89 c7             	mov    %rax,%rdi
  8043f8:	48 b8 7b 4b 80 00 00 	movabs $0x804b7b,%rax
  8043ff:	00 00 00 
  804402:	ff d0                	callq  *%rax
  804404:	39 c3                	cmp    %eax,%ebx
  804406:	0f 94 c0             	sete   %al
  804409:	0f b6 c0             	movzbl %al,%eax
  80440c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80440f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804416:	00 00 00 
  804419:	48 8b 00             	mov    (%rax),%rax
  80441c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804422:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804425:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804428:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80442b:	75 05                	jne    804432 <_pipeisclosed+0x7d>
			return ret;
  80442d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804430:	eb 4f                	jmp    804481 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  804432:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804435:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804438:	74 42                	je     80447c <_pipeisclosed+0xc7>
  80443a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80443e:	75 3c                	jne    80447c <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804440:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804447:	00 00 00 
  80444a:	48 8b 00             	mov    (%rax),%rax
  80444d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804453:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804456:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804459:	89 c6                	mov    %eax,%esi
  80445b:	48 bf 06 55 80 00 00 	movabs $0x805506,%rdi
  804462:	00 00 00 
  804465:	b8 00 00 00 00       	mov    $0x0,%eax
  80446a:	49 b8 0e 09 80 00 00 	movabs $0x80090e,%r8
  804471:	00 00 00 
  804474:	41 ff d0             	callq  *%r8
	}
  804477:	e9 4a ff ff ff       	jmpq   8043c6 <_pipeisclosed+0x11>
  80447c:	e9 45 ff ff ff       	jmpq   8043c6 <_pipeisclosed+0x11>
}
  804481:	48 83 c4 28          	add    $0x28,%rsp
  804485:	5b                   	pop    %rbx
  804486:	5d                   	pop    %rbp
  804487:	c3                   	retq   

0000000000804488 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804488:	55                   	push   %rbp
  804489:	48 89 e5             	mov    %rsp,%rbp
  80448c:	48 83 ec 30          	sub    $0x30,%rsp
  804490:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804493:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804497:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80449a:	48 89 d6             	mov    %rdx,%rsi
  80449d:	89 c7                	mov    %eax,%edi
  80449f:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  8044a6:	00 00 00 
  8044a9:	ff d0                	callq  *%rax
  8044ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044b2:	79 05                	jns    8044b9 <pipeisclosed+0x31>
		return r;
  8044b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044b7:	eb 31                	jmp    8044ea <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8044b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044bd:	48 89 c7             	mov    %rax,%rdi
  8044c0:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  8044c7:	00 00 00 
  8044ca:	ff d0                	callq  *%rax
  8044cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8044d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044d8:	48 89 d6             	mov    %rdx,%rsi
  8044db:	48 89 c7             	mov    %rax,%rdi
  8044de:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  8044e5:	00 00 00 
  8044e8:	ff d0                	callq  *%rax
}
  8044ea:	c9                   	leaveq 
  8044eb:	c3                   	retq   

00000000008044ec <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8044ec:	55                   	push   %rbp
  8044ed:	48 89 e5             	mov    %rsp,%rbp
  8044f0:	48 83 ec 40          	sub    $0x40,%rsp
  8044f4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8044f8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8044fc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804504:	48 89 c7             	mov    %rax,%rdi
  804507:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  80450e:	00 00 00 
  804511:	ff d0                	callq  *%rax
  804513:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804517:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80451b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80451f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804526:	00 
  804527:	e9 92 00 00 00       	jmpq   8045be <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80452c:	eb 41                	jmp    80456f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80452e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804533:	74 09                	je     80453e <devpipe_read+0x52>
				return i;
  804535:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804539:	e9 92 00 00 00       	jmpq   8045d0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80453e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804546:	48 89 d6             	mov    %rdx,%rsi
  804549:	48 89 c7             	mov    %rax,%rdi
  80454c:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  804553:	00 00 00 
  804556:	ff d0                	callq  *%rax
  804558:	85 c0                	test   %eax,%eax
  80455a:	74 07                	je     804563 <devpipe_read+0x77>
				return 0;
  80455c:	b8 00 00 00 00       	mov    $0x0,%eax
  804561:	eb 6d                	jmp    8045d0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804563:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  80456a:	00 00 00 
  80456d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80456f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804573:	8b 10                	mov    (%rax),%edx
  804575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804579:	8b 40 04             	mov    0x4(%rax),%eax
  80457c:	39 c2                	cmp    %eax,%edx
  80457e:	74 ae                	je     80452e <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804580:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804588:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80458c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804590:	8b 00                	mov    (%rax),%eax
  804592:	99                   	cltd   
  804593:	c1 ea 1b             	shr    $0x1b,%edx
  804596:	01 d0                	add    %edx,%eax
  804598:	83 e0 1f             	and    $0x1f,%eax
  80459b:	29 d0                	sub    %edx,%eax
  80459d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045a1:	48 98                	cltq   
  8045a3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8045a8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8045aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045ae:	8b 00                	mov    (%rax),%eax
  8045b0:	8d 50 01             	lea    0x1(%rax),%edx
  8045b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045b7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8045b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8045be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045c2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8045c6:	0f 82 60 ff ff ff    	jb     80452c <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8045cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8045d0:	c9                   	leaveq 
  8045d1:	c3                   	retq   

00000000008045d2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8045d2:	55                   	push   %rbp
  8045d3:	48 89 e5             	mov    %rsp,%rbp
  8045d6:	48 83 ec 40          	sub    $0x40,%rsp
  8045da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8045de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8045e2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8045e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045ea:	48 89 c7             	mov    %rax,%rdi
  8045ed:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  8045f4:	00 00 00 
  8045f7:	ff d0                	callq  *%rax
  8045f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8045fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804601:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804605:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80460c:	00 
  80460d:	e9 8e 00 00 00       	jmpq   8046a0 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804612:	eb 31                	jmp    804645 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804614:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80461c:	48 89 d6             	mov    %rdx,%rsi
  80461f:	48 89 c7             	mov    %rax,%rdi
  804622:	48 b8 b5 43 80 00 00 	movabs $0x8043b5,%rax
  804629:	00 00 00 
  80462c:	ff d0                	callq  *%rax
  80462e:	85 c0                	test   %eax,%eax
  804630:	74 07                	je     804639 <devpipe_write+0x67>
				return 0;
  804632:	b8 00 00 00 00       	mov    $0x0,%eax
  804637:	eb 79                	jmp    8046b2 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804639:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  804640:	00 00 00 
  804643:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804645:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804649:	8b 40 04             	mov    0x4(%rax),%eax
  80464c:	48 63 d0             	movslq %eax,%rdx
  80464f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804653:	8b 00                	mov    (%rax),%eax
  804655:	48 98                	cltq   
  804657:	48 83 c0 20          	add    $0x20,%rax
  80465b:	48 39 c2             	cmp    %rax,%rdx
  80465e:	73 b4                	jae    804614 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804664:	8b 40 04             	mov    0x4(%rax),%eax
  804667:	99                   	cltd   
  804668:	c1 ea 1b             	shr    $0x1b,%edx
  80466b:	01 d0                	add    %edx,%eax
  80466d:	83 e0 1f             	and    $0x1f,%eax
  804670:	29 d0                	sub    %edx,%eax
  804672:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804676:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80467a:	48 01 ca             	add    %rcx,%rdx
  80467d:	0f b6 0a             	movzbl (%rdx),%ecx
  804680:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804684:	48 98                	cltq   
  804686:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80468a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80468e:	8b 40 04             	mov    0x4(%rax),%eax
  804691:	8d 50 01             	lea    0x1(%rax),%edx
  804694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804698:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80469b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8046a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046a4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8046a8:	0f 82 64 ff ff ff    	jb     804612 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8046ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8046b2:	c9                   	leaveq 
  8046b3:	c3                   	retq   

00000000008046b4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8046b4:	55                   	push   %rbp
  8046b5:	48 89 e5             	mov    %rsp,%rbp
  8046b8:	48 83 ec 20          	sub    $0x20,%rsp
  8046bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8046c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046c8:	48 89 c7             	mov    %rax,%rdi
  8046cb:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  8046d2:	00 00 00 
  8046d5:	ff d0                	callq  *%rax
  8046d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8046db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046df:	48 be 19 55 80 00 00 	movabs $0x805519,%rsi
  8046e6:	00 00 00 
  8046e9:	48 89 c7             	mov    %rax,%rdi
  8046ec:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  8046f3:	00 00 00 
  8046f6:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8046f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046fc:	8b 50 04             	mov    0x4(%rax),%edx
  8046ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804703:	8b 00                	mov    (%rax),%eax
  804705:	29 c2                	sub    %eax,%edx
  804707:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80470b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804711:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804715:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80471c:	00 00 00 
	stat->st_dev = &devpipe;
  80471f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804723:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80472a:	00 00 00 
  80472d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804739:	c9                   	leaveq 
  80473a:	c3                   	retq   

000000000080473b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80473b:	55                   	push   %rbp
  80473c:	48 89 e5             	mov    %rsp,%rbp
  80473f:	48 83 ec 10          	sub    $0x10,%rsp
  804743:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804747:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80474b:	48 89 c6             	mov    %rax,%rsi
  80474e:	bf 00 00 00 00       	mov    $0x0,%edi
  804753:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  80475a:	00 00 00 
  80475d:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80475f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804763:	48 89 c7             	mov    %rax,%rdi
  804766:	48 b8 d2 29 80 00 00 	movabs $0x8029d2,%rax
  80476d:	00 00 00 
  804770:	ff d0                	callq  *%rax
  804772:	48 89 c6             	mov    %rax,%rsi
  804775:	bf 00 00 00 00       	mov    $0x0,%edi
  80477a:	48 b8 9d 1e 80 00 00 	movabs $0x801e9d,%rax
  804781:	00 00 00 
  804784:	ff d0                	callq  *%rax
}
  804786:	c9                   	leaveq 
  804787:	c3                   	retq   

0000000000804788 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804788:	55                   	push   %rbp
  804789:	48 89 e5             	mov    %rsp,%rbp
  80478c:	48 83 ec 20          	sub    $0x20,%rsp
  804790:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804793:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804796:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804799:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80479d:	be 01 00 00 00       	mov    $0x1,%esi
  8047a2:	48 89 c7             	mov    %rax,%rdi
  8047a5:	48 b8 aa 1c 80 00 00 	movabs $0x801caa,%rax
  8047ac:	00 00 00 
  8047af:	ff d0                	callq  *%rax
}
  8047b1:	c9                   	leaveq 
  8047b2:	c3                   	retq   

00000000008047b3 <getchar>:

int
getchar(void)
{
  8047b3:	55                   	push   %rbp
  8047b4:	48 89 e5             	mov    %rsp,%rbp
  8047b7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8047bb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8047bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8047c4:	48 89 c6             	mov    %rax,%rsi
  8047c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8047cc:	48 b8 c7 2e 80 00 00 	movabs $0x802ec7,%rax
  8047d3:	00 00 00 
  8047d6:	ff d0                	callq  *%rax
  8047d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8047db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047df:	79 05                	jns    8047e6 <getchar+0x33>
		return r;
  8047e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047e4:	eb 14                	jmp    8047fa <getchar+0x47>
	if (r < 1)
  8047e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047ea:	7f 07                	jg     8047f3 <getchar+0x40>
		return -E_EOF;
  8047ec:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8047f1:	eb 07                	jmp    8047fa <getchar+0x47>
	return c;
  8047f3:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8047f7:	0f b6 c0             	movzbl %al,%eax
}
  8047fa:	c9                   	leaveq 
  8047fb:	c3                   	retq   

00000000008047fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8047fc:	55                   	push   %rbp
  8047fd:	48 89 e5             	mov    %rsp,%rbp
  804800:	48 83 ec 20          	sub    $0x20,%rsp
  804804:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804807:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80480b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80480e:	48 89 d6             	mov    %rdx,%rsi
  804811:	89 c7                	mov    %eax,%edi
  804813:	48 b8 95 2a 80 00 00 	movabs $0x802a95,%rax
  80481a:	00 00 00 
  80481d:	ff d0                	callq  *%rax
  80481f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804822:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804826:	79 05                	jns    80482d <iscons+0x31>
		return r;
  804828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80482b:	eb 1a                	jmp    804847 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80482d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804831:	8b 10                	mov    (%rax),%edx
  804833:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80483a:	00 00 00 
  80483d:	8b 00                	mov    (%rax),%eax
  80483f:	39 c2                	cmp    %eax,%edx
  804841:	0f 94 c0             	sete   %al
  804844:	0f b6 c0             	movzbl %al,%eax
}
  804847:	c9                   	leaveq 
  804848:	c3                   	retq   

0000000000804849 <opencons>:

int
opencons(void)
{
  804849:	55                   	push   %rbp
  80484a:	48 89 e5             	mov    %rsp,%rbp
  80484d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804851:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804855:	48 89 c7             	mov    %rax,%rdi
  804858:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  80485f:	00 00 00 
  804862:	ff d0                	callq  *%rax
  804864:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804867:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80486b:	79 05                	jns    804872 <opencons+0x29>
		return r;
  80486d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804870:	eb 5b                	jmp    8048cd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804872:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804876:	ba 07 04 00 00       	mov    $0x407,%edx
  80487b:	48 89 c6             	mov    %rax,%rsi
  80487e:	bf 00 00 00 00       	mov    $0x0,%edi
  804883:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  80488a:	00 00 00 
  80488d:	ff d0                	callq  *%rax
  80488f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804892:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804896:	79 05                	jns    80489d <opencons+0x54>
		return r;
  804898:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80489b:	eb 30                	jmp    8048cd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80489d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048a1:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8048a8:	00 00 00 
  8048ab:	8b 12                	mov    (%rdx),%edx
  8048ad:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8048af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048b3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8048ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048be:	48 89 c7             	mov    %rax,%rdi
  8048c1:	48 b8 af 29 80 00 00 	movabs $0x8029af,%rax
  8048c8:	00 00 00 
  8048cb:	ff d0                	callq  *%rax
}
  8048cd:	c9                   	leaveq 
  8048ce:	c3                   	retq   

00000000008048cf <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8048cf:	55                   	push   %rbp
  8048d0:	48 89 e5             	mov    %rsp,%rbp
  8048d3:	48 83 ec 30          	sub    $0x30,%rsp
  8048d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8048db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8048df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8048e3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048e8:	75 07                	jne    8048f1 <devcons_read+0x22>
		return 0;
  8048ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8048ef:	eb 4b                	jmp    80493c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8048f1:	eb 0c                	jmp    8048ff <devcons_read+0x30>
		sys_yield();
  8048f3:	48 b8 b4 1d 80 00 00 	movabs $0x801db4,%rax
  8048fa:	00 00 00 
  8048fd:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8048ff:	48 b8 f4 1c 80 00 00 	movabs $0x801cf4,%rax
  804906:	00 00 00 
  804909:	ff d0                	callq  *%rax
  80490b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80490e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804912:	74 df                	je     8048f3 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804914:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804918:	79 05                	jns    80491f <devcons_read+0x50>
		return c;
  80491a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80491d:	eb 1d                	jmp    80493c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80491f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804923:	75 07                	jne    80492c <devcons_read+0x5d>
		return 0;
  804925:	b8 00 00 00 00       	mov    $0x0,%eax
  80492a:	eb 10                	jmp    80493c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80492c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80492f:	89 c2                	mov    %eax,%edx
  804931:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804935:	88 10                	mov    %dl,(%rax)
	return 1;
  804937:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80493c:	c9                   	leaveq 
  80493d:	c3                   	retq   

000000000080493e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80493e:	55                   	push   %rbp
  80493f:	48 89 e5             	mov    %rsp,%rbp
  804942:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804949:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804950:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804957:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80495e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804965:	eb 76                	jmp    8049dd <devcons_write+0x9f>
		m = n - tot;
  804967:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80496e:	89 c2                	mov    %eax,%edx
  804970:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804973:	29 c2                	sub    %eax,%edx
  804975:	89 d0                	mov    %edx,%eax
  804977:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80497a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80497d:	83 f8 7f             	cmp    $0x7f,%eax
  804980:	76 07                	jbe    804989 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804982:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804989:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80498c:	48 63 d0             	movslq %eax,%rdx
  80498f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804992:	48 63 c8             	movslq %eax,%rcx
  804995:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80499c:	48 01 c1             	add    %rax,%rcx
  80499f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8049a6:	48 89 ce             	mov    %rcx,%rsi
  8049a9:	48 89 c7             	mov    %rax,%rdi
  8049ac:	48 b8 e7 17 80 00 00 	movabs $0x8017e7,%rax
  8049b3:	00 00 00 
  8049b6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8049b8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8049bb:	48 63 d0             	movslq %eax,%rdx
  8049be:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8049c5:	48 89 d6             	mov    %rdx,%rsi
  8049c8:	48 89 c7             	mov    %rax,%rdi
  8049cb:	48 b8 aa 1c 80 00 00 	movabs $0x801caa,%rax
  8049d2:	00 00 00 
  8049d5:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8049d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8049da:	01 45 fc             	add    %eax,-0x4(%rbp)
  8049dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049e0:	48 98                	cltq   
  8049e2:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8049e9:	0f 82 78 ff ff ff    	jb     804967 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8049ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8049f2:	c9                   	leaveq 
  8049f3:	c3                   	retq   

00000000008049f4 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8049f4:	55                   	push   %rbp
  8049f5:	48 89 e5             	mov    %rsp,%rbp
  8049f8:	48 83 ec 08          	sub    $0x8,%rsp
  8049fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804a00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a05:	c9                   	leaveq 
  804a06:	c3                   	retq   

0000000000804a07 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804a07:	55                   	push   %rbp
  804a08:	48 89 e5             	mov    %rsp,%rbp
  804a0b:	48 83 ec 10          	sub    $0x10,%rsp
  804a0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804a13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804a17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a1b:	48 be 25 55 80 00 00 	movabs $0x805525,%rsi
  804a22:	00 00 00 
  804a25:	48 89 c7             	mov    %rax,%rdi
  804a28:	48 b8 c3 14 80 00 00 	movabs $0x8014c3,%rax
  804a2f:	00 00 00 
  804a32:	ff d0                	callq  *%rax
	return 0;
  804a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a39:	c9                   	leaveq 
  804a3a:	c3                   	retq   

0000000000804a3b <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804a3b:	55                   	push   %rbp
  804a3c:	48 89 e5             	mov    %rsp,%rbp
  804a3f:	48 83 ec 10          	sub    $0x10,%rsp
  804a43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804a47:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a4e:	00 00 00 
  804a51:	48 8b 00             	mov    (%rax),%rax
  804a54:	48 85 c0             	test   %rax,%rax
  804a57:	0f 85 84 00 00 00    	jne    804ae1 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804a5d:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804a64:	00 00 00 
  804a67:	48 8b 00             	mov    (%rax),%rax
  804a6a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804a70:	ba 07 00 00 00       	mov    $0x7,%edx
  804a75:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804a7a:	89 c7                	mov    %eax,%edi
  804a7c:	48 b8 f2 1d 80 00 00 	movabs $0x801df2,%rax
  804a83:	00 00 00 
  804a86:	ff d0                	callq  *%rax
  804a88:	85 c0                	test   %eax,%eax
  804a8a:	79 2a                	jns    804ab6 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804a8c:	48 ba 30 55 80 00 00 	movabs $0x805530,%rdx
  804a93:	00 00 00 
  804a96:	be 23 00 00 00       	mov    $0x23,%esi
  804a9b:	48 bf 57 55 80 00 00 	movabs $0x805557,%rdi
  804aa2:	00 00 00 
  804aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  804aaa:	48 b9 d5 06 80 00 00 	movabs $0x8006d5,%rcx
  804ab1:	00 00 00 
  804ab4:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804ab6:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804abd:	00 00 00 
  804ac0:	48 8b 00             	mov    (%rax),%rax
  804ac3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804ac9:	48 be f4 4a 80 00 00 	movabs $0x804af4,%rsi
  804ad0:	00 00 00 
  804ad3:	89 c7                	mov    %eax,%edi
  804ad5:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  804adc:	00 00 00 
  804adf:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804ae1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804ae8:	00 00 00 
  804aeb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804aef:	48 89 10             	mov    %rdx,(%rax)
}
  804af2:	c9                   	leaveq 
  804af3:	c3                   	retq   

0000000000804af4 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804af4:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804af7:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804afe:	00 00 00 
call *%rax
  804b01:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804b03:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804b0a:	00 
	movq 152(%rsp), %rcx  //Load RSP
  804b0b:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804b12:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804b13:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804b17:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  804b1a:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804b21:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804b22:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804b26:	4c 8b 3c 24          	mov    (%rsp),%r15
  804b2a:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804b2f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804b34:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804b39:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804b3e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804b43:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804b48:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804b4d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804b52:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804b57:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804b5c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804b61:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804b66:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804b6b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804b70:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804b74:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804b78:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804b79:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804b7a:	c3                   	retq   

0000000000804b7b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804b7b:	55                   	push   %rbp
  804b7c:	48 89 e5             	mov    %rsp,%rbp
  804b7f:	48 83 ec 18          	sub    $0x18,%rsp
  804b83:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804b87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b8b:	48 c1 e8 15          	shr    $0x15,%rax
  804b8f:	48 89 c2             	mov    %rax,%rdx
  804b92:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804b99:	01 00 00 
  804b9c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ba0:	83 e0 01             	and    $0x1,%eax
  804ba3:	48 85 c0             	test   %rax,%rax
  804ba6:	75 07                	jne    804baf <pageref+0x34>
		return 0;
  804ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  804bad:	eb 53                	jmp    804c02 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804baf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804bb3:	48 c1 e8 0c          	shr    $0xc,%rax
  804bb7:	48 89 c2             	mov    %rax,%rdx
  804bba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804bc1:	01 00 00 
  804bc4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804bc8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804bcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bd0:	83 e0 01             	and    $0x1,%eax
  804bd3:	48 85 c0             	test   %rax,%rax
  804bd6:	75 07                	jne    804bdf <pageref+0x64>
		return 0;
  804bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  804bdd:	eb 23                	jmp    804c02 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804bdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804be3:	48 c1 e8 0c          	shr    $0xc,%rax
  804be7:	48 89 c2             	mov    %rax,%rdx
  804bea:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804bf1:	00 00 00 
  804bf4:	48 c1 e2 04          	shl    $0x4,%rdx
  804bf8:	48 01 d0             	add    %rdx,%rax
  804bfb:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804bff:	0f b7 c0             	movzwl %ax,%eax
}
  804c02:	c9                   	leaveq 
  804c03:	c3                   	retq   
