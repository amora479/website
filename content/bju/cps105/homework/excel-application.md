---
title: "CPS 105"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Excel Application

Excel is boring... let's make it more fun by making it interactive.

## Overview

In this project, you will create a pay stub generator in Excel. The assignment is divided into several sections, and your score will be determined by how many sections you complete.

## Basic Requirements (Maximum Grade: 45 / 50)

Your spreadsheet must contain the following sheets:

| Sheet Name | Description |
| --- | --- |
| Timesheet | A table of time card entries for employees. |
| Employees | A table of employees |
| Pay Stub | An interactive form and report |
| Analysis | See Reporting Results below |

### Timesheet
Import the data for this sheet from a file named [timesheet.csv](/bju/cps105/homework/excel-application-assets/timesheet.csv). Do not add any extra columns or computations.

### Employees
Import the data for this sheet from a file named [employees.csv](/bju/cps105/homework/excel-application-assets/employees.csv). 

### Pay Stub

This is the interactive part of the spreadsheet. Provide a lookup form for the user to enter an employee ID. Display a pay stub for the employee, formatted as shown in Figure 1. The pay stub should contain the following data:

| Item | Description | 
| Hourly Rate | Employee’s hourly pay rate, from Employees sheet. |
| Hours Worked | Number of hours the employee worked, computed using all entries for the employee in the Timesheet. |
| Gross Wages | Total pay before deductions. If employee worked up to 40 hours, this is the Pay Rate × Hours Worked. If the employee worked more than 40 hours, the pay amount beyond 40 hours is Pay Rate × 1.5 × Overtime Hours, where Overtime Hours is hours worked above 40. |
| Federal Tax | 20% of Gross Pay |
| State Tax | 5% of Gross Pay |
| Current Income | Sum of income |
| Current Deductions | Sum of deductions (taxes and health plan) |

Below the Pay Stub, you may create a labeled list of calculated values. You can use the Define Name feature to assign names to the calculated values. The Pay Stub itself can then reference these names, rather than containing any formulas. This will help you check intermediate calculations and debug errors.

## Advanced Requirements (Maximum Grade: 50 / 50)

Enhance the spreadsheet so that when the user enters an Employee ID into the lookup form on the Pay Stub sheet that does not match an Employee ID defined on the Employees sheet, all values in the spreadsheet show as empty or zero (no #VALUE! or other error values appear).

## Challenge Requirements (Maximum Grade: 55 / 50)
In addition to tax payments, include a health plan deduction. Add a heading “Health Plan” with the number of dependents after it in parentheses. Compute the health deduction as follows: For 1-3 dependents, the deduction is $150. For each additional dependent after 3, the deduction is an additional $50. For 0 dependents, the deduction is $0.

## Report Result
Create three test cases for your spreadsheet consisting of input, expected results, and actual results. The test cases (input, expected results, and actual results) should appear in a table at the top of the Analysis sheet, followed by screen shots showing the actual results. 

Notes:
- The expected and actual results in your test cases should include current gross pay, total current deductions, and net pay.
- The expected results should be computed without using the spreadsheet itself. 
- For each test case, indicate whether the actual results match the expected results.
- For the extra version, include a screen shot showing the online time card submission form.
Submission
- Submit your spreadsheet before the deadline.

## Sample Layout

![layout](/bju/cps105/homework/excel-application/layout.png)