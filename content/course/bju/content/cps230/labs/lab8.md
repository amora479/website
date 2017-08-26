---
layout: page
title: Lab 8
---

# Overview

Welcome to assembly programming *for DOS*!  As we turn downwards toward the "bare metal" of the hardware, we will study
the architecture of the classic PC (IBM Model 5150 and compatibles).  Our first step on the road to "zero-operating-system"
programming is to write programs that work under DOS on a vintage IBM PC (or rather, a simulated DOS on a simulated IBM PC,
as provided by DOSBox).

In this lab, you will extend a provided 16-bit assembly program for DOS.

# Procedure

Before starting, make sure you have the required tools:

* NASM 2.x
* [DOSBox 0.74 (with integrated system debugger)]({{site.baseurl}}/downloads/dbd.zip)

## Orientation
 
Download and familiarize yourself the [starting code]({{site.baseurl}}/downloads/lab8.asm).  Go ahead and change the comments at the top to reflect your identity.

Compare this starting code to the starting code from [Lab 4]({{site.baseurl}}/labs/lab4).  Besides the fact that the programs do different things (one reads a number,
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

We will use a version of DOSBox that has an integrated debugger window.  With it you can freeze the entire simulated computer, inspect/edit memory,
step through code instruction by instruction, and basically control everything (even tricky things like interrupts).

## Running

In your Windows console, type the following command (if you installed DOSBox somewhere else, change this accordingly):

        C> \cps230\bin\dbd.exe .

        C>

**PAY ATTENTION to the period!**  With it, DOSBox will automatically "mount" the current working directory as the simulated PC's `C:` drive.
Without, you'll have to arrange that yourself by typing special DOSBox commands at the DOSBox prompt.

This should open 2 new windows: one that looks like a console window (with a command prompt), and the other full of cryptic looking text and numbers (that's the debugger).

For now, ignore the debugger and focus on the console.  **Inside the DOSBox console**, type the following command:

        C:\>lab8.com

The program should run, print a prompt message, and immediately terminate.

## Debugging

Now let's turn to debugging.  Type the following into your DOSBox console window:

        C:\>debug lab8.com

Everything should freeze.  That's because the debugger is waiting for your input!  Select the *other* DOSBox window.  It should look like this:

![The DOSBox Debugger Window]({{site.baseurl}}/images/lab8_debugger_annotated.png)

Type `help` and press Enter.  You can see the output in the lower window pane; you can scroll it up and down (to read it all) with the `Home` and `End` keys.

Find the information about how to single step/etc.  Experiment!  In particular, figure out how to display the contents of memory at a given
address (in the hex-dump pane near the top of the debugger window).


## Personalizing

**Add the necessary code/data to print your name/etc.** *before* the prompt asking for your name is printed.  The output should now look like this (prior to any user input):

        CpS 230 Lab 8: Alice B. College-Student (acoll555)

        What is your favorite letter? 

With, of course, the appropriate modifications to the name/login. :-)

## Completing

**Find the TODO comments** and complete the listed tasks.  You will want to linked "HelpPC" resources most useful here.

# Report

Document your completion of the lab, including

* Assembling and running the program
* Modifying the program to print your name/information
* Finishing the program (completing the TODOs)
* Stepping through the program with the DOSBox debugger


# Submission

Submit your completed `lab8.asm` and your report file, which must be named either:

* `report.md` (plain-text Markdown file)
* `report.docx` (Microsoft Word file)
* `report.pdf` (Adobe PDF file)

Case matters. :-)

# Grading

* 5 points for a well-formed submission (including report)
* 5 points for a working/personalized `lab8.asm` 

