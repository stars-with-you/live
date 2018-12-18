package com.fl.manager.controller;

import com.alibaba.fastjson.JSONObject;
import com.fl.bq.service.BqService;
import com.fl.common.CommonHelp;
import com.fl.common.ImgUtil;
import com.fl.common.TypeUtils;
import com.fl.common.VideoUtil;
import com.fl.live.service.LiveAttentionService;
import com.fl.live.service.LiveDetailService;
import com.fl.live.service.LiveService;
import com.fl.live.systc.service.SystcService;
import com.fl.manager.service.ManagerService;
import com.fl.model.AppBq;
import com.fl.model.AppLive;
import com.fl.model.AppLiveattach;
import com.fl.model.PsUser;
import com.fl.wx.WXCacheService;
import com.fl.wx.WXConstants;
import com.fl.wx.WXHelper;
import com.fl.wx.WXPayConfigImpl;
import com.fl.wx.pay.sdk.WXPay;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

@Controller
@RequestMapping(value = "/person")
public class PersonController {
    @Resource
    private ManagerService userService;
    @Resource
    private LiveService liveService;
    @Resource
    private LiveDetailService liveDetailService;
    @Resource
    private SystcService systcService;
    @Resource
    private HttpServletRequest request;
    @Resource
    private org.springframework.cache.ehcache.EhCacheCacheManager ehCacheCacheManager;
    @Resource
    private WXCacheService wxCacheService;
    @Resource
    private BqService bqService;
    @Resource
    private LiveAttentionService attentionService;

    /**
     * 后台个人中心
     *
     * @return
     */
    @RequestMapping(value = "/detail")
    public ModelAndView Detail() {
        ModelAndView mv = new ModelAndView();
        Session session = SecurityUtils.getSubject().getSession();
        String loginname = (String) session.getAttribute("loginname");
        PsUser model = userService.selectByPrimaryKey(loginname);
        mv.addObject("person", model);
        //
//        List<SysTc> list = systcService.getAll();
//        mv.addObject("tc", list);
        mv.setViewName("/manager/person_detail");
        return mv;
    }

