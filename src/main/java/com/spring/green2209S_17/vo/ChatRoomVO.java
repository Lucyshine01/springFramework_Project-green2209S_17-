package com.spring.green2209S_17.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ChatRoomVO {
	private int idx;
	private String roomId;
	private String userId_1;
	private String userId_2;
	private Date createIdDay;
}
