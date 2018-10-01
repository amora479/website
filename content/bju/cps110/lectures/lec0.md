---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Course Introduction

Welcome to Computer Science, the study of the transformation of information. Computer Science is a combination of many different fields, but it borrows heavily from mathematics.

## Programming Languages?

A programming language is a set of words and a highly-structured grammar that allows us to communicate with a machine so that it can follow our instructions.  Programming Languages vary wildly in their structure as well as their lexicon, but in general they fall into one of three categories.

- Machine Language is the most fundamental language.  This language consists of patterns of 1s and 0s that the computer executes directly.
- Assembly Language is one step above Machine Language.  This is a textual version of the 1s and 0s executed by the processor.
- High-Level Languages are languages that somewhat similar to how we write complex mathematical operations, albeit way more structured.

Computers, however, don't understand the instructions that we give them in high-level languages.  Those instructions have to "translated" to Machine Language so that the computer can understand. The tools that do this are known as either compilers or interpreters based on how they work.

A compiler is like a document translator.  You provide him with an entire document (a program) and he provides a complete translation to the computer so that the computer can run the translation.

An interpreter on the other hand translates in real time.  As you provide an instruction, the interpreter translates that instruction to Machine Language for running.

Compilers and interpreters both have benefits and trade-offs (a common theme in computer science, lunch is never truly free).  Compilers produce much faster, more memory effecient code, but that code will only work for a specific operating system and processor.  Interpreters produce more compatible code (you just need an interpreter for that processor or operating system) but the code is slower and uses more memory.

## Python - that's a snake right?

Not quite, Python also refers to a programming language written by Guido van Rossum in the 1990s.  It is an extremely popular interpreted programming language.  As it is interpreted, Python runs on a large number of operating systems and processors. It is used commonly in System Administration, Scientific Computing and Web Applications.

All python files, end with a `.py` extension.  Let's look at a sample Python program:

```py
# Make the turtle move
import turtle
size = 100
turtle.forward(size)
turtle.right(90)
turtle.forward(size * 10)
```

This program causes a turtle to appear which moves forward, turns right and then moves forward again until he disappears.

Python programs consist of three things:

- Comments (`# Make the turtle move`) - Sentences in english (or your native language) that allow you to describe to the reader of the python file what is happening
- Statements (`turtle.forward(size * 10)`) - Instructions that cause something to happen
- Expressions (`size * 10`) - Calculation of information necessary for instructions to be completed.