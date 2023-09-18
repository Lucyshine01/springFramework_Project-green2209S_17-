<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<div id="headMain" class="container-fluid-xl" style="z-index: 9;background-color:#fff;" >
  <div class="width d-flex">
    <div id="logo" class="d-flex fCol_center header pl-4">
    <!-- http://192.168.50.79:9090/green2209J_17/ -->
      <a href="${ctp}/"><img src="${ctp}/viewPage/logo3.png" width="120px"/></a>
    </div>
    <div></div>
    <div id="searchBox" class="ml-auto d-flex text-center fCol_center header">
      <input type="text" id="search1" name="search1" class="searchAnythingBox" placeholder="원하는 업체를 검색해 보세요" autocomplete='off' spellcheck="false">
      <i class="fa-solid fa-magnifying-glass"></i>
      <i class="fa-solid fa-circle-xmark iconHidden" onclick="removeSearch()"></i>
    </div>
    <div id="loginBox" class="d-flex fCol_center header">
    	<c:if test="${sUserLevel != '관리자'}">
	      <div>
	      	<c:if test="${sUserLevel == '일반' || empty sMid}">
	      		<button type="button" onclick="createCP();" class="btn w3-hover-light-grey text-dark ml-3 pl-4 pr-4">
	          업체등록
	        	</button>
	      	</c:if>
	      	<c:if test="${sUserLevel == '업체'}">
	      		<button type="button" onclick="location.href='${ctp}/member/companyInfo'" class="btn w3-hover-light-grey text-dark ml-3 pl-4 pr-4">
	          업체정보
	        	</button>
	      	</c:if>
	        <c:if test="${empty sMid}">
		        <button type="button" onclick="loginModalOn();" class="btn w3-hover-light-grey text-dark ml-3 pl-4 pr-4">
		          로그인
		        </button>
		        <button type="button" onclick="location.href='${ctp}/create/createUser'" style="margin-right: 15px" class="btn w3-2017-primrose-yellow w3-hover-amber btn-warning text-dark ml-3 pl-4 pr-4">
		          회원 가입
		        </button>
	        </c:if>
	        <c:if test="${!empty sMid}">
		        <button type="button" onclick="logout();" class="btn w3-hover-light-grey text-dark ml-3 pl-4 pr-4">
		          로그아웃
		        </button>
		        <button type="button" onclick="location.href='${ctp}/member/myInfo'" style="margin-right: 15px" class="btn w3-2017-primrose-yellow w3-hover-amber btn-warning text-dark ml-3 pl-4 pr-4">
		          내정보
		        </button>
	        </c:if>
	      </div>
      </c:if>
      <c:if test="${sUserLevel == '관리자'}">
      	<div>
	      	<button type="button" onclick="logout();" class="btn w3-hover-light-grey text-dark ml-3 pl-4 pr-4">
	          로그아웃
	        </button>
	        <button type="button" onclick="location.href='${ctp}/admin/main'" style="margin-right: 15px" class="btn w3-2017-primrose-yellow w3-hover-amber btn-warning text-dark ml-3 pl-4 pr-4">
	          관리자 화면
	        </button>
        </div>
      </c:if>
    </div>
  </div>
  <div class="d-flex width">
    <nav class="navbar">
      <div class="navbar-nav navIconBox">
        <div class="nav-item dropdown">
          <span class="nav-link dropdown-toggle nav-icon" id="navbardrop" data-toggle="dropdown">
            <i class="fa-solid fa-bars"></i>&nbsp;&nbsp;<b>전체카테고리</b>
          </span>
          <div class="dropdown-menu" style="position: absolute;">
            <span class="dropdown-item none-item">인테리어</span>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=1&detail=1">홈 인테리어</a>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=1&detail=2">상업공간 인테리어</a>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=1&detail=3">조명 인테리어</a>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=1&detail=4">욕실/화장실 리모델링</a>
            <span class="dropdown-item none-item">시공</span>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=2&detail=1">타일시공</a>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=2&detail=2">페인트시공</a>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=2&detail=3">싱크대 교체</a>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=2&detail=4">도배장판 시공</a>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=2&detail=5">인테리어 필름 시공</a>
            <span class="dropdown-item none-item">디자인</span>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=3&detail=1">도면 제작·수정</a>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=3&detail=2">인테리어 컨설팅</a>
            <a class="dropdown-item" href="${ctp}/member/companyList?categori=3&detail=3">3D 모델링</a>
          </div>
        </div>
      </div>
      <div class="navIconBox">
        <a href="${ctp}/member/companyList" class="nav-link nav-icon d-flex fCol_center">업체 목록</a>
        <span id="help1" class="help">인테모아의 다양한 <b>업체</b>를 만나보세요.</span>
      </div>
      <div class="navIconBox">
        <a href="${ctp}/member/helpCenter" class="nav-link nav-icon d-flex fCol_center">고객센터</a>
        <span id="help2" class="help">관리자와 <b>1대1 문의/답변</b>이 가능합니다.</span>
      </div>
      <!-- <div class="navIconBox">
        <a href="#" class="nav-link nav-icon d-flex fCol_center">의뢰 목록</a>
        <span id="help3" class="help">다양한 분야의 <b>전문가</b>에게 의뢰해보세요.<br/>(미구현)</span>
      </div> -->
      <div class="navIconBox">
        <a href="${ctp}/member/reviewList" class="nav-link nav-icon d-flex fCol_center">후기</a>
        <span id="help3" class="help">업체 및 인테모아의 <b>사용후기</b>를 찾아보세요.</span>
      </div>
      <div style="width: 150px;"></div>
    </nav>
   	<div class="ml-auto d-flex">
		  <div class="d-flex fCol_center" style="padding-right: 15px">
		    <a href="${ctp}/member/reviewList" class="nav-link nav-icon d-flex fCol_center" style="font-size: 1em;">
		      <span>맘에 드는 업체를 못 찾겠다면, <b>후기 검색</b>을 해보세요! ></span>
		    </a>
		  </div>
    </div>
  </div>
  <hr/>
