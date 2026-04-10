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










