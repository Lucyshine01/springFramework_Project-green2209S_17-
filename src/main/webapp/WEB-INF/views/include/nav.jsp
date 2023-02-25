<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>nav.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"/>
</head>
<body>
<p><br/></p>
<div class="container">
	<div>
		<a href="${ctp}/user/userMain">홈으로</a> | 
		<a href="${ctp}/guest/guestList">방명록</a> | 
		<a href="${ctp}/board/boardList">게시판</a> | 
		<a href="${ctp}/pds/pdsList">자료실</a> | 
		<a href="${ctp}/user/userLogout">로그아웃</a> | 
	</div>
</div>
<p><br/></p>
</body>
</html>