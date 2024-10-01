<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.FreeBbsComDao" %>
<%@ page import="com.sist.web.model.FreeBbsCom" %>
<%
Logger logger = LogManager.getLogger("freeWriteTopCom.jsp");
HttpUtil.requestLogString(request, logger);

long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", -1L);
String searchType = HttpUtil.get(request, "searchType", "");
String searchValue = HttpUtil.get(request, "searchValue", "");
long curPage = HttpUtil.get(request, "curPage", 1L);
long curComPage = HttpUtil.get(request, "curComPage", 1L);
long freeBbsComSeq = HttpUtil.get(request, "freeBbsComSeq", -1L);
	
String msg = "";
String icon = "";
boolean flag = true;

session.setAttribute("previousPage", request.getRequestURI());

if (freeBbsComSeq > 0 && freeBbsSeq > 0) {
	FreeBbsComDao freeBbsComDao = new FreeBbsComDao();
	FreeBbsCom freeBbsCom = freeBbsComDao.freeBbsComSelect(freeBbsComSeq);
	if (freeBbsCom != null) {
		if (freeBbsComDao.deleteFreeBbsCom(freeBbsComSeq)) {
			flag = false;
		} else {
			msg = "DB 작업중 오류가 발생하였습니다.";
			icon = "error";
		}
	} else {
		msg = "존재하지 않는 댓글입니다.";
		icon = "warning";
	}
} else {
	msg = "비정상적인 접근입니다.";
	icon = "warning";
}
%>
<!DOCTYPE html>
<html>
<head> 
<%@ include file="/include/header.jsp"%>
<script>
	$(document).ready(function(){
<%
		if(flag) {
%>
			Swal.fire({
				title: "<%=msg%>",
				icon: "<%=icon%>",
				confirmButtonColor: "#3085d6",
	            confirmButtonText: "확인",
	        }).then(result => {
	            if (result.isConfirmed) {        
	                document.bbsForm.submit();  // 확인 버튼을 누른 후에만 제출
	            }
	        });
<%
		} else {
%>
			document.bbsForm.submit();  // 경고창이 필요 없을 때는 바로 제출
<%
		}
%>
	});
</script>
</head>
<body>
<form name="bbsForm" action="/bbs/freeView.jsp" method="post">
	<input type="hidden" name="freeBbsSeq" id="freeBbsSeq" value="<%= freeBbsSeq %>">
	<input type="hidden" name="freeBbsComSeq" id="freeBbsComSeq" value="<%= freeBbsComSeq %>">
	<input type="hidden" name="searchType" id="searchType" value="<%= searchType %>">
	<input type="hidden" name="searchValue" id="searchValue" value="<%= searchValue %>">
	<input type="hidden" name="curPage" id="curPage" value="<%= curPage%>">
	<input type="hidden" name="curComPage" id="curComPage" value="<%= curComPage %>">
</form>
</body>
</html>