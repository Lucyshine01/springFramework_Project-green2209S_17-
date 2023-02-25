<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>creditHistroy.jsp</title>
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
		/* tr td:nth-child(2) {width: 40%;} */
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
						<span class="ml-2 mb-2">결제번호</span>
						<input id="merchant_uid" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">결제방식</span>
						<input id="pay_method" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">화폐</span>
						<input id="currency" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">결제 아이디</span>
						<input id="buyer_name" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">결제 이메일</span>
						<input id="buyer_email" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">카드명</span>
						<input id="card_name" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">카드 번호</span>
						<input id="card_number" type="text" class="form-control mb-2" disabled/>
					</div>
					<div style="float: right; width: 49%;">
						<span class="ml-2 mb-2">상품명</span>
						<input id="name" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">결제금액</span><br/>
						<input id="paid_amount" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">pg-id</span>
						<input id="pg_tid" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">승인 url(영수증)</span>
						<input id="receipt_url" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">결제 상태</span>
						<input id="success" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">취소 사유</span>
						<input id="error_msg" type="text" class="form-control mb-2" disabled/>
						<span class="ml-2 mb-2">결제 일</span>
						<input id="buyDay" type="text" class="form-control mb-2" disabled/>
					</div>
				</div>
				<div class="modalClose" onclick="modalClose();" style="top: 0px;"><i class="fa-solid fa-xmark"></i></div>
				<div>
					<input onclick="modalClose();" type="button" value="확인" class="btn btn-warning form-control mt-5"/>
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
          <h1 class="mt-4 mb-4">결제 내역</h1>
          <div class="card mb-4">
            <div class="card-header">
              <i class="fas fa-table me-1"></i>
              결제 목록 테이블
            </div>
            <div class="card-body">
              <table id="datatablesSimple" class="text-center">
                <thead>
                  <tr>
                    <th><div>결제번호</div></th>
                    <th><div>구매 아이디</div></th>
                    <th><div>결제상태</div></th>
                    <th><div>취소 사유</div></th>
                    <th><div>결제일</div></th>
                    <th><div></div></th>
                  </tr>
                </thead>
                <tbody>
                	<c:forEach var="vo" items="${vos}" varStatus="st">
                		<tr>
                			<td>${vo.merchant_uid}</td>
                			<td>${vo.buyer_name}</td>
                			<td>${vo.success == 'true' ? '결제 완료' : '취소'}</td>
                			<td>${vo.error_msg}</td>
                			<td><fmt:formatDate value="${vo.buyDay}" pattern="yyyy/MM/dd"/></td>
                			<td><input type="button" value="상세보기" onclick="modalOn('${vo.idx}');" class="btn btn-sm btn-warning"/></td>
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
				url: "${ctp}/admin/getPaymentInfo",
				data: {idx : idx},
				success: function(data) {
					let idx = data.idx;
					let merchant_uid = data.merchant_uid;
					let pay_method = data.pay_method;
					let currency = data.currency;
					let buyer_name = data.buyer_name;
					let buyer_email = data.buyer_email;
					let card_name = data.card_name;
					let card_number = data.card_number;
					let name = data.name;
					let paid_amount = data.paid_amount;
					let pg_tid = data.pg_tid;
					let receipt_url = data.receipt_url;
					let success = data.success;
					if(success == 'true') success = '결제 완료';
					else success = '결제 취소';
					let date = new Date(data.buyDay);
					let buyDay = date.getFullYear()+"/"+date.getMonth()+"/"+date.getDay()+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();
					
					$("#idx").val(idx);
					$("#merchant_uid").val(merchant_uid);
					$("#pay_method").val(pay_method);
					$("#currency").val(currency);
					$("#buyer_name").val(buyer_name);
					$("#buyer_email").val(buyer_email);
					$("#card_name").val(card_name);
					$("#card_number").val(card_number);
					$("#name").val(name);
					$("#paid_amount").val(paid_amount);
					$("#pg_tid").val(pg_tid);
					$("#receipt_url").val(receipt_url);
					$("#success").val(success);
					$("#buyDay").val(buyDay);
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