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
<%@ page import="com.sist.web.model.PagingCom" %>
<%@ page import="com.sist.web.model.PageComConfig" %>
<% 
Logger logger = LogManager.getLogger("freeView.jsp");
HttpUtil.requestLogString(request, logger);

long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", 0L);
String previousPage = StringUtil.nvl((String)session.getAttribute("previousPage"));
session.removeAttribute("previousPage");

if (freeBbsSeq == 0L) {
    response.sendRedirect("/bbs/freeList.jsp");
} else {
    String cookieUserId = CookieUtil.getValue(request, "USER_ID");
    String searchType = HttpUtil.get(request, "searchType", "");
    String searchValue = HttpUtil.get(request, "searchValue", "");
    long curPage = HttpUtil.get(request, "curPage", 1L);

    FreeBbsDao freeBbsDao = new FreeBbsDao();
    FreeBbs freeBbs = freeBbsDao.freeBbsSelect(freeBbsSeq);
    
    
    if (freeBbs != null && StringUtil.equals(freeBbs.getFreeBbsStatus(), "Y") && !previousPage.contains("Com")) {
        freeBbs.setFreeBbsReadCnt(freeBbsDao.getFreeBbsReadCnt(freeBbsSeq));
    }
   
    FreeBbsComDao freeBbsComDao = new FreeBbsComDao();
    long totalCom = freeBbsComDao.getFreeBbsComCnt(freeBbsSeq);
    long curComPage = HttpUtil.get(request, "curComPage", 1L);
    String freeBbsComContent = HttpUtil.get(request, "freeBbsComContent", "");
    
    PagingCom pagingCom = null;
    List<FreeBbsCom> list = null;
    
    if(totalCom > 0) {
        pagingCom = new PagingCom(totalCom, PageComConfig.NUM_OF_PAGE_PER_BLOCK, PageComConfig.NUM_OF_COM_PER_PAGE, curComPage);
        FreeBbsCom search = new FreeBbsCom();
        search.setFreeBbsSeq(freeBbsSeq);
        search.setStartCom(pagingCom.getStartCom());
        search.setEndCom(pagingCom.getEndCom());
        list = freeBbsComDao.freeBbsComList(search);
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
        	if (!StringUtil.isEmpty(cookieUserId)) {
%>
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
	     
				$("#btnWriteTop").on("click", function() {
					if($.trim($("#_freeBbsComContent").val()).length === 0) {
	                    Swal.fire({
	                        title: "댓글 내용을 입력해주세요",
	                        icon: "warning",
	                        confirmButtonColor: "#3085d6",
	                        confirmButtonText: "확인"
	                    });
	                    return;
					}
					
					var content = $("#_freeBbsComContent").val();
					$("#freeBbsComContent").val(content);
			        document.bbsForm.action = "/bbs/freeWriteTopCom.jsp";
			        document.bbsForm.submit();
				});		
<% 			
			} 
%>

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
                        title: "게시글을 삭제하시겠습니까?",
                        icon: "warning",
                        showCancelButton: true,
                        cancelButtonColor: "#3f51b5",
                        confirmButtonColor: "#3085d6",
                        confirmButtonText: "확인",
                        cancelButtonText: "취소",
                        reverseButtons: true,
                    }).then(result => {
                        if (result.isConfirmed) {
                            document.bbsForm.action = "/bbs/freeDelete.jsp";
                            document.bbsForm.submit();
                        }
                    });
                });
<%
            }
        }
