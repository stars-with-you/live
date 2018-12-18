package com.fl.perm.controller;

import javax.annotation.Resource;

import com.fl.common.CommonHelp;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import com.fl.mapper.PsPermissionMapper;
import com.fl.model.PsPermission;
import com.fl.perm.service.impl.PsPermServiceImpl;

@Controller
@RequestMapping({"/perm"})
public class PermController {

    @Resource
    private PsPermServiceImpl permService;
    private static final String jspmaster = CommonHelp
            .getPropertyKey(CommonHelp.getProperty("config/config.properties"), "jsp.master");

    /**
     * 获取所有权限
     *
     * @param rid
     * @return
     */
    @RequestMapping({"/getlistall"})
    @ResponseBody
    public String GetListAll() {
        return permService.GetListAll();
    }

    /**
     * 获取分页权限
     *
     * @param pn
     * @param ps
     * @param model
     * @return
     */
    @RequestMapping({"/getlist"})
    @ResponseBody
    public String GetList(int pn, int ps, PsPermission model) {
        return permService.GetList(pn, ps, model);
    }

    /**
     * 根据角色获取权限
     *
     * @param rid
     * @return
     */
    @RequestMapping({"/getlistbyrcode"})
    @ResponseBody
    public String GetListByRcode(String rcode) {
        return permService.GetListByRcode(rcode);
    }

    /***
     * 获取一条权限新
     *
     * @param pid
     * @return
     */
    @RequestMapping({"/getsingle"})
    @ResponseBody
    public String GetSingle(String pid) {
        return permService.GetSingle(pid);
    }

    /*
     * 获取权限列表
     */
    @RequestMapping({"/list"})
    public ModelAndView List() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/manager/list_perm" + jspmaster);
        return mv;
    }

    /**
     * 权限添加
     *
     * @param md
     * @return
     */
    @RequestMapping({"/add"})
    @ResponseBody
    public String Add(PsPermission md) {
        return permService.Add(md);
    }

    /**
     * 权限修改
     *
     * @param md
     * @return
     */
    @RequestMapping({"/updatebypid"})
    @ResponseBody
    public String UpdateByPid(PsPermission md) {
        return permService.UpdateByPid(md);
    }

    /**
     * 删除权限
     *
     * @param pid
     * @return
     */
    @RequestMapping({"/delbypid"})
    @ResponseBody
    public String DelByPid(String pid) {
        return permService.DelByPid(pid);
    }
}
