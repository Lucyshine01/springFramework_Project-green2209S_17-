<h1 align="center">인테리어 회사중개 사이트</h1>
<br><br>
프로젝트 사이트명 : 인테모아(Intemoa)<br>

- 배포된 프로젝트 방문 (AWS EC2)  - [보러가기][link]

[link]: http://ec2-43-200-238-66.ap-northeast-2.compute.amazonaws.com "프로젝트 사이트 방문하기"

- 테스트계정(일반 회원)
  +  ID : test
  +  PassWord : 1234 <br>

- 테스트계정(업체 회원)
  +  ID : RItssGjj
  +  PassWord : 12341234 <br>

- 사이트 메인홈 이미지
<div>
  <img src="https://drive.usercontent.google.com/download?id=1ZbP07tPN9YkWb1yst37Cx3nFLPd5lK0C&export=download&authuser=0&confirm=t&uuid=4244d427-5711-4d04-a424-b03002883977&at=APZUnTW2ICiwwkszRwWIpU4I0_q0:1695035814854" width="90%">
</div>

<br><br>
**목차**

- [1. 개발개요](#1-개발개요) <br>
- [2. 개발환경](#2-개발환경) <br>
- [3. 데이터베이스 구조](#3-데이터베이스-구조) <br>
- [4. 기능 설명](#4-기능-설명) <br>

<br>
------------
<br><br>

# 1. 개발개요
**개발 동기** : 인테리어 업체를 운영하시는 아버지의 일을 보고 업체와 회원간의 편리한 소통사이트가 있으면 좋겠다는 생각으로 프로젝트를 진행하게되었습니다.<br><br>
**개발 기간** : 2023.02.01 ~ 2023.03.01 <br><br>
**주요 기능** : <br>
<table>
  <tr>
    <td align="center">관리자 페이지</td>
    <td align="center">내용</td>
  </tr>
  <tr>
    <td>회원, 업체 관리</td>
    <td>일반 회원과 업체 회원를 관리할 수 있습니다.</td>
  </tr>
  <tr>
    <td>리뷰 및 신고 관리</td>
    <td>리뷰에 대한 관리와 리뷰에 대한 신고된 내용을 처리가 가능합니다.</td>
  </tr>
  <tr>
    <td>문의 답변</td>
    <td>회원의 문의 내용을 수신 및 답변을 할수 있습니다.</td>
  </tr>
  <tr>
    <td>채팅 내역</td>
    <td>회원과 업체간의 1대1 채팅 내역을 확인 할수 있습니다.</td>
  </tr>
  <tr>
    <td>결제 내역</td>
    <td>포인트 충전으로 회원들의 결제 내역 결과들을 조회할 수 있습니다.</td>
  </tr>
</table>
<br>
<table>
  <tr>
    <td align="center">사용자 페이지</td>
    <td align="center">내용</td>
  </tr>
  <tr>
    <td>회원가입, 내 정보 수정</td>
    <td>일반 회원가입 후 내 정보를 수정 할수 있습니다</td>
  </tr>
  <tr>
    <td>업체 등록</td>
    <td>회원가입 후 일정 포인트를 사용하여 업체 회원으로 신청할 수 있습니다.</td>
  </tr>
  <tr>
    <td>이미지 추가/삭제</td>
    <td>업체 회원의 업체 페이지에서 자신의 업체 소개 이미지를 추가 및 삭제 할 수 있습니다.</td>
  </tr>
  <tr>
    <td>업체 목록 검색</td>
    <td>업체 목록을 회사명,대표이름,소개글 내용으로 검색 할수 있습니다.</td>
  </tr>
  <tr>
    <td>리뷰 작성 및 삭제</td>
    <td>회원가입 후 업체 소개글에 리뷰작성이 가능하며 리뷰를 삭제 할수 있습니다.</td>
  </tr>
  <tr>
    <td>문의 작성</td>
    <td>불만사항을 작성하여 운영자에게 전달 할수 있습니다.</td>
  </tr>
  <tr>
    <td>1대1 채팅 기능</td>
    <td>실시간으로 회원과 업체간 채팅으로 소통이 가능합니다.</td>
  </tr>
  <tr>
    <td>실시간 알림</td>
    <td>자신의 업체소개글에 리뷰가 작성되거나 자신에게 채팅이 올 경우 실시간 알림으로 확인 할수 있습니다.</td>
  </tr>
</table>
<br><br>

# 2. 개발환경
- 개발 언어 : JAVA, JS, JQuery, JSP, HTML, CSS (spring Framework)
- 개발 프로그램 : spring-tool-suit 4.14.1 (Eclipes IDE 2022.03)
- 데이터베이스 : MySQL5.7.19
- 서버 : Apache Tomcat 9.0.8
- 사용 API : SockJS(웹소켓), STOMP(채팅)
<br><br>

# 3. 데이터베이스 구조
- 대부분의 테이블을 회원 테이블(user 테이블)의 mid 필드를 참조하여 연결
<div>
  <img src="https://drive.usercontent.google.com/download?id=1OgjXrL4QhrNy7baFobqe6TCiMD3KZP4-&export=download&authuser=0&confirm=t&uuid=41f30ac3-05ec-4123-a49c-7ce03146c127&at=APZUnTWJaj15T10CpnLjZmNItELX:1695036151208" width="90%">
</div>
<br><br>

# 4. 기능 설명

- 화면 설명 PPT - [보러가기][PPTfile]

[PPTfile]: https://docs.google.com/presentation/d/1x5vO0p4PDbU2HcflNs0YHbE6eLCalpoWjJzAv5ftfIY/edit?usp=drive_link "PPT"

- 슬라이드 PPT - [보러가기][slidePPT]

[slidePPT]: https://docs.google.com/presentation/d/e/2PACX-1vRRJ1jh6h6xwlClMy8dkBJqLiPcroYRrHvGirTQe8w60VneiV0KN2wKduP4vNcKTcMnQmoHR7Q-GIX_/pub?start=false&loop=false&delayms=3000 "슬라이드PPT"

<br><br>


