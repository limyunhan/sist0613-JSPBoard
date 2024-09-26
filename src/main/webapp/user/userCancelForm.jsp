<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.web.dao.UserDao" %>

<%
Logger logger = LogManager.getLogger("userCancelForm.jsp");
HttpUtil.requestLogString(request, logger);

User user = null;
String cookieUserId = CookieUtil.getValue(request, "USER_ID");

if (!StringUtil.isEmpty(cookieUserId)) {
    UserDao userDao = new UserDao();
    user = userDao.userSelect(cookieUserId);

    if (user == null || !StringUtil.equals(user.getUserStatus(), "Y")) {
        CookieUtil.deleteCookie(request, response, "/", "USER_ID");
        response.sendRedirect("/");
    }
} else {
    response.sendRedirect("/");
}
if (user != null) {
%>
	<!DOCTYPE html>
	<html>
	<head>
	<%@ include file="/include/header.jsp"%>
	<script>
		$(document).ready(function() {
		    $("#userPwd2").on("input", function() {
			    if ($("#userPwd1").val() !== $("#userPwd2").val()) {
			    	$(".pwdText2").text("비밀번호가 일치하지 않습니다.").css("color", "red");
				   
			    } else if ($.trim($("#userPwd1").val()).length !== 0) {
			    	$(".pwdText2").text("비밀번호가 일치합니다.").css("color", "blue");	
			    }
			});
		    
		    $("#btnCancel").on("click",function() {
		    	if($(".pwdText2").text() === "비밀번호가 일치합니다." && $.trim($("#userPwd1").val()).length !== 0) {
			    	var isPwdValid = false;
			    	var errorMsg = "";
			    	  	
					$.ajax({
						type: "POST",
			        	url: "/user/userPwdCheckAjax.jsp",
			        	data: {
			        	    userPwd: $("#userPwd1").val() 
			            },
			            dataType: "JSON", 
			            success: function(obj) {
			        	    if (obj.flag === 1) {
			             	  isPwdValid = true;
			        	    } else if (obj.flag === 0) {
			                    errorMsg = "입력하신 비밀번호가 정확하지 않습니다.";
			                } else if (obj.flag === -1) {
			            	    errorMsg = "유저를 찾을 수 없습니다. 관리자에 문의하여 주세요.";
			                } else {
								errorMsg = "알 수 없는 응답(파싱 실패)입니다. 관리자에 문의하여 주세요.";
			                }
			            },
			            error: function(xhr, status, error) {
			            	alert("서버 응답 오류 또는 네트워크 오류가 발생했습니다. 관리자에 문의하여 주세요.");
			            }
			    	});
			    	
			    	if (isPwdValid) {
				    	Swal.fire({
				    		title: errorMsg,
				    		icon: "warning",
					        showCancelButton: true,
					        showConfirmButton: false,
					        cancelButtonColor: "#3085d6",
					        cancelButtonText: "확인"
				    	});
				   
				
			    	} else {
			    		$("#userPwd").val($("#userPwd1").val());
						Swal.fire({
							title: "정말로 탈퇴하시겠습니까?",
							icon: "warning",
							showCancelButton: true, 
							cancelButtonColor: "#3f51b5",
							confirmButtonColor: "#3085d6", 
							confirmButtonText: "확인", 
							cancelButtonText: "취소", 
							reverseButtons: true, 
						}).then(result => {
							if (result.isConfirmed) { 
								document.cancelForm.submit();
							}
						});
			    	}
		    	} else {
					Swal.fire({
				    	title: "비밀번호를 입력해주세요.",
				    	icon: "warning",
				        showCancelButton: true,
				        showConfirmButton: false,
				        cancelButtonColor: "#3085d6",
				        cancelButtonText: "확인"
				    });
		    	}
			});
		});
	</script>
	</head>
	<body>
	<%@ include file="/include/navigation.jsp"%>
	<div class="container" style="max-width: 600px; background-color: #e8eaf6; border-radius: 10px; padding: 20px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);">
	    <div class="row mt-5">
	        <h1 class="text-center text-nowrap">회원탈퇴</h1>
	    </div>
	    <div class="row mt-4">
	        <div class="col-12">
	            <form name="cancelForm" method="post" action="/user/userCancelProc.jsp">
	                <div class="form-group mb-3 mt-5">
	                    <label for="userPwd1" class="form-label">비밀번호</label>
	                    <input type="password" class="form-control" id="userPwd1" name="userPwd1" placeholder="비밀번호" maxlength="12" required style="flex: 1;">
	                </div>
	                <div class="form-group mb-3 mt-5">
	                    <label for="userPwd2" class="form-label">비밀번호 확인</label>
	                    <input type="password" class="form-control" id="userPwd2" name="userPwd2" placeholder="비밀번호 확인" maxlength="12" required style="flex: 1;">
	                   <span class="pwdText2"></span>
	                </div>
	                <div class="d-flex justify-content-end mt-4">
	                    <button type="button" id="btnCancel" class="btn btn-outline-primary" style="background-color: #3f51b5;">탈퇴</button>
	                </div>
	                <input type="hidden" id="userPwd" name="userPwd" value="">
	            </form>
	        </div>
	    </div>
	</div>
	<%@ include file="/include/footer.jsp" %>
	</body>
	</html>
<%
}
%>