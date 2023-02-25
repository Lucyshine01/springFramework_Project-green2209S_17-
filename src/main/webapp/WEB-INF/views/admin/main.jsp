<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>main.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
	<link href="${ctp}/viewPage/viewPage.css" rel="stylesheet" type="text/css">
	<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
  <link href="${ctp}/css/templete/styles.css" rel="stylesheet" />
  <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
  <script type="text/javascript">
  	'use strict';
  	let now = new Array(13);
  	let nowDate = new Date();
  	
  	for(let i=-10; i<=0; i++){
  		let newDate = new Date(
  				nowDate.getFullYear(),
  				nowDate.getMonth()+1+i,
  		)
  		now[i+10] = newDate.getMonth()+1 + "월";
  	}
  	var chartLabels = [now[0], now[1], now[2], now[3], now[4], now[5], now[6], now[7], now[8], now[9]];
  	var chartData = [ <c:forEach var="totVo" items="${userTotVos}" varStatus="st" >${totVo}
												<c:if test="${fn:length(userTotVos) != st.count}">,</c:if>
											</c:forEach>]
  	var chartMax = 20;
  	
  	
  	var barLabels = [now[4], now[5], now[6], now[7], now[8], now[9]];
  	var barData = [	<c:forEach var="totVo" items="${cpTotVos}" varStatus="st" >${totVo}
											<c:if test="${fn:length(userTotVos) != st.count}">,</c:if>
										</c:forEach> ];
  	var barMax = 30;
  </script>
	<style>
  	.cardTitle {font-size: 1.6em; font-weight:bolder; text-align: center;}
  	.card-footer .big {font-size: 1.3em; margin-left: auto; margin-right: auto;}
		th div {text-align: center;}
		tr td:nth-child(2) {width: 40%;}
		#perPage {
			position: absolute;
			left: 80px;
			margin-top: 7px;
		}
  </style>
</head>
<body class="sb-nav-fixed">
	<jsp:include page="/WEB-INF/views/admin/head.jsp"></jsp:include>
	<div id="layoutSidenav">
		<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"></jsp:include>
    <div id="layoutSidenav_content">
      <main>
        <div class="container-fluid px-4">
          <h1 class="mt-4">통계창</h1>
          <ol class="breadcrumb mb-4">
            <li class="breadcrumb-item active">관리자 메인</li>
          </ol>
          <div class="row">
            <div class="col-xl-3 col-md-6">
              <div class="card bg-info text-white mb-4">
                <div class="card-body cardTitle">종합 회원수</div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                  <div class="big text-white pt-2 pb-2">${userTot}명</div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card bg-primary text-white mb-4">
                <div class="card-body cardTitle">총 업체수</div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                  <div class="big text-white pt-2 pb-2">${cpTot} 업체</div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card bg-danger text-white mb-4">
                <div class="card-body cardTitle">답변 대기 문의</div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                  <div class="big text-white pt-2 pb-2">${helpTot}건</div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-md-6">
              <div class="card bg-secondary text-white mb-4">
                <div class="card-body cardTitle">신고 처리 문의</div>
                <div class="card-footer d-flex align-items-center justify-content-between">
                  <div class="big text-white pt-2 pb-2">${reportTot}건</div>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-xl-6">
              <div class="card mb-4">
                <div class="card-header">
                  <i class="fas fa-chart-area me-1"></i>
                  월별 가입자 수
                </div>
                <div class="card-body"><canvas id="chatView" width="100%" height="40"></canvas></div>
              </div>
            </div>
            <div class="col-xl-6">
              <div class="card mb-4">
                <div class="card-header">
                  <i class="fas fa-chart-bar me-1"></i>
                  월별 총 가입 업체 수
                </div>
                <div class="card-body"><canvas id="cpChart" width="100%" height="40"></canvas></div>
              </div>
            </div>
          </div>
          <div class="card mb-4">
            <div class="card-header">
              <i class="fas fa-table me-1"></i>
              최근 가입한 유저
            </div>
            <div class="card-body">
              <table id="datatablesSimple" class="text-center">
                <thead>
                  <tr>
                    <th><div>아이디</div></th>
                    <th><div>이메일</div></th>
                    <th><div>전화번호</div></th>
                    <th><div>가입일</div></th>
                  </tr>
                </thead>
                <tbody>
                	<c:forEach var="vo" items="${userVOS}" varStatus="st">
                		<tr>
                			<td>${vo.mid}</td>
                			<td>${vo.email}</td>
                			<td>${vo.tel}</td>
                			<td><fmt:formatDate value="${vo.createDay}" pattern="yyyy/MM/hh"/></td>
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
	<script type="text/javascript">
		'use strict';
		let view = null;
		
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
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
	<script src="${ctp}/js/templete/assets/chart-area.js"></script>
	<%-- <script src="${ctp}/js/templete/assets/chart-area-demo.js"></script> --%>
	<script src="${ctp}/js/templete/assets/chart-bar.js"></script>
	<%-- <script src="${ctp}/js/templete/assets/chart-bar-demo.js"></script> --%>
	<script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" crossorigin="anonymous"></script>
	<script src="${ctp}/js/templete/datatables-simple-demo.js"></script>
</body>
</html>