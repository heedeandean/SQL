-- �μ�ID�� �Է��ϸ� �μ����� ��ȯ�ϴ� ������ �Լ��� �ۼ��Ͻÿ�.

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