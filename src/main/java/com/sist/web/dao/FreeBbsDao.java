package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.common.util.StringUtil;
import com.sist.web.db.DBManager;
import com.sist.web.model.FreeBbs;

public class FreeBbsDao {
	private static Logger logger = LogManager.getLogger(FreeBbsDao.class);

	public static Logger getLogger() {return logger;}
	public static void setLogger(Logger logger) {FreeBbsDao.logger = logger;}
	
	// 자유 게시글 리스트 조회(페이징 처리)
	public List<FreeBbs> freeBbsList(FreeBbs search) {
		List<FreeBbs> list = null;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT FREE_BBS_SEQ, USER_ID, FREE_BBS_TITLE, FREE_BBS_CONTENT, FREE_BBS_READ_CNT, FREE_BBS_RECOM_CNT, REG_DATE, UPDATE_DATE, USER_NAME ")
		  .append("FROM ( ")
		      .append("SELECT ROWNUM NUM, FREE_BBS_SEQ, USER_ID, FREE_BBS_TITLE, FREE_BBS_CONTENT, FREE_BBS_READ_CNT, FREE_BBS_RECOM_CNT, REG_DATE, UPDATE_DATE, USER_NAME ")
		      .append("FROM ( ")
		          .append("SELECT ")
		              .append("A.FREE_BBS_SEQ FREE_BBS_SEQ, ")
		              .append("A.USER_ID USER_ID, ")
		              .append("NVL(A.FREE_BBS_TITLE, '') FREE_BBS_TITLE, ")
		              .append("NVL(A.FREE_BBS_CONTENT, '') FREE_BBS_CONTENT, ")
		              .append("NVL(A.FREE_BBS_READ_CNT, 0) FREE_BBS_READ_CNT, ")
		              .append("NVL(A.FREE_BBS_RECOM_CNT, 0) FREE_BBS_RECOM_CNT, ")
		              .append("NVL(TO_CHAR(A.REG_DATE, 'YYYYMMDD HH24:MI:SS'), '') REG_DATE, ")
		              .append("NVL(B.USER_NAME, '') USER_NAME ")
		          .append("FROM FREE_BBS A, USERS B ")
		          .append("WHERE A.FREE_BBS_STATUS <> 'N' AND ");
		
		if(search != null) {
			if(!StringUtil.isEmpty(search.getFreeBbsContent()) && !StringUtil.isEmpty(search.getFreeBbsTitle())) {
				sb.append("(A.FREE_BBS_TITLE LIKE '%' || ? || '%' OR DBMS_LOB.INSTR(A.FREE_BBS_CONTENT, ?) > 0) AND ");
			} else if(!StringUtil.isEmpty(search.getFreeBbsTitle())) {
				sb.append("A.FREE_BBS_TITLE LIKE '%' || ? || '%' AND ");
			} else if(!StringUtil.isEmpty(search.getUserName())) {
			    sb.append("B.USER_NAME LIKE '%' || ? || '%' AND ");
			}
		}
		            sb.append("A.USER_ID = B.USER_ID ") 
		          .append("ORDER BY A.FREE_BBS_SEQ DESC ")
		      .append(") ") 
		  .append(") ")
		  .append("WHERE NUM BETWEEN ? AND ?");
		
		conn = DBManager.getConnection();
		try {
			ps = conn.prepareStatement(sb.toString());
			
			int idx = 0;
			
			if(search != null) {
				if(!StringUtil.isEmpty(search.getFreeBbsContent()) && !StringUtil.isEmpty(search.getFreeBbsTitle())) {
					ps.setString(++idx, search.getFreeBbsTitle());
					ps.setString(++idx, search.getFreeBbsContent());
				} else if(!StringUtil.isEmpty(search.getFreeBbsTitle())) {
					ps.setString(++idx, search.getFreeBbsTitle());
				} else if(!StringUtil.isEmpty(search.getUserName())) {
				    ps.setString(++idx, search.getUserName());
				}
			}
			
			ps.setLong(++idx, search.getStartPost());
			ps.setLong(++idx, search.getEndPost());
			rs = ps.executeQuery();
			
			// rs.next()가 있을 때 list를 할당하고 싶으므로 if + do ~ while문으로 대체한다.
			if(rs.next()) list = new ArrayList<>();
			
			do {
				FreeBbs freeBbs = new FreeBbs();
				freeBbs.setFreeBbsSeq(rs.getLong("FREE_BBS_SEQ"));
				freeBbs.setUserId(rs.getString("USER_ID"));
				freeBbs.setFreeBbsTitle(rs.getString("FREE_BBS_TITLE"));
				freeBbs.setFreeBbsContent(rs.getString("FREE_BBS_CONTENT"));
				freeBbs.setFreeBbsReadCnt(rs.getInt("FREE_BBS_READ_CNT"));
				freeBbs.setFreeBbsRecomCnt(rs.getInt("FREE_BBS_RECOM_CNT"));
				freeBbs.setFreeBbsStatus("Y");
				freeBbs.setRegDate(rs.getString("REG_DATE"));
				freeBbs.setUserName(rs.getString("USER_NAME"));
				list.add(freeBbs);
				
			} while(rs.next());
			
		} catch (SQLException e) {
			logger.error("[FreeBbsDao]freeBbsList SQLException", e);
		} finally {
			DBManager.close(rs, ps, conn);
		}
		
		return list;
	}
}
