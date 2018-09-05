---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Lab 1

## Goals

* Successfully compile and run a provided C program
* Successfully modify/personalize the provided program
* Gain confidence in your ability to compile C code via both the command line and the *Visual Studio* IDE
* Use the *WinDBG* system debugger (affectionately pronounced "wind-bag")

## Getting Started

1. Make sure you have installed Visual Studio 2017 (the Community Edition is sufficient) as well as the [Build Tools](https://www.visualstudio.com/downloads/#build-tools-for-visual-studio-2017).

1. [Recommendation] Create a new folder to contain all your Lab 1 work (you could name it, e.g., "lab1")

1. Open "your favorite text editor" (e.g., *Visual Studio Code*, *Atom*, *Notepad++*, the mighty *Vim*, or the sinister *Emacs*) and create a new file named "hello.c" in your Lab 1 folder

1. Paste the following code into "hello.c" and save the file:

    ```
    #include "stdio.h"

    int main() {
        printf("hello, world!\n");
        return 0;
    }
    ```

## Command-Line Fun

1. Open a **x64 Native Tools Command Prompt for VS 2017** window. Like this...

    ![Start Menu](/bju/cps230/homework/lab1-images/start-menu.png)

1. ...and use the `cd` command to navigate to your Lab 1 folder. *(don't type the `C> `; that's a placeholder to represent your command prompt)*

    ``` cmd
    C> cd "C:\Users\emcgee\Documents\CPS 230\lab1"
    ```

1. Run the following command:

    ``` cmd
    C> cl hello.c
    ```

    That's `cl` as in "cee ell", not "cee one".
    You should see output like the following, culminating in the command prompt appearing again:

        Microsoft (R) C/C++ Optimizing Compiler Version 19.13.26132 for x64
        Copyright (C) Microsoft Corporation.  All rights reserved.

        hello.c
        Microsoft (R) Incremental Linker Version 14.13.26132.0
        Copyright (C) Microsoft Corporation.  All rights reserved.

        /out:hello.exe
        hello.obj

        C> 

    If so, congratulations, you've compiled a C program at the command line!  If *not*, seek experienced help immediately (e.g., a lab monitor, a veteran student, or your instructor).  **Don't** try to proceed until this step is working!

1. Run the program, like this:

        C> hello

    You should see exactly the following output:

        hello, world!

        C> 

    **Note** that your command prompt (which, again, probably isn't exactly `C> `) appears after a blank line following the "hello, world!" bit.

1. Experiment with "hello.c".  After each suggested change, save the file, recompile it, and re-run "hello". Restore the file to its original state (i.e., like the original provided code) after each "experiment."

    * What is different about the output when you remove the "\n" from the "hello, world!\n" part?

    * What happens when you remove the quotes surrounding "hello, world!\n"?

    * What happens when you remove one of the parentheses?  One of the curly braces?

    * What happens if you delete the very first line (i.e., the line starting with `#include`)?

1. Personalize your "hello.c" program so that the output looks like this:

        hello, world!

        sincerely,
        Alice B. College-Student (acoll555)

    Unless you happen to be named `Alice B. College-Student` and/or your BJU login is in fact `acoll555`, you will need to change both of those.

## Visual Studio

1. Let's try compiling and debugging your program usinig the **Visual Studio Integrated Development Environment (IDE)**

    * Follow [these instructions](/bju/cps230/info/visual-studio) to create a new C project in Visual Studio 2017
    
        * When you create your C file, be sure to name it `hello.c` for consistency here

        * Paste into your new `hello.c` the contents of your old `hello.c` file and save

    * Click in the "gutter" to the left of the code next to the `int main() {` line; a solid red circle should appear in the gutter next to that line, indicating you have set a breakpoint there (see the screenshot)

        ![Setting a breakpoint](/bju/cps230/homework/lab1-images//breakpoint.png)


    * Click the "Run" button (i.e., the big green "play" button) to run the program in debug mode (but change the dropdown to x64 first).

        ![Running](/bju/cps230/homework/lab1-images//running.png)

    * The debugger should freeze the program with a yellow arrow pointing at your breakpoint!

    * Experiment; use the "step into" and "step over" buttons to single-step through your code several times

    * Finally, re-run your program in the debugger, stopping it at `int main() {`

    * Now select the `Debug->Windows->Disassembly` option to turn on the disassembly view:

        * Right click in the Disassembly view and make sure that all the "Show" options are enabled/selected

        * Note the "disassembled instruction" lines, containing an *address* (in hexadecimal), a series of *instruction bytes* (also in hex), and then a "human readable" (haha) assembly code statement

        * Note that each line of C source code may result in 0, 1, or *many* lines of machine/assembly code

        * Step through your program in Disassembly view; notice that you can now advance *machine instruction by machine instruction* instead of just *line by line*

## WinDBG System Debugger

Visual Studio is not the only debugger on the block.  As a matter of fact, you'll only be able to use it for debugging C code.  When we get to Assembly, you'll need to swap over to WinDBG.  So it is best to start getting some experience with it early.

1. Use your favorite search engine to find out how to download and install WinDBG (or find it on the CSLAB workstations).

    * Download it *from [Microsoft](https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk)* (don't trust random websites offering you debuggers)

    * Be aware that Microsoft *no longer makes WinDBG available as a separate product*; you must download an SDK installer that offers to install 5 kitchen sinks and 2 dishwashers in addition to "debugging tools for windows" (that's WinDBG), but you can safely uncheck all that extra unneeded stuff and install *only* WinDBG and friends

1. Launch the x64 version of WinDBG., usually found under `C:\Program Files (x86)\Windows Kits\10\Debuggers\x64`.
    
1. WinDBG knows nothing about projects, only EXE files (and maybe their source code, if it's available)

    * Using the command line again, recompile your hello.c file with `cl /Zi hello.c`.  This recompiles the exe with debugging information enabled (so that WinDBG actually shows you something other than gibberish).
    * Use `File / Open Executable...` to find and open your EXE file
    * Use `File / Open Source File...` to find and open `hello.c`
    * In the source view, click on a line of code to place the cursor there, then press the **F9** key to set a breakpoint on that line
    * Press **F5** to run the program (it may break before hitting your breakpoint; if it does, just press **F5** again)

1. Experiment with the rather ... *special* ... WinDBG user interface.  See if you can find/arrange the necessary debugging windows to match the following screenshot:

    ![Using WinDBG](/bju/cps230/homework/lab1-images/windbg.png)

1. Now experiment with running/stepping through your program.  See if you can retrace all the steps you took in Visual Studio (your search engine is your friend).

1. Be sure to provide screen shots documenting what you were able to achieve using WinDBG in your report! 

# Report

For this and all subsequent labs (unless otherwise indicated), you will turn in an electronic lab report.

I accept neatly formatted reports in the following formats:

* Microsoft Word (`*.docx`)
* Adobe PDF (`*.pdf`)

Follow the format established by the standard lab report template, available in:

* [Microsoft Word (DOCX)](/bju/cps230/downloads/lab_report_template.docx)

## Submission

Submit the following files to your Lab 1 folder in your Bitbucket repository:

- `report.docx` or `report.pdf`
- `hello.c` (with any/all modifications made)

## Grading

* 10 points: completion and presentation