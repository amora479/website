---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Unit Testing

Functions are one of the basic building blocks of program and designing them so that they are testing is of utmost importance.  So let's look at how to design testable functions.

## Two Ways

There are two general approaches to testing functions, test the entire program (and the function in the process) or just test the function by itself.  Testing functions individually before testing the entire program is usually faster and means there are less bugs when the entire program is tested.

## Unit Tests

A unit test is a small program that tests a single function to determine if the function works.  Unit tests could be run manually...

```py
def roundIt(num: float) -> int:
    return int(num + 0.5)

x = float(input('Enter a number: '))
result = roundIt(x)
print('Result: ', result)
```

But this does have some downsides.  Unit tests really should be repeatable, right now there is no record of what values to pass in. So what about automated unit testing.

```py
def roundIt(num: float) -> int:
    return int(num + 0.5)

result = roundIt(9.7)
if result == 10:
    print("Test 1: PASS")
else:
    print("Test 1: FAIL")

result = roundIt(8.2)
if result == 8:
    print("Test 2: PASS")
else:
    print("Test 2: FAIL")
```

Here there is no need to remember our test cases.  Python does that for us (which also means anyone that has our code can easily run our tests).

But wait...  There is an easier way.  Python has a statement meant exactly for this purpose `assert`.

```py
def roundIt(num: float) -> int:
    return int(num + 0.5)

assert roundIt(9.7) == 10
assert roundIt(8.2) == 8

# put the program using roundIt here
```

The assert statement receives a boolean condition and throws an exception if the result of the condition's evaluation is false.

It would be a little nice though if we didn't have to run the assertions every time we ran the program, only when we wanted to test. Enter pytest.  Pytest is a python library that allows us to write functions to test other functions.  These functions do have to have a special name though; the function's name must begin with `test_`.

```py
def roundIt(num: float) -> int:
    return int(num + 0.5)

def test_roundIt():
    assert roundIt(9.7) == 10
    assert roundIt(8.2) == 8

if __name__ == "__main__":
    # put the program using roundIt here
```

But wait... what in the world is that if statement?  Pytest is run using the `pytest` command instead of the `python` command.  That if statement allows us to run the regular program code only if we use the `python` command.  In other words, all the prints and inputs won't happen when we run with `pytest` which is good because they would cause pytest to crash.

## Designing Testable Functions

Some functions can't be tested with a unit test, like this one.

```py
def roundIt(num: float) -> int:
    print(int(num + 0.5))
```

It doesn't return anything!  A testable function will generally grab input from parameters, return a result and do no input or output.s

## Function Specifications

In order to have good testable functions, we need function specifications, or an exact description of what the function does.

Function specifications are contracts (like legal contracts) written in terms of preconditions and postconditions.  A precondition is a restriction on what parameter values are allowed (like "my function only supports even integers").  A postcondition is a promise about the output (like "my function produces a number that is below 65,536").  The idea is that as long as a person obeys your preconditions, the postoconditions will always be true, and if they break the preconditions, you're not responsible for the outcome.

Here is a sample:

```py
def sumNums(lo: int, hi: int) -> int:
    """Computes sum of sequence
    Preconditions: `lo` <= `hi`
    Postconditions: returns sum of numbers in
    range [`lo` .. `hi`]
    """
    sum = 0
    for i in range(lo, hi+1):
        sum += i
    return sum
```

This information helps us write unit tests... So which of the following would be acceptable unit tests?

```py
assert sumNums(1, 3) == 6 # 1 < 3 so good
assert sumNums(1, 1) == 1 # 1 <= 1 so good
assert sumNums(1, 0) == 0 # not good
assert sumNums(-2, -1) == -3 # -2 < -1 so good
```

## Test Driven Development

Traditionally, we have written functions first then tests.  One day someone tried it the other way.  This has some huge benefits.  First, remember requirements?  Before you ever write your function, you can write all the requirements out in terms of unit tests.  Now, not only do you have a record of the requirements, but you know exactly when you are done writing the function.