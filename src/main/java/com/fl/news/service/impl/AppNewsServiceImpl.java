/*
  Created: 方磊
  Date: 2017年8月4日  上午11:11:15

*/
package com.fl.news.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.springframework.stereotype.Service;

import com.fl.common.CommonHelp;
import com.fl.mapper.AppNewsinfoMapper;
import com.fl.model.AppNewsinfo;
import com.fl.news.service.AppNewsService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Service
public class AppNewsServiceImpl implements AppNewsService {

	@Resource
	private AppNewsinfoMapper appNewsMapper;

	private static final Logger log = org.slf4j.LoggerFactory.getLogger(AppNewsServiceImpl.class.getName());

	/*
	 * 获取分页数据json格式
	 */
	public String getData(int currentPage, int pagesize, AppNewsinfo model) {

		PageHelper.startPage(currentPage, pagesize);
		List<AppNewsinfo> list = appNewsMapper.selectList(model);

		PageInfo<AppNewsinfo> pageinfo = new PageInfo<AppNewsinfo>(list);

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

	public String Add(AppNewsinfo model) {
		int i;
		try {
			i = appNewsMapper.insert(model);
		} catch (Exception e) {
			try {
				log.error("新闻信息添加失败" + CommonHelp.ConvertToJson(model), e);
			} catch (Exception e1) {
			}
			return e.getMessage();
		}
		return String.valueOf(i);

	}

	public String DelByNid(String nid) {
		int i;
		try {
			i = appNewsMapper.deleteByPrimaryKey(nid);
		} catch (Exception e) {
			try {
				log.error("菜单信息删除失败" + nid, e);
			} catch (Exception e1) {
			}
			return e.getMessage();
		}
		return String.valueOf(i);
	}

	public String GetSingle(String nid) {
		AppNewsinfo model = new AppNewsinfo();
		model.setNid(nid);
		AppNewsinfo list = appNewsMapper.selectSingle(nid);
		String json;
		try {
			json = CommonHelp.ConvertToJson(list);
		} catch (Exception e) {
			json = "";
		}
		return json;
	}

	public AppNewsinfo GetSingleOjb(String nid) {
		AppNewsinfo model = new AppNewsinfo();
		model.setNid(nid);
		AppNewsinfo list = appNewsMapper.selectSingle(nid);
		return list;
	}

	public String UpdateByMid(AppNewsinfo model) {
		int i;
		try {
			i = appNewsMapper.update(model);
		} catch (Exception e) {
			try {
				log.error("菜单信息删除失败" + CommonHelp.ConvertToJson(model), e);
			} catch (Exception e1) {
			}
			return e.getMessage();
		}
		return String.valueOf(i);
	}

}
