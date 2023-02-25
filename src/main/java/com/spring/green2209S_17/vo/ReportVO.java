package com.spring.green2209S_17.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ReportVO {
	private int idx;
	private int replyIdx;
	private String replyMid;
	private String replyContent;
	private Date replyWriteDay;
	private String reportMid;
	private String reason;
	private Date reportWriteDay;
}
