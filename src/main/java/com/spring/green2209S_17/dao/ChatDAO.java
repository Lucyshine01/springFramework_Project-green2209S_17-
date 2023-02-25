package com.spring.green2209S_17.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.green2209S_17.vo.ChatContentVO;
import com.spring.green2209S_17.vo.ChatRoomVO;

public interface ChatDAO {

	public List<ChatRoomVO> getRoomId(@Param("mid") String mid);

	public void createRoomId(@Param("mid") String mid,@Param("cMid") String cMid,@Param("roomId") String roomId);

	public ChatRoomVO getRoomInfo(@Param("roomId") String roomId);

	public List<ChatContentVO> getChatList(@Param("userId_1") String userId_1, @Param("userId_2") String userId_2,@Param("start") int start,@Param("end") int end);

	public String getLastChatIdx(@Param("userId_1") String userId_1, @Param("userId_2") String userId_2);

	public void saveChatContent(@Param("content") String content, @Param("myMid") String myMid, @Param("oppMid") String oppMid);

}
