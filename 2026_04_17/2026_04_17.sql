
-- 학생정보 조회
--  학번 이름 학과명 학과번호 연락처
select s.`no`, s.name, s.major_no, s.phone, m.name  
from student s join major m on s.major_no = m.`no`;

create or replace view student_view
as
select s.`no`, s.name as student_name, s.major_no, s.phone, m.name  as major_name
from student s join major m on s.major_no = m.`no`;

-- 뷰 조회
select * from student_view;

-- 줄번호
select row_number() over(order by s.no) as rw ,
	s.`no`, s.name as student_name, s.major_no, s.phone, m.name  as major_name
from student s join major m on s.major_no = m.`no`;

create or replace view student_view
as
select row_number() over(order by s.no) as rw ,
	s.`no`, s.name as student_name, s.major_no, s.phone, m.name  as major_name
from student s join major m on s.major_no = m.`no`;

-- 뷰 목록 조회
show full tables where table_type = 'VIEW';

-- 인덱스
-- 인덱스 확인 방법
show index from student;

explain select * from enrollment e where student_no = '20230260';

select * from enrollment e where student_no = '20230260';


-- 실습 데이터 및 DB
create database idx_db;
use idx_db;

CREATE TABLE IF NOT EXISTS members (
  member_id  INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(50)  NOT NULL,
  email      VARCHAR(100) UNIQUE NOT NULL,
  phone      VARCHAR(20),
  grade      ENUM('BRONZE','SILVER','GOLD') DEFAULT 'BRONZE',
  point      INT DEFAULT 0,
  joined_at  DATETIME DEFAULT NOW()
);

-- 구매 테이블
CREATE TABLE IF NOT EXISTS purchases (
  purchase_id  INT AUTO_INCREMENT PRIMARY KEY,
  member_id    INT NOT NULL,
  item_name    VARCHAR(100) NOT NULL,
  price        INT NOT NULL,
  discount     INT DEFAULT 0,
  purchased_at DATETIME DEFAULT NOW(),
  FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- 샘플 데이터
INSERT INTO members (name, email, phone, grade, point) VALUES
  ('김영희', 'kim@test.com',  '010-1111-0001', 'GOLD',   1500),
  ('이준호', 'lee@test.com',  '010-1111-0002', 'SILVER', 800),
  ('박지연', 'park@test.com', '010-1111-0003', 'BRONZE', 200),
  ('정수연', 'jung@test.com', '010-1111-0004', 'GOLD',   3200),
  ('최현우', 'choi@test.com', '010-1111-0005', 'BRONZE',    0);

INSERT INTO purchases (member_id, item_name, price, discount, purchased_at) VALUES
  (1, '무선 키보드', 50000, 5000, '2025-03-01 10:00:00'),
  (1, '어댓패드',     30000, 3000, '2025-03-15 14:30:00'),
  (2, '미케이블츼',  15000,    0, '2025-02-20 09:00:00'),
  (3, 'USB 허브',      12000, 2000, '2025-04-01 11:00:00'),
  (4, '모니터',     250000,20000, '2025-01-10 16:00:00'),
  (4, '노트북 거치대', 40000,    0, '2025-02-05 13:00:00');



DELIMITER $$
CREATE PROCEDURE generate_purchase_data()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE mem_count INT;
  SELECT COUNT(*) INTO mem_count FROM members;

  WHILE i <= 10000 DO
    INSERT INTO purchases (member_id, item_name, price, discount, purchased_at)
    VALUES (
      FLOOR(1 + RAND() * mem_count),
      CONCAT('상품-', LPAD(i, 4, '0')),
      FLOOR(1000 + RAND() * 50000),
      FLOOR(RAND() * 5000),
      DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY)
    );
    SET i = i + 1;
  END WHILE;
END $$
DELIMITER ;

call generate_purchase_data();

select count(*) from purchases p;

EXPLAIN SELECT * FROM purchases WHERE member_id = 1;

explain SELECT COUNT(*) FROM purchases
WHERE purchased_at >= DATE_SUB(NOW(), INTERVAL 30 DAY);

explain select * from purchases
where item_name = '어댓패드';

create index idx_purchased_at on purchases(purchased_at);
create index idx_name on purchases(item_name);

-- 인덱스 통계 정보 갱신, 물리적인 공간 정리
OPTIMIZE TABLE purchases;

-- 자동차
-- 차량 테이블
CREATE TABLE IF NOT EXISTS cars (
  car_id       INT AUTO_INCREMENT PRIMARY KEY,
  brand        VARCHAR(50) NOT NULL,
  model        VARCHAR(50) NOT NULL,
  category     ENUM('소형','중형','대형','SUV') NOT NULL,
  daily_rate   INT NOT NULL,
  status       VARCHAR(20) DEFAULT '가용',
  registered_at DATETIME DEFAULT NOW()
);

-- 고객 테이블
CREATE TABLE IF NOT EXISTS customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(50)  NOT NULL,
  phone       VARCHAR(20),
  email       VARCHAR(100) UNIQUE,
  license_no  VARCHAR(20)  UNIQUE NOT NULL
);

