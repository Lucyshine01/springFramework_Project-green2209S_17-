package com.spring.green2209S_17;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.socket.TextMessage;

import com.spring.green2209S_17.pagination.PageVO;
import com.spring.green2209S_17.service.CompanyService;
import com.spring.green2209S_17.service.CreateService;
import com.spring.green2209S_17.service.MemberService;
import com.spring.green2209S_17.service.PaymentService;
import com.spring.green2209S_17.service.ReplyService;
import com.spring.green2209S_17.vo.CompanyImgVO;
import com.spring.green2209S_17.vo.CompanyVO;
import com.spring.green2209S_17.vo.HelpVO;
import com.spring.green2209S_17.vo.PaymentVO;
import com.spring.green2209S_17.vo.PointVO;
import com.spring.green2209S_17.vo.ReplyVO;
import com.spring.green2209S_17.vo.UserVO;

@Controller
@RequestMapping("/member")
public class MemberController {
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	CreateService createService;
	
	@Autowired
	CompanyService companyService;
	
	@Autowired
	ReplyService replyService;
	
	@Autowired
	PaymentService paymentService;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@ResponseBody
	@RequestMapping(value = "/login", method = RequestMethod.POST, produces = "application/text; charset=UTF-8")
	public String loginPost(@RequestParam("mid") String mid, @RequestParam("pwd") String pwd,
			@RequestParam(name = "rememId", defaultValue = "", required = false) String rememId,
			HttpServletResponse response, HttpServletRequest request, HttpSession session) {
		String data = memberService.loginCheck(mid,pwd,rememId,request,response,session);
		return data;
	}
	
	@RequestMapping(value = "/logout")
	public String logoutGet(HttpSession session, HttpServletRequest request) {
		session.invalidate();
		return "redirect:/";
	}
	
	@ResponseBody
	@RequestMapping(value = "/logout", method = RequestMethod.POST)
	public String logoutPost(HttpSession session) {
		session.invalidate();
		return "";
	}
	
	@RequestMapping(value = "/companyInfo")
	public String companyInfoGet(HttpSession session, Model model) {
		String mid = (String)session.getAttribute("sMid");
		if(mid == null) return "redirect:/";
		UserVO userVO = memberService.getUserInfo(mid);
		CompanyVO vo = companyService.getCpInfo(mid);
		CompanyImgVO voImg = companyService.getCpImgInfo(vo.getIdx());
		model.addAttribute("userVO", userVO);
		model.addAttribute("vo", vo);
		model.addAttribute("voImg", voImg);
		return "company/companyInfo";
	}
	
	@Transactional
	@RequestMapping(value = "/inputCPImg", method = RequestMethod.POST)
	public String inputCPImgPost(HttpSession session, MultipartHttpServletRequest file, HttpServletRequest request) {
		String mid = (String)session.getAttribute("sMid");
		String url = "";
		if(request.isSecure()) url = request.getHeader("referer").replace("https://", "");
		else url = request.getHeader("referer").replace("http://", "");
		
		int res = memberService.inputCPImg(file,request,mid);
		if(res == 0) return "redirect:/msg/saveImgFail?url="+url;
		return "redirect:"+request.getHeader("referer");
	}
	
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/cpIntroImgDelete", method = RequestMethod.POST)
	public String cpIntroImgDeletePost(HttpSession session, HttpServletRequest request,
			@RequestParam("imgName") String imgName) {
		String mid = (String)session.getAttribute("sMid");
		int res = memberService.cpIntroImgDelete(imgName,request,mid);
		return res+"";
	}
	
