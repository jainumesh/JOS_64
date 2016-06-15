
obj/net/testinput:     file format elf64-x86-64


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
  80003c:	e8 67 0a 00 00       	callq  800aa8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <announce>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    static void
announce(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
    // with ARP requests.  Ideally, we would use gratuitous ARP
    // for this, but QEMU's ARP implementation is dumb and only
    // listens for very specific ARP requests, such as requests
    // for the gateway IP.

    uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80004b:	c6 45 e0 52          	movb   $0x52,-0x20(%rbp)
  80004f:	c6 45 e1 54          	movb   $0x54,-0x1f(%rbp)
  800053:	c6 45 e2 00          	movb   $0x0,-0x1e(%rbp)
  800057:	c6 45 e3 12          	movb   $0x12,-0x1d(%rbp)
  80005b:	c6 45 e4 34          	movb   $0x34,-0x1c(%rbp)
  80005f:	c6 45 e5 56          	movb   $0x56,-0x1b(%rbp)
    uint32_t myip = inet_addr(IP);
  800063:	48 bf 40 55 80 00 00 	movabs $0x805540,%rdi
  80006a:	00 00 00 
  80006d:	48 b8 85 50 80 00 00 	movabs $0x805085,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 dc             	mov    %eax,-0x24(%rbp)
    uint32_t gwip = inet_addr(DEFAULT);
  80007c:	48 bf 4a 55 80 00 00 	movabs $0x80554a,%rdi
  800083:	00 00 00 
  800086:	48 b8 85 50 80 00 00 	movabs $0x805085,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	89 45 d8             	mov    %eax,-0x28(%rbp)
    int r;

    if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800095:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80009c:	00 00 00 
  80009f:	48 8b 00             	mov    (%rax),%rax
  8000a2:	ba 07 00 00 00       	mov    $0x7,%edx
  8000a7:	48 89 c6             	mov    %rax,%rsi
  8000aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8000af:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
  8000bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c2:	79 30                	jns    8000f4 <announce+0xb1>
        panic("sys_page_map: %e", r);
  8000c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c7:	89 c1                	mov    %eax,%ecx
  8000c9:	48 ba 53 55 80 00 00 	movabs $0x805553,%rdx
  8000d0:	00 00 00 
  8000d3:	be 19 00 00 00       	mov    $0x19,%esi
  8000d8:	48 bf 64 55 80 00 00 	movabs $0x805564,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	49 b8 56 0b 80 00 00 	movabs $0x800b56,%r8
  8000ee:	00 00 00 
  8000f1:	41 ff d0             	callq  *%r8

    struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
  8000f4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8000fb:	00 00 00 
  8000fe:	48 8b 00             	mov    (%rax),%rax
  800101:	48 83 c0 04          	add    $0x4,%rax
  800105:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    pkt->jp_len = sizeof(*arp);
  800109:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800110:	00 00 00 
  800113:	48 8b 00             	mov    (%rax),%rax
  800116:	c7 00 2a 00 00 00    	movl   $0x2a,(%rax)

    memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  80011c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800120:	ba 06 00 00 00       	mov    $0x6,%edx
  800125:	be ff 00 00 00       	mov    $0xff,%esi
  80012a:	48 89 c7             	mov    %rax,%rdi
  80012d:	48 b8 dd 1b 80 00 00 	movabs $0x801bdd,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
    memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  800139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80013d:	48 8d 48 06          	lea    0x6(%rax),%rcx
  800141:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800145:	ba 06 00 00 00       	mov    $0x6,%edx
  80014a:	48 89 c6             	mov    %rax,%rsi
  80014d:	48 89 cf             	mov    %rcx,%rdi
  800150:	48 b8 7f 1d 80 00 00 	movabs $0x801d7f,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
    arp->ethhdr.type = htons(ETHTYPE_ARP);
  80015c:	bf 06 08 00 00       	mov    $0x806,%edi
  800161:	48 b8 94 54 80 00 00 	movabs $0x805494,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800171:	66 89 42 0c          	mov    %ax,0xc(%rdx)
    arp->hwtype = htons(1); // Ethernet
  800175:	bf 01 00 00 00       	mov    $0x1,%edi
  80017a:	48 b8 94 54 80 00 00 	movabs $0x805494,%rax
  800181:	00 00 00 
  800184:	ff d0                	callq  *%rax
  800186:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018a:	66 89 42 0e          	mov    %ax,0xe(%rdx)
    arp->proto = htons(ETHTYPE_IP);
  80018e:	bf 00 08 00 00       	mov    $0x800,%edi
  800193:	48 b8 94 54 80 00 00 	movabs $0x805494,%rax
  80019a:	00 00 00 
  80019d:	ff d0                	callq  *%rax
  80019f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a3:	66 89 42 10          	mov    %ax,0x10(%rdx)
    arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001a7:	bf 04 06 00 00       	mov    $0x604,%edi
  8001ac:	48 b8 94 54 80 00 00 	movabs $0x805494,%rax
  8001b3:	00 00 00 
  8001b6:	ff d0                	callq  *%rax
  8001b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bc:	66 89 42 12          	mov    %ax,0x12(%rdx)
    arp->opcode = htons(ARP_REQUEST);
  8001c0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001c5:	48 b8 94 54 80 00 00 	movabs $0x805494,%rax
  8001cc:	00 00 00 
  8001cf:	ff d0                	callq  *%rax
  8001d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d5:	66 89 42 14          	mov    %ax,0x14(%rdx)
    memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001dd:	48 8d 48 16          	lea    0x16(%rax),%rcx
  8001e1:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001e5:	ba 06 00 00 00       	mov    $0x6,%edx
  8001ea:	48 89 c6             	mov    %rax,%rsi
  8001ed:	48 89 cf             	mov    %rcx,%rdi
  8001f0:	48 b8 7f 1d 80 00 00 	movabs $0x801d7f,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax
    memcpy(arp->sipaddr.addrw, &myip, 4);
  8001fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800200:	48 8d 48 1c          	lea    0x1c(%rax),%rcx
  800204:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
  800208:	ba 04 00 00 00       	mov    $0x4,%edx
  80020d:	48 89 c6             	mov    %rax,%rsi
  800210:	48 89 cf             	mov    %rcx,%rdi
  800213:	48 b8 7f 1d 80 00 00 	movabs $0x801d7f,%rax
  80021a:	00 00 00 
  80021d:	ff d0                	callq  *%rax
    memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  80021f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800223:	48 83 c0 20          	add    $0x20,%rax
  800227:	ba 06 00 00 00       	mov    $0x6,%edx
  80022c:	be 00 00 00 00       	mov    $0x0,%esi
  800231:	48 89 c7             	mov    %rax,%rdi
  800234:	48 b8 dd 1b 80 00 00 	movabs $0x801bdd,%rax
  80023b:	00 00 00 
  80023e:	ff d0                	callq  *%rax
    memcpy(arp->dipaddr.addrw, &gwip, 4);
  800240:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800244:	48 8d 48 26          	lea    0x26(%rax),%rcx
  800248:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80024c:	ba 04 00 00 00       	mov    $0x4,%edx
  800251:	48 89 c6             	mov    %rax,%rsi
  800254:	48 89 cf             	mov    %rcx,%rdi
  800257:	48 b8 7f 1d 80 00 00 	movabs $0x801d7f,%rax
  80025e:	00 00 00 
  800261:	ff d0                	callq  *%rax

    ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800263:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80026a:	00 00 00 
  80026d:	48 8b 10             	mov    (%rax),%rdx
  800270:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800277:	00 00 00 
  80027a:	8b 00                	mov    (%rax),%eax
  80027c:	b9 07 00 00 00       	mov    $0x7,%ecx
  800281:	be 0b 00 00 00       	mov    $0xb,%esi
  800286:	89 c7                	mov    %eax,%edi
  800288:	48 b8 4c 2d 80 00 00 	movabs $0x802d4c,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
    sys_page_unmap(0, pkt);
  800294:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80029b:	00 00 00 
  80029e:	48 8b 00             	mov    (%rax),%rax
  8002a1:	48 89 c6             	mov    %rax,%rsi
  8002a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002a9:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  8002b0:	00 00 00 
  8002b3:	ff d0                	callq  *%rax
}
  8002b5:	c9                   	leaveq 
  8002b6:	c3                   	retq   

00000000008002b7 <hexdump>:

    static void
hexdump(const char *prefix, const void *data, int len)
{
  8002b7:	55                   	push   %rbp
  8002b8:	48 89 e5             	mov    %rsp,%rbp
  8002bb:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  8002c2:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
  8002c6:	48 89 75 80          	mov    %rsi,-0x80(%rbp)
  8002ca:	89 95 7c ff ff ff    	mov    %edx,-0x84(%rbp)
    int i;
    char buf[80];
    char *end = buf + sizeof(buf);
  8002d0:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8002d4:	48 83 c0 50          	add    $0x50,%rax
  8002d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    char *out = NULL;
  8002dc:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8002e3:	00 
    for (i = 0; i < len; i++) {
  8002e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8002eb:	e9 41 01 00 00       	jmpq   800431 <hexdump+0x17a>
        if (i % 16 == 0)
  8002f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002f3:	83 e0 0f             	and    $0xf,%eax
  8002f6:	85 c0                	test   %eax,%eax
  8002f8:	75 4d                	jne    800347 <hexdump+0x90>
            out = buf + snprintf(buf, end - buf,
  8002fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8002fe:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800302:	48 29 c2             	sub    %rax,%rdx
  800305:	48 89 d0             	mov    %rdx,%rax
  800308:	89 c6                	mov    %eax,%esi
  80030a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80030d:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  800311:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800315:	41 89 c8             	mov    %ecx,%r8d
  800318:	48 89 d1             	mov    %rdx,%rcx
  80031b:	48 ba 74 55 80 00 00 	movabs $0x805574,%rdx
  800322:	00 00 00 
  800325:	48 89 c7             	mov    %rax,%rdi
  800328:	b8 00 00 00 00       	mov    $0x0,%eax
  80032d:	49 b9 f7 17 80 00 00 	movabs $0x8017f7,%r9
  800334:	00 00 00 
  800337:	41 ff d1             	callq  *%r9
  80033a:	48 98                	cltq   
  80033c:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  800340:	48 01 d0             	add    %rdx,%rax
  800343:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                    "%s%04x   ", prefix, i);
        out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  800347:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034a:	48 63 d0             	movslq %eax,%rdx
  80034d:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  800351:	48 01 d0             	add    %rdx,%rax
  800354:	0f b6 00             	movzbl (%rax),%eax
  800357:	0f b6 d0             	movzbl %al,%edx
  80035a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80035e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800362:	48 29 c1             	sub    %rax,%rcx
  800365:	48 89 c8             	mov    %rcx,%rax
  800368:	89 c6                	mov    %eax,%esi
  80036a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036e:	89 d1                	mov    %edx,%ecx
  800370:	48 ba 7e 55 80 00 00 	movabs $0x80557e,%rdx
  800377:	00 00 00 
  80037a:	48 89 c7             	mov    %rax,%rdi
  80037d:	b8 00 00 00 00       	mov    $0x0,%eax
  800382:	49 b8 f7 17 80 00 00 	movabs $0x8017f7,%r8
  800389:	00 00 00 
  80038c:	41 ff d0             	callq  *%r8
  80038f:	48 98                	cltq   
  800391:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        if (i % 16 == 15 || i == len - 1)
  800395:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800398:	99                   	cltd   
  800399:	c1 ea 1c             	shr    $0x1c,%edx
  80039c:	01 d0                	add    %edx,%eax
  80039e:	83 e0 0f             	and    $0xf,%eax
  8003a1:	29 d0                	sub    %edx,%eax
  8003a3:	83 f8 0f             	cmp    $0xf,%eax
  8003a6:	74 0e                	je     8003b6 <hexdump+0xff>
  8003a8:	8b 85 7c ff ff ff    	mov    -0x84(%rbp),%eax
  8003ae:	83 e8 01             	sub    $0x1,%eax
  8003b1:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8003b4:	75 33                	jne    8003e9 <hexdump+0x132>
            cprintf("%.*s\n", out - buf, buf);
  8003b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ba:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8003be:	48 89 d1             	mov    %rdx,%rcx
  8003c1:	48 29 c1             	sub    %rax,%rcx
  8003c4:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8003c8:	48 89 c2             	mov    %rax,%rdx
  8003cb:	48 89 ce             	mov    %rcx,%rsi
  8003ce:	48 bf 83 55 80 00 00 	movabs $0x805583,%rdi
  8003d5:	00 00 00 
  8003d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003dd:	48 b9 8f 0d 80 00 00 	movabs $0x800d8f,%rcx
  8003e4:	00 00 00 
  8003e7:	ff d1                	callq  *%rcx
        if (i % 2 == 1)
  8003e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003ec:	99                   	cltd   
  8003ed:	c1 ea 1f             	shr    $0x1f,%edx
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	83 e0 01             	and    $0x1,%eax
  8003f5:	29 d0                	sub    %edx,%eax
  8003f7:	83 f8 01             	cmp    $0x1,%eax
  8003fa:	75 0f                	jne    80040b <hexdump+0x154>
            *(out++) = ' ';
  8003fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800400:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800404:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  800408:	c6 00 20             	movb   $0x20,(%rax)
        if (i % 16 == 7)
  80040b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040e:	99                   	cltd   
  80040f:	c1 ea 1c             	shr    $0x1c,%edx
  800412:	01 d0                	add    %edx,%eax
  800414:	83 e0 0f             	and    $0xf,%eax
  800417:	29 d0                	sub    %edx,%eax
  800419:	83 f8 07             	cmp    $0x7,%eax
  80041c:	75 0f                	jne    80042d <hexdump+0x176>
            *(out++) = ' ';
  80041e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800422:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800426:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80042a:	c6 00 20             	movb   $0x20,(%rax)
{
    int i;
    char buf[80];
    char *end = buf + sizeof(buf);
    char *out = NULL;
    for (i = 0; i < len; i++) {
  80042d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800434:	3b 85 7c ff ff ff    	cmp    -0x84(%rbp),%eax
  80043a:	0f 8c b0 fe ff ff    	jl     8002f0 <hexdump+0x39>
        if (i % 2 == 1)
            *(out++) = ' ';
        if (i % 16 == 7)
            *(out++) = ' ';
    }
}
  800440:	c9                   	leaveq 
  800441:	c3                   	retq   

0000000000800442 <umain>:

    void
umain(int argc, char **argv)
{
  800442:	55                   	push   %rbp
  800443:	48 89 e5             	mov    %rsp,%rbp
  800446:	53                   	push   %rbx
  800447:	48 83 ec 38          	sub    $0x38,%rsp
  80044b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80044e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
    envid_t ns_envid = sys_getenvid();
  800452:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  800459:	00 00 00 
  80045c:	ff d0                	callq  *%rax
  80045e:	89 45 e8             	mov    %eax,-0x18(%rbp)
    int i, r, first = 1;
  800461:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)

    binaryname = "testinput";
  800468:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80046f:	00 00 00 
  800472:	48 bb 89 55 80 00 00 	movabs $0x805589,%rbx
  800479:	00 00 00 
  80047c:	48 89 18             	mov    %rbx,(%rax)

    output_envid = fork();
  80047f:	48 b8 95 29 80 00 00 	movabs $0x802995,%rax
  800486:	00 00 00 
  800489:	ff d0                	callq  *%rax
  80048b:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  800492:	00 00 00 
  800495:	89 02                	mov    %eax,(%rdx)
    if (output_envid < 0)
  800497:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80049e:	00 00 00 
  8004a1:	8b 00                	mov    (%rax),%eax
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	79 2a                	jns    8004d1 <umain+0x8f>
        panic("error forking");
  8004a7:	48 ba 93 55 80 00 00 	movabs $0x805593,%rdx
  8004ae:	00 00 00 
  8004b1:	be 4d 00 00 00       	mov    $0x4d,%esi
  8004b6:	48 bf 64 55 80 00 00 	movabs $0x805564,%rdi
  8004bd:	00 00 00 
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  8004cc:	00 00 00 
  8004cf:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8004d1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8004d8:	00 00 00 
  8004db:	8b 00                	mov    (%rax),%eax
  8004dd:	85 c0                	test   %eax,%eax
  8004df:	75 16                	jne    8004f7 <umain+0xb5>
        output(ns_envid);
  8004e1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 20 09 80 00 00 	movabs $0x800920,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
        return;
  8004f2:	e9 fb 01 00 00       	jmpq   8006f2 <umain+0x2b0>
    }

    input_envid = fork();
  8004f7:	48 b8 95 29 80 00 00 	movabs $0x802995,%rax
  8004fe:	00 00 00 
  800501:	ff d0                	callq  *%rax
  800503:	48 ba 04 90 80 00 00 	movabs $0x809004,%rdx
  80050a:	00 00 00 
  80050d:	89 02                	mov    %eax,(%rdx)
    if (input_envid < 0)
  80050f:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  800516:	00 00 00 
  800519:	8b 00                	mov    (%rax),%eax
  80051b:	85 c0                	test   %eax,%eax
  80051d:	79 2a                	jns    800549 <umain+0x107>
        panic("error forking");
  80051f:	48 ba 93 55 80 00 00 	movabs $0x805593,%rdx
  800526:	00 00 00 
  800529:	be 55 00 00 00       	mov    $0x55,%esi
  80052e:	48 bf 64 55 80 00 00 	movabs $0x805564,%rdi
  800535:	00 00 00 
  800538:	b8 00 00 00 00       	mov    $0x0,%eax
  80053d:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  800544:	00 00 00 
  800547:	ff d1                	callq  *%rcx
    else if (input_envid == 0) {
  800549:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  800550:	00 00 00 
  800553:	8b 00                	mov    (%rax),%eax
  800555:	85 c0                	test   %eax,%eax
  800557:	75 16                	jne    80056f <umain+0x12d>
        input(ns_envid);
  800559:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80055c:	89 c7                	mov    %eax,%edi
  80055e:	48 b8 1a 08 80 00 00 	movabs $0x80081a,%rax
  800565:	00 00 00 
  800568:	ff d0                	callq  *%rax
        return;
  80056a:	e9 83 01 00 00       	jmpq   8006f2 <umain+0x2b0>
    }

    cprintf("Sending ARP announcement...\n");
  80056f:	48 bf a1 55 80 00 00 	movabs $0x8055a1,%rdi
  800576:	00 00 00 
  800579:	b8 00 00 00 00       	mov    $0x0,%eax
  80057e:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  800585:	00 00 00 
  800588:	ff d2                	callq  *%rdx
    announce();
  80058a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800591:	00 00 00 
  800594:	ff d0                	callq  *%rax

    while (1) {
        envid_t whom;
        int perm;

        int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  800596:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80059d:	00 00 00 
  8005a0:	48 8b 08             	mov    (%rax),%rcx
  8005a3:	48 8d 55 dc          	lea    -0x24(%rbp),%rdx
  8005a7:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8005ab:	48 89 ce             	mov    %rcx,%rsi
  8005ae:	48 89 c7             	mov    %rax,%rdi
  8005b1:	48 b8 46 2c 80 00 00 	movabs $0x802c46,%rax
  8005b8:	00 00 00 
  8005bb:	ff d0                	callq  *%rax
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
        if (req < 0)
  8005c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c4:	79 30                	jns    8005f6 <umain+0x1b4>
            panic("ipc_recv: %e", req);
  8005c6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005c9:	89 c1                	mov    %eax,%ecx
  8005cb:	48 ba be 55 80 00 00 	movabs $0x8055be,%rdx
  8005d2:	00 00 00 
  8005d5:	be 64 00 00 00       	mov    $0x64,%esi
  8005da:	48 bf 64 55 80 00 00 	movabs $0x805564,%rdi
  8005e1:	00 00 00 
  8005e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e9:	49 b8 56 0b 80 00 00 	movabs $0x800b56,%r8
  8005f0:	00 00 00 
  8005f3:	41 ff d0             	callq  *%r8
        if (whom != input_envid)
  8005f6:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8005f9:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  800600:	00 00 00 
  800603:	8b 00                	mov    (%rax),%eax
  800605:	39 c2                	cmp    %eax,%edx
  800607:	74 30                	je     800639 <umain+0x1f7>
            panic("IPC from unexpected environment %08x", whom);
  800609:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80060c:	89 c1                	mov    %eax,%ecx
  80060e:	48 ba d0 55 80 00 00 	movabs $0x8055d0,%rdx
  800615:	00 00 00 
  800618:	be 66 00 00 00       	mov    $0x66,%esi
  80061d:	48 bf 64 55 80 00 00 	movabs $0x805564,%rdi
  800624:	00 00 00 
  800627:	b8 00 00 00 00       	mov    $0x0,%eax
  80062c:	49 b8 56 0b 80 00 00 	movabs $0x800b56,%r8
  800633:	00 00 00 
  800636:	41 ff d0             	callq  *%r8
        if (req != NSREQ_INPUT)
  800639:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%rbp)
  80063d:	74 30                	je     80066f <umain+0x22d>
            panic("Unexpected IPC %d", req);
  80063f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800642:	89 c1                	mov    %eax,%ecx
  800644:	48 ba f5 55 80 00 00 	movabs $0x8055f5,%rdx
  80064b:	00 00 00 
  80064e:	be 68 00 00 00       	mov    $0x68,%esi
  800653:	48 bf 64 55 80 00 00 	movabs $0x805564,%rdi
  80065a:	00 00 00 
  80065d:	b8 00 00 00 00       	mov    $0x0,%eax
  800662:	49 b8 56 0b 80 00 00 	movabs $0x800b56,%r8
  800669:	00 00 00 
  80066c:	41 ff d0             	callq  *%r8

        hexdump("input: ", pkt->jp_data, pkt->jp_len);
  80066f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800676:	00 00 00 
  800679:	48 8b 00             	mov    (%rax),%rax
  80067c:	8b 00                	mov    (%rax),%eax
  80067e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  800685:	00 00 00 
  800688:	48 8b 12             	mov    (%rdx),%rdx
  80068b:	48 8d 4a 04          	lea    0x4(%rdx),%rcx
  80068f:	89 c2                	mov    %eax,%edx
  800691:	48 89 ce             	mov    %rcx,%rsi
  800694:	48 bf 07 56 80 00 00 	movabs $0x805607,%rdi
  80069b:	00 00 00 
  80069e:	48 b8 b7 02 80 00 00 	movabs $0x8002b7,%rax
  8006a5:	00 00 00 
  8006a8:	ff d0                	callq  *%rax
        cprintf("\n");
  8006aa:	48 bf 0f 56 80 00 00 	movabs $0x80560f,%rdi
  8006b1:	00 00 00 
  8006b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b9:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  8006c0:	00 00 00 
  8006c3:	ff d2                	callq  *%rdx

        // Only indicate that we're waiting for packets once
        // we've received the ARP reply
        if (first)
  8006c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8006c9:	74 1b                	je     8006e6 <umain+0x2a4>
            cprintf("Waiting for packets...\n");
  8006cb:	48 bf 11 56 80 00 00 	movabs $0x805611,%rdi
  8006d2:	00 00 00 
  8006d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006da:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  8006e1:	00 00 00 
  8006e4:	ff d2                	callq  *%rdx
        first = 0;
  8006e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
  8006ed:	e9 a4 fe ff ff       	jmpq   800596 <umain+0x154>
}
  8006f2:	48 83 c4 38          	add    $0x38,%rsp
  8006f6:	5b                   	pop    %rbx
  8006f7:	5d                   	pop    %rbp
  8006f8:	c3                   	retq   

00000000008006f9 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  8006f9:	55                   	push   %rbp
  8006fa:	48 89 e5             	mov    %rsp,%rbp
  8006fd:	53                   	push   %rbx
  8006fe:	48 83 ec 28          	sub    $0x28,%rsp
  800702:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800705:	89 75 d8             	mov    %esi,-0x28(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  800708:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  80070f:	00 00 00 
  800712:	ff d0                	callq  *%rax
  800714:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800717:	01 d0                	add    %edx,%eax
  800719:	89 45 ec             	mov    %eax,-0x14(%rbp)

    binaryname = "ns_timer";
  80071c:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800723:	00 00 00 
  800726:	48 bb 30 56 80 00 00 	movabs $0x805630,%rbx
  80072d:	00 00 00 
  800730:	48 89 18             	mov    %rbx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800733:	eb 0c                	jmp    800741 <timer+0x48>
            sys_yield();
  800735:	48 b8 35 22 80 00 00 	movabs $0x802235,%rax
  80073c:	00 00 00 
  80073f:	ff d0                	callq  *%rax
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800741:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  800748:	00 00 00 
  80074b:	ff d0                	callq  *%rax
  80074d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800750:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800753:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800756:	73 06                	jae    80075e <timer+0x65>
  800758:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80075c:	79 d7                	jns    800735 <timer+0x3c>
            sys_yield();
        }
        if (r < 0)
  80075e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800762:	79 30                	jns    800794 <timer+0x9b>
            panic("sys_time_msec: %e", r);
  800764:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800767:	89 c1                	mov    %eax,%ecx
  800769:	48 ba 39 56 80 00 00 	movabs $0x805639,%rdx
  800770:	00 00 00 
  800773:	be 0f 00 00 00       	mov    $0xf,%esi
  800778:	48 bf 4b 56 80 00 00 	movabs $0x80564b,%rdi
  80077f:	00 00 00 
  800782:	b8 00 00 00 00       	mov    $0x0,%eax
  800787:	49 b8 56 0b 80 00 00 	movabs $0x800b56,%r8
  80078e:	00 00 00 
  800791:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  800794:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800797:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079c:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a1:	be 0c 00 00 00       	mov    $0xc,%esi
  8007a6:	89 c7                	mov    %eax,%edi
  8007a8:	48 b8 4c 2d 80 00 00 	movabs $0x802d4c,%rax
  8007af:	00 00 00 
  8007b2:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  8007b4:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bd:	be 00 00 00 00       	mov    $0x0,%esi
  8007c2:	48 89 c7             	mov    %rax,%rdi
  8007c5:	48 b8 46 2c 80 00 00 	movabs $0x802c46,%rax
  8007cc:	00 00 00 
  8007cf:	ff d0                	callq  *%rax
  8007d1:	89 45 e4             	mov    %eax,-0x1c(%rbp)

            if (whom != ns_envid) {
  8007d4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8007d7:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007da:	39 c2                	cmp    %eax,%edx
  8007dc:	74 22                	je     800800 <timer+0x107>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8007de:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007e1:	89 c6                	mov    %eax,%esi
  8007e3:	48 bf 58 56 80 00 00 	movabs $0x805658,%rdi
  8007ea:	00 00 00 
  8007ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f2:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  8007f9:	00 00 00 
  8007fc:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  8007fe:	eb b4                	jmp    8007b4 <timer+0xbb>
            if (whom != ns_envid) {
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
                continue;
            }

            stop = sys_time_msec() + to;
  800800:	48 b8 6e 25 80 00 00 	movabs $0x80256e,%rax
  800807:	00 00 00 
  80080a:	ff d0                	callq  *%rax
  80080c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80080f:	01 d0                	add    %edx,%eax
  800811:	89 45 ec             	mov    %eax,-0x14(%rbp)
            break;
        }
    }
  800814:	90                   	nop
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800815:	e9 27 ff ff ff       	jmpq   800741 <timer+0x48>

000000000080081a <input>:

#define debug 0

void
input(envid_t ns_envid)
{
  80081a:	55                   	push   %rbp
  80081b:	48 89 e5             	mov    %rsp,%rbp
  80081e:	53                   	push   %rbx
  80081f:	48 81 ec 28 08 00 00 	sub    $0x828,%rsp
  800826:	89 bd dc f7 ff ff    	mov    %edi,-0x824(%rbp)
    binaryname = "ns_input";
  80082c:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800833:	00 00 00 
  800836:	48 bb 93 56 80 00 00 	movabs $0x805693,%rbx
  80083d:	00 00 00 
  800840:	48 89 18             	mov    %rbx,(%rax)
		//If allocating new page each time		
        //sys_page_unmap(0, &nsipcbuf.pkt.jp_data);
	}
