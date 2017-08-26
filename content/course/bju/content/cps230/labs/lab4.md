---
layout: page
title: Lab 4
---

# Overview

Welcome to assembly programming!  In this lab, you will experiment with and [slightly] modify a provided assembly program.

# Procedure

Before starting, make sure you have the required tools:

* NASM 2.x
* Visual Studio 2015 with C++ tools installed

## Orientation
 
Download and familiarize yourself the [starting code]({{site.baseurl}}/downloads/lab4.asm).  Go ahead and change the comments at the top to reflect your identity.

> **Pro Tip**: You should always have an identifying comment at the top of any ASM files you submit!

Compare the starting ASM program to its equivalent version in C:

~~~~ c
#include <stdio.h>

unsigned int the_integer = 0;

int main() {
	printf("Please enter an integer: ");
	scanf("%d", &the_integer);
	
	the_integer += the_integer;
	
	printf("Your number added to itself is: %d\n", the_integer);
	
	return 0;
}
~~~~

Try to identify (without the aid of any compilers/tools) which lines of C correspond to which lines of ASM.  Are there ASM lines that don't seem to correspond to anything in the C program?  What about vice-versa?


## Assembling

Just like C code has to be *compiled* in order to run, so assembly code must be *assembled* in order to run.  We'll be using an assembler called NASM (the Net-wide Assembler).

* Open a NASM command prompt (search for `nasm-shell` in the Start menu)

* Navigate to the folder where you saved `lab4.asm` using the `cd` command (revisit [Lab 1]({{site.baseurl}}/labs/lab1) if you need reminders on how that works)

* Run the following command (again, don't type the `C> ` part):

        C> nasm -g -fwin32 lab4.asm
        
        C>

* You shouldn't see any output at all (other than the command prompt reappearing); **if you do, seek experienced help immediately**

* The line you just typed breaks down into several components:

    * `nasm`: we're running NASM, of course
    * `-g`: option/flag telling NASM to include debugging information in the output *object file*
    * `-fwin32`: option/flag telling NASM to generate an *object file* compatible with 32-bit Windows tools (like Visual Studio)
    * `lab4.asm`: the file to assemble (NASM will generate an output *object file* named `lab4.obj`)

* Run the `dir` command; you should now see a `lab4.obj` file in addition to `lab4.asm`; congratulations, you've assembled the program into an *object file*

## Linking

Your *object file* is not actually executable yet--it needs to be *linked* with some other stuff before it can run.  We'll use the Visual Studio command-line tools for this part.

Either

* Open a Visual Studio 2015 **x86** native tools command prompt (as you've done before) and navigate to your Lab 4 folder, *OR*
* Run the following command in your already-open NASM command prompt window (this has the effect of turning your NASM command prompt into a hybrid NASM/Visual Studio command prompt; cool, huh?)

        C> "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"

Now that you can run `cl` (remember: `cee-ell`, not `cee-one`!), do this

        C> cl /Zi lab4.obj msvcrt.lib legacy_stdio_definitions.lib

Let's break down that line into its components:

* `cl`: run the Visual Studio C/C++ *compiler driver* (normally used to compile C/C++ code, but here just being used to trigger linking)
* `/Zi`: an option flag telling `cl` to include debugging metadata in the resulting EXE file
* `lab4.obj`: the object file containing our code/data
* `msvcrt.lib`: the Micrsoft Visual C/C++ Run-Time library (containing all the extra "stuff" needed to get a runnable program)
* `legacy_stdio_definitions.lib`: a compatibility library needed when calling `printf` and `scanf` from assembly code

## Running

Run the program in your console window (just type `lab4` and hit `Enter`), experimenting with different inputs.

What happens if you enter `fred` instead of a number?

## Debugging

You can debug your EXE file in Visual Studio by

* Selecting "Open Project" from the File menu...
* ...and selecting your `lab4.exe` file as the "project".  Unfortunately, this won't open your source code automatically, so...
* ...open your `lab4.asm` source code file by selecting the `File / Open / File...` menu option.

**Wait!** Don't try to debug it yet.  Visual Studio is pretty clueless about assembly programs (I guess we can't blame it--support for source-debugging of ASM programs is probably not high on their list of requested features...),
so we need to help it out.  Open the `Debug / Options` menu option, select `Debugging / General` in the list box on the *left*, and find the `Use Native Compatibility Mode` option in the list box on the *right*.  Make sure the
checkbox next to that option is checked/filled-in!  Like this:

![Turning on debugging support]({{site.baseurl}}/images/vs_debug_native.png)

*Now* try setting a breakpoint in your `lab4.asm` code and clicking the `Debug` button to kick off your program!

> FWIW, WinDBG does not require any special settings, and it also features nice syntax-highlighting for ASM source code, making it an attractive alternative for debugging NASM-assembled programs... ;-)

## Personalizing

Pay close attention to how the program calls `printf`.  Notice several things:

* The format string must be defined elsewhere (e.g., in the `.data` section) and must have a label so we can refer to it
* Arguments are `push`ed one at a time, and in reverse order (if there are more than one) before the `call` instruction
* For some reason we're spelling `printf` as `_printf` in here!
* And for every argument `push`ed before the `call`, we must perform a `pop` to "clean up the stack" after the call (in this case, the program uses a `pop eax` for each argument)

Now, **add the necessary code/data to print your name/etc.** *before* the prompt asking for an integer is printed.  The output should now look like this (prior to any user input):

        CpS 230 Lab 4: Alice B. College-Student (acoll555)

        Please enter an integer: 

With, of course, the appropriate modifications to the name/login. :-)

# Report

Document your completion of the lab, including

* Assembling and running the program
* Stepping through the program with a debugger (either VS or WinDBG)
* Modifying the program to print your name/information

# Submission

Submit your completed `lab4.asm` and your report file, which must be named either:

* `report.md` (plain-text Markdown file)
* `report.docx` (Microsoft Word file)
* `report.pdf` (Adobe PDF file)

Case matters. :-)

# Grading

* 6 points for a well-formed submission (including report)
* 4 points for a working `lab4.asm` 

