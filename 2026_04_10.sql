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

select * from student where major like '__공학과';







