/**
 * board_db 샘플 데이터 생성 스크립트
 * 실행: node seed.js
 * 의존성: npm install mysql2 bcrypt faker
 */

const mysql = require("mysql2/promise");
const bcrypt = require("bcrypt");
const { faker } = require("@faker-js/faker/locale/ko");

// ──────────────────────────────────────────
// DB 연결 설정 (환경에 맞게 수정)
// ──────────────────────────────────────────
const DB_CONFIG = {
  host: "127.0.0.1",
  port: 3306,
  user: "root",       // ← 본인 계정으로 변경
  password: "12345678",       // ← 비밀번호 입력
  database: "board_db",
  multipleStatements: true,
};

// ──────────────────────────────────────────
// 수량 설정
// ──────────────────────────────────────────
const COUNT = {
  MEMBERS: 200,
  BOARDS: 10_000,
  COMMENTS: 30_000,
  BOARD_REACTIONS: 50_000,   // 좋아요 + 싫어요 합산
  COMMENT_REACTIONS: 100_000,
};

// ──────────────────────────────────────────
// 유틸
// ──────────────────────────────────────────
const rand = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
const pick = (arr) => arr[rand(0, arr.length - 1)];
const shuffle = (arr) => arr.sort(() => Math.random() - 0.5);

function chunk(arr, size) {
  const result = [];
  for (let i = 0; i < arr.length; i += size) result.push(arr.slice(i, i + size));
  return result;
}

// 중복 없는 (memberNo, targetId) 쌍 생성
function generateUniquePairs(memberNos, targetIds, totalCount) {
  const set = new Set();
  const pairs = [];
  const maxPossible = memberNos.length * targetIds.length;
  const limit = Math.min(totalCount, maxPossible);

  // 먼저 랜덤하게 시도
  let attempts = 0;
  while (pairs.length < limit && attempts < limit * 10) {
    attempts++;
    const no = pick(memberNos);
    const tid = pick(targetIds);
    const key = `${no}_${tid}`;
    if (!set.has(key)) {
      set.add(key);
      pairs.push([no, tid]);
    }
  }

  // 부족하면 순차 보충
  if (pairs.length < limit) {
    outer: for (const no of shuffle([...memberNos])) {
      for (const tid of shuffle([...targetIds])) {
        const key = `${no}_${tid}`;
        if (!set.has(key)) {
          set.add(key);
          pairs.push([no, tid]);
          if (pairs.length >= limit) break outer;
        }
      }
    }
  }

  return pairs;
}

// 좋아요 / 싫어요 분배 (총 N건을 두 테이블로 분배)
function splitReactions(pairs) {
  const mid = Math.floor(pairs.length / 2);
  return {
    likes: pairs.slice(0, mid),
    hates: pairs.slice(mid),
  };
}

