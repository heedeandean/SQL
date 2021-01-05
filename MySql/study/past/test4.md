# 문제 1  
* 학생, 과목, 교수, 수강내역 테이블 관계를 고려하여 생성하는 DDL을 작성하시오.
```mysql
START TRANSACTION;
# 학생 테이블 생성
Student    CREATE TABLE `Student` (
 `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
 `name` varchar(32) NOT NULL,
 `addr` varchar(30) NOT NULL,
 `birth` varchar(8) NOT NULL,
 `tel` varchar(15) NOT NULL,
 `email` varchar(31) NOT NULL,
 `regdt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `gender` bit(1) NOT NULL DEFAULT b'0',
 PRIMARY KEY (`id`)
) ;

# 과목 테이블 생성
create table Subject(
    id smallint unsigned not null auto_increment primary key,
    name varchar(31) not null,
    prof smallint unsigned,
    constraint foreign key fk_prof_prof(prof) references Prof(id) on delete set null
);

# 교수 테이블 생성
create table Prof(
    id smallint unsigned not null auto_increment primary key,
    name varchar(31) not null,
    likecnt int not null default 0
);

# 수강내역 테이블 생성
create table Enroll(
    id int unsigned not null auto_increment primary key,
    subject smallint unsigned not null,
    student int unsigned not null,
    constraint foreign key fk_subject(subject) references Subject(id) on delete cascade,
    constraint foreign key fk_student(student) references Student(id) on delete cascade
);
COMMIT;
```
```mysql
# 데이터 검증
select * from Student;
select * from Subject;
select * from Prof;
select * from Enroll;
```

# 문제 2
* 학생테이블과 과목테이블을 활용하여, 수강내역테이블에 테스트용 데이터를 구성하는 DML을 절차적으로 작성하시오.
```python
# Visual Studio Code로 Python을 이용해 1000명의 랜덤데이터를 Student 테이블에 넣어줌. 
 > pip install pymysql

# python 소스
import random
import pymysql

fam_names = list("김이박최강고윤엄한배성백전황서천방지마피")
first_names = list("건성현욱정민현주희진영래주동혜도모영진선재현호시우인성마무병별솔하라")
alp = list("0123456789abcsefghijklmnopqrstuvwxyz" * 3)
num = list("0123456789" * 4)
addrs = ["서울", "부산", "대구"]

m30 = [4,6,9,11]
years = list(range(70, 99))
monthes = list(range(1, 13))
days = list(range(1, 32))
days30 = list(range(1, 31))
days28 = list(range(1, 29))

def nr(n=4):
    return "".join(random.sample(num, n))

def ar(n=5):
    return "".join(random.sample(alp, n))

def make_birth():
    y = random.choice(years)
    m = random.choice(monthes)
    d = random.choice(days)
    if m in m30 and d > 30:
        d = random.choice(days30)
    elif m == 2 and d > 28:
        d = random.choice(days28)

    return "{}{:02d}{:02d}".format(y, m, d)


def make_data():
    sung = random.choice(fam_names)
    name = "".join(random.sample(first_names, 2))

    tel = "010-{}-{}".format(nr(), nr())
    email = "{}@gmail.com".format(ar(random.randrange(3,9)))
    addr = random.choice(addrs)
    
    return (sung + name, tel, email, make_birth(), addr)

data = []
for i in range(1000):
    data.append(make_data())
print(data)


conn = pymysql.connect(
    host='localhost', 
    user='dooo', 
    password='dooo!', 
    port=3306, db='dooodb', 
    charset='utf8')

with conn:
    cur = conn.cursor()
    sql = "insert into Student(name, tel, email, birth, addr) values(%s, %s, %s, %s, %s)"
    cur.executemany(sql, data)
    print("AffecedRowCount is", cur.rowcount)
    conn.commit()
```
```mysql
START TRANSACTION;
-- 모든학생이 적어도 한과목은 수강하며, 한 학생은 최대 3과목까지 수강한다면!!
# Enroll테이블 Indexes탭에서 인덱스를 생성하고 student, subject 컬럼에 체크한 후 UNIQUE 타입으로 설정한다.
insert into Enroll(student, subject)
 select id, (select id from Subject order by rand() limit 1) sid from Student order by id;

insert into Enroll(student, subject)
 select id, (select id from Subject order by rand() limit 1) sid from Student order by rand() limit 500
 on duplicate key update student = student;
 
insert into Enroll(student, subject)
 select id, (select id from Subject order by rand() limit 1) sid from Student order by rand() limit 500
 on duplicate key update student = student;
 
 COMMIT;
 
-- 데이터 검증
select * from Enroll order by student;
select subject, student, count(*) from Enroll group by 1,2 having count(*)>1; 
```

