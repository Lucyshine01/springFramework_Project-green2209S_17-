<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>adminHeader.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="include/viewPage.css" rel="stylesheet" type="text/css">
  <script></script>
  <style></style>
</head>
<body>
<div id="headMain" class="container-fluid-xl" style="z-index: 9;background-color:#fff;" >
  <div class="width d-flex" style="margin-left: 50px">
    <div id="logo" class="d-flex fCol_center header pl-4">
    <!-- http://192.168.50.79:9090/green2209J_17/ -->
      <a href="${ctp}/" target="_top"><img src="${ctp}/images/viewPage/logo3.png" width="120px"/></a>
    </div>
    <div id="loginBox" class="d-flex fCol_center ml-auto header">
    	<div>
        <a href="${ctp}/" target="_top" style="margin-right: 15px; font-size: 1.2em; font-weight: 400;" class="btn w3-2017-primrose-yellow w3-hover-amber btn-warning text-dark ml-3 pl-4 pr-4">
          <i class="fa-solid fa-house"></i> 메인 홈으로
        </a>
      </div>
    </div>
  </div>
  <hr/>
</div>

<!-- 로그인 모달 -->
<div id="loginModal">
	<div class="modalBack"></div>
	<div class="width" style="position: relative; ">
		<div class="modalMain d-flex">
			<div class="d-flex fCol_center" style="width: 50%">
				<div class="text-center mb-3" style="font-size: 1.8em; font-weight: 500;">MEMBER LOGIN</div>
				<div class="p-4 ml-auto mr-auto" style="font-size: 1.1em; width: 80%;">
					<form>
						<div>로그인</div>
						<input type="text" name="loginMid" id="loginMid" class="form-control mt-2 mb-3" autocomplete='off'/>
						<div>비밀번호</div>
						<input type="password" name="loginPwd" id="loginPwd" class="form-control mt-2 mb-1" />
						<div id="loginInfo" class="mb-2 ml-1" style="color: red;font-size: 0.8em;font-weight: 300;">&nbsp;</div>
						<input type="button" value="로그인" onclick="loginCheck();" class="btn btn-success mb-2 form-control"/>
						<input type="button" value="회원가입" onclick="location.href='${ctp}/create.us'" class="btn btn-primary mb-2 form-control" />
					</form>
				</div>
				<div>
				</div>
			</div>
			<div class="ml-auto" style="width: 45%">
				<div class="modalClose" onclick="modalClose();"><i class="fa-solid fa-xmark"></i></div>
				<div class="d-flex fCol_center" style="height: 400px; border-left: 2px solid #e2e2e2; padding-left: 50px; padding-right: 30px;">
					<div class="text-left mb-2" style="font-size: 1.8em; font-weight: 500; font-family: 'Spoqa Han Sans Neo', 'sans-serif';">
						인테리어가 필요할땐
					</div>
					<img src="${ctp}/images/viewPage/logo-big.png" width="100%">
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 비밀번호 변경 모달 -->
<div id="pwdChangeModal">
	<div class="modalBack"></div>
	<div class="width" style="position: relative;">
		<div class="modalMain d-flex">
			<div class="d-flex fCol_center" style="width: 50%">
				<div class="text-center mb-3" style="font-size: 1.8em; font-weight: 500;">비밀번호 변경</div>
				<div class="p-4 ml-auto mr-auto" style="font-size: 1.1em; width: 80%;">
					<form>
						<div>기존 비밀번호</div>
						<input type="password" name="oldPwd" id="oldPwd" class="form-control mt-2 mb-3" autocomplete='off'/>
						<div>새로운 비밀번호</div>
						<input type="password" name="newPwd" id="newPwd" class="form-control mt-2 mb-1" />
						<div>비밀번호 재확인</div>
						<input type="password" name="newPwd2" id="newPwd2" class="form-control mt-2 mb-1" />
						<div id="pwdChangeInfo" class="mb-2 ml-1" style="color: red;font-size: 0.8em;font-weight: 300;">&nbsp;<br/>&nbsp;</div>
						<input type="button" value="비밀번호 변경" onclick="pwdChangeCheck();" class="btn btn-success mb-2 form-control"/>
					</form>
				</div>
				<div>
				</div>
			</div>
			<div class="ml-auto" style="width: 45%">
				<div class="modalClose" onclick="modalClose();"><i class="fa-solid fa-xmark"></i></div>
				<div class="d-flex fCol_center" style="height: 400px; border-left: 2px solid #e2e2e2; padding-left: 50px; padding-right: 30px;">
					<div class="text-left mb-2" style="font-size: 1.8em; font-weight: 500; font-family: 'Spoqa Han Sans Neo', 'sans-serif';">
						인테리어가 필요할땐
					</div>
					<img src="${ctp}/images/viewPage/logo-big.png" width="100%">
				</div>
			</div>
		</div>
	</div>
