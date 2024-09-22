<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp"%>
<script>

</script>
</head>
<body>
<%@ include file="/include/navigation.jsp"%>
<div class="container" style="max-width: 400px; background-color: #e8eaf6; border-radius: 10px; padding: 20px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);">
    <div class="row mt-5">
        <h1 class="text-center text-nowrap">회원가입</h1>
    </div>
    <div class="row mt-4">
        <div class="col-12">
            <form id="regForm" name="regForm" method="post" action="/user/userProc.jsp">
                <div class="form-group mb-3">
                    <label for="userId" class="form-label">사용자 아이디</label>
                    <input type="text" class="form-control" id="userId" name="userId" placeholder="사용자 아이디" maxlength="12" required>
                </div>
                <div class="form-group mb-3">
                    <label for="userPwd1" class="form-label">비밀번호</label>
                    <input type="password" class="form-control" id="userPwd1" name="userPwd1" placeholder="비밀번호" maxlength="12" required>
                </div>
                <div class="form-group mb-3">
                    <label for="userPwd2" class="form-label">비밀번호 확인</label>
                    <input type="password" class="form-control" id="userPwd2" name="userPwd2" placeholder="비밀번호 확인" maxlength="12" required>
                </div>
                <div class="form-group mb-3">
                    <label for="userName" class="form-label">사용자 이름</label>
                    <input type="text" class="form-control" id="userName" name="userName" placeholder="사용자 이름" maxlength="15" required>
                </div>
                <div class="form-group mb-3">
                    <label for="userEmail" class="form-label">사용자 이메일</label>
                    <input type="email" class="form-control" id="userEmail" name="userEmail" placeholder="사용자 이메일" maxlength="30" required>
                </div>
                <div class="form-group mb-3">
	                <label for="userBirthDay" class="form-label">사용자 생일</label>
	                <input type="date" class="form-control" id="userBirthDay" name="userBirthDay" required>
                </div>
                <input type="hidden" id="userPwd" name="userPwd" value="">
                <div class="d-flex justify-content-end mt-4">
                    <button type="button" id="btnReg" class="btn btn-outline-primary" style="background-color: #3f51b5;">등록</button>
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/include/footer.jsp" %>
</body>
</html>