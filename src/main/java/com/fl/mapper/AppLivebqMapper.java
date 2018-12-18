package com.fl.mapper;

import com.fl.model.AppLivebq;

import java.util.List;

public interface AppLivebqMapper {
    List<AppLivebq> selectByLguid(String lguid);

    List<AppLivebq> selectByLguidyh(String lguid);

    List<AppLivebq> selectByDguid(String dguid);

    int insert(AppLivebq record);

    int insertList(List<AppLivebq> list);

    int deleteByDguid(String dguid);

    int update(AppLivebq record);
}