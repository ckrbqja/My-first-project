<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="URL" value="${pageContext.request.requestURL}" />
<!-- 관리자 메뉴에 마스터가 아닌 다른 계정이 올 시 메인으로 보낸다 -->
<c:if test="${sessionScope.id != 'master' and (fn : contains(URL, 'admin') or fn : contains(URL, 'accident') or fn : contains(URL, 'buy/list'))}">
	<script type="text/javascript">
		location.href='/main';
	</script>
</c:if>


<!-- header 시작 -->
<header id="menuHeader11"
	class="hc <c:if test="${fn : contains(URL, 'service') || fn : contains(URL, 'qna')}">extend</c:if> "
	style="border-bottom: 0.1px solid rgb(255, 255, 255, .5);">
	<div class="header-wrapper">
		<h1 id="menuHeaderLogoH1">
			<a style="background-image: none;" <c:if test="${URL.substring(36) == 'main.jsp'}">href="/main#page1"</c:if>
			href="/main" style="margin-top: -20px !important;">
			<img id="logoImg" src="http://localhost:8082/static/img/KsLogo.png" <c:if test="${ fn : contains(URL, 'service') || fn : contains(URL, 'qna')}">style="margin-top:0px!important;"</c:if>></a>
		</h1>
		<nav id="util">
			<ul>
				<li><c:if test="${sessionScope.id == null}">
						<a href="/member/loginForm" class="awaw">로그인 </a>
					</c:if> <c:if test="${sessionScope.id != null}">
						<a href="/member/logOut" class="awaw">로그아웃  </a>
					</c:if></li>
				<c:if test="${sessionScope.id != null && sessionScope.id != 'master'}">
					<li><a  class="awaw" href="${path}/member/detail/${sessionScope.id}">회원정보</a>
					</li>
				</c:if>
				<li><a href="/serviceCenter" class="awaw">고객센터</a></li>

				<!-- 관리자일 경우 보여짐 -->
				<c:if test="${sessionScope.id eq 'master'}">
					<li class="nav-menu nav-estimate primary dropdown"
						id="estimate-span"><a href="${path}/admin"
						class="dropdown-toggle awaw" data-toggle="dropdown" role="button"
						aria-expanded="false"> &nbsp;관리자 메뉴&nbsp;<span class="caret"></span></a>
						<ul class="dropdown-menu" role="menu">
							<li><a href="${path}/admin/carInsert">차량등록</a></li>
							<li><a href="${path}/admin/rentInsertForm">렌트등록</a></li>
							<li><a href="${path}/admin/carList">차량리스트</a></li>
							<li><a href="${path}/admin/rentList">렌트리스트</a></li>
							<li><a href="${path}/accident/list">사고이력 전체목록</a>
							<li><a href="${path}/counseling/list">상담(비구매) 전체목록</a>
							<li><a href="${path}/buy/list">예약(구매예정) 전체목록</a>
							<li class="divider"></li>
							<li><a href="#">Exit</a></li>
						</ul></li>
				</c:if>
			</ul>
		</nav>
		
		
		<nav class="gnb hc " id="menuHeader12" >
			<h2 class="sr-only ">메인 메뉴</h2>
			<div class="gnb-wrapper">
				<ul class="gnb-listbox">
					<li class="gnb-listitem gnb-listitem-long"><a
						<c:if test="${URL.substring(36) == 'main.jsp'}">href="/main#page2"</c:if>
						href="/main.doa" class="gnb-anchor awaw aa1 serviceLong"
						style="left: auto; right: 50px;">장기렌터카</a></li>
					<li class="gnb-listitem gnb-listitem-short"><a
						<c:if test="${URL.substring(36) == 'main.jsp'}">href="/main#page3"</c:if>
						href="/rent/main.do" class="gnb-anchor awaw aa2 serviceShort"
						style="left: 40px; width: 100px;">단기렌터카</a></li>
				</ul>
			</div>
			<div class="service">


				<!-- 고객센터 헤더 CSS -->
				<c:if test="${fn : contains(URL, 'service') || fn : contains(URL, 'qna')}">
					<div class="gnb-localnav">
						<div class="gnb-wrapper">
							<div class="gnb-curent customer">
								<ul>
									<li class="selected"><a id="P0401" href="#none"
										data-name="customer" data-role="true">고객센터</a>
										<div class="gnb-depth-layer">
											<ul></ul>
										</div></li>
								</ul>
							</div>
							<div class="gnb-local-depth">
								<ul>
									<li><a id="P040101" href="/serviceCenter">공지사항</a></li>
									<li><a id="P040102"
										href="/serviceCenter/customerConsultation">고객상담</a></li>
									<li><a id="P040103" href="/serviceCenter/faq">자주찾는 질문</a>
									</li>
									<li><a href="${path}/qna/list">QNA</a></li>


									<c:if test="${sessionScope.id eq 'master'}">
										<li><a id="P040104"
											href="${path}/serviceCenter/noticeInsertForm">공지사항 글쓰기</a></li>
										<li>
									</c:if>
								</ul>
							</div>
						</div>
					</div>
				</c:if>
			</div>
		</nav>
		<div id="pho">
			<c:if test="${fn : contains(URL, 'main')}">
				<c:set var="hidden" value="hidden" />
			</c:if>
			<div class="serviceHide header-placeholder ${hidden} plh">
				<div class="header-placeholder-bg plh ${hidden}"></div>
			</div>

		</div>
	</div>
