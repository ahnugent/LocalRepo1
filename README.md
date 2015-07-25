File:	'README.md'
Date:	2015-07-24
Scope:	These notes pertain to use of the solution script 'run_analysis.R'.
----------------------------------------------------------------------------------


1. Description
---------------

The script 'run_analysis.R' solves the problem posed by the Coursera getdata-030 ("Getting and Cleaning Data") course project.


2. Dependences
---------------

The following packages are installed by the solution script:  

	dplyr
	stringr

If these are already installed in the workspace by default, the 'library' commands can be commented-out in the script.

These files must be present in the working directory (so that the scrip can load external functions):

	'friendly.R'		(defines function 'friendly.name')


3. Environment
---------------

The script should be located in the working directory (denoted as "wd" below). The data files must be located in specifically named subfolders. These should be built automatically if the source data file (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) is unzipped from the working directory. The required file paths are as follows (Microsoft Windows syntax):

    \wd\UCI_HAR_Dataset\features.txt
              "        \activity_labels.txt
              "        \test\subject_test.txt
              "          "  \X_test.txt
              "          "  \y_test.txt
              "        \train\subject_train.txt
              "          "   \X_train.txt
              "          "   \y_train.txt

The data set contains other files that are not required for the present analysis.
 

4. Output
----------

The solution script creates 3 data frame tables, derived from the original data set:

	dat	adds 'activity' and 'subject' columns, but retains original variable naming.
	dat1	same as 'dat' but with user-friendly variable names.
	dat2	derived from 'dat' by grouping over 'activity' and 'subject', and averaging over all measures.

Upon finalisation of each of 'dat1' and 'dat2', the 'str' command is executed to display the data structures on the console.

(Nb. User-friendly Variable names were obtained by breaking out the metrics and dimension, while preserving the core signal names. For example, "tBodyAcc-mean()-Y" becomes "mean.Y.tBodyAcc".)

At the final stage of the script, the reduced, tidy data set ('dat2') is written to file 'tidydat.txt'.


5. Execution
-------------

Once the above requirements are in place, the solution script can be executed from the R (or RStudio) console:

	> source('run_analysis.R')


6. Other Resources
-------------------

Details of the analysis are given in the code book ('UCI_HAR_CodeBook.pdf').

