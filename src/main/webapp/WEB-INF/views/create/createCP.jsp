<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>createCP.jsp</title>
  <jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="${ctp}/viewPage/viewPage.css" rel="stylesheet" type="text/css">
  <link href="${ctp}/css/inputForm.css" rel="stylesheet" type="text/css">
  <script>
	  'use strict';
	  function cpCreateCheck() {
		  
		  let ans = confirm("업체회원 신청 시에는 2000포인트가 소모됩니다.\n진행하시겠습니까?");
		  if(!ans) return;
		  
		  let mid = '${sMid}';
		  let name = document.getElementById("name").value;
			let cpName = document.getElementById("cpName").value;
			let cpIntro = document.getElementById("cpIntro").value;
			let cpHomePage = document.getElementById("cpHomePage").value;
			let cpExps = document.getElementsByName("cpExps");
			
			let postcode = document.getElementById("postcode").value;
			let address = document.getElementById("address").value;
			let detailAddress = document.getElementById("detailAddress").value;
			let extraAddress = document.getElementById("extraAddress").value;
			
			let cpAddr = postcode + " " + address + " " + detailAddress + " " + extraAddress;
			
			let cpImg = document.getElementById("cpImg").value;
			let exp = cpImg.substring(cpImg.lastIndexOf('.')).toUpperCase();
			cpImg = cpImg.substring(cpImg.lastIndexOf('\\')+1);
			
			let cpExp = "";
			for(let i=0; i<cpExps.length; i++){
				if(cpExps[i].checked){
					cpExp += cpExps[i].value + "/";
				}
			}
			if(cpExp.length > 1){
				cpExp = cpExp.substring(0, cpExp.length-1);
			}
			
			if(name.trim() == ""){
				alert("대표명을 입력해주세요!");
	      document.getElementById("name").focus();
	      return false;
			}
			else if(cpName.trim() == ""){
				alert("회사명을 입력해주세요!");
	      document.getElementById("cpName").focus();
	      return false;
			}
			else if(postcode.trim() == "" || address.trim() == ""){
				alert("주소를 입력해주세요!");
	      return false;
			}
			
			let maxSize = 1024 * 1024 * 10;
			let imgSize = 0;
			
			if(cpImg == "")imgSize = 0;
			else if(cpImg != null){
				if(exp != '.PNG' && exp != '.JPG'){
					alert("로고 파일명 확장자가 잘못 되었습니다.");
		      document.getElementById("cpImg").focus();
		      return false;
				}
				imgSize = document.getElementById("cpImg").files[0].size;
				if(imgSize > maxSize) {
					alert("파일 사이즈는 10MB까지 허용합니다!");
					return;
				}
			}
			
			let query = {
					name : name,
					cpName : cpName,
					cpIntro : cpIntro,
					cpAddr : cpAddr,
					cpHomePage : cpHomePage,
					cpExp : cpExp,
					mid : mid,
					
					cpImg : cpImg,
					imgSize : imgSize
			}
			
			let sw = 0;
			$.ajax({
				type: "post",
				url: "${ctp}/create/createCompanyData",
				data: query,
				async: false,
				success: function(res) {
					if(res == '0') alert("업체회원 신청에 실패했습니다.");
					else if(res == '2') alert("업체명이 동일한 업체가 있습니다.");
					else if(res == '3') alert("보유하신 포인트가 부족합니다.");
					else {
						if(cpImg == '') {
							alert("업체회원 신청이 완료되었습니다.\n승인 후 재 로그인시 업체회원으로 로그인됩니다.");
							location.href = '${ctp}/';
						}
						saveImg.fileName.value = cpImg;
						sw = 1;
					}
				},
				error: function() {
					alert("전송 오류");
				}
			}).done(function() {
				if(sw == 1) {
					let form = $("#saveImg")[0];
					let formData = new FormData(form);
					$.ajax({
						type: "post",
						url: "${ctp}/create/saveCpImg",
						data: formData,
						async: false,
						processData: false,
				    contentType: false,
						success: function(res) {
							location.href = '${ctp}/msg/createCpOk';
						},
						error: function() {
							alert("전송 오류 - 2");
						}
					});
				}
			});
		}
  </script>
  <style>
  	#form {width: 800px;}
  </style>
