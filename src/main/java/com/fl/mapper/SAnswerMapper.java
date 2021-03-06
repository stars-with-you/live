package com.fl.mapper;

import com.fl.model.SAnswer;

import java.util.List;

public interface SAnswerMapper {
    List<SAnswer> selectBySid(String sid);

    List<SAnswer> selectAnswerCt(String sid);

    int insertList(List<SAnswer> record);

    int deleteBySid(String sid);
}