<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="layoutTag" tagdir="/WEB-INF/tags" %>
<layoutTag:layout>
<!DOCTYPE html>
<html>
<head>
<style>
@keyframes spin {
  0% {
    transform: translate(2px, 1px) rotate(0deg);
  }
  10% {
    transform: translate(-1px, -3px) rotate(36deg);
  }
  20% {
    transform: translate(-2px, 0px) rotate(72deg);
  }
  30% {
    transform: translate(1px, 2px) rotate(108deg);
  }
  40% {
    transform: translate(1px, -1px) rotate(144deg);
  }
  50% {
    transform: translate(-1px, 3px) rotate(180deg);
  }
  60% {
    transform: translate(-1px, 1px) rotate(216deg);
  }
  70% {
    transform: translate(3px, 1px) rotate(252deg);
  }
  80% {
    transform: translate(-2px, -1px) rotate(288deg);
  }
  90% {
    transform: translate(2px, 1px) rotate(324deg);
  }
  100% {
    transform: translate(1px, -2px) rotate(360deg);
  }
}
@keyframes speed {
  0% {
    transform: translate(2px, 1px) rotate(0deg);
  }
  10% {
    transform: translate(-1px, -3px) rotate(-1deg);
  }
  20% {
    transform: translate(-2px, 0px) rotate(1deg);
  }
  30% {
    transform: translate(1px, 2px) rotate(0deg);
  }
  40% {
    transform: translate(1px, -1px) rotate(1deg);
  }
  50% {
    transform: translate(-1px, 3px) rotate(-1deg);
  }
  60% {
    transform: translate(-1px, 1px) rotate(0deg);
  }
  70% {
    transform: translate(3px, 1px) rotate(-1deg);
  }
  80% {
    transform: translate(-2px, -1px) rotate(1deg);
  }
  90% {
    transform: translate(2px, 1px) rotate(0deg);
  }
  100% {
    transform: translate(1px, -2px) rotate(-1deg);
  }
}
@keyframes strikes {
  from {
    left: 25px;
  }
  to {
    left: -80px;
    opacity: 0;
  }
}
@keyframes dots {
  from {
    width: 0px;
  }
  to {
    width: 15px;
  }
}
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.fadeIn, .loading-window {
  animation: fadeIn 0.4s both;
}

.loading-window {
  background: #333;
  border-radius: 6px;
  border: 3px solid #ffe4e1;
  color: #ffe4e1;
  height: 200px;
  left: 50%;
  margin-left: -150px;
  margin-top: -100px;
  position: fixed;
  top: 50%;
  width: 300px;
  z-index: 99;
}
.loading-window .text {
  font-size: 16px;
  position: absolute;
  width: auto;
  top: 75%;
  left: 38%;
  margin: 0 auto;
}
.loading-window .dots {
  display: inline-block;
  width: 5px;
  overflow: hidden;
  vertical-align: bottom;
  animation: dots 1.5s linear infinite;
  transition: 1;
}

