---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 11: The Stack

## What is a stack?

Stacks are a FILO (First In Last Out) data structure, as opposed to a FIFO (First In First Out) data structure.  What this means is the first thing you put onto a stack will be the last thing that gets removed.  Stacks, in general, have 3 operations that are possible with them.

``` c
push(x) // pushes an object onto the stack
x = pop() // removes the top object from the stack and returns it
x = peek() // returns the top object without removing it
```

Stacks grow "up", meaning that each newly pushed item sits on top of the last item pushed.  In general, stacks are defined for a specific data structure (like ints, char \*, etc.).  Once defined, only items of that type can be inserted onto that stack.  This ensures that each item on the stack is of equal size.

## The Assembly (Program) Stack

The stack available to assembly programs allows you to push and pop 64-bit integers.  (Side note:  You can actually push and pop smaller quantities, and there are specific assembly instructions to accomplish this.  Don't use these unless you are absolutely sure what you are doing.  Mixing these alternative push / pop commands with traditional 64-bit push / pops can wreak havoc on your program's ability to execute properly.)

The stack in assembly starts at the highest level of memory and grows down.  This means that new items are actually inserted below the old ones (which can be confusing at first).  The address of the top of the stack is referenced by `RSP` register.

The push and pop commands are really just aliases for a set of simpler commands.

``` asm
push: register / memory: param
  sub rsp, 8
  mov [rsp], param

pop: register / memory: param
  mov param, [rsp]
  add rsp, 8
```

This is why it is possible to pop several things at once by adding a multiple of 8 to RSP.  With this being said, it should be fairly obvious, but still should be stated.  *DO NOT EVER MANUALLY SET RSP.* You can add and subtract RSP without incident, but manually overriding to another value can cause serious issues as the top of your stack will now be elsewhere with possibly no way to restore it.

## Using the Stack for Expressions

The stack is used for a great many things.  We've already seen it used to pass parameters to functions (more on that next lecture), and it can also be used for complex expression evalution.  Consider this expression: `x * 3 / 45 + y - z % a`.  Where should we put the intermediate values?  Where should we put the variables?  We can use the stack to hold intermediate values (as well as initial).  Note: This approach works, but is considered slow.  If you have a simple expression with no intermediates (or just 1 or 2 intermediates), just do everything in registers without the stack.

The first step is to convert your expression to RPN (method below): `x 3 * 45 / y + z a % -`.  Now we can simply read across.  If the item is a variable or integer, push it onto the stack.  If the item is an operation, pop two items off the stack into registers (depending on the operand), and push the result.  When done, the item at the top of the stack will be the result.

``` asm
; I assume all variables are globals
; x
push [x]
; 3
push 3
; *
pop rbx ; 3
pop rax ; x
imul rbx
push rax ; 3 * x
; 45
push 45
; /
pop rbx ; 45
pop rax ; 3 * x
cdq ; remember, we have to extend eax into edx so our dividend is twice the size of the divisor
idiv rbx
push rax ; 3 * x / 45
; y
push [y]
; +
pop rbx ; y
pop rax ; 3 * x / 45
add rax, rbx
push rax ; 3 * x / 45 + y
; z
push [z]
; a
push [a]
; %
pop rbx ; a
pop rax ; z
cdq ; remember, we have to extend eax into edx so our dividend is twice the size of the divisor
idiv rbx
push rdx ; remember, edx contains the divisor
; -
pop rbx ; z % a
pop rax ; 3 * x / 45 + y
sub rax, rbx
push rax ; 3 * x / 45 + y - z % a
```

## Converting to RPN (The Shunting-Yard Method)

``` text
while there are tokens to be read:
  read a token.
  if the token is a number, then push it to the output queue.
  if the token is an operator, then:
    while there is an operator at the top of the operator stack with greater than or equal to precedence and the operator is left associative:
      pop operators from the operator stack, onto the output queue.
    push the read operator onto the operator stack.
  if the token is a left bracket (i.e. "("), then:
    push it onto the operator stack.
  if the token is a right bracket (i.e. ")"), then:
    while the operator at the top of the operator stack is not a left bracket:
      pop operators from the operator stack onto the output queue.
    pop the left bracket from the stack.
    /* if the stack runs out without finding a left bracket, then there are mismatched parentheses. */
if there are no more tokens to read:
  while there are still operator tokens on the stack:
    /* if the operator token on the top of the stack is a bracket, then there are mismatched parentheses. */
    pop the operator onto the output queue.
exit.
```

| Token | Action | Output | Stack |
| --- | --- | --- | --- |
| x | Push `x` into output | | |
| * | Push `*` into stack | `x` | |
| 3 | Push `3` into output | `x` | `*` |
| / | Push `*` from stack into output | `x 3` | `*` |
| | Push `/` into stack | `x 3 *` |  |
| 45 | Push `45` into output | `x 3 *` | `/` |
| + | Pop `/` from stack into output | `x 3 * 45` | `/` |
|  | Push `+` into stack | `x 3 * 45 /` |  |
| y | Push `y` into output | `x 3 * 45 /` | `+` |
| - | Push `+` from stack into output | `x 3 * 45 / y` | `+` |
|  | Push `-` into stack | `x 3 * 45 / y +` |  |
| z | Push `z` into output | `x 3 * 45 / y +` | `-` |
| % | Push `%` into stack | `x 3 * 45 / y + z` | `-` |
| a | Push `a` into output | `x 3 * 45 / y + z` | `% -` |
| | Empty stack into output | `x 3 * 45 / y + z a` | `% -` |
| |  | `x 3 * 45 / y + z a % -` | |