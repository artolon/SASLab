libname SASlab1 "/folders/myfolders/SASskillslab-master";
Data work.alpha; SET saslab1.sales; 

PROC CONTENTS DATA=work.alpha; RUN;

DATA work.alpha;
SET saslab1.sales;
Bonus=500;
PROC CONTENTS DATA=work.alpha;
RUN;

PROC PRINT DATA=work.alpha;
VAR Employee_ID Salary Bonus;
RUN;

DATA work.alpha;
SET saslab1.sales;
Bonus=500;
Compensation = Salary + Bonus;
Format Salary Bonus Compensation COMMA8.;
PROC CONTENTS DATA=work.alpha;
RUN;

PROC PRINT DATA=work.alpha;
VAR Employee_ID Salary Bonus Compensation;
RUN;

DATA work.alpha; SET saslab1.sales;
Age = '01Jan2015'd - Birth_Date;
PROC Contents; RUN;
PROC PRINT; VAR birth_date age; run; 

Data work.alpha; SET saslab1.sales;
Age_days = '01jan2015'd - Birth_Date;
Age_years = age_days/365.25;
PROC CONTENTS; run; 
proc print; var age_years birth_date;
run; 
Age_years = age_days/365.25; RUN; 

/*Module 5*/
/*Open a new editor file, and do the following using the dataset staff.sas7bdat*/
libname SASlab1 "/folders/myfolders/SASskillslab-master";
DATA two; SET saslab1.staff; RUN;
PROC PRINT; RUN;

/*Create a new variable called Increase, which is salary multiplied by 0.02*/
DATA work.two;
SET saslab1.staff;
Increase = Salary*0.02;
PROC CONTENTS DATA=work.two;
RUN;

Data work.three; SET two; 
PROC PRINT; VAR salary Increase; RUN; 

/*Create a new variable called NewSalary, which is Salary + Increase*/
DATA work.four;
SET three;
NewSalary = Salary + Increase;
PROC CONTENTS DATA=work.four;
RUN;

Data five; SET four;
PROC PRINT; VAR salary Increase NewSalary; RUN; 

/*Create a new variable called years_emp, which is the number of years that an employee has 
been at the company as of January 1, 2011 
(Subtract the variable Emp_Hire_Date from January 1, 2011).  
Make this variable an integer variable (i.e., no decimal places, so people who have 
been with the company for less than a year as of January 1, 2011 will be coded 0).*/
DATA six;
SET five;
days_emp = '01Jan2011'd - Emp_Hire_Date; 
years_emp = INT(days_emp/365.25);
PROC CONTENTS DATA=six;
PROC PRINT; VAR years_emp; RUN; 

/*Reformat everything to mirror table in the In-class Exercise*/
PROC SORT DATA=six OUT=staff_hire; BY descending Emp_Hire_Date;
PROC PRINT DATA=staff_hire;
VAR Employee_ID Salary Increase NewSalary Emp_Hire_Date years_emp;
run;

/*Re-format NewSalary*/
PROC PRINT NOOBS; FORMAT NewSalary dollar8. salary dollar8. emp_hire_date DATE9.;
VAR Employee_ID Salary Increase NewSalary Emp_Hire_Date years_emp;
run;

/*Run a PROC FREQ of the variable that you made called years_emp*/
PROC FREQ; tables years_emp; RUN; 

/*Code a new variable called yr_emp_cat, where <1=1, 2-4=2, 5-9=3, and 10+=4*/
Data NewStaff; SET Staff_Hire;
IF years_emp<=1 THEN yr_emp_cat=1; 
ELSE IF years_emp>1 and years_emp<=4 THEN yr_emp_cat=2;
ELSE IF years_emp>4 and years_emp<=9 THEN yr_emp_cat=3; 
ELSE IF years_emp>9 THEN yr_emp_cat=4; RUN;

/*Run a PROC FREQ of the new and old variables with the LIST MISSPRINT option 
to check that you recoded properly*/
PROC FREQ; tables years_emp*yr_emp_cat/LIST missprint; RUN;

