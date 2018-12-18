/*
  Created: 方磊
  Date: 2017年7月25日  下午3:36:35

*/
package com.fl.manager.service.impl;

import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;

import com.fl.manager.service.ManagerService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.fl.common.CommonHelp;
import com.fl.common.EncodeUtils;
import com.fl.common.TypeUtils;
import com.fl.mapper.PsPermissionMapper;
import com.fl.mapper.PsRoleMapper;
import com.fl.mapper.PsUserMapper;
import com.fl.mapper.PsUserroleMapper;
import com.fl.model.PsPermission;
import com.fl.model.PsRole;
import com.fl.model.PsUser;
import com.fl.shiro.CustomUsernamePasswordToken;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Service
public class ManagerServiceImpl implements ManagerService {
    @Autowired
    private PsUserMapper userMapper;
    @Autowired
    private PsRoleMapper roleMapper;
    @Autowired
    private PsPermissionMapper permissionMapper;
    @Autowired
    private PsUserroleMapper userrolemapper;
    private static final Logger log = LoggerFactory.getLogger(ManagerServiceImpl.class.getName());

    /**
     * 获取一条用户信息
     */
    public PsUser selectByPrimaryKey(String loginname) {
        return userMapper.getSingleByLoginname(loginname);
    }
    public PsUser selectByOpenid(String openid) {
        return userMapper.getSingleByOpenid(openid);
    }
    public String selectSingle(String pguid) {
        return CommonHelp.ConvertToJson(userMapper.getSingleByPguid(pguid));
    }

    public List<PsRole> getRoles(String pguid) {
        return roleMapper.GetListByLoginname(pguid);
    }

    public List<PsPermission> getPermissions(String pguid) {
        return permissionMapper.getPermissionsByLoginname(pguid);
    }

    public String insert(PsUser model) {
        model.setLoginpwd(EncodeUtils.getMD5(model.getLoginpwd()));
        model.setAddtime(new Date());
        //生成用户唯一键
        model.setPguid(CommonHelp.getUuid());
        //空的话，设置成普通用户
        String cata=model.getCata();
        if (TypeUtils.isEmpty(cata)){
            model.setCata("1");
        }
        try {
            model.setUpdatetime(CommonHelp.getNowTime());
        } catch (ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        try {
            int rows = userMapper.insert(model);
            if (rows == 1) {
                return "1";
            } else {
                return "保存失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    /**
     * 修改密码
     */
    public int upwd(PsUser model) {
        String pwd = model.getLoginpwd();
        model.setLoginpwd(EncodeUtils.getMD5(pwd));
        int rows = userMapper.updateByPguid(model);
        return rows;
    }

    public int delete(String pguid) {
        userrolemapper.DelByRid(pguid);
        return userMapper.deleteByPguid(pguid);
    }

    public String getData(int currentPage, int pagesize, PsUser model) {
        if (!TypeUtils.isNumeric(String.valueOf(currentPage))) {
            currentPage = 1;
        }
        if (!TypeUtils.isNumeric(String.valueOf(pagesize))) {
            pagesize = 10;
        }
        PageHelper.startPage(currentPage, pagesize);
        List<PsUser> list = userMapper.selectOrLoginname(model);
        PageInfo<PsUser> pageinfo = new PageInfo<PsUser>(list);
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

    public String StartLogin(String loginname, String loginpwd, String code) {
        String logintype = "";
        Properties properties = CommonHelp.getProperty("config/shiro/login.properties");
        logintype = CommonHelp.getPropertyKey(properties, "login.usermanager");
        CustomUsernamePasswordToken token = new CustomUsernamePasswordToken(loginname.trim(),
                EncodeUtils.getMD5(loginpwd.trim()), false, "", code, logintype);
        Subject subject = SecurityUtils.getSubject();
        // if (!subject.isAuthenticated()) {
        Session session = subject.getSession();
        try {
            String validatecode = (String) session.getAttribute("validatecode");
            // String validatecode = redisService.get("validatecode");
            if (!code.trim().equals(validatecode)) {
                return "2";
            }
            try {
                subject.login(token);
                return "1";
            } catch (Exception ex) {
                log.error("登录失败", ex);
                return "0";
            }
        } catch (Exception ex) {
            log.error("", ex);
            return "3";
        }
        // }
        // return "1";
    }
    public String StartLogin2(String loginname, String loginpwd, String code,String openid) {
        String logintype = "";
        Properties properties = CommonHelp.getProperty("config/shiro/login.properties");
        logintype = CommonHelp.getPropertyKey(properties, "login.usermanager");
        CustomUsernamePasswordToken token = new CustomUsernamePasswordToken(loginname.trim(),
                EncodeUtils.getMD5(loginpwd.trim()), false, "", code, logintype);
        Subject subject = SecurityUtils.getSubject();
        // if (!subject.isAuthenticated()) {
        Session session = subject.getSession();
        try {
            String validatecode = (String) session.getAttribute("validatecode");
            // String validatecode = redisService.get("validatecode");
            if (!code.trim().equals(validatecode)) {
                return "2";
            }
            try {
                subject.login(token);
                userMapper.updateOpenid(loginname,openid);
                return "1";
            } catch (Exception ex) {
                log.error("登录失败", ex);
                return "0";
            }
        } catch (Exception ex) {
            log.error("", ex);
            return "3";
        }
        // }
        // return "1";
    }
    /**
     * 根据openid进行登录
     * @param openid
     * @return
     */
    public String WXStartLogin(String openid) {
        Subject subject = SecurityUtils.getSubject();
//        if(subject.isAuthenticated())//已经登录
//        {
//            return "1";
//        }
//        else {
            PsUser model = userMapper.getSingleByOpenid(openid);
            if (model != null) {
                String logintype = "";
                Properties properties = CommonHelp.getProperty("config/shiro/login.properties");
                logintype = CommonHelp.getPropertyKey(properties, "login.usermanager");
                CustomUsernamePasswordToken token = new CustomUsernamePasswordToken(model.getLoginname(),
                        model.getLoginpwd(), false, "", "", logintype);
                Session session = subject.getSession();
                try {
                    try {
                        subject.login(token);
                        return "1";
                    } catch (Exception ex) {
                        log.error("登录失败", ex);
                        return "0";
                    }
                } catch (Exception ex) {
                    log.error("", ex);
                    return "3";
                }
            } else {
                return "0";
            }
//        }
    }
    /**
     * 修改用户基本信息
     *
     * @param model
     * @return
     */
    public String update(PsUser model) {
        try {
            int rows = userMapper.updateByPguid(model);
            if (rows == 1) {
                return "1";
            } else {
                return "修改失败";
            }
        } catch (Exception ex) {
            log.error("用户信息用户失败", ex);
            return ex.getMessage();
        }
    }

    /**
     * 验证用户名是否存在
     *
     * @param loginname
     * @return 存在的话，返回false,验证不通过。
     */
    public String validate(String loginname) {
        try {
            PsUser user = userMapper.getSingleByLoginname(loginname);
            if (user != null) {
                return "false";
            } else {
                return "true";
            }
        } catch (Exception ex) {
            return "false";
        }
    }
    public String validate2(String loginname,String pguid) {
        try {
            PsUser user = userMapper.getValidate(loginname,pguid);
            if (user != null) {
                return "false";
            } else {
                return "true";
            }
        } catch (Exception ex) {
            return "false";
        }
    }
}
