---
title: "CPS 105"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Testing & Debugging

Decide on teams.  This is a group project!  It is preferred to have groups be a CS person and a non-CS person if possible so that you get some experience seeing things from someone else's viewpoint.  Your partner does not have to be in your section!  Use the #cps105 channel in slack to communicate with students who are not in your section.

## Get Started
Download a copy of the [starting code](/bju/cps105/homework/testing/testing.zip).  This contains a copy of the instructions below as well as a copy of the answer sheet.  Inside the zip file, `ttt_testing.html` is the sample program that you are testing.  Note, the tic-tac-toe is broken, it is supposed to be!  Note any problems you find through testing on the answer sheet.

## Overview
For this assignment, you (and a partner) will be working with a web-based, two-player tic-tac-toe game. You will be provided with a precise description of how the program is supposed to work, and your job will be to formulate and execute a plan for testing the program thoroughly. Your goal is to either verify that the program works exactly as it is specified or to find the bugs by identifying exactly how and when the program goes wrong.

## Background
Quality Assurance Engineer. There are professional engineers in software and hardware companies around the world whose job is similar to the work you will do in this lab. Quality assurance (QA) engineers are in a unique position, because they need to understand both the engineering that goes into products they test and the needs of the customers who will eventually be using those products. The work process for a QA engineer is much more extensive than the glimpse you get in this lab, but the basic problem is the same: make certain that a product works as it is specified by testing it according to a careful plan.

## Target Software
Before you get started with the assignment, download the tic-tac-toe game and familiarize yourself with the way it works. 
 
## Types of Testing
For this assignment, you will attempt to precisely identify buggy program behavior, but without seeing or understanding the program code, you will not know exactly what needs to be fixed. This is a common limitation of *black-box testing*. In *black-box testing*, you test a system without seeing “the inside”—its inner workings, the internal design. Instead, black-box testing relies on the externally observable behavior of a system.

In contrast, *white-box testing* is done with full knowledge of the system’s internals. In other words, you not only know what the system does, you also know exactly how and why the system does what it does. Although white-box testing can identify certain bugs more easily than black-box testing, white-box testing requires more technical expertise.

When you start programming (and debugging!) in later labs, keep both of these strategies in mind. Even if you are testing your own program, choosing black-box testing and distancing yourself from the internal design of the program can help you avoid making hasty assumptions about your program’s correctness. On the other hand, white-box testing can be essential for pinpointing the exact reasons for a bug. The knowledge that white-box test results provide can be very valuable to the programmer in identifying and fixing bugs.

## Specification
Since your goal is to identify what (if anything) works incorrectly with this program, you need a clear, precise definition of what it means for this program to work correctly - a specification. A specification is a carefully written, formal description of how a system (a program, in this case) should work. To keep things simple, the tic-tac-toe specification below is less formal and shorter than a normal specification. Based on it, begin forming a plan for testing the program. As you read the specification, start thinking about what you would do to confirm that it works as specified. 

1. The tic-tac-toe program lets two players (an O player and an X player) play a series of games of tic-tac-toe. 
1. The program keeps track of how many games each player has won and clearly displays the results at all times. (When the page is first opened or when the user clicks “Reset Win Counters,” these counters start at zero.) 
1. Players take turns making moves by clicking on the tile they want to mark. 
1. Players may mark only an empty tile, and a player’s turn ends when he/she marks an empty tile. 
1. The game ends when someone has won (three Os or Xs in a row) or when the board is full, which is a draw and counts as neither player’s win.
1. The page displays whose turn it is at any given time. 
1. Players alternate on who makes the first move. E.g., if O starts one game, X gets the first move of the next game. 
1. Clicking the Restart Current Game button clears the board, and it becomes the turn of the player who started the game that was restarted.

## Testing Specifications
Now let us take a closer look at parts of the specification and plan tests that would help you verify that the program works accordingly.
For each of the eight specifications, 

1. Describe how you would test that the program meets the specification. For each test, make sure to describe what you would do with the program, noting the observations you will make to determine program correctness.
1. Describe how you expect the program to behave in response. 
1. Decide if the program meets the specification, pass or fail.
1. If the program does not meet this specification, describe the actual response.
1. If the program does not meet this specification, list steps to reproduce the problem.

## Hints

- Number 8 is the most obscure one to thoroughly test. 
- Think of all situations when something could fail in order to catch a bug. Failures might happen on games during
    - the first game for any play along the way 
    - any subsequent game that occurs after a win or a draw
-	Two ways to test each of the numbers 2-8 separately:
    - Close down the file after each of the tests 2-8 and reopen
    - Ctrl+F5. 

## Submitting Your Responses
You and your partner should use one copy of the “Answer Sheet.docx” to record your answers.

Once you have finished testing and have completed the answer sheet, you will either be convinced that this program works according to specification or you will have identified one or more bugs and understand how to reproduce the problematic behavior. 

Submission
Put both your name and your partner’s name on the “ASG4 Answer Sheet.docx,” and submit to Canvas before the due date. 
