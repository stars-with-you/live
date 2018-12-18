package com.fl.mapper;

import com.fl.model.AppBq;

import java.util.List;

public interface AppBqMapper {
    int insert(AppBq record);

    AppBq selectSingle(String bguid);

    List<AppBq> select(AppBq model);

    List<AppBq> selectByBq(String bq);

    int deleteByBguid(String bguid);

    int update(AppBq model);
}