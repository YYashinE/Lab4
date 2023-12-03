-- 1. Создаем таблицу сотрудников
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(100),
    BirthDate DATE,
    StartDate DATE,
    Position VARCHAR(50),
    EmployeeLevel VARCHAR(10),
    Salary INT,
    DepartmentID INT,
    HasRights BOOLEAN
);

-- 2. Создаем таблицу отделов
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    HeadFullName VARCHAR(100),
    NumberOfEmployees INT
);

-- 3. Создаем таблицу оценок сотрудников
CREATE TABLE EmployeeRatings (
    EmployeeID INT,
    Quarter INT,
    Rating CHAR(1),
    PRIMARY KEY (EmployeeID, Quarter)
);

-- 4. Заполняем таблицу сотрудников
INSERT INTO Employees VALUES
(1, 'Иванов Иван Иванович', '1990-01-15', '2015-03-01', 'Разработчик', 'middle', 60000, 1, TRUE),
(2, 'Петров Петр Петрович', '1985-05-20', '2016-01-10', 'Бухгалтер', 'senior', 80000, 2, TRUE),
(3, 'Сидорова Анна Владимировна', '1992-11-30', '2018-07-05', 'Тестировщик', 'jun', 50000, 3, TRUE),
(4, 'Кузнецова Ольга Сергеевна', '1988-09-12', '2017-09-22', 'Разработчик', 'lead', 90000, 1, FALSE),
(5, 'Морозов Дмитрий Алексеевич', '1995-03-08', '2019-02-14', 'Аналитик', 'senior', 75000, 2, TRUE);

-- 5. Заполняем таблицу отделов
INSERT INTO Departments VALUES
(1, 'IT отдел', 'Кузнецова Ольга Сергеевна', 2),
(2, 'Бухгалтерский отдел', 'Петров Петр Петрович', 1),
(3, 'Тестировочный отдел', 'Сидорова Анна Владимировна', 1);

-- 6. Заполняем таблицу оценок сотрудников
INSERT INTO EmployeeRatings VALUES
(1, 1, 'A'), (1, 2, 'B'), (1, 3, 'C'), (1, 4, 'D'),
(2, 1, 'B'), (2, 2, 'C'), (2, 3, 'D'), (2, 4, 'E'),
(3, 1, 'C'), (3, 2, 'C'), (3, 3, 'B'), (3, 4, 'A'),
(4, 1, 'A'), (4, 2, 'A'), (4, 3, 'A'), (4, 4, 'A'),
(5, 1, 'B'), (5, 2, 'B'), (5, 3, 'C'), (5, 4, 'D');

-- 7. Добавляем новый отдел
INSERT INTO Departments VALUES
(4, 'Отдел Интеллектуального анализа данных', 'Новый Руководитель', 2);

-- 8. Добавляем сотрудников в новый отдел
INSERT INTO Employees VALUES
(6, 'Новый Руководитель', '1980-01-01', '2023-01-01', 'Руководитель отдела', 'lead', 100000, 4, TRUE),
(7, 'Сотрудник 1', '1990-02-02', '2023-01-15', 'Аналитик', 'jun', 55000, 4, TRUE),
(8, 'Сотрудник 2', '1995-03-03', '2023-01-20', 'Аналитик', 'jun', 55000, 4, TRUE);

-- 9. Выполняем запросы
-- 6.1
SELECT EmployeeID, FullName, StartDate FROM Employees;

-- 6.2
SELECT TOP 3 EmployeeID, FullName, StartDate FROM Employees;

-- 6.3
SELECT EmployeeID FROM Employees WHERE Position = 'Водитель';

-- 6.4
SELECT DISTINCT EmployeeID FROM EmployeeRatings WHERE Rating IN ('D', 'E');

-- 6.5
SELECT MAX(Salary) AS HighestSalary FROM Employees;

-- 6.6
SELECT DepartmentName FROM Departments ORDER BY NumberOfEmployees DESC LIMIT 1;

-- 6.7
SELECT EmployeeID, FullName, StartDate FROM Employees ORDER BY StartDate DESC;

