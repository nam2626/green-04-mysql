-- student DB 삭제
drop database student_db;
-- student DB 생성
create database student_db;
use student_db;

-- 학과 테이블
--   학과번호, 학과명, 등록일
--   컬럼명 데이터타입 제약조건1 제약조건2
create table major(
	no int auto_increment primary key,
	name varchar(20) not null unique,
	reg_date date default (CURRENT_DATE)
);
-- 샘플 데이터 5건 추가
-- 1. reg_date를 기본값(현재 날짜)으로 사용하는 경우
INSERT INTO major (name) VALUES ('컴퓨터공학');
INSERT INTO major (name) VALUES ('경영학');

-- 2. reg_date를 직접 지정하는 경우 (과거 데이터 입력 등)
INSERT INTO major (name, reg_date) VALUES ('시각디자인학', '2024-03-02');
INSERT INTO major (name, reg_date) VALUES ('전자공학', '2025-01-15');

-- 3. 여러 건을 한 번에 삽입하는 경우
INSERT INTO major (name) VALUES ('심리학');



