package com.spring.green2209S_17.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.green2209S_17.vo.ChatVO;
import com.spring.green2209S_17.vo.NoticeVO;

public interface NoticeDAO {

	public NoticeVO getNoticeType(@Param("noticeType") String noticeType, @Param("noctieMid") String noctieMid);

	public void createNotice(@Param("noticeType") String noticeType,@Param("noticeContent") String noticeContent,@Param("noctieMid") String noctieMid,@Param("url") String url);

	public void updateNotice(@Param("noticeType") String noticeType,@Param("noticeContent") String noticeContent,@Param("noctieMid") String noctieMid,@Param("url") String url);

	public List<NoticeVO> checkNotice(@Param("mid") String mid);

	public void noticeCheck(@Param("idxList") String idxList);

	public void noticeDelete(@Param("idx") int idx);

	public List<ChatVO> loadRoomData(@Param("mid") String mid);

}
