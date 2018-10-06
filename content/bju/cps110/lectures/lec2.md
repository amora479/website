---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Flow Control I

Programs execute from beginning to end.  Flow controls allow us to execute statements more than once as well as execute statements conditionally!

## For Loops

A for loop allows us to execute a statement a specific number of times.

```py
for i in [1, 2, 3, 4]:
    print(i)

# prints
# 1
# 2
# 3
# 4
```

Notice there is a loop variable `i` inside the for statement.  Also notice that there is a list of values `[1, 2, 3, 4]` inside the for statement.  The for loop will execute its body once for each item in the list of values.  Each time, `i` will become one of the items in the list starting at the beginning of the list.  So, the first time `i` will be 1, then `i` will be 2, then `i` will be 3, then `i` will be 4, then we'll be at the end of the list so the for loop will stop executing.

Also notice that there is a pesky `:` after the for.  Forgetting that will cause Python to tell you that your for loop isn't valid!

> The body of a for loop can be multiple statements, but each statement must be indented the same.
```py
for i in [1,2,3,4]:
    print("I am in the for loop")
    print("I am also in the for loop")
print("I am not in the for loop")
```

For loops are surprisingly useful.  For example, say we wanted to sum a list of numbers.
```py
sum = 0
for num in [5, 10, 15 20]:
    print("Processing Number: " + str(num))
    sum = sum + num

print("The sum of the numbers is " + str(sum))
```

But what if we wanted a for loop to execute 3000 times.  Do we have to type 1, 2, 3, 4, 5, 6, 7, 8, 9, 10....  3000.  Thankfully no.  There is a function in Python called the range function that will allow us generate a list of numbers...  One thing to remember though is the last item is always omitted.
```py
range(0, 3000) # => produces a list of values from 0 to 2999
```

Another cool thing about range is you can change the increment amount.
```py
range(0, 3000, 2) # => produces a list of values from 0 to 2998 counting by 2s
range(10, 0, -1) # => produces a list of values from 10 to 1
```

```py
for i in range(10, 0, -1):
    print(i)
print("BOOM!!!!")
```

## If Statements

If statements allow us to execute a group of statements conditionally.  For example, here is a very simple actuarial calculator that determines how many years you have left to live.

```py
ageStr = input("How old are you?")
age = int(ageStr)
yearsLeft = 80 - age
print("You have approximately " + str(yearsLeft) + " years of life left.")
```

A sneaky person could enter a negative number, so let's fix that.

```py
ageStr = input("How old are you?")
age = int(ageStr)
if age > 0:
    yearsLeft = 80 - age
    print("You have approximately " + str(yearsLeft) + " years of life left.")
else:
    print("I need a positve number greater than 0.")
```

Comparisons in Python come in many shapes, but they all result in boolean values.

| Comparison Type | Operator | 
| --- | --- |
| Are Two Values Equal? | == |
| Are Two Values Not Equal? | != |
| Is Value 1 Less Than Value 2? | < |
| Is Value 1 Less Than or Equal To Value 2? | <= |
| Is Value 1 Greater Than Value 2? | > |
| Is Value 1 Greater Than or Equal To Value 2? | >= |

If statements in Python also come in many shapes.  Note the presence of the colons after each statement...  They are required by Python.

```py
# if statement
if condition:
    # executes if condition 1 is true
    # statement 1
    # statement 2
    # ...
    # statement n

# if else statement
if condition:
    # executes if condition 1 is true
    # statement 1
    # statement 2
    # ...
    # statement n
else:
    # executes if condition 1 isn't true
    # statement 1
    # statement 2
    # ...
    # statement n

# if else if statement
if condition:
    # executes if condition 1 is true
    # statement 1
    # statement 2
    # ...
    # statement n
elif another condition: # you can have multiple else ifs
    # executes if condition 1 isn't true but condition 2 is
    # statement 1
    # statement 2
    # ...
    # statement n

# if else if else statement
if condition:
    # executes if condition 1 is true
    # statement 1
    # statement 2
    # ...
    # statement n
elif another condition: # you can have multiple else ifs
    # executes if condition 1 isn't true but condition 2 is
    # statement 1
    # statement 2
    # ...
    # statement n
else:
    # executes if none of the other conditions are true
    # statement 1
    # statement 2
    # ...
    # statement n
```

## Example

```py
# Grading Assistant Example
score = int(input("Enter Score (0-100): "))

if score >= 90:
    print("A")
elif score >= 80:
    print("B")
elif score >= 70:
    print("C")
elif score >= 60:
    print("D")
else:
    print("F")