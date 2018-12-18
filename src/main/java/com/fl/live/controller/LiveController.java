package com.fl.live.controller;

import com.fl.bq.service.BqService;
import com.fl.common.*;
import com.fl.common.controller.BaseController;
import com.fl.live.service.LiveAttentionService;
import com.fl.live.service.LiveDetailService;
import com.fl.live.service.LiveLogoService;
import com.fl.live.service.LiveService;
import com.fl.manager.service.ManagerService;
import com.fl.model.*;
import com.fl.wx.WXCacheService;
import com.fl.wx.WXConstants;
import com.fl.wx.WXHelper;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import sun.misc.BASE64Encoder;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.ParseException;
import java.util.*;

@Controller
@RequestMapping(value = "/applive")
public class LiveController extends BaseController {
    @Resource
    private LiveService liveService;
    @Resource
    private LiveDetailService liveDetailService;
    @Resource
    private ManagerService userService;
    @Resource
    private LiveLogoService liveLogoService;
    @Resource
    private HttpServletRequest request;
    @Resource
    private WXCacheService wxCacheService;
    @Resource
    private BqService bqService;
    @Resource
    private LiveAttentionService attentionService;
    /**
     * 直播列表页面（管理员）
     *
     * @return
     */
    @RequestMapping(value = {"/list"}, method = RequestMethod.GET)
    public ModelAndView List() {
        String cata = request.getParameter("cata");
        ModelAndView mv = new ModelAndView();
        mv.addObject("cata", cata);
        mv.setViewName("/manager/list_live");
        return mv;
    }

    /**
     * 直播数据查询（管理员）
     *
     * @param currentPage
     * @param pagesize
     * @param model
     * @return
     */
    @RequestMapping(value = "/data", method = RequestMethod.POST)
    @ResponseBody
    public String getData(int currentPage, int pagesize, AppLive model) {
        try {
            if (currentPage < 1) {
                currentPage = 1;
            }
            String rst = liveService.getData(currentPage, pagesize, model);
            return rst;
        } catch (Exception e) {
            return "";
        }
    }

    @RequestMapping(value = "/showdata", method = RequestMethod.POST)
    @ResponseBody
    public String getShowData(int currentPage, int pagesize) {
        AppLive model = new AppLive();
        model.setIspublic("1");
        model.setIshome("1");
        try {
            if (currentPage < 1) {
                currentPage = 1;
            }
            if (pagesize > 50) {
                pagesize = 50;
            }
            if (pagesize < 1) {
                pagesize = 1;
            }
            String rst = liveService.getData(currentPage, pagesize, model);
            return rst;
        } catch (Exception e) {
            return "";
        }
    }

    /**
     * 前台个人直播列表(我的直播)
     *
     * @param currentPage
     * @param pagesize
     * @param model
     * @return
     */
    @RequestMapping(value = "/dataperson", method = RequestMethod.POST)
    @ResponseBody
    public String getDataPerson(int currentPage, int pagesize, AppLive model) {
        Session session = SecurityUtils.getSubject().getSession();
        String pguid = (String) session.getAttribute("pguid");
        if (TypeUtils.isEmpty(pguid)) {
            return "";
        } else {
            model.setPguid(pguid);
            try {
                if (currentPage < 1) {
                    currentPage = 1;
                }
                String rst = liveService.getDataWX(currentPage, pagesize, model);
                return rst;
            } catch (Exception e) {
                return "";
            }
        }
    }

    /**
     * 前台个人直播列表(授权的直播)
     *
     * @param currentPage
     * @param pagesize
     * @param model
     * @return
     */
    @RequestMapping(value = "/datapersonsq", method = RequestMethod.POST)
    @ResponseBody
    public String getDataPersonSQ(int currentPage, int pagesize, AppLive model) {
        Session session = SecurityUtils.getSubject().getSession();
        String pguid = (String) session.getAttribute("pguid");
        if (TypeUtils.isEmpty(pguid)) {
            return "";
        } else {
            model.setPguid(pguid);
            try {
                if (currentPage < 1) {
                    currentPage = 1;
                }
                String rst = liveService.getDataWXSQ(currentPage, pagesize, model);
                return rst;
            } catch (Exception e) {
                return "";
            }
        }
    }

