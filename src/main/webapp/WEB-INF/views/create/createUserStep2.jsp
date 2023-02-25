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
	  const date = new Date();
	  let year = date.getFullYear();
	  let month = date.getMonth() + 1;
	  let day = date.getDate();
	  if((month + "").length == 1) month = "0" + month;
	  if((day + "").length == 1) day = "0" + day;
	  let max = "" + (year-19) + "-" + month + "-" + day;
	  
	  $(function(){
		  $("#pwdDanger1").removeClass('pwdDangerBar');
		  
	    $(".form-item").click(function(){
	      $(this).next().find("input").focus();
	    });
	    $("#birth").attr("max",max);
	    
	    $("#mid").on("propertychange change paste input",function() {
	    	idOverSw = 0;
	    	$("#overCheckBtn").removeAttr("disabled");
	    	$("#check").hide();
	    });
	    
	    $("#pwd").keyup(function() {
	    	let pwd = $("#pwd").val();
	    	let pwdLength = $("#pwd").val().length;
	    	
				if(pwdLength < 6) danger();
				else if(6 <= pwdLength && pwdLength < 10) {
					if(!pwdMiddleCheck(pwd)) return false;
					warning();
					$("#pwdSubInfor").html("")
				}
				else {
					if(!pwdMiddleCheck(pwd)) return false;
					safety();
					$("#pwdSubInfor").html("")
				}
			});
	    
	    $("#email").blur(function() {
				$("#emailForm").addClass('was-validated');
			});
	    $("#tel").blur(function() {
				$("#telForm").addClass('was-validated');
			});
	    
	  });
	  
	  function danger() {
		  $("#pwdDanger").html("위험");
			$("#pwdDanger1").removeClass('pwdDangerBar');
			$("#pwdDanger2").addClass('pwdDangerBar');
			$("#pwdDanger3").addClass('pwdDangerBar');
	  }
	  function warning() {
		  $("#pwdDanger").html("주의");
			$("#pwdDanger2").removeClass('pwdDangerBar');
			$("#pwdDanger1").addClass('pwdDangerBar');
			$("#pwdDanger3").addClass('pwdDangerBar');
	  }
	  function safety() {
		  $("#pwdDanger").html("안전");
			$("#pwdDanger3").removeClass('pwdDangerBar');
			$("#pwdDanger1").addClass('pwdDangerBar');
			$("#pwdDanger2").addClass('pwdDangerBar');
	  }
	  function pwdMiddleCheck(pwd) {
		  // ?= : 앞에서부터 해당패턴을 찾음 , . : 모든 문자열 , {n} or * or : n자리부터 or 첫자리부터 or 두번째자리부터
			// ?=.* : 첫번째 앞에서부터 모든 문자형식을 해당패턴으로 찾음
		  let pwdCheckReg = /(?=.*[~`!@#$%\^&*()-+=]).{1,}$/g;
    	let pwdCheckReg2 = /(?=.*[a-zA-Z0-9]).{1,}$/g;
    	let pwdCheckReg3 = /(?![~`!@#$%\^&*()-+=a-zA-Z0-9]).{1,}$/g;
		  if(pwd.match(pwdCheckReg) == null) {
				danger();
				$("#pwdSubInfor").html("특수문자가 포함되어야합니다.");
				return false;
			}
			else if(pwd.match(pwdCheckReg2) == null) {
				danger();
				$("#pwdSubInfor").html("영문 혹은 숫자를 포함시켜주세요.");
				return false;
			}
			else if(pwd.match(pwdCheckReg3) != null) {
				danger();
				$("#pwdSubInfor").html("허용되지 않는 문자가 있습니다!");
				return false;
			}
		  return true;
		}
	  
	  function createUser() {
		  
		  let tou = document.getElementById("terms_of_Use");
		  let uag = document.getElementById("usage_Agreement");
		  if(!tou.checked) {
			  alert("이용약관 동의를 하셔야합니다.");
			  return;
		  }
		  else if(!uag.checked) {
			  alert("개인정보 수집 및 이용 동의하셔야합니다.");
			  return;
		  }
		  
		  
			let mid = '${vo.mid}'
			let email = '${vo.email}'
			let pwd = $("#pwd").val();
			let birth = $("#birth").val();
			
			// ?= : 앞에서부터 해당 패턴의 해당하는 문자를 찾음
			// . : 모든 문자열
			// {n}, *, + : n번부터, 0번부터, 1번부터 - 인덱스번호
			// ?=.* : 첫자리부터 모든 문자형식을 해당패턴으로 찾음
			// ?! : 앞에서부터 해당 패턴에 해당하는 않는 문자를 찾음
			
			// 비밀번호는 [영문 대소문자,숫자(필수입력)],[키보드에서 입력가능한 특수문자(필수입력)] 사용가능 최소6자~최대20자
			let regPwd = /(?=.*[~`!@#$%\^&*()-+=])(?=.*[a-zA-Z0-9]).{6,20}$/g;
			
			// 해당패턴 외에 문자를 검사
			let regPwd2 = /(?![~`!@#$%\^&*()-+=a-zA-Z0-9]).{1,}$/g;
			
			if(pwd.trim() == ""){
				alert("비밀번호를 입력해주세요!");
	      document.getElementById("pwd").focus();
	      return false;
			}
			else if(birth.trim() == ""){
				alert("출생년도를 입력해주세요!");
	      document.getElementById("birth").focus();
	      return false;
			}
			
			if(!pwd.match(regPwd)){
				alert("비밀번호를 확인해주세요.");
	      document.getElementById("pwd").focus();
	      $("#pwdInfor").css("color","red");
	      return false;
			}
			else if(pwd.match(regPwd2)){
				alert("허용되지 않는 문자가 있습니다!");
	      document.getElementById("pwd").focus();
	      $("#pwdInfor").css("color","red");
	      return false;
			}
			
			let query = {
					mid:mid,
					email:email,
					pwd:pwd,
					birth:birth
			}
			
			document.getElementById("createUserBtn").disabled = true;
			
			$.ajax({
				type: "post",
				url : "${ctp}/create/createUserStep2",
				data: query,
				success: function(res) {
					if(res == '0'){
						alert("서버 오류로 인해 가입처리에 실패했습니다.");
						return false;
					}
					alert("회원가입이 완료되었습니다.\n로그인을 진행해주세요.");
					location.href = "${ctp}/";
				},
				error: function() {
					alert("전송 오류");
					document.getElementById("createUserBtn").disabled = false;
				}
			});
			
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
	          <div class="mb-2 titleContent">2. 회 원 가 입</div>
          </div>
          <div class="container">
            <div id="midForm" class="row item-row">
              <div class="col-2"></div>
              <div class="col-3 d-flex fCol_center form-item">아이디 ∗</div>
              <div class="col-5 d-flex fCol_center">
                <input type="text" id="mid" name="mid" class="form-control" value="${vo.mid}" disabled placeholder="아이디를 입력하세요" required>
                <div class="invalid-feedback text-left">
                  아이디는 최소 6자 최대 20자입니다.
                </div>
              </div>
            </div>
            <div id="pwdForm" class="row item-row">
              <div class="col-2">
              </div>
              <div class="col-3 d-flex fCol_center form-item">
              	비밀번호 ∗
              </div>
              <div class="col-5 d-flex fCol_center">
              	<div id="pwdInfor" class="mb-1 text-left">∗ 특수기호를 포함한 영문,숫자 6~20자</div>
                <input type="password" id="pwd" name="pwd" class="form-control" placeholder="비밀번호를 입력하세요" required maxlength="20">
                <div class="text-left mt-1 ml-2">
                  <span id="pwdSubInfor"></span>
                </div>
              </div>
              <div class="col-2 d-flex fCol_center" style="padding:0px;">
            		<div class="pwdDangerForm" style="font-size: 0.9em">비밀번호 보안<br/><span id="pwdDanger">위험</span></div>
              	<div class="pwdDangerForm mt-1">
              		<div id="pwdDanger1" class="pwdDangerBar"></div>
              		<div id="pwdDanger2" class="pwdDangerBar"></div>
              		<div id="pwdDanger3" class="pwdDangerBar"></div>
              	</div>
              </div>
            </div>
            <div id="emailForm" class="row item-row">
              <div class="col-2"></div>
              <div class="col-3 d-flex fCol_center form-item">이메일 ∗</div>
              <div class="col-5 d-flex fCol_center">
                <input type="text" name="email" id="email" class="form-control" value="${vo.email}" disabled placeholder="example@exam.ple" required>
                <div class="invalid-feedback text-left">
                  이메일을 입력하세요.
                </div>
              </div>
              <div class="col-2"></div>
            </div>
            <div class="row item-row">
              <div class="col-2"></div>
              <div class="col-3 d-flex fCol_center form-item">출생년도 ∗</div>
              <div class="col-5 d-flex fCol_center">
                <input type="date" name="birth" id="birth" class="form-control" required>
                <div class="invalid-feedback text-left">
                  출생년도을 입력해주세요
                </div>
              </div>
              <div class="col-2"></div>
            </div>
            <div class="row">
            	<div class="col-1"></div>
            	<div class="col-10" style="font-size: 1.6em; font-weight: bold;"><br/>약관 동의</div>
            	<div class="col-1"></div>
            </div>
            <br/><hr/><br/>
            <div class="row">
            	<div class="col-1"></div>
            	<div class="col-10">
            		<div class="d-flex" style="line-height: 2.5em; text-align: left">이용약관 동의<font color="red">(필수)</font>
            			<div class="ml-auto d-flex fCol_center"><input type="checkbox" id="terms_of_Use" style="transform: scale(1.3)"/></div>
            		</div>
            		<textarea readonly="readonly" class="p-3" style="width: 100%;resize:none; overflow-y: scroll; height: 200px; font-size: 0.8em; color: #bbb">
제1조(목적) 이 약관은 업체 회사(전자상거래 사업자)가 운영하는 업체 사이버 몰(이하 “몰”이라 한다)에서 제공하는 인터넷 관련 서비스(이하 “서비스”라 한다)를 이용함에 있어 사이버 몰과 이용자의 권리․의무 및 책임사항을 규정함을 목적으로 합니다.
 
  ※「PC통신, 무선 등을 이용하는 전자상거래에 대해서도 그 성질에 반하지 않는 한 이 약관을 준용합니다.」
 
제2조(정의)
 
  ① “몰”이란 업체 회사가 재화 또는 용역(이하 “재화 등”이라 함)을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 등을 거래할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 사이버몰을 운영하는 사업자의 의미로도 사용합니다.
 
  ② “이용자”란 “몰”에 접속하여 이 약관에 따라 “몰”이 제공하는 서비스를 받는 회원 및 비회원을 말합니다.
 
  ③ ‘회원’이라 함은 “몰”에 회원등록을 한 자로서, 계속적으로 “몰”이 제공하는 서비스를 이용할 수 있는 자를 말합니다.
 
  ④ ‘비회원’이라 함은 회원에 가입하지 않고 “몰”이 제공하는 서비스를 이용하는 자를 말합니다.
 
제3조 (약관 등의 명시와 설명 및 개정) 
 
  ① “몰”은 이 약관의 내용과 상호 및 대표자 성명, 영업소 소재지 주소(소비자의 불만을 처리할 수 있는 곳의 주소를 포함), 전화번호․모사전송번호․전자우편주소, 사업자등록번호, 통신판매업 신고번호, 개인정보관리책임자 등을 이용자가 쉽게 알 수 있도록 00 사이버몰의 초기 서비스화면(전면)에 게시합니다. 다만, 약관의 내용은 이용자가 연결화면을 통하여 볼 수 있도록 할 수 있습니다.
 
  ② “몰은 이용자가 약관에 동의하기에 앞서 약관에 정하여져 있는 내용 중 청약철회․배송책임․환불조건 등과 같은 중요한 내용을 이용자가 이해할 수 있도록 별도의 연결화면 또는 팝업화면 등을 제공하여 이용자의 확인을 구하여야 합니다.
 
  ③ “몰”은 「전자상거래 등에서의 소비자보호에 관한 법률」, 「약관의 규제에 관한 법률」, 「전자문서 및 전자거래기본법」, 「전자금융거래법」, 「전자서명법」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」, 「방문판매 등에 관한 법률」, 「소비자기본법」 등 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.
 
  ④ “몰”이 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행약관과 함께 몰의 초기화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 이용자에게 불리하게 약관내용을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지합니다.  이 경우 "몰“은 개정 전 내용과 개정 후 내용을 명확하게 비교하여 이용자가 알기 쉽도록 표시합니다. 
 
  ⑤ “몰”이 약관을 개정할 경우에는 그 개정약관은 그 적용일자 이후에 체결되는 계약에만 적용되고 그 이전에 이미 체결된 계약에 대해서는 개정 전의 약관조항이 그대로 적용됩니다. 다만 이미 계약을 체결한 이용자가 개정약관 조항의 적용을 받기를 원하는 뜻을 제3항에 의한 개정약관의 공지기간 내에 “몰”에 송신하여 “몰”의 동의를 받은 경우에는 개정약관 조항이 적용됩니다.
 
  ⑥ 이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제 등에 관한 법률, 공정거래위원회가 정하는 「전자상거래 등에서의 소비자 보호지침」 및 관계법령 또는 상관례에 따릅니다.
 
            		</textarea>
            	</div>
            	<div class="col-1"></div>
            </div>
            <div class="row">
            	<div class="col-1"></div>
            	<div class="col-10">
            		<div class="d-flex" style="line-height: 2.5em; text-align: left">개인정보 수집 및 이용 동의<font color="red">(필수)</font>
            			<div class="ml-auto d-flex fCol_center"><input type="checkbox" id="usage_Agreement" style="transform: scale(1.3)"/></div>
            		</div>
            		<textarea readonly="readonly" class="p-3" style="width: 100%;resize:none; overflow-y: scroll; height: 200px; font-size: 0.8em; color: #bbb">
개인정보처리방침

[차례]
1. 총칙
2. 개인정보 수집에 대한 동의
3. 개인정보의 수집 및 이용목적
4. 수집하는 개인정보 항목
5. 개인정보 자동수집 장치의 설치, 운영 및 그 거부에 관한 사항
6. 목적 외 사용 및 제3자에 대한 제공
7. 개인정보의 열람 및 정정
8. 개인정보 수집, 이용, 제공에 대한 동의철회
9. 개인정보의 보유 및 이용기간
10. 개인정보의 파기절차 및 방법
11. 아동의 개인정보 보호
12. 개인정보 보호를 위한 기술적 대책
13. 개인정보의 위탁처리
14. 의겸수렴 및 불만처리
15. 부 칙(시행일) 

1. 총칙

본 업체 사이트는 회원의 개인정보보호를 소중하게 생각하고, 회원의 개인정보를 보호하기 위하여 항상 최선을 다해 노력하고 있습니다. 
1) 회사는 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」을 비롯한 모든 개인정보보호 관련 법률규정을 준수하고 있으며, 관련 법령에 의거한 개인정보처리방침을 정하여 이용자 권익 보호에 최선을 다하고 있습니다.
2) 회사는 「개인정보처리방침」을 제정하여 이를 준수하고 있으며, 이를 인터넷사이트 및 모바일 어플리케이션에 공개하여 이용자가 언제나 용이하게 열람할 수 있도록 하고 있습니다.
3) 회사는 「개인정보처리방침」을 통하여 귀하께서 제공하시는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려드립니다.
4) 회사는 「개인정보처리방침」을 홈페이지 첫 화면 하단에 공개함으로써 귀하께서 언제나 용이하게 보실 수 있도록 조치하고 있습니다.
5) 회사는  「개인정보처리방침」을 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다.

