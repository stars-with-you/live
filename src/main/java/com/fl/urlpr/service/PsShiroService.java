package com.fl.urlpr.service;

import com.fl.common.CommonHelp;
import com.fl.model.PsShiro;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public interface PsShiroService {
    /**
     * 获取所有的shiro url拦截信息
     *
     * @return
     */
    public Map<String, String> SelectAll();

    public String getData(int currentPage, int pagesize, PsShiro model)
            throws JsonGenerationException, JsonMappingException, IOException;

    public String Add(PsShiro model) ;

    /**
     * 设置sguid为无效
     *
     * @param sguid
     * @return
     */
    public String Del(String sguid);

    /**
     * 获取一条url权限拦截
     *
     * @param sguid
     * @return
     */
    public String GetSingle(String sguid);

    public String UpdateBySguid(PsShiro model);
}