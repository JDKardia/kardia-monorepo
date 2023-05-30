
def add(x,y):
    """ add two integers together

    >>> [add(n,5) for n in range(6)]
    [5, 6, 7, 8, 9, 10]
    >>> add(-5,1)
    -4
    >>> add(-5,6) # obviously wrong test should fail
    1
    """
    return x + y

def subtract(x,y):
    """ subtract y from x

    >>> [subtract(n,2) for n in range(6)]
    [-2, -1, 0, 1, 2, 3]
    >>> subtract(-1,-1)
    0
    >>> subtract(-5,5)
    -10
    >>> subtract('ab','b')
    Traceback (most recent call last):
      File "/usr/lib/python3.9/doctest.py", line 1336, in __run
        exec(compile(example.source, filename, "single",
      File "<doctest __main__.subtract[3]>", line 1, in <module>
        subtract('ab','b')
      File "/home/kardia/MyCode/testing-examples/unit.py", line 26, in subtract
        return x - y
    TypeError: unsupported operand type(s) for -: 'str' and 'str'
    """
    return x - y

def smoketest():
    """ smoketest the functions of this file

    >>> smoketest()
    """
    add(1,2)
    subtract(2,3)

if __name__ == "__main__":
    import doctest
    doctest.testmod()
