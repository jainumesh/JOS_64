

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

