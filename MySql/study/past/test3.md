# 문제 1
* 오라클 HR Schema를 수업 중 작성된 학적DB와 통할 할 경우, 어떻게 표준화 방법을 정의할지 고민하여,  
데이터 표준 지침을 작성하시오.
```
지침의 목적: mysql dooodb와 Oracle 데이터 통합
표준화 기준: 기존의 db (mysql)와 형식을 최대한 통일한다.

명칭
1) 모든 테이블명, (정식) 컬럼명은 영문으로 한다.
2) 테이블명은 단수형으로 한다.
3) 테이블의 첫글자는 대문자로 한다.
4) 테이블 이름에 이음동의어, 동음이의어는 허용하지 않는다.
5) 테이블명은 띄어쓰기를 하지 않는다. 언더바를 쓰는 대신 Pascal case로 한다.
6) 영문 약어명은 허용하지 않는다.
7) 컬럼명은 소문자로 한다.
8) 컬럼명에 띄어쓰기가 필요할 경우 언더바로 대체한다.
9) Primary key는 기존(HR스키마)의 것을 유지한다.
10) Index의 이름은 ‘소문자 컬럼명_대문자 타입명’으로 한다.
11) Foreign key 이름은 ‘fk_참조할 테이블명’으로 한다.
12) Trigger 이름은 ‘tr_원 테이블명_업데이트 될 테이블명_컬럼명‘으로 쓴다.
13) Charset/Collation은 utf8, utf8_unicode_ci로 통일한다.

데이터 타입
1) id의 타입은 int unsigned로 설정한다.
2) Oracle에서 varchar2는 MySQL에서 varchar로 변경한다.
3) Oracle에서 number는 MySQL에서 int unsigned로 변경한다.
4) Oracle의 number의 default는 0으로 설정한다.
5) Oracle의 varchar2의 default는 ‘’으로 설정한다.
6) Oracle의 chars는 MySQL에서 varchar로 변경한다.
7) Oracle의 date는 MySQL에서 date이며, YY/MM/DD 형식으로 입력한다.
8) null 값은 그대로 null로 설정한다.
```

# 문제 2
* 위 문제의 데이터 표준 지침에 의거하여 아래 4개 테이블들을 MySQL에서 생성하는 스크립트를 작성하시오.  
(EMPLOYEES, JOBS, JOB_HISTORY, DEPARTMENTS)
```mysql
drop table if exists Departments;

create table Departments(
	 id int unsigned not null primary key default 0,
	 department_name varchar(30) not null default '',
	 manager_id int default 0,
	 location_id int default 0
);

drop table if exists Jobs;

create table Jobs(
	  id varchar(10) not null primary key default '',
	  job_title varchar(35) not null default '', 
	  min_salary int default 0,
	  max_salary int default 0
);

drop table if exists Employees;

create table Employees (
	  id int unsigned not null primary key default 0,
      	  first_name varchar(20)  default '', 
	  last_name varchar(25) not null default '',
	  email varchar(25) not null default '',
	  phone_number varchar(20) default '',
	  hire_date date not null, 
	  salary int unsigned not null default 0,
	  commission_pct int unsigned not null default 0,
	  manager_id int unsigned not null default 0,
	  job_id varchar(10) not null default '',
	  department_id int unsigned not null default 0 ,
      	  constraint foreign key fk_jobs(job_id) references Jobs(id),
          constraint foreign key fk_departments(department_id) references Departments(id),
	  unique key(email)
);

alter table Employees  add constraint  fk_employees_manager foreign key ( manager_id ) 
	references Employees(id) on delete cascade;

drop table if exists JobHistory;

create table JobHistory(
	  employee_id int unsigned not null default 0,
	  start_date date not null,
	  end_date  date not null,
	  job_id varchar(10) not null default '',
	  department_id int unsigned not null default 0,
	  constraint foreign key fk_employees(employee_id) references Employees(id),
          constraint foreign key fk_jobs(job_id) references Jobs(id),
          constraint foreign key fk_departments(department_id) references Departments(id),
	  primary key (employee_id, start_date)
);
```


