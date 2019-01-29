# 문제 1
* 학번, 학생명, 수강과목수, 전과목 평균점수 컬럼(총 4개 컬럼)을 갖는 view를 작성하시오.
```mysql
create view v_student_enroll_avg as 
	select stu.id as '학번', stu.name as '학생명', count(e.id) as '수강과목수', 
		round(sum(g.midterm + g.finalterm) / (count(e.id) *2), 1) as '전과목 평균점수'
	  from Grade g inner join Enroll e on g.enroll = e.id
		       inner join Student stu on e.student = stu.id 
	group by stu.id;
	
select * from v_student_enroll_avg;
```

# 문제 2
* 학번을 주면 해당 학생의 전과목 평균을 반환하는 Stored Fuction을 작성하시오.  
[호출 예. f_student_avg(학번)]
```mysql
-- Stored Fuction create
DELIMITER $$
create function getTavgFunc(f_student_avg int(11))
	returns float
BEGIN

        return (select round(sum(g.midterm + g.finalterm) / (count(e.id) *2), 1)
	          from Grade g inner join Enroll e on g.enroll = e.id
			       inner join Student stu on e.student = stu.id 
		 group by stu.id 
		 having f_student_avg = stu.id);

END $$
DELIMITER ;

-- 학번의 type을 보기위해 조회
desc Student;

-- Stored Fuction 'getTavgFunc'호출
select getTavgFunc(11);
```

# 문제 3
* 클럽(Club)을 하나 추가하면 클럽회원(ClubMember)으로 임의의 한 학생(Student)을   
회장으로 자동 등록하는 Trigger를 작성하시오.
```mysql
-- 트리거 tr_club_clubmember create
-- 테이블 ClubMember의 컬럼 level에서 회장은 2값이라고 줌.

DELIMITER //

create trigger tr_club_clubmember
		after insert on Club for each row
BEGIN
	insert into ClubMember(club, student, level) 
			values(NEW.id, (select id from Student order by rand() limit 1), 2);

END //
DELIMITER ;
```
```mysql
-- 데이터 검증
insert into Club(name) values('음악부');

select * from Club ;
select * from ClubMember where club = 6;
```

# 문제 4
* 지난 학기 데이터(수강학생수, 성적 등)를 기준으로 인기 교수(강좌) Top 3을 추천하는  
Stored Procedure를 작성하시오. 단, 데이터의 가중치는 자유롭게 부여하시오.

1. 데이터 모델링
```
-- 교수의 인기와 관련된 테이블
select * from Prof; 
select * from Subject;

-- 가중치 우선순위 설정 
1. likecnt (Prof 테이블)
2. students (Subject 테이블)
```

2. 데이터베이스 구현	
```mysql 
-- 과목당 몇명의 학생이 수업을 듣는지 테이블 Subject에 students 칼럼 추가 (단, 한 과목당 교수 한명을 배정했다.)
alter table Subject  add column students smallint default 0 not null;

update Subject s set students=(select count(*) from Enroll where subject = s.id group by subject);
select subject, count(*) from Enroll group by subject;

select * from Subject;

-- 스토어드 프로시저 sp_prof_top3() create
DELIMITER $$

create procedure sp_prof_top3()
BEGIN
	select p.name as '교수명', s.name as '강좌',  
		p.likecnt / (select avg(likecnt) from Prof) + 
		s.students/(select avg(students) from Subject) as score
	  from Prof p inner join Subject s on p.id = s.prof
	order by 3 desc limit 3;

END $$

DELIMITER ;

call sp_prof_top3();
```
```mysql
-- 데이터검증
select p.name as '교수명', s.name as '강좌', 
	p.likecnt, p.likecnt / (select avg(likecnt) from Prof) as likecnt_r, 
	s.students, s.students / (select avg(students) from Subject) as students_r
from Prof p inner join Subject s on p.id = s.prof
order by 5 desc;
```

