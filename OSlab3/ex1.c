#include<stdio.h>

int main(int argc , char **argv)
{
	int x =1;
	printf("Hello x = %d\n",x);

	__asm__("mov %1,%0\n\t"
		"add $1,%0"
		: "=r"(x)
		:"r"(x));
	printf("Hello x = %d after increment\n",x);
	
	if(x ==2){
		printf("OK\n");
	}else{
		printf("ERROR\n");
	}
// return 0; // need to check if this is a must in vm's compiler or not.
}


