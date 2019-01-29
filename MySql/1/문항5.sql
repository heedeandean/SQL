select * from Subject;

select * from Classroom;

insert into Classroom(name) values('201호');
insert into Classroom(name) values('202호');
insert into Classroom(name) values('203호');
insert into Classroom(name) values('204호');
insert into Classroom(name) values('205호');
insert into Classroom(name) values('206호');
insert into Classroom(name) values('207호');
insert into Classroom(name) values('208호');
insert into Classroom(name) values('209호');
insert into Classroom(name) values('210호');

-- Subject 테이블에 classroom 컬럼 추가
ALTER TABLE `dooodb`.`Subject` 
ADD COLUMN `classroom` SMALLINT(5) NOT NULL AFTER `prof`;

update Subject set classroom= (select distinct id from Classroom order by rand() limit 1);





-- 과목별 강의실이 중복되지 않았는지 확인. 
select *, count(*)
from Subject
group by id, classroom;


