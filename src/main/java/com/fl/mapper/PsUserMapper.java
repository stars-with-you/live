package com.fl.mapper;

import java.util.List;

import com.fl.model.PsUser;
import org.apache.ibatis.annotations.Param;

public interface PsUserMapper {
    int insert(PsUser model);

    PsUser getSingleByLoginname(String loginname);

    PsUser getSingleByPguid(String pguid);
    PsUser getSingleByOpenid(String openid);

    PsUser getValidate(@Param("loginname") String loginname,@Param("pguid")  String pguid);

    List<PsUser> selectOrLoginname(PsUser model);

    int updateByPguid(PsUser model);
    int updateOpenid(@Param("loginname") String loginname,@Param("openid")  String openid);

    int deleteByPguid(String pguid);
}