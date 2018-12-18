/*
  Created: 方磊
  Date: 2017年8月25日  下午5:27:28

*/
package com.fl.urlpr.service.impl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.PostConstruct;

import com.fl.urlpr.service.MyUrlFilterService;
import org.apache.shiro.config.Ini;
import org.apache.shiro.config.Ini.Section;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.util.CollectionUtils;
import org.apache.shiro.web.filter.mgt.DefaultFilterChainManager;
import org.apache.shiro.web.filter.mgt.PathMatchingFilterChainResolver;
import org.apache.shiro.web.servlet.AbstractShiroFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import com.fl.mapper.PsShiroMapper;
import com.fl.model.PsShiro;
import org.springframework.stereotype.Service;

/**
 * 用来更新拦截权限
 */
@Service
public class MyUrlFilterServiceImpl implements MyUrlFilterService {
    private final static Logger log = LoggerFactory.getLogger(MyUrlFilterServiceImpl.class);
    @Autowired
    private ShiroFilterFactoryBean shiroFilterFactoryBean;
    @Autowired
    private PsShiroMapper psShiroMapper;
    private String definitions = "";

    public String getDefinitions() {
        return definitions;
    }

    public void setDefinitions(String definitions) {
        this.definitions = definitions;
    }

    /**
     * 更新url权限过滤配置
     */
    public void updatePermission() {
        synchronized (shiroFilterFactoryBean) {// 强制同步，控制线程安全
            AbstractShiroFilter shiroFilter = null;
            try {
                shiroFilter = (AbstractShiroFilter) shiroFilterFactoryBean.getObject();
            } catch (Exception e) {
                log.error(e.getMessage());
            }
            // 获取过滤管理器
            PathMatchingFilterChainResolver filterChainResolver = (PathMatchingFilterChainResolver) shiroFilter
                    .getFilterChainResolver();
            DefaultFilterChainManager manager = (DefaultFilterChainManager) filterChainResolver.getFilterChainManager();
            // （0）清空初始权限配置
            manager.getFilterChains().clear();
            shiroFilterFactoryBean.getFilterChainDefinitionMap().clear();
            // （1）加载配置文件中的权限配置
            shiroFilterFactoryBean.setFilterChainDefinitions(definitions);
            List<PsShiro> list = psShiroMapper.selectAll();
            Map<String, String> map = new LinkedHashMap<String, String>();
            for (int i = 0; i < list.size(); i++) {
                map.put(list.get(i).getSkey(), list.get(i).getSvalue());
            }
            shiroFilterFactoryBean.setFilterChainDefinitionMap(map);
        }
    }
}
