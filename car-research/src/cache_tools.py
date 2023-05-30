import json
import os
from pathlib import Path

def cache_load(path: Path):
    with open(path, "r") as f:
        return json.load(f)


def cache_write(path: Path, blob):
    """
    >>> t1 = [1,2,3]
    >>> t2 = {"hello":"World"}
    >>> c1 = Path("f1.json")
    >>> c2 = Path("f2.json")
    >>> cache_write(c1,test)
    >>> cache_load(c1) == t1
    true
    >>> cache_write(c2,best)
    >>> cache_load(c2) == t2
    true
    """
    with open(path, "w") as f:
        json.dump(blob, f)


def jcache(pathFmt: str):
    def decorating_function(user_func):
        def wrapper(*args):
            name_args = [str(a) for a in args if isinstance(a, str) or isinstance(a,int)]
            path = Path(pathFmt.format(*name_args).replace(" ", "_"))
            os.makedirs(os.path.dirname(path), exist_ok=True)
            if path.exists() and path.is_file():
                result = cache_load(path)
            else:
                print(path)
                result = user_func(*args)
                cache_write(path, result)
            return result

        return wrapper

    return decorating_function


