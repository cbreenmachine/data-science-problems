---
title: "Analysis 1: UNC Salaries"
author: "Coleman Breen"
date:  "September 24, 2018"
output: 
  html_document:
    keep_md: TRUE
---

#Instructions

**Assigned:** Friday, September 7, 2018

**Due:** Friday, September 14, 2018 by 5:00 PM

**Submission:** Submit via an electronic document on Sakai. Must be submitted as an HTML file generated in RStudio. For each question, show your R code that you used to answer each question in the provided chunks. When a written response is required, be sure to answer the entire question in complete sentences outside the code chunks. When figures are required, be sure to follow all requirements to receive full credit. Point values are assigned for every part of this analysis.

#Introduction

Universities are typically opaque, bureaucratic institutions. To be transparent to tax payers, many public schools, such as the University of North Carolina, openly report **[salary information](http://www.newsobserver.com/news/databases/public-salaries/)**. In this assignment, we will analyze this information to answer pivotal questions that have endured over the course of time. The most recent salary data for UNC-Chapel Hill faculty and staff has already been downloaded in CSV format and titled *"UNC_System_Salaries Search and Report.csv"*. If you scan the spreadsheet, you will notice that Dr. Mario is not listed. People get depressed when they see that many digits after the decimal.

To answer all the questions, you will need the R package `tidyverse` to make figures and utilize `dplyr` functions.




#Data Information

Make sure the CSV data file is contained in the folder of your RMarkdown file. First, we start by using the `read_csv` function from the `readr` package found within the tidyverse. The code below executes this process by creating a tibble in your R environment named "salary".

```r
salary=read_csv("UNC_System_Salaries Search and Report.csv")
```

Now, we will explore the information that is contained in this dataset. The code below provides the names of the variables contained in the dataset.


```r
names(salary)
```

```
##  [1] "Name"                  "campus2"              
##  [3] "dept"                  "position"             
##  [5] "PRIMARY_WORKING_TITLE" "hiredate"             
##  [7] "exempt"                "fte"                  
##  [9] "employed"              "statesal"             
## [11] "nonstsal"              "totalsal"             
## [13] "stservyr"
```

Next, we will examine the type of data contains in these different variables. 

```r
str(salary,give.attr=F)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	12646 obs. of  13 variables:
##  $ Name                 : chr  "AACHOUI, YOUSSEF" "AARNIO, REA T" "ABAJAS, YASMINA L" "ABARBANELL, JEFFERY S" ...
##  $ campus2              : chr  "UNC-CHAPEL HILL" "UNC-CHAPEL HILL" "UNC-CHAPEL HILL" "UNC-CHAPEL HILL" ...
##  $ dept                 : chr  "Microbiology and Immunology" "SW-Research Projects" "Peds-Hematology/Oncology" "Kenan-Flagler Bus Sch" ...
##  $ position             : chr  "Research Professional, Medical" "Functional Paraprofessional" "Assistant Professor" "Associate Professor" ...
##  $ PRIMARY_WORKING_TITLE: chr  "Research Associate" "Graphic Designer" "NODESCR" "Associate Professor" ...
##  $ hiredate             : chr  "10/10/2011" "1/14/2013" "7/1/2015" "1/1/1999" ...
##  $ exempt               : chr  "Exempt from Personnel Act" "Subject to State Personnel Act" "Exempt from Personnel Act" "Exempt from Personnel Act" ...
##  $ fte                  : num  1 0.8 1 1 1 1 1 1 1 1 ...
##  $ employed             : int  12 12 12 9 12 12 12 9 12 9 ...
##  $ statesal             : chr  NA NA NA NA ...
##  $ nonstsal             : chr  NA NA NA NA ...
##  $ totalsal             : num  49128 33257 139405 181000 41098 ...
##  $ stservyr             : int  1 5 2 20 6 8 6 1 19 1 ...
```

You will notice that the variable "hiredate" is recorded as a character. The following code will first modify the original dataset to change this to a date variable with the format *yyyy-mm-dd*. Then, we will remove the hyphens to create a numeric variable as *yyyymmdd*. Finally, in the spirit of tidyverse, we will convert this data frame to a tibble


```r
salary$hiredate=as.Date(salary$hiredate, format="%m/%d/%Y")
salary$hiredate=as.numeric(gsub("-","",salary$hiredate))
salary=as.tibble(salary)
```

Now, we will use `head()` to view of first five rows and the modifications made to the original data. The rest of the assignment will extend off this modified dataset named `salary` which by now should be in your global environment.

```r
head(salary,5)
```

```
## # A tibble: 5 x 13
##   Name  campus2 dept  position PRIMARY_WORKING~ hiredate exempt   fte
##   <chr> <chr>   <chr> <chr>    <chr>               <dbl> <chr>  <dbl>
## 1 AACH~ UNC-CH~ Micr~ Researc~ Research Associ~ 20111010 Exemp~   1  
## 2 AARN~ UNC-CH~ SW-R~ Functio~ Graphic Designer 20130114 Subje~   0.8
## 3 ABAJ~ UNC-CH~ Peds~ Assista~ NODESCR          20150701 Exemp~   1  
## 4 ABAR~ UNC-CH~ Kena~ Associa~ Associate Profe~ 19990101 Exemp~   1  
## 5 ABAR~ UNC-CH~ Inst~ Researc~ Research Techni~ 20110912 Subje~   1  
## # ... with 5 more variables: employed <int>, statesal <chr>,
## #   nonstsal <chr>, totalsal <dbl>, stservyr <int>
```

# Assignment


## Part 1: Reducing the Data to a Smaller Set of Interest


###Q1 *(2 Points)* 

Create a new dataset named "salary2" that only contains the following variables:

- "Name"

- "dept"

- "position"

- "hiredate"

- "exempt"

- "totalsal"

Then, use the `names()` function to display the variable names of `salary2`.

```r
#--> Create salary2 using select
salary2 <- select(salary, 'Name', 'dept', 'position', 'hiredate', 'exempt', 'totalsal')
names(salary2)
```

```
## [1] "Name"     "dept"     "position" "hiredate" "exempt"   "totalsal"
```

###Q2 *(2 Points)*

Now, we modify `salary2`. Rename the variables "dept","position","exempt","totalsal" to "Department","Job","E", and "Salary", respectively. Do this for a new dataset called "salary3" and use `names()` to display the variable names of `salary3`.

```r
#--> Rename variables
salary3 <- transmute(salary2, Department=dept, Job=position, E=exempt, Salary=totalsal, hiredate)
names(salary3)
```

```
## [1] "Department" "Job"        "E"          "Salary"     "hiredate"
```

###Q3 *(2 Points)*

Now, we modify `salary3`. Create a new variable called "HireYear" that only contains the first four digits of the variable "hiredate" in a new dataset named "salary4". *Hint: Use the concept seen in the conversion of flight times to minutes since midnight.* Use the function `str()` to ensure that your new variable "HireYear" reports the year of the date that the employee was hired.


```r
#--> Add a 'HireYear' variable
salary3 <- mutate(salary3, HireYear = hiredate %/% 10000)
str(salary3)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	12646 obs. of  6 variables:
##  $ Department: chr  "Microbiology and Immunology" "SW-Research Projects" "Peds-Hematology/Oncology" "Kenan-Flagler Bus Sch" ...
##  $ Job       : chr  "Research Professional, Medical" "Functional Paraprofessional" "Assistant Professor" "Associate Professor" ...
##  $ E         : chr  "Exempt from Personnel Act" "Subject to State Personnel Act" "Exempt from Personnel Act" "Exempt from Personnel Act" ...
##  $ Salary    : num  49128 33257 139405 181000 41098 ...
##  $ hiredate  : num  20111010 20130114 20150701 19990101 20110912 ...
##  $ HireYear  : num  2011 2013 2015 1999 2011 ...
```
Looking at the output of str() from above, we see that HireYear has values 2011, 2013, 2015, etc. The mutate() call did what we wanted!

###Q4 *(2 points)*

Now, we modify `salary4`. Create a new variable called "YrsEmployed" which reports the number of years the employee has worked at UNC. Create a new dataset named "Salary5" and again use `str()` to display the variables in `salary5`.

```r
#--> Create salary4 with 'YrsEmployed' varibale
salary4 <- mutate(salary3, YrsEmployed = 2018 - HireYear)

#--> Create salary5 
salary5 <- salary4 
str(salary5)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	12646 obs. of  7 variables:
##  $ Department : chr  "Microbiology and Immunology" "SW-Research Projects" "Peds-Hematology/Oncology" "Kenan-Flagler Bus Sch" ...
##  $ Job        : chr  "Research Professional, Medical" "Functional Paraprofessional" "Assistant Professor" "Associate Professor" ...
##  $ E          : chr  "Exempt from Personnel Act" "Subject to State Personnel Act" "Exempt from Personnel Act" "Exempt from Personnel Act" ...
##  $ Salary     : num  49128 33257 139405 181000 41098 ...
##  $ hiredate   : num  20111010 20130114 20150701 19990101 20110912 ...
##  $ HireYear   : num  2011 2013 2015 1999 2011 ...
##  $ YrsEmployed: num  7 5 3 19 7 9 6 2 13 2 ...
```


###Q5 *(4 points)*

Now, we modify `salary5` to create our final dataset named "salary.final". Use the pipe `%>%` to make the following changes:

- Drop the variables "hiredate" and "HireYear". 

- Sort the observations by "YrsEmployed" and "Salary", in that order. 

- Rearrange the variables so that "YrsEmployed" and "Salary" are the first two variables in the dataset, in that order, without removing any of the other variables.

After you have used the `%>%` to make these changes, use the function `head()` to display the first 10 rows of `salary.final`.


```r
#--> Final cleaning pipeline
salary5 %>%
  select(-hiredate, -HireYear) %>% # Drop "hiredate", "HireYear"
  arrange(YrsEmployed, Salary) %>% # Sort by "YrsEmployed", "Salary"
  select(YrsEmployed, Salary, everything()) -> salary.final # Order the columns

#--> Display the fruits of our labor
head(salary.final, 10)
```

```
## # A tibble: 10 x 5
##    YrsEmployed Salary Department        Job                   E           
##          <dbl>  <dbl> <chr>             <chr>                 <chr>       
##  1           1  16500 School of Media ~ Library Assistant     Subject to ~
##  2           1  16852 Religious Studies Administrative / Off~ Subject to ~
##  3           1  17000 School of Media ~ Administrative / Off~ Subject to ~
##  4           1  17668 Ctr Health Prom ~ Research Asst/Tech, ~ Subject to ~
##  5           1  18700 Computer Science  Administrative / Off~ Subject to ~
##  6           1  19276 Ath Olympic Spor~ Administrative / Off~ Subject to ~
##  7           1  19750 Jewish Studies    Administrative / Off~ Subject to ~
##  8           1  21500 Kenan-Flagler Bu~ Administrative / Off~ Subject to ~
##  9           1  21850 Medicine-Gastroe~ Assistant Professor   Exempt from~
## 10           1  22575 Ctr Health Prom ~ Research Asst/Tech, ~ Subject to ~
```

```r
#--> Remove the old datasets to conserve RAM
remove(salary, salary2, salary3, salary4, salary5)
```

##Part 2: Answering Questions Based on All Data

### Q6 *(2 Points)*

What is the average salary of employees in the Neurosurgery Department?

Code *(1 Point)*:

```r
#--> Filter down to Neurosurgery
salary.final %>%
  filter(Department=="Neurosurgery") %>%
  select(Salary) %>%
  colMeans()
```

```
##   Salary 
## 340658.6
```

Answer *(1 Point)*: The mean salary for those in the Neurosurgery department in the UNC System is $340,659.

### Q7 *(4 Points)* 

How many employees have worked in the Biology Department for more than 5 years and are exempt from personnel act?

Code *(2 Points)*:

```r
#--> Filter down to Biology Department, worked for more than 5 years, exempt
salary.final %>%
  filter(Department == "Biology") %>%
  filter(YrsEmployed > 5) %>%
  filter(E == "Exempt from Personnel Act") %>%
  nrow()
```

```
## [1] 49
```

Answer *(2 Points)*: There are 49 employees that have worked in the Biology Department for more than 5 years and that are also exempt from the personnel act.

###Q8 *(4 Points)*

What is the median years employeed for employees from either the Computer Science Department or the Mathematics Department?  
I'm curious so I'll do both.

Code *(2 Points)*:

```r
#--> Median for Comp Sci
salary.final %>%
  filter(Department == "Computer Science") %>%
  select(Salary) %>%
  lapply(median)
```

```
## $Salary
## [1] 102881.1
```

```r
#--> Median for Mathematics
salary.final %>%
  filter(Department == "Mathematics") %>%
  select(Salary) %>%
  lapply(median)
```

```
## $Salary
## [1] 98392
```

Answer *(2 Points)*: The median salary for Computer Science employees is $102,881 while the median salary for matheamatics employees is $98,392. 

##Part 3: Answering Questions Based on Summarized Data

###Q9 *(4 Points)*

Based off the data in `salary.final`, create a grouped summary based off combinations of "Department" and "YrsEmployed". Call the new data set "deptyear_summary". Your summarized tibble, `deptyear_summary`, should report all of the following statistics with corresponding variable names.

- "n" = number of employees for each combination

- "mean" = average salary for each combination

- "sd" = standard deviation of salary for each combination.

In the process, make sure you use `ungroup()` with the pipe `%>%` to release the grouping so future work is no longer group specific. Following the creation of `deptyear_summary`, prove that your code worked by using `head()` to view the first 5 rows.

```r
#--> Grouping pipeline
salary.final %>%
  group_by(Department, YrsEmployed) %>%
  transmute('NumberEmployees' = n(),
            'MeanSalary' = mean(Salary),
            'StdSalary' = sd(Salary)) -> deptyear_summary 

#--> Ungroup and prove it
deptyear_summary %>%
  ungroup() %>%
  head(5)
```

```
## # A tibble: 5 x 5
##   Department              YrsEmployed NumberEmployees MeanSalary StdSalary
##   <chr>                         <dbl>           <int>      <dbl>     <dbl>
## 1 School of Media and Jo~           1               8     47130.    26488.
## 2 Religious Studies                 1               1     16852       NaN 
## 3 School of Media and Jo~           1               8     47130.    26488.
## 4 Ctr Health Prom and Di~           1               5     36949.    19793.
## 5 Computer Science                  1               4     49355.    22054.
```

###Q10 *(4 Points)*

Using the summarized data in `deptyear_summary`, use the `dplyr` functions to identify the 3 departments that award the highest average salary for employees who have been employed for 7 years. The output should only show the 3 departments along with the corresponding years employeed, which should all be 7, and the three summarizing statistics. 
Furthermore, explain why the standard deviation for one of the 3 departments in your list has a salary standard deviation of "NaN". What does this mean and how did it occur?

Code *(2 Points)*:

```r
#--> Filter down and get highest paying departments
deptyear_summary %>%
  filter(YrsEmployed == 7) %>%
  unique() %>%
  arrange(desc(MeanSalary)) %>%
  head(3)
```

```
## # A tibble: 3 x 5
## # Groups:   Department, YrsEmployed [3]
##   Department         YrsEmployed NumberEmployees MeanSalary StdSalary
##   <chr>                    <dbl>           <int>      <dbl>     <dbl>
## 1 Orthopaedics                 7               2    430372.   177975.
## 2 Neurosurgery                 7               1    390176.      NaN 
## 3 Ath Administration           7               2    373861.   469508.
```

Answer *(2 Points)*: The three departments with the employees with seven years of employment with the highest average salary are Orthopaedics ($430,373), Neurosurgery ($390,177), and Ath Administration ($373,861). 

The salary of the employee belonging to the Neurosurgery department with seven years of experience has a NaN (Not a Number) standard deviation because there is only one observation. You cannot compute the standard deviation of a single observation since it represents the spread of multiple observations.

###Q11 *(4 points)*

Create a scatter plot using `geom_point()` along with fitted lines using `geom_smooth` with the argument `method="lm"` showing the linear relationship between average salary and the years employeed. For this plot use the summarized data in `deptyear_summary`. Following the plot, please explain what this plot suggests about the relationship between the salary a UNC employee makes and ho many years that employee has served. Make reference to the figure and use descriptive adjectives and terms that are appropriate for discussing linear relationships.

Code and Figure *(2 Points)*:

```r
#--> Create plot with appropriate labels
ggplot(deptyear_summary, aes(x = YrsEmployed, y = MeanSalary)) + 
  geom_point() +
  geom_smooth(method = 'lm', color = 'red') +
  ylab('Mean salary by department (USD)') +
  xlab('Number of years employed') +
  ggtitle('Relationship between years employed and salary of UNC system employees')
```

![](unc_system_salaries_analysis_files/figure-html/unnamed-chunk-16-1.png)<!-- -->
  
Answer *(2 Points)*: It appears that there is slightly posive relationship between the average salary of employees belonging to a department and the number of years those employees have worked for the UNC system. It seems that as employees work longer and move up the ranks they will typically earn more money. Thus with seniority comes salary. However, there is quite a bit of spread and several outliers where the salaries are much higher than the majority of those in the scatter.

###Q12 *(6 Points)*

The purpose of summarizing the data was to analyze the previously discussed linear relationship by group. In `deptyear_summary`, there are 702 unique departments represented. You can verify this by using `length(unique(deptyear_summary$Department))`. In this part, I want you to select 3 academic departments, not previously discussed, and in one figure, display the scatter plots and fitted regression lines representing the relationship between average salary and years employed in three different colors. Then, in complete sentences, I want you to state what departments you chose and explain the differences and/or similarities between the groups regarding the previously mentioned relationship. Compare departments on the starting salary and the rate of increase in salary based on the fitted lines.


Code and Figure: *(3 Points)*:

```r
#--> Pick three departments:
# Asian studies --> because I am minoring in Hindi-Urdu and this is their dept.
# Biology --> because I work in a bio lab - how much does my boss make?
# Statistics and Operations Research --> because I am STAN major.
my_depts_v <- c("Asian Studies", "Biology", "Statistics and Operations Res")

#--> Filter down and graph
deptyear_summary %>%
  filter(Department %in% my_depts_v) %>%
  ggplot(aes(x = YrsEmployed, y = MeanSalary, color = Department)) +
  geom_point() +
  geom_smooth(method = 'lm') +
  ylab('Mean salary by department (USD)') +
  xlab('Number of years employed') +
  ggtitle('Relationship between years employed and salary of UNC employees')
```

![](unc_system_salaries_analysis_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

Answer *(3 Points)*: I chose to look at the Asian Studies, Biology, and Statistics and Operations Research departments for my analysis. The Asian Studies and Biology departments' salaries grow with number of years employed at a similar rate (roughly a 1,400 dollar increase with every year of experience). However, Biology employees start at least 10,000 dollars higher on average than their Asian Studies counterparts. The Statistics Department employees start even higher than Biolgy (and consequently Asian Studies) employees and their mean salaries grow even faster than both of the other departments' employees'. For every 10 years of experience, Statistics Department employees' salaries increase by approximately 2,500 dollars. Out of these three groups, Statistics Department employees have the highest starting salary and fastet wage growth.
