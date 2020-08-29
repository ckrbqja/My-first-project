<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="true"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="layoutTag" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<layoutTag:layout>
<!DOCTYPE html>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value='${now}' pattern='yyyy' var="now"/>
<html>
<style>
header img{margin-top:0px;}
.container {width: 1030px; }
#moreBtn {margin-top: 30px; background-color: #e0e0e0;}
.user_img {
   transform:scale(1.0);        
   transition: transform .5s; 
}

</style>
<style>
.select-box {height: 60px;}
.user_img { transform:scale(1.0);   transition: transform .5s;}
*{margin:0;padding:0;}
.thumb {width:auto;overflow:hidden;padding-bottom:56.25%;position:relative;}
.desc {display:inline;background: linear-gradient(to right, rgba(255,255,255,0) 50%, #FFE400 50%);background-size: 200%;background-position: 0 0;transition: .35s ease-in-out;font-size:11px;line-height:1.6;color:#666;word-break:keep-all;}
.textbox:hover .desc {background-position: -100% 0;}
.textbox:hover .user_img {   transform:	scale(1.1);   transition: 	transform .2s; }
</style>
<head>
 <link href="http://localhost:8082/static/css/total.css" rel="stylesheet" type="text/css"/>
 <link href="http://localhost:8082/static/css/bootstrap-slider.css" rel="stylesheet" type="text/css"/>
	<meta charset="UTF-8">
	<title>중고차 or 신차 리스트 페이지</title>
</head>
<body>
<div class="content">
<form class="listForm" action="/rent/rentListProc" method="post">
	<div class="container">
		<div class="breadcrumbs">
			<h2 class="tit">장기렌트카 리스트</h2>
			
			<div class="clearfix">
				<span>홈</span>
				<span class="cl-point2">장기렌트카 리스트</span>
			</div>
		</div>	
		<div class="container" style="padding-left: 0px; width: 1014px;">
		<div class="tab-menu v1">
            <ul class="unlink tTab" id="reservMenu">
            	<li class="col-3 selected">
                	<a href="/rent/NewRentList">신차 렌트카</a>
                </li>
                <li class="col-3 ">
                    <a href="/rent/rentList">중고차 렌트카</a>
                </li>
                <li class="col-3" >
		           <a href="/buy/memberCheckForm?check=1">예약 확인</a>
                </li>
            </ul>
        </div>
	</div>
	
	
<input class="hidden" name="limit" value="">
	<article id="artcleCarModlList" >
				<div class="header-group clearfix">
						<h3>
							검색 결과<span class="result_span" id="total"></span>
						</h3>
					<div class="select-col result_kind_new">
						<span class="select-box"> 
							<select name="orderBy" onchange="searchForm();" class="form-control ">
								<option value="0">낮은 가격 순</option>
								<option value="1">높은 가격 순</option>
								<option value="2">짧은 주행거리 순</option>
								<option value="3">최근 등록 순</option>
								<option value="4">인기 순</option>
							</select>
						</span>
					</div>
				</div>
				
				
		<div id="aa"></div>
		
		
		
		</article>
<div class="quick-top" style="z-index: 10000;">
	<a id="aaaaaa" class="btn-top">TOP</a>
</div>
	</div>
</form>
		<br><br>	
</div>
</body>
<script type="text/javascript">
//숫자 세자리 , 찍는 정규식
function numberFormat(inputNumber) {
	   return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

searchForm();
//최종 데이터 조회
function searchForm(click){
	if(click != 'click') $('[name=limit]').val('');
	var forms = $('.listForm').serialize();
		
	$.ajax({
		url  : '/rent/newRentListProc',
		data : forms,
		traditional : true,
		type : 'get',
		success : function(data){
			var str = '<div class="result_bigbox" id="result_bigbox_list" style="margin:0px">';
			$.each(data.rentList, function(key, value){
				str += '<a href="#"><div style="margin:0px" onmouseenter="oms('+key+')" onmouseleave="oml('+key+')" class="result_box grid-bottom hideme bottom textbox" onclick="location.href=\'/rent/NewRentListDetail/'+ value.rent_id +'\'">'+
				'<div class="car-list__sticker special">신차</div>'+
			'<div class="result_box_top ">'+
					'<div class="result_img user_car">'+
							'<img src="'+value.color_url+ value.color_image +'"  class="user_img">'+
						'<span class="car_number">'+ value.car_number +'</span>'+
					'</div>'+
				'<div class="result_top_right">'+
					'<p><span class="hotdeal_sticker top-2">Hot Deal</span>'+ value.manufacturer +'</p>'+
					'<p  class="desc" style="width: 200px;"><label class="check" style="margin-left:-20px;"><input id="checkId" type="checkbox" name="as'+key+'"><span class="icon" style="bottom:15px;left:9px;"></span></label>'+ value.car_name +'</p>'+
						'<ul class="sticker_box">'+
							'<li class="sticker_membership">멤버십</li>'+
						'</ul>'+
					'<ul class="result_rental">'+
						'<li style="font-size: 14px; margin-top: 70px;">렌탈료</li>'+
						'<li>'+
							'<span class="result_rental_price"  style="margin-top: 68px;">'
							+ numberFormat(value.price) +'<font size="-1">원~</font></span>'+
						'</li><li></li>'+
					'</ul>'+
				'</div>'+
				'<ul class="normal_price" style="width: 500px !important;">'+
					'<li style="font-size: 14px;">금  액</li>'+
					'<li><span>'+ numberFormat(value.car_price*10000) +'</span>원</li>'+
				'</ul>'+
			'</div>'+
			'<div class="result_box_bottom" style="height	: 114px;">'+
				'<div class="result_bottom">'+
					'<ul class="result_bottom_left_ul_dot">'+
						'<li>차량등록</li>'+
						'<li>주행거리</li>'+
					'</ul>'+
					'<ul class="result_bottom_left_ul">'+
						'<li> '+ value.reg_date.substring(0,4)+'년 </li>'+
						'<li> '+ value.milage +'km </li>'+
					'</ul>'+
				'</div>'+
				'<div class="result_bottom">'+
					'<ul class="result_bottom_left_ul_dot">'+
						'<li>계약기간</li>'+
						'<li>지역</li>'+
					'</ul>'+
					'<ul class="result_bottom_left_ul">'+
							'<li>'+ value.max_month+'개월</li>'+
							'<li>'+ value.location +'</li>'+
					'</ul>'+
				'</div>'+
			'</div>'+
		'</div></a>';
				
			});
				if(data.count > 1 ){
				str+= '</div><br><br><div class="col-sm-12" style="padding:0px;">';
				str+= '<input id="buTemp" class="hidden" value="'+data.count+'"><button class="col-sm-12 btn" id="moreBtn" type="button" onclick="more('+ data.count +');">더보기&nbsp;<span class="glyphicon glyphicon-menu-down"></span></button></div>';
				}
				
				$('#total').html('(총 '+data.total+'건)');
			$('#aa').html(str);
		}
	});
}

//더보기 버튼 클릭 시 
function more(count){
	$('[name=limit]').val(count-1);
	searchForm('click');
}

//footerSHeight값 이상일시 class를 바꾼다
$(window).scroll(
		function() {
			var windowHeight = $(window).height() - window.innerHeight-$('#footer').height(); // Viewport Height
			var scrollValue = $(document).scrollTop();
			if (scrollValue > windowHeight){
				$('.quick-top').attr('style','position:absolute');
				$('#aaaaaa').css('margin-top',windowHeight+'px');
					
			}else{
				$('.quick-top').css('position','fixed');
				$('#aaaaaa').css('margin-top','');
			}
		});


	$('#aaaaaa').css('display', 'none');
	$(window).scroll(function() {
		if ($(this).scrollTop() > 400) {$('#aaaaaa').fadeIn();} 
		else {$('#aaaaaa').fadeOut();}
	});

	$('#aaaaaa').click(function() {
		$('html, body').animate({scrollTop : 0}, 400);
		return false;
	});
	
	
//무한스크롤
$(window).scroll(
		function() {
			var windowHeight = $(window).height() - window.innerHeight;
			var scrollValue = $(document).scrollTop()+10;
			var bTemp = $('#buTemp').val();
			var count = $('[name=limit]').val();
			if(!isNaN(count))
			if(windowHeight < scrollValue) more(bTemp);
});

//스크롤 내릴시 헤더 가림
var header = document.querySelector('header');
var headerMoving = function(direction){
	
	
  if (direction === "up"){
    header.className = '';
  } else if (direction === "down"){
    header.className = 'scrollDown';
  }
};
var prevScrollTop = 0;
document.addEventListener("scroll", function(){ //스크롤 중인 이벤트
	var windowHeight = $('#total').offset().top - $('#menuHeader11').height(); // 토탈의 스크롤위치
	
	var scrollValue = $(document).scrollTop();	
	console.log(windowHeight +"  " + 	scrollValue);	
  	var nextScrollTop = window.pageYOffset || 0; 
  if (nextScrollTop > prevScrollTop   && scrollValue > windowHeight){
    headerMoving("down"); //스크롤 내리는 중에 실행코드
  } else if (nextScrollTop < prevScrollTop ){
    headerMoving("up"); //스크롤 올리는 중에 실행코드
  }
  prevScrollTop = nextScrollTop;
  
});


//스크롤 프로그레스바
jQuery(function($){
    var growmouseover = [true, '25px'] // magnify progress bar onmouseover? [Boolean, newheight]

    var $indicatorparts = $(document.body).append('<div class="scrollindicator"><div class="scrollprogress"></div></div>')
    var $indicatorMain = $indicatorparts.find('div.scrollindicator')
    var $scrollProgress = $indicatorparts.find('div.scrollprogress')
    var indicatorHeight = $indicatorMain.outerHeight()
    var transformsupport = $scrollProgress.css('transform')
    transformsupport = (transformsupport == "none" || transformsupport =="")? false: true

    		
    		
    function syncscrollprogress(){
        var winheight = $(window).height()
        var docheight = $(document).height()
        var scrollTop = $(window).scrollTop()
        var trackLength = $(document).height()-window.innerHeight;
        var pctScrolled = Math.floor(scrollTop/trackLength * 100)
        if(pctScrolled ==  99) pctScrolled = 100;
        console.log(pctScrolled);
            $scrollProgress.css('transform', 'translate3d(' + (-100 + pctScrolled) + '%,0,0)')
    }
    
    if (transformsupport){
        $indicatorMain.css('visibility', 'visible')
    
        $indicatorMain.on('click', function(e){
            var trackLength = $(document).height() - $(window).height()
            var scrollamt = e.clientX/($(window).width()-32) * trackLength
            $('html,body').animate({scrollTop: scrollamt}, 'fast')
        })
    
        if (growmouseover[0]){
            $indicatorMain.on('mouseenter touchstart', function(e){
                $(this).css('height', growmouseover[1])
                e.stopPropagation()
            })
        
            $indicatorMain.on('mouseleave', function(e){
                $(this).css('height', indicatorHeight)
            })
            
            $(document).on('touchstart', function(e){
                $indicatorMain.css('height', indicatorHeight)
            })
        }
        
        $(window).on("scroll load", function(){
            requestAnimationFrame(syncscrollprogress)
        })
    }
})

//호버가  css가 있어서 안됨 
function  oms(key){$('input:checkbox[name="as'+key+'"]').prop("checked", true);}
function  oml(key){$('input:checkbox[name="as'+key+'"]').prop("checked", false);}
</script>

</html>
</layoutTag:layout>