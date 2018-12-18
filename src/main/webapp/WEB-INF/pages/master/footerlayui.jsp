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
<style>
    .layui-layout-admin .layui-footer {
        text-align: center;
        background-color: #F0F2F5;
        color: #848587;
    }
</style>
<div>
<div class="layui-footer">
    <!-- 底部固定区域 -->
    金茂图文直播管理系统
</div>
</div>
</div>
<script>
    $(function () {
        var href = window.location.href;
        // if (href.indexOf("?") != -1 && href.indexOf("applive/list?cata")==-1) {
        //     href = href.substring(0, href.indexOf("?"));
        // }
        $("[href='" + href + "']").addClass("layui-this");
        $("[href='" + href + "']").parent().parent().parent().addClass("layui-nav-itemed").siblings().removeClass("layui-nav-itemed");
    });
</script>
</body>
</html>