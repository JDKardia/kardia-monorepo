def hello(name: str = "World") -> None:
    """
    >>> hello()
    Hello World
    >>> hello("joe")
    Hello joe
    """
    print(f"Hello {name}")
