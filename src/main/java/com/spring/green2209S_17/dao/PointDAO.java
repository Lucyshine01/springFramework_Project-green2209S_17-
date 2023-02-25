package com.spring.green2209S_17.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.green2209S_17.vo.PointVO;

public interface PointDAO {

	public void usePoint(@Param("mid") String mid, @Param("usePoint") int usePoint, @Param("leftPoint") int leftPoint,
			@Param("useContent") String useContent);

	public void updatePoint(@Param("mid") String mid, @Param("leftPoint")  int leftPoint);

	public List<PointVO> getPointInfo(@Param("mid") String mid);

}
