memo = {}

def fastED2(first, second):
    '''Returns the edit distance between the strings first and second. Uses
    memoization to speed up the process.'''
    if (first,second) in memo:
        return memo[(first,second)]
    elif first == '':  
        memo[(first,second)] = len(second)
        return len(second) 
    elif second == '':
        memo[(first,second)] = len(first)
        return len(first) 
    elif first[0] == second[0]:
        memo[(first,second)] = fastED2(first[1:], second[1:]) 
        return fastED2(first[1:], second[1:]) 
    else:
        substitution = 1 + fastED2(first[1:], second[1:]) 
        deletion = 1 + fastED2(first[1:], second) 
        insertion = 1 + fastED2(first, second[1:])
        memo[(first,second)] = min(substitution, deletion, insertion)      
        return min(substitution, deletion, insertion)


def fastED(first, second):
    '''Returns the edit distance between the strings first and second. Uses
    memoization to speed up the process.'''
    if (first,second) in memo:
        return memo[(first,second)]
    elif first == '':  
        return len(second) 
    elif second == '':
        return len(first) 
    elif first[0] == second[0]:
        return fastED(first[1:], second[1:]) 
    else:
        substitution = 1 + fastED(first[1:], second[1:]) 
        deletion = 1 + fastED(first[1:], second) 
        insertion = 1 + fastED(first, second[1:])
        memo[(first,second)] = min(substitution, deletion, insertion)      
        return min(substitution, deletion, insertion) 
