package com.spring.green2209S_17.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.green2209S_17.pagination.PageVO;
import com.spring.green2209S_17.vo.HelpVO;
import com.spring.green2209S_17.vo.PointVO;
import com.spring.green2209S_17.vo.ReplyVO;
import com.spring.green2209S_17.vo.UserVO;

public interface MemberService {

	public String loginCheck(String mid, String pwd, String rememId, HttpServletRequest request, HttpServletResponse response,
			HttpSession session);

	public UserVO getUserInfo(String mid);

	public int inputCPImg(MultipartHttpServletRequest file, HttpServletRequest request, String mid);

	public int cpIntroImgDelete(String imgName, HttpServletRequest request, String mid);

	public void getCompnayList(PageVO pageVO, Model model, String[] searchWord, String orderBy, String order, String searchItem, String searching);

	public List<ReplyVO> getReplyList(String boardIdx, int start, int end);

	public int getReplyTot(String boardIdx);

	public List<PointVO> getPointInfo(String mid);

	public int updateUserInfo(UserVO vo);

	public int updateUserPwd(String mid, String newPwd);

	public List<HelpVO> getHelpList(String mid);

	public int helpInput(HelpVO vo, String mid);

	public void cpViewCntUpdate(int idx);

	public void profileChange(MultipartHttpServletRequest file, HttpServletRequest request, UserVO vo, HttpSession session);

	public void profileDefault(UserVO vo, HttpServletRequest request, HttpSession session);

	public void myInfoDelete(String mid);

}