</head>
<body ondragstart="return false" onselectstart="return false">
<div id="loading_Bar"></div>
<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
  <div style="background-color: #fafafa; padding-bottom: 100px; padding-top: 100px">
    <div class="width">
      <div id="form">
        <div id="company" class="text-center">
        <div class="titleContent" style="margin-top: 30px; margin-bottom: 20px"> 기업 회원용 </div>
        <span class="subtitleContent">부적합한 내용으로 인해 관리자 승인을 받지 못할 경우<br/>1대1 문의를 통해 수정을 요청하실수 있습니다.</span>
        <div class="row item-row">
          <div class="col-2"></div>
          <div class="col-3 d-flex fCol_center form-item">회사명</div>
          <div class="col-5 d-flex fCol_center">
            <input type="text" name="cpName" id="cpName" class="form-control" required>
            <div class="invalid-feedback text-left">
              회사명을 입력해주세요.
            </div>
          </div>
          <div class="col-2"></div>
        </div>
        <div class="row item-row">
          <div class="col-2"></div>
          <div class="col-3 d-flex fCol_center form-item">대표 성명</div>
          <div class="col-5 d-flex fCol_center">
            <input type="text" name="name" id="name" class="form-control" required>
            <div class="invalid-feedback text-left">
              대표명을 입력해주세요.
            </div>
          </div>
          <div class="col-2"></div>
        </div>
        <div class="row item-row" style="margin-bottom: 8px;">
        	<div class="col-2"></div>
        	<div class="col-8 d-flex fCol_center form-item">회사 주소</div>
        	<div class="col-2"></div>
        </div>
        <div class="row item-row">
          <div class="col-2"></div>
          <div class="col-8 d-flex fCol_center" style="padding: 0">
            <!-- <input type="text" name="cpAddr" id="cpAddr" class="form-control" required> -->
            <div class="mb-2">
		          <div style="float:left; width: 67%"><input type="text" id="postcode" class="form-control" placeholder="우편번호"></div>
							<div style="float:right; width: 30%"><input type="button" onclick="execDaumPostcode()"  value="우편번호 찾기" class="btn btn-primary"></div>
						</div>
						<input type="text" id="address" class="form-control mb-2" placeholder="주소">
						<div class="mb-2">
							<div style="float:left; width: 49%"><input type="text" id="detailAddress" class="form-control" placeholder="상세주소"></div>
							<div style="float:right; width: 49%"><input type="text" id="extraAddress" class="form-control" placeholder="참고항목"></div>
						</div>
          </div>
          <div class="col-2"></div>
        </div>
        <div class="row item-row">
          <div class="col-2"></div>
          <div class="col-3 d-flex fCol_center form-item">홈페이지</div>
          <div class="col-5 d-flex fCol_center">
            <input type="text" name="cpHomePage" id="cpHomePage" class="form-control" placeholder="홈페이지가 있으시면 기입해주세요">
          </div>
          <div class="col-2"></div>
        </div>
        <div class="row item-row">
          <div class="col-2"></div>
          <div class="col-2 d-flex fCol_center form-item">전문분야</div>
          <div class="col-6">
          <div class="text-center categori">인테리어</div>
          <div class="d-flex checkFrom justify-content-start mb-2">
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="홈 인테리어" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;홈 인테리어</div>
            </div>
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="상업 인테리어" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;상업 인테리어</div>
            </div>
          </div>
          <div class="d-flex checkFrom justify-content-start">
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="조명 인테리어" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;조명 인테리어</div>
            </div>
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="욕실,화장실 인테리어" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;욕실,화장실 인테리어</div>
            </div>
          </div>
          <div class="text-center categori">시공</div>
          <div class="d-flex checkFrom justify-content-start mb-2">
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="타일시공" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;타일시공</div>
            </div>
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="페인트시공" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;페인트시공</div>
            </div>
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="싱크대 교체" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;싱크대 교체</div>
            </div>
          </div>
          <div class="d-flex checkFrom justify-content-start">
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="도배장판" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;도배장판시공</div>
            </div>
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="인테리어 필름" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;인테리어 필름시공</div>
            </div>
          </div>
          <div class="text-center categori">디자인</div>
          <div class="d-flex checkFrom justify-content-start mb-2">
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="도면 제작·수정" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;도면 제작·수정</div>
            </div>
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="인테리어 컨설팅" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;인테리어 컨설팅</div>
            </div>
          </div>
          <div class="d-flex checkFrom justify-content-start">
            <div class="d-flex">
              <div class="d-flex fCol_center"><input type="checkbox" name="cpExps" value="3D 모델링" ></div>
              <div class="d-flex fCol_center categori-item">&nbsp;3D 모델링</div>
            </div>
          </div>
        </div>
        <div class="col-2"></div>
      </div>
      <div class="row item-row">
        <!-- <div class="col-1"></div> -->
        <div class="col-1 d-flex fCol_center form-item" style="margin-left: 40px;">회사 소개</div>
        <div class="col-10 d-flex fCol_center"><textarea rows="7" name="cpIntro" id="cpIntro" placeholder="소개" class="form-control" style="resize: none;" ></textarea></div>
        <!-- <div class="col-1"></div> -->
      </div>
      <div class="row item-row">
        <div class="col-2"></div>
        <div class="col-3 d-flex fCol_center form-item">회사명 로고</div>
        <div class="col-5 d-flex fCol_center">
          <form id="saveImg">
          	<input type="file" name="cpImg" id="cpImg" class="mt-2 mb-3" required>
          	<input type="hidden" name="fileName"/>
          </form>
          <div class="invalid-feedback text-left" style="color: #666; top: 40px;">
            회사로고 이미지를 넣어주세요.(jpg,png파일만 허용합니다. 최대 10MByte)
          </div>
        </div>
        <div class="col-2"></div>
      </div>
      <div class="row item-row">
        <div class="col-3"></div>
        <div class="col-6 d-flex fCol_center" style="margin-top: 30px;">
            <input type="button" onclick="cpCreateCheck()" value="업체회원 신청" class="btn btn-warning">
          </div>
          <div class="col-3"></div>
        </div>
      </div>
    </div>
  </div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp"></jsp:include>
