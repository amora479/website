---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# String Processing

Strings are one of the fundamental data types we've seen in Python, and they are absolutely essential for any kind of interactivity.  We've seen one way of printing a string and an int.

```py
print("Your number is " + str(42))
```

However there are a couple of easier ways.  The first is the print function takes multiple arguments.  Each argument will be printed separated by a space.  No need to cast!

```py
print("Your number is", 42)
```

However, that extra space is painful sometimes.  We need a way that allows the same control as the concatenation method.  String interpolation offers just that.

```py
print("Your numbers are {0} and {1}".format(41, 42))
```

The format method for strings allows you to pass in arguments and then reference those in the string.  For example, `{0}` refers to the 0-th argument of the format function. (We start counting at 0.) `1` refers to the second argument.

## String Interaction

In Python, a string is really just a fancy list, meaning we can access each character individually.  Computer Science starts counting at 0 (this actually makes a lot of thigns easier, but its confusing your first time hearing it).  To access a single element of a list, you need to provide an index in square brackets.

```py
"Hello World"[0] # => "H"
"Hello World"[1] # => "e"
"Hello World"[2] # => "l"
"Hello World"[3] # => "l"
"Hello World"[4] # => "o"

"Hello World"[-1] # => "d"
```

One interesting quirk of python is that you can use negative numbers to start index from the back of the list. (This is not present in every language, but a lot of interpreted languages like Python offer this feature).

We can also grab slices of a string by using [start index:end index].  Not that the end index is not included, just like range.

```py
"Hello World"[1:3] # => "el"
"Hello World"[1:-1] # => "ello Worl"
```

If you do want to start at the beginning of the string or go to the end of the string, just omit the start or end index.

```py
"Hello World"[:3] # => "Hel"
"Hello World"[1:] # => "ello World"
```

## String Functions

Strings have dozens more functions besides the format function.  For example, you can change their case.

```py
x = "hEllo WoRld"
x.lower() # => "hello world"
x.upper() # => "HELLO WORLD"
x.capitalize() # => "Hello World"
```

One of the most invaluable pieces of Python is the [Standard Library](https://docs.python.org/).  So let's talk about how to read the Standard Library.  Look at the definition of the find function in the Text Sequence Type (or str for string).

```
str.find(sub[, start[, end]])
    Return the lowest index in the string where substring sub is found within the slice s[start:end]. Optional arguments start and end are interpreted as in slice notation. Return -1 if sub is not found.
```

Here we first see the function's name as well as which parameters it takes.  The parameters in []'s are optional, and below there is an english description of the function. So find, looks for the first character in a string and returns the index.

```py
"Hello World".find('Wor') # => 6
"Hello World".find('wor') # => -1
```

Notice that find is case-sensitive.   Let's write a new version of find that isn't case sensitive.

```py
def find(string: str, substring: str) -> int:
    for i in range(0, len(string) - len(substring) + 1):
        if substring.lower() == string[i:i + len(substring)].lower():
            return i
    return -1
```

