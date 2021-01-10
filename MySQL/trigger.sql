DROP TRIGGER IF EXISTS backUserTbl_DeleteTrg;
DELIMITER //
CREATE TRIGGER backUserTbl_DeleteTrg
    AFTER DELETE
    ON userTbl
    FOR EACH ROW
BEGIN
    INSERT INTO backup_userTbl VALUES(OLD.userID, OLD.name, OLD.birthYear
	, OLD.addr, OLD.mobile1, OLD.mobile2, OLD.height, OLD.mDate
        , '삭제', CURDATE(), CURRENT_USER());
END //
DELIMITER ;


DROP TRIGGER IF EXISTS userTbl_InsertTrg;
DELIMITER //
CREATE TRIGGER userTbl_InsertTrg
    AFTER INSERT
    ON userTbl
    FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'INSERT 안됩니다.';
END //
DELIMITER ;


DROP TRIGGER IF EXISTS userTbl_BeforeInsertTrg;
DELIMITER //
CREATE TRIGGER userTbl_BeforeInsertTrg
    BEFORE INSERT
    ON userTbl
    FOR EACH ROW
BEGIN
    IF (NEW.birthYear < 1900) THEN 
	SET NEW.birthYear = 0;
    ELSEIF (NEW.birthYear > YEAR(CURDATE())) THEN 
	SET NEW.birthYear = YEAR(CURDATE());
    END IF;
END //
DELIMITER ;

SHOW TRIGGERS FROM sqlDB;
