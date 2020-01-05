#include <stdio.h>
#include <cuda_runtime_api.h>
#include <time.h>
/****************************************************************************
  This program gives an example of a poor way to implement a password cracker
  in CUDA C. It is poor because it acheives this with just one thread, which
  is obviously not good given the scale of parallelism available to CUDA
  programs.
  
  The intentions of this program are:
    1) Demonstrate the use of __device__ and __global__ functions
    2) Enable a simulation of password cracking in the absence of library 
       with equivalent functionality to libcrypt. The password to be found
       is hardcoded into a function called is_a_match.   

  Compile with:
    nvcc -o password2cuda password2cuda.cu
  
  Run with:

    ./password2cuda
   
  Dr Kevan Buckley, University of Wolverhampton, 2018
*****************************************************************************/

/****************************************************************************
  This function returns 1 if the attempt at cracking the password is 
  identical to the plain text password string stored in the program. 
  Otherwise,it returns 0.
*****************************************************************************/


//declares device function which is called and execued on device
// is_a_match function has four attempt variables and plain passwords arrays. The function matches the password with attempts by running in while loop 
__device__ int is_a_match(char *attempt) {
	char plain_password1[] = "DV75";
	char plain_password2[] = "ET51";
	char plain_password3[] = "SD87";
	char plain_password4[] = "HR78";


	char *a = attempt;
	char *b = attempt;
	char *c = attempt;
	char *d = attempt;
	char *p1 = plain_password1;
	char *p2 = plain_password2;
	char *p3 = plain_password3;
	char *p4 = plain_password4;

	while(*a == *p1) { 
		if(*a == '\0') 
		{
			printf("Password: %s\n",plain_password1);
			break;
		}

		a++;
		p1++;
	}
	
	while(*b == *p2) { 
		if(*b == '\0') 
		{
			printf("Password: %s\n",plain_password2);
			break;
		}

		b++;
		p2++;
	}

	while(*c == *p3) { 
		if(*c == '\0') 
		{
			printf("Password: %s\n",plain_password3);
			break;
		}

		c++;
		p3++;
	}

	while(*d == *p4) { 
		if(*d == '\0') 
		{
			printf("Password: %s\n",plain_password4);
			return 1;
		}

		d++;
		p4++;
	}
	return 0;

}

//__global__ declares kernel which is called on host and executed on device
__global__ void  kernel() {
	char i1,i2,i3,i4;

	char password[7];
	password[6] = '\0';

	int i = blockIdx.x+65; //bloclkIdx is similar to thread index while it refers to the number associated with the block. 
	
int j = threadIdx.x+65;//number associated with each thread within the block
	char firstMatch = i; 
	char secondMatch = j; 

	password[0] = firstMatch;
	password[1] = secondMatch;
	for(i1='0'; i1<='9'; i1++){
		for(i2='0'; i2<='9'; i2++){
			for(i3='0'; i3<='9'; i3++){
				for(i4='0'; i4<='9'; i4++){
					password[2] = i1;
					password[3] = i2;
					password[4] = i3;
					password[5] = i4; 
					if(is_a_match(password)) {
					} 
					else {
	     			//printf("tried: %s\n", password);		  
					}
				}
			}
		}
	}
}


int time_difference(struct timespec *start, 
	struct timespec *finish, 
	long long int *difference) {
	long long int ds =  finish->tv_sec - start->tv_sec; 
	long long int dn =  finish->tv_nsec - start->tv_nsec; 
	if(dn < 0 ) {
		ds--;
		dn += 1000000000; 
	} 
	*difference = ds * 1000000000 + dn;
	return !(*difference > 0);
}


int main() {

	struct  timespec start, finish;
	long long int time_elapsed;
	clock_gettime(CLOCK_MONOTONIC, &start);

	kernel <<<26,26>>>();// The kernel function is invoked.The function will execute on device but is invoked from the host.The next part indicates that we want to execute the kernel with 26 thread block consisting of 26 thread. 
	cudaThreadSynchronize();
//This function returns an error if one of the preceding tasks has failed. 

	clock_gettime(CLOCK_MONOTONIC, &finish);
	time_difference(&start, &finish, &time_elapsed);
	printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed, (time_elapsed/1.0e9)); 

	return 0;
}


