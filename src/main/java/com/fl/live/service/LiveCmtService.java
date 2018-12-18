package com.fl.live.service;

import com.fl.model.AppComment;
import com.fl.model.AppLive;

public interface LiveCmtService {
    /*
     * 获取分页数据json格式
     */
    public String getData(int currentPage, int pagesize, AppComment model);

    public String getDataHf(String hfguid);

    public String getDataQt(int currentPage, int pagesize, AppComment model);

    public String getPersonData(int currentPage, int pagesize, String openid);

    public String Add(AppComment model);

    public String DelByCguid(String cguid);

    public String DelByLguid(String lguid);

    public String GetSingle(String cguid);

    public String Update(AppComment model);

    public String UpdateZan(String cguid);

    public String UpdateStatus(String cguid, String status);
}
