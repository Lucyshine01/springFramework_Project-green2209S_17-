<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<div id="layoutSidenav_nav">
  <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
      <div class="sb-sidenav-menu">
        <div class="nav">
          <div class="sb-sidenav-menu-heading">관리자 메뉴</div>
          <a class="nav-link" href="${ctp}/admin/main">
            <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
            통계
          </a>
          <div class="sb-sidenav-menu-heading">상세 메뉴</div>
          <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
            <div class="sb-nav-link-icon"><i class="fa-solid fa-user-pen"></i></div>
            회원 관리
            <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
          </a>
          <div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
            <nav class="sb-sidenav-menu-nested nav">
              <a class="nav-link" href="${ctp}/admin/userManage">
              	<div class="iconBlock"><i class="fa-solid fa-retweet"></i></div>회원 수정
              </a>
              <a class="nav-link" href="${ctp}/admin/companyManage">
              	<div class="iconBlock"><i class="fa-regular fa-building"></i></div>업체 관리
              </a>
              <a class="nav-link" href="${ctp}/admin/replyManage">
              	<div class="iconBlock"><i class="fa-solid fa-list"></i></div>후기 관리
              </a>
            </nav>
          </div>
          <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts2" aria-expanded="false" aria-controls="collapseLayouts">
            <div class="sb-nav-link-icon"><i class="fa-solid fa-globe"></i></div>
            서비스 관리
            <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
          </a>
          <div class="collapse" id="collapseLayouts2" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
            <nav class="sb-sidenav-menu-nested nav">
              <a class="nav-link" href="${ctp}/admin/helpManage"><div class="iconBlock"><i class="fa-regular fa-circle-question"></i></div>문의 관리</a>
              <a class="nav-link" href="${ctp}/admin/reportManage"><div class="iconBlock"><i class="fa-regular fa-flag"></i></div>신고 관리</a>
            </nav>
          </div>
          <div class="sb-sidenav-menu-heading">상세 내역</div>
          <a class="nav-link" href="${ctp}/admin/chatHistory">
            <div class="sb-nav-link-icon"><i class="fa-solid fa-comment-dots"></i></div>
            채팅 내역
          </a>
          <a class="nav-link" href="${ctp}/admin/creditHistroy">
            <div class="sb-nav-link-icon"><i class="fa-solid fa-server"></i></div>
            결제 내역
          </a>
        </div>
      </div>
    <div class="sb-sidenav-footer">
      <div class="small">Templete 출처 :</div>
      Start Bootstrap
    </div>
  </nav>
</div>