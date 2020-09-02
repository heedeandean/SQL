-- 모든학생이 적어도 한과목은 수강하며, 한 학생은 최대 3과목까지 수강한다면!!
insert into Enroll(student, subject)
 select id, (select id from Subject order by rand() limit 1) sid from Student order by id;

insert into Enroll(student, subject)
 select id, (select id from Subject order by rand() limit 1) sid from Student order by rand() limit 500
 on duplicate key update student = student;
 
insert into Enroll(student, subject)
 select id, (select id from Subject order by rand() limit 1) sid from Student order by rand() limit 500
 on duplicate key update student = student;
 
-- 데이터 검증
select * from Enroll order by student;
select subject, student, count(*) from Enroll group by 1,2 having count(*)>1; 