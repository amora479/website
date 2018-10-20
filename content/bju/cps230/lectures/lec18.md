---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 18: Multi-Language Compilation

When coding in C and Assembly, it is possible to interleave the languages programming things in the language that suits the task best.

## C In Assembly

In older architectures, it's actually possible to directly write assembly inside of C, unfortunately, this isn't the case for 64-bit assembly. You must compile the C as a separate obj file and then link the C obj file to the Assembly obj file.  You'll get some experience doing this in lab 7.

To create an object file from C instead of an exe, use the `/c` option.  For example, say you have a file named sample.c.  To create sample.obj, run the following command: `cl /Z sample.c`.

To link obj files, you simply use the `/Zi` option we have been using all along.  For example `cl /Zi main.obj sample.obj msvcrt.lib legacy_stdio_definitions.lib`.
