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
    
    IF (days/365) >= 5 THEN SELECT '입사한지 5년 이상입니다.';
    ELSE SELECT '입사한지 5년 미만입니다.';
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


DROP PROCEDURE IF EXISTS whileProc;
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
    DECLARE i INT; 
    DECLARE hap INT;
    SET i = 1;
    SET hap = 0;

    myWhile: WHILE (i <= 100) DO
	IF (i%7 = 0) THEN
	    SET i = i + 1;
            ITERATE myWhile;
	END IF;
            
	SET hap = hap + i;
        IF (hap > 1000) THEN
		LEAVE myWhile;
	END IF;
        SET i = i + 1;
    END WHILE;
    
    SELECT hap;
END $$
DELIMITER ;

CALL whileProc();


DROP PROCEDURE IF EXISTS errorProc;
DELIMITER $$
CREATE PROCEDURE errorProc()
BEGIN
    DECLARE CONTINUE HANDLER FOR 1146 SELECT '테이블이 없음' AS '메시지';
    SELECT * FROM noTable;
END $$
DELIMITER ;

CALL errorProc();
