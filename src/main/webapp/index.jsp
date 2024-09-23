<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp" %>

<script>
$(document).ready(function(){
   $("#btnFree").on("click", function(){
       location.href = "/board/freeList.jsp";
       });
   
   $("#btnStore").on("click", function(){
       location.href = "/board/storeList.jsp";
       });
});
</script>

<style>
    .card-header h2 {
        margin: 0;
        font-size: 1.5rem; /* 고정 크기 */
    }

    .table th, .table td {
        white-space: nowrap; /* 셀 내용 줄바꿈 방지 */
    }

    /* 반응형 텍스트 크기 조정 */
    .blockquote p {
        font-size: 1rem; /* 기본 크기 */
    }

    @media (max-width: 768px) {
        .card-header h2 {
            font-size: 1.2rem; /* 작은 화면에서 약간 줄어듦 */
        }
    }

    @media (min-width: 768px) {
        .card-header h2 {
            font-size: 1.5rem; /* 큰 화면에서 고정 크기 유지 */
        }
    }
</style>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>

<div class="container mt-4">
    <div class="row">
        <!-- 공지사항 카드 -->
        <div class="col-md-12 mb-3">
            <div class="card bg-light mb-3">
                <div class="card-header"><h2><i class="fa-solid fa-clipboard-check"></i> 공지사항</h2></div>
                <div class="card-body">
                    <ul>
                        <li>새로운 기능 업데이트가 적용되었습니다.</li>
                        <li>2024년 10월 1일 서버 점검이 예정되어 있습니다.</li>
                        <li>이벤트 참가 신청이 시작되었습니다!</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 인기 게시물 카드 -->
        <div class="col-md-12 mb-3">
            <div class="card bg-light mb-3">
                <div class="card-header"><h2><i class="fa-solid fa-fire"></i> 인기 게시물</h2></div>
                <div class="card-body">
                    <ul>
                        <li><a href="#">가장 인기 있는 게시물 제목 1</a></li>
                        <li><a href="#">가장 인기 있는 게시물 제목 2</a></li>
                        <li><a href="#">가장 인기 있는 게시물 제목 3</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 자유 게시판 카드 -->
        <div class="col-md-6 mb-3">
            <div class="card text-white bg-info mb-3">
                <div class="card-header"><h2><i class="fa-solid fa-list"></i> 자유 게시판</h2></div>
                <div class="card-body d-flex flex-column">
                    <div class="table-responsive">
                        <table class="table table-info">
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">제목</th>
                                    <th scope="col">작성자</th>
                                    <th scope="col">작성일</th>
                                    <th scope="col">작업</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="table-light">
                                    <th scope="row">1</th>
                                    <td>자유 게시판 글 제목 1</td>
                                    <td>작성자1</td>
                                    <td>2024-09-19</td>
                                    <td><button class="btn btn-outline-light btn-sm">좋아요</button></td>
                                </tr>
                                <tr class="table-light">
                                    <th scope="row">2</th>
                                    <td>자유 게시판 글 제목 2</td>
                                    <td>작성자2</td>
                                    <td>2024-09-18</td>
                                    <td><button class="btn btn-outline-light btn-sm">좋아요</button></td>
                                </tr>
                                <tr class="table-light">
                                    <th scope="row">3</th>
                                    <td>자유 게시판 글 제목 3</td>
                                    <td>작성자3</td>
                                    <td>2024-09-17</td>
                                    <td><button class="btn btn-outline-light btn-sm">좋아요</button></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-flex justify-content-end mt-auto">
                        <button type="button" id="btnFree" class="btn btn-outline-light btn-sm">전체보기</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 음식점 게시판 카드 -->
        <div class="col-md-6 mb-3">
            <div class="card text-white bg-info mb-3">
                <div class="card-header"><h2><i class="fa-solid fa-list-check"></i> 음식점 게시판</h2></div>
                <div class="card-body d-flex flex-column">
                    <div class="table-responsive">
                        <table class="table table-info">
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">제목</th>
                                    <th scope="col">작성자</th>
                                    <th scope="col">작성일</th>
                                    <th scope="col">작업</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="table-light">
                                    <th scope="row">1</th>
                                    <td>음식점 게시판 글 제목 1</td>
                                    <td>작성자1</td>
                                    <td>2024-09-19</td>
                                    <td><button class="btn btn-outline-light btn-sm">좋아요</button></td>
                                </tr>
                                <tr class="table-light">
                                    <th scope="row">2</th>
                                    <td>음식점 게시판 글 제목 2</td>
                                    <td>작성자2</td>
                                    <td>2024-09-18</td>
                                    <td><button class="btn btn-outline-light btn-sm">좋아요</button></td>
                                </tr>
                                <tr class="table-light">
                                    <th scope="row">3</th>
                                    <td>음식점 게시판 글 제목 3</td>
                                    <td>작성자3</td>
                                    <td>2024-09-17</td>
                                    <td><button class="btn btn-outline-light btn-sm">좋아요</button></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-flex justify-content-end mt-auto">
                        <button type="button" id="btnStore" class="btn btn-outline-light btn-sm">전체보기</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 사용자 피드백 섹션 -->
    <div class="row mb-3">
        <div class="col-md-12">
            <div class="card bg-light mb-3">
                <div class="card-header"><h2><i class="fa-solid fa-comment-dots"></i> 사용자 피드백</h2></div>
                <div class="card-body">
                    <blockquote class="blockquote">
                        <p class="mb-0">"이 사이트는 정말 유용해요!"</p>
                    </blockquote>
                    <blockquote class="blockquote">
                        <p class="mb-0">"사용하기 간편하고 필요한 정보가 많아요."</p>
                    </blockquote>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/include/footer.jsp" %>
</body>
</html>