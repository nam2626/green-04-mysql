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

-- 기본 조인
-- 1. 학생 이름, 학과명을 함께 조회
select s.name, m.name
from student s join major m on s.major_no = m.no;

-- 2. 수강 테이블에서 학번, 이름, 취득 평점을 조회
select s.no, s.name, e.grade
from student s join enrollment e on s.no = e.student_no;

select s.no, s.name, avg(e.grade) as avg_grade
from student s join enrollment e on s.no = e.student_no
group by s.no, s.name;

-- 3. 수강 테이블, 강좌 테이블에서 강좌 번호, 강좌 명, 취득한 평점 조회
select c.no, c.name, e.grade
from course c join enrollment e on c.no = e.course_no;

select c.no, c.name, avg(e.grade)
from course c join enrollment e on c.no = e.course_no
group by c.no, c.name;

-- 4. 학과 테이블에서 학과 이름과 건물 이름, 해당 학과 소속의 학생이름을 
--    학과 이름 기준으로 정렬해서 조회
select m.name, m.building, s.name
from major m join student s on m.no = s.major_no
order by m.name, s.name desc;

-- 5. 학생이름, 수강한 강좌명, 취득한 평점
select s.name, c.name, e.grade
from student s 
	join enrollment e on s.no = e.student_no
    join course c on e.course_no = c.no;

-- 5. 학생이름, 학과명, 수강한 강좌명, 취득한 평점
select s.name, m.name, c.name, e.grade
from student s 
	join enrollment e on s.no = e.student_no
    join course c on e.course_no = c.no
    join major m on s.major_no = m.no;
    
select *
from student s 
	join enrollment e on s.no = e.student_no
    join course c on e.course_no = c.no
    join major m on s.major_no = m.no;

-- 조인과 조건 결함
-- 1. '컴퓨터공학과'에 소속된 학생들의 이름과 전화번호 조회하기
select s.name, s.phone, m.name
from student s join major m on s.major_no = m.no
where m.name like '컴퓨터공학과';

-- 2. 평점 4.0 이상을 받은 학생의 이름과 강좌 번호 조회하기
select s.name, e.course_no, e.grade
from student s join enrollment e on s.no = e.student_no
where e.grade >= 4.0;

select s.name, count(*) as grade_count
from student s join enrollment e on s.no = e.student_no
where e.grade >= 4.0
group by s.name;

-- 3. 특정 학생(예: 학번 '20230001')이 수강하는 강좌 이름과 학점(시수) 조회하기
select c.name, c.score
from enrollment e join course c on e.course_no = c.no
where e.student_no like '20230001';

-- 4. 3학점(score=3)짜리 과목을 수강하는 학생 이름과 과목 이름 조회하기
select s.name, c.name
from student s join enrollment e on s.no = e.student_no
     join course c on e.course_no = c.no
where c.score = 3;

-- 5. '공학1관'에서 수업을 듣는(해당 건물의 학과 소속인) 학생들의 이름과 전공 조회하기
select s.name as sname, m.name as mname
from major m join student s on s.major_no = m.no
where m.building = '공학1관';

-- 자연 조인
create table A(
	code char(1),
    n int);

create table B(
	code char(1),
    cdate date default (CURRENT_DATE)
);

insert into A values('A',1),('B',2),('C',3),('D',4);
insert into B(code) values('A'),('B'),('D'),('F');
select * from A natural join B;

select * from A cross join B;