    /**
     * 后台个人直播列表
     *
     * @return
     */
    @RequestMapping(value = "/livelist")
    public ModelAndView LiveList() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/manager/person_live");
        mv.addObject("lguid", CommonHelp.getUuid());
        return mv;
    }

    @RequestMapping(value = "/livelistsq")
    public ModelAndView LiveListSQ() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/manager/person_livesq");
        return mv;
    }

    @RequestMapping(value = "/livelistgz")
    public ModelAndView LiveListGZ() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/manager/person_livegz");
        return mv;
    }

    /**
     * 后台个人直播列表
     *
     * @return
     */
    @RequestMapping(value = "/livecmt")
    public ModelAndView LiveCmt() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/manager/person_livecmt");
        return mv;
    }

    @RequestMapping(value = "/livedetail")
    public ModelAndView LiveDetail(String lguid) {
        ModelAndView mv = new ModelAndView();
        String pguid = request.getSession().getAttribute("pguid").toString();
        if (TypeUtils.isEmpty(pguid)) {
            mv.addObject("bz", "0");
            mv.addObject("isgz", "0");
        } else {
            if (liveService.Auth(lguid, pguid)) {
                mv.addObject("bz", "1");
            } else {
                mv.addObject("bz", "0");
            }
            //关注
            if (attentionService.isgz(pguid, lguid)) {
                mv.addObject("isgz", "1");
            } else {
                mv.addObject("isgz", "0");
            }
        }
        AppLive model = liveService.SelectSingle(lguid);
        mv.addObject("lguid", lguid);
        mv.addObject("model", model);
        List<AppBq> bqlist = bqService.list();
        StringBuilder sbbq = new StringBuilder();
        sbbq.append("[");
        for (int j = 0; j < bqlist.size(); j++) {
            sbbq.append("{\"title\":\"");
            sbbq.append(bqlist.get(j).getBq());
            sbbq.append("\",\"value\":\"");
            sbbq.append(bqlist.get(j).getBguid());
            sbbq.append("\",\"description\":\"\"},");
        }
        sbbq.append("]");
        mv.addObject("select", sbbq.toString());
        mv.setViewName("/manager/person_livedetail");
        return mv;
    }

    @RequestMapping(value = "/fileadd", method = RequestMethod.POST)
    @ResponseBody
    public String FileAdd(String lguid, String dguid, MultipartFile picfile) {
        List<AppLiveattach> listattach = new ArrayList<>();
        if (TypeUtils.isEmpty(dguid)) {
            dguid = CommonHelp.getUuid();
        }
        String base64 = "";
        String aguid = "";
        String sltlj = "";
        if (picfile != null) {
            AppLiveattach attach = new AppLiveattach();
            String newname = picfile.getOriginalFilename();
            String fguid = CommonHelp.getUuid();
            String newfilename = fguid + CommonHelp.getHZMDot(newname);
            String xdlj = "/upload/attach/" + CommonHelp.getStringDate("yyyyMMdd") + "/";
            String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
            // 文件保存路径
            File uploadFile = new File(jdlj);
            // 判断文件是否上传，如果上传的话将会创建该目录
            if (!uploadFile.exists()) {
                uploadFile.mkdirs(); // 创建该目录
            }
            if (TypeUtils.isImage(newname)) {
                try {
                    String newfilenameslt = fguid + "_slt" + CommonHelp.getHZMDot(newname);
                    ImgUtil imgUtil = new ImgUtil();
                    if(imgUtil.ThumbnailsImgMultipartFile(1280, picfile, jdlj + newfilename)) {
                        if (picfile.getSize() > 1024 * 100) {//大于100K,将生成缩略图
                            imgUtil.ThumbnailsImgMultipartFile(400, picfile, jdlj + newfilenameslt);
                        } else {
                            newfilenameslt = newfilename;
                        }
                        attach.setZoompath(xdlj + newfilenameslt);
                        sltlj = xdlj + newfilenameslt;
                        attach.setType("1");
                        aguid = CommonHelp.getUuid();
                        attach.setAguid(aguid);
                        attach.setPath(xdlj + newfilename);
                        attach.setCreatetime(new Date());
                        attach.setDguid(dguid);
                        attach.setFilename(newname);
                        attach.setLguid(lguid);
                        listattach.add(attach);
                        liveDetailService.Add(null, listattach, null);
                    }
                    else {
                        return "0";
                    }
                } catch (Exception e) {
                    return "0";
                }
            } else {
                //上传视频
                if (TypeUtils.isH5Video(newname)) {
                    if (picfile.getSize() > 1024 * 1024 * 50) {
                    } else {
                        try {
                            String newfilenameslt = fguid + "_slt" + ".png";
                            picfile.transferTo(new File(jdlj + newfilename));
                            String ffmpeg = Thread.currentThread().getContextClassLoader().getResource("/").getPath();
                            ffmpeg = ffmpeg.substring(1, ffmpeg.length());
                            System.out.println(ffmpeg);
                            VideoUtil vu = new VideoUtil(ffmpeg + "ffmpeg.exe");
                            vu.getThumb(jdlj + newfilename, jdlj + newfilenameslt, 400, 300, 0, 0, 3);
                            attach.setZoompath(xdlj + newfilenameslt);
                            sltlj = xdlj + newfilenameslt;
                        } catch (Exception e) {
                            return "0";
                        }
                        attach.setType("2");
                        aguid = CommonHelp.getUuid();
                        attach.setAguid(aguid);
                        attach.setPath(xdlj + newfilename);
                        attach.setCreatetime(new Date());
                        attach.setDguid(dguid);
                        attach.setFilename(newname);
                        attach.setLguid(lguid);
                        listattach.add(attach);
                        liveDetailService.Add(null, listattach, null);
                    }
                } else {
                    return "3";
                }
            }
        }
        return "{\"bz\":\"1\",\"rst\":{\"dguid\":\"" + dguid + "\",\"aguid\":\"" + aguid + "\",\"zoompath\":\"" + sltlj + "\"}}";
    }
    /*****************************************************微信分界线*******************************************************************/
    /**
     * 微信_注册页面
     *
     * @return
     */
    @RequestMapping(value = "/wx/reg")
    public String WXReg(String openid) {
        String str = "";
        if (openid != null && openid != "") {
            PsUser user = userService.selectByOpenid(openid);
            if (user != null) {
                //已经注册过了
                return "redirect:/person/wx/detail";
            } else {
                str = "/wx/wxreg";
            }
        } else {
            str = "/wx/wxreg";
        }
        return str;
    }

    /**
     * 微信_注册执行
     *
     * @param model
     */
    @RequestMapping(value = "/wx/add")
    @ResponseBody
    public String WXAdd(PsUser model) {
        String openid = model.getOpenid();
        String pwd = model.getLoginpwd();
        if (openid != null && openid != "") {
            WXHelper wxHelper = new WXHelper();
            org.springframework.cache.Cache cache = ehCacheCacheManager.getCache("wxcache");
            String page_accesstoken = cache.get("page_accesstoken").get().toString();
            JSONObject obj = wxHelper.getUserInfo_Page(page_accesstoken, openid);
            if (obj.getString("nickname") != null) {
                model.setDisplayname(obj.getString("nickname"));
                String b64 = CommonHelp.UrlToBase64(obj.getString("headimgurl"), "jpg");
                model.setLogo(b64);
            }
            model.setLoginpwd(pwd);
            model.setAddtime(new Date());
            model.setUpdatetime(new Date());
            model.setPguid(CommonHelp.getUuid());
            model.setAuth("0");
            return userService.insert(model);
        } else {
            return "0";
        }
    }

    @RequestMapping(value = "/wx/update")
    @ResponseBody
    public String WXUpdate(PsUser model, String localid) {
        System.out.println("localid实施实时搜索:" + localid);
        if (!TypeUtils.isEmpty(localid)) {
            String access_token = wxCacheService.getAccessToken();
            StringBuilder sb = new StringBuilder();
            sb.append("http://file.api.weixin.qq.com/cgi-bin/media/get?");
            sb.append("access_token=");
            sb.append(access_token);
            sb.append("&media_id=");
            sb.append(localid);
            String filePath = null;
            try {
                URL url = new URL(sb.toString());
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setDoInput(true);
                conn.setRequestMethod("GET");
                String contenttype = conn.getHeaderField("Content-Type");
                if (contenttype.contains("image")) {
                    String Contentdisposition = conn.getHeaderField("Content-disposition");
                    int ContentLength = Integer.parseInt(conn.getHeaderField("Content-Length"));
                    BufferedInputStream bis = new BufferedInputStream(conn.getInputStream());
                    String oriname = Contentdisposition.split("filename=")[1];
                    oriname = oriname.substring(1, oriname.length() - 1);
                    // 根据内容类型获取扩展名
                    String fileExt = contenttype.split("/")[1];
                    if (ContentLength > 1024 * 1024 * 1) {
                        // 将mediaId作为文件名,上传到服务器
                        String wjm = CommonHelp.getUuid();
                        String filename = wjm + "." + fileExt;
                        String xdlj = "/upload/userlogo/" + CommonHelp.getStringDate("yyyyMMdd") + "/";
                        String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                        filePath = jdlj + filename;
                        File uploadFile = new File(jdlj);
                        // 判断文件是否上传，如果上传的话将会创建该目录
                        if (!uploadFile.exists()) {
                            uploadFile.mkdirs(); // 创建该目录
                        }
                        FileOutputStream fos = new FileOutputStream(new File(filePath));
                        byte[] buf = new byte[8096];
                        int size = 0;
                        while ((size = bis.read(buf)) != -1)
                            fos.write(buf, 0, size);
                        fos.close();
                        bis.close();
                        conn.disconnect();
                        //大于1M时，进行压缩
                        CommonHelp.FileToYSFile(CommonHelp.SrcToBufferedImage(filePath), filePath, 0.9f);
                        String base64 = CommonHelp.BufferedImageToBase64(CommonHelp.SrcToBufferedImage(filePath), fileExt);
                        model.setLogo(base64);
                        File f = new File(filePath);
                        f.delete();
                    } else {
                        String base64 = CommonHelp.BufferedImageToBase64(ImageIO.read(bis), fileExt);
                        model.setLogo(base64);
                    }
                } else {
                }
            } catch (Exception e) {
            }
        }
        return userService.update(model);
    }

    /**
     * 前台个人中心
     *
     * @return
     */
    @RequestMapping(value = "/wx/detail")
    public ModelAndView WXDetail( String openid ) {
        ModelAndView mv = new ModelAndView();
        String url = request.getRequestURL() + "?" + request.getQueryString();
        if (!TypeUtils.isEmpty(openid)) {
            Session session = SecurityUtils.getSubject().getSession();
            String pguid = (String) session.getAttribute("pguid");
            if (TypeUtils.isEmpty(pguid)) {
                String rst = userService.WXStartLogin(openid);
                if (rst.equals("1")) {
                    //登录成功
                    PsUser user = userService.selectByOpenid(openid);
                    mv.addObject("user", user);
                    mv.setViewName("/wx/person_detail");
                } else {
                    //登录失败，进入登录页面进行登录
                    mv.addObject("tzurl", url);
                    mv.setViewName("/wx/wxreg");
                }
            } else {
                PsUser user = userService.selectByOpenid(openid);
                if (TypeUtils.isEmpty(user)) {
                    //登录失败，进入登录页面进行登录
                    mv.addObject("tzurl", url);
                    mv.setViewName("/wx/wxreg");
                } else {
                    mv.addObject("user", user);
                    mv.setViewName("/wx/person_detail");
                }
            }
        } else {
            mv.setViewName("/wx/person_detail");
        }
        WXHelper wxHelper = new WXHelper();
        String noncestr = wxHelper.create_nonce_str();
        String timestamp = wxHelper.create_timestamp();
        String signature = wxHelper.getSignature(wxCacheService.getJsapiTicket(wxCacheService.getAccessToken()), url, noncestr, timestamp);
        mv.addObject("appid", WXConstants.APPID);
        mv.addObject("noncestr", noncestr);
        mv.addObject("timestamp", timestamp);
        mv.addObject("signature", signature);
        return mv;
    }

    /**
     * 前台个人直播列表
     *
     * @return
     */
    @RequestMapping(value = "/wx/livelist")
    public ModelAndView WXLiveList(String openid) {
        ModelAndView mv = new ModelAndView();
        String url = request.getRequestURL() + "?" + request.getQueryString();
        if (!TypeUtils.isEmpty(openid)) {
            Session session = SecurityUtils.getSubject().getSession();
            String pguid = (String) session.getAttribute("pguid");
            String rst = userService.WXStartLogin(openid);
            if (rst.equals("1")) {
                //登录成功
                mv.setViewName("/wx/person_livelist");
            } else {
                //登录失败，进入登录页面进行登录
                mv.addObject("tzurl", url);
                mv.setViewName("/wx/wxreg");
            }
        } else {
            mv.setViewName("/wx/person_livelist");
        }
        WXHelper wxHelper = new WXHelper();
        String noncestr = wxHelper.create_nonce_str();
        String timestamp = wxHelper.create_timestamp();
        String signature = wxHelper.getSignature(wxCacheService.getJsapiTicket(wxCacheService.getAccessToken()), url, noncestr, timestamp);
        mv.addObject("appid", WXConstants.APPID);
        mv.addObject("noncestr", noncestr);
        mv.addObject("timestamp", timestamp);
        mv.addObject("signature", signature);
        return mv;
    }

    /**
     * 前台个人被授权直播列表
     *
     * @return
     */
    @RequestMapping(value = "/wx/livelistsq")
    public ModelAndView WXLiveListSQ(String openid) {
        ModelAndView mv = new ModelAndView();
        String url = request.getRequestURL() + "?" + request.getQueryString();
        if (!TypeUtils.isEmpty(openid)) {
            Session session = SecurityUtils.getSubject().getSession();
            String pguid = (String) session.getAttribute("pguid");
            String rst = userService.WXStartLogin(openid);
            if (rst.equals("1")) {
                //登录成功
                mv.setViewName("/wx/person_livelistsq");
            } else {
                //登录失败，进入登录页面进行登录
                mv.addObject("tzurl", url);
                mv.setViewName("/wx/wxreg");
            }
        } else {
            mv.setViewName("/wx/person_livelistsq");
        }
        return mv;
    }

    /**
     * 前台个人关注直播列表
     *
     * @return
     */
    @RequestMapping(value = "/wx/livelistgz")
    public ModelAndView WXLiveListGZ(String openid) {
        ModelAndView mv = new ModelAndView();
        String url = request.getRequestURL() + "?" + request.getQueryString();
        if (!TypeUtils.isEmpty(openid)) {
            Session session = SecurityUtils.getSubject().getSession();
            String pguid = (String) session.getAttribute("pguid");
            String rst = userService.WXStartLogin(openid);
            if (rst.equals("1")) {
                //登录成功
                mv.setViewName("/wx/person_livelistgz");
            } else {
                //登录失败，进入登录页面进行登录
                mv.addObject("tzurl", url);
                mv.setViewName("/wx/wxreg");
            }
        } else {
            mv.setViewName("/wx/person_livelistgz");
        }
        return mv;
    }

    /**
     * 微信接口问题
     *
     * @return
     */
    @RequestMapping(value = "/wx/error")
    public ModelAndView WXError() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/wx/wxerror");
        return mv;
    }

    @RequestMapping(value = "/createorder")
    public ModelAndView CreateOrder() throws Exception {
        ModelAndView mv = new ModelAndView();
        WXPayConfigImpl config = WXPayConfigImpl.getInstance();
        /**
         * config:包含appid,mch_id,key,nonce_str
         * autoReport:是否使用证书，true:使用，false:不使用
         * userSandbox:签名算法，true:md5,false:HMACSHA256
         */
        WXPay wxPay = new WXPay(config, false, false);
        HashMap<String, String> data = new HashMap<String, String>();
        data.put("body", "测试商家-商品类目");
        data.put("trade_type", "NATIVE");//交易类型
        data.put("detail", "");//
        data.put("fee_type", "CNY");//
        data.put("device_info", "WEB");
        data.put("out_trade_no", "fl20161909105959000000111108");
        data.put("total_fee", "1");
        data.put("notify_url", "http://test.letiantian.com/wxpay/notify");//接收微信支付异步通知回调地址，通知url必须为直接可访问的url，不能携带参数。
        data.put("spbill_create_ip", "123.12.12.123");//CommonHelp.GetIP(request)
        try {
            Map<String, String> r = wxPay.unifiedOrder(data);
            String fkmstr = CommonHelp.CreateQRCodeBase64Str(r.get("code_url"), "jpg", 15, "");
            mv.addObject("fkm", fkmstr);
        } catch (Exception e) {
            e.printStackTrace();
        }
        mv.setViewName("/manager/person_order");
        return mv;
    }
}
