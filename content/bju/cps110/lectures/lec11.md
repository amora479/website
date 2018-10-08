---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Local / Global Variables

Global variables are variables which exist outside of functions and control statements.  Local variables are the variables created inside of functions or control statements.  Local variables have a limited lifespan, they exist only until the end of the block in which they were created, then they are "dispoed of" or "garbage collected."

Global variables are what we have used for the majority of the semester, but local variables will be used more frequently now that we are using functions.  One interesting fact about global variables and functions is that you can create a local variable named the same as a global variable.

```py
someVariable = 0

def function():
    someVariable = 15

function()
print(someVariable) # => 0
```

In the example above, you might expect that 15 would be printed, after all we changed someVariable, right?  Nope, we created a new local variable named `someVariable` and then got rid of it when function exited.  We can use someVariable, but only for reading.

```py
someVariable = 5

def function():
    myVariable = someVariable 15
    print(myVariable) # => 20

function()
print(someVariable) # => 5
```

Functions have a glass ceiling.  You can see what is outside of them but you can't change it... unless you punch a hole in the glass ceiling.  That is what the global keyword does, it allows you to put a hole in the glass ceiling so you can update certain variables.

```py
someVariable = 0

def function():
    global someVariable
    someVariable = 15

function()
print(someVariable) # => 15
```