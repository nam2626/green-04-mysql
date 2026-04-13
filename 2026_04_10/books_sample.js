const fs = require('fs');

/**
 * 랜덤 날짜 생성 함수
 */
function getRandomDate(daysAgo) {
    const date = new Date();
    date.setDate(date.getDate() - Math.floor(Math.random() * daysAgo));
    return date.toISOString().replace('T', ' ').substring(0, 19);
}

const generateEnhancedData = (numBooks = 1000) => {
    // 1. 카테고리 데이터 정의 (C001~C020)
    const categories = [
        ['C001', '컴퓨터공학', '컴퓨터공학 기초 및 이론'],
        ['C002', '데이터과학', '빅데이터 분석 및 통계'],
        ['C003', '알고리즘', '자료구조 및 알고리즘 문제풀이'],
        ['C004', '소프트웨어공학', '설계 방법론 및 아키텍처'],
        ['C005', '프로그래밍언어', '다양한 개발 언어 학습'],
        ['C006', '인공지능', '머신러닝, 딥러닝 및 AI 모델링'],
        ['C007', '클라우드', 'AWS, Azure, GCP 인프라 구축'],
        ['C008', '정보보안', '해킹 방지, 보안 관제 및 암호학'],
        ['C009', '모바일개발', 'iOS, 안드로이드 앱 개발'],
        ['C010', '데이터베이스', 'SQL, NoSQL 및 DB 설계'],
        ['C011', '웹프론트엔드', 'HTML, CSS, React, Vue.js'],
        ['C012', '웹백엔드', 'Node.js, Spring, Django'],
        ['C013', '네트워크', 'TCP/IP 및 서버 네트워크 구축'],
        ['C014', '운영체제', 'Linux, Windows 서버 관리'],
        ['C015', '게임개발', 'Unity, Unreal Engine 게임 제작'],
        ['C016', '블록체인', '가상화폐 및 스마트 컨트랙트'],
        ['C017', '데브옵스', 'CI/CD, Docker 및 Kubernetes'],
        ['C018', '사물인터넷', 'IoT 하드웨어 제어 및 센서'],
        ['C019', '임베디드', '펌웨어 및 마이크로프로세서'],
        ['C020', 'UI/UX 디자인', '사용자 경험 설계 및 프로토타입']
    ];

    // 2. 제목 구성을 위한 키워드
    const prefixes = ['실전', '핵심', '입문', '고급', '클린', '모던', '초보자를 위한', '마스터링'];
    const subjects = ['파이썬', '자바', 'Node.js', '쿠버네티스', '도커', '텐서플로', '스위프트', '리눅스', '오라클', 'MySQL'];
    const suffixes = ['가이드', '바이블', '정석', '프로그래밍', '컴플리트 가이드', '워크북', '기초와 응용'];
    const authors = ['김철수', '이영희', '박민수', '최지우', '정현우', '강민주'];
    const publishers = ['IT미디어', '코딩월드', '데이터하우스', '디지털북스'];

    // 한글 깨짐 방지용 BOM
    const BOM = '\uFEFF';

    // 3. 카테고리 CSV 생성
    let categoryCsv = BOM + 'id,name,description\n';
    categories.forEach(cat => {
        categoryCsv += `${cat[0]},${cat[1]},${cat[2]}\n`;
    });
    fs.writeFileSync('category_extended.csv', categoryCsv);

    // 4. 도서 CSV 생성
    let bookCsv = BOM + 'title,author,publisher,isbn,stock,reg_date,category_id\n';
    for (let i = 0; i < numBooks; i++) {
        const title = `"${prefixes[Math.floor(Math.random() * prefixes.length)]} ${subjects[Math.floor(Math.random() * subjects.length)]} ${suffixes[Math.floor(Math.random() * suffixes.length)]}"`;
        const author = authors[Math.floor(Math.random() * authors.length)];
        const publisher = publishers[Math.floor(Math.random() * publishers.length)];
        
        // ISBN 13자리 생성
        let isbn = '';
        for (let j = 0; j < 13; j++) isbn += Math.floor(Math.random() * 10);
        
        const stock = Math.floor(Math.random() * 46) + 5; // 5~50
        const reg_date = getRandomDate(500);
        const category_id = categories[Math.floor(Math.random() * categories.length)][0];

        bookCsv += `${title},${author},${publisher},${isbn},${stock},${reg_date},${category_id}\n`;
    }
    fs.writeFileSync('books_extended_js.csv', bookCsv);

    console.log("완료: 'category_extended.csv'와 'books_extended.csv'가 생성되었습니다.");
}

// 실행
generateEnhancedData(1000);