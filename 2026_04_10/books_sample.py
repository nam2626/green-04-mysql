import csv
import random
from datetime import datetime, timedelta

def generate_enhanced_data(num_books=1000):
    # 1. 추가된 카테고리 리스트 (C001~C020, 총 20개)
    categories = [
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
    ]

    # 2. 책 제목 키워드
    prefixes = ['실전', '핵심', '입문', '고급', '클린', '모던', '초보자를 위한', '마스터링']
    subjects = ['파이썬', '자바', 'Go언어', '쿠버네티스', '도커', '텐서플로', '스위프트', '리눅스', '오라클', '마이SQL']
    suffixes = ['가이드', '바이블', '정석', '프로그래밍', '컴플리트 가이드', '워크북', '기초와 응용']

    # 카테고리 CSV 저장
    with open('category_extended.csv', 'w', encoding='utf-8-sig', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['id', 'name', 'description'])
        writer.writerows(categories)

    # 도서 CSV 저장
    with open('books_extended.csv', 'w', encoding='utf-8-sig', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['title', 'author', 'publisher', 'isbn', 'stock', 'reg_date', 'category_id'])

        for _ in range(num_books):
            title = f"{random.choice(prefixes)} {random.choice(subjects)} {random.choice(suffixes)}"
            author = random.choice(['김철수', '이영희', '박민수', '최지우', '정현우', '강민주'])
            publisher = random.choice(['IT미디어', '코딩월드', '데이터하우스', '디지털북스'])
            isbn = "".join([str(random.randint(0, 9)) for _ in range(13)])
            stock = random.randint(5, 50)
            
            days_ago = random.randint(0, 500)
            reg_date = (datetime.now() - timedelta(days=days_ago)).strftime('%Y-%m-%d %H:%M:%S')
            
            # 20개의 카테고리 ID 중 랜덤 선택
            category_id = random.choice(categories)[0]

            writer.writerow([title, author, publisher, isbn, stock, reg_date, category_id])

    print("완료: 'category_extended.csv'와 'books_extended.csv'가 생성되었습니다.")

if __name__ == "__main__":
    generate_enhanced_data(1000)