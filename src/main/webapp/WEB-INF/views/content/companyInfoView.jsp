<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="random" class="java.util.Random" scope="page"></jsp:useBean>
<jsp:useBean id="date" class="java.util.Date" scope="page"></jsp:useBean>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>companyInfoView.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="${ctp}/viewPage/viewPage.css" rel="stylesheet" type="text/css">
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
  <script>
	  'use strict';
	  function submitReply() {
		  let mid = "${sMid}";
		  let boardIdx = "${vo.idx}";
			let rating = $("#rating").val();
			let content = $("#content").val();
			
			boardIdx = "c" + boardIdx;
			
			let query = {
					mid: mid,
					boardIdx: boardIdx,
					rating: rating,
					content: content,
			}
			
			$.ajax({
				type: "post",
				url : "${ctp}/member/submitReply",
				data: query,
				success: function(res) {
					if(res == "1") document.location.reload(true);
					else alert("댓글 등록에 실패했습니다.");
				},
				error: function() {
					alert("전송 오류");
				}
			});
			
		}
	  
	  window.addEventListener("beforeunload", () => {
        localStorage.setItem("sidebar-scroll", element.scrollTop);
    });
	  
	  function starChange(val) {
		  let img = $("#star").attr("src");
		  if(img == "${ctp}/images/star/"+val+".jpg") {
			  $("#star").attr("src","${ctp}/images/star/0.0.jpg");
				$("#rating").val("0.0");
				return;
		  }
			$("#star").attr("src","${ctp}/images/star/"+val+".jpg");
			$("#rating").val(val);
		}
	  
	  function replyDelete(idx) {
			let ans = confirm("정말 삭제하시겠습니까?");
			if(!ans) return;
			
			$.ajax({
				type: "post",
				url : "${ctp}/member/replyDelete",
				data: {idx:idx},
				success: function(res) {
					if(res == '1') document.location.reload(true);
					else alert("삭제실패");
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
	  
	  
	  function chatRoomEnter(idx) {
			if('${sMid}' == '') {
				alert("로그인 후 이용하실 수 있습니다.");
				return;
			}
			
			let ans = confirm("100포인트를 사용하여 채팅을 진행하시겠습니까?\n(이전 대화기록이 존재할경우 포인트가 차감되지 않습니다.)");
			if(!ans) return;
				
			$.ajax({
				type: "post",
				url: "${ctp}/chatRoomCheck",
				data: {idx,idx},
				success: function(roomId) {
					if(roomId == 'over') {
						alert("자신과의 채팅은 불가능합니다.");
						return;
					}
					else if(roomId == '0') {
						alert("보유 포인트가 부족합니다.");
						return;
					}
					roomIdCheckOk(roomId);
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
	  let roomCode = "";
	  let stompClient = null
	  
	  function roomIdCheckOk(roomId) {
		  window.name = "parentForm";
		  let xx = (window.screen.width/2) - (510/2); 
      let yy = (window.screen.height/2) - (650/2); 
		  let openWin = window.open("${ctp}/chatRoom?roomId="+roomId, "chatRoom", "left="+xx+" ,top="+yy+" width=510, height=650, resizable = no, scrollbars = no");
		}
	  
	  function loadBeforeReply(cnt,e) {
		  let boardIdx = 'c' + ${vo.idx};
		  $.ajax({
				type: "post",
				url: "${ctp}/member/loadBeforeReply",
				data: {replyPag:cnt,boardIdx:boardIdx},
				success: function(res) {
				  let block = '';
					$(e).remove();
					if(${replyTot} > (cnt*5)) {
						cnt++;
						block += '<div class="d-flex fCol_center text-center loadBtn" onclick="loadBeforeReply('+cnt+',this)">이전 댓글 불러오기</div>';
					}
					for(let i=0; i<res.length; i++){
						let vo = res[(res.length-1)-i];
						block += '<tr><td><div class="d-flex" style="padding: 20px 50px 20px 50px; width: 900px; border-bottom: 1px solid #ddd;">';
						block += '<div class="d-flex fCol_center">';
						block += '<div class="m-2" style="border-radius: 70%; overflow: hidden;">';
						block += '<img src="${ctp}/images/profile/'+vo.profileImg+'" class="replyProfileImg"/></div></div>';
						block += '<div class="reply d-flex fCol_center" style="width: 100%;"><div class="d-flex">';
						block += '<div class="ml-3 p-2" style="font-size: 1.05em; font-weight: 300; width: 12%;">'+vo.mid+'</div>';
						block += '<div class="ml-4 p-1 d-flex fCol_center">';
						let rating = vo.rating + '';
						if((rating).length == 1) rating = rating + ".0";
						if(rating != 0.0) block += '<img src="${ctp}/images/star/'+rating+'.jpg" width="110px"/>';
						block += '</div>';
						block += '<div class="ml-auto p-2" style="font-size: 1.05em; font-weight: 300;">';
						
						let date = new Date(vo.writeDay);
						let MM = (date.getMonth() + 1) + "";
						let dd = date.getDate() + ""; 
						let HH = date.getHours() + "";
						let mm = date.getMinutes() + "";
						if(MM.length == 1) MM = "0"+MM;
						if(dd.length == 1) dd = "0"+dd;
						if(HH.length == 1) HH = "0"+HH;
						if(mm.length == 1) mm = "0"+mm;
						
						block += MM+'-'+dd+'  '+HH+':'+mm+'</div>';
						if(vo.mid != '${sMid}') block += '<div onclick="reportModalOn('+vo.idx+')" class="p-2 ml-1" style="font-size: 0.95em;cursor: pointer;">신고</div>';
						if(vo.mid == '${sMid}') block += '<div onclick="replyDelete('+vo.idx+')" class="p-2 ml-1" style="font-size: 0.95em;cursor: pointer;">삭제</div>';
						
						block += '</div><div class="d-flex">';
						block += '<div class="ml-4 p-2">'+vo.content+'</div>';
						block += '</div></div></div></td></tr>';
					}
					$("#replyTable tbody").prepend(block);
					block = '';
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
	  
	  let reportContent = "";
	  function selectReport() {
		  let selReport = $("#selectReport").val()
		  
			if(selReport == '1') reportContent = '광고 및 도배관련 댓글';
			else if(selReport == '2') reportContent = '욕설 및 모욕적인 내용';
			else if(selReport == '3') reportContent = '허위사실를 유포하는 내용';
			else if(selReport == 'etc') {
				reportContent = '';
				document.getElementById('reportContent').disabled = false;
				return;
			}
		  reportContentDisable();
		}
	  
	  function reportContentDisable() {
			$("#reportContent").val('');
			document.getElementById('reportContent').disabled = true;
		}
	  
	  function replyReport(idx) {
			let ans = confirm("해당 사유로 댓글을 신고하시겠습니까?\n사유가 적합하지 않은 경우, 허위신고로 불이익이 생길수 있습니다.");
			if(!ans) return;
			
			if(reportContent == "") {
				alert("신고 사유를 작성해주세요!");
				return;
			}
			
			$.ajax({
				type: "post",
				url : "${ctp}/member/replyReport",
				data: {idx:idx,reportContent:reportContent},
				success: function(res) {
					if(res == '1') {
						alert("신고가 접수되었습니다.");
						document.location.reload(true);
					}
					else if(res == '0') alert("이미 신고하신 댓글입니다.");
					else alert("서버오류"); 
				}
			});
		}
	  
  </script>
  <style>
  	.tit {
  		width: 110px;
  		font-family: 'Spoqa Han Sans Neo', 'sans-serif';
  		border-right: 2px solid #e0e0e0;
  		padding: 10px;
  		font-size: 1.1em;
  		font-weight: 400;
  		color: #333;
  	}
  	.cont {
  		width: 75%;
  		font-family: 'Spoqa Han Sans Neo', 'sans-serif';
  		margin-left: 30px;
  		padding: 10px;
  		font-size: 1.1em;
  		font-weight: 400;
  		color: #333;
  	}
  	.star {
  		height:28px;
  		width:11px;
  		position: absolute;
  		top: 0px; 
  		cursor: pointer;
  	}
  	.loadBtn {
  		font-weight: 400;
  		font-size: 1.05em;
  		height: 50px;
  		cursor: pointer;
  		border-bottom: 2px solid rgba(50,50,50,0.1);
  	}
  	.loadBtn:hover {background-color: rgba(50,50,50,0.2)}
  	.loadBtn:active {background-color: rgba(50,50,50,0.4)}
  	.replyProfileImg {
  		width: 60px;
  		height: 60px;
  		object-fit: cover;
  	}
  </style>
</head>
<body ondragstart="return false" onselectstart="return false">
	<jsp:include page="/WEB-INF/views/include/notice.jsp"></jsp:include>
	<div id="loading_Bar"></div>
	<c:if test="${empty sMid}"><jsp:include page="/WEB-INF/views/include/headTop.jsp"></jsp:include></c:if>
	<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
	<div class="width" style="margin-top: 30px">
		<div class="d-flex"><div class="ml-3 mb-3 titleContent">회사 정보</div></div>
		<div class="d-flex">
			<div class="ml-2 mb-4 subtitleContent">
				인테모아 업체 정보입니다.<br/>
				원하시는 업체를 찾아보세요.<p></p>
			</div>
		</div>
		<div class="d-flex ml-3 mb-3">
			<img src="${ctp}/images/cpProfile/${imgVO.cpImg}" width="200px" height="auto" />
			<div class="m-2 d-flex fCol_center cont" style="font-size: 1.3em; font-weight: 500;">${vo.cpName}&nbsp;&nbsp;[view : ${vo.viewCP}]</div>
			<div class="m-2 d-flex fCol_center">
				<input type="button" value="채팅하기" class="btn btn-secondary" onclick="chatRoomEnter(${vo.idx})"/>
			</div>
		</div>
		<div style="border-bottom: 2px solid #d0d0d0;"></div>
		<div class="mt-2 ml-2 mb-1" style="font-size: 1.8em; font-weight: 400; color: #333">
			업체 정보
		</div>
		<div class="mt-3 d-flex">
			<div class="d-flex fCol_center ml-4" style="width: 48%">
				<div class="d-flex fCol_center">
					<div class="d-flex mb-3">
						<div class="tit d-flex fCol_center">회사명</div>
						<div class="cont d-flex fCol_center">${vo.cpName}</div>
					</div>
					<div class="d-flex mb-3">
						<div class="tit d-flex fCol_center">대표명</div>
						<div class="cont d-flex fCol_center">${vo.name}</div>
					</div>
					<div class="d-flex mb-3">
						<div class="tit d-flex fCol_center">주소</div>
						<div class="cont d-flex fCol_center">${vo.cpAddr}</div>
					</div>
					<div class="d-flex mb-3">
						<div class="tit d-flex fCol_center">홈페이지</div>
						<div class="cont d-flex fCol_center">${vo.cpHomePage == '' ? '없음' : vo.cpHomePage}</div>
					</div>
				</div>
			</div>
			<div class="d-flex fCol_center ml-4" style="width: 48%">
				<div class="d-flex fCol_center">
					<div class="d-flex mb-3">
						<div class="tit d-flex fCol_center">연락처</div>
						<div class="cont d-flex fCol_center">${userVO.tel}</div>
					</div>
					<div class="d-flex mb-3">
						<div class="tit d-flex fCol_center">이메일</div>
						<div class="cont d-flex fCol_center">${userVO.email}</div>
					</div>
					<div class="d-flex mb-3">
						<div class="tit d-flex fCol_center">등록일</div>
						<div class="cont d-flex fCol_center"><fmt:formatDate value="${vo.createDayCP}" pattern="yyyy년 MM월 dd일"/></div>
					</div>
					<div class="d-flex mb-3">
						<div class="tit d-flex fCol_center">활동상태</div>
						<div class="cont d-flex fCol_center">${vo.act == 'off' ? '중단' : '활동중'}</div>
					</div>
				</div>
			</div>
		</div>
		<div class="mt-3 mb-5">
			<div class="d-flex fCol_center ml-4">
					<div class="d-flex mb-4">
						<div class="tit d-flex fCol_center">전문분야</div>
						<div class="cont d-flex fCol_center">${vo.cpExp == '' ? '없음' : fn:replace(vo.cpExp,'/',' | ')}</div>
					</div>
					<div class="d-flex mb-3">
						<div class="tit d-flex fCol_center">소개</div>
						<div class="cont d-flex fCol_center">${vo.cpIntro == '' ? '없음<br/>&nbsp;' : vo.cpIntro}</div>
					</div>
			</div>
		</div>
		<div class="mt-3" style="border-bottom: 2px solid #d0d0d0;"></div>
		<div class="d-flex fRow_center"
			style="padding: 30px 50px 30px 0px;">
			<div>
				<c:if test="${empty imgVO.cpIntroImg}">
					<div class="d-felx fCol_center text-center" style="width: 600px; line-height: 400px; font-size: 1.8em;">
						NO IMAGE
					</div>
				</c:if>
				<c:if test="${!empty imgVO.cpIntroImg}">
					<c:set var="imgs" value="${fn:split(imgVO.cpIntroImg,'/')}" />
					<div id="slideImg" class="carousel slide ml-auto" data-ride="carousel" style="width: 600px">
	        	<!-- (하단 바 스타일) -->
		        <div id="slideNumbar" style="z-index: 1;"><span id="numIns"></span><span id="numTot"></span></div>
		        <!-- The slideshow -->
	        	<div class="carousel-inner" style="height: 500px;">
	        		<c:forEach var="img" items="${imgs}" varStatus="st">
								<div class="carousel-item <c:if test="${st.index == 0}">active</c:if>" >
									<div style="height: 440px;"><img src="${ctp}/images/cpIntro/${fn:split(img,':')[0]}" style="object-fit: contain" /></div> 
								</div>
							</c:forEach>
		        </div>
		        <!-- Left and right controls -->
		        <a class="carousel-control-prev carousel-btn" href="#slideImg" data-slide="prev" style="left: -18px;" >
		          <i style="color: #000;" class="fa-solid fa-chevron-left"></i>
		        </a>
		        <a class="carousel-control-next carousel-btn" href="#slideImg" data-slide="next" style="right: -18px;" >
		          <i style="color: #000;" class="fa-solid fa-chevron-right"></i>
		        </a>
		      </div>
				</c:if>
			</div>
		</div>
		<div>
			<div class="reply ml-auto mr-auto mb-3" style="width: 800px; font-size: 1.4em; font-weight: 400;">
				총 댓글수 ${replyTot}개 / 평점 <fmt:formatNumber value="${avgRating}" pattern="0.0"/>
				<img class="mb-1 ml-2" src="${ctp}/images/star/<fmt:formatNumber value="${(avgRating - (avgRating % 0.5))}" pattern="0.0"/>.jpg" width="120px"/>
			</div>
			<hr/>
			<table id="replyTable" class="ml-auto mr-auto">
				<c:if test="${replyTot == 0}"><tr><td class="p-5 reply text-center" style="font-size: 1.05em;">작성된 댓글이 없습니다.</td></tr></c:if>
				<c:if test="${replyTot != 0 && !empty sMid}">
					<c:if test="${replyTot > (5*replyPag)}">
						<tr><td><div class="d-flex fCol_center text-center loadBtn" onclick="loadBeforeReply(2,this)">이전 댓글 불러오기</div></td></tr>
					</c:if>
					<c:set var="tot" value="${fn:length(replyVOS)-1}"/>
					<c:forEach begin="0" end="${tot}" varStatus="st" >
						<tr><td><div class="d-flex" style="padding: 20px 50px 20px 50px; width: 900px; border-bottom: 1px solid #ddd;">
							<div class="d-flex fCol_center">
								<div class="m-2" style="border-radius: 70%; overflow: hidden;">
									<img src="${ctp}/images/profile/${replyVOS[tot-st.index].profileImg}" class="replyProfileImg"/>
								</div>
							</div>
							<div class="reply d-flex fCol_center" style="width: 100%;">
								<div class="d-flex">
									<div class="ml-3 p-2" style="font-size: 1.05em; font-weight: 300; width: 12%;">${replyVOS[tot-st.index].mid}</div>
									<div class="ml-4 p-1 d-flex fCol_center">
										<c:if test="${replyVOS[tot-st.index].rating == 0.0}" ></c:if>
										<c:if test="${replyVOS[tot-st.index].rating != 0.0}" >
											<img src="${ctp}/images/star/${replyVOS[tot-st.index].rating}.jpg" width="110px"/>
										</c:if>
									</div>
									<div class="ml-auto p-2" style="font-size: 1.05em; font-weight: 300;">
										<fmt:formatDate value="${replyVOS[tot-st.index].writeDay}" pattern="MM-dd  HH:mm"/>
									</div>
									<c:if test="${replyVOS[st.index].mid != sMid}">
										<div onclick="reportModalOn(${replyVOS[tot-st.index].idx})" class="p-2 ml-1" style="font-size: 0.95em;cursor: pointer;">신고</div>
									</c:if>
									<c:if test="${replyVOS[st.index].mid == sMid}">
										<div onclick="replyDelete(${replyVOS[tot-st.index].idx})" class="p-2 ml-1" style="font-size: 0.95em;cursor: pointer;">삭제</div>
									</c:if>
								</div>
								<div class="d-flex">
									<div class="ml-4 p-2">${replyVOS[tot-st.index].content}</div>
								</div>
							</div>
						</div></td></tr>
					</c:forEach>
				</c:if>
				<tr><td><div class="d-flex" style="padding: 20px 50px 20px 50px; width: 900px;">
					<div class="d-flex fCol_center">
						<div class="m-2" style="border-radius: 70%; overflow: hidden;">
							<c:if test="${!empty sMid}">
								<img src="${ctp}/images/profile/${sProfileImg}" width="60px"/>
							</c:if>
						</div>
					</div>
					<div class="reply d-flex fCol_center" style="width: 100%;">
						<c:if test="${!empty sMid}">
						<div class="d-flex">
							<div class="ml-3 p-2" style="font-size: 1.05em; font-weight: 300;">작성자 : ${sMid}</div>
							<div class="ml-4 p-1 d-flex fCol_center">
								<div style="position: relative;">
									<img id="star" src="${ctp}/images/star/0.0.jpg" width="112px"/>
									<c:forEach begin="0" end="9" varStatus="st">
										<div class="star" onclick="starChange('${st.count * 0.5}')" style="left: ${(st.index * 11) + 1}px;"></div>
									</c:forEach>
									<input type="hidden" name="rating" id="rating" value="0.0"/>
								</div>
							</div>
							<div class="ml-auto p-2" style="font-size: 1.05em; font-weight: 300;">
								작성일자 : <fmt:formatDate value="${date}" pattern="MM-dd HH:mm"/>
							</div>
						</div>
						<div class="d-flex">
							<div class="ml-3 p-2" style="width: 88%">
								<textarea rows="2" name="content" id="content"  placeholder="무분별한 욕설 및 분란조장 댓글은 임의로 삭제될수 있습니다." class="form-control" style="resize: none;"></textarea>
							</div>
							<div class="d-flex fCol_center text-center" style="width: 9%;">
								<input type="button" onclick="submitReply();" value="작성" class="btn btn-secondary btn-sm" style="padding: 19px;" />
							</div>
						</div>
						</c:if>
						<c:if test="${empty sMid}">
							<div class="text-center" style="font-size: 1.05em; font-weight: 400;">
								로그인 후 리뷰를 확인하실수 있습니다.
							</div>
						</c:if>
					</div>
				</div></td></tr>
			</table>
			<div class="mb-3"></div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script src="${ctp}/viewPage/viewPage.js"></script>
</body>
</html>