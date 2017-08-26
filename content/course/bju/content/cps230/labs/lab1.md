---
layout: page
title: Lab 1
---

# Goals

* Successfully compile and run a provided C program

* Successfully modify/personalize the provided program

* Step through the program in the *Visual Studio* IDE's debugger

* Gain confidence in your ability to compile C code via both the command line and the *Visual Studio* IDE

* **BONUS**: Demonstrate 1337 haxx0r skilz (a.k.a. obsessive-compulsive nerd cred) by stepping through your
    program using the extremely-powerful-but-terrifyingly-cryptic standalone *WinDBG* system debugger
    (affectionately pronounced "wind-bag")

# Getting Started

0. Make sure you have installed Visual Studio 2015 (the Community Edition is sufficient)

1. [Recommendation] Create a new folder to contain all your Lab 1 work (you could name it, e.g., "lab1")

1. Open "your favorite text editor" (e.g., *SciTE*, *Notepad++*, the mighty *Vim*, or the sinister *Emacs*)
    and create a new file named "hello.c" in your Lab 1 folder

1. Paste the following code into "hello.c" and save the file:

    {% highlight c %}
    #include <stdio.h>

    int main() {
        printf("hello, world!\n");
        return 0;
    }
    {% endhighlight %}

# Command-Line Fun

1. Open a **VS2015 x86 Native Tools Command Prompt** window (do *not* use the x64 version; it will "work" but not the way you want).  Like this...

    ![Finding the command prompt...]({{ site.baseurl }}/images/lab1_vs_native_prompt.png)

1. ...and use the `cd` command to navigate to your Lab 1 folder.

    ![Finding your folder...]({{ site.baseurl }}/images/lab1_vs_prompt_cd.png)

1. Run the following command *(don't type the `C> `; that's a placeholder to represent your command prompt)*:

        C> cl hello.c

    That's `cl` as in "cee ell", not "cee one".
    You should see output like the following, culminating in the command prompt appearing again:

        Microsoft (R) C/C++ Optimizing Compiler Version 17.00.61030 for x86
        Copyright (C) Microsoft Corporation.  All rights reserved.

        hello.c
        Microsoft (R) Incremental Linker Version 11.00.61030.0
        Copyright (C) Microsoft Corporation.  All rights reserved.

        /out:hello.exe
        hello.obj

        C> 

    If so, congratulations, you've compiled a C program at the command line!  If *not*, seek experienced help
    immediately (e.g., a lab monitor, a veteran student, or your instructor).  **Don't** try to proceed until
    this step is working!

