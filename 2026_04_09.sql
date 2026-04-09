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

-- 자동차 DB 생성
-- car_db
create database car_db;
-- 생성된 DB 목록 확인
show databases;
-- 생성한 DB 선택
use car_db;
-- 현재 선택된 DB확인
select database();

-- 계정생성
--            사용자명      호스트(IP, %, localhost)    암호
create user 'car_admin'@'localhost' identified by '12345678';
-- 권한부여
grant all privileges on car_db.* to 'car_admin'@'localhost';
-- 권한 즉시 적용
flush privileges;
-- 부여된 권한 확인
show grants for 'car_admin'@'localhost';
-- car table
CREATE TABLE cars (
  car_id       INT           AUTO_INCREMENT PRIMARY KEY, -- 차량 고유번호
  brand        VARCHAR(50)   NOT NULL,                   -- 브랜드 (현대, BMW 등)
  model        VARCHAR(100)  NOT NULL,                   -- 모델명 (아반떼, 5시리즈 등)
  year         INT,                                      -- 연식
  mileage      INT,                                      -- 주행거리 (km)
  price        DECIMAL(12,0),                            -- 판매가격 (원)
  registered_at DATETIME     DEFAULT NOW()               -- 등록일
);
-- 샘플데이터 추가
INSERT INTO cars (brand, model, year, mileage, price)
VALUES 
('현대', '아반떼 CN7', 2022, 25000, 21000000),
('기아', '쏘렌토 MQ4', 2021, 48000, 35500000),
('제네시스', 'G80 (RG3)', 2023, 12000, 62000000),
('BMW', '5시리즈 (G30)', 2020, 55000, 42000000),
('테슬라', '모델 3', 2021, 38000, 45000000);

-- car 직원 사용자
-- 사용자명 : car_user
create user 'car_user'@'localhost' identified by '12345678';
-- 현재 존재하는 계정 목록
select user, host from mysql.user;
-- 직원은 car_db에 있는 테이블 조회 권한만 부여
grant select on car_db.* to 'car_user'@'localhost';
show grants for 'car_user'@'localhost';
-- 권한 회수
revoke select on car_db.* from 'car_user'@'localhost';
flush privileges;

-- 회원 DB 생성
create database member_db;
-- 회원 관리자, 앱 사용자, 콜센터 사용자 생성
create user 'member_admin'@'localhost' identified by '12345678';
create user 'app_user'@'localhost' identified by '12345678';
create user 'cs_user'@'localhost' identified by '12345678';
-- 권한 부여
grant all privileges on member_db.* 
to 'member_admin'@'localhost';
grant select,insert,update on member_db.* 
to 'app_user'@'localhost';
grant select on member_db.* to 'cs_user'@'localhost';

-- DB 선택
use member_db;
-- 회원 테이블 생성
CREATE TABLE members (
  member_id   INT          AUTO_INCREMENT PRIMARY KEY, -- 회원 고유번호
  username    VARCHAR(50)  NOT NULL,                   -- 아이디
  email       VARCHAR(100) NOT NULL,                   -- 이메일
  grade       VARCHAR(20)  DEFAULT 'BRONZE',           -- 회원 등급
  is_active   BOOLEAN      DEFAULT TRUE,               -- 활성 여부
  joined_at   DATETIME     DEFAULT NOW()               -- 가입일
);

-- 회원 테이블에 샘플데이터 추가
INSERT INTO members (username, email, grade, is_active, joined_at) VALUES
('kim_coder', 'kim@example.com', 'GOLD', TRUE, '2023-01-15 10:30:00'),
('lee_developer', 'lee@example.com', 'SILVER', TRUE, '2023-05-20 14:15:00'),
('park_star', 'park@example.com', 'BRONZE', TRUE, NOW()),
('choi_admin', 'choi@example.com', 'PLATINUM', TRUE, '2022-12-01 09:00:00'),
('jung_user', 'jung@example.com', 'BRONZE', FALSE, '2024-02-10 18:45:00');

SELECT * FROM members;
