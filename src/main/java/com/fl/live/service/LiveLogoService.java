package com.fl.live.service;

import com.fl.model.AppLivelogo;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface LiveLogoService {
    public List<AppLivelogo> getList(String lguid);

    public String getData(String lguid);

    public int Add(AppLivelogo model);

    public String DelByLogoid(String logoid, HttpServletRequest request);

    public String DelByLguid(String lguid, HttpServletRequest request);
}
