<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp"%>
<script>
    $(document).ready(function() {
        $("#userId").focus();

        $("#userId").on("input", function() {
            var userId = $.trim($("#userId").val());
            var idPwdCheck = /^[a-zA-Z0-9]{4,12}$/;
            var emptyCheck = /\s/g;  
            
            if (userId.length === 0) {
                $(".idText").text("아이디를 입력하세요.").css("color", "red");
            } else if (emptyCheck.test(userId)) {
                $(".idText").text("아이디는 공백을 포함할 수 없습니다.").css("color", "red");
            } else if (!idPwdCheck.test(userId)) {
                $(".idText").text("아이디는 4 ~ 12자 영문 대소문자와 숫자로만 입력 가능합니다.").css("color", "red");
            } else {
                $(".idText").text("");
            }
        });

        $("#userName").on("input", function() {
            if ($.trim($("#userName").val()).length === 0) {
                $(".nameText").text("사용자 이름을 입력해주세요.").css("color", "red");
            } else {
                $(".nameText").text("");
            }
        });
        
        $("#userEmail").on("input", function() {
            var emailCheck = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
            
            if ($.trim($("#userEmail").val()).length === 0) {
                $(".emailText").text("사용자 이메일을 입력해주세요.").css("color", "red");
            } else if (!emailCheck.test($("#userEmail").val())) {
                $(".emailText").text("사용자 이메일 형식이 올바르지 않습니다.").css("color", "red");
            } else {
                $(".emailText").text("");
            }
        });

        $("#btnFind").on("click", function() {
            if ($.trim($("#userId").val()).length === 0 || 
                $.trim($("#userName").val()).length === 0 || 
                $.trim($("#userEmail").val()).length === 0) {
                Swal.fire({
                    title: "모든 필드를 올바르게 입력해주세요.",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: "확인"
                });
                return;
            }
            
            document.pwdFindForm.submit();
        });
    });
</script>
</head>
<body>
<%@ include file="/include/navigation.jsp"%>
<div class="container" style="max-width: 400px; background-color: #e8eaf6; border-radius: 10px; padding: 20px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);">
    <div class="row mt-5">
        <h1 class="text-center text-nowrap">비밀번호 찾기</h1>
    </div>
    <div class="row mt-4">
        <div class="col-12">
            <form name="pwdFindForm" method="post" action="/user/userFindPwdProc.jsp">
                <div class="form-group mb-3">
                    <label for="userId" class="form-label">사용자 아이디</label>
                    <input type="text" class="form-control me-3" id="userId" name="userId" placeholder="사용자 아이디" maxlength="12" required style="flex: 1;">
                    <span class="idText"></span>
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
                <div class="d-flex justify-content-end mt-4">
                    <button type="button" id="btnFind" class="btn btn-outline-primary" style="background-color: #3f51b5;">찾기</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/include/footer.jsp" %>
</body>
</html>