-- 6.8
SELECT EmployeeLevel, AVG(Salary) AS AverageSalary FROM Employees GROUP BY EmployeeLevel;

-- 6.9
ALTER TABLE Employees ADD COLUMN AnnualBonusCoefficient FLOAT;

UPDATE Employees
SET AnnualBonusCoefficient = 1 +
    CASE WHEN Rating = 'A' THEN 0.2
         WHEN Rating = 'B' THEN 0.1
         WHEN Rating = 'D' THEN -0.1
         WHEN Rating = 'E' THEN -0.2
         ELSE 0
    END;


    
SELECT FullName
FROM Employees
ORDER BY Salary DESC
LIMIT 1;

SELECT FullName
FROM Employees
ORDER BY FullName;

SELECT EmployeeLevel, AVG(AGE(CURRENT_DATE, StartDate)) AS AverageExperience
FROM Employees
GROUP BY EmployeeLevel;


SELECT e.FullName, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;


SELECT d.DepartmentName, e.FullName, e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE (e.DepartmentID, e.Salary) IN (
    SELECT DepartmentID, MAX(Salary) AS MaxSalary
    FROM Employees
    GROUP BY DepartmentID
);



SELECT d.DepartmentName
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
ORDER BY e.Salary * e.BonusCoefficient DESC
LIMIT 1;



UPDATE Employees
SET Salary = 
  CASE 
    WHEN BonusCoefficient > 1.2 THEN Salary * 1.2
    WHEN BonusCoefficient >= 1 AND BonusCoefficient <= 1.2 THEN Salary * 1.1
    ELSE Salary
  END;


SELECT
  d.DepartmentName AS "Название отдела",
  e.FullName AS "Фамилия руководителя",
  COUNT(e.EmployeeID) AS "Количество сотрудников",
  AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.StartDate))) AS "Средний стаж",
  AVG(e.Salary) AS "Средний уровень зарплаты",
  COUNT(CASE WHEN e.EmployeeLevel = 'jun' THEN 1 END) AS "Количество сотрудников уровня junior",
  COUNT(CASE WHEN e.EmployeeLevel = 'mid' THEN 1 END) AS "Количество сотрудников уровня middle",
  COUNT(CASE WHEN e.EmployeeLevel = 'sen' THEN 1 END) AS "Количество сотрудников уровня senior",
  COUNT(CASE WHEN e.EmployeeLevel = 'lea' THEN 1 END) AS "Количество сотрудников уровня lead",
  SUM(e.Salary) AS "Общий размер оплаты труда всех сотрудников до индексации",
  SUM(e.Salary * e.BonusCoefficient) AS "Общий размер оплаты труда всех сотрудников после индексации",
  COUNT(CASE WHEN er.Rating = 'A' THEN 1 END) AS "Общее количество оценок А",
  COUNT(CASE WHEN er.Rating = 'B' THEN 1 END) AS "Общее количество оценок B",
  COUNT(CASE WHEN er.Rating = 'C' THEN 1 END) AS "Общее количество оценок C",
  COUNT(CASE WHEN er.Rating = 'D' THEN 1 END) AS "Общее количество оценок D",
  COUNT(CASE WHEN er.Rating = 'E' THEN 1 END) AS "Общее количество оценок E",
  AVG(e.BonusCoefficient) AS "Средний показатель коэффициента премии",
  SUM(e.Salary * (e.BonusCoefficient - 1)) AS "Общий размер премии",
  SUM(e.Salary + e.Salary * (e.BonusCoefficient - 1)) AS "Общая сумма зарплат (+ премии) до индексации",
  SUM(e.Salary + e.Salary * (e.BonusCoefficient - 1)) AS "Общая сумма зарплат (+ премии) после индексации",
  (SUM(e.Salary + e.Salary * (e.BonusCoefficient - 1)) - SUM(e.Salary + e.Salary * (e.BonusCoefficient - 1))) /
  SUM(e.Salary + e.Salary * (e.BonusCoefficient - 1)) * 100 AS "Разница в %"
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
LEFT JOIN EmployeeRatings er ON e.EmployeeID = er.EmployeeID
GROUP BY d.DepartmentName, e.FullName;
