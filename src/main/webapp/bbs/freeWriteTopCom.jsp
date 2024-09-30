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

String cookieUserId = CookieUtil.getValue(request, "USER_ID");
long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", -1L);
String searchType = HttpUtil.get(request, "searchType", "");
String searchValue = HttpUtil.get(request, "searchValue", "");
long curPage = HttpUtil.get(request, "curPage", 1L);
long curComPage = HttpUtil.get(request, "curComPage", 1L);
String freeBbsComContent = HttpUtil.get(request, "freeBbsComContent", "");

String msg = "";
String icon = "";
boolean flag = true;

if (freeBbsSeq > 0 && !StringUtil.isEmpty(freeBbsComContent)) {
	FreeBbsComDao freeBbsComDao = new FreeBbsComDao();
	FreeBbsCom freeBbsCom = new FreeBbsCom();
	
	freeBbsCom.setFreeBbsSeq(freeBbsSeq);
	freeBbsCom.setUserId(cookieUserId);
	freeBbsCom.setFreeBbsComContent(freeBbsComContent);
	
	if (freeBbsComDao.topFreeBbsComInsert(freeBbsCom)) {
		flag = false;
	} else {
		msg = "DB 작업중 오류가 발생하였습니다.";
		icon = "error";
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
	                document.bbsForm.submit();
	            }
	        });
<%
		}
%>
		document.bbsForm.submit();
    });
</script>
</head>
<body>
<form name="bbsForm" action="/bbs/freeView.jsp" method="post">
	<input type="hidden" name="freeBbsSeq" id="freeBbsSeq" value="<%= freeBbsSeq %>">
	<input type="hidden" name="searchType" id="searchType" value="<%= searchType %>">
	<input type="hidden" name="searchValue" id="searchValue" value="<%= searchValue %>">
	<input type="hidden" name="curPage" id="curPage" value="<%= curPage%>">
	<input type="hidden" name="curComPage" id="curComPage" value="<%= curComPage %>">
	<input type="hidden" name="freeBbsComContent" id="freeBbsComContent" value="<%= freeBbsComContent %>">
</form>
</body>
</html>