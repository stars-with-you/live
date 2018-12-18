package com.fl.bq.service.impl;

import com.fl.bq.service.BqService;
import com.fl.common.CommonHelp;
import com.fl.common.TypeUtils;
import com.fl.mapper.AppBqMapper;
import com.fl.model.AppBq;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class BqServiceImpl implements BqService {
    @Resource
    private AppBqMapper appBqMapper;

    public String getSingle(String bguid) {
        return CommonHelp.ConvertToJson(appBqMapper.selectSingle(bguid));
    }

    @Override
    public List<AppBq> list() {
        return appBqMapper.select(null);
    }

    public String GetList(int pn, int ps, AppBq model) {
        if (!TypeUtils.isNumeric(String.valueOf(pn))) {
            pn = 1;
        }
        if (!TypeUtils.isNumeric(String.valueOf(ps))) {
            ps = 10;
        }
        List<AppBq> list = null;
        String result = "[]";
        int totalcount = 0;
        try {
            PageHelper.startPage(pn, ps);
            list = appBqMapper.select(model);
            PageInfo<AppBq> pageinfo = new PageInfo<AppBq>(list);
            totalcount = (int) pageinfo.getTotal();
        } catch (Exception e1) {
            return "";
        }
        String json;
        try {
            json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
                    + CommonHelp.ConvertToJson(list) + "}";
        } catch (Exception e) {
            json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
    }

    public int Add(AppBq model) {
        try {
            List<AppBq> list = appBqMapper.selectByBq(model.getBq());
            if (list != null && list.size() > 0) {
                return 3;
            }
            int rows = appBqMapper.insert(model);
            return rows;
        } catch (Exception e) {
            return 0;
        }
    }

    public int Update(AppBq model) {
        try {
            List<AppBq> list = appBqMapper.selectByBq(model.getBq());
            if (list != null && list.size() > 0) {
                return 3;
            }
            int rows = appBqMapper.update(model);
            return rows;
        } catch (Exception e) {
            return 0;
        }
    }

    public int Delete(String bguid) {
        try {
            int rows = appBqMapper.deleteByBguid(bguid);
            return rows;
        } catch (Exception e) {
            return 0;
        }
    }
}
