package com.spring.green2209S_17.service;

public interface ReplyService {

	public int submitReply(String mid, String boardIdx, String rating, String content, String profileImg);

	public double getReplyRatingAvg(String boardIdx);

	public int deleteReply(int idx);

	public int reportReply(int idx, String mid, String reason);

	public void replyNotice(String noticeType, String noticeContent, String noctieMid, String url);
	
}
