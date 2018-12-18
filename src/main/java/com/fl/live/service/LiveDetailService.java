package com.fl.live.service;

import com.fl.model.AppLiveattach;
import com.fl.model.AppLivebq;
import com.fl.model.AppLivedetail;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface LiveDetailService {
    public String bqjsonByDguid(String dguid);
    public String bqjson(String lguid,String bz);

    public List<AppLivedetail> getList(String lguid);

    /*
     * 获取分页数据json格式
     */
    public String getData(int currentPage, int pagesize, AppLivedetail model);

    public String getDataFile(int currentPage, int pagesize, String lguid, String isfb, String bq);

    public String Add(AppLivedetail model, List<AppLiveattach> listattach, List<AppLivebq> listbq);

    public String AddSingleFile(AppLiveattach model);

    public String DelByDguid(String dguid, HttpServletRequest request);

    public String DelFileByAguid(String aguid, HttpServletRequest request);

    public String GetSingle(String dguid);

    public AppLivedetail SelectSingle(String dguid);

    public String UpdateByDguid(AppLivedetail model, List<AppLiveattach> listattach, List<AppLivebq> listbq);
    public int UpdateSortByDguid(AppLiveattach model);
}
