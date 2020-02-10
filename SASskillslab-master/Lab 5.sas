libname SASlab1 "/folders/myfolders/SASskillslab-master";

Data work.wave4; SET saslab1.lab5data; 
PROC CONTENTS data=wave4; RUN;

/*Is fast food consumption in the past 7 days associated with obesity?  
Run a PROC FREQ with the chi-square option to find out*/
Data wave4; SET wave4;
PROC SORT out=wave4_sort; by fastfood; run;
PROC FREQ ORDER=DATA; tables fastfood*obese/CHISQ; RUN;

/*The literature says that men are less likely to be obese than women.  
Is this the case in our data?  Answer this question by running a PROC FREQ with the RELRISK option*/
Data obese1; SET wave4_sort;  
PROC SORT DATA=obese1 out=obesesort; by descending male descending obese; 
PROC FREQ DATA=obesesort order=data; TABLES male*obese/RELRISK; RUN;

/*Is eating fast food still associated with obesity after adjusting for gender and depression 
(anydep)?  
Run a PROC LOGISTIC with obese as the dependent variable and fastfood, male, and anydep 
as the independent variables*/
proc logistic descending;
class fastfood / param=ref ref=first;
model obese = fastfood male anydep;
run;

/*Are there signifianct differences in mean BMI, among categories of fastfood? 
Run a one-way ANOVA to find out*/
PROC ANOVA plots (maxpoints=none);
CLASS fastfood;
MODEL BMI=fastfood;
MEANS fastfood/TUKEY;
QUIT;

/*Now run a linear regression with BMI as the dependent variable and fastfood, 
gender (male) and depression (use variable CESDSUM) as the independent variables.  
Since you can’t use the CLASS statement with PROC REG, you will have to code the dummy variables 
for fastfood yourself*/
Data dummy; SET wave4_sort;
PROC FREQ; tables fastfood; run;

Data dummy2; SET dummy;
IF fastfood=0 then Never=1; 
ELSE IF fastfood in (1,2,3) then Never=0;
IF fastfood=1 then Once=1;
ELSE IF fastfood in (0,2,3) then Once=0;
IF fastfood=2 then Twice=1;
ELSE IF fastfood in (0,1,3) then Twice=0;
IF fastfood=3 then Threex=1;
ELSE IF fastfood in (0,1,2) then Threex=0;
RUN; 

PROC FREQ; tables fastfood Never Once Twice Threex; RUN; 

PROC REG; MODEL BMI = threex twice once never male CESDSUM/CLB; QUIT