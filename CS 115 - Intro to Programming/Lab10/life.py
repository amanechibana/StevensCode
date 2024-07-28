#
# life.py - Game of Life lab
#
# Name: Amane Chibana
# Pledge: I pledge my honor that I have abided by the Stevens Honor System.
#

import random
import sys 
from functools import reduce

def createOneRow(width):
    """Returns one row of zeros of width "width"...  
       You should use this in your
       createBoard(width, height) function."""
    row = []
    for col in range(width):
        row += [0]
    return row

def createBoard(width,height):
    """Returns a board of zeros with 'width' width and 'height' height"""
    A = []
    for row in range(height): 
        A += [createOneRow(width)]
    return A

def printBoard( A ): 
    """ this function prints the 2d list-of-lists 
        A without spaces (using sys.stdout.write) 
    """ 
    for row in A: 
        for col in row: 
            sys.stdout.write( str(col) ) 
        sys.stdout.write( '\n' ) 

def diagonalize(width,height): 
    """ creates an empty board and then modifies it 
        so that it has a diagonal strip of "on" cells. 
    """ 
    A = createBoard(width, height) 
     
    for row in range(height): 
        for col in range(width): 
            if row == col: 
                A[row][col] = 1 
            else: 
                A[row][col] = 0      
    return A 

def innerCells(w,h):
    """creates new board that has zeros on the edge and returns the new board"""
    A = createBoard(w,h)

    for row in range(1,h-1):
        for col in range(1,w-1):
            if col !=1 or col != w-1:
                A[row][col] = 1
            else:
                A[row][col] = 0
    return A 

def randomCells(w,h):
    """creates and returns new board that has all random 0 or 1's with w width and h height"""
    A = createBoard(w,h)
    
    for row in range(1,h-1):
        for col in range(1,w-1):
            A[row][col] = random.choice([0,1])
    return A

def copy(A):
    """creates new board that is identical to input A and returns"""
    w = len(A[0])
    h = len(A)
    B = createBoard(w,h)

    for row in range(h):
        for col in range(w):
            B[row][col] = A[row][col]
    return B

def innerReverse(A):
    """creates new board that has zeros on the edge with numbers that are reversed compared to input A on the inside"""
    w = len(A[0])
    h = len(A)
    B = createBoard(w,h)

    for row in range(1,h-1):
        for col in range(1,w-1):
            if col !=1 or col != w-1:
                B[row][col] = 1-A[row][col]
            else:
                B[row][col] = 0
    return B

def countNeighbors(row,col,A):
    """takes location of cell and board. calculates and returns the number of neighbors surronding the cell"""
    return reduce(lambda a,b: a+b,A[row-1][col-1:col+2] + A[row+1][col-1:col+2] + A[row][col-1:col+2:2])

def next_life_generation(A):
    """ makes a copy of A and then advanced one 
        generation of Conway's game of life within 
        the *inner cells* of that copy. 
        The outer edge always stays 0. 
    """

    newA = copy(A)
    w = len(newA[0])
    h = len(newA)
   
    for row in range(1,h-1):
        for col in range(1,w-1):
            if countNeighbors(row,col,A)<2 or countNeighbors(row,col,A)>3:
                newA[row][col] = 0
            elif countNeighbors(row,col,A) == 3 and not(A[row][col]):
                newA[row][col] = 1
    return newA