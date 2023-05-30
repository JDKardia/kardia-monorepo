
def add(x,y):
    """ add two integers together

    >>> [add(n,5) for n in range(6)]
    [5, 6, 7, 8, 9, 10]
    >>> add(-1,-1)
    -2
    >>> add(-1,1)
    0
    >>> add(-5,1)
    -4
    >>> add(-5,6) # obviously wrong test should fail
    0
    """

    return x + y

if __name__ == "__main__":
    import doctest
    doctest.testmod()
