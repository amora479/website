---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# NASM Syntax Cheat Sheet (64-bit)

## Commenting

```
; comments in nasm come after a semi-colon
; there isn't really a thing like multi-line comments, each line has a semicolon in front

  opcode    param1, param2      ; but you can put comments at the end of lines
```

## Data Types

```
db - declared byte (8-bits, 1 byte)
dw - declared word (16-bits, 2 bytes)
dd - declared double word (32-bits, 4 bytes)
dq - declared quad word (64-bits, 8 bytes)

resb - reserved bytes (each reservation is 1 byte or 8-bits)
resw - reserved words (each reservation is 2 bytes or 16-bits)
resd - reserved dwords (each reservation is 4 bytes or 32 bits)
resq - reserved qwords (each reservation is 8 bytes or 64 bits)
```

## Declaring a Mutable Integer

```
section .data

  myInteger: dq 0
```

## Declaring a Mutable String

```
section .data

  myString1: db "a string without a newline", 0
  myString2: db "a string with a newline", 10, 0
```

## Declaring a Read-Only Integer

```
section .rdata

  myReadOnlyInteger: dq 0
```

## Declaring a Read-Only String

```
section .rdata

  myReadOnlyString1: db "a string without a newline", 0
  myReadOnlyString2: db "a string with a newline", 10, 0
```

## Declaring Initialized Arrays

```
section .data

  myArrayThatHas10Integers: dq 0,0,0,0,0,0,0,0,0,0
```

## Declaring Uninitialized Variables & Arrays

```
section .bss

  anInteger: resq 1       ; 1 integer
  aString: resb 80        ; a string 80 characters long
  aIntegerArray: resq 40  ; 40 integers
```

## Calling Printf with an Integer

```
mov   rdx, [your integer]
lea   rcx, [fmt]            ; a fmt string containing %lld
call  printf                ; don't forget he has to be externed in
```

## Reading an Integer with Scanf

```
lea   rdx, [your integer]   ; we need the address so lea
lea   rcx, [fmt]            ; a fmt string containing %lld
call  scanf
```

## If Statement

```
    cmp   [variable], value or register   ; this cannot be two memory addresses
    je    .if_1_true_part                 ; have more than 1 if in the function, increment the 1s
                                          ; other conditional jumps map apply
    jmp   .end_if_1                       ; unconditional jump for the label that is potentially far away
.if_1_true_part:
    ; true statements go here
.end_if_1:
```

## Conditional Jumps

```
je - jump if equal
jne - jump if not equal
jz - jump if zero
jnz - jump if not zero
js - jump if last operation resulted in a negative number
jns - jump if last operation resulted in a positive number
jg - jump if greater
jge - jump if greater than or equal to
jl - jump if less
jle - jump if less than or equal to
```

## If-Else Statement

```
    cmp   [variable], value or register   ; this cannot be two memory addresses
    je    .if_1_true_part                 ; have more than 1 if in the function, increment the 1s
                                          ; other conditional jumps map apply
    jmp   .if_1_false_part                ; unconditional jump for the label that is potentially far away
.if_1_true_part:
    ; true statements go here
    jmp .end_if_1
.if_1_false_part:
    ; false statements go here
.end_if_1:
```

## If-Else If-Else Statement

```
    cmp   [variable], value or register   ; this cannot be two memory addresses
    je    .if_1_true_part                 ; have more than 1 if in the function, increment the 1s
                                          ; other conditional jumps map apply
    jmp   .if_1_else_if_1                 ; unconditional jump for the label that is potentially far away
.if_1_true_part:
    ; true statements go here
    jmp .end_if_1
.if_1_else_if_1:                          ; you could potentially have n of these else if blocks
    cmp   [variable], value or register
    je    .if_1_else_if_1_true
    jmp   .if_1_false_part                ; would jump to if_1_else_if_n if you had more else ifs
.if_1_else_if_1_true:
    ; else if 1 statements go here
    jmp   .end_if_1                       ; end else if block
.if_1_false_part:
    ; else statements go here
.end_if_1:
```

## While Loop

```
.while_1                                  ; have more than 1 if while the function, increment the 1s
    cmp   [variable], value or register   ; this cannot be two memory addresses
    jne   .while_1_true                   ; other conditional jumps may apply
    jmp   .while_1_false                  ; unconditional jump for the label that is potentially far away
.while_1_true:
    ; while statements go here
    jmp .while_1
.while_1_false:
```

## Basic Function Template

```
global function_name:
function_name:
    ; have paramters, save them in the shadow space
    push   rbp          ; not needed if not doing recursion
    mov    rbp, rsp     ; not needed if not doing recursion
    ; create local variables if needed (sub rsp, 8 * number of variables)
    ; call other functions? create shared shadow space (sub rsp, 32)
      
    ; function body goes here
      
    mov    rax, [return value]
    ; remove shared shadow space if you created it
    ; remove local variables (if not using mov rsp, rbp to do so)
    mov    rsp, rbp     ; needed if stack frame originally created (will also remove local variables)
    pop    rbp          ; needed if stack frame originally created
    ret
```

## Basic Assembly File Tempalte

```
; unless you're doing something weird, you can leave this off to get better assembler messages 
; bits 64 
default rel             ; default memory access to relative mode (need /LARGEADDRESSAWARE:YES with cl if you don't do this)

extern printf           ; is _printf for *nix users, don't need if not using printf
extern scanf            ; is _scanf for *nix users, don't need if not using scanf

section .text           ; convention is instructions first, data at end, you can put data first though

global main             ; is _main for *nix users
main:
    sub     rsp, 32     ; shared shadow space for all function calls
    
    ; body of main
    
    add     rsp, 32     ; shared shadow space for all function calls
    ret
```

## Function Calls if More Than 6 Parameters

```
push    <other paramters>
sub     rsp, 32           ; functions expect shadow space to be at [rsp + 8] so shared shadow space can't be used
mov     r9, <param 4>
mov     r8, <param 3>
mov     rdx, <param 2>
mov     rcx, <param 1>
call    function
add     rsp, 8 * (number of parameters - 4) + 32
```
