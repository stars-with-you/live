package com.fl.live.service;

import com.fl.model.AppLive;

import javax.servlet.http.HttpServletRequest;

public interface LiveService {
    /*
     * 获取分页数据json格式
     */
    public String getData(int currentPage, int pagesize, AppLive model);

    public String getDataWX(int currentPage, int pagesize, AppLive model);

    public String getDataWXSQ(int currentPage, int pagesize, AppLive model);

    public String getDataWXGZ(int currentPage, int pagesize, AppLive model);

    public String getSwy(int ct, String istj);

    public boolean Auth(String lguid, String pguid);

    public String Add(AppLive model);

    public String DelByLguid(String lguid, HttpServletRequest request);

    public String GetSingle(String lguid);

    public AppLive SelectSingle(String lguid);

    public String UpdateByLguid(AppLive model);

    public String UpdateZanByLguid(String lguid);

    public String UpdateAccessByLguid(String lguid);
}
