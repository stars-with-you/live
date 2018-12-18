/*
  Created: 方磊
  Date: 2017年7月26日  下午3:25:29

*/
package com.fl.news.controller;

import java.text.ParseException;
import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fl.common.CommonHelp;
import com.fl.model.AppNewsinfo;
import com.fl.news.service.AppNewsService;

@Controller
@CrossOrigin
@RequestMapping(value = "/news")
public class NewsController {

	@Resource
	private AppNewsService newsService;
	private static final String jspmaster = CommonHelp
			.getPropertyKey(CommonHelp.getProperty("config/config.properties"), "jsp.master");
	@RequestMapping(value = { "/list" }, method = RequestMethod.GET)
	public ModelAndView List(HttpServletRequest request) {
		String menucode = request.getParameter("menucode");
		ModelAndView mv = new ModelAndView();
		mv.addObject("menucode", menucode);
		mv.setViewName("/manager/list_news"+jspmaster);
		return mv;
	}

	@RequestMapping(value = "/data", method = RequestMethod.POST)
	@ResponseBody

	public String getData(int currentPage, int pagesize, AppNewsinfo model) {
		try {
			if (currentPage < 1) {
				currentPage = 1;
			}
			String rst = newsService.getData(currentPage, pagesize, model);
			return rst;
		} catch (Exception e) {

			return "";
		}
	}

	@RequestMapping(value = "/add", method = RequestMethod.POST)
	@ResponseBody
	public String Add(AppNewsinfo model) {
		model.setNid(CommonHelp.getUuid());
		model.setAddtime(new Date());
		model.setUpdatetime(new Date());
		model.setIsdel("0");
		Session session = SecurityUtils.getSubject().getSession();
		String loginname = (String) session.getAttribute("loginname");
		String displayname = (String) session.getAttribute("displayname");
		model.setAddloginname(loginname);
		model.setAdddispname(displayname);
		return newsService.Add(model);

	}

	@RequestMapping(value = "/delbynid", method = RequestMethod.POST)
	@ResponseBody
	public String DelByNid(String nid) {
		return newsService.DelByNid(nid);
	}

	@RequestMapping(value = "/getsingle")
	@ResponseBody
	public String GetSingle(String nid) {
		return newsService.GetSingle(nid);
	}

	@RequestMapping(value = "/updatebynid", method = RequestMethod.POST)
	@ResponseBody
	public String UpdateByMid(AppNewsinfo model, String uptime) {
		if (uptime == null || uptime.isEmpty()) {
			model.setUpdatetime(new Date());
		} else {
			try {
				model.setUpdatetime(CommonHelp.getTime(uptime));
			} catch (ParseException e) {
				return "更新时间转换失败";
			}
		}
		Session session = SecurityUtils.getSubject().getSession();
		String loginname = (String) session.getAttribute("loginname");
		String displayname = (String) session.getAttribute("displayname");
		model.setAddloginname(loginname);
		model.setAdddispname(displayname);
		return newsService.UpdateByMid(model);
	}
}
