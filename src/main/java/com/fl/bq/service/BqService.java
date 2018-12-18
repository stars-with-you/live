package com.fl.bq.service;

import com.fl.model.AppBq;

import java.util.List;

public interface BqService {
    public String getSingle(String bguid);

    List<AppBq> list();

    public String GetList(int pn, int ps, AppBq model);

    public int Add(AppBq model);

    public int Update(AppBq model);

    public int Delete(String bguid);
}
