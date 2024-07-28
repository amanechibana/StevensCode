def factorial(n):
    if n == 1:
        return 1
    else:
        return n*factorial(n-1)
def test_factorial():
    assert factorial(3) == 6
    assert factorial(5) == 119









    
