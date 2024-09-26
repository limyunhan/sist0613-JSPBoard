<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp"%>
<script>
	$(document).ready(function() {
		$("#userId").focus();
	    var idPwdCheck = /^[a-zA-Z0-9]{4,12}$/;
	    var emptyCheck = /\s/g;          
	    var emailCheck = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	   
	    $("#userId").on("input", function() {
	    	var userId = $.trim($("#userId").val());
	    	
		    if (userId.length === 0) {
		    	$(".idText").text("아이디를 입력하세요.").css("color", "red");
		    } else if (emptyCheck.test(userId)) {
		    	$(".idText").text("아이디는 공백을 포함할수 없습니다.").css("color", "red");
		    } else if (!idPwdCheck.test(userId)) {
		    	$(".idText").text("아이디는 4 ~ 12자 영문 대소문자와 숫자로만 입력가능합니다.").css("color", "red");
	        } else {
	        	$(".idText").text("");
	        }
		});
	    
	    $("#btnUserIdCheck").on("click", function(){
		    $.ajax({
		    	type: "POST",
		    	url: "/user/userIdCheckAjax.jsp",
		    	data: {
	          		userId: $("#userId").val() 
	          	},
	          	dataType: "JSON", 
				success : function(obj){
					if (obj.flag === 1) {
						$(".idText").text("사용 가능한 아이디 입니다.").css("color", "blue");
					} else if (obj.flag === 0) {
						$(".idText").text("중복된 아이디입니다. 아이디를 다시 입력하세요.").css("color", "red");
						$("#userId").focus();
					} else if (obj.flag === -1) {
						$(".idText").text("아이디가 정상적으로 입력되지 않았습니다.").css("color", "red");
						$("#userId").focus();
					} else {
						alert("알 수 없는 응답(파싱 실패)입니다. 관리자에 문의하여 주세요.");
					}
				},
				error : function(xhr, status, error) {
					alert("서버 응답 오류 또는 네트워크 오류가 발생했습니다. 관리자에 문의하여 주세요.");
				}
			});
	    });
	    
	    $("#userPwd1").on("input", function() {
	    	var userPwd1 = $.trim($("#userPwd1").val());
	    	if (userPwd1.length === 0) {
	    		$(".pwdText1").text("비밀번호를 입력하세요.").css("color", "red");
	    	} else if (emptyCheck.test(userPwd1)) {
	    		$(".pwdText1").text("비밀번호는 공백을 포함할수 없습니다.").css("color", "red");
	       	} else if (!idPwdCheck.test(userPwd1)) {
	       		$(".pwdText1").text("비밀번호는 영문 대소문자와 숫자로 4 ~ 12자로만 입력가능합니다.").css("color", "red");
	       	} else {
	       		$(".pwdText1").text("");	
	        }
        });
	    
	    $("#userPwd2").on("input", function() {
		    if ($("#userPwd1").val() !== $("#userPwd2").val()) {
		    	$(".pwdText2").text("비밀번호가 일치하지 않습니다.").css("color", "red");
			   
		    } else if ($("#userPwd1").val() !== "") {
		    	$(".pwdText2").text("비밀번호가 일치합니다.").css("color", "blue");	
		    }
		});
	   
	    $("#userName").on("input", function() {
		    if ($.trim($("#userName").val()).length === 0) {
		    	$(".nameText").text("이름을 입력하세요.").css("color", "red");
		    } else {
		    	$(".nameText").text("");
		    }
		});
	   
	    $("#userEmail").on("input", function() {
		    if ($.trim($("#userEmail").val()).length === 0) {
		    	$(".emailText").text("이메일을 입력하세요.").css("color", "red");
		    } else if (!emailCheck.test($("#userEmail").val())) {
		    	$(".emailText").text("이메일 형식이 올바르지 않습니다.").css("color", "red");
		    } else {
			    $.ajax({
					type: "POST",
		            url: "/user/userEmailCheckAjax.jsp",
		            data: {
		        	    userEmail: $("#userEmail").val() 
		            },
		            dataType: "JSON", 
		            success: function(obj) {
		        	    if (obj.flag === 1) {
		             	    $(".emailText").text("사용 가능한 이메일입니다.").css("color", "blue");
		        	    } else if (obj.flag === 0) {
		            	    $(".emailText").text("이미 사용 중인 이메일입니다.").css("color", "red");
		                    $("#userEmail").focus();
		                } else if (obj.flag === -1) {
		            	    $(".emailText").text("이메일이 정상적으로 입력되지 않았습니다.").css("color", "red");
		                    $("#userEmail").focus();
		                } else {
							alert("알 수 없는 응답(파싱 실패)입니다. 관리자에 문의하여 주세요.");
		                }
		            },
		            error: function(xhr, status, error) {
		            	alert("서버 응답 오류 또는 네트워크 오류가 발생했습니다. 관리자에 문의하여 주세요.");
		            }
		    	});
		    }
	    });
	    
	    $("#userBirthDay").on("input", function() {
		    if($.trim($("#userBirthDay").val()).length === 0) {
		    	$(".birthDayText").text("생년월일을 입력하세요.").css("color", "red");
		    } else {
		    	$(".birthDayText").text("");
		    }
		});
		
	    $("#btnReg").on("click",function(){	
			if ($(".idText").text() === "사용 가능한 아이디입니다." && 
				$.trim($("#userPwd1").val()).length !== 0 &&
				$(".pwdText2").text() === "비밀번호가 일치합니다." &&
				$.trim($("#userName").val()).length !== 0 &&
				$(".emailText").text() === "사용 가능한 이메일입니다." &&
				$.trim($("#userBirthDay").val()).length !== 0) {
				$("#userPwd").val($("#userPwd1").val());
				document.regForm.submit();
				
			} else if ($(".idText").text() !== "사용 가능한 아이디입니다.") {
			    Swal.fire({
				    title: "아이디 중복체크후 진행해주세요.",
			        icon: "warning",
			        cancelButtonColor: "#3085d6",
			        cancelButtonText: "확인"
			    });
			    
			} else if ($(".emailText").text() !== "사용 가능한 이메일입니다.") {
				Swal.fire({
					title: "다른 이메일을 입력해주세요.",
			    	icon: "warning",
			        showCancelButton: true,
			        showConfirmButton: false,
			        cancelButtonColor: "#3085d6",
			        cancelButtonText: "확인"
			    });
			    
			} else {
				Swal.fire({
			    	title: "모든 필드를 올바르게 입력해주세요.",
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
		<h1 class="text-center text-nowrap">회원가입</h1>
	</div>
	<div class="row mt-4">
		<div class="col-12">
			<form name="regForm" method="post" action="/user/userProc.jsp">
				<div class="form-group mb-3">
					<label for="userId" class="form-label">사용자 아이디</label>
					<div class="d-flex">
						<input type="text" class="form-control me-3" id="userId" name="userId" placeholder="사용자 아이디" maxlength="12" required style="flex: 1;">
						<button type="button" id="btnUserIdCheck" class="btn btn-outline-primary" style="background-color: #3f51b5;">중복 검사</button>
					</div>
					<span class="idText"></span>
				</div>
				<div class="form-group mb-3 mt-5"> 
					<label for="userPwd1" class="form-label">비밀번호</label> 
					<input type="password" class="form-control" id="userPwd1" name="userPwd1" placeholder="비밀번호" maxlength="12" required style="flex: 1;">
					<span class="pwdText1"></span>
				</div>
				<div class="form-group mb-3 mt-5"> 
					<label for="userPwd2" class="form-label">비밀번호 확인</label> 
					<input type="password" class="form-control" id="userPwd2" name="userPwd2" placeholder="비밀번호 확인" maxlength="12" required style="flex: 1;"> 
					<span class="pwdText2"></span>
				</div>
				<div class="form-group mb-3 mt-5"> 
					<label for="userName" class="form-label">사용자 이름</label> 
					<input type="text" class="form-control" id="userName" name="userName" placeholder="사용자 이름" maxlength="15" required style="flex: 1;">
					<span class="nameText"></span>
				</div>
				<div class="form-group mb-3 mt-5"> 
					<label for="userEmail" class="form-label">사용자 이메일</label> 
					<input type="email" class="form-control" id="userEmail" name="userEmail" placeholder="사용자 이메일" maxlength="30" required style="flex: 1;">
					<span class="emailText"></span>
				</div>
				<div class="form-group mb-3 mt-5"> 
					<label for="userBirthDay" class="form-label">사용자 생년월일</label> 
					<input type="date" class="form-control" id="userBirthDay" name="userBirthDay" required style="flex: 1;"> 
					<span class="birthDayText"></span>
				</div>
				<div class="d-flex justify-content-end mt-4">
					<button type="button" id="btnReg" class="btn btn-outline-primary" style="background-color: #3f51b5;">등록</button>
				</div>
				<input type="hidden" id="userPwd" name="userPwd" value="">
			</form>
		</div>
	</div>
</div>
<%@ include file="/include/footer.jsp"%>
</body>
</html>