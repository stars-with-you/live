package com.fl.live.service.impl;

import com.fl.common.CommonHelp;
import com.fl.live.service.LiveAuthService;
import com.fl.mapper.AppAuthMapper;
import com.fl.model.AppAuth;
import com.fl.model.AppComment;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class LiveAuthServiceImpl implements LiveAuthService {
    @Autowired
    private AppAuthMapper appAuthMapper;

    @Override
    public String insert(AppAuth model) {
        model.setAuguid(CommonHelp.getUuid());
        model.setCata("1");
        model.setSqtime(new Date());
        int rows = appAuthMapper.insert(model);
        return String.valueOf(rows);
    }

    @Override
    public String insertMap(List<AppAuth> list) {
        int rows = appAuthMapper.insertMap(list);
        return String.valueOf(rows);
    }

    @Override
    public String deleteByAuguid(String auguid) {
        int rows = appAuthMapper.deleteByAuguid(auguid);
        return String.valueOf(rows);
    }

    @Override
    public String getData(int currentPage, int pagesize, AppAuth model) {
//        PageHelper.startPage(currentPage, pagesize);
        List<AppAuth> list = appAuthMapper.selectList(model);
//        PageInfo<AppAuth> pageinfo = new PageInfo<AppAuth>(list);
        int totalcount = (int) list.size();
        String json;
        try {
            json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
                    + CommonHelp.ConvertToJson(list) + "}";
        } catch (Exception e) {
            json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
    }
}
