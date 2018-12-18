package com.fl.live.service.impl;

import com.fl.common.CommonHelp;
import com.fl.live.service.LiveAttentionService;
import com.fl.mapper.AppAttentionMapper;
import com.fl.model.AppAttention;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;

@Service
public class LiveAttentionServiceImpl implements LiveAttentionService {
    @Resource
    protected AppAttentionMapper appAttentionMapper;

    public boolean isgz(String pguid, String lguid) {
        AppAttention m = appAttentionMapper.selectSingle(pguid, lguid);
        if (m == null) {//没关注
            return false;
        } else {
            return true;
        }
    }

    @Override
    public String insert(AppAttention model) {
        try {
            AppAttention m = appAttentionMapper.selectSingle(model.getPguid(), model.getLguid());
            if (m == null) {
                model.setGzid(CommonHelp.getUuid());
                model.setAddtime(new Date());
                int i = appAttentionMapper.insert(model);
                if (i == 1) {
                    return "1";
                } else {
                    return "2";
                }
            } else {
                return "1";
            }
        } catch (Exception e) {
            return "0";
        }
    }

    @Override
    public String deleteByGzid(String pguid, String lguid) {
        int i = appAttentionMapper.delete(pguid, lguid);
        if (i > 0) {
            return "1";
        } else {
            return "0";
        }
    }
}
