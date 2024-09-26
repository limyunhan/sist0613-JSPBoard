<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@   page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
Logger logger = LogManager.getLogger("userCancelProc.jsp");
HttpUtil.requestLogString(request, logger);

String userPwd = HttpUtil.get(request, "userPwd");
String cookieUserId = CookieUtil.getValue(request, "USER_ID");

String msg;
String redirectUrl;
String icon="warning";

if (!StringUtil.isEmpty(cookieUserId)) {
	if(!StringUtil.isEmpty(userPwd)) {
		UserDao userDao = new UserDao();
		User user = userDao.userSelect(cookieUserId);
		if(user != null) {
			if(StringUtil.equals(user.getUserPwd(), userPwd)) {
				if(userDao.userCancel(user.getUserId())) {
					CookieUtil.deleteCookie(request, response, "/", "USER_ID");
					msg = "회원 탈퇴가 완료되었습니다.";
					redirectUrl = "/";
					icon = "success";
				} else {
					msg = "회원 탈퇴중 오류가 발생하였습니다.";
					redirectUrl = "/user/userCancelForm.jsp";
					icon = "error";
				}
			} else {
				msg = "비밀번호가 일치하지 않습니다.";
				redirectUrl = "/user/userCancelForm.jsp";
			}
		} else {
			CookieUtil.deleteCookie(request, response, "/", "USER_ID");
			msg = "비정상적인 로그인 정보입니다.";
			redirectUrl = "/";
		}
	} else {
		msg = "비정상적인 접근입니다.";
		redirectUrl = "/user/userCancelForm.jsp";
	}
} else {
	msg = "비로그인 사용자입니다.";
	redirectUrl = "/";
}
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp"%>
<script>
	$(document).ready(function(){
	    Swal.fire({
	        title: "<%=msg%>",
	        icon: "<%=icon%>",
	        confirmButtonColor: "#3085d6",
	        confirmButtonText: "확인",
	    }).then(result => {
	        if (result.isConfirmed) {        
	            location.href = "<%=redirectUrl%>";
	        }
	    });
	});
</script>
</head>
<body>
</body>
</html>