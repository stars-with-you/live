package com.fl.mapper;

import java.util.List;

import com.fl.model.AppNewsinfo;

public interface AppNewsinfoMapper {
	List<AppNewsinfo> selectList(AppNewsinfo model);

	AppNewsinfo selectSingle(String nide);

	int deleteByPrimaryKey(String mid);

	int insert(AppNewsinfo model);

	int update(AppNewsinfo model);
}