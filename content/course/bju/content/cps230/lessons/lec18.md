---
title: "CPS 230 Lecture 18"
---

# Lecture 18: Multi-Language Compilation

When coding in C and Assembly, it is possible to interleave the languages programming things in the language that suits the task best.

## C In Assembly

It is possible, and actually very easy, to just embed assembly directly into your C file.  To do so simply use an `__asm` block like so:

``` c
int sum(int a, int b, int c) {
	int result = 0;

	__asm {
		mov eax, a
		add eax, b
		add eax, c
		mov result, eax
	};

	return result;
}
```

## C / Assembly Separated

Unfortunately, it isn't so easy to put C into an Assembly file.  You must compile the C as a separate obj file and then link the C obj file to the Assembly obj file.

To create an object file from C instead of an exe, use the `/c` option.  For example, say you have a file named sample.c.  To create sample.obj, run the following command: `cl /Z sample.c`.

To link obj files, you simply use the `/Zi` option we have been using all along.  For example `cl /Zi main.obj sample.obj msvcrt.lib legacy_stdio_definitions.lib`.