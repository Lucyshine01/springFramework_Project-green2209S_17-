<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>chatRoom.jsp</title>
	<jsp:include page="/WEB-INF/views/include/bs4.jsp"></jsp:include>
  <link href="${ctp}/viewPage/viewPage.css" rel="stylesheet" type="text/css">
  <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
  <script>
  	'use strict';
  	if('${sMid}' == '') window.close();
  	let nowSt = '${sMid == vos[0].sendId ? "right" : "left"}';
  	let oldTime = '<fmt:formatDate value="${vos[0].sendDay}" pattern="HH.mm"/>'
  	let oldDate = '';
  	if(${fn:length(vos)} != 0) oldDate = '<fmt:formatDate value="${vos[0].sendDay}" pattern="yyyy년 MM월 dd일"/>'
  	let block = '';
  	let topic = '/topic/'+'${roomId}'
  	let chatList = 0;
  	
  	var sock = new SockJS('http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/chattingRoom');
  	let stompClient = Stomp.over(sock);
  	stompClient.connect({}, function(frame) {
			console.log('Conneted : ' + frame);
			stompClient.subscribe(topic, function(res) {
				let msg = JSON.parse(res.body);
				
				let mid = msg.mid;
				let time = msg.time;
				let newDate = msg.newDate;
				let content = msg.content;
				let chatClass = '';
				
				block	+= '<div class="d-flex fCol_center">';
				
				if(newDate != oldDate) {
					block	+= '<div class="dateBox ml-auto mr-auto text-center">';
					block	+= newDate+'</div>';
				}
				
				if(mid != '${sMid}') {
					chatClass = 'left mr-auto';
					arriveSend();
					if(nowSt == 'right') {
						block += '<div class="profileBox">';
						block += '<div class="ml-2 mr-2" style="position: absolute;">';
						block += '<img class="profile" src="${ctp}/images/${oppProfile}"></div>';
						block += '<span class="d-flex fCol_center oppNameBox">${oppName}</span></div>';
						nowSt = 'left';
					}
				}
				else {
					chatClass = 'right ml-auto mr-3';
					nowSt = 'right';
				}
				
				let timeblock = '<span class="timeBlock">' + time + '</span>';
				
				block += '<div class="textBox '+chatClass+'">';
				block += content;
				if(oldTime != time) {
					block += timeblock;
					oldTime = time;
				}
				block += '</div>'
					
				$("#chatBackground").append(block);
				oldDate = newDate;
				block = '';
				scrollDown();
			});
		});
  	
  	var arriveSock = new SockJS('http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/arrive');
  	let stompClient2 = Stomp.over(arriveSock);
  	stompClient2.connect({}, function(frame) {
  		stompClient2.subscribe(topic, function(res) {
  			console.log(res.body);
  		});
  	});
  	
  	function send() {
			let content = $("#content").val();
			if(content == '') return;
			let query = {
				mid : '${sMid}',
				oppMid : '${oppMid}',
				roomId : '${roomId}',
				content: content
			}
			let jsonMsg = JSON.stringify(query);
  		stompClient.send("/app/chattingRoom", {}, jsonMsg);
  		$("#content").val('');
		}
  	
  	
  	function arriveSend() {
			stompClient2.send("/app/arrive", {}, "${roomId}/arriveOk");
		}
  	
		function scrollDown() {
			$('#chatBackground').scrollTop($('#chatBackground')[0].scrollHeight);
		} 
  	
		function loadChat(e) {
			let scrollH = document.getElementById("chatBackground").scrollHeight;
			chatList = chatList + 20;
			$.ajax({
				type : "post",
				url : "${ctp}/loadingChatList",
				data: {num:chatList,mid:'${sMid}',oppMid:'${oppMid}'},
				success: function(vos) {
					$(e).remove();
					let oldTime2 = '';
					let oldDate2 = '';
					let nowSt2 = '';
					if(vos[vos.length-1].sendId == '${sMid}') nowSt2 = 'right';
					else nowSt2 = 'left';
					if(vos[vos.length-1].idx != ${lastIdx}) block += '<div id="beforeChatBtn" class="d-flex fCol_center text-center mb-2" onclick="loadChat(this);">이전 채팅 불러오기</div>'
					for(let i=vos.length-1; i>=0; i--) {
						let vo = vos[i];
						
						let mid = vo.sendId;
						let content = vo.content;
						
						let date = new Date(vo.sendDay);
						let HH = date.getHours();
						let mm = date.getMinutes();
						let month = date.getMonth() + 1;
						let day = date.getDate();
						if(HH.length == 1) HH = "0" + HH;
						if(mm.length == 1) mm = "0" + mm;
						if(month.length == 1) month = "0" + month;
						if(day.length == 1) day = "0" + day;
						
						let time = HH + ":" + mm;
						let newDate = date.getFullYear() + "년 " + month + "월 " + day + "일"
						if(i==vos.length-1) oldDate2 = newDate;
						
						let chatClass = '';
						block	+= '<div class="d-flex fCol_center">';
						
						if(newDate != oldDate2 || vo.idx == ${lastIdx}) {
							block	+= '<div class="dateBox ml-auto mr-auto text-center">';
							block	+= newDate+'</div>';
						}
						
						if(mid != '${sMid}') {
							chatClass = 'left mr-auto';
							if(nowSt2 == 'right' || i==vos.length-1) {
								block += '<div class="profileBox">';
								block += '<div class="ml-2 mr-2" style="position: absolute;">';
								block += '<img class="profile" src="${ctp}/images/${oppProfile}"></div>';
								block += '<span class="d-flex fCol_center oppNameBox">${oppName}</span></div>';
								nowSt2 = 'left';
							}
						}
						else {
							chatClass = 'right ml-auto mr-3';
							nowSt2 = 'right';
						}
						
						let timeblock = '<span class="timeBlock">' + time + '</span>';
						
						block += '<div class="textBox '+chatClass+'">';
						block += content;
						if(oldTime != time) {
							block += timeblock;
							oldTime = time;
						}
						block += '</div>'
						
						oldDate2 = newDate;
					}
					$("#chatBackground").prepend(block);
					block = '';
					$("#chatBackground").scrollTop(document.getElementById("chatBackground").scrollHeight - scrollH);
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
		
  </script>
  <style>
  	body {overflow-y: hidden;}
  	#main {
  		padding: 0;
  		margin: 0;
  		background-color: #b2c7da;
  	}
  	
  	#chatBackground {
  		overflow-y: auto;
  		overflow: overlay;
  	}
  	#chatBackground::-webkit-scrollbar {
  		width: 11px;
	    height: 20%;
		}
		#chatBackground::-webkit-scrollbar-track {
	    background: rgba(0,0,0,0);  /*스크롤바 뒷 배경 색상*/
		}
  	#chatBackground::-webkit-scrollbar-thumb {
	    background: rgba(40,40,40,0.5); /* 스크롤바의 색상 */
	    background-clip: padding-box;
	    border: 2px solid transparent;
	    border-radius: 10px;
	    /* border-radius: 10px; */
		}
  	.dateBox {
  		background-color: rgba(0,0,0,0.25);
  		padding: 2px 30px;
  		color: #fff;
  		font-size: 1.05em;
  		font-weight: 400;
  		border-radius: 3px;
  		margin: 3px 0;
  	}
  	.textBox {
  		padding: 10px;
  		margin-top: 3px;
  		margin-bottom: 3px;
  		max-width: 250px;
  		min-width: 60px;
  		text-align: center;
  		word-wrap: break-word;
  	}
  	.left {
  		position: relative;
  		background-color: #fff;
  		margin-left: 65px;
  		border-top-right-radius: 3px;
  		border-bottom-right-radius: 3px;
  		border-top-left-radius: 3px;
  		border-bottom-left-radius: 3px;
  		/* float: left; */
  	}
  	.right {
  		position: relative;
  		background-color: #fee500;
  		border-top-right-radius: 3px;
  		border-bottom-right-radius: 3px;
  		border-top-left-radius: 3px;
  		border-bottom-left-radius: 3px;
  		/* float: right; */
  	}
  	.timeBlock {
  		display: inline-block;
  		position: absolute;
  		color: #fff;
  		font-size: 0.85em;
  		font-weight: 300;
  		bottom: 2px;
  		background-color: rgba(0,0,0,0.1);
  		padding-left: 5px;
  		padding-right: 5px;
  	}
  	.left .timeBlock {
  		left: 100%;
  		border-top-right-radius: 5px;
  		border-bottom-right-radius: 5px;
  	}
  	.right .timeBlock {
  		right: 100%;
  		border-top-left-radius: 5px;
  		border-bottom-left-radius: 5px;
  	}
  	#textForm {
  		/* background: #cccccc; */
  		position: fixed;
  		bottom: 0;
  		width: 100%;
  		box-shadow: 0 1px 2px 2px rgba(50,50,50,0.2);
  	}
  	#headBackground {
  		position: fixed;
  		top: 0;
  		width: 100%;
  		background-color: #a1b6c9;
  		height: 50px;
  		box-shadow: 0 1px 3px 3px rgba(50,50,50,0.2);
  	}
  	#headName {
  		font-size: 1.3em;
  		font-weight: 700;
  	}
  	#beforeChatBtn {
			-webkit-user-select: none;
			-moz-user-select: none;
			-ms-use-select: none;
			user-select: none;
			height: 50px;
			cursor: pointer;
			transition: 0.1s;
			font-size: 1.1em;
			font-weight: 400;
			background-color: rgba(100,100,100,0.1);
  	}
  	#beforeChatBtn:hover{background-color: rgba(50,50,50,0.2);}
  	#beforeChatBtn:active{background-color: rgba(50,50,50,0.4);}
  	.profileBox {
  		position: relative;
  		height: 30px;
  	}
  	.profile {
  		width: 50px;
  		height: 50px;
  		object-fit: cover;
  		border-radius: 22px;
  	}
  	.oppNameBox {margin-left: 65px;}
  </style>