%>
    });
    
    function list(curComPage) {
        $("#curComPage").val(curComPage);
        document.bbsForm.action = "/bbs/freeView.jsp";
        document.bbsForm.submit();
    }
    
    function deleteCom(freeBbsComSeq) {
    	$("#freeBbsComSeq").val(freeBbsComSeq);
    	document.bbsForm.action = "/bbs/freeDeleteCom.jsp";
    	document.bbsForm.submit();
    }
    
    function editCom(freeBbsComSeq, freeBbsComContent) {
    	const $commentCard = $(".card[data-seq='" + freeBbsComSeq + "']");
    	const $contentParagraph = $commentCard.find(".card-text").first();
    	const $buttonsContainer = $commentCard.find(".d-flex");
    	const $existingButtons = $buttonsContainer.find("button").hide();
    	
        const $textarea = $("<textarea>", {
            class: "form-control",
            rows: 3
        }).val(freeBbsComContent); 
        $contentParagraph.replaceWith($textarea);

        const $cancelButton = $("<button>", {
            type: "button",
            class: "btn btn-outline-light btn-sm me-2",
            text: "수정 취소",
            click: function() {
                $textarea.replaceWith($contentParagraph); 
                $cancelButton.remove(); 
                $saveButton.remove(); 
                $existingButtons.show();
            }
        });
        
        const $saveButton = $("<button>", {
            type: "button",
            class: "btn btn-outline-light btn-sm me-2",
            text: "수정 저장",
            click: function() {
                const newContent = $textarea.val();
                $("#freeBbsComContent").val(newContent); 
                $("#freeBbsComSeq").val(freeBbsComSeq); 

                $("form[name='bbsForm']").attr("action", "/bbs/freeUpdateCom.jsp"); 
                $("form[name='bbsForm']").submit();
            }
        });

        $buttonsContainer.append($saveButton);
        $buttonsContainer.append($cancelButton);
    }
    
    function replyCom(freeBbsComSeq) {
        const $commentDiv = $("div[data-seq='" + freeBbsComSeq + "']");
        if ($commentDiv.find(".reply-form").length > 0) {
            return;
        }

        const replyFormHTML = 
            '<div class="reply-form mt-2">' +
                '<textarea class="form-control" name="replyContent" rows="2" placeholder="답글을 작성하세요"></textarea>' +
                '<div class="text-end mt-2">' +  
                    '<button type="button" class="btn btn-outline-light btn-sm me-2" onclick="submitReply(' + freeBbsComSeq + ')">작성</button>' +
                    '<button type="button" class="btn btn-outline-light btn-sm me-2" onclick="cancelReply(this)">취소</button>' +
                '</div>' +
            '</div>';


        $commentDiv.append(replyFormHTML);
    }

    function submitReply(freeBbsComSeq) {
        const $commentDiv = $("div[data-seq='" + freeBbsComSeq + "']");
        const replyContent = $commentDiv.find("textarea[name='replyContent']").val();

        if (replyContent.trim().length === 0) {
            Swal.fire({
                title: "오류",
                text: "답글을 작성하세요",
                icon: "warning",
                confirmButtonColor: "#3085d6",
                confirmButtonText: "확인"
            });
            return;
        }

        $("#freeBbsComContent").val(replyContent);
        $("#freeBbsComSeq").val(freeBbsComSeq);

        document.bbsForm.action = "/bbs/freeWriteSubCom.jsp";
        document.bbsForm.submit();
    }

    function cancelReply(button) {
        const $replyForm = $(button).closest(".reply-form");
        if ($replyForm.length) {
            $replyForm.remove(); 
        }
    }
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
    
    <!-- 버튼 박스 -->
	<div class="d-flex justify-content-end my-3">
	    <button type="button" id="btnList" class="btn btn-secondary me-2">리스트</button>
	    <% if(StringUtil.equals(cookieUserId, freeBbs.getUserId())) { %>
	        <button type="button" id="btnUpdate" class="btn btn-secondary me-2">수정</button>
	        <button type="button" id="btnDelete" class="btn btn-secondary">삭제</button>
	    <% } %>
	</div>
    
    <!-- 댓글 섹션 -->
    <hr>
    <div class="comments-section mt-4">
        <h5>댓글
        <% if (freeBbs.getFreeBbsComCnt() != 0) { %>
        (<span style="color: blue;"><%= StringUtil.toNumberFormat(freeBbs.getFreeBbsComCnt()) %></span>)
		<% } %>
        </h5>
        <!-- 댓글 목록 -->
        
