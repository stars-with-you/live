package com.fl.mapper;

import com.fl.model.SReply;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SReplyMapper {
    List<SReply> selectIsReply(@Param("tel") String tel, @Param("sid") String sid);

    List<SReply> selectIsReplyByOpenid(@Param("openid") String openid, @Param("sid") String sid);

    int insert(List<SReply> record);
}