---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Flow Control II

We need to look at one last flow control, a loop for when we don't know exactly how many iterations we need.  We just want it to loop until some condition is True.  This structure is known as a while loop in Python.

```py
while condition:
    # statement 1
    # statement 2
    # ...
    # statement n
```

## Validating Input

While loops are very commonly used to check for valid input.  Assume the user's input is invalid, and loop `while not valid:`

```py
valid = False
while not valid:
    name = input("Enter your name: ")
    if name == "":
        print("Sorry, but your name is required")
    else:
        valid = True
```

This can also be done if your input can be multiple values!

```py
valid = False
while not valid:
    format = input("Format your hard drive (Y/N): ")
    valid = True
    if format == "Y":
        print("Formatting!!!")
    elif format == "N":
        print("Oh, okay...")
    else:
        valid = False
        print("Sorry, but you have to actually tell me...")
```