---
title: "CPS 105"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Algorithms

## Introduction

In this assignment, you will work with algorithms that manipulate stacks and queues. [Watch a short video about stacks and queues.](https://www.youtube.com/watch?v=6QS_Cup1YoI)

## Sample Problem

Here is an algorithm using a stack and a queue. 

```
WHILE queue is !empty:
    remove item from front of queue
    IF item is a vowel:
        push item onto top of stack
    ENDIF
ENDWHILE # end of loop
```

Sample Problem: Show a trace of the algorithm by indicating the contents of the stack and the queue at the end of each iteration of the loop, given a starting queue value of EAT (E is at the front). Then, describe what the algorithm does.

| Iteration | Stack | Queue |
| --- | --- | --- |
| | | E A T |
| After 1st Loop | E | A T |
| After 2nd Loop | A E | T |
| After 3rd Loop | A E | |


The algorithm extracts vowels from a word and puts them in reverse order onto a stack.

## Problem 1

Here is an algorithm to sort a stack of cafeteria trays of various colors so that similar colors are grouped together. The algorithm uses three stacks. stack1 initially contains the cafeteria trays to be sorted. stack2 and stack3 are used by the algorithm to help sort the trays. 

```
let stack1 hold unsorted trays
WHILE stack1 is !empty:				 # Loop 1
    currentColor := color of tray on top of stack1	
    WHILE stack1 is !empty:	    		 # Nested Loop A
        remove tray from stack1
        IF color of tray = currentColor:
            push tray on stack2
        ELSE:
            push tray onto stack3
        ENDIF
    ENDWHILE # end of Loop A	
    WHILE stack3 is !empty:			 # Nested Loop B
        remove tray from stack3
        push tray on stack1
    ENDWHILE # end of Loop B
ENDWHILE # end of Loop 1
```

1.	Which stack contains the sorted trays when the Algorithm 2 completes? _______________ (1 point)
2.	Show a trace of the values of the three stacks, given the starting value of stack1 shown below. (4 points)

| Location | currentColor | stack1 | stack2 | stack3 | 
| --- | --- | --- | --- | --- |
| Before Loop 1 | - | G R B R G B | - | - |
| 1st Iteration of Loop 1: After Loop A | | | | |
| 1st Iteration of Loop 1: After Loop B | | | | |
| 2nd Iteration of Loop 1: After Loop A | | | | |
| 2nd Iteration of Loop 1: After Loop B | | | | |
| 3rd Iteration of Loop 1: After Loop A | | | | |
| 3rd Iteration of Loop 1: After Loop B | | | | |

## Problem 2
In computer science, sorting is a well-studied problem. We say that word1 is “lexicographically” less than word2 if word1 comes before word2 alphabetically. For example, A < B, Q < T, E < Z.

Here is a queue-based algorithm to test which of two words is lexicographically less than the other. The two words are initially loaded onto two queues, queue1 and queue2, with the first letter of each word at the front of the respective queue.

```
WHILE queue1 is !empty AND queue2 is !empty:
    remove letter1 from front of queue1
    remove letter2 from front of queue2
    IF letter1 < letter2:
        Done. Report that queue1 contained the lexicographically lower word, and 
        exit algorithm.
    ELSE IF letter1 > letter2:
        Done. Report that queue2 contained the lexicographically lower word, and 
        exit algorithm.
    ENDIF
ENDWHILE
```

Algorithm 3 works correctly for some pairs of words, but for other pairs, it gives no result. 

3.	Fill out the table for Algorithm 3. If the algorithm does not provide an answer, put “(unknown).” (3 points)

| queue1 | queue2 | Queue Reported to be Lower | Number of Loop Iterations |
| --- | --- | --- | --- |
| c a t | d o g | | |
| b e n t | b e n d | | |
| c a n d i e d | c a n | | |
| e s c a p e | e s c a p e d | | |
| p e n | p e n | | |

4.	Add a few lines after the end of the algorithm to give the appropriate responses for all 5 example word pairs. If the words are the same, either queue may be reported to contain the lexicographically lower word. (4 points)

```

IF _________________________________________________________________ :

    __________________________________________________________________

ELSE ________________________________________________________________:

    __________________________________________________________________

ENDIF
```
5.	Complete the table after you've corrected the algorithm.

| queue1 | queue2 | Queue Reported to be Lower |
| --- | --- | --- |
| c a t | d o g | |
| b e n t | b e n d | |
| c a n d i e d | c a n | |
| e s c a p e | e s c a p e d | |
| p e n | p e n | |

## Problem 3
Here is a stack-based algorithm for computing the value of a Roman numeral. (It is not totally correct.)

```
number := 0
WHILE stack is !empty:
    remove numeral from top of stack
    IF numeral = I: numValue := 1
    IF numeral = V: numValue := 5
    IF numeral = X: numValue := 10
    IF numeral = L: numValue := 50
    IF numeral = C: numValue := 100
    IF numeral = M: numValue := 1000
   number := number + numValue
ENDWHILE
report number 
```

6.	Show a trace of Algorithm 4 with MCXLII in the stack (3 points):

| Location | Stack | numeral | number |
| --- | --- | --- | --- |
| Before Loop | M C X L I I | - | 0 |
| After 1st Iteration | | | |
| After 2nd Iteration | | | |
| After 3rd Iteration | | | |
| After 4th Iteration | | | |
| After 5th Iteration | | | |
| After 6th Iteration | | | |

7.	What is the correct value for MCXLV? (Check online if you need to.) _____________________ (1 point)
8.	Suppose you wish to write a corrected Roman numeral converter. Assume the surrounding loop has been written, and you are tasked with writing the if statement for testing for the special situation illustrated by #7 above. Fill in the blanks to correctly handle “subtractive notation.” (4 points)

If you process one numeral each time through the loop, there are a couple ways to handle subtractive notation: looking forward to the next number or looking back at the previous number. For this exercise, you should look forward to the next number. For instance, with the input “LIV,” the value of number at the end of each loop will be 50, 49, and 54. 

Warning: You cannot compare numeral values like “C” and “X” and get the right result. You need to compare their numerical values: 100 and 10. 

```
number    := the computed value so far
numeral   := the current numeral being handled
numValue  := the numeric value of the current numeral
nextRN    := the next numeral, or "end" if there are no more
nextValue := the numeric value of the next numeral. If nextRN is 
             "end," nextValue is not updated.


IF _______________________________________________________________ :

    number := number _______________________________________________

__________________________________________________________________ :

    number := number _______________________________________________

ENDIF
```
9.	Complete this table for MCMXLIV using the corrected algorithm: (4 pts)

| Location | Stack | number | numeral | numValue | nextRN | nextValue |
| --- | --- | --- | --- | --- | --- | --- |
| After 1st Iteration | | | M | 1000 | C | 100 |
| After 2nd Iteration | | | C | | | |
| After 3rd Iteration | | | M | | | |
| After 4th Iteration | | | X | | | |
| After 5th Iteration | | | L | | | |
| After 6th Iteration | | | I | | | |
| After 7th Iteration | | | V | | | |

10.	ADVANCED EXERCISE: Write out the entire Roman numeral converter algorithm, incorporating your changes to Algorithm 4. You may not need all the blanks. (1 point if nearly correct. 2 points if completely correct.)

Tricky aspects:
a.	You will need to devise a way to retrieve nextRN, but still make it available to be numeral the next time through the loop. You may assume that if there are no more numerals, “end” is returned from the stack.
b.	You need to assign the appropriate values to nextValue to correspond to nextRN. 
```
number := 0, nextValue := 0

WHILE _______________________________________________________________:
    # get numeral and nextRN from the stack

    __________________________________________________________________

    __________________________________________________________________

    __________________________________________________________________
    # set numValue
    IF numeral = I: numValue := 1
    IF numeral = V: numValue := 5
    IF numeral = X: numValue := 10
    IF numeral = L: numValue := 50
    IF numeral = C: numValue := 100
    IF numeral = M: numValue := 1000
    # set nextValue

    __________________________________________________________________

    __________________________________________________________________

    __________________________________________________________________

    __________________________________________________________________

    __________________________________________________________________

    __________________________________________________________________
    # Update number 

    __________________________________________________________________

    __________________________________________________________________

    __________________________________________________________________

    __________________________________________________________________

    __________________________________________________________________
ENDWHILE
report number 
```
