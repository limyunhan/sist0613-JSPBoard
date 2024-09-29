<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.FreeBbsDao"%>
<%@ page import="com.sist.web.model.FreeBbs"%>
<%
Logger logger = LogManager.getLogger("freeDelete.jsp");
HttpUtil.requestLogString(request, logger);

String cookieUserId = CookieUtil.getValue(request, "USER_ID");
long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", -1L);
String msg;
String icon = "warning";

if (freeBbsSeq > 0) {
	FreeBbsDao freeBbsDao = new FreeBbsDao();
	FreeBbs freeBbs = freeBbsDao.freeBbsSelect(freeBbsSeq);
	if (freeBbs != null && StringUtil.equals(freeBbs.getFreeBbsStatus(), "Y")) {
		if(StringUtil.equals(cookieUserId, freeBbs.getUserId())) {
			if(freeBbsDao.freeBbsDelete(freeBbsSeq)) {
				msg = "게시글을 성공적으로 삭제했습니다.";
				icon = "success";
			} else {
				msg = "게시글 삭제 중 오류가 발생하였습니다.";
				icon = "error";
			}
		} else {
			msg = "로그인한 사용자의 게시글이 아닙니다.";
		}
	} else {
		msg = "게시글이 존재하지 않습니다."; 
	}
} else {
	msg = "비정상적인 접근입니다.";
}

%>

<html>
<head>
<%@ include file="/include/header.jsp" %>
</head>
<script>
	$(document).ready(function() {
		Swal.fire({
			title: "<%=msg%>",
			icon: "<%=icon%>",
			confirmButtonColor: "#3085d6",
			confirmButtonText: "확인",
		}).then(result => {
			if(result.isConfirmed) {
				location.href = "/bbs/freeList.jsp";
			}
		});
	});
</script>
<body>
</body>
</html>