#else
	char buf[2048];
	int perm = PTE_U | PTE_P | PTE_W; //This is needed for page allocation from kern to user environment. (Remember no transfer can happen (that is sys_page_map)
  800843:	c7 45 ec 07 00 00 00 	movl   $0x7,-0x14(%rbp)
	int len = 2047; // Buffer length
  80084a:	c7 45 e8 ff 07 00 00 	movl   $0x7ff,-0x18(%rbp)
	int r = 0;
  800851:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
	while (1) {
		while ((r = sys_net_rx(&buf)) < 0) {
  800858:	eb 0c                	jmp    800866 <input+0x4c>
			sys_yield(); //This was neat.
  80085a:	48 b8 35 22 80 00 00 	movabs $0x802235,%rax
  800861:	00 00 00 
  800864:	ff d0                	callq  *%rax
	char buf[2048];
	int perm = PTE_U | PTE_P | PTE_W; //This is needed for page allocation from kern to user environment. (Remember no transfer can happen (that is sys_page_map)
	int len = 2047; // Buffer length
	int r = 0;
	while (1) {
		while ((r = sys_net_rx(&buf)) < 0) {
  800866:	48 8d 85 e0 f7 ff ff 	lea    -0x820(%rbp),%rax
  80086d:	48 89 c7             	mov    %rax,%rdi
  800870:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  800877:	00 00 00 
  80087a:	ff d0                	callq  *%rax
  80087c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800883:	78 d5                	js     80085a <input+0x40>
			sys_yield(); //This was neat.
		}
		len = r;
  800885:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800888:	89 45 e8             	mov    %eax,-0x18(%rbp)
		// Get the page received from the PCI. (Don't use sys_page_map..use alloc)
		while ((r = sys_page_alloc(0, &nsipcbuf, perm)) < 0);
  80088b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80088e:	89 c2                	mov    %eax,%edx
  800890:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  800897:	00 00 00 
  80089a:	bf 00 00 00 00       	mov    $0x0,%edi
  80089f:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8008a6:	00 00 00 
  8008a9:	ff d0                	callq  *%rax
  8008ab:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8008ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008b2:	78 d7                	js     80088b <input+0x71>
		nsipcbuf.pkt.jp_len = len;
  8008b4:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8008bb:	00 00 00 
  8008be:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8008c1:	89 10                	mov    %edx,(%rax)
		memmove(nsipcbuf.pkt.jp_data, buf, len);
  8008c3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8008c6:	48 63 d0             	movslq %eax,%rdx
  8008c9:	48 8d 85 e0 f7 ff ff 	lea    -0x820(%rbp),%rax
  8008d0:	48 89 c6             	mov    %rax,%rsi
  8008d3:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8008da:	00 00 00 
  8008dd:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  8008e4:	00 00 00 
  8008e7:	ff d0                	callq  *%rax
		while ((r = sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, perm)) < 0);
  8008e9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8008ec:	8b 85 dc f7 ff ff    	mov    -0x824(%rbp),%eax
  8008f2:	89 d1                	mov    %edx,%ecx
  8008f4:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  8008fb:	00 00 00 
  8008fe:	be 0a 00 00 00       	mov    $0xa,%esi
  800903:	89 c7                	mov    %eax,%edi
  800905:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  80090c:	00 00 00 
  80090f:	ff d0                	callq  *%rax
  800911:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800914:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800918:	78 cf                	js     8008e9 <input+0xcf>
	}
  80091a:	90                   	nop
	char buf[2048];
	int perm = PTE_U | PTE_P | PTE_W; //This is needed for page allocation from kern to user environment. (Remember no transfer can happen (that is sys_page_map)
	int len = 2047; // Buffer length
	int r = 0;
	while (1) {
		while ((r = sys_net_rx(&buf)) < 0) {
  80091b:	e9 46 ff ff ff       	jmpq   800866 <input+0x4c>

0000000000800920 <output>:
// Virtual address at which to receive page mappings containing client requests.
struct jif_pkt *sendReq = (struct jif_pkt *)(0x0ffff000 - PGSIZE);

void
output(envid_t ns_envid)
{
  800920:	55                   	push   %rbp
  800921:	48 89 e5             	mov    %rsp,%rbp
  800924:	53                   	push   %rbx
  800925:	48 83 ec 38          	sub    $0x38,%rsp
  800929:	89 7d cc             	mov    %edi,-0x34(%rbp)
    binaryname = "ns_output";
  80092c:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800933:	00 00 00 
  800936:	48 bb a0 56 80 00 00 	movabs $0x8056a0,%rbx
  80093d:	00 00 00 
  800940:	48 89 18             	mov    %rbx,(%rax)

    // LAB 6: Your code here:
    // 	- read a packet from the network server
    //	- send the packet to the device driver
#if 1
	void* buf = NULL;
  800943:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80094a:	00 
	size_t len = 0;
  80094b:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  800952:	00 
	//struct jif_pkt *sendReq;
	uint32_t req, whom;
	int perm, r;

	while (1) {
		perm = 0;
  800953:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%rbp)

		cprintf("output env id %d \n", thisenv->env_id);
  80095a:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800961:	00 00 00 
  800964:	48 8b 00             	mov    (%rax),%rax
  800967:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80096d:	89 c6                	mov    %eax,%esi
  80096f:	48 bf aa 56 80 00 00 	movabs $0x8056aa,%rdi
  800976:	00 00 00 
  800979:	b8 00 00 00 00       	mov    $0x0,%eax
  80097e:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  800985:	00 00 00 
  800988:	ff d2                	callq  *%rdx

		req = ipc_recv((int32_t *) &whom, sendReq, &perm);
  80098a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800991:	00 00 00 
  800994:	48 8b 08             	mov    (%rax),%rcx
  800997:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  80099b:	48 8d 45 d4          	lea    -0x2c(%rbp),%rax
  80099f:	48 89 ce             	mov    %rcx,%rsi
  8009a2:	48 89 c7             	mov    %rax,%rdi
  8009a5:	48 b8 46 2c 80 00 00 	movabs $0x802c46,%rax
  8009ac:	00 00 00 
  8009af:	ff d0                	callq  *%rax
  8009b1:	89 45 dc             	mov    %eax,-0x24(%rbp)
		while(thisenv->env_ipc_recving == 1)
  8009b4:	eb 0c                	jmp    8009c2 <output+0xa2>
			sys_yield();
  8009b6:	48 b8 35 22 80 00 00 	movabs $0x802235,%rax
  8009bd:	00 00 00 
  8009c0:	ff d0                	callq  *%rax
		perm = 0;

		cprintf("output env id %d \n", thisenv->env_id);

		req = ipc_recv((int32_t *) &whom, sendReq, &perm);
		while(thisenv->env_ipc_recving == 1)
  8009c2:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8009c9:	00 00 00 
  8009cc:	48 8b 00             	mov    (%rax),%rax
  8009cf:	0f b6 80 f8 00 00 00 	movzbl 0xf8(%rax),%eax
  8009d6:	84 c0                	test   %al,%al
  8009d8:	75 dc                	jne    8009b6 <output+0x96>
		if (debug)
			cprintf("net packet send req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(sendReq)], sendReq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  8009da:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8009dd:	83 e0 01             	and    $0x1,%eax
  8009e0:	85 c0                	test   %eax,%eax
  8009e2:	75 26                	jne    800a0a <output+0xea>
			cprintf("Invalid request from %08x: no argument page\n",
  8009e4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8009e7:	89 c6                	mov    %eax,%esi
  8009e9:	48 bf c0 56 80 00 00 	movabs $0x8056c0,%rdi
  8009f0:	00 00 00 
  8009f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f8:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  8009ff:	00 00 00 
  800a02:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  800a04:	90                   	nop
			continue;
		}
		while ((r = sys_net_tx(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0);		
		//cprintf("buffer %s len %d\n", nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
#endif		
    }
  800a05:	e9 49 ff ff ff       	jmpq   800953 <output+0x33>
			continue; // just leave it hanging...
		}
		//if(debug)
		//	cprintf("output data %s",sendReq->jp_data);

		if(req == NSREQ_OUTPUT)
  800a0a:	83 7d dc 0b          	cmpl   $0xb,-0x24(%rbp)
  800a0e:	75 48                	jne    800a58 <output+0x138>
		{	
			while(sys_net_tx((void*)sendReq->jp_data, sendReq->jp_len) != 0)
  800a10:	eb 0c                	jmp    800a1e <output+0xfe>
			{
				sys_yield();
  800a12:	48 b8 35 22 80 00 00 	movabs $0x802235,%rax
  800a19:	00 00 00 
  800a1c:	ff d0                	callq  *%rax
		//if(debug)
		//	cprintf("output data %s",sendReq->jp_data);

		if(req == NSREQ_OUTPUT)
		{	
			while(sys_net_tx((void*)sendReq->jp_data, sendReq->jp_len) != 0)
  800a1e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800a25:	00 00 00 
  800a28:	48 8b 00             	mov    (%rax),%rax
  800a2b:	8b 00                	mov    (%rax),%eax
  800a2d:	48 98                	cltq   
  800a2f:	48 ba 08 80 80 00 00 	movabs $0x808008,%rdx
  800a36:	00 00 00 
  800a39:	48 8b 12             	mov    (%rdx),%rdx
  800a3c:	48 83 c2 04          	add    $0x4,%rdx
  800a40:	48 89 c6             	mov    %rax,%rsi
  800a43:	48 89 d7             	mov    %rdx,%rdi
  800a46:	48 b8 e0 24 80 00 00 	movabs $0x8024e0,%rax
  800a4d:	00 00 00 
  800a50:	ff d0                	callq  *%rax
  800a52:	85 c0                	test   %eax,%eax
  800a54:	75 bc                	jne    800a12 <output+0xf2>
  800a56:	eb 2a                	jmp    800a82 <output+0x162>
			{
				sys_yield();
			}
		}else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  800a58:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  800a5b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a5e:	89 c6                	mov    %eax,%esi
  800a60:	48 bf f0 56 80 00 00 	movabs $0x8056f0,%rdi
  800a67:	00 00 00 
  800a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6f:	48 b9 8f 0d 80 00 00 	movabs $0x800d8f,%rcx
  800a76:	00 00 00 
  800a79:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  800a7b:	c7 45 d8 fd ff ff ff 	movl   $0xfffffffd,-0x28(%rbp)
		}
		
		if(debug)
			cprintf("Net Output: Sent packet to kernel %d to %x\n", r, whom);
		sys_page_unmap(0, sendReq);
  800a82:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800a89:	00 00 00 
  800a8c:	48 8b 00             	mov    (%rax),%rax
  800a8f:	48 89 c6             	mov    %rax,%rsi
  800a92:	bf 00 00 00 00       	mov    $0x0,%edi
  800a97:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  800a9e:	00 00 00 
  800aa1:	ff d0                	callq  *%rax
			continue;
		}
		while ((r = sys_net_tx(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0);		
		//cprintf("buffer %s len %d\n", nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
#endif		
    }
  800aa3:	e9 ab fe ff ff       	jmpq   800953 <output+0x33>

0000000000800aa8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800aa8:	55                   	push   %rbp
  800aa9:	48 89 e5             	mov    %rsp,%rbp
  800aac:	48 83 ec 10          	sub    $0x10,%rsp
  800ab0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ab3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800ab7:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  800abe:	00 00 00 
  800ac1:	ff d0                	callq  *%rax
  800ac3:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ac8:	48 63 d0             	movslq %eax,%rdx
  800acb:	48 89 d0             	mov    %rdx,%rax
  800ace:	48 c1 e0 03          	shl    $0x3,%rax
  800ad2:	48 01 d0             	add    %rdx,%rax
  800ad5:	48 c1 e0 05          	shl    $0x5,%rax
  800ad9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800ae0:	00 00 00 
  800ae3:	48 01 c2             	add    %rax,%rdx
  800ae6:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800aed:	00 00 00 
  800af0:	48 89 10             	mov    %rdx,(%rax)
	//cprintf("I am entering libmain\n");
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800af3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800af7:	7e 14                	jle    800b0d <libmain+0x65>
		binaryname = argv[0];
  800af9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800afd:	48 8b 10             	mov    (%rax),%rdx
  800b00:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800b07:	00 00 00 
  800b0a:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800b0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800b11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b14:	48 89 d6             	mov    %rdx,%rsi
  800b17:	89 c7                	mov    %eax,%edi
  800b19:	48 b8 42 04 80 00 00 	movabs $0x800442,%rax
  800b20:	00 00 00 
  800b23:	ff d0                	callq  *%rax
	// exit gracefully
	exit();
  800b25:	48 b8 33 0b 80 00 00 	movabs $0x800b33,%rax
  800b2c:	00 00 00 
  800b2f:	ff d0                	callq  *%rax
}
  800b31:	c9                   	leaveq 
  800b32:	c3                   	retq   

0000000000800b33 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800b33:	55                   	push   %rbp
  800b34:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800b37:	48 b8 71 31 80 00 00 	movabs $0x803171,%rax
  800b3e:	00 00 00 
  800b41:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800b43:	bf 00 00 00 00       	mov    $0x0,%edi
  800b48:	48 b8 b3 21 80 00 00 	movabs $0x8021b3,%rax
  800b4f:	00 00 00 
  800b52:	ff d0                	callq  *%rax

}
  800b54:	5d                   	pop    %rbp
  800b55:	c3                   	retq   

0000000000800b56 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800b56:	55                   	push   %rbp
  800b57:	48 89 e5             	mov    %rsp,%rbp
  800b5a:	53                   	push   %rbx
  800b5b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800b62:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800b69:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800b6f:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b76:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b7d:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b84:	84 c0                	test   %al,%al
  800b86:	74 23                	je     800bab <_panic+0x55>
  800b88:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b8f:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b93:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b97:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b9b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b9f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800ba3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800ba7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800bab:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bb2:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800bb9:	00 00 00 
  800bbc:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800bc3:	00 00 00 
  800bc6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bca:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800bd1:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800bd8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800bdf:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  800be6:	00 00 00 
  800be9:	48 8b 18             	mov    (%rax),%rbx
  800bec:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  800bf3:	00 00 00 
  800bf6:	ff d0                	callq  *%rax
  800bf8:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800bfe:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c05:	41 89 c8             	mov    %ecx,%r8d
  800c08:	48 89 d1             	mov    %rdx,%rcx
  800c0b:	48 89 da             	mov    %rbx,%rdx
  800c0e:	89 c6                	mov    %eax,%esi
  800c10:	48 bf 20 57 80 00 00 	movabs $0x805720,%rdi
  800c17:	00 00 00 
  800c1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1f:	49 b9 8f 0d 80 00 00 	movabs $0x800d8f,%r9
  800c26:	00 00 00 
  800c29:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800c2c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800c33:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800c3a:	48 89 d6             	mov    %rdx,%rsi
  800c3d:	48 89 c7             	mov    %rax,%rdi
  800c40:	48 b8 e3 0c 80 00 00 	movabs $0x800ce3,%rax
  800c47:	00 00 00 
  800c4a:	ff d0                	callq  *%rax
	cprintf("\n");
  800c4c:	48 bf 43 57 80 00 00 	movabs $0x805743,%rdi
  800c53:	00 00 00 
  800c56:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5b:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  800c62:	00 00 00 
  800c65:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c67:	cc                   	int3   
  800c68:	eb fd                	jmp    800c67 <_panic+0x111>

0000000000800c6a <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800c6a:	55                   	push   %rbp
  800c6b:	48 89 e5             	mov    %rsp,%rbp
  800c6e:	48 83 ec 10          	sub    $0x10,%rsp
  800c72:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c75:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800c79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c7d:	8b 00                	mov    (%rax),%eax
  800c7f:	8d 48 01             	lea    0x1(%rax),%ecx
  800c82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c86:	89 0a                	mov    %ecx,(%rdx)
  800c88:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c8b:	89 d1                	mov    %edx,%ecx
  800c8d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c91:	48 98                	cltq   
  800c93:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800c97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c9b:	8b 00                	mov    (%rax),%eax
  800c9d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ca2:	75 2c                	jne    800cd0 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800ca4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca8:	8b 00                	mov    (%rax),%eax
  800caa:	48 98                	cltq   
  800cac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cb0:	48 83 c2 08          	add    $0x8,%rdx
  800cb4:	48 89 c6             	mov    %rax,%rsi
  800cb7:	48 89 d7             	mov    %rdx,%rdi
  800cba:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  800cc1:	00 00 00 
  800cc4:	ff d0                	callq  *%rax
        b->idx = 0;
  800cc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cca:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd4:	8b 40 04             	mov    0x4(%rax),%eax
  800cd7:	8d 50 01             	lea    0x1(%rax),%edx
  800cda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cde:	89 50 04             	mov    %edx,0x4(%rax)
}
  800ce1:	c9                   	leaveq 
  800ce2:	c3                   	retq   

0000000000800ce3 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800ce3:	55                   	push   %rbp
  800ce4:	48 89 e5             	mov    %rsp,%rbp
  800ce7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800cee:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800cf5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800cfc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800d03:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800d0a:	48 8b 0a             	mov    (%rdx),%rcx
  800d0d:	48 89 08             	mov    %rcx,(%rax)
  800d10:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d14:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d18:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d1c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800d20:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800d27:	00 00 00 
    b.cnt = 0;
  800d2a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800d31:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800d34:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800d3b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800d42:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800d49:	48 89 c6             	mov    %rax,%rsi
  800d4c:	48 bf 6a 0c 80 00 00 	movabs $0x800c6a,%rdi
  800d53:	00 00 00 
  800d56:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  800d5d:	00 00 00 
  800d60:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800d62:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800d68:	48 98                	cltq   
  800d6a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800d71:	48 83 c2 08          	add    $0x8,%rdx
  800d75:	48 89 c6             	mov    %rax,%rsi
  800d78:	48 89 d7             	mov    %rdx,%rdi
  800d7b:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  800d82:	00 00 00 
  800d85:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800d87:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d8d:	c9                   	leaveq 
  800d8e:	c3                   	retq   

0000000000800d8f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800d8f:	55                   	push   %rbp
  800d90:	48 89 e5             	mov    %rsp,%rbp
  800d93:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d9a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800da1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800da8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800daf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800db6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dbd:	84 c0                	test   %al,%al
  800dbf:	74 20                	je     800de1 <cprintf+0x52>
  800dc1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dc5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dc9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dcd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dd1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dd5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dd9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ddd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800de1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800de8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800def:	00 00 00 
  800df2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800df9:	00 00 00 
  800dfc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e00:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e07:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e0e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800e15:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e1c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e23:	48 8b 0a             	mov    (%rdx),%rcx
  800e26:	48 89 08             	mov    %rcx,(%rax)
  800e29:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e2d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e31:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e35:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800e39:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800e40:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e47:	48 89 d6             	mov    %rdx,%rsi
  800e4a:	48 89 c7             	mov    %rax,%rdi
  800e4d:	48 b8 e3 0c 80 00 00 	movabs $0x800ce3,%rax
  800e54:	00 00 00 
  800e57:	ff d0                	callq  *%rax
  800e59:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800e5f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e65:	c9                   	leaveq 
  800e66:	c3                   	retq   

0000000000800e67 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e67:	55                   	push   %rbp
  800e68:	48 89 e5             	mov    %rsp,%rbp
  800e6b:	53                   	push   %rbx
  800e6c:	48 83 ec 38          	sub    $0x38,%rsp
  800e70:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e78:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800e7c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800e7f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800e83:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e87:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800e8a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800e8e:	77 3b                	ja     800ecb <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e90:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800e93:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800e97:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800e9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800e9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea3:	48 f7 f3             	div    %rbx
  800ea6:	48 89 c2             	mov    %rax,%rdx
  800ea9:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800eac:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800eaf:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800eb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb7:	41 89 f9             	mov    %edi,%r9d
  800eba:	48 89 c7             	mov    %rax,%rdi
  800ebd:	48 b8 67 0e 80 00 00 	movabs $0x800e67,%rax
  800ec4:	00 00 00 
  800ec7:	ff d0                	callq  *%rax
  800ec9:	eb 1e                	jmp    800ee9 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ecb:	eb 12                	jmp    800edf <printnum+0x78>
			putch(padc, putdat);
  800ecd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800ed1:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800ed4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed8:	48 89 ce             	mov    %rcx,%rsi
  800edb:	89 d7                	mov    %edx,%edi
  800edd:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800edf:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800ee3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800ee7:	7f e4                	jg     800ecd <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ee9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800eec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ef0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef5:	48 f7 f1             	div    %rcx
  800ef8:	48 89 d0             	mov    %rdx,%rax
  800efb:	48 ba 50 59 80 00 00 	movabs $0x805950,%rdx
  800f02:	00 00 00 
  800f05:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800f09:	0f be d0             	movsbl %al,%edx
  800f0c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800f10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f14:	48 89 ce             	mov    %rcx,%rsi
  800f17:	89 d7                	mov    %edx,%edi
  800f19:	ff d0                	callq  *%rax
}
  800f1b:	48 83 c4 38          	add    $0x38,%rsp
  800f1f:	5b                   	pop    %rbx
  800f20:	5d                   	pop    %rbp
  800f21:	c3                   	retq   

0000000000800f22 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800f22:	55                   	push   %rbp
  800f23:	48 89 e5             	mov    %rsp,%rbp
  800f26:	48 83 ec 1c          	sub    $0x1c,%rsp
  800f2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f2e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800f31:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800f35:	7e 52                	jle    800f89 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800f37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3b:	8b 00                	mov    (%rax),%eax
  800f3d:	83 f8 30             	cmp    $0x30,%eax
  800f40:	73 24                	jae    800f66 <getuint+0x44>
  800f42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f46:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4e:	8b 00                	mov    (%rax),%eax
  800f50:	89 c0                	mov    %eax,%eax
  800f52:	48 01 d0             	add    %rdx,%rax
  800f55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f59:	8b 12                	mov    (%rdx),%edx
  800f5b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f62:	89 0a                	mov    %ecx,(%rdx)
  800f64:	eb 17                	jmp    800f7d <getuint+0x5b>
  800f66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800f6e:	48 89 d0             	mov    %rdx,%rax
  800f71:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800f75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f79:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f7d:	48 8b 00             	mov    (%rax),%rax
  800f80:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f84:	e9 a3 00 00 00       	jmpq   80102c <getuint+0x10a>
	else if (lflag)
  800f89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f8d:	74 4f                	je     800fde <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800f8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f93:	8b 00                	mov    (%rax),%eax
  800f95:	83 f8 30             	cmp    $0x30,%eax
  800f98:	73 24                	jae    800fbe <getuint+0x9c>
  800f9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa6:	8b 00                	mov    (%rax),%eax
  800fa8:	89 c0                	mov    %eax,%eax
  800faa:	48 01 d0             	add    %rdx,%rax
  800fad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb1:	8b 12                	mov    (%rdx),%edx
  800fb3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800fb6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fba:	89 0a                	mov    %ecx,(%rdx)
  800fbc:	eb 17                	jmp    800fd5 <getuint+0xb3>
  800fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800fc6:	48 89 d0             	mov    %rdx,%rax
  800fc9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800fcd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fd1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fd5:	48 8b 00             	mov    (%rax),%rax
  800fd8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800fdc:	eb 4e                	jmp    80102c <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800fde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe2:	8b 00                	mov    (%rax),%eax
  800fe4:	83 f8 30             	cmp    $0x30,%eax
  800fe7:	73 24                	jae    80100d <getuint+0xeb>
  800fe9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ff1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff5:	8b 00                	mov    (%rax),%eax
  800ff7:	89 c0                	mov    %eax,%eax
  800ff9:	48 01 d0             	add    %rdx,%rax
  800ffc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801000:	8b 12                	mov    (%rdx),%edx
  801002:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801005:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801009:	89 0a                	mov    %ecx,(%rdx)
  80100b:	eb 17                	jmp    801024 <getuint+0x102>
  80100d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801011:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801015:	48 89 d0             	mov    %rdx,%rax
  801018:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80101c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801020:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801024:	8b 00                	mov    (%rax),%eax
  801026:	89 c0                	mov    %eax,%eax
  801028:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80102c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801030:	c9                   	leaveq 
  801031:	c3                   	retq   

0000000000801032 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801032:	55                   	push   %rbp
  801033:	48 89 e5             	mov    %rsp,%rbp
  801036:	48 83 ec 1c          	sub    $0x1c,%rsp
  80103a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  801041:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801045:	7e 52                	jle    801099 <getint+0x67>
		x=va_arg(*ap, long long);
  801047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104b:	8b 00                	mov    (%rax),%eax
  80104d:	83 f8 30             	cmp    $0x30,%eax
  801050:	73 24                	jae    801076 <getint+0x44>
  801052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801056:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80105a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105e:	8b 00                	mov    (%rax),%eax
  801060:	89 c0                	mov    %eax,%eax
  801062:	48 01 d0             	add    %rdx,%rax
  801065:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801069:	8b 12                	mov    (%rdx),%edx
  80106b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80106e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801072:	89 0a                	mov    %ecx,(%rdx)
  801074:	eb 17                	jmp    80108d <getint+0x5b>
  801076:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80107a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80107e:	48 89 d0             	mov    %rdx,%rax
  801081:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801085:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801089:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80108d:	48 8b 00             	mov    (%rax),%rax
  801090:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801094:	e9 a3 00 00 00       	jmpq   80113c <getint+0x10a>
	else if (lflag)
  801099:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80109d:	74 4f                	je     8010ee <getint+0xbc>
		x=va_arg(*ap, long);
  80109f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a3:	8b 00                	mov    (%rax),%eax
  8010a5:	83 f8 30             	cmp    $0x30,%eax
  8010a8:	73 24                	jae    8010ce <getint+0x9c>
  8010aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ae:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8010b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b6:	8b 00                	mov    (%rax),%eax
  8010b8:	89 c0                	mov    %eax,%eax
  8010ba:	48 01 d0             	add    %rdx,%rax
  8010bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010c1:	8b 12                	mov    (%rdx),%edx
  8010c3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010ca:	89 0a                	mov    %ecx,(%rdx)
  8010cc:	eb 17                	jmp    8010e5 <getint+0xb3>
  8010ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8010d6:	48 89 d0             	mov    %rdx,%rax
  8010d9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8010dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010e1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010e5:	48 8b 00             	mov    (%rax),%rax
  8010e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8010ec:	eb 4e                	jmp    80113c <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	8b 00                	mov    (%rax),%eax
  8010f4:	83 f8 30             	cmp    $0x30,%eax
  8010f7:	73 24                	jae    80111d <getint+0xeb>
  8010f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801105:	8b 00                	mov    (%rax),%eax
  801107:	89 c0                	mov    %eax,%eax
  801109:	48 01 d0             	add    %rdx,%rax
  80110c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801110:	8b 12                	mov    (%rdx),%edx
  801112:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801115:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801119:	89 0a                	mov    %ecx,(%rdx)
  80111b:	eb 17                	jmp    801134 <getint+0x102>
  80111d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801121:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801125:	48 89 d0             	mov    %rdx,%rax
  801128:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80112c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801130:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801134:	8b 00                	mov    (%rax),%eax
  801136:	48 98                	cltq   
  801138:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80113c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801140:	c9                   	leaveq 
  801141:	c3                   	retq   

0000000000801142 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801142:	55                   	push   %rbp
  801143:	48 89 e5             	mov    %rsp,%rbp
  801146:	41 54                	push   %r12
  801148:	53                   	push   %rbx
  801149:	48 83 ec 60          	sub    $0x60,%rsp
  80114d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801151:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801155:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801159:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80115d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801161:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801165:	48 8b 0a             	mov    (%rdx),%rcx
  801168:	48 89 08             	mov    %rcx,(%rax)
  80116b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80116f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801173:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801177:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80117b:	eb 17                	jmp    801194 <vprintfmt+0x52>
			if (ch == '\0')
  80117d:	85 db                	test   %ebx,%ebx
  80117f:	0f 84 cc 04 00 00    	je     801651 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  801185:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801189:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80118d:	48 89 d6             	mov    %rdx,%rsi
  801190:	89 df                	mov    %ebx,%edi
  801192:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801194:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801198:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80119c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8011a0:	0f b6 00             	movzbl (%rax),%eax
  8011a3:	0f b6 d8             	movzbl %al,%ebx
  8011a6:	83 fb 25             	cmp    $0x25,%ebx
  8011a9:	75 d2                	jne    80117d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011ab:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8011af:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8011b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8011bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8011c4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8011cb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011cf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011d3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8011d7:	0f b6 00             	movzbl (%rax),%eax
  8011da:	0f b6 d8             	movzbl %al,%ebx
  8011dd:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8011e0:	83 f8 55             	cmp    $0x55,%eax
  8011e3:	0f 87 34 04 00 00    	ja     80161d <vprintfmt+0x4db>
  8011e9:	89 c0                	mov    %eax,%eax
  8011eb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8011f2:	00 
  8011f3:	48 b8 78 59 80 00 00 	movabs $0x805978,%rax
  8011fa:	00 00 00 
  8011fd:	48 01 d0             	add    %rdx,%rax
  801200:	48 8b 00             	mov    (%rax),%rax
  801203:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  801205:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  801209:	eb c0                	jmp    8011cb <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80120b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80120f:	eb ba                	jmp    8011cb <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801211:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  801218:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80121b:	89 d0                	mov    %edx,%eax
  80121d:	c1 e0 02             	shl    $0x2,%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	01 c0                	add    %eax,%eax
  801224:	01 d8                	add    %ebx,%eax
  801226:	83 e8 30             	sub    $0x30,%eax
  801229:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80122c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801230:	0f b6 00             	movzbl (%rax),%eax
  801233:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801236:	83 fb 2f             	cmp    $0x2f,%ebx
  801239:	7e 0c                	jle    801247 <vprintfmt+0x105>
  80123b:	83 fb 39             	cmp    $0x39,%ebx
  80123e:	7f 07                	jg     801247 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801240:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801245:	eb d1                	jmp    801218 <vprintfmt+0xd6>
			goto process_precision;
  801247:	eb 58                	jmp    8012a1 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  801249:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80124c:	83 f8 30             	cmp    $0x30,%eax
  80124f:	73 17                	jae    801268 <vprintfmt+0x126>
  801251:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801255:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801258:	89 c0                	mov    %eax,%eax
  80125a:	48 01 d0             	add    %rdx,%rax
  80125d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801260:	83 c2 08             	add    $0x8,%edx
  801263:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801266:	eb 0f                	jmp    801277 <vprintfmt+0x135>
  801268:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80126c:	48 89 d0             	mov    %rdx,%rax
  80126f:	48 83 c2 08          	add    $0x8,%rdx
  801273:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801277:	8b 00                	mov    (%rax),%eax
  801279:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80127c:	eb 23                	jmp    8012a1 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80127e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801282:	79 0c                	jns    801290 <vprintfmt+0x14e>
				width = 0;
  801284:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80128b:	e9 3b ff ff ff       	jmpq   8011cb <vprintfmt+0x89>
  801290:	e9 36 ff ff ff       	jmpq   8011cb <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801295:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80129c:	e9 2a ff ff ff       	jmpq   8011cb <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8012a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8012a5:	79 12                	jns    8012b9 <vprintfmt+0x177>
				width = precision, precision = -1;
  8012a7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8012aa:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8012ad:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8012b4:	e9 12 ff ff ff       	jmpq   8011cb <vprintfmt+0x89>
  8012b9:	e9 0d ff ff ff       	jmpq   8011cb <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012be:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8012c2:	e9 04 ff ff ff       	jmpq   8011cb <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8012c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012ca:	83 f8 30             	cmp    $0x30,%eax
  8012cd:	73 17                	jae    8012e6 <vprintfmt+0x1a4>
  8012cf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8012d3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012d6:	89 c0                	mov    %eax,%eax
  8012d8:	48 01 d0             	add    %rdx,%rax
  8012db:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012de:	83 c2 08             	add    $0x8,%edx
  8012e1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012e4:	eb 0f                	jmp    8012f5 <vprintfmt+0x1b3>
  8012e6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8012ea:	48 89 d0             	mov    %rdx,%rax
  8012ed:	48 83 c2 08          	add    $0x8,%rdx
  8012f1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012f5:	8b 10                	mov    (%rax),%edx
  8012f7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8012fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012ff:	48 89 ce             	mov    %rcx,%rsi
  801302:	89 d7                	mov    %edx,%edi
  801304:	ff d0                	callq  *%rax
			break;
  801306:	e9 40 03 00 00       	jmpq   80164b <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80130b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80130e:	83 f8 30             	cmp    $0x30,%eax
  801311:	73 17                	jae    80132a <vprintfmt+0x1e8>
  801313:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801317:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80131a:	89 c0                	mov    %eax,%eax
  80131c:	48 01 d0             	add    %rdx,%rax
  80131f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801322:	83 c2 08             	add    $0x8,%edx
  801325:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801328:	eb 0f                	jmp    801339 <vprintfmt+0x1f7>
  80132a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80132e:	48 89 d0             	mov    %rdx,%rax
  801331:	48 83 c2 08          	add    $0x8,%rdx
  801335:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801339:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80133b:	85 db                	test   %ebx,%ebx
  80133d:	79 02                	jns    801341 <vprintfmt+0x1ff>
				err = -err;
  80133f:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801341:	83 fb 15             	cmp    $0x15,%ebx
  801344:	7f 16                	jg     80135c <vprintfmt+0x21a>
  801346:	48 b8 a0 58 80 00 00 	movabs $0x8058a0,%rax
  80134d:	00 00 00 
  801350:	48 63 d3             	movslq %ebx,%rdx
  801353:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801357:	4d 85 e4             	test   %r12,%r12
  80135a:	75 2e                	jne    80138a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80135c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801360:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801364:	89 d9                	mov    %ebx,%ecx
  801366:	48 ba 61 59 80 00 00 	movabs $0x805961,%rdx
  80136d:	00 00 00 
  801370:	48 89 c7             	mov    %rax,%rdi
  801373:	b8 00 00 00 00       	mov    $0x0,%eax
  801378:	49 b8 5a 16 80 00 00 	movabs $0x80165a,%r8
  80137f:	00 00 00 
  801382:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801385:	e9 c1 02 00 00       	jmpq   80164b <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80138a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80138e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801392:	4c 89 e1             	mov    %r12,%rcx
  801395:	48 ba 6a 59 80 00 00 	movabs $0x80596a,%rdx
  80139c:	00 00 00 
  80139f:	48 89 c7             	mov    %rax,%rdi
  8013a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a7:	49 b8 5a 16 80 00 00 	movabs $0x80165a,%r8
  8013ae:	00 00 00 
  8013b1:	41 ff d0             	callq  *%r8
			break;
  8013b4:	e9 92 02 00 00       	jmpq   80164b <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8013b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013bc:	83 f8 30             	cmp    $0x30,%eax
  8013bf:	73 17                	jae    8013d8 <vprintfmt+0x296>
  8013c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8013c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8013c8:	89 c0                	mov    %eax,%eax
  8013ca:	48 01 d0             	add    %rdx,%rax
  8013cd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013d0:	83 c2 08             	add    $0x8,%edx
  8013d3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8013d6:	eb 0f                	jmp    8013e7 <vprintfmt+0x2a5>
  8013d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8013dc:	48 89 d0             	mov    %rdx,%rax
  8013df:	48 83 c2 08          	add    $0x8,%rdx
  8013e3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013e7:	4c 8b 20             	mov    (%rax),%r12
  8013ea:	4d 85 e4             	test   %r12,%r12
  8013ed:	75 0a                	jne    8013f9 <vprintfmt+0x2b7>
				p = "(null)";
  8013ef:	49 bc 6d 59 80 00 00 	movabs $0x80596d,%r12
  8013f6:	00 00 00 
			if (width > 0 && padc != '-')
  8013f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013fd:	7e 3f                	jle    80143e <vprintfmt+0x2fc>
  8013ff:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801403:	74 39                	je     80143e <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  801405:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801408:	48 98                	cltq   
  80140a:	48 89 c6             	mov    %rax,%rsi
  80140d:	4c 89 e7             	mov    %r12,%rdi
  801410:	48 b8 06 19 80 00 00 	movabs $0x801906,%rax
  801417:	00 00 00 
  80141a:	ff d0                	callq  *%rax
  80141c:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80141f:	eb 17                	jmp    801438 <vprintfmt+0x2f6>
					putch(padc, putdat);
  801421:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801425:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801429:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80142d:	48 89 ce             	mov    %rcx,%rsi
  801430:	89 d7                	mov    %edx,%edi
  801432:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801434:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801438:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80143c:	7f e3                	jg     801421 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80143e:	eb 37                	jmp    801477 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  801440:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801444:	74 1e                	je     801464 <vprintfmt+0x322>
  801446:	83 fb 1f             	cmp    $0x1f,%ebx
  801449:	7e 05                	jle    801450 <vprintfmt+0x30e>
  80144b:	83 fb 7e             	cmp    $0x7e,%ebx
  80144e:	7e 14                	jle    801464 <vprintfmt+0x322>
					putch('?', putdat);
  801450:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801454:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801458:	48 89 d6             	mov    %rdx,%rsi
  80145b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801460:	ff d0                	callq  *%rax
  801462:	eb 0f                	jmp    801473 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  801464:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801468:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80146c:	48 89 d6             	mov    %rdx,%rsi
  80146f:	89 df                	mov    %ebx,%edi
  801471:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801473:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801477:	4c 89 e0             	mov    %r12,%rax
  80147a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80147e:	0f b6 00             	movzbl (%rax),%eax
  801481:	0f be d8             	movsbl %al,%ebx
  801484:	85 db                	test   %ebx,%ebx
  801486:	74 10                	je     801498 <vprintfmt+0x356>
  801488:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80148c:	78 b2                	js     801440 <vprintfmt+0x2fe>
  80148e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801492:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801496:	79 a8                	jns    801440 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801498:	eb 16                	jmp    8014b0 <vprintfmt+0x36e>
				putch(' ', putdat);
  80149a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80149e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014a2:	48 89 d6             	mov    %rdx,%rsi
  8014a5:	bf 20 00 00 00       	mov    $0x20,%edi
  8014aa:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014ac:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8014b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8014b4:	7f e4                	jg     80149a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8014b6:	e9 90 01 00 00       	jmpq   80164b <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8014bb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014bf:	be 03 00 00 00       	mov    $0x3,%esi
  8014c4:	48 89 c7             	mov    %rax,%rdi
  8014c7:	48 b8 32 10 80 00 00 	movabs $0x801032,%rax
  8014ce:	00 00 00 
  8014d1:	ff d0                	callq  *%rax
  8014d3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8014d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014db:	48 85 c0             	test   %rax,%rax
  8014de:	79 1d                	jns    8014fd <vprintfmt+0x3bb>
				putch('-', putdat);
  8014e0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014e8:	48 89 d6             	mov    %rdx,%rsi
  8014eb:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8014f0:	ff d0                	callq  *%rax
				num = -(long long) num;
  8014f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f6:	48 f7 d8             	neg    %rax
  8014f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8014fd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801504:	e9 d5 00 00 00       	jmpq   8015de <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801509:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80150d:	be 03 00 00 00       	mov    $0x3,%esi
  801512:	48 89 c7             	mov    %rax,%rdi
  801515:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  80151c:	00 00 00 
  80151f:	ff d0                	callq  *%rax
  801521:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801525:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80152c:	e9 ad 00 00 00       	jmpq   8015de <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getint(&aq, lflag);
  801531:	8b 55 e0             	mov    -0x20(%rbp),%edx
  801534:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801538:	89 d6                	mov    %edx,%esi
  80153a:	48 89 c7             	mov    %rax,%rdi
  80153d:	48 b8 32 10 80 00 00 	movabs $0x801032,%rax
  801544:	00 00 00 
  801547:	ff d0                	callq  *%rax
  801549:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  80154d:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801554:	e9 85 00 00 00       	jmpq   8015de <vprintfmt+0x49c>


			// pointer
		case 'p':
			putch('0', putdat);
  801559:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80155d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801561:	48 89 d6             	mov    %rdx,%rsi
  801564:	bf 30 00 00 00       	mov    $0x30,%edi
  801569:	ff d0                	callq  *%rax
			putch('x', putdat);
  80156b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80156f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801573:	48 89 d6             	mov    %rdx,%rsi
  801576:	bf 78 00 00 00       	mov    $0x78,%edi
  80157b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80157d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801580:	83 f8 30             	cmp    $0x30,%eax
  801583:	73 17                	jae    80159c <vprintfmt+0x45a>
  801585:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801589:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80158c:	89 c0                	mov    %eax,%eax
  80158e:	48 01 d0             	add    %rdx,%rax
  801591:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801594:	83 c2 08             	add    $0x8,%edx
  801597:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80159a:	eb 0f                	jmp    8015ab <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80159c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8015a0:	48 89 d0             	mov    %rdx,%rax
  8015a3:	48 83 c2 08          	add    $0x8,%rdx
  8015a7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8015ab:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8015ae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8015b2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8015b9:	eb 23                	jmp    8015de <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8015bb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8015bf:	be 03 00 00 00       	mov    $0x3,%esi
  8015c4:	48 89 c7             	mov    %rax,%rdi
  8015c7:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  8015ce:	00 00 00 
  8015d1:	ff d0                	callq  *%rax
  8015d3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8015d7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8015de:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8015e3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8015e6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8015e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015ed:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8015f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015f5:	45 89 c1             	mov    %r8d,%r9d
  8015f8:	41 89 f8             	mov    %edi,%r8d
  8015fb:	48 89 c7             	mov    %rax,%rdi
  8015fe:	48 b8 67 0e 80 00 00 	movabs $0x800e67,%rax
  801605:	00 00 00 
  801608:	ff d0                	callq  *%rax
			break;
  80160a:	eb 3f                	jmp    80164b <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80160c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801610:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801614:	48 89 d6             	mov    %rdx,%rsi
  801617:	89 df                	mov    %ebx,%edi
  801619:	ff d0                	callq  *%rax
			break;
  80161b:	eb 2e                	jmp    80164b <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80161d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801621:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801625:	48 89 d6             	mov    %rdx,%rsi
  801628:	bf 25 00 00 00       	mov    $0x25,%edi
  80162d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80162f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801634:	eb 05                	jmp    80163b <vprintfmt+0x4f9>
  801636:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80163b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80163f:	48 83 e8 01          	sub    $0x1,%rax
  801643:	0f b6 00             	movzbl (%rax),%eax
  801646:	3c 25                	cmp    $0x25,%al
  801648:	75 ec                	jne    801636 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80164a:	90                   	nop
		}
	}
  80164b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80164c:	e9 43 fb ff ff       	jmpq   801194 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801651:	48 83 c4 60          	add    $0x60,%rsp
  801655:	5b                   	pop    %rbx
  801656:	41 5c                	pop    %r12
  801658:	5d                   	pop    %rbp
  801659:	c3                   	retq   

