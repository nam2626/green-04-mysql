-- Active: 1775701110283@@127.0.0.1@3306@new_student_db
`
📝 MySQL 함수 종합 문제
문제 1. (문자열) student 테이블에서 학번(no)의 앞 4자리(입학년도)와 이름(name)을 하이픈(-)으로 연결하여 '입학년도-이름' 형식(예: 2026-홍길동)으로 조회하세요. (별칭: student_title)

문제 2. (문자열 + 제어 흐름) student 테이블에서 학생의 연락처(phone)가 있다면 뒤의 4자리를 '**'로 마스킹 처리하고(예: 0101234**), 연락처가 비어있다면(NULL) '번호없음'으로 출력하세요. (별칭: masked_phone) 
(힌트: SUBSTRING, CONCAT, IFNULL 또는 IF 활용)

문제 3. (숫자) course 테이블에서 각 과목의 학점(score)을 1.5배 한 후, 소수점 첫째 자리에서 무조건 올림 처리하여 정수로 조회하세요. (별칭: adjusted_score)

문제 4. (날짜 + 문자열) student 테이블에서 학번(no)의 앞 4자리(입학년도)를 추출한 뒤, 현재 연도에서 그 값을 빼서 '입학 후 경과 년수'를 계산하여 조회하세요. (별칭: years_passed)
(힌트: YEAR, CURDATE 활용)

문제 5. (제어 흐름) Enrollment 테이블에서 부여된 성적(grade)에 따라 상태를 표시하세요. 

'A' 또는 'B'로 시작하면 ➔ '패스'
'C' 또는 'D'로 시작하면 ➔ '재수강 권장'
'F'면 ➔ '낙제'
아직 입력되지 않은 경우(NULL) ➔ '평가대기' (별칭: grade_status)
문제 6. (문자열) course 테이블에서 과목명(name) 양 끝에 있을지도 모르는 불필요한 공백을 먼저 완벽히 제거한 후, 그 글자 수가 7글자 이상인 과목의 모든 컬럼을 조회하세요.

문제 7. (제어 흐름 + 문자열) major 테이블에서 전화번호(tel)의 앞 2자리가 '02'로 시작하면 '서울 본캠퍼스', 그 외의 번호이거나 비어있다면 '지방/기타 캠퍼스'로 분류하여 학과명(name)과 함께 조회하세요. (별칭: campus_type)

문제 8. (숫자 + 제어 흐름) student 테이블에서 학번(no)을 숫자로 다루어 2로 나눈 나머지를 구하고, 나머지가 0이면 '청백팀', 1이면 '홍백팀'으로 체육대회 팀을 배정하여 학생 이름(name)과 함께 조회하세요. (별칭: team_name)

문제 9. (문자열) major 테이블에서 전공 번호(no)를 총 5자리 문자열로 출력하되, 빈 앞자리는 별표('*')로 채워 출력하세요. (예: 101 ➔ **101) (별칭: masked_major_no)

문제 10. (날짜 포맷팅) 성적 증명서 발급 시간을 시뮬레이션합니다. 현재 시간(NOW())을 기준으로 증명서 발급 일시를 구하되, 보기 좋게 'YYYY/MM/DD PM/AM HH시 MI분' (예: 2026/04/14 PM 05시 45분) 포맷으로 변환하여 단일 값으로 조회하세요. (별칭: print_datetime)
`


-- 문제 1. (문자열) student 테이블에서 학번(no)의 앞 4자리(입학년도)와 이름(name)을 하이픈(-)으로 연결하여 '입학년도-이름' 형식(예: 2026-홍길동)으로 조회하세요. (별칭: student_title)
SELECT 
    CONCAT(SUBSTRING(no, 1, 4), '-', name) AS student_title 
FROM student;
-- 문제 2. (문자열 + 제어 흐름) student 테이블에서 학생의 연락처(phone)가 있다면 뒤의 4자리를 '**'로 마스킹 처리하고(예: 0101234**), 연락처가 비어있다면(NULL) '번호없음'으로 출력하세요. (별칭: masked_phone) 
-- (힌트: SUBSTRING, CONCAT, IFNULL 또는 IF 활용)
SELECT 
    name,
    IF(phone IS NULL, '번호없음', CONCAT(SUBSTRING(phone, 1, 7), '****')) AS masked_phone
