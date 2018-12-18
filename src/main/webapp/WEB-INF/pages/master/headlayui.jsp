<%--
  Created: 方磊
  Date: 2018年3月16日  下午2:57:26
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName()+ ":"+ request.getServerPort()
            + path + "/";
//
%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="renderer" content="webkit"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="金茂图文直播">
    <meta name="author" content="fl">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="金茂图文直播,江苏金茂图文,江苏金茂图文直播,江苏金茂图文直播系统">
    <link rel="shortcut icon" href="<%=basePath%>images/index_PC_01.png">
    <title>金茂图文直播</title>
    <link rel="stylesheet" href="<%=basePath%>js/layui/css/layui.css"/>
    <script src="<%=basePath%>js/jquery-1.12.4.js"></script>
    <script src="<%=basePath%>js/layui/layui.js"></script>
    <style>
        .layui-body{
            background-color: #eee;
        }
        .layui-card{
            margin: 15px 15px;
        }
        .layui-card-header{
            border-left: 5px solid #108cee;
        }
        .layui-card-header h2{
            border-bottom: none;
            color: #333;
            font-size: 16px;
            background-color: transparent;

        }
        .layui-card-body{
            color: #666;
        }
        input, textarea, select, button{
            color: #666;
        }
        .layui-input {
            height: 30px;
        }
        .layui-side-scroll
        {
            background-color: #23262E;
        }
        .layui-layout-admin .layui-header{
            background-color: #fff;
        }
/*菜单颜色设置*/
        .layui-nav-tree .layui-nav-bar {
            background-color: #1E9FFF;
        }
        .layui-nav-tree .layui-nav-child dd.layui-this, .layui-nav-tree .layui-nav-child dd.layui-this a, .layui-nav-tree .layui-this, .layui-nav-tree .layui-this>a, .layui-nav-tree .layui-this>a:hover{
            background-color: #1E9FFF;
        }
        .layui-laypage .layui-laypage-curr .layui-laypage-em {
            background-color: #1E9FFF;
        }
        .layui-layout-admin .layui-side {
            top: 0px;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <div class="layui-header" style="margin-left: 200px;">
        <ul class="layui-nav layui-layout-right" >
            <li class="layui-nav-item">
                <a href="javascript:;" style="color: #393D49;">
                    欢迎您，${sessionScope.displayname}
                </a>
            </li>
            <li class="layui-nav-item"><a href="<%=basePath%>/manager/exit"  style="color: #393D49;">退出</a></li>
        </ul>
    </div>
    <div class="layui-side">
        <div class="layui-side-scroll">
            <div style="background-color:#393D49;color: #fff;font-weight: 300;font-size: 16px;line-height: 60px;width:200px;text-align: center;"><img src="<%=basePath%>images/index_PC_01.png" style="width:30px;height: 30px;">&nbsp;&nbsp;&nbsp;金茂图文直播</div>
            <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
            <ul id="ulcd" class="layui-nav layui-nav-tree">

                <c:forEach items="${sessionScope.menu}" var="item" varStatus="status">
                    <c:if test="${item.cata=='1'}">
                        <c:choose>
                            <c:when test="${sessionScope.usercata!='0'}">

                                <c:if test="${item.menucode=='005' || item.menucode=='007'}">
                                    <li class="layui-nav-item  layui-nav-itemed">
                                        <a href="javascript:;"><i
                                                class="layui-icon ${item.iconname}"></i>&nbsp;&nbsp;${item.menuname}</a>
                                        <dl class="layui-nav-child">
                                            <c:forEach items="${sessionScope.menu}" var="itemc">
                                                <c:if test="${itemc.parentcode==item.menucode}">
                                                    <dd>
                                                        <a style="padding-left:40px;"
                                                           href="<%=basePath%>${itemc.url}">${itemc.menuname}</a>
                                                    </dd>
                                                </c:if>
                                            </c:forEach>
                                        </dl>
                                    </li>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <li class="layui-nav-item  layui-nav-itemed">
                                    <a href="javascript:;"><i
                                            class="layui-icon ${item.iconname}"></i>&nbsp;&nbsp;${item.menuname}</a>
                                    <dl class="layui-nav-child">
                                        <c:forEach items="${sessionScope.menu}" var="itemc">
                                            <c:if test="${itemc.parentcode==item.menucode}">
                                                <dd>
                                                    <a style="padding-left:40px;"
                                                       href="<%=basePath%>${itemc.url}">${itemc.menuname}</a>
                                                </dd>
                                            </c:if>
                                        </c:forEach>
                                    </dl>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </c:forEach>
            </ul>
        </div>
    </div>