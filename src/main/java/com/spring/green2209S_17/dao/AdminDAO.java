package com.spring.green2209S_17.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.green2209S_17.vo.HelpVO;
import com.spring.green2209S_17.vo.PaymentVO;
import com.spring.green2209S_17.vo.ReplyVO;
import com.spring.green2209S_17.vo.ReportVO;
import com.spring.green2209S_17.vo.UserVO;

public interface AdminDAO {

	public List<UserVO> getAllUserInfo();

	public int updateUserInfo(@Param("vo") UserVO vo);

	public int userDelete(@Param("idx") int idx);

	public List<UserVO> getAllChatList();

	public List<PaymentVO> getAllPaymentList();

	public PaymentVO getPaymentInfo(@Param("idx") int idx);

	public List<ReportVO> getAllReportList();

	public int userAccDisable(@Param("vo") ReportVO vo, @Param("accStop") String accStop);

	public List<HelpVO> getAllHelpList();

	public HelpVO gethelpInfo(@Param("idx") int idx);

	public int helpAnswer(@Param("vo") HelpVO vo);

	public List<Integer> getUserMonthTot(@Param("day") String day,@Param("day2") String day2,@Param("day4") List<String> day4);

	public Integer getCpMonthTot(@Param("day3") String day3);

	public List<UserVO> getRecentUserInfo();

	public int getUserCount();

	public int getCpCount();

	public int getHelpCount();

	public int getReportCount();

	public List<ReplyVO> getAllReplyList();

	public ReplyVO getReplyInfo(@Param("idx") int idx);

	public int removeReply(@Param("idx") int idx);
	
}
