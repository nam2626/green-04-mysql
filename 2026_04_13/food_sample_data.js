const fs = require('fs');

// 1. 설정 및 데이터 풀
const CATEGORIES = ['튀김', '요리', '사이드', '주류', '음료'];
const COUNTS = {
  table: 20,
  order: 500,
  orderDetail: 5000
};

const MENU_DATA = {
  '튀김': ['치킨 가라아게', '감자튀김', '새우튀김', '모듬튀김', '오징어링'],
  '요리': ['찹스테이크', '해물짬뽕탕', '감바스', '제육볶음', '골뱅이소면', '나베', '떡볶이', '닭발', '훈제오리', '카프레제'],
  '사이드': ['공기밥', '계란찜', '누룽지', '황도', '라면', '치즈스틱', '파인애플샤베트'],
  '주류': ['소주', '맥주', '생맥주 500cc', '하이볼', '청하', '막걸리', '화요', '일품진로', '레드와인', '잭다니엘'],
  '음료': ['콜라', '사이다', '제로콜라', '웰치스', '오렌지주스', '에이드', '토닉워터', '우롱차', '녹차', '탄산수']
};

const getRandomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
const getRandomBool = () => Math.random() > 0.1; // 90% 확률로 true
const getRandomItem = (arr) => arr[Math.floor(Math.random() * arr.length)];

// 2. Category 생성 (id: 1~5)
let categoryContent = "id,name\n";
CATEGORIES.forEach((name, i) => {
  categoryContent += `${i + 1},${name}\n`;
});
fs.writeFileSync('category.csv', categoryContent);

// 3. Food_Order_Table 생성 (1~20번 테이블)
let tableContent = "no,status\n";
for (let i = 1; i <= COUNTS.table; i++) {
  tableContent += `${i},${getRandomBool()}\n`;
}
fs.writeFileSync('food_order_table.csv', tableContent);

// 4. Menu 생성
let menuContent = "id,name,price,status,recommand,category_id\n";
const menus = [];
let menuIdCounter = 1;

Object.entries(MENU_DATA).forEach(([catName, menuList], idx) => {
  const categoryId = idx + 1;
  menuList.forEach(name => {
    const price = (idx === 0 || idx === 1) ? getRandomInt(15, 30) * 1000 : getRandomInt(3, 10) * 1000;
    const menu = { id: menuIdCounter++, name, price, categoryId };
    menus.push(menu);
    menuContent += `${menu.id},${menu.name},${menu.price},true,${Math.random() > 0.8},${menu.categoryId}\n`;
  });
});
fs.writeFileSync('menu.csv', menuContent);

// 5. Food_Order 생성 (500건)
let orderContent = "no,time,status,table_no\n";
const orders = [];
const startDate = new Date('2026-04-01T17:00:00');

for (let i = 1; i <= COUNTS.order; i++) {
  const orderTime = new Date(startDate.getTime() + (i * getRandomInt(10, 30) * 60000));
  const timeStr = orderTime.toISOString().slice(0, 19).replace('T', ' ');
  const tableNo = getRandomInt(1, 20);
  const status = getRandomInt(0, 2); // 0:주문, 1:준비중, 2:완료
  orders.push(i);
  orderContent += `${i},${timeStr},${status},${tableNo}\n`;
}
fs.writeFileSync('food_order.csv', orderContent);

// 6. Food_Order_Detail 생성 (5000건)
// 기본키가 없으므로 중복 조합 허용 (단, 실무에선 (order_no, menu_id) 유니크를 걸기도 함)
let detailContent = "order_no,menu_id,quantity\n";
for (let i = 0; i < COUNTS.orderDetail; i++) {
  const orderNo = getRandomItem(orders);
  const menu = getRandomItem(menus);
  const quantity = getRandomInt(1, 5); // 수량은 최소 1개 이상 (CHK 제약조건 준수)
  detailContent += `${orderNo},${menu.id},${quantity}\n`;
}
fs.writeFileSync('food_order_detail.csv', detailContent);

console.log("음식 주문 시스템 샘플 CSV 생성 완료!");
console.log("- category.csv (5건)");
console.log("- food_order_table.csv (20건)");
console.log("- menu.csv (42건)");
console.log("- food_order.csv (500건)");
console.log("- food_order_detail.csv (5000건)");