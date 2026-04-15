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

select * from A crosscoursecourse join B;

-- JOIN과 GROUP 결합
-- 1. 학과 이름별 학생 수 조회
select m.name, count(*) as student_count
from major m join student s on m.no = s.major_no
group by m.name;
-- 2. 학생 이름별, 전체 수강 과목의 평균 평점 조회, 전체 이수한 학점의 합 조회
select s.name, avg(e.grade) as avg_grade, sum(c.score) as sum_score
from student s join enrollment e on s.no = e.student_no
     join course c on e.course_no = c.no
	group by s.no, s.name;
-- 3. 강좌 이름별, 수강생 숫자, 이수한 평균 평점 조회
select c.name, count(*) as student_count, avg(e.grade) as avg_grade
from course c join enrollment e on c.no = e.course_no
group by c.name;
-- 4. 학과별, 수강 과목별, 수강한 학생 인원수 조회
select m.name, c.name, count(*) as count_student
from major m join student s on m.no = s.major_no
 join enrollment e on e.student_no = s.no
 join course c on e.course_no = c.no
 group by m.name, c.name;
-- 5. 입학년도별, 학과별, 인원수 조회
select left(s.no,4) as s_year, m.name, count(*) as count_student
from student s join major m on s.major_no = m.no
group by left(s.no,4),m.name;

delete from enrollment where course_no in('C13432115','C16342045','C18188658');
alter table enrollment drop constraint FK_student_TO_enrollment1;
delete from student where major_no in('105', '108');
delete from enrollment where student_no in('20230017','20240685','20260333');

-- 외부 조인 (Outer Join)
select * from A left outer join B on A.code = B.code;
select * from A right outer join B on A.code = B.code;
-- 불일치 쿼리
select * from A left outer join B on A.code = B.code where B.code is null;
select * from A where code not in(select code from B);
select * from A right outer join B on A.code = B.code where A.code is null;

-- 학과 테이블에서 학과 인원수가 0인 학과들의 학과번호, 학과명을 조회
select m.no, m.name
from major m left outer join student s on m.no = s.major_no
where s.major_no is null;
select m.no, m.name
from student s right outer join major m on m.no = s.major_no
where s.major_no is null;

-- 한번도 수강신청을 하지않은 학생들을 조회
-- 학번 이름 학과명 연락처
select s.no, s.name, m.name, s.phone
from student s left outer join enrollment e on s.no = e.student_no
join major m on s.major_no = m.no
where e.student_no is null;

select s.no, s.name, m.name, s.phone
from student s join major m on s.major_no = m.no
left outer join enrollment e on s.no = e.student_no
where e.student_no is null;

-- 한번 수강신청이 되지 않은 과정 조회
-- 과정번호, 과정명
select c.no, c.name
from course c left outer join enrollment e on c.no = e.course_no
where e.course_no is null ;

select c.*
from course c left outer join enrollment e on c.no = e.course_no
where e.course_no is null ;

-- -----------------------------------------
-- 실습 문제

-- -----------------------------------------
-- 1. 연료 타입(fuel_type)별 자동차 수, 평균 가격 조회
-- 2. 지점(branch)별 총 판매 건수 조회
-- 3. 제조사 번호별 등록된 자동차 수 조회
-- 4. 판매 날짜별 판매 건수 조회
-- 5. 국가(country)별 제조사 수 조회
-- 6. 자동차 이름과 해당 자동차 제조사의 이름을 함께 조회
-- 7. 판매 내역의 고객 이름과 판매된 자동차의 이름을 조회
-- 8. 2000년 이후에 설립된 제조사의 자동차들 조회
-- 9. 가격이 7000만 원 이상인 차를 산 고객 리스트 조회
-- 10. 각 판매 내역에 대해 '차이름(제조사명)' 형식으로 출력
-- 11. 제조사 이름별 자동차 모델 수 조회
-- 12. 연료 타입별 총 판매 대수를 내림차순 조회
-- 13. 가장 많이 팔린 자동차 모델 이름과 판매 대수 조회
-- 14. 2024년에 가장 많이 판매한 제조사 이름 조회
-- 15. 모든 제조사와 해당 제조사가 생산한 자동차 수를 조회 (자동차가 없는 제조사도 0으로 표시)
-- 16. 한 번도 판매된 적이 없는 자동차의 모델명과 제조사명 조회
-- 17. 자동차를 하나도 등록하지 않은 제조사의 이름과 국가 조회
-- 18. 모든 자동차 리스트를 출력하고, 2025년에 판매된 적이 있는지 여부 표시 (판매된 차는 판매일, 아니면 '판매된적없음'으로 출력)

