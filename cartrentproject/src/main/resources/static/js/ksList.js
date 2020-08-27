$(document).ready(function(){
	selectCar();
	//시간차를둬야 가능
	setTimeout(function() {searchForm();}, 60);
	
	$('#ex1').slider({});  //대여기간
	$("#ex2").slider({});  //월렌탈료
	$("#ex3").slider({});  //주행거리
	$("#ex4").slider({});  //차량등록

});
//숫자 세자리 콤마 찍는 정규식
function numberFormat(inputNumber) {
	   return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

//footerSHeight값 이상일시 class를 바꾼다
$(window).scroll(
		function() {
			var windowHeight = $(window).height() - window.innerHeight-$('#footer').height(); // Viewport Height
			var scrollValue = $(document).scrollTop();
			if (scrollValue > windowHeight){
				$('.quick-top').attr('style','position:absolute');
				$('#toptop').css('margin-top',windowHeight+'px');
					
			}else{
				$('.quick-top').css('position','fixed');
				$('#toptop').css('margin-top','');
			}
		});




//버튼 클릭시 효과 & 값 입력
function cc(index, data){
	var data1 = $('.'+ data + index).html();
	if($('.'+ data + index).attr('class').match('selected_red_font')==null){
		$('.'+ data + index).addClass('selected_red_font selected_red');
		$('#a' + data1).val(data1);
		
		$('.'+data).attr('class', data);
		$('.'+data).val('');
	}else{
		$('.'+ data + index).attr('class', data + index);
		$('#a' + data1).val('');
	}
}

//전체 버튼 클릭 시 다른 값 제거
function ac(data){
	var temp = '';
	if($('.'+data).attr('class').match('selected_red_font')==null){
		$('.'+data).addClass('selected_red_font selected_red');
		
		for(i = 0 ; i < 6; i++){
			$('.'+ data + i).attr('class', data + i);
			$('#a' + $('.'+ data + i).html()).val('');
		}
	}else{ 
		$('.'+data).attr('class', data);
	}
}

//최종 데이터 조회
function searchForm(click){
	if(click != 'click') $('[name=limit]').val('');
	var forms = $('.listForm').serialize();
	$.ajax({
		url  : '/rent/rentListProc',
		data : forms,
		traditional : true,
		type : 'get',
		success : function(data){
			var str = '<div class="result_bigbox" id="result_bigbox_list" style="margin:0px">';
			$.each(data.rentList, function(key, value){
				str += '<a href="#"><div class="result_box grid-bottom hideme bottom textbox" onclick="location.href=\'/rent/rentListDetail/'+ value.rent_id +'\'">'+
				'<div class="car-list__sticker joonggo">중고차</div>'+
			'<div class="result_box_top ">'+
					'<div class="result_img user_car">'+
							'<img src="'+value.rent_url+'"  class="user_img">'+
						'<span class="car_number">'+ value.car_number +'</span>'+
					'</div>'+
				'<div class="result_top_right">'+
					'<p>'+ value.manufacturer +'</p>'+
					'<p  class="desc" style="width: 200px;">'+ value.car_name +'</p>'+
						'<ul class="sticker_box">'+
							'<li class="sticker_membership">멤버십</li>'+
						'</ul>'+
					'<ul class="result_rental">'+
						'<li style="font-size: 14px; margin-top: 70px;">렌탈료</li>'+
						'<li>'+
							'<span class="result_rental_price"  style="margin-top: 66px;">'
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
			'</div>';
			if(value.standby_personnel > 0){
				str += '<div class="howmany_box" style="background-color: f5f5f5;'+ 
				'z-index: -5">'+
					'<span class="howmany_box_span" style="font-size:13px;">&nbsp;&nbsp;&nbsp;&nbsp;현재 <span class="cl-point2 fontbold">'+ 
					+ value.standby_personnel +'</span>명의 고객님이 상담 중입니다.</span>'+
				'</div>';
			}
		str += '</div></a>';
				
			});
				if(data.count > 1 ){
				str+= '</div></div><div class="col-sm-12" style="padding:0px; border:none !important;">';
				str+= '<input id="buTemp" class="hidden" value="'+data.count+'"><button style="background-color:#e0e0e0;" class="col-sm-12 btn" id="moreBtn" type="button" onclick="more('+ data.count +');">더보기&nbsp;<span class="glyphicon glyphicon-menu-down"></span></button></div>';
				}
				
				$('#total').html('(총 '+data.total+'건)');
			$('#aa').html(str);
		}
	});
}

//더보기 버튼 클릭 시 화면보여줌
function more(count){
	$('[name=limit]').val(count-1);
	searchForm('click');
}

//무한스크롤
$(window).scroll(
		function() {
			var windowHeight = $(window).height() - window.innerHeight;
			var scrollValue = $(document).scrollTop()+10;
			var bTemp = $('#buTemp').val();
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
	var windowHeight = $('#total').offset().top - $('#menuHeader11').height(); ; // 토탈의 스크롤위치
	var scrollValue = $(document).scrollTop();	
  	var nextScrollTop = window.pageYOffset || 0; 
  	
  if (nextScrollTop > prevScrollTop && scrollValue > windowHeight){
    headerMoving("down"); //스크롤 내리는 중에 실행코드
  } else if (nextScrollTop < prevScrollTop ){
    headerMoving("up"); //스크롤 올리는 중에 실행코드
  }
  prevScrollTop = nextScrollTop;
  
});



		