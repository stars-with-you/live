package com.fl.wx;

import com.alibaba.fastjson.JSONObject;
import com.fl.common.CommonHelp;
import com.fl.common.CommonHelpConstants;
import com.fl.common.EncodeUtils;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Service
public class WXCacheServiceImpl implements WXCacheService {
    /**
     * 获取全局access_token
     *
     * @return
     */
    @Override
    @Cacheable(value = "wxcache", key = "'wx_accesstoken'")
    public String getAccessToken() {
        System.out.println("getAccessToken没有使用缓存");
        StringBuilder sb = new StringBuilder();
        sb.append("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential");
        sb.append("&appid=");
        sb.append(WXConstants.APPID);
        sb.append("&secret=");
        sb.append(WXConstants.SECRET);
        String rst = "";
        try {
            rst = CommonHelp.GetFromURL(sb.toString(), "GET", "", "");
            JSONObject obj = CommonHelp.ConvertToJsonObject(rst);
            String accessToken = obj.getString("access_token");
            if (accessToken != null && accessToken.length() > 0) {
                return accessToken;
            } else {
                String errcode = obj.getString("errcode");
                String invalid = obj.getString("invalid");
//                -1	系统繁忙，此时请开发者稍候再试
//                0	请求成功
//                40001	AppSecret错误或者AppSecret不属于这个公众号，请开发者确认AppSecret的正确性
//                40002	请确保grant_type字段值为client_credential
//                40164	调用接口的IP地址不在白名单中，请在接口IP白名单中进行设置。（小程序及小游戏调用不要求IP地址在白名单内。
                return "";
            }
        } catch (Exception e) {
            return "";
        }
    }
    //获取openid文档：https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421140842

    /**
     * 获取网页授权access_token、openid
     *
     * @param code 填写第一步获取的code参数
     * @return
     */
    @Override
    public JSONObject getPageAccessToken(String code) {
        StringBuilder sb = new StringBuilder();
        sb.append("https://api.weixin.qq.com/sns/oauth2/access_token?");
        sb.append("&appid=");
        sb.append(WXConstants.APPID);
        sb.append("&secret=");
        sb.append(WXConstants.SECRET);
        sb.append("&code=");
        sb.append(code);
        sb.append("&grant_type=");
        sb.append("authorization_code");
        String rst = "";
        try {
            rst = CommonHelp.GetFromURL(sb.toString(), "POST", "", "");
            JSONObject obj = CommonHelp.ConvertToJsonObject(rst);
            return obj;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 获取jsapi_ticket
     *
     * @param access_token
     * @return
     */
    @Override
    @Cacheable(value = "wxcache", key = "'wx_sapiticket'")
    public String getJsapiTicket(String access_token) {
        System.out.println("getJsapiTicket没有使用缓存");
        StringBuilder sb = new StringBuilder();
        sb.append("https://api.weixin.qq.com/cgi-bin/ticket/getticket?type=jsapi");
        sb.append("&access_token=");
        sb.append(access_token);
        String rst = "";
        try {
            rst = CommonHelp.GetFromURL(sb.toString(), "GET", "", "");
            JSONObject obj = CommonHelp.ConvertToJsonObject(rst);
            String accessToken = obj.getString("errcode");
            if (accessToken != null && accessToken.equals("0")) {
                return obj.getString("ticket");
            } else {
                return "";
            }
        } catch (Exception e) {
            return "";
        }
    }
}
