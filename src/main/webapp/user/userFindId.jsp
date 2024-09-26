<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp"%>
<script>
    $(document).ready(function() {
        $("#userName").focus();

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
            if ($.trim($("#userName").val()).length === 0 || $.trim($("#userEmail").val()).length === 0) {
                Swal.fire({
                    title: "모든 필드를 올바르게 입력해주세요.",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: "확인"
                });
                return;
            }
            
            document.findForm.submit();
        });
    });
</script>
</head>
<body>
<%@ include file="/include/navigation.jsp"%>
<div class="container" style="max-width: 600px; background-color: #e8eaf6; border-radius: 10px; padding: 20px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);">
    <div class="row mt-5">
        <h1 class="text-center text-nowrap">아이디 찾기</h1>
    </div>
    <div class="row mt-4">
        <div class="col-12">
            <form name="findForm" method="post" action="/user/userFindIdProc.jsp">
                <div class="form-group mb-3">
                    <label for="userName" class="form-label">사용자 이름</label>
                    <input type="text" class="form-control" id="userName" name="userName" placeholder="사용자 이름" maxlength="15" required style="flex: 1;">
                    <span class="nameText"></span>
                </div>
                <div class="form-group mb-3 mt-5"> 
                    <label for="userEmail" class="form-label">사용자 이메일</label>
                    <input type="email" class="form-control" id="userEmail" name="userEmail" placeholder="사용자 이메일" maxlength="30" required style="flex: 1;">
                    <span class="emailText"></span>
                </div>
                <div class="d-flex justify-content-end mt-5">
                    <button type="button" id="btnFind" class="btn btn-outline-primary" style="background-color: #3f51b5;">찾기</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/include/footer.jsp" %>
</body>
</html>