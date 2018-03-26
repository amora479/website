---
title: "CPS 230 Lab 8"
---

# Lab 8
## Overview

Welcome to assembly programming *for DOS*!  As we turn downwards toward the "bare metal" of the hardware, we will study
the architecture of the classic PC (IBM Model 5150 and compatibles).  Our first step on the road to "zero-operating-system"
programming is to write programs that work under DOS on a vintage IBM PC (or rather, a simulated DOS on a simulated IBM PC,
as provided by DOSBox).

In this lab, you will extend a provided 16-bit assembly program for DOS.

## Procedure

Before starting, make sure you have the required tools:

* NASM 2.x
* [DOSBox-X (with integrated system debugger)](/course/bju/content/cps230/downloads/dosbox-x.exe)

## Orientation
 
Download and familiarize yourself the [starting code](/course/bju/content/cps230/downloads/lab8.asm).  Go ahead and change the comments at the top to reflect your identity.

Compare this starting code to the starting code from [Lab 4](/course/bju/content/cps230/labs/lab4).  Besides the fact that the programs do different things (one reads a number,
the other doesn't read anything \[yet\]), what significant syntactic differences do you notice?  *Summarize in your report...*

## Assembling

In addition to support for generating Win32 PE/COFF files, NASM can generate "flat" binary files (no sections, no symbol tables, no nothing--just code/data bytes).
We will use this capability to generate classic "COM" files, the simplest and most primitive kind of DOS executable file.

* Open a NASM command prompt (search for `nasm-shell` in the Start menu)

* Navigate to the folder where you saved `lab8.asm`

* Run the following command (again, don't type the `C> ` part):

        C> nasm -fbin -olab8.com lab8.asm
        
        C>

* The line you just typed breaks down into several components:

    * `nasm`: we're running NASM, of course
    * `-fbin`: option/flag telling NASM to generate a flat binary file (no metadata of any kind--in this case, NASM is acting like its own linker, too)
    * `-olab8.com`: name our output file `lab8.com`
    * `lab8.asm`: the file to assemble

## DOSBox

You cannot run your `.com` file in your Windows console (unless you are running a 32-bit version of Windows, which you almost certainly are not).

You will use a wonderful open source program called DOSBox to run this and all other 16-bit programs you write.  DOSBox simulates:

* An x86 CPU (including support for 32-bit processors like the 386 and 486)
* Classic PC graphics and sound hardware (like VGA, Soundblaster, and Adlib)
* Enough of the original IBM BIOS firmware and MS-DOS APIs to run most old DOS software

DOSBox's primary purpose is to run vintage DOS games, but it has proven surprisingly useful at keeping ancient business software alive, too.

We will use a version of DOSBox that has an integrated debugger window, DOSBox-X.  With it you can freeze the entire simulated computer, inspect/edit memory, step through code instruction by instruction, and basically control everything (even tricky things like interrupts).

## Running

Open the dosbox-x.exe file located at `C:\dosbox\`.

This should open a new window that looks like a console window (with a command prompt).  The debugger won't open just yet.

We need to get your `.com` file inside of DOSBox so we can execute it. Make a note of which drive DOSBox-X is currently using.  You can find out by looking at the letter at the start of the prompt, which usually looks like:

        Z:\>

This means the Z drive is currently in use so we need to use another one.  Under the drive menu, pick anyone **except the one you just noted**.  (I'll use C)  Select _Mount as Hard Disk_ under that drive and then, in the menu that appears, select the folder containing your `.com` file.

Now, we need to switch to this new drive.  To do so, **in DOSBox**, type the drive letter followed by a colon, i.e. `C:`, then press enter. **This should change the letter at the beginning of the prompt**.

You should be able to run your `.com` now by typing the name of the file and the extension in the DOSBox prompt.

        C:\>lab8.com

The program should run, print a prompt message, and immediately terminate.

## Debugging

Now let's turn to debugging.  There are two debuggers built into DOSBox-X, a very old debugger from the DOS era and a new graphical one.  We'll use the graphical one since it is a bit easier and the layout is more familiar. Type the following into your DOSBox console window:

        C:\>debugbox lab8.com

Everything should freeze.  That's because the debugger is waiting for your input!  Select the *other* DOSBox window that appeared.  It should look like this:

![The DOSBox Debugger Window](/course/bju/content/cps230/images/lab8_debugger_annotated.png)

Type `help` and press Enter.  You can see the output in the lower window pane; you can scroll it up and down (to read it all) with the `Home` and `End` keys.

A few pointers to get you started:

* `Up Arrow / Down Arrow` should change the line of assembly that you are on.
* `F9` will set a breakpoint
* `F10` will step over the current instruction
* `F11` will follow a call statement to the function your are jumping to
* `F5` will continue execution until termination or the next breakpoint
* `Page Up / Page Down` will scroll through memory (but memory addresses work differently in DOS)

Experiment!  In particular, figure out how to jump to a specific memory address (in the hex-dump pane near the top of the debugger window).

## Personalizing

**Add the necessary code/data to print your name/etc.** *before* the prompt asking for your name is printed.  The output should now look like this (prior to any user input):

        CpS 230 Lab 8: Alice B. College-Student (acoll555)

        What is your favorite letter? 

With, of course, the appropriate modifications to the name/login. :-)

## Completing

**Find the TODO comments** and complete the listed tasks.  You will want to linked "HelpPC" resources most useful here.

## Report

Document your completion of the lab, including

* Assembling and running the program
* Modifying the program to print your name/information
* Finishing the program (completing the TODOs)
* Stepping through the program with the DOSBox debugger

If you are not printing a physical copy, make sure to list in the report any help you received as well as a statement that all work is your own.  Help received from the professor does not need to be listed. The electronic report should be submitted along with your code.

If you are printing out your report, staple one of the department honesty sheets to the top listing the help received on the sheet.  Turn this printed report in at the beginning of the class period after the due date.

## Submission

Submit your completed `lab8.asm` and your report file, which must be named either:

* `report.docx` (Microsoft Word file)
* `report.pdf` (Adobe PDF file)

## Grading

* 5 points for a well-formed submission (including report)
* 5 points for a working/personalized `lab8.asm` 

