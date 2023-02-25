<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>companyList.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="${ctp}/viewPage/viewPage.css" rel="stylesheet" type="text/css">
  <script>
	  'use strict';
		let pag = ${pag};
		let totPage = ${totPage};
		let pageSize = ${pageSize};
		let bf_SearchItem = "${searchItem}";
		let bf_Searching = "${searching}";
		
		function searchingList() {
			let searchItem = $("#searchItem").val();
			let searching = $("#searching").val();
			if(searching.trim() == '') return;
			location.href = "${ctp}/member/companyList?searching="+searching+"&searchItem="+searchItem+"&orderBy=${orderBy}&order=${order}&pag=${pag}&pageSize=${pageSize}&categori=${categori}&detail=${detail}";
		}
		function orderByChange() {
			let orderBy = $("#orderBy").val();
			if(bf_Searching != ""){
				location.href = "${ctp}/member/companyList?searching="+bf_Searching+"&searchItem="+bf_SearchItem+"&orderBy="+orderBy.split("/")[0]+'&order='+orderBy.split("/")[1]+'&pageSize='+pageSize+"&categori=${categori}&detail=${detail}";
			}
			else location.href = "${ctp}/member/companyList?orderBy="+orderBy.split("/")[0]+'&order='+orderBy.split("/")[1]+'&pageSize='+pageSize+"&categori=${categori}&detail=${detail}";
		}
		
		$(function() {
			$("#searching").on('keydown', function(e){
				if(e.keyCode == 13) searchingList();
			});
		});
  </script>
  <style>
  	.searchItemForm {
  		outline: none;
  		border: 1px solid #ccc;
  		padding: 3px;
   	}
   	.searchingForm {
   		outline: none;
   		border: 1px solid #ccc;
   		padding: 5px 8px;
   		border-radius: 4px;
   	}
   	#searchbtn {
   		padding: 7px 12px 5px 12px;
   		margin-bottom: 1px;
   	}
  </style>
