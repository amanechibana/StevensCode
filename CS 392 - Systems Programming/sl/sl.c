/*******************************************************************************
 * Name        : sl.c
 * Author      : Amane Chibana
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <string.h>
#include <limits.h>

int main(int argc, char *argv[])
{
    struct stat fileinfo;
    if (stat(argv[1], &fileinfo) == -1)
    {
        fprintf(stderr, "Permission denied. %s cannot be read.", argv[1]);
        return EXIT_FAILURE;
    }

    if (!S_ISDIR(fileinfo.st_mode))
    {
        fprintf(stderr, "The first argument has to be a directory.");
        return EXIT_FAILURE;
    }

    if (!(fileinfo.st_mode & S_IRGRP))
    {
        fprintf(stderr, "Permission denied. %s cannot be read.", argv[1]);
        return EXIT_FAILURE;
    }

    int pipe1[2];
    int pipe2[2];

    if (pipe(pipe1) == -1 || pipe(pipe2) == -1)
    {
        fprintf(stderr, "Error: pipe() failed. \n");
        return EXIT_FAILURE;
    }

    pid_t pidls = fork();
    if (pidls == -1)
    {
        fprintf(stderr, "Error: fork() failed. \n");
        return EXIT_FAILURE;
    }
    if (pidls == 0)
    {
        dup2(pipe1[1], 1);
        close(pipe1[0]); 
        close(pipe1[1]);
        close(pipe2[0]);
        close(pipe2[1]);
        if (execlp("ls", "ls", "-ai", argv[1], NULL) == -1)
        {
            fprintf(stderr, "Error: ls failed. \n");
            return EXIT_FAILURE;
        }
    }

    pid_t pidsort = fork();
    if (pidsort == -1)
    {
        fprintf(stderr, "Error: fork() failed. \n");
        return EXIT_FAILURE;
    }
    if (pidsort == 0)
    {
        dup2(pipe1[0], 0);
        dup2(pipe2[1], 1);
        close(pipe1[1]); 
        close(pipe1[0]);
        close(pipe2[0]);
        close(pipe2[1]);
        if (execlp("sort", "sort", NULL) == -1)
        {
            fprintf(stderr, "Error: sort failed. \n");
            return EXIT_FAILURE;
        }
    }

    dup2(pipe2[0], 0);
    close(pipe1[0]);
    close(pipe1[1]);
    close(pipe2[0]);
    close(pipe2[1]);

    if (waitpid(pidls, NULL, 0) == -1)
    {
        fprintf(stderr, "Error: wait() failed. \n");
        return EXIT_FAILURE;
    }

    if (waitpid(pidsort, NULL, 0) == -1)
    {
        fprintf(stderr, "Error: wait() failed. \n");
        return EXIT_FAILURE;
    }



    char line[PATH_MAX];
    int linecount;

    while (fgets(line, PATH_MAX, stdin))
    {
        printf("%s", line);
        linecount++;
    }

    printf("Total files: %d\n", linecount);

    close(pipe2[0]);

    return EXIT_SUCCESS;
}