package com.fl.mapper;

import com.fl.model.AppLiveattach;

import java.util.List;

public interface AppLiveattachMapper {
    List<AppLiveattach> selectList(AppLiveattach record);

    List<AppLiveattach> selectListByLguid(String lguid);

    int insert(List<AppLiveattach> list);
     int insertSort(AppLiveattach model);
    AppLiveattach selectSingle(String aguid);

    int update(AppLiveattach record);

    int updateSort(AppLiveattach record);

    int delete(String aguid);

    int deleteByDguid(String dguid);

    int deleteByLguid(String lguid);
}