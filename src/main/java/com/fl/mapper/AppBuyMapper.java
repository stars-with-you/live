package com.fl.mapper;

import com.fl.model.AppBuy;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface AppBuyMapper {


    int insert(AppBuy record);

    int insertSelective(AppBuy record);

}