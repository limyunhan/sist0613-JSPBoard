package com.sist.web.model;

import java.io.Serializable;

public class FreeBbsCom implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private long freeBbsComSeq; // 댓글 번호
	private long freeBbsSeq; // 게시글 번호
	private String userId; // 사용자 아이디
	private String freeBbsComContent; // 댓글 내용
	private String freeBbsComStatus; // 댓글 상태
	private String regDate; // 등록일
	private Long ref; // 최상위 댓글 번호
	private int reStep; // 그룹 내 댓글 순서
	private int reLevel; // 댓글 깊이
	private long startCom;
	private long endCom;
	
	public long getFreeBbsComSeq() {return freeBbsComSeq;}
	public void setFreeBbsComSeq(long freeBbsComSeq) {this.freeBbsComSeq = freeBbsComSeq;}
	public long getFreeBbsSeq() {return freeBbsSeq;}
	public void setFreeBbsSeq(long freeBbsSeq) {this.freeBbsSeq = freeBbsSeq;}
	public String getUserId() {return userId;}
	public void setUserId(String userId) {this.userId = userId;}
	public String getFreeBbsComContent() {return freeBbsComContent;}
	public void setFreeBbsComContent(String freeBbsComContent) {this.freeBbsComContent = freeBbsComContent;}
	public String getFreeBbsComStatus() {return freeBbsComStatus;}
	public void setFreeBbsComStatus(String freeBbsComStatus) {this.freeBbsComStatus = freeBbsComStatus;}
	public String getRegDate() {return regDate;}
	public void setRegDate(String regDate) {this.regDate = regDate;}
	public Long getRef() {return ref;}
	public void setRef(Long ref) {this.ref = ref;}
	public int getReStep() {return reStep;}
	public void setReStep(int reStep) {this.reStep = reStep;}
	public int getReLevel() {return reLevel;}
	public void setReLevel(int reLevel) {this.reLevel = reLevel;}
	public long getStartCom() {return startCom;}
	public void setStartCom(long startCom) {this.startCom = startCom;}
	public long getEndCom() {return endCom;}
	public void setEndCom(long endCom) {this.endCom = endCom;}
	
	public FreeBbsCom() {
		setFreeBbsComSeq(0);
		setFreeBbsSeq(0);
		setUserId("");
		setFreeBbsComContent("");
		setFreeBbsComStatus("");
		setRegDate("");
		setRef(0L);
		setReStep(0);
		setReLevel(0);
		setStartCom(0);
		setEndCom(0);
	}
}