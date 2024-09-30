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
if (freeBbsSeq == 0L) {
    response.sendRedirect("/bbs/freeList.jsp");
} else {
    String cookieUserId = CookieUtil.getValue(request, "USER_ID");
    String searchType = HttpUtil.get(request, "searchType", "");
    String searchValue = HttpUtil.get(request, "searchValue", "");
    long curPage = HttpUtil.get(request, "curPage", -1L);

    FreeBbsDao freeBbsDao = new FreeBbsDao();
    FreeBbs freeBbs = freeBbsDao.freeBbsSelect(freeBbsSeq);
    
    // 여기가 문제
    if (freeBbs != null && StringUtil.equals(freeBbs.getFreeBbsStatus(), "Y")) {
        freeBbs.setFreeBbsReadCnt(freeBbsDao.getFreeBbsReadCnt(freeBbsSeq));
    }
   
    FreeBbsComDao freeBbsComDao = new FreeBbsComDao();
    long totalCom = freeBbsComDao.getFreeBbsComCnt(freeBbsSeq);
    long curComPage = HttpUtil.get(request, "curComPage", 1L);
    String freeBbsComContent = HttpUtil.get(request, "freeBbsComContent", "");
    
    PagingCom pagingCom = null;
    List<FreeBbsCom> list = null;
    
    if(totalCom > 0) {
        pagingCom = new PagingCom(totalCom, PageComConfig.NUM_OF_PAGE_PER_BLOCK, PageComConfig.NUM_OF_COM_PER_PAGE, curPage);
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
				
				$("#freeBbsComContent").val($("#_freeBbsComContent").val());
		        document.bbsForm.action = "/bbs/freeWriteTopCom.jsp";
		        document.bbsForm.submit();
			});

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
    
    function list(curComPage) {
        $("#curComPage").val(curComPage);
        document.bbsForm.action = "/bbs/freeView.jsp";
        document.bbsForm.submit();
    }
    
    function replyCom(freeBbsComSeq) {
    	
    	
    	
    }
    
    function editCom(comSeq, content) {
        const commentCard = document.querySelector(`.card[data-seq='${comSeq}']`);
        const contentParagraph = commentCard.querySelector('.card-text');
        const buttonsContainer = commentCard.querySelector('.d-flex');

        // 텍스트 영역 생성
        const textarea = document.createElement('textarea');
        textarea.className = 'form-control';
        textarea.rows = 3;
        textarea.value = content;

        // 기존 콘텐츠를 텍스트 영역으로 교체
        contentParagraph.replaceWith(textarea);

        // 수정 취소 버튼 생성
        const cancelButton = document.createElement('button');
        cancelButton.type = 'button';
        cancelButton.className = 'btn btn-outline-secondary btn-sm me-2';
        cancelButton.textContent = '수정 취소';
        cancelButton.onclick = function() {
            textarea.replaceWith(contentParagraph); // 기존 내용으로 복구
            cancelButton.remove(); // 취소 버튼 제거
            saveButton.remove(); // 저장 버튼 제거
        };

        // 수정 저장 버튼 생성
        const saveButton = document.createElement('button');
        saveButton.type = 'button';
        saveButton.className = 'btn btn-primary btn-sm';
        saveButton.textContent = '수정 저장';
        saveButton.onclick = function() {
            const newContent = textarea.value;

            // hidden 필드에 수정할 댓글 내용 설정
            document.getElementById('freeBbsComContent').value = newContent; // 히든 필드에 내용 설정
            document.getElementById('freeBbsComSeq').value = comSeq; // 댓글 시퀀스 설정

            // 폼 제출
            document.bbsForm.action = '/path/to/update/comment'; // 실제 URL로 수정
            document.bbsForm.submit();
        };

        // 버튼을 추가
        buttonsContainer.appendChild(saveButton);
        buttonsContainer.appendChild(cancelButton);
    }

    function deleteCom(freeBbsComSeq) {
    	$("#freeBbsComSeq").val(freeBbsComSeq);
    	document.bbsForm.action = "/bbs/freeDeleteCom.jsp";
    	document.bbsForm.submit();
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
    <!-- 댓글 섹션 -->
    <hr>
    <div class="comments-section mt-4">
        <h5>댓글
        <% if (freeBbs.getFreeBbsComCnt() != 0) { %>
        (<span style="color: blue;"><%= StringUtil.toNumberFormat(freeBbs.getFreeBbsComCnt()) %></span>)
		<% } %>
        </h5>
        <!-- 댓글 목록 -->
        <div id="commentsContainer">
<% 
			if (list != null && list.size() > 0) {
				Iterator<FreeBbsCom> iterator = list.iterator();
				while(iterator.hasNext()) {
					FreeBbsCom freeBbsCom = iterator.next();
%>
	            	<div class="card mb-3" style="margin-left: <%= freeBbsCom.getReLevel() * 20 %>px;">
	                	<div class="card-body">
<%
						if (StringUtil.equals(freeBbsCom.getFreeBbsComStatus(), "N")) {
%>
							<h6 class="card-title">삭제된 댓글입니다.</h6>
<%
						} else {
%>
	                    	<h6 class="card-title">댓글 작성자: <%= freeBbsCom.getUserName() %></h6>
	                    	<p class="card-text"><%= freeBbsCom.getFreeBbsComContent() %></p>
	                    	<p class="card-text">
	                        	<small class="text-muted"><%= freeBbsCom.getRegDate() %></small>
	                    	</p>
	                    	<div class="d-flex justify-content-end mt-2">
	                    		<button type="button" class="btn btn-outline-light btn-sm me-2" onclick="replyCom(<%= freeBbsCom.getFreeBbsComSeq() %>)">답글</button>
<%
								if (StringUtil.equals(cookieUserId, freeBbsCom.getUserId())) {
%>
									<button type="button" class="btn btn-outline-light btn-sm me-2" onclick="editCom(<%= freeBbsCom.getFreeBbsComSeq() %>, '<%= freeBbsCom.getFreeBbsComContent() %>')">수정</button>
						        	<button type="button" class="btn btn-outline-danger btn-sm" onclick="deleteCom(<%= freeBbsCom.getFreeBbsComSeq() %>)">삭제</button>
<%
								}
						}
%>
							</div>
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