1. Run the program, like this:

        C> hello

    You should see exactly the following output:

        hello, world!

        C> 

    **Note** that your command prompt (which, again, probably isn't exactly `C> `) appears after a blank line
    following the "hello, world!" bit.

1. Experiment with "hello.c".  After each suggested change, save the file, recompile it, and re-run "hello".
    Restore the file to its original state (i.e., like the original provided code) after each "experiment."

    * What is different about the output when you remove the "\n" from the "hello, world!\n" part?

    * What happens when you remove the quotes surrounding "hello, world!\n"?

    * What happens when you remove one of the parentheses?  One of the curly braces?

    * What happens if you delete the very first line (i.e., the line starting with `#include`)?

1. Personalize your "hello.c" program so that the output looks like this:

        hello, world!

                sincerely,
                Alice B. College-Student (acoll555)

    Unless you happen to be named Alice B. College-Student and/or your BJU login is in fact `acoll555`,
    you will need to change both of those, of course...

# Visual Studio

1. Let's try compiling and debugging your program usinig the **Visual Studio Integrated Development Environment (IDE)**

    * Follow [these instructions]({{site.baseurl}}/notes/visualstudio) to create a new C project in Visual Studio 2015
    
        * When you create your C file, be sure to name it `hello.c` for consistency here

        * Paste into your new `hello.c` the contents of your old `hello.c` file and save

    * Click in the "gutter" to the left of the code next to the `int main() {` line; a solid red circle
        should appear in the gutter next to that line, indicating you have set a breakpoint there (see the screenshot)

        ![Setting a breakpoint]({{site.baseurl}}/images/lab1_vs_breakpoint.png)

    * Click the "Run" button (i.e., the big green "play" button) to run the program in debug mode

    * The debugger should freeze the program with a yellow arrow pointing at your breakpoint!

    * Experiment; use the "step into" and "step over" buttons to single-step through your code several times

    * Finally, re-run your program in the debugger, stopping it at `int main() {`

    * Now select the `Debug->Windows->Disassembly` option to turn on the disassembly view:

        * Right click in the Disassembly view and make sure that all the "Show" options are enabled/selected

        * Note the "disassembled instruction" lines, containing an *address* (in hexadecimal), a series
            of *instruction bytes* (also in hex), and then a "human readable" (haha) assembly code statement

        * Note that each line of C source code may result in 0, 1, or *many* lines of machine/assembly code

        * Step through your program in Disassembly view; notice that you can now advance *machine instruction by machine instruction*
            instead of just *line by line*

> **Note**
>
> You can also use Visual Studio to debug EXE files you created at the command line (like you created with `cl` at the beginning
> of the lab).  See how [in this MSDN How-To article](https://msdn.microsoft.com/en-us/library/0bxe8ytt.aspx).
>
> For best results, you should compile your EXE with the `/Zi` flag (e.g., `cl /Zi hello.c`) to make
> sure it has debugging information embedded in it.

# For 1337 haxx0rs Only

1. Use your favorite search engine to find out how to download and install WinDBG (or find it on the CSLAB workstations).

    * Download it *from Microsoft* (don't trust random websites offering you debuggers)

    * Be aware that Microsoft *no longer makes WinDBG available as a separate product*; you must download
        an SDK installer that offers to install 5 kitchen sinks and 2 dishwashers in addition to "debugging tools for windows" (that's WinDBG),
        but you can safely uncheck all that extra unneeded stuff and install *only* WinDBG and friends

1. Launch the x86 version of WinDBG (the x64 version will work, but it will show you things you are not ready to see; avoid it for now).
    
1. WinDBG knows nothing about projects, only EXE files (and maybe their source code, if it's available)

    * Use `File / Open Executable...` to find and open your EXE file

    * Use `File / Open Source File...` to find and open `hello.c`

    * In the source view, click on a line of code to place the cursor there, then press the **F9** key to set a breakpoint on that line

    * Press **F5** to run the program (it may break before hitting your breakpoint; if it does, just press **F5** again)

1. Experiment with the rather . . . *special* . . . WinDBG user interface.  See if you can find/arrange the necessary debugging windows to match the following screenshot:

    ![Using WinDBG like a 1337 haxx0r b055]({{ site.baseurl }}/images/lab1_windbg.png)

1. Now experiment with running/stepping through your program.  See if you can retrace all the steps you took in Visual Studio (your search engine is your friend).

1. Be sure to provide screen shots documenting what you were able to achieve using WinDBG in your report! 

# Report

For this and all subsequent labs (unless otherwise indicated), you will turn in an electronic lab report.

I accept neatly formatted reports in the following formats:

* Pandoc Markdown (`*.md`) *[the simple plain text format I used to create these instructions]*
* Microsoft Word (`*.docx`) *[which can be generated from Markdown using Pandoc]*
* Adobe PDF (`*.pdf`)

Any other format will be ignored (i.e., if you submit anything else, you officially did not submit a report).  Bletcherously sloppy/unreadable reports may be similarly ignored.

Follow the format established by the standard lab report template, available in:

* [Pandoc Markdown]({{site.baseurl}}/downloads/lab_report_template.md)
* [Microsoft Word (DOCX)]({{site.baseurl}}/downloads/lab_report_template.docx)

If you need to include any images (e.g., screenshots) in your report, you *must* submit either a `*.docx` or a PDF so that your report comprises a single file.

# Submission

Submit the following files to your Lab 1 submission repository:
- `report.md` (or `report.docx`, or `report.pdf`)
- `hello.c` (with any/all modifications made)

See [this]({{ site.baseurl}}/notes/submission) for information about how to do that.

# Grading

* 10 points: completion and presentation