    /**
     * 前台个人直播列表(我的关注)
     *
     * @param currentPage
     * @param pagesize
     * @param model
     * @return
     */
    @RequestMapping(value = "/datapersongz", method = RequestMethod.POST)
    @ResponseBody
    public String getDataPersonGZ(int currentPage, int pagesize, AppLive model) {
        Session session = SecurityUtils.getSubject().getSession();
        String pguid = (String) session.getAttribute("pguid");
        if (TypeUtils.isEmpty(pguid)) {
            return "";
        } else {
            model.setPguid(pguid);
            try {
                if (currentPage < 1) {
                    currentPage = 1;
                }
                String rst = liveService.getDataWXGZ(currentPage, pagesize, model);
                return rst;
            } catch (Exception e) {
                return "";
            }
        }
    }

    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public String Add(AppLive model,  MultipartFile zbewmfile) {
        String lguid = model.getLguid();
        if (!TypeUtils.isEmpty(lguid)) {

            if (zbewmfile != null) {
                String zbewmnewname = zbewmfile.getOriginalFilename();
                if (zbewmfile.getSize() > 0 && TypeUtils.isImage(zbewmnewname)) {
                    try {
                        String newfilename = CommonHelp.getUuid() + CommonHelp.getHZMDot(zbewmnewname);
                        // 文件保存路径
                        String xdlj = "/upload/zbewm/";
                        String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                        File uploadFile = new File(jdlj);
                        // 判断文件是否上传，如果上传的话将会创建该目录
                        if (!uploadFile.exists()) {
                            uploadFile.mkdirs(); // 创建该目录
                        }
                        ImgUtil imgUtil = new ImgUtil();
                        imgUtil.ThumbnailsImgMultipartFile(1280, zbewmfile, jdlj + newfilename);
                        model.setZbewm(xdlj + newfilename);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
            //生成用户唯一键
//        String lguid = CommonHelp.getUuid();
//        model.setLguid(lguid);
            //空的话，设置成普通用户
            String cata = model.getCata();
            Subject subject = SecurityUtils.getSubject();
            // if (!subject.isAuthenticated()) {
            Session session = subject.getSession();
            String pguid = (String) session.getAttribute("pguid");
            model.setPguid(pguid);
            //可以评论
            model.setIscomment("1");
            String path = request.getContextPath();
            String server_url = request.getScheme() + "://" + request.getServerName()
                    + path + "/";
            String ewmurl = "/applive/wxlive?lguid=" + lguid;
            server_url = CommonHelpConstants.DominName + ewmurl;
            model.setUrl(ewmurl);
            //生成二维码图片
            try {
                String xdlj = "/upload/ewm/" + CommonHelp.getStringDate("yyyyMMdd") + "/";
                String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                File uploadFile = new File(jdlj);
                // 判断文件是否上传，如果上传的话将会创建该目录
                if (!uploadFile.exists()) {
                    uploadFile.mkdirs(); // 创建该目录
                }
                CommonHelp.CreateQRCodeFile(server_url, jdlj + lguid + ".png", 7, "");
                model.setEwm(xdlj + lguid + ".png");
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                model.setCreatetime(CommonHelp.getNowTime());
                model.setUpdatetime(CommonHelp.getNowTime());
            } catch (ParseException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            return liveService.Add(model);
        } else {
            return "";
        }
    }

    @RequestMapping(value = "/getsingle")
    @ResponseBody
    public String getsingle(String lguid) {
        return liveService.GetSingle(lguid);
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ResponseBody
    public String Update(AppLive model,  MultipartFile zbewmfile) {

        if (zbewmfile != null) {
            String zbewmnewname = zbewmfile.getOriginalFilename();
            if (zbewmfile.getSize() > 0 && TypeUtils.isImage(zbewmnewname)) {
                try {
                    String newfilename = CommonHelp.getUuid() + CommonHelp.getHZMDot(zbewmnewname);
                    // 文件保存路径
                    String xdlj = "/upload/zbewm/";
                    String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                    File uploadFile = new File(jdlj);
                    // 判断文件是否上传，如果上传的话将会创建该目录
                    if (!uploadFile.exists()) {
                        uploadFile.mkdirs(); // 创建该目录
                    }
                    ImgUtil imgUtil = new ImgUtil();
                    imgUtil.ThumbnailsImgMultipartFile(1280, zbewmfile, jdlj + newfilename);
                    model.setZbewm(xdlj + newfilename);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return liveService.UpdateByLguid(model);
    }

    @RequestMapping(value = "/delbylguid", method = RequestMethod.POST)
    @ResponseBody
    public String Delete(String lguid) {
        return liveService.DelByLguid(lguid, request);
    }
/***********************************************微信******************************************************************/
    /**
     * 进入直播详细页面
     *
     * @param lguid
     * @param openid
     * @return
     */
    @RequestMapping(value = {"/wxlive"}, method = RequestMethod.GET)
    public ModelAndView Detail(String lguid, String openid) {
        ModelAndView mv = new ModelAndView();
        if (!TypeUtils.isEmpty(openid)) {
            String rst = userService.WXStartLogin(openid);
            if (rst.equals("1")) {//登录成功
                //再判断有没有直播权限
                String pguid = request.getSession().getAttribute("pguid").toString();
                if (liveService.Auth(lguid, pguid)) {
                    mv.addObject("bz", "1");
                } else {
                    mv.addObject("bz", "0");
                }
                //关注
                if(attentionService.isgz(pguid,lguid)){
                    mv.addObject("isgz", "1");
                }
                else{
                    mv.addObject("isgz", "0");
                }
            } else {
                mv.addObject("bz", "0");
                mv.addObject("isgz", "1");
            }

            liveService.UpdateAccessByLguid(lguid);
            AppLive model = liveService.SelectSingle(lguid);
            mv.addObject("lguid", lguid);
            mv.addObject("model", model);
            //
            String url = request.getRequestURL() + "?" + request.getQueryString();
            WXHelper wxHelper = new WXHelper();
            String noncestr = wxHelper.create_nonce_str();
            String timestamp = wxHelper.create_timestamp();
            String signature = wxHelper.getSignature(wxCacheService.getJsapiTicket(wxCacheService.getAccessToken()), url, noncestr, timestamp);
            mv.addObject("appid", WXConstants.APPID);
            mv.addObject("noncestr", noncestr);
            mv.addObject("timestamp", timestamp);
            mv.addObject("signature", signature);
            List<AppBq> bqlist= bqService.list();
            StringBuilder sbbq=new StringBuilder();
            sbbq.append("[");
            for (int j = 0; j <bqlist.size() ; j++) {
                sbbq.append("{\"title\":\"");
                sbbq.append(bqlist.get(j).getBq());
                sbbq.append("\",\"value\":\"");
                sbbq.append(bqlist.get(j).getBguid());
                sbbq.append("\",\"description\":\"\"},");
            }
            sbbq.append("]");
            mv.addObject("select",sbbq.toString());
            mv.setViewName("/wx/live");
        } else {
            mv.setViewName("/wx/live");
        }
        return mv;
    }

    @RequestMapping(value = "/wx/add", method = RequestMethod.POST)
    @ResponseBody
    public String WXAdd(AppLive model, String localid,String zbewmstr) {
        //生成用户唯一键
        String lguid = CommonHelp.getUuid();
        Subject subject = SecurityUtils.getSubject();
        // if (!subject.isAuthenticated()) {
        Session session = subject.getSession();
        String auth = (String) session.getAttribute("auth");
        if (!auth.equals("1")) {
            return "3";
        }
        if(!TypeUtils.isEmpty(zbewmstr)){
            String access_token = wxCacheService.getAccessToken();
            StringBuilder sb = new StringBuilder();
            sb.append("http://file.api.weixin.qq.com/cgi-bin/media/get?");
            sb.append("access_token=");
            sb.append(access_token);
            sb.append("&media_id=");
            sb.append(zbewmstr);
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
                    // 将mediaId作为文件名,上传到服务器
                    String wjm = CommonHelp.getUuid();
                    String filename = wjm + "." + fileExt;
                    String xdlj = "/upload/zbewm/" + lguid + "/";
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
                    if (ContentLength > 1024 * 1024 * 1) {
                        //大于1M时，进行压缩
                        CommonHelp.FileToYSFile(CommonHelp.SrcToBufferedImage(filePath), filePath, 0.9f);
                    }
                    model.setZbewm(xdlj + filename);
                }
            } catch (Exception e) {
                model.setZbewm("");
            }
        }else{

        }
        if (TypeUtils.isEmpty(localid)) {
            model.setDefaultpic("/upload/defaultpic/default.png");
        } else {
            localid = localid.substring(0, localid.length() - 1);
            String[] arr = localid.split(";");
            for (int i = 0; i < arr.length; i++) {
                String access_token = wxCacheService.getAccessToken();
                StringBuilder sb = new StringBuilder();
                sb.append("http://file.api.weixin.qq.com/cgi-bin/media/get?");
                sb.append("access_token=");
                sb.append(access_token);
                sb.append("&media_id=");
                sb.append(arr[i]);
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
                        // 将mediaId作为文件名,上传到服务器
                        String wjm = CommonHelp.getUuid();
                        String filename = wjm + "." + fileExt;
                        String xdlj = "/upload/defaultpic/" + lguid + "/";
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
                        if (ContentLength > 1024 * 1024 * 1) {
                            //大于1M时，进行压缩
                            CommonHelp.FileToYSFile(CommonHelp.SrcToBufferedImage(filePath), filePath, 0.9f);
                        }
                        model.setDefaultpic(xdlj + filename);
                        AppLivelogo attach = new AppLivelogo();
                        String logoid = CommonHelp.getUuid();
                        attach.setLogoid(logoid);
                        attach.setLguid(lguid);
                        attach.setOriname(oriname);
                        attach.setCata("");
                        attach.setDefaultpic(xdlj + filename);
                        attach.setAddtime(new Date());
                        attach.setZoompath("");
                        liveLogoService.Add(attach);
                    } else {
                        model.setDefaultpic("/upload/defaultpic/default.png");
                    }
                } catch (Exception e) {
                    model.setDefaultpic("/upload/defaultpic/default.png");
                }
            }
        }
        model.setLguid(lguid);
        //空的话，设置成普通用户
        String cata = model.getCata();
        String pguid = (String) session.getAttribute("pguid");
        model.setPguid(pguid);
        //可以评论
        model.setIscomment("1");
        String ewmurl = "/applive/wxlive?lguid=" + lguid;
        String server_url = CommonHelpConstants.DominName + ewmurl;
        model.setUrl(ewmurl);
        //生成二维码图片
        try {
            String xdlj = "/upload/ewm/" + CommonHelp.getStringDate("yyyyMMdd") + "/";
            String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
            File uploadFile = new File(jdlj);
            // 判断文件是否上传，如果上传的话将会创建该目录
            if (!uploadFile.exists()) {
                uploadFile.mkdirs(); // 创建该目录
            }
            CommonHelp.CreateQRCodeFile(server_url, jdlj + lguid + ".png", 7, "");
            model.setEwm(xdlj + lguid + ".png");
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            model.setCreatetime(CommonHelp.getNowTime());
            model.setUpdatetime(CommonHelp.getNowTime());
        } catch (ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return liveService.Add(model);
    }

    @RequestMapping(value = "/wx/update", method = RequestMethod.POST)
    @ResponseBody
    public String WXUpdate(AppLive model, String localid,String zbewmstr) {
        System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxlocalid:" + localid);
        String lguid = model.getLguid();
        if(!TypeUtils.isEmpty(zbewmstr)){
            String access_token = wxCacheService.getAccessToken();
            StringBuilder sb = new StringBuilder();
            sb.append("http://file.api.weixin.qq.com/cgi-bin/media/get?");
            sb.append("access_token=");
            sb.append(access_token);
            sb.append("&media_id=");
            sb.append(zbewmstr);
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
                    // 将mediaId作为文件名,上传到服务器
                    String wjm = CommonHelp.getUuid();
                    String filename = wjm + "." + fileExt;
                    String xdlj = "/upload/zbewm/" + lguid + "/";
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
                    if (ContentLength > 1024 * 1024 * 1) {
                        //大于1M时，进行压缩
                        CommonHelp.FileToYSFile(CommonHelp.SrcToBufferedImage(filePath), filePath, 0.9f);
                    }
                    model.setZbewm(xdlj + filename);
                }
            } catch (Exception e) {
                model.setZbewm("");
            }
        }else{

        }
        if (!TypeUtils.isEmpty(localid)) {
            localid = localid.substring(0, localid.length() - 1);
            String[] arr = localid.split(";");
            System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxarr[0]:" + arr[0]);
            for (int i = 0; i < arr.length; i++) {
                String access_token = wxCacheService.getAccessToken();
                StringBuilder sb = new StringBuilder();
                sb.append("http://file.api.weixin.qq.com/cgi-bin/media/get?");
                sb.append("access_token=");
                sb.append(access_token);
                sb.append("&media_id=");
                sb.append(arr[i]);
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
                        // 将mediaId作为文件名,上传到服务器
                        String wjm = CommonHelp.getUuid();
                        String filename = wjm + "." + fileExt;
                        String xdlj = "/upload/defaultpic/" + lguid + "/";
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
                        if (ContentLength > 1024 * 1024 * 1) {
                            //大于1M时，进行压缩
                            CommonHelp.FileToYSFile(CommonHelp.SrcToBufferedImage(filePath), filePath, 0.9f);
                        }
                        model.setDefaultpic(xdlj + filename);
                        AppLivelogo attach = new AppLivelogo();
                        String logoid = CommonHelp.getUuid();
                        attach.setLogoid(logoid);
                        attach.setLguid(lguid);
                        attach.setOriname(oriname);
                        attach.setCata("");
                        attach.setDefaultpic(xdlj + filename);
                        attach.setAddtime(new Date());
                        attach.setZoompath("");
                        liveLogoService.Add(attach);
                    } else {
                    }
                } catch (Exception e) {
                    System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx异常");
                }
            }
        }
        try {
            model.setUpdatetime(CommonHelp.getNowTime());
        } catch (ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return liveService.UpdateByLguid(model);
    }

    /**
     * 直播点赞
     *
     * @param lguid
     * @return
     */
    @RequestMapping(value = "/zan", method = RequestMethod.POST)
    @ResponseBody
    public String LiveZan(String lguid) {
        return liveService.UpdateZanByLguid(lguid);
    }

    @RequestMapping(value = "/wordexport")
    public void WordExport(String lguid, HttpServletResponse response) {
        BASE64Encoder encoder = new BASE64Encoder();
        AppLive livemodel = liveService.SelectSingle(lguid);
        List<AppLivelogo> logolist = liveLogoService.getList(lguid);
        String fileName = livemodel.getTitle() + ".doc";
        Map<String, Object> mapvalue = new HashMap<String, Object>();
        String ewm = request.getSession().getServletContext().getRealPath(livemodel.getEwm());
        File ewmFile = new File(ewm);
        // 判断文件是否上传，如果上传的话将会创建该目录
        if (ewmFile.exists()) {
            String ewm64 = encoder.encode(CommonHelp.getBytes(ewm));
            livemodel.setEwm(ewm64);
        }
        mapvalue.put("livemodel", livemodel);
        for (int i = 0; i < logolist.size(); i++) {
            String defaultpic = logolist.get(i).getDefaultpic();
            if(!TypeUtils.isEmpty(defaultpic)) {
                String jdlj = request.getSession().getServletContext().getRealPath(defaultpic);
                //获取base64
                String rst = encoder.encode(CommonHelp.getBytes(jdlj));
                logolist.get(i).setDefaultpic(rst);
                //获取后缀名
                String hz = CommonHelp.getHZM(defaultpic).toLowerCase();
                logolist.get(i).setZoompath(hz);
            }
        }
        mapvalue.put("logolist", logolist);
        //直播数据
        List<AppLivedetail> detaillist = liveDetailService.getList(lguid);
        List<AppLivedetailExtend> dlist = new ArrayList<AppLivedetailExtend>();
        for (int t = 0; t < detaillist.size(); t++) {
            AppLivedetailExtend m = new AppLivedetailExtend();
            String lj = detaillist.get(t).getPguid();
            if(!TypeUtils.isEmpty(lj)) {
                String[] arr = lj.split(";");
                Map<String, String> sb = new HashMap<String, String>();
                for (int s = 0; s < arr.length; s++) {
                    String jdlj = request.getSession().getServletContext().getRealPath(arr[s].split(",")[0]);
                    File fj = new File(jdlj);
                    // 判断文件是否上传，如果上传的话将会创建该目录
                    if (fj.exists()) {
                        String rst = encoder.encode(CommonHelp.getBytes(jdlj));
                        sb.put(CommonHelp.getUuid(), rst);
                    }
                }
                m.setBase64(sb);
            }
            m.setAppLivedetail(detaillist.get(t));
            dlist.add(m);
        }
        mapvalue.put("dlist", dlist);
        String context = request.getSession().getServletContext().toString();
        try {
            String endCodeFileName = new String(fileName.getBytes("GBK"), "ISO8859-1");
            response.reset();
            response.setHeader("Content-Type",
                    "application/octet-stream;charset=UTF-8");
            response.setHeader("Content-Disposition",
                    "attachment;filename=" + endCodeFileName);
            response.setHeader("Connection", "close");
            WordUtil wUtil = new WordUtil();
            wUtil.createDoc(mapvalue, response.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
