SELECT * FROM EMPLOYEES;
SELECT * FROM JOBS;

-- 1�� �μ��� ������
SELECT MAX(D.DEPARTMENT_NAME) DEPARTMENT_NAME, COUNT(DISTINCT E.EMPLOYEE_ID) EMP_CNT
FROM EMPLOYEES E INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY E.DEPARTMENT_ID
ORDER BY 2 DESC;

-- 2�� �μ��� ��� �޿�(salary)
SELECT MAX(D.DEPARTMENT_NAME) DEPARTMENT_NAME, ROUND(AVG(E.SALARY)) AVG_SAL
FROM EMPLOYEES E INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY E.DEPARTMENT_ID
ORDER BY 2 DESC;

-- 3�� ��å�� ��� �޿�
SELECT JOB_ID, ROUND(AVG(SALARY), 2)
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY 1;

-- 4�� �ڽ��� �Ŵ��� ���� �� ���� �޿��� �޴� ��� ���
-- 1��
SELECT *
FROM EMPLOYEES E
WHERE SALARY > (SELECT EE.SALARY FROM EMPLOYEES EE WHERE E.MANAGER_ID = EE.EMPLOYEE_ID);

-- 2��
SELECT E.*
  FROM EMPLOYEES E INNER JOIN EMPLOYEES EE ON E.MANAGER_ID = EE.EMPLOYEE_ID
 WHERE E.SALARY > EE.SALARY; 


-- 5�� Job title�� Sales Representative�� ���� �߿���, �޿��� 9,000 ~ 10,000 �� �������� �̸��� �޿��� ����Ͻÿ�. 

-- SELECT TRIM(first_name)||' '||TRIM(last_name) AS NAME, SALARY
SELECT CONCAT(CONCAT(E.FIRST_NAME, ' '), E.LAST_NAME) AS NAME, E.SALARY
  FROM EMPLOYEES E INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
 WHERE J.JOB_TITLE = 'Sales Representative' AND E.SALARY BETWEEN 9000 AND 10000
ORDER BY 2 DESC, 1;



/* 6�� �� ���޺��� �޿��� ������ ���ϰ��� �Ѵ�.
�޿� ������ ���� ���� ���޼����� �޿� ������ ����Ͻÿ�.
(��, �޿������� 30,000 �̻��� ���޸� ����� ��) */
select JOB_ID, SUM(SALARY)
from employees
group by JOB_ID
HAVING SUM(SALARY) >= 30000
ORDER BY 2 DESC;

-- 7�� �� ���ú� ��� ����(�޿�)�� ���������� ���� 3�� ���ø� ����Ͻÿ�.
SELECT *
FROM (SELECT CITY, ROUND(AVG(E.SALARY))
        FROM DEPARTMENTS D INNER JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
                           INNER JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
      GROUP BY CITY
      ORDER BY 2 DESC) SUB
WHERE ROWNUM < 4;

/* 8�� ��å(Job Title)�� Sales Manager�� ������� �Ի�⵵(hire_date)�� ��� �޿��� ����Ͻÿ�. 
	��� �� �⵵�� �������� �������� �����Ͻÿ�.*/
    
SELECT CONCAT(TO_CHAR(E.HIRE_DATE, 'YYYY'), '��'), ROUND(AVG(E.SALARY))
  FROM EMPLOYEES E INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
 WHERE J.JOB_TITLE = 'Sales Manager'
 GROUP BY CONCAT(TO_CHAR(E.HIRE_DATE, 'YYYY'), '��')
 ORDER BY 1;
 
 /* 9�� �� ����(city)�� �ִ� ��� �μ� �������� ��ձ޿��� ��ȸ�ϰ��� �Ѵ�. 
	��ձ޿��� ���� ���� ���ú��� ���ø�(city)�� ��տ���, �ش� ������ �������� ����Ͻÿ�. 
	��, ���ÿ� �ٹ��ϴ� ������ 10�� �̻��� ���� �����ϰ� ��ȸ�Ͻÿ�.*/
SELECT *
FROM (SELECT CITY, ROUND(AVG(E.SALARY)), COUNT(E.EMPLOYEE_ID) AS E_COUNT
        FROM DEPARTMENTS D INNER JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
                           INNER JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
      GROUP BY CITY
      ORDER BY 2) SUB
