<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>adContent.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <script>
  </script>
  <style>
  	.container {margin-left: 50px;}
  	.top {
  		font-family: 'Spoqa Han Sans Neo', 'sans-serif';
  		font-size: 1.7em;
  		font-weight: bold;
  	}
  	.title {
  		font-size: 1.4em;
  		font-weight: 500;
  	}
  </style>
</head>
<body>
<p><br/></p>
<div class="container">
	<div class="text-center top pt-3 pb-3" style="border-top: 2px solid #ccc">답변 대기중인 문의 수</div>
	<div class="mb-4 d-flex justify-content-around pb-3" style="border-bottom: 2px solid #ccc;">
		<div class="top text-center" style="font-size: 3.5em; width: 45%; line-height: 2em; position: relative;">
			<c:if test="${helpCnt > 0}"><i class="fa-solid fa-circle-exclamation" style="color: #CC0000"></i></c:if>
			<c:if test="${helpCnt == 0}"><i class="fa-regular fa-circle-check" style="color: #00dd33"></i></c:if>
		</div>
		<div class="top text-center" style="font-size: 2em; width: 45%; line-height: 3.5em;">${helpCnt}건</div>
	</div>
	<div class="mb-4">
		<table class="table table-hover text-center">
			<thead class="thead-dark"><tr><th colspan="4" class="title">유저 현황</th></tr></thead>
			<tr><th colspan="2">유저 수</th><td colspan="2">${userTot}명</td></tr>
			<thead class="thead-dark"><tr><th colspan="4" class="title">최근 등록된 회원</th></tr></thead>
			<tr><td>아이디</td><td>이메일</td><td>생일</td><td>생성일</td></tr>
			<c:forEach var="vo" items="${userVOS}" end="4">
				<tr>
					<td>${vo.mid}</td>
					<td>${vo.email}</td>
					<td>${fn:substring(vo.birth,0,10)}</td>
					<td>${fn:substring(vo.createDay,0,10)}</td>
				</tr>
			</c:forEach>
			<tr><td colspan="4"></td></tr>
		</table>
	</div>
	<div class="mb-4">
		<table class="table table-hover text-center">
			<thead class="thead-dark"><tr><th colspan="4" class="title">업체 현황</th></tr></thead>
			<tr><th colspan="2">업체 수</th><td colspan="2">${companyTot}개</td></tr>
			<thead class="thead-dark"><tr><th colspan="4" class="title">최근 등록된 업체</th></tr></thead>
			<tr><td>회사명</td><td>대표명</td><td>업체활성화 상태</td><td>등록일</td></tr>
			<c:forEach var="vo" items="${companyVOS}" end="4">
				<tr>
					<td>${vo.cpName}</td>
					<td>${vo.name}</td>
					<td>
						<c:if test="${vo.act == 'off'}">비활성</c:if>
						<c:if test="${vo.act != 'off'}">완료</c:if>
					</td>
					<td>${fn:substring(vo.createDayCP,0,10)}</td>
				</tr>
			</c:forEach>
			<tr><td colspan="4"></td></tr>
		</table>
	</div>
	<div class="mb-4">
		<table class="table table-hover text-center">
			<thead class="thead-dark"><tr><th colspan="4" class="title" >이미지 파일 현황</th></tr></thead>
			<tr><th colspan="2">파일 수</th><td colspan="2">${totFile}개</td></tr>
			<tr><th colspan="2">용량</th><td colspan="2"><fmt:formatNumber value="${totFSize/1024/1024}" pattern="0.00"/>Mbyte</td></tr>
			<thead class="thead-dark"><tr><th colspan="4" class="title">최근 업로드된 파일</th></tr></thead>
			<tr><td>파일명</td><td>업로더</td><td>파일크기</td><td>수정일</td></tr>
			<c:forEach var="vo" items="${pdsVOS}" end="4" >
				<tr>
					<td>${vo.fSysName}</td>
					<td>${vo.mid}</td>
					<td><fmt:formatNumber value="${(vo.fSize/1024)/1024}" pattern="0.00"/>Mbyte</td>
					<td>${fn:substring(vo.inDate,0,10)}</td>
				</tr>
			</c:forEach>
			<tr><td colspan="4"></td></tr>
		</table>
	</div>
	<div class="mb-4">
		<table class="table table-hover text-center">
			<thead class="thead-dark"><tr><th colspan="4" class="title" >이미지 파일 현황</th></tr></thead>
			<tr><th>댓글 수</th><td colspan="2">${replyTot}개</td></tr>
			<thead class="thead-dark"><tr><th colspan="4" class="title">최근 업로드된 파일</th></tr></thead>
			<tr><td>작성자</td><td>내용</td><td>평점</td><td>작성일</td></tr>
			<c:forEach var="vo" items="${replyVOS}" end="4" >
				<tr>
					<td>${vo.mid}</td>
					<td>${vo.content}</td>
					<td>${vo.rating == 0.0 ? '없음' : vo.rating}</td>
					<td>${fn:substring(vo.writeDay,0,10)}</td>
				</tr>
			</c:forEach>
			<tr><td colspan="4"></td></tr>
		</table>
	</div>
	<div class="mb-4">
		<table class="table table-hover text-center">
			<thead class="thead-dark"><tr><th colspan="6" class="title" >신고 현황</th></tr></thead>
			<tr><th colspan="3">신고 수</th><td colspan="3">${reportTot}개</td></tr>
			<thead class="thead-dark"><tr><th colspan="6" class="title">최근 신고된 댓글</th></tr></thead>
			<tr><td>신고 번호</td><td>신고된 아이디</td><td>댓글 내용</td><td>작성일</td><td>신고자</td><td>신고일</td></tr>
			<c:forEach var="vo" items="${reportVOS}" end="4" >
				<tr>
					<td>${vo.replyIdx}</td>
					<td>${vo.replyMid}</td>
					<td>${vo.replyContent}</td>
					<td>${fn:substring(vo.replyWriteDay,0,10)}</td>
					<td>${vo.reportMid}</td>
					<td>${fn:substring(vo.reportWriteDay,0,10)}</td>
				</tr>
			</c:forEach>
			<tr><td colspan="6"></td></tr>
		</table>
	</div>
</div>
<p><br/></p>
</body>
</html>