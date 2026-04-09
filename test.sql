-- MySQL
SELECT VERSION();
-- 현재 접속 계정을 확인
select user();
-- 문자셋 확인 쿼리
show variables like 'character%';
show variables like 'collation%';