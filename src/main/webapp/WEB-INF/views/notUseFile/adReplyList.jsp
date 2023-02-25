<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>adUserList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="include/viewPage.css" rel="stylesheet" type="text/css">
  <script>
  	'use strict';
  	let pag = ${pag};
  	let totPage = ${totPage};
  	let pageSize = ${pageSize};
  	let searching = "${searching}";
  	
  	if(totPage != 0){
	  	if(pag > totPage || pag <= 0) {
	  		if(searching != '') location.href = '${ctp}/adReplySearch.ad?pag='+totPage+'&pageSize='+pageSize+'&searching=${searching}&searchItem=${searchItem}';
	  		else location.href = '${ctp}/adReplyList.ad?pag='+totPage+'&pageSize='+pageSize;
	  	}
  	}
  	function pageSizeChange() {
			let pageSize = $("#pageSize").val();
			location.href = '${ctp}/adReplyList.ad?pag=${pag}&pageSize='+pageSize;
		}
  	
		function replyDelete(idx) {
			let ans = confirm("정말 삭제하시겠습니까?");
			if(!ans) return;
			
			$.ajax({
				type: "post",
				url : "${ctp}/adReplyDel.ad",
				data: {ridx:idx},
				success: function(res) {
					if(res == '1') location.reload();
					else alert("삭제실패");
				}
			});
		}
		
  	function searchReply() {
			let searchItem = $("#searchItem").val();
			let searching = $("#searching").val();
			if(searching.trim() == '') return;
			
			location.href = "${ctp}/adReplySearch.ad?searching="+searching+"&searchItem="+searchItem+"&pag=${pag}&pageSize=${pageSize}";
		}
  	
  	$(function() {
			$("#searching").on('keydown', function(e){
				if(e.keyCode == 13) searchReply();
			});
		});
  </script>
  <style>
  	.container {margin-left: 50px;}
  	td {
  		font-weight: 300;
  	}
  	.form-hidden {display: none;}
  	.form-hidden td {padding: 10px 0px; text-align: center;}
  </style>
</head>
<body>
	<div class=" container mt-3">
		<div class="ml-3 mb-3" style="float: left">
			<select id="searchItem" name="searchItem">
				<option ${searchItem=='mid' ? 'selected' : '' } value="mid">아이디</option>
				<option ${searchItem=='content' ? 'selected' : '' } value="content">내용</option>
				<option ${searchItem=='boardIdx' ? 'selected' : '' } value="boardIdx">게시판번호</option>
				<option ${searchItem=='ridx' ? 'selected' : '' } value="ridx">댓글번호</option>
			</select>
			<input type="text" name="searching" id="searching" value="${searching}" />
			<input type="button" onclick="searchReply()" value="검색" class="btn btn-sm btn-secondary" />
		</div>
		<div class="mr-3 mb-3" style="float: right">
			글 표시 수 
			<select id="pageSize" name="pageSize" onchange="pageSizeChange()">
				<option ${pageSize=='5' ? 'selected' : '' } value="5">5개</option>
				<option ${pageSize=='10' ? 'selected' : '' } value="10">10개</option>
				<option ${pageSize=='20' ? 'selected' : '' } value="20">20개</option>
				<option ${pageSize=='50' ? 'selected' : '' } value="50">50개</option>
			</select>
		</div>
		<table class="table table-hover text-center">
			<thead class="thead-dark"><tr><th colspan="9" class="title">댓글 현황</th></tr></thead>
			<tr><th colspan="3">총 댓글 수</th><td colspan="4">${replyTot}개</td></tr>
			<thead class="thead-dark"><tr><th colspan="9" class="title">회원 목록</th></tr></thead>
			<tr>
				<td>번호</td>
				<td>게시판 번호</td>
				<td>작성자</td>
				<td>내용</td>
				<td>평점</td>
				<td>작성일</td>
				<td>삭제</td>
			</tr>
			<c:forEach var="vo" items="${vos}" varStatus="st">
				<tr>
					<td>${vo.ridx}</td>
					<td>${vo.boardIdx}</td>
					<td>${vo.mid}</td>
					<td>${vo.content}</td>
					<td>${vo.rating == 0.0 ? '없음' : vo.rating}</td>
					<td>${fn:substring(vo.writeDay,0,10)}</td>
					<td>
						<input type="button" onclick="replyDelete(${vo.ridx})" value="삭제" class="btn btn-sm btn-danger"/>
					</td>
				</tr>
			</c:forEach>
			<tr><td colspan="7"></td></tr>
		</table>
		<div class="text-center">
		  <ul class="pagination justify-content-center">
		  	<c:if test="${empty searching}"><c:set var="adList" value="${ctp}/adReplyList.ad?pageSize=${pageSize}" /> </c:if>
		  	<c:if test="${!empty searching}"><c:set var="adList" value="${ctp}/adReplySearch.ad?pageSize=${pageSize}&searching=${searching}&searchItem=${searchItem}"/></c:if>
		    <c:if test="${pag > 1}">
		      <li class="page-item"><a class="page-link text-secondary" href="${adList}&pag=1">
		      	<i class="fa-solid fa-backward-fast"></i>
		      </a></li>
		    </c:if>
		    <c:if test="${curBlock > 0}">
		      <li class="page-item"><a class="page-link text-secondary" href="${adList}&pag=${(curBlock-1)*blockSize + 1}">
		      	<i class="fa-solid fa-caret-left"></i>
		      </a></li>
		    </c:if>
		    <c:forEach var="i" begin="${(curBlock)*blockSize + 1}" end="${(curBlock)*blockSize + blockSize}" varStatus="st">
		      <c:if test="${i <= totPage && i == pag}">
		    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${adList}&pag=${i}">${i}</a></li>
		    	</c:if>
		      <c:if test="${i <= totPage && i != pag}">
		    		<li class="page-item"><a class="page-link text-secondary" href="${adList}&pag=${i}">${i}</a></li>
		    	</c:if>
		    </c:forEach>
		    <c:if test="${curBlock < lastBlock}">
		      <li class="page-item"><a class="page-link text-secondary" href="${adList}&pag=${(curBlock+1)*blockSize + 1}">
		      	<i class="fa-solid fa-caret-right"></i>
		      </a></li>
		    </c:if>
		    <c:if test="${pag < totPage}">
		      <li class="page-item"><a class="page-link text-secondary" href="${adList}&pag=${totPage}">
		      	<i class="fa-solid fa-forward-fast"></i>
		      </a></li>
		    </c:if>
		  </ul>
		</div>
	</div>
	<script src="include/viewPage.js"></script>
</body>
</html>