package com.spring.green2209S_17.pagination;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.spring.green2209S_17.dao.PageDAO;

@Service
public class PageProcess {

	@Autowired
	PageDAO PageDAO;
	
	// 매퍼 동적처리로 하나로 통일
	public List<HashMap<String, Object>> paging(PageVO vo, Model model, String tableName, String feildName, String feildWord, String orderBy, String order,
			String select, String group_by, String other) {
		vo = pagingModel(vo,model,tableName,feildName,feildWord,"","",other);
		return PageDAO.getTermList(select, tableName, vo.getStartIndexNo(), vo.getPageSize(), feildName, feildWord, orderBy, order, group_by,other);
	}
	
	public List<HashMap<String, Object>> pagingManyWords(PageVO vo, Model model, String tableName, String feildName, String feildWord, String orderBy, String order, 
			String select, String group_by, String other) {
		vo = pagingModel(vo,model,tableName,feildName,feildWord,"","",other);
		return PageDAO.getTermListManyWords(select, tableName, vo.getStartIndexNo(), vo.getPageSize(), feildName, feildWord, orderBy, order, group_by,other);
	}

	public List<HashMap<String, Object>> paging_Search(PageVO vo, Model model, String tableName, String feildName, String feildWord, String orderBy, String order, 
			String searchItem, String searching, String select, String group_by, String other) {
		vo = pagingModel(vo,model,tableName,feildName,feildWord,searchItem,searching,other);
		return PageDAO.getTermList_Search(select, tableName, vo.getStartIndexNo(), vo.getPageSize(), feildName, feildWord, orderBy, order, searchItem, searching, group_by,other);
	}
	public List<HashMap<String, Object>> pagingManyWords_Search(PageVO vo, Model model, String tableName, String feildName, String feildWord, String orderBy, String order, 
			String searchItem, String searching, String select, String group_by, String other) {
		vo = pagingModel(vo,model,tableName,feildName,feildWord,searchItem,searching,other);
		return PageDAO.getTermListManyWords_Search(select, tableName, vo.getStartIndexNo(), vo.getPageSize(), feildName, feildWord, orderBy, order, searchItem, searching, group_by,other);
	}
	
	private PageVO pagingModel(PageVO vo, Model model, String tableName, String feildName, String feildWord, String searchItem, String searching, String other) {
		if(vo.getPag() == 0) vo.setPag(1);
		if(vo.getPageSize() == 0) vo.setPageSize(5);
		
		if(searching.equals("")) {
			if(feildWord.contains("|")) vo.setTotRecCnt(PageDAO.totTermRecCntManyWords(tableName, feildName, feildWord, other));
			else vo.setTotRecCnt(PageDAO.totTermRecCnt(tableName, feildName, feildWord, other));
		}
		else {
			if(feildWord.contains("|")) vo.setTotRecCnt(PageDAO.totTermRecCntManyWords_Search(tableName, feildName, feildWord, searchItem, searching, other));
			else vo.setTotRecCnt(PageDAO.totTermRecCnt_Search(tableName, feildName, feildWord, searchItem, searching, other));
		}
		
		return pagingSub(vo, model, feildName, feildWord);
	}
	