.car {
  position: absolute;
  width: 117px;
  height: 42px;
  left: 92px;
  top: 70px;
}
.car .strike {
  position: absolute;
  width: 11px;
  height: 1px;
  background: #ffe4e1;
  animation: strikes 0.2s linear infinite;
}
.car .strike2 {
  top: 11px;
  animation-delay: 0.05s;
}
.car .strike3 {
  top: 22px;
  animation-delay: 0.1s;
}
.car .strike4 {
  top: 33px;
  animation-delay: 0.15s;
}
.car .strike5 {
  top: 44px;
  animation-delay: 0.2s;
}
.car-detail {
  position: absolute;
  display: block;
  background: #ffe4e1;
  animation: speed 0.5s linear infinite;
}
.car-detail.spoiler {
  width: 0;
  height: 0;
  top: 7px;
  background: none;
  border: 20px solid transparent;
  border-bottom: 8px solid #ffe4e1;
  border-left: 20px solid #ffe4e1;
}
.car-detail.back {
  height: 20px;
  width: 92px;
  top: 15px;
  left: 0px;
}
.car-detail.center {
  height: 35px;
  top:0px;
  width: 75px;
  left: 12px;
  border-top-left-radius: 30px;
  border-top-right-radius: 45px 40px;
  border: 4px solid #ffe4e1;
  background: none;
  box-sizing: border-box;
}
.car-detail.center1 {
  height: 35px;
  width: 35px;
  left: 12px;
  border-top-left-radius: 30px;
}
.car-detail.front {
  height: 20px;
  width: 50px;
  top: 15px;
  left: 67px;
  border-top-right-radius: 50px 40px;
  border-bottom-right-radius: 10px;
}
.car-detail.wheel {
  height: 20px;
  width: 20px;
  border-radius: 50%;
  top: 20px;
  left: 12px;
  border: 3px solid #333;
  background: linear-gradient(45deg, transparent 45%, #ffe4e1 46%, #ffe4e1 54%, transparent 55%), linear-gradient(-45deg, transparent 45%, #ffe4e1 46%, #ffe4e1 54%, transparent 55%), linear-gradient(90deg, transparent 45%, #ffe4e1 46%, #ffe4e1 54%, transparent 55%), linear-gradient(0deg, transparent 45%, #ffe4e1 46%, #ffe4e1 54%, transparent 55%), radial-gradient(#ffe4e1 29%, transparent 30%, transparent 50%, #ffe4e1 51%), #333;
  animation-name: spin;
}
.car-detail.wheel2 {
  left: 82px;
}
.checkbox input {display:none;}
.checkbox span {display:inline-block;vertical-align:middle;cursor:pointer;}
.checkbox .icon {position:relative;width: 17px;height: 17px;border: 1px solid #c8ccd4;border-radius: 3px;transition: background 0.1s ease;}
.checkbox .icon::after {content: '';position: absolute;top: 1px;left: 5px;width: 5px;height: 11px;border-right: 2px solid #fff;border-bottom: 2px solid #fff;transform: rotate(45deg) scale(0);transition: all 0.3s ease;transition-delay: 0.15s;opacity: 0;}
.checkbox .text {margin-left: 5px;}

.checkbox input:checked ~ .icon {border-color: transparent;background: #ff1616;animation: jelly 0.6s ease;}
.checkbox input:checked ~ .icon::after {opacity: 1;transform: rotate(45deg) scale(1);
}

@keyframes jelly {
	from {transform: scale(1, 1);}
	30% {transform: scale(1.25, 0.75);}
	40% {transform: scale(0.75, 1.25);}
	50% {transform: scale(1.15, 0.85);}
	65% {transform: scale(0.95, 1.05);}
	75% {transform: scale(1.05, 0.95);}
	to {transform: scale(1, 1);}
}


img{
	margin-top:-20px;
}
#aaaa{
	position: fixed;
	box-shadow: rgba(0, 0, 0, 0.5) 0 0 0 9999px, rgba(0, 0, 0, 0.5) 2px 2px
		3px 3px;
	z-index: 10000;
}
.swal2-checkbox input {
	display:none;
}
</style>
<meta charset="UTF-8">
<title>솔렌트카 로그인 페이지</title>
</head>
<body>

	<c:if test="${sessionScope.id != null and check == 0}">
		<script type="text/javascript">
			location.href='${path}/main';
		</script>
	</c:if>
	<c:if test="${sessionScope.id != null and check == 1}">
		<script type="text/javascript">
			location.href='${path}/counseling/userList';
		</script>
	</c:if>
	<div id="content">
    <div id="container" class="col-half">
    
    
        <div class="breadcrumbs text-c">
            <h2 class="tit">로그인</h2>
        </div>
		<form class="form-horizontal" action="${path}/member/loginProc" method="get" name="form1">
	    <input type="hidden" id="check" name="check" value="${check}">
            <div class="tab-menu v3">
                <ul>
                    <li class="col-2 selected">
                        <a href="#login-personal" id="persn">개인회원/개인사업자</a>
                    </li>
                </ul>
            </div>
                <div class="input-field field-large">
                    <div class="input-row">
                        <span class="input input-large">
							<input type="text" class="form-control idinput" id="id" name="id" size="10" placeholder="아이디를 입력하세요"/>
							<input class="hidden" name="Referer" value="${Referer}">
                        </span>
                    </div>
                    <div class="input-row">
                        <span class="input input-large">
							<input type="password" class="form-control" name="password" size="10" placeholder="비밀번호를 입력하세요"/>
                        </span>
                    </div>
                    <div class="input-row">
						<label class="checkbox">
							<input type="checkbox"  id="select-terms3" class="chkuser_id"  name="chkuser_id" class="idchk" >
							<span class="icon"></span>
							<span class="text">아이디 저장</span>
						</label>
                    </div>
                </div>
                <div class="join-btn-box btn-box text-c" >
                    <button type="button" class="btn btn-color2 btn-block btn-large" onClick="saveid(document.new_user_session);">로그인</button>
                </div>
                <div id="login-personal" class="tab-content" style="display: block;">
	                <div class="join-alert">
	                    <div class="btn-box text-c">
	                        <a onclick="location.href='${path}/member/insertForm'" class="btn">간편회원가입</a>
	                    </div>
	                </div>
                </div>
        </form>
    </div>
    
</div>
	<div id="aaaa"  style="display:none;"> s  	</div>		

<div class="loading-window" style="z-index: 99999; display: none; ">
    <div class="car">
        <div class="strike"></div>
        <div class="strike strike2"></div>
        <div class="strike strike3"></div>
        <div class="strike strike4"></div>
        <div class="strike strike5"></div>
        <div class="car-detail back"></div>
        <div class="car-detail center"></div>
        <div class="car-detail center1"></div>
        <div class="car-detail front"></div>
        <div class="car-detail wheel"></div>
        <div class="car-detail wheel wheel2"></div>
    </div>

    <div class="text">
        <span>Loading</span><span class = "dots">...</span>
    </div>
</div>
</body>
<script>

$(function(){
	var check = document.getElementById('check').value;
	getid();
	$("#chkuser_id").click(function(){
		saveid();
	}); //#chkuser_id.click
}); //function(){
  
 function saveid() {
   var expdate = new Date();
   // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
   if($(".chkuser_id").prop("checked")){
    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
   } else {
    expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
   }
   setCookie("saveid", $("#id").val(), expdate);
	if(check == 1) {
		alert("zzdasd");
		document.form1.action="${path}/member/loginProc?check="+check;
		document.form1.submit();
	}


	

	$.ajax({
		url 	: '/member/loginProcAjax',
		data 	: $('[name=form1]').serialize(),
		type	: 'get',
		success : function(data){
			if(data == 0){
				$('#aaaa').css('display','none');
				$('.loading-window').css('display','none'); 
					Swal.fire({
			        title: 'Error!', /*상단 타이틀*/
			        text: '아이디를 확인해주세요', /*내용*/
			        icon: 'error', /*아이콘 타입*/
			        confirmButtonText: '확인' /*확인버튼 클가*/
			    });

			}
			if(data == 1){
				$('#aaaa').css('display','none');
				$('.loading-window').css('display','none'); 
				
				Swal.fire({
			        title: 'Error!', /*상단 타이틀*/
			        text: '비밀번호를 확인해주세요', /*내용*/
			        icon: 'error', /*아이콘 타입*/
			        confirmButtonText: '확인' /*확인버튼 클가*/
			    });
			}
			if(data == 2){
			    Swal.fire({
			        title: 'success!', /*상단 타이틀*/
			        text: '로그인 되었습니다', /*내용*/
			        icon: 'success', /*아이콘 타입*/
			        confirmButtonText: '확인' /*확인버튼 클가*/
			    }).then(function(){
			    	//프리로더
					$('.loading-window').css('display','block');
					$('#aaaa').css('display','block');
					
					setTimeout(function() { form1.submit(); }, 2000);
			    });
				
			}
		}
	}); //ajax end
		


 } //saveid()
 
 function setCookie (name, value, expires) {
    document.cookie = name + "=" + escape (value) +"; path=/; expires=" + expires.toGMTString();
  } //setCookie(name,value,expires)

  function getCookie(Name) {
    var search = Name + "=";
    if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
      offset = document.cookie.indexOf(search);
      if (offset != -1) { // 쿠키가 존재하면
        offset += search.length;
        // set index of beginning of value
        end = document.cookie.indexOf(";", offset);
        // 쿠키 값의 마지막 위치 인덱스 번호 설정
        if (end == -1)
          end = document.cookie.length;
        return unescape(document.cookie.substring(offset, end));
      }
    }
    return "";
  } //getCookie(Name)

 function getid() {
  var saveId = getCookie("saveid");
  if(saveId != "") {
   $("#id").val(saveId);
   $(".chkuser_id").prop("checked",true);
  }
 } //getid()
</script> 

</html>
</layoutTag:layout>