000000000080165a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80165a:	55                   	push   %rbp
  80165b:	48 89 e5             	mov    %rsp,%rbp
  80165e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801665:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80166c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801673:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80167a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801681:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801688:	84 c0                	test   %al,%al
  80168a:	74 20                	je     8016ac <printfmt+0x52>
  80168c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801690:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801694:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801698:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80169c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8016a0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8016a4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8016a8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8016ac:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8016b3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8016ba:	00 00 00 
  8016bd:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8016c4:	00 00 00 
  8016c7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8016cb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8016d2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8016d9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8016e0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8016e7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8016ee:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8016f5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8016fc:	48 89 c7             	mov    %rax,%rdi
  8016ff:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  801706:	00 00 00 
  801709:	ff d0                	callq  *%rax
	va_end(ap);
}
  80170b:	c9                   	leaveq 
  80170c:	c3                   	retq   

000000000080170d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80170d:	55                   	push   %rbp
  80170e:	48 89 e5             	mov    %rsp,%rbp
  801711:	48 83 ec 10          	sub    $0x10,%rsp
  801715:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801718:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80171c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801720:	8b 40 10             	mov    0x10(%rax),%eax
  801723:	8d 50 01             	lea    0x1(%rax),%edx
  801726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80172d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801731:	48 8b 10             	mov    (%rax),%rdx
  801734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801738:	48 8b 40 08          	mov    0x8(%rax),%rax
  80173c:	48 39 c2             	cmp    %rax,%rdx
  80173f:	73 17                	jae    801758 <sprintputch+0x4b>
		*b->buf++ = ch;
  801741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801745:	48 8b 00             	mov    (%rax),%rax
  801748:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80174c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801750:	48 89 0a             	mov    %rcx,(%rdx)
  801753:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801756:	88 10                	mov    %dl,(%rax)
}
  801758:	c9                   	leaveq 
  801759:	c3                   	retq   

000000000080175a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80175a:	55                   	push   %rbp
  80175b:	48 89 e5             	mov    %rsp,%rbp
  80175e:	48 83 ec 50          	sub    $0x50,%rsp
  801762:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801766:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801769:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80176d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801771:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801775:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801779:	48 8b 0a             	mov    (%rdx),%rcx
  80177c:	48 89 08             	mov    %rcx,(%rax)
  80177f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801783:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801787:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80178b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80178f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801793:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801797:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80179a:	48 98                	cltq   
  80179c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017a0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8017a4:	48 01 d0             	add    %rdx,%rax
  8017a7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8017ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8017b2:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8017b7:	74 06                	je     8017bf <vsnprintf+0x65>
  8017b9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8017bd:	7f 07                	jg     8017c6 <vsnprintf+0x6c>
		return -E_INVAL;
  8017bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c4:	eb 2f                	jmp    8017f5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8017c6:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8017ca:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8017ce:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8017d2:	48 89 c6             	mov    %rax,%rsi
  8017d5:	48 bf 0d 17 80 00 00 	movabs $0x80170d,%rdi
  8017dc:	00 00 00 
  8017df:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  8017e6:	00 00 00 
  8017e9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8017eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ef:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8017f2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8017f5:	c9                   	leaveq 
  8017f6:	c3                   	retq   

00000000008017f7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017f7:	55                   	push   %rbp
  8017f8:	48 89 e5             	mov    %rsp,%rbp
  8017fb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801802:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801809:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80180f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801816:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80181d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801824:	84 c0                	test   %al,%al
  801826:	74 20                	je     801848 <snprintf+0x51>
  801828:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80182c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801830:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801834:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801838:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80183c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801840:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801844:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801848:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80184f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801856:	00 00 00 
  801859:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801860:	00 00 00 
  801863:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801867:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80186e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801875:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80187c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801883:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80188a:	48 8b 0a             	mov    (%rdx),%rcx
  80188d:	48 89 08             	mov    %rcx,(%rax)
  801890:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801894:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801898:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80189c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8018a0:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8018a7:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8018ae:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8018b4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8018bb:	48 89 c7             	mov    %rax,%rdi
  8018be:	48 b8 5a 17 80 00 00 	movabs $0x80175a,%rax
  8018c5:	00 00 00 
  8018c8:	ff d0                	callq  *%rax
  8018ca:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8018d0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8018d6:	c9                   	leaveq 
  8018d7:	c3                   	retq   

00000000008018d8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8018d8:	55                   	push   %rbp
  8018d9:	48 89 e5             	mov    %rsp,%rbp
  8018dc:	48 83 ec 18          	sub    $0x18,%rsp
  8018e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8018e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018eb:	eb 09                	jmp    8018f6 <strlen+0x1e>
		n++;
  8018ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018f1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018fa:	0f b6 00             	movzbl (%rax),%eax
  8018fd:	84 c0                	test   %al,%al
  8018ff:	75 ec                	jne    8018ed <strlen+0x15>
		n++;
	return n;
  801901:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801904:	c9                   	leaveq 
  801905:	c3                   	retq   

0000000000801906 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801906:	55                   	push   %rbp
  801907:	48 89 e5             	mov    %rsp,%rbp
  80190a:	48 83 ec 20          	sub    $0x20,%rsp
  80190e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801912:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801916:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80191d:	eb 0e                	jmp    80192d <strnlen+0x27>
		n++;
  80191f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801923:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801928:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80192d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801932:	74 0b                	je     80193f <strnlen+0x39>
  801934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801938:	0f b6 00             	movzbl (%rax),%eax
  80193b:	84 c0                	test   %al,%al
  80193d:	75 e0                	jne    80191f <strnlen+0x19>
		n++;
	return n;
  80193f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801942:	c9                   	leaveq 
  801943:	c3                   	retq   

0000000000801944 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801944:	55                   	push   %rbp
  801945:	48 89 e5             	mov    %rsp,%rbp
  801948:	48 83 ec 20          	sub    $0x20,%rsp
  80194c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801950:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801954:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801958:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80195c:	90                   	nop
  80195d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801961:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801965:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801969:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80196d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801971:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801975:	0f b6 12             	movzbl (%rdx),%edx
  801978:	88 10                	mov    %dl,(%rax)
  80197a:	0f b6 00             	movzbl (%rax),%eax
  80197d:	84 c0                	test   %al,%al
  80197f:	75 dc                	jne    80195d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801981:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801985:	c9                   	leaveq 
  801986:	c3                   	retq   

0000000000801987 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801987:	55                   	push   %rbp
  801988:	48 89 e5             	mov    %rsp,%rbp
  80198b:	48 83 ec 20          	sub    $0x20,%rsp
  80198f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801993:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80199b:	48 89 c7             	mov    %rax,%rdi
  80199e:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  8019a5:	00 00 00 
  8019a8:	ff d0                	callq  *%rax
  8019aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8019ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b0:	48 63 d0             	movslq %eax,%rdx
  8019b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019b7:	48 01 c2             	add    %rax,%rdx
  8019ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019be:	48 89 c6             	mov    %rax,%rsi
  8019c1:	48 89 d7             	mov    %rdx,%rdi
  8019c4:	48 b8 44 19 80 00 00 	movabs $0x801944,%rax
  8019cb:	00 00 00 
  8019ce:	ff d0                	callq  *%rax
	return dst;
  8019d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019d4:	c9                   	leaveq 
  8019d5:	c3                   	retq   

00000000008019d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8019d6:	55                   	push   %rbp
  8019d7:	48 89 e5             	mov    %rsp,%rbp
  8019da:	48 83 ec 28          	sub    $0x28,%rsp
  8019de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8019ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8019f2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8019f9:	00 
  8019fa:	eb 2a                	jmp    801a26 <strncpy+0x50>
		*dst++ = *src;
  8019fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a00:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a04:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a08:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801a0c:	0f b6 12             	movzbl (%rdx),%edx
  801a0f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801a11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a15:	0f b6 00             	movzbl (%rax),%eax
  801a18:	84 c0                	test   %al,%al
  801a1a:	74 05                	je     801a21 <strncpy+0x4b>
			src++;
  801a1c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a21:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a2a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801a2e:	72 cc                	jb     8019fc <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801a30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a34:	c9                   	leaveq 
  801a35:	c3                   	retq   

0000000000801a36 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801a36:	55                   	push   %rbp
  801a37:	48 89 e5             	mov    %rsp,%rbp
  801a3a:	48 83 ec 28          	sub    $0x28,%rsp
  801a3e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a46:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a4e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801a52:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a57:	74 3d                	je     801a96 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801a59:	eb 1d                	jmp    801a78 <strlcpy+0x42>
			*dst++ = *src++;
  801a5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a5f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a63:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a67:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801a6b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801a6f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801a73:	0f b6 12             	movzbl (%rdx),%edx
  801a76:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a78:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a7d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a82:	74 0b                	je     801a8f <strlcpy+0x59>
  801a84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a88:	0f b6 00             	movzbl (%rax),%eax
  801a8b:	84 c0                	test   %al,%al
  801a8d:	75 cc                	jne    801a5b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a93:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a96:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a9e:	48 29 c2             	sub    %rax,%rdx
  801aa1:	48 89 d0             	mov    %rdx,%rax
}
  801aa4:	c9                   	leaveq 
  801aa5:	c3                   	retq   

0000000000801aa6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801aa6:	55                   	push   %rbp
  801aa7:	48 89 e5             	mov    %rsp,%rbp
  801aaa:	48 83 ec 10          	sub    $0x10,%rsp
  801aae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ab2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801ab6:	eb 0a                	jmp    801ac2 <strcmp+0x1c>
		p++, q++;
  801ab8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801abd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac6:	0f b6 00             	movzbl (%rax),%eax
  801ac9:	84 c0                	test   %al,%al
  801acb:	74 12                	je     801adf <strcmp+0x39>
  801acd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad1:	0f b6 10             	movzbl (%rax),%edx
  801ad4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ad8:	0f b6 00             	movzbl (%rax),%eax
  801adb:	38 c2                	cmp    %al,%dl
  801add:	74 d9                	je     801ab8 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801adf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae3:	0f b6 00             	movzbl (%rax),%eax
  801ae6:	0f b6 d0             	movzbl %al,%edx
  801ae9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aed:	0f b6 00             	movzbl (%rax),%eax
  801af0:	0f b6 c0             	movzbl %al,%eax
  801af3:	29 c2                	sub    %eax,%edx
  801af5:	89 d0                	mov    %edx,%eax
}
  801af7:	c9                   	leaveq 
  801af8:	c3                   	retq   

0000000000801af9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801af9:	55                   	push   %rbp
  801afa:	48 89 e5             	mov    %rsp,%rbp
  801afd:	48 83 ec 18          	sub    $0x18,%rsp
  801b01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b09:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801b0d:	eb 0f                	jmp    801b1e <strncmp+0x25>
		n--, p++, q++;
  801b0f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801b14:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b19:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801b1e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b23:	74 1d                	je     801b42 <strncmp+0x49>
  801b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b29:	0f b6 00             	movzbl (%rax),%eax
  801b2c:	84 c0                	test   %al,%al
  801b2e:	74 12                	je     801b42 <strncmp+0x49>
  801b30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b34:	0f b6 10             	movzbl (%rax),%edx
  801b37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b3b:	0f b6 00             	movzbl (%rax),%eax
  801b3e:	38 c2                	cmp    %al,%dl
  801b40:	74 cd                	je     801b0f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801b42:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b47:	75 07                	jne    801b50 <strncmp+0x57>
		return 0;
  801b49:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4e:	eb 18                	jmp    801b68 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801b50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b54:	0f b6 00             	movzbl (%rax),%eax
  801b57:	0f b6 d0             	movzbl %al,%edx
  801b5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b5e:	0f b6 00             	movzbl (%rax),%eax
  801b61:	0f b6 c0             	movzbl %al,%eax
  801b64:	29 c2                	sub    %eax,%edx
  801b66:	89 d0                	mov    %edx,%eax
}
  801b68:	c9                   	leaveq 
  801b69:	c3                   	retq   

0000000000801b6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b6a:	55                   	push   %rbp
  801b6b:	48 89 e5             	mov    %rsp,%rbp
  801b6e:	48 83 ec 0c          	sub    $0xc,%rsp
  801b72:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b76:	89 f0                	mov    %esi,%eax
  801b78:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b7b:	eb 17                	jmp    801b94 <strchr+0x2a>
		if (*s == c)
  801b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b81:	0f b6 00             	movzbl (%rax),%eax
  801b84:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b87:	75 06                	jne    801b8f <strchr+0x25>
			return (char *) s;
  801b89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b8d:	eb 15                	jmp    801ba4 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b8f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b98:	0f b6 00             	movzbl (%rax),%eax
  801b9b:	84 c0                	test   %al,%al
  801b9d:	75 de                	jne    801b7d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba4:	c9                   	leaveq 
  801ba5:	c3                   	retq   

0000000000801ba6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ba6:	55                   	push   %rbp
  801ba7:	48 89 e5             	mov    %rsp,%rbp
  801baa:	48 83 ec 0c          	sub    $0xc,%rsp
  801bae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bb2:	89 f0                	mov    %esi,%eax
  801bb4:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801bb7:	eb 13                	jmp    801bcc <strfind+0x26>
		if (*s == c)
  801bb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bbd:	0f b6 00             	movzbl (%rax),%eax
  801bc0:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801bc3:	75 02                	jne    801bc7 <strfind+0x21>
			break;
  801bc5:	eb 10                	jmp    801bd7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801bc7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bd0:	0f b6 00             	movzbl (%rax),%eax
  801bd3:	84 c0                	test   %al,%al
  801bd5:	75 e2                	jne    801bb9 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801bd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801bdb:	c9                   	leaveq 
  801bdc:	c3                   	retq   

0000000000801bdd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801bdd:	55                   	push   %rbp
  801bde:	48 89 e5             	mov    %rsp,%rbp
  801be1:	48 83 ec 18          	sub    $0x18,%rsp
  801be5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801be9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801bec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801bf0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bf5:	75 06                	jne    801bfd <memset+0x20>
		return v;
  801bf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bfb:	eb 69                	jmp    801c66 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801bfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c01:	83 e0 03             	and    $0x3,%eax
  801c04:	48 85 c0             	test   %rax,%rax
  801c07:	75 48                	jne    801c51 <memset+0x74>
  801c09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c0d:	83 e0 03             	and    $0x3,%eax
  801c10:	48 85 c0             	test   %rax,%rax
  801c13:	75 3c                	jne    801c51 <memset+0x74>
		c &= 0xFF;
  801c15:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801c1c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c1f:	c1 e0 18             	shl    $0x18,%eax
  801c22:	89 c2                	mov    %eax,%edx
  801c24:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c27:	c1 e0 10             	shl    $0x10,%eax
  801c2a:	09 c2                	or     %eax,%edx
  801c2c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c2f:	c1 e0 08             	shl    $0x8,%eax
  801c32:	09 d0                	or     %edx,%eax
  801c34:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801c37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c3b:	48 c1 e8 02          	shr    $0x2,%rax
  801c3f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801c42:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c46:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c49:	48 89 d7             	mov    %rdx,%rdi
  801c4c:	fc                   	cld    
  801c4d:	f3 ab                	rep stos %eax,%es:(%rdi)
  801c4f:	eb 11                	jmp    801c62 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801c51:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c55:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c58:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c5c:	48 89 d7             	mov    %rdx,%rdi
  801c5f:	fc                   	cld    
  801c60:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801c62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c66:	c9                   	leaveq 
  801c67:	c3                   	retq   

0000000000801c68 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801c68:	55                   	push   %rbp
  801c69:	48 89 e5             	mov    %rsp,%rbp
  801c6c:	48 83 ec 28          	sub    $0x28,%rsp
  801c70:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c78:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c80:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c88:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c90:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c94:	0f 83 88 00 00 00    	jae    801d22 <memmove+0xba>
  801c9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ca2:	48 01 d0             	add    %rdx,%rax
  801ca5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801ca9:	76 77                	jbe    801d22 <memmove+0xba>
		s += n;
  801cab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801caf:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801cb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb7:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801cbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cbf:	83 e0 03             	and    $0x3,%eax
  801cc2:	48 85 c0             	test   %rax,%rax
  801cc5:	75 3b                	jne    801d02 <memmove+0x9a>
  801cc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ccb:	83 e0 03             	and    $0x3,%eax
  801cce:	48 85 c0             	test   %rax,%rax
  801cd1:	75 2f                	jne    801d02 <memmove+0x9a>
  801cd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd7:	83 e0 03             	and    $0x3,%eax
  801cda:	48 85 c0             	test   %rax,%rax
  801cdd:	75 23                	jne    801d02 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce3:	48 83 e8 04          	sub    $0x4,%rax
  801ce7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ceb:	48 83 ea 04          	sub    $0x4,%rdx
  801cef:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801cf3:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801cf7:	48 89 c7             	mov    %rax,%rdi
  801cfa:	48 89 d6             	mov    %rdx,%rsi
  801cfd:	fd                   	std    
  801cfe:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801d00:	eb 1d                	jmp    801d1f <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d06:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801d0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d0e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801d12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d16:	48 89 d7             	mov    %rdx,%rdi
  801d19:	48 89 c1             	mov    %rax,%rcx
  801d1c:	fd                   	std    
  801d1d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d1f:	fc                   	cld    
  801d20:	eb 57                	jmp    801d79 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801d22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d26:	83 e0 03             	and    $0x3,%eax
  801d29:	48 85 c0             	test   %rax,%rax
  801d2c:	75 36                	jne    801d64 <memmove+0xfc>
  801d2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d32:	83 e0 03             	and    $0x3,%eax
  801d35:	48 85 c0             	test   %rax,%rax
  801d38:	75 2a                	jne    801d64 <memmove+0xfc>
  801d3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d3e:	83 e0 03             	and    $0x3,%eax
  801d41:	48 85 c0             	test   %rax,%rax
  801d44:	75 1e                	jne    801d64 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801d46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d4a:	48 c1 e8 02          	shr    $0x2,%rax
  801d4e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801d51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d55:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d59:	48 89 c7             	mov    %rax,%rdi
  801d5c:	48 89 d6             	mov    %rdx,%rsi
  801d5f:	fc                   	cld    
  801d60:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801d62:	eb 15                	jmp    801d79 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801d64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d6c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801d70:	48 89 c7             	mov    %rax,%rdi
  801d73:	48 89 d6             	mov    %rdx,%rsi
  801d76:	fc                   	cld    
  801d77:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d7d:	c9                   	leaveq 
  801d7e:	c3                   	retq   

0000000000801d7f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d7f:	55                   	push   %rbp
  801d80:	48 89 e5             	mov    %rsp,%rbp
  801d83:	48 83 ec 18          	sub    $0x18,%rsp
  801d87:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d8f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d97:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d9f:	48 89 ce             	mov    %rcx,%rsi
  801da2:	48 89 c7             	mov    %rax,%rdi
  801da5:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  801dac:	00 00 00 
  801daf:	ff d0                	callq  *%rax
}
  801db1:	c9                   	leaveq 
  801db2:	c3                   	retq   

0000000000801db3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801db3:	55                   	push   %rbp
  801db4:	48 89 e5             	mov    %rsp,%rbp
  801db7:	48 83 ec 28          	sub    $0x28,%rsp
  801dbb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dbf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801dc3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801dc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dcb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801dcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801dd7:	eb 36                	jmp    801e0f <memcmp+0x5c>
		if (*s1 != *s2)
  801dd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ddd:	0f b6 10             	movzbl (%rax),%edx
  801de0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de4:	0f b6 00             	movzbl (%rax),%eax
  801de7:	38 c2                	cmp    %al,%dl
  801de9:	74 1a                	je     801e05 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801deb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801def:	0f b6 00             	movzbl (%rax),%eax
  801df2:	0f b6 d0             	movzbl %al,%edx
  801df5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df9:	0f b6 00             	movzbl (%rax),%eax
  801dfc:	0f b6 c0             	movzbl %al,%eax
  801dff:	29 c2                	sub    %eax,%edx
  801e01:	89 d0                	mov    %edx,%eax
  801e03:	eb 20                	jmp    801e25 <memcmp+0x72>
		s1++, s2++;
  801e05:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801e0a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e13:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e17:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801e1b:	48 85 c0             	test   %rax,%rax
  801e1e:	75 b9                	jne    801dd9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e25:	c9                   	leaveq 
  801e26:	c3                   	retq   

0000000000801e27 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801e27:	55                   	push   %rbp
  801e28:	48 89 e5             	mov    %rsp,%rbp
  801e2b:	48 83 ec 28          	sub    $0x28,%rsp
  801e2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e33:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801e36:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801e3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e42:	48 01 d0             	add    %rdx,%rax
  801e45:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801e49:	eb 15                	jmp    801e60 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801e4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e4f:	0f b6 10             	movzbl (%rax),%edx
  801e52:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e55:	38 c2                	cmp    %al,%dl
  801e57:	75 02                	jne    801e5b <memfind+0x34>
			break;
  801e59:	eb 0f                	jmp    801e6a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801e5b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801e60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e64:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801e68:	72 e1                	jb     801e4b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801e6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e6e:	c9                   	leaveq 
  801e6f:	c3                   	retq   

0000000000801e70 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801e70:	55                   	push   %rbp
  801e71:	48 89 e5             	mov    %rsp,%rbp
  801e74:	48 83 ec 34          	sub    $0x34,%rsp
  801e78:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e7c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e80:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e8a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e91:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e92:	eb 05                	jmp    801e99 <strtol+0x29>
		s++;
  801e94:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e9d:	0f b6 00             	movzbl (%rax),%eax
  801ea0:	3c 20                	cmp    $0x20,%al
  801ea2:	74 f0                	je     801e94 <strtol+0x24>
  801ea4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea8:	0f b6 00             	movzbl (%rax),%eax
  801eab:	3c 09                	cmp    $0x9,%al
  801ead:	74 e5                	je     801e94 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801eaf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb3:	0f b6 00             	movzbl (%rax),%eax
  801eb6:	3c 2b                	cmp    $0x2b,%al
  801eb8:	75 07                	jne    801ec1 <strtol+0x51>
		s++;
  801eba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ebf:	eb 17                	jmp    801ed8 <strtol+0x68>
	else if (*s == '-')
  801ec1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec5:	0f b6 00             	movzbl (%rax),%eax
  801ec8:	3c 2d                	cmp    $0x2d,%al
  801eca:	75 0c                	jne    801ed8 <strtol+0x68>
		s++, neg = 1;
  801ecc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ed1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ed8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801edc:	74 06                	je     801ee4 <strtol+0x74>
  801ede:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801ee2:	75 28                	jne    801f0c <strtol+0x9c>
  801ee4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee8:	0f b6 00             	movzbl (%rax),%eax
  801eeb:	3c 30                	cmp    $0x30,%al
  801eed:	75 1d                	jne    801f0c <strtol+0x9c>
  801eef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef3:	48 83 c0 01          	add    $0x1,%rax
  801ef7:	0f b6 00             	movzbl (%rax),%eax
  801efa:	3c 78                	cmp    $0x78,%al
  801efc:	75 0e                	jne    801f0c <strtol+0x9c>
		s += 2, base = 16;
  801efe:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801f03:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801f0a:	eb 2c                	jmp    801f38 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801f0c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801f10:	75 19                	jne    801f2b <strtol+0xbb>
  801f12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f16:	0f b6 00             	movzbl (%rax),%eax
  801f19:	3c 30                	cmp    $0x30,%al
  801f1b:	75 0e                	jne    801f2b <strtol+0xbb>
		s++, base = 8;
  801f1d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f22:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801f29:	eb 0d                	jmp    801f38 <strtol+0xc8>
	else if (base == 0)
  801f2b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801f2f:	75 07                	jne    801f38 <strtol+0xc8>
		base = 10;
  801f31:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801f38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f3c:	0f b6 00             	movzbl (%rax),%eax
  801f3f:	3c 2f                	cmp    $0x2f,%al
  801f41:	7e 1d                	jle    801f60 <strtol+0xf0>
  801f43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f47:	0f b6 00             	movzbl (%rax),%eax
  801f4a:	3c 39                	cmp    $0x39,%al
  801f4c:	7f 12                	jg     801f60 <strtol+0xf0>
			dig = *s - '0';
  801f4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f52:	0f b6 00             	movzbl (%rax),%eax
  801f55:	0f be c0             	movsbl %al,%eax
  801f58:	83 e8 30             	sub    $0x30,%eax
  801f5b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f5e:	eb 4e                	jmp    801fae <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801f60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f64:	0f b6 00             	movzbl (%rax),%eax
  801f67:	3c 60                	cmp    $0x60,%al
  801f69:	7e 1d                	jle    801f88 <strtol+0x118>
  801f6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f6f:	0f b6 00             	movzbl (%rax),%eax
  801f72:	3c 7a                	cmp    $0x7a,%al
  801f74:	7f 12                	jg     801f88 <strtol+0x118>
			dig = *s - 'a' + 10;
  801f76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f7a:	0f b6 00             	movzbl (%rax),%eax
  801f7d:	0f be c0             	movsbl %al,%eax
  801f80:	83 e8 57             	sub    $0x57,%eax
  801f83:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f86:	eb 26                	jmp    801fae <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f8c:	0f b6 00             	movzbl (%rax),%eax
  801f8f:	3c 40                	cmp    $0x40,%al
  801f91:	7e 48                	jle    801fdb <strtol+0x16b>
  801f93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f97:	0f b6 00             	movzbl (%rax),%eax
  801f9a:	3c 5a                	cmp    $0x5a,%al
  801f9c:	7f 3d                	jg     801fdb <strtol+0x16b>
			dig = *s - 'A' + 10;
  801f9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa2:	0f b6 00             	movzbl (%rax),%eax
  801fa5:	0f be c0             	movsbl %al,%eax
  801fa8:	83 e8 37             	sub    $0x37,%eax
  801fab:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801fae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fb1:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801fb4:	7c 02                	jl     801fb8 <strtol+0x148>
			break;
  801fb6:	eb 23                	jmp    801fdb <strtol+0x16b>
		s++, val = (val * base) + dig;
  801fb8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801fbd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fc0:	48 98                	cltq   
  801fc2:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801fc7:	48 89 c2             	mov    %rax,%rdx
  801fca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fcd:	48 98                	cltq   
  801fcf:	48 01 d0             	add    %rdx,%rax
  801fd2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801fd6:	e9 5d ff ff ff       	jmpq   801f38 <strtol+0xc8>

	if (endptr)
  801fdb:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801fe0:	74 0b                	je     801fed <strtol+0x17d>
		*endptr = (char *) s;
  801fe2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fe6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fea:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801fed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ff1:	74 09                	je     801ffc <strtol+0x18c>
  801ff3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ff7:	48 f7 d8             	neg    %rax
  801ffa:	eb 04                	jmp    802000 <strtol+0x190>
  801ffc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802000:	c9                   	leaveq 
  802001:	c3                   	retq   

