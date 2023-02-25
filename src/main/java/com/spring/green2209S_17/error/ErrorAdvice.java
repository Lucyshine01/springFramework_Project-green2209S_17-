package com.spring.green2209S_17.error;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

@Controller
@RequestMapping("/error")
@ControllerAdvice
public class ErrorAdvice {
	
	private Logger logger = LoggerFactory.getLogger(ErrorAdvice.class);
	
	private int errorCode;
	private String errorMsg;
	private String adviceMsg;
	
//	@ExceptionHandler(Exception.class)
//	public String handelExcption(Exception ex, Model model, HttpServletRequest request) {
//		logger.error("예외오류발생 : {}", ex.getMessage());
//		logger.error("상세내용 : {}", ex.getStackTrace());
//		errorMsg = ex.getMessage();
//		adviceMsg = "위 내용으로 관리자에게 문의하십시오.";
//		return returnErrorPage(model,request);
//	}
	
	//400
	@ExceptionHandler(BindException.class)
	@ResponseStatus(HttpStatus.BAD_REQUEST)
	public String badRequest(BindException ex, Model model, HttpServletRequest request) {
		logger.error("예외오류발생 : {}", ex.getMessage());
		logger.error("상세내용 : {}", ex.getStackTrace());
		errorCode = 400;
		errorMsg = HttpStatus.valueOf(400).getReasonPhrase();
		adviceMsg = "클라이언트 요청이 거부되었습니다!<br/>[Type Error!]";
		return returnErrorPage(model,request);
	};
	
	//403
	@RequestMapping(value = "/403")
	public String forbidden(Exception ex, Model model, HttpServletRequest request) {
		logger.error("예외오류발생 : {}", ex.getMessage());
		logger.error("상세내용 : {}", ex.getStackTrace());
		errorCode = 403;
		errorMsg = HttpStatus.valueOf(403).getReasonPhrase();
		adviceMsg = "서버가 요청을 거부했습니다!";
		return returnErrorPage(model,request);
	};
	
	//404
	@ExceptionHandler(NoHandlerFoundException.class)
	@ResponseStatus(HttpStatus.NOT_FOUND)
	public String notFound(NoHandlerFoundException ex, Model model, HttpServletRequest request) {
		logger.error("예외오류발생 : {}", ex.getMessage());
		logger.error("상세내용 : {}", ex.getStackTrace());
		errorCode = 404;
		errorMsg = HttpStatus.valueOf(404).getReasonPhrase();
		adviceMsg = "페이지를 찾을수 없습니다!";
		return returnErrorPage(model,request);
	};
	
	@RequestMapping(value =  "/errorPage", method = RequestMethod.GET)
	public String customErrorGet(@RequestParam("errorDetail") String errorDetail ,Model model, HttpServletRequest request,
			@RequestParam("errorMsg") String errorMsg, @RequestParam("adviceMsg") String adviceMsg) {
		logger.error("예외오류발생 : {}", errorDetail);
		this.errorMsg = errorMsg;
		this.adviceMsg = adviceMsg;
		return returnErrorPage(model,request);
	}
	
	private String returnErrorPage(Model model, HttpServletRequest request) {
		String url = "";
		if(request.getHeader("referer") != null) url = "location.href=\""+request.getHeader("referer")+"\"";
		else url = "history.back()";
		model.addAttribute("url", url);
		if(errorCode == 0) model.addAttribute("errorCode", "Error");
		else model.addAttribute("errorCode", errorCode);
		model.addAttribute("errorMsg", errorMsg);
		model.addAttribute("adviceMsg", adviceMsg);
		return "error/errorPage";
	}
	
	
}
