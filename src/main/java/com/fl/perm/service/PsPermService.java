package com.fl.perm.service;

import com.fl.common.CommonHelp;
import com.fl.common.TypeUtils;
import com.fl.model.PsPermission;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import java.util.List;
import java.util.UUID;

public interface PsPermService {
    public String GetListAll();

    /**
     * 获取分页权限
     *
     * @param pn
     * @param ps
     * @param model
     * @return
     */
    public String GetList(int pn, int ps, PsPermission model);

    /**
     * 根据角色代码获取所有
     *
     * @param rcode
     * @return
     */
    public String GetListByRcode(String rcode);

    /**
     * 获取一条权限
     *
     * @param pid
     * @return
     */
    public String GetSingle(String pid);

    /**
     * 添加一条权限
     *
     * @param md
     * @return
     */
    public String Add(PsPermission md);

    /**
     * 更新一条权限
     *
     * @param md
     * @return
     */
    public String UpdateByPid(PsPermission md);

    /**
     * 删除一条权限信息
     *
     * @param pid
     * @return
     */
    public String DelByPid(String pid);
}
