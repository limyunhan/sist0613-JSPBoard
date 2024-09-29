package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;
import com.sist.web.model.FreeBbsCom;

public class FreeBbsComDao {
	private static Logger logger = LogManager.getLogger(FreeBbsComDao.class);

	public static Logger getLogger() {return logger;}
	public static void setLogger(Logger logger) {FreeBbsComDao.logger = logger;}
	
	// 댓글 계층 구조 적용한채로 리스트로 가져오기
	public List<FreeBbsCom> freeBbsComList(long freeBbsSeq, int startCom, int endCom) {
		List<FreeBbsCom> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT FREE_BBS_COM_SEQ, FREE_BBS_SEQ, USER_ID, FREE_BBS_COM_CONTENT, FREE_BBS_COM_STATUS, REG_DATE, REF, RE_STEP, RE_LEVEL ")
		  .append("FROM ( ")
		  	.append("SELECT ROWNUM NUM, FREE_BBS_COM_SEQ, FREE_BBS_SEQ, USER_ID, FREE_BBS_COM_CONTENT, FREE_BBS_COM_STATUS, REG_DATE, REF, RE_STEP, RE_LEVEL ")
		  		.append("FROM ( ")
		  			.append("SELECT FREE_BBS_COM_SEQ, ")
		  				.append("FREE_BBS_SEQ, ")
		  				.append("NVL(USER_ID, '') USER_ID, ")
		  				.append("NVL(FREE_BBS_COM_CONTENT, '') FREE_BBS_COM_CONTENT, ")
		  				.append("NVL(FREE_BBS_COM_STATUS, 'N') FREE_BBS_COM_STATUS, ")
		  				.append("NVL(TO_CHAR(REG_DATE, 'YYYY-MM-DD HH24:MI:SS'), '') REG_DATE, ")
		  				.append("NVL(REF, 0) REF, ")
		  				.append("NVL(RE_STEP, 0) RE_STEP, ")
		  				.append("NVL(RE_LEVEL, 0) RE_LEVEL ")
				.append("FROM FREE_BBS_COM ")
				.append("WHERE FREE_BBS_SEQ = ? ")
				.append("ORDER BY REF, RE_STEP ")
			.append(") ")
		.append(") ")
		.append("WHERE NUM BETWEEN ? AND ?"); 
		

		try {
			conn = DBManager.getConnection();
			ps = conn.prepareStatement(sb.toString());
			
			int idx = 0;
			ps.setLong(++idx, freeBbsSeq);
			ps.setLong(++idx, startCom);
			ps.setLong(++idx, endCom);
			rs = ps.executeQuery();
			
			while (rs.next()) {
				FreeBbsCom freeBbsCom = new FreeBbsCom();
		        freeBbsCom.setFreeBbsComSeq(rs.getLong("FREE_BBS_COM_SEQ"));
		        freeBbsCom.setFreeBbsSeq(rs.getLong("FREE_BBS_SEQ"));
		        freeBbsCom.setUserId(rs.getString("USER_ID"));
		        freeBbsCom.setFreeBbsComContent(rs.getString("FREE_BBS_COM_CONTENT"));
		        freeBbsCom.setFreeBbsComStatus(rs.getString("FREE_BBS_COM_STATUS"));
		        freeBbsCom.setRegDate(rs.getString("REG_DATE"));
		        freeBbsCom.setRef(rs.getLong("REF"));
		        freeBbsCom.setReStep(rs.getInt("RE_STEP"));
		        freeBbsCom.setReLevel(rs.getInt("RE_LEVEL"));
		        list.add(freeBbsCom);
			}
		} catch (SQLException e) {
			logger.error("[FreeBbsComDao]freeBbsComList SQLException", e);
		} finally {
			DBManager.close(rs, ps, conn);
		}
		
		return list;
	}
	
	// 댓글 번호 가져오기
	public long nextFreeBbsComSeq(Connection conn) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT FREE_BBS_COM_SEQ.NEXTVAL FROM DUAL ");
		
		long freeBbsComSeq = 0;
		
		try {
			ps = conn.prepareStatement(sb.toString());
			rs = ps.executeQuery();
			rs.next();
			freeBbsComSeq = rs.getLong(1);
		} catch (SQLException e) {
			logger.error("[FreeBBsComDao]nextFreeBbsComSeq SQLException", e);
		} finally {
			DBManager.close(rs, ps);
		}
		
