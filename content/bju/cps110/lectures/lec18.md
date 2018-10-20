---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Command Line Basics

The command line is a useful tool that will you use throughout the remainder of your CS career.  Thus far, we've basically used it for running Python and pytest (and maybe installing a few Python modules).  However, there are a ton of useful command line utilities that exist.  There are tools for searching files.  There are also tools for tracing which computers you route through to reach a website.

Ultimately, all commands in Python fall under the same basic syntax.

```cmd
command argument1 argument2 ... argumentN
```

You first type the name of the command then provide any required or needed arguments.  Think of like calling a function except this function is actually a runnable program.

## Streams

Any open file in Python is a stream, but there exist three default streams: STDIN, STDOUT, and STDERR.  STDIN is the default input stream and we've already seen how to read from STDIN.  Just use the `input()` function.  Same for STDOUT, you can print to it with with just `print()`.  However, since these are streams, you can also read and write to the streams like you would any file.

```py
import sys

variable = sys.stdin.read()
sys.stdout.write(variable)
```

STDERR is a bit new.  STDERR is the stream for printing error messages.  To print to it, you can use `.write()` as in `sys.stderr.write()` or you can also use print, but print needs an additional argument.

```py
import sys

print("An error occurred", file = sys.stderr)
```

## Redirection

On the command line, you can cause your input to come from a file rather than having to type the input each time.  This is super useful for testing!  Simply use the `<`.  Note that `<` must come at the end of the line after all of the arguments.  The filename also comes after the `<`.  So it looks like this.

```cmd
command argument1 argument2 ... argumentN < someFile.txt
```

Just like you can redirect input, you can redirect output.  Just use `>` instead.

```cmd
command argument1 argument2 ... argumentN > someFile.txt
```

You can even do both at the same time.

```cmd
command argument1 argument2 ... argumentN > someFile.txt < someOtherFile.txt
```

Redirecting STDERR though is a bit more tricky, but not much.  Use `2>` instead.

## Reading Arguments

All of this is kinda moot if we don't look at how to read arguments in Python.  There is a variable in `sys` called `argv` that holds any arguments passed to your Python file.

> WARNING: The first argument of this list will always be the name of the Python file not the first argument.  Arguments start at index 1.  This means that a list will always have 1 element so if you need 3 arguments, make sure you actually have 4.

The typical method of ensuring you have arguments is to check the length of the list at the very beginning of the program and print a helpful error message to STDERR and exit if you don't have enough.

```py
import sys

if len(sys.argv) < 3:
    print("You didn't give me two numbers to add", file = sys.stderr)
    print("Usage: python add.py <number1> <number2>", file = sys.stderr)
    sys.exit()

argument1 = sys.argv[1] # first argument is at 1
argument2 = sys.argv[2] # second argument is at 2
print(int(argument1) + int(argument2))
```