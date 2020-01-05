#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <crypt.h>
#include <time.h>


int n_passwords = 4;

char *encrypted_passwords[] = {
  "$6$KB$zi3fXMJevNoChNTJt69vjDIda67syVyENwdw6TIEecnk8q.cRot8X.0c17MG/Xl/M8xYJkjVzxoH9y55sVwXq/",
  "$6$KB$1mEnLCYT6mweh/1RJ8B228i/fG4ee1VkVorzrYux4xDwXFxz3Ae5tig5F1uMaekN2HSZfS4bgbBS4.Hta.tjj0",
  "$6$KB$Vq2yxyC0KPJn434zm7/nLwULvz2lqpiKtDa6KfsUmKVEjCLBEChhX5UwBWvbEaLgXfFT2I0GyOmhLqRyEyg180",
  "$6$KB$5EmaeQErXZCaDfHlnvye6o7t26kJGYSqaoi3ALdPJBc5tGTdY7JyPyAFFfhTVptGSikmfP9mt.saZtsjfgXop0"
};


void substr(char *dest, char *src, int start, int length){
  memcpy(dest, src + start, length);
  *(dest + length) = '\0';
}



void crack(char *salt_and_encrypted){
  int x, y, z,q;     
  char salt[7];    
  char plain[7];   
  char *enc;       
  int count = 0;   

  substr(salt, salt_and_encrypted, 0, 6);

  for(x='A'; x<='Z'; x++){
    for(y='A'; y<='Z'; y++){
     for(q='A';q<='Z';q++ ){
      for(z=0; z<=99; z++){
        sprintf(plain, "%c%c%c%02d", x, y, q, z); 
        enc = (char *) crypt(plain, salt);
        count++;
        if(strcmp(salt_and_encrypted, enc) == 0){
          printf("#%-8d%s %s\n", count, plain, enc);
        } else {
          printf(" %-8d%s %s\n", count, plain, enc);
        }
       }
      }
    }
  }
  printf("%d solutions explored\n", count);
}

int time_difference(struct timespec *start, struct timespec *finish, 
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
int i;
  struct timespec start, finish;   
  long long int time_elapsed;

  clock_gettime(CLOCK_MONOTONIC, &start);
 
	for(i=0;i<n_passwords;i<i++) {
    crack(encrypted_passwords[i]);
  }

  clock_gettime(CLOCK_MONOTONIC, &finish);
  time_difference(&start, &finish, &time_elapsed);
  printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed, 
         (time_elapsed/1.0e9)); 

  return 0;
}

