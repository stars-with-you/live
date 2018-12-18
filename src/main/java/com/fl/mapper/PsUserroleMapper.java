package com.fl.mapper;

import java.util.List;

import com.fl.model.PsUserrole;

public interface PsUserroleMapper {
	int DelByRid(String pguid);

	int AddUserRole(List<PsUserrole> model);
}