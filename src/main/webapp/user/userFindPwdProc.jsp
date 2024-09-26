<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
Logger logger = LogManager.getLogger("userFindPwdProc.jsp");
HttpUtil.requestLogString(request, logger);

String userId = HttpUtil.get(request, "userId");
String userName = HttpUtil.get(request, "userName");
String userEmail = HttpUtil.get(request, "userEmail");

User user = null;
String msg;
String redirectUrl = "/user/userFindPwd.jsp";
boolean isFound = false;

if (StringUtil.isEmpty(userId) || StringUtil.isEmpty(userName) || StringUtil.isEmpty(userEmail)) {
    msg = "비정상적인 접근입니다.";
} else {
	UserDao userDao = new UserDao();
    user = userDao.userPwdSearch(userName, userEmail, userId);
    
    if (user != null) {
        if (user.getUserStatus().equals("Y")) {
            msg = "비밀번호를 찾았습니다.";
            isFound = true;
            session.setAttribute("openLoginModal", "1");
        } else {
            msg = "탈퇴한 사용자입니다.";
        }
        redirectUrl = "/";
    } else {
        msg = "아이디, 이름, 이메일이 일치하는 비밀번호가 없습니다.";
    }
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
    			<% if(isFound) { %>
    			text: "비밀번호 : <%= user.getUserPwd()%>",
    			<% } %>
                icon: "<%=redirectUrl.equals("/") ? "success" : "warning"%>",
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