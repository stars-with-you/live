/*
  Created: 方磊
  Date: 2017年9月1日  上午9:46:41

*/
package com.fl.urlpr.service.impl;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.fl.urlpr.service.MyUrlFilterService;
import com.fl.urlpr.service.PsShiroService;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.web.filter.mgt.DefaultFilterChainManager;
import org.apache.shiro.web.filter.mgt.PathMatchingFilterChainResolver;
import org.apache.shiro.web.servlet.AbstractShiroFilter;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import com.fl.common.CommonHelp;
import com.fl.mapper.PsShiroMapper;
import com.fl.model.PsShiro;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;

@Service
public class PsShiroServiceImpl implements PsShiroService {
	@Autowired
	private PsShiroMapper psShiroMapper;

	@Autowired
	private MyUrlFilterService myUrlFilterService;

	private static final Logger log = org.slf4j.LoggerFactory.getLogger(PsShiroServiceImpl.class.getName());


	/**
	 * 获取所有的shiro url拦截信息
	 * 
	 * @return
	 */
	public Map<String, String> SelectAll() {
		List<PsShiro> list = psShiroMapper.selectAll();
		Map<String, String> map = new LinkedHashMap<String, String>();
		for (int i = 0; i < list.size(); i++) {
			map.put(list.get(i).getSkey(), list.get(i).getSvalue());
		}
		return map;
	}

	public String getData(int currentPage, int pagesize, PsShiro model)
			throws JsonGenerationException, JsonMappingException, IOException {

		PageHelper.startPage(currentPage, pagesize);
		List<PsShiro> list = psShiroMapper.selectList(model);

		PageInfo<PsShiro> pageinfo = new PageInfo<PsShiro>(list);

		int totalcount = (int) pageinfo.getTotal();
		String json;
		try {

			json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
					+ CommonHelp.ConvertToJson(list) + "}";
		} catch (Exception e) {
			json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
		}
		return json;
	}

	public String Add(PsShiro model) {
		int i;
		try {
			i = psShiroMapper.insert(model);
            myUrlFilterService.updatePermission();
		} catch (Exception e) {
			try {
				log.error("url权限拦截信息添加失败" + CommonHelp.ConvertToJson(model), e);
			} catch (Exception e1) {
			}
			return e.getMessage();
		}
		return String.valueOf(i);
	}

	/**
	 * 设置sguid为无效
	 * 
	 * @param sguid
	 * @return
	 */
	public String Del(String sguid) {
		int i;
		try {
			PsShiro record = new PsShiro();
			record.setIsdel("1");
			record.setSguid(sguid);
			i = psShiroMapper.updateIsDel(record);
			//myShiroFilterFactoryBean.setFilterChainDefinitions("/manager/exit = logout");
			myUrlFilterService.updatePermission();
		} catch (Exception e) {
			try {
				log.error("url拦截信息删除失败", e);
			} catch (Exception e1) {
			}
			return e.getMessage();
		}
		return String.valueOf(i);
	}

	/**
	 * 获取一条url权限拦截
	 * 
	 * @param sguid
	 * @return
	 */
	public String GetSingle(String sguid) {
		PsShiro model = new PsShiro();
		model.setSguid(sguid);
		PsShiro list = psShiroMapper.selectList(model).get(0);
		String json;
		try {
			json = CommonHelp.ConvertToJson(list);
		} catch (Exception e) {
			json = "";
		}
		return json;
	}

	/**
	 * 修改一条权限
	 * @param model
	 * @return
	 */
	public String UpdateBySguid(PsShiro model) {
		int i;
		try {
			i = psShiroMapper.updateSelective(model);
			myUrlFilterService.updatePermission();
		} catch (Exception e) {
			try {
				log.error("url拦截信息修改失败" + CommonHelp.ConvertToJson(model), e);
			} catch (Exception e1) {
			}
			return e.getMessage();
		}
		return String.valueOf(i);
	}

}
