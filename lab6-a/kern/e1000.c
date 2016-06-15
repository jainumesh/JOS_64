#if 1

#include <kern/e1000.h>
#include <kern/pci.h>
#include <kern/pmap.h>
#include <inc/string.h>
#include <netif/etharp.h>

#define debug 1
// LAB 6: Your driver code here

struct tx_desc txDescArr[NUM_TX_DESC] __attribute__ ((aligned (PGSIZE)))  =  {{0, 0, 0, 0, 0, 0, 0}};
struct rx_desc rxDescArr[NUM_RX_DESC] __attribute__ ((aligned (PGSIZE)))  =  {{0, 0, 0, 0, 0, 0}};

int tx_desc_head = 0;
int tx_desc_tail = 0;
int rx_desc_head = 0;
int rx_desc_tail = 0;
volatile uint32_t *map_region;
char arr[10] = "hello";

#if 0
struct tx_desc
{
	uint64_t addr;
	uint16_t length;
	uint8_t cso;
	uint8_t cmd;
	uint8_t status;
	uint8_t css;
	uint16_t special;
};
#endif

void initializeTxDescriptors(){
    int i;
    struct PageInfo* page;
    for (i = 0; i < NUM_TX_DESC; i++){
        page = page_alloc(1);
        txDescArr[i].addr = page2pa(page);
        txDescArr[i].cmd = 0x09;
        txDescArr[i].length = E1000_TXD_BUFFER_LENGTH;
        txDescArr[i].status = 0x1;
    }
}

#if 0
struct rx_desc
{
	uint64_t addr;
	uint16_t length;
	uint16_t chcksum;
	uint8_t status;
	uint8_t errors;
	uint16_t special;
};
#endif

void initializeRxDescriptors(){
    int i;
    struct PageInfo* page;
    for (i = 0; i < NUM_RX_DESC; i++){
        page = page_alloc(1);
        rxDescArr[i].addr = page2pa(page);
		//no cmd to give
		//length will get set by hardware based on incoming packet size
		//status set deafult as 0 so no need to update here
    }
}

int pci_transmit_packet(const void * src,size_t n){ //Need to check for more parameters
    void * va;

	if (debug)
	{
		cprintf("Inside pci_transmit_packet\n");
		cprintf("String %s size %d\n",src, n);
	}

	if(n > E1000_TXD_BUFFER_LENGTH){
        cprintf("This should not fail\n");
        return -1;
    }

	/*check if free descriptors are available*/
    if(!(txDescArr[tx_desc_tail].status & 0x1)){
		if (debug)
	        cprintf("Tx Desc is not free [%d] and [%d]\n",txDescArr[tx_desc_tail].status, tx_desc_tail);
        return -1;
    }

    va = page2kva(pa2page(txDescArr[tx_desc_tail].addr));
    memmove(va, src, n);

	//set packet length
	txDescArr[tx_desc_tail].length = n;
	//txDescArr[tx_desc_tail].length = n+14;  //taking ethernet header in consideration 
											  //but script is failing with this
	//Reset the status as not free
	txDescArr[tx_desc_tail].status = 0x0;											  

	//Update the tail pointer
	tx_desc_tail = (tx_desc_tail + 1) % NUM_TX_DESC;
	map_region[0x3818 >> 2] = tx_desc_tail;	
	
    cprintf("sending packet\n");
    return 0;
}

int pci_receive_packet(void * dst){ //Need to check for more parameters
    const void * va;
	int n = 0;
	if (debug)
		cprintf("Inside pci_receive_packet\n");
	rx_desc_tail = (rx_desc_tail + 1) % NUM_RX_DESC;

	/*check if descriptors has been filled*/
    if(!(rxDescArr[rx_desc_tail].status & 0x1)){
		if (debug)
	        cprintf("Rx packet is not available yet [%d] and [%d]\n",rxDescArr[rx_desc_tail].status, rx_desc_tail);
		
			rx_desc_tail = map_region[0x2818 >> 2]; 
        return -1;
    }
	
	n = rxDescArr[rx_desc_tail].length;

    va = page2kva(pa2page(rxDescArr[rx_desc_tail].addr));
    memmove(dst, va, n);

	//Reset the status as free descriptor
	rxDescArr[rx_desc_tail].status &= ~0x03;
	
	//rx_desc_tail = (rx_desc_tail + 1) % NUM_RX_DESC;

	//Update the tail pointer
	map_region[0x2818 >> 2] = rx_desc_tail;	
	
    cprintf("receiving packet\n");

	//return length of packet
    return n;
}

