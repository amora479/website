---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Boolean Logic

Booleans in Python are very simple structures, just the result of a condition check.  So far we've seen some very simple condition checks...

```py
x > 0
x < 0
x == 0
x == "H"
```

But condition checks can be extremely complex.  Individual conditions can be combined using one of two operators `and` and `or`.  They can also be flipped using `not`.  Let's look at how these work...

```py
# and returns True if and only if both sides are true...
True and True # => True
True and False # => False
False and True # => False
False and False # => False

# or returns True if either side is true...
True or True # => True
True or False # => True
False or True # => True
False or False # => False

# not inverts the value of a boolean
not True # => False
not False # => True
```

Boolean expressions consist of one or more of these operators and checks...

```py
while input != "S" or input != "M" or input != "M":
while input != "S" and input != "M" and input != "M":
```

Which of the above would loop while the input was not S, M, or H?  If you guessed the and version, you're correct.  Remember the or returns true if any of the arguments are true.  So if the user entered S, then the not H and not M would be true so we would continue looping.

## Evaluating Complex Expressions

Just like there is an order of mathematical operations, PEMDAS, there is an order of boolean expressions, PNAO (Parenthesis, Not, And, Or). Also, just like math, we work from left to right.  Let's take an expression and unpack it.

```py
(True and False) or not True and True
# evaluate the parenthesis first
False or not True and True
# evaluate the not 
False or False and True
# evaluate the and
False or False
# evaluate the or
False
```

Try a few for yourself.  Plug them into the Python interpreter to check your answers!