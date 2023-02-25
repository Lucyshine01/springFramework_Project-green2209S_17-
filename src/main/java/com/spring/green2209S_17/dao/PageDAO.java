package com.spring.green2209S_17.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface PageDAO {

	public int totTermRecCnt(@Param("tableName") String tableName,@Param("feildName") String feildName,@Param("feildWord") String feildWord, @Param("other") String other);
	
	public int totTermRecCntManyWords(@Param("tableName") String tableName,@Param("feildName") String feildName,@Param("feildWord") String feildWord, @Param("other") String other);
	
	public int totTermRecCnt_Search(@Param("tableName") String tableName,@Param("feildName") String feildName,@Param("feildWord") String feildWord, 
			@Param("searchItem") String searchItem,@Param("searching") String searching, @Param("other") String other);
	
	public int totTermRecCntManyWords_Search(@Param("tableName") String tableName,@Param("feildName") String feildName,@Param("feildWord") String feildWord, 
			@Param("searchItem") String searchItem,@Param("searching") String searching, @Param("other") String other);
	
	public List<HashMap<String, Object>> getTermList(@Param("select") String select, @Param("tableName") String tableName,@Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize,@Param("feildName") String feildName,@Param("feildWord") String feildWord,
			@Param("orderBy") String orderBy, @Param("order") String order, @Param("group_by") String group_by, @Param("other") String other);
	
	public List<HashMap<String, Object>> getTermListManyWords(@Param("select") String select, @Param("tableName") String tableName,@Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize,@Param("feildName") String feildName,@Param("feildWord") String feildWord,
			@Param("orderBy") String orderBy, @Param("order") String order, @Param("group_by") String group_by, @Param("other") String other);

	public List<HashMap<String, Object>> getTermList_Search(@Param("select") String select, @Param("tableName") String tableName,@Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize,@Param("feildName") String feildName,@Param("feildWord") String feildWord,
			@Param("orderBy") String orderBy, @Param("order") String order, @Param("searchItem") String searchItem, 
			@Param("searching") String searching, @Param("group_by") String group_by, @Param("other") String other);

	public List<HashMap<String, Object>> getTermListManyWords_Search(@Param("select") String select, @Param("tableName") String tableName,@Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize,@Param("feildName") String feildName,@Param("feildWord") String feildWord,
			@Param("orderBy") String orderBy, @Param("order") String order, @Param("searchItem") String searchItem, 
			@Param("searching") String searching, @Param("group_by") String group_by, @Param("other") String other);
	
	
	


}