/*Run a PROC FREQ on just your new variable.  
What proportion of workers has been with the company for 10 years or more

Answer: 53.07%*/
PROC FREQ; tables yr_emp_cat; RUN; 

/*Next, create a new variable called “vacation” where people who have been working at the 
company for a year or less are coded 5, those who have been working for 2-4 years are coded 10, 
those who have been working for 5-9 years are 15 and those working for 10+ years are 20.
 
BUT the Vice President of the company and the Officers (Chief Marketing, Chief Sales, 
Chief Financial and Chief Executive Officer) get 25 vacation days regardless of how long 
they’ve been with the company. Paste your code for creating the new variable below, as well 
as the output from a PROC FREQ of vacation*/
Data Vacation; SET NewStaff;
IF yr_emp_cat=1 THEN vacation=5;
ELSE IF yr_emp_cat=2 THEN vacation=10;
ELSE IF yr_emp_cat=3 THEN vacation=15;
ELSE IF yr_emp_cat=4 and job_title="Chief Marketing Officer" or 
job_title="Chief Sales Officer" or job_title="Chief Financial Officer"
or job_title="Chief Executive Officer" THEN vacation=25;
ELSE IF yr_emp_cat=4 and job_title~="Chief Marketing Officer" or 
job_title~="Chief Sales Officer" or job_title~="Chief Financial Officer"
or job_title~="Chief Executive Officer" THEN vacation=20;
RUN;

PROC FREQ; tables vacation; RUN; 

/*Save the new version of the dataset that includes the new variables you’ve created 
as a permanent dataset with a new name of your choice*/
libname SASlab1 '/folders/myfolders/SASskillslab-master';
data saslab1.vacation2; SET vacation; run; 

/*Refer to Part 3 of Module 5 before moving on. Code below:*/
DATA work.New_w4bmi;
SET saslab1.new_w4bmi;
PROC CONTENTS DATA=work.New_w4bmi;
RUN; 

/*Freq table of old variable*/
PROC FREQ; tables H4BMICLS; run;

/*Recode h4bmicls to new variables called bmi4cat*/
DATA NewBMI; SET New_w4bmi;
if h4bmicls = 1 then bmi4cat=1; 
else if h4bmicls = 2 then bmi4cat=2; 
else if h4bmicls = 3 then bmi4cat=3; 
else if h4bmicls in (4, 5, 6) then bmi4cat=4; 
else if h4bmicls in (88, 89, 96, 97, 99) then bmi4cat=.; RUN; 

/*Check Freq table of new variable*/
PROC FREQ; TABLES bmi4cat*h4bmicls / LIST MISSPRINT; RUN; 

/*Find another way to code bmi4cat.  
See if you can use even fewer lines of code than in the second example above.*/
DATA recode; SET NewBMI;
if h4bmicls <=3 then bmi4cat=h4bmicls; 
else if h4bmicls in (4, 5, 6) then bmi4cat=4; 
else if h4bmicls in (88, 89, 96, 97, 99) then bmi4cat=.; RUN; 

/*Check Freq table of new variable*/
PROC FREQ; TABLES bmi4cat*h4bmicls / LIST MISSPRINT; RUN;

/*Module 6*/
libname SASlab1 "/folders/myfolders/SASskillslab-master";
DATA men;
SET saslab1.male;
PROC PRINT;
RUN;

DATA women;
SET saslab1.female;
PROC PRINT;
RUN;

/*Combine the two datasets (merge/concatenate)*/
DATA all;
SET work.men work.women;
PROC PRINT;
RUN;

/*Same exercise, but now we see some categories are different!*/
DATA work.male2;
SET saslab1.male_class;
PROC PRINT;
RUN;

/*Oh no! They are coded to missing, since the cats are not the same*/
DATA work.female2;
SET saslab1.female_cat;
PROC PRINT; RUN; 

DATA work.all2;
SET work.male2 work.female2;
PROC PRINT;
RUN;

/*Rename so that it looks nice and pretty*/
DATA work.all2;
SET work.male2 work.female2 (rename=(bmicat=bmiclass));
PROC PRINT;
RUN;

