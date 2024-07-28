############################################################
# Name: Amane Chibana 
# Pledge: I pledge my honor that I have abided by the Stevens Honor System.
# CS115 Lab 1
#
############################################################

def same(word):
    """
    The following function takes the word and compares the first letter(by the index 0) and the last letter(with the index -1)
    To make sure case sensitivity does not interfere it lowered-cased each letter getting compared by adding .lower()
    if the two letters are the same the function returns true and returns false if they are not the same
    """
    if word[0].lower() == word[-1].lower():
        return True
    else:
        return False 

def consecutiveSum(x, y):
    """
    the function takes variables x and y and calculates the consecutive sum equation and the result is returned
    """
    return ((x+y)/2)*(y-x-1)
    


