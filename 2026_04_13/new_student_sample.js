const fs = require('fs');

// 설정값
const COUNTS = { major: 10, student: 200, course: 30, enrollment: 1000 };
const years = ['2024', '2025', '2026'];

// 데이터 풀 (사실적인 명칭들)
const majorNames = ['컴퓨터공학과', '전자공학과', '경영학과', '심리학과', '기계공학과', '미디어커뮤니케이션학과', '생명공학과', '경제학과', '디자인학과', '국어국문학과'];
const buildingNames = ['공학관', '인문관', '사회과학관', '경영관', '정보과학관', '예술관', '학생회관', '본관', '미래관', '중앙도서관'];
const courseNames = [
  '데이터베이스 기초', '알고리즘 분석', '서양미술의 이해', '미시경제학', '심리학 개론', 
  '운영체제론', '마케팅 원론', '기구학', '자바 프로그래밍', '디지털 논리회로',
  '매체 비평', '생화학', '거시경제학', '동양 철학의 이해', '데이터 구조', 
  '인공지능 개론', '회계원리', '글로벌 리더십', '창의적 사고', '네트워크 보안'
];
const lastNames = ['김', '이', '박', '최', '정', '강', '조', '윤', '장', '임', '한', '오', '서', '신', '권'];
const firstNames = ['민준', '서연', '도윤', '하은', '주원', '지우', '지호', '채원', '준우', '윤아', '민지', '현우', '예준', '수아', '성현'];

// 헬퍼 함수
const getRandomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
const pad = (num, size) => String(num).padStart(size, '0');
const getRandomArrayItem = (arr) => arr[Math.floor(Math.random() * arr.length)];

// 1. 학과 데이터 (major.csv)
const majors = [];
let majorContent = "no,name,building,tel\n";
majorNames.forEach((name, i) => {
  const no = pad(i + 1, 3);
  const building = getRandomArrayItem(buildingNames);
  const tel = `02${getRandomInt(2000, 8000)}${pad(i + 1, 4)}`;
  majors.push(no);
  majorContent += `${no},${name},${building},${tel}\n`;
});
fs.writeFileSync('major.csv', majorContent);

// 2. 학생 데이터 (student.csv)
const students = [];
let studentContent = "no,name,phone,major_no\n";
for (let i = 1; i <= COUNTS.student; i++) {
  const year = getRandomArrayItem(years);
  const no = `${year.slice(2)}${pad(getRandomInt(10, 99), 2)}${pad(i, 4)}`; // 실제 학번 느낌 (연도+학과번호+일련번호)
  const name = getRandomArrayItem(lastNames) + getRandomArrayItem(firstNames);
  const phone = `010${getRandomInt(2000, 9999)}${pad(i, 4)}`;
  const major_no = getRandomArrayItem(majors);
  students.push(no);
  studentContent += `${no},${name},${phone},${major_no}\n`;
}
fs.writeFileSync('student.csv', studentContent);

// 3. 강좌 데이터 (course.csv)
const courses = [];
let courseContent = "no,name,score\n";
for (let i = 1; i <= COUNTS.course; i++) {
  const year = getRandomArrayItem(years);
  const semester = getRandomInt(1, 2);
  const no = `${year}${semester}${pad(i, 4)}`; 
  const name = courseNames[i % courseNames.length] + (i > courseNames.length ? ` II` : '');
  const score = getRandomInt(1, 3);
  courses.push(no);
  courseContent += `${no},${name},${score}\n`;
}
fs.writeFileSync('course.csv', courseContent);

// 4. 수강 데이터 (enrollment.csv)
const enrollmentsSet = new Set();
const gradeLetters = ['A+', 'A0', 'B+', 'B0', 'C+', 'C0', 'D+', 'F'];
let enrollmentContent = "student_no,course_no,grade\n";

while (enrollmentsSet.size < COUNTS.enrollment) {
  const s_no = getRandomArrayItem(students);
  const c_no = getRandomArrayItem(courses);
  const key = `${s_no},${c_no}`;

  if (!enrollmentsSet.has(key)) {
    enrollmentsSet.add(key);
    const grade = getRandomArrayItem(gradeLetters);
    enrollmentContent += `${key},${grade}\n`;
  }
}
fs.writeFileSync('enrollment.csv', enrollmentContent);

console.log("현실적인 샘플 데이터 생성이 완료되었습니다!");