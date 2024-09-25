<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@   page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
   Logger logger = LogManager.getLogger("findProd_2.jsp");
   
   String userId = HttpUtil.get(request, "userId");
   String userName = HttpUtil.get(request, "userName");
   String userBirthDay = HttpUtil.get(request, "userBirthDay");
   
   String msg = "";
   String redirectUrl = "/user/userFindPw.jsp";
   
   User user = null;
   UserDao userDao = new UserDao();
   
  // user = userDao.userIdFind(userName, userBirthDay);
   
   logger.debug("userId : " + userId);
   logger.debug("userName : " + userName);
   logger.debug("userBirthDay : " + userBirthDay);
   if(!userId.trim().isEmpty())
   {
      //user = userDao.userPwFind(userId, userName, userBirthDay);
      if(user != null)
      {
         //if(user.getStatus().equals("Y"))
         {   
            msg = "비밀번호를 찾았습니다. 비밀번호 : " + user.getUserPwd();
            redirectUrl = "/user/userFindPw.jsp";
         }
        // else
         {
            msg = "정지된 사용자 입니다.";
            redirectUrl = "/user/userFindPw.jsp";
         }
      }
      else
      {
         msg = "아이디,이름,이메일이 일치하는 비밀번호가 없습니다.";
         redirectUrl = "/user/userFindPw.jsp";
      }
      
   }
%>
   
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
   
alert("<%=msg%>");
location.href = "<%=redirectUrl%>";

</script>
</head>
<body>
</body>
</html>