0000000000802002 <strstr>:

char * strstr(const char *in, const char *str)
{
  802002:	55                   	push   %rbp
  802003:	48 89 e5             	mov    %rsp,%rbp
  802006:	48 83 ec 30          	sub    $0x30,%rsp
  80200a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80200e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  802012:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802016:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80201a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80201e:	0f b6 00             	movzbl (%rax),%eax
  802021:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  802024:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802028:	75 06                	jne    802030 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80202a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80202e:	eb 6b                	jmp    80209b <strstr+0x99>

	len = strlen(str);
  802030:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802034:	48 89 c7             	mov    %rax,%rdi
  802037:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  80203e:	00 00 00 
  802041:	ff d0                	callq  *%rax
  802043:	48 98                	cltq   
  802045:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  802049:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802051:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802055:	0f b6 00             	movzbl (%rax),%eax
  802058:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80205b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80205f:	75 07                	jne    802068 <strstr+0x66>
				return (char *) 0;
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
  802066:	eb 33                	jmp    80209b <strstr+0x99>
		} while (sc != c);
  802068:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80206c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80206f:	75 d8                	jne    802049 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  802071:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802075:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802079:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80207d:	48 89 ce             	mov    %rcx,%rsi
  802080:	48 89 c7             	mov    %rax,%rdi
  802083:	48 b8 f9 1a 80 00 00 	movabs $0x801af9,%rax
  80208a:	00 00 00 
  80208d:	ff d0                	callq  *%rax
  80208f:	85 c0                	test   %eax,%eax
  802091:	75 b6                	jne    802049 <strstr+0x47>

	return (char *) (in - 1);
  802093:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802097:	48 83 e8 01          	sub    $0x1,%rax
}
  80209b:	c9                   	leaveq 
  80209c:	c3                   	retq   

000000000080209d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80209d:	55                   	push   %rbp
  80209e:	48 89 e5             	mov    %rsp,%rbp
  8020a1:	53                   	push   %rbx
  8020a2:	48 83 ec 48          	sub    $0x48,%rsp
  8020a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8020a9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8020ac:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8020b0:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8020b4:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8020b8:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020bf:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8020c3:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8020c7:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8020cb:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8020cf:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8020d3:	4c 89 c3             	mov    %r8,%rbx
  8020d6:	cd 30                	int    $0x30
  8020d8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8020dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8020e0:	74 3e                	je     802120 <syscall+0x83>
  8020e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8020e7:	7e 37                	jle    802120 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8020e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020ed:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020f0:	49 89 d0             	mov    %rdx,%r8
  8020f3:	89 c1                	mov    %eax,%ecx
  8020f5:	48 ba 28 5c 80 00 00 	movabs $0x805c28,%rdx
  8020fc:	00 00 00 
  8020ff:	be 23 00 00 00       	mov    $0x23,%esi
  802104:	48 bf 45 5c 80 00 00 	movabs $0x805c45,%rdi
  80210b:	00 00 00 
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
  802113:	49 b9 56 0b 80 00 00 	movabs $0x800b56,%r9
  80211a:	00 00 00 
  80211d:	41 ff d1             	callq  *%r9

	return ret;
  802120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802124:	48 83 c4 48          	add    $0x48,%rsp
  802128:	5b                   	pop    %rbx
  802129:	5d                   	pop    %rbp
  80212a:	c3                   	retq   

000000000080212b <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
  80212f:	48 83 ec 20          	sub    $0x20,%rsp
  802133:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802137:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80213b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80213f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802143:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80214a:	00 
  80214b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802151:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802157:	48 89 d1             	mov    %rdx,%rcx
  80215a:	48 89 c2             	mov    %rax,%rdx
  80215d:	be 00 00 00 00       	mov    $0x0,%esi
  802162:	bf 00 00 00 00       	mov    $0x0,%edi
  802167:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  80216e:	00 00 00 
  802171:	ff d0                	callq  *%rax
}
  802173:	c9                   	leaveq 
  802174:	c3                   	retq   

0000000000802175 <sys_cgetc>:

int
sys_cgetc(void)
{
  802175:	55                   	push   %rbp
  802176:	48 89 e5             	mov    %rsp,%rbp
  802179:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80217d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802184:	00 
  802185:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80218b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802191:	b9 00 00 00 00       	mov    $0x0,%ecx
  802196:	ba 00 00 00 00       	mov    $0x0,%edx
  80219b:	be 00 00 00 00       	mov    $0x0,%esi
  8021a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8021a5:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  8021ac:	00 00 00 
  8021af:	ff d0                	callq  *%rax
}
  8021b1:	c9                   	leaveq 
  8021b2:	c3                   	retq   

00000000008021b3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8021b3:	55                   	push   %rbp
  8021b4:	48 89 e5             	mov    %rsp,%rbp
  8021b7:	48 83 ec 10          	sub    $0x10,%rsp
  8021bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8021be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c1:	48 98                	cltq   
  8021c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021ca:	00 
  8021cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021dc:	48 89 c2             	mov    %rax,%rdx
  8021df:	be 01 00 00 00       	mov    $0x1,%esi
  8021e4:	bf 03 00 00 00       	mov    $0x3,%edi
  8021e9:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  8021f0:	00 00 00 
  8021f3:	ff d0                	callq  *%rax
}
  8021f5:	c9                   	leaveq 
  8021f6:	c3                   	retq   

00000000008021f7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8021f7:	55                   	push   %rbp
  8021f8:	48 89 e5             	mov    %rsp,%rbp
  8021fb:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8021ff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802206:	00 
  802207:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80220d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802213:	b9 00 00 00 00       	mov    $0x0,%ecx
  802218:	ba 00 00 00 00       	mov    $0x0,%edx
  80221d:	be 00 00 00 00       	mov    $0x0,%esi
  802222:	bf 02 00 00 00       	mov    $0x2,%edi
  802227:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  80222e:	00 00 00 
  802231:	ff d0                	callq  *%rax
}
  802233:	c9                   	leaveq 
  802234:	c3                   	retq   

0000000000802235 <sys_yield>:

void
sys_yield(void)
{
  802235:	55                   	push   %rbp
  802236:	48 89 e5             	mov    %rsp,%rbp
  802239:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80223d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802244:	00 
  802245:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80224b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802251:	b9 00 00 00 00       	mov    $0x0,%ecx
  802256:	ba 00 00 00 00       	mov    $0x0,%edx
  80225b:	be 00 00 00 00       	mov    $0x0,%esi
  802260:	bf 0b 00 00 00       	mov    $0xb,%edi
  802265:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  80226c:	00 00 00 
  80226f:	ff d0                	callq  *%rax
}
  802271:	c9                   	leaveq 
  802272:	c3                   	retq   

0000000000802273 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802273:	55                   	push   %rbp
  802274:	48 89 e5             	mov    %rsp,%rbp
  802277:	48 83 ec 20          	sub    $0x20,%rsp
  80227b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80227e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802282:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802285:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802288:	48 63 c8             	movslq %eax,%rcx
  80228b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80228f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802292:	48 98                	cltq   
  802294:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80229b:	00 
  80229c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022a2:	49 89 c8             	mov    %rcx,%r8
  8022a5:	48 89 d1             	mov    %rdx,%rcx
  8022a8:	48 89 c2             	mov    %rax,%rdx
  8022ab:	be 01 00 00 00       	mov    $0x1,%esi
  8022b0:	bf 04 00 00 00       	mov    $0x4,%edi
  8022b5:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  8022bc:	00 00 00 
  8022bf:	ff d0                	callq  *%rax
}
  8022c1:	c9                   	leaveq 
  8022c2:	c3                   	retq   

00000000008022c3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8022c3:	55                   	push   %rbp
  8022c4:	48 89 e5             	mov    %rsp,%rbp
  8022c7:	48 83 ec 30          	sub    $0x30,%rsp
  8022cb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8022d2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8022d5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8022d9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8022dd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022e0:	48 63 c8             	movslq %eax,%rcx
  8022e3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8022e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ea:	48 63 f0             	movslq %eax,%rsi
  8022ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f4:	48 98                	cltq   
  8022f6:	48 89 0c 24          	mov    %rcx,(%rsp)
  8022fa:	49 89 f9             	mov    %rdi,%r9
  8022fd:	49 89 f0             	mov    %rsi,%r8
  802300:	48 89 d1             	mov    %rdx,%rcx
  802303:	48 89 c2             	mov    %rax,%rdx
  802306:	be 01 00 00 00       	mov    $0x1,%esi
  80230b:	bf 05 00 00 00       	mov    $0x5,%edi
  802310:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  802317:	00 00 00 
  80231a:	ff d0                	callq  *%rax
}
  80231c:	c9                   	leaveq 
  80231d:	c3                   	retq   

000000000080231e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80231e:	55                   	push   %rbp
  80231f:	48 89 e5             	mov    %rsp,%rbp
  802322:	48 83 ec 20          	sub    $0x20,%rsp
  802326:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802329:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80232d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802331:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802334:	48 98                	cltq   
  802336:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80233d:	00 
  80233e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802344:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80234a:	48 89 d1             	mov    %rdx,%rcx
  80234d:	48 89 c2             	mov    %rax,%rdx
  802350:	be 01 00 00 00       	mov    $0x1,%esi
  802355:	bf 06 00 00 00       	mov    $0x6,%edi
  80235a:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  802361:	00 00 00 
  802364:	ff d0                	callq  *%rax
}
  802366:	c9                   	leaveq 
  802367:	c3                   	retq   

0000000000802368 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802368:	55                   	push   %rbp
  802369:	48 89 e5             	mov    %rsp,%rbp
  80236c:	48 83 ec 10          	sub    $0x10,%rsp
  802370:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802373:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802376:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802379:	48 63 d0             	movslq %eax,%rdx
  80237c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237f:	48 98                	cltq   
  802381:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802388:	00 
  802389:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80238f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802395:	48 89 d1             	mov    %rdx,%rcx
  802398:	48 89 c2             	mov    %rax,%rdx
  80239b:	be 01 00 00 00       	mov    $0x1,%esi
  8023a0:	bf 08 00 00 00       	mov    $0x8,%edi
  8023a5:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  8023ac:	00 00 00 
  8023af:	ff d0                	callq  *%rax
}
  8023b1:	c9                   	leaveq 
  8023b2:	c3                   	retq   

00000000008023b3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8023b3:	55                   	push   %rbp
  8023b4:	48 89 e5             	mov    %rsp,%rbp
  8023b7:	48 83 ec 20          	sub    $0x20,%rsp
  8023bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8023c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c9:	48 98                	cltq   
  8023cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023d2:	00 
  8023d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023df:	48 89 d1             	mov    %rdx,%rcx
  8023e2:	48 89 c2             	mov    %rax,%rdx
  8023e5:	be 01 00 00 00       	mov    $0x1,%esi
  8023ea:	bf 09 00 00 00       	mov    $0x9,%edi
  8023ef:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  8023f6:	00 00 00 
  8023f9:	ff d0                	callq  *%rax
}
  8023fb:	c9                   	leaveq 
  8023fc:	c3                   	retq   

00000000008023fd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8023fd:	55                   	push   %rbp
  8023fe:	48 89 e5             	mov    %rsp,%rbp
  802401:	48 83 ec 20          	sub    $0x20,%rsp
  802405:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802408:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80240c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802410:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802413:	48 98                	cltq   
  802415:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80241c:	00 
  80241d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802423:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802429:	48 89 d1             	mov    %rdx,%rcx
  80242c:	48 89 c2             	mov    %rax,%rdx
  80242f:	be 01 00 00 00       	mov    $0x1,%esi
  802434:	bf 0a 00 00 00       	mov    $0xa,%edi
  802439:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  802440:	00 00 00 
  802443:	ff d0                	callq  *%rax
}
  802445:	c9                   	leaveq 
  802446:	c3                   	retq   

0000000000802447 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802447:	55                   	push   %rbp
  802448:	48 89 e5             	mov    %rsp,%rbp
  80244b:	48 83 ec 20          	sub    $0x20,%rsp
  80244f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802452:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802456:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80245a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80245d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802460:	48 63 f0             	movslq %eax,%rsi
  802463:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802467:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246a:	48 98                	cltq   
  80246c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802470:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802477:	00 
  802478:	49 89 f1             	mov    %rsi,%r9
  80247b:	49 89 c8             	mov    %rcx,%r8
  80247e:	48 89 d1             	mov    %rdx,%rcx
  802481:	48 89 c2             	mov    %rax,%rdx
  802484:	be 00 00 00 00       	mov    $0x0,%esi
  802489:	bf 0c 00 00 00       	mov    $0xc,%edi
  80248e:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  802495:	00 00 00 
  802498:	ff d0                	callq  *%rax
}
  80249a:	c9                   	leaveq 
  80249b:	c3                   	retq   

000000000080249c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80249c:	55                   	push   %rbp
  80249d:	48 89 e5             	mov    %rsp,%rbp
  8024a0:	48 83 ec 10          	sub    $0x10,%rsp
  8024a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8024a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024b3:	00 
  8024b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8024c5:	48 89 c2             	mov    %rax,%rdx
  8024c8:	be 01 00 00 00       	mov    $0x1,%esi
  8024cd:	bf 0d 00 00 00       	mov    $0xd,%edi
  8024d2:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  8024d9:	00 00 00 
  8024dc:	ff d0                	callq  *%rax
}
  8024de:	c9                   	leaveq 
  8024df:	c3                   	retq   

00000000008024e0 <sys_net_tx>:

int
sys_net_tx(void *buf, size_t len)
{
  8024e0:	55                   	push   %rbp
  8024e1:	48 89 e5             	mov    %rsp,%rbp
  8024e4:	48 83 ec 20          	sub    $0x20,%rsp
  8024e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_net_tx, 1, (uint64_t)buf, len, 0, 0, 0);
  8024f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024ff:	00 
  802500:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802506:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80250c:	48 89 d1             	mov    %rdx,%rcx
  80250f:	48 89 c2             	mov    %rax,%rdx
  802512:	be 01 00 00 00       	mov    $0x1,%esi
  802517:	bf 0f 00 00 00       	mov    $0xf,%edi
  80251c:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  802523:	00 00 00 
  802526:	ff d0                	callq  *%rax
}
  802528:	c9                   	leaveq 
  802529:	c3                   	retq   

000000000080252a <sys_net_rx>:

int
sys_net_rx(void *buf)
{
  80252a:	55                   	push   %rbp
  80252b:	48 89 e5             	mov    %rsp,%rbp
  80252e:	48 83 ec 10          	sub    $0x10,%rsp
  802532:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_net_rx, 0, (uint64_t)buf, 0, 0, 0, 0);
  802536:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80253a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802541:	00 
  802542:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802548:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80254e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802553:	48 89 c2             	mov    %rax,%rdx
  802556:	be 00 00 00 00       	mov    $0x0,%esi
  80255b:	bf 10 00 00 00       	mov    $0x10,%edi
  802560:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  802567:	00 00 00 
  80256a:	ff d0                	callq  *%rax
}
  80256c:	c9                   	leaveq 
  80256d:	c3                   	retq   

000000000080256e <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80256e:	55                   	push   %rbp
  80256f:	48 89 e5             	mov    %rsp,%rbp
  802572:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802576:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80257d:	00 
  80257e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802584:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80258a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80258f:	ba 00 00 00 00       	mov    $0x0,%edx
  802594:	be 00 00 00 00       	mov    $0x0,%esi
  802599:	bf 0e 00 00 00       	mov    $0xe,%edi
  80259e:	48 b8 9d 20 80 00 00 	movabs $0x80209d,%rax
  8025a5:	00 00 00 
  8025a8:	ff d0                	callq  *%rax
}
  8025aa:	c9                   	leaveq 
  8025ab:	c3                   	retq   

00000000008025ac <pgfault>:
        return esp;
}

static void
pgfault(struct UTrapframe *utf)
{
  8025ac:	55                   	push   %rbp
  8025ad:	48 89 e5             	mov    %rsp,%rbp
  8025b0:	48 83 ec 30          	sub    $0x30,%rsp
  8025b4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8025b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025bc:	48 8b 00             	mov    (%rax),%rax
  8025bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  8025c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025cb:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	//cprintf("I am in user's page fault handler\n");
	if(!(err &FEC_WR)&&(uvpt[PPN(addr)]& PTE_COW))
  8025ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025d1:	83 e0 02             	and    $0x2,%eax
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	75 4d                	jne    802625 <pgfault+0x79>
  8025d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8025e0:	48 89 c2             	mov    %rax,%rdx
  8025e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025ea:	01 00 00 
  8025ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f1:	25 00 08 00 00       	and    $0x800,%eax
  8025f6:	48 85 c0             	test   %rax,%rax
  8025f9:	74 2a                	je     802625 <pgfault+0x79>
		panic("Page isnt writable/ COW, why did I get a pagefault \n");
  8025fb:	48 ba 58 5c 80 00 00 	movabs $0x805c58,%rdx
  802602:	00 00 00 
  802605:	be 23 00 00 00       	mov    $0x23,%esi
  80260a:	48 bf 8d 5c 80 00 00 	movabs $0x805c8d,%rdi
  802611:	00 00 00 
  802614:	b8 00 00 00 00       	mov    $0x0,%eax
  802619:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  802620:	00 00 00 
  802623:	ff d1                	callq  *%rcx
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.
	if(0 == sys_page_alloc(0,(void*)PFTEMP,PTE_U|PTE_P|PTE_W)){
  802625:	ba 07 00 00 00       	mov    $0x7,%edx
  80262a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80262f:	bf 00 00 00 00       	mov    $0x0,%edi
  802634:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  80263b:	00 00 00 
  80263e:	ff d0                	callq  *%rax
  802640:	85 c0                	test   %eax,%eax
  802642:	0f 85 cd 00 00 00    	jne    802715 <pgfault+0x169>
		Pageaddr = ROUNDDOWN(addr,PGSIZE);
  802648:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80264c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802654:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80265a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		memmove(PFTEMP, Pageaddr, PGSIZE);
  80265e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802662:	ba 00 10 00 00       	mov    $0x1000,%edx
  802667:	48 89 c6             	mov    %rax,%rsi
  80266a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80266f:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  802676:	00 00 00 
  802679:	ff d0                	callq  *%rax
		if(0> sys_page_map(0,PFTEMP,0,Pageaddr,PTE_U|PTE_P|PTE_W))
  80267b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80267f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802685:	48 89 c1             	mov    %rax,%rcx
  802688:	ba 00 00 00 00       	mov    $0x0,%edx
  80268d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802692:	bf 00 00 00 00       	mov    $0x0,%edi
  802697:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	callq  *%rax
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	79 2a                	jns    8026d1 <pgfault+0x125>
				panic("Page map at temp address failed");
  8026a7:	48 ba 98 5c 80 00 00 	movabs $0x805c98,%rdx
  8026ae:	00 00 00 
  8026b1:	be 30 00 00 00       	mov    $0x30,%esi
  8026b6:	48 bf 8d 5c 80 00 00 	movabs $0x805c8d,%rdi
  8026bd:	00 00 00 
  8026c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c5:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  8026cc:	00 00 00 
  8026cf:	ff d1                	callq  *%rcx
		if(0> sys_page_unmap(0,PFTEMP))
  8026d1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8026d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8026db:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  8026e2:	00 00 00 
  8026e5:	ff d0                	callq  *%rax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	79 54                	jns    80273f <pgfault+0x193>
				panic("Page unmap from temp location failed");
  8026eb:	48 ba b8 5c 80 00 00 	movabs $0x805cb8,%rdx
  8026f2:	00 00 00 
  8026f5:	be 32 00 00 00       	mov    $0x32,%esi
  8026fa:	48 bf 8d 5c 80 00 00 	movabs $0x805c8d,%rdi
  802701:	00 00 00 
  802704:	b8 00 00 00 00       	mov    $0x0,%eax
  802709:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  802710:	00 00 00 
  802713:	ff d1                	callq  *%rcx
	}else{
		panic("Page Allocation Failed during handling page fault");
  802715:	48 ba e0 5c 80 00 00 	movabs $0x805ce0,%rdx
  80271c:	00 00 00 
  80271f:	be 34 00 00 00       	mov    $0x34,%esi
  802724:	48 bf 8d 5c 80 00 00 	movabs $0x805c8d,%rdi
  80272b:	00 00 00 
  80272e:	b8 00 00 00 00       	mov    $0x0,%eax
  802733:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  80273a:	00 00 00 
  80273d:	ff d1                	callq  *%rcx
	}
	//panic("pgfault not implemented");
}
  80273f:	c9                   	leaveq 
  802740:	c3                   	retq   

0000000000802741 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802741:	55                   	push   %rbp
  802742:	48 89 e5             	mov    %rsp,%rbp
  802745:	48 83 ec 20          	sub    $0x20,%rsp
  802749:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80274c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	int perm = (uvpt[pn]) & PTE_SYSCALL; // Doubtful..
  80274f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802756:	01 00 00 
  802759:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80275c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802760:	25 07 0e 00 00       	and    $0xe07,%eax
  802765:	89 45 fc             	mov    %eax,-0x4(%rbp)
	void* addr = (void*)((uint64_t)pn *PGSIZE);
  802768:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80276b:	48 c1 e0 0c          	shl    $0xc,%rax
  80276f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("DuPpage: Incoming addr = [%x], permission = [%d]\n", addr,perm);
	// LAB 4: Your code  here.
	if(perm & PTE_SHARE){
  802773:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802776:	25 00 04 00 00       	and    $0x400,%eax
  80277b:	85 c0                	test   %eax,%eax
  80277d:	74 57                	je     8027d6 <duppage+0x95>
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  80277f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802782:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802786:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802789:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80278d:	41 89 f0             	mov    %esi,%r8d
  802790:	48 89 c6             	mov    %rax,%rsi
  802793:	bf 00 00 00 00       	mov    $0x0,%edi
  802798:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  80279f:	00 00 00 
  8027a2:	ff d0                	callq  *%rax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	0f 8e 52 01 00 00    	jle    8028fe <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8027ac:	48 ba 12 5d 80 00 00 	movabs $0x805d12,%rdx
  8027b3:	00 00 00 
  8027b6:	be 4e 00 00 00       	mov    $0x4e,%esi
  8027bb:	48 bf 8d 5c 80 00 00 	movabs $0x805c8d,%rdi
  8027c2:	00 00 00 
  8027c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ca:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  8027d1:	00 00 00 
  8027d4:	ff d1                	callq  *%rcx

	}else{
	if((perm & PTE_W || perm & PTE_COW)){
  8027d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d9:	83 e0 02             	and    $0x2,%eax
  8027dc:	85 c0                	test   %eax,%eax
  8027de:	75 10                	jne    8027f0 <duppage+0xaf>
  8027e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e3:	25 00 08 00 00       	and    $0x800,%eax
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	0f 84 bb 00 00 00    	je     8028ab <duppage+0x16a>
		perm = (perm|PTE_COW)&(~PTE_W);
  8027f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f3:	25 fd f7 ff ff       	and    $0xfffff7fd,%eax
  8027f8:	80 cc 08             	or     $0x8,%ah
  8027fb:	89 45 fc             	mov    %eax,-0x4(%rbp)

		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8027fe:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802801:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802805:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802808:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280c:	41 89 f0             	mov    %esi,%r8d
  80280f:	48 89 c6             	mov    %rax,%rsi
  802812:	bf 00 00 00 00       	mov    $0x0,%edi
  802817:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  80281e:	00 00 00 
  802821:	ff d0                	callq  *%rax
  802823:	85 c0                	test   %eax,%eax
  802825:	7e 2a                	jle    802851 <duppage+0x110>
			panic("Page alloc with COW  failed.\n");
  802827:	48 ba 12 5d 80 00 00 	movabs $0x805d12,%rdx
  80282e:	00 00 00 
  802831:	be 55 00 00 00       	mov    $0x55,%esi
  802836:	48 bf 8d 5c 80 00 00 	movabs $0x805c8d,%rdi
  80283d:	00 00 00 
  802840:	b8 00 00 00 00       	mov    $0x0,%eax
  802845:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  80284c:	00 00 00 
  80284f:	ff d1                	callq  *%rcx
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  802851:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802854:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802858:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285c:	41 89 c8             	mov    %ecx,%r8d
  80285f:	48 89 d1             	mov    %rdx,%rcx
  802862:	ba 00 00 00 00       	mov    $0x0,%edx
  802867:	48 89 c6             	mov    %rax,%rsi
  80286a:	bf 00 00 00 00       	mov    $0x0,%edi
  80286f:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  802876:	00 00 00 
  802879:	ff d0                	callq  *%rax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	7e 2a                	jle    8028a9 <duppage+0x168>
			panic("Page alloc with COW  failed.\n");
  80287f:	48 ba 12 5d 80 00 00 	movabs $0x805d12,%rdx
  802886:	00 00 00 
  802889:	be 57 00 00 00       	mov    $0x57,%esi
  80288e:	48 bf 8d 5c 80 00 00 	movabs $0x805c8d,%rdi
  802895:	00 00 00 
  802898:	b8 00 00 00 00       	mov    $0x0,%eax
  80289d:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  8028a4:	00 00 00 
  8028a7:	ff d1                	callq  *%rcx
	if((perm & PTE_W || perm & PTE_COW)){
		perm = (perm|PTE_COW)&(~PTE_W);

		if(0 < sys_page_map(0,addr,envid,addr,perm))
			panic("Page alloc with COW  failed.\n");
		if(0 <  sys_page_map(0,addr,0,addr,perm))
  8028a9:	eb 53                	jmp    8028fe <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
	}else{
	
		if(0 < sys_page_map(0,addr,envid,addr,perm))
  8028ab:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8028ae:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8028b2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8028b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b9:	41 89 f0             	mov    %esi,%r8d
  8028bc:	48 89 c6             	mov    %rax,%rsi
  8028bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8028c4:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  8028cb:	00 00 00 
  8028ce:	ff d0                	callq  *%rax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	7e 2a                	jle    8028fe <duppage+0x1bd>
			panic("Page alloc with COW  failed.\n");
  8028d4:	48 ba 12 5d 80 00 00 	movabs $0x805d12,%rdx
  8028db:	00 00 00 
  8028de:	be 5b 00 00 00       	mov    $0x5b,%esi
  8028e3:	48 bf 8d 5c 80 00 00 	movabs $0x805c8d,%rdi
  8028ea:	00 00 00 
  8028ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f2:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  8028f9:	00 00 00 
  8028fc:	ff d1                	callq  *%rcx
		}
	}

	//panic("duppage not implemented");
	
	return 0;
  8028fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802903:	c9                   	leaveq 
  802904:	c3                   	retq   

0000000000802905 <pt_is_mapped>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
bool
pt_is_mapped(void *va)
{
  802905:	55                   	push   %rbp
  802906:	48 89 e5             	mov    %rsp,%rbp
  802909:	48 83 ec 18          	sub    $0x18,%rsp
  80290d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t addr = (uint64_t)va;
  802911:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802915:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return (uvpml4e[VPML4E(addr)] & PTE_P) && (uvpde[VPDPE(addr<<12)] & PTE_P) && (uvpd[VPD(addr<<12)] & PTE_P);
  802919:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80291d:	48 c1 e8 27          	shr    $0x27,%rax
  802921:	48 89 c2             	mov    %rax,%rdx
  802924:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80292b:	01 00 00 
  80292e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802932:	83 e0 01             	and    $0x1,%eax
  802935:	48 85 c0             	test   %rax,%rax
  802938:	74 51                	je     80298b <pt_is_mapped+0x86>
  80293a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80293e:	48 c1 e0 0c          	shl    $0xc,%rax
  802942:	48 c1 e8 1e          	shr    $0x1e,%rax
  802946:	48 89 c2             	mov    %rax,%rdx
  802949:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802950:	01 00 00 
  802953:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802957:	83 e0 01             	and    $0x1,%eax
  80295a:	48 85 c0             	test   %rax,%rax
  80295d:	74 2c                	je     80298b <pt_is_mapped+0x86>
  80295f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802963:	48 c1 e0 0c          	shl    $0xc,%rax
  802967:	48 c1 e8 15          	shr    $0x15,%rax
  80296b:	48 89 c2             	mov    %rax,%rdx
  80296e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802975:	01 00 00 
  802978:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80297c:	83 e0 01             	and    $0x1,%eax
  80297f:	48 85 c0             	test   %rax,%rax
  802982:	74 07                	je     80298b <pt_is_mapped+0x86>
  802984:	b8 01 00 00 00       	mov    $0x1,%eax
  802989:	eb 05                	jmp    802990 <pt_is_mapped+0x8b>
  80298b:	b8 00 00 00 00       	mov    $0x0,%eax
  802990:	83 e0 01             	and    $0x1,%eax
}
  802993:	c9                   	leaveq 
  802994:	c3                   	retq   

0000000000802995 <fork>:

envid_t
fork(void)
{
  802995:	55                   	push   %rbp
  802996:	48 89 e5             	mov    %rsp,%rbp
  802999:	48 83 ec 20          	sub    $0x20,%rsp
	// LAB 4: Your code here.
	envid_t envid;
	int r;
	uint64_t i;
	uint64_t addr, last;
	set_pgfault_handler(pgfault);
  80299d:	48 bf ac 25 80 00 00 	movabs $0x8025ac,%rdi
  8029a4:	00 00 00 
  8029a7:	48 b8 bc 4e 80 00 00 	movabs $0x804ebc,%rax
  8029ae:	00 00 00 
  8029b1:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8029b3:	b8 07 00 00 00       	mov    $0x7,%eax
  8029b8:	cd 30                	int    $0x30
  8029ba:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8029bd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
	envid = sys_exofork();
  8029c0:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if(envid < 0)
  8029c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029c7:	79 30                	jns    8029f9 <fork+0x64>
		panic("\nsys_exofork error: %e\n", envid);
  8029c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029cc:	89 c1                	mov    %eax,%ecx
  8029ce:	48 ba 30 5d 80 00 00 	movabs $0x805d30,%rdx
  8029d5:	00 00 00 
  8029d8:	be 86 00 00 00       	mov    $0x86,%esi
  8029dd:	48 bf 8d 5c 80 00 00 	movabs $0x805c8d,%rdi
  8029e4:	00 00 00 
  8029e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ec:	49 b8 56 0b 80 00 00 	movabs $0x800b56,%r8
  8029f3:	00 00 00 
  8029f6:	41 ff d0             	callq  *%r8
    else if(envid == 0)
  8029f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029fd:	75 46                	jne    802a45 <fork+0xb0>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8029ff:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
  802a0b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802a10:	48 63 d0             	movslq %eax,%rdx
  802a13:	48 89 d0             	mov    %rdx,%rax
  802a16:	48 c1 e0 03          	shl    $0x3,%rax
  802a1a:	48 01 d0             	add    %rdx,%rax
  802a1d:	48 c1 e0 05          	shl    $0x5,%rax
  802a21:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a28:	00 00 00 
  802a2b:	48 01 c2             	add    %rax,%rdx
  802a2e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802a35:	00 00 00 
  802a38:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a40:	e9 d1 01 00 00       	jmpq   802c16 <fork+0x281>
	}
	uint64_t ad = 0;
  802a45:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802a4c:	00 
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802a4d:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  802a52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802a56:	e9 df 00 00 00       	jmpq   802b3a <fork+0x1a5>
	/*Do we really need to scan all the pages????*/
		if(uvpml4e[VPML4E(addr)]& PTE_P){
  802a5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a5f:	48 c1 e8 27          	shr    $0x27,%rax
  802a63:	48 89 c2             	mov    %rax,%rdx
  802a66:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802a6d:	01 00 00 
  802a70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a74:	83 e0 01             	and    $0x1,%eax
  802a77:	48 85 c0             	test   %rax,%rax
  802a7a:	0f 84 9e 00 00 00    	je     802b1e <fork+0x189>
			if( uvpde[VPDPE(addr)] & PTE_P){
  802a80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a84:	48 c1 e8 1e          	shr    $0x1e,%rax
  802a88:	48 89 c2             	mov    %rax,%rdx
  802a8b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802a92:	01 00 00 
  802a95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a99:	83 e0 01             	and    $0x1,%eax
  802a9c:	48 85 c0             	test   %rax,%rax
  802a9f:	74 73                	je     802b14 <fork+0x17f>
				if( uvpd[VPD(addr)] & PTE_P){
  802aa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aa5:	48 c1 e8 15          	shr    $0x15,%rax
  802aa9:	48 89 c2             	mov    %rax,%rdx
  802aac:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ab3:	01 00 00 
  802ab6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aba:	83 e0 01             	and    $0x1,%eax
  802abd:	48 85 c0             	test   %rax,%rax
  802ac0:	74 48                	je     802b0a <fork+0x175>
					if((ad =uvpt[VPN(addr)])& PTE_P){
  802ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ac6:	48 c1 e8 0c          	shr    $0xc,%rax
  802aca:	48 89 c2             	mov    %rax,%rdx
  802acd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ad4:	01 00 00 
  802ad7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802adb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802adf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae3:	83 e0 01             	and    $0x1,%eax
  802ae6:	48 85 c0             	test   %rax,%rax
  802ae9:	74 47                	je     802b32 <fork+0x19d>
						//cprintf("hi\n");
						//cprintf("addr = [%x]\n",ad);
						duppage(envid, VPN(addr));	
  802aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802aef:	48 c1 e8 0c          	shr    $0xc,%rax
  802af3:	89 c2                	mov    %eax,%edx
  802af5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802af8:	89 d6                	mov    %edx,%esi
  802afa:	89 c7                	mov    %eax,%edi
  802afc:	48 b8 41 27 80 00 00 	movabs $0x802741,%rax
  802b03:	00 00 00 
  802b06:	ff d0                	callq  *%rax
  802b08:	eb 28                	jmp    802b32 <fork+0x19d>
					}
				}else{
					addr -= NPDENTRIES*PGSIZE;
  802b0a:	48 81 6d f8 00 00 20 	subq   $0x200000,-0x8(%rbp)
  802b11:	00 
  802b12:	eb 1e                	jmp    802b32 <fork+0x19d>
					//addr -= ((VPD(addr)+1)<<PDXSHIFT);
				}
			}else{
				addr -= NPDENTRIES*NPDENTRIES*PGSIZE;
  802b14:	48 81 6d f8 00 00 00 	subq   $0x40000000,-0x8(%rbp)
  802b1b:	40 
  802b1c:	eb 14                	jmp    802b32 <fork+0x19d>
				//addr -= ((VPDPE(addr)+1)<<PDPESHIFT);
			}
	
		}else{
		/*uvpml4e.. move by */
			addr -= ((VPML4E(addr)+1)<<PML4SHIFT)
  802b1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b22:	48 c1 e8 27          	shr    $0x27,%rax
  802b26:	48 83 c0 01          	add    $0x1,%rax
  802b2a:	48 c1 e0 27          	shl    $0x27,%rax
  802b2e:	48 29 45 f8          	sub    %rax,-0x8(%rbp)
	{
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	uint64_t ad = 0;
	for (addr = (uint64_t)USTACKTOP-PGSIZE; addr >=(uint64_t)UTEXT; addr -= PGSIZE){  // Is this enough, am I leaving a bug for future here???	
  802b32:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802b39:	00 
  802b3a:	48 81 7d f8 ff ff 7f 	cmpq   $0x7fffff,-0x8(%rbp)
  802b41:	00 
  802b42:	0f 87 13 ff ff ff    	ja     802a5b <fork+0xc6>
		}
	
	}


	sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802b48:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b4b:	ba 07 00 00 00       	mov    $0x7,%edx
  802b50:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802b55:	89 c7                	mov    %eax,%edi
  802b57:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  802b5e:	00 00 00 
  802b61:	ff d0                	callq  *%rax

	sys_page_alloc(envid, (void*)(USTACKTOP - PGSIZE),PTE_P|PTE_U|PTE_W); 
  802b63:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b66:	ba 07 00 00 00       	mov    $0x7,%edx
  802b6b:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802b70:	89 c7                	mov    %eax,%edi
  802b72:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  802b79:	00 00 00 
  802b7c:	ff d0                	callq  *%rax

	sys_page_map(envid, (void*)(USTACKTOP - PGSIZE), 0, PFTEMP,PTE_P|PTE_U|PTE_W);
  802b7e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b81:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802b87:	b9 00 f0 5f 00       	mov    $0x5ff000,%ecx
  802b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b91:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802b96:	89 c7                	mov    %eax,%edi
  802b98:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  802b9f:	00 00 00 
  802ba2:	ff d0                	callq  *%rax

	memmove(PFTEMP, (void*)(USTACKTOP-PGSIZE), PGSIZE);
  802ba4:	ba 00 10 00 00       	mov    $0x1000,%edx
  802ba9:	be 00 d0 7f ef       	mov    $0xef7fd000,%esi
  802bae:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802bb3:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  802bba:	00 00 00 
  802bbd:	ff d0                	callq  *%rax

	sys_page_unmap(0, PFTEMP);
  802bbf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802bc4:	bf 00 00 00 00       	mov    $0x0,%edi
  802bc9:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  802bd0:	00 00 00 
  802bd3:	ff d0                	callq  *%rax

    sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall); 
  802bd5:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802bdc:	00 00 00 
  802bdf:	48 8b 00             	mov    (%rax),%rax
  802be2:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802be9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bec:	48 89 d6             	mov    %rdx,%rsi
  802bef:	89 c7                	mov    %eax,%edi
  802bf1:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  802bf8:	00 00 00 
  802bfb:	ff d0                	callq  *%rax
	
	sys_env_set_status(envid, ENV_RUNNABLE);
  802bfd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c00:	be 02 00 00 00       	mov    $0x2,%esi
  802c05:	89 c7                	mov    %eax,%edi
  802c07:	48 b8 68 23 80 00 00 	movabs $0x802368,%rax
  802c0e:	00 00 00 
  802c11:	ff d0                	callq  *%rax

	return envid;
  802c13:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  802c16:	c9                   	leaveq 
  802c17:	c3                   	retq   

0000000000802c18 <sfork>:

	
// Challenge!
int
sfork(void)
{
  802c18:	55                   	push   %rbp
  802c19:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802c1c:	48 ba 48 5d 80 00 00 	movabs $0x805d48,%rdx
  802c23:	00 00 00 
  802c26:	be bf 00 00 00       	mov    $0xbf,%esi
  802c2b:	48 bf 8d 5c 80 00 00 	movabs $0x805c8d,%rdi
  802c32:	00 00 00 
  802c35:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3a:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  802c41:	00 00 00 
  802c44:	ff d1                	callq  *%rcx

0000000000802c46 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c46:	55                   	push   %rbp
  802c47:	48 89 e5             	mov    %rsp,%rbp
  802c4a:	48 83 ec 30          	sub    $0x30,%rsp
  802c4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c52:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c56:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int result;
	if(thisenv->env_status== 0){
  802c5a:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802c61:	00 00 00 
  802c64:	48 8b 00             	mov    (%rax),%rax
  802c67:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  802c6d:	85 c0                	test   %eax,%eax
  802c6f:	75 3c                	jne    802cad <ipc_recv+0x67>
		thisenv = &envs[ENVX(sys_getenvid())];
  802c71:	48 b8 f7 21 80 00 00 	movabs $0x8021f7,%rax
  802c78:	00 00 00 
  802c7b:	ff d0                	callq  *%rax
  802c7d:	25 ff 03 00 00       	and    $0x3ff,%eax
  802c82:	48 63 d0             	movslq %eax,%rdx
  802c85:	48 89 d0             	mov    %rdx,%rax
  802c88:	48 c1 e0 03          	shl    $0x3,%rax
  802c8c:	48 01 d0             	add    %rdx,%rax
  802c8f:	48 c1 e0 05          	shl    $0x5,%rax
  802c93:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802c9a:	00 00 00 
  802c9d:	48 01 c2             	add    %rax,%rdx
  802ca0:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802ca7:	00 00 00 
  802caa:	48 89 10             	mov    %rdx,(%rax)
	}
	if(!pg)
  802cad:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802cb2:	75 0e                	jne    802cc2 <ipc_recv+0x7c>
		pg = (void*) UTOP;
  802cb4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802cbb:	00 00 00 
  802cbe:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	result = sys_ipc_recv(pg);
  802cc2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cc6:	48 89 c7             	mov    %rax,%rdi
  802cc9:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  802cd0:	00 00 00 
  802cd3:	ff d0                	callq  *%rax
  802cd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(result< 0){
  802cd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdc:	79 19                	jns    802cf7 <ipc_recv+0xb1>
		*from_env_store = 0;
  802cde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store =0;
  802ce8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cec:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return result;
  802cf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf5:	eb 53                	jmp    802d4a <ipc_recv+0x104>
	}
	if(from_env_store)
  802cf7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802cfc:	74 19                	je     802d17 <ipc_recv+0xd1>
		*from_env_store = thisenv->env_ipc_from;
  802cfe:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802d05:	00 00 00 
  802d08:	48 8b 00             	mov    (%rax),%rax
  802d0b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802d11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d15:	89 10                	mov    %edx,(%rax)
	if(perm_store)
  802d17:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d1c:	74 19                	je     802d37 <ipc_recv+0xf1>
		*perm_store = thisenv->env_ipc_perm;
  802d1e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802d25:	00 00 00 
  802d28:	48 8b 00             	mov    (%rax),%rax
  802d2b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802d31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d35:	89 10                	mov    %edx,(%rax)
	
	//cprintf("I am IPC Recv, sending value[%d] my env id is [%d]and status is [%d] and I am sending to [%d]",thisenv->env_ipc_value,thisenv->env_id,thisenv->env_status,thisenv->env_ipc_from);	
	return thisenv->env_ipc_value;
  802d37:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802d3e:	00 00 00 
  802d41:	48 8b 00             	mov    (%rax),%rax
  802d44:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

	//panic("ipc_recv not implemented");
}
  802d4a:	c9                   	leaveq 
  802d4b:	c3                   	retq   

0000000000802d4c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802d4c:	55                   	push   %rbp
  802d4d:	48 89 e5             	mov    %rsp,%rbp
  802d50:	48 83 ec 30          	sub    $0x30,%rsp
  802d54:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d57:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802d5a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802d5e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result;
	if(!pg)
  802d61:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d66:	75 0e                	jne    802d76 <ipc_send+0x2a>
		pg = (void*)UTOP;
  802d68:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802d6f:	00 00 00 
  802d72:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	do{
	 	result = sys_ipc_try_send(to_env,val,pg,perm);
  802d76:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802d79:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802d7c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d83:	89 c7                	mov    %eax,%edi
  802d85:	48 b8 47 24 80 00 00 	movabs $0x802447,%rax
  802d8c:	00 00 00 
  802d8f:	ff d0                	callq  *%rax
  802d91:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(-E_IPC_NOT_RECV == result)
  802d94:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802d98:	75 0c                	jne    802da6 <ipc_send+0x5a>
			sys_yield();
  802d9a:	48 b8 35 22 80 00 00 	movabs $0x802235,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
	}while(-E_IPC_NOT_RECV == result);
  802da6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802daa:	74 ca                	je     802d76 <ipc_send+0x2a>
	
	//panic("ipc_send not implemented");
}
  802dac:	c9                   	leaveq 
  802dad:	c3                   	retq   

