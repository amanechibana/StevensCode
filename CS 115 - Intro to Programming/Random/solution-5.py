"""
 Name: Amane Chibana 
 Pledge: I pledge my honor that I have abided by the Stevens Honor System. 
 CS115 Lab 2 - Recursion 
"""

def dot(L, K):
    """
    Takes list L and K and returns the dot product of them
    """
    if L==[] or K==[]:
        return 0
    else:
        return L[0]*K[0] + dot(L[1:],K[1:])

def explode(S):
    """
    Takes string S and returns a list of one letter strings. Individual characters. 
    """
    if S=="":
        return []
    else:
        return [S[0]] + explode(S[1:])

def ind(e, L):
    """
    Takes element e and sequence L and returns the index of where the first element e is found or the length of the list if e is not found
    """
    if L == "" or L == []:
        return 0
    elif L[0] == e:
        return 0 
    else:
        return 1 + ind(e, L[1:])

def removeAll(e, L):
    """
    takes element e and list L then removes all elements in list L that are identical to e. Returns the list without the element e. 
    """
    if L == []:
        return [] 
    elif L[0] != e:
        return [L[0]] + removeAll(e, L[1:])
    elif L[0] == e:
        return removeAll(e, L[1:])

def myFilter(f, L):
    """
    takes function f and list L and returns a new list that has elements that returned true for the function f. 
    """
    if L == []:
        return []
    elif f(L[0]) == True:
        return [L[0]] + myFilter(f, L[1:])
    else:
        return myFilter(f, L[1:])

def deepReverse(L):
    """
    takes list L and returns a reversed version of the list. If there are lists inside the list the list inside will be reversed too. 
    """
    if L == []:
        return []
    elif isinstance(L[-1], list):   
        return [deepReverse(L[-1])] + deepReverse(L[:-1])
    else:
        return [L[-1]] + deepReverse(L[:-1])
    

