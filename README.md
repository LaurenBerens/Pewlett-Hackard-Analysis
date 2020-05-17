# Pewlett-Hackard-Analysis
## My Tables and Data laid out
- Number of [titles] retiring: final_retirement_count_title.csv
- Number of employees with each title: final_title_count.csv
- List of current employees born between 1/1/52-12/31/55: retirement_info.csv
- List of current employees born between 1/1/65-12/31/65: final_mentor_program.csv

### We have been asked to provide data related to up coming retirements, titles held by the employees nearing retirement and the possibility of maintaining a mentorship program.  The mentorship program would allow retirees to work part-time providing support and leadership up and coming employees.  This data is intended to help prepare leadership for replacing retirees quickly with as little negative impact on the company as possible using the possible the mentorship program as well as possible hiring plans.

### One of the most important steps we took in pulling together this data was to create tables with current employees only without duplicate representation of employees in the tables.  One of the biggest challenges was to ensure we used data sets that only included those current employees.  We added (for example) **AND (de.to_date = '9999-01-01')** in order to ensure only current employees were reflected.  Additionally, we had the challenge to ensure our employees were not duplicated within the COUNTs.  We used the following code (for example) to avoid duplicate data.  This strategy worked beautifully in providing accurate data for leadership.

`FROM 
(SELECT emp_no, first_name, last_name, title, from_date, to_date, ROW_NUMBER() OVER 
(PARTITION BY (emp_no)
ORDER BY from_date DESC) rn
FROM initial_mentor_program
) tmp WHERE rn = 1`

### 5% of the current employees are likely to retire within the year.  The titles taking the biggest loss due to retirement will be Engineers, Assistant Engineers and Staff.  Employees titled "Engineer" will be losing 10.5% of their workforce.  Assitant Engineers will lose 16.3% of their workforce. Staff will be losing 13.4% of their collegues.  The main recommendation is to prepare promotions and additional hiring within those areas most immediately to minimize the negative affects of these retirements on current employees.  The other titles have between 0% and 6% projected turnover due to retirement this year which is managable through typical hiring practices.  This data is helpful in making predictions however it does not account for specific retirement plans of employees. Additionally, this data does not consider typical attrition where collegues change employment whether it be within the same company or change companies.  This turnover rate would be helpful in planning for hiring within the year.
