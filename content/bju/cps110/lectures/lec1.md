---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Data Types / Variables

To the processor, every piece of information is numeric.  Video, word documents, games, pictures, etc. are all represented using numbers at a fundamental level.  It should come as no surprise that Python therefore has great support for mathematical operations.  But first, how in the world do you print stuff (or show it to the user)?

## Printing

Printing or displaying information is one of the most basic problems in Computer Science, right along with getting input from the user.  The most famous comptuer program is the `Hello World` program which is used to demonstrate how to produce output in a given programming language.

Here is `Hello World` in Python:
```py
print("Hello World")
```

We'll see more examples of using print as we go... (as well as how to do input).

## Mathematical Operations

Python supports many of the common (as well as uncommon) mathematical operators.

| Operation | Python Operator |
| --- | --- |
| Addition | + |
| Subtraction | - | 
| Multiplication | * |
| Division | / |
| Truncating Division | // |
| Exponentiation | ** |
| Modulus (Remainder) | % |

And here is how they are used.

```py
print(5 + 2) # => 7
print(5 - 2) # => 3
print(5 * 2) # => 10
print(5 / 2) # => 2.5
print(5 // 2) # => 2
print(5 ** 2) # => 25
print(5 % 2) # => 1
```

## Variables

In programming, and in math, sometimes we need to put the result of a calculation somewhere so we can reuse it...  These are called variables in Python.  Variables are just a block of memory that has a name and an associated value.

The assignment statement in Python creates a variable that can be used later and gives it a value
```py
temperatureFarenheight = 59
print((temperatureFarenheight - 32) * 5 / 9)
```

> A warning about variable names.  They are case sensitve!  Take a look at the folowing python example:
```py
tempFarenheight = 59
tempCelcius = (tempfarenheight - 32) * 5 / 9 # will crash here because no variable named tempfarenheight exists
```

# Data Types

The value of a variable in Python has a type, known as a data type.  Let's look at the four most common.

### Ints

Integers in Python are whole numbers and they can as big or as small as you want.  In other words, they can be arbitrary in length.

### Floats

Floats in Python are decimal numbers.  These numbers are limited by the number of bits your processor supports.  This doesn't mean these numbers can't be huge, but there is a limit to exactly how big they can be.

> Ints and floats are not the same thing in Python and they are treated very differently.  In general, calculations involving an int produce an int (except for division).  However, if you put one float in the mix, things change.
```py
x = 22 + 2 * 5
y = 22 + 2.0 * 5
print(x) # => 32
print(y) # => 32.0
```

### Strings

Strings are just characters wrapped in quotes.  For example, `"Hello World"` is a Python string.  However, Python doesn't specify which kind of quote.  You could also use a single quote like this: `'Hello World'`.  You just have to make sure that the start quote and the end quote are the same, so `"Hello World'` is not a Python string.

The one thing that is different is if you want to put a line break in a string. Then you have to use triple quotes.
```py
"""This is a multi-line string in Python
See there is another line here"""

'''This is also a multi-line string in Python
See there is another line here too'''
```

### Boolean

Booleans are values that are truth-y, they are either `True` or `False`.  These are generally used to check to see if a condition is `True` such as whether the variable `x` is greater than 0.

## Calculations with Data Types

You must be careful when you are performing calculations with data types.  For example, you cannot add a string and a number together.

```py
x = "Hello" 
y = 2
x + y # will crash because the types are different
```

## Conversion of Types

You can however convert between data types.  For example, both ints and floats can be converted to a string by wrapping them, `str(<number value or variable>)`.  The same is true of strings.  If a string contains a float inside, you can convert it to a float by wrapping it `float(<string>)`.  You can also wrap ints to convert them to floats and floats to convert them to ints.

```py
x = "2.0"
y = 2.0
z = 2

xAsAString = str(x) # => "2.0" 
xAsAnInt = int(x) # => 2
xAsAFloat = float(x) # => 2.0
yAsAString = str(y) # => "2.0" 
yAsAnInt = int(y) # => 2
yAsAFloat = float(y) # => 2.0
zAsAString = str(z) # => "2" 
zAsAnInt = int(z) # => 2
zAsAFloat = float(z) # => 2.0
```

## Input

But let's be honest, a program is really boring if we're only producing output.  We need to also be able to get input from the user! Just like there is a `print(<value>)` function, there is also an `input(<prompt>)` function that will prompt the user for input.  The input function though always returns the user's input as a string...

```py
# Simple Temperature Conversion
temperatureFarenheight = input("Give me a temperature in F and I will tell you what it is in C:")
temperatureCelcius = (temperatureFarenheight - 32) * 5/9 # will crash here because temperatureFarenheight is a string
print("The temperature in C is " + temperatureCelcius)
```

Oops... version 2!
```py
# Simple Temperature Conversion
temperatureFarenheight = input("Give me a temperature in F and I will tell you what it is in C:")
temperatureFarenheight = float(temperatureFarenheight)
temperatureCelcius = (temperatureFarenheight - 32) * 5/9 
print("The temperature in C is " + temperatureCelcius) # will crash here because temperatureCelcius is a float
```

Oops... version 3!
```py
# Simple Temperature Conversion
temperatureFarenheight = input("Give me a temperature in F and I will tell you what it is in C:")
temperatureFarenheight = float(temperatureFarenheight)
temperatureCelcius = (temperatureFarenheight - 32) * 5/9 
print("The temperature in C is " + str(temperatureCelcius))
```