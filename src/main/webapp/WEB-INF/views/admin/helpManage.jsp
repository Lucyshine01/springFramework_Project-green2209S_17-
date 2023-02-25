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
			<div class="modalMain" style="width: 60%; left: 55%; padding-top: 20px;">
				<div class="mb-2">
					<div>
						<span class="ml-2 mb-2">문의 제목</span>
						<input id="title" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">내용</span>
						<textarea id="content" type="text" class="form-control mb-2" disabled></textarea>
						<span class="ml-2 mb-2">답변</span>
						<textarea id="answer" type="text" class="form-control mb-2"></textarea>
					</div>
				</div>
				<div>
					<input type="button" id="helpBtn" value="답변 완료" class="btn btn-warning form-control mt-5"/>
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
                    <th><div>문의 번호</div></th>
                    <th><div>제목</div></th>
                    <th><div>아이디</div></th>
                    <th><div>문의일</div></th>
                    <th><div>답변 상태</div></th>
                    <th><div>답변일</div></th>
                    <th><div>상세보기</div></th>
                  </tr>
                </thead>
                <tbody>
                	<c:forEach var="vo" items="${vos}" varStatus="st">
                		<tr>
                			<td>${vo.idx}</td>
                			<td>${vo.title}</td>
                			<td>${vo.mid}</td>
                			<td><fmt:formatDate value="${vo.writeDay}" pattern="yyyy/MM/hh"/></td>
                			<td>${vo.conf == 'off' ? '대기중' : '답변 완료'}</td>
                			<td><c:if test="${!empty vo.answerDay}"><fmt:formatDate value="${vo.answerDay}" pattern="yyyy/MM/hh"/></c:if></td>
                			<td><input type="button" value="답변" onclick="modalOn(${vo.idx});" class="btn btn-sm btn-warning"/></td>
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
				url: "${ctp}/admin/helpInfo",
				data: {idx:idx},
				success: function(data) {
					let title = data.title;
					let content = data.content;
					
					$("#title").val(title);
					$("#content").val(content);
					
					if(data.answer == '' || data.answer == null) {
						$("#answer").val('');
						$("#helpBtn").attr("onclick","helpAnswerComplete("+idx+")");
						document.getElementById("answer").disabled = false;
						return;
					}
					else {
						$("#answer").val(data.answer);
						document.getElementById("answer").disabled = true;
						document.getElementById("helpBtn").disabled = true;
					}
					
				},
				error: function() {
					alert("전송 오류");
				}
			});
			
			$("#modal").show();
			$("#modal").animate({opacity:"1"},200);
		}
		
		function modalClose() {
			$(".modalCss").hide();
			$(".modalCss").css("opacity","0");
		}
		
		function helpAnswerComplete(idx) {
			let ans = confirm("문의 답변을 완료 하시겠습니까?");
			if(!ans) return;
			
			let answer = $("#answer").val();
			let query = {
					idx : idx,
					answer : answer
			}
			
			$.ajax({
				type: "post",
				url: "${ctp}/admin/helpAnswer",
				data: query,
				success: function(res) {
					if(res == '1'){
						alert("답변 완료");
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