// ──────────────────────────────────────────
// 게시글 제목 / 본문 생성 (한국어 사실적)
// ──────────────────────────────────────────
const BOARD_CATEGORIES = [
  {
    titles: [
      "오늘 점심 뭐 먹었나요? 추천해드려요",
      "서울 숨겨진 맛집 공유합니다",
      "이 식당 가봤나요? 솔직 후기",
      "혼밥하기 좋은 식당 모음",
      "요즘 핫한 카페 다녀왔어요",
    ],
    contents: [
      "오늘 점심으로 된장찌개 백반을 먹었는데 정말 맛있었어요. 가격도 8천원이라 합리적이었고 반찬도 푸짐했어요.",
      "강남역 근처에 숨겨진 맛집을 발견했어요. 직접 담근 간장으로 만든 간장게장이 일품이에요. 줄 서서 먹을 만한 집이에요.",
      "요즘 유행하는 무한리필 고깃집에 다녀왔어요. 고기 질이 생각보다 좋았고 직원분들도 친절하셨어요.",
    ],
  },
  {
    titles: [
      "요즘 이 드라마 보시는 분 계신가요?",
      "넷플릭스 추천작 공유해요",
      "영화 리뷰 - 기대 이상이었어요",
      "이번 주말 볼만한 영화 추천",
      "덕질하면서 힘든 점 ㅋㅋ",
    ],
    contents: [
      "요즘 방영 중인 드라마 정주행하고 있는데 스토리가 너무 탄탄해서 잠을 못 자고 있어요. 특히 주인공 연기가 인상적이에요.",
      "주말에 개봉한 영화 보고 왔는데 생각보다 훨씬 재밌었어요. CG가 웅장하고 OST도 감동적이더라고요.",
      "넷플릭스에서 한국 오리지널 시리즈 봤는데 세계적인 완성도네요. 외국 친구한테도 추천했더니 엄청 좋아하더라고요.",
    ],
  },
  {
    titles: [
      "취업 준비하면서 느끼는 것들",
      "직장인 공감 모여라",
      "이직 고민입니다 조언 부탁드려요",
      "스타트업 vs 대기업 어느 쪽이 나을까요",
      "퇴근 후 부업 추천해주세요",
    ],
    contents: [
      "취업 준비한 지 벌써 6개월이 됐어요. 자소서만 100개 넘게 쓴 것 같은데 아직도 갈 곳을 못 찾고 있어요. 같이 준비하는 분들 응원합니다.",
      "직장 생활 5년 차인데 번아웃이 너무 심하게 왔어요. 퇴사하고 쉬고 싶은 마음이 굴뚝같은데 현실적인 문제가 발목을 잡네요.",
      "이직을 준비 중인데 현 직장과 오퍼 받은 회사 중 어디가 나을지 모르겠어요. 연봉은 오퍼 받은 곳이 높지만 워라밸은 현재가 더 나은 것 같고요.",
    ],
  },
  {
    titles: [
      "헬스 3개월 차 후기예요",
      "다이어트 식단 공유합니다",
      "런닝 처음 시작하는 분들께",
      "홈트레이닝 루틴 추천해드려요",
      "살 10kg 감량 후기",
    ],
    contents: [
      "헬스장 등록하고 3개월이 지났는데 가시적인 변화가 생기기 시작했어요. 처음엔 너무 힘들었는데 이제는 안 가면 뭔가 빠진 느낌이 들더라고요.",
      "다이어트 시작한 지 두 달 만에 8kg 감량에 성공했어요. 제가 지킨 핵심은 저녁 8시 이후 금식과 하루 7천 보 걷기였어요.",
      "런닝을 시작하고 싶으신 분들은 처음부터 너무 무리하지 마세요. 저는 처음 한 달은 30분 걷기와 5분 달리기를 번갈아 했어요.",
    ],
  },
  {
    titles: [
      "파이썬 독학 중인데 막히는 부분 있어요",
      "개발자 커리어 어떻게 시작하셨나요",
      "비전공자 개발 공부 방법 공유",
      "사이드 프로젝트 같이 할 분 구합니다",
      "코딩테스트 준비 어떻게 하셨어요",
    ],
    contents: [
      "파이썬을 독학한 지 3개월 됐는데 알고리즘 문제를 풀 때 항상 막혀요. 특히 재귀 함수 개념이 아직도 헷갈리는데 좋은 강의 추천해주실 분 계신가요?",
      "비전공자로 웹 개발 취업에 성공했어요. 저는 HTML/CSS부터 시작해서 JavaScript, React 순으로 공부했고 포트폴리오를 꾸준히 만든 게 도움이 많이 됐어요.",
      "코딩테스트 준비를 위해 백준과 프로그래머스를 병행하고 있어요. 하루에 최소 한 문제씩 풀고 있는데 꾸준함이 제일 중요한 것 같아요.",
    ],
  },
  {
    titles: [
      "여행 다녀왔어요 후기 공유",
      "제주도 3박 4일 코스 추천",
      "해외여행 처음인데 어디가 좋을까요",
      "여행 경비 절약하는 꿀팁",
      "혼자 여행 가봤나요?",
    ],
    contents: [
      "지난 주말에 부산 다녀왔어요. 광안리에서 야경 보고 해운대 해장국으로 아침을 해결했는데 정말 힐링이 됐어요. 부산은 갈 때마다 새로운 매력이 있는 것 같아요.",
      "제주도 혼자 여행을 다녀왔는데 렌트카 빌려서 동서남북 다 돌았어요. 성산일출봉 일출은 꼭 보시길 추천드려요. 새벽 4시에 올라야 하지만 그만한 가치가 있어요.",
      "베트남 다낭 5일 다녀왔어요. 물가가 저렴하고 음식도 맛있고 날씨도 좋아서 정말 만족스러웠어요. 특히 미케 비치는 한국 해수욕장과는 비교가 안 될 정도로 맑았어요.",
    ],
  },
];

