<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@   page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
Logger logger = LogManager.getLogger("loginProc.jsp");
HttpUtil.requestLogString(request, logger);

String userId = HttpUtil.get(request, "userId");
String userPwd = HttpUtil.get(request, "userPwd");

String msg;
String icon = "warning";
String redirectUrl = "/";
String previousUrl = (String)session.getAttribute("previousUrl");
session.removeAttribute("previousUrl");

if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)) {
	UserDao userDao = new UserDao();
	User user = userDao.userSelect(userId);
	if (user != null) {
		if (StringUtil.equals(userPwd, user.getUserPwd())) {
			if (user.getUserStatus().equals("Y")) {
				CookieUtil.addCookie(response, "/", "USER_ID", userId);
				msg = "로그인 성공";
				icon = "success";
				redirectUrl = !StringUtil.isEmpty(previousUrl) ? previousUrl : "/";
			} else {
				msg = "탈퇴한 사용자입니다.";
				session.setAttribute("openLoginModal", "1");
			}
		} else {
			msg = "아이디 또는 비밀번호가 일치하지 않습니다.";
			session.setAttribute("openLoginModal", "1");
		}
	} else {
		msg = "아이디 또는 비밀번호가 일치하지 않습니다.";
		session.setAttribute("openLoginModal", "1");
	}
} else {
	msg = "비정상적인 접근입니다.";
	session.setAttribute("openLoginModal", "1");
}
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp" %>
</head>
<body>
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
</body>
</html>