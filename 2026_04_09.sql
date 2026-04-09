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





