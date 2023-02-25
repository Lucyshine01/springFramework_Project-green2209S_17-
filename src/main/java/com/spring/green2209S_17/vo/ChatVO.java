package com.spring.green2209S_17.vo;

import lombok.Data;

@Data
public class ChatVO {
	private int idx;
	private String content;
	private String sendId;
	private String receiveId;
	private String sendDay;
	private String roomId;
	private String oppCpName;
	private String oppCpMid;
	private String oppCpIdx;
	private String oppImg;
	private String oppName;
}
