<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>home.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="${ctp}/viewPage/viewPage.css" rel="stylesheet" type="text/css">
  <script></script>
  <style></style>
</head>

<body ondragstart="return false" onselectstart="return false">
	<jsp:include page="/WEB-INF/views/include/notice.jsp"></jsp:include>
	<div id="loading_Bar"></div>
	<c:if test="${empty sMid}"><jsp:include page="/WEB-INF/views/include/headTop.jsp"></jsp:include></c:if>
	<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
	
	<jsp:include page="/WEB-INF/views/include/body.jsp"></jsp:include>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script src="${ctp}/viewPage/viewPage.js"></script>
</body>
</html>