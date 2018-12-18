package com.fl.live.service.impl;

import com.fl.common.CommonHelp;
import com.fl.common.TypeUtils;
import com.fl.live.service.LiveDetailService;
import com.fl.mapper.AppLiveattachMapper;
import com.fl.mapper.AppLivebqMapper;
import com.fl.mapper.AppLivedetailMapper;
import com.fl.model.AppLiveattach;
import com.fl.model.AppLivebq;
import com.fl.model.AppLivedetail;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class LiveDetailServiceImpl implements LiveDetailService {
    @Resource
    private AppLivedetailMapper appLivedetail;
    @Resource
    private AppLiveattachMapper appLiveattachMapper;
    @Resource
    private AppLivebqMapper appLivebqMapper;

    public String bqjsonByDguid(String dguid) {
        List<AppLivebq> list = appLivebqMapper.selectByDguid(dguid);
        return CommonHelp.ConvertToJson(list);
    }
    ///获取直播的所有标签
    public String bqjson(String lguid,String bz) {
        List<AppLivebq> list=new ArrayList<AppLivebq>();
        if(bz.equals("1")){
            list= appLivebqMapper.selectByLguid(lguid);
        }
        else {
            list= appLivebqMapper.selectByLguidyh(lguid);
        }

        return CommonHelp.ConvertToJson(list);
    }

    public List<AppLivedetail> getList(String lguid) {
        AppLivedetail model = new AppLivedetail();
        model.setLguid(lguid);
        return appLivedetail.selectListFile(1000, lguid, 0, "", "");
    }

    @Override
    public String getData(int currentPage, int pagesize, AppLivedetail model) {
        PageHelper.startPage(currentPage, pagesize);
        List<AppLivedetail> list = appLivedetail.selectList(model);
        PageInfo<AppLivedetail> pageinfo = new PageInfo<AppLivedetail>(list);
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

    @Override
    public String getDataFile(int currentPage, int pagesize, String lguid, String isfb, String bq) {
        List<AppLivedetail> list = appLivedetail.selectListFile(pagesize * currentPage, lguid, (currentPage - 1) * pagesize, isfb, bq);
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
    public String Add(AppLivedetail model, List<AppLiveattach> listattach, List<AppLivebq> listbq) {
        try {
            int rows = 0;
            if (model != null) {
                rows = appLivedetail.insert(model);
            }
            if (listattach != null && listattach.size() > 0) {
                int rowsattach = appLiveattachMapper.insert(listattach);
            }
            appLivebqMapper.deleteByDguid(model.getDguid());
            if (listbq != null && listbq.size() > 0) {
                int rowsbq = appLivebqMapper.insertList(listbq);
            }
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
    public String AddSingleFile(AppLiveattach fj) {
        try {
            int rowsattach = appLiveattachMapper.insertSort(fj);
            if (rowsattach == 1) {
                return "1";
            } else {
                return "保存失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    @Override
    public String DelByDguid(String dguid, HttpServletRequest request) {
        try {
            int rows = appLivedetail.delete(dguid);
            appLivebqMapper.deleteByDguid(dguid);//删除标签
            AppLiveattach model = new AppLiveattach();
            model.setDguid(dguid);
            List<AppLiveattach> list = appLiveattachMapper.selectList(model);
            if (list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    String xdlj = list.get(i).getPath();
                    String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
                    File uploadFile = new File(jdlj);
                    if (uploadFile.exists() && !uploadFile.isDirectory()) {
                        uploadFile.delete();
                    }
                    String zoomlj = list.get(i).getZoompath();
                    if (!TypeUtils.isEmpty(zoomlj)) {
                        String zoomjdlj = request.getSession().getServletContext().getRealPath(zoomlj);
                        File zoomFile = new File(zoomjdlj);
                        // 判断文件是否上传，如果上传的话将会创建该目录
                        if (zoomFile.exists() && !zoomFile.isDirectory()) {
                            zoomFile.delete();
                        }
                    }
                }
                appLiveattachMapper.deleteByDguid(dguid);//删除附件
            }
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
    public String DelFileByAguid(String aguid, HttpServletRequest request) {
        try {
            AppLiveattach model = appLiveattachMapper.selectSingle(aguid);
            String xdlj = model.getPath();
            String zoomlj = model.getZoompath();
            String jdlj = request.getSession().getServletContext().getRealPath(xdlj);
            String zoomjdlj = request.getSession().getServletContext().getRealPath(zoomlj);
            File uploadFile = new File(jdlj);
            // 判断文件是否上传，如果上传的话将会创建该目录
            if (uploadFile.exists() && !uploadFile.isDirectory()) {
                uploadFile.delete();
            }
            File zoomFile = new File(zoomjdlj);
            // 判断文件是否上传，如果上传的话将会创建该目录
            if (zoomFile.exists() && !zoomFile.isDirectory()) {
                zoomFile.delete();
            }
            int rows = appLiveattachMapper.delete(aguid);
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
    public String GetSingle(String dguid) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("dmodel", appLivedetail.selectSingle(dguid));
        AppLiveattach model = new AppLiveattach();
        model.setDguid(dguid);
        map.put("amodel", appLiveattachMapper.selectList(model));
        return CommonHelp.ConvertToJson(map);
    }

    @Override
    public AppLivedetail SelectSingle(String dguid) {
        return appLivedetail.selectSingle(dguid);
    }

    @Override
    public String UpdateByDguid(AppLivedetail model, List<AppLiveattach> listattach, List<AppLivebq> listbq) {
        try {
            int rows = appLivedetail.update(model);
            if (listattach != null && listattach.size() > 0) {
                int rowsattach = appLiveattachMapper.insert(listattach);
            }
            appLivebqMapper.deleteByDguid(model.getDguid());
            if (listbq != null && listbq.size() > 0) {
                int rowsbq = appLivebqMapper.insertList(listbq);
            }
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
     * 修改附件順序
     * @param model
     * @return
     */
    @Override
    public int UpdateSortByDguid(AppLiveattach model){
        return appLiveattachMapper.updateSort(model);
    }

}
