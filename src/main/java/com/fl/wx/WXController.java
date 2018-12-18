package com.fl.wx;

import com.alibaba.fastjson.JSONObject;
import com.fl.common.CommonHelpConstants;
import com.fl.common.EncodeUtils;
import com.fl.common.TypeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value = "/wx")
public class WXController {
    @Resource
    private WXCacheService wxCacheService;
    @Resource
    private HttpServletRequest request;
    @Resource
    private org.springframework.cache.ehcache.EhCacheCacheManager ehCacheCacheManager;

    @RequestMapping(value = "/getopenid")
    public String GetOpenid(String code, String state) {
        if (TypeUtils.isEmpty(code)) {
            //没有获取到code说明微信接口出现异常了
            return "redirect:/person/wx/error";
        } else {
            JSONObject obj = wxCacheService.getPageAccessToken(code);
            String openid = obj.getString("openid");
            if (openid != null && openid.length() > 0) {
                try {
                    org.springframework.cache.Cache cache = ehCacheCacheManager.getCache("wxcache");
                    String page_accesstoken = obj.getString("access_token");
                    cache.put("page_accesstoken", page_accesstoken);
                    System.out.println("通过code获取page_accesstoken:" + page_accesstoken);
                } catch (Exception e) {
                    System.out.println("出现异常了:" + e.getMessage());
                }
                String lasturl = EncodeUtils.urlDecode(state, "utf-8");
                if (lasturl.contains("?")) {
                    String[] arr = lasturl.split("\\?");
                    lasturl = arr[0] + "?openid=" + openid + "&" + arr[1];
                } else {
                    lasturl += "?openid=" + openid;
                }
                return "redirect:" + lasturl;
            } else {
                return "redirect:/person/wx/error";
            }
        }
    }

    /**
     * 获取网页授权code,并跳转到url(/wx/getopenid)
     *
     * @param state
     * @param scope
     * @return
     */
    @RequestMapping(value = "/getcode")
    public String GetCode(String state, String scope) {
        StringBuilder sb = new StringBuilder();
        sb.append("https://open.weixin.qq.com/connect/oauth2/authorize?");
        sb.append("appid=");
        sb.append(WXConstants.APPID);
        sb.append("&redirect_uri=");
        String url = CommonHelpConstants.DominName + "/wx/getopenid";
        sb.append(EncodeUtils.urlEncode(url, "utf-8"));
        sb.append("&response_type=");
        sb.append("code");
        sb.append("&scope=");
        sb.append(scope);
        if (state != null && state != "") {
            sb.append("&state=");
            sb.append(state);
        }
        sb.append("#wechat_redirect");
        return "redirect:" + sb.toString();
    }
}
