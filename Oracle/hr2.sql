select sysdate, CURRENT_TIMESTAMP from dual;
select to_char(current_timestamp, 'YYYY-mm-dd HH24:MI:SS') from dual;

create table Test (
	ts   timestamp,
	tsz  timestamp with time zone,
	ts0  timestamp(0)
);
create sequence test_seq
 start with 1
 increment BY 1
 maxvalue 10000;

insert into Test(ts, tsz, ts0)
 values(SYSDATE, SYSDATE, SYSDATE);
 
select * from Test;

create table T(id number, name varchar2(30));

insert into T(id, name) values(test_seq.nextval, '���̼�');

select * from T;
select * from Employees;

/* 1)	�μ���, ������(first_name), �޿�, Ŀ�̼� �÷��� ���� �並 �ۼ��Ͻÿ�.
    ��, Ŀ�̼� ����Ʈ�� ���� ��� 0���� ��ȯ�Ͻÿ�. */

drop view v_employees_departments;

create view v_employees_departments as     
    select e.first_name, e.salary, nvl(e.commission_pct, 0) commission_pct, d.department_name
      from Employees e inner join Departments d on e.department_id = d.department_id
    WITH READ ONLY;
      
select * from v_employees_departments;

-- 2)	�μ���, ��å, ������, �Ի����� ���� �並 �ۼ��Ͻÿ�.
create view v_employees_departments_jobs as  
    select d.department_name, j.job_title, e.first_name, e.hire_date
      from Employees e inner join Departments d on e.department_id = d.department_id
                        inner join Jobs j on e.job_id = j.job_id
    WITH READ ONLY;
        
select * from v_employees_departments_jobs;

/* �μ����̺� ������ �÷��� �߰��ϰ�,
�ʱⰪ(���� �μ��� ������)�� ������ ��,
������ �Ի� �� ���� ������ �÷��� �����ϴ� Ʈ���Ÿ� �ۼ��Ͻÿ�. */

alter table Departments add employee_cnt number(5) default 0 not null;

update Departments d 
    set employee_cnt = (select count(*) 
                          from Employees e 
                         where d.department_id = e.department_id );

 drop trigger tr_emp_cnt;    
        
CREATE TRIGGER tr_emp_cnt
    after insert
    ON employees  FOR EACH ROW
    when (new.department_id is not null)
begin
    update Departments  set employee_cnt = employee_cnt + 1
     where department_id = :new.department_id;    
end; 

CREATE TRIGGER tr_emp_cnt_del
    after delete
    ON employees  FOR EACH ROW
    when (old.department_id is not null)
begin
    update Departments  set employee_cnt = employee_cnt - 1
     where department_id = :old.department_id;    
end; 


select * from Departments where department_id = 80;
select * from Employees;

drop sequence employees_seq;
create sequence employees_seq
 start with 1
 increment BY 1
 maxvalue 10000;

insert into employees(employee_id, last_name, email, hire_date, job_id, department_id)
        values(employees_seq.nextval, 'heee', 'hh@gg.com', current_timestamp, 'AD_VP', 80); 
        

delete from Employees where last_name = 'heee';
    
    
    
    
    


