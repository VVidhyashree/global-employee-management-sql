-- Global employee & Payroll Database Project (MySQL)
--create table employees
CREATE TABLE Employees (
  EmployeeID INT PRIMARY KEY,
  FullName VARCHAR(100),
  ManagerID INT,
  HireDate DATE,
  Country VARCHAR(50),
  City VARCHAR(50)
);

--create table payroll
CREATE TABLE Payroll (
  EmployeeID INT,
  ProjectCode VARCHAR(20),
  BaseSalaryUSD DECIMAL(10,2),
  BonusUSD DECIMAL(10,2),
  FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- Insert Sample Data
INSERT INTO Employees VALUES
(1001, 'Liam Carter', 2001, '2021-03-15', 'USA', 'New York'),
(2001, 'Sofia Martinez', 3001, '2020-07-01', 'Spain', 'Madrid'),
(3001, 'Aiko Tanaka', 4001, '2022-11-27', 'Japan', 'Tokyo');


INSERT INTO Payroll VALUES
(1001, 'INTL-A1', 7500, 500),
(2001, 'INTL-B2', 9800, 800),
(3001, 'INTL-A1', 11500, 0);


1. Retrieve all employees
SELECT * FROM Employees;
+------------+----------------+-----------+------------+---------+----------+
| EmployeeID | FullName       | ManagerID | HireDate   | Country | City     |
+------------+----------------+-----------+------------+---------+----------+
|       1001 | Liam Carter    |      2001 | 2021-03-15 | USA     | New York |
|       2001 | Sofia Martinez |      3001 | 2020-07-01 | Spain   | Madrid   |
|       3001 | Aiko Tanaka    |      4001 | 2022-11-27 | Japan   | Tokyo    |
+------------+----------------+-----------+------------+---------+----------+

2. Retrieve all payroll records
SELECT * FROM Payroll;
+------------+-------------+---------------+----------+
| EmployeeID | ProjectCode | BaseSalaryUSD | BonusUSD |
+------------+-------------+---------------+----------+
|       1001 | INTL-A1     |       7500.00 |   500.00 |
|       2001 | INTL-B2     |       9800.00 |   800.00 |
|       3001 | INTL-A1     |      11500.00 |     0.00 |
+------------+-------------+---------------+----------+

  3. Find employees in a specific country
SELECT * FROM Employees WHERE Country = 'USA';
+------------+-------------+-----------+------------+---------+----------+
| EmployeeID | FullName    | ManagerID | HireDate   | Country | City     |
+------------+-------------+-----------+------------+---------+----------+
|       1001 | Liam Carter |      2001 | 2021-03-15 | USA     | New York |
+------------+-------------+-----------+------------+---------+----------+
1 row in set (0.02 sec)

4. List employees hired after 2021
SELECT * FROM Employees WHERE HireDate > '2021-12-31';
+------------+-------------+-----------+------------+---------+-------+
| EmployeeID | FullName    | ManagerID | HireDate   | Country | City  |
+------------+-------------+-----------+------------+---------+-------+
|       3001 | Aiko Tanaka |      4001 | 2022-11-27 | Japan   | Tokyo |
+------------+-------------+-----------+------------+---------+-------+
1 row in set (0.22 sec)

5. Show employees with BaseSalaryUSD greater than 9000
SELECT e.FullName, p.BaseSalaryUSD
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
WHERE p.BaseSalaryUSD > 9000;
+----------------+---------------+
| FullName       | BaseSalaryUSD |
+----------------+---------------+
| Sofia Martinez |       9800.00 |
| Aiko Tanaka    |      11500.00 |
+----------------+---------------+
2 rows in set (0.01 sec)
  
6. Combine employee and payroll info
SELECT e.EmployeeID, e.FullName, e.Country, p.ProjectCode, p.BaseSalaryUSD, p.BonusUSD
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID;
+------------+----------------+---------+-------------+---------------+----------+
| EmployeeID | FullName       | Country | ProjectCode | BaseSalaryUSD | BonusUSD |
+------------+----------------+---------+-------------+---------------+----------+
|       1001 | Liam Carter    | USA     | INTL-A1     |       7500.00 |   500.00 |
|       2001 | Sofia Martinez | Spain   | INTL-B2     |       9800.00 |   800.00 |
|       3001 | Aiko Tanaka    | Japan   | INTL-A1     |      11500.00 |     0.00 |
+------------+----------------+---------+-------------+---------------+----------+
3 rows in set (0.01 sec)

7. Show employees who don’t have payroll records (LEFT JOIN)
SELECT e.EmployeeID, e.FullName, p.ProjectCode
FROM Employees e
LEFT JOIN Payroll p ON e.EmployeeID = p.EmployeeID
WHERE p.EmployeeID IS NULL;
Empty set (0.01 sec)

8. Average salary by country
SELECT e.Country, AVG(p.BaseSalaryUSD + p.BonusUSD) AS AvgSalaryUSD
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Country;
Empty set (0.00 sec)

 9. Count of employees by country
SELECT Country, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Country;
+---------+--------------+
| Country | AvgSalaryUSD |
+---------+--------------+
| USA     |  8000.000000 |
| Spain   | 10600.000000 |
| Japan   | 11500.000000 |
+---------+--------------+
3 rows in set (0.02 sec)

 10. Total payroll cost by project
SELECT ProjectCode, SUM(BaseSalaryUSD + BonusUSD) AS TotalCost
FROM Payroll
GROUP BY ProjectCode;
+-------------+-----------+
| ProjectCode | TotalCost |
+-------------+-----------+
| INTL-A1     |  19500.00 |
| INTL-B2     |  10600.00 |
+-------------+-----------+
2 rows in set (0.00 sec)
  
11. Number of employees reporting to each manager
SELECT ManagerID, COUNT(*) AS StaffCount
FROM Employees
GROUP BY ManagerID
HAVING COUNT(*) > 0;
+-----------+------------+
| ManagerID | StaffCount |
+-----------+------------+
|      2001 |          1 |
|      3001 |          1 |
|      4001 |          1 |
+-----------+------------+
3 rows in set (0.00 sec)

12. Highest paid employee (total compensation)
SELECT FullName, Country, TotalCompUSD
FROM (
  SELECT e.FullName, e.Country, (p.BaseSalaryUSD + p.BonusUSD) AS TotalCompUSD
  FROM Employees e
  JOIN Payroll p ON e.EmployeeID = p.EmployeeID
) AS t
ORDER BY TotalCompUSD DESC
LIMIT 1;
+-------------+---------+--------------+
| FullName    | Country | TotalCompUSD |
+-------------+---------+--------------+
| Aiko Tanaka | Japan   |     11500.00 |
+-------------+---------+--------------+
1 row in set (0.01 sec)
  
13. Employees earning above average salary
SELECT e.FullName, (p.BaseSalaryUSD + p.BonusUSD) AS TotalSalary
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
WHERE (p.BaseSalaryUSD + p.BonusUSD) > (
  SELECT AVG(BaseSalaryUSD + BonusUSD) FROM Payroll
);
+----------------+-------------+
| FullName       | TotalSalary |
+----------------+-------------+
| Sofia Martinez |    10600.00 |
| Aiko Tanaka    |    11500.00 |
+----------------+-------------+
2 rows in set (0.01 sec)
  
14. Second highest salary
SELECT e.FullName, (p.BaseSalaryUSD + p.BonusUSD) AS TotalSalary
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
ORDER BY TotalSalary DESC
LIMIT 1 OFFSET 1;
+----------------+-------------+
| FullName       | TotalSalary |
+----------------+-------------+
| Sofia Martinez |    10600.00 |
+----------------+-------------+
1 row in set (0.00 sec)

15. List employees along with their manager
SELECT e.FullName AS Employee, m.FullName AS Manager
FROM Employees e
JOIN Employees m ON e.ManagerID = m.EmployeeID;
+----------------+----------------+
| Employee       | Manager        |
+----------------+----------------+
| Liam Carter    | Sofia Martinez |
| Sofia Martinez | Aiko Tanaka    |
+----------------+----------------+
2 rows in set (0.00 sec)

16. Employees grouped by project
SELECT p.ProjectCode, GROUP_CONCAT(e.FullName) AS Employees
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
GROUP BY p.ProjectCode;
+-------------+-------------------------+
| ProjectCode | Employees               |
+-------------+-------------------------+
| INTL-A1     | Liam Carter,Aiko Tanaka |
| INTL-B2     | Sofia Martinez          |
+-------------+-------------------------+
2 rows in set (0.01 sec)

17. Find employees with no bonus
SELECT e.FullName, p.BaseSalaryUSD
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
WHERE p.BonusUSD = 0;
+-------------+---------------+
| FullName    | BaseSalaryUSD |
+-------------+---------------+
| Aiko Tanaka |      11500.00 |
+-------------+---------------+
1 row in set (0.00 sec)
  
18. Total bonus paid per country
SELECT e.Country, SUM(p.BonusUSD) AS TotalBonusUSD
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Country;
+---------+---------------+
| Country | TotalBonusUSD |
+---------+---------------+
| USA     |        500.00 |
| Spain   |        800.00 |
| Japan   |          0.00 |
+---------+---------------+
3 rows in set (0.01 sec)

19. Rank employees by total compensation
SELECT e.FullName,
       e.Country,
       (p.BaseSalaryUSD + p.BonusUSD) AS TotalCompUSD,
       RANK() OVER (ORDER BY (p.BaseSalaryUSD + p.BonusUSD) DESC) AS SalaryRank
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID;
+----------------+---------+--------------+------------+
| FullName       | Country | TotalCompUSD | SalaryRank |
+----------------+---------+--------------+------------+
| Aiko Tanaka    | Japan   |     11500.00 |          1 |
| Sofia Martinez | Spain   |     10600.00 |          2 |
| Liam Carter    | USA     |      8000.00 |          3 |
+----------------+---------+--------------+------------+
3 rows in set (0.01 sec)
  
20. Running total of payroll cost
SELECT p.ProjectCode,
       p.BaseSalaryUSD + p.BonusUSD AS Salary,
       SUM(p.BaseSalaryUSD + p.BonusUSD) OVER (PARTITION BY p.ProjectCode ORDER BY p.BaseSalaryUSD) AS RunningTotal
FROM Payroll p;
+-------------+----------+--------------+
| ProjectCode | Salary   | RunningTotal |
+-------------+----------+--------------+
| INTL-A1     |  8000.00 |      8000.00 |
| INTL-A1     | 11500.00 |     19500.00 |
| INTL-B2     | 10600.00 |     10600.00 |
+-------------+----------+--------------+
3 rows in set (0.01 sec)

21. Country-wise compensation split into salary & bonus
SELECT e.Country,
       SUM(p.BaseSalaryUSD) AS TotalBase,
       SUM(p.BonusUSD) AS TotalBonus,
       ROUND(SUM(p.BonusUSD) / SUM(p.BaseSalaryUSD + p.BonusUSD) * 100, 2) AS BonusPercent
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Country;
+---------+-----------+------------+--------------+
| Country | TotalBase | TotalBonus | BonusPercent |
+---------+-----------+------------+--------------+
| USA     |   7500.00 |     500.00 |         6.25 |
| Spain   |   9800.00 |     800.00 |         7.55 |
| Japan   |  11500.00 |       0.00 |         0.00 |
+---------+-----------+------------+--------------+
3 rows in set (0.01 sec)
  
22. Count of employees with bonus > 0 vs bonus = 0
SELECT CASE WHEN p.BonusUSD > 0 THEN 'Has Bonus' ELSE 'No Bonus' END AS BonusStatus,
       COUNT(*) AS EmployeeCount
FROM Payroll p
GROUP BY BonusStatus;
+-------------+---------------+
| BonusStatus | EmployeeCount |
+-------------+---------------+
| Has Bonus   |             2 |
| No Bonus    |             1 |
+-------------+---------------+
2 rows in set (0.00 sec)

23. Highest salary per country using GROUP_CONCAT
SELECT e.Country,
       MAX(p.BaseSalaryUSD + p.BonusUSD) AS MaxComp,
       GROUP_CONCAT(e.FullName) AS EmployeesWithMax
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Country;
+---------+----------+------------------+
| Country | MaxComp  | EmployeesWithMax |
+---------+----------+------------------+
| Japan   | 11500.00 | Aiko Tanaka      |
| Spain   | 10600.00 | Sofia Martinez   |
| USA     |  8000.00 | Liam Carter      |
+---------+----------+------------------+
3 rows in set (0.00 sec)
  
24. Employees whose salary > country average
SELECT e.FullName, e.Country, (p.BaseSalaryUSD + p.BonusUSD) AS TotalSalary
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
WHERE (p.BaseSalaryUSD + p.BonusUSD) > (
  SELECT AVG(p2.BaseSalaryUSD + p2.BonusUSD)
  FROM Employees e2
  JOIN Payroll p2 ON e2.EmployeeID = p2.EmployeeID
  WHERE e2.Country = e.Country
);
Empty set (0.00 sec)
  
25. Employees whose managers earn less than them
SELECT e.FullName, e.ManagerID
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
WHERE (p.BaseSalaryUSD + p.BonusUSD) >
(SELECT p2.BaseSalaryUSD + p2.BonusUSD
 FROM Payroll p2
 WHERE p2.EmployeeID = e.ManagerID);
Empty set (0.00 sec)

26. Rank employees within each country by salary
SELECT e.Country, e.FullName,
       (p.BaseSalaryUSD + p.BonusUSD) AS TotalSalary,
       RANK() OVER (PARTITION BY e.Country ORDER BY (p.BaseSalaryUSD + p.BonusUSD) DESC) AS RankInCountry
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID;
+---------+----------------+-------------+---------------+
| Country | FullName       | TotalSalary | RankInCountry |
+---------+----------------+-------------+---------------+
| Japan   | Aiko Tanaka    |    11500.00 |             1 |
| Spain   | Sofia Martinez |    10600.00 |             1 |
| USA     | Liam Carter    |     8000.00 |             1 |
+---------+----------------+-------------+---------------+
3 rows in set (0.00 sec)


27. Rolling average of salaries
SELECT e.Country, e.FullName,
       AVG(p.BaseSalaryUSD + p.BonusUSD)
       OVER (PARTITION BY e.Country ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS RollingAvg
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID;
+---------+----------------+--------------+
| Country | FullName       | RollingAvg   |
+---------+----------------+--------------+
| Japan   | Aiko Tanaka    | 11500.000000 |
| Spain   | Sofia Martinez | 10600.000000 |
| USA     | Liam Carter    |  8000.000000 |
+---------+----------------+--------------+
3 rows in set (0.00 sec)

28. Percent of total payroll per employee (global)
SELECT e.FullName,
       (p.BaseSalaryUSD + p.BonusUSD) AS TotalSalary,
       ROUND((p.BaseSalaryUSD + p.BonusUSD) / SUM(p.BaseSalaryUSD + p.BonusUSD) OVER() * 100, 2) AS PercentOfTotal
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID;
+----------------+-------------+----------------+
| FullName       | TotalSalary | PercentOfTotal |
+----------------+-------------+----------------+
| Liam Carter    |     8000.00 |          26.58 |
| Sofia Martinez |    10600.00 |          35.22 |
| Aiko Tanaka    |    11500.00 |          38.21 |
+----------------+-------------+----------------+
3 rows in set (0.00 sec)

29. Country-wise count of employees in each project (dynamic cross tab)
SELECT e.Country, p.ProjectCode, COUNT(*) AS EmployeeCount
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
GROUP BY e.Country, p.ProjectCode
ORDER BY e.Country;
+---------+-------------+---------------+
| Country | ProjectCode | EmployeeCount |
+---------+-------------+---------------+
| Japan   | INTL-A1     |             1 |
| Spain   | INTL-B2     |             1 |
| USA     | INTL-A1     |             1 |
+---------+-------------+---------------+
3 rows in set (0.00 sec)

30. Bonus category classification
SELECT e.FullName, 
       CASE 
         WHEN p.BonusUSD = 0 THEN 'No Bonus'
         WHEN p.BonusUSD < 600 THEN 'Low Bonus'
         ELSE 'High Bonus'
       END AS BonusCategory
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID;
+----------------+---------------+
| FullName       | BonusCategory |
+----------------+---------------+
| Liam Carter    | Low Bonus     |
| Sofia Martinez | High Bonus    |
| Aiko Tanaka    | No Bonus      |
+----------------+---------------+
3 rows in set (0.00 sec)
  
//create table projects
CREATE TABLE Projects (
  ProjectCode VARCHAR(20) PRIMARY KEY,
  ProjectName VARCHAR(100),
  ClientCountry VARCHAR(50)
);

//insert into project table
INSERT INTO Projects VALUES
('INTL-A1', 'Global CRM Rollout', 'USA'),
('INTL-B2', 'Data Migration Europe', 'Spain');

31. Join all three tables to see project & client info
SELECT e.FullName, e.Country AS EmployeeCountry,
       pr.ProjectName, pr.ClientCountry,
       (p.BaseSalaryUSD + p.BonusUSD) AS TotalCompUSD
FROM Employees e
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
JOIN Projects pr ON p.ProjectCode = pr.ProjectCode;
+----------------+-----------------+-----------------------+---------------+--------------+
| FullName       | EmployeeCountry | ProjectName           | ClientCountry | TotalCompUSD |
+----------------+-----------------+-----------------------+---------------+--------------+
| Liam Carter    | USA             | Global CRM Rollout    | USA           |      8000.00 |
| Sofia Martinez | Spain           | Data Migration Europe | Spain         |     10600.00 |
| Aiko Tanaka    | Japan           | Global CRM Rollout    | USA           |     11500.00 |
+----------------+-----------------+-----------------------+---------------+--------------+
3 rows in set (0.00 sec)

32. Total cost by client country
SELECT pr.ClientCountry, SUM(p.BaseSalaryUSD + p.BonusUSD) AS TotalCostUSD
FROM Payroll p
JOIN Projects pr ON p.ProjectCode = pr.ProjectCode
GROUP BY pr.ClientCountry;
+---------------+--------------+
| ClientCountry | TotalCostUSD |
+---------------+--------------+
| USA           |     19500.00 |
| Spain         |     10600.00 |
+---------------+--------------+
2 rows in set (0.00 sec)









