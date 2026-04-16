create database sub_member_db;
use sub_member_db;

-- 회원 테이블
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

-- 단일행 : 가장 포인트가 높은 회원
-- 1. 포인트 최대값 조회
select max(point) from members;
-- 2. 회원 테이블에서 포인트 컬럼이 1번 쿼리와 같은 값만 조회
select * from members where point = (select max(point) from members);
-- 3. 회원 테이블에서 포인트가 평균 이상인 회원만 조회
select * from members where point >= (select avg(point) from members);
-- 다중행 : GOLD 등급 회원의 구매 내역
select * from purchases p 
where p.member_id in(select member_id from members m where m.grade = 'Gold');
-- 4. 인라인 뷰 : 회원별 총 구매금액 계산 후에 평균 이상만 필터
-- 4-1. 회원별 총 구매금액 조회
select member_id, sum(price - discount) as total
from purchases  group by member_id ;
-- 4-2. 인라인뷰는 1번의 조회결과 from 절에 지정
select *
from 
	(select member_id, sum(price - discount) as total
		from purchases  group by member_id) t
where total >= (select avg(price-discount) from purchases);

-- ------------------------
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

-- 단일행: 일일 렌탈료가 가장 비싼 차량
select * from cars where daily_rate = (select max(daily_rate) from cars);

-- 다중행: SUV가 렌탈된 이력
select * from cars c join rentals r on c.car_id = r.car_id where c.category = 'SUV';

select * from rentals 
where car_id in(select car_id from cars where category = 'SUV');

-- 인라인 뷰: 차량별 누적 수익 계산 후 평균 이상만
select * 
from
	(select car_id, sum(total_fee - discount) as sum_total 
	from rentals group by car_id) r
where 
	sum_total >= (select avg(total_fee - discount) from rentals); 

-- 스칼라






