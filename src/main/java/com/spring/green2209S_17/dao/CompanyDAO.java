package com.spring.green2209S_17.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.spring.green2209S_17.vo.CompanyImgVO;
import com.spring.green2209S_17.vo.CompanyVO;

public interface CompanyDAO {

	public List<CompanyVO> getAllCpList();

	public HashMap<String, Object> getCpDetailInfo(@Param("idx") int idx);

	public CompanyVO getCpInfo(@Param("mid") String mid);
	
	public int setUpdateCpInfo(@Param("vo") CompanyVO vo);

	public CompanyImgVO getCpImgInfo(@Param("idx") int idx);

	public int setSaveCpImg(@Param("vo") CompanyImgVO vo);

}
