---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# References

In Python, variables don't actually contain their value (at least the non-String, non-Boolean and non-Numeric ones don't).  What they contain is the address of the value.  This has some very strange repercussions. 

```py
x = [1, 2, 3] # not an int, boolean or string so x has a reference inside not the list
y = x # we make a copy of the reference, so both x and y point to the same list
y[1] = 4 # we update the list through the reference
print(x) # => [1, 4, 3] we updated x as well because x and y point at the same list
```

One way to determine that two references point to the same location is to use the `is` equality check rather than ==.  With lists, == checks to ensure every element is the same, but `is` checks to see if the addresses are the same.

```py
x = [1, 2, 3]
y = x
y[1] = 4

x is y # => True
x == y # => True

x = [1, 2, 3]
y = [1, 3, 3] # => a new different list

x is y # => False
x == y # => True
```

## References and Functions

variables containing references has repercussions for function calls as well.  We can manipulate variables without returning them!

```py
listy = []

def add(myList: list, num: int):
    myList.add(num)

def remove(myList: list, num: int):
    myList.remove(num)

add(listy, 3) # we pass the global listy to add
print(listy) # => [3]
```

## Tuples

A tuple is a list that cannot be modified. You create a tuple the same way you create a list, just swap the square braces for parenthesis...

```py
x = (1, 2, 3)
```

Tuples support many of the same functions as lists.  You can index them `x[0]`, slice them `x[1:]` and even concatenate them `(1,2,3) + (4,5)`.  But you can't do any update operations!

```py
x[0] = 1
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'tuple' object does not support item assignment
x.append(3)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'tuple' object has no attribute 'append'
x.remove(3)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'tuple' object has no attribute 'remove'
```

Because tuples are similar, yet different, to lists, we can use tuples inside of lists and lists inside of tuples.  This can create some really fun data structures to play with.  A rule of thumb though.  If your data needs to change, use a list, and use a tuple if it doesn't.

## Example

Let's create a vet's record log for cats.  We need to be able to add and remove cats, so we'll use a list.  But inside the list we'll use tuples `(cat name, [list of visits])` since cat names don't really change.  Inside the list of visits, we'll also use a tuple `(date of visit, reason)` since those items are history and won't change either.

```py
cats = []

def list_cats(cats):
    for cat in cats:
        print("{0} - {1}".format(cat[0], cat[1]))

def find_cat(cats,name):
    for cat in cats:
        if cat[0] == name:
            return cat
    return None

def add_cat(cats, cat):
    cats.append((cat, []))

def remove_cat(cats, cat):
    cats.remove(find_cat(cats, cat))

def add_visit(cats, cat, date, reasonOfVisit):
    foundCat = find_cat(cats, cat)
    if foundCat != None:
        foundCat[1].append((date, reasonOfVisit))
    else:
        print("Your cat is no longer here... (You signed a waiver)")
    
def remove_visit(cats, cat, date):
    foundCat = find_cat(cats, cat)
    if foundCat != None:
        for visit in foundCat[1]:
            if date == visit[0]:
                foundCat[1].remove(visit)
    else:
        print("Your cat is no longer here... (You signed a waiver)")
```

We can load this up in interactive mode to show it works!

```py
>>> cats
[]
>>> add_cat(cats, "Bubby") # pass the global cats array here
>>> cats
[('Bubby', [])]
>>> add_visit(cats, "Bubby", "10/3/2018", "losing fur")
>>> cats
[('Bubby', [('10/3/2018', 'losing fur')])]
>>> list_cats(cats)
Bubby - [('10/3/2018', 'losing fur')]
>>> 
```