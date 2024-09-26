<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.UserDao"%>
<%@ page import="com.sist.web.model.User"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%
Logger logger = LogManager.getLogger("userPwdCheckAjax.jsp");
HttpUtil.requestLogString(request, logger);

String cookieUserId = CookieUtil.getValue(request, "USER_ID");
String userPwd = HttpUtil.get(request, "userPwd");

if (!StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(cookieUserId)) {
	UserDao userDao = new UserDao();
	User user = userDao.userSelect(cookieUserId);
	
	if(user != null) {
		if(StringUtil.equals(user.getUserPwd(), userPwd)) {
			response.getWriter().write("{\"flag\":1}");
		}
		else {
			response.getWriter().write("{\"flag\":0}");
		} 
	} else {
		response.getWriter().write("{\"flag\":-1}");
	}
} else {
	response.getWriter().write("{\"flag\":-1}");
}
%>