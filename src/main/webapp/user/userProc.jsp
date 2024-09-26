<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
Logger logger = LogManager.getLogger("userProc.jsp");
HttpUtil.requestLogString(request, logger);

String userId = HttpUtil.get(request, "userId");
String userPwd = HttpUtil.get(request, "userPwd");
String userName = HttpUtil.get(request, "userName");
String userEmail = HttpUtil.get(request, "userEmail");
String userBirthDay = HttpUtil.get(request, "userBirthDay").replace("-", "");
String cookieUserId = CookieUtil.getValue(request, "USER_ID");

String msg;
String redirectUrl = "/user/userRegForm.jsp"; 
String icon = "warning"; 

UserDao userDao = new UserDao();

if (StringUtil.isEmpty(cookieUserId)) {
    // 회원가입 처리
    if (StringUtil.isEmpty(userId) || StringUtil.isEmpty(userPwd) || 
        StringUtil.isEmpty(userName) || StringUtil.isEmpty(userEmail) || 
        StringUtil.isEmpty(userBirthDay)) {
        msg = "비정상적인 접근입니다.";
    } else {
        User user = new User();		
        user.setUserId(userId);
        user.setUserPwd(userPwd);
        user.setUserName(userName);
        user.setUserEmail(userEmail);
        user.setUserBirthday(userBirthDay);

        if (userDao.userInsert(user)) {
            msg = "회원가입이 완료되었습니다.";
            redirectUrl = "/index.jsp";
            icon = "success";
        } else {
            msg = "회원가입 중 오류가 발생하였습니다.";
        }
    }
} else { 
    // 사용자 정보 수정 처리
    User user = userDao.userSelect(cookieUserId);
    
    if (user == null) {
        CookieUtil.deleteCookie(request, response, "/", "USER_ID");
        msg = "올바른 사용자가 아닙니다.";
        redirectUrl = "/";
    } else if (!StringUtil.equals(user.getUserStatus(), "Y") || 
               !StringUtil.equals(user.getUserId(), userId)) {
        CookieUtil.deleteCookie(request, response, "/", "USER_ID");
        msg = "정지된 사용자 입니다.";
        redirectUrl = "/";
    } else {
        if (StringUtil.isEmpty(userId) || StringUtil.isEmpty(userPwd) || 
            StringUtil.isEmpty(userName) || StringUtil.isEmpty(userEmail) || 
            StringUtil.isEmpty(userBirthDay)) {
            msg = "비정상적인 접근입니다.";
        } else {
            user.setUserId(userId);
            user.setUserPwd(userPwd);
            user.setUserName(userName);
            user.setUserEmail(userEmail);
            user.setUserBirthday(userBirthDay);

            if (userDao.userUpdate(user)) {
                msg = "회원정보가 수정 되었습니다.";
                icon = "success";
            } else {
                msg = "회원정보 수정 중 오류가 발생하였습니다.";
                icon = "error";
            }
        }
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