</head>
<body>
	<div id="main">
		<div id="headSpace"></div>
		<div id="chatBackground" class="pb-2 pt-2">
			<c:set var="vosLeng" value="${fn:length(vos)-1}" />
			<c:set var="nowSt" value="right"/>
			<c:if test="${lastIdx != vos[vosLeng].idx && fn:length(vos) != 0}">
				<div id="beforeChatBtn" class="d-flex fCol_center text-center mb-2" onclick="loadChat(this);">이전 채팅 불러오기</div>
			</c:if>
			<c:if test="${fn:length(vos) != 0}">
				<c:forEach begin="0" end="${fn:length(vos)-1}" varStatus="st">
					<div class="d-flex fCol_center">
						<c:if test="${lastIdx == vos[vosLeng-st.index].idx}">
							<div class="dateBox ml-auto mr-auto text-center">
								<fmt:formatDate value="${vos[vosLeng-st.index].sendDay}" pattern="yyyy년 MM월 dd일"/>
							</div>
						</c:if>
						<c:if test="${(fn:substring(date,0,11)) != (fn:substring(vos[vosLeng-st.index].sendDay,0,11)) && st.index != 0}">
							<div class="dateBox ml-auto mr-auto text-center">
								<fmt:formatDate value="${vos[vosLeng-st.index].sendDay}" pattern="yyyy년 MM월 dd일"/>
							</div>
						</c:if>
						<!-- profile -->
						<c:if test="${sMid != vos[vosLeng-st.index].sendId && nowSt == 'right'}">
							<div class="profileBox">
								<div class="ml-2 mr-2" style="position: absolute;">
									<img class="profile" src="${ctp}/images/${oppProfile}" >
								</div>
								<span class="d-flex fCol_center oppNameBox">${oppName}</span>
							</div>
							<c:set var="nowSt" value="left"/>
						</c:if>
						<!-- textBox -->
						<c:if test="${sMid == vos[vosLeng-st.index].sendId}"><c:set var="nowSt" value="right"/></c:if>
						<div class="textBox ${sMid == vos[vosLeng-st.index].sendId ? 'right ml-auto mr-3' : 'left mr-auto'}">
							${vos[vosLeng-st.index].content}
							<c:if test="${time != fn:substring(vos[vosLeng-st.index].sendDay,0,16)}"> 
								<span class="timeBlock"><fmt:formatDate value="${vos[vosLeng-st.index].sendDay}" pattern="HH:mm"/></span>
							</c:if>
						</div>
					</div>
					<c:set var="time" value="${fn:substring(vos[vosLeng-st.index].sendDay,0,16)}"/>
					<c:set var="date" value="${vos[vosLeng-st.index].sendDay}"/>
				</c:forEach>
			</c:if>
		</div>
		<div id="headBackground" class="d-flex p-2 pl-3">
			<div id="headName" class="d-flex fCol_center">${oppName}</div>
		</div>
		<div id="textForm" class="d-flex pt-4 pb-4 pl-3 pr-3">
			<input type="text" name="content" id="content" class="form-control ml-auto mr-3" autocomplete='off'/>
			<input type="button" value="&nbsp;&nbsp;&nbsp;전 송&nbsp;&nbsp;&nbsp;" id="sendBtn" class="btn btn-success" onclick="send();"/>
		</div>
	</div>
<script>
	let screenWidth = window.innerHeight;
	let textFormWidth = document.getElementById('textForm').offsetHeight;
	let headFormWidth = document.getElementById('headBackground').offsetHeight;
	$(function() {
		$("#main").css("height",screenWidth+"px");
		$("#chatBackground").css("height",(screenWidth-textFormWidth-headFormWidth)+"px");
		$("#headSpace").css("height",headFormWidth+"px");
		$('#chatBackground').scrollTop($('#chatBackground')[0].scrollHeight);
		$("#content").on('keydown', function(e){
			if(e.keyCode == 13) $("#sendBtn").click();
		});
	});
	
	window.addEventListener(`resize`, function() {
		screenWidth = window.innerHeight;
		$("#main").css("height",screenWidth+"px");
		$("#chatBackground").css("height",(screenWidth-textFormWidth-headFormWidth)+"px");
	});
</script>
<script src="${ctp}/viewPage/viewPage.js"></script>
</body>
</html>