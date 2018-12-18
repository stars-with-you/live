package com.fl.live.controller;

import com.fl.common.CommonHelp;
import com.fl.common.ImgUtil;
import com.fl.common.TypeUtils;
import com.fl.live.service.LiveLogoService;
import com.fl.model.AppLivelogo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.Date;

@Controller
@RequestMapping(value = "/livelogo")
public class LiveLogoController {
    @Resource
    private HttpServletRequest request;
    @Resource
    private LiveLogoService liveLogoService;

    @RequestMapping(value = "/fileadd", method = RequestMethod.POST)
    @ResponseBody
    public String FileAdd(String lguid,  MultipartFile picfile) {
        String base64 = "";
        String logoid = "";
        String sltlj="";
        if (picfile != null) {
            AppLivelogo attach = new AppLivelogo();
            String newname = picfile.getOriginalFilename();
            if (TypeUtils.isImage(newname)) {
                try {
                    String fguid = CommonHelp.getUuid();
                    String newfilename = fguid + CommonHelp.getHZMDot(newname);
                    // 文件保存路径
                    String xdlj = "/upload/defaultpic/" + lguid+ "/";
                    String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                    File uploadFile = new File(jdlj);
                    // 判断文件是否上传，如果上传的话将会创建该目录
                    if (!uploadFile.exists()) {
                        uploadFile.mkdirs(); // 创建该目录
                    }
//                    if (picfile.getSize() > 1024 * 1024 * 1) {//大于1M,进行压缩
//                        BufferedImage bi = CommonHelp.MultipartFileToBufferedImage(picfile);
//                        if (bi != null) {
//                            CommonHelp.FileToYSFile(bi, jdlj + newfilename, 0.9f);
//                        }
//                    } else {
//                        picfile.transferTo(new File(jdlj + newfilename));
//                    }
                    ImgUtil imgUtil = new ImgUtil();
                    imgUtil.ThumbnailsImgMultipartFile(1280, picfile, jdlj + newfilename);
                    logoid = CommonHelp.getUuid();
                    attach.setLogoid(logoid);
                    attach.setLguid(lguid);
                    attach.setOriname(newname);
                    attach.setCata("");
                    sltlj=xdlj + newfilename;
                    attach.setDefaultpic(xdlj + newfilename);
                    attach.setAddtime(new Date());
                    attach.setZoompath("");
                    liveLogoService.Add(attach);
                } catch (Exception e) {
                    return "0";
                }
            }
        }
        return "{\"bz\":\"1\",\"rst\":{\"logoid\":\"" + logoid + "\",\"defaultpic\":\"" + sltlj + "\"}}";
    }
    @RequestMapping(value = "/delbylogoid", method = RequestMethod.POST)
    @ResponseBody
    public String Delete(String logoid) {
        return liveLogoService.DelByLogoid(logoid, request);
    }
    @RequestMapping(value = "/delbylguid", method = RequestMethod.POST)
    @ResponseBody
    public String DeleteByLguid(String lguid) {
        return liveLogoService.DelByLguid(lguid, request);
    }
    @RequestMapping(value = "/data", method = RequestMethod.POST)
    @ResponseBody
    public String getData(String lguid) {
        try {
            String rst = liveLogoService.getData(lguid);
            return rst;
        } catch (Exception e) {
            return "";
        }
    }
}
