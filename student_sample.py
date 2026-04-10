import csv
import random

def generate_student_data(num_records=1000):
    # 학과 리스트 (5개)
    majors = ['컴퓨터공학과', '경영학과', '심리학과', '전자공학과', '시각디자인학과']
    
    # 성씨와 이름 구성 요소 (실제 한국 성명 조합)
    last_names = ['김', '이', '박', '최', '정', '강', '조', '윤', '장', '임', '한', '오', '서', '신', '권']
    first_names = ['민준', '서연', '도윤', '서윤', '하준', '지우', '주원', '하은', '지호', '윤아', 
                   '준우', '민지', '현우', '지아', '건우', '채원', '우진', '지윤', '선우', '서현']

    # 도메인 리스트
    domains = ['naver.com', 'gmail.com', 'daum.net', 'outlook.com']

    with open('students_sample.csv', 'w', encoding='utf-8-sig', newline='') as f:
        writer = csv.writer(f)
        
        # CSV 헤더 작성 (Table 구조와 매칭)
        # no, name, major, in_year, email
        writer.writerow(['no', 'name', 'major', 'in_year', 'email'])

        generated_ids = set()

        for i in range(num_records):
            # 학번 생성 (중복 방지, 8자리 문자열)
            # 예: 20230001, 20240002...
            while True:
                in_year = random.randint(2023, 2026)
                student_id = f"{in_year}{random.randint(1000, 9999)}"
                if student_id not in generated_ids:
                    generated_ids.add(student_id)
                    break
            
            # 이름 조합
            name = random.choice(last_names) + random.choice(first_names)
            
            # 학과 선택
            major = random.choice(majors)
            
            # 이메일 생성 (학번 기반으로 고유성 확보)
            email = f"user{student_id}@{random.choice(domains)}"
            
            # 행 데이터 작성
            writer.writerow([student_id, name, major, in_year, email])

    print(f"성공적으로 {num_records}건의 데이터를 'students_sample.csv'로 저장했습니다.")

if __name__ == "__main__":
    generate_student_data(1000)