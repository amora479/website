---
title: "CPS 230 Lecture 10"
---

# Lecture 9: Control Flow in Assembly (While Statements)

## While Statements

Just like if statements, while loops have a basic structure consisting of a few labels.  However, whiles have less labels than ifs since the structure is a bit easier.

``` asm
_while:
	... perform condition check ...
	... if true, jump to _true_part ...
	... jump to _false_part ...
_true_part:
	... body ...
	... jump to _while ...
_false_part:
```

## Do-While Statements

The difference between a while and a do while in C is that, with a do while, your body is guaranteed to execute once, whereas in a while, the body might never be run.

``` c
while(x != 0) {
	--x;
}

do {
	--x
} while (x != 0);
```

The do while structure in assembly uses even few labels than the while!

``` asm
_do_while:
	... body ...
	... perform condition check ...
	... if false, jump to _false_part ...
	... jump to _do_while ...
_false_part:
```