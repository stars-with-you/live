package com.fl.live.controller;

import com.fl.common.TypeUtils;
import com.fl.live.service.LiveAttentionService;
import com.fl.model.AppAttention;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

@Controller
@RequestMapping(value = "/attention")
public class LiveAttentionController {
    @Resource
    private LiveAttentionService attentionService;

    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public String Add(AppAttention model) {
        Session session = SecurityUtils.getSubject().getSession();
        String pguid = (String) session.getAttribute("pguid");
        String displayname = (String) session.getAttribute("displayname");
        if (TypeUtils.isEmpty(pguid)) {
            return "3";
        } else {
            model.setPguid(pguid);
            model.setDisplayname(displayname);
            return attentionService.insert(model);
        }
    }

    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public String DeleteByCguid(String lguid) {
        Session session = SecurityUtils.getSubject().getSession();
        String pguid = (String) session.getAttribute("pguid");
        return attentionService.deleteByGzid(pguid, lguid);
    }
}
