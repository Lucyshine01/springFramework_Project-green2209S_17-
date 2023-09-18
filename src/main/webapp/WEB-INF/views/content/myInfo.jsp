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
  <link href="${ctp}/viewPage/viewPage.css" rel="stylesheet" type="text/css">
  <!-- iamport.payment.js -->
  <script src="https://cdn.iamport.kr/js/iamport.payment-1.1.8.js"></script>
  <script>
  	'use strict';
  	
  	function requestPay() {
  			let buyCode = ''
  			let selectProduct = '';
  			let productAmount = 0;
  			document.getElementsByName('point').forEach(function(e) {
					if(e.checked) selectProduct = e.value;
				});
  			
  			$.ajax({
  				type: 'post',
  				url: '${ctp}/member/getBuyCode',
  				data: {selectIdx:selectProduct},
  				async: false,
  				success: function(res) {
  					if(res == '0') {
  						alert("결제 오류");
  						return;
  					}
						buyCode = res.split("/")[0];
						selectProduct = res.split("/")[1]; 
						productAmount = res.split("/")[2]; 
					},
  				error: function() {
						alert("결제 오류1");
						return;
					}
  			});
  			
  			productAmount = 10;
				const IMP = window.IMP; // 생략 가능
				IMP.init("imp57552168"); // 예: imp00000000a
        IMP.request_pay({
            pg : 'html5_inicis.INIpayTest',
            pay_method : 'card',
            merchant_uid: buyCode, 
            name : selectProduct,
            amount : productAmount,
            buyer_email : '${vo.email}',
            buyer_name : '${vo.mid}',
            buyer_tel : '${vo.tel}',
            buyer_addr : '',
            buyer_postcode : ''
        }, function (rsp) { // callback
        	let data = JSON.stringify(rsp);
        	
          $.ajax({
          	type: 'post',
	  				url: '${ctp}/member/productBuy',
	  				data: data,
	  				contentType : "application/json; charset=UTF-8",
	  				async: false,
	  				success: function(mapData) {
	  					if(mapData.res == '0') {
	  						alert("결재가 취소되었습니다.\n다시 시도해주세요.");
	  						//document.location.reload(true);
	  						return;
	  					}
	  					let strMapData = JSON.stringify(mapData);
	  					$.ajax({
	  						type: 'post',
  		  				url: '${ctp}/member/pointBuyingProcess',
  		  				data: strMapData,
  		  				contentType : "application/json; charset=UTF-8",
  		  				async: false,
  		  				success: function(res) {
  		  					if(res == '0') {
  		  						alert("포인트 지급처리 중 문제가 발생했습니다.\n관리자에게 문의하십시오.");
  		  						return;
  		  					}
		  						alert("결제 처리가 완료되었습니다.");
		  						document.location.reload(true);
  		  				},
	  		  			error: function() {
		  		  			alert("포인트 지급처리 중 문제가 발생했습니다.\n관리자에게 문의하십시오.");
		  						return;
	  		  			}
	  					});
						},
	  				error: function() {
							alert("결제 오류2");
							return;
						}
          });
        });
    }
  	
  	function myInfoDelete() {
			let ans = confirm("정말로 계정을 탈퇴처리 하시겠습니까?");
			if(!ans) return;
			ans = confirm("탈퇴처리 후 계정을 복구할 수 없으며,\n해당 계정과 연동되있는 이메일,전화번호를 다시 이용할수 없습니다.\n그래도 진행하시겠습니까?");
			if(!ans) return;
			
			$.ajax({
				type: "post",
				url: "${ctp}/member/myInfoDelete",
				success: function() {
					alert("탈퇴처리 되었습니다.");
					location.href="${ctp}/";
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
  	
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
  				idx : '${vo.idx}',
  				email: email,
  				tel  : tel,
  				birth: birth
  		}
  		
  		$.ajax({
  			type: "post",
  			url : "${ctp}/member/myinfoUpdate",
  			data: query,
  			success: function(res) {
					if(res == '1') {
						alert("회원 정보가 수정되었습니다.");
						document.location.reload(true);
					}
					else alert("수정에 실패했습니다.");
				}
  		});
		}
  	
  	function profileDefault() {
  		$.ajax({
  			type: "post",
  			url : "${ctp}/member/profileDefault",
  			success: function() {document.location.reload(true);}
  		});
		}
  	
  	function myInfoReset() {
			let email = "${vo.email}";
			let tel = "${vo.tel}";
			let birth = '<fmt:formatDate value="${vo.birth}" pattern="yyyy-MM-dd"/>';
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
  .item .item-text input[type=text],input[type=date] {
  	text-align: center;
  	padding: 3px;
  	border: 2px solid #e0e0e0;
  	border-radius: 5px;
  	outline: none;
  }
  #pointTable::-webkit-scrollbar {
		width: 11px;
    height: 20%;
	}
  #pointTable::-webkit-scrollbar-track {background: rgba(0,0,0,0);}
  #pointTable::-webkit-scrollbar-thumb {
    background: rgba(40,40,40,0.5);
    background-clip: padding-box;
    border: 2px solid transparent;
    border-radius: 10px;
	}
	.checkBtn {
		width: 100%;
		height: 45px;
		border-radius: 3px;
		border: 1px solid rgba(50,50,50,0.3);
		margin: 10px 0px;
		box-shadow: 0 0 2px 2px rgba(100,100,100,0.1);
		cursor: pointer;
	}
	.radioBtn {
		margin-left: 20px;
		cursor: pointer;
	}
	.radioText {
		margin-left: 40px;
		text-align: left;
		font-size: 1.1em;
		font-weight: 400;
	}
  </style>
</head>
<body ondragstart="return false" onselectstart="return false">
	<jsp:include page="/WEB-INF/views/include/notice.jsp"></jsp:include>
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
			<div class="d-flex fCol_center ml-auto mr-auto" style="width: 38%;justify-content:flex-start;">
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
						<fmt:formatDate value="${vo.createDay}" pattern="yyyy년 MM월 dd일"/>
					</div>
					<div class="botLine"></div>
				</div>
				<div class="d-flex mb-5 item">
					<div class="form-item d-flex fCol_center">프로필</div>
					<div class="d-flex text-center item-text mr-auto">
						<img src="${ctp}/images/profile/${vo.profile}" class="ml-5" style="width: 100px; height: 100px; object-fit: cover;"/>
						<div class="ml-2 d-flex fCol_center" style="justify-content: flex-end; font-size:0.8em; width: 68px;">
							<c:if test="${vo.profile != 'default.jpg'}"><div class="mb-4"><input type="button" onclick="profileDefault()" value="기본 프로필로 변경" class="btn btn-warning"/></div></c:if>
							<form name="profileForm" action="${ctp}/member/profileChange" method="post" enctype="multipart/form-data"><input type="file" name="profile" id="profile" /></form>
						</div>
					</div>
				</div>
			</div>
			<div class="d-flex fCol_center ml-auto mr-auto" style="width: 38%;justify-content:flex-start;">
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
						<div class="ml-auto mr-auto" style="width: 190px"><input type="date" name="birth" id="birth" required></div>
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
				<input type="button" onclick="myInfoDelete()" value="회원탈퇴" class="btn btn-secondary mr-2"/>
				<input type="button" onclick="myInfoUpdate()" value="수정하기" class="btn btn-danger mr-2"/>
				<input type="button" onclick="myInfoReset()" value="원래대로" class="btn btn-success"/>
			</div>
		</div>
	</div>
	<div class="width mt-5 mb-3">
		<div class="text-center" style="font-size: 2.8em; font-weight: 600; margin-bottom: 10px;">
			포인트 사용 내역
		</div>
		<div class="text-center mb-4" style="color: #bbb; font-weight: 300">
			고객님이 사용하신 포인트 내역입니다.<br/>
			사용하실 포인트를 충전하실수 있습니다.
		</div>
		<hr class="ml-auto mr-auto" style="margin-bottom: 50px; width: 90%; box-shadow: 0px 1px 1px 1px #aaa;"/>
		<div class="d-flex p-3" >
			<div id="pointTable" class="col-9 text-center p-0" style="height: 600px; width:1000px; border: 2px solid rgba(50,50,50,0.1); overflow-y: auto;">
				<table class="table table-hover">
					<tr>
						<td>시간</td>
						<td>사용 포인트</td>
						<td>남은 포인트</td>
						<td>사용 사유</td>
						<td>사용일</td>
					</tr>
					<c:forEach var="pointVO" items="${pointVOS}" varStatus="st">
						<tr class="pt-1 pb-1">
							<td><fmt:formatDate value="${pointVO.usePointDay}" pattern="HH:mm" /></td>
							<td><fmt:formatNumber value="${pointVO.usePoint}" pattern="#,###pt" /></td>
							<td><fmt:formatNumber value="${pointVO.leftPoint}" pattern="#,###pt" /></td>
							<td>${pointVO.useContent}</td>
							<td><fmt:formatDate value="${pointVO.usePointDay}" pattern="yyyy년 MM월 dd일" /></td>
						</tr>
					</c:forEach>
					<tr><td colspan="5" style="padding: 0px"></td></tr>
				</table>
			</div>
			<div class="text-left pt-3 ml-auto" style="width: 250px;">
				<form name="pointChargeForm" class="d-flex fCol_center">
					<input type="button" value="포인트 충전" onclick="requestPay();" class="btn btn-warning btn-lg w3-2017-primrose-yellow w3-hover-amber mb-3 pt-4 pb-4"/>
					<div class="d-flex checkBtn"><input type="radio" name="point" class="radioBtn" value="1" checked="checked"/><span class="radioText d-flex fCol_center">1000pt - 1000원</span></div>
					<div class="d-flex checkBtn"><input type="radio" name="point" class="radioBtn" value="2" /><span class="radioText d-flex fCol_center">5000pt - 5000원</span></div>
					<div class="d-flex checkBtn"><input type="radio" name="point" class="radioBtn" value="3" /><span class="radioText d-flex fCol_center">10000pt - 9200원</span></div>
					<div class="d-flex checkBtn"><input type="radio" name="point" class="radioBtn" value="4" /><span class="radioText d-flex fCol_center">30000pt - 27000원</span></div>
					<div class="d-flex checkBtn"><input type="radio" name="point" class="radioBtn" value="5" /><span class="radioText d-flex fCol_center">100000pt - 88000원</span></div>
				</form>
			</div>
		</div>
	</div>
	
	
	<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
	<script>
		'use strict';
		let birth = '<fmt:formatDate value="${vo.birth}" pattern="yyyy-MM-dd"/>';
  	$("#birth").val(birth);
  	
  	$(function() {
			$(".checkBtn").click(function() {
				$(".radioBtn").prop("checked",false);
				$(this).children(".radioBtn").prop("checked",true);
			});
			
			$("#profile").change(function() {
				let val = $("#profile")[0].files[0].name;
				let type = $("#profile")[0].files[0].type;
				let size = $("#profile")[0].files[0].size;
		    let exp = val.substring(val.lastIndexOf('.')+1).toUpperCase();
		    if(exp != 'PNG' && exp != "JPG" && exp != "JPEG" && exp != "BMP" && exp != "JFIF" && exp != "TIFF" && exp != "SVG" && exp != "WEBP") {
		      alert("허용 되지 않는 확장자입니다!\n확장자 - png, jpg, jpeg, jfif, webp, bmp, tiff, svg");
		      return;
		    }
		    else if(size > (1024*1024*20)) {
		    	alert("파일 최대 크기는 20Mb입니다.");
		      return;
		    }
		    profileForm.submit();
			});
		});
  	
	</script>
	<script src="${ctp}/viewPage/viewPage.js"></script>
</body>
</html>