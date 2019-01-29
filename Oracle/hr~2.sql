drop trigger tr_emp_cnt_del;

CREATE TRIGGER tr_emp_cnt_del
    after delete
    ON employees  FOR EACH ROW
    when (old.department_id is not null)
begin
    update Departments  set employee_cnt = employee_cnt - 1
     where department_id = :old.department_id;    
end; 

select get_d_name(10) from dual;


