/*******************************************************************************
 * Name        : minishell.c
 * Author      : Amane Chibana
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/stat.h>
#include <string.h>
#include <errno.h>
#include <pwd.h>
#include <signal.h>
#include <limits.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#define BLUE "\x1b[34;1m"
#define DEFAULT "\x1b[0m"

volatile sig_atomic_t interrupted;

void catch (int sig)
{
    interrupted = sig;
    printf("\n");
}

void installhandler()
{
    struct sigaction setup_action;
    setup_action.sa_handler = catch;
    if (sigaction(SIGINT, &setup_action, NULL) == -1)
    {
        fprintf(stderr, "Error: Cannot register signal handler. %s.\n", strerror(errno));
        exit(EXIT_FAILURE);
    }
}

int parse_input(char *input, char *parout[])
{
    char *token;
    int i = 0;
    token = strtok(input, " ");
    while (token != NULL)
    {
        if (*token != '\0')
        {
            parout[i++] = token;
            token = strtok(NULL, " ");
        }
    }
    parout[i] = NULL;

    return i;
}

typedef struct
{
    char pid[32];
    char user[257];
    char command[257];
} process;

int compare(const void *a, const void *b)
{
    process *procA = *(process **)a;
    process *procB = *(process **)b;
    return (atoi(procA->pid) - atoi(procB->pid));
}

int main()
{
    installhandler();

    char cwd[PATH_MAX];

    while (1)
    {
        if (getcwd(cwd, sizeof(cwd)) != NULL)
        {
            printf("%s[%s]%s> ", BLUE, cwd, DEFAULT);
        }
        else
        {
            fprintf(stderr, "Error: Cannot get current working directory. %s.\n", strerror(errno));
        }

        char userIn[4096];
        if (fgets(userIn, 4096, stdin) == NULL)
        {
            if (interrupted == SIGINT)
            {
                interrupted = 0;
                continue;
            }
            fprintf(stderr, "Error: Failed to read from stdin. %s.\n", strerror(errno));
            continue;
        }

        if(!strcmp(userIn,"\n")){
            continue;
        }

        if (userIn[strlen(userIn) - 1] == '\n')
        {
            userIn[strlen(userIn) - 1] = '\0';
        }

        char *parout[1000];
        int parnum = parse_input(userIn, parout);

        struct passwd *pw = getpwuid(getuid());
        if (pw == NULL)
        {
            fprintf(stderr, "Error: Cannot get passwd entry. %s.\n", strerror(errno));
            continue;
        }

        if ((!strcmp(parout[0], "cd")))
        {
            if (parnum > 2)
            {
                fprintf(stderr, "Error: Too many arguments to cd.\n");
                continue;
            }

            if (parnum == 1 || !(strcmp(parout[1], "~")))
            {
                if (chdir(pw->pw_dir) == -1)
                {
                    fprintf(stderr, "Error: Cannot change directory to %s. %s.\n", pw->pw_dir, strerror(errno));
                }
            }
            else
            {
                char newpath[PATH_MAX];

                if (strchr(parout[1], '~') != NULL)
                {
                    sprintf(newpath, "%s%s", pw->pw_dir, parout[1] + 1);
                }
                else
                {
                    sprintf(newpath, "%s", parout[1]);
                }

                if (chdir(newpath) == -1)
                {
                    fprintf(stderr, "Error: Cannot change directory to %s. %s.\n", parout[1], strerror(errno));
                }
            }
            continue;
        }

        if ((!strcmp(parout[0], "exit")))
        {
            return EXIT_SUCCESS;
        }

        if ((!strcmp(parout[0], "pwd")))
        {
            if (getcwd(cwd, sizeof(cwd)) != NULL)
            {
                printf("%s\n", cwd);
            }
            else
            {
                fprintf(stderr, "Error: Cannot get current working directory. %s.\n", strerror(errno));
            }
            continue;
        }

        if ((!strcmp(parout[0], "lf")))
        {
            DIR *dp = opendir(cwd);
            struct dirent *dirp;

            if (dp == NULL)
            {
                fprintf(stderr, "Cannot open %s\n", cwd);
                continue;
            }

            while ((dirp = readdir(dp)) != NULL)
            {
                if (!(strcmp(dirp->d_name, ".")) || !(strcmp(dirp->d_name, "..")))
                {
                    continue;
                }
                printf("%s\n", dirp->d_name);
            }

            closedir(dp);
            continue;
        }

        if ((!strcmp(parout[0], "lp")))
        {
            process *procs[1024];
            int count = 0;

            DIR *dp = opendir("/proc/");
            struct dirent *dirp;
            struct stat fileinfo;

            if (dp == NULL)
            {
                fprintf(stderr, "Cannot open %s\n", "/proc/");
                continue;
            }

            while ((dirp = readdir(dp)) != NULL)
            {
                if (!(strcmp(dirp->d_name, ".")) || !(strcmp(dirp->d_name, "..")))
                {
                    continue;
                }

                if (atoi(dirp->d_name) == 0)
                {
                    continue;
                }

                procs[count] = (process *)malloc(sizeof(process));
                if (procs[count] == NULL)
                {
                    fprintf(stderr, "Error: malloc() failed. %s.\n", strerror(errno));
                    continue; 
                }
                strcpy(procs[count]->pid, dirp->d_name);

                char filepath[PATH_MAX];
                sprintf(filepath, "%s%s", "/proc/", dirp->d_name);

                struct stat info;
                stat(filepath, &info);
                struct passwd *pw = getpwuid(info.st_uid);

                strcpy(procs[count]->user, getpwuid(info.st_uid)->pw_name);

                sprintf(filepath, "%s%s%s", "/proc/", dirp->d_name, "/cmdline");

                int f = open(filepath, O_RDONLY);
                if (f == -1)
                {
                    count++;
                    strcpy(procs[count]->command, "");
                    continue;
                }

                strcpy(procs[count]->command, "");
                if (read(f, procs[count]->command, 256) == -1)
                {
                    count++;
                    close(f);
                    continue;
                }

                close(f);
                count++;
            }

            closedir(dp);

            qsort(procs, count, sizeof(process *), compare);

            for (int i = 0; i < count; i++)
            {
                printf("%-6s %-10s %-20s\n", procs[i]->pid, procs[i]->user, procs[i]->command);

                free(procs[i]);
            }

            continue;
        }

        pid_t pid = fork();
        if (pid == -1)
        {
            fprintf(stderr, "Error: fork() failed. %s.\n", strerror(errno));
            continue;
        }

        if (pid == 0)
        {
            if (execvp(parout[0], parout) == -1)
            {
                fprintf(stderr, "Error: exec() failed. %s.\n", strerror(errno));
                return EXIT_FAILURE;
            }
        }
        else
        {
            if (waitpid(pid, NULL, 0) == -1)
            {
                if (interrupted == SIGINT)
                {
                    interrupted = 0;
                    continue;
                }
                fprintf(stderr, "Error: wait() failed. %s.\n", strerror(errno));
            }
        }
    }
    return 0;
}