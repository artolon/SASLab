/*Write a SAS program that includes a LIBNAME statement indicating where the new dataset is 
located and the command to obtain the contents of the dataset*/
libname SASlab1 "/folders/myfolders/SASskillslab-master";
Data work.census; SET saslab1.small_census; 
PROC CONTENTS Data=census; RUN;

/*Now add the position option to the code*/
PROC CONTENTS Data=census position; RUN;

/*Use PROC PRINT and ask for the first 20 observations*/
PROC Print Data=census (firstobs=1 obs=20); RUN;

/*Add a VAR statement to your code for #4 to ask for only the variables income, edu, and gender*/
PROC Print Data=census (firstobs=1 obs=20); VAR income edu gender; RUN;

/*Sort data by income in descending order.  
Save sorted data set by another name, and run a PROC PRINT of income, edu, and gender 
using the sorted data set.  Show only the first 20 observations.*/
PROC SORT data=census out=sort_census; BY descending income;
PROC PRINT Data=sort_census (firstobs=1 obs=20); VAR income edu gender; RUN; 

/*The top 1% of the people in this data set earned more than $9000.  
Rewrite your code for #6 to limit your output to these people.*/
PROC PRINT Data=sort_census; VAR income edu gender; WHERE income>9000; RUN; 

/*What percentage of people in the top 1% are male?  To find out, run a PROC FREQ on the variable 
gender using the WHERE statement to limit the analysis to people who earn more than $9000*/
PROC FREQ data=sort_census; tables gender; where income>9000; run; 
