'use strict';
let fixSW = 0;
let randomSearch = Math.floor((Math.random() * 12) +1)
if(randomSearch == 1) $("#search2").val("홈 인테리어");
else if(randomSearch == 2) $("#search2").val("상업 인테리어");
else if(randomSearch == 3) $("#search2").val("조명 인테리어");
else if(randomSearch == 4) $("#search2").val("욕실,화장실");
else if(randomSearch == 5) $("#search2").val("타일시공");
else if(randomSearch == 6) $("#search2").val("페인트시공");
else if(randomSearch == 7) $("#search2").val("싱크대 교체");
else if(randomSearch == 8) $("#search2").val("도배장판");
else if(randomSearch == 9) $("#search2").val("필름");
else if(randomSearch == 10) $("#search2").val("도면 제작");
else if(randomSearch == 11) $("#search2").val("3D 모델링");
else if(randomSearch == 12) $("#search2").val("인테리어 컨설팅");

function removeSearch() {
  $("#search1").val("");
  $("#searchBox .fa-circle-xmark").addClass("iconHidden");
  $("#searchBox .fa-magnifying-glass").removeClass("iconHidden");
}
function loginModalOn() {
	$("#loginModal").show();
	$("#loginModal").animate({opacity:"1"},200);
}
function pwdChangeModalOn() {
	$("#pwdChangeModal").show();
	$("#pwdChangeModal").animate({opacity:"1"},200);
}
function modalClose() {
	$("#loginModal").hide();
	$("#loginModal").css("opacity","0");
	$("#pwdChangeModal").hide();
	$("#pwdChangeModal").css("opacity","0");
	$("#helpInputModal").hide();
	$("#helpInputModal").css("opacity","0");
}


// 요소나온후 미리 읽어와야함
window.onload = function() {
  let headerTop = document.getElementById("headerTop");
  if(isNaN(headerTop))fixSW = 1;
  else fixSW = 0;
  
  $(window).scroll(function(){
    let space = document.getElementById("headMain").clientHeight + "px";
    if(fixSW == 1){
      if($(this).scrollTop() > 60) {
        $("#headMain").addClass("fixTop");
        $("#headMainSpace").css("height",space);
      }
      else {
        $("#headMain").removeClass("fixTop");
        $("#headMainSpace").css("height","0px");
      }
    }
    else if(fixSW == 0){
      $("#headMain").addClass("fixTop");
      $("#headMainSpace").css("height",space);
    }
  });
};

$(document).ready(function(){
  $("#headerTop").hide();
  $("#loading_Bar").css("width","0px");
  $("#loading_Bar").animate({width:"4000px"},500);
  // $("#loading_Bar").slideUp();
  $("#loading_Bar").fadeOut("slow");
  $("#headerTop").delay(400);
  $("#headerTop").slideDown(450);
  $("#mainView").css("background-color","#000225");
  $("html, body").animate({ scrollTop: 0 }, 5); 
  
  $(".searchAnythingBox").on('keydown', function(e){
		if(e.keyCode == 13) {
			let idx = $(this).attr("id").replace("search","");
			searchingAnything(idx);
		}
	});
  
  $("#search1").on('focusin',function(e){
    $(this).animate({width:"350px"},10);
  });
  $("#search1").on('focusout',function(e){
    $(this).animate({width:"250px"},10);
  });
  $("#search1").keyup(function(){
    if($(this).val().length >= 1){
      $("#searchBox .fa-circle-xmark").removeClass("iconHidden");
      $("#searchBox .fa-magnifying-glass").addClass("iconHidden");
    }
    else {
      $("#searchBox .fa-circle-xmark").addClass("iconHidden");
      $("#searchBox .fa-magnifying-glass").removeClass("iconHidden");
    }
  });
  
  let search2SW = 0;
  $("#search2").on('focusin',function(e){
		if(search2SW == 0){
    	$(this).val("");
    	search2SW = 1;
		}
  });
  
  
  $(".modalBack").click(function(){modalClose();});
	
	$("#loginMid").on('keydown',function(e){if(e.keyCode == 13)loginCheck();});
	$("#loginPwd").on('keydown',function(e){if(e.keyCode == 13)loginCheck();});
	
  // carousel
  let tempTot = $(".carousel-item img").length + ""; // 요소(ELEMENT) 안의 해당객체 갯수 구하기
  if(tempTot.length == 1) tempTot = "0" + tempTot;
  $("#numTot").html(" / "+tempTot);
  $("#numIns").html("01");
  $("#slideImg").on('slide.bs.carousel', function(e){
    let val = e.to;
    $("#numIns").html("0"+(val+1));
    if(val == 0) {
      $("#mainView").css("background-color","#000225");
    }
    else if(val == 1) {
      $("#mainView").css("background-color","#1e44a6");
    }
    else if(val == 2) {
      $("#mainView").css("background-color","#303441");
    }
    else if(val == 3) {
      $("#mainView").css("background-color","#37116c");
    }
    else if(val == 4) {
      $("#mainView").css("background-color","#999");
    }
    else if(val == 5) {
      $("#mainView").css("background-color","#603a3a");
    }
    else if(val == 6) {
      $("#mainView").css("background-color","#7c9585");
    }
  });
  $('#slideImg').carousel({
    // 슬리아딩 자동 순환 지연 시간
    // false면 자동 순환하지 않는다.
    interval: 5000,
    // hover를 설정하면 마우스를 가져대면 자동 순환이 멈춘다.
    pause: "hover",
    // 순환 설정, true면 1 -> 2가면 다시 1로 돌아가서 반복
    wrap: true,
  });
});