/*In class exercise - Part 1*/
/*PROC CONTENTS or PROC PRINT on the datasets sales.sas7bdat and nonsales.sas7bdat – 
which variables are different in the two datasets?

Answer: The first name/last name variables are different between the two*/
DATA sales2;
SET saslab1.sales;
PROC PRINT;
RUN;

DATA nonsales2;
SET saslab1.nonsales;
PROC PRINT;

/*Concatenate the two datasets using the RENAME option to change the names of the variables 
that are different in nonsales to the variable names used in sales*/
DATA work.rename1;
SET work.sales2 work.nonsales2 (rename=(first=First_Name last=Last_Name));
PROC PRINT;
RUN;

/*Make a new permanent dataset called allemployees that includes only the variables 
Employee_ID, First_Name, Last_Name, Job_Title, and Salary*/
libname SASlab1 '/folders/myfolders/SASskillslab-master';
data saslab1.sales_and_non; SET rename1 
(KEEP = Employee_ID First_Name Last_Name Job_Title Salary); run; 
PROC CONTENTS; PROC PRINT; RUN;

/*In class exercise - Part 2

Run a PROC PRINT or PROC CONTENTS to explore the variables in each dataset.  
How many observations are in each dataset? What is the common variable?*/
DATA level;
SET saslab1.product_level;
PROC CONTENTS;
RUN;

DATA list;
SET saslab1.product_list;
PROC CONTENTS;
RUN; 

/*Sort the datasets by the common variable*/
DATA level2;
SET level;
PROC SORT OUT = level_sort; BY product_level;
PROC PRINT DATA = level_sort;
RUN;

DATA list2;
SET list;
PROC SORT OUT=list_sort; by product_level;
PROC PRINT DATA=list_sort;
RUN;

/*Merge the two datasets on the common variable*/
DATA merged_level;
MERGE level_sort list_sort; by product_level;
PROC PRINT Data=merged_level;
RUN;

/*Run a PROC PRINT of the new dataset with only the variables 
Product_ID, Product_Name, Product_Level and Product_Level_Name*/
PROC PRINT Data=merged_level;
VAR Product_ID Product_Name Product_Level Product_Level_Name;
RUN;

/*Module 7 - Descriptive Statistics
In Class Exercise #4 Part 1*/
libname SASlab1 "/folders/myfolders/SASskillslab-master";
Data work.omega; SET saslab1.AH_W4BMI2;

/*Run a PROC FREQ on the variable agefstsmk (age first smoked a cigarette)*/
PROC FREQ; tables agefstsmk; run; 

/*In class exercise #4 Part 2****

Run a PROC UNIVARIATE or a PROC MEANS on the variable waist_cir (waist circumference in cm)*/
PROC UNIVARIATE DATA = omega; VAR waist_cir;
RUN;

/*Sort by gender (male) and ask for your PROC UNIVARIATE or PROC MEANS by gender.  
Which gender has a higher mean waist circumference?  
Give the mean waist circumference for men and women in your answer.*/
DATA omega2;
SET omega;
PROC SORT OUT=omega_sort; by male;
PROC UNIVARIATE DATA=omega_sort; var waist_cir; by male; 
RUN;

/*Module 8 - Descriptive Statistics
*****In Class Exercise #5 Part 1*****

Recode the variable H4WP39 into a new binary variable called "dadcash";
People who said they received ANY cash from dad = 1
No cash from dad (or legitimate skip) = 0*/
libname SASlab1 "/folders/myfolders/SASskillslab-master";
Data work.dads; SET saslab1.day5data;

Data work.dads2; SET work.dads;
if h4wp39 in (0,7) then dadcash=0;
else if h4wp39 not in (6,8) then dadcash=1;
LABEL dadcash = 'cash from dad for living exp in past 12 mo'; run; 

PROC FREQ; tables dadcash*h4wp39/LIST MISSPRINT; RUN; 

/*More Freq tables, just for comparison*/
PROC FREQ; TABLES dadcash*H4WP39;
RUN;

PROC FREQ; TABLES dadcash*H4WP39/MISSPRINT;
RUN;

