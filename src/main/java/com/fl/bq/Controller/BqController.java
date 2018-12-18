package com.fl.bq.Controller;

import com.fl.bq.service.BqService;
import com.fl.common.CommonHelp;
import com.fl.model.AppBq;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;

@Controller
@RequestMapping(value = "/bq")
public class BqController {
    @Resource
    private BqService bqService;

    /*
     * 获取bq列表
     */
    @RequestMapping({"/list"})
    public ModelAndView List() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/manager/list_bq");
        return mv;
    }

    @ResponseBody
    @RequestMapping(value = "/getlist")
    public String getlist(int pn, int ps, AppBq model) {
        return bqService.GetList(pn, ps, model);
    }

    /**
     * 权限添加
     *
     * @param md
     * @return
     */
    @RequestMapping({"/add"})
    @ResponseBody
    public String Add(AppBq md) {
        md.setBguid(CommonHelp.getUuid());
        return String.valueOf(bqService.Add(md));
    }

    @RequestMapping(value = "/updatebybguid")
    @ResponseBody
    public String Update(AppBq md) {
        return String.valueOf(bqService.Update(md));
    }

    @ResponseBody
    @RequestMapping(value = "/getsingle")
    public String getSingle(String bguid) {
        return bqService.getSingle(bguid);
    }

    @RequestMapping(value = "/delbybguid")
    @ResponseBody
    public String Del(String bguid) {
        return String.valueOf(bqService.Delete(bguid));
    }
}