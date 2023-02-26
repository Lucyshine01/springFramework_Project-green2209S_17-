<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<c:if test="${!empty sMid}">
	<div class="fixed-back">
		<div class="d-flex fCol_center" style="position: absolute;">
			<div class="fixed-Icon d-flex fCol_center"  style="bottom: 12%">
				<i id="noticeBtn" class="fa-regular fa-bell d-flex fCol_center" onclick="noticeModalOn();" style="height: 100%"></i>
				<div class="noticeTot text-center d-flex fCol_center"></div>
				<div id="noticeBar" class="modalRel">
					<div class="noticeModal d-flex">
						<div class="p-2 pl-3 text-left" style="border-bottom: 1px solid rgba(50,50,50,0.2)">알림</div>
						<div id="noticeContent" class="d-flex noticeModal_objBoard"><div class="mt-5">알림 내용이 없습니다.</div></div>
					</div>
				</div>
			</div>
			<div class="fixed-Icon d-flex fCol_center" style="bottom: 4%">
				<i id="chatBtn" class="fa-regular fa-comment-dots d-flex fCol_center" onclick="chatModalOn();" style="height: 100%"></i>
				<div id="chatBar" class="modalRel">
					<div class="noticeModal d-flex">
						<div class="p-2 pl-3 text-left" style="border-bottom: 1px solid rgba(50,50,50,0.2)">채팅</div>
						<div id="chatContent" class="d-flex noticeModal_objBoard"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</c:if>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
	<script>
		'use strict';
		let nVOS = null;
		let lastTime = '2000-01-01 00:00:00.0'
		let noticeTot = 0;
		let idxList = '';
		
		let noticeModalSw = 0;
		let chatModalSw = 0;
		
	<c:if test="${!empty sMid}">
		const sock = new SockJS('http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/realNotice');
		sock.onopen = function() {
			console.log("Connecting...");
			sock.send("${sMid}");
		}
		sock.onmessage = function(msg) {
			let res = JSON.parse(msg.data);
			if(res.vos[res.vos.length-1].noticeDay != lastTime) {
				nVOS = res.vos;
				for(let i=0; i<nVOS.length; i++){
					if(nVOS[i].status == 'n') noticeTot++;
				}
				if(noticeTot != 0) {
					if(noticeTot > 99) noticeTot = 99;
					$(".noticeTot").html(noticeTot + "");
					$(".noticeTot").css("visibility","visible");
				}
				noticeTot = 0;
				noticeDataWrite();
			}
			
		}
		sock.onclose = function() {
			console.log("Disconnect...");
		}
		
		function noticeDataWrite() {
			let block = '';
			if(nVOS == null) $("#noticeContent").html('<div class="mt-5">알림 내용이 없습니다.</div>');
			for(let i=0; i<nVOS.length; i++) {
				if(nVOS[i].status == 'n') {
					idxList += nVOS[i].idx + "/";
					block += '<div class="content_block"><span';
				}
				else block += '<div class="content_block_read"><span';
				if(nVOS[i].url != '') block += ' onclick="window.open(\''+nVOS[i].url+'\')" style="cursor: pointer;" ';
				block+= '>'+nVOS[i].noticeContent+'</span>';
				block+= '<br/><div>';
				block+= '<span class="notice_subBtn" onclick="noticeDelete('+nVOS[i].idx+',this)">삭제</span></div>';
				block+= '</div>';
			}
			$("#noticeContent").html(block);
			if(idxList.length > 1) idxList = idxList.substring(0,idxList.length-1);
		}
		
		function noticeCheck(idx,me) {
			$.ajax({
				type: "post",
				url: "${ctp}/chat/noticeCheck",
				data:{idx:idx},
				success: function() {
					$(me).parent().parent().addClass("content_block_read");
					$(me).parent().parent().removeClass("content_block");
					$(me).remove();
				},
				error: function() {alert("연결 오류");}
			});
		};
		
		function noticeDelete(idx,me) {
			$.ajax({
				type: "post",
				url: "${ctp}/chat/noticeDelete",
				data:{idx:idx},
				async: false,
				success: function() {
					$(me).parent().parent().remove();
				},
				error: function() {alert("연결 오류");}
			});
			let text = document.getElementById("noticeContent").innerText;
			if(text == '') $("#noticeContent").html('<div class="mt-5">알림 내용이 없습니다.</div>');
		};
		
		$.ajax({
			type: "post",
			url: "${ctp}/chat/loadRoomData",
			async: false,
			success: function(cVOS) {
				let block = '';
				for(let i=0; i<cVOS.length; i++) {
					block += '<div id="'+cVOS[i].roomId+'" class="chat_block"><div class="profileBlock">';
					block += '<div class="ml-1" style="position: absolute;">';
					block += '<img class="profileImg" src="${ctp}/images/';
					if(cVOS[i].oppCpName != '') block += 'cpProfile/'+cVOS[i].oppImg+'"></div>';
					else block += 'profile/'+cVOS[i].oppImg+'"></div>';
					block += '<div class="d-flex fCol_center oppName">'+cVOS[i].oppName;
					block += '<div class="chatContent">';
					if(cVOS[i].content.length > 20) block += cVOS[i].content.substring(0,18) + "...</div></div>";
					else block += cVOS[i].content + "</div></div>";
					let hh = cVOS[i].sendDay.substring(11,13);
					let mm = cVOS[i].sendDay.substring(14,16);
					if(hh >= 13) hh = "오후 " + (hh - 12);
					else if(hh == 12) aMpM = "오후 " + hh;
					else hh = "오전 " + hh;
					block += '<div class="timeBlock">'+ cVOS[i].sendDay.substring(5,7) + "." + cVOS[i].sendDay.substring(8,10) + "<br/>" + hh + ":" + mm +'</div>';
					block += '</div></div>';
				}
				if(cVOS.length <= 0) block = '<div class="mt-5">대화방이 없습니다.</div>';
				$("#chatContent").html(block);
			},
			error: function() {alert("연결 오류");}
		});
		
	</c:if>
		
		function noticeModalOn() {
			$("#noticeBar").show();
			$("#noticeBtn").attr("onclick","noticeModalOff()");
			noticeModalSw = 1;
			chatModalOff();
			if(idxList.length > 0) {
				$.ajax({
					type: "post",
					url: "${ctp}/chat/noticeCheck",
					data:{idxList:idxList},
					success: function() {$(".noticeTot").css("visibility","hidden");},
					error: function() {alert("연결 오류");}
				});
			}
		}
		function noticeModalOff() {
			$("#noticeBar").hide();
			$("#noticeBtn").attr("onclick","noticeModalOn()");
			noticeModalSw = 0;
		}
		function chatModalOn() {
			$("#chatBar").show();
			$("#chatBtn").attr("onclick","chatModalOff()");
			chatModalSw = 1;
			noticeModalOff();
		}
		function chatModalOff() {
			$("#chatBar").hide();
			$("#chatBtn").attr("onclick","chatModalOn()");
			chatModalSw = 0;
		}
		
		$(function() {
			$(".fixed-Icon i").on("mouseover", function(){
				$(this).parent(".fixed-Icon").css("background-color","#efefef");
			});
			$(".fixed-Icon i").on("mouseout", function(){
				$(this).parent(".fixed-Icon").css("background-color","#fff");
			});
			
			$(".chat_block").dblclick(function() {
				let roomId = $(this).prop("id");
        window.name = "parentForm";
        let xx = (window.screen.width/2) - (510/2); 
        let yy = (window.screen.height/2) - (650/2); 
		  	let openWin = window.open("${ctp}/chatRoom?roomId="+roomId, "chatRoom", "left="+xx+" ,top="+yy+" width=510, height=650, resizable = no, scrollbars = no");
      });
			
		});
	</script>