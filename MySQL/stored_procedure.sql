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


DROP TABLE IF EXISTS guguTBL;
CREATE TABLE guguTBL (txt VARCHAR(100));

DROP PROCEDURE IF EXISTS whileProc2;
DELIMITER $$
CREATE PROCEDURE whileProc2()
BEGIN
    DECLARE txt VARCHAR(100);
    DECLARE dan INT;
    DECLARE i INT;
    SET dan = 2;
    
    WHILE (dan < 10) DO
	SET txt = '';
	SET i = 1;
        
	WHILE (i < 10) DO
	    SET txt = concat(txt, ' ', dan, 'x', i, '=', dan*i);
            SET i = i + 1;
        END WHILE;
        SET dan = dan + 1;
        INSERT INTO guguTBL VALUES(txt);
    END WHILE;
    SELECT * FROM guguTBL;
END $$
DELIMITER ;

CALL whileProc2();


DROP PROCEDURE IF EXISTS errorProc;
DELIMITER $$
CREATE PROCEDURE errorProc()
BEGIN
    DECLARE CONTINUE HANDLER FOR 1146 SELECT '테이블이 없음' AS '메시지';
    SELECT * FROM noTable;
END $$
DELIMITER ;

CALL errorProc();


ALTER TABLE userTbl ADD grade VARCHAR(5);

DROP PROCEDURE IF EXISTS cursorProc;
DELIMITER $$
CREATE PROCEDURE cursorProc()
BEGIN
    DECLARE id CHAR(8);
    DECLARE total BIGINT; 
    DECLARE userGrade VARCHAR(5); 
    DECLARE endOfRow BOOLEAN DEFAULT FALSE; 

    DECLARE userCuror CURSOR FOR -- 커서 선언
        SELECT U.userID, SUM(price*amount)
	  FROM userTbl U LEFT OUTER JOIN buyTbl B ON U.userID = B.userID
	  GROUP BY 1;
  
    DECLARE CONTINUE HANDLER -- 행의 끝
        FOR NOT FOUND SET endOfRow = TRUE;
    
    OPEN userCuror; -- 커서 열기

    cursor_loop: LOOP
        FETCH userCuror INTO id, total; 
        
        IF endOfRow THEN 
            LEAVE cursor_loop;
        END IF;

	CASE 
		WHEN (total >= 1500) THEN SET userGrade = '최우수고객';
		WHEN (total >= 1000) THEN SET userGrade = '우수고객';
		WHEN (total >= 1) THEN SET userGrade = '일반고객';
		ELSE SET userGrade = '유령고객';
	END CASE;
        
        UPDATE userTbl SET grade = userGrade WHERE userID = id;
    END LOOP cursor_loop;
    
    CLOSE userCuror; -- 커서 닫기
END $$
DELIMITER ;

CALL cursorProc();
SELECT * FROM usertbl;
