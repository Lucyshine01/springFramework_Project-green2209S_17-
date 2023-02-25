<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>adminMain.jsp</title>
  <frameset rows="76px,*" frameborder="0">
  	<frameset cols="250px, *">
  	<frame src="${ctp}/include/blank.jsp" name="##" frameborder="0"/>
  	<frame src="${ctp}/adminHeader.ad" name="header" frameborder="0"/>
  	</frameset>
	  <frameset cols="300px, *">
	  	<frame src="${ctp}/adLeft.ad" name="adLeft" frameborder="0"/>
	  	<frame src="${ctp}/adContent.ad" name="adContent" frameborder="0"/>
	  </frameset>
  </frameset>
  <script></script>
  <style></style>
</head>
<body ondragstart="return false" onselectstart="return false">
</body>
</html>