int
pci_func_attach_E1000(struct pci_func *f)
{
    pci_func_enable(f);
    map_region = (uint32_t *)mmio_map_region(f->reg_base[0] ,(size_t)f->reg_size[0]);
    cprintf("Device status reg is %x\n",map_region[2]);

	/*Sending intialize start*/
	map_region[0x3810 >> 2] = 0x0; //TDH set to 0b
	map_region[0x3818 >> 2] = 0x0; //TDT set to 0b

    map_region[0x400 >> 2] = 0x4008A; //TCTL
    map_region[0x410 >> 2] = 0x60200A; //TIPG  /*binary: 00000000011000000010000000001010*/
    map_region[0x3800 >> 2] = PADDR(txDescArr); //TDBAL & TDBAH
    map_region[0x3808 >> 2] = NUM_TX_DESC << 4;	//TDLEN set to 1024 = 64*16 = 0x400
    /*Sending intialize end*/

	/*Receiving intialize start*/
	map_region[0x2810 >> 2] = 0x01; //RDH set to 0b
	map_region[0x2818 >> 2] = 0x0; //RDT set to 0b

    map_region[0x100 >> 2] = 0x4018002; //RCTL  /* Binary 00000100 00000001 10000000 00000010 */
    										  /* set bits SECRC/BSIZE/BAM/EN */
    map_region[0x2800 >> 2] = PADDR(rxDescArr); //RDBAL & RDBAH
    map_region[0x2808 >> 2] = NUM_RX_DESC << 4;	//RDLEN set to 1024 = 64*16 = 0x400
    map_region[0x5200 >> 2] = 0x0;	//MTA (Multicast Tablr Array) set to 0 for now

	map_region[0x5400 >> 2] = 0x12005452;
	map_region[0x5404 >> 2] = 0x5634 | 0x80000000;
		
	//Setting mac address    
    //uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56}; //from testoutput.c
	//memmove((void*)&map_region[0x5400 >> 2], mac,  ETHARP_HWADDR_LEN);	//RAL and RAH

	//cprintf("hex 1 %x vs 0x12005452\n",map_region[0x5400]);
	//cprintf("hex 2 %x vs 0x5634\n",map_region[0x5404]);
	/*Receiving intialize end*/

    initializeTxDescriptors();
    initializeRxDescriptors();

    cprintf("Initialized E1000 device\n");
    return 0;
}

#else

#include <kern/e1000.h>

// LAB 6: Your driver code here

volatile uint32_t *net_pci_addr;

// Transmit decriptor array and packet buffer (continuous memory)
struct tx_desc tx_desc_arr[PCI_TXDESC] ;//__attribute__ ((aligned (16)));
struct tx_pkt tx_pkt_buf[PCI_TXDESC];

// Transmit decriptor array and packet buffer (continuous memory)
struct rx_desc rx_desc_arr[PCI_RXDESC] ;//__attribute__ ((aligned (16)));
struct rx_pkt rx_pkt_buf[PCI_RXDESC];


