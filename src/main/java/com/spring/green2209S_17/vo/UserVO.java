package com.spring.green2209S_17.vo;

import java.util.Date;

import javax.validation.constraints.Pattern;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class UserVO {
	private int idx;
	@Pattern(regexp = "^([a-zA-Z0-9]){6,20}$")
	private String mid;
	private String pwd;
	@Pattern(regexp = "^([-_.]?[0-9a-zA-Z]){4,20}@+([-_.]?[0-9a-zA-Z]){4,20}.+[a-zA-Z]{2,3}$")
	private String email;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date birth;
	@Pattern(regexp = "^([0-9]){2,3}-+([0-9]){3,4}-+([0-9]){3,4}$")
	private String tel;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date createDay;
	private String userLevel;
	private int point;
	private String profile;
	private Date accStop;
}
