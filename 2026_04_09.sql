-- DB 생성
create database student_db;

create database student_db
	character set utf8mb4
    collate utf8mb4_0900_ai_ci;
    
-- DB 선택
use student_db;

-- 학생 테이블 생성
create table students(
	student_id int auto_increment primary key,
    name varchar(50) not null,
    grade int,
    email varchar(200),
    enrolled_at datetime default now()
);
-- 데이터베이스 목록 확인
show databases;

-- 테이블 삭제
drop table students;
-- DB 삭제
drop database student_db;



