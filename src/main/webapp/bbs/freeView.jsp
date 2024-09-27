<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.sist.web.dao.FreeBbsDao"%>
<%@ page import="com.sist.web.model.FreeBbs"%>
<%
	Logger logger = LogManager.getLogger("freeView.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curPage", 1L);
	long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", 0L);
	
	FreeBbsDao freeBbsDao = new FreeBbsDao();
	FreeBbs freeBbs = freeBbsDao.freeBbsSelect(freeBbsSeq);
	if(freeBbs != null) {
		freeBbsDao.freeBbsReadCntPlus(freeBbsSeq);
	}
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp"%>
</head>
<body>
<%@include file="/include/navigation.jsp"%>
<div class="container mt-5">
	<h2>게시물 보기</h2>
	<div class="row" style="margin-right: 0; margin-left: 0;">
		<table class="table table-hover">
			<thead>
				<tr class="table-active">
					<th scope="col" style="width: 60%"><%= freeBbs.getFreeBbsTitle() %><br>작성자 : <%= freeBbs.getUserName() %></th>
					<th scope="col" style="width: 40%" class="text-end">
						조회수 : <%= StringUtil.toNumberFormat(freeBbs.getFreeBbsReadCnt()) %><br>
						작성일 : <%= freeBbs.getRegDate() %><br>
						<% if (!StringUtil.isEmpty(freeBbs.getUpdateDate())) { %>
						수정일 : <%= freeBbs.getUpdateDate() %>
						<% } %>
					</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan="2"><pre style="white-space: pre-wrap;"></pre>
					</td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="2"></td>
				</tr>
			</tfoot>
		</table>
	</div>
	<div class="d-flex">
		<button type="button" id="btnList" class="btn btn-outline-primary me-2">리스트</button>
		<% if(StringUtil.equals(cookieUserId, freeBbs.getUserId())) { %>
		<button type="button" id="btnUpdate" class="btn btn-outline-primary me-2">수정</button>
		<button type="button" id="btnDelete" class="btn btn-outline-primary">삭제</button>
		<% } %>
	</div>
	<hr>
	<div class="comments-section mt-4">
		<h5>댓글()</h5>
		<div class="card mb-3">
			<div class="card-body">
				<h6 class="card-title">댓글 작성자: 김철수</h6>
				<p class="card-text">이 게시물은 정말 유익했습니다! 감사합니다.</p>
				<p class="card-text">
					<small class="text-muted">2024-09-20 12:34</small>
				</p>
			</div>
		</div>
		<div class="card mb-3">
			<div class="card-body">
				<h6 class="card-title">댓글 작성자: 이영희</h6>
				<p class="card-text">좋은 정보 공유해주셔서 감사합니다.</p>
				<p class="card-text">
					<small class="text-muted">2024-09-20 14:20</small>
				</p>
			</div>
		</div>
		<!-- 댓글 입력 폼 -->
		<div class="mt-4">
			<form name="" action="" method="post">
				<div class="mb-3">
					<label for="commentText" class="form-label">댓글 내용</label>
					<textarea class="form-control" id="commentText" rows="3" placeholder="댓글을 입력하세요."></textarea>
				</div>
				<button type="submit" class="btn btn-primary">댓글 작성</button>
			</form>
		</div>
	</div>
</div>
<%@include file="/include/footer.jsp"%>
<form name="bbsForm" action="" method="post">
      <input type="hidden" id="searchType" name="searchType" value="<%= searchType %>">
      <input type="hidden" id="searchValue" name="searchValue" value="<%= searchValue %>">
      <input type="hidden" id="curPage" name="curPage" value="<%= curPage %>">
      <input type="hidden" id="freebbsSeq" name="freeBbsSeq" value="<%= freeBbsSeq %>">
</form>
</body>
</html>