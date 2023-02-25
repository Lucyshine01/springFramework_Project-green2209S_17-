package com.spring.green2209S_17;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MessageController {
	
	@RequestMapping(value = "/msg/{msgFlag}", method = RequestMethod.GET)
	public String msgget(@PathVariable String msgFlag, Model model, HttpServletRequest request,
			@RequestParam(name = "url", defaultValue = "", required = false) String url) {
		String homeUrl = request.getLocalAddr() + ":" + request.getLocalPort() + request.getContextPath();
		if(msgFlag.equals("actEmailNoFound")) {
			model.addAttribute("msg", "잘못된 인증 URL입니다.");
			model.addAttribute("url", homeUrl);
		}
		else if(msgFlag.equals("wrongURL")) {
			model.addAttribute("msg", "잘못된 인증 URL입니다.");
			model.addAttribute("url", homeUrl);
		}
		else if(msgFlag.equals("worngEmail")) {
			model.addAttribute("msg", "등록되지 않은 이메일입니다.");
			model.addAttribute("url", homeUrl);
		}
		else if(msgFlag.equals("noLogin")) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.");
			model.addAttribute("url", homeUrl);
		}
		else if(msgFlag.equals("noCompany")) {
			model.addAttribute("msg", "업체회원 전환 후 이용가능합니다.");
			model.addAttribute("url", homeUrl);
		}
		else if(msgFlag.equals("noAdmin")) {
			model.addAttribute("msg", "허용되지 않은 접근");
			model.addAttribute("url", homeUrl);
		}
		else if(msgFlag.equals("offActCp")) {
			model.addAttribute("msg", "현재 업체 승인 심사중입니다.");
			model.addAttribute("url", homeUrl);
		}
		else if(msgFlag.equals("onActCp")) {
			model.addAttribute("msg", "비업체 회원만 이용가능합니다.");
			model.addAttribute("url", homeUrl);
		}
		else if(msgFlag.equals("alreadyMember")) {
			model.addAttribute("msg", "비회원만 이용가능합니다.");
			model.addAttribute("url", homeUrl);
		}
		else if(msgFlag.equals("createCpOk")) {
			model.addAttribute("msg", "업체회원 신청이 완료되었습니다.\\n승인 후 재 로그인시 업체회원으로 로그인됩니다.");
			model.addAttribute("url", homeUrl);
		}
		else if(msgFlag.equals("saveImgFail")) {
			model.addAttribute("msg", "이미지 업로드에 실패했습니다. 관리자에 문의하십시오.");
			model.addAttribute("url", url);
		}
		else if(msgFlag.equals("wrongUrl")) {
			model.addAttribute("msg", "잘못된 url 요청입니다.");
			model.addAttribute("url", homeUrl);
		}
		else if(msgFlag.equals("sessionOver")) {
			model.addAttribute("msg", "세션이 만료되었습니다.");
			model.addAttribute("url", homeUrl);
		}
		
		return "msg/message";
	}
}