PROC FREQ; TABLES dadcash*H4WP39/MISSING;
RUN;

PROC FREQ; TABLES dadcash*H4WP39/LIST;
RUN;

/****In class exercise #5 part 2****

Run a PROC FREQ on the association between depression (anydep) and diabetes (c_joint), 
sorting the data by these variables and using the ORDER=data option for the PROC FREQ statement. 
Use the CHISQ option for the TABLES statement*/
libname SASlab1 "/folders/myfolders/SASskillslab-master";
Data day5; SET saslab1.day5data;
PROC SORT out=day5_sort; by anydep c_joint;
PROC FREQ ORDER=DATA; tables anydep*c_joint/CHISQ; RUN;

/*Experiment with different tests*/
PROC FREQ ORDER=DATA; tables anydep*c_joint/CL; RUN;

/*Now run a PROC FREQ on the association between BMI category (bmi4cat) and diabetes (c_joint). 
You will have to re-sort your data by bmi4cat (ascending – this is the default, you don’t need to specify it) 
and c_joint (descending).  
What is different about this crosstab compared to that for depression and diabetes?*/
libname SASlab1 "/folders/myfolders/SASskillslab-master";
Data day_resort; SET work.day5;
PROC SORT out=day5_resort; by bmi4cat descending c_joint;
PROC FREQ ORDER=DATA; TABLES bmi4cat*c_joint/CL; run;

/*****In class exercise #5 part 3*****

Do people who have diabetes have a larger waist circumference (waist) than people without diabetes (c_joint)?  
Run a PROC TTEST to find out.*/
PROC SORT; BY C_JOINT;
PROC MEANS; VAR waist; BY C_JOINT;
RUN;

PROC TTEST;
CLASS C_Joint;
VAR waist;
RUN;

/*Do people with a history of depression (anydep) 
have a larger waist circumference than people without depression? 
Run a PROC TTEST to find out.*/
PROC TTEST;
CLASS anydep;
VAR waist;
RUN;

/*****In class exercise #5 part 4****

Run an ANOVA with waist circumference as the dependent variable and 
race/ethnicity (ethrace) as the independent variable*/
PROC ANOVA;
CLASS ethrace;
MODEL waist = ethrace;
QUIT;

PROC ANOVA plots (maxpoints=none);
CLASS ethrace;
MODEL waist = ethrace;
MEANS ethrace / hovtest welch;
QUIT;

/*Rerun your analysis using the TUKEY option to obtain pairwise tests*/
PROC ANOVA plots (maxpoints=none);
CLASS ethrace;
MODEL waist = ethrace;
MEANS ethrace / TUKEY;
QUIT;

/*****In class exercise #5 part 5****/
libname SASlab1 "/folders/myfolders/SASskillslab-master";
Data work.lab; SET saslab1.lab5data;

/*Run a crosstab of current smoking (cursmk; rows) and obesity (obese; columns)
use the RELRISK option to obtain the OR and 95% CI.  Don’t forget to sort by cursmk and obese first. 
Paste your code and output below and highlight the OR.*/
PROC SORT DATA LAB out lab_sort; by cursmk obese;
PROC FREQ; TABLES cursmk*obese/RELRISK;

/*Now run a binary logistic regression with the variable obese as the outcome 
and cursmk as the only independent variable*/
PROC LOGISTIC descending;
MODEL obese = cursmk;
RUN;

/*Add the variables male and ethrace to your model. Don’t forget the CLASS statement for ethrace*/
proc logistic descending;
class ethrace / param=ref ref=first;
model obese = cursmk male ethrace;
run;

/*Now add a term for the interaction between gender and smoking to the model*/
proc logistic descending;
class ethrace / param=ref ref=first;
model obese = cursmk male ethrace cursmk*male;
run;

/*Run separate models predicting obesity from cursmk and ethrace for men and women*/
proc logistic descending;
class ethrace / param=ref ref=first;
model obese = cursmk ethrace; where male=1;
run;

proc logistic descending;
class ethrace / param=ref ref=first;
model obese = cursmk ethrace; where male=0;
run;


