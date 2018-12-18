package com.fl.wx;

import com.alibaba.fastjson.JSONObject;
import com.fl.common.CommonHelp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.Formatter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.*;
public class WXHelper {
    /**
     * 获取关注公告号用户基本信息（包括UnionID机制）
     *
     * @param access_token 调用接口凭证，普通access_token
     * @param openid       普通用户的标识，对当前公众号唯一
     * @return 返回参数参考连接https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421140839
     */
    public JSONObject getUserInfo_GZ(String access_token, String openid) {
        StringBuilder sb = new StringBuilder();
        sb.append("https://api.weixin.qq.com/cgi-bin/user/info?");
        sb.append("access_token=");
        sb.append(access_token);
        sb.append("&openid=");
        sb.append(openid);
        sb.append("&lang=zh_CN");
        String rst = "";
        try {
            rst = CommonHelp.GetFromURL(sb.toString(), "GET", "", "");
            JSONObject obj = CommonHelp.ConvertToJsonObject(rst);
            return obj;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 获取网友授权用户基本信息
     * @param access_token 网友授权access_token
     * @param openid
     * @return
     */
    public JSONObject getUserInfo_Page(String access_token, String openid) {
        StringBuilder sb = new StringBuilder();
        sb.append("https://api.weixin.qq.com/sns/userinfo?");
        sb.append("access_token=");
        sb.append(access_token);
        sb.append("&openid=");
        sb.append(openid);
        sb.append("&lang=zh_CN");
        String rst = "";
        try {
            rst = CommonHelp.GetFromURL(sb.toString(), "GET", "", "");
            JSONObject obj = CommonHelp.ConvertToJsonObject(rst);
            return obj;
        } catch (Exception e) {
            return null;
        }
    }
    /**
     * 获取签名算法
     *
     * @param url       签名用的url
     * @param nonce_str 生成签名的随机串
     * @param timestamp 生成签名的时间戳
     * @return
     */
    public String getSignature(String jsapiticket, String url, String nonce_str, String timestamp) {
        Map<String, String> ret = sign(jsapiticket, url, nonce_str, timestamp);
        String signature = ret.get("signature");
        return signature;
    }

    /**
     * JS-SDK使用权限签名算法
     *
     * @param jsapi_ticket
     * @param url          签名用的url
     * @param nonce_str    生成签名的随机串
     * @param timestamp    生成签名的时间戳
     * @return
     */
    public Map<String, String> sign(String jsapi_ticket, String url, String nonce_str, String timestamp) {
        Map<String, String> ret = new HashMap<String, String>();
        String string1;
        String signature = "";
        //注意这里参数名必须全部小写，且必须有序
        string1 = "jsapi_ticket=" + jsapi_ticket +
                "&noncestr=" + nonce_str +
                "&timestamp=" + timestamp +
                "&url=" + url;
        try {
            MessageDigest crypt = MessageDigest.getInstance("SHA-1");
            crypt.reset();
            crypt.update(string1.getBytes("UTF-8"));
            signature = byteToHex(crypt.digest());
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        ret.put("url", url);
        ret.put("jsapi_ticket", jsapi_ticket);
        ret.put("nonceStr", nonce_str);
        ret.put("timestamp", timestamp);
        ret.put("signature", signature);
        return ret;
    }

    private String byteToHex(final byte[] hash) {
        Formatter formatter = new Formatter();
        for (byte b : hash) {
            formatter.format("%02x", b);
        }
        String result = formatter.toString();
        formatter.close();
        return result;
    }

    /**
     * 生成签名的随机串
     *
     * @return
     */
    public String create_nonce_str() {
        return UUID.randomUUID().toString().replace("-", "");
    }

    /**
     * 生成签名的时间戳
     *
     * @return
     */
    public String create_timestamp() {
        return Long.toString(System.currentTimeMillis() / 1000);
    }
}
