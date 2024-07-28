/*******************************************************************************
 * Name        : bstree.c
 * Author      : Amane Chibana
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System. 
 ******************************************************************************/
#include "bstree.h"

void add_node(void* add, size_t num, tree_t* tree, int (*compare)(void*,void*)){
    struct node* newNode = (struct node*)malloc(sizeof(struct node*));
    newNode->left = NULL;
    newNode->right = NULL;
    
    newNode->data = malloc(num);

    for(size_t i = 0; i < num; i++){
        *(char*)(newNode->data + i) = *(char*)(add + i);
    }    

    struct node* curr = tree->root; 

    while(tree->root != NULL){
        int test = compare(newNode->data,curr->data);
        if(test == 1 || test == 0){
            if(curr->right == NULL){
                curr->right = newNode;
                break;
            }
            curr = curr->right;
        } else{
            if(curr->left == NULL){
                curr->left = newNode;
                break;
            }
            curr = curr->left;
        }
    }

    if(tree->root == NULL){
        tree->root = newNode; 
    }
}

void print_tree(node_t* node, void (*printNode)(void*)){
    if(node == NULL){
        return;
    }

    print_tree(node->left, printNode);
    printNode(node->data);
    print_tree(node->right,printNode);
}

void destroy(tree_t* tree){
    destroyHelp(tree->root);
    tree->root = NULL;
}

void destroyHelp(node_t* node){
    if(node == NULL){
        return;
    }
    destroyHelp(node->left);
    destroyHelp(node->right);
    free(node->data);
    node->data = NULL;
    free(node);
    node = NULL;
}