# 문제 3
* 동아리(Club)별 회원 테이블(ClubMember)을 다음과 같이 만들고, 동아리별 50명 내외로 가입시키시오.  
(단, Club 테이블의 leader 컬럼은 삭제하고, 리더를 회원테이블의 레벨(level) 2로 등록하시오.)
```mysql
START TRANSACTION;

# ClubMember 테이블 생성.
create table ClubMember(
    id int unsigned not null auto_increment primary key,
    club varchar(31) not null default 0,
    student varchar(32) not null,
    level smallint unsigned not null default 0
);

# 각 club에 student를 배정하고, level에는 0 or 1 값을 줌.
insert into ClubMember(student, club, level)
 select id, (select id from Club order by rand() limit 1), floor(rand() * 2) sid from Student order by id;
 
# club의 id 값이 1인 학생들을 select 한 후, 임의의 학생 한명에게 클럽장의 level 값 2를 부여.
select *
from ClubMember
where club = 1
order by level desc;

update ClubMember set level ='2' where id ='8';

COMMIT;
```
```mysql
# 데이터 검증
-- 동아리별 학생 수를 확인.
select club, count(*)
from ClubMember
group by club;

-- 학생이 중복으로 동아리에 가입했는지 확인.
select club, student, count(*) from ClubMember group by 1,2 having count(*)>1; 

-- 각 동아리에 클럽장 수가 1명인지 확인.
select club, count(*)
from ClubMember
where level = 2
group by club, level;
```

# 문제 4
* 학과 테이블(Dept)을 만들고 5개 학과 이상 샘플 데이터를 등록하고,  
학생 테이블 학과 컬럼(dept)를 추가한 후 모든 학생에 대해 랜덤하게 과 배정을 시키시오.
```mysql
# Dept테이블 생성.
START TRANSACTION;
create table Dept(
    id int unsigned not null auto_increment primary key,
    name varchar(31) not null default 0,
    prof varchar(31) not null default 0,
    student varchar(32) not null default 0
);

insert into Dept(name) values('심리학과');
insert into Dept(name) values('모델과');
insert into Dept(name) values('통신과');
insert into Dept(name) values('컴퓨터과');
insert into Dept(name) values('디자인과');

# Prof 테이블에서 Dept테이블의 prof 컬럼에 랜덤으로 값을 가져옴.
Update Dept set prof = (select id from Prof order by rand() limit 1);

# student테이블에 dept컬럼 추가
ALTER TABLE `dooodb`.`Student` 
ADD COLUMN `dept` VARCHAR(31) NOT NULL DEFAULT 0 AFTER `gender`;

# Dept 테이블에서 Student테이블의 dept컬럼에 랜덤으로 값을 가져옴.
Update Student set dept = (select id from Dept order by rand() limit 1);

# Dept 테이블의 과대표(student) 설정.
Update Dept set student = (select id from Student where dept = 1 order by rand() limit 1) where id = 1;
Update Dept set student = (select id from Student where dept = 2 order by rand() limit 1) where id = 2;
Update Dept set student = (select id from Student where dept = 3 order by rand() limit 1) where id = 3;
Update Dept set student = (select id from Student where dept = 4 order by rand() limit 1) where id = 4;
Update Dept set student = (select id from Student where dept = 5 order by rand() limit 1) where id = 5;

COMMIT;
```
```mysql
# 데이터 검증
select * from Student;
select * from Dept;

-- 학과별 학생 수 확인
select dept, count(*)
from Student
group by dept;

-- dept테이블의 student 컬럼이 Student 테이블의 dept 컬럼과 일치하는지 확인.
select id, dept
from Student
where id = 978; 
```

# 문제 5
* 강의실 테이블(Classroom)을 만들고, 샘플강의실 10개를 등록하고,  
과목별 강의실 배치를 위해 과목(Subject) 테이블에 강의실컬럼(classroom)을 추가한 후 배정하시오.
```mysql
START TRANSACTION;

# Classroom 테이블 생성.
create table Classroom(
    id int unsigned not null auto_increment primary key,
    name varchar(31) not null
);

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

# Subject 테이블에 classroom 컬럼 추가
ALTER TABLE `dooodb`.`Subject` 
ADD COLUMN `classroom` SMALLINT(5) NOT NULL AFTER `prof`;

# Subject 테이블 classroom 컬럼에 Classroom의 id 값을 랜덤으로 가져옴.
update Subject set classroom= (select id from Classroom order by rand() limit 1);

COMMIT;
```
```mysql
# 데이터 검증
-- 과목별 강의실이 중복되지 않았는지 확인. 
select classroom, count(*)
from Subject
group by classroom;
```

# 문제 6  

1) 수강하는 과목별 중간고사, 기말고사 성적을 저장하는 테이블(Grade) 생성.  

