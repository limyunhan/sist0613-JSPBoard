<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
					<th scope="col" style="width: 60%">게시물 제목 예시<br /> 작성자:
						홍길동&nbsp;&nbsp;&nbsp; <a href="mailto:hong@example.com"
						style="color: #828282;">hong@example.com</a>
					</th>
					<th scope="col" style="width: 40%" class="text-end">조회수: 123<br />
						2024-09-20
					</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan="2"><pre style="white-space: pre-wrap;">이곳은 게시물 내용이 들어갑니다. 여러 줄로 작성된 내용이<br>HTML에서 줄바꿈을 표시하게 됩니다.</pre>
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
		<button type="button" id="btnList" class="btn btn-secondary me-2">리스트</button>
		<button type="button" id="btnUpdate" class="btn btn-secondary me-2">수정</button>
		<button type="button" id="btnDelete" class="btn btn-secondary">삭제</button>
	</div>
	<hr>
	<div class="comments-section mt-4">
		<h5>댓글</h5>
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
			<h5>댓글 작성</h5>
			<form>
				<div class="mb-3">
					<label for="commentText" class="form-label">댓글 내용</label>
					<textarea class="form-control" id="commentText" rows="3"
						placeholder="댓글을 입력하세요."></textarea>
				</div>
				<button type="submit" class="btn btn-primary">댓글 작성</button>
			</form>
		</div>
	</div>
</div>
<%@include file="/include/footer.jsp"%>
</body>
</html>