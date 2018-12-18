package com.fl.oauth;

import com.fl.common.TypeUtils;
import com.fl.live.service.LiveService;
import org.apache.oltu.oauth2.as.issuer.MD5Generator;
import org.apache.oltu.oauth2.as.issuer.OAuthIssuer;
import org.apache.oltu.oauth2.as.issuer.OAuthIssuerImpl;
import org.apache.oltu.oauth2.as.request.OAuthAuthzRequest;
import org.apache.oltu.oauth2.as.response.OAuthASResponse;
import org.apache.oltu.oauth2.common.OAuth;
import org.apache.oltu.oauth2.common.error.OAuthError;
import org.apache.oltu.oauth2.common.exception.OAuthSystemException;
import org.apache.oltu.oauth2.common.message.OAuthResponse;
import org.apache.oltu.oauth2.common.message.types.ResponseType;
import org.apache.oltu.oauth2.rs.response.OAuthRSResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URI;

@Controller
@RequestMapping(value = "/oauth/server")
public class ServerController {
    @Resource
    private LiveService liveService;
    @Resource
    private org.springframework.cache.ehcache.EhCacheCacheManager ehCacheCacheManager;

    //向客户端返回授权许可码 code
    @RequestMapping("/responsecode")
    public Object ResponseCode(HttpServletRequest request) {
        try {
            //构建OAuth授权请求 
            OAuthAuthzRequest oauthRequest = new OAuthAuthzRequest(request);
            String clientId = oauthRequest.getClientId();
            String responseType = oauthRequest.getParam(OAuth.OAUTH_RESPONSE_TYPE);
            //得到到客户端重定向地址
            String redirectURI = oauthRequest.getParam(OAuth.OAUTH_REDIRECT_URI);
            //生成授权码
            String authcode = "";
            if (responseType.equals(ResponseType.CODE.toString())) {
                OAuthIssuerImpl oAuthIssuerImpl = new OAuthIssuerImpl(new MD5Generator());
                authcode = oAuthIssuerImpl.authorizationCode();
                //保存授权码
                //oauthClientService.saveCode(clientId, authcode);
            }
            //进行OAuth响应构建
            OAuthASResponse.OAuthAuthorizationResponseBuilder builder =
                    OAuthASResponse.authorizationResponse(request, HttpServletResponse.SC_FOUND);
            //设置授权码
            builder.setCode(authcode);
            //构建响应
            final OAuthResponse response = builder.location(redirectURI).buildQueryMessage();
            String responceUri = response.getLocationUri();
            //根据OAuthResponse返回ResponseEntity响应
            HttpHeaders headers = new HttpHeaders();
            headers.setLocation(new URI(response.getLocationUri()));
            return new ResponseEntity(headers, HttpStatus.valueOf(response.getResponseStatus()));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    //获取客户端的code码，向客户端返回access token
    @RequestMapping(value = "/responseaccesstoken")
    @ResponseBody
    @CrossOrigin
    public String ResponseAccessToken(HttpServletRequest request) {
        OAuthIssuer oauthIssuerImpl = null;
        try {
            String clientId = request.getParameter(OAuth.OAUTH_CLIENT_ID);
            String clientSecret = request.getParameter(OAuth.OAUTH_CLIENT_SECRET);
            if (TypeUtils.isEmpty(clientId) || !clientId.equals(OauthConstants.ClientId_SWY)) {
                return "false";
            }
            if (TypeUtils.isEmpty(clientSecret) || !clientSecret.equals(OauthConstants.Secret_SWY)) {
                return "false";
            }
            String accessToken = "";
            //生成Access Token
            oauthIssuerImpl = new OAuthIssuerImpl(new MD5Generator());
            accessToken = oauthIssuerImpl.accessToken();
            org.springframework.cache.Cache cache = ehCacheCacheManager.getCache("wxcache");
            cache.put("swytoken", accessToken);
            //根据OAuthResponse生成ResponseEntity
            return accessToken;
        } catch (Exception e) {
            return "false";
        }
    }

    @RequestMapping("/responseuinfo")
    @ResponseBody
    @CrossOrigin
    public String ResponseInfo(HttpServletRequest request) throws OAuthSystemException {
        try {
            //获取Access Token 
            String accessToken = request.getParameter("accessToken");
            String ct = request.getParameter("ct");
            int count = 0;
            try {
                if (!TypeUtils.isEmpty(ct)) {
                    count = Integer.parseInt(ct);
                }
            } catch (NumberFormatException e) {
                return "false";
            }
            String istj = request.getParameter("istj");
            //验证Access Token 
            org.springframework.cache.Cache cache = ehCacheCacheManager.getCache("wxcache");
            String swytoken = cache.get("swytoken").get().toString();
            if (TypeUtils.isEmpty(accessToken) || !swytoken.equals(accessToken)) {
                // 如果不存在/过期了，返回未验证错误，需重新验证 
                OAuthResponse oauthResponse = OAuthRSResponse
                        .errorResponse(HttpServletResponse.SC_UNAUTHORIZED)
                        .setError(OAuthError.ResourceResponse.INVALID_TOKEN)
                        .buildHeaderMessage();
                HttpHeaders headers = new HttpHeaders();
                headers.add(OAuth.HeaderType.WWW_AUTHENTICATE,
                        oauthResponse.getHeader(OAuth.HeaderType.WWW_AUTHENTICATE));
                //return new ResponseEntity(headers, HttpStatus.UNAUTHORIZED);
                return "false";
            }
            //返回用户名 
            String json = liveService.getSwy(count, istj);
            return json;
        } catch (Exception e) {
            return "false";
        }
    }
}
