<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>helpManage.jsp</title>
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
			<div class="modalMain" style="width: 40%; left: 55%; padding-top: 20px;">
				<div class="mb-2">
					<div style="float: left; width: 49%;">
						<span class="ml-2 mb-2">DB 번호</span>
						<input id="idx" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">아이디</span>
						<input id="mid" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">작성일</span>
						<input id="writeDay" type="text" class="form-control mb-2" disabled/>
					</div>
					<div style="float: right; width: 49%;">
						<span class="ml-2 mb-2">별점</span>
						<input id="rating" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">내용</span>
						<textarea id="content" class="form-control mb-2" rows="4" disabled></textarea>
					</div>
				</div>
				<div>
					<input type="button" id="correctBtn" value="확인" class="btn btn-warning form-control mt-5"/>
					<input type="button" id="removeBtn" value="삭제처리" class="btn btn-danger form-control mt-2"/>
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
          <h1 class="mt-4 mb-4">후기 관리</h1>
          <div class="card mb-4">
            <div class="card-header">
              <i class="fas fa-table me-1"></i>
              후기 목록 테이블
            </div>
            <div class="card-body">
              <table id="datatablesSimple" class="text-center">
                <thead>
                  <tr>
                    <th><div>후기 번호</div></th>
                    <th><div>내용</div></th>
                    <th><div>별점</div></th>
                    <th><div>아이디</div></th>
                    <th><div>작성일</div></th>
                    <th><div>처리</div></th>
                  </tr>
                </thead>
                <tbody>
                	<c:forEach var="vo" items="${vos}" varStatus="st">
                		<tr>
                			<td>${vo.idx}</td>
                			<td>${vo.content}</td>
                			<td>${vo.rating}</td>
                			<td>${vo.mid}</td>
                			<td><fmt:formatDate value="${vo.writeDay}" pattern="yyyy/MM/hh"/></td>
                			<td><input type="button" value="상세" onclick="modalOn(${vo.idx});" class="btn btn-sm btn-warning"/></td>
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
		
		function modalOn(idx) {
			$.ajax({
				type: "post",
				url: "${ctp}/admin/replyInfo",
				data: {idx:idx},
				success: function(data) {
					let idx = data.idx;
					let mid = data.mid;
					let content = data.content;
					let rating = data.rating;
					let date = new Date(data.writeDay);
					let writeDay = date.getFullYear()+"/"+date.getMonth()+"/"+date.getDay()+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();
					
					$("#idx").val(idx);
					$("#mid").val(mid);
					$("#content").val(content.replaceAll('<br/>','\n'));
					$("#rating").val(rating);
					$("#writeDay").val(writeDay);
					
					$("#removeBtn").attr("onclick","removeReply("+idx+")");
					
				},
				error: function() {
					alert("전송 오류");
				}
			});
			
			$("#modal").show();
			$("#modal").animate({opacity:"1"},200);
		}
		
		$("#correctBtn").click(function() {
			$(".modalCss").hide();
			$(".modalCss").css("opacity","0");
		});
		
		function modalClose() {
			$(".modalCss").hide();
			$(".modalCss").css("opacity","0");
		}
		
		function removeReply(idx) {
			let ans = confirm("정말 해당 댓글을 삭제하겠습니까?");
			if(!ans) return;
			
			$.ajax({
				type: "post",
				url: "${ctp}/admin/removeReply",
				data: {idx:idx},
				success: function(res) {
					if(res == '1'){
						alert("삭제 완료");
						location.reload();
					}
					else alert("삭제 실패");
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