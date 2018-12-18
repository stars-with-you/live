package com.fl.live.systc.service.impl;

import com.fl.common.CommonHelp;
import com.fl.mapper.SysTcMapper;
import com.fl.model.AppLive;
import com.fl.model.SysTc;
import com.fl.live.systc.service.SystcService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service
public class SystcServiceImpl implements SystcService {
    private static final Logger log = LoggerFactory.getLogger(SystcServiceImpl.class.getName());
    @Resource
    private SysTcMapper sysTcMapper;

    @Override
    public String insert(SysTc model) {
        model.setTguid(CommonHelp.getUuid());
        model.setCtime(new Date());
        try {
            int rows = sysTcMapper.insert(model);
            if (rows == 1) {
                return "1";
            } else {
                return "保存失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    @Override
    public String select(String tguid) {
        return CommonHelp.ConvertToJson(sysTcMapper.selectSingle(tguid));
    }

    @Override
    public String delete(String tguid) {
        return null;
    }

    @Override
    public String getData(int currentPage, int pagesize, SysTc model) {
        PageHelper.startPage(currentPage, pagesize);
        List<SysTc> list = sysTcMapper.selectList(model);
        PageInfo<SysTc> pageinfo = new PageInfo<SysTc>(list);
        int totalcount = (int) pageinfo.getTotal();
        String json;
        try {
            json = "{\"code\": \"0\", \"msg\": \"\",\"count\": \"" + totalcount + "\",\"data\":"
                    + CommonHelp.ConvertToJson(list) + "}";
        } catch (Exception e) {
            json = "{\"code\": \"1\", \"msg\": \"\",\"count\":0,data:[]}";
        }
        return json;
    }

    @Override
    public List<SysTc> getAll() {
        SysTc model=new SysTc();
        model.setYxbz("1");
        return sysTcMapper.selectList(model);
    }

    @Override
    public String update(SysTc model) {
        try {
            model.setCtime(new Date());

            int rows = sysTcMapper.update(model);
            if (rows == 1) {
                return "1";
            } else {
                return "修改失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }
}
