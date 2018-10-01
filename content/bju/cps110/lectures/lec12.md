---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Lists

In python a list is a data type which can contain multiple items.  For example, here is a list that contains a number, a boolean and a string!

```py
x = [1, True, "Hello!"]
```

Notice that the contents of a list go inside square brackets and that each item is separated by a single comma.  Lists can pretty much hold any number of things (unless you have more things than you have RAM, but that is an entirely different problem).

## Working with Lists

The python docs shows a number of functions that work on lists.  For example, you can check the size of a list with the `len()` function.

```py
x = [1, 2, 3, 4]
print(len(x)) # will print 4
```

Lists also like strings can be sliced.  (Actually, strings are just fancy lists where each thing in the list is a character.)

```py
x = [1, 2, 3, 4]
print(x[1:2]) # will print [2], remember that slicing stops before the last index
```

## Editing the Contents of a List

The contents of a list can be easily changed by setting a list index to a value.  For example,

```py
x = [1, 2, 3, 4]
x[1] = 5
print(x) # will print [1, 5, 3, 4]
```

You can also add things a list using the `append()` function.

```py
x = [1, 2, 3, 4]
x.append(5)
print(x) # will print [1, 2, 3, 4, 5]
```

Notice that append does not return a new list.  It modifies the existing list!!  There is also a `remove()` function.

```py
x = [1, 2, 3, 4]
x.remove(3)
print(x) # will print [1, 2, 4]
```

This also modifies the list, but notice that remove takes the item to remove, not the position of the item.  This might be a gotcha if you're coming from another language like C, C++, C# or Java.

One word of caution.  Lists in python do not allow arbitrary indexing.  If you try to access a position that does not exist, the program will crash.

```py
x = [1, 2, 3, 4]
x[5] # will crash here!
print(x) 
```

## Reading / Writing

Let's write some functions to manipulate a global array that is 100 numbers long, and then we'll unit test the functions.

```py
memory = [0] * 100

# reads from the global memory list at the address provided
# returns None if the address is not in range
def read(address):
    global memory
    if 0 <= address and address < 100:
        return memory[address]
    else:
        return None

# writes int the global memory list at the address provided
def write(address, value):
    global memory
    if 0 <= address and address < 100 and -999 <= value and value <= 999:
        memory[address] = value
```