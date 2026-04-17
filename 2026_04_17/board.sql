-- Active: 1775701110283@@127.0.0.1@3306@board_db
create DATABASE board_db;
USE board_db;

desc board;
CREATE TABLE board
(
  bno               BIGINT      NOT NULL AUTO_INCREMENT,
  title             VARCHAR(50) NULL    ,
  content           LONGTEXT    NULL    ,
  write_date        DATETIME    NULL     DEFAULT now(),
  mno               int         NOT NULL,
  bcount            int         NULL     DEFAULT 0,
  write_update_date DATETIME    NULL     DEFAULT now(),
  PRIMARY KEY (bno)
);

CREATE TABLE board_comment
(
  cno     BIGINT        NOT NULL AUTO_INCREMENT,
  content VARCHAR(1000) NULL    ,
  cdate   DATETIME      NULL     DEFAULT now(),
  mno     int           NOT NULL,
  bno     BIGINT        NOT NULL,
  PRIMARY KEY (cno)
);

CREATE TABLE board_comment_hate
(
  no  int    NOT NULL,
  cno BIGINT NOT NULL
);

CREATE TABLE board_comment_like
(
  no  int    NOT NULL,
  cno BIGINT NOT NULL
);

CREATE TABLE board_hate
(
  no  int    NOT NULL,
  bno BIGINT NOT NULL
);

CREATE TABLE board_like
(
  no  int    NOT NULL,
  bno BIGINT NOT NULL
);

CREATE TABLE board_member
(
  no       int         NOT NULL AUTO_INCREMENT,
  id       VARCHAR(20) NOT NULL,
  passwd   CHAR(128)   NULL    ,
  username VARCHAR(10) NULL    ,
  nickname VARCHAR(10) NULL    ,
  PRIMARY KEY (no)
);

ALTER TABLE board
  ADD CONSTRAINT FK_board_member_TO_board
    FOREIGN KEY (mno)
    REFERENCES board_member (no);

ALTER TABLE board_like
  ADD CONSTRAINT FK_board_member_TO_board_like
    FOREIGN KEY (no)
    REFERENCES board_member (no);

ALTER TABLE board_like
  ADD CONSTRAINT FK_board_TO_board_like
    FOREIGN KEY (bno)
    REFERENCES board (bno);

ALTER TABLE board_hate
  ADD CONSTRAINT FK_board_member_TO_board_hate
    FOREIGN KEY (no)
    REFERENCES board_member (no);

ALTER TABLE board_hate
  ADD CONSTRAINT FK_board_TO_board_hate
    FOREIGN KEY (bno)
    REFERENCES board (bno);

ALTER TABLE board_comment
  ADD CONSTRAINT FK_board_member_TO_board_comment
    FOREIGN KEY (mno)
    REFERENCES board_member (no);

ALTER TABLE board_comment
  ADD CONSTRAINT FK_board_TO_board_comment
    FOREIGN KEY (bno)
    REFERENCES board (bno);

ALTER TABLE board_comment_like
  ADD CONSTRAINT FK_board_member_TO_board_comment_like
    FOREIGN KEY (no)
    REFERENCES board_member (no);

ALTER TABLE board_comment_like
  ADD CONSTRAINT FK_board_comment_TO_board_comment_like
    FOREIGN KEY (cno)
    REFERENCES board_comment (cno);

ALTER TABLE board_comment_hate
  ADD CONSTRAINT FK_board_member_TO_board_comment_hate
    FOREIGN KEY (no)
    REFERENCES board_member (no);

ALTER TABLE board_comment_hate
  ADD CONSTRAINT FK_board_comment_TO_board_comment_hate
    FOREIGN KEY (cno)
    REFERENCES board_comment (cno);

-- 댓글 좋아요, 싫어요, 게시글 좋아요, 싫어요는 중복 방지 위해 unique 제약조건 추가
alter table board_like add constraint unique (no, bno);
alter table board_hate add constraint unique (no, bno);
alter table board_comment_like add constraint unique (no, cno); 
alter table board_comment_hate add constraint unique (no, cno);

--- -------------------------
select count(*) from board;
select count(*) from board_comment; 
select count(*) from board_like;
select count(*) from board_hate;
select count(*) from board_comment_like;
select count(*) from board_comment_hate;
select count(*) from board_member;

-- 게시글 확인
select * from board LIMIT 100;