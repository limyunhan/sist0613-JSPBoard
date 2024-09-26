<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.model.FreeBbs" %>
<%@ page import="com.sist.web.dao.FreeBbsDao" %>
<%
Logger logger = LogManager.getLogger("freeWriteProc.jsp");
HttpUtil.requestLogString(request, logger);	

String cookieUserId = CookieUtil.getValue(request, "USER_ID");
String freeBbsTitle = HttpUtil.get(request, "freeBbsTitle");
String freeBbsContent = HttpUtil.get(request, "freeBbsContent");

String msg;
String icon;
String redirectUrl = "/bbs/freeWrite.jsp";

if(!StringUtil.isEmpty(freeBbsTitle) && !StringUtil.isEmpty(freeBbsContent)) {
	FreeBbsDao freeBbsDao = new FreeBbsDao();
	FreeBbs freeBbs = new FreeBbs(); // id, title, content만 세팅해서 Insert하면 된다.
	
	freeBbs.setUserId(cookieUserId); // 필터에서 검증되기 때문에 그대로 사용해도 무방
	freeBbs.setFreeBbsTitle(freeBbsTitle);
	freeBbs.setFreeBbsContent(freeBbsContent);
	
	if(freeBbsDao.freeBbsInsert(freeBbs)) {
		msg = "게시글을 성공적으로 작성하였습니다.";
		icon = "success";
		redirectUrl = "/bbs/freeList.jsp";
	} else {
		msg = "게시글 작성에 실패하였습니다.";
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
<%@ include file="/include/header.jsp" %>
</head>
<body>
<script>
	$(document).ready(function() {
		Swal.fire({
			title: "<%=msg%>",
			icon: "<%=icon%>",
			confirmButtonColor: "#3085d6",
			confirmButtonText: "확인",
		}).then(result => {
			if(result.isConfirmed) {
				location.href = "<%=redirectUrl%>";
			}
		});
	});
</script>
</body>
</html>