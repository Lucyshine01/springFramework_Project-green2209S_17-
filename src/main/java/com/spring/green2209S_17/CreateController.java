package com.spring.green2209S_17;

import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.green2209S_17.service.CreateService;
import com.spring.green2209S_17.service.PointService;
import com.spring.green2209S_17.util.SecurityUtil;
import com.spring.green2209S_17.vo.CompanyImgVO;
import com.spring.green2209S_17.vo.CompanyVO;
import com.spring.green2209S_17.vo.UserVO;

@Controller
@RequestMapping("/create")
public class CreateController {
	
	@Autowired
	CreateService createService;
	
	@Autowired
	PointService pointservice;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@RequestMapping(value = "/createUser")
	public String createUserGet(HttpSession session, HttpServletRequest request) {
		String mid = session.getAttribute("sMid") == null ? "" : (String)session.getAttribute("sMid");
		if(!mid.equals("")) {
			String url = request.getContextPath() + "/";
			return "redirect:/msg/alreadyMember?url=" + url;
		}
		return "create/createUser";
	}
	
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/createUser", method = RequestMethod.POST)
	public String createUserPost(UserVO vo, HttpServletRequest request) {
		if(createService.getEmailCheck(vo.getEmail()) != null) return "2";
		else if(createService.getTelCheck(vo.getTel()) != null) return "3";
		
		UUID uid = UUID.randomUUID();
		String code = SecurityUtil.encryptSHA256(uid.toString()).substring(0,20);
		int res = createService.setCreateUser_Step1(vo,code);
		if(res == 0) return "0";
		createService.sendActEmail(vo,code,request);
		
		return res+"";
	}
	
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/reSendActMail", method = RequestMethod.POST)
	public String createUserPost(@RequestParam("email") String email, HttpServletRequest request) {
		
		UserVO vo = createService.getEmailCheck(email);
		if(vo == null) return "redirect:/msg/worngEmail";
		
		UUID uid = UUID.randomUUID();
		String code = SecurityUtil.encryptSHA256(uid.toString()).substring(0,20);
		int res = createService.setUpdateEmailCode(email,code);
		if(res == 0) return "0";
		createService.sendActEmail(vo,code,request);
		return res+"";
	}
	
	@ResponseBody
	@RequestMapping(value = "/idOverCheck", method = RequestMethod.POST)
	public String idOverCheckPost(@RequestParam("mid") String mid) {
		int res = 1;
		if(createService.getIdCheck(mid) == null) res = 0;
		return res + "";
	}
	
	@RequestMapping(value = "/actEmail")
	public String actEmailGet(@RequestParam("code") String code, Model model, HttpServletRequest request) {
		UserVO vo = createService.searchCodeInfor(code);
		if(vo == null) {
			return "redirect:/msg/actEmailNoFound";
		}
		vo = createService.getEmailCheck(vo.getEmail());
		model.addAttribute("vo",vo);
		return "create/createUserStep2";
	}
	
	@RequestMapping(value = "/emailSendMail")
	public String emailSendMailGet(@RequestParam(required = false) String email, Model model) {
		if(email == null) return "redirect:/msg/wrongURL";
		int res = 0;
		if(createService.searchEmailInfor(email) != null) res = 1;
	 	if(res == 0) return "redirect:/msg/wrongURL";
	 	model.addAttribute("email", email);
		return "create/emailSendMail";
	}
	
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/createUserStep2", method = RequestMethod.POST)
	public String createUserStep2Post(UserVO vo) {
		vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		int res = createService.setCreateUser_Step2(vo);
		if(res == 0) pointservice.usePoint(vo.getMid(),0,10000,"회원 가입 이벤트 1만 무료포인트 증정");
		return res + "";
	}
	
	@ResponseBody
	@RequestMapping(value = "/cpCreate", method = RequestMethod.POST)
	public String cpCreatePost(@RequestParam("mid") String mid) {
		CompanyVO cpVO = createService.getCpIdCheck(mid);
		String res = "2";
		if(cpVO == null) res = "0";
		else if(cpVO.getAct().equals("off")) res = "1"; 
		return res;
	}
	
	@RequestMapping(value = "/cpCreate", method = RequestMethod.GET)
	public String cpCreateGet(HttpSession session, HttpServletRequest request) {
		String mid = session.getAttribute("sMid") == null ? "" : (String)session.getAttribute("sMid");
		if(mid.equals("")) return "redirect:/msg/noLogin";
		String url = request.getHeader("referer") == null ? request.getLocalAddr() + ":" + request.getLocalPort() + request.getContextPath() : request.getHeader("referer");
		CompanyVO cpVO = createService.getCpIdCheck(mid);
		if(cpVO == null) return "create/createCP";
		else if(cpVO.getAct().equals("off")) return "redirect:/msg/offActCp?url=" + url; 
		else return "redirect:/msg/onActCp?url=" + url;
	}
	
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/createCompanyData", method = RequestMethod.POST)
	public String createCompanyDataPost(CompanyVO cpVO, CompanyImgVO cpImgVO) {
		int res = 0;
		UserVO userVO = createService.getIdCheck(cpVO.getMid());
		if(userVO.getPoint() < 2000) return "3";
		
		if (createService.getCpNameCheck(cpVO.getCpName()) != null) res = 2;
		else res = createService.setCreateCompany(cpVO,cpImgVO);
		if(res == 1) pointservice.usePoint(userVO.getMid(),2000,userVO.getPoint()-2000,userVO.getMid() + "님의 업체등록 포인트 비용지불");
		return res + "";
	}
	
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/saveCpImg", method = RequestMethod.POST)
	public String saveCpImgPost(MultipartHttpServletRequest file,
			@RequestParam("fileName") String fileName,
			HttpServletRequest request) {
		createService.saveImg(request,file,fileName);
		return "";
	}
	
	
}
