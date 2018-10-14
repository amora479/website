---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Functions Part II

Sometimes, you just need to make a piece of code simpler...

```py
import random

secretNum = random.randrange(1, 11)
numGuesses = 0
guess = 0

while guess != secretNum:
    guess = int(input("Enter your guess: "))
    numGuesses += 1
    if guess < secretNum:
        print("Your guess is too low.")
    elif guess > secretNum:
        print("Your guess is too high.")
    else:
        print("You got it!!")

print("It took you", numGuesses, "guesses.") 
```

This program isn't bad, but we could hide some of the messy details.  This is called abstraction: hiding away implementation details behind a simple interface.  The process of restructuring code and introducing abstraction is called refactoring.

```py
import random

def getSecretNumber():
    return random.randrange(1, 11)

def checkGuess(guess, secretNumber):
    if guess < secretNum:
        print("Your guess is too low.")
    elif guess > secretNum:
        print("Your guess is too high.")
    else:
        print("You got it!!")

def main:()
    secretNum = getSecretNumber()
    numGuesses = 0
    guess = 0

    while guess != secretNum:
        guess = int(input("Enter your guess: "))
        numGuesses += 1
        checkGuess(guess, secretNum)

    print("It took you", numGuesses, "guesses.")

main()
```

Does this have any benefits? Yes, if we have to include the protector if `if __name__ == "__main__":` we only have to put one thing under it, the function call to main.

We have also simplified our main logic.  The author doesn't have to worry about how to call random or how to check guesses, they can just call our functions.  It would be nice though if they knew what those functions did without having to look at the code.  Introducing simple doc strings.

We've already looked at some very complex doc strings, now let's introduce some more simples ones.

```py
import random

def getSecretNumber():
    """returns a number between 1 and 10"""
    return random.randrange(1, 11)

def checkGuess(guess, secretNumber):
    """determiness guess and secret number's relationship
       and prints a message describing it"""
    if guess < secretNum:
        print("Your guess is too low.")
    elif guess > secretNum:
        print("Your guess is too high.")
    else:
        print("You got it!!")

def main:()
    secretNum = getSecretNumber()
    numGuesses = 0
    guess = 0

    while guess != secretNum:
        guess = int(input("Enter your guess: "))
        numGuesses += 1
        checkGuess(guess, secretNum)

    print("It took you", numGuesses, "guesses.")

main()
```

These doc strings are primarily meant for very simple function, or functions where there isn't a limit we want to place on the parameter values.