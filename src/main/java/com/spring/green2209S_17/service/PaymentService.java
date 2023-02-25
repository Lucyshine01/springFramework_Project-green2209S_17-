package com.spring.green2209S_17.service;

import com.spring.green2209S_17.vo.PaymentVO;

public interface PaymentService {

	public int setPaymentWrite(PaymentVO vo);

	public int userChargePoint(String mid, int point);

}
