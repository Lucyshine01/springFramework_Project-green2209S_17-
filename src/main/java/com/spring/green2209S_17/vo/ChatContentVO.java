package com.spring.green2209S_17.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ChatContentVO {
	private int idx;
	private String content;
	private String sendId;
	private String receivedId;
	private Date sendDay;
}
