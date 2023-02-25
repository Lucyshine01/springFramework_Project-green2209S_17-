package com.spring.green2209S_17.vo;

import java.util.Date;

import lombok.Data;

@Data
public class CompanyVO {
	private int idx;
	private String name;
	private String cpName;
	private String cpAddr;
	private String cpHomePage;
	private String cpIntro;
	private String cpExp;
	private String act;
	private String mid;
	private Date createDayCP;
	private int viewCP;
	
	//as
	private double starAvg;
}
