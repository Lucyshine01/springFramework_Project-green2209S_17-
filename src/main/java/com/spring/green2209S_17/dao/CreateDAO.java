package com.spring.green2209S_17.dao;

import org.apache.ibatis.annotations.Param;

import com.spring.green2209S_17.vo.CompanyImgVO;
import com.spring.green2209S_17.vo.CompanyVO;
import com.spring.green2209S_17.vo.UserVO;

public interface CreateDAO {

	public UserVO getIdCheck(@Param("mid") String mid);

	public UserVO getEmailCheck(@Param("email") String email);

	public UserVO getTelCheck(@Param("tel") String tel);

	public int setCreateUser_Step1(@Param("vo") UserVO vo,@Param("code") String code);

	public UserVO searchCodeInfor(@Param("code") String code);

	public UserVO searchEmailInfor(@Param("email") String email);

	public int setUpdateEmailCode(@Param("email") String email, @Param("code") String code);
	
	public int setCreateUser_Step2Delete(@Param("vo") UserVO vo);

	public int setCreateUser_Step2Update(@Param("vo") UserVO vo);

	public CompanyVO getCpIdCheck(@Param("mid") String mid);

	public CompanyVO getCpNameCheck(@Param("cpName") String cpName);

	public int setCreateCompany(@Param("cpVO") CompanyVO cpVO);

	public int setCreateCompanyImg(@Param("idx") int idx, @Param("cpImgVO") CompanyImgVO cpImgVO);

	public void saveImgUpdate(@Param("fileName") String fileName,@Param("sFileName") String sFileName);

	public void accStopDateDefault(@Param("idx") int idx);

	public UserVO getUser(@Param("i") int i);

	public void updatedata(@Param("vo") UserVO vo, @Param("birth")String birth, @Param("createDay")String createDay);

}
