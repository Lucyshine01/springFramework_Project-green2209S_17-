package com.spring.green2209S_17.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.green2209S_17.vo.CompanyImgVO;
import com.spring.green2209S_17.vo.HelpVO;
import com.spring.green2209S_17.vo.UserVO;

public interface MemberDAO {

	public List<CompanyImgVO> getCompanyImgList(@Param("strImgSearch") String strImgSearch);

	public int updateUserInfo(@Param("vo") UserVO vo);

	public int updateUserPwd(@Param("mid") String mid, @Param("newPwd") String newPwd);

	public List<HelpVO> getHelpList(@Param("mid") String mid);

	public int helpInput(String title, String content,@Param("mid") String mid);

	public int helpInput(@Param("vo") HelpVO vo, @Param("mid") String mid);

	public void cpViewCntUpdate(@Param("idx") int idx);

	public void updateUserProfile(@Param("profile") String profile, @Param("mid") String mid);

	public void profileDefault(@Param("mid") String mid);
	
}
