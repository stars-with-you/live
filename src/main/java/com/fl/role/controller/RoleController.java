package com.fl.role.controller;

import javax.annotation.Resource;

import com.fl.common.CommonHelp;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fl.model.PsRole;
import com.fl.role.service.PsRoleService;

@Controller
@RequestMapping({ "/role" })
public class RoleController {

	@Resource
	private PsRoleService roleService;
    private static final String jspmaster = CommonHelp
            .getPropertyKey(CommonHelp.getProperty("config/config.properties"), "jsp.master");
	@RequestMapping({ "/getlist" })
	@ResponseBody
	public String GetList(int pn, int ps, PsRole model) {
		return roleService.GetList(pn, ps, model);
	}

	@RequestMapping({ "/getlistbypguid" })
	@ResponseBody
	public String GetListByPguid(String pguid) {
		return roleService.GetListByLoginname(pguid);
	}

	/***
	 * 获取一条角色
	 * 
	 * @param pid
	 * @return
	 */
	@RequestMapping({ "/getsingle" })
	@ResponseBody
	public String GetSingle(String rcode) {
		return roleService.GetSingle(rcode);
	}

	@RequestMapping({ "/list" })
	public ModelAndView List() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/manager/list_role"+jspmaster);
		return mv;
	}

	/**
	 * 角色添加
	 * 
	 * @param md
	 * @return
	 */
	@RequestMapping({ "/add" })
	@ResponseBody
	public String Add(PsRole md) {
		return roleService.add(md);
	}

	/**
	 * 角色修改
	 * 
	 * @param md
	 * @return
	 */
	@RequestMapping({ "/updatebyrcode" })
	@ResponseBody
	public String UpdateByRcode(PsRole md) {
		return roleService.UpdateByRcode(md);
	}

	/**
	 * 删除角色
	 * 
	 * @param pid
	 * @return
	 */
	@RequestMapping({ "/delbyrcode" })
	@ResponseBody
	public String DelByRcode(String rcode) {
		return roleService.DelByRcode(rcode);

	}

	@RequestMapping({ "/addroleperm" })
	@ResponseBody
	public String AddRolePerm(String rcode, String pidstr) {
		return roleService.AddRolePerm(rcode, pidstr);
	}

	@RequestMapping({ "/adduserrole" })
	@ResponseBody
	public String AddUserRole(String pguid, String rcodestr) {
		return roleService.AddUserRole(pguid, rcodestr);
	}
}
