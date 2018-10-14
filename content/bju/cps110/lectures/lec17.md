---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Dictionaries / CSV Files

In Python, a dictionary is a list, but instead of having the index be an integer, its a string!  What?  Yeah, its a little odd, but these guys are super userful.  First, how do you create one.  Lists are made with `[]`, tuples are made with `()` and dictionaries are made witn `{}`.

```py
myDictionary = {}
```

Inserting things into a dictionary is easy, much easier than lists.  You don't even need a method!  Likewise, getting things out is easy, just use the same string you used when you put the item in.

```py
cprint(myDictionary['aNewEntry'])
```

The string you used to insert an item into a dictionary is called the `key` and the object, number or string associated with that key is called the `value`.  Most of the standard operations like `len()` and `in` checks work on dictionaries.

```py
myDictionary = {}
myDictionary['aNewEntry'] = 1234
len(myDictionary) # => 1
'aNewEntry' in myDictionary # => True
'?' in myDictionary # => False
```

Things like slicing however don't work!  Its also not quite as easy to iterate over a dictionary.

```py
for key in myDictionary:
    value = myDictionary[key]
    # do stuff with value or key
```

There are two methods that will allow you to get just the keys `myDictionary.keys()` or values `myDictionary.values()`

## Processing a CSV File

CSV (Comma Separated Value) files are an incredibly common format to receive data in.  The files are relatively simple.  There are multiple data elements in the file group by line in the file.  Each element in a row has a comma separating it from the other elements (usually, sometimes its a tab and even more rare something else).  Processing a CSV involves opening the file, spliting on newline and then splitting on comma, kinda like what we did last time... or you could just use the Python module for reading csv files...

```py
import csv

with open('eggs.csv', 'rb') as csvfile:
    spamreader = csv.reader(csvfile)
    for row in spamreader:
        print(', '.join(row))
```

Let's break this guy down.

```py
import csv
```

This is a way to add modules, you've seen it many times.  We've imported `bottle` and `random` thus far.  There are ton of other modules out there though.  Check your friendly neighborhood Python documentation more often, you might literally find a module that will save you 20+ hrs of work.

```py
with open('eggs.csv', 'rb') as csvfile:
```

This is just another way of opening a file in Python but with a benefit. Remember the `close()` function.  It is difficult to remember to close files sometimes and that leads to problems.  `with` automatically closes the file at the end of the block so you don't have to remember to do it.  The `as csvfile` part is the variable name.  This statement would be the same as `csvfile = open(...)`.

```py
spamreader = csv.reader(csvfile)
for row in spamreader:
```

Create a brand new csv reader, and then iterate over each line in the CSV.  A word of warning.  The first line of a CSV file usually describes what each data element is, so you might have to skip the first line.

## Grouping and Totaling CSVs with Dictionaries

For the following two examples, I am using the [2010 Census Data](/bju/cps110/lectures/lec17-downloads/2010_city_state_postal_pop.csv).  There are examples with other data sets in the class resources on [Github](https://github.com/sschaub/cps110).  We are going to attempt to produce a list of populations by state.  The file has the populations listed by city, state and postal code.

So first, as usual, let's do the not so nice version first so you know what it looks like and appreciate the nice version.  Programming is just like math after all...

```py
with open('2010_city_state_postal_pop.csv', 'r') as census2010:
    populationsByState = {}
    skip = True
    for line in census2010:
        if not skip:
            (postalCode, city, state, population) = line.split(",")
            if state in populationsByState:
                populationsByState[state] = populationsByState[state] + int(population)
            else:
                populationsByState[state] = int(population)
        skip = False

    for state in populationsByState:
        print(state, populationsByState[state])
```

And then with the csv module...

```py
import csv

with open('2010_city_state_postal_pop.csv', 'r') as census2010:
    populationsByState = {}
    csvreader = csv.reader(census2010)
    skip = True
    for line in csvreader:
        if not skip:
            if line[2] in populationsByState:
                populationsByState[line[2]] = populationsByState[line[2]] + int(line[3])
            else:
                populationsByState[line[2]] = int(line[3])
        skip = False
            
    for state in populationsByState:
        print(state, populationsByState[state])
```

And an even better version with the csv reader...

```py
import csv

with open('2010_city_state_postal_pop.csv', 'r') as census2010:
    populationsByState = {}
    csvreader = csv.DictReader(census2010)
    for line in csvreader:
        if line['State'] in populationsByState:
            populationsByState[line['State']] = populationsByState[line['State']] + int(line['2010 Population'])
        else:
            populationsByState[line['State']] = int(line['2010 Population'])
            
    for state in populationsByState:
        print(state, populationsByState[state])
```

Wait, wait, wait...  What is a DictReader? Remember how the first line of the csv file usually contains descriptors.  Rather than skip the first line and have to memorize the location of each column, the DictReader allows us to use the descriptor to find the data we want.

What if we wanted to print the states in alphabetical order?  Lists include a builtin sort method we can use, but we're not using a list at the moment because the dictionary is easier.  We could, however, build a list of states as we go.  Since the state is the key, we can use that in our bottom for loop.

```py
import csv

with open('2010_city_state_postal_pop.csv', 'r') as census2010:
    populationsByState = {}
    states = []
    csvreader = csv.DictReader(census2010)
    for line in csvreader:
        if line['State'] in populationsByState:
            populationsByState[line['State']] = populationsByState[line['State']] + int(line['2010 Population'])
        else:
            states.append(line['State'])
            populationsByState[line['State']] = int(line['2010 Population'])
            
    for state in states.sort():
        print(state, populationsByState[state])
```