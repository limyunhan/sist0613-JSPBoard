<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.sist.web.dao.FreeBbsDao"%>
<%@ page import="com.sist.web.dao.FreeBbsComDao" %>
<%@ page import="com.sist.web.model.FreeBbsCom" %>
<%@ page import="com.sist.web.model.FreeBbs"%>
<%
Logger logger = LogManager.getLogger("freeView.jsp");
HttpUtil.requestLogString(request, logger);

long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", 0L);
if (freeBbsSeq == 0L) {
    response.sendRedirect("/bbs/freeList.jsp");
} else {
    String cookieUserId = CookieUtil.getValue(request, "USER_ID");
    String searchType = HttpUtil.get(request, "searchType", "");
    String searchValue = HttpUtil.get(request, "searchValue", "");
    long curPage = HttpUtil.get(request, "curPage", -1L);

    FreeBbsDao freeBbsDao = new FreeBbsDao();
    FreeBbs freeBbs = freeBbsDao.freeBbsSelect(freeBbsSeq);
    if (freeBbs != null && StringUtil.equals(freeBbs.getFreeBbsStatus(), "Y")) {
        freeBbs.setFreeBbsReadCnt(freeBbsDao.getFreeBbsReadCnt(freeBbsSeq));
    }
    
    FreeBbsComDao freeBbsComDao = new FreeBbsComDao();
    long totalCom = freeBbsDao.freeBbsTotalPost(search);
    long curPage = HttpUtil.get(request, "curPage", 1L);

    Paging paging = null;
    List<FreeBbs> list = null;

    if(totalPost > 0) {
        paging = new Paging(totalPost, PageConfig.NUM_OF_PAGE_PER_BLOCK, PageConfig.NUM_OF_POST_PER_PAGE, curPage);
        search.setStartPost(paging.getStartPost());
        search.setEndPost(paging.getEndPost());
        list = freeBbsDao.freeBbsList(search);
        logger.debug("list size() : " + list.size());
    }
    
    
    
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp"%>
</head>
<script>
    $(document).ready(function() {
<%
        if (freeBbs == null || StringUtil.equals(freeBbs.getFreeBbsStatus(), "N")) {
%>
            Swal.fire({
                title: "조회하신 게시물이 존재하지 않습니다.",
                icon: "warning",
                confirmButtonColor: "#3085d6",
                confirmButtonText: "확인",
            }).then(result => {
                if (result.isConfirmed) {
                    document.bbsForm.action = "/bbs/freeList.jsp";
                    document.bbsForm.submit();
                }
            });
<%
        } else {
%>
            <% if (!StringUtil.isEmpty(cookieUserId)) { %>
            $.ajax({
                type: "POST",
                url: "/bbs/recomCheckInitAjax.jsp",
                data: {
                    userId: "<%= cookieUserId %>",
                    freeBbsSeq: <%= freeBbsSeq %>
                },
                dataType: "JSON",
                success: function(obj) {
                    if (obj.flag) {
                        $("#btnRecom").html("<i class='fas fa-thumbs-up'></i> 추천 <%= freeBbs.getFreeBbsRecomCnt() %>");
                    } else {
                        $("#btnRecom").html("<i class='fas fa-thumbs-up' style='color: blue;'></i> 추천 <%= freeBbs.getFreeBbsRecomCnt() %>");
                    }
                },
                error: function(xhr, status, error) {
                    Swal.fire({
                        title: "오류",
                        text: "서버 응답 오류가 발생했습니다. 관리자에게 문의하세요.",
                        icon: "error",
                        confirmButtonColor: "#3085d6",
                        confirmButtonText: "확인"
                    });
                }
            });
            <% } %>

            $("#btnList").on("click", function() {
                document.bbsForm.action = "/bbs/freeList.jsp";
                document.bbsForm.submit();
            });

            $("#btnRecom").on("click", function() {
<%
                if (StringUtil.isEmpty(cookieUserId)) {
%>
                    Swal.fire({
                        title: "오류",
                        text: "비로그인 추천은 제한되어 있습니다.",
                        icon: "error",
                        confirmButtonColor: "#3085d6",
                        confirmButtonText: "확인"
                    });
<%
                } else {
%>
                    $.ajax({
                        type: "POST",
                        url: "/bbs/recomCheckAjax.jsp",
                        data: {
                            userId: "<%= cookieUserId %>",
                            freeBbsSeq: <%= freeBbsSeq %>
                        },
                        dataType: "JSON",
                        success: function(obj) {
                            if (obj.flag) {
                                Swal.fire({
                                    title: "추천을 완료했습니다!",
                                    icon: "success",
                                    confirmButtonColor: "#3085d6",
                                    confirmButtonText: "확인",
                                });
                                $("#btnRecom").html("<i class='fas fa-thumbs-up' style='color: blue;'></i> 추천 " + obj.newCount);
                            } else {
                                Swal.fire({
                                    title: "추천을 취소했습니다!",
                                    icon: "info",
                                    confirmButtonColor: "#3085d6",
                                    confirmButtonText: "확인",
                                });
                                $("#btnRecom").html("<i class='fas fa-thumbs-up'></i> 추천 " + obj.newCount);
                            }
                        },
                        error: function(xhr, status, error) {
                            Swal.fire({
                                title: "오류",
                                text: "서버 응답 오류가 발생했습니다. 관리자에게 문의하세요.",
                                icon: "error",
                                confirmButtonColor: "#3085d6",
                                confirmButtonText: "확인"
                            });
                        }
                    });
<%
                }
%>
            });

<%
            if (StringUtil.equals(cookieUserId, freeBbs.getUserId())) {
%>
                $("#btnUpdate").on("click", function() {
                    document.bbsForm.action = "/bbs/freeUpdate.jsp";
                    document.bbsForm.submit();
                });

                $("#btnDelete").on("click", function() {
                    Swal.fire({
                        title: "게시글을 수정하시겠습니까?",
                        icon: "success",
                        showCancelButton: true,
                        cancelButtonColor: "#3f51b5",
                        confirmButtonColor: "#3085d6",
                        confirmButtonText: "확인",
                        cancelButtonText: "취소",
                        reverseButtons: true,
                    }).then(result => {
                        if (result.isConfirmed) {
                            document.updateForm.submit();
                        }
                    });
                });
<%
            }
        }
%>
    });
</script>
<body>
<%@ include file="/include/navigation.jsp"%>
<div class="container mt-5">
    <h2>게시물 보기</h2>
    <div class="row">
        <table class="table">
            <thead>
                <tr class="table-active">
                    <th scope="col" style="width: 60%; word-wrap: break-word;">
                        <%= freeBbs.getFreeBbsTitle() %><br>
                        <small class="text-body">작성자: <%= freeBbs.getUserName() %></small>
                    </th>
                    <th scope="col" style="width: 40%;" class="text-end">
                        <small class="text-body">조회수: <%= StringUtil.toNumberFormat(freeBbs.getFreeBbsReadCnt()) %><br></small>
                        <small class="text-body">작성일: <%= freeBbs.getRegDate() %>&nbsp;</small>
                        <% if (!StringUtil.isEmpty(freeBbs.getUpdateDate())) { %>
                            <small class="text-body">수정일: <%= freeBbs.getUpdateDate() %></small>
                        <% } %>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="2">
                        <pre><%= StringUtil.replace(freeBbs.getFreeBbsContent(), "\n", "<br>") %></pre>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- 추천 박스 -->
    <div class="d-flex justify-content-center align-items-center my-3">
        <!-- 추천 버튼 -->
        <button type="button" id="btnRecom" class="btn btn-success">
            <i class='fas fa-thumbs-up'></i> 추천 <%= freeBbs.getFreeBbsRecomCnt() %>
        </button>
    </div>
    <!-- 댓글 섹션 -->
    <hr>
    <div class="comments-section mt-4">
        <h5>댓글</h5>

        <!-- 댓글 목록 -->
<% 
		FreeBbsComDao freeBbsComDao = new FreeBbsComDao();
        List<freeBbsCom> list = freeBbsComDao.freeBbsComList(freeBbsSeq, startCom, endCom);
        for (Comment comment : comments) {
%>
            <div class="card mb-3">
                <div class="card-body">
                    <h6 class="card-title">댓글 작성자: <%= comment.getUserName() %></h6>
                    <p class="card-text"><%= comment.getCommentText() %></p>
                    <p class="card-text">
                        <small class="text-muted"><%= comment.getRegDate() %></small>
                    </p>
                </div>
            </div>
        <%
        }
        %>
        
        <!-- 댓글 작성 폼 -->
        <div class="mb-3">
            <h6>댓글 작성</h6>
            <form id="commentForm">
                <div class="form-group">
                    <textarea class="form-control" id="commentText" rows="3" placeholder="댓글을 작성하세요"></textarea>
                </div>
                <button type="submit" class="btn btn-primary mt-2">댓글 작성</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
<%
}
%>