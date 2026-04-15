use group_student;
-- 전체 데이터 기준
-- 1. 전체 학생수 구하기
select count(*) from student;
-- 2. 전화번호가 등록된 학생 수를 구하기
--    null 아닌 개수
update student set phone = null where name like '윤%';
select * from student where phone is null;
select count(phone) from student;
-- 3. 전체 수강 내역의 평균 평점을 구하기
select truncate(avg(grade),2) from enrollment;