<script src="${ctp}/viewPage/viewPage.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	$("#info").html('업체회원 신청 후 수정 및 재작성시에는<br/>2000포인트가 소모됩니다.');
	$("#info").css("font-size","1.2em");
	$("#infoModal").show();
	$("#infoModal").animate({opacity:"1"},200);
  function execDaumPostcode() {
    new daum.Postcode({
      oncomplete: function(data) {
        // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

        // 각 주소의 노출 규칙에 따라 주소를 조합한다.
        // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
        var addr = ''; // 주소 변수
        var extraAddr = ''; // 참고항목 변수

        //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
        if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
            addr = data.roadAddress;
        } else { // 사용자가 지번 주소를 선택했을 경우(J)
            addr = data.jibunAddress;
        }

        // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
        if(data.userSelectedType === 'R'){
          // 법정동명이 있을 경우 추가한다. (법정리는 제외)
          // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
          if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
            extraAddr += data.bname;
          }
          // 건물명이 있고, 공동주택일 경우 추가한다.
          if(data.buildingName !== '' && data.apartment === 'Y'){
            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
          }
          // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
          if(extraAddr !== ''){
            extraAddr = ' (' + extraAddr + ')';
          }
          // 조합된 참고항목을 해당 필드에 넣는다.
          document.getElementById("extraAddress").value = extraAddr;
      
        } else {
          	document.getElementById("extraAddress").value = '';
        }

        // 우편번호와 주소 정보를 해당 필드에 넣는다.
        document.getElementById('postcode').value = data.zonecode;
        document.getElementById("address").value = addr;
        // 커서를 상세주소 필드로 이동한다.
        document.getElementById("detailAddress").focus();
      }
    }).open();
  }
</script>
</body>
</html>