/*******************************************************************************
 * Name        : server.c
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

typedef struct
{
    char prompt[1024];
    char options[3][50];
    int answer_idx;
} Entry;

typedef struct
{
    int fd;
    int score;
    char name[128];
} Player;

void usage(char *arg)
{
    printf("Usage: %s [-f question_file] [-i IP_address] [-p port_number] [-h]\n\n", arg);
    printf("-f question_file     Default to \"questions.txt\";\n"
           "-i IP_address        Default to \"127.0.0.1\";\n"
           "-p port_number       Default to 25555;\n"
           "-h                   Display this help info.\n");
}

int read_questions(Entry *arr, char *filename)
{
    FILE *stream;
    char *line = NULL;
    size_t len = 0;
    ssize_t nread = 0;
    int i = 0;
    char buffer[1024];

    if ((stream = fopen(filename, "r")) == NULL)
    {
        fprintf(stderr, "Error in opening file!\n");
        exit(EXIT_FAILURE);
    }

    while ((nread = getline(&line, &len, stream)) != -1)
    {
        if (!strcmp(line, "\n") || !strcmp(line, "\r\n"))
        {
            continue;
        }

        Entry newEntry;
        strcpy(newEntry.prompt, line);

        if ((getline(&line, &len, stream)) != -1)
        {
            char *token = strtok(line, " ");
            for (int j = 0; j < 3; j++)
            {
                strcpy(buffer, token);
                if (buffer[strlen(buffer) - 1] == '\n')
                {
                    buffer[strlen(buffer) - 1] = 0;
                }
                strcpy(newEntry.options[j], buffer);
                token = strtok(NULL, " ");
            }
        }

        if ((getline(&line, &len, stream)) != -1)
        {
            for (int j = 0; j < 3; j++)
            {
                strcpy(buffer, line);
                if (buffer[strlen(buffer) - 1] == '\n')
                {
                    buffer[strlen(buffer) - 1] = 0;
                }

                if (!strcmp(newEntry.options[j], line) || !strcmp(newEntry.options[j], buffer))
                {
                    newEntry.answer_idx = j;
                    break;
                }
            }
        }

        arr[i++] = newEntry;
    }

    return i;
};

int main(int argc, char *argv[])
{
    int opt;
    extern int opterr;
    opterr = 0;
    char question_file[1024] = "questions.txt";
    char address[1024] = "127.0.0.1";
    int port = 25555;

    while ((opt = getopt(argc, argv, "f:i:p:h")) != -1)
    {
        switch (opt)
        {
        case 'f':
            strcpy(question_file, optarg);
            break;
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

    // begin socket setup / question reading

    int server_fd;
    int client_fd;
    struct sockaddr_in server_addr;
    struct sockaddr_in in_addr;
    socklen_t addr_size = sizeof(in_addr);

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    server_addr.sin_addr.s_addr = inet_addr(address);

    int i =
        bind(server_fd,
             (struct sockaddr *)&server_addr,
             sizeof(server_addr));

    if (i < 0)
    {
        perror("Could not bind file descriptor with address");
        exit(1);
    }

// step 3: Listen to 2-3 connections
#define MAX_CONN 3
    if (listen(server_fd, MAX_CONN) == 0)
        printf("Welcome to 392 Trivia!\n");
    else
        perror("listen");

    // read questions

    Entry questions[50];
    int qnum = read_questions(questions, question_file);

    // step 4:

    fd_set myset;
    FD_SET(server_fd, &myset);
    int max_fd = server_fd;
    int n_conn = 0;
    int names = 0;
    Player players[MAX_CONN];
    for (int i = 0; i < MAX_CONN; i++)
    {
        Player newPlayer;
        newPlayer.fd = -1;
        newPlayer.score = 0;
        players[i] = newPlayer;
    }

    int recvbytes = 0;
    char buffer[1024];

    while (1)
    {
        FD_SET(server_fd, &myset);
        max_fd = server_fd;
        for (int i = 0; i < MAX_CONN; i++)
        {
            if (players[i].fd != -1)
            {
                FD_SET(players[i].fd, &myset);
                if (players[i].fd > max_fd)
                    max_fd = players[i].fd;
            }
        }

        select(max_fd + 1, &myset, NULL, NULL, NULL);

        if (FD_ISSET(server_fd, &myset))
        {
            client_fd = accept(server_fd,
                               (struct sockaddr *)&in_addr,
                               &addr_size);
            if (n_conn < MAX_CONN)
            {
                printf("New connection detected!\n");

                char *playerReq = "Please type your name: ";
                send(client_fd, playerReq, strlen(playerReq), 0);

                n_conn++;

                for (int i = 0; i < MAX_CONN; i++)
                {
                    if (players[i].fd == -1)
                    {
                        players[i].fd = client_fd;
                        break;
                    }
                }
            }
            else
            {
                printf("Max connection reached!\n");
                close(client_fd);
            }
        }

        int gamestart = 0;

        for (int i = 0; i < n_conn; i++)
        {
            if (players[i].fd != -1 && FD_ISSET(players[i].fd, &myset))
            {
                recvbytes = recv(players[i].fd, buffer, sizeof(buffer) - 1, 0);
                if (recvbytes == 0)
                {
                    printf("Lost connection!\n");
                    close(players[i].fd);
                    players[i].fd = -1;
                    n_conn--;
                    if(players[i].name[0] !='\0'){
                        names--;
                    }
                    strcpy(players[i].name,"");
                }
                else
                {
                    buffer[recvbytes] = '\0';
                    strcpy(players[i].name, buffer);
                    if (printf("Hi %s!\n", players[i].name) > 0)
                    {
                        names++;
                    }

                    if (n_conn == MAX_CONN && names == MAX_CONN)
                    {
                        char *startMsg = "The game starts now!\n";
                        for (int j = 0; j < MAX_CONN; j++)
                        {
                            write(players[j].fd, startMsg, strlen(startMsg));
                        }
                        gamestart = 1;
                    }
                }
            }
        }
        if (gamestart == 1)
        {
            break;
        }
    }

    char buffer2[4096];

    for (int i = 0; i < qnum; i++)
    {
        printf("Score:\n");
        for (int j = 0; j < MAX_CONN; j++)
        {
            printf("%s:%d ", players[j].name, players[j].score);
        }
        printf("\n");
        fflush(stdout);

        // re-initialization
        FD_SET(server_fd, &myset);
        max_fd = server_fd;
        for (int j = 0; j < MAX_CONN; j++)
        {
            if (players[j].fd != -1)
            {
                FD_SET(players[j].fd, &myset);
                if (players[j].fd > max_fd)
                    max_fd = players[j].fd;
            }
        }

        sprintf(buffer2, "Question %d : %sPress 1: %s\nPress 2: %s\nPress 3: %s\n", i + 1, questions[i].prompt, questions[i].options[0], questions[i].options[1], questions[i].options[2]);
        for (int j = 0; j < n_conn; j++)
        {
            if (players[j].fd != 0)
            {
                send(players[j].fd, buffer2, strlen(buffer2), 0);
            }
        }

        select(max_fd + 1, &myset, NULL, NULL, NULL);

        for (int j = 0; j < n_conn; j++)
        {
            if (players[j].fd != -1 && FD_ISSET(players[j].fd, &myset))
            {
                recvbytes = recv(players[j].fd, buffer, sizeof(buffer) - 1, 0);
                if (recvbytes == 0)
                {
                    printf("Lost connection! Closing Game!\n");
                    for (int i = 0; i < MAX_CONN; i++)
                    {
                        if (players[i].fd != 0)
                        {
                            close(players[i].fd);
                        }
                    }

                    close(server_fd);
                    return 0;
                }
                else
                {
                    if (atoi(buffer) == questions[i].answer_idx + 1)
                    {
                        players[j].score++;
                    }
                    else
                    {
                        players[j].score--;
                    }
                    break;
                }
            }
        }

        sprintf(buffer2, "The correct answer was: %s\n\n", questions[i].options[questions[i].answer_idx]);
        for (int j = 0; j < n_conn; j++)
        {
            if (players[j].fd != 0)
            {
                send(players[j].fd, buffer2, strlen(buffer2), 0);
            }
        }
    }
    int winnermax = -10000;

    printf("Final Score:\n");
        for (int j = 0; j < MAX_CONN; j++)
        {
            printf("%s:%d ", players[j].name, players[j].score);
        }
        printf("\n");
        fflush(stdout);

    for (int i = 0; i < MAX_CONN; i++)
    {
        if (players[i].score >= winnermax)
        {
            winnermax = players[i].score;
        }
    }

    for (int i = 0; i < MAX_CONN; i++)
    {
        if (players[i].score == winnermax)
        {
            printf("Congrats %s!\n", players[i].name);
        }
    }

    for (int i = 0; i < MAX_CONN; i++)
    {
        if (players[i].fd != 0)
        {
            close(players[i].fd);
        }
    }

    close(server_fd);

    return 0;
}