<% 
		if (list != null && list.size() > 0) {
			Iterator<FreeBbsCom> iterator = list.iterator();
			while(iterator.hasNext()) {
				FreeBbsCom freeBbsCom = iterator.next();
%>		
				<div class="position-relative mb-3" style="margin-left: <%= freeBbsCom.getReLevel() * 40 %>px;">
			    <% if (freeBbsCom.getReLevel() != 0) { %> 
			        <i class="fa-solid fa-arrow-right fa-xl" style="position: absolute; top: 50%; left: -30px; transform: translateY(-50%);"></i>
			    <% } %>
				    <div class="card" data-seq="<%= freeBbsCom.getFreeBbsComSeq() %>">
				        <div class="card-body">
				            <% if (StringUtil.equals(freeBbsCom.getFreeBbsComStatus(), "N")) { %>
				                <h6 class="card-title">삭제된 댓글입니다.</h6>
				            <% } else { %>
				                <h6 class="card-title">댓글 작성자: <%= freeBbsCom.getUserName() %></h6>
				                <p class="card-text"><%= StringUtil.replace(freeBbsCom.getFreeBbsComContent(), "\n", "<br>") %></p>
				                <p class="card-text">
				                    <small class="text-muted"><%= freeBbsCom.getRegDate() %></small>
				                </p>
				                <div class="d-flex justify-content-end mt-2">
				                    <% if (!StringUtil.isEmpty(cookieUserId)) { %>
				                        <button type="button" class="btn btn-outline-light btn-sm me-2" onclick="replyCom(<%= freeBbsCom.getFreeBbsComSeq() %>)">답글</button>
				                    <% } %>
				                    <% if (StringUtil.equals(cookieUserId, freeBbsCom.getUserId())) { %>
				                        <button type="button" class="btn btn-outline-light btn-sm me-2" onclick="editCom(<%= freeBbsCom.getFreeBbsComSeq() %>, 
				                        '<%= StringUtil.replace(StringUtil.replace(StringUtil.replace(freeBbsCom.getFreeBbsComContent(), "'", "\\'"), "\n", "\\n"), "\r", "\\r") %>')">수정</button>
				                        <button type="button" class="btn btn-outline-danger btn-sm me-2" onclick="deleteCom(<%= freeBbsCom.getFreeBbsComSeq() %>)">삭제</button>
				                    <% } %>
				                </div>
				            <% } %>
				        </div>
				    </div>
				</div>
				
<%
			}
		} 
%>
		<!-- 댓글 페이징 처리 -->
		<div id="pageContainer">
			<ul class="pagination justify-content-center mb-0 w-100">
<%
			if (pagingCom != null) {
				if (pagingCom.getPrevBlockPage() != -1) {
%>
					<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="list(<%= pagingCom.getPrevBlockPage() %>)">&laquo;</a></li>
<%
				}
                            
				for (long i = pagingCom.getStartPage(); i <= pagingCom.getEndPage(); i++) {
    				if (i != pagingCom.getCurrentPage()) {
%>
						<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="list(<%= i %>)"><%= i %></a></li>
<%  
					} else {
%>
						<li class="page-item active"><a class="page-link" href="javascript:void(0)" style="cursor:default;"><%= i %></a></li>
<%
					}
    			}
				
				if (pagingCom.getNextBlockPage() != -1) {
%>      
					<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="list(<%= pagingCom.getNextBlockPage() %>)">&raquo;</a></li>
<%
				}
			}
%>
			</ul>
		</div>
        <!-- 댓글 작성 폼 -->
        <div class="mb-3 text-end">
            <div class="form-group">
            	<textarea class="form-control" id="_freeBbsComContent" name="_freeBbsComContent" rows="3" placeholder="댓글을 작성하세요"></textarea>
            </div>
            <button type="button" id="btnWriteTop" class="btn btn-primary mt-2">댓글 작성</button>
        </div>
    </div>
</div>
<form name="bbsForm" id="bbsForm" action="" method="post">
	<input type="hidden" name="freeBbsSeq" id="freeBbsSeq" value="<%=freeBbsSeq%>">
	<input type="hidden" name="searchType" id="searchType" value="<%=searchType%>">
	<input type="hidden" name="searchValue" id="searchValue" value="<%=searchValue%>">
	<input type="hidden" name="curPage" id="curPage" value="<%=curPage%>">
	<input type="hidden" name="curComPage" id="curComPage" value="<%=curComPage%>">
	<input type="hidden" name="freeBbsComContent" id="freeBbsComContent" value="<%=freeBbsComContent%>">
	<input type="hidden" name="freeBbsComSeq" id="freeBbsComSeq" value="">
</form>
</body>
</html>
<%
}
%>