	@RequestMapping(value = "/companyList")
	public String companyListGet(HttpSession session, Model model, PageVO pageVO,
			@RequestParam(name = "categori", defaultValue = "all", required = false) String categori,
			@RequestParam(name = "detail", defaultValue = "", required = false) String detail,
			@RequestParam(name = "orderBy", defaultValue = "createDayCP", required = false) String orderBy,
			@RequestParam(name = "order", defaultValue = "desc", required = false) String order,
			@RequestParam(name = "searching", defaultValue = "", required = false) String searching,
			@RequestParam(name = "searchItem", defaultValue = "all", required = false) String searchItem
			) {
		String[] categoris = {"인테리어","시공","디자인"};
		String[] interior = {"홈 인테리어","상업 인테리어","조명 인테리어","욕실,화장실 인테리어"};
		String[] installation = {"타일시공","페인트시공","싱크대 교체","도배장판","인테리어 필름"};
		String[] design = {"도면 제작","인테리어 컨설팅","도면 제작·수정"};
		model.addAttribute("categori",categori);
		
		String categoriWord[] = null;
		
		int errorCheckSW = 0;
		if(categori.equals("1")) {
			model.addAttribute("categoriName",categoris[Integer.parseInt(categori)-1]);
			if(detail.equals("1") || detail.equals("2") || detail.equals("3") || detail.equals("4")) {
				categoriWord = companyListSub(model,interior[Integer.parseInt(detail)-1]);
				errorCheckSW = 1;
			}
			else categoriWord = companyListSub(model,interior);
		}
		else if(categori.equals("2")) {
			model.addAttribute("categoriName",categoris[Integer.parseInt(categori)-1]);
			if(detail.equals("1") || detail.equals("2") || detail.equals("3") || detail.equals("4") || detail.equals("5")) {
				categoriWord = companyListSub(model,installation[Integer.parseInt(detail)-1]);
				errorCheckSW = 1;
			}
			else categoriWord = companyListSub(model,installation);
		}
		else if(categori.equals("3")) {
			model.addAttribute("categoriName",categoris[Integer.parseInt(categori)-1]);
			if(detail.equals("1") || detail.equals("2") || detail.equals("3")) {
				categoriWord = companyListSub(model,design[Integer.parseInt(detail)-1]);
				errorCheckSW = 1;
			}
			else categoriWord = companyListSub(model,design);
		}
		else if(categori.equals("all")) {
			model.addAttribute("categoriName","전체 목록");
			errorCheckSW = 1;
		}
		if(errorCheckSW == 0 && !detail.equals("")) return "redirect:/msg/wrongUrl";
		else if(!detail.equals("")) model.addAttribute("detail",detail);
		if(pageVO.getPageSize() == 0) pageVO.setPageSize(9);
		
		if(!searching.equals("")) {
			model.addAttribute("searching",searching);
			model.addAttribute("searchItem",searchItem);
			memberService.getCompnayList(pageVO, model, categoriWord, orderBy, order, searchItem, searching);
		}
		else memberService.getCompnayList(pageVO,model,categoriWord,orderBy,order, searchItem, searching);
		
		model.addAttribute("orderBy",orderBy);
		model.addAttribute("order",order);
		return "content/companyList";
	}
	
	private String[] companyListSub(Model model, String word) {
		String categoriWord[];
		model.addAttribute("subCategori",word);
		categoriWord = new String[]{word};
		return categoriWord;
	}
	private String[] companyListSub(Model model, String[] word) {
		String categoriWord[];
		categoriWord = word;
		return categoriWord;
	}
	
