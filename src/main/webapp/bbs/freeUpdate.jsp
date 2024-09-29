<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager"%>
<%@ page import="org.apache.logging.log4j.Logger"%>
<%@ page import="com.sist.common.util.StringUtil"%>
<%@ page import="com.sist.web.util.CookieUtil"%>
<%@ page import="com.sist.web.util.HttpUtil"%>
<%@ page import="com.sist.web.dao.FreeBbsDao"%>
<%@ page import="com.sist.web.model.FreeBbs"%>
<%
String cookieUserId = CookieUtil.getValue(request, "USER_ID");
String searchType = HttpUtil.get(request, "searchType", "");
String searchValue = HttpUtil.get(request, "searchValue", "");
String msg = "";
String icon = "warning";

FreeBbs freeBbs = null;
long curPage = HttpUtil.get(request, "curPage", 1L);
long freeBbsSeq = HttpUtil.get(request, "freeBbsSeq", -1L);
boolean flag = true;

if(freeBbsSeq > 0) {
	FreeBbsDao freeBbsDao = new FreeBbsDao();
	freeBbs = freeBbsDao.freeBbsSelect(freeBbsSeq);
	if(freeBbs != null && StringUtil.equals(freeBbs.getFreeBbsStatus(), "Y")) {
		if(StringUtil.equals(cookieUserId, freeBbs.getUserId())) {
			flag = false;
		} else {
			msg = "로그인한 사용자의 게시글이 아닙니다.";
			icon = "error";
		}
	} else {
		msg = "게시글이 존재하지 않습니다.";	
	}
} else {
	msg = "비정상적인 접근입니다.";
}
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/header.jsp" %>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/lang/summernote-ko-KR.min.js"></script>
<style>
	.note-editor {
		border: 2px solid #1e88e5; 
	    border-radius: 5px; 
	    font-family: "GmarketSans"; 
	}
	
	.note-editable {
	    border: 2px solid #1e88e5; 
	    background-color: #f0f5fa; 
	    color: #7B8AB8; 
	    min-height: 500px; 
	    padding: 10px; 
	    border-radius: 5px;
	}
	
	.note-editable:focus {
    	border: 4px solid #abccee;
	}
		
	.note-toolbar {
	    background-color: #f0f5fa;
	    border-radius: 5px; 
	    margin-bottom: 5px; 
	}
</style>
<script>
	$(document).ready(function() {
<%
		if (flag) {
%>
			Swal.fire({
				title: "<%= msg %>",
				icon: "<%= icon %>",
				confirmButtonColor: "#3085d6",
				confirmButtonText: "확인",
				}).then(result => {
				if (result.isConfirmed) {      
					document.bbsForm.submit();
				}
			});
<%
		} else {
%>
		$("#freeBbsTitle").focus();
		$("#freeBbsContent").summernote({
			lang: 'ko-KR',
			toolbar: [
				["insert", ['picture']],
	            ["fontname", ["fontname"]],
	            ["fontsize", ["fontsize"]],
	            ["color", ["color"]],
	            ["style", ["style"]],
	            ["font", ["strikethrough", "superscript", "subscript"]],
	            ["table", ["table"]],
	        	["para", ["ul", "ol", "paragraph"]],
	        	["height", ["height"]],
	    	],
	    	fontNames: ['GmarketSans', 'Nanum Gothic', 'Noto Sans KR', 'Spoqa Han Sans'],
	    	fontNamesIgnoreCheck: ['GmarketSans', 'Nanum Gothic', 'Noto Sans KR', 'Spoqa Han Sans'], 
		});
		
		$("#btnList").on("click", function(){
			document.bbsForm.action = "/bbs/freeList.jsp";
			document.bbsForm.submit();
		});
		
		$("#btnUpdate").on("click", function() {
			if ($.trim($("#freeBbsTitle").val()).length === 0) { 
				Swal.fire({
					title: "제목을 입력해주세요.",
				 	icon: "warning",
				 	showCancelButton: true,
				    showConfirmButton: false,
				    cancelButtonColor: "#3085d6",
				    cancelButtonText: "확인"
				});
			} else if ($.trim($("#freeBbsContent").val()).length === 0) {
				Swal.fire({
					title:"내용을 입력해주세요.",
					icon: "warning",
				 	showCancelButton: true,
				    showConfirmButton: false,
				    cancelButtonColor: "#3085d6",
				    cancelButtonText: "확인"
				});
			} else {
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
			}
		});  
<%
		}
%>
	});
</script>
</head>
<body>
<% if (!flag) { %>
<%@ include file="/include/navigation.jsp" %>

<div class="container">
   <br>
   <h2>자유 게시물 수정</h2>
   <form name="updateForm" id="updateForm" action="/bbs/freeUpdateProc.jsp" method="post">
      <input type="text" name="freeBbsTitle" id="freeBbsTitle" maxlength="100" style="ime-mode:active;" value="<%= freeBbs.getFreeBbsTitle() %>" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
      <div class="form-group">
         <textarea class="form-control" name="freeBbsContent" id="freeBbsContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required><%= freeBbs.getFreeBbsContent() %></textarea>
      </div>
       <input type="hidden" name="freeBbsSeq" value="<%=freeBbsSeq%>"/>
      <input type="hidden" name="searchType" value="<%=searchType%>"/>
      <input type="hidden" name="searchValue" value="<%=searchValue%>"/>
      <input type="hidden" name="curPage" value="<%=curPage%>"/>
   </form>
   
   <div class="form-group row">
      <div class="col-sm-12">
         <div class="d-flex justify-content-end mt-4">
         <button type="button" id="btnUpdate" class="btn btn-outline-primary"  title="수정"><i class="fa-sharp-duotone fa-solid fa-file-pen"></i> 수정</button>       
         <button type="button" id="btnList" class="btn btn-outline-primary" style=" position: relative; left: 10px;"title="리스트"><i class="fa-sharp-duotone fa-solid fa-list"></i> 리스트</button>
         </div>
        </div>
   </div>
</div>
<form name="bbsForm" method="post"> 
   <input type="hidden" name="freeBbsSeq" value="<%=freeBbsSeq%>"/>
   <input type="hidden" name="searchType" value="<%=searchType%>"/>
   <input type="hidden" name="searchValue" value="<%=searchValue%>"/>
   <input type="hidden" name="curPage" value="<%=curPage%>"/>
</form>
<%@ include file="/include/footer.jsp" %>
<% } %>
</body>
</html>