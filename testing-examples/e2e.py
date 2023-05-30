from tool2 import subtract
from tool1 import add
def end_to_end_test():
    """

    >>> end_to_end_test()
    """
    assert (add(1,subtract(1,2)) == 0)
    assert (add(5,subtract(1,2)) == 4)
    # assert (add('a',subtract('bc','c')) == 'ab')

if __name__ == "__main__":
    import doctest
    doctest.testmod()
