package com.fl.live.controller;

import com.fl.bq.service.BqService;
import com.fl.common.CommonHelp;
import com.fl.common.TypeUtils;
import com.fl.common.controller.BaseController;
import com.fl.live.service.LiveDetailService;
import com.fl.live.service.LiveService;
import com.fl.manager.service.ManagerService;
import com.fl.model.AppBq;
import com.fl.model.AppLiveattach;
import com.fl.model.AppLivebq;
import com.fl.model.AppLivedetail;
import com.fl.wx.WXCacheService;
import com.fl.wx.WXConstants;
import com.fl.wx.WXHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.awt.image.BufferedImage;
import java.io.*;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping(value = "/applive/detail")
public class LiveDetailController extends BaseController {
    @Resource
    private LiveDetailService liveDetailService;
    @Resource
    private LiveService liveService;
    @Resource
    private ManagerService userService;
    @Resource
    private HttpServletRequest request;
    @Resource
    private WXCacheService wxCacheService;
    @Resource
    private BqService bqService;

    /**
     * 显示直播详情列表页面
     *
     * @param lguid
     * @return
     */
    @RequestMapping(value = {"/list"}, method = RequestMethod.GET)
    public ModelAndView List(String lguid) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("lguid", lguid);
        mv.setViewName("/manager/list_livedetail");
        List<AppBq> bqlist = bqService.list();
        mv.addObject("bqlist", bqlist);
        return mv;
    }

    /**
     * 获取直播详情数据，不包含附件
     *
     * @param currentPage
     * @param pagesize
     * @param model
     * @return
     */
    @RequestMapping(value = "/data", method = RequestMethod.POST)
    @ResponseBody
    public String getData(int currentPage, int pagesize, AppLivedetail model) {
        try {
            if (currentPage < 1) {
                currentPage = 1;
            }
            String rst = liveDetailService.getData(currentPage, pagesize, model);
            return rst;
        } catch (Exception e) {
            return "";
        }
    }

    /**
     * 获取直播详情数据，包含附件
     *
     * @param currentPage
     * @param pagesize
     * @param lguid
     * @return
     */
    @RequestMapping(value = "/datafile", method = RequestMethod.POST)
    @ResponseBody
    public String getDataFile(int currentPage, int pagesize, String lguid, String isfb, String bq) {
        if (!TypeUtils.isEmpty(lguid)) {
            try {
                if (currentPage < 1) {
                    currentPage = 1;
                }
                String rst = liveDetailService.getDataFile(currentPage, pagesize, lguid, isfb, bq);
                return rst;
            } catch (Exception e) {
                return "";
            }
        } else {
            return "";
        }
    }

    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public String Add(AppLivedetail model, MultipartFile[] picfile, String mybq, String mybguid) {
        List<AppLiveattach> listattach = new ArrayList<>();
        String dguid = CommonHelp.getUuid();
        if (picfile != null) {
            for (int i = 0; i < picfile.length; i++) {
                AppLiveattach attach = new AppLiveattach();
                String newname = picfile[i].getOriginalFilename();
                if (picfile[i].getSize() > 0 && TypeUtils.isImage(newname)) {
                    try {
                        String fguid = CommonHelp.getUuid();
                        String newfilename = fguid + CommonHelp.getHZMDot(newname);
                        String newfilenameslt = fguid + "_slt" + CommonHelp.getHZMDot(newname);
                        // 文件保存路径
                        String xdlj = "/upload/attach/" + CommonHelp.getStringDate("yyyyMMdd") + "/";
                        String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                        File uploadFile = new File(jdlj);
                        // 判断文件是否上传，如果上传的话将会创建该目录
                        if (!uploadFile.exists()) {
                            uploadFile.mkdirs(); // 创建该目录
                        }
                        picfile[i].transferTo(new File(jdlj + newfilename));
                        if (picfile[i].getSize() > 1024 * 10) {
                            BufferedImage bi = CommonHelp.MultipartFileToBufferedImage(picfile[i]);
                            if (bi != null) {
                                CommonHelp.FileToYSFile(bi, jdlj + newfilenameslt, 0.9f);
                            } else {
                                newfilenameslt = newfilename;
                            }
                        } else {
                            newfilenameslt = newfilename;
                        }
                        attach.setAguid(CommonHelp.getUuid());
                        attach.setPath(xdlj + newfilename);
                        attach.setCreatetime(new Date());
                        attach.setDguid(dguid);
                        attach.setFilename(newname);
                        attach.setZoompath(xdlj + newfilenameslt);
                        attach.setType("1");
                        attach.setLguid(model.getLguid());
                        listattach.add(attach);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        model.setDguid(dguid);
        model.setCreatetime(new Date());
        model.setUpdatetime(new Date());
        model.setPguid(request.getSession().getAttribute("pguid").toString());
        List<AppLivebq> listbq = new ArrayList<AppLivebq>();
        if (!TypeUtils.isEmpty(mybq)) {
            String[] arrbq = mybq.split(",");
            String[] arrbguid = mybguid.split(",");
            for (int t = 0; t < arrbq.length; t++) {
                AppLivebq bq = new AppLivebq();
                bq.setBid(CommonHelp.getUuid());
                bq.setLguid(model.getLguid());
                bq.setBguid(arrbguid[t]);
                bq.setBq(arrbq[t]);
                bq.setDguid(dguid);
                listbq.add(bq);
            }
        }
        String rst = liveDetailService.Add(model, listattach, listbq);
        return rst;
    }

    /**
     * 根据dguid 获取直播详情和附件
     *
     * @param dguid
     * @return
     */
    @RequestMapping(value = "/getsingle")
    @ResponseBody
    public String getsingle(String dguid) {
        return liveDetailService.GetSingle(dguid);
    }

    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ResponseBody
    public String Update(AppLivedetail model, MultipartFile[] picfile, String mybq, String mybguid) {
        List<AppLiveattach> listattach = new ArrayList<>();
        String dguid = model.getDguid();
        if (picfile != null) {
            for (int i = 0; i < picfile.length; i++) {
                AppLiveattach attach = new AppLiveattach();
                String newname = picfile[i].getOriginalFilename();
                if (picfile[i].getSize() > 0 && TypeUtils.isImage(newname)) {
                    try {
                        String fguid = CommonHelp.getUuid();
                        String newfilename = fguid + CommonHelp.getHZMDot(newname);
                        String newfilenameslt = fguid + "_slt" + CommonHelp.getHZMDot(newname);
                        // 文件保存路径
                        String xdlj = "/upload/attach/" + CommonHelp.getStringDate("yyyyMMdd") + "/";
                        String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                        File uploadFile = new File(jdlj);
                        // 判断文件是否上传，如果上传的话将会创建该目录
                        if (!uploadFile.exists()) {
                            uploadFile.mkdirs(); // 创建该目录
                        }
                        picfile[i].transferTo(new File(jdlj + newfilename));
                        if (picfile[i].getSize() > 1024 * 10) {
                            BufferedImage bi = CommonHelp.MultipartFileToBufferedImage(picfile[i]);
                            if (bi != null) {
                                CommonHelp.FileToYSFile(bi, jdlj + newfilenameslt, 0.9f);
                            } else {
                                newfilenameslt = newfilename;
                            }
                        } else {
                            newfilenameslt = newfilename;
                        }
                        attach.setAguid(CommonHelp.getUuid());
                        attach.setPath(xdlj + newfilename);
                        attach.setCreatetime(new Date());
                        attach.setDguid(dguid);
                        attach.setFilename(newname);
                        attach.setZoompath(xdlj + newfilenameslt);
                        attach.setType("1");
                        attach.setLguid(model.getLguid());
                        listattach.add(attach);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        model.setPguid(request.getSession().getAttribute("pguid").toString());
        List<AppLivebq> listbq = new ArrayList<AppLivebq>();
        if (!TypeUtils.isEmpty(mybq)) {
            String[] arrbq = mybq.split(",");
            String[] arrbguid = mybguid.split(",");
            for (int t = 0; t < arrbq.length; t++) {
                AppLivebq bq = new AppLivebq();
                bq.setBid(CommonHelp.getUuid());
                bq.setLguid(model.getLguid());
                bq.setBguid(arrbguid[t]);
                bq.setBq(arrbq[t]);
                bq.setDguid(dguid);
                listbq.add(bq);
            }
        }
        return liveDetailService.UpdateByDguid(model, listattach, listbq);
    }

    /**
     * 删除一条直播信息
     *
     * @param dguid
     * @return
     */
    @RequestMapping(value = "/delbydguid", method = RequestMethod.POST)
    @ResponseBody
    public String Delete(String dguid) {
        return liveDetailService.DelByDguid(dguid, (HttpServletRequest) request);
    }

    /**
     * 删除一个附件
     *
     * @param aguid 附件主键
     * @return
     */
    @RequestMapping(value = "/delfilebyaguid", method = RequestMethod.POST)
    @ResponseBody
    public String DeleteFile(String aguid) {
        return liveDetailService.DelFileByAguid(aguid, (HttpServletRequest) request);
    }

    /**
     * 微信直播詳情发布页面
     *
     * @return
     */
    @RequestMapping(value = "/wxadd", method = RequestMethod.GET)
    public ModelAndView WXAdd(String lguid, String openid) {
        ModelAndView mv = new ModelAndView();
        if (openid != null && openid != "") {
            String rst = userService.WXStartLogin(openid);
            if (rst.equals("1")) {
                //登录成功
                mv.addObject("lguid", lguid);
                String url = request.getRequestURL().toString() + "?" + request.getQueryString();
                WXHelper wxHelper = new WXHelper();
                String noncestr = wxHelper.create_nonce_str();
                String timestamp = wxHelper.create_timestamp();
                String jsapi_ticket = wxCacheService.getJsapiTicket(wxCacheService.getAccessToken());
                String signature = wxHelper.getSignature(jsapi_ticket, url, noncestr, timestamp);
                mv.addObject("appid", WXConstants.APPID);
                mv.addObject("noncestr", noncestr);
                mv.addObject("timestamp", timestamp);
                mv.addObject("signature", signature);
                mv.setViewName("/wx/livefb");
            } else {
                //登录失败，进入登录页面进行登录
                mv.addObject("tzurl", request.getRequestURL().toString() + "?" + request.getQueryString());
                mv.setViewName("/wx/wxlogin");
            }
        } else {
            mv.setViewName("/wx/livefb");
        }
        return mv;
    }

    @RequestMapping(value = "/wxupdate", method = RequestMethod.GET)
    public ModelAndView WXUpdate(String lguid, String dguid, String openid) {
        ModelAndView mv = new ModelAndView();
        if (openid != null && openid != "") {
            String rst = userService.WXStartLogin(openid);
            if (rst.equals("1")) {
                //登录成功
                mv.addObject("lguid", lguid);
                mv.addObject("dguid", dguid);
                String url = request.getRequestURL().toString() + "?" + request.getQueryString();
                WXHelper wxHelper = new WXHelper();
                String noncestr = wxHelper.create_nonce_str();
                String timestamp = wxHelper.create_timestamp();
                String jsapi_ticket = wxCacheService.getJsapiTicket(wxCacheService.getAccessToken());
                String signature = wxHelper.getSignature(jsapi_ticket, url, noncestr, timestamp);
                mv.addObject("appid", WXConstants.APPID);
                mv.addObject("noncestr", noncestr);
                mv.addObject("timestamp", timestamp);
                mv.addObject("signature", signature);
                mv.setViewName("/wx/livefb");
            } else {
                //登录失败，进入登录页面进行登录
                mv.addObject("tzurl", request.getRequestURL().toString() + "?" + request.getQueryString());
                mv.setViewName("/wx/wxlogin");
            }
        } else {
            mv.setViewName("/wx/livefb");
        }
        return mv;
    }

    @RequestMapping(value = "/wxaddstart", method = RequestMethod.POST)
    @ResponseBody
    public String WXAddStart(AppLivedetail model, String filestr, String mybq, String mybguid,String myfj) {
        //        附件顺序
        if(!TypeUtils.isEmpty(myfj)){
            String[] fj1=myfj.split(",");
            for (int s = 0; s <fj1.length ; s++) {
                String[] fjxx=fj1[s].split(";");
                String fjaguid=fjxx[0];
                String sort=fjxx[1];
                AppLiveattach afj=new AppLiveattach();
                afj.setAguid(fjaguid);
                afj.setSort(new BigDecimal(sort));
                liveDetailService.UpdateSortByDguid(afj);
            }
        }
        String pguid = null;
        try {
            pguid = request.getSession().getAttribute("pguid").toString();
        } catch (Exception e) {
            return "您没有登录";
        }
        String lguid = model.getLguid();
        if (!liveService.Auth(lguid, pguid)) {
            return "您没有权限进行直播";
        } else {
            List<AppLiveattach> listattach = new ArrayList<>();
            String dguid = "";
            if (TypeUtils.isEmpty(model.getDguid())) {
                dguid = CommonHelp.getUuid();
                model.setDguid(dguid);
            } else {
                dguid = model.getDguid();
            }
            model.setCreatetime(model.getUpdatetime());
            model.setPguid(pguid);
            if (!TypeUtils.isEmpty(filestr)) {
                String[] filearr = filestr.split(",");
                List<String> filelist = new ArrayList<String>();
                List<String> indexarr=new ArrayList<String>();
                for (int x = 0; x <filearr.length ; x++) {
                    String[] sr=filearr[x].split(";");
                    String srid=sr[0];
                    String srindex=sr[1];
                    filelist.add(srid);
                    indexarr.add(srindex);
                }
                //附件
                if (filearr != null && filearr.length>0) {
                    String xdlj = "/upload/attach/" + CommonHelp.getStringDate("yyyyMMdd") + "/";
                    String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                    String access_token = wxCacheService.getAccessToken();
                    downFile(access_token, filelist, jdlj, liveDetailService, xdlj, dguid, 0, model.getLguid(),indexarr);
                }
            }
            //
            List<AppLivebq> listbq = new ArrayList<AppLivebq>();
            if (!TypeUtils.isEmpty(mybq)) {
                String[] arrbq = mybq.split(",");
                String[] arrbguid = mybguid.split(",");
                for (int t = 0; t < arrbq.length; t++) {
                    AppLivebq bq = new AppLivebq();
                    bq.setBid(CommonHelp.getUuid());
                    bq.setLguid(model.getLguid());
                    bq.setBguid(arrbguid[t]);
                    bq.setBq(arrbq[t]);
                    bq.setDguid(dguid);
                    listbq.add(bq);
                }
            }
            String rst = liveDetailService.Add(model, listattach, listbq);
            if (rst.equals("1")) {
                return "1";
            } else {
                return rst;
            }
        }
    }

    @RequestMapping(value = "/wxupdatestart", method = RequestMethod.POST)
    @ResponseBody
    public String WXUpdateStart(AppLivedetail model, String filestr, String mybq, String mybguid,String myfj) {
//        附件顺序
        if(!TypeUtils.isEmpty(myfj)){
            String[] fj1=myfj.split(",");
            for (int s = 0; s <fj1.length ; s++) {
                String[] fjxx=fj1[s].split(";");
                String fjaguid=fjxx[0];
                String sort=fjxx[1];
                AppLiveattach afj=new AppLiveattach();
                afj.setAguid(fjaguid);
                afj.setSort(new BigDecimal(sort));
                liveDetailService.UpdateSortByDguid(afj);
            }
        }
        String pguid = null;
        try {
            pguid = request.getSession().getAttribute("pguid").toString();
        } catch (Exception e) {
            return "您没有登录";
        }
        String lguid = model.getLguid();
        if (!liveService.Auth(lguid, pguid)) {
            return "您没有权限进行直播";
        } else {
            List<AppLiveattach> listattach = new ArrayList<>();
            String dguid = model.getDguid();
            model.setPguid(pguid);
            if (!TypeUtils.isEmpty(filestr)) {

                String[] filearr = filestr.split(",");
                List<String> filelist = new ArrayList<String>();
                List<String> indexarr=new ArrayList<String>();
                for (int x = 0; x <filearr.length ; x++) {
                    String[] sr=filearr[x].split(";");
                    String srid=sr[0];
                    String srindex=sr[1];
                    filelist.add(srid);
                    indexarr.add(srindex);
                }
                //附件
                if (filearr != null) {
                    String xdlj = "/upload/attach/" + CommonHelp.getStringDate("yyyyMMdd") + "/";
                    String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                    String access_token = wxCacheService.getAccessToken();
                    downFile(access_token, filelist, jdlj, liveDetailService, xdlj, dguid, 0, model.getLguid(),indexarr);
                }
            }
            //
            List<AppLivebq> listbq = new ArrayList<AppLivebq>();
            if (!TypeUtils.isEmpty(mybq)) {
                String[] arrbq = mybq.split(",");
                String[] arrbguid = mybguid.split(",");
                for (int t = 0; t < arrbq.length; t++) {
                    AppLivebq bq = new AppLivebq();
                    bq.setBid(CommonHelp.getUuid());
                    bq.setLguid(model.getLguid());
                    bq.setBguid(arrbguid[t]);
                    bq.setBq(arrbq[t]);
                    bq.setDguid(dguid);
                    listbq.add(bq);
                }
            }
            String rst = liveDetailService.UpdateByDguid(model, listattach, listbq);
            if (rst.equals("1")) {
                return "1";
            } else {
                return rst;
            }
        }
    }

    @ResponseBody
    @RequestMapping(value = "/getbqbylguid")
    public String GetBqByLguid(String lguid,String bz) {
        return liveDetailService.bqjson(lguid,bz);
    }

    @ResponseBody
    @RequestMapping(value = "/getbqbydguid")
    public String GetBqByDguid(String dguid) {
        return liveDetailService.bqjsonByDguid(dguid);
    }

    /**
     * 微信多媒体下载接口
     *
     * @param access_token
     * @param filelist     媒体文件ID list
     * @param savePath     文件上传路径
     * @return 返回文件名
     */
    public void downFile(String access_token, List<String> filelist, String savePath, LiveDetailService liveDetailService, String xdlj, String dguid, int index, String lguid,List<String> indexarr) {
        if (filelist != null && filelist.size() > 0 && index < filelist.size()) {
            StringBuilder sb = new StringBuilder();
            sb.append("http://file.api.weixin.qq.com/cgi-bin/media/get?");
            sb.append("access_token=");
            sb.append(access_token);
            sb.append("&media_id=");
            sb.append(filelist.get(index));
            String rst = "";
            String filePath = null;
            String filePathslt = "";
            try {
                URL url = new URL(sb.toString());
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setDoInput(true);
                conn.setRequestMethod("GET");
                String contenttype = conn.getHeaderField("Content-Type");
                if (contenttype.contains("image")) {
                    String Contentdisposition = conn.getHeaderField("Content-disposition");
                    int ContentLength = Integer.parseInt(conn.getHeaderField("Content-Length"));
                    String oriname = Contentdisposition.split("filename=")[1];
                    oriname = oriname.substring(1, oriname.length() - 1);
                    // 根据内容类型获取扩展名
                    String fileExt = contenttype.split("/")[1];
                    // 将mediaId作为文件名,上传到服务器
                    String wjm = CommonHelp.getUuid();
                    String filename = wjm + "." + fileExt;
                    String filenameslt = wjm + "_slt." + fileExt;
                    filePath = savePath + filename;
                    filePathslt = savePath + filenameslt;
                    BufferedInputStream bis = new BufferedInputStream(conn.getInputStream());
                    File uploadFile = new File(savePath);
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
                    //大于500K时，进行压缩
                    if (ContentLength > 1024 * 500) {
                        CommonHelp.FileToYSFile(CommonHelp.SrcToBufferedImage(filePath), filePath, 0.7f);
                    }
                    //当图片大于100K时，进行缩略
                    if (ContentLength > 1024 * 100) {
                        CommonHelp.FileToYSFile(CommonHelp.SrcToBufferedImage(filePath), filePathslt, 0.7f);
                    } else {
                        filenameslt = filename;
                    }
                    AppLiveattach fj = new AppLiveattach();
                    fj.setAguid(CommonHelp.getUuid());
                    fj.setDguid(dguid);
                    fj.setPath(xdlj + filename);
                    fj.setCreatetime(new Date());
                    fj.setFilename(oriname);
                    fj.setZoompath(xdlj + filenameslt);
                    fj.setType("1");
                    fj.setLguid(lguid);
                    try {
                        fj.setSort(new BigDecimal(indexarr.get(index)));
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    liveDetailService.AddSingleFile(fj);
                    downFile(access_token, filelist, savePath, liveDetailService, xdlj, dguid, ++index, lguid,indexarr);
                } else {
                    //获取内容
                    InputStream inputStream = conn.getInputStream();
                    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream, "UTF8"));
                    final StringBuffer stringBuffer = new StringBuffer();
                    String line = null;
                    while ((line = bufferedReader.readLine()) != null) {
                        stringBuffer.append(line);
                    }
                    String resp = stringBuffer.toString();
                    System.out.println("contenttype:" + contenttype);
                    System.out.println("resp:" + resp);
                }
            } catch (Exception e) {
                System.out.println("errormessage:" + e.getMessage());
                filePath = null;
            }
        }
    }
}
