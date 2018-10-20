---
title: "CPS 110"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Processing Excel Files

Excel files.  Everybody loves to hate them, but they are dead useful in a lot of circumstances.  Much of the business world literally could not exist without Excel.  So learning to process Excel files is pretty important.

But first, let's talk about what an excel file looks like.

## Object Models

An excel file is also known as a workbook.  Workbooks have many worksheets.  Each worksheet has many rows and many columns.  Finally, each row and column has many cells, and each cell has a value.  That value can be a formula or a string or numerical data.  Whew...

Row and columns in excel are a bit different.  They start at 1 rather than 0 for rows anyway.  Columns are lettered starting at A instead.

## Processing Excel

For the following example, I am using the [Financial Sample](/bju/cps110/lectures/lec20-downloads/sample.xlsx) provided by Microsoft. 

So first, how do we open an excel file.  There is a module in python, the `openpyxl` module, that is made for processing excel documents.

```py
import openpyxl

workbook = openpyxl.load_workbook('sample.xlsx')
```

From there, we have to get a worksheet in order to do anything useful.  To get the default worksheet, use the active variable.  To get another worksheet, you can use square brackets.

```py
worksheet = workbook.active # gets the default worksheet
worksheet = workbook['Sheet 1'] # gets the worksheet named Sheet 1
```

Getting an individual cell is fairly easy, we just have to use excel's reference format.

```py
worksheet["A1"]
```

Notice however that this returns a cell object rather than the value.  You have to use the `.value` variable to get or set the value.

```py
worksheet["A1"].value
worksheet["A1"].value = "Hello World"
```

It is also fairly easy to save a workbook after you have made modifications.

```py
workbook.save('updatedWorksheet.xlsx')
```

You can also add sheets to a workbook if you would really like!

```py
workbook.create_sheet("Sheet MySheet")
```

You can also get ranges of columns and sheets.

```py
worksheet["A":"D"] # columns A through D
worksheet[1:30] # rows 1 to 30
worksheet["A1":"D30"] # columns A through D but just for rows 1 to 30
```

Let's iterate over the data we have and compute the profit of each country.

```py
import openpyxl

workbook = openpyxl.load_workbook('sample.xlsx')
worksheet = workbook.active

lenOfData = len(worksheet["A":"A"]) # figure out how many rows we have
countries = worksheet["B2":"B" + str(lenOfData)] # this is actually a 2d list where each row is a list that is 1 item long
profits = worksheet["L2":"L" + str(lenOfData)] # this is actually a 2d list where each row is a list that is 1 item long

profitPerCountry = {}
for i in range(len(countries)):
    if countries[i][0] in profitPerCountry:
        profitPerCountry[countries[i][0].value] += float(profits[i][0].value)
    else:
        profitPerCountry[countries[i][0].value] = float(profits[i][0].value)

for country in sorted(profitPerCountry):
    print(country, "-", profitPerCountry[country])
```