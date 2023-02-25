package com.spring.green2209S_17.vo;

import java.util.Date;

import lombok.Data;

@Data
public class HelpVO {
	private int idx;
	private String title;
	private String content;
	private String conf;
	private String answer;
	private String mid;
	private Date writeDay;
	private Date answerDay;
}
