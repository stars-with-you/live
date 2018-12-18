/*
  Created: 方磊
  Date: 2017年9月4日  上午9:04:01

*/
package com.fl.urlpr.controller;

import java.util.Date;

import javax.annotation.Resource;

import com.fl.urlpr.service.PsShiroService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fl.common.CommonHelp;
import com.fl.model.PsShiro;

@Controller
@RequestMapping(value = "/urlpr")
public class UrlPRController {

	@Resource
	private PsShiroService psShiroServiceImpl;
	private static final String jspmaster = CommonHelp
			.getPropertyKey(CommonHelp.getProperty("config/config.properties"), "jsp.master");
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String List() {
		return "/manager/list_urlpr"+jspmaster;
	}

	@RequestMapping(value = "/data", method = RequestMethod.POST)
	@ResponseBody
	public String getData(int currentPage, int pagesize, PsShiro model) {
		try {
			if (currentPage < 1) {
				currentPage = 1;
			}
			return psShiroServiceImpl.getData(currentPage, pagesize, model);
		} catch (Exception e) {

			return "";
		}
	}

	/**
	 * 添加url拦截
	 * 
	 * @param model
	 * @return 1:添加成功 其他：添加失败
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	@ResponseBody
	public String Add(PsShiro model) {
		model.setSguid(CommonHelp.getUuid());
		Session session = SecurityUtils.getSubject().getSession();
		String loginname = (String) session.getAttribute("loginname");
		String displayname = (String) session.getAttribute("displayname");
		model.setSadder(loginname);
		model.setSaddtime(new Date());
		model.setSupdater(displayname);
		model.setSupdatetime(new Date());
		model.setIsdel("0");
		return psShiroServiceImpl.Add(model);

	}

	@RequestMapping(value = "/delbysguid", method = RequestMethod.POST)
	@ResponseBody
	public String DelByMid(String sguid) {
		return psShiroServiceImpl.Del(sguid);
	}

	@RequestMapping(value = "/getsingle", method = RequestMethod.POST)
	@ResponseBody
	public String GetSingle(String sguid) {
		return psShiroServiceImpl.GetSingle(sguid);
	}

	@RequestMapping(value = "/updatebysguid", method = RequestMethod.POST)
	@ResponseBody
	public String UpdateBySguid(PsShiro model) {

		Session session = SecurityUtils.getSubject().getSession();
		String loginname = (String) session.getAttribute("loginname");
		model.setSupdater(loginname);
		model.setSupdatetime(new Date());
		return psShiroServiceImpl.UpdateBySguid(model);
	}
}
