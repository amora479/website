---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# File Processing

In Python, interaction with files can be interesting...  We've already seen how to write files, using the `open()` command.  Open takes two arguments, the filename and the mode.  Up until this point, we've only used open with a "w" (which means write mode).  With a `"w"`, python will try to open the file and if it doesn't exist, it will create it.  With `"r"` as the option, Python opens the file in read mode.  The mode here is important as it tells Python which methods are allowed on the file.  For example, you cannot write to a file that is open in read mode.  This is mainly a protection built in to the operating system to prevent two people from trying to write to the same file at the same time.

## Writing a File

```py
file = open("myfile.txt", "w")
file.write("""this is a line of text
this is another line of text""")
file.close()
```

The close here is important. Anytime you open a file, you have to close it when your are done.  For writing, often the text you wrote won't actually be written until you close.

## Reading a File

```py
file = open("myfile.txt", "w")

file.read() # this will read the entire file into a string
file.readlines() # this will read the entire file split the file on \n and put the lines into a list for you

for line in file: # this will do the exact same thing as readlines, but now you're ready to iterate over the lines
    # do something

file.close()
```

## File Processing

I have a list of students: first name, last name and email.  Each piece of data is separated by a tag.  I want to collect all of the students that have an even length last name, and put those into a file separated by commas instead of tabs.  So here is the tab separated file.

```
First	Last	Email
Gunnar	Kramer	dbanarse@outlook.com
Marques	Wilkerson	bradl@outlook.com
Lilia	Mcclain	carreras@aol.com
Londyn	Doyle	adamk@optonline.net
Deja	Mcknight	dieman@optonline.net
Paxton	Finley	epeeist@verizon.net
Jorge	Delacruz	citadel@yahoo.ca
Amya	Herring	kmself@gmail.com
Shamar	Dodson	tattooman@optonline.net
Braydon	Mcconnell	skoch@hotmail.com
Valerie	Mason	nanop@yahoo.ca
Zion	Hobbs	muadip@yahoo.com
```

So let's do it using our newfound knowledge!

```py
tabSeparatedFile = open("students.tsv", "r")

# will be a list of lists
studentsWithEvenLastNames = []
# iterate line by line
for line in tabSeparatedFile:
    data = line.strip().split("\t")
    # only students with last names
    if len(data[1]) % 2 == 0:
        studentsWithEvenLastNames.append(data)

tabSeparatedFile.close()

commaSeparatedFile = open("students.csv", "w")

# iterate over found students
for student in studentsWithEvenLastNames:
    # join takes a list and prints the string between each element of the list
    commaSeparatedFile.write(",".join(student) + "\n")

commaSeparatedFile.close()
```