</head>
<body ondragstart="return false" onselectstart="return false">
	<jsp:include page="/WEB-INF/views/include/notice.jsp"></jsp:include>
	<div id="loading_Bar"></div>
	<c:if test="${empty sMid}"><jsp:include page="/WEB-INF/views/include/headTop.jsp"></jsp:include></c:if>
	<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
	<div class="width" style="margin-top: 50px;">
		<div class="row">
			<div class="col-3">
				<div class="side-Menu">
					<div class="mb-3 ml-2" style="font-size: 1.7em; font-weight: 500;">
						<c:if test="${categori == 'all'}">카테고리</c:if>
						<c:if test="${categori != 'all'}">${categoriName}</c:if>
					</div>
					<div style="border-bottom: 2px solid #fc3; margin-bottom: 20px"></div>
	        <div class="first-class"><a href="${ctp}/member/companyList?categori=1">인테리어</a></div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=1&detail=1'">홈 인테리어</div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=1&detail=2'">상업공간 인테리어</div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=1&detail=3'">조명 인테리어</div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=1&detail=4'">욕실/화장실 리모델링</div>
	        <div class="first-class"><a href="${ctp}/member/companyList?categori=2">시공</a></div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=2&detail=1'">타일시공</div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=2&detail=2'">페인트시공</div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=2&detail=3'">싱크대 교체</div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=2&detail=4'">도배장판 시공</div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=2&detail=5'">인테리어 필름 시공</div>
	        <div class="first-class"><a href="${ctp}/member/companyList?categori=3">디자인</a></div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=3&detail=1'">도면 제작·수정</div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=3&detail=2'">인테리어 컨설팅</div>
	        <div class="second-class" onclick="location.href='${ctp}/member/companyList?categori=3&detail=3'">3D 모델링</div>
	       </div>
			</div>
			<div class="col-9">
				<div class="main-content">
					<div class="topCategori">
						<c:if test="${empty categori}">
							<a href="${ctp}/member/companyList">전체목록</a>
						</c:if>
						<c:if test="${!empty categori}">
							<a href="${ctp}/member/companyList">업체목록</a>&nbsp;>&nbsp;
							<a href="${ctp}/member/companyList?categori=${categori}">${categoriName}</a>
							<c:if test="${!empty subCategori}">
								&nbsp;>&nbsp;<a href="${ctp}/member/companyList?categori=${categori}&detail=${detail}">${subCategori}</a>
							</c:if>
						</c:if>
					</div>
					<c:if test="${empty searching}"><div class="topTitle">인테모아 업체목록</div></c:if>
					<c:if test="${!empty searching}"><div class="topTitle">업체 검색</div></c:if>
					<div class="d-flex">
						<div class="ml-auto mr-2 mb-2 d-flex">
							<select id="searchItem" name="searchItem" class="searchItemForm mr-1">
								<option ${searchItem == 'all' ? 'selected' : ''} value="all">전체</option>
								<option ${searchItem == 'cpName' ? 'selected' : ''} value="cpName">회사명</option>
								<option ${searchItem == 'name' ? 'selected' : ''} value="name">대표명</option>
								<option ${searchItem == 'cpIntro' ? 'selected' : ''} value="cpIntro">소개</option>
							</select>
							<input type="text" value="${searching}" name="searching" id="searching" class="searchingForm mr-1"/>
							<input type="button" onclick="searchingList();" id="searchbtn" value="검색" class="btn btn-sm btn-secondary mr-1"/>
						</div>
						<div class="mr-2">
							<select id="orderBy" onchange="orderByChange();" class="searchItemForm">
								<option ${orderBy == 'createDayCP' ? (order == 'desc' ? 'selected' : '' ) : '' } value="createDayCP/desc">최신 순</option>
								<option ${orderBy == 'createDayCP' ? (order == 'asc' ? 'selected' : '' ) : '' } value="createDayCP/asc">등록 순</option>
								<option ${orderBy == 'viewCP' ? (order == 'desc' ? 'selected' : '' ) : '' } value="viewCP/desc">조회수 순</option>
								<option ${orderBy == 'rating' ? (order == 'desc' ? 'selected' : '' )  : '' } value="rating/desc">별점 순</option>
								<option ${orderBy == 'reviewCnt' ? (order == 'desc' ? 'selected' : '' )  : '' } value="reviewCnt/desc">리뷰수 순</option>
							</select>
						</div>
					</div>
					<div style="border-bottom: 2px solid #d0d0d0;"></div>
				</div>
				<div class="d-flex" style="flex-wrap: wrap">
					<c:if test="${vos == null}">
						<div class="ml-auto mr-auto" style="font-size: 1.1em; color: #333; margin-top: 200px">검색된 결과가 없습니다.</div>
					</c:if>
					<c:forEach var="vo" items="${vos}" varStatus="st">
						<div onclick="location.href='${ctp}/member/companyInfoView?no=${vo.idx}'" class="d-flex" style="width: 33%; height: 330px; flex-direction: column;">
							<div class="d-flex justify-content-center cpItemBox" style="height: 212px">
								<img src="${ctp}/images/cpProfile/${imgVOS[st.index].cpImg}" width="80%" height="auto" style="object-fit: contain">
							</div>
							<div class="text-center">
								<div class="ml-auto mr-auto cpItemText" style="width: 80%; font-size: 1.05em;">${vo.cpName}</div>
								<div class="ml-auto mr-auto cpItemText" style="width: 90%; color: #bbb; font-size:0.9em; font-weight: 300;">
									${fn:substring(fn:replace(vo.cpIntro,'<br/>',''),0,40)}
									<c:if test="${fn:length(fn:replace(vo.cpIntro,'<br/>','')) > 40}">...</c:if>
								</div>
								<div><img src="${ctp}/images/star/<fmt:formatNumber value="${(vo.starAvg - (vo.starAvg % 0.5))}" pattern="0.0"/>.jpg" width="60px"/><fmt:formatNumber value="${vo.starAvg}" pattern="0.0" /></div>
							</div>
						</div>
					</c:forEach>
				</div>
				<div class="text-center mt-5">
				  <ul class="pagination justify-content-center">
				  	<c:if test="${empty searching}"><c:set var="CPList" value="${ctp}/member/companyList?pageSize=${pageSize}&categori=${categori}&detail=${detail}&orderBy=${orderBy}&order=${order}"/> </c:if>
				  	<c:if test="${!empty searching}"><c:set var="CPList" value="${ctp}/member/companyList?pageSize=${pageSize}&searching=${searching}&searchItem=${searchItem}&categori=${categori}&detail=${detail}&orderBy=${orderBy}&order=${order}"/></c:if>
				    <c:if test="${pageVO.pag > 1}">
				      <li class="page-item"><a class="page-link text-secondary" href="${CPList}&pag=1">
				      	<i class="fa-solid fa-backward-fast"></i>
				      </a></li>
				    </c:if>
				    <c:if test="${pageVO.curBlock > 0}">
				      <li class="page-item"><a class="page-link text-secondary" href="${CPList}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">
				      	<i class="fa-solid fa-caret-left"></i>
				      </a></li>
				    </c:if>
				    <c:forEach var="i" begin="${(pageVO.curBlock)*pageVO.blockSize + 1}" end="${(pageVO.curBlock)*pageVO.blockSize + pageVO.blockSize}" varStatus="st">
				      <c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
				    		<li class="page-item active"><a class="page-link bg-secondary border-secondary" href="${CPList}&pag=${i}">${i}</a></li>
				    	</c:if>
				      <c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
				    		<li class="page-item"><a class="page-link text-secondary" href="${CPList}&pag=${i}">${i}</a></li>
				    	</c:if>
				    </c:forEach>
				    <c:if test="${pageVO.curBlock < pageVO.lastBlock}">
				      <li class="page-item"><a class="page-link text-secondary" href="${CPList}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">
				      	<i class="fa-solid fa-caret-right"></i>
				      </a></li>
				    </c:if>
				    <c:if test="${pageVO.pag < pageVO.totPage}">
				      <li class="page-item"><a class="page-link text-secondary" href="${CPList}&pag=${pageVO.totPage}">
				      	<i class="fa-solid fa-forward-fast"></i>
				      </a></li>
				    </c:if>
				  </ul>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script src="${ctp}/viewPage/viewPage.js"></script>
</body>
</html>