0000000000802dae <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802dae:	55                   	push   %rbp
  802daf:	48 89 e5             	mov    %rsp,%rbp
  802db2:	48 83 ec 14          	sub    $0x14,%rsp
  802db6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802db9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802dc0:	eb 5e                	jmp    802e20 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802dc2:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802dc9:	00 00 00 
  802dcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcf:	48 63 d0             	movslq %eax,%rdx
  802dd2:	48 89 d0             	mov    %rdx,%rax
  802dd5:	48 c1 e0 03          	shl    $0x3,%rax
  802dd9:	48 01 d0             	add    %rdx,%rax
  802ddc:	48 c1 e0 05          	shl    $0x5,%rax
  802de0:	48 01 c8             	add    %rcx,%rax
  802de3:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802de9:	8b 00                	mov    (%rax),%eax
  802deb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802dee:	75 2c                	jne    802e1c <ipc_find_env+0x6e>
			return envs[i].env_id;
  802df0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802df7:	00 00 00 
  802dfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfd:	48 63 d0             	movslq %eax,%rdx
  802e00:	48 89 d0             	mov    %rdx,%rax
  802e03:	48 c1 e0 03          	shl    $0x3,%rax
  802e07:	48 01 d0             	add    %rdx,%rax
  802e0a:	48 c1 e0 05          	shl    $0x5,%rax
  802e0e:	48 01 c8             	add    %rcx,%rax
  802e11:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802e17:	8b 40 08             	mov    0x8(%rax),%eax
  802e1a:	eb 12                	jmp    802e2e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802e1c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e20:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802e27:	7e 99                	jle    802dc2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2e:	c9                   	leaveq 
  802e2f:	c3                   	retq   

0000000000802e30 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802e30:	55                   	push   %rbp
  802e31:	48 89 e5             	mov    %rsp,%rbp
  802e34:	48 83 ec 08          	sub    $0x8,%rsp
  802e38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802e3c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e40:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802e47:	ff ff ff 
  802e4a:	48 01 d0             	add    %rdx,%rax
  802e4d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802e51:	c9                   	leaveq 
  802e52:	c3                   	retq   

0000000000802e53 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802e53:	55                   	push   %rbp
  802e54:	48 89 e5             	mov    %rsp,%rbp
  802e57:	48 83 ec 08          	sub    $0x8,%rsp
  802e5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802e5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e63:	48 89 c7             	mov    %rax,%rdi
  802e66:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  802e6d:	00 00 00 
  802e70:	ff d0                	callq  *%rax
  802e72:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802e78:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802e7c:	c9                   	leaveq 
  802e7d:	c3                   	retq   

0000000000802e7e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802e7e:	55                   	push   %rbp
  802e7f:	48 89 e5             	mov    %rsp,%rbp
  802e82:	48 83 ec 18          	sub    $0x18,%rsp
  802e86:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802e8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e91:	eb 6b                	jmp    802efe <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802e93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e96:	48 98                	cltq   
  802e98:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e9e:	48 c1 e0 0c          	shl    $0xc,%rax
  802ea2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802ea6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eaa:	48 c1 e8 15          	shr    $0x15,%rax
  802eae:	48 89 c2             	mov    %rax,%rdx
  802eb1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802eb8:	01 00 00 
  802ebb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ebf:	83 e0 01             	and    $0x1,%eax
  802ec2:	48 85 c0             	test   %rax,%rax
  802ec5:	74 21                	je     802ee8 <fd_alloc+0x6a>
  802ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ecb:	48 c1 e8 0c          	shr    $0xc,%rax
  802ecf:	48 89 c2             	mov    %rax,%rdx
  802ed2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ed9:	01 00 00 
  802edc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ee0:	83 e0 01             	and    $0x1,%eax
  802ee3:	48 85 c0             	test   %rax,%rax
  802ee6:	75 12                	jne    802efa <fd_alloc+0x7c>
			*fd_store = fd;
  802ee8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ef0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef8:	eb 1a                	jmp    802f14 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802efa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802efe:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802f02:	7e 8f                	jle    802e93 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802f04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f08:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802f0f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802f14:	c9                   	leaveq 
  802f15:	c3                   	retq   

0000000000802f16 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802f16:	55                   	push   %rbp
  802f17:	48 89 e5             	mov    %rsp,%rbp
  802f1a:	48 83 ec 20          	sub    $0x20,%rsp
  802f1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802f25:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f29:	78 06                	js     802f31 <fd_lookup+0x1b>
  802f2b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802f2f:	7e 07                	jle    802f38 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802f31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f36:	eb 6c                	jmp    802fa4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802f38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f3b:	48 98                	cltq   
  802f3d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802f43:	48 c1 e0 0c          	shl    $0xc,%rax
  802f47:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802f4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f4f:	48 c1 e8 15          	shr    $0x15,%rax
  802f53:	48 89 c2             	mov    %rax,%rdx
  802f56:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802f5d:	01 00 00 
  802f60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f64:	83 e0 01             	and    $0x1,%eax
  802f67:	48 85 c0             	test   %rax,%rax
  802f6a:	74 21                	je     802f8d <fd_lookup+0x77>
  802f6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f70:	48 c1 e8 0c          	shr    $0xc,%rax
  802f74:	48 89 c2             	mov    %rax,%rdx
  802f77:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f7e:	01 00 00 
  802f81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f85:	83 e0 01             	and    $0x1,%eax
  802f88:	48 85 c0             	test   %rax,%rax
  802f8b:	75 07                	jne    802f94 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802f8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f92:	eb 10                	jmp    802fa4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802f94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f98:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f9c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802f9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fa4:	c9                   	leaveq 
  802fa5:	c3                   	retq   

0000000000802fa6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802fa6:	55                   	push   %rbp
  802fa7:	48 89 e5             	mov    %rsp,%rbp
  802faa:	48 83 ec 30          	sub    $0x30,%rsp
  802fae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fb2:	89 f0                	mov    %esi,%eax
  802fb4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802fb7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fbb:	48 89 c7             	mov    %rax,%rdi
  802fbe:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
  802fca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fce:	48 89 d6             	mov    %rdx,%rsi
  802fd1:	89 c7                	mov    %eax,%edi
  802fd3:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  802fda:	00 00 00 
  802fdd:	ff d0                	callq  *%rax
  802fdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe6:	78 0a                	js     802ff2 <fd_close+0x4c>
	    || fd != fd2)
  802fe8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fec:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802ff0:	74 12                	je     803004 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802ff2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802ff6:	74 05                	je     802ffd <fd_close+0x57>
  802ff8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffb:	eb 05                	jmp    803002 <fd_close+0x5c>
  802ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  803002:	eb 69                	jmp    80306d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803004:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803008:	8b 00                	mov    (%rax),%eax
  80300a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80300e:	48 89 d6             	mov    %rdx,%rsi
  803011:	89 c7                	mov    %eax,%edi
  803013:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  80301a:	00 00 00 
  80301d:	ff d0                	callq  *%rax
  80301f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803022:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803026:	78 2a                	js     803052 <fd_close+0xac>
		if (dev->dev_close)
  803028:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302c:	48 8b 40 20          	mov    0x20(%rax),%rax
  803030:	48 85 c0             	test   %rax,%rax
  803033:	74 16                	je     80304b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  803035:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803039:	48 8b 40 20          	mov    0x20(%rax),%rax
  80303d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803041:	48 89 d7             	mov    %rdx,%rdi
  803044:	ff d0                	callq  *%rax
  803046:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803049:	eb 07                	jmp    803052 <fd_close+0xac>
		else
			r = 0;
  80304b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803052:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803056:	48 89 c6             	mov    %rax,%rsi
  803059:	bf 00 00 00 00       	mov    $0x0,%edi
  80305e:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  803065:	00 00 00 
  803068:	ff d0                	callq  *%rax
	return r;
  80306a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80306d:	c9                   	leaveq 
  80306e:	c3                   	retq   

000000000080306f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80306f:	55                   	push   %rbp
  803070:	48 89 e5             	mov    %rsp,%rbp
  803073:	48 83 ec 20          	sub    $0x20,%rsp
  803077:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80307a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80307e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803085:	eb 41                	jmp    8030c8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803087:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80308e:	00 00 00 
  803091:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803094:	48 63 d2             	movslq %edx,%rdx
  803097:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80309b:	8b 00                	mov    (%rax),%eax
  80309d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8030a0:	75 22                	jne    8030c4 <dev_lookup+0x55>
			*dev = devtab[i];
  8030a2:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8030a9:	00 00 00 
  8030ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030af:	48 63 d2             	movslq %edx,%rdx
  8030b2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8030b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ba:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8030bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c2:	eb 60                	jmp    803124 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8030c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8030c8:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8030cf:	00 00 00 
  8030d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030d5:	48 63 d2             	movslq %edx,%rdx
  8030d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030dc:	48 85 c0             	test   %rax,%rax
  8030df:	75 a6                	jne    803087 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8030e1:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8030e8:	00 00 00 
  8030eb:	48 8b 00             	mov    (%rax),%rax
  8030ee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030f7:	89 c6                	mov    %eax,%esi
  8030f9:	48 bf 60 5d 80 00 00 	movabs $0x805d60,%rdi
  803100:	00 00 00 
  803103:	b8 00 00 00 00       	mov    $0x0,%eax
  803108:	48 b9 8f 0d 80 00 00 	movabs $0x800d8f,%rcx
  80310f:	00 00 00 
  803112:	ff d1                	callq  *%rcx
	*dev = 0;
  803114:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803118:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80311f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803124:	c9                   	leaveq 
  803125:	c3                   	retq   

0000000000803126 <close>:

int
close(int fdnum)
{
  803126:	55                   	push   %rbp
  803127:	48 89 e5             	mov    %rsp,%rbp
  80312a:	48 83 ec 20          	sub    $0x20,%rsp
  80312e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803131:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803138:	48 89 d6             	mov    %rdx,%rsi
  80313b:	89 c7                	mov    %eax,%edi
  80313d:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803144:	00 00 00 
  803147:	ff d0                	callq  *%rax
  803149:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803150:	79 05                	jns    803157 <close+0x31>
		return r;
  803152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803155:	eb 18                	jmp    80316f <close+0x49>
	else
		return fd_close(fd, 1);
  803157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80315b:	be 01 00 00 00       	mov    $0x1,%esi
  803160:	48 89 c7             	mov    %rax,%rdi
  803163:	48 b8 a6 2f 80 00 00 	movabs $0x802fa6,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
}
  80316f:	c9                   	leaveq 
  803170:	c3                   	retq   

0000000000803171 <close_all>:

void
close_all(void)
{
  803171:	55                   	push   %rbp
  803172:	48 89 e5             	mov    %rsp,%rbp
  803175:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803180:	eb 15                	jmp    803197 <close_all+0x26>
		close(i);
  803182:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803185:	89 c7                	mov    %eax,%edi
  803187:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  80318e:	00 00 00 
  803191:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803193:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803197:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80319b:	7e e5                	jle    803182 <close_all+0x11>
		close(i);
}
  80319d:	c9                   	leaveq 
  80319e:	c3                   	retq   

000000000080319f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80319f:	55                   	push   %rbp
  8031a0:	48 89 e5             	mov    %rsp,%rbp
  8031a3:	48 83 ec 40          	sub    $0x40,%rsp
  8031a7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8031aa:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8031ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8031b1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8031b4:	48 89 d6             	mov    %rdx,%rsi
  8031b7:	89 c7                	mov    %eax,%edi
  8031b9:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  8031c0:	00 00 00 
  8031c3:	ff d0                	callq  *%rax
  8031c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031cc:	79 08                	jns    8031d6 <dup+0x37>
		return r;
  8031ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d1:	e9 70 01 00 00       	jmpq   803346 <dup+0x1a7>
	close(newfdnum);
  8031d6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8031d9:	89 c7                	mov    %eax,%edi
  8031db:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  8031e2:	00 00 00 
  8031e5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8031e7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8031ea:	48 98                	cltq   
  8031ec:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8031f2:	48 c1 e0 0c          	shl    $0xc,%rax
  8031f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8031fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031fe:	48 89 c7             	mov    %rax,%rdi
  803201:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  803208:	00 00 00 
  80320b:	ff d0                	callq  *%rax
  80320d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803215:	48 89 c7             	mov    %rax,%rdi
  803218:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  80321f:	00 00 00 
  803222:	ff d0                	callq  *%rax
  803224:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80322c:	48 c1 e8 15          	shr    $0x15,%rax
  803230:	48 89 c2             	mov    %rax,%rdx
  803233:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80323a:	01 00 00 
  80323d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803241:	83 e0 01             	and    $0x1,%eax
  803244:	48 85 c0             	test   %rax,%rax
  803247:	74 73                	je     8032bc <dup+0x11d>
  803249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80324d:	48 c1 e8 0c          	shr    $0xc,%rax
  803251:	48 89 c2             	mov    %rax,%rdx
  803254:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80325b:	01 00 00 
  80325e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803262:	83 e0 01             	and    $0x1,%eax
  803265:	48 85 c0             	test   %rax,%rax
  803268:	74 52                	je     8032bc <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80326a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80326e:	48 c1 e8 0c          	shr    $0xc,%rax
  803272:	48 89 c2             	mov    %rax,%rdx
  803275:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80327c:	01 00 00 
  80327f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803283:	25 07 0e 00 00       	and    $0xe07,%eax
  803288:	89 c1                	mov    %eax,%ecx
  80328a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80328e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803292:	41 89 c8             	mov    %ecx,%r8d
  803295:	48 89 d1             	mov    %rdx,%rcx
  803298:	ba 00 00 00 00       	mov    $0x0,%edx
  80329d:	48 89 c6             	mov    %rax,%rsi
  8032a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a5:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  8032ac:	00 00 00 
  8032af:	ff d0                	callq  *%rax
  8032b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b8:	79 02                	jns    8032bc <dup+0x11d>
			goto err;
  8032ba:	eb 57                	jmp    803313 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8032bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c0:	48 c1 e8 0c          	shr    $0xc,%rax
  8032c4:	48 89 c2             	mov    %rax,%rdx
  8032c7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8032ce:	01 00 00 
  8032d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8032da:	89 c1                	mov    %eax,%ecx
  8032dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032e4:	41 89 c8             	mov    %ecx,%r8d
  8032e7:	48 89 d1             	mov    %rdx,%rcx
  8032ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ef:	48 89 c6             	mov    %rax,%rsi
  8032f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f7:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  8032fe:	00 00 00 
  803301:	ff d0                	callq  *%rax
  803303:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803306:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80330a:	79 02                	jns    80330e <dup+0x16f>
		goto err;
  80330c:	eb 05                	jmp    803313 <dup+0x174>

	return newfdnum;
  80330e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803311:	eb 33                	jmp    803346 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  803313:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803317:	48 89 c6             	mov    %rax,%rsi
  80331a:	bf 00 00 00 00       	mov    $0x0,%edi
  80331f:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  803326:	00 00 00 
  803329:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80332b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80332f:	48 89 c6             	mov    %rax,%rsi
  803332:	bf 00 00 00 00       	mov    $0x0,%edi
  803337:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  80333e:	00 00 00 
  803341:	ff d0                	callq  *%rax
	return r;
  803343:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803346:	c9                   	leaveq 
  803347:	c3                   	retq   

0000000000803348 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803348:	55                   	push   %rbp
  803349:	48 89 e5             	mov    %rsp,%rbp
  80334c:	48 83 ec 40          	sub    $0x40,%rsp
  803350:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803353:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803357:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	//cprintf("Inside Read");
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80335b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80335f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803362:	48 89 d6             	mov    %rdx,%rsi
  803365:	89 c7                	mov    %eax,%edi
  803367:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  80336e:	00 00 00 
  803371:	ff d0                	callq  *%rax
  803373:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803376:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80337a:	78 24                	js     8033a0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80337c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803380:	8b 00                	mov    (%rax),%eax
  803382:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803386:	48 89 d6             	mov    %rdx,%rsi
  803389:	89 c7                	mov    %eax,%edi
  80338b:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
  803397:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80339a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80339e:	79 05                	jns    8033a5 <read+0x5d>
		return r;
  8033a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a3:	eb 76                	jmp    80341b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8033a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a9:	8b 40 08             	mov    0x8(%rax),%eax
  8033ac:	83 e0 03             	and    $0x3,%eax
  8033af:	83 f8 01             	cmp    $0x1,%eax
  8033b2:	75 3a                	jne    8033ee <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8033b4:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8033bb:	00 00 00 
  8033be:	48 8b 00             	mov    (%rax),%rax
  8033c1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8033c7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8033ca:	89 c6                	mov    %eax,%esi
  8033cc:	48 bf 7f 5d 80 00 00 	movabs $0x805d7f,%rdi
  8033d3:	00 00 00 
  8033d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033db:	48 b9 8f 0d 80 00 00 	movabs $0x800d8f,%rcx
  8033e2:	00 00 00 
  8033e5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8033e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8033ec:	eb 2d                	jmp    80341b <read+0xd3>
	}
	if (!dev->dev_read)
  8033ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8033f6:	48 85 c0             	test   %rax,%rax
  8033f9:	75 07                	jne    803402 <read+0xba>
		return -E_NOT_SUPP;
  8033fb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803400:	eb 19                	jmp    80341b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803406:	48 8b 40 10          	mov    0x10(%rax),%rax
  80340a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80340e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803412:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803416:	48 89 cf             	mov    %rcx,%rdi
  803419:	ff d0                	callq  *%rax
}
  80341b:	c9                   	leaveq 
  80341c:	c3                   	retq   

000000000080341d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80341d:	55                   	push   %rbp
  80341e:	48 89 e5             	mov    %rsp,%rbp
  803421:	48 83 ec 30          	sub    $0x30,%rsp
  803425:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803428:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80342c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803430:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803437:	eb 49                	jmp    803482 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803439:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80343c:	48 98                	cltq   
  80343e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803442:	48 29 c2             	sub    %rax,%rdx
  803445:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803448:	48 63 c8             	movslq %eax,%rcx
  80344b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80344f:	48 01 c1             	add    %rax,%rcx
  803452:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803455:	48 89 ce             	mov    %rcx,%rsi
  803458:	89 c7                	mov    %eax,%edi
  80345a:	48 b8 48 33 80 00 00 	movabs $0x803348,%rax
  803461:	00 00 00 
  803464:	ff d0                	callq  *%rax
  803466:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803469:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80346d:	79 05                	jns    803474 <readn+0x57>
			return m;
  80346f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803472:	eb 1c                	jmp    803490 <readn+0x73>
		if (m == 0)
  803474:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803478:	75 02                	jne    80347c <readn+0x5f>
			break;
  80347a:	eb 11                	jmp    80348d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80347c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80347f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803485:	48 98                	cltq   
  803487:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80348b:	72 ac                	jb     803439 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80348d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803490:	c9                   	leaveq 
  803491:	c3                   	retq   

0000000000803492 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803492:	55                   	push   %rbp
  803493:	48 89 e5             	mov    %rsp,%rbp
  803496:	48 83 ec 40          	sub    $0x40,%rsp
  80349a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80349d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034a1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8034a5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034a9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034ac:	48 89 d6             	mov    %rdx,%rsi
  8034af:	89 c7                	mov    %eax,%edi
  8034b1:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  8034b8:	00 00 00 
  8034bb:	ff d0                	callq  *%rax
  8034bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c4:	78 24                	js     8034ea <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8034c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ca:	8b 00                	mov    (%rax),%eax
  8034cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034d0:	48 89 d6             	mov    %rdx,%rsi
  8034d3:	89 c7                	mov    %eax,%edi
  8034d5:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  8034dc:	00 00 00 
  8034df:	ff d0                	callq  *%rax
  8034e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e8:	79 05                	jns    8034ef <write+0x5d>
		return r;
  8034ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ed:	eb 75                	jmp    803564 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8034ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f3:	8b 40 08             	mov    0x8(%rax),%eax
  8034f6:	83 e0 03             	and    $0x3,%eax
  8034f9:	85 c0                	test   %eax,%eax
  8034fb:	75 3a                	jne    803537 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8034fd:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803504:	00 00 00 
  803507:	48 8b 00             	mov    (%rax),%rax
  80350a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803510:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803513:	89 c6                	mov    %eax,%esi
  803515:	48 bf 9b 5d 80 00 00 	movabs $0x805d9b,%rdi
  80351c:	00 00 00 
  80351f:	b8 00 00 00 00       	mov    $0x0,%eax
  803524:	48 b9 8f 0d 80 00 00 	movabs $0x800d8f,%rcx
  80352b:	00 00 00 
  80352e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803530:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803535:	eb 2d                	jmp    803564 <write+0xd2>
	{
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
		sys_cputs(buf, n);
	}
	if (!dev->dev_write)
  803537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80353f:	48 85 c0             	test   %rax,%rax
  803542:	75 07                	jne    80354b <write+0xb9>
		return -E_NOT_SUPP;
  803544:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803549:	eb 19                	jmp    803564 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80354b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354f:	48 8b 40 18          	mov    0x18(%rax),%rax
  803553:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803557:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80355b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80355f:	48 89 cf             	mov    %rcx,%rdi
  803562:	ff d0                	callq  *%rax
}
  803564:	c9                   	leaveq 
  803565:	c3                   	retq   

0000000000803566 <seek>:

