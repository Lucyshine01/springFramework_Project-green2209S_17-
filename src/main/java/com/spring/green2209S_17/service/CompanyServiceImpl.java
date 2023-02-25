package com.spring.green2209S_17.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.green2209S_17.dao.CompanyDAO;
import com.spring.green2209S_17.vo.CompanyImgVO;
import com.spring.green2209S_17.vo.CompanyVO;

@Service
public class CompanyServiceImpl implements CompanyService {
	
	@Autowired
	CompanyDAO comapnyDAO;

	@Override
	public List<CompanyVO> getAllCpList() {
		return comapnyDAO.getAllCpList();
	}

	@Override
	public HashMap<String, Object> getCpDetailInfo(int idx) {
		return comapnyDAO.getCpDetailInfo(idx);
	}

	@Override
	public CompanyVO getCpInfo(String mid) {
		return comapnyDAO.getCpInfo(mid);
	}
	
	@Override
	public int setUpdateCpInfo(CompanyVO vo) {
		return comapnyDAO.setUpdateCpInfo(vo);
	}

	@Override
	public CompanyImgVO getCpImgInfo(int idx) {
		return comapnyDAO.getCpImgInfo(idx);
	}

	
	
	
}
