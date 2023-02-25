<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>userManage.jsp</title>
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
						<input id="mid" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">이메일</span>
						<input id="email" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">생일</span>
						<input id="birth" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">전화번호</span>
						<input id="tel" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">가입일</span>
						<input id="createDay" type="text" class="form-control mb-2" disabled/>
					</div>
					<div style="float: right; width: 49%;">
						<span class="ml-2 mb-2">회원 구분</span>
						<input id="userLevel" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">보유 포인트</span>
						<input id="point" type="text" class="form-control mb-2"/>
						<span class="ml-2 mb-2">프로필</span><br/>
						<div class="d-flex"><img id="profile" class="ml-auto mr-auto mb-2" width="100px"/><br/></div>
						<span class="ml-2 mb-2">상태 변경</span>
						<select id="act" class="form-control mb-2">
							<option value="on">활동</option>
							<option value="off">정지</option>
							<option value="del">삭제</option>
						</select>
						<span class="ml-2 mb-2">정지 기간</span>
						<input id="stopDate" type="date" class="form-control mb-2" disabled="disabled" />
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
          <h1 class="mt-4 mb-4">회원 관리</h1>
          <div class="card mb-4">
            <div class="card-header">
              <i class="fas fa-table me-1"></i>
              회원 목록 테이블
            </div>
            <div class="card-body">
              <table id="datatablesSimple" class="text-center">
                <thead>
                  <tr>
                    <th><div>아이디</div></th>
                    <th><div>이메일</div></th>
                    <th><div>생일</div></th>
                    <th><div>전화번호</div></th>
                    <th><div>회원 구문</div></th>
                    <th><div>가입일</div></th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                	<c:forEach var="vo" items="${vos}" varStatus="st">
                		<tr>
                			<td>${vo.mid}</td>
                			<td>${vo.email}</td>
                			<td><fmt:formatDate value="${vo.birth}" pattern="yyyy/MM/hh"/></td>
                			<td>${vo.tel}</td>
                			<td>${vo.userLevel}</td>
                			<td><fmt:formatDate value="${vo.createDay}" pattern="yyyy/MM/hh"/></td>
                			<td><input type="button" value="상세보기" onclick="modalOn('${vo.mid}');" class="btn btn-sm btn-warning"/></td>
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
			$.ajax({
				type: "post",
				url: "${ctp}/admin/getUserInfo",
				data: {mid : mid},
				success: function(data) {
					let idx = data.idx;
					let mid = data.mid;
					let email = data.email;
					let date = new Date(data.birth);
					let birth = date.getFullYear()+"/"+date.getMonth()+"/"+date.getDay()+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();;
					let tel = data.tel;
					let userLevel = data.userLevel;
					let point = data.point;
					date = new Date(data.createDay);
					let createDay = date.getFullYear()+"/"+date.getMonth()+"/"+date.getDay()+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();
					let accStop = null
					if(data.accStop != null) {
						date = new Date(data.accStop);
					  let MM = (date.getMonth()+1)+"";
					  let dd = date.getDate()+"";
					  if(MM.length == 1) MM = "0" + MM;
					  if(dd.length == 1) dd = "0" + dd;
						accStop = date.getFullYear()+"-"+MM+"-"+dd;
					}
					let profile = '${ctp}/images/profile/' + data.profile;
					
					$("#idx").val(idx);
					$("#mid").val(mid);
					$("#email").val(email);
					$("#birth").val(birth);
					$("#tel").val(tel);
					$("#userLevel").val(userLevel);
					$("#point").val(point);
					$("#createDay").val(createDay);
					$("#profile").attr("src",profile);
					if(accStop != null) {
						document.getElementById("stopDate").disabled = false;
						$("#stopDate").val(accStop);
					}
					else {
						$("#stopDate").val('');
						document.getElementById("stopDate").disabled = true;
					}
					
					let act = 'on';
					if(data.accStop != null) act = 'off';
					if(data.pwd == '') act = 'del';
					$("#act").val(act).prop("selected",true);
					
					$("#updateBtn").attr("onclick","updateUserInfo('"+idx+"')");
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
		
		function updateUserInfo(idx) {
			let query = {
					idx: idx,
					point: $("#point").val(),
					accStop: $("#stopDate").val(),
					act: $("#act").val()
			}
			
			if($("#act").val() == 'del') {
				let ans = confirm("정말 해당 회원계정을 삭제처리 하시겠습니까?");
				if(!ans) return;
			}
			if($("#act").val() == 'off') {
				if($("#stopDate").val() == '') {
					alert("정지 기간을 설정하세요.")
					return;
				}
			}
			
			$.ajax({
				type: "post",
				url: "${ctp}/admin/updateUserInfo",
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
				
				if($("#act").val()=='off') document.getElementById("stopDate").disabled = false;
				else document.getElementById("stopDate").disabled = true;
			});
		  
		  let date = new Date();
		  let MM = (date.getMonth()+1)+"";
		  let dd = date.getDate()+"";
		  if(MM.length == 1) MM = "0" + MM;
		  if(dd.length == 1) dd = "0" + dd;
		  $("#stopDate").attr("min",date.getFullYear()+"-"+MM+"-"+dd);
		  
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