int
seek(int fdnum, off_t offset)
{
  803566:	55                   	push   %rbp
  803567:	48 89 e5             	mov    %rsp,%rbp
  80356a:	48 83 ec 18          	sub    $0x18,%rsp
  80356e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803571:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803574:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803578:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80357b:	48 89 d6             	mov    %rdx,%rsi
  80357e:	89 c7                	mov    %eax,%edi
  803580:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803587:	00 00 00 
  80358a:	ff d0                	callq  *%rax
  80358c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803593:	79 05                	jns    80359a <seek+0x34>
		return r;
  803595:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803598:	eb 0f                	jmp    8035a9 <seek+0x43>
	fd->fd_offset = offset;
  80359a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035a1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8035a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035a9:	c9                   	leaveq 
  8035aa:	c3                   	retq   

00000000008035ab <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8035ab:	55                   	push   %rbp
  8035ac:	48 89 e5             	mov    %rsp,%rbp
  8035af:	48 83 ec 30          	sub    $0x30,%rsp
  8035b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8035b6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8035b9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8035bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035c0:	48 89 d6             	mov    %rdx,%rsi
  8035c3:	89 c7                	mov    %eax,%edi
  8035c5:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  8035cc:	00 00 00 
  8035cf:	ff d0                	callq  *%rax
  8035d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d8:	78 24                	js     8035fe <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8035da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035de:	8b 00                	mov    (%rax),%eax
  8035e0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035e4:	48 89 d6             	mov    %rdx,%rsi
  8035e7:	89 c7                	mov    %eax,%edi
  8035e9:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  8035f0:	00 00 00 
  8035f3:	ff d0                	callq  *%rax
  8035f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035fc:	79 05                	jns    803603 <ftruncate+0x58>
		return r;
  8035fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803601:	eb 72                	jmp    803675 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803607:	8b 40 08             	mov    0x8(%rax),%eax
  80360a:	83 e0 03             	and    $0x3,%eax
  80360d:	85 c0                	test   %eax,%eax
  80360f:	75 3a                	jne    80364b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803611:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803618:	00 00 00 
  80361b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80361e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803624:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803627:	89 c6                	mov    %eax,%esi
  803629:	48 bf b8 5d 80 00 00 	movabs $0x805db8,%rdi
  803630:	00 00 00 
  803633:	b8 00 00 00 00       	mov    $0x0,%eax
  803638:	48 b9 8f 0d 80 00 00 	movabs $0x800d8f,%rcx
  80363f:	00 00 00 
  803642:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803644:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803649:	eb 2a                	jmp    803675 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80364b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364f:	48 8b 40 30          	mov    0x30(%rax),%rax
  803653:	48 85 c0             	test   %rax,%rax
  803656:	75 07                	jne    80365f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803658:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80365d:	eb 16                	jmp    803675 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80365f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803663:	48 8b 40 30          	mov    0x30(%rax),%rax
  803667:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80366b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80366e:	89 ce                	mov    %ecx,%esi
  803670:	48 89 d7             	mov    %rdx,%rdi
  803673:	ff d0                	callq  *%rax
}
  803675:	c9                   	leaveq 
  803676:	c3                   	retq   

0000000000803677 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803677:	55                   	push   %rbp
  803678:	48 89 e5             	mov    %rsp,%rbp
  80367b:	48 83 ec 30          	sub    $0x30,%rsp
  80367f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803682:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803686:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80368a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80368d:	48 89 d6             	mov    %rdx,%rsi
  803690:	89 c7                	mov    %eax,%edi
  803692:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803699:	00 00 00 
  80369c:	ff d0                	callq  *%rax
  80369e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a5:	78 24                	js     8036cb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8036a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ab:	8b 00                	mov    (%rax),%eax
  8036ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036b1:	48 89 d6             	mov    %rdx,%rsi
  8036b4:	89 c7                	mov    %eax,%edi
  8036b6:	48 b8 6f 30 80 00 00 	movabs $0x80306f,%rax
  8036bd:	00 00 00 
  8036c0:	ff d0                	callq  *%rax
  8036c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c9:	79 05                	jns    8036d0 <fstat+0x59>
		return r;
  8036cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ce:	eb 5e                	jmp    80372e <fstat+0xb7>
	if (!dev->dev_stat)
  8036d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8036d8:	48 85 c0             	test   %rax,%rax
  8036db:	75 07                	jne    8036e4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8036dd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8036e2:	eb 4a                	jmp    80372e <fstat+0xb7>
	stat->st_name[0] = 0;
  8036e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036e8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8036eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036ef:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8036f6:	00 00 00 
	stat->st_isdir = 0;
  8036f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036fd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803704:	00 00 00 
	stat->st_dev = dev;
  803707:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80370b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80370f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803716:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80371e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803722:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803726:	48 89 ce             	mov    %rcx,%rsi
  803729:	48 89 d7             	mov    %rdx,%rdi
  80372c:	ff d0                	callq  *%rax
}
  80372e:	c9                   	leaveq 
  80372f:	c3                   	retq   

0000000000803730 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803730:	55                   	push   %rbp
  803731:	48 89 e5             	mov    %rsp,%rbp
  803734:	48 83 ec 20          	sub    $0x20,%rsp
  803738:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80373c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803744:	be 00 00 00 00       	mov    $0x0,%esi
  803749:	48 89 c7             	mov    %rax,%rdi
  80374c:	48 b8 1e 38 80 00 00 	movabs $0x80381e,%rax
  803753:	00 00 00 
  803756:	ff d0                	callq  *%rax
  803758:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80375b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80375f:	79 05                	jns    803766 <stat+0x36>
		return fd;
  803761:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803764:	eb 2f                	jmp    803795 <stat+0x65>
	r = fstat(fd, stat);
  803766:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80376a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80376d:	48 89 d6             	mov    %rdx,%rsi
  803770:	89 c7                	mov    %eax,%edi
  803772:	48 b8 77 36 80 00 00 	movabs $0x803677,%rax
  803779:	00 00 00 
  80377c:	ff d0                	callq  *%rax
  80377e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803781:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803784:	89 c7                	mov    %eax,%edi
  803786:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  80378d:	00 00 00 
  803790:	ff d0                	callq  *%rax
	return r;
  803792:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803795:	c9                   	leaveq 
  803796:	c3                   	retq   

0000000000803797 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803797:	55                   	push   %rbp
  803798:	48 89 e5             	mov    %rsp,%rbp
  80379b:	48 83 ec 10          	sub    $0x10,%rsp
  80379f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8037a6:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8037ad:	00 00 00 
  8037b0:	8b 00                	mov    (%rax),%eax
  8037b2:	85 c0                	test   %eax,%eax
  8037b4:	75 1d                	jne    8037d3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8037b6:	bf 01 00 00 00       	mov    $0x1,%edi
  8037bb:	48 b8 ae 2d 80 00 00 	movabs $0x802dae,%rax
  8037c2:	00 00 00 
  8037c5:	ff d0                	callq  *%rax
  8037c7:	48 ba 08 90 80 00 00 	movabs $0x809008,%rdx
  8037ce:	00 00 00 
  8037d1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8037d3:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8037da:	00 00 00 
  8037dd:	8b 00                	mov    (%rax),%eax
  8037df:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8037e2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8037e7:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8037ee:	00 00 00 
  8037f1:	89 c7                	mov    %eax,%edi
  8037f3:	48 b8 4c 2d 80 00 00 	movabs $0x802d4c,%rax
  8037fa:	00 00 00 
  8037fd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8037ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803803:	ba 00 00 00 00       	mov    $0x0,%edx
  803808:	48 89 c6             	mov    %rax,%rsi
  80380b:	bf 00 00 00 00       	mov    $0x0,%edi
  803810:	48 b8 46 2c 80 00 00 	movabs $0x802c46,%rax
  803817:	00 00 00 
  80381a:	ff d0                	callq  *%rax
}
  80381c:	c9                   	leaveq 
  80381d:	c3                   	retq   

000000000080381e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80381e:	55                   	push   %rbp
  80381f:	48 89 e5             	mov    %rsp,%rbp
  803822:	48 83 ec 30          	sub    $0x30,%rsp
  803826:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80382a:	89 75 d4             	mov    %esi,-0x2c(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	int r = -1;
  80382d:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	int d = -1;
  803834:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	int len = 0;
  80383b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	void *va;
	if(!path)
  803842:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803847:	75 08                	jne    803851 <open+0x33>
	{
		return r;
  803849:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384c:	e9 f2 00 00 00       	jmpq   803943 <open+0x125>
	}	
	else if((len = strlen(path)) >= MAXPATHLEN) 
  803851:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803855:	48 89 c7             	mov    %rax,%rdi
  803858:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  80385f:	00 00 00 
  803862:	ff d0                	callq  *%rax
  803864:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803867:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%rbp)
  80386e:	7e 0a                	jle    80387a <open+0x5c>
	{
		return -E_BAD_PATH;
  803870:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803875:	e9 c9 00 00 00       	jmpq   803943 <open+0x125>
	}
	else
	{
		struct Fd *fd_store = NULL;
  80387a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803881:	00 
		if((r = fd_alloc(&fd_store)) < 0 || fd_store == NULL)
  803882:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803886:	48 89 c7             	mov    %rax,%rdi
  803889:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  803890:	00 00 00 
  803893:	ff d0                	callq  *%rax
  803895:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803898:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80389c:	78 09                	js     8038a7 <open+0x89>
  80389e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038a2:	48 85 c0             	test   %rax,%rax
  8038a5:	75 08                	jne    8038af <open+0x91>
		{
			return r;
  8038a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038aa:	e9 94 00 00 00       	jmpq   803943 <open+0x125>
		}	
		strncpy(fsipcbuf.open.req_path,  path, MAXPATHLEN);
  8038af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b3:	ba 00 04 00 00       	mov    $0x400,%edx
  8038b8:	48 89 c6             	mov    %rax,%rsi
  8038bb:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8038c2:	00 00 00 
  8038c5:	48 b8 d6 19 80 00 00 	movabs $0x8019d6,%rax
  8038cc:	00 00 00 
  8038cf:	ff d0                	callq  *%rax
		fsipcbuf.open.req_omode = mode;
  8038d1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038d8:	00 00 00 
  8038db:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8038de:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
		if ((r = fsipc(FSREQ_OPEN, fd_store)) < 0)
  8038e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e8:	48 89 c6             	mov    %rax,%rsi
  8038eb:	bf 01 00 00 00       	mov    $0x1,%edi
  8038f0:	48 b8 97 37 80 00 00 	movabs $0x803797,%rax
  8038f7:	00 00 00 
  8038fa:	ff d0                	callq  *%rax
  8038fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803903:	79 2b                	jns    803930 <open+0x112>
		{
			if((d = fd_close(fd_store, 0)) < 0)
  803905:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803909:	be 00 00 00 00       	mov    $0x0,%esi
  80390e:	48 89 c7             	mov    %rax,%rdi
  803911:	48 b8 a6 2f 80 00 00 	movabs $0x802fa6,%rax
  803918:	00 00 00 
  80391b:	ff d0                	callq  *%rax
  80391d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803920:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803924:	79 05                	jns    80392b <open+0x10d>
			{
				return d;
  803926:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803929:	eb 18                	jmp    803943 <open+0x125>
			}
			return r;
  80392b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80392e:	eb 13                	jmp    803943 <open+0x125>
		}	
		return fd2num(fd_store);
  803930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803934:	48 89 c7             	mov    %rax,%rdi
  803937:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  80393e:	00 00 00 
  803941:	ff d0                	callq  *%rax
	}
	//panic ("open not implemented");
}
  803943:	c9                   	leaveq 
  803944:	c3                   	retq   

0000000000803945 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803945:	55                   	push   %rbp
  803946:	48 89 e5             	mov    %rsp,%rbp
  803949:	48 83 ec 10          	sub    $0x10,%rsp
  80394d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803951:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803955:	8b 50 0c             	mov    0xc(%rax),%edx
  803958:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80395f:	00 00 00 
  803962:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803964:	be 00 00 00 00       	mov    $0x0,%esi
  803969:	bf 06 00 00 00       	mov    $0x6,%edi
  80396e:	48 b8 97 37 80 00 00 	movabs $0x803797,%rax
  803975:	00 00 00 
  803978:	ff d0                	callq  *%rax
}
  80397a:	c9                   	leaveq 
  80397b:	c3                   	retq   

000000000080397c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80397c:	55                   	push   %rbp
  80397d:	48 89 e5             	mov    %rsp,%rbp
  803980:	48 83 ec 30          	sub    $0x30,%rsp
  803984:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803988:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80398c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r = 0;
  803990:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	if(!fd || !buf)
  803997:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80399c:	74 07                	je     8039a5 <devfile_read+0x29>
  80399e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8039a3:	75 07                	jne    8039ac <devfile_read+0x30>
		return -E_INVAL;
  8039a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8039aa:	eb 77                	jmp    803a23 <devfile_read+0xa7>
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8039ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b0:	8b 50 0c             	mov    0xc(%rax),%edx
  8039b3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039ba:	00 00 00 
  8039bd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8039bf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c6:	00 00 00 
  8039c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8039cd:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) <= 0){
  8039d1:	be 00 00 00 00       	mov    $0x0,%esi
  8039d6:	bf 03 00 00 00       	mov    $0x3,%edi
  8039db:	48 b8 97 37 80 00 00 	movabs $0x803797,%rax
  8039e2:	00 00 00 
  8039e5:	ff d0                	callq  *%rax
  8039e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ee:	7f 05                	jg     8039f5 <devfile_read+0x79>
		//cprintf("devfile_read r is [%d]\n",r);
		return r;
  8039f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f3:	eb 2e                	jmp    803a23 <devfile_read+0xa7>
	}
	//cprintf("devfile_read %x %x %x %x\n",fsipcbuf.readRet.ret_buf[0], fsipcbuf.readRet.ret_buf[1], fsipcbuf.readRet.ret_buf[2], fsipcbuf.readRet.ret_buf[3]);
	memmove(buf, (char*)fsipcbuf.readRet.ret_buf, r);
  8039f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039f8:	48 63 d0             	movslq %eax,%rdx
  8039fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ff:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803a06:	00 00 00 
  803a09:	48 89 c7             	mov    %rax,%rdi
  803a0c:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  803a13:	00 00 00 
  803a16:	ff d0                	callq  *%rax
	char* buf1 = (char*)buf;
  803a18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//cprintf("devfile_read ri is [%d] %x %x %x %x\n",r,buf1[0],buf1[1],buf1[2],buf1[3]);
	return r;
  803a20:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  803a23:	c9                   	leaveq 
  803a24:	c3                   	retq   

0000000000803a25 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803a25:	55                   	push   %rbp
  803a26:	48 89 e5             	mov    %rsp,%rbp
  803a29:	48 83 ec 30          	sub    $0x30,%rsp
  803a2d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a35:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	int r = -1;
  803a39:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	if(!fd || !buf)
  803a40:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a45:	74 07                	je     803a4e <devfile_write+0x29>
  803a47:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a4c:	75 08                	jne    803a56 <devfile_write+0x31>
		return r;
  803a4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a51:	e9 9a 00 00 00       	jmpq   803af0 <devfile_write+0xcb>
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803a56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a5a:	8b 50 0c             	mov    0xc(%rax),%edx
  803a5d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a64:	00 00 00 
  803a67:	89 10                	mov    %edx,(%rax)
	if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
  803a69:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803a70:	00 
  803a71:	76 08                	jbe    803a7b <devfile_write+0x56>
	{
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
  803a73:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803a7a:	00 
	}
	fsipcbuf.write.req_n = n;
  803a7b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a82:	00 00 00 
  803a85:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a89:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	memmove((void*)fsipcbuf.write.req_buf, (void*)buf, n);
  803a8d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a95:	48 89 c6             	mov    %rax,%rsi
  803a98:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  803a9f:	00 00 00 
  803aa2:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  803aa9:	00 00 00 
  803aac:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) <= 0){
  803aae:	be 00 00 00 00       	mov    $0x0,%esi
  803ab3:	bf 04 00 00 00       	mov    $0x4,%edi
  803ab8:	48 b8 97 37 80 00 00 	movabs $0x803797,%rax
  803abf:	00 00 00 
  803ac2:	ff d0                	callq  *%rax
  803ac4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ac7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803acb:	7f 20                	jg     803aed <devfile_write+0xc8>
		cprintf("fsipc-FSREQ_WRITE returns 0");
  803acd:	48 bf de 5d 80 00 00 	movabs $0x805dde,%rdi
  803ad4:	00 00 00 
  803ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  803adc:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  803ae3:	00 00 00 
  803ae6:	ff d2                	callq  *%rdx
		return r;
  803ae8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aeb:	eb 03                	jmp    803af0 <devfile_write+0xcb>
	}
	return r;
  803aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_write not implemented");
}
  803af0:	c9                   	leaveq 
  803af1:	c3                   	retq   

0000000000803af2 <devfile_stat>:


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803af2:	55                   	push   %rbp
  803af3:	48 89 e5             	mov    %rsp,%rbp
  803af6:	48 83 ec 20          	sub    $0x20,%rsp
  803afa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803afe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803b02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b06:	8b 50 0c             	mov    0xc(%rax),%edx
  803b09:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b10:	00 00 00 
  803b13:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803b15:	be 00 00 00 00       	mov    $0x0,%esi
  803b1a:	bf 05 00 00 00       	mov    $0x5,%edi
  803b1f:	48 b8 97 37 80 00 00 	movabs $0x803797,%rax
  803b26:	00 00 00 
  803b29:	ff d0                	callq  *%rax
  803b2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b32:	79 05                	jns    803b39 <devfile_stat+0x47>
		return r;
  803b34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b37:	eb 56                	jmp    803b8f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803b39:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b3d:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803b44:	00 00 00 
  803b47:	48 89 c7             	mov    %rax,%rdi
  803b4a:	48 b8 44 19 80 00 00 	movabs $0x801944,%rax
  803b51:	00 00 00 
  803b54:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803b56:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b5d:	00 00 00 
  803b60:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803b66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b6a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803b70:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b77:	00 00 00 
  803b7a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803b80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b84:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803b8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b8f:	c9                   	leaveq 
  803b90:	c3                   	retq   

0000000000803b91 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803b91:	55                   	push   %rbp
  803b92:	48 89 e5             	mov    %rsp,%rbp
  803b95:	48 83 ec 10          	sub    $0x10,%rsp
  803b99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b9d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803ba0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba4:	8b 50 0c             	mov    0xc(%rax),%edx
  803ba7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bae:	00 00 00 
  803bb1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803bb3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bba:	00 00 00 
  803bbd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803bc0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803bc3:	be 00 00 00 00       	mov    $0x0,%esi
  803bc8:	bf 02 00 00 00       	mov    $0x2,%edi
  803bcd:	48 b8 97 37 80 00 00 	movabs $0x803797,%rax
  803bd4:	00 00 00 
  803bd7:	ff d0                	callq  *%rax
}
  803bd9:	c9                   	leaveq 
  803bda:	c3                   	retq   

0000000000803bdb <remove>:

// Delete a file
int
remove(const char *path)
{
  803bdb:	55                   	push   %rbp
  803bdc:	48 89 e5             	mov    %rsp,%rbp
  803bdf:	48 83 ec 10          	sub    $0x10,%rsp
  803be3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803be7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803beb:	48 89 c7             	mov    %rax,%rdi
  803bee:	48 b8 d8 18 80 00 00 	movabs $0x8018d8,%rax
  803bf5:	00 00 00 
  803bf8:	ff d0                	callq  *%rax
  803bfa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803bff:	7e 07                	jle    803c08 <remove+0x2d>
		return -E_BAD_PATH;
  803c01:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803c06:	eb 33                	jmp    803c3b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803c08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c0c:	48 89 c6             	mov    %rax,%rsi
  803c0f:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803c16:	00 00 00 
  803c19:	48 b8 44 19 80 00 00 	movabs $0x801944,%rax
  803c20:	00 00 00 
  803c23:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803c25:	be 00 00 00 00       	mov    $0x0,%esi
  803c2a:	bf 07 00 00 00       	mov    $0x7,%edi
  803c2f:	48 b8 97 37 80 00 00 	movabs $0x803797,%rax
  803c36:	00 00 00 
  803c39:	ff d0                	callq  *%rax
}
  803c3b:	c9                   	leaveq 
  803c3c:	c3                   	retq   

0000000000803c3d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803c3d:	55                   	push   %rbp
  803c3e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803c41:	be 00 00 00 00       	mov    $0x0,%esi
  803c46:	bf 08 00 00 00       	mov    $0x8,%edi
  803c4b:	48 b8 97 37 80 00 00 	movabs $0x803797,%rax
  803c52:	00 00 00 
  803c55:	ff d0                	callq  *%rax
}
  803c57:	5d                   	pop    %rbp
  803c58:	c3                   	retq   

0000000000803c59 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803c59:	55                   	push   %rbp
  803c5a:	48 89 e5             	mov    %rsp,%rbp
  803c5d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803c64:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803c6b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803c72:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803c79:	be 00 00 00 00       	mov    $0x0,%esi
  803c7e:	48 89 c7             	mov    %rax,%rdi
  803c81:	48 b8 1e 38 80 00 00 	movabs $0x80381e,%rax
  803c88:	00 00 00 
  803c8b:	ff d0                	callq  *%rax
  803c8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803c90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c94:	79 28                	jns    803cbe <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803c96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c99:	89 c6                	mov    %eax,%esi
  803c9b:	48 bf fa 5d 80 00 00 	movabs $0x805dfa,%rdi
  803ca2:	00 00 00 
  803ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  803caa:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  803cb1:	00 00 00 
  803cb4:	ff d2                	callq  *%rdx
		return fd_src;
  803cb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb9:	e9 74 01 00 00       	jmpq   803e32 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803cbe:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803cc5:	be 01 01 00 00       	mov    $0x101,%esi
  803cca:	48 89 c7             	mov    %rax,%rdi
  803ccd:	48 b8 1e 38 80 00 00 	movabs $0x80381e,%rax
  803cd4:	00 00 00 
  803cd7:	ff d0                	callq  *%rax
  803cd9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803cdc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ce0:	79 39                	jns    803d1b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803ce2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ce5:	89 c6                	mov    %eax,%esi
  803ce7:	48 bf 10 5e 80 00 00 	movabs $0x805e10,%rdi
  803cee:	00 00 00 
  803cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf6:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  803cfd:	00 00 00 
  803d00:	ff d2                	callq  *%rdx
		close(fd_src);
  803d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d05:	89 c7                	mov    %eax,%edi
  803d07:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  803d0e:	00 00 00 
  803d11:	ff d0                	callq  *%rax
		return fd_dest;
  803d13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d16:	e9 17 01 00 00       	jmpq   803e32 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803d1b:	eb 74                	jmp    803d91 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803d1d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803d20:	48 63 d0             	movslq %eax,%rdx
  803d23:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803d2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d2d:	48 89 ce             	mov    %rcx,%rsi
  803d30:	89 c7                	mov    %eax,%edi
  803d32:	48 b8 92 34 80 00 00 	movabs $0x803492,%rax
  803d39:	00 00 00 
  803d3c:	ff d0                	callq  *%rax
  803d3e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803d41:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803d45:	79 4a                	jns    803d91 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803d47:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803d4a:	89 c6                	mov    %eax,%esi
  803d4c:	48 bf 2a 5e 80 00 00 	movabs $0x805e2a,%rdi
  803d53:	00 00 00 
  803d56:	b8 00 00 00 00       	mov    $0x0,%eax
  803d5b:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  803d62:	00 00 00 
  803d65:	ff d2                	callq  *%rdx
			close(fd_src);
  803d67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6a:	89 c7                	mov    %eax,%edi
  803d6c:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  803d73:	00 00 00 
  803d76:	ff d0                	callq  *%rax
			close(fd_dest);
  803d78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d7b:	89 c7                	mov    %eax,%edi
  803d7d:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  803d84:	00 00 00 
  803d87:	ff d0                	callq  *%rax
			return write_size;
  803d89:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803d8c:	e9 a1 00 00 00       	jmpq   803e32 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803d91:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803d98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d9b:	ba 00 02 00 00       	mov    $0x200,%edx
  803da0:	48 89 ce             	mov    %rcx,%rsi
  803da3:	89 c7                	mov    %eax,%edi
  803da5:	48 b8 48 33 80 00 00 	movabs $0x803348,%rax
  803dac:	00 00 00 
  803daf:	ff d0                	callq  *%rax
  803db1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803db4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803db8:	0f 8f 5f ff ff ff    	jg     803d1d <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803dbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803dc2:	79 47                	jns    803e0b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803dc4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803dc7:	89 c6                	mov    %eax,%esi
  803dc9:	48 bf 3d 5e 80 00 00 	movabs $0x805e3d,%rdi
  803dd0:	00 00 00 
  803dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd8:	48 ba 8f 0d 80 00 00 	movabs $0x800d8f,%rdx
  803ddf:	00 00 00 
  803de2:	ff d2                	callq  *%rdx
		close(fd_src);
  803de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de7:	89 c7                	mov    %eax,%edi
  803de9:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  803df0:	00 00 00 
  803df3:	ff d0                	callq  *%rax
		close(fd_dest);
  803df5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803df8:	89 c7                	mov    %eax,%edi
  803dfa:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  803e01:	00 00 00 
  803e04:	ff d0                	callq  *%rax
		return read_size;
  803e06:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e09:	eb 27                	jmp    803e32 <copy+0x1d9>
	}
	close(fd_src);
  803e0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e0e:	89 c7                	mov    %eax,%edi
  803e10:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  803e17:	00 00 00 
  803e1a:	ff d0                	callq  *%rax
	close(fd_dest);
  803e1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e1f:	89 c7                	mov    %eax,%edi
  803e21:	48 b8 26 31 80 00 00 	movabs $0x803126,%rax
  803e28:	00 00 00 
  803e2b:	ff d0                	callq  *%rax
	return 0;
  803e2d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803e32:	c9                   	leaveq 
  803e33:	c3                   	retq   

0000000000803e34 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803e34:	55                   	push   %rbp
  803e35:	48 89 e5             	mov    %rsp,%rbp
  803e38:	48 83 ec 20          	sub    $0x20,%rsp
  803e3c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803e3f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e43:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e46:	48 89 d6             	mov    %rdx,%rsi
  803e49:	89 c7                	mov    %eax,%edi
  803e4b:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  803e52:	00 00 00 
  803e55:	ff d0                	callq  *%rax
  803e57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e5e:	79 05                	jns    803e65 <fd2sockid+0x31>
		return r;
  803e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e63:	eb 24                	jmp    803e89 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e69:	8b 10                	mov    (%rax),%edx
  803e6b:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  803e72:	00 00 00 
  803e75:	8b 00                	mov    (%rax),%eax
  803e77:	39 c2                	cmp    %eax,%edx
  803e79:	74 07                	je     803e82 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803e7b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803e80:	eb 07                	jmp    803e89 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e86:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803e89:	c9                   	leaveq 
  803e8a:	c3                   	retq   

0000000000803e8b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803e8b:	55                   	push   %rbp
  803e8c:	48 89 e5             	mov    %rsp,%rbp
  803e8f:	48 83 ec 20          	sub    $0x20,%rsp
  803e93:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803e96:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e9a:	48 89 c7             	mov    %rax,%rdi
  803e9d:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  803ea4:	00 00 00 
  803ea7:	ff d0                	callq  *%rax
  803ea9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb0:	78 26                	js     803ed8 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803eb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eb6:	ba 07 04 00 00       	mov    $0x407,%edx
  803ebb:	48 89 c6             	mov    %rax,%rsi
  803ebe:	bf 00 00 00 00       	mov    $0x0,%edi
  803ec3:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  803eca:	00 00 00 
  803ecd:	ff d0                	callq  *%rax
  803ecf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ed2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ed6:	79 16                	jns    803eee <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803ed8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803edb:	89 c7                	mov    %eax,%edi
  803edd:	48 b8 98 43 80 00 00 	movabs $0x804398,%rax
  803ee4:	00 00 00 
  803ee7:	ff d0                	callq  *%rax
		return r;
  803ee9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eec:	eb 3a                	jmp    803f28 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803eee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ef2:	48 ba a0 80 80 00 00 	movabs $0x8080a0,%rdx
  803ef9:	00 00 00 
  803efc:	8b 12                	mov    (%rdx),%edx
  803efe:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f04:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803f0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f0f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f12:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803f15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f19:	48 89 c7             	mov    %rax,%rdi
  803f1c:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  803f23:	00 00 00 
  803f26:	ff d0                	callq  *%rax
}
  803f28:	c9                   	leaveq 
  803f29:	c3                   	retq   

0000000000803f2a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803f2a:	55                   	push   %rbp
  803f2b:	48 89 e5             	mov    %rsp,%rbp
  803f2e:	48 83 ec 30          	sub    $0x30,%rsp
  803f32:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f35:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f39:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803f3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f40:	89 c7                	mov    %eax,%edi
  803f42:	48 b8 34 3e 80 00 00 	movabs $0x803e34,%rax
  803f49:	00 00 00 
  803f4c:	ff d0                	callq  *%rax
  803f4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f55:	79 05                	jns    803f5c <accept+0x32>
		return r;
  803f57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5a:	eb 3b                	jmp    803f97 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803f5c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803f60:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803f64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f67:	48 89 ce             	mov    %rcx,%rsi
  803f6a:	89 c7                	mov    %eax,%edi
  803f6c:	48 b8 75 42 80 00 00 	movabs $0x804275,%rax
  803f73:	00 00 00 
  803f76:	ff d0                	callq  *%rax
  803f78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f7f:	79 05                	jns    803f86 <accept+0x5c>
		return r;
  803f81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f84:	eb 11                	jmp    803f97 <accept+0x6d>
	return alloc_sockfd(r);
  803f86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f89:	89 c7                	mov    %eax,%edi
  803f8b:	48 b8 8b 3e 80 00 00 	movabs $0x803e8b,%rax
  803f92:	00 00 00 
  803f95:	ff d0                	callq  *%rax
}
  803f97:	c9                   	leaveq 
  803f98:	c3                   	retq   

0000000000803f99 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803f99:	55                   	push   %rbp
  803f9a:	48 89 e5             	mov    %rsp,%rbp
  803f9d:	48 83 ec 20          	sub    $0x20,%rsp
  803fa1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fa4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fa8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803fab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fae:	89 c7                	mov    %eax,%edi
  803fb0:	48 b8 34 3e 80 00 00 	movabs $0x803e34,%rax
  803fb7:	00 00 00 
  803fba:	ff d0                	callq  *%rax
  803fbc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fbf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc3:	79 05                	jns    803fca <bind+0x31>
		return r;
  803fc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc8:	eb 1b                	jmp    803fe5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803fca:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803fcd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd4:	48 89 ce             	mov    %rcx,%rsi
  803fd7:	89 c7                	mov    %eax,%edi
  803fd9:	48 b8 f4 42 80 00 00 	movabs $0x8042f4,%rax
  803fe0:	00 00 00 
  803fe3:	ff d0                	callq  *%rax
}
  803fe5:	c9                   	leaveq 
  803fe6:	c3                   	retq   

0000000000803fe7 <shutdown>:

int
shutdown(int s, int how)
{
  803fe7:	55                   	push   %rbp
  803fe8:	48 89 e5             	mov    %rsp,%rbp
  803feb:	48 83 ec 20          	sub    $0x20,%rsp
  803fef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ff2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ff5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ff8:	89 c7                	mov    %eax,%edi
  803ffa:	48 b8 34 3e 80 00 00 	movabs $0x803e34,%rax
  804001:	00 00 00 
  804004:	ff d0                	callq  *%rax
  804006:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804009:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80400d:	79 05                	jns    804014 <shutdown+0x2d>
		return r;
  80400f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804012:	eb 16                	jmp    80402a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  804014:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804017:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80401a:	89 d6                	mov    %edx,%esi
  80401c:	89 c7                	mov    %eax,%edi
  80401e:	48 b8 58 43 80 00 00 	movabs $0x804358,%rax
  804025:	00 00 00 
  804028:	ff d0                	callq  *%rax
}
  80402a:	c9                   	leaveq 
  80402b:	c3                   	retq   