function genBoardTitle() {
  const cat = pick(BOARD_CATEGORIES);
  const base = pick(cat.titles);
  const suffix = rand(0, 3) === 0 ? ` (${faker.date.recent({ days: 30 }).getMonth() + 1}월 업데이트)` : "";
  return base + suffix;
}

function genBoardContent() {
  const cat = pick(BOARD_CATEGORIES);
  const paragraphs = rand(1, 3);
  let content = pick(cat.contents);
  for (let i = 1; i < paragraphs; i++) {
    const cat2 = pick(BOARD_CATEGORIES);
    content += "\n\n" + pick(cat2.contents);
  }
  return content;
}

const COMMENT_TEMPLATES = [
  "저도 비슷한 경험이 있어요. 공감합니다!",
  "좋은 정보 감사해요. 꼭 한번 해봐야겠네요.",
  "정말 도움이 됐어요. 감사합니다.",
  "오 저도 궁금했던 건데 이렇게 올려주시니 너무 좋아요!",
  "혹시 더 자세한 정보도 있으신가요?",
  "저는 다른 방법을 써봤는데 이게 더 좋아 보이네요.",
  "이런 내용은 처음 봤는데 신선하네요.",
  "공감 100%입니다. 정말 그렇죠.",
  "저도 해봤는데 생각보다 훨씬 좋더라고요.",
  "좋은 글이에요. 주변에 공유해야겠어요.",
  "헉 이런 방법이 있었군요! 몰랐어요.",
  "경험 공유해주셔서 감사해요. 참고할게요.",
  "저는 조금 다르게 생각하는데 그것도 한 방법이겠네요.",
  "비슷한 고민을 하고 있었는데 많은 도움이 됐어요.",
  "오늘 딱 이게 필요했는데 타이밍이 너무 좋네요 ㅎㅎ",
  "정말 꿀팁이네요. 스크랩해뒀어요.",
  "저도 이거 해보고 싶은데 처음엔 어렵지 않나요?",
  "공감이 많이 되네요. 저도 그랬거든요.",
  "좋은 정보네요! 감사합니다 :)",
  "직접 경험담이라 더 신뢰가 가요.",
  "이런 글 더 올려주세요!",
  "너무 공감해서 댓글 남겨요.",
  "덕분에 좋은 정보 알게 됐어요.",
  "처음엔 반신반의했는데 해보니까 진짜 효과 있더라고요.",
  "이거 제 친구한테도 알려줬는데 좋아하더라고요.",
];

// ──────────────────────────────────────────
// 배치 INSERT 헬퍼
// ──────────────────────────────────────────
async function batchInsert(conn, table, columns, rows, batchSize = 1000) {
  const batches = chunk(rows, batchSize);
  const colStr = columns.join(", ");

  for (let i = 0; i < batches.length; i++) {
    const placeholders = batches[i].map(() => `(${columns.map(() => "?").join(", ")})`).join(", ");
    const values = batches[i].flat();
    await conn.execute(`INSERT INTO ${table} (${colStr}) VALUES ${placeholders}`, values);
    process.stdout.write(`\r  [${table}] ${Math.min((i + 1) * batchSize, rows.length)} / ${rows.length}`);
  }
  console.log("");
}