</div>

<!-- fix시 공백채우기 -->
<div id="headMainSpace"></div>
<!-- fix시 공백채우기 -->

<!-- 로그인 모달 -->
<div id="loginModal" class="modalCss">
	<div class="modalBack"></div>
	<div class="width" style="position: relative; ">
		<div class="modalMain d-flex">
			<div class="d-flex fCol_center" style="width: 50%">
				<div class="text-center mb-3" style="font-size: 1.8em; font-weight: 500;">MEMBER LOGIN</div>
				<div class="p-4 ml-auto mr-auto" style="font-size: 1.1em; width: 80%;">
					<form>
						<div>로그인</div>
						<input type="text" value="${cookie.cMid.value}" name="loginMid" id="loginMid" class="form-control mt-2 mb-3" autocomplete='off'/>
						<div>비밀번호</div>
						<input type="password" name="loginPwd" id="loginPwd" class="form-control mt-2 mb-1" />
						<div class="mb-2 d-flex" style="font-size: 0.9em; font-weight: 400;">
							<div class="ml-auto mr-2 mt-2">
						 		아이디 저장 <input type="checkbox" name="rememId" id="rememId" value="on" ${cookie.cMid.value != null ? 'checked' : ''} />
						 	</div>
						 </div>
						<div id="loginInfo" class="mb-2 ml-1" style="color: red;font-size: 0.8em;font-weight: 300;">&nbsp;<br/>&nbsp;</div>
						<input type="button" value="로그인" onclick="loginCheck();" style="font-size: 1.1em;" class="btn btn-warning mb-2 form-control text-white"/>
						<input type="button" value="회원가입" onclick="location.href='${ctp}/create/createUser'" style="font-size: 1.1em;" class="btn btn-info mb-2 form-control text-white" />
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
					<img src="${ctp}/viewPage/logo-big.png" width="100%">
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 비밀번호 변경 모달 -->
<div id="pwdChangeModal" class="modalCss">
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
						<input type="button" value="비밀번호 변경" onclick="pwdChange()" class="btn btn-warning mb-2 form-control"/>
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
					<img src="${ctp}/viewPage/logo-big.png" width="100%">
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 기타 알림 모달 -->
<div id="infoModal" class="modalCss">
	<div class="modalBack"></div>
	<div class="width" style="position: relative;">
		<div class="modalMain text-center" style="width: 400px">
			<div style="font-size: 2.3em; font-weight: bold;">알림</div>
			<div id="info"></div>
			<input type="button" value="확인" class="btn btn-warning form-control" onclick="modalClose();" />
		</div>
	</div>
</div>

<!-- 신고 모달 -->
	<div id="reportModal" class="modalCss">
		<div class="modalBack"></div>
		<div class="width" style="position: relative;">
			<div class="modalMain text-center" style="width: 400px">
				<div style="font-size: 1.8em; font-weight: bold;">댓글 신고</div>
				<div class="d-flex mt-2 mb-2">
					<div class="mb-1 d-flex fCol_center" style="width: 110px">신고 사유</div> 
					<select id="selectReport" class="form-control" onchange="selectReport()">
						<option value="" >신고사유를 선택하세요</option>
						<option value="1" >광고 및 도배관련 댓글</option>
						<option value="2" >욕설 및 모욕적인 내용</option>
						<option value="3" >허위사실를 유포하는 내용</option>
						<option value="etc" >기타</option>
					</select>
				</div>
				<div class="mb-2"><textarea  id="reportContent" rows="4" class="form-control" placeholder="사유를 입력해주세요" style="resize: none;" disabled="disabled"></textarea></div>
				<input type="button" id="reportBtn" value="신고" class="btn btn-danger"/>
				<input type="button" value="닫기" class="btn btn-warning" onclick="modalClose();" />
				<input type="hidden" id="re_idx" name="re_idx"/>
			</div>
		</div>
	</div>

