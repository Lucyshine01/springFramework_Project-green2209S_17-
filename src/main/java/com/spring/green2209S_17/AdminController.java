package com.spring.green2209S_17;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.green2209S_17.dao.AdminDAO;
import com.spring.green2209S_17.service.CompanyService;
import com.spring.green2209S_17.service.CreateService;
import com.spring.green2209S_17.service.MemberService;
import com.spring.green2209S_17.vo.CompanyVO;
import com.spring.green2209S_17.vo.HelpVO;
import com.spring.green2209S_17.vo.PaymentVO;
import com.spring.green2209S_17.vo.ReportVO;
import com.spring.green2209S_17.vo.UserVO;

@Controller
@RequestMapping("/admin")
@Service
public class AdminController {
	
	@Autowired
	AdminDAO adminDAO;
	
	@Autowired
	CompanyService companyService;
	
	@Autowired
	CreateService createService;
	
	@Autowired
	MemberService memberService;
	
	
	@RequestMapping("/main")
	public String mainGet(Model model) {
		
		String day = "";
		String day2 = "\"";
		String day3 = "";
		List<Integer> cpTotVos = new ArrayList<Integer>();
		for(int i=9; i>=0; i--) {
			LocalDate date = LocalDate.now().minusMonths(i);
			String yy = date.getYear()+"";
			String mm = date.getMonthValue()+"";
			if(mm.length() == 1) mm = "0"+mm;
			day += "\""+yy+"-"+mm+"\",";
			day2 +=  yy+"-"+mm +",";
			day3 = yy+"-"+mm;
			if(i<=5) cpTotVos.add(adminDAO.getCpMonthTot(day3));
		}
		day=day.substring(0,day.length()-1);
		day2 = day2.substring(0,day2.length()-1) + "\"";
		List<Integer> userTotVos = adminDAO.getUserMonthTot(day,day2);
		
		List<UserVO> userVOS = adminDAO.getRecentUserInfo();
		
		int userTot = adminDAO.getUserCount();
		int cpTot = adminDAO.getCpCount();
		int helpTot = adminDAO.getHelpCount();
		int reportTot = adminDAO.getReportCount();
		
		
		model.addAttribute("userTotVos",userTotVos);
		model.addAttribute("cpTotVos",cpTotVos);
		model.addAttribute("userVOS",userVOS);
		model.addAttribute("userTot",userTot);
		model.addAttribute("cpTot",cpTot);
		model.addAttribute("helpTot",helpTot);
		model.addAttribute("reportTot",reportTot);
		return "admin/main";
	}
	
	@RequestMapping("/userManage")
	public String userManageGet(Model model) {
		List<UserVO> vos = adminDAO.getAllUserInfo();
		model.addAttribute("vos",vos);
		return "admin/userManage";
	}
	
	@ResponseBody
	@RequestMapping(value = "/getUserInfo", method = RequestMethod.POST)
	public UserVO getUserInfoPost(@RequestParam("mid") String mid) {
		UserVO vo = createService.getIdCheck(mid);
		return vo;
	}
	
	@RequestMapping("/companyManage")
	public String companyManageGet(Model model) {
		List<CompanyVO> vos = companyService.getAllCpList();
		model.addAttribute("vos",vos);
		return "admin/companyManage";
	}
	
	@ResponseBody
	@RequestMapping(value = "/getCpDetailInfo", method = RequestMethod.POST)
	public Map<String, Object> getCpDetaiInfoPost(@RequestParam("idx") int idx) {
		Map<String, Object> map = companyService.getCpDetailInfo(idx);
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateCpInfo", method = RequestMethod.POST)
	public String updateCpInfoPost(CompanyVO vo) {
		int res = companyService.setUpdateCpInfo(vo);
		return "" + res;
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateUserInfo", method = RequestMethod.POST)
	public String updateUserInfoPost(UserVO vo,@RequestParam("act") String act) {
		int res = 0;
		if(!act.equals("off")) vo.setAccStop(null);
		if(act.equals("del")) return adminDAO.userDelete(vo.getIdx())+"";
		res = adminDAO.updateUserInfo(vo);
		return "" + res;
	}
	
	@RequestMapping("/chatHistory")
	public String chatHistoryGet(Model model) {
		List<UserVO> vos = adminDAO.getAllChatList();
		model.addAttribute("vos",vos);
		return "admin/chatHistory";
	}
	
	@RequestMapping("/creditHistroy")
	public String creditHistroyGet(Model model) {
		List<PaymentVO> vos = adminDAO.getAllPaymentList();
		model.addAttribute("vos",vos);
		return "admin/creditHistroy";
	}
	
	@ResponseBody
	@RequestMapping(value="/getPaymentInfo", method = RequestMethod.POST)
	public PaymentVO getPaymentInfoPost(@RequestParam("idx") int idx) {
		PaymentVO vo = adminDAO.getPaymentInfo(idx);
		return vo;
	}
	
	@RequestMapping("/reportManage")
	public String reportManageGet(Model model) {
		List<ReportVO> vos = adminDAO.getAllReportList();
		model.addAttribute("vos",vos);
		return "admin/reportManage";
	}
	
	@ResponseBody
	@RequestMapping(value="/userAccDisable", method = RequestMethod.POST)
	public String userAccDisablePost(ReportVO vo,@RequestParam("stopDay") String stopDay) {
		int res = adminDAO.userAccDisable(vo,stopDay);
		return res + "";
	}
	
	@RequestMapping("/helpManage")
	public String helpManageGet(Model model) {
		List<HelpVO> vos = adminDAO.getAllHelpList();
		model.addAttribute("vos",vos);
		return "admin/helpManage";
	}
	
	@ResponseBody
	@RequestMapping(value="/helpInfo", method = RequestMethod.POST)
	public HelpVO helpInfoPost(@RequestParam("idx") int idx) {
		HelpVO vo = adminDAO.gethelpInfo(idx);
		return vo;
	}
	@ResponseBody
	@RequestMapping(value="/helpAnswer", method = RequestMethod.POST)
	public String helpAnswerPost(HelpVO vo) {
		vo.setAnswer(vo.getAnswer().replaceAll("\n", "<br/>"));
		int res = adminDAO.helpAnswer(vo);
		return res + "";
	}
	
}

