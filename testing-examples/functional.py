
a = {'key':'database-entry'}

def thing_1():
    global a
    a['one'] = 'thing1'
    a['two'] = 'thing1'

def thing_2():
    global a
    a['two'] = 'thing2'
    a['one'] = 'thing2'


def do_things_one_way():
    """

    >>> do_things_one_way()
    >>> print(a)
    {'key': 'database-entry', 'one': 'thing2', 'two': 'thing2'}
    """
    thing_1()
    thing_2()

def do_things_another_way():
    """

    >>> do_things_another_way()
    >>> print(a)
    {'key': 'database-entry', 'two': 'thing2', 'one': 'thing1' }
    """
    thing_2()
    thing_1()

if __name__ == "__main__":
    import doctest
    doctest.testmod()
