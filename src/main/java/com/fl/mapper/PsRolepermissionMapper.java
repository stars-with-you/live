package com.fl.mapper;

import java.util.List;

import com.fl.model.PsRolepermission;

public interface PsRolepermissionMapper {
	int DelByRid(String rid);

	int AddRolePerm(List<PsRolepermission> list);
}