---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Debugging

There are three types of errors and pitfalls in Python: Syntax Errors, Runtime Errors and Logical Errors.

## Syntax Errors

These are errors where your program does not conform to the Python specification.  For example, your forgetting a colon after an if statement would be considered a syntax error.

Before Python runs a line of your program, it checks for valid syntax so syntax errors are the first kind of error that is reported.

## Runtime Errors

Typically, runtime errors are the second kind of error that is noticed.  These are errors that cause your program to crash unexpectedly, like dividing by 0 or adding a string and int together.

## Logic Errors

Logic errors are typically the last kind of error that is caught and they are the most difficult.  Logic errors are mistakes in calculations that don't result in a crash but result in a wrong answer, like dividing when you should have multiplied.

## Debugging

Finding where a logic error happens can be difficult.  The easiest way to find them is to add print debugging statements.

These statements go after any variable assignment or condition check.  For example, here is an example buggy chicken feed program.

```py
temperature = int(input('Enter the temperature in degrees fahrenheit: '))
print("temperature is now", temperature)
totalWeight = int(input('Enter total chicken weight in pounds'))
print("totalWeight is now", totalWeight)

if temperature <= 60:
    print('It’s cold! temperature =', temperature)
    feedAmt = totalWeight * .12
    print("feedAmt is now", feedAmt)
elif temperature >= 90:
    print('It’s hot! temperature =', temperature)
    feedAmt = totalWeight * .08
    print("feedAmt is now", feedAmt)
else:
    print('It’s comfortable! temperature =', temperature)
    feedAmt = totalWeight * .1
    print("feedAmt is now", feedAmt)

print('Feed them ', feedAmt, " pounds of Robert's Best")
```

Run the test cases we developed earlier against this buggy version and use the print statements to figure out where it is wrong.

| Test Case # | Input | Expected Output |
| --- | --- | --- |
| 1 | W - 100, T - 59 | 12 |
| 2 | W - 100, T - 60 | 10 |
| 3 | W - 100, T - 90 | 10 |
| 4 | W - 100, T - 91 | 8 |