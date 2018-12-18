/*
  Created: 方磊
  Date: 2017年8月18日  上午10:32:27

*/
package com.fl.show.controller;

import com.fl.common.TypeUtils;
import com.fl.live.service.LiveAttentionService;
import com.fl.live.service.LiveCmtService;
import com.fl.live.service.LiveDetailService;
import com.fl.live.service.LiveService;
import com.fl.model.AppLive;
import com.fl.model.AppNewsinfo;
import com.fl.news.service.AppNewsService;
import com.fl.wx.WXCacheService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value = {"/show"})
public class ShowController {

    @Resource
    private LiveService liveService;
    @Resource
    private HttpServletRequest request;
    @Resource
    private LiveDetailService liveDetailService;
    @Resource
    private LiveCmtService commentService;
    @Resource
    private WXCacheService wxCacheService;
    @Resource
    private LiveAttentionService attentionService;

    @RequestMapping(value = {""}, method = RequestMethod.GET)
    public ModelAndView Home(String p) {
        ModelAndView mView = new ModelAndView();
        if (TypeUtils.isEmpty(p)) {
            p = "";
        }
        mView.setViewName("/show/home" + p);
        return mView;
    }

    /*
     * 直播列表页
     */
    @RequestMapping(value = {"/zhibo"}, method = RequestMethod.GET)
    public ModelAndView ZhiBo() {
        ModelAndView mView = new ModelAndView();
        mView.setViewName("/show/zhibo");
        return mView;
    }

    /*
     * 直播列表页
     */
    @RequestMapping(value = {"/zhibo/detail"}, method = RequestMethod.GET)
    public ModelAndView ZBDetail(String lguid) {
        ModelAndView mView = new ModelAndView();
        AppLive model = liveService.SelectSingle(lguid);
        mView.addObject("model", model);
        mView.addObject("lguid", lguid);
        mView.setViewName("/show/zhibodetail");
        //关注
        try {
            String pguid = request.getSession().getAttribute("pguid").toString();
            if (!TypeUtils.isEmpty(pguid)) {
                if (attentionService.isgz(pguid, lguid)) {
                    mView.addObject("isgz", "1");
                } else {
                    mView.addObject("isgz", "0");
                }
            } else {
                mView.addObject("isgz", "0");
            }
        } catch (Exception e) {
            mView.addObject("isgz", "0");
        }
        return mView;
    }


    @RequestMapping(value = {"/test"})
    public ModelAndView NewsSingle() {
        ModelAndView mView = new ModelAndView();
        mView.setViewName("/wx/testimg");
        return mView;
    }
}
