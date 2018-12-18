package com.fl.shiro;

import com.fl.common.CommonHelp;
import com.fl.manager.service.ManagerService;
import com.fl.menu.service.AppMenuService;
import com.fl.model.AppMenu;
import com.fl.model.PsPermission;
import com.fl.model.PsRole;
import com.fl.model.PsUser;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.PrincipalCollection;

import javax.annotation.Resource;
import java.util.List;

public class UserManagerRealm extends AuthorizingRealm {
    @Resource
    private ManagerService managerServiceImpl;
    @Resource
    private AppMenuService appMenuService;

    /*
     * 清楚shiro缓存
     */
    public void clearCache() {
        PrincipalCollection principals = SecurityUtils.getSubject().getPrincipals();
        super.clearCache(principals);
    }

    /*
     * 授权
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        // 因为非正常退出，即没有显式调用 SecurityUtils.getSubject().logout()
        // (可能是关闭浏览器，或超时)，但此时缓存依旧存在(principals)，所以会自己跑到授权方法里。
        if (!SecurityUtils.getSubject().isAuthenticated()) {
            doClearCache(principals);
            SecurityUtils.getSubject().logout();
            return null;
        }
        String pguid = (String) principals.getPrimaryPrincipal();
        SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
        // 角色保存代码
        // 权限保存url
        List<PsRole> roles = managerServiceImpl.getRoles(pguid);
        for (PsRole tRoles : roles) {
            authorizationInfo.addRole(tRoles.getRcode());
        }
        List<PsPermission> permissions = managerServiceImpl.getPermissions(pguid);
        for (PsPermission tPermissions : permissions) {
            authorizationInfo.addStringPermission(tPermissions.getPurl());
        }
        return authorizationInfo;
    }

    /*
     * 认证
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        CustomUsernamePasswordToken login_token = (CustomUsernamePasswordToken) token;
        //（1） 以上校验码验证通过以后,查询数据库
        String loginname = (String) login_token.getPrincipal();//获取用户名
        PsUser user = managerServiceImpl.selectByPrimaryKey(loginname);
        if (user == null) {
            throw new UnknownAccountException("用户不存在！");// 没找到帐号
        }
        // 交给AuthenticatingRealm使用CredentialsMatcher进行密码匹配，如果觉得人家的不好可以自定义实现
        //（2）获取用户的用户名和密码，，，和用户输入的作比较
        SimpleAuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(user.getPguid(), // 用户名
                user.getLoginpwd(), // 密码
                getName() // realm name
        );
        //比较成功，保存session
        Session session = SecurityUtils.getSubject().getSession();
        session.setAttribute("openid", user.getOpenid());
        session.setAttribute("pguid", user.getPguid());
        session.setAttribute("auth", user.getAuth());
        session.setAttribute("usercata", user.getCata());
        session.setAttribute("loginname", user.getLoginname());
        session.setAttribute("displayname", user.getDisplayname());
        String json = appMenuService.getMenu();
        List<AppMenu> list = (List<AppMenu>) CommonHelp.ConvertToOjb(json);
        session.setAttribute("menu", list);
        return authenticationInfo;
    }
}
