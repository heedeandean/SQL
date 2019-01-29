select * from ClubMember;
select * from Club;


insert into ClubMember(student, club, level)
 select id, (select id from Club order by rand() limit 1), floor(rand() * 2) sid from Student order by id;



select *
from ClubMember
where club = 1
order by level desc;

update ClubMember set level ='2' where id ='8';



-- 데이터 검증
select club, count(*)
from ClubMember
group by club;

select club, student, count(*) from ClubMember group by 1,2 having count(*)>1; 


select club, count(*)
from ClubMember
where level = 2
group by club, level;

