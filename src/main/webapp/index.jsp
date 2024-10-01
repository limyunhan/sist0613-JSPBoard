<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.web.model.FreeBbs"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.sist.web.dao.FreeBbsDao"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp" %>
<%
Logger logger = LogManager.getLogger("index.jsp");
HttpUtil.requestLogString(request, logger);

String openLoginModal = (String)session.getAttribute("openLoginModal");
session.removeAttribute("openLoginModal");

List<FreeBbs> list = null;
FreeBbs search = new FreeBbs();
search.setStartPost(1);
search.setEndPost(5);

FreeBbsDao freeBbsDao = new FreeBbsDao();
list = freeBbsDao.freeBbsList(search);

List<FreeBbs> popularList = null;
FreeBbs popularFreeBbs = new FreeBbs();
popularFreeBbs.setStartPost(1);
popularFreeBbs.setEndPost(5);
popularList = freeBbsDao.popularFreeBbsList(popularFreeBbs);

logger.debug("popularList size() : " + popularList.size());
%>
<script>
	$(document).ready(function(){
		$("#btnFree").on("click", function(){
	   		location.href = "/bbs/freeList.jsp";
		});
		
		$("#btnStore").on("click", function(){
			location.href = "/bbs/restoList.jsp";
		});
		
<% 		
		if(openLoginModal != null && openLoginModal.equals("1")) { 
%>
			showModal();
<% 
		} 
%>
	});
	
    function view(freeBbsSeq) {
        $("#freeBbsSeq").val(freeBbsSeq);
        document.bbsForm.action = "/bbs/freeView.jsp";
        document.bbsForm.submit();
    }
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
                <div class="card-header"><h2><i class="fa-solid fa-fire"></i> 최근 7일동안의 인기 게시물</h2></div>
                <div class="card-body">
                    <ul>
<%
					if (popularList != null && popularList.size() > 0) {
						Iterator<FreeBbs> iterator = popularList.iterator();
						while(iterator.hasNext()) {
							FreeBbs freeBbs = iterator.next();
%>
							<li><a href="javascript:void(0)" onclick="view(<%= freeBbs.getFreeBbsSeq() %>)"><%= freeBbs.getFreeBbsTitle() %></a></li>
<%

						}
					} else {
%>
						<li><a href="javascript:void(0)">해당 데이터가 존재하지 않습니다.</a></li>
<% 
					}
%>
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
	                                <th scope="col" class="text-center" style="width: 20%">번호</th>
	                                <th scope="col" class="text-center" style="width: 40%">제목</th>
	                                <th scope="col" class="text-center" style="width: 20%">작성자</th>
	                                <th scope="col" class="text-center" style="width: 10%">조회수</th>
	                                <th scope="col" class="text-center" style="width: 10%">추천</th>
	                            </tr>
                            </thead>
                            <tbody>
<%
                        if (list != null && list.size() > 0) {
                        	Iterator<FreeBbs> iterator = list.iterator();
                            while(iterator.hasNext()) {
                                FreeBbs freeBbs = iterator.next();
%>
                                <tr class="table-light">
                                    <th scope="row" class="text-center"><%= freeBbs.getFreeBbsSeq() %></th>
                                    <td class="text-center">
                                    	<a href="javascript:void(0)" onclick="view(<%= freeBbs.getFreeBbsSeq() %>)"><%= freeBbs.getFreeBbsTitle() %>
                                    	<% if (freeBbs.getFreeBbsComCnt() != 0) { %>
                                    	(<span style="color: blue;"><%= StringUtil.toNumberFormat(freeBbs.getFreeBbsComCnt()) %></span>)
                                    	<% } %>
                                    	</a>
                                    </td>
                                    <td class="text-center"><%= freeBbs.getUserName() %></td>
                                    <td class="text-center"><%= StringUtil.toNumberFormat(freeBbs.getFreeBbsReadCnt()) %></td>
                                    <td class="text-center"><%= StringUtil.toNumberFormat(freeBbs.getFreeBbsRecomCnt()) %></td>
                                </tr>
<%
                            }
                        } else {
%>
                            <tr>
                                <td colspan="6" class="text-center">해당 데이터가 존재하지 않습니다.</td>
                            </tr>
<%
                        }
%>
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
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="table-light">
                                    <th scope="row">1</th>
                                    <td>음식점 게시판 글 제목 1</td>
                                    <td>작성자1</td>
                                    <td>2024-09-19</td>
                                </tr>
                                <tr class="table-light">
                                    <th scope="row">2</th>
                                    <td>음식점 게시판 글 제목 2</td>
                                    <td>작성자2</td>
                                    <td>2024-09-18</td>
                                </tr>
                                <tr class="table-light">
                                    <th scope="row">3</th>
                                    <td>음식점 게시판 글 제목 3</td>
                                    <td>작성자3</td>
                                    <td>2024-09-17</td>
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
<form name="bbsForm" action="" method="post">
	<input type="hidden" id="freeBbsSeq" name="freeBbsSeq" value="">
</form>
<%@ include file="/include/footer.jsp" %>
</body>
</html>