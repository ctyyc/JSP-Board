# JSP-BOARD

#### Setting
프로젝트 생성 > 톰캣 세팅 > DB 관련 정보 생성 > DB jar 파일 추가

#### Script
````
// db 생성
create database jspdb;
````

````
// 회원 테이블 생성
create table USER(
	userID varchar(20),
	userPassword varchar(20),
	userName varchar(20),
	userGender varchar(20),
	userEmail varchar(50),
	primary key(userID)
);
````

````
// 게시글 테이블 생성
create table POST (
	postID int,
	title varchar(50),
	userID varchar(20),
	regDate datetime,
	contents varchar(2048),
	available int,
	primary key(postID)
);
````

<br>

#### 참고 :
https://happy-inside.tistory.com/category/%EC%BD%94%EB%94%A9/JSP%20%EA%B2%8C%EC%8B%9C%ED%8C%90
