package com.spring.green2209S_17.dao;

import org.apache.ibatis.annotations.Param;

import com.spring.green2209S_17.vo.PaymentVO;

public interface PaymentDAO {

	public void setFailPayment(@Param("vo") PaymentVO vo);

	public int setSuccessPayment(@Param("vo") PaymentVO vo);

	public int userChargePoint(@Param("mid") String mid, @Param("point") int point);
	
}
