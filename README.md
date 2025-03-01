# Employees-Analysis
This project, Employee Data Analysis, was an opportunity for me to apply data analysis techniques to an employee dataset and extract meaningful insights. The dataset contained information such as employee names, locations, salaries, and reporting structures. My primary objective was to understand salary distribution, analyze hierarchical relationships, and optimize the processing of this data.

Questions for Analysis Using SQL:
1. What is the gender breakdown of employees in the company?
2. What is the race/ethnicity breakdown of employees in the company?
3. What is the age distribution of employees in the company?
4. How many employees work at headquarters versus remote locations?
5. What is the average length of employment for employees who have been terminated?
6. How does the gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate?
9. What is the distribution of employees across locations by state?
10. How has the company's employee count changed over time based on hire and term dates?
11. What is the tenure distribution for each department?

To achieve this, I leveraged Python (pandas, collections) for data manipulation and analysis. One of the key challenges was structuring the employee hierarchy based on reporting managers. To solve this, I implemented Topological Sorting using Kahn’s Algorithm (BFS Approach), which ensured that employees were arranged in the correct order according to their reporting relationships. Additionally, I conducted a salary analysis and identified the maximum total salary as 503,350, providing valuable insights into compensation distribution.

Through this project, I gained hands-on experience working with large datasets and improved my ability to apply graph algorithms to real-world problems. I also learned how memoization can significantly optimize computational efficiency when processing hierarchical data. This experience reinforced my understanding of data structures, algorithms, and performance optimization techniques in a practical scenario.

In conclusion, this project successfully helped me analyze employee salary distributions and organizational structures. The use of graph-based algorithms proved to be an efficient approach to managing hierarchical data. Looking ahead, I see potential for further enhancements, such as predictive analytics for salary trends and more advanced data visualizations to provide deeper insights.
