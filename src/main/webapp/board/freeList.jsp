<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp"%>
<script>
	$(document).ready(function() {
		$("#btnWrite").on("click", function() {
			location.href = "/board/freeWrite.jsp";
		});
	});
</script>
</head>
<body>
	<%@ include file="/include/navigation.jsp"%>
	<div class="container mt-4">
		<div class="row">
			<!-- 자유 게시판 카드 -->
			<div class="col-md-12">
				<div class="card text-white bg-info mb-3">
					<div class="card-header d-flex justify-content-between align-items-center">
						<h2 style="margin: 0;">자유 게시판</h2>
						<div class="d-flex align-items-center">
							<select id="_searchType" class="form-select mx-1" style="max-width: 200px;">
								<option value="">조회항목</option>
								<option value="title">- 제목</option>
								<option value="titleContent">- 제목 + 내용</option>
								<option value="author">- 작성자</option>
							</select>
							<input type="text" name="_searchValue" id="_searchValue" value="" 
								class="form-control mx-1" maxlength="20" placeholder="검색" 
								style="max-width: 400px;" />
							<button type="button" id="btnSearch" class="btn btn-outline-light mx-1" 
								style="white-space: nowrap;">검색</button>
						</div>
					</div>
					<div class="card-body d-flex flex-column">
						<table class="table table-info">
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">제목</th>
									<th scope="col">작성자</th>
									<th scope="col">작성일</th>
								</tr>
							</thead>
							<tbody>
								<tr class="table-light">
									<th scope="row">1</th>
									<td>자유 게시판 글 제목 1</td>
									<td>작성자1</td>
									<td>2024-09-19</td>
								</tr>
								<tr class="table-light">
									<th scope="row">2</th>
									<td>자유 게시판 글 제목 2</td>
									<td>작성자2</td>
									<td>2024-09-18</td>
								</tr>
								<tr class="table-light">
									<th scope="row">3</th>
									<td>자유 게시판 글 제목 3</td>
									<td>작성자3</td>
									<td>2024-09-17</td>
								</tr>
							</tbody>
						</table>
						<div>
							<ul class="pagination d-flex justify-content-between mb-0 w-100">
								<li class="page-item disabled"><a class="page-link" href="#">&laquo;</a></li>
								<li class="page-item active flex-fill text-center"><a class="page-link" href="#">1</a></li>
								<li class="page-item flex-fill text-center"><a class="page-link" href="#">2</a></li>
								<li class="page-item flex-fill text-center"><a class="page-link" href="#">3</a></li>
								<li class="page-item flex-fill text-center"><a class="page-link" href="#">4</a></li>
								<li class="page-item flex-fill text-center"><a class="page-link" href="#">5</a></li>
								<li class="page-item"><a class="page-link" href="#">&raquo;</a></li>
								<li class="ms-auto">
									<button type="button" id="btnWrite" class="btn btn-outline-light d-flex align-items-center">
										<i class="fa-sharp-duotone fa-solid fa-pen me-1"></i> <span>자유 글쓰기</span>
									</button>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
