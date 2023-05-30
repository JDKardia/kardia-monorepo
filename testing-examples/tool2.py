def subtract(x,y):
    """ subtract y from x

    >>> [subtract(n,2) for n in range(6)]
    [-2, -1, 0, 1, 2, 3]
    >>> subtract(-1,-1)
    0
    >>> subtract(-1,1)
    -2
    >>> subtract(-5,1)
    -6
    >>> subtract(-5,6)
    -11
    """

    return x - y

if __name__ == "__main__":
    import doctest
    doctest.testmod()
