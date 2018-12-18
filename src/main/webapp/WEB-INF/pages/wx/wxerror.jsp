<%--
  User: fanglei
  Date: 2018-07-03
  Time: 15:01
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<html>
<head>
    <title>系统错误</title>
</head>
<body>
微信接口错误导致获取openid获取失败
</body>
</html>
