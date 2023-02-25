<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>reportManage.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
	<link href="${ctp}/viewPage/viewPage.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
  <link href="${ctp}/css/templete/styles.css" rel="stylesheet" />
  <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
  <style>
  	.modalBack {
			background-color: #000;
			z-index: 11;
			opacity: 0.3;
			position: absolute;
			left: 0px;
			top: 0px;
		}
		th div {text-align: center;}
		#perPage {
			position: absolute;
			left: 80px;
			margin-top: 7px;
		}
  </style>
</head>
<body class="sb-nav-fixed">
	<div id="modal" class="modalCss">
		<div class="modalBack" onclick="modalClose();"></div>
		<div class="width" style="position: relative;">
			<div class="modalMain" style="width: 24%; left: 55%; padding-top: 20px;">
				<div class="mb-2">
					<div>
						<span class="ml-2 mb-2">정지 대상 아이디</span>
						<input id="replyMid" type="text" class="form-control mb-2" disabled/>
						정지 기간
						<select id="stopDay" class="form-control mb-2">
							<option value="1">1일 정지</option>
							<option value="3">3일 정지</option>
							<option value="7">1주 정지</option>
							<option value="14">2주 정지</option>
							<option value="30">1개월 정지</option>
							<option value="60">2개월 정지</option>
							<option value="90">3개월 정지</option>
							<option value="180">6개월 정지</option>
							<option value="365">1년 정지</option>
							<option value="999999">무기한 정지</option>
						</select>
					</div>
				</div>
				<div>
					<input onclick="userAccDisable()" type="button" value="적용" class="btn btn-warning form-control mt-5"/>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/admin/head.jsp"></jsp:include>
	<div id="layoutSidenav">
		<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"></jsp:include>
    <div id="layoutSidenav_content">
      <main>
        <div class="container-fluid px-4">
          <h1 class="mt-4 mb-4">신고내역 관리</h1>
          <div class="card mb-4">
            <div class="card-header">
              <i class="fas fa-table me-1"></i>
              신고 목록 테이블
            </div>
            <div class="card-body">
              <table id="datatablesSimple" class="text-center">
                <thead>
                  <tr>
                    <th><div>댓글 아이디</div></th>
                    <th><div>내용</div></th>
                    <th><div>신고 사유</div></th>
                    <th><div>신고 아이디</div></th>
                    <th><div>댓글 작성일</div></th>
                    <th><div>신고일</div></th>
                    <th><div>처분</div></th>
                  </tr>
                </thead>
                <tbody>
                	<c:forEach var="vo" items="${vos}" varStatus="st">
                		<tr>
                			<td>${vo.replyMid}</td>
                			<td>${vo.replyContent}</td>
                			<td>${vo.reason}</td>
                			<td>${vo.reportMid}</td>
                			<td><fmt:formatDate value="${vo.replyWriteDay}" pattern="yyyy/MM/hh"/></td>
                			<td><fmt:formatDate value="${vo.reportWriteDay}" pattern="yyyy/MM/hh"/></td>
                			<td><input type="button" value="처리" onclick="modalOn('${vo.replyMid}');" class="btn btn-sm btn-warning"/></td>
                		</tr>
                	</c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </main>
      <footer class="py-4 bg-light mt-auto">
        <div class="container-fluid px-4">
          <div class="d-flex align-items-center justify-content-between small">
          	<div></div>
            <div class="text-muted">Copyright&copy;2022 InTeMoa. All rights reserved.</div>
          </div>
        </div>
      </footer>
    </div>
	</div>
	<script src="${ctp}/js/templete/datatables-simple-demo.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" crossorigin="anonymous"></script>
	<script>
		'use strict';
		let view = null;
		
		
		function modalOn(mid) {
			$("#replyMid").val(mid);
			$("#modal").show();
			$("#modal").animate({opacity:"1"},200);
		}
		
		function modalClose() {
			$(".modalCss").hide();
			$(".modalCss").css("opacity","0");
		}
		
		function userAccDisable() {
			let ans = confirm("정말 해당 회원을 정지처분 하겠습니까?");
			if(!ans) return;
			
			let replyMid = $("#replyMid").val();
			let stopDay = $("#stopDay").val();
			stopDay = Number(stopDay);
			
			let now = new Date();
			let now2 = new Date(
					now.getFullYear(),
					now.getMonth()+1,
					now.getDate() + stopDay
			);
			
			stopDay = now2.getFullYear()+"-"+now2.getMonth()+"-"+now2.getDate();
			
			let query = {
					replyMid:replyMid,
					stopDay:stopDay
			}
			
			$.ajax({
				type: "post",
				url: "${ctp}/admin/userAccDisable",
				data: query,
				success: function(res) {
					if(res == '1'){
						alert("수정 완료");
						location.reload();
					}
					else alert("수정 실패");
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
		
		$(function() {
			let deviceWidth = screen.width;
			let deviceHeight = document.body.offsetHeight;
		  $(".modalBack").css("width", deviceWidth + "px");
		  $(".modalBack").css("height", deviceHeight + "px");
		});
		
		window.onload = function() {
			let perPage = '<span id="perPage" class="ml-2 text-dark">&nbsp;페이지 당 표시 수</span>';
			$(".datatable-top .datatable-dropdown label:not(select)").css("color","#fff");
			$(".datatable-top .datatable-dropdown label").append(perPage);
			$(".datatable-top .datatable-dropdown label select").append("<option value='50'>50</option>");
			$(".datatable-top .datatable-dropdown label select").append("<option value='100'>100</option>");
			$(".datatable-top .datatable-dropdown label select").append("<option value='200'>200</option>");
			$(".datatable-top .datatable-dropdown label select").attr("onchange","changeView();");
			$(".datatable-pagination-list-item").attr("onclick","changeViewLive();");
			let search = '<input class="datatable-input" placeholder="내용 검색"'
			search +='type="search" title="Search within table" aria-controls="datatablesSimple">'
			$(".datatable-search").html(search);
			changeView();
		};
		
		function changeView() {
			let viewText = $(".datatable-info").html();
			viewText = viewText.replace("Showing ","");
			let firstCnt = viewText.split(' to ')[0];
			let lastCnt = viewText.split(' to ')[1].split(' of ')[0];
			let totCnt = viewText.split(' to ')[1].split(' of ')[1].replace(" entries","");
			$(".datatable-info").html(firstCnt + "번 ~ " + lastCnt + "번 자료 조회중 - 총 자료수 : " + totCnt + "개");
			$(".datatable-pagination-list-item-link").attr("onclick","changeViewLive();");
			$(".datatable-pagination-list-item-link").attr("onclick","changeViewLive();");
			if(view != null) clearTimeout(view);
		}
		function changeViewLive() {
			view = setTimeout(changeView,10);
		}
		
	</script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="${ctp}/js/templete//scripts.js"></script>
</body>
</html>