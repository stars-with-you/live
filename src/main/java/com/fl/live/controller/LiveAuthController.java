package com.fl.live.controller;

import com.fl.live.service.LiveAuthService;
import com.fl.model.AppAuth;
import com.fl.model.AppComment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

@Controller
@RequestMapping(value = "/applive/auth")
public class LiveAuthController {
    @Resource
    private LiveAuthService liveAuthService;

    @RequestMapping(value = "/data", method = RequestMethod.POST)
    @ResponseBody
    public String getData(int currentPage, int pagesize, AppAuth model) {
        try {
            if (currentPage < 1) {
                currentPage = 1;
            }
            String rst = liveAuthService.getData(currentPage, pagesize, model);
            return rst;
        } catch (Exception e) {
            return "";
        }
    }

    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public String Add(AppAuth model) {
        return liveAuthService.insert(model);
    }

    @RequestMapping(value = "/deletebyauguid", method = RequestMethod.POST)
    @ResponseBody
    public String DeleteByCguid(String auguid) {
        return liveAuthService.deleteByAuguid(auguid);
    }
}
