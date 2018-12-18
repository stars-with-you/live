package com.fl.mapper;

import com.fl.model.SQuestion;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SQuestionMapper {
    int insert(SQuestion record);

    int insertList(List<SQuestion> list);

    List<SQuestion> getListBySid(@Param("sid") String sid);

    int deleteBySid(String sid);
}