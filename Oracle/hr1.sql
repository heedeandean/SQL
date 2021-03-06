SELECT * FROM EMPLOYEES;
SELECT * FROM JOBS;

-- 1번 부서별 직원수
SELECT MAX(D.DEPARTMENT_NAME) DEPARTMENT_NAME, COUNT(DISTINCT E.EMPLOYEE_ID) EMP_CNT
FROM EMPLOYEES E INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY E.DEPARTMENT_ID
ORDER BY 2 DESC;

-- 2번 부서별 평균 급여(salary)
SELECT MAX(D.DEPARTMENT_NAME) DEPARTMENT_NAME, ROUND(AVG(E.SALARY)) AVG_SAL
FROM EMPLOYEES E INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY E.DEPARTMENT_ID
ORDER BY 2 DESC;

-- 3번 직책별 평균 급여
SELECT JOB_ID, ROUND(AVG(SALARY), 2)
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY 1;

-- 4번 자신의 매니저 보다 더 많은 급여를 받는 사람 목록
-- 1안
SELECT *
FROM EMPLOYEES E
WHERE SALARY > (SELECT EE.SALARY FROM EMPLOYEES EE WHERE E.MANAGER_ID = EE.EMPLOYEE_ID);

-- 2안
SELECT E.*
  FROM EMPLOYEES E INNER JOIN EMPLOYEES EE ON E.MANAGER_ID = EE.EMPLOYEE_ID
 WHERE E.SALARY > EE.SALARY; 


-- 5번 Job title이 Sales Representative인 직원 중에서, 급여가 9,000 ~ 10,000 인 직원들의 이름과 급여를 출력하시오. 

-- SELECT TRIM(first_name)||' '||TRIM(last_name) AS NAME, SALARY
SELECT CONCAT(CONCAT(E.FIRST_NAME, ' '), E.LAST_NAME) AS NAME, E.SALARY
  FROM EMPLOYEES E INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
 WHERE J.JOB_TITLE = 'Sales Representative' AND E.SALARY BETWEEN 9000 AND 10000
ORDER BY 2 DESC, 1;



/* 6번 각 직급별로 급여의 총합을 구하고자 한다.
급여 총합이 가장 높은 직급순으로 급여 총합을 출력하시오.
(단, 급여총합이 30,000 이상인 직급만 출력할 것) */
select JOB_ID, SUM(SALARY)
from employees
group by JOB_ID
HAVING SUM(SALARY) >= 30000
ORDER BY 2 DESC;

-- 7번 각 도시별 평균 연봉(급여)가 높은순으로 상위 3개 도시만 출력하시오.
SELECT *
FROM (SELECT CITY, ROUND(AVG(E.SALARY))
        FROM DEPARTMENTS D INNER JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
                           INNER JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
      GROUP BY CITY
      ORDER BY 2 DESC) SUB
WHERE ROWNUM < 4;

/* 8번 직책(Job Title)이 Sales Manager인 사원들의 입사년도(hire_date)별 평균 급여를 출력하시오. 
	출력 시 년도를 기준으로 오름차순 정렬하시오.*/
    
SELECT CONCAT(TO_CHAR(E.HIRE_DATE, 'YYYY'), '년'), ROUND(AVG(E.SALARY))
  FROM EMPLOYEES E INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
 WHERE J.JOB_TITLE = 'Sales Manager'
 GROUP BY CONCAT(TO_CHAR(E.HIRE_DATE, 'YYYY'), '년')
 ORDER BY 1;
 
 /* 9번 각 도시(city)에 있는 모든 부서 직원들의 평균급여를 조회하고자 한다. 
	평균급여가 가장 낮은 도시부터 도시명(city)과 평균연봉, 해당 도시의 직원수를 출력하시오. 
	단, 도시에 근무하는 직원이 10명 이상인 곳은 제외하고 조회하시오.*/
SELECT *
FROM (SELECT CITY, ROUND(AVG(E.SALARY)), COUNT(E.EMPLOYEE_ID) AS E_COUNT
        FROM DEPARTMENTS D INNER JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
                           INNER JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
      GROUP BY CITY
      ORDER BY 2) SUB
WHERE E_COUNT < 10;

/* 10번 ‘Public  Accountant’의 직책(job_title)으로 과거에 근무한 적이 있는 모든
	사원의 사번과 이름을 출력하시오. 
	(현재 ‘Public Accountant’의 직책(job_title)으로 근무하는 사원은 고려 하지 않는다) */  
    
SELECT E.EMPLOYEE_ID, E.FIRST_NAME || ' ' ||  E.JOB_ID, JH.*
  FROM JOB_HISTORY JH INNER JOIN JOBS J ON JH.JOB_ID = J.JOB_ID 
                      INNER JOIN EMPLOYEES E ON JH.EMPLOYEE_ID = E.EMPLOYEE_ID
WHERE J.JOB_TITLE = 'Public Accountant';