</header>
<!-- header 끝 -->


<!-- 퀵메뉴 메인이 아닐 시 보여짐 -->
<c:if test="${!fn : contains(URL, 'main') and !fn : contains(URL, 'admin') and !fn : contains(URL, 'accident') and !fn : contains(URL, 'buy/list')}">
<div id="qMenu">
	<input type="checkbox" id="menuicon" onclick="qClick();"  >
<ul class="menuicon" <c:if test="${fn : contains(URL, 'service') || fn : contains(URL, 'qna')}">style="top:183!important;"</c:if> >
	<li>
		<label for="menuicon" >
			<span></span><span></span><span></span>
		</label>
	</li>
</ul>
<div class="sidebar">
	<div class="quick-menu" style="z-index: 1000 !important; right:-92px;">
		<ul>
			<li class="menu1"><a href="/rent/main.do">단기예약</a></li>
			<li class="menu2"><a href="/rent/rentList">중고차 렌터카</a></li>
			<li class="menu3"><a href="/rent/NewRentList">다이렉트견적</a></li>
			<li class="menu6"><a href="/serviceCenter/customerConsultation">상담신청</a>
			</li>
		</ul>
	</div>
</div>
</div>
</c:if>


<c:if test="${!fn : contains(URL, 'main.do')}"> <style>body {margin-top: 100 !important;}</style> </c:if>
<c:if test="${URL.substring(36) == 'main.jsp'}"> <style>.awaw{color:white !important;}</style></c:if>

<c:if test="${fn : contains(URL, 'main.do')}"> <style>
		header a img {margin-top: -20px !important;}
		a:hover {text-decoration: none;}
		header a {color: white !important;}
		#menuHeader11, #menuHeader12 {
			background-color: transparent;
			a: hover {text-decoration: none;}
		}
</style> </c:if>
		
		
<!-- 메인 헤더 CSS -->
<c:if test="${fn : contains(URL, 'main')}">
<script type="text/javascript">
$('.awaw').hover(function() {
	$('#menuHeader11').css('background-color','white');
	$('#menuHeader12').css('background-color','white');
	$('.plh').removeClass('hidden');
	$('.awaw').attr('style','color:black !important; text-decoration: none;' )
	$('.aa1').attr('style','color:black !important; left: auto; right: 50px; text-decoration: none;')
	$('.aa2').attr('style','color:black !important; left: 40px; width: 100px; text-decoration: none;') 
});
$('.aa1').hover(function() {$('.aa1').attr('style','color:#eb444b !important; left: auto; right: 50px; text-decoration: none;')});
$('.aa2').hover(function() {$('.aa2').attr('style','color:#f68121 !important; left: 40px; width: 100px; text-decoration: none;')});
	
$('#menuHeader11').hover(function() {}, function(){
	$('#menuHeader11').css('background-color','transparent');
	$('#menuHeader12').css('background-color','transparent');
	$('#menuHeader12').css('background-color','transparent');
	$('.plh').addClass('hidden');
	$('.awaw').attr('style','color:white !important text-decoration: none;')
	$('.aa1').attr('style','color:white !important; left: auto; right: 50px; text-decoration: none;')
	$('.aa2').attr('style','color:white !important; left: 40px; width: 100px; text-decoration: none;')
});

</script>
</c:if>
<script type="text/javascript">
//퀵메뉴 호버
$('#qMenu').hover(function() {
	$('#menuicon').prop('checked', true);
	$('.menuicon').animate({right: '52px'}, 500, 'swing');
	$('.quick-menu').animate({right: '0px'}, 500, 'swing');
	}, function(){
		$('.menuicon').animate({right: '-50px'}, 500, 'swing');
		$('.quick-menu').animate({right: '-100px'}, 500, 'swing');
		$('#menuicon').prop('checked', false);
});

//클릭시 체크가 없을 경우
function qClick(){
	if(!$("input:checkbox[id='menuicon']").is(":checked"))
		$('.menuicon').animate({right: '-50px'}, 500, 'swing');
		$('.quick-menu').animate({right: '-100px'}, 500, 'swing');
		$('#menuicon').prop('checked', false);
}
</script>
