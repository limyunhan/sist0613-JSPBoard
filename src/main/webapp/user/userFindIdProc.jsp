<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
Logger logger = LogManager.getLogger("userFindIdProc.jsp");
HttpUtil.requestLogString(request, logger);

String userName = HttpUtil.get(request, "userName");
String userEmail = HttpUtil.get(request, "userEmail");

String msg = "";
String redirectUrl = "/user/userFindId.jsp";

UserDao userDao = new UserDao();
String userId = null;

if (StringUtil.isEmpty(userName) || StringUtil.isEmpty(userEmail)) {
    msg = "비정상적인 접근입니다.";
} else {
    userId = userDao.userIdSearch(userName, userEmail);

    if (userId != null) {
        User user = userDao.userSelect(userId);
        if (user != null) {
            if (user.getUserStatus().equals("Y")) {
                msg = "아이디를 찾았습니다. 아이디 : " + user.getUserId();
                redirectUrl = "/";
            } else {
                msg = "탈퇴한 사용자입니다.";
            }
        } else {
            msg = "DB에서 문제가 발생하였습니다.";
        }
    } else {
        msg = "이름, 이메일이 일치하는 아이디가 없습니다.";
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
            icon: "<%=redirectUrl.equals("index.jsp") ? "success" : "warning"%>",
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