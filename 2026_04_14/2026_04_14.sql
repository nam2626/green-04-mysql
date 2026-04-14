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
select SUBSTRING('2026-04-14',1,4)

-- student 테이블에서 학번(no)은 8자리(예: 20261234)로 구성되어 있습니다.
-- 학번의 앞 4자리를 추출하여 '입학년도'라는 별칭으로 조회하세요
select SUBSTRING(no,1,4) as 입학년도 from  student;

-- major 테이블에서 전화번호(tel)의 첫 3자리(지역번호 등)만 추출하여 조회하세요.
select SUBString(tel,1,3) from major;

-- REPLACE : 텍스트 변경
SELECT REPLACE('010-1234-5678', '-', '') AS phone_number; 
SELECT REPLACE('AAaa', 'A', 'B');

-- major 테이블에서 건물명(building)에 '관'이라는 글자가 들어간다면 
-- 이를 '빌딩'으로 바꾸어 조회하세요. (예: 공학관 ➔ 공학빌딩)
select replace(building , '관','빌딩') as building from major;
-- student 테이블에서 학생의 전화번호(phone) 중 
-- '010'으로 시작하는 부분을 '8210'(국가코드 포함)으로 변경하여 조회하세요.
select REPLACE(phone, '010','8201') from  student;

-- UPPER / LOWER : 대소문자 변환
SELECT UPPER('mysql') AS upper_case, LOWER('MySQL') AS lower_case; 

-- CHAR_LENGTH : 글자 개수
select CHAR_LENGTH('ABC'), CHAR_LENGTH('안녕하');

-- TRIM : 좌우 쓸데없는 공백을 제거
select trim('     A     '), CHAR_LENGTH(trim('     A     '));
select LTRIM('     A     '), RTRIM('     A     ');

-- LPAD, RPAD
select lpad('1234',10,'0'), rpad('1234',10,'0');
select lpad('AAAA',10,'123'), RPAD('AAAA',10,'123');

-- major 테이블에 학과번호가 3자리입니다. 이를 총 4자리로 표시하겠습니다.
-- 빈 앞자리는 알파벳 M을 붙이도록 하겠습니다.
-- M003
select lpad(no,4,'M') from major;

-- student 테이블에서 phone 컬럼의 데이터를 앞에 5자리까지만 부분 추출후에
-- 나머지 뒷자리는 '*'로 마스킹 처리 후 출력
-- 01012******
select rpad(substring(phone,1,5),11,'*') from  student;
select concat(substring(phone,1,5),'******') from  student;
-- 이름  연락처
-- 김*수 010****1234
select 
	concat(SUBSTRING(name,1,1),'*', SUBSTRING(name,CHAR_LENGTH(name),1)) 
		as 
	name,
	CONCAT(substring(phone,1,3),'****',substring(phone,8,4)) 
		as 
	phone
from student;

select 
	concat(left(name,1),'*', if(CHAR_LENGTH(name)=2,'',right(name,1)) ) 
		as 
	name,
	CONCAT(left(phone,3),'****',right(phone,4)) as phone
from student;

-- instr : 특정 단어가 몇번째 글자에 있는지 검색하는 함수
select instr('ABCDEF','C'),instr('ABCDEF','X');

-- -----------------------
-- ROUND(숫자, 자리수) : 반올림
select 
	round(12345.12345,-3),
	round(12345.12345,-2),
	round(12345.12345,-1),
	round(12345.12345,0),
	round(12345.12345,1),
	round(12345.12345,2),
	round(12345.12345,3);
-- TRUNCATE(숫자, 자리수) : 반올림	
select 
	truncate(12345.12345,-3),
	truncate(12345.12345,-2),
	truncate(12345.12345,-1),
	truncate(12345.12345,0),
	truncate(12345.12345,1),
	truncate(12345.12345,2),
	truncate(12345.12345,3);

-- CEIL, FLOOR : 올림, 내림 - 소수점만 제거
select ceil(3.4), floor(3.4);
select ceil(-3.4), floor(-3.4);

-- ABS : 절대값
select abs(100), abs(-100);

-- MOD : 나누기 나머지 구함
select mod(5,2), mod(4,2);

-- FORMAT : , 소수 자리수 지정, 반올림
select 
	format(1234567.89,0),
	format(1234567.895,2);
-- $1,500
select 
	concat('$',format(1500,0));

-- ---------------------------
-- NOW : 현재 날짜 시간
-- curdate : 현재 날짜
-- curtime : 현재 시간
select 
	now(),
	CURDATE(),
	curtime(), (CURRENT_DATE);

-- 날짜를 더하거나 빼기
-- DATE_ADD : 특정일 기준으로 날짜 계산하는 함수
--			  몇 일뒤 날짜, 한달 뒤 날짜
select curdate(), date_add(curdate(),interval 30 day) as after_date;
select curdate(), date_add(curdate(),interval 1 week) as after_date;
select curdate(), date_add(curdate(),interval -1 week) as after_date;
select curdate(), date_sub(curdate(),interval 1 week) as after_date;
select curdate(), date_add(curdate(),interval 1 month) as after_date;
select curdate(), date_add(curdate(),interval 1 year) as after_date;
-- 택배일
select curdate(), date_add(curdate(), interval 3 day) as after_date;

-- 날짜 형태
-- YYYY-MM-DD
select date_format(now(),'%Y-%m-%d');
-- 2026년 06월 01일
select date_format(now(),'%Y년 %m월 %d일');
-- 2026-06-01 17:11:24
select date_format(now(),'%Y-%m-%d %H:%i:%s');
-- 2026년 06월 01일 PM 11시 05분
select date_format(now(),'%Y년 %m월 %d일 %p %h시 %i분');
-- 2026년 06월 01일 Monday PM 11시 05분
select date_format(now(),'%Y년 %m월 %d일 %W %p %h시 %i분');
-- 2026-April-14 Tuesday PM 03시 29분
select date_format(now(),'%Y-%M-%d %W %p %h시 %i분');
-- 2026-Apr-14 Tuesday PM 03시 29분
select date_format(now(),'%Y-%b-%d %W %p %h시 %i분');

-- 날짜 계산 : DATEDIFF 특정일1 - 특정일2 -> 일수 반환
select datediff('2026-12-31',curdate());

-- 년, 월, 일 : year, month, day
-- 시, 분, 초 : hour, minute, second
select
	year(now()),month(now()),day(now()), 
	hour(now()), minute(now()), second(now());

-- ------------------------------






