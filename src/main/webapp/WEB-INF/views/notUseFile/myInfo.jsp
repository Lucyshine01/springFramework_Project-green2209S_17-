<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>myInfo.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="include/viewPage.css" rel="stylesheet" type="text/css">
  <script>
  	'use strict';
  	
  	function myInfoUpdate() {
  		let ans = confirm("수정하시겠습니까?"); 
  		if(!ans) return;
  		
  		let email = $("#email").val();
  		let tel = $("#tel").val();
  		let birth = $("#birth").val();
  		
  		let regEmail = /^([-_.]?[0-9a-zA-Z]){4,20}@+([-_.]?[0-9a-zA-Z]){4,20}.+[a-zA-Z]{2,3}$/i;
			let regTel = /^([0-9]){2,3}-+([0-9]){3,4}-+([0-9]){3,4}$/g;
  		
			if(email.trim() == ""){
				alert("이메일을 입력해주세요!");
	      document.getElementById("email").focus();
	      return false;
			}
			else if(birth.trim() == ""){
				alert("생일을 등록해주세요!");
	      document.getElementById("brith").focus();
	      return false;
			}
			else if(tel.trim() == ""){
				alert("전화번호를 입력해주세요!");
	      document.getElementById("tel").focus();
	      return false;
			}
			
			if(!email.match(regEmail)){
				alert("허용되지 않는 이메일입니다!");
	      document.getElementById("email").focus();
	      return false;
			}
			else if(!tel.match(regTel)){
				alert("허용되지 않는 전화번호입니다!");
	      document.getElementById("tel").focus();
	      return false;
			}
			
  		let query = {
  				uidx : '${vo.uidx}',
  				email: email,
  				tel  : tel,
  				birth: birth
  		}
  		
  		$.ajax({
  			type: "post",
  			url : "${ctp}/infoUpdate.us",
  			data: query,
  			success: function(res) {
					if(res == '1') location.reload();
					else alert("수정에 실패했습니다.");
				}
  		});
		}
  	
  	function myInfoReset() {
			let email = "${vo.email}";
			let tel = "${vo.tel}";
			let birth = "${fn:substring(vo.birth,0,10)}";
			$("#email").val(email);
			$("#tel").val(tel);
			$("#birth").val(birth);
		}
  </script>
  <style>
  .item {
		position: relative; 
  }
  .form-item {
  	width : 115px;
  	text-align : center;
    font-size: 1.3em;
    border-radius: 20px;
    padding: 20px;
    padding-top: 5px;
    padding-bottom: 5px;
    background-color: #fff;
    box-shadow: 0px 1px 3px 0px #b0b0b0;
    color: #666;
    z-index: 2;
    /* width: 30%; */
  }
  .item .botLine {
  	position: absolute;
  	top: 38px;
  	left: 70px;
  	width: 80%;
  	border-bottom: 2px solid #e0e0e0;
  	z-index: 0;
  }
  .item .item-text{
  	width: 70%;
  	font-size: 1.1em;
  	font-weight: 300;
  	font-family: 'Spoqa Han Sans Neo';
  	color: #333;
  }
  .item .item-text input {
  	text-align: center;
  	padding: 3px;
  	border: 2px solid #e0e0e0;
  	border-radius: 5px;
  	outline: none;
  }
  </style>
</head>
<body ondragstart="return false" onselectstart="return false">
	<div id="loading_Bar"></div>
	<jsp:include page="/WEB-INF/views/include/headTop.jsp"></jsp:include>
	<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
	<div class="width" style="padding: 30px; padding-top: 40px">
		<div class="text-center" style="font-size: 2.8em; font-weight: 600; margin-bottom: 10px;">
			내 정보화면
		</div>
		<div class="text-center mb-4" style="color: #bbb; font-weight: 300">
			고객님이 설정하신 계정의 필수 정보들입니다.<br/>
			변경되거나 잘못 기입하신 내용을 수정하실수 있습니다.
		</div>
		<hr class="ml-auto mr-auto" style="margin-bottom: 50px; width: 90%; box-shadow: 0px 1px 1px 1px #aaa;"/>
		<div class="d-flex">
			<div class="d-flex fCol_center ml-auto mr-auto" style="width: 38%">
				<div class="d-flex mb-5 item">
					<div class="form-item">아이디</div>
					<div class="d-flex fCol_center text-center item-text mr-auto">
						${vo.mid}
					</div>
					<div class="botLine"></div>
				</div>
				<div class="d-flex mb-5 item">
					<div class="form-item">이메일</div>
					<div class="d-flex fCol_center text-center item-text mr-auto">
						<div><input type="text" name="email" id="email" value="${vo.email}" required></div>
					</div>
					<div class="botLine"></div>
				</div>
				<div class="d-flex mb-5 item">
					<div class="form-item">연락처</div>
					<div class="d-flex fCol_center text-center item-text mr-auto">
						<div><input type="text" name="tel" id="tel" value="${vo.tel}" required></div>
					</div>
					<div class="botLine"></div>
				</div>
				<div class="d-flex mb-5 item">
					<div class="form-item">가입일</div>
					<div class="d-flex fCol_center text-center item-text mr-auto">
						${fn:substring(vo.createDay,0,10)}
					</div>
					<div class="botLine"></div>
				</div>
			</div>
			<div class="d-flex fCol_center ml-auto mr-auto" style="width: 38%">
				<div class="d-flex mb-5 item">
					<div class="form-item">비밀번호</div>
					<div class="d-flex" style="width: 70%">
						<div class="ml-auto mr-auto">
							<input type="button" value="비밀번호 변경" onclick="pwdChangeModalOn();" class="btn btn-warning"/>
						</div>
					</div>
					<div class="botLine"></div>
				</div>
				<div class="d-flex mb-5 item">
					<div class="form-item">생년월일</div>
					<div class="d-flex fCol_center text-center item-text mr-auto">
						<div class="ml-auto mr-auto" style="width: 190px"><input type="date" name="birth" id="birth"  value="${fn:substring(vo.birth,0,10)}" required></div>
					</div>
					<div class="botLine"></div>
				</div>
				<div class="d-flex mb-5 item">
					<div class="form-item">회원등급</div>
					<div class="d-flex fCol_center text-center item-text mr-auto">
						${vo.userLevel}
					</div>
					<div class="botLine"></div>
				</div>
				<div class="d-flex mb-5 item">
					<div class="form-item">포인트</div>
					<div class="d-flex fCol_center text-center item-text mr-auto">
						<fmt:formatNumber value="${vo.point}"/>pt
					</div>
					<div class="botLine"></div>
				</div>
			</div>
		</div>
		<div class="d-flex">
			<div class="ml-auto" style="margin-right: 80px">
				<input type="button" onclick="myInfoUpdate()" value="수정하기" class="btn btn-danger mr-2"/>
				<input type="button" onclick="myInfoReset()" value="원래대로" class="btn btn-success"/>
			</div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script src="include/viewPage.js"></script>
</body>
</html>