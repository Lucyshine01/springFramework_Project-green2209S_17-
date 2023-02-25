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
	  		if(searching != '') location.href = '${ctp}/adCPSearch.ad?pag='+totPage+'&pageSize='+pageSize+'&searching=${searching}&searchItem=${searchItem}';
	  		else location.href = '${ctp}/adCPList.ad?pag='+totPage+'&pageSize='+pageSize;
	  	}
  	}
  	function pageSizeChange() {
			let pageSize = $("#pageSize").val();
			location.href = '${ctp}/adUserList.ad?pag=${pag}&pageSize='+pageSize;
		}
  	
  	function CPUpdate(idx,mid) {
  		let ans = confirm("수정 하시겠습니까?");
			if(!ans) return;
			
			let act = $("#act"+idx).val()
			
  		$.ajax({
				type: "post",
				url : "${ctp}/adCPUpdate.ad",
				data: {cidx:idx,act:act,mid:mid},
				success: function(res) {
					if(res == '1') location.reload();
					else alert("수정실패");
				}
			});
		}
  	
		function CPDelete(idx,mid) {
			let ans = confirm("정말 삭제하시겠습니까?");
			if(!ans) return;
			
			$.ajax({
				type: "post",
				url : "${ctp}/adCPDel.ad",
				data: {cidx:idx,mid:mid},
				success: function(res) {
					if(res == '1') location.reload();
					else alert("삭제실패");
				}
			});
		}
		
  	function searchCP() {
			let searchItem = $("#searchItem").val();
			let searching = $("#searching").val();
			if(searching.trim() == '') return;
			location.href = "${ctp}/adCPSearch.ad?searching="+searching+"&searchItem="+searchItem+"&pag=${pag}&pageSize=${pageSize}";
		}
  	
  	$(function() {
			$("#searching").on('keydown', function(e){
				if(e.keyCode == 13) searchCP();
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
				<option ${searchItem=='cpName' ? 'selected' : '' } value="cpName">회사명</option>
				<option ${searchItem=='name' ? 'selected' : '' } value="name">대표명</option>
				<option ${searchItem=='cpAddr' ? 'selected' : '' } value="cpAddr">주소</option>
				<option ${searchItem=='cpIntro' ? 'selected' : '' } value="cpIntro">소개</option>
				<option ${searchItem=='cpExp' ? 'selected' : '' } value="cpExp">분야</option>
				<option ${searchItem=='mid' ? 'selected' : '' } value="mid">아이디</option>
			</select>
			<input type="text" name="searching" id="searching" value="${searching}" />
			<input type="button" onclick="searchCP()" value="검색" class="btn btn-sm btn-secondary" />
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
			<thead class="thead-dark"><tr><th colspan="9" class="title">업체 현황</th></tr></thead>
			<tr><th colspan="4">총 업체 수</th><td colspan="5">${CPTot}개</td></tr>
			<thead class="thead-dark"><tr><th colspan="9" class="title">회원 목록</th></tr></thead>
			<tr>
				<td>번호</td>
				<td>회사명</td>
				<td>대표명</td>
				<td>아이디</td>
				<td>분야</td>
				<td>등록일</td>
				<td>활성화 상태</td>
				<td>수정/삭제</td>
			</tr>
			<c:forEach var="vo" items="${vos}" varStatus="st">
				<tr>
					<td>${vo.cidx}</td>
					<td>${vo.cpName}</td>
					<td>${vo.name}</td>
					<td>${vo.mid}</td>
					<td style="width: 300px">${vo.cpExp}</td>
					<td>${fn:substring(vo.createDayCP,0,10)}</td>
					<td>
						<select id="act${vo.cidx}">
							<option ${vo.act == 'on' ? 'selected' : ''} value="on">활성</option>
							<option ${vo.act == 'off' ? 'selected' : ''} value="off">비활성</option>
						</select>
					</td>
					<td>
						<input type="button" onclick="CPUpdate(${vo.cidx},'${vo.mid}')" value="수정" class="btn btn-sm btn-warning"/>
						<input type="button" onclick="CPDelete(${vo.cidx},'${vo.mid}')" value="삭제" class="btn btn-sm btn-danger"/>
					</td>
				</tr>
			</c:forEach>
			<tr><td colspan="8"></td></tr>
		</table>
		<div class="text-center">
		  <ul class="pagination justify-content-center">
		  	<c:if test="${empty searching}"><c:set var="adList" value="${ctp}/adCPList.ad?pageSize=${pageSize}" /> </c:if>
		  	<c:if test="${!empty searching}"><c:set var="adList" value="${ctp}/adCPSearch.ad?pageSize=${pageSize}&searching=${searching}&searchItem=${searchItem}"/></c:if>
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