	public PageVO pagingSub(PageVO vo, Model model, String feildName, String feildWord) {
		vo.setTotPage(vo.getTotRecCnt() % vo.getPageSize()==0 ? vo.getTotRecCnt() / vo.getPageSize() : (vo.getTotRecCnt() / vo.getPageSize())+1);
		if((vo.getTotPage() < vo.getPag() || vo.getPag() < 1) && vo.getTotPage() > 0) vo.setPag(vo.getTotPage());
		
		vo.setStartIndexNo((vo.getPag()-1) * vo.getPageSize());
		vo.setCurScrStartNo(vo.getTotRecCnt() - vo.getStartIndexNo());
		
		if(vo.getBlockSize()==0) vo.setBlockSize(3);
		vo.setCurBlock((vo.getPag() - 1) / vo.getBlockSize());
		vo.setLastBlock((vo.getTotPage()-1) / vo.getBlockSize());
		
		vo.setPart(feildName);
		
		model.addAttribute("blockSize", vo.getBlockSize());
		model.addAttribute("curBlock", vo.getCurBlock());
		model.addAttribute("lastBlock", vo.getLastBlock());
		model.addAttribute("pageSize", vo.getPageSize());
		model.addAttribute("pag", vo.getPag());
		model.addAttribute("totRecCnt", vo.getTotRecCnt());
		model.addAttribute("totPage", vo.getTotPage());
		model.addAttribute("curScrStartNo", vo.getCurScrStartNo());
		
		model.addAttribute("pageVO", vo);
		model.addAttribute("feildWord",feildWord);
		return vo;
	}
	
//	public ArrayList<MemberVO> paging(PageVO vo, Model model, String tableName) {
//		
//		if(vo.getPag() == 0) vo.setPag(1);
//		if(vo.getPageSize() == 0) vo.setPageSize(5);
//		
//		vo.setTotRecCnt(PageDAO.totRecCnt(tableName));
//		vo.setTotPage(vo.getTotRecCnt() % vo.getPageSize()==0 ? vo.getTotRecCnt() / vo.getPageSize() : (vo.getTotRecCnt() / vo.getPageSize())+1);
//		vo.setStartIndexNo((vo.getPag()-1) * vo.getPageSize());
//		vo.setCurScrStartNo(vo.getTotRecCnt() - vo.getStartIndexNo());
//		
//		vo.setBlockSize(3);
//		vo.setCurBlock((vo.getPag() - 1) / vo.getBlockSize());
//		vo.setLastBlock((vo.getTotPage()-1) / vo.getBlockSize());
//		
//		model.addAttribute("blockSize", vo.getBlockSize());
//		model.addAttribute("curBlock", vo.getCurBlock());
//		model.addAttribute("lastBlock", vo.getLastBlock());
//		model.addAttribute("pageSize", vo.getPageSize());
//		model.addAttribute("pag", vo.getPag());
//		model.addAttribute("totPage", vo.getTotPage());
//		model.addAttribute("curScrStartNo", vo.getCurScrStartNo());
//		
//		return PageDAO.getList(tableName, vo.getStartIndexNo(), vo.getPageSize());
//	}
	
//	public ArrayList<MemberVO> pagingSearch(PageVO vo, Model model, String tableName, String keyWord, String searchWord) {
//		
//		if(vo.getPag() == 0) vo.setPag(1);
//		if(vo.getPageSize() == 0) vo.setPageSize(5);
//		
//		vo.setTotRecCnt(PageDAO.totRecCntSearch(tableName, keyWord, searchWord));
//		vo.setTotPage(vo.getTotRecCnt() % vo.getPageSize()==0 ? vo.getTotRecCnt() / vo.getPageSize() : (vo.getTotRecCnt() / vo.getPageSize())+1);
//		vo.setStartIndexNo((vo.getPag()-1) * vo.getPageSize());
//		vo.setCurScrStartNo(vo.getTotRecCnt() - vo.getStartIndexNo());
//		
//		vo.setBlockSize(3);
//		vo.setCurBlock((vo.getPag() - 1) / vo.getBlockSize());
//		vo.setLastBlock((vo.getTotPage()-1) / vo.getBlockSize());
//		
//		model.addAttribute("blockSize", vo.getBlockSize());
//		model.addAttribute("curBlock", vo.getCurBlock());
//		model.addAttribute("lastBlock", vo.getLastBlock());
//		model.addAttribute("pageSize", vo.getPageSize());
//		model.addAttribute("pag", vo.getPag());
//		model.addAttribute("totPage", vo.getTotPage());
//		model.addAttribute("curScrStartNo", vo.getCurScrStartNo());
//		
//		return PageDAO.getListSearch(tableName, vo.getStartIndexNo(), vo.getPageSize(), keyWord, searchWord);
//	}
//	
//	public PageVO totRecCnt(int pag, int pageSize, String section, String part, String searchString) {
//		PageVO pageVO = new PageVO();
//		
//		int totRecCnt = 0;
//		
//		if(section.equals("webMessage")) {
//			String mid = part;
//			int mSw = Integer.parseInt(searchString);
//			totRecCnt = webMessageServiceDAO.totRecCnt(mid, mSw);
//		}
//		
//		int totPage = (totRecCnt % pageSize)==0 ? totRecCnt / pageSize : (totRecCnt / pageSize) + 1;
//		int startIndexNo = (pag - 1) * pageSize;
//		int curScrStartNo = totRecCnt - startIndexNo;
//		
//		int blockSize = 3;
//		int curBlock = (pag - 1) / blockSize;
//		int lastBlock = (totPage - 1) / blockSize;
//		
//		pageVO.setPag(pag);
//		pageVO.setPageSize(pageSize);
//		pageVO.setTotRecCnt(totRecCnt);
//		pageVO.setTotPage(totPage);
//		pageVO.setStartIndexNo(startIndexNo);
//		pageVO.setCurScrStartNo(curScrStartNo);
//		pageVO.setBlockSize(blockSize);
//		pageVO.setCurBlock(curBlock);
//		pageVO.setLastBlock(lastBlock);
//		
//		return pageVO;
//	}
	
	
}
