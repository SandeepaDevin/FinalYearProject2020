// libraries added to existing RSATx.c file
#include <signal.h>
#include <netinet/in.h>
#include <unistd.h>
#include "socket-tx.h"
#include <time.h>

//socket created
#define INPUT_IP "169.254.55.66"
#define PORT 5050
#define BUFLEN 1624

struct sockaddr_in server,client;
char buffer[BUFLEN];
char buffer1[BUFLEN];

int s= sizeof(server);

//initialize it inside RSATx_open
void open_trans_init(){
  buffer[BUFLEN]='\0';
  buffer1[BUFLEN]='\0';

  if((s=socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP))== -1){
    printf('socket creation failed');
    exit(-1);
  }

  printf("socket opn\n");
  memset((char *) &server, 0, sizeof(server));
  memset((char *) &client, 0, sizeof(client));

  printf('memory cleaned\n');

  server.sin_family= AF_INET;
  server.sin_addr.s_addr=inet_addr('169.254.55.68');
  server.sin_port= htons(PORT);

  printf("port connected\n");

  if(inet_aton(INPUT_IP, &client.sin_addr)==0){
    printf('inet_aton failed\n');
    exit(-1);
  }
  printf('binding success');

  if(bind(s,(const struct sockaddr *)&server, sizeof(server))== -1){
    printf("bind failed");
    exit(-1);
  }
  printf('binding successful\n');
}

void msg_trans_receive(){
  int n; 
  socklen_t len; //size of client

  n=recvfrom(s, (char *)buffer, BUFLEN, 0, (struct sockaddr *)&client, &len);
  buffer[n]='\0';
  printf('client; %s\n',buffer);
}

//initialize the file inside RSATx_close
void close_trans_socket(){
  printf("socket close\n");
  close(s);
}
