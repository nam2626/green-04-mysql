const fs = require('fs');
const { fakerKO } = require('@faker-js/faker');

// 1. 제조사 데이터
const manufacturers = [
    { no: 'M01', name: '현대자동차', country: '대한민국', foundation_year: 1967 },
    { no: 'M02', name: '기아', country: '대한민국', foundation_year: 1944 },
    { no: 'M03', name: '테슬라', country: '미국', foundation_year: 2003 },
    { no: 'M04', name: '토요타', country: '일본', foundation_year: 1937 },
    { no: 'M05', name: '메르세데스-벤츠', country: '독일', foundation_year: 1926 },
    { no: 'M06', name: 'BMW', country: '독일', foundation_year: 1916 },
    { no: 'M07', name: '볼보', country: '스웨덴', foundation_year: 1927 },
];

// 2. 자동차 모델 데이터
const carModels = [
    { mfr: 'M01', models: [['그랜저', 4500, '가솔린'], ['아반떼', 2500, '가솔린'], ['아이오닉5', 5500, '전기']] },
    { mfr: 'M02', models: [['쏘렌토', 4000, '하이브리드'], ['K5', 3000, '가솔린'], ['EV6', 5800, '전기']] },
    { mfr: 'M03', models: [['Model 3', 6000, '전기'], ['Model Y', 7500, '전기']] },
    { mfr: 'M04', models: [['캠리', 3800, '하이브리드'], ['프리우스', 4200, '하이브리드']] },
    { mfr: 'M05', models: [['E-Class', 8500, '가솔린'], ['S-Class', 15000, '가솔린']] },
    { mfr: 'M06', models: [['5 Series', 7800, '디젤'], ['3 Series', 5500, '가솔린']] },
    { mfr: 'M07', models: [['XC90', 9500, '하이브리드'], ['S60', 5000, '가솔린']] },
];

const cars = [];
carModels.forEach((mfrGroup) => {
    mfrGroup.models.forEach(([name, price, fuel]) => {
        cars.push({
            no: `CAR-${fakerKO.string.numeric(6)}`,
            name: name,
            manufacturer_no: mfrGroup.mfr,
            price: price,
            fuel_type: fuel
        });
    });
});

// 3. 판매내역 데이터 생성 (4,000건, 2024~2025년)
const sales = [];
const branches = ['강남지점', '서초지점', '잠실지점', '판교지점', '해운대지점', '대전지점', '광주지점', '대구지점'];

for (let i = 0; i < 4000; i++) {
    const randomCar = cars[Math.floor(Math.random() * cars.length)];
    // 날짜를 2024-01-01부터 2025-12-31까지 생성
    const salesDate = fakerKO.date.between({ 
        from: '2024-01-01T00:00:00.000z', 
        to: '2025-12-31T23:59:59.000z' 
    }).toISOString().split('T')[0];

    sales.push({
        car_no: randomCar.no,
        sales_date: salesDate,
        customer_name: fakerKO.person.fullName().replace(/ /g, ''),
        branch: branches[Math.floor(Math.random() * branches.length)]
    });
}

// 4. SQL 구문 조립
let sqlContent = `-- 자동차 산업 샘플 데이터 (판매내역 4,000건)\n\n`;
const escape = (val) => typeof val === 'string' ? `'${val.replace(/'/g, "''")}'` : val;

// 제조사
sqlContent += `INSERT INTO manufacturer (no, name, country, foundation_year) VALUES \n` +
    manufacturers.map(m => `(${escape(m.no)}, ${escape(m.name)}, ${escape(m.country)}, ${m.foundation_year})`).join(',\n') + ';\n\n';

// 자동차
sqlContent += `INSERT INTO car (no, name, manufacturer_no, price, fuel_type) VALUES \n` +
    cars.map(c => `(${escape(c.no)}, ${escape(c.name)}, ${escape(c.manufacturer_no)}, ${c.price}, ${escape(c.fuel_type)})`).join(',\n') + ';\n\n';

// 판매내역 (성능을 위해 500건씩 끊어서 INSERT)
for (let i = 0; i < sales.length; i += 500) {
    const batch = sales.slice(i, i + 500);
    sqlContent += `INSERT INTO sales (car_no, sales_date, customer_name, branch) VALUES \n` +
        batch.map(s => `(${escape(s.car_no)}, ${escape(s.sales_date)}, ${escape(s.customer_name)}, ${escape(s.branch)})`).join(',\n') + ';\n\n';
}

fs.writeFileSync('car_sales_data_4000.sql', sqlContent, 'utf8');
console.log('✅ car_sales_data_4000.sql 파일 생성 완료!');