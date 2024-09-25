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
	
	// 페이징 처리를 위한 전체 게시글 수 조회 후 반환(검색 조건 반영)
	public long freeBbsTotalPost(FreeBbs search) {
		long totalPost = 0;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		StringBuilder sb = new StringBuilder();
		
		sb.append("SELECT COUNT(A.FREE_BBS_SEQ) CNT ")
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
		sb.append("A.USER_ID = B.USER_ID");
		
		try {
			conn = DBManager.getConnection();
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
			
			rs = ps.executeQuery();
			rs.next();
			totalPost = rs.getLong("CNT");
			
		} catch (SQLException e) {
			logger.error("[FreeBbsDao]freeBbsTotalPost SQLException", e);
		} finally {
			DBManager.close(rs, ps, conn);
		}
		
		return totalPost;
	}
	
	// 자유 게시글 조회(게시글 자세히보기, 삭제, 수정 등에 사용할 쿼리문)
	// 게시글 자세히 보기시에는 삭제 유무에 따른 로직들을 추가하고 싶으므로 게시글 상태를 조회 컬럼에 추가한다.
	public FreeBbs freeBbsSelect(long freeBbsSeq) {
		FreeBbs freeBbs= null;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		StringBuilder sb = new StringBuilder();
		
		sb.append("SELECT A.USER_ID USER_ID, ")
		  .append("NVL(A.FREE_BBS_TITLE, '') FREE_BBS_TITLE, ")
		  .append("NVL(A.FREE_BBS_CONTENT, '') FREE_BBS_CONTENT, ")
		  .append("NVL(A.FREE_BBS_READ_CNT, 0) FREE_BBS_READ_CNT, ")
		  .append("NVL(A.FREE_BBS_RECOM_CNT, 0) FREE_BBS_RECOM_CNT, ")
		  .append("NVL(A.FREE_BBS_STATUS, 'N') FREE_BBS_STATUS, ")
		  .append("NVL(TO_CHAR(A.REG_DATE, 'YYYYMMDD HH24:MI:SS'), '') REG_DATE, ")
		  .append("NVL(A.UPDATE_DATE, '') UPDATE_DATE, ")
		  .append("NVL(B.USER_NAME, '') USER_NAME ")
		  .append("FROM FREE_BBS A, USERS B ")
		  .append("WHERE A.FREE_BBS_SEQ = ? AND ")
		  .append("A.USER_ID = B.USER_ID");
		

		try {
			conn = DBManager.getConnection();
			ps = conn.prepareStatement(sb.toString());
			ps.setLong(1, freeBbsSeq);
			rs = ps.executeQuery();
			
			if(rs.next()) {
				freeBbs = new FreeBbs();
				freeBbs.setFreeBbsSeq(freeBbsSeq);
				freeBbs.setUserId(rs.getString("USER_ID"));
				freeBbs.setFreeBbsTitle(rs.getString("FREE_BBS_TITLE"));
				freeBbs.setFreeBbsContent(rs.getString("FREE_BBS_CONTENT"));
				freeBbs.setFreeBbsReadCnt(rs.getInt("FREE_BBS_READ_CNT"));
				freeBbs.setFreeBbsRecomCnt(rs.getInt("FREE_BBS_RECOM_CNT"));
				freeBbs.setFreeBbsStatus(rs.getString("FREE_BBS_STATUS"));
				freeBbs.setRegDate(rs.getString("REG_DATE"));
				freeBbs.setUpdateDate(rs.getString("UPDATE_DATE"));
				freeBbs.setUserName(rs.getString("USER_NAME"));
			}
		} catch (SQLException e) {
			logger.error("[FreeBbsDao]freeBbsSelect SQLException", e);
		} finally {
			DBManager.close(rs, ps, conn);
		}
		
		return freeBbs;
	}
	
	// 자유 게시글 작성전 SEQ 값 가져오기
	public long nextFreeBbsSeq(Connection conn) {
		long freeBbsSeq = 0;
		PreparedStatement ps = null;
		ResultSet rs = null;
		StringBuilder sb = new StringBuilder();
		
		sb.append("SELECT FREE_BOARD_SEQ.NEXTVAL FROM DUAL");
		
		try {
			ps = conn.prepareStatement(sb.toString());
			rs = ps.executeQuery();
			rs.next();
			freeBbsSeq = rs.getLong(1);
		} catch (SQLException e) {
			logger.error("[FreeBbsDao]nextFreeBbsSeq SQLException", e);
		} finally {
			DBManager.close(rs, ps);
		}
		
		return freeBbsSeq;
	}
	
	// 자유게시글 작성
	public boolean freeBbsInsert(FreeBbs freeBbs) {
		long freeBbsSeq = 0;
		Connection conn = null;
		PreparedStatement ps = null;

		StringBuilder sb = new StringBuilder();
		sb.append("INSERT INTO FREE_BBS(FREE_BBS_SEQ, USER_ID, FREE_BBS_TITLE, FREE_BBS_CONTENT, FREE_BBS_READ_CNT, FREE_BBS_RECOM_CNT, FREE_BBS_STATUS, REG_DATE) ") 
		  .append("VALUES (?, ?, ?, ?, 0, 0, 'Y', SYSDATE)");
		
		int cnt = 0;
		
		try {
			conn = DBManager.getConnection();
			freeBbsSeq = nextFreeBbsSeq(conn);
			ps = conn.prepareStatement(sb.toString());
			
			int idx = 0;
			ps.setLong(++idx, freeBbsSeq);
			ps.setString(++idx, freeBbs.getUserId());
			ps.setString(++idx, freeBbs.getFreeBbsTitle());
			ps.setString(++idx, freeBbs.getFreeBbsContent());
			
			cnt = ps.executeUpdate();
		} catch (SQLException e) {
			logger.error("[FreeBbsDao]freeBbsInsert SQLException", e);
		} finally {
			DBManager.close(ps, conn);
		}
		
		return (cnt == 1) ? true : false;
	}
	
	// 자유 게시글 수정 1 : 게시글 수정
	public boolean freeBbsUpdate(FreeBbs freeBbs) {
		Connection conn = null;
		PreparedStatement ps = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("UPDATE FREE_BBS ")
		  .append("SET BBS_TITLE = ?, BBS_CONTENT = ?, UPDATE_DATE = SYSDATE ")
		  .append("WHERE FREE_BBS_SEQ = ?");
		
		int cnt = 0;
		try {
			conn = DBManager.getConnection();
			ps = conn.prepareStatement(sb.toString());
			
			int idx = 0;
			ps.setString(++idx, freeBbs.getFreeBbsTitle());
			ps.setString(++idx, freeBbs.getFreeBbsContent());
			ps.setLong(++idx, freeBbs.getFreeBbsSeq());
			cnt = ps.executeUpdate();
		} catch (SQLException e) {
			logger.error("[FreeBbsDao]", e);
		} finally {
			DBManager.close(ps, conn);
		}
		
		return (cnt == 1) ? true : false;
		
	}
	
	// 자유 게시글 수정 2 : 게시글 조회수 증가 
	public boolean freeBbsReadCntPlus(long freeBbsSeq) {
		Connection conn = null;
		PreparedStatement ps = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("UPDATE FREE_BBS ")
		  .append("SET FREE_BBS_READ_CNT = FREE_BBS_READ_CNT + 1")
		  .append("WHERE FREE_BBS_SEQ = ?");
		
		int cnt = 0;
		try {
			conn = DBManager.getConnection();
			ps = conn.prepareStatement(sb.toString());
			ps.setLong(1, freeBbsSeq);
			cnt = ps.executeUpdate();
		} catch (SQLException e) {
			logger.error("[FreeBbsDao]", e);
		} finally {
			DBManager.close(ps, conn);
		}
		
		return (cnt == 1) ? true : false;
	}
	
	// 자유 게시글 수정 3 : 게시글 추천수 증가 
	public boolean freeBbsRecomCntPlus(long freeBbsSeq) {
		Connection conn = null;
		PreparedStatement ps = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("UPDATE FREE_BBS ")
		  .append("SET FREE_BBS_RECOM_CNT = FREE_BBS_RECOM_CNT + 1 ")
		  .append("WHERE FREE_BBS_SEQ = ? ");
		
		int cnt = 0;
		try {
			conn = DBManager.getConnection();
			ps = conn.prepareStatement(sb.toString());
			ps.setLong(1, freeBbsSeq);
			cnt = ps.executeUpdate();
		} catch (SQLException e) {
			logger.error("[FreeBbsDao]", e);
		} finally {
			DBManager.close(ps, conn);
		}
		
		return (cnt == 1) ? true : false;
	}
	
	// 자유 게시글 수정 4 : 게시글 삭제('N'으로 변경)
	public boolean freeBbsDelete(long freeBbsSeq) {
		Connection conn = null;
		PreparedStatement ps = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("UPDATE FREE_BBS ")
		  .append("SET FREE_BBS_STATUS = 'N' ")
		  .append("WHERE FREE_BBS_SEQ = ?");
		
		int cnt = 0;
		try {
			conn = DBManager.getConnection();
			ps = conn.prepareStatement(sb.toString());
			ps.setLong(1, freeBbsSeq);
			cnt = ps.executeUpdate();
		} catch (SQLException e) {
			logger.error("[FreeBbsDao]", e);
		} finally {
			DBManager.close(ps, conn);
		}
		
		return (cnt == 1) ? true : false;
	}	
}