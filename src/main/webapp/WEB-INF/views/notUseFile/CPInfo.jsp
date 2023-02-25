<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="random" class="java.util.Random" scope="page"></jsp:useBean>
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
	  let maxSize= 1024 * 1024 * 20;
	  let cnt = 0;
	  function inputFile(me) {
	    $(me).next(".filebox").click();
	  }
	  function onChangefile(me) {
	    let val = $(me).val();
	    val = val.substring(val.lastIndexOf('\\')+1);
	    let exp = val.substring(val.lastIndexOf('.')+1).toUpperCase();
	    if(exp != 'PNG' && exp != "JPG") {
	      alert("PNG,JPG파일만 허용합니다!");
	      return;
	    }
	    let fileSize = $(me)[0].files[0].size;
	    if(maxSize < fileSize) {
	    	alert("이미지는 10MB 이하만 업로드 가능합니다!");
	    	$(me).val("");
	    	return;
	    }
	    $(me).prev(".fIcon").hide();
	    $("#fileBoxs").append('<div class="fileName mr-3 mt-2" style="overflow : hidden;">'+val+'</div>');
	    let next = '<input type="hidden" name="fileSize'+cnt+'" value="'+fileSize+'"/>';
	    cnt = cnt + 1;
	    next += '<i class="fIcon fa-solid fa-plus mt-2" onclick="inputFile(this)"></i></div><input type="file" name="files'+cnt+'" id="files'+cnt+'" class="filebox" onchange="onChangefile(this)">'
	    $("#fileBoxs").append(next);
	  }
	  function inputImg() {
		  let file0 = $("#files0").val()
			if(file0.trim() == "") return;
			let ans = confirm("이미지를 추가하시겠습니까?");
			if(!ans) return;
			
			plusImgForm.submit();
		}
	  function imgDelete() {
			let ans = confirm("해당 이미지를 삭제하시겠습니까?");
			if(!ans) return;
			
			
			let img = $("#imgDel").val();
			
			$.ajax({
				type: "post",
				url : "${ctp}/imgDel.co",
				data: {imgName:img,mid:'${sMid}'},
				success: function(res) {
					if(res == '1') location.reload();
					else alert("이미지 삭제에 실패하였습니다.");
				},
				error: function() {
					alert("전송 오류");
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
				고객님께서 등록하신 인테모아 업체 정보입니다.<br/>
				변경된 정보 혹은 잘못된 정보가 있으실 경우 문의를 통해 정보를 변경하실 수 있습니다.<p></p>
			</div>
		</div>
		<div class="d-flex ml-3 mb-3">
			<img src="${ctp}/data/logo/${vo.cpImg}" width="200px" height="auto"/>
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
		<div class="d-flex" style="padding: 30px 50px 0px 50px;">
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
									<div style="height: 440px;"><img src="${ctp}/data/picture/${img}" style="object-fit: contain"/></div>
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
			<div class="mt-3 mb-5 ml-auto text-center" style="width: 40%">
				<form name="plusImgForm" method="post" action="${ctp}/inputCPImg.co" enctype="multipart/form-data">
					<div>
				    <div id="fileBoxs" class="d-flex" style="flex-wrap: wrap">
				      <i class="fIcon fa-solid fa-plus mt-2" onclick="inputFile(this)"></i>
				      <input class="filebox" type="file" name="files0" id="files0" onchange="onChangefile(this)">
				    </div>
				  </div>
			  </form>
			</div>
		</div>
		<div class="d-flex">
			<c:if test="${!empty vo.cpIntroImg}">
				<select id="imgDel" name="imgDel" class="form-control ml-auto m-3" style="width: 20%">
					<c:forEach var="img" items="${imgs}" varStatus="st">
						<option value="${img}">${st.count}. ${img}</option>
					</c:forEach>
				</select>
				<input type="button" value="선택 이미지삭제" onclick="imgDelete();" class="btn btn-danger m-3"/>
				<input type="button" value="이미지 추가" onclick="inputImg();" class="btn btn-success m-3"/>
			</c:if>
			<c:if test="${empty vo.cpIntroImg}">
				<input type="button" value="이미지 추가" onclick="inputImg();" class="btn btn-success ml-auto m-3"/>
			</c:if>
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
				<c:if test="${replyTot == 0}"><tr><td class="p-5 reply" style="font-size: 1.05em">작성된 댓글이 없습니다.</td></tr></c:if>
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
								</div>
								<div class="d-flex">
									<div class="ml-4 p-2">${replyVO.content}</div>
								</div>
							</div>
						</div></td></tr>
					</c:forEach>
				</c:if>
			</table>
			<div class="mb-3"></div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script src="include/viewPage.js"></script>
</body>
</html>