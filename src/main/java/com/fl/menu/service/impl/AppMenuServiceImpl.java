/*
  Created: 方磊
  Date: 2017年8月3日  上午8:45:30

*/
package com.fl.menu.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fl.common.CommonHelp;
import com.fl.mapper.AppMenuMapper;
import com.fl.menu.service.AppMenuService;
import com.fl.model.AppMenu;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Service
public class AppMenuServiceImpl implements AppMenuService {

	@Autowired
	private AppMenuMapper appMenuMapper;

	private static final Logger log = org.slf4j.LoggerFactory.getLogger(AppMenuServiceImpl.class.getName());

	public String getData(int currentPage, int pagesize, AppMenu model) {

		PageHelper.startPage(currentPage, pagesize);
		List<AppMenu> list = appMenuMapper.selectList(model);

		PageInfo<AppMenu> pageinfo = new PageInfo<AppMenu>(list);

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

	public String Add(AppMenu model) {
		// AppMenu md = new AppMenu();
		// md.setMenucode(model.getMenucode());
		// List<AppMenu> list = appMenuMapper.selectAll(md);
		// if (list.size() > 0) {
		// return "2";
		// }
		int i;
		try {
			i = appMenuMapper.insert(model);
		} catch (Exception e) {
			try {
				log.error("菜单信息添加失败" + CommonHelp.ConvertToJson(model), e);
			} catch (Exception e1) {
			}
			return e.getMessage();
		}
		return String.valueOf(i);
	}

	public String Del(String mid) {
		int i;
		try {
			i = appMenuMapper.deleteByPrimaryKey(mid);
		} catch (Exception e) {
			try {
				log.error("菜单信息删除失败" + mid, e);
			} catch (Exception e1) {
			}
			return e.getMessage();
		}
		return String.valueOf(i);
	}

	public String GetSingle(String mid) {
		AppMenu model = new AppMenu();
		model.setMid(mid);
		AppMenu list = appMenuMapper.selectAll(model).get(0);
		String json;
		try {
			json = CommonHelp.ConvertToJson(list);
		} catch (Exception e) {
			json = "";
		}
		return json;
	}

	public String UpdateByMid(AppMenu model) {
		int i;
		try {
			i = appMenuMapper.update(model);
		} catch (Exception e) {
			try {
				log.error("菜单信息删除失败" + CommonHelp.ConvertToJson(model), e);
			} catch (Exception e1) {
			}
			return e.getMessage();
		}
		return String.valueOf(i);
	}

	public String getMenu() {
		AppMenu model = new AppMenu();
		List<AppMenu> list = appMenuMapper.selectAll(model);
		String json;
		try {
			json = CommonHelp.ConvertToJson(list);
		} catch (Exception e) {
			return "";
		}
		return json;
	}

}