		return freeBbsComSeq;
	}
	
	
	// 최상위 댓글 작성 쿼리
	public boolean topFreeBbsComInsert(FreeBbsCom freeBbsCom) {
		long freeBbsComSeq = 0;
		Connection conn = null;
		PreparedStatement ps = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("INSERT INTO FREE_BBS_COM (FREE_BBS_COM_SEQ, FREE_BBS_SEQ, USER_ID, FREE_BBS_COM_CONTENT, FREE_BBS_COM_STATUS, REG_DATE, REF, RE_STEP, RE_LEVEL) ") 
		  .append("VALUES (?, ?, ?, ?, 'Y', SYSDATE, ?, 0, 0 )");
		
		int cnt = 0;
		try {
			conn = DBManager.getConnection();
			freeBbsComSeq = nextFreeBbsComSeq(conn);
			ps = conn.prepareStatement(sb.toString());
		
			int idx = 0;
			ps.setLong(++idx, freeBbsComSeq);
			ps.setLong(++idx, freeBbsCom.getFreeBbsSeq());
			ps.setString(++idx, freeBbsCom.getUserId());
			ps.setString(++idx, freeBbsCom.getFreeBbsComContent());
			ps.setLong(++idx, freeBbsComSeq); // REF는 자기자신
			cnt = ps.executeUpdate();
		} catch (SQLException e) {
			logger.error("[FreeBbsComDao]topFreeBbsComInsert SQLException", e);
		} finally {
			DBManager.close(ps, conn);
		}
		
		return (cnt == 1);
	}
	
	// 대댓글 작성 쿼리, 부모 댓글의 ref, re_step, re_level을 추가적으로 전달받음
	public boolean subFreeBbsComInsert(FreeBbsCom freeBbsCom) {
		long freeBbsComSeq = 0;
	    Connection conn = null;
	    PreparedStatement ps = null;

	    StringBuilder sb = new StringBuilder();
	    sb.append("INSERT INTO FREE_BBS_COM (FREE_BBS_COM_SEQ, FREE_BBS_SEQ, USER_ID, FREE_BBS_COM_CONTENT, FREE_BBS_COM_STATUS, REG_DATE, REF, RE_STEP, RE_LEVEL) ")
	      .append("VALUES (?, ?, ?, ?, 'Y', SYSDATE, ?, ?, ?)");

	    int cnt = 0;
	    try {
	        conn = DBManager.getConnection();
	        freeBbsComSeq = nextFreeBbsComSeq(conn);

	        // 대댓글을 추가하기 전에 RE_STEP을 증가시켜서 댓글 순서를 맞춰야 한다.
	        updateReStep(conn, freeBbsCom.getRef(), freeBbsCom.getReStep());

	        ps = conn.prepareStatement(sb.toString());

	        int idx = 0;
	        ps.setLong(++idx, freeBbsComSeq);
	        ps.setLong(++idx, freeBbsCom.getFreeBbsSeq());
	        ps.setString(++idx, freeBbsCom.getUserId());
	        ps.setString(++idx, freeBbsCom.getFreeBbsComContent());
	        ps.setLong(++idx, freeBbsCom.getRef());        // REF는 부모 댓글의 REF와 동일
	        ps.setInt(++idx, freeBbsCom.getReStep() + 1);  // RE_STEP은 부모 댓글보다 1 증가
	        ps.setInt(++idx, freeBbsCom.getReLevel() + 1); // RE_LEVEL은 부모 댓글보다 1 증가

	        cnt = ps.executeUpdate();
	    } catch (SQLException e) {
	        logger.error("[FreeBbsComDao]subFreeBbsComInsert SQLException", e);
	    } finally {
	        DBManager.close(ps, conn);
	    }

	    return (cnt == 1);
	}

	// RE_STEP을 업데이트하여 대댓글의 순서를 유지
	private void updateReStep(Connection conn, long ref, int reStep) {
		PreparedStatement ps = null;
		StringBuilder sb = new StringBuilder();
		sb.append("UPDATE FREE_BBS_COM SET RE_STEP = RE_STEP + 1 WHERE REF = ? AND RE_STEP > ?");
		
		try {
	        ps = conn.prepareStatement(sb.toString());
	        
	        int idx = 0;
	        ps.setLong(++idx, ref);
	        ps.setInt(++idx, reStep);
	        ps.executeUpdate();
	    } catch (SQLException e) {
	    	logger.error("[FreeBbsComDao]updateReStep SQLException", e);
	    } finally {
	        DBManager.close(ps);
	    }
	}
	
	// 댓글 수정 쿼리
	public boolean updateFreeBbsCom(FreeBbsCom freeBbsCom) {
	    Connection conn = null;
	    PreparedStatement ps = null;

	    StringBuilder sb = new StringBuilder();
	    sb.append("UPDATE FREE_BBS_COM SET ")
	      .append("FREE_BBS_COM_CONTENT = ? ")
	      .append("WHERE FREE_BBS_COM_SEQ = ?"); 

	    int cnt = 0;
	    try {
	        conn = DBManager.getConnection();
	        ps = conn.prepareStatement(sb.toString());

	        int idx = 0;
	        ps.setString(++idx, freeBbsCom.getFreeBbsComContent());
	        ps.setLong(++idx, freeBbsCom.getFreeBbsComSeq());

	        cnt = ps.executeUpdate();
	    } catch (SQLException e) {
	        logger.error("[FreeBbsComDao]updateFreeBbsCom SQLException", e);
	    } finally {
	        DBManager.close(ps, conn);
	    }

	    return (cnt == 1); 
	}

	// 댓글 삭제 쿼리 (status를 'N'으로 변경)
	public boolean deleteFreeBbsCom(long freeBbsComSeq) {
	    Connection conn = null;
	    PreparedStatement ps = null;

	    StringBuilder sb = new StringBuilder();
	    sb.append("UPDATE FREE_BBS_COM SET ")
	      .append("FREE_BBS_COM_STATUS = 'N' ")
	      .append("WHERE FREE_BBS_COM_SEQ = ?");

	    int cnt = 0;
	    
	    try {
	        conn = DBManager.getConnection();
	        ps = conn.prepareStatement(sb.toString());
	        ps.setLong(1, freeBbsComSeq); // 삭제할 댓글의 시퀀스 설정
	        cnt = ps.executeUpdate();
	    } catch (SQLException e) {
	        logger.error("[FreeBbsComDao]deleteFreeBbsCom SQLException", e);
	    } finally {
	        DBManager.close(ps, conn);
	    }

	    return (cnt == 1); // 삭제 성공 시 true 반환
	}	
	
	// 
}