#include "UnrolledLL.h"
/*
Name: Amane Chibana
Pledge: I pledge my honor that I have abided by the Stevens Honor System. 
*/
uNode* new_unode(uNode** prev, u_int64_t blksize) {
	uNode* nnode = (uNode*) malloc(sizeof(uNode*));
	nnode->next = NULL;
	nnode-> blksize = blksize;

	nnode->datagrp = (int*) malloc(sizeof(int) * blksize);

	for (u_int64_t i = 0; i < blksize; i++) {
		nnode->datagrp[i] = rand() % 100;
	}

    if ((*prev) == NULL) *prev = nnode;
    else (*prev)->next = nnode;

	return nnode;
}

void init_ullist(UnrolledLL* ullist, u_int64_t size, u_int64_t blksize) {
	ullist->head = NULL;
	ullist->len = 0;

	uNode* nnode;

	for (u_int64_t i = 0; i < size/blksize; i++) {
		if (i == 0) nnode = new_unode(&(ullist->head),blksize);
		else nnode = new_unode(&nnode,blksize);
		ullist->len++;
	}
}

void iterate_ullist(uNode* uiter) {
	while (uiter != NULL) {
        for (u_int64_t i = 0; i < uiter -> blksize; i++) {
		    int num = uiter->datagrp[i];
	    }
		
		uiter = uiter->next;
	}
}

void clean_uulist(UnrolledLL* ullist) {
    if (ullist != NULL && ullist->head != NULL) {
        uNode* current = ullist->head;
        uNode* next;
 
        while (current != NULL) {
            next = current->next;
            free(current->datagrp);
            free(current);
            current = next;
        }

        ullist->head = NULL;
    }
    return;
}