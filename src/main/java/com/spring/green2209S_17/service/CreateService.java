package com.spring.green2209S_17.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.green2209S_17.vo.CompanyImgVO;
import com.spring.green2209S_17.vo.CompanyVO;
import com.spring.green2209S_17.vo.UserVO;

public interface CreateService {
	
	public UserVO getIdCheck(String mid);

	public UserVO getEmailCheck(String email);

	public UserVO getTelCheck(String tel);

	public int setCreateUser_Step1(UserVO vo, String code);

	public void sendActEmail(UserVO vo, String code, HttpServletRequest request);

	public UserVO searchCodeInfor(String code);

	public UserVO searchEmailInfor(String email);

	public int setUpdateEmailCode(String email, String code);

	public int setCreateUser_Step2(UserVO vo);

	public CompanyVO getCpIdCheck(String mid);

	public CompanyVO getCpNameCheck(String cpName);

	public int setCreateCompany(CompanyVO cpVO, CompanyImgVO cpImgVO);

	public void saveImg(HttpServletRequest request, MultipartHttpServletRequest file, String fileName);

}
