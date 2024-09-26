<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<% if (!request.getRequestURI().contains("user")) { %>
<script>
	$(document).ready(function() {
		$("#loginModal").on("click", function() {
			$("#loginModal").on("shown.bs.modal", function() {
				$("#userId").focus();
			});
		});
<% 
		if (StringUtil.isEmpty(CookieUtil.getValue(request, "USER_ID"))) {
%>
			$("#btnLogin").on("click", function() {
				fn_loginCheck();
			});
			
			$("#regForm").on("click", function() {
				location.href = "/user/userRegForm.jsp";
			});
<% 
		} else {
%>
			$("#btnLogout").on("click", function() {
<%
				String currentUrl = request.getRequestURI();
				session.setAttribute("previousUrl", currentUrl);
%>		
				location.href = "/loginOut.jsp";
			});
			
			$("#updateForm").on("click", function() {
				location.href = "/user/userUpdateForm.jsp";
			});
<%
		}
%>
	});

	function fn_loginCheck() {
		if ($.trim($("#userId").val()).length === 0) {
			alert("아이디를 입력하세요.");
			$("#userId").val("");
			$("#userId").focus();
			return;
		}
	
		if ($.trim($("#userPwd").val()).length === 0) {
			alert("비밀번호를 입력하세요.");
			$("#userPwd").val("");
			$("#userPwd").focus();
			return;
		}
<%
		String currentUrl = request.getRequestURI();
		session.setAttribute("previousUrl", currentUrl);
%>		
		document.loginForm.submit();
	}

	function showModal() {
		$("#loginModal").modal("show");
	}
</script>
<% } %>
<nav class="navbar navbar-expand-lg bg-info">
	<div class="container-fluid">
		<a class="navbar-brand text-white fs-3" href="/"><i class="fa-solid fa-utensils"></i> JSPBoard</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarColor01" aria-controls="navbarColor01" aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarColor01">
			<ul class="navbar-nav me-auto">
				<li class="nav-item">
					<a class="nav-link active text-white fs-7" href="/board/freeList.jsp"><i class="fa-solid fa-list"></i> 자유게시판</a>
				</li>
				<li class="nav-item">
					<a class="nav-link text-white fs-7" href="/board/restoList.jsp"><i class="fa-solid fa-list-check"></i>음식점 게시판</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle text-white fs-7" data-bs-toggle="dropdown" href="" role="button" aria-haspopup="true" aria-expanded="false"><i class="fa-solid fa-sitemap"></i> 사이트맵</a>
					<div class="dropdown-menu">
						<a class="dropdown-item" href="">이용약관</a> 
						<a class="dropdown-item" href="">개인정보처리방침</a>
						<% if (!StringUtil.isEmpty(CookieUtil.getValue(request, "USER_ID"))) { %>
						<a class="dropdown-item" href="/user/userCancelForm.jsp">회원탈퇴</a>
						<% } %>
					</div>
				</li>
			</ul>
			<div class="d-flex align-items-center">
<%
				if (!request.getRequestURI().contains("user")) {
					if (StringUtil.isEmpty(CookieUtil.getValue(request, "USER_ID"))) {
%>
				<!-- 로그인이 안 되어 있을 경우 -->
				<button type="button" id="regForm" class="btn btn-outline-primary me-2" style="background-color: #3f51b5;">회원가입</button>
				<button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#loginModal">로그인</button>
<%
				} else {
%>
				<!-- 로그인이 되어 있을 경우 -->
				<button type="button" id="updateForm" class="btn btn-outline-primary me-2" style="background-color: #3f51b5;">회원정보수정</button>
				<button type="button" id="btnLogout" class="btn btn-outline-primary">로그아웃</button>
<%
					}
				}
%>
			</div>
		</div>
	</div>
</nav>

<%-- 로그인 모달 제외 조건 : user 관련 작업중일 때 --%>
<% if (!request.getRequestURI().contains("user")) { %>
<!-- 모달 구조 -->
<form name="loginForm" id="loginForm" method="post" action="/loginProc.jsp" class="form-signin">
	<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="loginModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="loginModalLabel">로그인</h5>
					<button type="button" id="btntest098" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
						<div class="mb-3">
							<label for="userId" class="form-label">아이디</label> 
							<input type="text" class="form-control" id="userId" name="userId" placeholder="아이디 입력" required>
						</div>
						<div class="mb-3">
							<label for="userPwd" class="form-label">비밀번호</label> 
							<input type="password" class="form-control" id="userPwd" name="userPwd" placeholder="비밀번호 입력" required>
						</div>
						<div class="form-check mb-3">
							<input class="form-check-input" type="checkbox" value="" id="rememberPasswordCheck"> 
							<label class="form-check-label" for="rememberPasswordCheck">비밀번호를 저장하시겠습니까?</label>
						</div>
					<div class="text-center mb-3">
						<a class="btn-dark" href="/user/userFindId.jsp">아이디 찾기</a>
						&nbsp; | &nbsp;
						<a class="btn-dark" href="/user/userFindPwd.jsp">비밀번호 찾기</a>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal" style="background-color: #3f51b5;">닫기</button>
					<button type="button" id="btnLogin" class="btn btn-outline-primary">로그인</button>
				</div>
			</div>
		</div>
	</div>
</form>
<% } %>