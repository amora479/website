---
title: "CPS 230 Program 2"
---

# Program 2
## Overview

You will write a Reverse Polish Notation (RPN) calculator program in NASM assembly.

## RPN

RPN is a *postfix* math notation, in which the operators come *after* the operands, not between them.  For example:

``` text
1 1 +
```

is the RPN equivalent of the more familiar *infix* notation

``` text
1 + 1
```

Despite its strangeness (to most of us), RPN has a fascinating advantage over *infix*: it doesn't need parentheses!
The following expressions (with the equivalent *infix* version) demonstrate this:

``` text
234+*  -->  2 * (3 + 4)

234*+  -->  2 + (3 * 4)

23+4*  -->  (2 + 3) * 4

23*4+  -->  (2 * 3) + 4
```

RPN is particularly straightforward to implement in computers by using a stack to store operands and results.  E.g.,
the RPN expression `2 1 + 4 -` could be evaluated using the following sequence of operations:

* Encounter `2` in input; push 2 onto stack
* Encounter `1` in input; push 1 onto stack
* Encounter `+` in input; perform addition by
    * Popping 2 operands from stack (1 and 2)
    * Adding them
    * Pushing the result (3) back onto the stack
* Encounter `4` in input; push 4 onto the stack
* Encounter `-` in input; perform subtraction by
    * Popping 2 operands from stack (4 and 3)
    * Subtracting the *newer* operand (4) from the *older* operand (3)
    * Pushing the result (-1) onto the stack

At the end, assuming no errors (like `1 +` or `1 2 3`) the stack will contain only one value: the value of the entire expression.

> **Note**: while the built-in x86 stack (i.e., the `push` and `pop` instructions) is handy, it's not the only way to
> implement an RPN-style operand stack.  After all--you couldn't *directly* use that if you wrote this program in C!
> There are some key advantages to creating your own stack (out of an array [to hold the values] and an index variable
> [to indicate the "top" of the stack]), but it will be more work, too, so think carefully before you code.

# Basic Requirements (Max Score: 80%)

Write a 3-operation RPN calculator that works on 32-bit signed integers using decimal notation.  The following features are
required (and are laid out in a good order-of-implementation):

1. Loop forever, reading input one raw character at a time, using the C runtime function `getchar()` (`extern _getchar` in NASM);
    recall that, in the Win32 C calling convention, *return values come back in `eax`*

    > **Note:** Do not use `scanf`; it is tempting, but the cake is a lie: `scanf` is *loaded* with subtle, tricky corner cases,
    > including some that are basically insurmountable.  Trust me, I'm actually trying to make your life *easier* here...

1. Terminate on EOF (i.e., when `_getchar` returns a negative "character")

1. *Ignore* any other character (except for the special ones mentioned below)

    > **Note** This means that spaces are ignored, and that `11+` and `1 1 +` are equivalent (at this stage)

1. If the user enters a decimal digit ('0' to '9'), convert that digit to its numeric form and push the resulting number onto the RPN stack

1. If the user enters the character `\n` (i.e., hits Enter/Return), print the top value from the stack in the format `[%d]` (using `_printf`)

1. If the user enters `+`, perform addition by popping 2 numbers from the RPN stack, adding them, and pushing the result

1. If the user enters `-`, perform subtraction by popping 2 numbers from the RPN stack, subtracting the second from the first, and pushing the result

