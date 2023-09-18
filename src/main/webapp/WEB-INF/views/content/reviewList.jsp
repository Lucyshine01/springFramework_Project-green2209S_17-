<%@ page language="java" contentType="text/html; charset=UTF-8"
		pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>reviewList</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
<link href="${ctp}/viewPage/viewPage.css" rel="stylesheet"
		type="text/css">
<script>
	'use strict';
	let pag = ${pag};
	let totPage = ${totPage};
	let pageSize = ${pageSize};
	if(pageSize == '') pageSize = 10
	let bf_SearchItem = "${searchItem}";
	let bf_Searching = "${searching}";
	
	let orderBy = "${orderBy}";
	let order = "${order}";
	
	function orderByChange() {
		orderBy = $("#orderBy").val();
		if(bf_Searching != "")location.href = "${ctp}/member/reviewList?searching="+bf_Searching+"&searchItem="+bf_SearchItem+"&orderBy="+orderBy.split("/")[0]+"&order="+orderBy.split("/")[1]+"&pageSize="+pageSize;
		else location.href = "${ctp}/member/reviewList?orderBy="+orderBy.split("/")[0]+'&order='+orderBy.split("/")[1]+'&pageSize='+pageSize;
	}
	function pageSizeChange() {
		pageSize = $("#pageSize").val();
		if(bf_Searching != "")location.href = "${ctp}/member/reviewList?searching="+bf_Searching+"&searchItem="+bf_SearchItem+"&orderBy="+orderBy+"&order="+order+"&pageSize="+pageSize;
		else location.href = "${ctp}/member/reviewList?orderBy="+orderBy+'&order='+order+'&pageSize='+pageSize;
	}
	
	function searchingList() {
		let searchItem = $("#searchItem").val();
		let searching = $("#searching").val();
		if(searching.trim() == '') return;
		location.href = "${ctp}/member/reviewList?searching="+searching+"&searchItem="+searchItem+"&orderBy=${orderBy}&order=${order}&pageSize=${pageSize}";
	}
	
	$(function() {
		$("#searching").on('keydown', function(e){
			if(e.keyCode == 13) searchingList();
		});
	});
	
