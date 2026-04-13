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

select * from major;

-- 2. reg_date를 직접 지정하는 경우 (과거 데이터 입력 등)
INSERT INTO major (name, reg_date) VALUES ('시각디자인학', '2024-03-02');
INSERT INTO major (name, reg_date) VALUES ('전자공학', '2025-01-15');

-- 3. 여러 건을 한 번에 삽입하는 경우
INSERT INTO major (name) VALUES ('심리학'),('생활체육');
-- 테이블 속성 확인
desc major;

-- 학생 테이블 생성 (학과 테이블 참조)
CREATE TABLE students (
  student_id  INT          AUTO_INCREMENT PRIMARY KEY,  -- 학생 고유번호
  name        VARCHAR(50)  NOT NULL,                    -- 이름
  email       VARCHAR(100) NOT NULL UNIQUE,             -- 이메일 (중복 불가)
  major_no     INT,                                      -- 학과
  is_active  BOOLEAN      DEFAULT TRUE,                -- 재학 여부
  enrolled_at DATETIME     DEFAULT NOW()               -- 등록일
);

-- 연락처 추가
alter table students add column phone char(11);
-- email에 @가 들어가 있는지 체크하는 제약 조건
alter table students add constraint chk_email check(email like '_%@%_');
-- chk_email 제약조건 제거
alter table students drop constraint chk_email;

-- 1번 학생 (기본 설정값 사용) - 체크
INSERT INTO students (name, email, major_no) 
VALUES ('김철수', 'chulsoo@example.com', 1);

-- 2번 학생 (학과 번호 2)
INSERT INTO students (name, email, major_no) 
VALUES ('이영희', 'y@oungheeexample.com', 2);

-- 3번 학생 (휴학 중인 경우)
INSERT INTO students (name, email, major_no, is_active) 
VALUES ('박민수', 'minsooexample.co@m', 1, FALSE);

-- 4번 학생 (직접 등록일 지정)
INSERT INTO students (name, email, major_no, enrolled_at) 
VALUES ('최지우', 'jiwoo@example.com', 3, '2025-12-25 10:30:00');

-- 5번 학생 (학과 번호 4)
INSERT INTO students (name, email, major_no) 
VALUES ('정다은', 'daeun@example.com', 4);

-- 외래키(Foreign Key)FK 제약 조건
-- on delete restrict : 참조중인 값이 있으면 삭제가 안되게끔 멈춤
--                      참조중인 테이블의 튜플을 제거 및 업데이트 수행 후 삭제 가능
--						참조중인 값이 없어야 삭제가 가능
alter table students add constraint fk_major_no foreign key(major_no)
references major(no) on delete restrict;
-- on delete set null : 삭제가 되었을 떄 참조중 값은 null로 변경
alter table students add constraint fk_major_no foreign key(major_no)
references major(no) on delete set null;
-- on delete cascade : 참조되던 값이 삭제되면 같이 삭제
alter table students add constraint fk_major_no foreign key(major_no)
references major(no) on delete cascade;

-- on update restirct : 자식테이블에 값이 있으면 수정 작업을 취소
alter table students add constraint fk_major_no foreign key(major_no)
references major(no) on update restrict;
-- on update cascade :  자식테이블에 값이 있으면 수정 작업을 할 때 동일 한 값으로 수정
alter table students add constraint fk_major_no foreign key(major_no)
references major(no) on update cascade;
-- on update cascade :  자식테이블에 값이 있으면 수정 작업을 할 때 NULL 값으로 수정
alter table students add constraint fk_major_no foreign key(major_no)
references major(no) on update set null;

-- 두 옵션을 전부 한번에 처리
alter table students add constraint fk_major_no foreign key(major_no)
references major(no) on delete cascade on update set null;

-- 외래키 제약 조건 삭제
alter table students drop constraint fk_major_no;

delete from major where no = 2;

select * from students;

-- 기본키 추가 방법
-- 과목 테이블
--  과목번호, 과목명
drop table subjects;
create table subjects(
	code int,
	title varchar(20)
);

alter table subjects add constraint pk_code primary key(code);
-- 기본키 제거 방법
alter table subjects drop primary key;





