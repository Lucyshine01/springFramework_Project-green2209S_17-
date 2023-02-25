<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>adLeft.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <script></script>
  <style>
  	a {text-decoration-line:none;}
  	.menu {
  		width: 200px;
  		margin-bottom: 10px;
  		font-size: 1.2em;
  		font-weight: 400;
  		color: #999;
  	}
  	.menu:hover {
  		color: #555;
  	}
  </style>
</head>
<body>
<p><br/></p>
<div class="container">
  <div class="text-center" style="font-size: 1.7em;font-weight: bold;">관리자메뉴</div>
  <hr/>
  <div class="text-center menu ml-auto mr-auto">
  	<a href="${ctp}/adminMain.ad" target="_top"><i class="fa-solid fa-house"></i> 관리자 메인</a>
  </div>
  <div class="text-center menu ml-auto mr-auto">
  	<a href="${ctp}/adUserList.ad?pag=1&pageSize=5" target="adContent"><i class="fa-solid fa-user"></i> 회원 관리</a>
  </div>
  <div class="text-center menu ml-auto mr-auto">
  	<a href="${ctp}/adCPList.ad?pag=1&pageSize=5" target="adContent"><i class="fa-solid fa-building"></i> 업체 관리</a>
  </div>
  <div class="text-center menu ml-auto mr-auto">
  	<a href="${ctp}/adReplyList.ad?pag=1&pageSize=5" target="adContent"><i class="fa-solid fa-comment-dots"></i> 댓글 관리</a>
  </div>
  <%-- <div class="text-center menu ml-auto mr-auto">
  	<a href="${ctp}/ad.ad?pag=1&pageSize=5" target="adContent"><i class="fa-solid fa-code-pull-request"></i> 의뢰 관리</a>
  </div> --%>
  <div class="text-center menu ml-auto mr-auto">
  	<a href="${ctp}/adHelpList.ad" target="adContent"><i class="fa-solid fa-circle-question"></i> 문의 관리</a>
  </div>
  <div class="text-center menu ml-auto mr-auto">
  	<a href="${ctp}/adReportList.ad?pag=1&pageSize=5" target="adContent"><i class="fa-solid fa-ban"></i> 신고 관리</a>
  </div>
</div>
<p><br/></p>
</body>
</html>