package com.spring.green2209S_17.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.green2209S_17.dao.PointDAO;

@Service
public class PointServiceImpl implements PointService {
	
	@Autowired
	PointDAO pointDAO;

	@Override
	public void usePoint(String mid, int usePoint, int leftPoint, String useContent) {
		pointDAO.usePoint(mid,usePoint,leftPoint,useContent);
		pointDAO.updatePoint(mid,leftPoint);
	}
	
}
