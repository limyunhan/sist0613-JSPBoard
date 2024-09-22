<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="org.apache.logging.log4j.LogManager"%>   
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>

<%
   Logger logger = LogManager.getLogger("userUpdateForm.jsp");
   HttpUtil.requestLogString(request, logger);
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp" %>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>

<div class="container">
    <div class="row mt-5">
       <h1>회원정보수정</h1>
    </div>
    <div class="row mt-2">
        <div class="col-12">
         <form name="updateForm" id="updataForm" action="/user/userProc.jsp" method="post">
                <div class="form-group fs-4">
                    <label for="username">사용자 아이디</label>
                   <!-- 쿠키아이디나 유저아이디 둘다 사용가능 -->
                </div>
                <br />
                <div class="form-group">
                    <label for="username">비밀번호</label>
                    <input type="password" class="form-control" id="userPwd1" name="userPwd1" value="비번이지롱" placeholder="비밀번호" maxlength="12" />
                </div>
                <br />
                <div class="form-group">
                    <label for="username">비밀번호 확인</label>
                    <input type="password" class="form-control" id="userPwd2" name="userPwd2" value="비번을 한번더!" placeholder="비밀번호 확인" maxlength="12" />
                </div>
                <br />
                <div class="form-group">
                    <label for="username">사용자 이름</label>
                    <input type="text" class="form-control" id="userName" name="userName" value="너의 이름은" placeholder="사용자 이름" maxlength="15" />
                </div>
                <br />
                <div class="form-group">
                    <label for="username">사용자 이메일</label>
                    <input type="text" class="form-control" id="userEmail" name="userEmail" value="이메일" placeholder="사용자 이메일" maxlength="30" />
                </div>
                <input type="hidden" id="userId" name="userId" value="히든아이디" />
            <input type="hidden" id="userPwd" name="userPwd" value="히든비밀번호" />
            <div class="d-flex justify-content-end mt-4">
                <button type="button" id="btnUpdate" class="btn btn-outline-primary" style="background-color: #3f51b5;">수정</button>
                </div>
         </form>
        </div>
    </div>
</div>
<%@ include file="/include/footer.jsp" %>
</body>
</html>