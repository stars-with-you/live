package com.fl.live.controller;

import com.alibaba.fastjson.JSONObject;
import com.fl.common.CommonHelp;
import com.fl.common.EncodeUtils;
import com.fl.common.TypeUtils;
import com.fl.live.service.LiveCmtService;
import com.fl.manager.service.ManagerService;
import com.fl.model.AppComment;
import com.fl.model.PsUser;
import com.fl.wx.WXHelper;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;

@Controller
@RequestMapping(value = "/applive/cmt")
public class LiveCmtController {
    @Resource
    private LiveCmtService commentService;
    @Resource
    private ManagerService managerServiceImpl;
    @Resource
    private HttpServletRequest request;
    @Resource
    private org.springframework.cache.ehcache.EhCacheCacheManager ehCacheCacheManager;

    @RequestMapping(value = {"/list"}, method = RequestMethod.GET)
    public ModelAndView List(String lguid) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("lguid", lguid);
        mv.setViewName("/manager/list_livecmt");
        return mv;
    }

    @RequestMapping(value = "/data", method = RequestMethod.POST)
    @ResponseBody
    public String getData(int currentPage, int pagesize, AppComment model) {
        try {
            if (currentPage < 1) {
                currentPage = 1;
            }
            String rst = commentService.getData(currentPage, pagesize, model);
            return rst;
        } catch (Exception e) {
            return "";
        }
    }

    @RequestMapping(value = "/persondata", method = RequestMethod.POST)
    @ResponseBody
    public String getPersonData(int currentPage, int pagesize, AppComment model) {
        try {
            if (currentPage < 1) {
                currentPage = 1;
            }
            String openid = (String) SecurityUtils.getSubject().getSession().getAttribute("openid");
            String rst = commentService.getPersonData(currentPage, pagesize, openid);
            return rst;
        } catch (Exception e) {
            return "";
        }
    }

    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public String Add(AppComment model) {
//0表示非违禁，1表示违禁，2表示建议人工复审
        String cmt = model.getComment();
        if (cmt.length() > 1999) {
            return "评论的字符串过长";
        } else {
            String codetype = EncodeUtils.getEncoding(cmt);
            if (codetype.equalsIgnoreCase("gbk")) {
            }
            //生成唯一键
            model.setCguid(CommonHelp.getUuid());
            Subject subject = SecurityUtils.getSubject();
            // if (!subject.isAuthenticated()) {
            Session session = subject.getSession();
            model.setNickname((String) session.getAttribute("displayname"));
            String ip = CommonHelp.GetIP(request);
            model.setIp(ip);
            try {
                if (ip.equalsIgnoreCase("0:0:0:0:0:0:0:1")) {
                    model.setIpplace("中国");
                } else {
                    String region = CommonHelp.GetIPPalce(ip).getJSONObject("data").getString("region");
                    String city = CommonHelp.GetIPPalce(ip).getJSONObject("data").getString("city");
                    model.setIpplace(region + city);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                model.setCreatetime(CommonHelp.getNowTime());
            } catch (ParseException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            String rows = commentService.Add(model);
            return "1";
        }
    }

    @RequestMapping(value = "/getsingle")
    @ResponseBody
    public String getsingle(String cguid) {
        return commentService.GetSingle(cguid);
    }

    @RequestMapping(value = "/deletebycguid", method = RequestMethod.POST)
    @ResponseBody
    public String DeleteByCguid(String cguid) {
        return commentService.DelByCguid(cguid);
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ResponseBody
    public String Update(AppComment model) {
        return commentService.Update(model);
    }

    /**
     * 获取直播前台评论信息
     *
     * @param currentPage
     * @param pagesize
     * @param model
     * @return
     */
    @RequestMapping(value = "/wxdata", method = RequestMethod.POST)
    @ResponseBody
    public String getWXData(int currentPage, int pagesize, AppComment model) {
        if (!TypeUtils.isEmpty(model.getLguid())) {
            try {
                if (currentPage < 1) {
                    currentPage = 1;
                }
                String rst = commentService.getDataQt(currentPage, pagesize, model);
                return rst;
            } catch (Exception e) {
                return "";
            }
        } else {
            return "";
        }
    }

    @RequestMapping(value = "/wxdatahf", method = RequestMethod.POST)
    @ResponseBody
    public String getWXDataHf(String hfguid) {
        try {
            String rst = commentService.getDataHf(hfguid);
            return rst;
        } catch (Exception e) {
            return "";
        }
    }

    /**
     * 前台添加一条评论
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/wxadd", method = RequestMethod.POST)
    @ResponseBody
    public String WXAdd(AppComment model) {
//0表示非违禁，1表示违禁，2表示建议人工复审
        String cmt = model.getComment();
        if (cmt.length() > 1999) {
            return "评论的字符串过长";
        } else {
            //生成唯一键
            model.setCguid(CommonHelp.getUuid());
            String hfid = model.getHfguid();
            if (hfid != null && hfid != "") {//如果回复id不为空，表明是回复评论
                model.setCata(2);
            } else {
                model.setCata(1);
            }
            if (model.getCata().equals(1)) {
                model.setStatus("2");//待审
            } else {
                model.setStatus("0"); //评论通过
            }
            try {
                Session session = SecurityUtils.getSubject().getSession();
                String displayname = (String) session.getAttribute("displayname");
                String myopenid = (String) session.getAttribute("openid");
                String openid = model.getOpenid();
                if (TypeUtils.isEmpty(displayname)) {
                    if (openid != null && openid != "") {
                        WXHelper wxHelper = new WXHelper();
                        org.springframework.cache.Cache cache = ehCacheCacheManager.getCache("wxcache");
                        String page_accesstoken = cache.get("page_accesstoken").get().toString();
                        JSONObject obj = wxHelper.getUserInfo_Page(page_accesstoken, openid);
                        if (obj.getString("nickname") != null) {
                            model.setNickname(obj.getString("nickname"));
                            model.setHeadurl(obj.getString("headimgurl"));
                            model.setIpplace(obj.getString("province") + obj.getString("city"));
                        } else {
                            model.setNickname("匿名网友");
                        }
                    } else {
                        model.setNickname("匿名网友");
                    }
                } else {
                    if (TypeUtils.isEmpty(openid)) {
                        model.setOpenid(myopenid);
                    }
                    model.setNickname(displayname);
                    String loginname = (String) session.getAttribute("loginname");
                    PsUser user = managerServiceImpl.selectByPrimaryKey(loginname);
                    model.setHeadurl(user.getLogo());
                }
                String ip = CommonHelp.GetIP(request);
                model.setIp(ip);
                model.setCreatetime(CommonHelp.getNowTime());
                String rows = commentService.Add(model);
                return "1";
            } catch (Exception e) {
                return "评论失败！";
            }
        }
    }

    /**
     * 前台评论点赞
     *
     * @param cguid
     * @return
     */
    @RequestMapping(value = "/wxzan", method = RequestMethod.POST)
    @ResponseBody
    public String WXZan(String cguid) {
        return commentService.UpdateZan(cguid);
    }

    /**
     * 前台评论审核通过
     *
     * @param cguid
     * @return
     */
    @RequestMapping(value = "/wxstatus", method = RequestMethod.POST)
    @ResponseBody
    public String WXStatus(String cguid) {
        return commentService.UpdateStatus(cguid, "0");
    }
}