FROM student;
-- 문제 3. (숫자) course 테이블에서 각 과목의 학점(score)을 1.5배 한 후, 소수점 첫째 자리에서 무조건 올림 처리하여 정수로 조회하세요. (별칭: adjusted_score)
SELECT 
    name, 
    score, 
    CEIL(score * 1.5) AS adjusted_score 
FROM course;

-- 문제 4. (날짜 + 문자열) student 테이블에서 학번(no)의 앞 4자리(입학년도)를 추출한 뒤, 현재 연도에서 그 값을 빼서 '입학 후 경과 년수'를 계산하여 조회하세요. (별칭: years_passed)
-- (힌트: YEAR, CURDATE 활용)
SELECT 
    name, 
    no,
    (YEAR(CURDATE()) - (2000 + SUBSTRING(no, 1, 2))) AS years_passed 
FROM student;
-- 문제 5. (제어 흐름) Enrollment 테이블에서 부여된 성적(grade)에 따라 상태를 표시하세요. 

-- 'A' 또는 'B'로 시작하면 ➔ '패스'
-- 'C' 또는 'D'로 시작하면 ➔ '재수강 권장'
-- 'F'면 ➔ '낙제'
-- 아직 입력되지 않은 경우(NULL) ➔ '평가대기' (별칭: grade_status)
select student_no, course_no, grade,
    if(grade IS NULL, '평가대기',
        if(grade LIKE 'A%' OR grade LIKE 'B%', '패스',
            if(grade LIKE 'C%' OR grade LIKE 'D%', '재수강 권장',
                if(grade = 'F', '낙제', '평가대기')
            )
        )
    ) AS grade_status
from Enrollment;


-- 문제 6. (문자열) course 테이블에서 과목명(name) 양 끝에 있을지도 모르는 불필요한 공백을 먼저 완벽히 제거한 후, 그 글자 수가 7글자 이상인 과목의 모든 컬럼을 조회하세요.
SELECT * FROM course 
WHERE CHAR_LENGTH(TRIM(name)) >= 7;
-- 문제 7. (제어 흐름 + 문자열) major 테이블에서 전화번호(tel)의 앞 2자리가 '02'로 시작하면 '서울 본캠퍼스', 그 외의 번호이거나 비어있다면 '지방/기타 캠퍼스'로 분류하여 학과명(name)과 함께 조회하세요. (별칭: campus_type)
SELECT 
    name AS major_name,
    IF(SUBSTRING(tel, 1, 2) = '02', '서울 본캠퍼스', '지방/기타 캠퍼스') AS campus_type
FROM major;
-- 문제 8. (숫자 + 제어 흐름) student 테이블에서 학번(no)을 숫자로 다루어 2로 나눈 나머지를 구하고, 나머지가 0이면 '청백팀', 1이면 '홍백팀'으로 체육대회 팀을 배정하여 학생 이름(name)과 함께 조회하세요. (별칭: team_name)
SELECT 
    name, 
    no,
    IF(MOD(no, 2) = 0, '청백팀', '홍백팀') AS team_name
FROM student;
-- 문제 9. (문자열) major 테이블에서 전공 번호(no)를 총 5자리 문자열로 출력하되, 빈 앞자리는 별표('*')로 채워 출력하세요. (예: 101 ➔ **101) (별칭: masked_major_no)
SELECT 
    name AS major_name,
    LPAD(no, 5, '*') AS masked_major_no
FROM major;

-- 문제 10. (날짜 포맷팅) 성적 증명서 발급 시간을 시뮬레이션합니다. 현재 시간(NOW())을 기준으로 증명서 발급 일시를 구하되, 보기 좋게 'YYYY/MM/DD PM/AM HH시 MI분' (예: 2026/04/14 PM 05시 45분) 포맷으로 변환하여 단일 값으로 조회하세요. (별칭: print_datetime)
SELECT 
    DATE_FORMAT(NOW(), '%Y/%m/%d %p %h시 %i분') AS print_datetime;