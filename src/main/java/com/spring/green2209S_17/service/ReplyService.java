package com.spring.green2209S_17.service;

import java.util.List;

import org.springframework.ui.Model;

import com.spring.green2209S_17.pagination.PageVO;
import com.spring.green2209S_17.vo.ReplyVO;

public interface ReplyService {

	public int submitReply(String mid, String boardIdx, String rating, String content, String profileImg);

	public double getReplyRatingAvg(String boardIdx);

	public int deleteReply(int idx);

	public int reportReply(int idx, String mid, String reason);

	public void replyNotice(String noticeType, String noticeContent, String noctieMid, String url);

	public List<ReplyVO> getReplyAllList(PageVO pageVO, Model model, String orderBy, String order, String searching, String searchItem);
	
}