int
pci_func_attach_E1000(struct pci_func *pcif){

	int i = 0;
	// Register the PCI device and enable
	pci_func_enable(pcif);

	// Provide the memory for the PCI device
	net_pci_addr = mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
	// Check to see if the correct value gets printed
	cprintf("NET PCI status: %x\n", net_pci_addr[E1000_STATUS]);

	// Initialize transmit descriptor array and packet buffer (not necessarily needed)
	memset(tx_desc_arr, 0, sizeof(struct tx_desc) * PCI_TXDESC);
	memset(tx_pkt_buf, 0, sizeof(struct tx_pkt) * PCI_TXDESC);
	
	/* Transmit initialization */
	// Transmit descriptor base address registers init
	net_pci_addr[E1000_TDBAL] = PADDR(tx_desc_arr);
	net_pci_addr[E1000_TDBAH] = 0x0;

	// Transmit descriptor length register init
	net_pci_addr[E1000_TDLEN] = sizeof(struct tx_desc) * PCI_TXDESC;

	// Transmit descriptor head and tail registers init
	net_pci_addr[E1000_TDH] = 0x0;
	net_pci_addr[E1000_TDT] = 0x0;

	// Transmit control register init
	// 1st bit
	net_pci_addr[E1000_TCTL] = E1000_TCTL_EN;
	// 2nd bit
	net_pci_addr[E1000_TCTL] |= E1000_TCTL_PSP;
	// TCTL-CT starts from 4th bit and extends to 11th bit
	// clear all those bits and set it to 10h (11:4) (as per manual)
	net_pci_addr[E1000_TCTL] &= ~E1000_TCTL_CT;
	net_pci_addr[E1000_TCTL] |= (0x10) << 4;
	// TCTL-COLD starts from 12the bit and extends to 21st bit
	// clear all those bits and set i to 40h (21:12) (as per manual)
	net_pci_addr[E1000_TCTL] &= ~E1000_TCTL_COLD;
	net_pci_addr[E1000_TCTL] |= (0x40) << 12;

	/* Transmit IPG register init */
	// Set to zero first
	net_pci_addr[E1000_TIPG] = 0x0;
	// IPGT value 10 for IEEE 802.3 standard (as per maunal)
	net_pci_addr[E1000_TIPG] |= 0xA;
	// IPGR1 2/3 the value of IPGR2 as per IEEE 802.3 standard (as per manual)
	// Starts from the 10th bit
	net_pci_addr[E1000_TIPG] |= (0x4) << 10;
	// IPGR2 starts from the 20th bit, value = 6(as per manual)
	net_pci_addr[E1000_TIPG] |= (0x6) << 20; 

	/* Receive Initialization */
	// Program the Receive Address Registers
	net_pci_addr[E1000_RAL] = 0x12005452;
	net_pci_addr[E1000_RAH] = 0x5634 | E1000_RAH_AV; // HArd coded mac address. (needed to specify end of RAH)
	net_pci_addr[E1000_MTA] = 0x0;

	// Program the Receive Descriptor Base Address Registers
	net_pci_addr[E1000_RDBAL] = PADDR(rx_desc_arr);
    net_pci_addr[E1000_RDBAH] = 0x0;

	// Set the Receive Descriptor Length Register
	net_pci_addr[E1000_RDLEN] = sizeof(struct rx_desc) * PCI_RXDESC;

    // Set the Receive Descriptor Head and Tail Registers
	net_pci_addr[E1000_RDH] = 0x0;
	net_pci_addr[E1000_RDT] = 0x0;

	// Initialize the Receive Control Register
	net_pci_addr[E1000_RCTL] |= E1000_RCTL_EN;
	// Bradcast set 1b
	net_pci_addr[E1000_RCTL] |= E1000_RCTL_BAM;
	// CRC strip
	net_pci_addr[E1000_RCTL] |= E1000_RCTL_SECRC;
	// Associate the descriptors with the packets. (one to one mapping)
	for (i = 0; i < PCI_TXDESC; i++) {
		tx_desc_arr[i].addr = PADDR(tx_pkt_buf[i].buf);
		tx_desc_arr[i].status |= E1000_TXD_STAT_DD;
		rx_desc_arr[i].addr = PADDR(rx_pkt_buf[i].buf);
	}

	pci_transmit_packet(NULL, 0);
	return 0;
}


int
pci_transmit_packet(const void *data, size_t len)
{
	cprintf("\n The length in kern space is:%d", len);
	data = "hello world";
	len = strlen(data);
	if (len > TX_PKT_SIZE) {
		return -1;
	}
	// Transmit descriptor tail register. (tdt is an index into the descriptor array)
	uint32_t tail = net_pci_addr[E1000_TDT];

	// Use the DD bit, which is set by the PCI device.
	if (tx_desc_arr[tail].status & E1000_TXD_STAT_DD) {
		memmove(tx_pkt_buf[tail].buf, data, len);
		tx_desc_arr[tail].length = len;
		// Clear the DD bit and set the RS bit for feedback and mark the end of packet (necessary).
		tx_desc_arr[tail].status = 0;
		tx_desc_arr[tail].cmd |=  E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP; //This has to be enabled...for HW to process the packet.
		// circular queue
		net_pci_addr[E1000_TDT] = (tail+1) % PCI_TXDESC;
		return 0;
	}
	else {	
		return -1;
	}
}

int
pci_receive_packet(char *data) {
	uint32_t tail = net_pci_addr[E1000_RDT];
	// if Packet is has DD bit set, then start processing.
	if (rx_desc_arr[tail].status & E1000_RXD_STAT_DD) {
		// For now, no need to process multi frame data.
		if (!(rx_desc_arr[tail].status & E1000_RXD_STAT_EOP)) {
			panic("Don't allow jumbo frames!\n");
		}
		uint32_t len = rx_desc_arr[tail].length;
		memmove(data, rx_pkt_buf[tail].buf, len);
		// Unset the status (just the opposite of Transmit.
		rx_desc_arr[tail].status &= ~E1000_RXD_STAT_DD;
		rx_desc_arr[tail].status &= ~E1000_RXD_STAT_EOP;
		net_pci_addr[E1000_RDT] = (tail + 1) % 64;
		// return the length to say how much data has been transferred.
		return len;
	}
	return -1;
}
#endif
