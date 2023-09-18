package com.spring.green2209S_17.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.green2209S_17.dao.NoticeDAO;
import com.spring.green2209S_17.dao.PageDAO;
import com.spring.green2209S_17.dao.ReplyDAO;
import com.spring.green2209S_17.pagination.PageProcess;
import com.spring.green2209S_17.pagination.PageVO;
import com.spring.green2209S_17.vo.NoticeVO;
import com.spring.green2209S_17.vo.ReplyVO;

@Service
public class ReplyServiceImpl implements ReplyService {
	
	@Autowired
	ReplyDAO replyDAO;
	
	@Autowired
	NoticeDAO noticeDAO;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	PageDAO pageDAO;
	
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

	@Override
	public List<ReplyVO> getReplyAllList(PageVO pageVO, Model model, String orderBy, String order, String searching, String searchItem) {
		if(orderBy.equals("")) orderBy = "writeDay";
		if(order.equals("")) order = "desc";
		
		
		ObjectMapper objectMapper = new ObjectMapper();
		List<ReplyVO> vos = new ArrayList<ReplyVO>();
		List<HashMap<String, Object>> listMap = null;
		
		String select = "c.cpName as cpName,c.idx as cidx, r.*";
		String tableName = "company c right join reply r on concat('c',c.idx) = r.boardidx";
		String feildName = searchItem;
		String feildWord = searching;
		String other = "";
		String group_by = "group by r.idx";
		
		if(pageVO.getPag() == 0) pageVO.setPag(1);
		if(pageVO.getPageSize() == 0) pageVO.setPageSize(10);
		pageVO.setBlockSize(5);
		
		pageVO.setTotRecCnt(pageDAO.totTermRecCnt(tableName, feildName, feildWord, other));
		pageVO = pageProcess.pagingSub(pageVO, model, feildName, feildWord);
		
		listMap = pageDAO.getTermList(select, tableName, pageVO.getStartIndexNo(), pageVO.getPageSize(), feildName, feildWord, orderBy, order, group_by,other);
		if(listMap.isEmpty()) return null;
		for(int i = 0; i<listMap.size(); i++) vos.add(i, objectMapper.convertValue(listMap.get(i), ReplyVO.class));
		model.addAttribute("pageSize",pageVO.getPageSize());
		model.addAttribute("orderBy",orderBy);
		model.addAttribute("order",order);
		model.addAttribute("searching",searching);
		model.addAttribute("searchItem",searchItem);
		model.addAttribute("pageVO",pageVO);
		return vos;
	}
	
}
