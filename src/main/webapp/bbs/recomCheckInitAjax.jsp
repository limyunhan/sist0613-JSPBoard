<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.dao.FreeBbsRecomDao"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%
Logger logger = LogManager.getLogger("recomCheckAjax.jsp");
HttpUtil.requestLogString(request, logger);

String userId = HttpUtil.get(request, "userId");
long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", -1L);
FreeBbsRecomDao freeBbsRecomDao = new FreeBbsRecomDao();

boolean flag = freeBbsRecomDao.isValid(userId, freeBbsSeq);

// JSON 응답 생성
StringBuilder jsonResponse = new StringBuilder();
jsonResponse.append("{\"flag\": ").append(flag).append("}");

response.getWriter().write(jsonResponse.toString());
%>