	@RequestMapping(value =  "/companyInfoView")
	public String companyInfoViewGet(HttpSession session, Model model,
			@RequestParam(name = "no", defaultValue = "", required = false ) String no) {
		int idx = 0;
		try {idx = Integer.parseInt(no);} 
		catch (NumberFormatException e) {return "redirect:/msg/wrongURL";}
		
		ObjectMapper objectMapper = new ObjectMapper();
		HashMap<String, Object> hashMap = companyService.getCpDetailInfo(idx);
		CompanyVO vo = objectMapper.convertValue(hashMap, CompanyVO.class);
		CompanyImgVO imgVO = companyService.getCpImgInfo(vo.getIdx());
		
		UserVO userVO = memberService.getUserInfo(vo.getMid());
		
		List<ReplyVO> replyVOS = memberService.getReplyList("c"+vo.getIdx(),0,5);
		int replyTot = 0;
		double avgRating = 0;
		
		if(replyVOS.size()>0) {
			replyTot = memberService.getReplyTot("c"+vo.getIdx());
			avgRating = replyService.getReplyRatingAvg("c"+vo.getIdx());
		}
		
		try {
			Map<String, String> map = new HashMap<String, String>();
			ObjectMapper mapper = new ObjectMapper();
			String view = (String)session.getAttribute("view");
			if(view == null) {
				map.put("c"+vo.getIdx(), "1");
				vo.setViewCP(vo.getViewCP()+1);
			}
			else {
				map = mapper.readValue(view, Map.class);
				if(map.get("c"+vo.getIdx()) == null) {
					memberService.cpViewCntUpdate(vo.getIdx());
					map.put("c"+vo.getIdx(), "1");
					vo.setViewCP(vo.getViewCP()+1);
				}
			}
			session.removeAttribute("view");
			view = mapper.writeValueAsString(map);
			session.setAttribute("view", view);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		model.addAttribute("vo",vo);
		model.addAttribute("imgVO",imgVO);
		model.addAttribute("userVO", userVO);
		model.addAttribute("replyVOS", replyVOS);
		model.addAttribute("replyTot", replyTot);
		model.addAttribute("avgRating", avgRating);
		model.addAttribute("replyPag", 1);
		
		
		
		return "content/companyInfoView";
	}
	
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/submitReply", method = RequestMethod.POST)
	public String submitReplyPost(HttpSession session, HttpServletRequest request,
			@RequestParam(name = "mid", defaultValue = "", required = false ) String mid,
			@RequestParam(name = "boardIdx", defaultValue = "", required = false ) String boardIdx,
			@RequestParam(name = "rating", defaultValue = "", required = false ) String rating,
			@RequestParam(name = "content", defaultValue = "", required = false ) String content
			) {
		String profileImg = (String)session.getAttribute("sProfileImg");
		int res = 0;
		if(!mid.equals("") && !boardIdx.equals("") && !rating.equals("") && !content.equals("")) {
			res = replyService.submitReply(mid,boardIdx,rating,content,profileImg);
			
			if(res == 1) {
				int cpIdx = Integer.parseInt(boardIdx.replace("c", ""));
				String noticeType = "boardReply/"+mid;
				String noticeContent = mid+"님이 업체 리뷰를 작성하였습니다.";
				String noctieMid = (String)companyService.getCpDetailInfo(cpIdx).get("mid");
				String url = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/member/companyInfoView?no="+cpIdx;
				replyService.replyNotice(noticeType,noticeContent,noctieMid,url);
			}
		}
		return res+"";
	}
	
	@ResponseBody
	@RequestMapping(value = "/loadBeforeReply", method = RequestMethod.POST)
	public List<ReplyVO> loadBeforeReplyPost(@RequestParam("replyPag") int replyPag,
			@RequestParam("boardIdx") String boardIdx) {
		int num = replyPag*5 - 5;
		List<ReplyVO> vos = memberService.getReplyList(boardIdx,num,num);
		return vos;
	}
	
	@ResponseBody
	@RequestMapping(value = "/replyDelete", method = RequestMethod.POST)
	public String replyDeletePost(@RequestParam("idx") int idx) {
		int res = replyService.deleteReply(idx);
		return res + "";
	}
	@ResponseBody
	@RequestMapping(value = "/replyReport", method = RequestMethod.POST)
	public String replyReportPost(HttpSession session,
			@RequestParam("idx") int idx, @RequestParam("reportContent") String reason) {
		String mid = (String) session.getAttribute("sMid");
		if(mid == null || reason.equals("")) return "0";
		int res = replyService.reportReply(idx,mid,reason);
		return res + "";
	}
	
	@RequestMapping(value = "/myInfo", method = RequestMethod.GET)
	public String myInfoGET(HttpSession session,Model model) {
		String mid = (String) session.getAttribute("sMid");
		UserVO vo = createService.getIdCheck(mid);
		List<PointVO> pointVOS = memberService.getPointInfo(mid);
		model.addAttribute("vo", vo);
		model.addAttribute("pointVOS", pointVOS);
		return "content/myInfo";
	}
	
	@ResponseBody
	@RequestMapping(value = "/getBuyCode", method = RequestMethod.POST, produces = "application/text; charset=UTF-8")
	public String getBuyCodePost(@RequestParam("selectIdx") String idx) {
		if(!idx.equals("1") && !idx.equals("2") && !idx.equals("3") && !idx.equals("4") && !idx.equals("5")) return "0";
		String[] product = {"","1000 포인트","5000 포인트","10000 포인트","30000 포인트","100000 포인트"};
		int[] amount = {0, 1000, 5000, 9200, 27000, 88000};
		Date date = new Date();
		SimpleDateFormat nowFormat = new SimpleDateFormat("ddssHHyyyymmMM");
		long code = Long.parseLong("99999999999999") - Long.parseLong(nowFormat.format(date));
		UUID uid = UUID.randomUUID();
		String randomId = uid.toString().substring(0,5);
		String buyCode = code + "-" + randomId;
		
		return buyCode + "/" + product[Integer.parseInt(idx)] + "/" + amount[Integer.parseInt(idx)];
	}
	
	@ResponseBody
	@RequestMapping(value = "/productBuy", method = RequestMethod.POST)
	public Map<String, Object> productBuyPost(@RequestBody PaymentVO vo, HttpSession session) {
		String mid = (String)session.getAttribute("sMid");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("res", "0");
		if(mid == null) return map;
		vo.setBuyer_name(mid);
		int res = paymentService.setPaymentWrite(vo);
		if(res == 1) {
			map.put("res", "1");
			map.put("productName", vo.getName());
		}
		return map;
	}
	
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/pointBuyingProcess", method = RequestMethod.POST)
	public String pointBuyingProcessPost(@RequestBody Map<String, Object> mapData, HttpSession session) {
		String mid = (String)session.getAttribute("sMid");
		String[] product = {"1000 포인트","5000 포인트","10000 포인트","30000 포인트","100000 포인트"};
		int[] productPt = {1000,5000,10000,30000,100000};
		Map<String, Integer> productMap = new HashMap<String, Integer>();
		for(int i=0; i<product.length; i++) productMap.put(product[i], productPt[i]);
		int point = productMap.get(mapData.get("productName"));
		
		int res = paymentService.userChargePoint(mid,point);
		return res+"";
	}
	
	@ResponseBody
	@RequestMapping(value = "/myinfoUpdate", method = RequestMethod.POST)
	public String myinfoUpdatePost(UserVO vo, HttpSession session) {
		int res = memberService.updateUserInfo(vo);
		return res+"";
	}
	
	@ResponseBody
	@RequestMapping(value = "/oldPwdCheck", method = RequestMethod.POST)
	public String oldPwdCheckPost(HttpSession session, @RequestParam("pwd") String pwd) {
		String mid = (String)session.getAttribute("sMid");
		UserVO vo = createService.getIdCheck(mid);
		if(passwordEncoder.matches(pwd, vo.getPwd())) return "1";
		return "0";
	}
	
	@ResponseBody
	@RequestMapping(value = "/pwdUpdate", method = RequestMethod.POST)
	public String pwdUpdatePost(HttpSession session, @RequestParam("pwd") String pwd) {
		String mid = (String)session.getAttribute("sMid");
		String newPwd = passwordEncoder.encode(pwd);
		int res = memberService.updateUserPwd(mid,newPwd);
		
		return res+"";
	}
	
	@RequestMapping(value = "/helpCenter", method = RequestMethod.GET)
	public String helpCenterGet(HttpSession session, Model model) {
		String mid = (String)session.getAttribute("sMid");
		List<HelpVO> vos = memberService.getHelpList(mid);
		model.addAttribute("vos",vos);
		model.addAttribute("tot",vos.size());
		return "help/help";
	}
	
	@ResponseBody
	@RequestMapping(value = "/helpInput", method = RequestMethod.POST)
	public String helpInputPost(HttpSession session,HelpVO vo) {
		String mid = (String)session.getAttribute("sMid");
		
		int res = memberService.helpInput(vo,mid);
		
		return res+"";
	}
	
	@Transactional
	@RequestMapping(value = "/profileChange", method = RequestMethod.POST)
	public String profileChangePost(HttpSession session, MultipartHttpServletRequest file, HttpServletRequest request) {
		String mid = (String)session.getAttribute("sMid");
		UserVO vo = memberService.getUserInfo(mid);
		memberService.profileChange(file,request,vo);
		return "redirect:"+request.getHeader("referer");
	}
	
	@ResponseBody
	@RequestMapping(value = "/profileDefault", method = RequestMethod.POST)
	public String profileDefaultPost(HttpSession session, HttpServletRequest request) {
		String mid = (String)session.getAttribute("sMid");
		UserVO vo = memberService.getUserInfo(mid);
		memberService.profileDefault(vo,request);
		return "";
	}
	
}
