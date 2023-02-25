package com.spring.green2209S_17.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.green2209S_17.dao.NoticeDAO;
import com.spring.green2209S_17.dao.ReplyDAO;
import com.spring.green2209S_17.vo.NoticeVO;

@Service
public class ReplyServiceImpl implements ReplyService {
	
	@Autowired
	ReplyDAO replyDAO;
	
	@Autowired
	NoticeDAO noticeDAO;
	
	@Override
	public int submitReply(String mid, String boardIdx, String rating, String content, String profileImg) {
		return replyDAO.submitReply(mid,boardIdx,rating,content,profileImg);
	}

	@Override
	public double getReplyRatingAvg(String boardIdx) {
		return replyDAO.getReplyRatingAvg(boardIdx);
	}

	@Override
	public int deleteReply(int idx) {
		return replyDAO.deleteReply(idx);
	}

	@Override
	public int reportReply(int idx, String mid, String reason) {
		return replyDAO.reportReply(idx, mid,reason);
	}

	@Override
	public void replyNotice(String noticeType, String noticeContent, String noctieMid, String url) {
		NoticeVO noticeVO = noticeDAO.getNoticeType(noticeType,noctieMid);
		
		if(noticeVO == null) noticeDAO.createNotice(noticeType,noticeContent,noctieMid,url);
		else noticeDAO.updateNotice(noticeType,noticeContent,noctieMid,url);
	}
	
}
