---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Software Development

The development of software needs to be a procedural, repeatable process.  Throwing stuff at a wall and seeing what sticks doesn't generally produce good results...

The general process for writing software is:

1. Develop Requirements
1. Design a Solution
1. Write Code
1. Test

## Defining Requirements

Ask the user for a description of what the program should do.  Look for things you need to get as input from the user, calculations (especially things that are conditional or need to be repeated), and things to output.  After you've written those down, ask questions from the user to ensure what you have written is correct.

```
Harry walked into Fred's Software Shop and slapped his checkbook on the counter. " I want you to write a program for me to help me figure out how much feed to give my chickens," he began. "How much will it cost?" 

Fred replied, "Well, that doesn't sound too complicated, but I need a few more details before I can estimate the fee. How do you calculate the amount of feed to give the chickens now?" 

"Well, it's like this," Harry explained. "Basically, each chicken eats 10% of its body weight in feed. But the temperature has an effect on the appetites of those temperamental fowl. If it's hot -- say, over 90 degrees -- they only eat 8% of their body weight. But when the temperature drops below 60 degrees, they eat 12%." 

"Will the program have to calculate the total weight for all the chickens, or will you simply give it that information?" probed Fred. Harry answered, "Well, it would be nice if I could enter the weight for each chicken and have the program calculate the total weight for me ... " 

"That will cost extra," warned Fred. "I'm not good at loops yet." 

"Then I'll add up the total weight myself," said Harry. "I want to keep the cost down."
```

From this story, we see several things.  One we are going to ask for the temperature and total weight of the chickens as input.  We have one calculation if the temperature is > 90 degress, one calculation if it is < 60, and one calculation for in between. We only have one output which is the total amount of feed.

## Design

The general design for all programs (and functions that we'll talk about later) is:

1. Get Input
1. Do Calculations
1. Display Output

This helps keep our code organized and easily understandable.

For the chicken program, our outline is going to be...

1. Ask for totalWeight and temperature
1. Perform the correct calculation 
1. Print the result of the calculation

## Write Code

```py
totalWeight = int(input("Enter the total weight of all chickens: "))
temperature = int(input("Enter the temperature: "))

feed = 0
if temperature > 90:
    feed = totalWeight * 0.08
elif temperature < 60:
    feed = totalWeight * 0.12
else:
    feed = totalWeight * 0.10

print("Your chickens need " + str(feed) + " units of feed")
```

## Test

Test cases are used to check for errors in the program.  A good test case consists of input and expected output. After discovering an error, the programmer will use the test case to find the bug and fix it!

Test cases are generally made for break points in the code.  Pay particular condition to if conditions.

For example, the chicken program has two breaks, around 60 and 90.  We need to check to make sure both sides of those breaks work properly.

| Test Case # | Input | Expected Output |
| --- | --- | --- |
| 1 | W - 100, T - 59 | 12 |
| 2 | W - 100, T - 60 | 10 |
| 3 | W - 100, T - 90 | 10 |
| 4 | W - 100, T - 91 | 8 |