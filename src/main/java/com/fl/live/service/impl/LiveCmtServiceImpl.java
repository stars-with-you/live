package com.fl.live.service.impl;

import com.fl.common.CommonHelp;
import com.fl.live.service.LiveCmtService;
import com.fl.mapper.AppCommentMapper;
import com.fl.model.AppComment;
import com.fl.model.AppLive;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.ParseException;
import java.util.List;

@Service
public class LiveCmtServiceImpl implements LiveCmtService {
    @Resource
    private AppCommentMapper appCommentMapper;
    @Override
    public String getData(int currentPage, int pagesize, AppComment model) {
        PageHelper.startPage(currentPage, pagesize);
        List<AppComment> list = appCommentMapper.selectList(model);
        PageInfo<AppComment> pageinfo = new PageInfo<AppComment>(list);
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
    public String getPersonData(int currentPage, int pagesize, String openid) {
        PageHelper.startPage(currentPage, pagesize);
        List<AppComment> list = appCommentMapper.selectPersonList(openid);
        PageInfo<AppComment> pageinfo = new PageInfo<AppComment>(list);
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

    /**
     * 获取评论的回复信息
     * @param hfguid
     * @return
     */
    @Override
    public String getDataHf(String hfguid) {
        List<AppComment> list = appCommentMapper.selectHfList(hfguid);
        int totalcount =list.size();
        String json;
        try {
            json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
                    + CommonHelp.ConvertToJson(list) + "}";
        } catch (Exception e) {
            json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
    }
    @Override
    public String getDataQt(int currentPage, int pagesize,AppComment model) {
        List<AppComment> list = appCommentMapper.selectListQt(pagesize*currentPage,model.getLguid(),(currentPage-1)*pagesize,model.getStatus());
        int totalcount = list.size();
        String json;
        try {
            json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
                    + CommonHelp.ConvertToJson(list) + "}";
        } catch (Exception e) {
            json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
    }

    @Override
    public String Add(AppComment model) {

        try {
            int rows = appCommentMapper.insert(model);
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
    public String DelByCguid(String cguid) {
        try {
            int rows = appCommentMapper.DeleteByCguid(cguid);
            if (rows >= 1) {
                return "1";
            } else {
                return "删除失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    @Override
    public String DelByLguid(String lguid) {
        return null;
    }

    @Override
    public String GetSingle(String cguid) {
        return CommonHelp.ConvertToJson(appCommentMapper.selectSingle(cguid));
    }

    @Override
    public String Update(AppComment model) {
        try {
            int rows = appCommentMapper.update(model);
            if (rows == 1) {
                return "1";
            } else {
                return "修改失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    @Override
    public String UpdateZan(String cguid) {
        try {
            int rows = appCommentMapper.updateZan(cguid);
            if (rows == 1) {
                return "1";
            } else {
                return "修改失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    @Override
    public String UpdateStatus(String cguid, String status) {
        try {
            int rows = appCommentMapper.updateStatus(cguid,status);
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
