---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Functions

Remember a function is just a mini program.  It takes input, does calculations and produces output.  The input is the function parameters and the output is produced by the return statement.  Functions are divided between two parts (actually the colon does the dividing!).  The part before the colon, the name, paramters and type hints is the function interface.  It describes how the function looks to the rest of the program.  The part after the colon, the if statemnts, loops and calculations that eventually return something is the function implementation.

```py
def add(x, y):   #interface
    return x + y #implementation
```

Note: it might seem odd, but functions have to come before whatever uses them.  For example,

```py
add(2, 3)

def add(x, y):
    return x + y
```

would crash because add doesn't exist when you call `add(2, 3)`.  It only exists after python sees the function and "registers" it for use.

## Parameters

Functions don't need parameters, per se.  The could just return something.  But just like programs need input most of the time, so do functions.  Parameters are best thought of as placeholders are variables without a value.  They will be given a value eventually, but not until someone calls them and provides values.  This means that things like

```py 
def func(x.lower()):
```

aren't valid.  x is a placeholder, there isn't a value inside of it yet.  You need to do the x.lower() statement in the function implementation which won't be invoked until someone calls the function and gives x a value.  The placeholders in the interface are called **formal parameters** since they don't have a value.  The parameters inside the implementation are called **actual parameters** because they have a value when the implementation executes. 

## Type Hints

Functions generally exepct the data type passed to them to be a certain data type.  For example, add probably expects both parameters to be ints or floats, but which?  We have no idea.  When you write functions, it is a good practice to add hints.  These hints are not checked by Python.  So if a function hints it wants a string, you can still give it an integer and watch it barf.  However, they do provide help to programmers (including you!).  So here is the add function it hints about the parameters and return type.

```py
def add(x: int, y: int) -> int:
    return x + y
```

## Why Functions?

First of all, functions help us manage complexity.  We can isolate a piece of code and reason about it only in terms of the parameters.  (This also reduces duplication of code,)

```py
alex.forward(30)
alex.right(120)
alex.forward(30)
alex.right(120)
alex.forward(30)
alex.right(120)

greta.forward(50)
greta.right(120)
greta.forward(50)
greta.right(120)
greta.forward(50)
greta.right(120)
```

Look at that mess.  If we wanted to change greta to move foward 60 instead of 50, we have to change 4 values.  What if we miss one?  We've introduced a bug...  Or what if we wanted to go forward and write a differnt number of times...

```py
def forwardAndRight(turtle: turtle, times: int, forward: int, right: int):
    for i in range(0, times):
        turtle.forward(forward)
        turtle.right(right)

forward(alex, 4, 30 , 120)
forward(gretta, 4, 50 , 120)
```

Not only is this shorter, it is much easier to modify.  This leads us into our second reason... abstraction.  Abstraction is the hiding of complexity behind a simple interface.  Some of the functions in the standard library are horrifically complex, but they have a simple interface where you call them and not worry about the complexity.  If it were not for abstraction, much the technology we have today wouldn't exist.