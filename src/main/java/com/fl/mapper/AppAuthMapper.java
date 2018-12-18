package com.fl.mapper;

import com.fl.model.AppAuth;
import com.fl.model.AppComment;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface AppAuthMapper {
    int insert(AppAuth model);

    int insertMap(List<AppAuth> list);

    int deleteByAuguid(String auguid);

    List<AppAuth> selectList(AppAuth model);
}