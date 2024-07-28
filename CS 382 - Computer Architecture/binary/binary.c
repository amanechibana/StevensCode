/*******************************************************************************
 * Filename: binary.c
 * Author  : Amane Chibana
 * Version : 1.0
 * Date    : September 12, 2023
 * Description: Displays the binary pattern of any 32 bit integer
 * Pledge  : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void display(int8_t bit)
{
    putchar(bit + 48);
}

void display_32(int32_t num)
{
    for(int i = 31; i>=0;i--){
        display(num>>i & 1);
    }
}

int main(int argc, char const *argv[])
{
    display_32(234509);
    return 0;
}

