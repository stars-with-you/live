package com.fl.shiro;

import com.fl.mapper.PsShiroMapper;
import com.fl.model.PsShiro;
import org.apache.shiro.config.Ini;
import org.apache.shiro.config.Ini.Section;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

public class MyfilterChainDefinitionMap implements FactoryBean<Ini.Section> {
    @Autowired
    private PsShiroMapper psShiroMapper;
    private String filterChainDefinitions;

    public Section getObject() {
        List<PsShiro> list = psShiroMapper.selectAll();
        Ini ini = new Ini();
        //加载默认的url
        ini.load(filterChainDefinitions);
        Ini.Section section = ini.getSection(Ini.DEFAULT_SECTION_NAME);
        for (PsShiro resource : list) {
            section.put(resource.getSkey(), resource.getSvalue());
        }
        return section;
    }

    /**
     * 通过filterChainDefinitions对默认的url过滤定义
     *
     * @param filterChainDefinitions 默认的url过滤定义
     */
    public void setFilterChainDefinitions(String filterChainDefinitions) {
        this.filterChainDefinitions = filterChainDefinitions;
    }

    public Class<?> getObjectType() {
        return this.getClass();
    }

    public boolean isSingleton() {
        return false;
    }
}
