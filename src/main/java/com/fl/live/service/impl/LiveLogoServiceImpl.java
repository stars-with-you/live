package com.fl.live.service.impl;

import com.fl.common.CommonHelp;
import com.fl.live.service.LiveLogoService;
import com.fl.mapper.AppLivelogoMapper;
import com.fl.model.AppLivelogo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.List;

@Service
public class LiveLogoServiceImpl implements LiveLogoService {
    @Resource
    private AppLivelogoMapper appLivelogoMapper;

    public String getData(String lguid) {
        List<AppLivelogo> list = appLivelogoMapper.selectList(lguid);
        String json;
        try {
            json = CommonHelp.ConvertToJson(list);
        } catch (Exception e) {
            json = "";
        }
        return json;
    }

    public List<AppLivelogo> getList(String lguid) {
        return appLivelogoMapper.selectList(lguid);
    }

    @Override
    public int Add(AppLivelogo model) {
        return appLivelogoMapper.insert(model);
    }

    public String DelByLogoid(String logoid, HttpServletRequest request) {
        try {
            AppLivelogo model = appLivelogoMapper.selectSingle(logoid);
            if (model != null) {
                String xdlj = model.getDefaultpic();
                String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                File uploadFile = new File(jdlj);
                // 判断文件是否上传，如果上传的话将会创建该目录
                if (uploadFile.exists()) {
                    uploadFile.delete();
                }
                int rows = appLivelogoMapper.deleteByKey(logoid);
                if (rows == 1) {
                    return "1";
                } else {
                    return "删除失败";
                }
            } else {
                return "删除失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    public String DelByLguid(String lguid, HttpServletRequest request) {
        try {
            List<AppLivelogo> list = appLivelogoMapper.selectList(lguid);
            if (list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    String xdlj = list.get(i).getDefaultpic();
                    String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                    File uploadFile = new File(jdlj);
                    // 判断文件是否上传，如果上传的话将会创建该目录
                    if (uploadFile.exists()) {
                        uploadFile.delete();
                    }
                }
                int rows = appLivelogoMapper.deleteByLguid(lguid);
                if (rows > 0) {
                    return "1";
                } else {
                    return "删除失败";
                }
            } else {
                return "删除失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }
}
