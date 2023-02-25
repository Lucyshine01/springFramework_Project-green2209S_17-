<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>createUserStep2.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="${ctp}/viewPage/viewPage.css" rel="stylesheet" type="text/css">
  <link href="${ctp}/css/inputForm.css" rel="stylesheet" type="text/css">
  <script>
	  'use strict';
	  function reSendActMail() {
		  disableBtn(10000);
			let email = '${email}'
			$.ajax({
				type: "post",
				url : "${ctp}/create/reSendActMail",
				data: {email,email},
				success: function(res) {
					if(res == '0') alert("알수 없는 오류로 인증메일 전송을 실패했씁니다.");
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
	  
	  function disableBtn(cnt) {
		  $("#sendBtnInfor").html("10초 후 재전송이 가능합니다.");
		  let delay = setInterval(function() {
			  cnt = cnt - 50;
			  document.getElementById("sendBtn").disabled = true;
			  if(cnt%1000 == 0 && cnt != 0) {
				  $("#sendBtnInfor").html((cnt/1000) + "초 후 재전송이 가능합니다.");
			  }
			  if(cnt == 0) {
				  clearTimeout(delay);
				  document.getElementById("sendBtn").disabled = false;
				  $("#sendBtnInfor").html("&nbsp;");
			  }
			},50);
		}
  </script>
</head>
<body ondragstart="return false" onselectstart="return false">
<div id="loading_Bar"></div>
<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
  <div style="background-color: #fafafa; padding-bottom: 100px; padding-top: 100px;">
    <div class="width">
      <div id="form" class="needs-validation">
        <div id="normal" class="text-center">
        	<div id="normalTitle">
	          <div class="mb-2 titleContent">이메일 인증</div>
          </div>
          <div class="container">
            <div class="text-center m-3">${email}로 인증 메일을 전송하였습니다.<br/>메일이 도착하지 않았으면 하단의 재전송 버튼을 눌러보세요.</div>
            <div class="row item-row">
              <div class="col-3"></div>
              <div class="col-6 d-flex fCol_center" style="margin-top: 30px;">
                <input type="button" id="sendBtn" value="인증메일 재전송" onclick="reSendActMail();" class="btn btn-warning">
              </div>
              <div class="col-3"></div>
            </div>
            <div id="sendBtnInfor">&nbsp;</div>
          </div>
        </div>
      </div>
    </div>
  </div>
<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
<script src="${ctp}/viewPage/viewPage.js"></script>
</body>
</html>