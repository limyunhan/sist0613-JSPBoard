package com.sist.web.model;

import java.io.Serializable;

public class PagingCom implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private long totalBlock; // 총 블록의 수
	private long currentBlock; // 현재 블록

	private long totalPage; // 총 페이지의 수
	private long currentPage; // 현재 페이지
	private long startPage; // 현재 블록의 startPage
	private long endPage; // 현재 블록의 endPage
	private long prevBlockPage; // 이전 블록의 endPage
	private long nextBlockPage; // 다음 블록의 startPage
	private int numOfPagePerBlock; // 블록당 페이지 수

	private long totalCom; // 총 댓글의 수
	private long startCom; // 현재 페이지 내에서의 시작 댓글의 row num
	private long endCom; // 현재 페이지 내에서의 끝 댓글의 row num
	private int numOfComPerPage; // 페이지당 댓글 수
	
	public long getTotalBlock() {return totalBlock;}
	public void setTotalBlock(long totalBlock) {this.totalBlock = totalBlock;}
	public long getCurrentBlock() {return currentBlock;}
	public void setCurrentBlock(long currentBlock) {this.currentBlock = currentBlock;}
	public long getTotalPage() {return totalPage;}
	public void setTotalPage(long totalPage) {this.totalPage = totalPage;}
	public long getCurrentPage() {return currentPage;}
	public void setCurrentPage(long currentPage) {this.currentPage = currentPage;}
	public long getStartPage() {return startPage;}
	public void setStartPage(long startPage) {this.startPage = startPage;}
	public long getEndPage() {return endPage;}
	public void setEndPage(long endPage) {this.endPage = endPage;}
	public long getPrevBlockPage() {return prevBlockPage;}
	public void setPrevBlockPage(long prevBlockPage) {this.prevBlockPage = prevBlockPage;}
	public long getNextBlockPage() {return nextBlockPage;}
	public void setNextBlockPage(long nextBlockPage) {this.nextBlockPage = nextBlockPage;}
	public int getNumOfPagePerBlock() {return numOfPagePerBlock;}
	public void setNumOfPagePerBlock(int numOfPagePerBlock) {this.numOfPagePerBlock = numOfPagePerBlock;}
	public long getTotalCom() {return totalCom;}
	public void setTotalCom(long totalCom) {this.totalCom = totalCom;}
	public long getStartCom() {return startCom;}
	public void setStartCom(long startCom) {this.startCom = startCom;}
	public long getEndCom() {return endCom;}
	public void setEndCom(long endCom) {this.endCom = endCom;}
	public int getNumOfComPerPage() {return numOfComPerPage;}
	public void setNumOfComPerPage(int numOfComPerPage) {this.numOfComPerPage = numOfComPerPage;}
	
	public PagingCom(long totalCom, int numOfPagePerBlock, int numOfComPerPage, long currentPage) {
		setTotalCom(totalCom);
		setNumOfPagePerBlock(numOfPagePerBlock);
		setNumOfComPerPage(numOfComPerPage);
		setCurrentPage(currentPage);
		
		if(totalCom > 0) {
			pagingProc();
		}
	}

	public void pagingProc() {
		totalPage = ((totalCom - 1) / numOfComPerPage) + 1;
		totalBlock = ((totalPage - 1) / numOfPagePerBlock) + 1;
		currentBlock = ((currentPage - 1) / numOfPagePerBlock) + 1;

		startPage = (currentBlock - 1) * numOfPagePerBlock + 1;
		endPage = (startPage + numOfPagePerBlock - 1 > totalPage) ? totalPage : startPage + numOfPagePerBlock - 1;
		prevBlockPage = (currentBlock > 1) ? startPage - 1 : -1;
		nextBlockPage = (currentBlock < totalBlock) ? endPage + 1 : -1;

		startCom = (currentPage - 1) * numOfComPerPage + 1;
		endCom = (startCom + numOfComPerPage - 1 > totalCom) ? totalCom : startCom + numOfComPerPage - 1;
	}
}