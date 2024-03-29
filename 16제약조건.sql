--제약조건 - 컬럼에 데이터에대한 수정, 삭제 등을 방지하기 위한 조건
--PRIMARY KEY - 테이블의 고유키, 중복 X, NULL 허용X, PK는 테이블에서 1개
--UNIQUE - 중복 X, NULL허용
--NOT NULL - NULL을 허용하지 않음
--FOREIGN KEY  - 참조하는 테이블의 PK를 넣어놓은 키, 중복 O, NULL O
--CHECK - 컬럼에 대한 데이터 제한

DROP TABLE DEPTS;

--테이블의 제약조건을 확인하는 방법들이 존재합니다. 
--제약조건탭에서 확인
SELECT * FROM USER_CONSTRAINTS;

--1ST (열레벨)
CREATE TABLE DEPTS (
    DEPT_NO NUMBER(2)       CONSTRAINT DEPTS_DEPT_NO_PK PRIMARY KEY ,
    DEPT_NAME VARCHAR2(30)  CONSTRAINT DEPTS_DEPT_NAME_NN NOT NULL,
    DEPT_DATE DATE          DEFAULT SYSDATE , --제약조건X (컬럼의 기본값)
    DEPT_PHONE VARCHAR2(30) CONSTRAINT DEPTS_DEPT_PHONE UNIQUE,
    DEPT_GENDER CHAR(1)     CONSTRAINT DEPTS_DEPT_GENDER_CK CHECK( DEPT_GENDER IN ('F', 'M') ),
    LOCA_ID NUMBER(4)       CONSTRAINT DEPTS_LOCA_ID_FK REFERENCES LOCATIONS(LOCATION_ID)    
);

DROP TABLE DEPTS;

--1ST (CONSTRAIN는 생략가능)
CREATE TABLE DEPTS (
    DEPT_NO NUMBER(2)       PRIMARY KEY ,
    DEPT_NAME VARCHAR2(30)  NOT NULL, --NOT NULL같은 경우는 컨트스트레인트 키워드 생략하고 많이 사용함
    DEPT_DATE DATE          DEFAULT SYSDATE , --제약조건X (컬럼의 기본값)
    DEPT_PHONE VARCHAR2(30) NOT NULL UNIQUE, -- 다른 종류의 제약조건을 같이 줄수도 있습니다
    DEPT_GENDER CHAR(1)     NOT NULL CHECK( DEPT_GENDER IN ('F', 'M') ),
    LOCA_ID NUMBER(4)       REFERENCES LOCATIONS(LOCATION_ID)    
);
--
INSERT INTO DEPTS(DEPT_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID)
VALUES (1, NULL, '010..', 'F', 1700); --NOT NULL제약 위배

INSERT INTO DEPTS(DEPT_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID)
VALUES (1, 'HONG', '010..', 'X', 1700); --CHECK제약 위배

INSERT INTO DEPTS(DEPT_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID)
VALUES (1, 'HONG', '010..', 'F', 100); -- 참조제약 위배

INSERT INTO DEPTS(DEPT_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID)
VALUES (1, 'HONG', '010..', 'F', 1700);

INSERT INTO DEPTS(DEPT_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID)
VALUES (2, 'HONG', '010..', 'F', 1700); -- UNIQUE제약 위배

--2ND(테이블레벨 제약조건 정의)
DROP TABLE DEPTS;

CREATE TABLE DEPTS (
    DEPT_NO NUMBER(2),
    DEPT_NAME VARCHAR2(30) NOT NULL, --NOT NULL은 열레벨 정의
    DEPT_DATE DATE DEFAULT SYSDATE,
    DEPT_PHONE VARCHAR2(30) NOT NULL,
    DEPT_GENDER CHAR(1),
    LOCA_ID NUMBER(4),
    CONSTRAINT DEPT_NO_PK PRIMARY KEY (DEPT_NO /*, DEPT_NAME*/), --슈퍼키는 테이블레벨로 지정이 가능합니다.
    CONSTRAINT DPET_PHONE_UK UNIQUE (DEPT_PHONE),
    CONSTRAINT DEPT_GENDER_CK CHECK (DEPT_GENDER IN ('F', 'M')),
    CONSTRAINT DEPT_LOCA_ID_FK FOREIGN KEY (LOCA_ID) REFERENCES LOCATIONS(LOCATION_ID)
);


--3ND (제약조건의 추가 삭제), 수정이 없습니다
DROP TABLE DEPTS;

CREATE TABLE DEPTS (
    DEPT_NO NUMBER(2),
    DEPT_NAME VARCHAR2(30) NOT NULL, --NOT NULL은 열레벨 정의
    DEPT_DATE DATE DEFAULT SYSDATE,
    DEPT_PHONE VARCHAR2(30),
    DEPT_GENDER CHAR(1),
    LOCA_ID NUMBER(4)
);
--PK추가
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_NO_PK PRIMARY KEY (DEPT_NO);
--UK추가
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_NO_UK UNIQUE (DEPT_PHONE);
--CHECK제약
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_GENDER_CK CHECK (DEPT_GENDER IN ('F', 'M'));
--FK제약
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_LOCA_ID_FK FOREIGN KEY (LOCA_ID) REFERENCES LOCATIONS(LOCATION_ID);
--NOT NULL은 ALTER구문으로 불가능하고, MODIFY를 이용해서 열 수정으로 변경이 들어갑니다.
ALTER TABLE DEPTS MODIFY DEPT_PHONE VARCHAR2(30) NOT NULL;

--제약조건 삭제
ALTER TABLE DEPTS DROP CONSTRAINT DEPT_NO_UK; --제약조건명으로 삭제합니다.

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'DEPTS';

-----------------------------------------------------------------------------
--연습문제
CREATE TABLE MEMBERS(
    M_NAME VARCHAR2(30) NOT NULL ,
    M_NUM NUMBER(10),
    REG_DATE DATE,
    GENDER VARCHAR2(1),
    LOCA NUMBER(4)
);
ALTER TABLE MEMBERS ADD CONSTRAINT mem_memnum_pk PRIMARY KEY (M_NUM);
ALTER TABLE MEMBERS ADD CONSTRAINT mem_regdate_uk UNIQUE (REG_DATE);
ALTER TABLE MEMBERS ADD CONSTRAINT mem_loca_loc_locid_fk FOREIGN KEY (LOCA) REFERENCES LOCATIONS(LOCATION_ID);

INSERT INTO MEMBERS VALUES('AAA', 1, TO_DATE('2018-07-01', 'YY/MM/DD'), 'M', 1800);
//..

SELECT m_name, m_num, street_address, location_id
FROM MEMBERS M
JOIN LOCATIONS L
ON M.LOCA = L.LOCATION_ID
ORDER BY M_NUM;




