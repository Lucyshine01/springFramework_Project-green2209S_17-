<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:if test="${empty sMid}">
<a href="${ctp}/create/createUser">
  <div id="headerTop">
    <div class="width d-flex">
      <div id="hTL" class="d-flex fCol_center text-dark">
        <span>인테리어가 필요할땐, 인테모아</span>
      </div>
      <div id="hTR" class="d-flex fCol_center text-dark ml-auto">
        <span>신규가입하고 <b>1만원 가량의 포인트</b>를 받으세요! &nbsp;></span>
      </div>
    </div>
  </div>
</a>
</c:if>