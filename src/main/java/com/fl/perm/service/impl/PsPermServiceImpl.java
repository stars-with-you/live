/*
  Created: 方磊
  Date: 2017年8月16日  上午9:19:26

*/
package com.fl.perm.service.impl;

import java.util.List;
import java.util.UUID;

import com.fl.perm.service.PsPermService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.fl.common.CommonHelp;
import com.fl.common.TypeUtils;
import com.fl.mapper.PsPermissionMapper;
import com.fl.model.PsPermission;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Service
public class PsPermServiceImpl implements PsPermService {
    @Autowired
    private PsPermissionMapper tp;
    private static final Logger logger = LoggerFactory.getLogger(PsPermServiceImpl.class.getName());

    public String GetListAll() {
        List<PsPermission> list = null;
        String result = "";
        try {
            list = tp.GetListAll();
        } catch (Exception e1) {
            logger.error("权限列表获取", e1);
        }
        if (list != null && list.size() > 0) {
            try {
                result = CommonHelp.ConvertToJson(list);
            } catch (Exception e) {
                logger.error("权限列表转成json时出错：", e);
            }
        }
        return result;
    }

    /**
     * 获取分页权限
     *
     * @param pn
     * @param ps
     * @param model
     * @return
     */
    public String GetList(int pn, int ps, PsPermission model) {
        if (!TypeUtils.isNumeric(String.valueOf(pn))) {
            pn = 1;
        }
        if (!TypeUtils.isNumeric(String.valueOf(ps))) {
            ps = 10;
        }
        List<PsPermission> list = null;
        String result = "[]";
        int totalcount = 0;
        try {
            PageHelper.startPage(pn, ps);
            list = tp.GetListOrPname(model);
            PageInfo<PsPermission> pageinfo = new PageInfo<PsPermission>(list);
            totalcount = (int) pageinfo.getTotal();
        } catch (Exception e1) {
            logger.error("权限列表获取", e1);
            return "";
        }
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
     * 根据角色代码获取所有
     *
     * @param rcode
     * @return
     */
    public String GetListByRcode(String rcode) {
        List<PsPermission> list = null;
        String result = "";
        try {
            list = tp.GetListByRcode(rcode);
        } catch (Exception e1) {
            logger.error("权限列表获取", e1);
        }
        if (list != null && list.size() > 0) {
            try {
                result = CommonHelp.ConvertToJson(list);
            } catch (Exception e) {
                logger.error("权限列表转成json时出错：", e);
            }
        }
        return result;
    }

    /**
     * 获取一条权限
     *
     * @param pid
     * @return
     */
    public String GetSingle(String pid) {
        PsPermission mv = tp.GetSingle(pid);
        String result = "";
        if (mv != null) {
            try {
                result = CommonHelp.ConvertToJson(mv);
            } catch (Exception e) {
                // TODO Auto-generated catch block
                logger.error("单条权限转成json时出错：", e);
            }
        }
        return result;
    }

    /**
     * 添加一条权限
     *
     * @param md
     * @return
     */
    public String Add(PsPermission md) {
        PsPermission model = new PsPermission();
        model.setPid(UUID.randomUUID().toString().replaceAll("-", ""));
        model.setPname(md.getPname());
        model.setPurl(md.getPurl());
        try {
            int rows = tp.Add(model);
            if (rows == 1) {
                return "1";
            } else {
                return "权限添加失败";
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            logger.error("权限添加失败：", e);
            return "权限添加失败：" + e.getMessage();
        }
    }

    /**
     * 更新一条权限
     *
     * @param md
     * @return
     */
    public String UpdateByPid(PsPermission md) {
        //new UserManagerRealm().clearCache();
        try {
            int rows = tp.UpdateByPid(md);
            if (rows == 1) {
                return "1";
            } else {
                return "权限修改失败";
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            logger.error("权限修改失败：", e);
            return "权限修改失败：" + e.getMessage();
        }
    }

    /**
     * 删除一条权限信息
     *
     * @param pid
     * @return
     */
    public String DelByPid(String pid) {
        //new UserManagerRealm().clearCache();
        int rows;
        try {
            rows = tp.DelByPid(pid);
            if (rows == 1) {
                return "1";
            } else {
                return "权限删除失败";
            }
        } catch (Exception e) {
            logger.error("权限删除失败", e);
            return "权限删除失败:" + e.getMessage();
        }
    }
}
