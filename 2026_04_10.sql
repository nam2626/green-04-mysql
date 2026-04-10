-- student_db
create database student_db;

use student_db;

-- 학생 테이블
--	 학번, 이름, 학과명, 입학년도, 이메일
--   20251111, 홍길동, 경영정보학과, 2026, hong1234@test.ac.kr
create table student(
	no char(8) primary key,
	-- not null 반드시 입력
	name varchar(10) not null,
	major varchar(20),
	in_year year,
	email varchar(50)
);

-- 샘플 데이터 10건
insert into student(no, name, major, in_year, email)
values('20221111','홍길동','경영정보학과',2022,'test_hong@test.ac.kr');

select * from student;

insert into student(no, name, major, in_year, email)
values('20221112','김영희','경영정보학과',2022,'test_kim@test.ac.kr');

commit;
rollback;

-- 데이터 조회
-- 전체 조회
select * from student;
-- 특정 컬럼 조회
-- 이름, 학과명, 이메일
select name, major, email from student;
-- 학번, 이메일, 학과명
select no, email, major from student;
-- 입학년도가 2024년인 학생 데이터만 조회
select * from student where in_year = 2024; 
-- 입학년도가 2025년이 아닌 학생 데이터만 조회
select * from student where in_year != 2025;
-- 학과명이 컴퓨터공학과인 학생 데이터만 조회
select * from student where major = '컴퓨터공학과';
-- 이름이 김씨인 학생만 조회
select * from student where name like '김%';
-- 이름이 현으로 끝나는 학생만 조회
select * from student where name like '%현';
-- 이름에 서가 들어가는 학생만 조회
select * from student where name like '%서%';
-- 학과명에 공학과로 끝나는데, 공학과 앞에 반드시 2글자가 와야함.
select * from student where major like '__공학과';
-- 학생 이메일이 네이버 메일인 학생을 조회
select * from student where email like '%@naver.com'
-- 입학년도가 2023, 2024인 학생들만 조회
select * from student where in_year = 2023 or in_year = 2024;
select * from student where in_year in(2023,2024);
select * from student where in_year between 2023 and 2024;
-- __공학과로 끝나지 않는 학과만 조회
select * from student where major not like '__공학과';
-- 입학년도가 2023, 2024가 아닌 학생만 조회
select * from student where in_year not in(2023,2024);
-- 입학년도가 2023이 아닌 학생만 조회
select * from student where not in_year = 2023;
-- 정렬 - order by 컬럼명 asc, 컬럼명 desc
-- asc 오름차순, desc 내림차순
select * from student order by in_year desc;
select * from student order by in_year desc, no asc;
-- 이름 기준으로 내림차순 정렬
select * from student order by name desc;
-- 고정길이 문자열, 가변길이 문자열
CREATE TABLE string_test (
    char_col CHAR(10),
    varchar_col VARCHAR(10)
);

INSERT INTO string_test VALUES ('Apple', 'Apple');

select * from string_test;
-- 비교하면 뒤에 공백은 무시하고 비교
select * from string_test where char_col = 'Apple';
-- 다른 DB는 조회가 안됨.
-- 고정길이 문자열은 남은 공간을 공백으로 저장, 공백까지 비교
select * from string_test where char_col like 'Apple';
select LENGTH(char_col), LENGTH(varchar_col) from string_test;

-- 학생테이블에 있는 학과 목록만 조회, 단 중복된 학과는 제거
select distinct major from student;

-- alter : create로 만든 개체를 수정할때 사용
-- 사용자 비밀번호 변경
alter user 'car_admin'@'localhost' identified by '123456789';
-- 테이블 이름 변경
alter table string_test rename to new_string_test;
-- 컬럼 추가
alter table new_string_test add column num int default 100;
-- 학생 테이블에 성별 컬럼 추가 boolean 기본값 false
alter table student add column gender boolean default false;
-- 성별 컬럼 지우기
alter table student drop column gender;
-- 컬럼 타입 변경
alter table student modify column name varchar(15) not null;
-- 타입 변경시 기존 데이터가 변환이 되는 건지 체크
alter table student modify column name int not null;
alter table student modify column name varchar(2) not null;
-- 컬럼 이름 변경
alter table student change column gender new_gender boolean default false;
-- update 수정
-- update 테이블명 set 컬럼명 = 수정할값, .... where 조건식
update student set in_year = 2022 where in_year = 2023;
-- delete 삭제
-- delete from 테이블명 where 조건식
-- 김씨인 학생 데이터만 삭제
delete from student where name like '김%';

-- 학과 테이블
-- 1. 학과 목록만 추출
select distinct major from student;
-- 2. 학과 번호 생성하여 학과번호, 학과명 조회
select row_number() over(order by major) as no, major as name
from (select distinct major from student) s;

select CONCAT('M', LPAD(ROW_NUMBER() over (order by major), 3, '0') ) as no,
major as name
from (select distinct major from student) as unique_majors;
-- 3. 학과 테이블 생성
create table major(
	no char(4) primary key,
	name varchar(20)
);
-- 4. 학과 테이블에 데이터 추가
insert into major(no, name)
select CONCAT('M', LPAD(ROW_NUMBER() over (order by major), 3, '0') ) as no,
major as name
from (select distinct major from student) as unique_majors;
-- 5. 학과 테이블 생성하면서 데이터를 추가 - 추천 X
create table major2
as 
select CONCAT('M', LPAD(ROW_NUMBER() over (order by major), 3, '0') ) as no,
major as name
from (select distinct major from student) as unique_majors;

-- 6. 학생 테이블에 학과 번호 컬럼을 추가
alter table student add column mno char(4);

-- 7. 학생 테이블에 학과 번호 값을 업데이트, 학과 테이블을 참조해서 업데이트 수행
update student set mno = (select no from major where name = major); 

-- 8. 학생 테이블의 학과명을 컬럼을 제거
alter table student drop column major;

-- 9. 간단하게 조인 체험
select s.no, s.name, m.name, s.email 
from student s join major m on s.mno = m.no; 


-- ---------------------------------------------------------
-- 도서 관리 DB 구축
-- ---------------------------------------------------------
-- 1. library_db 생성
create database library_db; 

use library_db;

-- 2. books 테이블 생성
--	 도서 고유번호, 도서 제목, 저자, 출판사, ISBN, 재고수량, 등록일
create table books(
	id int AUTO_INCREMENT primary key,
	title varchar(100) not null,
	author varchar(50),
	publisher varchar(50),
	isbn char(13),
	stock int default 0,
	reg_date datetime default now()
);

-- 3. 샘플 데이터 5건 생성해서 저장
insert into books(title, author, publisher, isbn, stock)
values('자바의 정석', '남궁성', '도우출판', '9788968481479', 10),
('파이썬 라이브러리를 활용한 데이터 분석', '웨스 맥키니', '한빛미디어', '9788968482766', 5),
('코딩 인터뷰 완전 분석', '게일 라크만 맥도웰', '인사이트', '9788966263997', 8),
('클린 코드', '로버트 C. 마틴', '인사이트', '9788966266308', 12),
('알고리즘 트레이닝', '구종만', '인사이트', '9788966266315', 7);


-- 4. 도서 분류 테이블
--   분류 아이디값, 분류명, 분류설명

-- 5. 도서 분류샘플데이터 5건 생성해서 저장

-- 6. 도서 테이블에 분류 아이디 컬럼 추가

-- 7. 각 테이블에 샘플 데이터 추가







