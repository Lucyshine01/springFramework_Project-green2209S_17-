<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<div id="mainView">
    <div class="width d-flex">
      <div id="mainView_1">
        <div id="mainViewTitle" style="pointer-events: none;">
          인테리어 전문 인테모아에서<br/>
          원하는 업체를 찾아보세요!
        </div>
        <div id="mainView_searchBox">
          <input type="text" id="search2" name="search2" class="searchAnythingBox" placeholder="인테리어 업체 찾기" autocomplete='off' spellcheck="false">
          <i onclick="searchingAnything(2);" class="fa-solid fa-magnifying-glass"></i>
        </div>
        <div class="d-flex">
          <span onclick="location.href='${ctp}/member/companyList?searching=인테리어&searchItem=all&orderBy=createDayCP&order=desc&pag=1&pageSize=9&categori=all&detail='" class="hasTag">#인테리어</span>
          <span onclick="location.href='${ctp}/member/companyList?searching=디자인&searchItem=all&orderBy=createDayCP&order=desc&pag=1&pageSize=9&categori=all&detail='" class="hasTag">#디자인</span>
          <span onclick="location.href='${ctp}/member/companyList?searching=생활&searchItem=all&orderBy=createDayCP&order=desc&pag=1&pageSize=9&categori=all&detail='" class="hasTag">#생활</span>
          <span onclick="location.href='${ctp}/member/companyList?searching=건축&searchItem=all&orderBy=createDayCP&order=desc&pag=1&pageSize=9&categori=all&detail='" class="hasTag">#건축</span>
        </div>
      </div>
      <div id="slideImg" class="carousel slide ml-auto" data-ride="carousel">
        <!-- (하단 바 스타일) -->
        <div id="slideNumbar" style="z-index: 1;"><span id="numIns"></span><span id="numTot"></span></div>
        <!-- The slideshow -->
        <div class="carousel-inner">
          <div class="carousel-item active">
            <img src="${ctp}/viewPage/test1.png"/>
          </div>
          <div class="carousel-item">
            <img src="${ctp}/viewPage/test2.png"/>
          </div>
          <div class="carousel-item">
            <img src="${ctp}/viewPage/test3.png"/>
          </div>
          <div class="carousel-item">
            <img src="${ctp}/viewPage/test4.png"/>
          </div>
          <div class="carousel-item">
            <img src="${ctp}/viewPage/test5.png"/>
          </div>
          <div class="carousel-item">
            <img src="${ctp}/viewPage/test6.png"/>
          </div>
          <div class="carousel-item">
            <img src="${ctp}/viewPage/test7.png"/>
          </div>
        </div>
        <!-- Left and right controls -->
        <a class="carousel-control-prev carousel-btn" href="#slideImg" data-slide="prev" style="left: -18px;" >
          <i style="color: #000;" class="fa-solid fa-chevron-left"></i>
        </a>
        <a class="carousel-control-next carousel-btn" href="#slideImg" data-slide="next" style="right: -18px;" >
          <i style="color: #000;" class="fa-solid fa-chevron-right"></i>
        </a>
      </div>
    </div>
  </div>
  <div class="width" style="margin-top: 70px;">
    <div class="mb-5" style="font-size: 1.9em; margin-left: 80px; pointer-events: none;">
      카테고리에서 필요한 업체를 찾아보세요!
    </div>
    <div id="category" class="d-flex justify-content-around">
      <div class="d-flex fCol_center text-center category_Icon" onclick="location.href='${ctp}/member/companyList?categori=1'">
        <img src="${ctp}/viewPage/인테리어Icon.png" width="200px">
        <span>인테리어</span>
      </div>
      <div class="d-flex fCol_center text-center category_Icon" onclick="location.href='${ctp}/member/companyList?categori=2'">
        <img src="${ctp}/viewPage/시공Icon.png" width="200px">
        <span>시공</span>
      </div>
      <div class="d-flex fCol_center text-center category_Icon" onclick="location.href='${ctp}/member/companyList?categori=3'">
        <img src="${ctp}/viewPage/디자인Icon.png" width="200px">
        <span>디자인</span>
      </div>
    </div>
  </div>
  <div id="advBox">
    <div class="width text-center" style="padding-top: 80px;">
      <div style="font-size: 2em;font-weight: 700;">내게 필요한 시공업체를 만날수 있는 인테모아의 장점!</div>
    </div>
    <div class="width d-flex justify-content-around" style="margin-top: 60px;">
      <div class="d-flex fCol_center adv">
        <div class="advTitle">빠른 커뮤니케이션</div>
        <div class="advSub">
          실시간 채팅으로<br/>
          빠르게 문의하고 거래해보세요!
        </div>
      </div>
      <div class="d-flex fCol_center adv">
        <div class="advTitle">신속한 의견반영</div>
        <div class="advSub">
          서비스에 불편한 점이 있으신가요?<br/>
          고객센터에 문의하시고 빠른 답변을 받아보세요!
        </div>
      </div>
      <div class="d-flex fCol_center adv">
        <div class="advTitle">만족스러운 결과물</div>
        <div class="advSub">
          분야별 전문가가<br/>
          만족스러운 결과물을 제공합니다.
        </div>
      </div>
    </div>
  </div>
  <c:if test="${empty sMid}">
	  <a href="${ctp}/create/createUser" style="background-color: #202224; display: block;">
	    <div class="width"><img src="${ctp}/viewPage/signup_banner.png" width="1200px"></div>
	  </a>
  </c:if>