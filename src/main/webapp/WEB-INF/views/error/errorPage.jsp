<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>errorPage.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="/WEB-INF/view/include/viewPage.css" rel="stylesheet" type="text/css">
  <script></script>
  <style></style>
</head>
<body ondragstart="return false" onselectstart="return false">
	<div id="loading_Bar"></div>
	<div class="width" style="padding-top: 250px">
		<div class="text-center">
			<div style="font-size: 8em;">${errorCode}</div>
			<div class="mt-2 " style="font-size: 2.7em;"><i class="fa-solid fa-triangle-exclamation"></i> ${errorMsg}</div>
			<div class="mt-2 mb-4" style="font-size: 1.5em">${adviceMsg}</div>
		</div>
		<div class="text-center">
			<span class="text-center"><button type="button" onclick="location.href='${ctp}/'" class="btn btn-success" ><i class="fa-solid fa-house-chimney"></i> 홈으로 이동</button></span>
			<span class="text-center"><button type="button" onclick="history.back();" class="btn btn-info" ><i class="fa-solid fa-rotate-right"></i> 이전페이지로</button></span>
		</div>
	</div>
	<script src="/WEB-INF/view/include/viewPage.js"></script>
</body>
</html>