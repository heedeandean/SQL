#Grade 테이블 생성
create table Grade(
	id int unsigned not null auto_increment primary key,
    midterm smallint unsigned not null default 0,
    finalterm smallint unsigned not null default 0,
    enroll smallint unsigned not null
);


insert into Grade(enroll) (select id from Enroll order by id);
 
update Grade set midterm = (floor(rand() * 101));
update Grade set finalterm = (floor(rand() * 101));


-- 여기에서 학점이 안되요~!!
select sub.name as '과목', stu.name as '학생명', g.midterm as '중간고사', g.finalterm as '기말고사', 
          g.midterm + g.finalterm as '총점',  round((g.midterm + g.finalterm) / 2 , 1) as '평균',
         case '평균' when '평균' like'9%' then 'A' 
                             else 'F' end as '학점' 
														
from Grade g inner join (Enroll e inner join Student stu on e.student = stu.id
						inner join Subject sub on e.subject = sub.id) on g.enroll = e.id;