2. 개인정보 수집에 대한 동의

귀하께서 본 사이트의 개인정보보호방침 또는 이용약관의 내용에 대해 「동의 한다」버튼 또는 「동의하지 않는다」버튼을 클릭할 수 있는 절차를 마련하여, 「동의 한다」버튼을 클릭하면 개인정보 수집에 대해 동의한 것으로 봅니다.

3. 개인정보의 수집 및 이용목적

본 사이트는 다음과 같은 목적을 위하여 개인정보를 수집하고 있습니다.
서비스 제공을 위한 계약의 성립 : 본인식별 및 본인의사 확인 등
서비스의 이행 : 상품배송 및 대금결제
회원 관리 : 회원제 서비스 이용에 따른 본인확인, 개인 식별, 연령확인, 불만처리 등 민원처리
기타 새로운 서비스, 신상품이나 이벤트 정보 안내
단, 이용자의 기본적 인권 침해의 우려가 있는 민감한 개인정보(인종 및 민족, 사상 및 신조, 출신지 및 본적지, 정치적 성향 및 범죄기록, 건강상태 등)는 수집하지 않습니다.

4. 수집하는 개인정보 항목

본 사이트는 회원가입, 상담, 서비스 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다. 
1) 개인정보 수집방법 : 홈페이지(회원가입)
2) 수집항목 : 이름 , 생년월일 , 성별 , 로그인ID , 비밀번호 , 전화번호 , 주소 , 휴대전화번호 , 이메일 , 주민등록번호 , 접속 로그 , 접속 IP 정보 , 결제기록

            		</textarea>
            	</div>
            	<div class="col-1"></div>
            </div>
            <div class="row item-row">
              <div class="col-3"></div>
              <div class="col-6 d-flex fCol_center" style="margin-top: 30px;">
                <input type="button" id="createUserBtn" value="회원가입" onclick="createUser();" class="btn btn-warning">
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