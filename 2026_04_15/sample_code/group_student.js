const fs = require('fs');
const { fakerKO } = require('@faker-js/faker');

// 설정값
const STUDENT_COUNT = 1000;
const COURSE_COUNT = 200;
const ENROLLMENT_PER_STUDENT = 30; // 1000명 * 30과목 = 30,000건

// 1. 학과 데이터 (10건) - 사실적인 학과명과 건물명
const majors = [
    { no: '101', name: '컴퓨터공학과', building: '공학1관', tel: '0212341011' },
    { no: '102', name: '전자공학과', building: '공학2관', tel: '0212341021' },
    { no: '103', name: '경영학과', building: '경영관', tel: '0212341031' },
    { no: '104', name: '경제학과', building: '상경관', tel: '0212341041' },
    { no: '105', name: '영어영문학과', building: '인문관', tel: '0212341051' },
    { no: '106', name: '심리학과', building: '사회과학관', tel: '0212341061' },
    { no: '107', name: '기계공학과', building: '공학1관', tel: '0212341071' },
    { no: '108', name: '시각디자인학과', building: '예술관', tel: '0212341081' },
    { no: '109', name: '법학과', building: '법학관', tel: '0212341091' },
    { no: '110', name: '행정학과', building: '사회과학관', tel: '0212341101' },
];

// 2. 강좌 데이터 생성 (200건)
const courses = [];
const coursePrefixes = ['일반', '기초', '심화', '응용', '고급', '실무', '글로벌'];
const courseTopics = ['프로그래밍', '네트워크', '데이터베이스', '마케팅', '회계', '기계설계', '유체역학', '전자회로', '소프트웨어', '인공지능', '경영전략', '거시경제', '건축학', '민법', '상법', '심리학', '교육학', '타이포그래피', '생명공학', '화학공학'];
const courseSuffixes = ['이해', '개론', '원론', '실습', '세미나', '연구', '특강', '기초', '활용'];

const generatedCourseNames = new Set();
while (courses.length < COURSE_COUNT) {
    const topic = courseTopics[fakerKO.number.int({ min: 0, max: courseTopics.length - 1 })];
    const suffix = courseSuffixes[fakerKO.number.int({ min: 0, max: courseSuffixes.length - 1 })];
    let name = `${topic} ${suffix}`;
    
    // 간혹 접두사 추가
    if (Math.random() > 0.5) {
        const prefix = coursePrefixes[fakerKO.number.int({ min: 0, max: coursePrefixes.length - 1 })];
        name = `${prefix} ${name}`;
    }

    if (!generatedCourseNames.has(name)) {
        generatedCourseNames.add(name);
        const courseNo = `C${fakerKO.string.numeric(8)}`; // CHAR(9)
        const score = fakerKO.number.int({ min: 1, max: 4 }); // 1~4학점
        courses.push({ no: courseNo, name: name.substring(0, 20), score });
    }
}

// 3. 학생 데이터 생성 (1,000건) - 2023~2026학번
const students = [];
for (let i = 0; i < STUDENT_COUNT; i++) {
    const year = fakerKO.number.int({ min: 2023, max: 2026 });
    const sequence = String(i + 1).padStart(4, '0');
    const studentNo = `${year}${sequence}`; // CHAR(8)
    const name = fakerKO.person.fullName().replace(/ /g, ''); // 띄어쓰기 제거된 한국 이름
    const phone = `010${fakerKO.string.numeric(8)}`; // CHAR(11) ex) 01012345678
    const major = majors[fakerKO.number.int({ min: 0, max: majors.length - 1 })].no;

    students.push({ no: studentNo, name, phone, major_no: major });
}

// 4. 수강(Enrollment) 데이터 생성 (30,000건)
const enrollments = [];
const possibleGrades = [4.5, 4.0, 3.5, 3.0, 2.5, 2.0, 1.5, 1.0, 0.0]; // 한국 대학교 실제 학점 체계

students.forEach(student => {
    // 각 학생마다 중복되지 않는 강좌 30개 무작위 선택
    const shuffledCourses = [...courses].sort(() => 0.5 - Math.random());
    const selectedCourses = shuffledCourses.slice(0, ENROLLMENT_PER_STUDENT);

    selectedCourses.forEach(course => {
        const grade = possibleGrades[fakerKO.number.int({ min: 0, max: possibleGrades.length - 1 })];
        enrollments.push({
            student_no: student.no,
            course_no: course.no,
            grade: grade
        });
    });
});

// 5. SQL 파일로 출력 구문 만들기
console.log('SQL 파일 생성 중...');
const sqlStatements = [];

// 이스케이프 처리 헬퍼 함수
const escape = (str) => typeof str === 'string' ? `'${str.replace(/'/g, "''")}'` : str;

// 테이블에 데이터 삽입하는 함수
const generateInserts = (tableName, dataArray) => {
    // 한 번의 INSERT 문에 넣을 최대 행의 수 (최적화용)
    const BATCH_SIZE = 1000; 
    for (let i = 0; i < dataArray.length; i += BATCH_SIZE) {
        const batch = dataArray.slice(i, i + BATCH_SIZE);
        const values = batch.map(obj => `(${Object.values(obj).map(val => val === null ? 'NULL' : escape(val)).join(', ')})`).join(',\n  ');
        sqlStatements.push(`INSERT INTO ${tableName} (${Object.keys(batch[0]).join(', ')}) VALUES \n  ${values};\n`);
    }
};

// FK 의존성 순서대로 INSERT (major -> student -> course -> enrollment)
generateInserts('major', majors);
generateInserts('student', students);
generateInserts('course', courses);
generateInserts('enrollment', enrollments);

// 파일 쓰기
fs.writeFileSync('sample_data.sql', sqlStatements.join('\n'), 'utf8');
console.log(`✅ 생성 완료!`);
console.log(`- 학생(student): ${students.length}건`);
console.log(`- 학과(major): ${majors.length}건`);
console.log(`- 강좌(course): ${courses.length}건`);
console.log(`- 수강(enrollment): ${enrollments.length}건`);
console.log(`결과 파일: sample_data.sql 확인바랍니다.`);