/* 11번	2007년에 입사(hire_date)한 직원들의 사번(employee_id),
	이름(first_name), 성(last_name), 
	부서명(department_name)을 조회합니다.  
	이때, 부서에 배치되지 않은 직원의 경우, ‘<Not Assigned>’로 출력하시오. */
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, NVL(D.DEPARTMENT_NAME, '<Not Assigned>')
  FROM EMPLOYEES E FULL JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 WHERE E.HIRE_DATE LIKE '07%' 
 ORDER BY 1;

/* 12번 부서별로 가장 적은 급여를 받고 있는 직원의 이름, 부서이름, 급여를 출력하시오. 
	이름은 last_name만 출력하며, 부서이름으로 오름차순 정렬하고, 
	이름을 기준 으로 오름차순 정렬하여 출력합니다.*/
SELECT EE.LAST_NAME, D.DEPARTMENT_NAME, T.MIN_S    
FROM (SELECT E.DEPARTMENT_ID, MIN(E.SALARY) AS MIN_S
  FROM EMPLOYEES E
 WHERE E.DEPARTMENT_ID IS NOT NULL 
GROUP BY E.DEPARTMENT_ID) T INNER JOIN EMPLOYEES EE ON EE.DEPARTMENT_ID = T.DEPARTMENT_ID AND EE.SALARY = T.MIN_S
                                INNER JOIN DEPARTMENTS D ON T.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY 1;
    
    
    

SELECT EE.DEPARTMENT_ID, EE.EMPLOYEE_ID, EE.LAST_NAME, EE.SALARY, MIN_SAL
  FROM (SELECT E.DEPARTMENT_ID, MIN(E.SALARY) MIN_SAL
          FROM EMPLOYEES E
         WHERE E.DEPARTMENT_ID IS NOT NULL
        GROUP BY E.DEPARTMENT_ID) SUB INNER JOIN EMPLOYEES EE 
                                      ON SUB.DEPARTMENT_ID = EE.DEPARTMENT_ID AND EE.SALARY = SUB.MIN_SAL
ORDER BY 1;
    
    
SELECT E.DEPARTMENT_ID, MIN(E.SALARY) MIN_SAL
          FROM EMPLOYEES E
         WHERE E.DEPARTMENT_ID IS NOT NULL
        GROUP BY E.DEPARTMENT_ID;
    
/* 13번 EMPLOYEES 테이블에서 급여를 많이 받는 순서대로 조회했을 때
   6번째부터 10 번째까지 5명의 last_name, first_name, salary를 조회하는 sql문장을 작성하시오.*/
    
SELECT *
FROM (SELECT RANK() OVER (ORDER BY SALARY DESC) AS RANKING, LAST_NAME, FIRST_NAME, SALARY
  FROM EMPLOYEES) T
WHERE RANKING BETWEEN 6 AND 10;

/* 14번	‘Sales’ 부서에 속한 직원의 이름(first_name), 급여(salary), 
	부서이름(department_name)을 조회하시오. 
	단, 급여는 100번 부서의 평균보다 적게 받는 직원 정보만 출력되어야 한다. */
    
SELECT E.FIRST_NAME, E.SALARY, D.DEPARTMENT_NAME
FROM EMPLOYEES E FULL JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.DEPARTMENT_NAME ='Sales'AND 
      E.SALARY < (SELECT AVG(SALARY)
                    FROM EMPLOYEES
                   WHERE DEPARTMENT_ID = 100  
                  GROUP BY DEPARTMENT_ID);
                  
/* 15)	부서별 입사월별 직원수를 출력하시오. 
	단, 직원수가 5명 이상인 부서만 출력되어야 하며 출력결과는 부서이름 순으로 한다. */

SELECT D.DEPARTMENT_NAME, CONCAT(TO_CHAR(E.HIRE_DATE, 'MM'), '월') AS HIRE_M, COUNT(*)  
FROM DEPARTMENTS D, EMPLOYEES E
WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME, CONCAT(TO_CHAR(E.HIRE_DATE, 'MM'), '월')
HAVING COUNT(*)>=5
ORDER BY 1;

/*16) 커미션(commission_pct)을 가장 많이 받은 상위 4명의 
	부서명(department_name), 직원명 (first_name), 급여(salary),
	커미션(commission_pct) 정보를 조회하시오. 
	출력결과는 커미션을 많이 받는 순서로 출력하되 동일한 커미션에 대해서는 급여가 높은
 	직원이 먼저 출력 되게 한다.*/

SELECT T.*
FROM (SELECT RANK() OVER (ORDER BY E.COMMISSION_PCT DESC) AS RANKING, 
             D.DEPARTMENT_NAME, E.FIRST_NAME, E.SALARY, E.COMMISSION_PCT
        FROM EMPLOYEES E INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
       WHERE COMMISSION_PCT IS NOT NULL ) T
WHERE RANKING BETWEEN 1 AND 4
ORDER BY RANKING, SALARY DESC;   




    

SELECT * FROM JOB_HISTORY;
SELECT * FROM JOBS;
SELECT * FROM COUNTRIES;
SELECT * FROM LOCATIONS;
SELECT * FROM EMPLOYEES;
SELECT * FROM REGIONS;
SELECT * FROM DEPARTMENTS;
SELECT COUNT(*) FROM EMPLOYEES E FULL JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;















    

