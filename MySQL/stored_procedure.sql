DROP PROCEDURE IF EXISTS ifProc;

DELIMITER $$
CREATE PROCEDURE ifProc()
BEGIN
	DECLARE hireDate DATE; -- 입사일
    DECLARE curDate DATE; 
    DECLARE days INT; -- 근무한 일수
    
    SELECT hire_date INTO hireDate 
      FROM employees.employees 
      WHERE emp_no = 10001; 
	
    SET curDate = CURRENT_DATE();
    SET days = DATEDIFF(curDate, hireDate);
    
    IF (days/365) >= 5 THEN
		SELECT '입사한지 5년 이상입니다.';
	ELSE
		SELECT '입사한지 5년 미만입니다.';
	END IF;
END $$
DELIMITER ;

CALL ifProc();


DROP PROCEDURE IF EXISTS caseProc;

DELIMITER $$
CREATE PROCEDURE caseProc()
BEGIN
	DECLARE score INT; 

    SET score = 100;

/*    
    IF score >= 90 THEN SELECT 'A';
	ELSEIF score >= 80 THEN SELECT 'B';
	ELSEIF score >= 70 THEN SELECT 'C';
	ELSEIF score >= 60 THEN SELECT 'D';
    ELSE SELECT 'F';
	END IF;
*/
	CASE 
		WHEN score >= 90 THEN SELECT 'A';
        WHEN score >= 80 THEN SELECT 'B';
        WHEN score >= 70 THEN SELECT 'C';
        WHEN score >= 60 THEN SELECT 'D';
        ELSE SELECT 'F';
	END CASE;
END $$
DELIMITER ;

CALL caseProc();