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




