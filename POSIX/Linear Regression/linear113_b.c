#include <stdio.h>
#include <math.h>




int main(int argc, char **argv) {
  int i;
  double m;
  double c;
  double q;
  double w;
  
  if(argc != 3) {
    fprintf(stderr, "You need to specify a slope and intercept\n");
    return 1;
  }

  sscanf(argv[1], "%lf", &m);
  sscanf(argv[2], "%lf", &c);
  printf("q,w\n");
  for(i=0; i<100; i++) {
    q = i;
    w = (m * q) + c;
    printf("%0.2lf,%0.2lf\n", q, w);
  }
  
  return 0;
}

