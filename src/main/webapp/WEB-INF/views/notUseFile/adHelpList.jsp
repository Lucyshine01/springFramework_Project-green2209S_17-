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
	  		else location.href = '${ctp}/adHelpList.ad?pag='+totPage+'&pageSize='+pageSize;
	  	}
  	}
  	function pageSizeChange() {
			let pageSize = $("#pageSize").val();
			location.href = '${ctp}/adHelpList.ad?pag=${pag}&pageSize='+pageSize;
		}
  	
		function helpBoxOn(idx) {
			$(".box"+idx).show();
			$("#boxOn"+idx).hide();
			$("#boxOff"+idx).show();
		}
		function helpBoxClose(idx) {
			$(".box"+idx).hide();
			$("#boxOn"+idx).show();
			$("#boxOff"+idx).hide();
		}
		
		function helpAnswerCheck(idx) {
			let ans = confirm("전송하시겠습니까?");
			if(!ans) return;
			
			let answer = $("#answer"+idx).val();
			
			$.ajax({
				type: "post",
				url : "${ctp}/adHelpAnswer.ad",
				data: {hidx:idx,answer:answer},
				success: function(res) {
					if(res == '1') location.reload();
					else alert("답변 전송에 실패했습니다.");
				},
				error: function() {
					alert("전송 오류");
				}
			});
			
		}
		
  	function searchHelp() {
			let searchItem = $("#searchItem").val();
			let searching = $("#searching").val();
			if(searching.trim() == '') return;
			
			location.href = "${ctp}/adHelpSearch.ad?searching="+searching+"&searchItem="+searchItem+"&pag=${pag}&pageSize=${pageSize}";
		}
  	
  	$(function() {
			$("#searching").on('keydown', function(e){
				if(e.keyCode == 13) searchHelp();
			});
		});
  </script>
  <style>
  	.container {margin-left: 50px;}
  	th,td {
  		font-weight: 300;
  	}
  	.form-hidden {display: none;}
  	.form-hidden td {padding: 10px 0px; text-align: center;}
  	.offBox{display: none;}
  	.fixBox{
  		width: 800px;
  		overflow: hidden;
  		text-overflow: ellipsis;
  	}
  </style>
</head>
<body>
	<div class=" container mt-3">
		<div class="ml-3 mb-3" style="float: left">
			<select id="searchItem" name="searchItem">
				<option ${searchItem=='hidx' ? 'selected' : '' } value="hidx">문의글 번호</option>
				<option ${searchItem=='title' ? 'selected' : '' } value="title">제목</option>
				<option ${searchItem=='conf' ? 'selected' : '' } value="conf">답변상태</option>
				<option ${searchItem=='mid' ? 'selected' : '' } value="mid">아이디</option>
			</select>
			<input type="text" name="searching" id="searching" value="${searching}" />
			<input type="button" onclick="searchHelp()" value="검색" class="btn btn-sm btn-secondary" />
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
			<thead class="thead-dark"><tr><th colspan="6" class="title">문의글 현황</th></tr></thead>
			<tr><th colspan="3">총 문의 수</th><td colspan="3">${helpTot}개</td></tr>
			<tr><th colspan="3">답변완료</th><td colspan="3">${answerTot}개</td></tr>
			<tr><th colspan="3">답변대기중</th><td colspan="3">${noAnswerTot}개</td></tr>
			<thead class="thead-dark"><tr><th colspan="6" class="title">문의글 목록</th></tr></thead>
			<tr>
				<td>문의글 번호</td>
				<td>제목</td>
				<td>작성 아이디</td>
				<td>답변상태</td>
				<td>작성일</td>
				<td>답변</td>
			</tr>
			<c:forEach var="vo" items="${vos}" varStatus="st">
				<tr>
					<td class="align-middle">${vo.hidx}</td>
					<td class="align-middle" style="margin-top: ;">${vo.title}</td>
					<td class="align-middle">${vo.mid}</td>
					<td class="align-middle">${vo.conf == 'off' ? '답변대기중' : '답변완료'}</td>
					<td class="align-middle">${fn:substring(vo.writeDay,0,10)}<br/>${fn:substring(vo.writeDay,11,16)}</td>
					<td class="align-middle">
						<c:if test="${vo.conf == 'off'}">
							<input type="button" id="boxOn${vo.hidx}" onclick="helpBoxOn(${vo.hidx})" value="답변" class="btn btn-sm btn-warning"/>
						</c:if>
						<c:if test="${vo.conf != 'off'}">
							<input type="button" id="boxOn${vo.hidx}" onclick="helpBoxOn(${vo.hidx})" value="내용" class="btn btn-sm btn-success"/>
						</c:if>
						<input type="button" id="boxOff${vo.hidx}" onclick="helpBoxClose(${vo.hidx})" value="닫기" class="btn btn-sm btn-primary offBox"/>
					</td>
				</tr>
				<tr class="offBox box${vo.hidx}" >
					<td class="align-middle">내용</td>
					<td class="align-middle" colspan="4"><div class="fixBox ml-auto mr-auto">${vo.content}</div></td>
					<td class="align-middle" style="width: 137px;">${fn:substring(vo.writeDay,0,10)}<br/>${fn:substring(vo.writeDay,11,16)}</td>
				</tr>
				<c:if test="${vo.conf == 'off'}">
					<tr class="offBox box${vo.hidx}">
						<td class="align-middle" colspan="5"><textarea id="answer${vo.hidx}" name="answer${vo.hidx}" rows="7" class="form-control"></textarea></td>
						<td class="align-middle" style="width: 137px;"><input type="button" onclick="helpAnswerCheck(${vo.hidx});" value="답변 전송" class="btn btn-secondary"/></td>
					</tr>
				</c:if>
				<c:if test="${vo.conf != 'off'}">
					<tr class="offBox box${vo.hidx}">
						<td class="align-middle">답변 내용</td>
						<td class="align-middle" colspan="4"><div class="fixBox ml-auto mr-auto">${vo.answer}</div></td>
						<td class="align-middle" style="width: 137px;">${fn:substring(vo.writeDay,0,10)}<br/>${fn:substring(vo.writeDay,11,16)}</td>
					</tr>
				</c:if>
			</c:forEach>
			<tr><td colspan="7"></td></tr>
		</table>
		<div class="text-center">
		  <ul class="pagination justify-content-center">
		  	<c:if test="${empty searching}"><c:set var="adList" value="${ctp}/adHelpList.ad?pageSize=${pageSize}" /> </c:if>
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