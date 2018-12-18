package com.fl.mapper;

import com.fl.model.AppLivelogo;

import java.util.List;

public interface AppLivelogoMapper {
    AppLivelogo selectSingle(String logoid);

    List<AppLivelogo> selectList(String lguid);

    int insert(AppLivelogo record);

    int deleteByKey(String logoid);

    int deleteByLguid(String lguid);
}