<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="nowDate" />

<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="layoutTag" tagdir="/WEB-INF/tags" %>
<layoutTag:layout>
<!DOCTYPE html>
<html>
<head>
<style>.list{ height: 50px;}</style>
<meta charset="UTF-8">
<title>공지사항 작성 페이지</title>
<%@ include file="serviceHeader.jsp" %>
<link href="http://localhost:8082/static/css/ss.css" rel="stylesheet" type="text/css" >
</head>
<body>

<div id="content">
    <div id="container">
        <div class="breadcrumbs">
            <h2 class="tit">공지사항</h2>
            <div class="clearfix">
                <span>홈</span>
                <span>고객센터</span>
                <span class="cl-bold">공지사항</span>
            </div>
        </div>
        <!-- breadcrumbs//end -->
        <div class="view-type v2">
            <div class="view-header">
                <h4><span class="cl-point1">[${list.a.division}]</span> ${list.a.subject} </h4>
                <span class="time">${list.a.reg_date}</span>
            </div>
            
            <div class="view-content"> ${list.a.content} </div>
            
            <div class="view-paging">
            
	                <div class="list" style="height:50px;">
            <c:if test="${list.b != null}">
	                    <a href="/serviceCenter/noticeDetail/${list.b.no}?number=${list.number}&moVal=${list.moVal}&moKind=${list.moKind}">
	                        <span class="prev">이전글</span>
	                        <span class="link">		${list.b.subject}</span>
	                        <span class="time fr">  ${list.b.reg_date}</span>
                        </a>
             </c:if>
            <c:if test="${list.b == null}">
	                    <a href="#" >
	                        <span class="prev">이전글</span>
	                        <span class="link">		이전글이 존재하지 않습니다.</span>
	                    </a>
             </c:if>
	                </div>
                
                
                
	                <div class="list clearfix"  style="height:50px;">
            <c:if test="${list.c != null}">
	                    <a href="/serviceCenter/noticeDetail/${list.c.no}?number=${list.number}&number=${list.number}&moVal=${list.moVal}&moKind=${list.moKind}">
	                        <span class="next">다음글</span>
	                        <span class="link">		${list.c.subject}</span>
	                        <span class="time fr">  ${list.c.reg_date}</span>
                        </a>
            </c:if>
            <c:if test="${list.c == null}">
                    	<a href="#">
	                        <span class="next">다음글</span>
	                        <span class="link">		다음글이 존재하지 않습니다.</span>
	                    </a>
            </c:if>
	                </div>
                
            </div>
            
            
            
        </div>
        
        <div class="btn-box text-c">
        	<c:if test="${sessionScope.id eq 'master'}">
        		<a href="${path}/serviceCenter/noticeUpdateForm?no=${list.a.no}" class="btn btn-danger btn-fix3 btn-large">수정</a>
        		<a href="${path}/serviceCenter/noticeDelete?no=${list.a.no}" class="btn btn-danger btn-fix3 btn-large">삭제</a>
        	</c:if>
            <a href="${path}/serviceCenter?number=${list.number}&moVal=${list.moVal}&moKind=${list.moKind}" style="font-size:18px; height:50px; background-color: #444444; color:white;" class="btn btn-fix3 btn-l	arge">목록</a>
        </div>
        <!-- btn-box//end -->
        
    </div>
    <!-- container//end -->
</div>



</body>
</html>
</layoutTag:layout>