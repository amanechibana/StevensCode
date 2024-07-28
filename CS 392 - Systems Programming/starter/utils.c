/*******************************************************************************
 * Name        : utils.c
 * Author      : Amane Chibana 
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System. 
 ******************************************************************************/
#include "utils.h"

int cmpr_int(void* a, void* b){
    int x = *(int*)a;
    int y = *(int*)b;
    if (x == y){
        return 0;
    }
    return (x > y) ? 1 : -1; 
}

int cmpr_float(void* a, void* b){
    float x = *(float*)a;
    float y = *(float*)b;
    if (x == y){
        return 0;
    }
    return (x > y) ? 1 : -1; 
}

void print_int(void* a){
    int x = *(int*)a;
    printf("%d ", x);
}

void print_float(void* a){
    float x = *(float*)a;
    printf("%f ", x);
}