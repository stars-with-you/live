package com.fl.manager.controller;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.util.Date;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.fl.common.TypeUtils;
import com.fl.manager.service.ManagerService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import com.fl.common.CommonHelp;
import com.fl.menu.service.AppMenuService;
import com.fl.model.AppMenu;
import com.fl.model.PsUser;
import sun.misc.BASE64Encoder;

@Controller
@RequestMapping(value = "/manager")
public class ManagerController {
    @Resource
    private ManagerService userService;
    @Resource
    private HttpServletRequest request;
    private static final String jspmaster = CommonHelp
            .getPropertyKey(CommonHelp.getProperty("config/config.properties"), "jsp.master");

    /**
     * 登录页面
     *
     * @return
     */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String Login() {
        return "/manager/login";
    }

    /**
     * 登录操作
     *
     * @param loginname
     * @param loginpwd
     * @param code
     * @return
     */
    @RequestMapping(value = "/startlogin", method = RequestMethod.POST)
    @ResponseBody
    public String StartLogin(String loginname, String loginpwd, String code) {
        return userService.StartLogin(loginname, loginpwd, code);
    }

    /**
     * 模版首页
     *
     * @return
     */
    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public ModelAndView Index() {
        ModelAndView mView = new ModelAndView();
        mView.setViewName("/master/master" + jspmaster);
        return mView;
    }

    /**
     * 用户列表页面
     *
     * @return
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String List() {
        return "/manager/list_manager" + jspmaster;
    }

    /**
     * 添加用户
     *
     * @param model
     * @return
     * @throws ParseException
     */
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    @ResponseBody
    public String Add(PsUser model, MultipartFile picfile) {
        if (picfile != null) {
            String newname = picfile.getOriginalFilename();
            if (picfile.getSize() > 0 && TypeUtils.isImage(newname)) {
                try {
                    BASE64Encoder encoder = new BASE64Encoder();
                    String rst = encoder.encode(picfile.getBytes());
                    model.setLogo("data:image/" + CommonHelp.getHZMDot(newname) + ";base64," + rst);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        } else {
            String jdlj = request.getSession().getServletContext().getRealPath("/upload/defaultpic/default.png");
            BASE64Encoder encoder = new BASE64Encoder();
            String rst = encoder.encode(CommonHelp.getBytes(jdlj));
            model.setLogo("data:image/png;base64," + rst);
        }
        return userService.insert(model);
    }

    /**
     * 修改用户信息页面
     *
     * @param pguid
     * @return
     */
    @RequestMapping(value = "/getsingle")
    @ResponseBody
    public String getsingle(String pguid) {
        return userService.selectSingle(pguid);
    }

    /**
     * 修改用户信息
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @ResponseBody
    public String Update(PsUser model, MultipartFile picfile) {
        if (picfile != null) {
            String newname = picfile.getOriginalFilename();
            if (picfile.getSize() > 0 && TypeUtils.isImage(newname)) {
                try {
                    BASE64Encoder encoder = new BASE64Encoder();
                    String rst = encoder.encode(picfile.getBytes());
                    model.setLogo("data:image/" + CommonHelp.getHZMDot(newname) + ";base64," + rst);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        } else {
        }
        String pguid = (String) request.getSession().getAttribute("pguid");
        String mString = model.getPguid();
        if (pguid.equals(mString)) {
            request.getSession().setAttribute("displayname", model.getDisplayname());
        }
        model.setUpdatetime(new Date());
        return userService.update(model);
    }

    /**
     * 验证用户名是否存在
     *
     * @param loginname
     * @return
     */
    @RequestMapping(value = "/validate")
    @ResponseBody
    public String validate(String loginname) {
        return userService.validate(loginname);
    }

    @RequestMapping(value = "/validate2")
    @ResponseBody
    public String validate2(String loginname, String pguid) {
        return userService.validate2(loginname, pguid);
    }

    /**
     * 获取用户信息列表
     *
     * @param currentPage
     * @param model
     * @return
     */
    @RequestMapping(value = "/data", method = RequestMethod.POST)
    @ResponseBody
    public String getData(int currentPage, int pagesize, PsUser model) {
        return userService.getData(currentPage, pagesize, model);
    }

    /**
     * 删除管理员帐号
     *
     * @param pguid
     * @return
     */
    @RequestMapping(value = "/del", method = RequestMethod.POST)
    @ResponseBody
    public String delete(String pguid) {
        try {
            int rows = userService.delete(pguid);
            if (rows > 0) {
                return "1";
            } else {
                return "0";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    /**
     * 修改密码
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/upwd", method = RequestMethod.POST)
    @ResponseBody
    public String upwd(PsUser model) {
        try {
            int rows = userService.upwd(model);
            if (rows == 1) {
                return "1";
            } else {
                return "修改失败";
            }
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    @RequestMapping(value = "/exit")
    public String Exit() {
        SecurityUtils.getSubject().logout();
        return "redirect:/manager/login";
    }
}
