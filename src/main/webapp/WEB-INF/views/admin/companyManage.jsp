<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>companyManage.jsp</title>
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
			<div class="modalMain" style="width: 70%; left: 55%;">
				<div class="mb-2">
					<div style="float: left; width: 49%;">
						<span class="ml-2 mb-2">DB 번호</span>
						<input id="idx" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">아이디</span>
						<input id="mid" type="text" class="form-control mb-2"/>
						<span class="ml-2 mb-2">회사명</span>
						<input id="cpName" type="text" class="form-control mb-2"/>
						<span class="ml-2 mb-2">대표명</span>
						<input id="name" type="text" class="form-control mb-2"/>
						<span class="ml-2 mb-2">주소</span>
						<input id="cpAddr" type="text" class="form-control mb-2"/>
						<span class="ml-2 mb-2">가입일</span>
						<input id="createDayCP" type="text" class="form-control mb-2" disabled/>
					</div>
					<div style="float: right; width: 49%;">
						<span class="ml-2 mb-2">페이지 조회수</span>
						<input id="viewCP" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">홈페이지</span>
						<input id="cpHomePage" type="text" class="form-control mb-2"/>
						<span class="ml-2 mb-2">소개</span>
						<textarea id="cpIntro" class="form-control mb-2" rows="4" ></textarea>
						<span class="ml-2 mb-2">분야</span>
						<input id="cpExp" type="text" class="form-control mb-2"/>
						<span class="ml-2 mb-2">현재 상태</span>
						<select id="act" class="form-control">
							<option value="on">활동중</option>
							<option value="off">정지</option>
						</select>
					</div>
				</div>
				<div class="modalClose" onclick="modalClose();" style="top: 0px;"><i class="fa-solid fa-xmark"></i></div>
				<div>
					<input id="updateBtn" type="button" value="변경" class="btn btn-warning form-control mt-5" disabled/>
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
          <h1 class="mt-4 mb-4">업체 관리</h1>
          <div class="card mb-4">
            <div class="card-header">
              <i class="fas fa-table me-1"></i>
              업체 목록 테이블
            </div>
            <div class="card-body">
              <table id="datatablesSimple" class="text-center">
                <thead>
                  <tr>
                    <th><div>회사명</div></th>
                    <th><div>대표명</div></th>
                    <th><div>계정</div></th>
                    <th><div>업체가입일</div></th>
                    <th><div>현재 활동</div></th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                	<c:forEach var="vo" items="${vos}" varStatus="st">
                		<tr>
                			<td>${vo.cpName}</td>
                			<td>${vo.name}</td>
                			<td>${vo.mid}</td>
                			<td><fmt:formatDate value="${vo.createDayCP}" pattern="yyyy/MM/hh"/></td>
                			<td>${vo.act == 'on' ? '활동중' : '활동 중지' }</td>
                			<td><input type="button" value="상세보기" onclick="modalOn(${vo.idx});" class="btn btn-sm btn-warning"/></td>
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
				url: "${ctp}/admin/getCpDetailInfo",
				data: {idx : idx},
				success: function(data) {
					let idx = data.idx;
					let name = data.name;
					let cpName = data.cpName;
					let cpAddr = data.cpAddr;
					let cpHomePage = data.cpHomePage;
					let cpIntro = data.cpIntro.replaceAll('<br/>','\n');
					let cpExp = data.cpExp;
					let mid = data.mid;
					let date = new Date(data.createDayCP);
					let createDayCP = date.getFullYear()+"/"+date.getMonth()+"/"+date.getDay()+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();
					let viewCP = data.viewCP;
					let act = data.act;
					
					$("#idx").val(idx);
					$("#name").val(name);
					$("#cpName").val(cpName);
					$("#cpAddr").val(cpAddr);
					$("#cpHomePage").val(cpHomePage);
					$("#cpIntro").val(cpIntro);
					$("#cpExp").val(cpExp);
					$("#mid").val(mid);
					$("#createDayCP").val(createDayCP);
					$("#viewCP").val(viewCP);
					$("#act").val(act).prop("selected",true);
					
					$("#updateBtn").attr("onclick","updateCpInfo('"+idx+"')");
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
		
		function updateCpInfo(idx) {
			let query = {
					idx: idx,
					name: $("#name").val(),
					cpName: $("#cpName").val(),
					cpAddr: $("#cpAddr").val(),
					cpHomePage: $("#cpHomePage").val(),
					cpIntro: $("#cpIntro").val(),
					cpExp: $("#cpExp").val(),
					mid: $("#mid").val(),
					act: $("#act").val()
			}
			$.ajax({
				type: "post",
				url: "${ctp}/admin/updateCpInfo",
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
		  $(".modalMain input[type=text],textarea").on("propertychange change paste input",function() {
				document.getElementById("updateBtn").disabled = false;
			});
		  $("#act").on("change",function() {
				document.getElementById("updateBtn").disabled = false;
			});
		  
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