WHERE E_COUNT < 10;

/* 10�� ��Public  Accountant���� ��å(job_title)���� ���ſ� �ٹ��� ���� �ִ� ���
	����� ����� �̸��� ����Ͻÿ�. 
	(���� ��Public Accountant���� ��å(job_title)���� �ٹ��ϴ� ����� ��� ���� �ʴ´�) */  
    
SELECT E.EMPLOYEE_ID, E.FIRST_NAME || ' ' ||  E.JOB_ID, JH.*
  FROM JOB_HISTORY JH INNER JOIN JOBS J ON JH.JOB_ID = J.JOB_ID 
                      INNER JOIN EMPLOYEES E ON JH.EMPLOYEE_ID = E.EMPLOYEE_ID
WHERE J.JOB_TITLE = 'Public Accountant';


/* 11��	2007�⿡ �Ի�(hire_date)�� �������� ���(employee_id),
	�̸�(first_name), ��(last_name), 
	�μ���(department_name)�� ��ȸ�մϴ�.  
	�̶�, �μ��� ��ġ���� ���� ������ ���, ��<Not Assigned>���� ����Ͻÿ�. */
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, NVL(D.DEPARTMENT_NAME, '<Not Assigned>')
  FROM EMPLOYEES E FULL JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 WHERE E.HIRE_DATE LIKE '07%' 
 ORDER BY 1;

/* 12�� �μ����� ���� ���� �޿��� �ް� �ִ� ������ �̸�, �μ��̸�, �޿��� ����Ͻÿ�. 
	�̸��� last_name�� ����ϸ�, �μ��̸����� �������� �����ϰ�, 
	�̸��� ���� ���� �������� �����Ͽ� ����մϴ�.*/
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
    
/* 13�� EMPLOYEES ���̺��� �޿��� ���� �޴� ������� ��ȸ���� ��
   6��°���� 10 ��°���� 5���� last_name, first_name, salary�� ��ȸ�ϴ� sql������ �ۼ��Ͻÿ�.*/
    
SELECT *
FROM (SELECT RANK() OVER (ORDER BY SALARY DESC) AS RANKING, LAST_NAME, FIRST_NAME, SALARY
  FROM EMPLOYEES) T
WHERE RANKING BETWEEN 6 AND 10;

/* 14��	��Sales�� �μ��� ���� ������ �̸�(first_name), �޿�(salary), 
	�μ��̸�(department_name)�� ��ȸ�Ͻÿ�. 
	��, �޿��� 100�� �μ��� ��պ��� ���� �޴� ���� ������ ��µǾ�� �Ѵ�. */
    
SELECT E.FIRST_NAME, E.SALARY, D.DEPARTMENT_NAME
FROM EMPLOYEES E FULL JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.DEPARTMENT_NAME ='Sales'AND 
      E.SALARY < (SELECT AVG(SALARY)
                    FROM EMPLOYEES
                   WHERE DEPARTMENT_ID = 100  
                  GROUP BY DEPARTMENT_ID);
                  
/* 15)	�μ��� �Ի���� �������� ����Ͻÿ�. 
	��, �������� 5�� �̻��� �μ��� ��µǾ�� �ϸ� ��°���� �μ��̸� ������ �Ѵ�. */

SELECT D.DEPARTMENT_NAME, CONCAT(TO_CHAR(E.HIRE_DATE, 'MM'), '��') AS HIRE_M, COUNT(*)  
FROM DEPARTMENTS D, EMPLOYEES E
WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME, CONCAT(TO_CHAR(E.HIRE_DATE, 'MM'), '��')
HAVING COUNT(*)>=5
ORDER BY 1;

/*16) Ŀ�̼�(commission_pct)�� ���� ���� ���� ���� 4���� 
	�μ���(department_name), ������ (first_name), �޿�(salary),
	Ŀ�̼�(commission_pct) ������ ��ȸ�Ͻÿ�. 
	��°���� Ŀ�̼��� ���� �޴� ������ ����ϵ� ������ Ŀ�̼ǿ� ���ؼ��� �޿��� ����
 	������ ���� ��� �ǰ� �Ѵ�.*/

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















    

