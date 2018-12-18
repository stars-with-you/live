package com.fl.mapper;

import java.util.List;

import com.fl.model.AppMenu;

public interface AppMenuMapper {
	List<AppMenu> selectAll(AppMenu model);

	List<AppMenu> selectList(AppMenu model);

	int deleteByPrimaryKey(String mid);

	int insert(AppMenu model);

	int update(AppMenu model);
}