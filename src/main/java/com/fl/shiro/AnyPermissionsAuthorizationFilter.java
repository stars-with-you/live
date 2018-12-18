/*
  Created: 方磊
  Date: 2017年8月23日  上午11:29:39

*/
package com.fl.shiro;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authz.AuthorizationFilter;

public class AnyPermissionsAuthorizationFilter extends AuthorizationFilter {

	@Override
	protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue)
			throws Exception {
		Subject subject = getSubject(request, response);
		String[] perms = (String[]) mappedValue;

		for (String perm : perms) {
			if (subject.isPermitted(perm)) {
				return true;
			}
		}

		return false;
	}

}