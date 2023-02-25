<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<hr/>
<div style="background-color: #f0f0f0;">
  <div id="helpCenter" class="width d-flex justify-content-between">
    <div class="d-flex fCol_center">
      <div style="font-size: 1.2em; font-weight: 600;">고객센터</div>
      <div class="mt-4" style="font-family: 'Spoqa Han Sans Neo';">10:30~18:00 (점심시간 13:00~14:00)</div>
      <div class="mt-2" style="font-family: 'Spoqa Han Sans Neo';">주말,공휴일 휴무</div>
      <div class="mt-4">
        <input type="button" onclick="location.href='${ctp}/member/helpCenter'" value="1:1문의" class="btn btn-outline-secondary w3-hover-grey">
      </div>
    </div>
    <div class="d-flex fCol_center botMenu">
      <div style="font-size: 1.2em; font-weight: 600;">인테모아</div>
      <div class="mt-4"><a href="${ctp}/">메인 홈</a></div>
      <!-- <div class="mt-2"><a href="#">의뢰 목록</a></div> -->
      <div class="mt-2"><a href="${ctp}/member/companyList">업체 목록</a></div>
      <div class="mt-2"><a href="${ctp}/member/helpCenter">고객센터</a></div>
      <!-- <div class="mt-2"><a href="#">게시판</a></div> -->
    </div>
  </div>
</div>
<hr/>
<div style="background-color: #f0f0f0;">
  <div class="width text-center pt-4 pb-4">
    <span style="font-size: 0.9em; color: #333;">
      인테모아 &#124; 충청북도 청주시 서원구 사창동 148-7 4,5층 &#124; 제작자 : 장지호<br/>
      고객센터 : 1234-1234 &#124; help@intemoa.com<br/><br/>
    </span>
    <span style="font-size: 0.9em; color: #aaa;">
      Copyright&copy;2022 InTeMoa. All rights reserved.
    </span>
  </div>
</div>

