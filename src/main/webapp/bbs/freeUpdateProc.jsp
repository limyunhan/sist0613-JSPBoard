<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.FreeBbsDao" %>
<%@ page import="com.sist.web.model.FreeBbs" %>
    
<%
Logger logger = LogManager.getLogger("freeUpdateProc.jsp");
HttpUtil.requestLogString(request, logger);

String cookieUserId = CookieUtil.getValue(request, "USER_ID");
String searchType = HttpUtil.get(request, "searchType", "");
String searchValue = HttpUtil.get(request, "searchValue", "");
String freeBbsTitle = HttpUtil.get(request, "freeBbsTitle", "");
String freeBbsContent = HttpUtil.get(request, "freeBbsContent", "");
long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", -1L);
long curPage = HttpUtil.get(request, "curPage", 1L);

String msg;
String icon = "warning";
String redirectUrl = "/bbs/freeList.jsp";

if(freeBbsSeq > 0 && !StringUtil.isEmpty(freeBbsTitle) && !StringUtil.isEmpty(freeBbsContent)) {
	FreeBbsDao freeBbsDao = new FreeBbsDao();
	FreeBbs freeBbs = freeBbsDao.freeBbsSelect(freeBbsSeq);
	if(freeBbs != null && StringUtil.equals(freeBbs.getFreeBbsStatus(), "Y")) {
		if(StringUtil.equals(cookieUserId, freeBbs.getUserId())) {
			freeBbs.setFreeBbsTitle(freeBbsTitle);
			freeBbs.setFreeBbsContent(freeBbsContent);
			if(freeBbsDao.freeBbsUpdate(freeBbs)) {
				msg = "게시글을 성공적으로 수정하였습니다.";
				icon = "success";
				redirectUrl = "/bbs/freeView.jsp";
			} else {
				msg = "게시글 수정 중 오류가 발생하였습니다.";
				icon = "error";
			}
		} else {
			msg = "사용자 정보가 일치하지 않습니다.";
		}
	} else {
		msg = "존재하지 않는 게시글입니다.";
	}
} else {
	msg = "비정상적인 접근입니다."; 
}
%>    
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp" %>
</head>
<script>
	$(document).ready(function(){
		Swal.fire({
			title: "<%= msg %>",
			icon: "<%= icon %>",
			confirmButtonColor: "#3085d6",
			confirmButtonText: "확인",
			}).then(result => {
			if (result.isConfirmed) {   
				document.bbsForm.action = "<%= redirectUrl %>";
				document.bbsForm.submit();
			}
		});
	});
</script>
<body>
<form name="bbsForm" id="bbsForm" method="post" action="">
	<input type="hidden" name="freeBbsSeq" value="<%=freeBbsSeq%>">
	<input type="hidden" name="curPage" value="<%=curPage%>">
	<input type="hidden" name="searchType" value="<%=searchType%>">
	<input type="hidden" name="searchValue" value="<%=searchValue%>">
</form>
</body>
</html>