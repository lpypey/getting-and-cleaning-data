# *Getting and Cleaning Data* Course project

This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

This repository contains the following files:


- `README.md`, this file, which provides an overview of the data set and how it was created.
- `tidydata.txt`, which contains the data set.
- `CodeBook.md`, the code book, which describes the contents of the data set (data, variables and transformations used to generate the data).
- `run_analysis.R`, the R script that was used to create the data set 

## The `run_analysis.R` script that was used to create the data set: </a>

It retrieves the source data set and transforms it to produce the final data set by implementing the following steps:

- Download and unzip source data if it doesn't exist.
- Read data.
- Merge the training and the test sets to create one data set.
- Extract only the measurements on the mean and standard deviation for each measurement.
- Use descriptive activity names to name the activities in the data set.
- Label the data set with descriptive variable names.
- Create a second, independent tidy set with the average of each variable for each activity and each subject.
- Write the data set to the `tidydata.txt` file.

The `tidydata.txt` in this repository was created by running the `run_analysis.R` script using R version 3.5.2 (2018-12-20) 
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows >= 8 x64 (build 9200)

This script requires the `dplyr` package (version 0.7.8 was used).
