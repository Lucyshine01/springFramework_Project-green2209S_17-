package com.spring.green2209S_17.vo;

import java.util.Date;

import lombok.Data;

@Data
public class PaymentVO {
	private int idx;
	private String merchant_uid; /* buyCode */
	private String currency;
	private String pay_method;
	private String buyer_name;
	private String buyer_email;
	private String card_name;
	private String card_number;
	private String name;
	private String paid_amount;
	private String pg_tid;
	private String receipt_url;
	private String success;
	private String error_msg;
	private Date buyDay;
}