</div>
<script src="include/viewPage.js"></script>
<script>
	function pwdChangeCheck() {
		let sMid = "${sMid}";
		let oldPwd = $("#oldPwd").val();
		let newPwd = $("#newPwd").val();
		let newPwd2 = $("#newPwd2").val();
		let regPwd = /^([!@#$%^&+=<>?,\./\*()_-]?[a-zA-Z0-9]){6,20}$/g;
		if(oldPwd.trim() == "" || newPwd.trim() == "" || newPwd.trim() == ""){
			$("#pwdChangeInfo").html("모든 칸에 입력을 완료해주세요!<br/>&nbsp;");
			return;
		}
		if(newPwd != newPwd2){
			$("#pwdChangeInfo").html("재입력한 비밀번호가 불일치합니다<br/>&nbsp;");
			return;
		}
		if(!newPwd.match(regPwd)){
			$("#pwdChangeInfo").html("새 비밀번호가 양식에 올바르지 않습니다.<br/>다른 비밀번호를 입력해주세요.");
			return;
		}
		
		let res_sw = '0';
		$.ajax({
			type: "post",
			url : "{ctp}/oldPwdCheck.us",
			data: {mid:sMid,pwd:oldPwd},
			async: false,										// ajax 순차적(동기식 처리)
			success: function(res) {
				if(res == '1') res_sw = res;
				else $("#pwdChangeInfo").html("기존 비밀번호가 불일치합니다.<br/>&nbsp;");
			},
			error: function() {
				alert("전송 오류");
			}
		});
		
		if(res_sw == '0') return;
		
		if(oldPwd == newPwd){
			$("#pwdChangeInfo").html("기존과 같은 비밀번호입니다.<br/>다른 비밀번호를 입력해주세요.");
			return;
		}
		$.ajax({
			type: "post",
			url : "{ctp}/pwdUpdate.us",
			data: {mid:sMid,pwd:newPwd},
			async: false,
			success: function(res) {
				if(res == '1') {
					alert("비밀번호가 변경되었습니다.");
					location.href='${ctp}/myInfo.us';
				}
				else {
					$("#pwdChangeInfo").html("서버 오류로 인해 변경에 실패했습니다.<br/>&nbsp;");
					return;
				}
			},
			error: function() {
				alert("전송 오류");
			}
		});
	}
	
	function loginCheck() {
		let mid = $("#loginMid").val();
		let pwd = $("#loginPwd").val();
		
		if(mid.trim() == "" || pwd.trim() == ""){
			$("#loginInfo").html("아이디와 비밀번호를 입력후 로그인해주세요.");
			return;
		}
		
		$.ajax({
			type: "post",
			url : "${ctp}/loginCheck.us",
			data: {mid:mid,pwd:pwd},
			success: function(res){
				if (res == '1') location.href = "${ctp}/";
				else $("#loginInfo").html("아이디 혹은 비밀번호가 불일치합니다.");
			},
			error: function(){
				alert("전송 오류");
			}
		});
	}
	
	function logout() {
		$.ajax({
			url : "${ctp}/logoutCheck.us",
			success: function(){
				location.href = "${ctp}/";
			}
		});
	}
</script>
</body>
</html>