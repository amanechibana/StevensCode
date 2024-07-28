/*******************************************************************************
 * Name        : client.c
 * Author      : Amane Chibana
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <arpa/inet.h>

void usage(char *arg)
{
    printf("Usage: %s [-i IP_address] [-p port_number] [-h]\n\n", arg);
    printf("-i IP_address        Default to \"127.0.0.1\";\n"
           "-p port_number       Default to 25555;\n"
           "-h                   Display this help info.\n");
}

void parse_connect(int argc, char **argv, int *server_fd)
{
    int opt;
    extern int opterr;
    opterr = 0;
    char address[1024] = "127.0.0.1";
    int port = 25555;

    while ((opt = getopt(argc, argv, "f:i:p:h")) != -1)
    {
        switch (opt)
        {
        case 'i':
            strcpy(address, optarg);
            break;
        case 'p':
            port = atoi(optarg);
            break;
        case 'h':
            usage(argv[0]);
            exit(EXIT_SUCCESS);
        case '?':
            fprintf(stderr, "Error: Unknown option \'-<%c>\' recieved.\n", optopt);
            exit(EXIT_FAILURE);
        }
    }

    struct sockaddr_in server_addr;
    socklen_t addr_size = sizeof(server_addr);

    *server_fd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    server_addr.sin_addr.s_addr = inet_addr(address);

    connect(*server_fd,
            (struct sockaddr *)&server_addr,
            addr_size);
}

int main(int argc, char *argv[])
{
    int server_fd;
    parse_connect(argc, argv, &server_fd);
    int max_fd = server_fd;

    fd_set myset;
    FD_SET(server_fd, &myset);

    char buffer[1024];

    while (1)
    {

        FD_SET(server_fd, &myset);
        FD_SET(STDIN_FILENO, &myset);
        max_fd = server_fd;

        select(max_fd + 1, &myset, NULL, NULL, NULL);

        if (FD_ISSET(server_fd, &myset))
        {
            int recvbytes = recv(server_fd, buffer, 1024, 0);
            if (recvbytes == 0) break;
            else
            {
                buffer[recvbytes] = 0;
                printf("[Server]: %s", buffer);
                fflush(stdout);
            }
        }

        if (FD_ISSET(STDIN_FILENO, &myset))
        {
            fflush(stdout);
            scanf("%s", buffer);
            send(server_fd, buffer, strlen(buffer), 0);
        }
    }

    close(server_fd);
}