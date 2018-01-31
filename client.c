#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define MAX_BUF 1000

int main(int argc, char* argv[])
{
  int sockd;
  int count;
  struct sockaddr_in serv_name;
  (unsigned char) buf[MAX_BUF];
  int status;

  if (argc < 3)
  {
    fprintf(stderr, "Usage: %s ip_address port_number\n", argv[0]);
    exit(1);
  }
  /* create a socket */
  sockd = socket(AF_INET, SOCK_STREAM, 0);
  if (sockd == -1)
  {
    perror("Socket creation");
    exit(1);
  }

  /* server address */ 
  serv_name.sin_family = AF_INET;
  inet_aton(argv[1], &serv_name.sin_addr);
  serv_name.sin_port = htons(atoi(argv[2]));

  /* connect to the server */
  status = connect(sockd, (struct sockaddr*)&serv_name, sizeof(serv_name));
  if (status == -1)
  {
    perror("Connection error");
    exit(1);
  }
  while (1) {
    count = read(sockd, buf, MAX_BUF);
    for (int i = 0; i < count, i+= 1) {
      printf("Received %d", *buf + i +);
    }
    
    //write(1, buf, count);
  }

  close(sockd);
  return 0;
}