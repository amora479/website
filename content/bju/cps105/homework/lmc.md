---
title: "CPS 105"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Little Man Computer

This assignment will give you familiarity with the level of precision that computers require in their instruction.  It will also give you a bit of an introduction to "programming" as you'll write (if you choose to) small (not necessarily simple) programs to accomplish basic tasks.

## Getting Started

Download the [resource files](/bju/cps105/homework/lmc-downloads/lmc.zip) and extract them.  Inside you will find two html files, `LMC4.html` is the Little Man Computer Simulator you will be using for this assignment.  `AboutLMC.html` is another page which contains additional information about the Little Man Computer; use this page to refresh your memory of the in-class material.  There are also two programs that you copy into the Little Man Computer to try it out.

## Instructions

In a word document, or using a text editor like notepad, neatly type your answers to each of the questions below.  Be sure to indicate which question you're answering by placing the question number on a line by itself with the answer below the number.  You may write and turn in your answers on paper if you prefer.

## Questions

1. Translate the following instructions.  Give both the name as well as an english description.  The first row is done for you; see question 4 if you need an additional example.

    | Mailbox | Instruction | Instruction Name / Mailbox | Description |
    | --- | --- | --- | --- |
    | 0 | 516 | Load 16 | Take the value located at Mailbox 16 and place it into the `Calc` box. |
    | 1 | 320 | | |
    | 2 | 901 | | |
    | 3 | 321 | | |
    | 4 | 901 | | |
    | 5 | 322 | | |
    | 6 | 714 | | |
    | 7 | 520 | | |
    | 8 | 121 | | |
    | 9 | 320 | | |
    | 10 | 522 | | |
    | 11 | 217 | | |
    | 12 | 322 | | |
    | 13 | 606 | | |
    | 14 | 520 | | |
    | 15 | 902 | | |
    | 16 | 0 | | |
    | 17 | 1 | | |
1. Copy the program from question 1 into the Little Man Computer (use the `Enter Program` box) then click `Load`.  Put `7 4` into the `Input Tray` then click `Run`. (You can alternatively click `Step` a bunch of times to watch the Little Man Computer execute each instruction individually.) What value is in the `Output` box at the end of the program?
1. What mathematical task is the program from question 1 doing? (Be sure to try multiple inputs before you give your answer.)
1. Give what instruction (Raw and Name / Mailbox) would accomplish what is described.
    | Mailbox | Instruction | Instruction Name / Mailbox | Description |
    | --- | --- | --- | --- |
    | 0 | | | Remove a number from the `Input Tray` and put it into the `Calc` box |
    | 1 | | | Copy the number in the `Calc` box into Mailbox 20 |
    | 2 | | | Remove a number from the `Input Tray` and put it into the `Calc` box |
    | 3 | | | Copy the number in the `Calc` box to Mailbox 21 |
    | 4 | | | Subtract the number in Mailbox 20 from the number in the `Calc` box updating the `Calc` box with the result |
    | 5 | | | If the number in the `Calc` box is >= 0, set the `Instruction Location` to 8.  Otherwise, do nothing |
    | 6 | | | Copy the number in Mailbox 20 to the `Calc` box |
    | 7 | | | Set the `Instruction Location` to 9 |
    | 8 | | | Copy the number in Mailbox 21 to the `Calc` box |
    | 9 | | | Copy the number in the `Calc` box to the `Output Tray` |
    | 10 | | | Halt |
1. Using the following table, trace, using the program from question 4, what would happen with an `Input Tray` of 2 and 9.  Note, you may not need all mailboxes or rows.
    | Mailbox Executed | Instruction Location | Calc | Input Tray | Output Tray | Mailbox 20 | Mailbox 21 |
    | --- | --- | --- | --- | --- | --- | --- |
    | _Start_ | 0 | 0 | 2 9 | ? | ? | ? |
    | 1 | | | | | | |
    | 2 | | | | | | |
    | 3 | | | | | | |
    | 4 | | | | | | |
    | 5 | | | | | | |
    | ? | | | | | | |
    | ? | | | | | | |
    | ? | | | | | | |
    | ? | | | | | | |
1. Using the following table, trace, using the program from question 4, what would happen with an `Input Tray` of 8 and 3.  Note, you may not need all mailboxes or rows.
    | Mailbox Executed | Instruction Location | Calc | Input Tray | Output Tray | Mailbox 20 | Mailbox 21 |
    | --- | --- | --- | --- | --- | --- | --- |
    | _Start_ | 0 | 0 | 8 3 | ? | ? | ? |
    | 1 | | | | | | |
    | 2 | | | | | | |
    | 3 | | | | | | |
    | 4 | | | | | | |
    | 5 | | | | | | |
    | ? | | | | | | |
    | ? | | | | | | |
    | ? | | | | | | |
    | ? | | | | | | |
1. _CHALLENGE_ Create a Little Man Computer program that will swap two numbers.  The basic steps you will need are:
    1. Read a number from the `Input Tray` and store it.
    1. Read a number from the `Input Tray` and store it.
    1. Output the second number to the `Output Tray`.
    1. Output the first number to the `Output Tray`.
1. _ADVANCED_ Write a Little Man Computer program that will triple a number from the `Input Tray` only if it is >= 0.  Put the tripled or negative value into the `Output Tray`.

## Submission

If you are submitting an electronic document, submit the assignment using BJU Online.  For those submitting a written version, the assignment must be submitted during the class period before the due date.  If not submitted during that class period, please scan your written document and submit it electronically.