* Grade 테이블 생성 
```mysql
START TRANSACTION;

create table Grade(  
    id int unsigned not null auto_increment primary key,
    midterm smallint unsigned not null default 0,
    finalterm smallint unsigned not null default 0,
    enroll smallint unsigned not null
);

COMMIT;
```
```
다른 설정 값
Grade테이블 편집 -> Indexes 탭 -> 컬럼 enroll에 인덱스 생성
Grade테이블 편집 -> 컬럼 enroll에 UQ값을 줌
```

2) 수강테이블 기준으로 샘플 데이터를 중간(midterm), 기말(finalterm), 성적(100점 만점)으로 구성.
```mysql
START TRANSACTION;
insert into Grade(enroll) (select id from Enroll order by id);
 
update Grade set midterm = (floor(rand() * 101));
update Grade set finalterm = (floor(rand() * 101));
COMMIT;
```
```mysql
# 데이터 검증
select * from Grade;
```
3) 과목별 수강생을 과목/성적 순으로 아래와 같은 형식으로 출력하는 SQL을 작성하시오.
```mysql
select sub.name as '과목명', stu.name as '학생명', g.midterm as '중간', g.finalterm as '기말',
          g.midterm + g.finalterm as '총점',  round((g.midterm + g.finalterm) / 2 , 1) as '평균',
          case when round((g.midterm + g.finalterm) / 2 , 1) >= 90 then 'A' 
               when round((g.midterm + g.finalterm) / 2 , 1) >= 80 then 'B' 
               when round((g.midterm + g.finalterm) / 2 , 1) >= 70 then 'C' 
               when round((g.midterm + g.finalterm) / 2 , 1) >= 60 then 'D' 
               when round((g.midterm + g.finalterm) / 2 , 1) >= 50 then 'E' 
	       else 'F' end as '학점' 
from Grade g inner join (Enroll e inner join Student stu on e.student = stu.id
						inner join Subject sub on e.subject = sub.id) on g.enroll = e.id
order by 1, 5 desc;
```
4) 과목별 통계 리포트를 과목순으로 하여 아래와 같이 출력하는 SQL을 작성하시오.
```mysql
# T1 테이블 생성.(문제3을 그대로 가져오는 테이블을 생성)
START TRANSACTION;
create table T1(
    id smallint unsigned not null auto_increment primary key,
    subject_t varchar(31) not null,
    student_t varchar(31) not null,
    midterm_t smallint unsigned not null,
    finalterm_t smallint unsigned not null,
    sum_t smallint unsigned not null,
    avg_t smallint unsigned not null,
    level_t varchar(10) not null
);
COMMIT;
```
```mysql
# 값을 넣어줌
START TRANSACTION;
insert into T1(subject_t , student_t, midterm_t, finalterm_t, sum_t , avg_t, level_t ) select sub.name as '과목', stu.name as '학생명', 
            g.midterm as '중간고사', g.finalterm as '기말고사',
            g.midterm + g.finalterm as '총점',  round((g.midterm + g.finalterm) / 2 , 1) as '평균',
            case when round((g.midterm + g.finalterm) / 2 , 1) >= 90 then 'A' 
                 when round((g.midterm + g.finalterm) / 2 , 1) >= 80 then 'B' 
                 when round((g.midterm + g.finalterm) / 2 , 1) >= 70 then 'C' 
                 when round((g.midterm + g.finalterm) / 2 , 1) >= 60 then 'D' 
                 when round((g.midterm + g.finalterm) / 2 , 1) >= 50 then 'E' 
		 else 'F' end as '학점' 
from Grade g inner join (Enroll e inner join Student stu on e.student = stu.id
	     inner join Subject sub on e.subject = sub.id) on g.enroll = e.id
order by 1, 6 desc;
COMMIT;
```
```mysql
select t.subject_t as '과목', round(avg(t.avg_t), 1) as '평균', count(t.student_t) as '학생 수',  
      (select student_t from T1 where subject_t = t.subject_t and sum_t = max(t.sum_t) limit 1) as '최고득점자',
      max(t.sum_t) as '최고점수'
from T1 t
group by t.subject_t
order by 1;
```
5) 학생별 통계 리포트를 성적순으로 하여 아래와 같이 출력하는 SQL을 작성하시오.
```mysql
select student_t as '학생명', count(subject_t) as '과목수', sum(sum_t) as '총점', round(sum(avg_t)/count(subject_t), 1) as '평균', 
       case when round(sum(avg_t)/count(subject_t), 1) >= 90 then 'A' 
            when round(sum(avg_t)/count(subject_t), 1) >= 80 then 'B' 
            when round(sum(avg_t)/count(subject_t), 1) >= 70 then 'C' 
            when round(sum(avg_t)/count(subject_t), 1) >= 60 then 'D' 
            when round(sum(avg_t)/count(subject_t), 1) >= 50 then 'E' 
            else 'F' end as '평점' 
from T1
group by 1
order by 3  desc; 
```





