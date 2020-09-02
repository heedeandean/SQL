select * from Student;

select * from Dept;

insert into Dept(name) values('심리학과');
insert into Dept(name) values('모델과');
insert into Dept(name) values('통신과');
insert into Dept(name) values('컴퓨터과');
insert into Dept(name) values('디자인과');

Update Dept set prof = (select id from Prof order by rand() limit 1);



Update Student set dept = (select id from Dept order by rand() limit 1);

-- 학과별 학생 수 확인
select dept, count(*)
from Student
group by dept;

Update Dept set student = (select id from Student where dept = 1 order by rand() limit 1) where id = 1;
Update Dept set student = (select id from Student where dept = 2 order by rand() limit 1) where id = 2;
Update Dept set student = (select id from Student where dept = 3 order by rand() limit 1) where id = 3;
Update Dept set student = (select id from Student where dept = 4 order by rand() limit 1) where id = 4;
Update Dept set student = (select id from Student where dept = 5 order by rand() limit 1) where id = 5;

-- dept테이블의 student 컬럼이 Student 테이블의 dept 컬럼과 일치하는지 확인.
select id, dept
from Student
where id = 978; 