</script>
<style>
	.reviewTd {text-align: center; padding-top: 40px; padding-bottom: 40px}
	.td1 {border-right: 1px solid #ddd;}
	.td2 {border-right: 1px solid #ddd;}
	.td3 {width:50%;border-right: 1px solid #ddd;}
	.td4 {border-right: 1px solid #ddd;}
	.td5 {}
	.topTitle {
		font-size: 2em;
		font-weight: 500;
		font-family: 'Spoqa Han Sans Neo';
		text-align: center;
	}
</style>
</head>
<body ondragstart="return false">
	<jsp:include page="/WEB-INF/views/include/notice.jsp" />
	<div id="loading_Bar"></div>
	<c:if test="${empty sMid}"><jsp:include page="/WEB-INF/views/include/headTop.jsp"></jsp:include></c:if>
	<jsp:include page="/WEB-INF/views/include/header.jsp" />
	<div class="width" style="margin-top: 30px; margin-bottom: 30px">
		<div class="mr-auto ml-auto">
			<div class="text-center" style="font-size: 2.8em; font-weight: 600; margin-bottom: 10px;">
				후기 목록
			</div>
			<div class="text-center mb-4" style="color: #666; font-weight: 300">
				인테모아의 업체 이용 후기를 찾아보세요.<br/>업체 이름을 클릭하면 업체페이지로 이동합니다.
			</div>
			<div class="d-flex">
				<div class="mr-auto ml-2">
					목록수 : 
					<select id="pageSize" name="pageSize" onchange="pageSizeChange();" class="searchItemForm mr-1">
						<option ${pageSize == 10 ? 'selected' : '' } value="10">10개</option>
						<option ${pageSize == 20 ? 'selected' : '' } value="20">20개</option>
						<option ${pageSize == 50 ? 'selected' : '' } value="50">50개</option>
					</select>
				</div>
				<div class="ml-auto mr-2 mb-2 d-flex">
					<select id="searchItem" name="searchItem" class="searchItemForm mr-1">
						<option ${searchItem == 'cpName' ? 'selected' : ''} value="cpName">업체명</option>
						<option ${searchItem == 'content' ? 'selected' : ''} value="content">내용</option>
					</select>
					<input type="text" value="${searching}" name="searching" id="searching" class="searchingForm mr-1"/>
					<input type="button" onclick="searchingList()" id="searchbtn" value="검색" class="btn btn-sm btn-secondary mr-1"/>
				</div>
				<div class="mr-2">
					<select id="orderBy" onchange="orderByChange();" class="searchItemForm">
						<option ${orderBy == 'writeDay' ? (order == 'desc' ? 'selected' : '' ) : '' } value="writeDay/desc">최신 순</option>
						<option ${orderBy == 'writeDay' ? (order == 'asc' ? 'selected' : '' ) : '' } value="writeDay/asc">등록 순</option>
						<option ${orderBy == 'rating' ? (order == 'desc' ? 'selected' : '' )  : '' } value="rating/desc">별점 순</option>
					</select>
				</div>
			</div>
			<div style="border-bottom: 2px solid #d0d0d0;"></div>
			<table class="table">
				<tr>
					<td class="reviewTd">별점</td>
					<td class="reviewTd">업체</td>
					<td class="reviewTd">내용</td>
					<td class="reviewTd">작성일</td>
					<td class="reviewTd">아이디</td>
				</tr>
				<c:if test="${vos != null}">
					<c:forEach var="vo" items="${vos}" varStatus="st">
						<tr>
							<td class="reviewTd td1 align-middle" style="padding-right: 20px; padding-top: 40px; padding-bottom: 40px">
								<c:if test="${vo.rating == 0.0}">별점 없음</c:if>
								<c:if test="${vo.rating != 0.0}"><font size="2px">${vo.rating}</font><br/><img src="${ctp}/images/star/${vo.rating}.jpg" width="60px"/></c:if>
							</td>
							<td class="reviewTd td2 align-middle" style="fonpadding-right: 20px; padding-left: 20px; padding-top: 40px; padding-bottom: 40px">
								<a href="/green2209S_17/member/companyInfoView?no=${vo.cidx}" style="font-size: 16px; font-weight:700;">${vo.cpName}</a>
							</td>
							
							<td class="reviewTd td3 align-middle" style="padding-right: 20px; padding-left: 20px; padding-top: 40px; padding-bottom: 40px">
								${vo.content}
							</td>
							<td class="reviewTd td4 align-middle" style="padding-right: 20px; padding-left: 20px; padding-top: 40px; padding-bottom: 40px">
								<fmt:formatDate value="${vo.writeDay}" pattern="yyyy년 MM월 dd일" />
							</td>
							<td class="reviewTd td5 align-middle" style="padding-left: 20px; padding-top: 40px; padding-bottom: 40px">
								${vo.mid}
							</td>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${vos == null}">
					<tr>
						<td class="text-center" colspan="5">검색된 결과가 없습니다.</td>
					</tr>
				</c:if>
				<tr>
					<td colspan="5" style="padding: 0px"></td>
				</tr>
			</table>
			<div class="text-center mt-5">
			  <ul class="pagination justify-content-center">
			  	<c:if test="${empty searching}"><c:set var="REList" value="${ctp}/member/reviewList?pageSize=${pageSize}&orderBy=${orderBy}&order=${order}"/> </c:if>
			  	<c:if test="${!empty searching}"><c:set var="REList" value="${ctp}/member/reviewList?pageSize=${pageSize}&searching=${searching}&searchItem=${searchItem}&orderBy=${orderBy}&order=${order}"/></c:if>
			    <c:if test="${pageVO.pag > 1}">
			      <li class="page-item"><a class="page-link text-secondary" href="${REList}&pag=1">
			      	<i class="fa-solid fa-backward-fast"></i>
			      </a></li>
			    </c:if>
			    <c:if test="${pageVO.curBlock > 0}">
			      <li class="page-item"><a class="page-link text-secondary" href="${REList}&pag=${pageVO.pag - 1}">
			      	<i class="fa-solid fa-caret-left"></i>
			      </a></li>
			    </c:if>
			    <c:forEach var="i" begin="${(pageVO.curBlock)*pageVO.blockSize + 1}" end="${(pageVO.curBlock)*pageVO.blockSize + pageVO.blockSize}" varStatus="st">
			      <c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
			    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${REList}&pag=${i}">${i}</a></li>
			    	</c:if>
			      <c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
			    		<li class="page-item"><a class="page-link text-secondary" href="${REList}&pag=${i}">${i}</a></li>
			    	</c:if>
			    </c:forEach>
			    <c:if test="${pageVO.curBlock < pageVO.lastBlock}">
			      <li class="page-item"><a class="page-link text-secondary" href="${REList}&pag=${pageVO.pag + 1}">
			      	<i class="fa-solid fa-caret-right"></i>
			      </a></li>
			    </c:if>
			    <c:if test="${pageVO.pag < pageVO.totPage}">
			      <li class="page-item"><a class="page-link text-secondary" href="${REList}&pag=${pageVO.totPage}">
			      	<i class="fa-solid fa-forward-fast"></i>
			      </a></li>
			    </c:if>
			  </ul>
			</div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	<script src="${ctp}/viewPage/viewPage.js"></script>
</body>
</html>