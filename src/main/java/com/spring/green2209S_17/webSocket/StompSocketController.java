package com.spring.green2209S_17.webSocket;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.green2209S_17.dao.ChatDAO;
import com.spring.green2209S_17.dao.CompanyDAO;
import com.spring.green2209S_17.dao.CreateDAO;
import com.spring.green2209S_17.dao.NoticeDAO;
import com.spring.green2209S_17.dao.PointDAO;
import com.spring.green2209S_17.service.PointService;
import com.spring.green2209S_17.vo.ChatContentVO;
import com.spring.green2209S_17.vo.ChatRoomVO;
import com.spring.green2209S_17.vo.CompanyVO;
import com.spring.green2209S_17.vo.NoticeVO;
import com.spring.green2209S_17.vo.UserVO;

@Controller
@Service
public class StompSocketController {
	
	@Autowired
	private SimpMessagingTemplate simpMessagingTemplate;
	
	@Autowired
	ChatDAO chatDAO;
	
	@Autowired
	CreateDAO createDAO;
	
	@Autowired
	CompanyDAO companyDAO;
	
	@Autowired
	NoticeDAO noticeDAO;
	
	@Autowired
	PointService pointService;
	
	private String arriveMsg = "";
	
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/chatRoomCheck", method = RequestMethod.POST)
	public String chatRoomCheckPost(HttpSession session, @RequestParam("idx") int idx) {
		String mid = (String) session.getAttribute("sMid");
		String roomId = "";
		List<ChatRoomVO> vos = chatDAO.getRoomId(mid);
		Map<String, Object> map = companyDAO.getCpDetailInfo(idx);
		if(mid.equals((String)map.get("mid"))) return "over";
		if(vos.size() != 0) {
			for(int i=0; i<vos.size(); i++) {
				if(vos.get(i).getUserId_1().equals((String)map.get("mid"))) {
					roomId = vos.get(i).getRoomId();
					break;
				}
				else if(vos.get(i).getUserId_2().equals((String)map.get("mid"))) {
					roomId = vos.get(i).getRoomId();
					break;
				}
			}
		}
		
		if(roomId.equals("")) {
			UserVO userVO = createDAO.getIdCheck(mid);
			if(userVO.getPoint() < 100) return "0";
			pointService.usePoint(userVO.getMid(), 100, userVO.getPoint()-100, map.get("cpName")+"님과의 채팅방 개설");
			UUID randomId = UUID.randomUUID();
			roomId = randomId.toString();
			chatDAO.createRoomId(mid,(String)map.get("mid"),roomId);
		}
		
		return roomId;
	}
	
	@RequestMapping(value = "/chatRoom", method = RequestMethod.GET)
	public String chatRoomGet(Model model, HttpSession session,
			@RequestParam("roomId") String roomId) {
		String mid = (String) session.getAttribute("sMid");
		if(mid == null) return "redirect:/msg/sessionOver";
		ChatRoomVO roomVO = chatDAO.getRoomInfo(roomId);
		String str_LastIdx = chatDAO.getLastChatIdx(roomVO.getUserId_1(),roomVO.getUserId_2());
		int lastIdx = 0;
		if(str_LastIdx != null) lastIdx = Integer.parseInt(str_LastIdx); 
		List<ChatContentVO> vos = chatDAO.getChatList(roomVO.getUserId_1(),roomVO.getUserId_2(),0,20);
		model.addAttribute("vos",vos);
		model.addAttribute("roomId",roomId);
		model.addAttribute("lastIdx",lastIdx);
		String oppMid = !roomVO.getUserId_1().equals(mid) ? roomVO.getUserId_1() : roomVO.getUserId_2();
		model.addAttribute("oppMid",oppMid);
		
		CompanyVO cpVO = companyDAO.getCpInfo(oppMid);
		
		String oppName = "";
		String oppProfile = "";
		if(cpVO != null) {
			oppName = cpVO.getCpName();
			oppProfile = "cpProfile/" + companyDAO.getCpImgInfo(cpVO.getIdx()).getCpImg();
		}
		else {
			oppName = oppMid;
			oppProfile = "profile/" + createDAO.getIdCheck(oppMid).getProfile();
		}
		model.addAttribute("oppName",oppName);
		model.addAttribute("oppProfile",oppProfile);
		return "content/chatRoom";
	}
	
	@Transactional
	@MessageMapping("/chattingRoom")
	public @ResponseBody void chattingMsg(@RequestBody Map<String, String> msg) {
		LocalDate now = LocalDate.now();
    LocalDateTime nowTime = LocalDateTime.now();
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일");
    
		String time = nowTime.format(timeFormatter);
		String newDate = now.format(dateFormatter);
		
		String myMid = msg.get("mid");
		String oppMid = msg.get("oppMid");
		String roomId = msg.get("roomId");
		String content = msg.get("content");
		
//		System.out.println("Content : " + content);
//		System.out.println("myMid : " + myMid);
//		System.out.println("oppMid : " + oppMid);
//		System.out.println("roomId : " + roomId);
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, String> map = new HashMap<String, String>();
		map.put("mid", myMid);
		map.put("time", time);
		map.put("newDate", newDate);
		map.put("content", content);
		String payload = "";
		try {
			payload = mapper.writeValueAsString(map);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		simpMessagingTemplate.convertAndSend("/topic/"+roomId,payload);
		chatDAO.saveChatContent(content,myMid,oppMid);
		
		arriveCheck(myMid,oppMid);
	}
	
	private void arriveCheck(String myMid, String oppMid) {
		try {
			Thread.sleep(500);
			if(!arriveMsg.equals("arriveOk")) {
				String noticeType = "1-to-1/"+myMid;
				NoticeVO noticeVO = noticeDAO.getNoticeType(noticeType,oppMid);
				String myName = myMid;
				CompanyVO companyVO = companyDAO.getCpInfo(myMid);
				
				if(companyVO != null) myName = companyVO.getCpName();
				String noticeContent = myName+"님이 회원님께 채팅메세지를 보내왔습니다.";
				if(noticeVO == null) noticeDAO.createNotice(noticeType,noticeContent,oppMid,"");
				else noticeDAO.updateNotice(noticeType,noticeContent,oppMid,"");
			}
			else arriveMsg = "";
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
	
	@MessageMapping("/arrive")
	public void arriveMsg(String msg) {
		String roomId = msg.substring(0,msg.indexOf("/")+1);
		arriveMsg = msg.substring(msg.indexOf("/")+1);
		simpMessagingTemplate.convertAndSend("/topic/"+roomId,arriveMsg);
	}
	
	@ResponseBody
	@RequestMapping(value = "/loadingChatList", method = RequestMethod.POST)
	public List<ChatContentVO> loadingChatListPost(@RequestParam("num") int num,
			@RequestParam("mid") String mid, @RequestParam("oppMid") String oppMid) {
		List<ChatContentVO> vos = chatDAO.getChatList(mid,oppMid,num,20);
		return vos;
	}
	
}
