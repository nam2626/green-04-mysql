use new_student_db;

-- CONCAT : 문자열을 연결하는 함수
-- as : 별칭을 지정하는 키워드
select concat('홍', '길동', '입니다') as text;
-- student 테이블에서 학생의 이름과 전화번호를 묶어서 이름(전화번호) 형식으로 조회
-- 김철수(01012345678)
select CONCAT(name, '(',phone,')') as name from student;
-- course 테이블에서 과목명과 학점을 묶어 "[과목명] - 학점: 점수" 형식으로 출력하세요. 
-- [운영체제론] - 학점: 3
select concat('[',name,'] - 학점 :' , score)  from course;
-- 지우
select * from student where name like concat('%', '지우' ,'%');

-- SUBSTRING : 특정 문자열을 추출
select substring('1234567890', 3,2), substring('1234567890', 5,4)
-- SUBSTRING: 날짜 문자열에서 연도만 추출하기
-- 2026-04-14

-- student 테이블에서 학번(no)은 8자리(예: 20261234)로 구성되어 있습니다.
-- 학번의 앞 4자리를 추출하여 '입학년도'라는 별칭으로 조회하세요

-- major 테이블에서 전화번호(tel)의 첫 3자리(지역번호 등)만 추출하여 조회하세요.



