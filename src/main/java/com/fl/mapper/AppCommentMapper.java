package com.fl.mapper;

import com.fl.model.AppComment;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface AppCommentMapper {
    int DeleteByCguid(@Param("cguid") String cguid);

    int DeleteByLguid(@Param("lguid") String lguid);

    int insert(AppComment model);

    AppComment selectSingle(String cguid);

    List<AppComment> selectList(AppComment model);

    List<AppComment> selectPersonList(String pguid);

    List<AppComment> selectListQt(@Param("endnum") int endnum, @Param("lguid") String lguid, @Param("startnum") int startnum, @Param("status") String status);

    List<AppComment> selectHfList(String hfguid);

    int update(AppComment model);

    int updateZan(@Param("cguid") String cguid);

    int updateStatus(@Param("cguid") String cguid, @Param("status") String status);
}