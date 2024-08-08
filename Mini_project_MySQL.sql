CREATE DATABASE users_adverts;

use users_adverts;

select * from users;

CREATE TABLE users(
  date DATE,
  user_id VARCHAR(64) NOT NULL,
  view_adverts INT 
);

-- # 1 Напишите запрос SQL, выводящий одним числом количество уникальных пользователей в этой таблице в период с 2023-11-07 по 2023-11-15.
SELECT 
 COUNT(DISTINCT user_id) as count
FROM
 users
WHERE
 date BETWEEN '2023-11-07' AND '2023-11-15';
 
-- # 2 Определите пользователя, который за весь период посмотрел наибольшее количество объявлений. 
SELECT
 user_id
  ,SUM(view_adverts) as view_count
FROM
 users
GROUP BY
 user_id
ORDER BY 
 view_count DESC
LIMIT 1;

-- # 3 ---
SELECT
 user_id
FROM
 users
WHERE
 view_adverts IN (SELECT MAX(view_adverts) FROM users);

--# 3 USING CTE FOR SOLVING PROBLEM
WITH pre_res AS (
	 SELECT
	 date
     ,COUNT(DISTINCT user_id) as unique_users
	  ,AVG(view_adverts) AS avg_view_adverts
	FROM
	 users
	GROUP BY 
	  date)
SELECT 
 date
 ,avg_view_adverts
FROM
 pre_res
WHERE
 unique_users > 500
ORDER BY 
 avg_view_adverts DESC
 LIMIT 1;
 
---# 4 USING GREGATIONAL FUNCTION TO SOVLE PROBLEM
SELECT 
    user_id, CEILING(AVG(view_adverts)) AS count
FROM
    users
GROUP BY user_id
ORDER BY count DESC;
 
-- # 5 using  HAVING to solve problem
SELECT 
    user_id,
    AVG(view_adverts) AS avg_count,
    COUNT(DISTINCT date) AS active_days
FROM
    users
GROUP BY 
    user_id
HAVING 
    COUNT(DISTINCT date) >= 5
ORDER BY 
    avg_count DESC
LIMIT 1;

# ---------------------------------------------------
-- PART 2
CREATE DATABASE IF NOT EXISTS mini_project;
use mini_project;

CREATE TABLE IF NOT EXISTS T_TAB1 (
  id INT UNIQUE,
  GOODS_TYPE VARCHAR(16) NOT NULL,
  QUANTITY INT NOT NULL,
  AMOUNT INT NOT NULL,
  SELLER_NAME VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS T_TAB2(
  id INT UNIQUE,
  NAME VARCHAR(32) NOT NULL,
  SALARY INT NOT NULL,
  AGE INT NOT NULL
);

INSERT INTO T_TAB1 (ID, GOODS_TYPE, QUANTITY, AMOUNT, SELLER_NAME) VALUES
(1, 'MOBILE PHONE', 2, 400000, 'MIKE'),
(2, 'KEYBOARD', 1, 10000, 'MIKE'),
(3, 'MOBILE PHONE', 1, 50000, 'JANE'),
(4, 'MONITOR', 1, 110000, 'JOE'),
(5, 'MONITOR', 2, 80000, 'JANE'),
(6, 'MOBILE PHONE', 1, 130000, 'JOE'),
(7, 'MOBILE PHONE', 1, 60000, 'ANNA'),
(8, 'PRINTER', 1, 90000, 'ANNA'),
(9, 'KEYBOARD', 2, 10000, 'ANNA'),
(10, 'PRINTER', 1, 80000, 'MIKE');

INSERT INTO T_TAB2 (ID, NAME, SALARY, AGE) VALUES
(1, 'ANNA', 110000, 27),
(2, 'JANE', 80000, 25),
(3, 'MIKE', 120000, 25),
(4, 'JOE', 70000, 24),
(5, 'RITA', 120000, 29);

-- 1
SELECT
 DISTINCT GOODS_TYPE
FROM
 T_TAB1;
 
--# 2 
SELECT
 COUNT(QUANTITY) as count
 ,SUM(AMOUNT * QUANTITY) as total_revenue
FROM
 T_TAB1
WHERE
 GOODS_TYPE = 'MOBILE PHONE'
GROUP BY
 GOODS_TYPE;
 
 --# 3
SELECT
  *
FROM
 T_TAB2
WHERE
 salary > 100000;
 
-- # 4 using UNION:)  to solve problem
	SELECT 
	 'MIN_AGE' as metric
	  ,MIN(AGE) as value
	FROM
	 T_TAB2
UNION ALL
	SELECT
     'MAX_AGE' as metric
      ,MAX(AGE) as value
	FROM
     T_TAB2
UNION ALL
	SELECT
      'MIN_SALARY' as metric
       ,MIN(SALARY) as value
    FROM
     T_TAB2
UNION ALL
    SELECT
      'MAX_SALARY' as metric
       ,MAX(SALARY) as value
    FROM
     T_TAB2;

--# 5
	SELECT
	 'Среднее продажа клавиатур' as product
	  , AVG(QUANTITY) as avg_keybord
	FROM
	 T_TAB1
	WHERE
	 GOODS_TYPE = 'KEYBOARD'
UNION ALL
	SELECT
	 'Среднее продажа принтеров' as product
	  ,AVG(QUANTITY) as avg_printer
	FROM
	 T_TAB1
	WHERE
	 GOODS_TYPE = 'PRINTER';

--# 6 
SELECT
 NAME
, SUM(AMOUNT * QUANTITY) as total_revenue
FROM
 T_TAB1 AS t1
RIGHT JOIN
 T_TAB2 AS t2 ON t1.SELLER_NAME = t2.name
GROUP BY
 t2.name;
 
--- # 7 
SELECT
 t2.NAME
 ,t1.GOODS_TYPE
  ,t1.QUANTITY
   ,t1.AMOUNT
    ,t2.SALARY
    ,t2.AGE
FROM
 T_TAB2 as t2
LEFT JOIN
 T_TAB1 as t1 ON t1.SELLER_NAME = t2.NAME;
  
  
--# 8 Напишите запрос, который вернёт имя и возраст сотрудника, который ничего не продал. Сколько таких сотрудников?
WITH pre_res AS (
	SELECT
	 t2.NAME
	 , t2.AGE
	  , SUM(AMOUNT * QUANTITY) as total_revenue
	FROM
	 T_TAB1 AS t1
	RIGHT JOIN
	 T_TAB2 AS t2 ON t1.SELLER_NAME = t2.name
	GROUP BY
	 t2.name, t2.AGE)
SELECT
 NAME
 ,AGE
FROM 
 pre_res
WHERE
 total_revenue IS NULL OR total_revenue = 0;
 
-- # 9 Напишите запрос, который вернёт имя сотрудника и его заработную плату с возрастом меньше 26 лет? Какое количество строк вернул запрос?
SELECT
 NAME
 ,SALARY
FROM
 T_TAB2
WHERE
 AGE < 26;
 
-- # 10 Сколько строк вернёт следующий запрос:
SELECT COUNT(*) FROM T_TAB1 t
JOIN T_TAB2 t2 ON t2.name = t.seller_name
WHERE t2.name = 'RITA'

 

		 



