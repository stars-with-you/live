package com.fl.live.systc.controller;

import com.fl.common.CommonHelp;
import com.fl.common.TypeUtils;
import com.fl.model.AppLive;
import com.fl.model.PsUser;
import com.fl.model.SysTc;
import com.fl.live.systc.service.SystcService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.File;

@Controller
@RequestMapping(value = "/systc")
public class SystcController {
    @Resource
    private SystcService systcService;
    private static final String jspmaster = CommonHelp
            .getPropertyKey(CommonHelp.getProperty("config/config.properties"), "jsp.master");

    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String List() {
        return "/manager/list_systc" + jspmaster;
    }

    /**
     * 获取套餐信息列表
     *
     * @param currentPage
     * @param model
     * @return
     */
    @RequestMapping(value = "/data", method = RequestMethod.POST)
    @ResponseBody
    public String getData(int currentPage, int pagesize, SysTc model) {
        return systcService.getData(currentPage, pagesize, model);
    }

    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public String Add(SysTc model) {
        return systcService.insert(model);
    }
    @RequestMapping(value = "/getsingle")
    @ResponseBody
    public String getsingle(String tguid) {
        return systcService.select(tguid);
    }
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ResponseBody
    public String Update(SysTc model) {
        return systcService.update(model);
    }
}