# 문제 5
* Oracle HR Scheme에서 'Marketing' 부서에 속한 직원의 이름(last_name), 급여(salary), 부서이름(department_name)을  
  조회하시오. (단, 급여는 80번 부서의 평균 보다 적게 받는 직원만 출력되어야 함.)
```sql
select e.last_name, e.salary, d.department_name
  from employees e inner join departments d on e.department_id = d.department_id
 where d.department_name = 'Marketing' 
    and e.salary < (select avg(salary) from employees 
                    group by department_id 
                      having department_id = 80);
```

# 문제 6
* 과목별 Top 3 학생의 이름과 성적을 한줄로 표현하는 리포트를 아래와 같이 출력되는 프로시저를 작성하시오.  
(단, 성적은 중간, 기말 평균이며, 과목명 오름차순으로 정렬하시오.)
```mysql
-- v_grade_enroll 뷰 생성

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `dooo`@`%` 
    SQL SECURITY DEFINER
VIEW `v_grade_enroll` AS
    SELECT 
        `g`.`id` AS `id`,
        `stu`.`name` AS `student_name`,
        `sub`.`name` AS `subject_name`,
        `g`.`midterm` AS `midterm`,
        `g`.`finalterm` AS `finalterm`,
        `g`.`avr` AS `avr`,
        `g`.`enroll` AS `enroll`,
        `e`.`subject` AS `subject`,
        `e`.`student` AS `student`
    FROM
        (((`Grade` `g`
        JOIN `Enroll` `e` ON ((`g`.`enroll` = `e`.`id`)))
        JOIN `Student` `stu` ON ((`e`.`student` = `stu`.`id`)))
        JOIN `Subject` `sub` ON ((`e`.`subject` = `sub`.`id`)));
        
select * from v_grade_enroll;
```
```mysql
delimiter $$
create procedure sp_subject_top_3( )


BEGIN

    declare _isdone boolean default False;
    declare _sub_name varchar(31);
    declare _stu_name varchar(31);
    declare _score smallint;

    declare top_3 CURSOR FOR
		select subject_name, student_name, max(avr)
		from v_grade_enroll 
		group by subject_name, student_name 
		order by 1, 3 desc;
    
    declare continue handler 
        for not found set _isdone = True;
        
    drop table if exists t_g_top_3;
    
    create temporary table t_g_top_3 (
        `sub_name` varchar(31) default ' ' primary key,
        `1st_stu` varchar(31) default ' ',
        `1st_score` smallint default 0 ,
	`2nd_stu` varchar(31) default ' ',
        `2nd_score` smallint default 0 ,
        `3rd_stu` varchar(31) default ' ',
	`3rd_score` smallint default 0,
        `cnt` smallint default 1 
    );


  OPEN top_3  ;
        

  loop1 : LOOP
    
	Fetch top_3  into _sub_name,  _stu_name , _score  ;
    
        IF not exists (select * from t_g_top_3 where sub_name = `_sub_name`) THEN
            insert into t_g_top_3(`sub_name`, `1st_stu`, `1st_score`) value(_sub_name, _stu_name, _score );

        ELSEIF  exists (select * from t_g_top_3 where sub_name = `_sub_name` and cnt = 1) THEN
             update t_g_top_3 set `2nd_stu`= _stu_name, `2nd_score` = _score, cnt = cnt + 1
              where `sub_name` = _sub_name and cnt = 1  ;

	ELSE 
             update t_g_top_3 set `3rd_stu`= _stu_name, `3rd_score` = _score, cnt = cnt + 1
              where `sub_name` = _sub_name and cnt = 2  ;
             
        END IF;
        
    
	IF _isdone THEN
            LEAVE loop1;
        END IF;
       
  END LOOP loop1;
    
  CLOSE  top_3 ;
    
    select sub_name as '과목', 1st_stu as '1등' , 1st_score as '점수', 2nd_stu as '2등', 2nd_score as '점수',
           3rd_stu as '3등', 3rd_score as '점수'
      from t_g_top_3
    order by 1;


END  $$

delimiter ;

call  sp_subject_top_3() ;
```