000000000080402c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80402c:	55                   	push   %rbp
  80402d:	48 89 e5             	mov    %rsp,%rbp
  804030:	48 83 ec 10          	sub    $0x10,%rsp
  804034:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  804038:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80403c:	48 89 c7             	mov    %rax,%rdi
  80403f:	48 b8 fc 4f 80 00 00 	movabs $0x804ffc,%rax
  804046:	00 00 00 
  804049:	ff d0                	callq  *%rax
  80404b:	83 f8 01             	cmp    $0x1,%eax
  80404e:	75 17                	jne    804067 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  804050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804054:	8b 40 0c             	mov    0xc(%rax),%eax
  804057:	89 c7                	mov    %eax,%edi
  804059:	48 b8 98 43 80 00 00 	movabs $0x804398,%rax
  804060:	00 00 00 
  804063:	ff d0                	callq  *%rax
  804065:	eb 05                	jmp    80406c <devsock_close+0x40>
	else
		return 0;
  804067:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80406c:	c9                   	leaveq 
  80406d:	c3                   	retq   

000000000080406e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80406e:	55                   	push   %rbp
  80406f:	48 89 e5             	mov    %rsp,%rbp
  804072:	48 83 ec 20          	sub    $0x20,%rsp
  804076:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804079:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80407d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804080:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804083:	89 c7                	mov    %eax,%edi
  804085:	48 b8 34 3e 80 00 00 	movabs $0x803e34,%rax
  80408c:	00 00 00 
  80408f:	ff d0                	callq  *%rax
  804091:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804094:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804098:	79 05                	jns    80409f <connect+0x31>
		return r;
  80409a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80409d:	eb 1b                	jmp    8040ba <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80409f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8040a2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8040a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040a9:	48 89 ce             	mov    %rcx,%rsi
  8040ac:	89 c7                	mov    %eax,%edi
  8040ae:	48 b8 c5 43 80 00 00 	movabs $0x8043c5,%rax
  8040b5:	00 00 00 
  8040b8:	ff d0                	callq  *%rax
}
  8040ba:	c9                   	leaveq 
  8040bb:	c3                   	retq   

00000000008040bc <listen>:

int
listen(int s, int backlog)
{
  8040bc:	55                   	push   %rbp
  8040bd:	48 89 e5             	mov    %rsp,%rbp
  8040c0:	48 83 ec 20          	sub    $0x20,%rsp
  8040c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040c7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8040ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040cd:	89 c7                	mov    %eax,%edi
  8040cf:	48 b8 34 3e 80 00 00 	movabs $0x803e34,%rax
  8040d6:	00 00 00 
  8040d9:	ff d0                	callq  *%rax
  8040db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040e2:	79 05                	jns    8040e9 <listen+0x2d>
		return r;
  8040e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040e7:	eb 16                	jmp    8040ff <listen+0x43>
	return nsipc_listen(r, backlog);
  8040e9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8040ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ef:	89 d6                	mov    %edx,%esi
  8040f1:	89 c7                	mov    %eax,%edi
  8040f3:	48 b8 29 44 80 00 00 	movabs $0x804429,%rax
  8040fa:	00 00 00 
  8040fd:	ff d0                	callq  *%rax
}
  8040ff:	c9                   	leaveq 
  804100:	c3                   	retq   

0000000000804101 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  804101:	55                   	push   %rbp
  804102:	48 89 e5             	mov    %rsp,%rbp
  804105:	48 83 ec 20          	sub    $0x20,%rsp
  804109:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80410d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804111:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  804115:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804119:	89 c2                	mov    %eax,%edx
  80411b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80411f:	8b 40 0c             	mov    0xc(%rax),%eax
  804122:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804126:	b9 00 00 00 00       	mov    $0x0,%ecx
  80412b:	89 c7                	mov    %eax,%edi
  80412d:	48 b8 69 44 80 00 00 	movabs $0x804469,%rax
  804134:	00 00 00 
  804137:	ff d0                	callq  *%rax
}
  804139:	c9                   	leaveq 
  80413a:	c3                   	retq   

000000000080413b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80413b:	55                   	push   %rbp
  80413c:	48 89 e5             	mov    %rsp,%rbp
  80413f:	48 83 ec 20          	sub    $0x20,%rsp
  804143:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804147:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80414b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80414f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804153:	89 c2                	mov    %eax,%edx
  804155:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804159:	8b 40 0c             	mov    0xc(%rax),%eax
  80415c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804160:	b9 00 00 00 00       	mov    $0x0,%ecx
  804165:	89 c7                	mov    %eax,%edi
  804167:	48 b8 35 45 80 00 00 	movabs $0x804535,%rax
  80416e:	00 00 00 
  804171:	ff d0                	callq  *%rax
}
  804173:	c9                   	leaveq 
  804174:	c3                   	retq   

0000000000804175 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  804175:	55                   	push   %rbp
  804176:	48 89 e5             	mov    %rsp,%rbp
  804179:	48 83 ec 10          	sub    $0x10,%rsp
  80417d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804181:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  804185:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804189:	48 be 58 5e 80 00 00 	movabs $0x805e58,%rsi
  804190:	00 00 00 
  804193:	48 89 c7             	mov    %rax,%rdi
  804196:	48 b8 44 19 80 00 00 	movabs $0x801944,%rax
  80419d:	00 00 00 
  8041a0:	ff d0                	callq  *%rax
	return 0;
  8041a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041a7:	c9                   	leaveq 
  8041a8:	c3                   	retq   

00000000008041a9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8041a9:	55                   	push   %rbp
  8041aa:	48 89 e5             	mov    %rsp,%rbp
  8041ad:	48 83 ec 20          	sub    $0x20,%rsp
  8041b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041b4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8041b7:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8041ba:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8041bd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8041c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041c3:	89 ce                	mov    %ecx,%esi
  8041c5:	89 c7                	mov    %eax,%edi
  8041c7:	48 b8 ed 45 80 00 00 	movabs $0x8045ed,%rax
  8041ce:	00 00 00 
  8041d1:	ff d0                	callq  *%rax
  8041d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041da:	79 05                	jns    8041e1 <socket+0x38>
		return r;
  8041dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041df:	eb 11                	jmp    8041f2 <socket+0x49>
	return alloc_sockfd(r);
  8041e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e4:	89 c7                	mov    %eax,%edi
  8041e6:	48 b8 8b 3e 80 00 00 	movabs $0x803e8b,%rax
  8041ed:	00 00 00 
  8041f0:	ff d0                	callq  *%rax
}
  8041f2:	c9                   	leaveq 
  8041f3:	c3                   	retq   

00000000008041f4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8041f4:	55                   	push   %rbp
  8041f5:	48 89 e5             	mov    %rsp,%rbp
  8041f8:	48 83 ec 10          	sub    $0x10,%rsp
  8041fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8041ff:	48 b8 0c 90 80 00 00 	movabs $0x80900c,%rax
  804206:	00 00 00 
  804209:	8b 00                	mov    (%rax),%eax
  80420b:	85 c0                	test   %eax,%eax
  80420d:	75 1d                	jne    80422c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80420f:	bf 02 00 00 00       	mov    $0x2,%edi
  804214:	48 b8 ae 2d 80 00 00 	movabs $0x802dae,%rax
  80421b:	00 00 00 
  80421e:	ff d0                	callq  *%rax
  804220:	48 ba 0c 90 80 00 00 	movabs $0x80900c,%rdx
  804227:	00 00 00 
  80422a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80422c:	48 b8 0c 90 80 00 00 	movabs $0x80900c,%rax
  804233:	00 00 00 
  804236:	8b 00                	mov    (%rax),%eax
  804238:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80423b:	b9 07 00 00 00       	mov    $0x7,%ecx
  804240:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  804247:	00 00 00 
  80424a:	89 c7                	mov    %eax,%edi
  80424c:	48 b8 4c 2d 80 00 00 	movabs $0x802d4c,%rax
  804253:	00 00 00 
  804256:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  804258:	ba 00 00 00 00       	mov    $0x0,%edx
  80425d:	be 00 00 00 00       	mov    $0x0,%esi
  804262:	bf 00 00 00 00       	mov    $0x0,%edi
  804267:	48 b8 46 2c 80 00 00 	movabs $0x802c46,%rax
  80426e:	00 00 00 
  804271:	ff d0                	callq  *%rax
}
  804273:	c9                   	leaveq 
  804274:	c3                   	retq   

0000000000804275 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804275:	55                   	push   %rbp
  804276:	48 89 e5             	mov    %rsp,%rbp
  804279:	48 83 ec 30          	sub    $0x30,%rsp
  80427d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804280:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804284:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  804288:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80428f:	00 00 00 
  804292:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804295:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804297:	bf 01 00 00 00       	mov    $0x1,%edi
  80429c:	48 b8 f4 41 80 00 00 	movabs $0x8041f4,%rax
  8042a3:	00 00 00 
  8042a6:	ff d0                	callq  *%rax
  8042a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042af:	78 3e                	js     8042ef <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8042b1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8042b8:	00 00 00 
  8042bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8042bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042c3:	8b 40 10             	mov    0x10(%rax),%eax
  8042c6:	89 c2                	mov    %eax,%edx
  8042c8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8042cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042d0:	48 89 ce             	mov    %rcx,%rsi
  8042d3:	48 89 c7             	mov    %rax,%rdi
  8042d6:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  8042dd:	00 00 00 
  8042e0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8042e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e6:	8b 50 10             	mov    0x10(%rax),%edx
  8042e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042ed:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8042ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8042f2:	c9                   	leaveq 
  8042f3:	c3                   	retq   

00000000008042f4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8042f4:	55                   	push   %rbp
  8042f5:	48 89 e5             	mov    %rsp,%rbp
  8042f8:	48 83 ec 10          	sub    $0x10,%rsp
  8042fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8042ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804303:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  804306:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80430d:	00 00 00 
  804310:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804313:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804315:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431c:	48 89 c6             	mov    %rax,%rsi
  80431f:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  804326:	00 00 00 
  804329:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  804330:	00 00 00 
  804333:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804335:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80433c:	00 00 00 
  80433f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804342:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804345:	bf 02 00 00 00       	mov    $0x2,%edi
  80434a:	48 b8 f4 41 80 00 00 	movabs $0x8041f4,%rax
  804351:	00 00 00 
  804354:	ff d0                	callq  *%rax
}
  804356:	c9                   	leaveq 
  804357:	c3                   	retq   

0000000000804358 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804358:	55                   	push   %rbp
  804359:	48 89 e5             	mov    %rsp,%rbp
  80435c:	48 83 ec 10          	sub    $0x10,%rsp
  804360:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804363:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804366:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80436d:	00 00 00 
  804370:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804373:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804375:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80437c:	00 00 00 
  80437f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804382:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804385:	bf 03 00 00 00       	mov    $0x3,%edi
  80438a:	48 b8 f4 41 80 00 00 	movabs $0x8041f4,%rax
  804391:	00 00 00 
  804394:	ff d0                	callq  *%rax
}
  804396:	c9                   	leaveq 
  804397:	c3                   	retq   

0000000000804398 <nsipc_close>:

int
nsipc_close(int s)
{
  804398:	55                   	push   %rbp
  804399:	48 89 e5             	mov    %rsp,%rbp
  80439c:	48 83 ec 10          	sub    $0x10,%rsp
  8043a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8043a3:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8043aa:	00 00 00 
  8043ad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8043b0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8043b2:	bf 04 00 00 00       	mov    $0x4,%edi
  8043b7:	48 b8 f4 41 80 00 00 	movabs $0x8041f4,%rax
  8043be:	00 00 00 
  8043c1:	ff d0                	callq  *%rax
}
  8043c3:	c9                   	leaveq 
  8043c4:	c3                   	retq   

00000000008043c5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8043c5:	55                   	push   %rbp
  8043c6:	48 89 e5             	mov    %rsp,%rbp
  8043c9:	48 83 ec 10          	sub    $0x10,%rsp
  8043cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8043d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8043d4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8043d7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8043de:	00 00 00 
  8043e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8043e4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8043e6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8043e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ed:	48 89 c6             	mov    %rax,%rsi
  8043f0:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8043f7:	00 00 00 
  8043fa:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  804401:	00 00 00 
  804404:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804406:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80440d:	00 00 00 
  804410:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804413:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804416:	bf 05 00 00 00       	mov    $0x5,%edi
  80441b:	48 b8 f4 41 80 00 00 	movabs $0x8041f4,%rax
  804422:	00 00 00 
  804425:	ff d0                	callq  *%rax
}
  804427:	c9                   	leaveq 
  804428:	c3                   	retq   

0000000000804429 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804429:	55                   	push   %rbp
  80442a:	48 89 e5             	mov    %rsp,%rbp
  80442d:	48 83 ec 10          	sub    $0x10,%rsp
  804431:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804434:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804437:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80443e:	00 00 00 
  804441:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804444:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804446:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80444d:	00 00 00 
  804450:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804453:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804456:	bf 06 00 00 00       	mov    $0x6,%edi
  80445b:	48 b8 f4 41 80 00 00 	movabs $0x8041f4,%rax
  804462:	00 00 00 
  804465:	ff d0                	callq  *%rax
}
  804467:	c9                   	leaveq 
  804468:	c3                   	retq   

0000000000804469 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804469:	55                   	push   %rbp
  80446a:	48 89 e5             	mov    %rsp,%rbp
  80446d:	48 83 ec 30          	sub    $0x30,%rsp
  804471:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804474:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804478:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80447b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80447e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804485:	00 00 00 
  804488:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80448b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80448d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804494:	00 00 00 
  804497:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80449a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80449d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044a4:	00 00 00 
  8044a7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8044aa:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8044ad:	bf 07 00 00 00       	mov    $0x7,%edi
  8044b2:	48 b8 f4 41 80 00 00 	movabs $0x8041f4,%rax
  8044b9:	00 00 00 
  8044bc:	ff d0                	callq  *%rax
  8044be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044c5:	78 69                	js     804530 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8044c7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8044ce:	7f 08                	jg     8044d8 <nsipc_recv+0x6f>
  8044d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044d3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8044d6:	7e 35                	jle    80450d <nsipc_recv+0xa4>
  8044d8:	48 b9 5f 5e 80 00 00 	movabs $0x805e5f,%rcx
  8044df:	00 00 00 
  8044e2:	48 ba 74 5e 80 00 00 	movabs $0x805e74,%rdx
  8044e9:	00 00 00 
  8044ec:	be 61 00 00 00       	mov    $0x61,%esi
  8044f1:	48 bf 89 5e 80 00 00 	movabs $0x805e89,%rdi
  8044f8:	00 00 00 
  8044fb:	b8 00 00 00 00       	mov    $0x0,%eax
  804500:	49 b8 56 0b 80 00 00 	movabs $0x800b56,%r8
  804507:	00 00 00 
  80450a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80450d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804510:	48 63 d0             	movslq %eax,%rdx
  804513:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804517:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  80451e:	00 00 00 
  804521:	48 89 c7             	mov    %rax,%rdi
  804524:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  80452b:	00 00 00 
  80452e:	ff d0                	callq  *%rax
	}

	return r;
  804530:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804533:	c9                   	leaveq 
  804534:	c3                   	retq   

0000000000804535 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804535:	55                   	push   %rbp
  804536:	48 89 e5             	mov    %rsp,%rbp
  804539:	48 83 ec 20          	sub    $0x20,%rsp
  80453d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804540:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804544:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804547:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80454a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804551:	00 00 00 
  804554:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804557:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804559:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804560:	7e 35                	jle    804597 <nsipc_send+0x62>
  804562:	48 b9 95 5e 80 00 00 	movabs $0x805e95,%rcx
  804569:	00 00 00 
  80456c:	48 ba 74 5e 80 00 00 	movabs $0x805e74,%rdx
  804573:	00 00 00 
  804576:	be 6c 00 00 00       	mov    $0x6c,%esi
  80457b:	48 bf 89 5e 80 00 00 	movabs $0x805e89,%rdi
  804582:	00 00 00 
  804585:	b8 00 00 00 00       	mov    $0x0,%eax
  80458a:	49 b8 56 0b 80 00 00 	movabs $0x800b56,%r8
  804591:	00 00 00 
  804594:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804597:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80459a:	48 63 d0             	movslq %eax,%rdx
  80459d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045a1:	48 89 c6             	mov    %rax,%rsi
  8045a4:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  8045ab:	00 00 00 
  8045ae:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  8045b5:	00 00 00 
  8045b8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8045ba:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045c1:	00 00 00 
  8045c4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8045c7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8045ca:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045d1:	00 00 00 
  8045d4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8045d7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8045da:	bf 08 00 00 00       	mov    $0x8,%edi
  8045df:	48 b8 f4 41 80 00 00 	movabs $0x8041f4,%rax
  8045e6:	00 00 00 
  8045e9:	ff d0                	callq  *%rax
}
  8045eb:	c9                   	leaveq 
  8045ec:	c3                   	retq   

00000000008045ed <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8045ed:	55                   	push   %rbp
  8045ee:	48 89 e5             	mov    %rsp,%rbp
  8045f1:	48 83 ec 10          	sub    $0x10,%rsp
  8045f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8045f8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8045fb:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8045fe:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804605:	00 00 00 
  804608:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80460b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80460d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804614:	00 00 00 
  804617:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80461a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80461d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804624:	00 00 00 
  804627:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80462a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80462d:	bf 09 00 00 00       	mov    $0x9,%edi
  804632:	48 b8 f4 41 80 00 00 	movabs $0x8041f4,%rax
  804639:	00 00 00 
  80463c:	ff d0                	callq  *%rax
}
  80463e:	c9                   	leaveq 
  80463f:	c3                   	retq   

0000000000804640 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804640:	55                   	push   %rbp
  804641:	48 89 e5             	mov    %rsp,%rbp
  804644:	53                   	push   %rbx
  804645:	48 83 ec 38          	sub    $0x38,%rsp
  804649:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80464d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804651:	48 89 c7             	mov    %rax,%rdi
  804654:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  80465b:	00 00 00 
  80465e:	ff d0                	callq  *%rax
  804660:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804663:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804667:	0f 88 bf 01 00 00    	js     80482c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80466d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804671:	ba 07 04 00 00       	mov    $0x407,%edx
  804676:	48 89 c6             	mov    %rax,%rsi
  804679:	bf 00 00 00 00       	mov    $0x0,%edi
  80467e:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  804685:	00 00 00 
  804688:	ff d0                	callq  *%rax
  80468a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80468d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804691:	0f 88 95 01 00 00    	js     80482c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804697:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80469b:	48 89 c7             	mov    %rax,%rdi
  80469e:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  8046a5:	00 00 00 
  8046a8:	ff d0                	callq  *%rax
  8046aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8046ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8046b1:	0f 88 5d 01 00 00    	js     804814 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8046b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046bb:	ba 07 04 00 00       	mov    $0x407,%edx
  8046c0:	48 89 c6             	mov    %rax,%rsi
  8046c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8046c8:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  8046cf:	00 00 00 
  8046d2:	ff d0                	callq  *%rax
  8046d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8046d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8046db:	0f 88 33 01 00 00    	js     804814 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8046e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046e5:	48 89 c7             	mov    %rax,%rdi
  8046e8:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  8046ef:	00 00 00 
  8046f2:	ff d0                	callq  *%rax
  8046f4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8046f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046fc:	ba 07 04 00 00       	mov    $0x407,%edx
  804701:	48 89 c6             	mov    %rax,%rsi
  804704:	bf 00 00 00 00       	mov    $0x0,%edi
  804709:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  804710:	00 00 00 
  804713:	ff d0                	callq  *%rax
  804715:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804718:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80471c:	79 05                	jns    804723 <pipe+0xe3>
		goto err2;
  80471e:	e9 d9 00 00 00       	jmpq   8047fc <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804723:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804727:	48 89 c7             	mov    %rax,%rdi
  80472a:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  804731:	00 00 00 
  804734:	ff d0                	callq  *%rax
  804736:	48 89 c2             	mov    %rax,%rdx
  804739:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80473d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804743:	48 89 d1             	mov    %rdx,%rcx
  804746:	ba 00 00 00 00       	mov    $0x0,%edx
  80474b:	48 89 c6             	mov    %rax,%rsi
  80474e:	bf 00 00 00 00       	mov    $0x0,%edi
  804753:	48 b8 c3 22 80 00 00 	movabs $0x8022c3,%rax
  80475a:	00 00 00 
  80475d:	ff d0                	callq  *%rax
  80475f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804762:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804766:	79 1b                	jns    804783 <pipe+0x143>
		goto err3;
  804768:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804769:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80476d:	48 89 c6             	mov    %rax,%rsi
  804770:	bf 00 00 00 00       	mov    $0x0,%edi
  804775:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  80477c:	00 00 00 
  80477f:	ff d0                	callq  *%rax
  804781:	eb 79                	jmp    8047fc <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804787:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  80478e:	00 00 00 
  804791:	8b 12                	mov    (%rdx),%edx
  804793:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804799:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8047a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047a4:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  8047ab:	00 00 00 
  8047ae:	8b 12                	mov    (%rdx),%edx
  8047b0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8047b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047b6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8047bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047c1:	48 89 c7             	mov    %rax,%rdi
  8047c4:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  8047cb:	00 00 00 
  8047ce:	ff d0                	callq  *%rax
  8047d0:	89 c2                	mov    %eax,%edx
  8047d2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8047d6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8047d8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8047dc:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8047e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047e4:	48 89 c7             	mov    %rax,%rdi
  8047e7:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  8047ee:	00 00 00 
  8047f1:	ff d0                	callq  *%rax
  8047f3:	89 03                	mov    %eax,(%rbx)
	return 0;
  8047f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8047fa:	eb 33                	jmp    80482f <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8047fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804800:	48 89 c6             	mov    %rax,%rsi
  804803:	bf 00 00 00 00       	mov    $0x0,%edi
  804808:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  80480f:	00 00 00 
  804812:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804814:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804818:	48 89 c6             	mov    %rax,%rsi
  80481b:	bf 00 00 00 00       	mov    $0x0,%edi
  804820:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  804827:	00 00 00 
  80482a:	ff d0                	callq  *%rax
err:
	return r;
  80482c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80482f:	48 83 c4 38          	add    $0x38,%rsp
  804833:	5b                   	pop    %rbx
  804834:	5d                   	pop    %rbp
  804835:	c3                   	retq   

0000000000804836 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804836:	55                   	push   %rbp
  804837:	48 89 e5             	mov    %rsp,%rbp
  80483a:	53                   	push   %rbx
  80483b:	48 83 ec 28          	sub    $0x28,%rsp
  80483f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804843:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804847:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80484e:	00 00 00 
  804851:	48 8b 00             	mov    (%rax),%rax
  804854:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80485a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80485d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804861:	48 89 c7             	mov    %rax,%rdi
  804864:	48 b8 fc 4f 80 00 00 	movabs $0x804ffc,%rax
  80486b:	00 00 00 
  80486e:	ff d0                	callq  *%rax
  804870:	89 c3                	mov    %eax,%ebx
  804872:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804876:	48 89 c7             	mov    %rax,%rdi
  804879:	48 b8 fc 4f 80 00 00 	movabs $0x804ffc,%rax
  804880:	00 00 00 
  804883:	ff d0                	callq  *%rax
  804885:	39 c3                	cmp    %eax,%ebx
  804887:	0f 94 c0             	sete   %al
  80488a:	0f b6 c0             	movzbl %al,%eax
  80488d:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804890:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804897:	00 00 00 
  80489a:	48 8b 00             	mov    (%rax),%rax
  80489d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8048a3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8048a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048a9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8048ac:	75 05                	jne    8048b3 <_pipeisclosed+0x7d>
			return ret;
  8048ae:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8048b1:	eb 4f                	jmp    804902 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8048b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048b6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8048b9:	74 42                	je     8048fd <_pipeisclosed+0xc7>
  8048bb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8048bf:	75 3c                	jne    8048fd <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8048c1:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8048c8:	00 00 00 
  8048cb:	48 8b 00             	mov    (%rax),%rax
  8048ce:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8048d4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8048d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048da:	89 c6                	mov    %eax,%esi
  8048dc:	48 bf a6 5e 80 00 00 	movabs $0x805ea6,%rdi
  8048e3:	00 00 00 
  8048e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8048eb:	49 b8 8f 0d 80 00 00 	movabs $0x800d8f,%r8
  8048f2:	00 00 00 
  8048f5:	41 ff d0             	callq  *%r8
	}
  8048f8:	e9 4a ff ff ff       	jmpq   804847 <_pipeisclosed+0x11>
  8048fd:	e9 45 ff ff ff       	jmpq   804847 <_pipeisclosed+0x11>
}
  804902:	48 83 c4 28          	add    $0x28,%rsp
  804906:	5b                   	pop    %rbx
  804907:	5d                   	pop    %rbp
  804908:	c3                   	retq   

0000000000804909 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804909:	55                   	push   %rbp
  80490a:	48 89 e5             	mov    %rsp,%rbp
  80490d:	48 83 ec 30          	sub    $0x30,%rsp
  804911:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804914:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804918:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80491b:	48 89 d6             	mov    %rdx,%rsi
  80491e:	89 c7                	mov    %eax,%edi
  804920:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  804927:	00 00 00 
  80492a:	ff d0                	callq  *%rax
  80492c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80492f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804933:	79 05                	jns    80493a <pipeisclosed+0x31>
		return r;
  804935:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804938:	eb 31                	jmp    80496b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80493a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80493e:	48 89 c7             	mov    %rax,%rdi
  804941:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  804948:	00 00 00 
  80494b:	ff d0                	callq  *%rax
  80494d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804955:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804959:	48 89 d6             	mov    %rdx,%rsi
  80495c:	48 89 c7             	mov    %rax,%rdi
  80495f:	48 b8 36 48 80 00 00 	movabs $0x804836,%rax
  804966:	00 00 00 
  804969:	ff d0                	callq  *%rax
}
  80496b:	c9                   	leaveq 
  80496c:	c3                   	retq   

000000000080496d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80496d:	55                   	push   %rbp
  80496e:	48 89 e5             	mov    %rsp,%rbp
  804971:	48 83 ec 40          	sub    $0x40,%rsp
  804975:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804979:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80497d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804981:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804985:	48 89 c7             	mov    %rax,%rdi
  804988:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  80498f:	00 00 00 
  804992:	ff d0                	callq  *%rax
  804994:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804998:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80499c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8049a0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8049a7:	00 
  8049a8:	e9 92 00 00 00       	jmpq   804a3f <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8049ad:	eb 41                	jmp    8049f0 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8049af:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8049b4:	74 09                	je     8049bf <devpipe_read+0x52>
				return i;
  8049b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049ba:	e9 92 00 00 00       	jmpq   804a51 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8049bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049c7:	48 89 d6             	mov    %rdx,%rsi
  8049ca:	48 89 c7             	mov    %rax,%rdi
  8049cd:	48 b8 36 48 80 00 00 	movabs $0x804836,%rax
  8049d4:	00 00 00 
  8049d7:	ff d0                	callq  *%rax
  8049d9:	85 c0                	test   %eax,%eax
  8049db:	74 07                	je     8049e4 <devpipe_read+0x77>
				return 0;
  8049dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8049e2:	eb 6d                	jmp    804a51 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8049e4:	48 b8 35 22 80 00 00 	movabs $0x802235,%rax
  8049eb:	00 00 00 
  8049ee:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8049f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049f4:	8b 10                	mov    (%rax),%edx
  8049f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049fa:	8b 40 04             	mov    0x4(%rax),%eax
  8049fd:	39 c2                	cmp    %eax,%edx
  8049ff:	74 ae                	je     8049af <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804a01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a05:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804a09:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804a0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a11:	8b 00                	mov    (%rax),%eax
  804a13:	99                   	cltd   
  804a14:	c1 ea 1b             	shr    $0x1b,%edx
  804a17:	01 d0                	add    %edx,%eax
  804a19:	83 e0 1f             	and    $0x1f,%eax
  804a1c:	29 d0                	sub    %edx,%eax
  804a1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a22:	48 98                	cltq   
  804a24:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804a29:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804a2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a2f:	8b 00                	mov    (%rax),%eax
  804a31:	8d 50 01             	lea    0x1(%rax),%edx
  804a34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a38:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804a3a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804a3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a43:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804a47:	0f 82 60 ff ff ff    	jb     8049ad <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804a4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804a51:	c9                   	leaveq 
  804a52:	c3                   	retq   

0000000000804a53 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804a53:	55                   	push   %rbp
  804a54:	48 89 e5             	mov    %rsp,%rbp
  804a57:	48 83 ec 40          	sub    $0x40,%rsp
  804a5b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804a5f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804a63:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804a67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a6b:	48 89 c7             	mov    %rax,%rdi
  804a6e:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  804a75:	00 00 00 
  804a78:	ff d0                	callq  *%rax
  804a7a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804a7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804a86:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804a8d:	00 
  804a8e:	e9 8e 00 00 00       	jmpq   804b21 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804a93:	eb 31                	jmp    804ac6 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804a95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a9d:	48 89 d6             	mov    %rdx,%rsi
  804aa0:	48 89 c7             	mov    %rax,%rdi
  804aa3:	48 b8 36 48 80 00 00 	movabs $0x804836,%rax
  804aaa:	00 00 00 
  804aad:	ff d0                	callq  *%rax
  804aaf:	85 c0                	test   %eax,%eax
  804ab1:	74 07                	je     804aba <devpipe_write+0x67>
				return 0;
  804ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  804ab8:	eb 79                	jmp    804b33 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804aba:	48 b8 35 22 80 00 00 	movabs $0x802235,%rax
  804ac1:	00 00 00 
  804ac4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804ac6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804aca:	8b 40 04             	mov    0x4(%rax),%eax
  804acd:	48 63 d0             	movslq %eax,%rdx
  804ad0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ad4:	8b 00                	mov    (%rax),%eax
  804ad6:	48 98                	cltq   
  804ad8:	48 83 c0 20          	add    $0x20,%rax
  804adc:	48 39 c2             	cmp    %rax,%rdx
  804adf:	73 b4                	jae    804a95 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804ae1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ae5:	8b 40 04             	mov    0x4(%rax),%eax
  804ae8:	99                   	cltd   
  804ae9:	c1 ea 1b             	shr    $0x1b,%edx
  804aec:	01 d0                	add    %edx,%eax
  804aee:	83 e0 1f             	and    $0x1f,%eax
  804af1:	29 d0                	sub    %edx,%eax
  804af3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804af7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804afb:	48 01 ca             	add    %rcx,%rdx
  804afe:	0f b6 0a             	movzbl (%rdx),%ecx
  804b01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b05:	48 98                	cltq   
  804b07:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804b0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b0f:	8b 40 04             	mov    0x4(%rax),%eax
  804b12:	8d 50 01             	lea    0x1(%rax),%edx
  804b15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b19:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804b1c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804b21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b25:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804b29:	0f 82 64 ff ff ff    	jb     804a93 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804b2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804b33:	c9                   	leaveq 
  804b34:	c3                   	retq   

0000000000804b35 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804b35:	55                   	push   %rbp
  804b36:	48 89 e5             	mov    %rsp,%rbp
  804b39:	48 83 ec 20          	sub    $0x20,%rsp
  804b3d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804b41:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804b45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b49:	48 89 c7             	mov    %rax,%rdi
  804b4c:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  804b53:	00 00 00 
  804b56:	ff d0                	callq  *%rax
  804b58:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804b5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b60:	48 be b9 5e 80 00 00 	movabs $0x805eb9,%rsi
  804b67:	00 00 00 
  804b6a:	48 89 c7             	mov    %rax,%rdi
  804b6d:	48 b8 44 19 80 00 00 	movabs $0x801944,%rax
  804b74:	00 00 00 
  804b77:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804b79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b7d:	8b 50 04             	mov    0x4(%rax),%edx
  804b80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b84:	8b 00                	mov    (%rax),%eax
  804b86:	29 c2                	sub    %eax,%edx
  804b88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b8c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804b92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b96:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804b9d:	00 00 00 
	stat->st_dev = &devpipe;
  804ba0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ba4:	48 b9 e0 80 80 00 00 	movabs $0x8080e0,%rcx
  804bab:	00 00 00 
  804bae:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804bba:	c9                   	leaveq 
  804bbb:	c3                   	retq   

