/*
Author  : Amane Chibana
Pledge  : I pledge my honor that I have abided by the Stevens Honor System.
*/
#include <stdio.h>
void copy_str(char *src, char *dst)
{
    /*copies src into dst*/
    int i = 0;
loop:
    dst[i] = src[i];
    if (src[i] != '\0')
    {
        i++;
        goto loop;
    }
}
int dot_prod(char *vec_a, char *vec_b, int length, int size_elem)
{
    /* calculates the dot product of vec_a and vec_b.
    Uses size_elem to find the proper index of the data where the vec's are pointing to
    loops length times
    */
    int i = 0;
    int num = 0;
loop:
    if (i < length)
    {

        num += (*(int *)(vec_a + i * size_elem)) * (*(int *)(vec_b + i * size_elem));

        i++;
        goto loop;
    }

    return num;
}

void sort_nib(int *arr, int length)
{
    /*places int arr and seperates into nibbles in nibs array.
    Sorts nibs through selection sort
    reorders original array through pointer*/

    // nibs array
    char nibs[8 * length];

    // seperates nibbles from arr and places into nibs through bitwise AND
    for (int i = 0; i < length; i++)
    {
        int curr = arr[i];
        for (int j = 0; j < 8; j++)
        {
            nibs[j + 8 * i] = curr & 0xf;
            curr = curr >> 4;
        }
    }

    // sorts nibs array with selection sort
    for (int i = 0; i < 8 * length; i++)
    {

        char curr = nibs[i];
        int min = i;
        for (int j = i; j < 8 * length; j++)
        {
            if (nibs[j] < nibs[min])
            {
                min = j;
            }
        }
        if (curr != nibs[min])
        {
            char temp = nibs[min];
            nibs[min] = curr;
            nibs[i] = temp;
        }
    }

    // places back into original arr through bitwise OR
    int k = 0;
    for (int i = 0; i < length; i++)
    {
        arr[i] = (nibs[k] << 28);
        k++;
        for (int j = 24; j >= 0; j -= 4)
        {
            arr[i] = arr[i] | (nibs[k] << j);
            k++;
        }
    }
}
int main(int argc, char **argv)
{
    /**
     * Task 1
     */
    char str1[] = "382 is the best!";
    char str2[100] = {0};
    copy_str(str1, str2);
    puts(str1);
    puts(str2);
    /**
     * Task 2
     */
    int vec_a[3] = {12, 34, 10};
    int vec_b[3] = {10, 20, 30};
    int dot = dot_prod((char *)vec_a, (char *)vec_b, 3, sizeof(int));
    printf("%d\n", dot);
    /**
     * Task 3
     */
    int arr[3] = {0x12BFDA09, 0x9089CDBA, 0x56788910};
    sort_nib(arr, 3);
    for (int i = 0; i < 3; i++)
    {
        printf("0x%08x ", arr[i]);
    }
    puts(" ");
    return 0;
}