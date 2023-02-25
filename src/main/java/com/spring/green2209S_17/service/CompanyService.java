package com.spring.green2209S_17.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.spring.green2209S_17.vo.CompanyImgVO;
import com.spring.green2209S_17.vo.CompanyVO;

public interface CompanyService {

	public List<CompanyVO> getAllCpList();

	public HashMap<String, Object> getCpDetailInfo(int idx);
	
	public CompanyVO getCpInfo(String mid);

	public int setUpdateCpInfo(CompanyVO vo);

	public CompanyImgVO getCpImgInfo(int idx);

	
}
