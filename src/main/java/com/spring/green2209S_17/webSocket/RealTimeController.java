package com.spring.green2209S_17.webSocket;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.green2209S_17.dao.NoticeDAO;
import com.spring.green2209S_17.vo.ChatVO;
import com.spring.green2209S_17.vo.NoticeVO;

@Controller
@Service
@RequestMapping("/chat")
public class RealTimeController extends TextWebSocketHandler {
	
	private List<WebSocketSession> sessionList = new ArrayList<WebSocketSession>();
	
	private static final Logger log = LoggerFactory.getLogger(RealTimeController.class);
	
	@Autowired
	NoticeDAO noticeDAO;
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		log.info("접속 완료, afterConnectionEstablished");
		sessionList.add(session);
		log.info("접속 아이디 : " + session.getId());
		//log.info(session.getPrincipal().getName() + "님이 입장하셨습니다.");
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		log.info("웹소켓 유지중.. , handleMessage");
		log.info("아이디 : " + message.getPayload() + "(세션 ID : " + session.getId() + ")");
		System.out.println(sessionList);
//		for(WebSocketSession s : sessionList) {
//			//s.sendMessage(new TextMessage(session.getPrincipal().getName() + ":" + message.getPayload()));
//		}
		String date = "";
		while(true) {
			int sw = 0;
			for(WebSocketSession ws : sessionList) if(ws.getId().equals(session.getId())) sw = 1;
			if(sw != 1) break;
			List<NoticeVO> vos = noticeDAO.checkNotice(message.getPayload());
			if(vos.size()>0 && !vos.get(vos.size()-1).getNoticeDay().equals(date)) {
				for(int i=0; i<vos.size(); i++) {
					if(!vos.get(i).getUrl().equals("") && vos.get(i).getUrl() != null) {
						String url = vos.get(i).getUrl().substring(0,vos.get(i).getUrl().indexOf(":9090"));
						String sRemoteIP = session.getRemoteAddress().toString();
						String remoteIP = sRemoteIP.substring(1,sRemoteIP.indexOf(":"));
						String urlIP = url.substring(url.lastIndexOf("/")+1);
						if(!remoteIP.equals(urlIP)) vos.get(i).setUrl(vos.get(i).getUrl().replace(urlIP, remoteIP));
					}
				}
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("vos",vos);
				ObjectMapper mapper = new ObjectMapper();
				TextMessage msg = new TextMessage(mapper.writeValueAsString(map));
				session.sendMessage(msg);
				date = vos.get(vos.size()-1).getNoticeDay();
			}
			try {
				Thread.sleep(20000);
			}
			catch (InterruptedException e) {
        e.printStackTrace();
			}
		}
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		log.info("소켓 종료, afterConnectionClosed");

		sessionList.remove(session);
		log.info("종료 아이디 : " + session.getId());
		//log.info(session.getPrincipal().getName() + "님이 퇴장하셨습니다.");
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/noticeCheck", method = RequestMethod.POST)
	public String noticeCheckPost(@RequestParam("idxList") String idxList) {
		idxList = "'" + idxList.replaceAll("/", "','") + "'";
		noticeDAO.noticeCheck(idxList);
		return "";
	}
	
	@ResponseBody
	@RequestMapping(value = "/noticeDelete", method = RequestMethod.POST)
	public String noticeDeletePost(@RequestParam("idx") int idx) {
		noticeDAO.noticeDelete(idx);
		return "";
	}
	@ResponseBody
	@RequestMapping(value = "/loadRoomData", method = RequestMethod.POST)
	public List<ChatVO> loadRoomDataPost(HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		List<ChatVO> vos = noticeDAO.loadRoomData(mid);
		
		for(int i=0; i<vos.size(); i++) {
			if(vos.get(i).getOppCpMid().contains(",")) {
				for(int j=0; j<vos.get(i).getOppCpMid().split(",").length; j++) {
					if(!vos.get(i).getOppCpMid().split(",")[j].equals(mid)) vos.get(i).setOppName(vos.get(i).getOppCpName().split(",")[j]);
				}
			}
			else if(!vos.get(i).getOppCpMid().equals("")) vos.get(i).setOppName(vos.get(i).getOppCpName());
			else {
				if(!vos.get(i).getSendId().equals(mid)) vos.get(i).setOppName(vos.get(i).getSendId());
				else vos.get(i).setOppName(vos.get(i).getReceiveId());
			}
		}
		return vos;
	}
	
	
}
