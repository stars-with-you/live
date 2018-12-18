package com.fl.live.service.impl;

import com.fl.common.CommonHelp;
import com.fl.common.TypeUtils;
import com.fl.live.service.LiveService;
import com.fl.mapper.AppCommentMapper;
import com.fl.mapper.AppLiveMapper;
import com.fl.mapper.AppLiveattachMapper;
import com.fl.mapper.AppLivedetailMapper;
import com.fl.model.AppLive;
import com.fl.model.AppLiveSwy;
import com.fl.model.AppLiveattach;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.List;

@Service
public class LiveServiceImpl implements LiveService {
    @Resource
    private AppLiveMapper appLiveMapper;
    @Resource
    private AppLivedetailMapper appLivedetailMapper;
    @Resource
    private AppLiveattachMapper appLiveattachMapper;
    @Resource
    private AppCommentMapper appCommentMapper;

    @Override
    public String getData(int currentPage, int pagesize, AppLive model) {
        PageHelper.startPage(currentPage, pagesize);
        List<AppLive> list = appLiveMapper.selectList(model);
        PageInfo<AppLive> pageinfo = new PageInfo<AppLive>(list);
        int totalcount = (int) pageinfo.getTotal();
        String json;
        try {
            json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
                    + CommonHelp.ConvertToJson(list) + "}";
        } catch (Exception e) {
            json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
    }

    //微信直播列表(我的直播)
    @Override
    public String getDataWX(int currentPage, int pagesize, AppLive model) {
        PageHelper.startPage(currentPage, pagesize);
        List<AppLive> list = appLiveMapper.selectListWX(model);
        PageInfo<AppLive> pageinfo = new PageInfo<AppLive>(list);
        int totalcount = (int) pageinfo.getTotal();
        String json;
        try {
            json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
                    + CommonHelp.ConvertToJson(list) + "}";
        } catch (Exception e) {
            json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
    }

    //    微信直播列表(授权的直播)
    public String getDataWXSQ(int currentPage, int pagesize, AppLive model) {
        PageHelper.startPage(currentPage, pagesize);
        List<AppLive> list = appLiveMapper.selectListWXSQ(model);
        PageInfo<AppLive> pageinfo = new PageInfo<AppLive>(list);
        int totalcount = (int) pageinfo.getTotal();
        String json;
        try {
            json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
                    + CommonHelp.ConvertToJson(list) + "}";
        } catch (Exception e) {
            json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
    }

    //    微信直播列表(关注的直播)
    public String getDataWXGZ(int currentPage, int pagesize, AppLive model) {
        PageHelper.startPage(currentPage, pagesize);
        List<AppLive> list = appLiveMapper.selectListWXGZ(model);
        PageInfo<AppLive> pageinfo = new PageInfo<AppLive>(list);
        int totalcount = (int) pageinfo.getTotal();
        String json;
        try {
            json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
                    + CommonHelp.ConvertToJson(list) + "}";
        } catch (Exception e) {
            json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
    }

    public String getSwy(int ct, String istj) {
        if (ct < 1) {
            ct = 10;
        }
        List<AppLiveSwy> list = appLiveMapper.getswy(istj, ct, 0);
        int totalcount = list.size();
        String json;

        try {
            if(totalcount>0) {
                json = "{\"code\": \"1\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
                        + CommonHelp.ConvertToJson(list) + "}";
            }
            else{
                json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
            }
        } catch (Exception e) {
            json = "{\"code\": \"0\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
    }

    /**
     * 判断是否有权限进行直播
     *
     * @param lguid
     * @param pguid
     * @return
     */
    @Override
    public boolean Auth(String lguid, String pguid) {
        List<AppLive> list = appLiveMapper.selectAuth(lguid, pguid);
        if (list != null && list.size() > 0) {
            return true;
        } else {
            return false;
        }
    }

    @Override
    public String Add(AppLive model) {
        try {
            int rows = appLiveMapper.insert(model);
            if (rows == 1) {
                return "1";
            } else {
                return "保存失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    @Override
    public String DelByLguid(String lguid, HttpServletRequest request) {
        try {
            AppLive model = appLiveMapper.selectSingle(lguid);
            int rows = appLiveMapper.delete(lguid);
            String logo = model.getDefaultpic();
            String logo2 = request.getSession().getServletContext().getRealPath(logo);
            if (!TypeUtils.isEmpty(logo2) && !logo2.contains("default.png")) {
                File uploadFile = new File(logo2);
                if (uploadFile.exists() && !uploadFile.isDirectory()) {
                    uploadFile.delete();
                }
            }
            String ewm = model.getEwm();
            String ewm2 = request.getSession().getServletContext().getRealPath(ewm);
            if (!TypeUtils.isEmpty(ewm2)) {
                File ewmuploadFile = new File(ewm2);
                if (ewmuploadFile.exists() && !ewmuploadFile.isDirectory()) {
                    ewmuploadFile.delete();
                }
            }
            String zbewm = model.getZbewm();
            String zbewm2 = request.getSession().getServletContext().getRealPath(zbewm);
            if (!TypeUtils.isEmpty(zbewm2)) {
                File zbewmuploadFile = new File(zbewm2);
                if (zbewmuploadFile.exists() && !zbewmuploadFile.isDirectory()) {
                    zbewmuploadFile.delete();
                }
            }
            List<AppLiveattach> list = appLiveattachMapper.selectListByLguid(lguid);
            for (int i = 0; i < list.size(); i++) {
                String path = list.get(i).getPath();
                String path2 = request.getSession().getServletContext().getRealPath(path);
                if (!TypeUtils.isEmpty(path2)) {
                    File pathuploadFile = new File(path2);

                    if (pathuploadFile.exists() && !pathuploadFile.isDirectory()) {
                        pathuploadFile.delete();
                    }
                }
                String zoompath = list.get(i).getZoompath();
                String zoompath2 = request.getSession().getServletContext().getRealPath(zoompath);
                if (!TypeUtils.isEmpty(zoompath2)) {
                    File zoompathuploadFile = new File(zoompath2);
                    if (zoompathuploadFile.exists() && !zoompathuploadFile.isDirectory()) {
                        zoompathuploadFile.delete();
                    }
                }
            }
            appLiveattachMapper.deleteByLguid(lguid);
            appLivedetailMapper.deleteByLguid(lguid);
            appCommentMapper.DeleteByLguid(lguid);
            if (rows == 1) {
                return "1";
            } else {
                return "删除失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    @Override
    public String GetSingle(String lguid) {
        return CommonHelp.ConvertToJson(appLiveMapper.selectSingle(lguid));
    }

    @Override
    public AppLive SelectSingle(String lguid) {
        return appLiveMapper.selectSingle(lguid);
    }

    @Override
    public String UpdateByLguid(AppLive model) {
        try {
            int rows = appLiveMapper.update(model);
            if (rows == 1) {
                return "1";
            } else {
                return "修改失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    /**
     * 点赞+1
     *
     * @param lguid
     * @return
     */
    @Override
    public String UpdateZanByLguid(String lguid) {
        try {
            int rows = appLiveMapper.updateZan(lguid);
            if (rows == 1) {
                return "1";
            } else {
                return "修改失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    /**
     * 访问量+1
     *
     * @param lguid
     * @return
     */
    @Override
    public String UpdateAccessByLguid(String lguid) {
        try {
            int rows = appLiveMapper.updateAccess(lguid);
            if (rows == 1) {
                return "1";
            } else {
                return "修改失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }
}
