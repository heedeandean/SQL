-- 부서ID를 입력하면 부서명을 반환하는 스토어드 함수를 작성하시오.

CREATE FUNCTION get_d_name (dept_id IN number) RETURN varchar2
IS
	v_ret varchar2;
BEGIN
	select department_name into v_ret from Departments where department_id = dept_id;
    return v_ret;
END;

desc departments;


-- --
SELECT * 
  FROM USER_SEQUENCES 
 WHERE SEQUENCE_NAME = UPPER('employees_seq');