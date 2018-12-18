<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<script>
location.href="<%=basePath%>manager/login";
</script>
<div>
登录失效，请<a href='<%=basePath %>manager/login'>重新登录</a>
</div>