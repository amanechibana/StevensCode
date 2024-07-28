/*******************************************************************************
 * Name        : pfind.c
 * Author      : Amane Chibana
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char perms[10];

int permissioncheck(struct stat fileinfo)
{
    char permsoffile[10];
    permsoffile[9] = 0;

    for (int i = 0; i < 9; i++)
    {
        permsoffile[i] = '-';
        switch (i)
        {
        case 0:
            if (S_IRUSR & fileinfo.st_mode)
            {
                permsoffile[i] = 'r';
            }
            break;
        case 1:
            if (S_IWUSR & fileinfo.st_mode)
            {
                permsoffile[i] = 'w';
            }
            break;
        case 2:
            if (S_IXUSR & fileinfo.st_mode)
            {
                permsoffile[i] = 'x';
            }
            break;
        case 3:
            if (S_IRGRP & fileinfo.st_mode)
            {
                permsoffile[i] = 'r';
            }
            break;
        case 4:
            if (S_IWGRP & fileinfo.st_mode)
            {
                permsoffile[i] = 'w';
            }
            break;
        case 5:
            if (S_IXGRP & fileinfo.st_mode)
            {
                permsoffile[i] = 'x';
            }
            break;
        case 6:
            if (S_IROTH & fileinfo.st_mode)
            {
                permsoffile[i] = 'r';
            }
            break;
        case 7:
            if (S_IWOTH & fileinfo.st_mode)
            {
                permsoffile[i] = 'w';
            }
            break;
        case 8:
            if (S_IXOTH & fileinfo.st_mode)
            {
                permsoffile[i] = 'x';
            }
            break;
        }
    }

    return strcmp(perms, permsoffile);
}

int direcexpl(char *path)
{
    DIR *dp = opendir(path);
    struct dirent *dirp;
    struct stat fileinfo;

    if (dp == NULL)
    {
        fprintf(stderr, "Cannot open %s\n", path);
        return EXIT_FAILURE;
    }

    while ((dirp = readdir(dp)) != NULL)
    {
        if (!(strcmp(dirp->d_name, ".")) || !(strcmp(dirp->d_name, "..")))
        {
            continue;
        }
        char filepath[PATH_MAX];    
        (!(strcmp("/", path + strlen(path) - 1))) ? sprintf(filepath, "%s%s", path, dirp->d_name) : sprintf(filepath, "%s/%s", path, dirp->d_name);

        int status = stat(filepath, &fileinfo);

        if (S_ISREG(fileinfo.st_mode) && !(permissioncheck(fileinfo)))
        {
            printf("%s\n", filepath);
        }

        if (S_ISDIR(fileinfo.st_mode))
        {
            direcexpl(filepath);
        }
    }
    closedir(dp);
    return 0;
}

int main(int argc, char *argv[])
{
    if (strlen(argv[2]) != 9)
    {
        fprintf(stderr, "Error: Permissions string '%s' is invalid.\n", argv[2]);
        return EXIT_FAILURE;
    }

    for (int i = 0; i < 9; i++)
    {
        if (argv[2][i] == '-')
        {
            continue;
        }
        if (i % 3 == 0 && argv[2][i] != 'r')
        {
            fprintf(stderr, "Error: Permissions string '%s' is invalid.\n", argv[2]);
            return EXIT_FAILURE;
        }
        if (i % 3 == 1 && argv[2][i] != 'w')
        {
            fprintf(stderr, "Error: Permissions string '%s' is invalid.\n", argv[2]);
            return EXIT_FAILURE;
        }
        if (i % 3 == 2 && argv[2][i] != 'x')
        {
            fprintf(stderr, "Error: Permissions string '%s' is invalid.\n", argv[2]);
            return EXIT_FAILURE;
        }
    }
    strcpy(perms, argv[2]);
    direcexpl(argv[1]);

    return 0;
}
