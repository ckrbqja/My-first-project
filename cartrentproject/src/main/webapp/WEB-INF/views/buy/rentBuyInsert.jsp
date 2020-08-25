<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="layoutTag" tagdir="/WEB-INF/tags" %>
<layoutTag:layout>
<!DOCTYPE html>
<html>
<head>
 <link href="http://localhost:8082/static/css/total.css" rel="stylesheet" type="text/css"/>
<meta charset="UTF-8">
<title>상세정보</title>
<head>
<style>
#container{margin-top:40px!important;}
header img {margin-top:0px;}
@-webkit-keyframes sparkle {
  from {
    background-position: 0% 100%;
  }
  to {
    background-position: 200% 100%;
  }
}

@keyframes sparkle {
  from {
    background-position: 0% 100%;
  }
  to {
    background-position: 200% 100%;
  }
}
.test {
  background: white;
  display: inline-block;
  padding: 1em;
  font-family: Helvetica Neue;
  border-radius: 100px;
  position: relative;
}
.test:before {
  -webkit-animation: sparkle 4s infinite linear;
          animation: sparkle 4s infinite linear;
  background: -webkit-gradient(linear, left top, right top, from(#7FEFBD), color-stop(11%, #FFF689), color-stop(22%, #EC0B43), color-stop(33%, #7FEFBD), color-stop(44%, #FFF689), color-stop(55%, #EC0B43), color-stop(66%, #7FEFBD), color-stop(77%, #FFF689), color-stop(88%, #EC0B43), to(#7FEFBD));
  background: linear-gradient(90deg, #000000 0%, #000002 11%, #CCCCCC 22%, #999999 33%, #888888 44%, #555555 55%, #444444 66%, #333333 77%, #222222 88%, #111111 100%);
  background-size: 300% 100%;
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  border-radius: 4px;
  -webkit-filter: blur(3px);
          filter: blur(3px);
  z-index: -1;
  -webkit-transform: scale(0.99) translateY(3px);
          transform: scale(0.99) translateY(3px);
}
</style>
</head>


<body id="" class="longterm-section type-reverse">
<div id="content">
	<div id="container">
		<div class="breadcrumbs">
			<h2 class="tit">솔렌트카 상세정보</h2>
			
			<div class="clearfix">
				<span>홈</span>
				<span>중고렌터카</span>
				<span class="cl-point2">다이렉트 견적</span>
			</div>
			
		</div>

			<div class="header-group mab0 form-group">
				<h3 class="col-sm-5">다이렉트 견적</h3>
				<div class="col-sm-offset-10">
				<a href="#" class="btn btn-line4 btn-fix1 listBtn" onclick="location.href='${path}/rent/rentList'"   >목록</a>
				</div>
			</div>
			<div class="car-list v1 car-list--inquiry">
				<div class="car-list__item-jg">
					<div class="car-list__thumbnail-jg">
						<div class="car-list__thumbnail-image-jg user_car">
							<div class="howmany_jg" >
							    <span class="howmany_jg_font">현재 ${rent.standby_personnel}명의 고객님이 상담 진행 중입니다.</span>
							</div>

							<ul class="underimg col-sm-4">
								<c:forEach items="${rentImage}" var="image">
									<li><img src="${image.rent_url}" width="230" height="120"></li>
								</c:forEach>
							</ul>
						</div>
					</div>
					<div class="car-list__caption-jg">
					<div style="padding-bottom:15px;">
						<p class="car-list__caption-title">${car.car_name}</p>
					</div>
					<div class="bg-line-tran col-sm-8">
					<hr>

						<table style="table-layout-fixed;word-break:break-all;" >
							<tr>
								<td style="width:100px;" >∙ 모델명</td>
								<td>
									${car.car_name}
								</td>
							</tr>
							<tr>
								<td>∙ 소비자가</td>
								<td>
									${String.format('%,d',rent.price)}원
								</td>
							</tr>
							<tr>
								<td>∙ 계약기간</td>
								<td>최대${rent.max_month}개월</td>
							</tr>
							<tr>
								<td>표준 렌탈료</td>
								<td><span class="month_price_number">${String.format('%,d',rent.price)}</span>원</td>
							</tr>
						</table>
                     </div>
					</div>
				</div>
				<!-- car-list__item//end -->
			</div>
	
		<div style=" height: 200px;"></div>

			<article>
				<div class="header-group estimate-type mab0">
					<h4>차량 정보</h4>
				</div>
				<table class="tb-cnt tb-my bt0">
	                    <colgroup>
	                        <col width="20%">
	                        <col width="30%">
	                        <col width="20%">
	                        <col width="30%">
	                    </colgroup>
	                    <tbody>
				        <tr>
					    <th>제조사</th>
					    <td>${car.manufacturer}</td>						
					    <th>차량번호</th>
					    <td>${rent.car_number}</td>							
					  </tr>
					  <tr>
					    <th>차종</th>
					    <td>${car.manufacturer}</td>						
					    <th>최초 등록일</th>
					    <td>${rent.reg_date}</td>								
					  </tr>
					  <tr>
					    <th>모델명</th>
					    <td colspan="3">${car.car_name} </td>				
					  </tr>
					  	
					  <tr>
					  	<th>제조사차량옵션</th>
						<td colspan="3">
								-
						</td>
					  </tr>
					  
					  <tr>
					  	<th>제조사차량옵션2</th>
						<td colspan="3">
								-
						</td>
					  </tr>
					  
					  <tr>
					    <th>주행거리</th>
					    <td>${String.format('%,d',rent.milage)} km</td>					
					    <th>연료</th>
					    <td>${car.fuel}</td>							
					  </tr>	
					  <tr>
					    <th>배기량</th><td>${car.exhaust_volume}cc</td>											
					    <th>색상</th>
					    <td>${rent.color}</td>								
					  </tr>
					  <tr>
					    <th>지역</th>
					    <td colspan="3">${rent.location}</td>			
					  </tr>
	                   </tbody>
	                </table>
			</article>

			<article>
				<div class="header-group estimate-type mab0">
					<h4>옵션 정보</h4>
				</div>
				<div>
					<img src="http://localhost:8082/static/img/icon_가죽시트_${count[0]}.png">
					<img src="http://localhost:8082/static/img/icon_네비게이션_${count[1]}.png">
					<img src="http://localhost:8082/static/img/icon_룸미러_${count[2]}.png">
					<img src="http://localhost:8082/static/img/icon_스마트키_${count[3]}.png">
					<img src="http://localhost:8082/static/img/icon_썬루프_${count[4]}.png">
					<img src="http://localhost:8082/static/img/icon_통풍시트_${count[5]}.png">
					<img src="http://localhost:8082/static/img/icon_후방카메라_${count[6]}.png">
				</div>
				
			</article>			

		<br><br>
		
		<form action="${path}/buy/insertProc" method="post">
		
        	<input type="hidden" name="id" value="${sessionScope.id}"> <!-- 아이디 -->
        	<input type="hidden" name="car_id" value="${rent.car_id}"> <!-- 차 아이디 -->
        	<input type="hidden" name="rent_id" value="${rent.rent_id}"> <!-- 렌트 아이디 -->
        	<input type="hidden" name="color" value="${rent.color}"> <!-- 차 색상 -->
        	<input type="hidden" name="month" value="${month}"> <!-- 계약기간 -->
        	
			<div class="form-gorup-list js-accordion-group">

				<article>
					<div class="header-group estimate-type clearfix mab0">
						<h4 class="fl">선택한 렌트 정보</h4>
					</div>
					<fieldset>
						<legend class="sr-only">렌트 선택 폼</legend>
						<div class="form-group form-group--estimate test">
							<input type="text" id="sDate" readonly="readonly" placeholder="계약시작일" name="sDate" value="" style="display:none;" >
									<div class="form-group__list">
									<div class="form-group__header">
										<div class="estimate-list">
											<div class="estimate-list__label">
												<p class="estimate-list__label-title">계약기간</p>
											</div>
											<!-- estimate-list__label//end -->
											<div class="estimate-list__item">
												<div class="estimate-item__caption clearfix">
													<p class="estimate-item__caption-text fl" id="monthShow">${month}개월</p>
												</div>
											</div>
										</div>
										
								</div>

								<div class="form-group__header">
									<div class="estimate-list">
										<div class="estimate-list__label">
												<p class="estimate-list__label-title">약정 주행거리</p>
										</div>
										<!-- estimate-list__label//end -->
										<div class="estimate-list__item">
											<div class="estimate-item__caption clearfix">
												<p class="estimate-item__caption-text"  id="driving">${km}만km 이하/년</p>
											</div>
											<!-- estimate-item__caption//end -->
										</div>
									</div>
									
								<div class="form-group__header">
									<div class="estimate-list" style="margin-left: 0px;">
										<div class="estimate-list__label">
												<p class="estimate-list__label-title">보증금</p>
										</div>
										<div class="estimate-item__caption clearfix">
											<!-- estimate-item__caption//end -->
											<div class="col-sm-10">
												<p class="estimate-item__caption-text" id="prmsDtcClsCd_view">보증금<span id="span_deposit" class="cl-point2 ml10">&nbsp;${deposit}원&nbsp;</span>(렌탈료 1개월분 * 5)<span id="span_deposit_after" ></span></p>
											</div>
											<div class="col-sm-12">
												<p class="estimate-item__caption-subtext">※ 보증금 납부 후 차량이 출고되며, 입금(가상)계좌는 계약완료 후 문자 발송됩니다.</p>
											</div>
										</div>
									</div>
									</div>
								
								</div>
								
								<div class="form-group__header">
									<div class="estimate-list">
										<div class="estimate-list__label">
											<p class="estimate-list__label-title">월 렌트비용</p>
										</div>
										<div class="estimate-list__item">
											<div class="estimate-item__caption clearfix">
												<p class="estimate-item__caption-text fl" >${totalPrice}원</p>
											</div>
										</div>
									</div>
								</div>
								
						</div>
						</div>
					</fieldset>
					
					<br><br>
					
					<div class="header-group estimate-type clearfix mab0">
						<h4 class="fl">정보 입력</h4>
					</div>
					
					<div class="form-group__header">
						<div class="estimate-list">
							<div class="estimate-list__label">
								<p class="estimate-list__label-title">이 름</p>
							</div>
							<div class="estimate-list__item">
								<div class="estimate-item__caption clearfix">
									<input type="text" class="form-control" id="name" name="name"value="${member.name }">
								</div>
							</div>
						</div>
					</div>
					
					<div class="form-group__header">
						<div class="estimate-list">
							<div class="estimate-list__label">
								<p class="estimate-list__label-title">주소</p>
							</div>
							<div class="estimate-list__item">
								<div class="estimate-item__caption clearfix">
									<input type="text" class="form-control" id="address" name="address" value="${member.address}" style="border: 1px double #D1D0CE;background-color: #e2e2e2;" readonly/>
								</div>
							</div>
						</div>
					</div>
					
					<div class="form-group__header">
						<div class="estimate-list">
							<div class="estimate-list__label">
								<p class="estimate-list__label-title">전화번호</p>
							</div>
							<div class="estimate-list__item">
								<div class="estimate-item__caption clearfix">
									<input type="text" class="form-control" id="tel" name="tel"value="${member.tel}" maxlength="11">
								</div>
							</div>
						</div>
					</div>
				</article>
				
				<div class="btn-box text-c">
					<button type="submit" class="btn btn-color2 btn-large btn-fix3 m-link sm-link_padding-all sm-link5">
						<span>구매완료</span>
					</button>
				</div>
				
</div></form></div></div>
</body>
<script>
$("#name").on("keyup", function() {
    $(this).val($(this).val().replace(/[^a-zA-Zㄱ-힣]/gi,""));
});

$("#tel").on("keyup", function() {
    $(this).val($(this).val().replace(/[^0-9]/g,""));
});
</script>
</html>
</layoutTag:layout>