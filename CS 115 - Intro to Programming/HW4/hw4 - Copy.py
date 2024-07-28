'''
Created on October 15, 2022 
@author: Amane Chibana
Pledge: I pledge my honor that I have abided by the Stevens Honor System. 

CS115 - Hw 4
'''

def pascalRowAdd(l):
    '''Takes a pascal row and returns the next row without the first number in the row'''
    if l == []:
        return []
    elif l == [1]:
        return [1]
    else:
        return [l[0]+l[1]]+pascalRowAdd(l[1:])

def pascal_row(n):
    '''Takes integer input n and returns a list that contains integers of the nth row of pascal triangle'''
    if n==0: 
        return [1]
    if n==1:
        return [1,1]
    else:
        pass

def pascal_triangle(n):
    '''Takes integer input n and returns list of rows of pascals triangle up to the row number n'''
    if n == 0:
        return [[1]]
    if n==1:
        return [[1,1]]
    else:
        pascal_triangle(n-1)+[pascal_row(n)]

def test_pascal_row():
    '''Runs test cases for pascal_row function. Returns true or false'''
    assert pascal_row(0) == [1]
    assert pascal_row(1) == [1, 1]
    assert pascal_row(5) == [1, 5, 10, 10, 5, 1]
    
def test_pascal_triangle():
    '''Runs test cases for pascal_triangle function. Returns true or false'''
    assert pascal_triangle(0) == [[1]]
    assert pascal_triangle(1) == [[1], [1, 1]]
    assert pascal_triangle(5) == [[1], [1, 1], [1, 2, 1], [1, 3, 3, 1], [1, 4, 6, 4, 1], [1, 5, 10, 10, 5, 1]]
        


