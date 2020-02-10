libname SASlab1 "/folders/myfolders/SASskillslab-master";

Data work.ah; SET saslab1.ah_w4bmi2; 
PROC CONTENTS data=work.ah; RUN;

DATA work.sm; SET saslab1.sm_glucose;
PROC CONTENTS DATA=work.sm; RUN;

/*Merge the two datasets on the varibles "AID"*/

/*First, sort the datasets by the common variable*/
DATA ah2; SET ah;
PROC SORT OUT = ah_sort; BY AID;
PROC PRINT DATA=ah_sort;
RUN;

DATA sm2; SET sm;
PROC SORT OUT=sm_sort; by AID;
PROC PRINT DATA=sm_sort;
RUN;

/*Merge the two datasets on the common variable*/
DATA ahsm;
MERGE ah_sort sm_sort; by AID;
PROC CONTENTS Data=ahsm;
RUN;

/*Run a PROC UNIVARIATE with plots on the variable HbA1c*/
PROC UNIVARIATE PLOTS; VAR hba1c;
RUN;

/*Run a PROC FREQ of the variable w4ff (number of times ate fast food in past week)*/
PROC FREQ; tables w4ff; RUN;

/*Obtain separate frequency tables for the variable cursmk for men and women 
using PROC FREQ, but without using the WHERE option*/
DATA ahsm3;
SET ahsm;
PROC SORT OUT=ahsm3_sort; by male;
PROC FREQ DATA=ahsm3_sort; TABLES cursmk; by male; 
RUN;
