---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Modules

Python consists of a language and a standard library.  This library contains a ton of useful stuff that is already written for you, like the writing of complex mathematical calculations (you could rather easily write a Python program to do your calculus homework).

The standard library is organized into modules. A module is a collection of classes, variables and functions.  A class is a collection of variables and functions defining an object or custom data type.  An object is an instance of a class (or that data type), and a function is a named group of statements... Whew...

Today, we'll look at modules and functions.  Classes and objects will come later in the semester, but you still need to be aware of what they are.

## Standard Library Organization

In the standard library, there are a plethora of modules.  For example the math module contains several useful variables and functions.  To use a module, you simply import it...

```py
import math
```

Then you can reference any function, variable or class by using the module name dot the variable, function or class.

```py
import math
math.pi # => 3.141592653589793
math.e # => 2.718281828459045
math.sin(15) # => 0.6502878401571168
math.cos(15) # => -0.7596879128588213
math.tan(15) # => -0.8559934009085188
```

There are many functions in the standard library; you've already seen a few like: `print()`, `input()`, and `range()`.  We'll look at how to write our own in a minute.

So how can you find all the modules and what they contain? Go to the [Standard Library Documentation](https://docs.python.org/)

## Functions

To use a function you write a statement that invokes the function by using its name and supplying any required values.

For example, to use print, we write:
```py
print("Hello")
```

This is known as a function call or invocation.  Those required values are called parameters.
To execute this statement, Python finds the definition of the function and runs the statements inside.

Function definitions consist of two parts: an interface gives the function name and describes what parameters the function receives and an implementation that is the statements inside the function.  A function is just like a mini program: it needs input, it does calculations and returns output.

Function input is via the parameters.  The caller of the function has to provide values for each parameter.  The output of a function is done via a return statement, which tells Python which value to give back to the caller.

For example, the `len()` function returns the length of a string!  So we have to give it a string parameter, and we have to collect the value given back to us.

```py
string = "Hello World"
lengthOfString = len(string)
```

There are many functions built into Python that you don't even need a module to use!  Look at the [Python Standard Library](https://docs.python.org/3/library/functions.html) for more information.

## Classes / Objects

