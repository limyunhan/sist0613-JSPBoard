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
<%@ page import="com.sist.web.model.PageConfig"%>
<%@ page import="com.sist.web.model.Paging"%>
<%
Logger logger = LogManager.getLogger("freeList.jsp");
HttpUtil.requestLogString(request, logger);

String searchType = HttpUtil.get(request, "searchType", "");
String searchValue = HttpUtil.get(request, "searchValue", "");

FreeBbs search = new FreeBbs();
if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
    if(StringUtil.equals(searchType , "1")) {
        search.setFreeBbsTitle(searchValue);
    } else if(StringUtil.equals(searchType, "2")) {
        search.setFreeBbsTitle(searchValue);
        search.setFreeBbsContent(searchValue);
    } else if(StringUtil.equals(searchType, "3")) {
        search.setUserName(searchValue);
    }
} 

FreeBbsDao freeBbsDao = new FreeBbsDao();
long totalPost = freeBbsDao.freeBbsTotalPost(search);
long curPage = HttpUtil.get(request, "curPage", 1L);

Paging paging = null;
List<FreeBbs> list = null;

if(totalPost > 0) {
    paging = new Paging(totalPost, PageConfig.NUM_OF_PAGE_PER_BLOCK, PageConfig.NUM_OF_POST_PER_PAGE, curPage);
    search.setStartPost(paging.getStartPost());
    search.setEndPost(paging.getEndPost());
    logger.debug(search.getStartPost());
    logger.debug(search.getEndPost());
    list = freeBbsDao.freeBbsList(search);
    logger.debug("list size() : " + list.size());
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/include/header.jsp"%>
<script>
    $(document).ready(function() {
        $("#_searchType").change(function() {
            $("#_searchValue").val("");
        });
        
        $("#btnSearch").on("click", function() {
            if ($("#_searchType").val() === "") {
                Swal.fire({
                    title: "검색항목을 선택하세요",
                    icon: "warning",
                    showCancelButton: true,
                    showConfirmButton: false,
                    cancelButtonColor: "#3085d6",
                    cancelButtonText: "확인"
                });
                
                $("#_searchType").focus();
                return;
            } 
            
            if($.trim($("#_searchValue").val()).length === 0) {
                Swal.fire({
                    title: "검색 값을 입력하세요",
                    icon: "warning",
                    showCancelButton: true,
                    showConfirmButton: false,
                    cancelButtonColor: "#3085d6",
                    cancelButtonText: "확인"
                });
                
                $("#_searchValue").focus();
                return;
            }
            
            $("#searchType").val($("#_searchType").val());
            $("#searchValue").val($("#_searchValue").val());
            $("#curPage").val("");
            document.bbsForm.action = "/bbs/freeList.jsp";
            document.bbsForm.submit();
        });
    
        $("#btnWrite").on("click", function() {
            document.bbsForm.action = "/bbs/freeWrite.jsp";
            document.bbsForm.submit();
        });
    });
    
    function list(curPage) {
        $("#curPage").val(curPage);
        document.bbsForm.action = "/bbs/freeList.jsp";
        document.bbsForm.submit();
    }
    
    function view(freeBbsSeq) {
        $("#freeBbsSeq").val(freeBbsSeq);
        document.bbsForm.action = "/bbs/freeView.jsp";
        document.bbsForm.submit();
    }
</script>
</head>
<body>
<%@ include file="/include/navigation.jsp"%>
<div class="container mt-4">
    <div class="row">
        <!-- 자유 게시판 카드 -->
        <div class="col-md-12">
            <div class="card bg-info text-white mb-3">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h2 class="m-0">자유 게시판</h2>
                    <div class="d-flex align-items-center">
                        <select id="_searchType" class="form-select mx-1" style="max-width: 200px;">
                            <option value="">조회항목</option>
                            <option value="1" <% if (StringUtil.equals(searchType, "1")) { %> selected <% } %>>- 제목</option>
                            <option value="2" <% if (StringUtil.equals(searchType, "2")) { %> selected <% } %>>- 제목 + 내용</option>
                            <option value="3" <% if (StringUtil.equals(searchType, "3")) { %> selected <% } %>>- 작성자</option>
                        </select>
                        <input type="text" name="_searchValue" id="_searchValue" value="<%= searchValue %>" class="form-control mx-1" maxlength="20" placeholder="검색" style="max-width: 400px;" />
                        <button type="button" id="btnSearch" class="btn btn-outline-light mx-1" style="white-space: nowrap;">검색</button>
                    </div>
                </div>
                <div class="card-body d-flex flex-column">
                    <table class="table table-info">
                        <thead class="thead-dark">
                            <tr>
                                <th scope="col" class="text-center" style="width: 10%">번호</th>
                                <th scope="col" class="text-center" style="width: 40%">제목</th>
                                <th scope="col" class="text-center" style="width: 10%">작성자</th>
                                <th scope="col" class="text-center" style="width: 20%">작성일</th>
                                <th scope="col" class="text-center" style="width: 10%">조회수</th>
                                <th scope="col" class="text-center" style="width: 10%">추천</th>
                            </tr>
                        </thead>
                        <tbody>
<%
                        if(list != null && list.size() > 0) {
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
                                    	</a>
                                    	<% } %>
                                    </td>
                                    <td class="text-center"><%= freeBbs.getUserName() %></td>
                                    <td class="text-center"><%= freeBbs.getRegDate() %></td>
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
                        <tfoot>
                            <tr>
                                <td colspan="6"></td>
                            </tr>
                        </tfoot>
                    </table>
                    <div>
                        <ul class="pagination justify-content-center mb-0 w-100">
<%
                        if (paging != null) {
                            if (paging.getPrevBlockPage() != -1) {
%>
                                <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="list(<%= paging.getPrevBlockPage() %>)">&laquo;</a></li>
<%
                            }
                            
                            for (long i = paging.getStartPage(); i <= paging.getEndPage(); i++) {
                                if (i != paging.getCurrentPage()) {
%>
                                    <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="list(<%= i %>)"><%= i %></a></li>
<%  
                                } else {
%>
                                    <li class="page-item active"><a class="page-link" href="javascript:void(0)" style="cursor:default;"><%= i %></a></li>
<% 
                                }
                            }
                            
                            if (paging.getNextBlockPage() != -1) {
%>      
                                <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="list(<%= paging.getNextBlockPage() %>)">&raquo;</a></li>
<%
                            }
                        }
%>
                        </ul>
                    </div>
                </div>
                <div class="card-footer text-end">
                    <button type="button" id="btnWrite" class="btn btn-outline-light"><i class="fa-solid fa-pen-to-square"></i> 글쓰기</button>
                </div>
            </div>
        </div>
    </div>
</div>
<form name="bbsForm" id="bbsForm" action="" method="post">
    <input type="hidden" id="searchType" name="searchType" value="<%= searchType %>">
    <input type="hidden" id="searchValue" name="searchValue" value="<%= searchValue %>">
    <input type="hidden" id="curPage" name="curPage" value="<%= curPage %>">
    <input type="hidden" id="freeBbsSeq" name="freeBbsSeq" value="">
</form>
<%@ include file="/include/footer.jsp"%>
</body>
</html>