-- 렌탈 테이블
CREATE TABLE IF NOT EXISTS rentals (
  rental_id   INT AUTO_INCREMENT PRIMARY KEY,
  car_id      INT NOT NULL,
  customer_id INT NOT NULL,
  start_date  DATE NOT NULL,
  end_date    DATE NOT NULL,
  actual_return DATE,
  total_fee   INT NOT NULL,
  discount    INT DEFAULT 0,
  rented_at   DATETIME DEFAULT NOW(),
  FOREIGN KEY (car_id)      REFERENCES cars(car_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 샘플 데이터
INSERT INTO cars (brand, model, category, daily_rate, status) VALUES
  ('현대', '아이오닉',   '소형',  40000, '가용'),
  ('기아', '스토닉',     '중형',  55000, '가용'),
  ('숨셸', 'G80',         '대형',  90000, '대여중'),
  ('펌티앤', '팅커',    'SUV', 120000, '가용'),
  ('테슬라', '모델Y', 'SUV', 150000, '가용');

INSERT INTO customers (name, phone, email, license_no) VALUES
  ('김맑도', '010-2222-0001', 'rip@car.com',  'LC-001'),
  ('이소율', '010-2222-0002', 'soy@car.com',  'LC-002'),
  ('박민준', '010-2222-0003', 'min@car.com',  'LC-003');

INSERT INTO rentals (car_id, customer_id, start_date, end_date, actual_return, total_fee, discount) VALUES
  (1, 1, '2025-03-01', '2025-03-05', '2025-03-05', 160000, 10000),
  (2, 2, '2025-03-10', '2025-03-15', '2025-03-16', 275000,     0),
  (3, 3, '2025-04-01', '2025-04-03', NULL,          180000, 20000),
  (4, 1, '2025-02-14', '2025-02-17', '2025-02-17', 360000, 30000);

DELIMITER $$
create PROCEDURE generate_rental_data()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE car_cnt INT;
  DECLARE cust_cnt INT;
  SELECT COUNT(*) INTO car_cnt  FROM cars;
  SELECT COUNT(*) INTO cust_cnt FROM customers;

  WHILE i <= 10000 DO
    SET @start = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY);
    SET @days  = FLOOR(1 + RAND() * 14);
    INSERT INTO rentals (car_id, customer_id, start_date, end_date, total_fee, discount, rented_at)
    VALUES (
      FLOOR(1 + RAND() * car_cnt),
      FLOOR(1 + RAND() * cust_cnt),
      @start,
      DATE_ADD(@start, INTERVAL @days DAY),
      FLOOR(30000 + RAND() * 500000),
      FLOOR(RAND() * 20000),
      @start
    );
    SET i = i + 1;
  END WHILE;
END $$
DELIMITER ;

CALL generate_rental_data();
SELECT COUNT(*) FROM rentals;

EXPLAIN SELECT * FROM rentals WHERE car_id = 1;
explain SELECT COUNT(*) FROM rentals
WHERE start_date >= DATE_SUB(NOW(), INTERVAL 30 DAY);

CREATE INDEX idx_rentals_date ON rentals(start_date);

-- trigger
-- 데이터베이스 생성
CREATE DATABASE trigger_study;
USE trigger_study;

-- 직원 테이블
CREATE TABLE employees (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(50)    NOT NULL,
    dept      VARCHAR(30)    NOT NULL,
    salary    INT            NOT NULL,
    hired_at  DATE           NOT NULL
);

-- 급여 변경 이력 테이블 (트리거가 자동으로 기록)
CREATE TABLE salary_log (
    log_id      INT AUTO_INCREMENT PRIMARY KEY,
    emp_id      INT            NOT NULL,
    old_salary  INT,
    new_salary  INT,
    changed_at  DATETIME       NOT NULL,
    memo        VARCHAR(100)
);

-- 삭제된 직원 보관 테이블
CREATE TABLE deleted_employees (
    id          INT,
    name        VARCHAR(50),
    dept        VARCHAR(30),
    salary      INT,
    hired_at    DATE,
    deleted_at  DATETIME       NOT NULL
);

INSERT INTO employees (name, dept, salary, hired_at) VALUES
    ('김민준', '개발팀',  3500000, '2020-03-02'),
    ('이서연', '마케팅팀', 3200000, '2021-07-15'),
    ('박지호', '개발팀',  4000000, '2019-01-10'),
    ('최예린', '인사팀',  2900000, '2022-11-01');

-- 급여 변경 이력 자동 기록
-- AFTER UPDATE

DELIMITER $$
create trigger trg_salary_log
after update on employees
for each row
begin
	if old.salary != new.salary then
		insert into salary_log(emp_id,old_salary,new_salary,changed_at,memo)
		values(
			old.id,
			old.salary,
			new.salary,
			now(),
			concat(old.name,'의 급여 변경'));
	end if;
end $$
DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_after_delete_employees
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO deleted_employees (
        id,
        name,
        dept,
        salary,
        hired_at,
        deleted_at
    )
    VALUES (
        OLD.id,
        OLD.name,
        OLD.dept,
        OLD.salary,
        OLD.hired_at,
        NOW()
    );
END $$

DELIMITER ;


























