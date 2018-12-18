package com.fl.live.systc.service;

import com.fl.model.SysTc;

import java.util.List;

public interface SystcService {
    /**
     * 插入一条套餐信息
     * @param model
     * @return 返回受影响的行数
     */
    public String insert(SysTc model);

    /**
     * 根据tguid查询套餐信息
     * @param tguid
     * @return 返回受影响的行数
     */
    public String select(String tguid);

    /**
     * 根据tguid删除信息
     * @param tguid
     * @return 返回受影响的行数
     */
    public String delete(String tguid);

    /**
     * 分页查询套餐信息
     * @param currentPage 当前页
     * @param pagesize 每页数量
     * @param model 查询条件
     * @return 返回查询列表json
     */
    public String getData(int currentPage, int pagesize, SysTc model);

    /**
     * 获取所有有效的套餐
     * @return
     */
    public List<SysTc> getAll();
    /**
     * 更新一条套餐信息，根据tguid
     * @param model
     * @return 返回受影响的行数
     */
    public String update(SysTc model);
}
