package com.fl.live.service;

import com.fl.model.AppAuth;
import com.fl.model.AppComment;

import java.util.List;

public interface LiveAuthService {
    public String insert(AppAuth model);

    public String insertMap(List<AppAuth> list);

    public String deleteByAuguid(String auguid);

    /*
     * 获取分页数据json格式
     */
    public String getData(int currentPage, int pagesize, AppAuth model);
}