1. If the user enters `~`, perform negation by popping 1 number, negating it (two's complement rules), and pushing the result


## Hints

* Try to implement each of the above features in the sequence they are listed, stopping between each one to test/debug
* For this level, with no stack-bounds-checking, directly using `push` and `pop` to manage your RPN stack is the easiest approach; if you are planning
    on going beyond this level, however, make sure you read the next level's instructions and consider all the implications first
* You can convert a single-digit decimal digit from ASCII to its decimal value by subtracting the ASCII value for the character `0`
* Thanks to the way the C calling convention works, if you are using the x86 stack as your RPN stack, you can print the top value by simply
    * Pushing the address of the format string `"[%d]", 0`
    * Calling `_printf`
    * Cleaning off only *one* parameter (the format string address), leaving the actual value as-is on the stack
* There is a `neg` instruction that may [slightly] simplify the implementation of `~`, but of course `not`/`inc` will work, too


# Intermediate Requirements (Max Score: 90%)

Enhance your basic (80-level) calculator program to be more *robust* (i.e., checking for stack underflow) and more *useful*.

## Robustness

First, see what happens when you enter `+` (followed by ENTER) into your calculator.
What's happening?  Unless you took special steps to avoid this (i.e., are already half done with this stage), your `+` operation
popped 2 numbers...  Except we had never *pushed* 2 numbers!  In the jargon of industry, we have "stack underflow" (popping more than we pushed).

We need to catch this.  Add code to check *everywhere* anything is popped, aborting the program with an error
message if the stack would underflow.  Try to avoid resorting to a copy-paste carpet-bombing campaign.

You *should* create `push_value` and `pop_value` functions that handle RPN pushes/pops, and can check for underflow along the way.
The only downside to this approach is that **it makes it hard/impossible to use the x86 stack** as your RPN stack.  If you have
trouble implementing your own separate stack, you *may* avoid making `push_value`/`pop_value` functions and you *may* use
boilerplate checking code everywhere, but you *will* lose some points for that.

## Usefulness

In addition, add support for the `*` (multiplication) and `/` (division) operations.

These operations will require the use of the `imul` and `idiv` instructions (along with `idiv`'s helper, `cdq`).
These instructions are *quite* different from `add`, `sub`, and the like, so give yourself plenty of time to 
research them in the Intel manuals *and* experiment with them in test programs.

## Hints

* Keep your program simple:
    * if you use variables/arrays, make them global rather than local (with all the stack frame fun)
    * and don't even think about making a dynamic/unbounded stack! just use a static/fixed-length array (16 elements max is plenty)
* The simplest way to abort your program is to call the C standard library function `exit` (`extern _exit`);
    follow the convention of passing a non-zero number (e.g., 1) to indicate a non-successful program termination
* Do not worry about recovering from edge cases like divide-by-zero

# Advanced Requirements (Max Score: 100%)

Up to here your calculator has been limited to single-digit number input; i.e., the input `123` would push 1, 2, then 3
onto the stack, *not* the number 123.

This might seem like a problem, and it is an inconvenience, but it's not a deal-breaker.  
For example, to enter the number 17, you could write:

``` text
125**7+
```

Try it!  123 is longer but not much harder:

``` text
125**2+25**3+
```

See the pattern?  Cool!  If you're a programmer.  But for Joe User, erm...  Not so much.  Let's add multi-digit number support!

Modify your input loop to support multi-digit numbers.  Any non-digit character (e.g., a space) will signal the "end" of a given number.  To add 11 and 17, for example, you could say

``` text
11 17+
```

Your program should not have to change all that much:

* Add storage/logic to keep track of a "current number" (i.e., the number currently being entered)
* Add storage/logic to keep track of whether or not the last input was a digit character
* If the user enters a digit, add the digit to the "current" number (this will not be simple addition--see the pattern referenced above)
* If the user enters any non-digit, then
    * If the previous character was a digit, push the "current" number and reset both the "current" number value and any digit tracking state
    * If not, nothing special happens
    * In either case, "normal" non-digit character input processing happens at this point

> **Note:** Do not use `scanf`; it is tempting, but the cake is a lie: `scanf` is *loaded* with subtle, tricky corner cases,
> including some that are basically insurmountable.  Trust me, I'm actually trying to make your life *easier* here...


## Extra Credit Requirements (+10%)

For some extra credit, add support for simple *variables* to your calculator.

For simplicity, your calculator should support only (exactly) 26 32-bit integer variables, named `a` through `z` (all variables start with value 0).

New syntax to parse/interpret:

* `$a` means "push the current value of variable `a` onto the RPN stack"
* `=a` means "pop the top of the RPN stack and store it in variable `a`, overwriting the old value of `a`"

Any non-standard variants (e.g., `$A`, instead of `$a`) can be ignored.  Or you can get fancy and report a syntax error.

# Insane Extra Credit Requirements (+25%)

For the ultimate challenge, rework your calculator to do all math (and store all values) in 32-bit *floating-point*.

For simplicity/sanity, keep your input integer-only.  Output should use the `%f` format specifier.

The best way to do this is to write some C code performing floating point operations (addition, etc.), compile, debug, and look at the disassembly.
Find the floating point instructions (including the supporting ones like convert-int-to-float) and look up the details in the Intel manual.

## Report

Fill out the [standard program report template](/course/bju/content/cps230/downloads/report_template.docx) and submit it along with your assembly using Bitbucket.  If you are not printing a physical copy, make sure to list in the report any help you received.  Help received from the professor does not need to be listed.

# Submission

Use the submission system to submit your code in a single NASM source file named `prog2.asm`.
