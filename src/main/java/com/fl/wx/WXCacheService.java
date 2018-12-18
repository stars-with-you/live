package com.fl.wx;

import com.alibaba.fastjson.JSONObject;
import org.springframework.cache.annotation.Cacheable;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface WXCacheService {
    /**
     * 获取全局access_token
     *
     * @return
     */
    public String getAccessToken();

    /**
     * 获取网页授权access_token
     *
     * @return
     */
    public JSONObject getPageAccessToken(String code);

    /**
     * 获取jsapi_ticket
     *
     * @return
     */
    public String getJsapiTicket(String access_token);

}
