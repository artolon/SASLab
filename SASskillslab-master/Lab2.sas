libname SASlab1 "/folders/myfolders/SASskillslab-master";
Data work.Add_Health; SET saslab1.wave1; 
PROC CONTENTS Data=Add_Health; RUN;

/*Find the questions about vomiting/laxatives/diet pills. Run frequencies on each variable*/
PROC FREQ Data=Add_Health; 
TABLES H1GH30C H1GH30D H1GH30E; 
RUN; 

/* Recode into binary variables, 
People coded 1 on the original variable are 1 on the new variable
People coded 0 or 7 are coded 0 on the new variable.*/
Data work.HealthNew; SET work.Add_Health;
IF H1GH30C=1 THEN Vomit=1; 
ELSE IF H1GH30C in (0, 7) THEN Vomit=0;
ELSE IF H1GH30C in (6, 8) THEN Vomit=.;

IF H1GH30D=1 THEN Pills=1; 
ELSE IF H1GH30D in (0, 7) THEN Pills=0;
ELSE IF H1GH30D in (6, 8) THEN Pills=.;

IF H1GH30E=1 THEN Lax=1; 
ELSE IF H1GH30E in (0, 7) THEN Lax=0;
ELSE IF H1GH30E in (6, 8) THEN Lax=.;
RUN;

/*Run a freq table to show it was done correctly*/
PROC FREQ; TABLES Vomit*H1GH30C Pills*H1GH30D Lax*H1GH30E / LIST MISSPRINT; RUN;

/*Create an additional new variable called anywgtbeh
People are coded 1 if they are coded 1 on any of your new variables 
and coded 0 if they are coded 0 on all of your new variables.  
Run a proc freq of the anywgtbeh*variables using list missprint*/
Data HealthNew2; SET HealthNew; 
IF Vomit=1 or Pills=1 or Lax=1 THEN anywgtbeh=1;
ELSE IF Vomit=0 or Pill=0 or Lax=0 THEN anywgtbeh=0;
ELSE if Vomit=. or Pill=. or Lax=. THEN anywgtbeh=.; RUN;

PROC FREQ; TABLES anywgtbeh*(Vomit Pills Lax)/ LIST MISSPRINT; RUN;

PROC PRINT; VAR H1GH59A H1GH59B; RUN;
PROC FREQ; TABLES H1GH59A*H1GH59B; RUN;

/*Convert H1GH59A and H1GH59B into a single variable that has total height in inches
If coded “don’t know” or “refused” on H1GH59A and/or H1GH59B, it is missing on the new variable.*/
Data Inches1; SET HealthNew2;
Inches=(H1GH59A*12)+H1GH59B;
IF Inches>97 THEN Inches=.;
ELSE IF Inches<=97 THEN Inches=Inches; RUN; 

PROC SORT DATA=Inches1 OUT=Inches2; BY descending inches;
PROC PRINT; VAR inches; RUN;

/*Create a new variable called weight on which those who are coded as 
“refused,” “don’t know,” or “not applicable” are coded missing.  
Everyone else should have the same value on weight as they did for H1GH60.*/
DATA Weight1; SET Inches2;
IF H1GH60>=996 THEN Weight=.;
ELSE IF H1GH60<996 THEN Weight=H1GH60; RUN; 

PROC SORT DATA=Weight1 OUT=Weight2; BY descending weight;
PROC PRINT; VAR weight; RUN;

/*Using inches and weight, create a new variable called BMI using the formula 
703 x weight (lbs) / [height (in)]2*/
DATA BMI; SET Weight2;
BMI=(weight*703)/(inches*inches); RUN; 

/*Round BMI to the 10ths decimal place*/
DATA BMI2; SET BMI;
BMI=ROUND(BMI,0.1); RUN;

/*BMI sorted from highest to lowest BMI*/
PROC SORT DATA=BMI2 OUT=BMI_SORT; BY DESCENDING BMI;  
PROC PRINT; VAR BMI; RUN; 


