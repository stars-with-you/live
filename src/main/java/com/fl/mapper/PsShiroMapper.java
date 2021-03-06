package com.fl.mapper;

import java.util.List;

import com.fl.model.PsShiro;

/**
 * shiro URL拦截配置DAO
 * 
 * @author Administrator
 *
 */
public interface PsShiroMapper {

	int insert(PsShiro record);

	List<PsShiro> selectAll();

	List<PsShiro> selectList(PsShiro record);

	int updateSelective(PsShiro record);

	int updateIsDel(PsShiro record);
}