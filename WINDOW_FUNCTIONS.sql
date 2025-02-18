CREATE TABLE Employees ( employee_id INT PRIMARY KEY, name VARCHAR(50), department VARCHAR(50), salary INT ); 
INSERT INTO Employees (employee_id, name, department, salary) VALUES (1, 'Alice', 'IT', 5000), (2, 'Bob', 'HR', 4000), (3, 'Charlie', 'IT', 7000), (4, 'David', 'Sales', 4500), (5, 'Emma', 'IT', 6000);


CREATE TABLE Performance ( performance_id INT PRIMARY KEY, employee_id INT, score INT, review_year INT, FOREIGN KEY (employee_id) REFERENCES Employees(employee_id) ); 
INSERT INTO Performance (performance_id, employee_id, score, review_year) VALUES (101, 1, 85, 2023), (102, 2, 78, 2023), (103, 3, 92, 2023), (104, 4, 88, 2023), (105, 5, 90, 2023);




select 
  e.name ,
   rank() over (Order by pf.score desc ) as score_rank 
from 
 Employees as e 
join 
 Performance as pf 
on pf.employee_id = e.employee_id;

--
select 
  e.name ,
   ROW_NUMBER() over (Order by e.salary desc ) as score_rank ,
   e.salary
from 
 Employees as e 
join 
 Performance as pf 
on pf.employee_id = e.employee_id;

-- 
select 
  e.*,
   pf.score
from 
 Employees as e 
left join 
 Performance as pf 
on pf.employee_id = e.employee_id;

-- 
select 
  e.name,
   rank() over (PARTITION BY e.department ORDER BY pf.score) as ranks,
   e.department
   ,pf.score
from 
 Employees as e 
left join 
 Performance as pf 
on pf.employee_id = e.employee_id;

--
with smth AS(
	select 
		e.*,
         RANK() OVER(PARTITION BY e.department ORDER BY pf.score DESC) as smth_smth
    from 
     Employees as e
	join 
     Performance as pf 
	on pf.employee_id = e.employee_id
)
select
  smth.*
  ,smth_smth
from 
 smth
where 
 smth_smth = 1;

 
