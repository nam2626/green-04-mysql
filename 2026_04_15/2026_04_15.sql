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
-- 4. 개설된 강좌 중 가장 높은 학점과 낮은 학점을 구하기
select max(score), min(score) from course;
-- 5. 모든 강좌의 학점 총합
select sum(score) from course;

-- 테이블 단일 그룹화
-- 1. 학과 번호별 학생 수 구하기
select major_no, count(*) as student_count
from student
group by major_no
order by student_count desc;
-- 2. 수강 테이블에서 강좌 번호별 수강생 수 조회
select course_no, concat(count(*),'명') as course_count
from enrollment
group by course_no;
-- 3. 수강 테이블에서 학생 번호별 수강한 과목수를 조회
select student_no, count(*) as course_count
from enrollment
group by student_no;
-- 4. 수강 테이블에서 강좌 번호별 최고 평점, 최저 평점
select course_no, max(grade) as max_grade, min(grade) as min_grade
from enrollment
group by course_no;
-- 5. 학과 테이블에서 건물별로 위치한 학과 수 조회
select building, count(*) as count_major
from major
group by building;
-- having 절 활용(그룹 조건 필터)
-- 1. 강좌별 수강생 인원수를 조회(단, 수강생이 150명 이상인 것만 대상)
select course_no, count(*) as course_count
from enrollment
group by course_no having count(*) >= 150;
-- 2. 평균 평점이 2.5 이상인 학생들을 조회
-- 학번 평균_평점
select student_no,avg(grade) as avg_grade
from enrollment
group by student_no having avg(grade) >= 2.5;
-- 3. 입학년도별 학생 인원수를 조회
select left(no,4) as in_year, count(*) as count_student
from student
group by left(no,4);
-- 학과번호 별 소속학생이 100명 이상인 학과 번호와 인원수를 조회
select major_no, count(*) as count_student
from student
group by major_no having count(*) >= 100;




