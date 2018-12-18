package com.fl.mapper;

import com.fl.model.SSurvey;

import java.util.List;

public interface SSurveyMapper {
    SSurvey getSingle(String sid);

    List<SSurvey> getList(SSurvey record);

    int insert(SSurvey record);

    int updateBySid(SSurvey record);

    int updateisedit(String sid);

    int deleteBySid(String sid);
}