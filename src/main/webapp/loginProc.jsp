<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@   page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>


<%
   Logger logger = LogManager.getLogger("loginProc.jsp");

   //String userId = request.getParameter("userId");
   //String userPwd = request.getParameter("userPwd");
   String userId = HttpUtil.get(request,"userId");
   String userPwd = HttpUtil.get(request,"userPwd");
   
   String msg = "";
   String redirectUrl= "";
   
   User user = null;
   UserDao userDao = new UserDao();
   
   logger.debug("userId : " + userId); 
   logger.debug("userPwd : " + userPwd);
   
   //if(userId != null && !userId.equals("") && userPwd != null 
   //                                 && userPwd.equals(""))
   if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))    
   {
   
      user = userDao.userSelect(userId);
      
      if(user != null)
      {
         //비밀번호 체크
         //if(userPwd.equals(user.getUserPwd()))
         if(StringUtil.equals(userPwd, user.getUserPwd()))            
         {
            if(user.getUserStatus().equals("Y"))
            {   
               // 쿠키적용
               CookieUtil.addCookie(response, "/", "USER_ID", userId);
               
               msg = "로그인 성공";
               redirectUrl = "/";
            }
            else
            {
               msg = "정지된 사용자 입니다.";
               redirectUrl = "/";
            }
         }
         else
         {
            msg = "비밀번호가 일치하지 않습니다.";
            redirectUrl = "/";
         }
      }
      else
      {
         msg = "아이디가 존재하지 않습니다.";
         redirectUrl = "/";
      }
   }
   else
   {
      // 아이디나 비밀번호가 입력되지 않은 경우
      msg = "아이디나 비밀번호가 입력되지 않았습니다.";
      redirectUrl = "/";
   }
   
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<script>
   alert("<%=msg%>");
   location.href = "<%=redirectUrl%>";
</script>
</body>
</html>