// ──────────────────────────────────────────
// 메인
// ──────────────────────────────────────────
async function main() {
  console.log("📦 board_db 샘플 데이터 생성 시작\n");
  const conn = await mysql.createConnection(DB_CONFIG);

  try {
    // ── 1. 회원 ──────────────────────────────
    console.log(`▶ 회원 ${COUNT.MEMBERS}명 생성 중...`);
    const hashedPw = await bcrypt.hash("Test1234!", 10);

    const memberRows = [];
    for (let i = 1; i <= COUNT.MEMBERS; i++) {
      const firstName = faker.person.lastName();
      const lastName  = faker.person.firstName();
      const username  = firstName + lastName;
      const nickname  = faker.internet.displayName().slice(0, 10);
      const id = `user${String(i).padStart(4, "0")}`;
      memberRows.push([id, hashedPw, username.slice(0, 10), nickname]);
    }
    await batchInsert(conn, "board_member", ["id", "passwd", "username", "nickname"], memberRows);

    // 회원 번호 조회
    const [memberResult] = await conn.query("SELECT no FROM board_member");
    const memberNos = memberResult.map((r) => r.no);
    console.log(`  ✅ 회원 ${memberNos.length}명 완료\n`);

    // ── 2. 게시글 ─────────────────────────────
    console.log(`▶ 게시글 ${COUNT.BOARDS}건 생성 중...`);
    const boardRows = [];
    const now = new Date();

    for (let i = 0; i < COUNT.BOARDS; i++) {
      const mno = pick(memberNos);
      const title = genBoardTitle();
      const content = genBoardContent();
      const writeDate = faker.date.between({ from: new Date("2023-01-01"), to: now });
      const updateDate = new Date(writeDate.getTime() + rand(0, 86400000));
      const bcount = rand(0, 500);
      boardRows.push([title, content, writeDate, mno, bcount, updateDate]);
    }
    await batchInsert(
      conn,
      "board",
      ["title", "content", "write_date", "mno", "bcount", "write_update_date"],
      boardRows
    );

    const [boardResult] = await conn.query("SELECT bno FROM board");
    const bnos = boardResult.map((r) => r.bno);
    console.log(`  ✅ 게시글 ${bnos.length}건 완료\n`);

    // ── 3. 댓글 ──────────────────────────────
    console.log(`▶ 댓글 ${COUNT.COMMENTS}건 생성 중...`);
    const commentRows = [];

    for (let i = 0; i < COUNT.COMMENTS; i++) {
      const mno = pick(memberNos);
      const bno = pick(bnos);
      const content = pick(COMMENT_TEMPLATES);
      const cdate = faker.date.between({ from: new Date("2023-01-01"), to: now });
      commentRows.push([content, cdate, mno, bno]);
    }
    await batchInsert(conn, "board_comment", ["content", "cdate", "mno", "bno"], commentRows);

    const [commentResult] = await conn.query("SELECT cno FROM board_comment");
    const cnos = commentResult.map((r) => r.cno);
    console.log(`  ✅ 댓글 ${cnos.length}건 완료\n`);

    // ── 4. 게시글 좋아요 / 싫어요 ──────────────
    console.log(`▶ 게시글 좋아요/싫어요 ${COUNT.BOARD_REACTIONS}건 생성 중...`);
    const boardPairs = generateUniquePairs(memberNos, bnos, COUNT.BOARD_REACTIONS);
    const { likes: boardLikes, hates: boardHates } = splitReactions(boardPairs);

    console.log(`  → 좋아요 ${boardLikes.length}건 삽입 중...`);
    await batchInsert(conn, "board_like", ["no", "bno"], boardLikes);
    console.log(`  → 싫어요 ${boardHates.length}건 삽입 중...`);
    await batchInsert(conn, "board_hate", ["no", "bno"], boardHates);
    console.log(`  ✅ 게시글 리액션 완료\n`);

    // ── 5. 댓글 좋아요 / 싫어요 ────────────────
    console.log(`▶ 댓글 좋아요/싫어요 ${COUNT.COMMENT_REACTIONS}건 생성 중...`);
    const commentPairs = generateUniquePairs(memberNos, cnos, COUNT.COMMENT_REACTIONS);
    const { likes: commentLikes, hates: commentHates } = splitReactions(commentPairs);

    console.log(`  → 좋아요 ${commentLikes.length}건 삽입 중...`);
    await batchInsert(conn, "board_comment_like", ["no", "cno"], commentLikes);
    console.log(`  → 싫어요 ${commentHates.length}건 삽입 중...`);
    await batchInsert(conn, "board_comment_hate", ["no", "cno"], commentHates);
    console.log(`  ✅ 댓글 리액션 완료\n`);

    console.log("🎉 모든 샘플 데이터 생성 완료!");
    console.log(`
┌────────────────────────────────┬──────────────┐
│ 테이블                         │ 생성 건수    │
├────────────────────────────────┼──────────────┤
│ board_member                   │ ${String(memberNos.length).padStart(12)} │
│ board                          │ ${String(bnos.length).padStart(12)} │
│ board_comment                  │ ${String(cnos.length).padStart(12)} │
│ board_like                     │ ${String(boardLikes.length).padStart(12)} │
│ board_hate                     │ ${String(boardHates.length).padStart(12)} │
│ board_comment_like             │ ${String(commentLikes.length).padStart(12)} │
│ board_comment_hate             │ ${String(commentHates.length).padStart(12)} │
└────────────────────────────────┴──────────────┘
`);
  } finally {
    await conn.end();
  }
}

main().catch((err) => {
  console.error("❌ 오류 발생:", err.message);
  process.exit(1);
});