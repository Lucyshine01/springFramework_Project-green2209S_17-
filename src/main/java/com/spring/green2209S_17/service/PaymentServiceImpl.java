package com.spring.green2209S_17.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.green2209S_17.dao.CreateDAO;
import com.spring.green2209S_17.dao.PaymentDAO;
import com.spring.green2209S_17.dao.PointDAO;
import com.spring.green2209S_17.vo.PaymentVO;
import com.spring.green2209S_17.vo.UserVO;

@Service
public class PaymentServiceImpl implements PaymentService {
	
	@Autowired
	PaymentDAO paymentDAO;
	
	@Autowired
	PointDAO pointDAO;
	
	@Autowired
	CreateDAO createDAO;
	
	@Override
	public int setPaymentWrite(PaymentVO vo) {
		if(vo.getSuccess() == "false") {
			paymentDAO.setFailPayment(vo);
			return 0;
		} 
		int res = paymentDAO.setSuccessPayment(vo);
		return res;
	}

	@Override
	public int userChargePoint(String mid, int point) {
		UserVO vo = createDAO.getIdCheck(mid);
		System.out.println("포인트 : "+point);
		System.out.println("포인트 : "+(vo.getPoint()+point));
		pointDAO.usePoint(vo.getMid(), 0, vo.getPoint()+point, point+"포인트 유료충전 서비스");
		return paymentDAO.userChargePoint(mid,point);
	}
	
	
	
}
