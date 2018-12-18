<%--
  Created: 方磊
  Date: 2018年3月16日  下午2:57:26
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<jsp:include page="/WEB-INF/pages/master/headlayui.jsp"></jsp:include>
<div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;"></div>
</div>
<script>
    layui.use(['element'], function () {
        var element = layui.element;
    });
</script>
<jsp:include page="/WEB-INF/pages/master/footerlayui.jsp"></jsp:include>