package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;

public class FreeBbsRecomDao {
	private static Logger logger = LogManager.getLogger(FreeBbsRecomDao.class);

	public static Logger getLogger() {return logger;}
	public static void setLogger(Logger logger) {FreeBbsRecomDao.logger = logger;}
	
	// 게시글을 추천할 수 있는지 여부 가져오기
	public boolean isValid(String userId, long freeBbsSeq) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT COUNT(*) CNT ")
		  .append("FROM FREE_BBS_RECOM ")
		  .append("WHERE USER_ID = ? AND FREE_BBS_SEQ = ?");
		
		int cnt = 0;
		
		try {
			conn = DBManager.getConnection();
			ps = conn.prepareStatement(sb.toString());
			ps.setString(1, userId);
			ps.setLong(2, freeBbsSeq);
			rs = ps.executeQuery();
			rs.next();
			cnt = rs.getInt("CNT");
		} catch (SQLException e) {
			logger.error("[FreeBbsRecomDao]isRecomValid SQLException", e);
		} finally {
			DBManager.close(rs, ps, conn);
		}
				
		return (cnt == 0);
	}
	
	public int getFreeBbsRecomCnt(long freeBbsSeq) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT COUNT(*) CNT ")
		  .append("FROM FREE_BBS_RECOM ")
		  .append("WHERE FREE_BBS_SEQ = ?");
		
		int cnt = 0;
		
		try {
			conn = DBManager.getConnection();
			ps = conn.prepareStatement(sb.toString());
			ps.setLong(1, freeBbsSeq);
			rs = ps.executeQuery();
			if(rs.next()) {
				cnt = rs.getInt("CNT");
			}
		} catch (SQLException e) {
			logger.error("[FreeBbsRecomDao]getFreeBbsRecomCnt SQLException", e);
		} finally {
			DBManager.close(rs, ps, conn);
		}
				
		return cnt;
	}
	

	// 게시글 추천수 증가 
	public boolean freeBbsRecomInsert(String userId, long freeBbsSeq) {
		Connection conn = null;
		PreparedStatement ps = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("INSERT INTO FREE_BBS_RECOM(USER_ID, FREE_BBS_SEQ, RECOM_DATE) ")
		  .append("VALUES(?, ?, SYSDATE) ");
		
		int cnt = 0;
		
		try {
			conn = DBManager.getConnection();
			ps = conn.prepareStatement(sb.toString());
			ps.setString(1, userId);
			ps.setLong(2, freeBbsSeq);
			cnt = ps.executeUpdate();
		} catch (SQLException e) {
			logger.error("[FreeBbsRecomDao]freeBbsRecomInsert SQLException", e);
		} finally {
			DBManager.close(ps, conn);
		}
		
		return (cnt == 1);
		
	}
	
	// 게시물 추천수 감소
	public boolean freeBbsRecomDelete(String userId, long freeBbsSeq) {
		Connection conn = null;
		PreparedStatement ps = null;
		
		StringBuilder sb = new StringBuilder();
		sb.append("DELETE FROM FREE_BBS_RECOM WHERE USER_ID = ? AND FREE_BBS_SEQ = ? ");
		
		int cnt = 0;
		
		try {
			conn = DBManager.getConnection();
			ps = conn.prepareStatement(sb.toString());
			ps.setString(1, userId);
			ps.setLong(2, freeBbsSeq);
			cnt = ps.executeUpdate();
		} catch (SQLException e) {
			logger.error("[FreeBbsRecomDao]freeBbsRecomDelete SQLException", e);
		} finally {
			DBManager.close(ps, conn);
		}
		
		return (cnt == 1);
	}
}