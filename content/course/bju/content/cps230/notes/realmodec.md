# Writing DOS Programs in Real Mode C

## Getting and Building BCC (Bruce's C Compiler)

There aren't many C compilers left that produce native 8086, and there certainly aren't any that support all of the current C standard.

However, there are some compilers that support a subset of C (known as K&R C) that produce 8086 and support inline assembly (to write to the screen).

[BCC](https://github.com/lkundrak/dev86/) is one such tool, but you'll need to download, compile and install on Windows.

Here are the steps.

1. Download and install [Cygwin](https://cygwin.com).  During the install process, you are going to be asked which libraries to install.  Select `automake`, `autoconf`, `gcc-g++`, `git` and `make`.
1. Cygwin's make does not like spaces in directory names so `cd ..` into the `home` folder.  Check to see if there are spaces in your username.  If yes, create another folder within the home folder and use the new directory instead of the one autocreated by Cygwin.
1. Open a cygwin shell and clone the the bcc compiler using `git clone https://github.com/lkundrak/dev86.git`.
1. `cd` into the `dev86` directory that was created and run the command `make` to compile and build. When asked which options, just type `quit` as the default are fine.
1. You might have received an error about strtol missing in the previous step, that's okay, finish installation by running `make install`.

## Writing a Real-Mode C Program

The easiest thing to do is write your C files in the `C:\cygwin[64?]\home\<username>` directory you created a moment ago.  This way you can continue using Cygwin for compilation easily.

Below is an example real-mode C program that draws a line that bounces at 45 degree angles to the screen using graphics mode.

```c

```
