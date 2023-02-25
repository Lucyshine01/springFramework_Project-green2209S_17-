package com.spring.green2209S_17.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.green2209S_17.vo.ReplyVO;

public interface ReplyDAO {

	public String[] getStarList(@Param("star_WHERE") String star_WHERE,@Param("star_FIND_IN_SET") String star_FIND_IN_SET);

	public List<ReplyVO> getReplyList(@Param("boardIdx") String boardIdx,@Param("start") int start, @Param("end") int end);

	public int getReplyTot(@Param("boardIdx") String boardIdx);

	public int submitReply(@Param("mid") String mid,@Param("boardIdx") String boardIdx,@Param("rating") String rating, @Param("content") String content, @Param("profileImg") String profileImg);

	public double getReplyRatingAvg(@Param("boardIdx") String boardIdx);

	public int deleteReply(@Param("idx") int idx);

	public int reportReply(@Param("idx") int idx,@Param("mid") String mid, @Param("reason") String reason);

}