<script>
	'use strict';
	
	
	$(function() {
		if($("#loginMid").val() != ""){
			$("#rememId").attr("checked","checked");
		}
	});
	
	function pwdChange() {
		let oldPwd = $("#oldPwd").val();
		let newPwd = $("#newPwd").val();
		let newPwd2 = $("#newPwd2").val();
		// ?= : 앞에서부터 해당패턴을 찾음 , . : 모든 문자열 , {n} or * or : n자리부터 or 첫자리부터 or 두번째자리부터
		// ?=.* : 첫번째 앞에서부터 모든 문자형식을 해당패턴으로 찾음
	  let pwdCheckReg = /(?=.*[~`!@#$%\^&*()-+=]).{1,}$/g;
		let pwdCheckReg2 = /(?=.*[a-zA-Z0-9]).{1,}$/g;
		let pwdCheckReg3 = /(?![~`!@#$%\^&*()-+=a-zA-Z0-9]).{1,}$/g;
	  
		if(oldPwd.trim() == "" || newPwd.trim() == "" || newPwd.trim() == ""){
			$("#pwdChangeInfo").html("모든 칸에 입력을 완료해주세요!<br/>&nbsp;");
			return;
		}
		if(newPwd != newPwd2){
			$("#pwdChangeInfo").html("재입력한 비밀번호가 불일치합니다<br/>&nbsp;");
			return;
		}
		
		if(newPwd.match(pwdCheckReg) == null) {
			$("#pwdChangeInfo").html("특수문자가 포함되어야합니다.<br/>&nbsp;");
			return false;
		}
		else if(newPwd.match(pwdCheckReg2) == null) {
			$("#pwdChangeInfo").html("영문 혹은 숫자를 포함시켜주세요.<br/>&nbsp;");
			return false;
		}
		else if(newPwd.match(pwdCheckReg3) != null) {
			$("#pwdChangeInfo").html("허용되지 않는 문자가 있습니다!<br/>&nbsp;");
			return false;
		}
		
		
		let res_sw = '0';
		$.ajax({
			type: "post",
			url : "${ctp}/member/oldPwdCheck",
			data: {pwd:oldPwd},
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
			url : "${ctp}/member/pwdUpdate",
			data: {pwd:newPwd},
			async: false,
			success: function(res) {
				if(res == '1') {
					alert("비밀번호가 변경되었습니다.");
					document.location.reload(true);
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
		
		let rememId = document.getElementById("rememId");
		
		if(mid.trim() == "" || pwd.trim() == ""){
			$("#loginInfo").html("아이디와 비밀번호를 입력후 로그인해주세요.<br/>&nbsp;");
			return;
		}
		
		let query;
		if(rememId.checked) query = {mid:mid,pwd:pwd,rememId:rememId.value};
		else query = {mid:mid,pwd:pwd};
		
		$.ajax({
			type: "post",
			url : "${ctp}/member/login",
			data: query,
			success: function(res){
				let res1 = res.substring(0, 1);
				let res2 = res.substring(1);
				if (res1 == '1') location.href = res2;
				else if(res1 == '2') $("#loginInfo").html("존재하지 않는 계정입니다.<br/>&nbsp;");
				else if(res1 == '3') $("#loginInfo").html("인증이 되지 않은 계정입니다.<br/> 인증 후 다시 로그인해주세요.");
				else if(res1 == '4') $("#loginInfo").html(res2);
				else $("#loginInfo").html("비밀번호가 불일치합니다.<br/>&nbsp;");
			},
			error: function(){
				alert("전송 오류");
			}
		});
	}
	
	function createCP() {
		let mid = '${sMid}';
		
		if(mid == '') {
			infoModalOn('로그인 후 이용가능합니다.');
			return false;
		}
		
		$.ajax({
			type: "post",
			url : "${ctp}/create/cpCreate",
			data: {mid:mid},
			success: function(res){
				if(res == '1') infoModalOn('현재 업체 승인 심사중입니다.');
				else if(res == '2') infoModalOn('이미 업체 회원입니다.');
				else location.href = '${ctp}/create/cpCreate';
			},
			error: function(){
				alert("전송 오류");
			}
		});
	}
	
	function logout() {
		$.ajax({
			type: "post",
			url : "${ctp}/member/logout",
			success: function(){
				location.href = '${ctp}/';
			}
		});
	}
	
	
	// 검색
	function searchingAnything(idx) {
		let search = $("#search"+idx).val();
		if(search.trim() == "") return;
		location.href = "${ctp}/member/companyList?searching="+search+"&searchItem=all&orderBy=createDayCP&order=desc&pag=1&pageSize=9&categori=all&detail=";
	}
	
</script>
