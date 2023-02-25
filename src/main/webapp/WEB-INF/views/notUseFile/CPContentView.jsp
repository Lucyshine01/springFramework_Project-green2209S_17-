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
  <title>CPInfo.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="include/viewPage.css" rel="stylesheet" type="text/css">
  <script>
	  'use strict';
	  function submitReply() {
		  let mid = "${sMid}";
		  let boardIdx = "${vo.cidx}";
			let rating = $("#rating").val();
			let content = $("#content").val();
			
			boardIdx = "c" + boardIdx;
			
			let query = {
					mid: mid,
					boardIdx: boardIdx,
					rating: rating,
					content: content
			}
			
			$.ajax({
				type: "post",
				url : "${ctp}/submitReply.co",
				data: query,
				success: function(res) {
					if(res == "1") location.reload();
					else alert("댓글 등록에 실패했습니다.");
				},
				error: function() {
					alert("전송 오류");
				}
			});
			
		}
	  function starChange(val) {
		  let img = $("#star").attr("src");
		  if(img == "${ctp}/data/star/"+val+".jpg") {
			  $("#star").attr("src","${ctp}/data/star/0.0.jpg");
				$("#rating").val("0.0");
				return;
		  }
			$("#star").attr("src","${ctp}/data/star/"+val+".jpg");
			$("#rating").val(val);
		}
	  
	  function replyDelete(idx) {
			let ans = confirm("정말 삭제하시겠습니까?");
			if(!ans) return;
			
			$.ajax({
				type: "post",
				url : "${ctp}/coReplyDel.co",
				data: {ridx:idx},
				success: function(res) {
					if(res == '1') location.reload();
					else alert("삭제실패");
				}
			});
		}
	  function replyReport(idx) {
			let ans = confirm("신고하시겠습니까?");
			if(!ans) return;
			
			$.ajax({
				type: "post",
				url : "${ctp}/coReplyReport.co",
				data: {ridx:idx},
				success: function(res) {
					if(res == '1') {
						alert("신고가 접수되었습니다.");
						location.reload();
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
  </style>
</head>
<body ondragstart="return false" onselectstart="return false">
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
			<img src="${ctp}/data/logo/${vo.cpImg}" width="200px" height="auto" />
			<div class="m-2 d-flex fCol_center cont" style="font-size: 1.3em; font-weight: 500;">${vo.cpName}&nbsp;&nbsp;[view : ${vo.viewCP}]</div>
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
						<div class="cont d-flex fCol_center">${vo.tel}</div>
					</div>
					<div class="d-flex mb-3">
						<div class="tit d-flex fCol_center">이메일</div>
						<div class="cont d-flex fCol_center">${vo.email}</div>
					</div>
					<div class="d-flex mb-3">
						<div class="tit d-flex fCol_center">등록일</div>
						<div class="cont d-flex fCol_center">${fn:substring(vo.createDayCP,0,10)}</div>
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
				<c:if test="${empty vo.cpIntroImg}">
					<div class="d-felx fCol_center text-center" style="width: 600px; line-height: 400px; font-size: 1.8em;">
						NO IMAGE
					</div>
				</c:if>
				<c:if test="${!empty vo.cpIntroImg}">
					<c:set var="imgs" value="${fn:split(vo.cpIntroImg,'/')}" />
					<div id="slideImg" class="carousel slide ml-auto" data-ride="carousel" style="width: 600px">
	        	<!-- (하단 바 스타일) -->
		        <div id="slideNumbar" style="z-index: 1;"><span id="numIns"></span><span id="numTot"></span></div>
		        <!-- The slideshow -->
	        	<div class="carousel-inner" style="height: 500px;">
	        		<c:forEach var="img" items="${imgs}" varStatus="st">
								<div class="carousel-item <c:if test="${st.index == 0}">active</c:if>" >
									<div style="height: 440px;"><img src="${ctp}/data/picture/${img}" style="object-fit: contain" /></div> 
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
				총 댓글수 ${replyTot}개
				<c:if test="${avgRating != 0.0}">
				 / 평점 <fmt:formatNumber value="${avgRating}" pattern="0.0"/>
				</c:if> 
			</div>
			<hr/>
			<table class="ml-auto mr-auto">
				<c:if test="${replyTot == 0}"><tr><td class="p-5 reply text-center" style="font-size: 1.05em;">작성된 댓글이 없습니다.</td></tr></c:if>
				<c:if test="${replyTot != 0}">
					<c:forEach var="replyVO" items="${replyVOS}" >
						<tr><td><div class="d-flex" style="padding: 20px 50px 20px 50px; width: 900px; border-bottom: 1px solid #ddd;">
							<div class="d-flex fCol_center">
								<div class="m-2" style="border-radius: 70%; overflow: hidden;">
									<img src="${ctp}/data/profile/userIcon-${random.nextInt(4)}.jpg" width="60px"/>
								</div>
							</div>
							<div class="reply d-flex fCol_center" style="width: 100%;">
								<div class="d-flex">
									<div class="ml-3 p-2" style="font-size: 1.05em; font-weight: 300; width: 12%;">${replyVO.mid}</div>
									<div class="ml-4 p-1 d-flex fCol_center">
										<c:if test="${replyVO.rating == 0.0}" ></c:if>
										<c:if test="${replyVO.rating != 0.0}" >
											<img src="${ctp}/data/star/${replyVO.rating}.jpg" width="110px"/>
										</c:if>
									</div>
									<div class="ml-auto p-2" style="font-size: 1.05em; font-weight: 300;">${fn:substring(replyVO.writeDay,0,16)}</div>
									<c:if test="${replyVO.mid != sMid}">
										<div onclick="replyReport(${replyVO.ridx})" class="p-2 ml-1" style="font-size: 0.95em;cursor: pointer;">신고</div>
									</c:if>
									<c:if test="${replyVO.mid == sMid}">
										<div onclick="replyDelete(${replyVO.ridx})" class="p-2 ml-1" style="font-size: 0.95em;cursor: pointer;">삭제</div>
									</c:if>
								</div>
								<div class="d-flex">
									<div class="ml-4 p-2">${replyVO.content}</div>
								</div>
							</div>
						</div></td></tr>
					</c:forEach>
				</c:if>
				<tr><td><div class="d-flex" style="padding: 20px 50px 20px 50px; width: 900px;">
					<div class="d-flex fCol_center">
						<div class="m-2" style="border-radius: 70%; overflow: hidden;">
							<img src="${ctp}/data/profile/userIcon-${random.nextInt(4)}.jpg" width="60px"/>
						</div>
					</div>
					<div class="reply d-flex fCol_center" style="width: 100%;">
						<div class="d-flex">
							<div class="ml-3 p-2" style="font-size: 1.05em; font-weight: 300;">작성자 : ${sMid}</div>
							<div class="ml-4 p-1 d-flex fCol_center">
								<div style="position: relative;">
									<img id="star" src="${ctp}/data/star/0.0.jpg" width="112px"/>
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
					</div>
				</div></td></tr>
			</table>
			<div class="mb-3"></div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script src="include/viewPage.js"></script>
</body>
</html>