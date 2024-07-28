def prime(n):
    """
    Input: Takes an integer n
    Output: True if the number n is prime, False otherwise
    """
    possibleDivisors = range(2,n)
    divisors = filter(lambda x: n % x == 0, possibleDivisors)
    return len(list(divisors)) == 0
    print(list(divisors)) 

print("Is 13 prime?: ", prime(13))
print("Is 10 prime?: ", prime(10))