---
```
# 서술형 문제 1

* 데이터 표준화의 정의 및 필요성에 대하여 서술하시오.

1. 데이터 표준화의 정의
데이터 표준화는 시스템별로 산재해 있는 데이터 정보 요소에 대한 명칭, 정의, 형식, 규칙에 대한 원칙을 수립하여 
이를 전사적으로 적용하는 것을 의미한다. 이러한 데이터 표준화 작업은 데이터의 정확한 의미를 파악할 수 있게 할 뿐만 아니라 
데이터에 대한 상반된 시각을 조정하는 역할을 수행한다.

2. 데이터 표준화의 필요성
- 명칭의 통일로 인한 명확한 의사소통의 증대 :
동일한 데이터에 대해서는 동일한 명칭을 사용함으로써 개발자-현업, 운영자-현업, 운영자-운영자 등 
다양한 계층간에 명확하고 신속한 의사소통이 가능하다.

- 필요한 데이터의 소재 파악에 소요되는 시간 및 노력 감소 :
새로운 정보 요건 사항 발생시 표준화된 데이터를 사용함으로써 데이터의 의미, 데이터의 위치 등을 신속하게 파악할 수 있어 
정보 활용자에게 원하는 시기에 정확한 정보를 전달한다.

- 일관된 데이터 형식 및 규칙의 적용으로 인한 데이터 품질 향상 :
데이터 형식 및 규칙을 데이터 표준에 맞게 적용함으로써 데이터의 입력 오류 방지를 통해 데이터의 품질을 향상시킬 수 있다. 
또한 데이터의 활용에 있어 표준에 근거하여 활용함으로써 잘못된 데이터의 활용으로 인한 의사결정의 오류를 줄인다.

- 정보시스템 간 데이터 인터페이스 시 데이터 변환, 정제 비용 감소 :
데이터 통합 프로젝트나 개별 시스템에서 다른 시스템의 데이터가 필요한 경우 전사적으로 데이터 표준에 의해 
데이터가 관리되고 있으면, 별도의 변환이나 정제 작업을 수행하지 않고 그대로 활용 하면 되기 때문에 
별도의 비용적인 부분이 발생하지 않는다.

# 서술형 문제 2

* 데이터 표준화 절차에는 어떠한 것이 있으며, 각 절차별 요소에 대해 서술하시오.

1. 표준화 대상 도출 및 정의
기존 업무 수행 시 데이터 활용에 따른 문제점을 담당자 인터뷰 등을 통해 조사하고, 
정보 시스템에서 활용하는 식별자, 항목 표시, 코드, 서식 등을 분석하여 외부기관과의
연계 등에서 발생하는 문제점과 국가 및 산업 표준에 따른 개선사항 등을 파악한다.

(1) 규정 및 가이드라인과 기존 코드 표준, 시스템 운영 문서를 수집하고, 시스템에 대한
    역공학(Reverse Engineering)을 통해 시스템별 컬럼, 코드, 도메인을 분석
(2) 표준 데이터 항목을 정의한다.
(3) 표준 데이터 체크리스트를 활용하여 검토한다.
  - 데이터 요소 표준 지침에 적합한가?
  - 전사적인 코드 표준에 적합한가?
  - 동음이의어, 이음동의어?
  - 기존의 표준 코드는 반영되었는가?
 (4) 정의된 표준 데이터 항목을 검토한 후, 표준 데이터 관리 저장소에 등록하여 
     전사적으로 활용할 수 있도록 관리한다.
 
 2. 표준화 방안을 분석한다.
 조사한 표준화 대상 항목별로 문제점과 개선 사항 등 데이터의 특성을 정리하고,
 데이터 항목 간의 관련성 등 연계 관계를 고려하여 표준화 방안과 표준화 추진 시 
 고려사항 등을 정리한다.
 
 3. 표준화 체계 및 적용 방안을 정립한다.
 분석한 문제점과 개선 사항을 기초로 표준화 방안을 정리하고 내용을 검토 및 보완하여 표준화 방안을 수립한다. 
 표준화 방안에 따른 표준화 체계와 적용 방안을 수립하여 적용한다.
```
