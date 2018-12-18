/*
  Created: 方磊
  Date: 2017年8月22日  下午5:17:44

*/
package com.fl.shiro;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.subject.Subject;
import org.apache.shiro.util.StringUtils;
import org.apache.shiro.web.filter.authz.AuthorizationFilter;
import org.apache.shiro.web.util.WebUtils;

import com.fl.common.TypeUtils;

public class CustomPermissionsAuthorizationFilter extends AuthorizationFilter {

	// TODO - complete JavaDoc
	/**
	 * 当权限验证没有通过时调用此方法
	 */
	@Override
	protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws IOException {
		Subject subject = getSubject(request, response);
		// If the subject isn't identified, redirect to login URL
		if (subject.getPrincipal() == null) {
			saveRequestAndRedirectToLogin(request, response);
		} else {
			HttpServletRequest httpRequest = WebUtils.toHttp(request);
			// (1)如果是Ajax请求,不进行跳转
			// java.lang.IllegalStateException: Cannot call sendRedirect() after
			// the response has been committed
			if (!TypeUtils.isAjax(httpRequest)) {// Ajax请求
				// If subject is known but not authorized, redirect to the
				// unauthorized URL if there is one
				// If no unauthorized URL is specified, just return an
				// unauthorized
				// HTTP status code
				String unauthorizedUrl = getUnauthorizedUrl();
				// SHIRO-142 - ensure that redirect _or_ error code occurs -
				// both
				// cannot happen due to response commit:
				if (StringUtils.hasText(unauthorizedUrl)) {
					WebUtils.issueRedirect(request, response, unauthorizedUrl);
				} else {
					WebUtils.toHttp(response).sendError(HttpServletResponse.SC_UNAUTHORIZED);
				}
			}
		}
		return false;
	}

	public boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue)
			throws IOException {

		Subject subject = getSubject(request, response);
		String[] perms = (String[]) mappedValue;
		boolean isPermitted = false;
		if (perms != null && perms.length > 0) {
			try {
				if (perms.length == 1) {
					if (!subject.isPermitted(perms[0])) {
						isPermitted = false;
					} else {
						isPermitted = true;
					}
				} else {
					if (!subject.isPermittedAll(perms)) {
						isPermitted = false;
					} else {
						isPermitted = true;
					}
				}
			} catch (Exception e) {
				isPermitted = false;
			}
		} else {
			isPermitted = true;
		}

		if (!isPermitted) {
			HttpServletRequest httpRequest = WebUtils.toHttp(request);
			if (TypeUtils.isAjax(httpRequest)) {// Ajax请求

				HttpServletResponse httpServletResponse = WebUtils.toHttp(response);
				httpServletResponse.setCharacterEncoding("UTF-8");
				PrintWriter out = httpServletResponse.getWriter();
				if (TypeUtils.isGet(httpRequest)) {
					out.println("<script>$.messager.alert('', '您没有权限进行操作！', 'warning');</script>");
				} else {
					out.println("您没有权限进行操作！");
				}
				out.flush();
				out.close();
			}
		}
		return isPermitted;
	}
}
