package com.spring.green2209S_17.interceptor;

import java.util.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class FirstInterceptor extends HandlerInterceptorAdapter {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		Date date = new Date();
		int mm = date.getMinutes();
		String userLevel = session.getAttribute("sUserLevel") == null ? "" : (String)session.getAttribute("sUserLevel");
		if(userLevel.equals("관리자")) return true;
		
//		if(session.getAttribute("connCnt") == null) session.setAttribute("connCnt", mm+"/1");
//		else {
//			String strConnCnt = (String)session.getAttribute("connCnt");
//			int mmCheck = Integer.parseInt(strConnCnt.split("/")[0]);
//			int connCnt = Integer.parseInt(strConnCnt.split("/")[1]);
//			if(connCnt < 20 && mmCheck == mm) {
//				connCnt++;
//				session.removeAttribute("connCnt");
//				session.setAttribute("connCnt", mm + "/" + connCnt);
//			}
//			else if (mmCheck != mm) {
//				session.removeAttribute("connCnt");
//				session.setAttribute("connCnt", mm+"/1");
//			}
//			else {
//				String url = "/error/errorPage?errorMsg=Too Many Request!";
//				url += "&adviceMsg=페이지요청이 너무 많습니다!<br/>잠시후 다시 시도해주세요.";
//				if((String)session.getAttribute("sMid") == null)
//					url += "&errorDetail="+ request.getRemoteAddr() + "의 페이지요청수 초과";
//				else url += "&errorDetail="+ request.getRemoteAddr() + "/" + (String)session.getAttribute("sMid") 
//									+ "의 페이지요청수 초과";
//				RequestDispatcher dispatcher = request.getRequestDispatcher(url);
//				dispatcher.forward(request, response);
//				return false;
//			}
//		}
		
		return true;
	}

	@Override
	public void postHandle(
			HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView)
			throws Exception {
	}
	
}