0000000000804bbc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804bbc:	55                   	push   %rbp
  804bbd:	48 89 e5             	mov    %rsp,%rbp
  804bc0:	48 83 ec 10          	sub    $0x10,%rsp
  804bc4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bcc:	48 89 c6             	mov    %rax,%rsi
  804bcf:	bf 00 00 00 00       	mov    $0x0,%edi
  804bd4:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  804bdb:	00 00 00 
  804bde:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804be0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804be4:	48 89 c7             	mov    %rax,%rdi
  804be7:	48 b8 53 2e 80 00 00 	movabs $0x802e53,%rax
  804bee:	00 00 00 
  804bf1:	ff d0                	callq  *%rax
  804bf3:	48 89 c6             	mov    %rax,%rsi
  804bf6:	bf 00 00 00 00       	mov    $0x0,%edi
  804bfb:	48 b8 1e 23 80 00 00 	movabs $0x80231e,%rax
  804c02:	00 00 00 
  804c05:	ff d0                	callq  *%rax
}
  804c07:	c9                   	leaveq 
  804c08:	c3                   	retq   

0000000000804c09 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804c09:	55                   	push   %rbp
  804c0a:	48 89 e5             	mov    %rsp,%rbp
  804c0d:	48 83 ec 20          	sub    $0x20,%rsp
  804c11:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804c14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804c17:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804c1a:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804c1e:	be 01 00 00 00       	mov    $0x1,%esi
  804c23:	48 89 c7             	mov    %rax,%rdi
  804c26:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  804c2d:	00 00 00 
  804c30:	ff d0                	callq  *%rax
}
  804c32:	c9                   	leaveq 
  804c33:	c3                   	retq   

0000000000804c34 <getchar>:

int
getchar(void)
{
  804c34:	55                   	push   %rbp
  804c35:	48 89 e5             	mov    %rsp,%rbp
  804c38:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804c3c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804c40:	ba 01 00 00 00       	mov    $0x1,%edx
  804c45:	48 89 c6             	mov    %rax,%rsi
  804c48:	bf 00 00 00 00       	mov    $0x0,%edi
  804c4d:	48 b8 48 33 80 00 00 	movabs $0x803348,%rax
  804c54:	00 00 00 
  804c57:	ff d0                	callq  *%rax
  804c59:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804c5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c60:	79 05                	jns    804c67 <getchar+0x33>
		return r;
  804c62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c65:	eb 14                	jmp    804c7b <getchar+0x47>
	if (r < 1)
  804c67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c6b:	7f 07                	jg     804c74 <getchar+0x40>
		return -E_EOF;
  804c6d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804c72:	eb 07                	jmp    804c7b <getchar+0x47>
	return c;
  804c74:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804c78:	0f b6 c0             	movzbl %al,%eax
}
  804c7b:	c9                   	leaveq 
  804c7c:	c3                   	retq   

0000000000804c7d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804c7d:	55                   	push   %rbp
  804c7e:	48 89 e5             	mov    %rsp,%rbp
  804c81:	48 83 ec 20          	sub    $0x20,%rsp
  804c85:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804c88:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804c8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804c8f:	48 89 d6             	mov    %rdx,%rsi
  804c92:	89 c7                	mov    %eax,%edi
  804c94:	48 b8 16 2f 80 00 00 	movabs $0x802f16,%rax
  804c9b:	00 00 00 
  804c9e:	ff d0                	callq  *%rax
  804ca0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ca3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ca7:	79 05                	jns    804cae <iscons+0x31>
		return r;
  804ca9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cac:	eb 1a                	jmp    804cc8 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804cae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cb2:	8b 10                	mov    (%rax),%edx
  804cb4:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  804cbb:	00 00 00 
  804cbe:	8b 00                	mov    (%rax),%eax
  804cc0:	39 c2                	cmp    %eax,%edx
  804cc2:	0f 94 c0             	sete   %al
  804cc5:	0f b6 c0             	movzbl %al,%eax
}
  804cc8:	c9                   	leaveq 
  804cc9:	c3                   	retq   

0000000000804cca <opencons>:

int
opencons(void)
{
  804cca:	55                   	push   %rbp
  804ccb:	48 89 e5             	mov    %rsp,%rbp
  804cce:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804cd2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804cd6:	48 89 c7             	mov    %rax,%rdi
  804cd9:	48 b8 7e 2e 80 00 00 	movabs $0x802e7e,%rax
  804ce0:	00 00 00 
  804ce3:	ff d0                	callq  *%rax
  804ce5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ce8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804cec:	79 05                	jns    804cf3 <opencons+0x29>
		return r;
  804cee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cf1:	eb 5b                	jmp    804d4e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804cf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cf7:	ba 07 04 00 00       	mov    $0x407,%edx
  804cfc:	48 89 c6             	mov    %rax,%rsi
  804cff:	bf 00 00 00 00       	mov    $0x0,%edi
  804d04:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  804d0b:	00 00 00 
  804d0e:	ff d0                	callq  *%rax
  804d10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d17:	79 05                	jns    804d1e <opencons+0x54>
		return r;
  804d19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d1c:	eb 30                	jmp    804d4e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804d1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d22:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  804d29:	00 00 00 
  804d2c:	8b 12                	mov    (%rdx),%edx
  804d2e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804d30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d34:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804d3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d3f:	48 89 c7             	mov    %rax,%rdi
  804d42:	48 b8 30 2e 80 00 00 	movabs $0x802e30,%rax
  804d49:	00 00 00 
  804d4c:	ff d0                	callq  *%rax
}
  804d4e:	c9                   	leaveq 
  804d4f:	c3                   	retq   

0000000000804d50 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804d50:	55                   	push   %rbp
  804d51:	48 89 e5             	mov    %rsp,%rbp
  804d54:	48 83 ec 30          	sub    $0x30,%rsp
  804d58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804d5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804d60:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804d64:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804d69:	75 07                	jne    804d72 <devcons_read+0x22>
		return 0;
  804d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  804d70:	eb 4b                	jmp    804dbd <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804d72:	eb 0c                	jmp    804d80 <devcons_read+0x30>
		sys_yield();
  804d74:	48 b8 35 22 80 00 00 	movabs $0x802235,%rax
  804d7b:	00 00 00 
  804d7e:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804d80:	48 b8 75 21 80 00 00 	movabs $0x802175,%rax
  804d87:	00 00 00 
  804d8a:	ff d0                	callq  *%rax
  804d8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d93:	74 df                	je     804d74 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804d95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d99:	79 05                	jns    804da0 <devcons_read+0x50>
		return c;
  804d9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d9e:	eb 1d                	jmp    804dbd <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804da0:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804da4:	75 07                	jne    804dad <devcons_read+0x5d>
		return 0;
  804da6:	b8 00 00 00 00       	mov    $0x0,%eax
  804dab:	eb 10                	jmp    804dbd <devcons_read+0x6d>
	*(char*)vbuf = c;
  804dad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804db0:	89 c2                	mov    %eax,%edx
  804db2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804db6:	88 10                	mov    %dl,(%rax)
	return 1;
  804db8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804dbd:	c9                   	leaveq 
  804dbe:	c3                   	retq   

0000000000804dbf <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804dbf:	55                   	push   %rbp
  804dc0:	48 89 e5             	mov    %rsp,%rbp
  804dc3:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804dca:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804dd1:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804dd8:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804ddf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804de6:	eb 76                	jmp    804e5e <devcons_write+0x9f>
		m = n - tot;
  804de8:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804def:	89 c2                	mov    %eax,%edx
  804df1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804df4:	29 c2                	sub    %eax,%edx
  804df6:	89 d0                	mov    %edx,%eax
  804df8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804dfb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804dfe:	83 f8 7f             	cmp    $0x7f,%eax
  804e01:	76 07                	jbe    804e0a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804e03:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804e0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e0d:	48 63 d0             	movslq %eax,%rdx
  804e10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e13:	48 63 c8             	movslq %eax,%rcx
  804e16:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804e1d:	48 01 c1             	add    %rax,%rcx
  804e20:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804e27:	48 89 ce             	mov    %rcx,%rsi
  804e2a:	48 89 c7             	mov    %rax,%rdi
  804e2d:	48 b8 68 1c 80 00 00 	movabs $0x801c68,%rax
  804e34:	00 00 00 
  804e37:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804e39:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e3c:	48 63 d0             	movslq %eax,%rdx
  804e3f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804e46:	48 89 d6             	mov    %rdx,%rsi
  804e49:	48 89 c7             	mov    %rax,%rdi
  804e4c:	48 b8 2b 21 80 00 00 	movabs $0x80212b,%rax
  804e53:	00 00 00 
  804e56:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804e58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e5b:	01 45 fc             	add    %eax,-0x4(%rbp)
  804e5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e61:	48 98                	cltq   
  804e63:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804e6a:	0f 82 78 ff ff ff    	jb     804de8 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804e70:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804e73:	c9                   	leaveq 
  804e74:	c3                   	retq   

0000000000804e75 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804e75:	55                   	push   %rbp
  804e76:	48 89 e5             	mov    %rsp,%rbp
  804e79:	48 83 ec 08          	sub    $0x8,%rsp
  804e7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804e86:	c9                   	leaveq 
  804e87:	c3                   	retq   

0000000000804e88 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804e88:	55                   	push   %rbp
  804e89:	48 89 e5             	mov    %rsp,%rbp
  804e8c:	48 83 ec 10          	sub    $0x10,%rsp
  804e90:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804e94:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e9c:	48 be c5 5e 80 00 00 	movabs $0x805ec5,%rsi
  804ea3:	00 00 00 
  804ea6:	48 89 c7             	mov    %rax,%rdi
  804ea9:	48 b8 44 19 80 00 00 	movabs $0x801944,%rax
  804eb0:	00 00 00 
  804eb3:	ff d0                	callq  *%rax
	return 0;
  804eb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804eba:	c9                   	leaveq 
  804ebb:	c3                   	retq   

0000000000804ebc <set_pgfault_handler>:
// _pgfault_upcall routine when a page fault occurs.


void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804ebc:	55                   	push   %rbp
  804ebd:	48 89 e5             	mov    %rsp,%rbp
  804ec0:	48 83 ec 10          	sub    $0x10,%rsp
  804ec4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
        int r;
        //struct Env *thisenv = NULL;
        if (_pgfault_handler == 0) {
  804ec8:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804ecf:	00 00 00 
  804ed2:	48 8b 00             	mov    (%rax),%rax
  804ed5:	48 85 c0             	test   %rax,%rax
  804ed8:	0f 85 84 00 00 00    	jne    804f62 <set_pgfault_handler+0xa6>
                // First time through!
                // LAB 4: Your code here.
                //cprintf("Inside set_pgfault_handler");
                if(0> sys_page_alloc(thisenv->env_id, (void*)UXSTACKTOP - PGSIZE,PTE_U|PTE_P|PTE_W)){
  804ede:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804ee5:	00 00 00 
  804ee8:	48 8b 00             	mov    (%rax),%rax
  804eeb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804ef1:	ba 07 00 00 00       	mov    $0x7,%edx
  804ef6:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804efb:	89 c7                	mov    %eax,%edi
  804efd:	48 b8 73 22 80 00 00 	movabs $0x802273,%rax
  804f04:	00 00 00 
  804f07:	ff d0                	callq  *%rax
  804f09:	85 c0                	test   %eax,%eax
  804f0b:	79 2a                	jns    804f37 <set_pgfault_handler+0x7b>
                        panic("Page not available for exception stack");
  804f0d:	48 ba d0 5e 80 00 00 	movabs $0x805ed0,%rdx
  804f14:	00 00 00 
  804f17:	be 23 00 00 00       	mov    $0x23,%esi
  804f1c:	48 bf f7 5e 80 00 00 	movabs $0x805ef7,%rdi
  804f23:	00 00 00 
  804f26:	b8 00 00 00 00       	mov    $0x0,%eax
  804f2b:	48 b9 56 0b 80 00 00 	movabs $0x800b56,%rcx
  804f32:	00 00 00 
  804f35:	ff d1                	callq  *%rcx
                }
                sys_env_set_pgfault_upcall(thisenv->env_id, (void*)_pgfault_upcall);
  804f37:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804f3e:	00 00 00 
  804f41:	48 8b 00             	mov    (%rax),%rax
  804f44:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804f4a:	48 be 75 4f 80 00 00 	movabs $0x804f75,%rsi
  804f51:	00 00 00 
  804f54:	89 c7                	mov    %eax,%edi
  804f56:	48 b8 fd 23 80 00 00 	movabs $0x8023fd,%rax
  804f5d:	00 00 00 
  804f60:	ff d0                	callq  *%rax
				
               // sys_env_set_pgfault_upcall(thisenv->env_id,handler);
        }

        // Save handler pointer for assembly to call.
        _pgfault_handler = handler;
  804f62:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804f69:	00 00 00 
  804f6c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804f70:	48 89 10             	mov    %rdx,(%rax)
}
  804f73:	c9                   	leaveq 
  804f74:	c3                   	retq   

0000000000804f75 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804f75:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804f78:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  804f7f:	00 00 00 
call *%rax
  804f82:	ff d0                	callq  *%rax
    // LAB 4: Your code here.

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.

	movq 136(%rsp), %rbx  //Load RIP 
  804f84:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804f8b:	00 
	movq 152(%rsp), %rcx  //Load RSP
  804f8c:	48 8b 8c 24 98 00 00 	mov    0x98(%rsp),%rcx
  804f93:	00 
	//Move pointer on the stack and save the RIP on trap time stack 
	subq $8, %rcx          
  804f94:	48 83 e9 08          	sub    $0x8,%rcx
	movq %rbx, (%rcx) 
  804f98:	48 89 19             	mov    %rbx,(%rcx)
	//Now update value of trap time stack rsp after pushing rip in UXSTACKTOP
	movq %rcx, 152(%rsp)
  804f9b:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  804fa2:	00 
	
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16,%rsp
  804fa3:	48 83 c4 10          	add    $0x10,%rsp
	POPA_ 
  804fa7:	4c 8b 3c 24          	mov    (%rsp),%r15
  804fab:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804fb0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804fb5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804fba:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804fbf:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804fc4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804fc9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804fce:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804fd3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804fd8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804fdd:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804fe2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804fe7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804fec:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804ff1:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addq $8, %rsp
  804ff5:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  804ff9:	9d                   	popfq  
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp
  804ffa:	5c                   	pop    %rsp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  804ffb:	c3                   	retq   

0000000000804ffc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804ffc:	55                   	push   %rbp
  804ffd:	48 89 e5             	mov    %rsp,%rbp
  805000:	48 83 ec 18          	sub    $0x18,%rsp
  805004:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805008:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80500c:	48 c1 e8 15          	shr    $0x15,%rax
  805010:	48 89 c2             	mov    %rax,%rdx
  805013:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80501a:	01 00 00 
  80501d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805021:	83 e0 01             	and    $0x1,%eax
  805024:	48 85 c0             	test   %rax,%rax
  805027:	75 07                	jne    805030 <pageref+0x34>
		return 0;
  805029:	b8 00 00 00 00       	mov    $0x0,%eax
  80502e:	eb 53                	jmp    805083 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805030:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805034:	48 c1 e8 0c          	shr    $0xc,%rax
  805038:	48 89 c2             	mov    %rax,%rdx
  80503b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805042:	01 00 00 
  805045:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805049:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80504d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805051:	83 e0 01             	and    $0x1,%eax
  805054:	48 85 c0             	test   %rax,%rax
  805057:	75 07                	jne    805060 <pageref+0x64>
		return 0;
  805059:	b8 00 00 00 00       	mov    $0x0,%eax
  80505e:	eb 23                	jmp    805083 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805060:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805064:	48 c1 e8 0c          	shr    $0xc,%rax
  805068:	48 89 c2             	mov    %rax,%rdx
  80506b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805072:	00 00 00 
  805075:	48 c1 e2 04          	shl    $0x4,%rdx
  805079:	48 01 d0             	add    %rdx,%rax
  80507c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805080:	0f b7 c0             	movzwl %ax,%eax
}
  805083:	c9                   	leaveq 
  805084:	c3                   	retq   

0000000000805085 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  805085:	55                   	push   %rbp
  805086:	48 89 e5             	mov    %rsp,%rbp
  805089:	48 83 ec 20          	sub    $0x20,%rsp
  80508d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  805091:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805095:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805099:	48 89 d6             	mov    %rdx,%rsi
  80509c:	48 89 c7             	mov    %rax,%rdi
  80509f:	48 b8 bb 50 80 00 00 	movabs $0x8050bb,%rax
  8050a6:	00 00 00 
  8050a9:	ff d0                	callq  *%rax
  8050ab:	85 c0                	test   %eax,%eax
  8050ad:	74 05                	je     8050b4 <inet_addr+0x2f>
    return (val.s_addr);
  8050af:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8050b2:	eb 05                	jmp    8050b9 <inet_addr+0x34>
  }
  return (INADDR_NONE);
  8050b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8050b9:	c9                   	leaveq 
  8050ba:	c3                   	retq   

00000000008050bb <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8050bb:	55                   	push   %rbp
  8050bc:	48 89 e5             	mov    %rsp,%rbp
  8050bf:	48 83 ec 40          	sub    $0x40,%rsp
  8050c3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8050c7:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  8050cb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8050cf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  8050d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8050d7:	0f b6 00             	movzbl (%rax),%eax
  8050da:	0f be c0             	movsbl %al,%eax
  8050dd:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  8050e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8050e3:	3c 2f                	cmp    $0x2f,%al
  8050e5:	76 07                	jbe    8050ee <inet_aton+0x33>
  8050e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8050ea:	3c 39                	cmp    $0x39,%al
  8050ec:	76 0a                	jbe    8050f8 <inet_aton+0x3d>
      return (0);
  8050ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8050f3:	e9 68 02 00 00       	jmpq   805360 <inet_aton+0x2a5>
    val = 0;
  8050f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  8050ff:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  805106:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  80510a:	75 40                	jne    80514c <inet_aton+0x91>
      c = *++cp;
  80510c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805111:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805115:	0f b6 00             	movzbl (%rax),%eax
  805118:	0f be c0             	movsbl %al,%eax
  80511b:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  80511e:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  805122:	74 06                	je     80512a <inet_aton+0x6f>
  805124:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  805128:	75 1b                	jne    805145 <inet_aton+0x8a>
        base = 16;
  80512a:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  805131:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805136:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80513a:	0f b6 00             	movzbl (%rax),%eax
  80513d:	0f be c0             	movsbl %al,%eax
  805140:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805143:	eb 07                	jmp    80514c <inet_aton+0x91>
      } else
        base = 8;
  805145:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  80514c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80514f:	3c 2f                	cmp    $0x2f,%al
  805151:	76 2f                	jbe    805182 <inet_aton+0xc7>
  805153:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805156:	3c 39                	cmp    $0x39,%al
  805158:	77 28                	ja     805182 <inet_aton+0xc7>
        val = (val * base) + (int)(c - '0');
  80515a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80515d:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  805161:	89 c2                	mov    %eax,%edx
  805163:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805166:	01 d0                	add    %edx,%eax
  805168:	83 e8 30             	sub    $0x30,%eax
  80516b:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  80516e:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805173:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805177:	0f b6 00             	movzbl (%rax),%eax
  80517a:	0f be c0             	movsbl %al,%eax
  80517d:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else if (base == 16 && isxdigit(c)) {
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
        c = *++cp;
      } else
        break;
    }
  805180:	eb ca                	jmp    80514c <inet_aton+0x91>
    }
    for (;;) {
      if (isdigit(c)) {
        val = (val * base) + (int)(c - '0');
        c = *++cp;
      } else if (base == 16 && isxdigit(c)) {
  805182:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  805186:	75 72                	jne    8051fa <inet_aton+0x13f>
  805188:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80518b:	3c 2f                	cmp    $0x2f,%al
  80518d:	76 07                	jbe    805196 <inet_aton+0xdb>
  80518f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805192:	3c 39                	cmp    $0x39,%al
  805194:	76 1c                	jbe    8051b2 <inet_aton+0xf7>
  805196:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805199:	3c 60                	cmp    $0x60,%al
  80519b:	76 07                	jbe    8051a4 <inet_aton+0xe9>
  80519d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051a0:	3c 66                	cmp    $0x66,%al
  8051a2:	76 0e                	jbe    8051b2 <inet_aton+0xf7>
  8051a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051a7:	3c 40                	cmp    $0x40,%al
  8051a9:	76 4f                	jbe    8051fa <inet_aton+0x13f>
  8051ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051ae:	3c 46                	cmp    $0x46,%al
  8051b0:	77 48                	ja     8051fa <inet_aton+0x13f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8051b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051b5:	c1 e0 04             	shl    $0x4,%eax
  8051b8:	89 c2                	mov    %eax,%edx
  8051ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051bd:	8d 48 0a             	lea    0xa(%rax),%ecx
  8051c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051c3:	3c 60                	cmp    $0x60,%al
  8051c5:	76 0e                	jbe    8051d5 <inet_aton+0x11a>
  8051c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051ca:	3c 7a                	cmp    $0x7a,%al
  8051cc:	77 07                	ja     8051d5 <inet_aton+0x11a>
  8051ce:	b8 61 00 00 00       	mov    $0x61,%eax
  8051d3:	eb 05                	jmp    8051da <inet_aton+0x11f>
  8051d5:	b8 41 00 00 00       	mov    $0x41,%eax
  8051da:	29 c1                	sub    %eax,%ecx
  8051dc:	89 c8                	mov    %ecx,%eax
  8051de:	09 d0                	or     %edx,%eax
  8051e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8051e3:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8051e8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8051ec:	0f b6 00             	movzbl (%rax),%eax
  8051ef:	0f be c0             	movsbl %al,%eax
  8051f2:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  8051f5:	e9 52 ff ff ff       	jmpq   80514c <inet_aton+0x91>
    if (c == '.') {
  8051fa:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  8051fe:	75 40                	jne    805240 <inet_aton+0x185>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  805200:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805204:	48 83 c0 0c          	add    $0xc,%rax
  805208:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  80520c:	72 0a                	jb     805218 <inet_aton+0x15d>
        return (0);
  80520e:	b8 00 00 00 00       	mov    $0x0,%eax
  805213:	e9 48 01 00 00       	jmpq   805360 <inet_aton+0x2a5>
      *pp++ = val;
  805218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80521c:	48 8d 50 04          	lea    0x4(%rax),%rdx
  805220:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  805224:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805227:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  805229:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80522e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805232:	0f b6 00             	movzbl (%rax),%eax
  805235:	0f be c0             	movsbl %al,%eax
  805238:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  80523b:	e9 a0 fe ff ff       	jmpq   8050e0 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  805240:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  805241:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805245:	74 3c                	je     805283 <inet_aton+0x1c8>
  805247:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80524a:	3c 1f                	cmp    $0x1f,%al
  80524c:	76 2b                	jbe    805279 <inet_aton+0x1be>
  80524e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805251:	84 c0                	test   %al,%al
  805253:	78 24                	js     805279 <inet_aton+0x1be>
  805255:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  805259:	74 28                	je     805283 <inet_aton+0x1c8>
  80525b:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  80525f:	74 22                	je     805283 <inet_aton+0x1c8>
  805261:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  805265:	74 1c                	je     805283 <inet_aton+0x1c8>
  805267:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80526b:	74 16                	je     805283 <inet_aton+0x1c8>
  80526d:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  805271:	74 10                	je     805283 <inet_aton+0x1c8>
  805273:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  805277:	74 0a                	je     805283 <inet_aton+0x1c8>
    return (0);
  805279:	b8 00 00 00 00       	mov    $0x0,%eax
  80527e:	e9 dd 00 00 00       	jmpq   805360 <inet_aton+0x2a5>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  805283:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805287:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80528b:	48 29 c2             	sub    %rax,%rdx
  80528e:	48 89 d0             	mov    %rdx,%rax
  805291:	48 c1 f8 02          	sar    $0x2,%rax
  805295:	83 c0 01             	add    $0x1,%eax
  805298:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  80529b:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  80529f:	0f 87 98 00 00 00    	ja     80533d <inet_aton+0x282>
  8052a5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8052a8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8052af:	00 
  8052b0:	48 b8 08 5f 80 00 00 	movabs $0x805f08,%rax
  8052b7:	00 00 00 
  8052ba:	48 01 d0             	add    %rdx,%rax
  8052bd:	48 8b 00             	mov    (%rax),%rax
  8052c0:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8052c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8052c7:	e9 94 00 00 00       	jmpq   805360 <inet_aton+0x2a5>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8052cc:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8052d3:	76 0a                	jbe    8052df <inet_aton+0x224>
      return (0);
  8052d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8052da:	e9 81 00 00 00       	jmpq   805360 <inet_aton+0x2a5>
    val |= parts[0] << 24;
  8052df:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8052e2:	c1 e0 18             	shl    $0x18,%eax
  8052e5:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8052e8:	eb 53                	jmp    80533d <inet_aton+0x282>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8052ea:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  8052f1:	76 07                	jbe    8052fa <inet_aton+0x23f>
      return (0);
  8052f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8052f8:	eb 66                	jmp    805360 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8052fa:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8052fd:	c1 e0 18             	shl    $0x18,%eax
  805300:	89 c2                	mov    %eax,%edx
  805302:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  805305:	c1 e0 10             	shl    $0x10,%eax
  805308:	09 d0                	or     %edx,%eax
  80530a:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80530d:	eb 2e                	jmp    80533d <inet_aton+0x282>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80530f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  805316:	76 07                	jbe    80531f <inet_aton+0x264>
      return (0);
  805318:	b8 00 00 00 00       	mov    $0x0,%eax
  80531d:	eb 41                	jmp    805360 <inet_aton+0x2a5>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80531f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805322:	c1 e0 18             	shl    $0x18,%eax
  805325:	89 c2                	mov    %eax,%edx
  805327:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80532a:	c1 e0 10             	shl    $0x10,%eax
  80532d:	09 c2                	or     %eax,%edx
  80532f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  805332:	c1 e0 08             	shl    $0x8,%eax
  805335:	09 d0                	or     %edx,%eax
  805337:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80533a:	eb 01                	jmp    80533d <inet_aton+0x282>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  80533c:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  80533d:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  805342:	74 17                	je     80535b <inet_aton+0x2a0>
    addr->s_addr = htonl(val);
  805344:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805347:	89 c7                	mov    %eax,%edi
  805349:	48 b8 d9 54 80 00 00 	movabs $0x8054d9,%rax
  805350:	00 00 00 
  805353:	ff d0                	callq  *%rax
  805355:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  805359:	89 02                	mov    %eax,(%rdx)
  return (1);
  80535b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  805360:	c9                   	leaveq 
  805361:	c3                   	retq   

0000000000805362 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  805362:	55                   	push   %rbp
  805363:	48 89 e5             	mov    %rsp,%rbp
  805366:	48 83 ec 30          	sub    $0x30,%rsp
  80536a:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80536d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805370:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  805373:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  80537a:	00 00 00 
  80537d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  805381:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  805385:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  805389:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  80538d:	e9 e0 00 00 00       	jmpq   805472 <inet_ntoa+0x110>
    i = 0;
  805392:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  805396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80539a:	0f b6 08             	movzbl (%rax),%ecx
  80539d:	0f b6 d1             	movzbl %cl,%edx
  8053a0:	89 d0                	mov    %edx,%eax
  8053a2:	c1 e0 02             	shl    $0x2,%eax
  8053a5:	01 d0                	add    %edx,%eax
  8053a7:	c1 e0 03             	shl    $0x3,%eax
  8053aa:	01 d0                	add    %edx,%eax
  8053ac:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8053b3:	01 d0                	add    %edx,%eax
  8053b5:	66 c1 e8 08          	shr    $0x8,%ax
  8053b9:	c0 e8 03             	shr    $0x3,%al
  8053bc:	88 45 ed             	mov    %al,-0x13(%rbp)
  8053bf:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8053c3:	89 d0                	mov    %edx,%eax
  8053c5:	c1 e0 02             	shl    $0x2,%eax
  8053c8:	01 d0                	add    %edx,%eax
  8053ca:	01 c0                	add    %eax,%eax
  8053cc:	29 c1                	sub    %eax,%ecx
  8053ce:	89 c8                	mov    %ecx,%eax
  8053d0:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8053d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053d7:	0f b6 00             	movzbl (%rax),%eax
  8053da:	0f b6 d0             	movzbl %al,%edx
  8053dd:	89 d0                	mov    %edx,%eax
  8053df:	c1 e0 02             	shl    $0x2,%eax
  8053e2:	01 d0                	add    %edx,%eax
  8053e4:	c1 e0 03             	shl    $0x3,%eax
  8053e7:	01 d0                	add    %edx,%eax
  8053e9:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8053f0:	01 d0                	add    %edx,%eax
  8053f2:	66 c1 e8 08          	shr    $0x8,%ax
  8053f6:	89 c2                	mov    %eax,%edx
  8053f8:	c0 ea 03             	shr    $0x3,%dl
  8053fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053ff:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  805401:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  805405:	8d 50 01             	lea    0x1(%rax),%edx
  805408:	88 55 ee             	mov    %dl,-0x12(%rbp)
  80540b:	0f b6 c0             	movzbl %al,%eax
  80540e:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  805412:	83 c2 30             	add    $0x30,%edx
  805415:	48 98                	cltq   
  805417:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  80541b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80541f:	0f b6 00             	movzbl (%rax),%eax
  805422:	84 c0                	test   %al,%al
  805424:	0f 85 6c ff ff ff    	jne    805396 <inet_ntoa+0x34>
    while(i--)
  80542a:	eb 1a                	jmp    805446 <inet_ntoa+0xe4>
      *rp++ = inv[i];
  80542c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805430:	48 8d 50 01          	lea    0x1(%rax),%rdx
  805434:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  805438:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  80543c:	48 63 d2             	movslq %edx,%rdx
  80543f:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  805444:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  805446:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80544a:	8d 50 ff             	lea    -0x1(%rax),%edx
  80544d:	88 55 ee             	mov    %dl,-0x12(%rbp)
  805450:	84 c0                	test   %al,%al
  805452:	75 d8                	jne    80542c <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  805454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805458:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80545c:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  805460:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  805463:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  805468:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80546c:	83 c0 01             	add    $0x1,%eax
  80546f:	88 45 ef             	mov    %al,-0x11(%rbp)
  805472:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  805476:	0f 86 16 ff ff ff    	jbe    805392 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  80547c:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  805481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805485:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  805488:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  80548f:	00 00 00 
}
  805492:	c9                   	leaveq 
  805493:	c3                   	retq   

0000000000805494 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  805494:	55                   	push   %rbp
  805495:	48 89 e5             	mov    %rsp,%rbp
  805498:	48 83 ec 04          	sub    $0x4,%rsp
  80549c:	89 f8                	mov    %edi,%eax
  80549e:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8054a2:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8054a6:	c1 e0 08             	shl    $0x8,%eax
  8054a9:	89 c2                	mov    %eax,%edx
  8054ab:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8054af:	66 c1 e8 08          	shr    $0x8,%ax
  8054b3:	09 d0                	or     %edx,%eax
}
  8054b5:	c9                   	leaveq 
  8054b6:	c3                   	retq   

00000000008054b7 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8054b7:	55                   	push   %rbp
  8054b8:	48 89 e5             	mov    %rsp,%rbp
  8054bb:	48 83 ec 08          	sub    $0x8,%rsp
  8054bf:	89 f8                	mov    %edi,%eax
  8054c1:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8054c5:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8054c9:	89 c7                	mov    %eax,%edi
  8054cb:	48 b8 94 54 80 00 00 	movabs $0x805494,%rax
  8054d2:	00 00 00 
  8054d5:	ff d0                	callq  *%rax
}
  8054d7:	c9                   	leaveq 
  8054d8:	c3                   	retq   

00000000008054d9 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8054d9:	55                   	push   %rbp
  8054da:	48 89 e5             	mov    %rsp,%rbp
  8054dd:	48 83 ec 04          	sub    $0x4,%rsp
  8054e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8054e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054e7:	c1 e0 18             	shl    $0x18,%eax
  8054ea:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  8054ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054ef:	25 00 ff 00 00       	and    $0xff00,%eax
  8054f4:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8054f7:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  8054f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054fc:	25 00 00 ff 00       	and    $0xff0000,%eax
  805501:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805505:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  805507:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80550a:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80550d:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80550f:	c9                   	leaveq 
  805510:	c3                   	retq   

0000000000805511 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  805511:	55                   	push   %rbp
  805512:	48 89 e5             	mov    %rsp,%rbp
  805515:	48 83 ec 08          	sub    $0x8,%rsp
  805519:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  80551c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80551f:	89 c7                	mov    %eax,%edi
  805521:	48 b8 d9 54 80 00 00 	movabs $0x8054d9,%rax
  805528:	00 00 00 
  80552b:	ff d0                	callq  *%rax
}
  80552d:	c9                   	leaveq 
  80552e:	c3                   	retq   
