#include <inc/lib.h>

void
usage(void)
{
	cprintf("usage: lsfd [-1]\n");
	exit();
}

void
umain(int argc, char **argv)
{
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;
	fprintf(1,"Entering lsfd\n");

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
		if (i == '1')
			usefprint = 1;
		else
			usage();
	fprintf(1,"Middle 1 lsfd\n");
	for (i = 0; i < 32; i++){
		fprintf(1,"fstat umain returning with i = [%d]",i);
		if (fstat(i, &st) >= 0) {
			fprintf(1,"fstat umain2  returning with i = [%d]",i);
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
	}
		fprintf(1,"Exiting lsfd i = [%d]\n",i);
}
