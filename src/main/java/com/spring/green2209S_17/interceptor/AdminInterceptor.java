package com.spring.green2209S_17.interceptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class AdminInterceptor extends HandlerInterceptorAdapter {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession();
		String userLevel = (String) session.getAttribute("sUserLevel");
		if(userLevel == null) {
			RequestDispatcher dispatcher = request.getRequestDispatcher("/msg/noLogin");
			dispatcher.forward(request, response);
			return false;
		}
		else if(!userLevel.equals("관리자")) {
			RequestDispatcher dispatcher = request.getRequestDispatcher("/msg/noAdmin");
			dispatcher.forward(request, response);
			return false;
		}
		return true;
	}
	
	@Override
	public void postHandle(
			HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView)
			throws Exception {
	}
	
}
