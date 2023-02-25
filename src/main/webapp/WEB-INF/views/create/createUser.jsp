<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>createUser.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="${ctp}/viewPage/viewPage.css" rel="stylesheet" type="text/css">
  <link href="${ctp}/css/inputForm.css" rel="stylesheet" type="text/css">
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
  <script>
	  'use strict';
	  let idOverSw = 0;
	  
	  const date = new Date();
	  let year = date.getFullYear();
	  let month = date.getMonth() + 1;
	  let day = date.getDate();
	  if((month + "").length == 1) month = "0" + month;
	  if((day + "").length == 1) day = "0" + day;
	  let max = "" + (year-19) + "-" + month + "-" + day;
	  
	  $(function(){
	    $(".form-item").click(function(){
	      $(this).next().find("input").focus();
	    });
	    $("#birth").attr("max",max);
	    
	    $("#mid").on("propertychange change paste input",function() {
	    	idOverSw = 0;
	    	$("#overCheckBtn").removeAttr("disabled");
	    	$("#check").hide();
	    });
	    
	    $("#mid").blur(function() {
				$("#midForm").addClass('was-validated');
			});
	    $("#email").blur(function() {
				$("#emailForm").addClass('was-validated');
			});
	    $("#tel").blur(function() {
				$("#telForm").addClass('was-validated');
			});
	    
	    
	  });
	  
	  function createUser() {
		  if(idOverSw == 0) {
			  alert("아이디 중복체크를 하세요!");
			  return;
		  }
			let mid = document.getElementById("mid").value;
			let email = document.getElementById("email").value;
			let tel = document.getElementById("tel").value;
			
			let regId = /^([a-zA-Z0-9]){6,20}$/g;   //아이디는 영문소문자,대문자,숫자,밑줄만 사용가능
			
			// ? : 있거나 없거나 최대 1개, 최소 0개
			let regEmail = /^([-_.]?[0-9a-zA-Z]){4,20}\@+([-_.]?[0-9a-zA-Z]){4,20}.+[a-zA-Z]{2,3}$/i; //이메일 형식에 맞도록 체크(a@b.c)
			let regTel = /^([0-9]){2,3}-+([0-9]){3,4}-+([0-9]){3,4}$/g;
			
			if(mid.trim() == ""){
				alert("아이디를 입력해주세요!");
	      document.getElementById("mid").focus();
	      return false;
			}
			else if(email.trim() == ""){
				alert("이메일을 입력해주세요!");
	      document.getElementById("email").focus();
	      return false;
			}
			else if(tel.trim() == ""){
				alert("전화번호를 입력해주세요!");
	      document.getElementById("tel").focus();
	      return false;
			}
			
			if(!mid.match(regId)){
				alert("허용되지 않는 아이디입니다!");
	      document.getElementById("mid").focus();
	      return false;
			}
			else if(!email.match(regEmail)){
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
					mid:mid,
					email:email,
					tel:tel
			}
			
			btnHide();
			
			$.ajax({
				type: "post",
				url : "${ctp}/create/createUser",
				data: query,
				success: function(res) {
					if(res == '0') {
						alert("인증메일 전송중 오류가 발생하였습니다.\n다시 시도해주세요.");
						btnShow();
						return false;
					}
					else if(res == '2') {
						alert("이미 존재하는 이메일입니다.\n다른 이메일을 입력해주세요.");
						$("#email").select();
						btnShow();
						return false;
					}
					else if(res == '3') {
						alert("이미 존재하는 전화번호입니다.");
						$("#tel").select();
						btnShow();
						return false;
					}
					else if(res == '1') {
						alert("해당메일로 인증메일을 전송하였습니다.\n인증 확인을 진행해주세요.");
						location.href = '${ctp}/create/emailSendMail?email='+email;
					}
				},
				error: function() {
					alert("전송 오류");
					btnShow();
				}
			});
			
		}
		
	  function btnShow() {
		  document.getElementById("createUserBtn").disabled = false;
		  $("#loadingImg").hide();
		}
	  function btnHide() {
		  document.getElementById("createUserBtn").disabled = true;
			$("#loadingImg").show();
		}
	  
	  function idOverCheck() {
			let mid = $("#mid").val();
			let regId = /^([a-zA-Z0-9]){6,20}$/g;
			if(mid.trim() == ""){
				alert("아이디를 입력해주세요.");
	      document.getElementById("mid").focus();
	      return false;
			}
			else if(!mid.trim().match(regId)){
				alert("허용되지 않는 아이디입니다!");
	      document.getElementById("mid").focus();
	      return false;
			}
			$.ajax({
				type: "post",
				url : "${ctp}/create/idOverCheck",
				data: {mid:mid},
				success: function(res) {
					if(res=="0"){
						alert("사용하실수 있는 아이디입니다.");
						idOverSw = 1;
						$("#overCheckBtn").attr("disabled","");
						$("#check").show();
					}
					else {
						alert("중복된 아이디가 있습니다!");
					}
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
  </script>
</head>
<body ondragstart="return false" onselectstart="return false">
<div id="loading_Bar"></div>
<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
  <div style="background-color: #fafafa; padding-bottom: 100px; padding-top: 100px">
    <div class="width">
      <div id="form">
        <div id="normal" class="text-center">
        	<div id="normalTitle">
	          <div class="mb-2 titleContent">1. 정 보 입 력</div>
	          <!-- <span class="subtitleContent">회원가입은 만 19세 이상부터 가능합니다.</span> -->
          </div>
          <div class="container">
            <div id="midForm" class="row item-row">
              <div class="col-2"></div>
              <div class="col-3 d-flex fCol_center form-item">아이디 ∗</div>
              <div class="col-5 d-flex fCol_center">
                <input type="text" id="mid" name="mid" class="form-control" placeholder="아이디를 입력하세요" required>
                <div class="invalid-feedback text-left">
                  아이디는 최소 6자 최대 20자입니다.
                </div>
              </div>
              <div class="col-2 d-flex" style="padding:0px;">
              	<div class="d-flex fCol_center"><input type="button" onclick="idOverCheck()" value="중복체크" id="overCheckBtn" class="btn btn-secondary" style="float: left; width: 80px"/></div>
              	<div class="d-flex fCol_center ml-2"><i id="check" class="fa-regular fa-circle-check" style="color: #03E646; font-size: 1.3em"></i></div>
              </div>
            </div>
            <div id="emailForm" class="row item-row">
              <div class="col-2"></div>
              <div class="col-3 d-flex fCol_center form-item">이메일 ∗</div>
              <div class="col-5 d-flex fCol_center">
                <input type="text" name="email" id="email" class="form-control" placeholder="example@exam.ple" required>
                <div class="invalid-feedback text-left">
                  이메일을 입력하세요.
                </div>
              </div>
              <div class="col-2"></div>
            </div>
            <div id="telForm" class="row item-row">
              <div class="col-2"></div>
              <div class="col-3 d-flex fCol_center form-item">전화번호 ∗</div>
              <div class="col-5 d-flex fCol_center">
                <input type="text" name="tel" id="tel" class="form-control" placeholder="ex (010)-####-###" required>
                <div class="invalid-feedback text-left">
                  전화번호를 입력해주세요.
                </div>
              </div>
              <div class="col-2"></div>
            </div>
            <div class="row item-row">
              <div class="col-3"></div>
              <div class="col-6 d-flex fCol_center" style="margin-top: 30px;">
                <input type="button" id="createUserBtn" value=" 다음 단계" onclick="createUser();" class="btn btn-warning"/>
                <img id="loadingImg" src='${ctp}/images/loading.gif' width="10%" style="position: absolute; right: 80px; display: none;"/>
              </div>
              <div class="col-3"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
<script src="${ctp}/viewPage/viewPage.js"></script>
</body>
</html>