package com.spring.green2209S_17.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyVO {
	private int idx;
	private String boardIdx;
	private String content;
	private double rating;
	private Date writeDay;
	private String mid;
	private String profileImg;
	
	private String oriMid;
}
