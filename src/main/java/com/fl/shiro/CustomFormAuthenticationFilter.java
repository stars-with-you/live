/*
  Created: 方磊
  Date: 2017年8月18日  上午8:59:55

*/
package com.fl.shiro;

import java.io.PrintWriter;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.apache.shiro.web.util.WebUtils;

import com.fl.common.CommonHelp;
import com.fl.common.TypeUtils;

public class CustomFormAuthenticationFilter extends FormAuthenticationFilter {
	/**
	 * (1)访问地址必须存在，否则报404错误 (2)访问地址必须配置authc
	 * (3)请求不是Ajax请求(4)帐号登录失效或没有登录的情况下(5)否则不会调用这个filter
	 */
	@Override
	protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws Exception {
		// 是否是登录请求地址，根据loginUrl调用pathMatcher方法判断
		if (isLoginRequest(request, response)) {
			if (isLoginSubmission(request, response)) {
				return executeLogin(request, response);
			} else {
				// 放行 allow them to see the login page ;)
				return true;
			}
		} else {
			HttpServletRequest httpRequest = WebUtils.toHttp(request);

			if (TypeUtils.isAjax(httpRequest)) {// Ajax请求

				HttpServletResponse httpServletResponse = WebUtils.toHttp(response);
				httpServletResponse.setCharacterEncoding("UTF-8");
				PrintWriter out = httpServletResponse.getWriter();
				if (TypeUtils.isGet(httpRequest)) {
					out.println("<script>alert('登录失效,或者您没有访问权限');</script>");
				} else {
					out.println("登录失效,或者您没有访问权限");
				}
				out.flush();
				out.close();
				return false;

			} else {

				String path = httpRequest.getContextPath();
				String basePath = httpRequest.getScheme() + "://" + httpRequest.getServerName() + ":"
						+ httpRequest.getServerPort() + path + "/";

				String url = httpRequest.getRequestURL().toString();
				String config = CommonHelp.getPropertyKey(CommonHelp.getProperty("config/config.properties"),
						"manager.tologinurl");
				String[] arr = config.split(",");
//				if (TypeUtils.IsStringContainsStr(url, arr)) {
//					setLoginUrl(basePath + "manager/login");
//				} else {
//					setLoginUrl(basePath + "show/normal/login");
//				}
				setLoginUrl(basePath + "manager/login");
				saveRequestAndRedirectToLogin(request, response);
			}
			return false;
		}
	}
}
