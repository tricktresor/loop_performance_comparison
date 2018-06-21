# Loop Performance Comparison
Performance Comparison LOOP with Condition and standard table and sorted table

inspired by this post:

https://www.abapforum.com/forum/viewtopic.php?f=1&t=21900

# Task
The task is to get the number of table entries which fit the condition "True" in one field of the table.

# Comparison types
short description of the different solutions

## P01_REDUCE        
Loop using REDUCE

## P02_FILTER
Loop using FILTER

## P03_LOOP_CASE
Loop with a CASE condition inside the loop (using work area).

## P04_LOOP_WHERE
Loop with a WHERE condition (using work area)

## P05_LOOP_CASE_FS
Loop with a CASE condition inside the loop (using field symbols)

## P06_LOOP_WHERE_FS
Loop with a WHERE condition (using field symbols)

## P07_LOOP_WHERE_NO
Loop with WHERE Condition but with TRANSPORTING NO FIELDS

# Classes
These classes will be used.

## help
Class for dealing with random figures.

## help_standard
Class which processes all different solution using a standard table.

## help_sorted
Class which processes all different solution using a sorted table.

# Comparison
There are no run time measurements inside this class. 
Use Transaction SAT to compare the performance.
Filter result list by "HELP_P" to get a direct overview
