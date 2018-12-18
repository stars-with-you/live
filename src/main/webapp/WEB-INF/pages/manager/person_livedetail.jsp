<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %><%--
  User: fanglei
  Date: 2018-04-20
  Time: 15:41
--%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName()
            + ":" + request.getServerPort()
            + path + "/";
    String baseMyPath = request.getScheme() + "://"
            + request.getServerName()
            + path;
    Calendar calendar = Calendar.getInstance();
    calendar.setTime(new Date());
    calendar.add(Calendar.DAY_OF_MONTH, -1);//+1今天的时间加一天
    Date mydate=calendar.getTime();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>${model.title}<c:set var="now" value="<%=mydate%>" />
        <c:if test="${model.enddate<now}">回顾</c:if>
        <c:if test="${model.startdate>now}">还未开始</c:if>
        <c:if test="${model.enddate>now && model.startdate<now}">直播中</c:if></title>
    <meta charset="utf-8"/>
    <link rel="shortcut icon" href="<%=basePath%>images/index_PC_01.png">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta name="viewport"
          content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black"/>
    <meta name="format-detection" content="telephone=no"/>
    <!-- iOS 图标 begin -->
    <link rel="apple-touch-icon-precomposed" href="/apple-touch-icon-57x57-precomposed.png"/>
    <!-- iPhone 和 iTouch，默认 57x57 像素，必须有 -->
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/apple-touch-icon-114x114-precomposed.png"/>
    <!-- Retina iPhone 和 Retina iTouch，114x114 像素，可以没有，但推荐有 -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/apple-touch-icon-144x144-precomposed.png"/>
    <!-- Retina iPad，144x144 像素，可以没有，但推荐有 -->
    <!-- iOS 图标 end -->
    <link rel="stylesheet" href="<%=basePath%>js/layui/css/layui.css"/>
    <link rel="stylesheet" href="<%=basePath%>js/simditor/styles/simditor.css"/>
    <script src="<%=basePath%>js/jquery-1.12.4.js"></script>
    <script src="<%=basePath%>js/layui/layui.js"></script>
    <script>
        function GetQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]);
            return null;
        }

        var openid = GetQueryString("openid");
    </script>
    <link href="<%=basePath%>images/layout.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="<%=basePath%>js/jquery-weui/lib/weui.min.css">
    <link rel="stylesheet" href="<%=basePath%>js/jquery-weui/css/jquery-weui.min.css">
    <link rel="stylesheet" href="<%=basePath%>js/tdrag/jquery.gridly.css">
    <style>
        body {
            background: #fff;
        }

        .tab_bar {
            height: 44px;
            border-bottom: 1px solid #edeef2;
            display: -webkit-box;
            display: -webkit-flex;
            display: flex;
            background: #fff;
            flex-flow: row wrap;
            justify-content: flex-start;
            position: absolute;
            left: 0;
        }

        .tab {
            height: 100%;
            width: 100%;
            flex: 1;
            line-height: 44px;
            font-size: 1.3em;
            color: #333;
            position: relative;
        }

        .tab span {
            display: block;
            /*margin: 0px 35px;*/
            height: 41px;
            font-size: 16px;
        }

        .case-intruduct dl {
            min-height: 20px;
            height: auto;
            background: #fff;
            border: 1px solid #edeef2;
            margin: 0;
            padding: 10px 10px;
            line-height: 20px;
        }

        .cnum {
            position: absolute;
            top: 5px;
            height: 16px;
            right: 0;
        }

        .vux-badge {
            display: inline-block;
            text-align: center;
            background: #f74c31;
            color: #fff;
            font-size: 12px;
            height: 16px;
            line-height: 16px;
            border-radius: 8px;
            padding: 0 6px;
            background-clip: padding-box;
            vertical-align: middle;
        }

        .ewm {
            padding: 30px 0px;
        }

        .ewm img {
            margin: 0px 20px;
        }

        /*直播详情样式*/
        .bq {
            width: 90%;
            border-left: 1px solid #CCC;
            margin-left: 20px;
            padding-bottom: 0px;
            padding-left: 20px;
            text-align: left;
            margin-top: 2px;
        }

        .zhibo-live-box2 {
            width: 90%;
            border-left: 1px solid #CCC;
            margin-left: 20px;
            padding-bottom: 0px;
            padding-left: 20px;
        }

        .zhibo-live-box2:before {
            content: "";
            position: relative;
            display: block;
            opacity: 1;
            -ms-transform: translateX(-26px);
            transform: translateX(-26px);
            top: 13px;
            width: 0;
            height: 0;
            border: 5px solid #ff8a00;
            border-radius: 10px;
        }

        .zhibo-live-box2 p:first-child {
            margin: 0px;
            color: #ff8a00;
        }

        .zhibo-live-box2 p:last-child {
            margin: 0px;
            font-size: 16px;
            color: #000;
        }

        .img-box {
            flex-wrap: wrap;
            justify-content: space-between;
            margin: 5px 5px 0px 0px;
            width: 130px;
            height: 100px;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            display: inline-block;
            border: none;
        }

        .imgdetailcz {
            float: right;
            cursor: pointer;
        }

        /*直播详情样式结束*/

        .liuyan {
            margin-left: 20px;
        }

        .liuyan-list {
            padding-bottom: 0px;
            padding-top: 0px;
        }

        .liuyan-list p b {
            color: #999
        }

        .liuyan-list:before {
            content: "";
            position: relative;
            display: block;
            opacity: 1;
            -ms-transform: translateX(-15px);
            transform: translateX(-15px);
            top: 18px;
            width: 0;
            height: 0;
            border: 5px solid #ff8a00;
            border-radius: 10px;
        }

        .bottomctl {
            position: fixed;
            height: 50px;
            bottom: 30px;
            right: 50%;
            margin-right: -200px;
            z-index: 1;
            display: -webkit-box;
            display: -webkit-flex;
            display: flex;
            -webkit-box-align: center;
            -webkit-align-items: center;
            align-items: center;
        }

        .bottomctl .comment {
            background-color: rgba(0, 0, 0, .5);
        }

        .bottomctl .tool {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            margin-right: 20px;
            color: #fff;
            text-align: center;
            line-height: 50px;
        }

        .bottomctl .zan {
            background-color: rgba(0, 0, 0, .5);
            -webkit-transition: all .2s cubic-bezier(.03, .6, .81, 1.57);
            transition: all .2s cubic-bezier(.03, .6, .81, 1.57);
            -webkit-transform-origin: 50% 50%;
            transform-origin: 50% 50%;
            color: #f6423e;
        }

        .iconfont img {
            margin-top: 10px;
        }

        .liuyan-float {
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, .5);
            opacity: 1;
            position: absolute;
            top: 0px;
            left: 0;
            z-index: 99;
            display: none;
        }

        .liuyan-nr {
            width: 100%;
            min-height: 100px;
            text-align: center;
            position: fixed;
            bottom: 0px;
            z-index: 999;
            background: #fff;
            opacity: 1;
            padding: 30px 0px;
            display: none;
        }

        .liuyan-nr input {
            width: 80%;
            padding: 0px 5px;
            height: 30px;
            background: #f3f3f3;
            border: none;
            border-radius: 5px;
            color: #999;
            margin-bottom: 20px;
        }

        .liuyan-nr textarea {
            width: 80%;
            min-height: 60px;
            height: auto;
            line-height: 20px;
            padding: 5px;
            background: #f3f3f3;
            border: none;
            border-radius: 5px;
            color: #999;
        }

        .tab-current {
            border-bottom: 3px solid #ff8a00;
        }

        .dzly {
            position: absolute;
            top: 290px;
            left: 20px;
            color: #fff;
            font-size: 14px;
            z-index: 9;
            text-shadow: 1px 2px 2px #666666;
        }

        .dianzanshu, .liuyanshu, .liulanshu {
            float: left;
            margin-left: 15px;
        }

        .liuyanshu a {
            float: left;
            color: #fff;
        }

        .dow-btn {
            width: 96%;
            margin: 0 auto;
            flex-wrap: wrap;
            justify-content: space-between;
        }

        .dow-btn div {
            width: 100px;
            height: 30px;
        }

        /*---2018.6.15----*/
        .admin-img {
            width: 24px;
            height: 24px;
            float: left;
        }

        .admin-img img {
            width: 24px;
            height: 24px;
            display: block;
            border-radius: 50%;
        }

        .ly {
            float: left;
            width: 88%;
            text-align: left
        }

        .liuyan {
            margin-left: 20px;
            font-size: .9em;
            color: #999;
            line-height: 2;
        }

        .liuyan-list:before {
            content: "";
            position: relative;
            display: block;
            opacity: 1;
            -ms-transform: translateX(-15px);
            transform: translateX(-15px);
            top: 18px;
            width: 0;
            height: 0;
            border: 5px solid #ff8a00;
            border-radius: 10px;
        }

        .ly-hf {
            border-bottom: 1px solid #DADADA;
        }

        .liuyan-list p span {
            margin-left: 0px;
        }

        .huifu-nr {
            margin-left: 25px;
            padding: 10px;
            text-align: left;
        }

        .huifu-nr p {
            padding: 3px 0px;
        }

        .huifu-nr span {
            color: #F63;
            padding-right: 5px;
        }

        .spcmttime {
            font-size: .8em;
            float: left;
        }

        .myp {
            text-align: right;
        }

        .imgcz {
            margin-bottom: -3px;
        }

        .zantext {
            padding-left: 2px;
        }

        .zansx {
            padding: 5px;
        }

        /*星星点赞*/
        canvas {
            display: block;
            position: absolute;
            bottom: 50px;
            right: 50%;
            margin-right: -350px;
            z-index: -1;
            cursor: pointer;
            -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
        }

        .journal-reward {
        }

        /**
        图片查看器设置
         */
        .weui-photo-browser-modal .photo-container img {
            max-width: 100%;
            margin-top: 0;
            max-height: 100%;
        }

        .weui-photo-browser-modal {
            z-index: 1000;
        }

        .photo-container img {
            margin: 0 auto;
        }

        .weui-cells {
            font-size: 14px;
        }

        .weui-swiped-btn {
            display: flex;
            align-items: center;
            justify-content: space-between;
            border: none;
        }

        .delweui {
            width: 20px;
            height: 20px;
            float: right;
            cursor: pointer;
        }

        .spqd {
            padding: 3px;
            border: 1px solid #999;
            border-radius: 3px 4px;
            font-size: 10px;
            cursor: pointer;
            display: inline-block;
            margin-right: 4px;
        }

        .spadd {
            color: #fff;
            background-color: #1aad19;
        }

        .sprm {
            color: #000;
            background-color: #fff;
        }
    </style>
    <style>
        .layui-body {
            background-color: #eee;
        }

        .layui-card {
            margin: 15px 15px;
        }

        .layui-card-header {
            border-left: 5px solid #108cee;
        }

        .layui-card-header h2 {
            border-bottom: none;
            color: #333;
            font-size: 16px;
            background-color: transparent;

        }

        .layui-card-body {
            color: #666;
        }

        input, textarea, select, button {
            color: #666;
        }

        .layui-input {
            height: 30px;
        }

        .layui-side-scroll {
            background-color: #23262E;
        }

        .layui-layout-admin .layui-header {
            background-color: #fff;
        }

        /*菜单颜色设置*/
        .layui-nav-tree .layui-nav-bar {
            background-color: #1E9FFF;
        }

        .layui-nav-tree .layui-nav-child dd.layui-this, .layui-nav-tree .layui-nav-child dd.layui-this a, .layui-nav-tree .layui-this, .layui-nav-tree .layui-this > a, .layui-nav-tree .layui-this > a:hover {
            background-color: #1E9FFF;
        }

        .layui-laypage .layui-laypage-curr .layui-laypage-em {
            background-color: #1E9FFF;
        }

    </style>
    <style>
        .layui-layout-admin .layui-side {
            top: 0px;
        }

        .weui-popup__container, .weui-popup__overlay {

            z-index: 1000;
        }

        .weui-popup__modal {
            z-index: 1001;
        }

        .weui-picker-overlay, .weui-picker-container {
            z-index: 1002;
        }

        .layui-layout-left {
            left: 0px;
        }

        .simditor {
            height: 200px;
        }

        .simditor .simditor-body, .editor-style {
            font-size: 14px;
        }

        .simditor .simditor-body {
            max-height: 180px;
            overflow: auto;
            padding: 0 15px;
        }

        .simditor .simditor-body {
            min-height: 50px;
        }
        .simditor .simditor-body p, .simditor .simditor-body div, .editor-style p, .editor-style div
       {
            margin: 0;
        }
        .simditor .simditor-wrapper .simditor-placeholder{
            padding: 0 15px;
        }
        .mygz {
            float: right;
            color: #ff8a00;
            text-shadow: 1px 2px 2px #e5e1ea;
            cursor: pointer;
        }

        .weui-loadmore {
            width: 95%;
        }
        .solid {
            position: fixed;
            top: 0;
            z-index: 88;
            width:420px;
            background-color: #eee;
            -webkit-box-shadow: 0 5px 5px rgba(0, 0, 0, 0.1);
            shadow: 0 5px 5px rgba(0, 0, 0, 0.1);
            -webkit-transition: all 0.25s ease-in-out;
            -moz-transition: all 0.25s ease-in-out;
            -o-transition: all 0.25s ease-in-out;
        }
        .weui-uploader__file{
            /*float: left;*/
            position: absolute;
        }
    </style>
</head>

<body>
<div class="layui-layout-body">
    <div class="layui-layout layui-layout-admin">
        <div class="layui-header" style="margin-left: 200px;">
            <%--<ul class="layui-nav layui-layout-left">--%>
            <%--<li class="layui-nav-item layadmin-flexible" lay-unselect="">--%>
            <%--<a href="javascript:;" title="侧边伸缩" style="color: #393D49;">--%>
            <%--<i class="layui-icon layui-icon-shrink-right" id="LAY_app_flexible"></i>--%>
            <%--</a>--%>
            <%--</li>--%>
            <%--</ul>--%>
            <ul class="layui-nav layui-layout-right">
                <li class="layui-nav-item">
                    <a href="javascript:;" style="color: #393D49;">
                        欢迎您，${sessionScope.displayname}
                    </a>
                </li>
                <li class="layui-nav-item"><a href="<%=basePath%>/manager/exit" style="color: #393D49;">退出</a></li>
            </ul>
        </div>
        <div id="divside" class="layui-side">
            <div class="layui-side-scroll">
                <div style="background-color:#393D49;color: #fff;font-weight: 300;font-size: 16px;line-height: 60px;width:200px;text-align: center;">
                    <img src="<%=basePath%>images/index_PC_01.png" style="width:30px;height: 30px;">&nbsp;&nbsp;&nbsp;金茂图文直播
                </div>
                <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
                <ul id="ulcd" class="layui-nav layui-nav-tree">

                    <c:forEach items="${sessionScope.menu}" var="item" varStatus="status">
                        <c:if test="${item.cata=='1'}">
                            <c:choose>
                                <c:when test="${sessionScope.usercata!='0'}">

                                    <c:if test="${item.menucode=='005' || item.menucode=='007'}">
                                        <li class="layui-nav-item  layui-nav-itemed">
                                            <a href="javascript:;"><i
                                                    class="layui-icon ${item.iconname}"></i>&nbsp;&nbsp;${item.menuname}
                                            </a>
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
    </div>
</div>
<div class="zhibo" style="width:480px; border:none;position: absolute;left: 50%;margin-left: -250px;height:99%;">
    <div class="zhibo-content-img" style="height:320px; width:100%;">
        <div class="dzly">
            <div class="liulanshu">
                ${model.access}人浏览
            </div>
            <div class="dianzanshu">
                <span id="spzanct">${model.zan}</span>点赞
            </div>
            <%--<div class="liuyanshu">--%>
            <%--<span>0</span>条留言--%>
            <%--</div>--%>
        </div>
        <div id="mygz" class="dzly" style="right: 20px;">
            <c:if test="${isgz=='1'}">
                <div class="mygz" onclick="qxgzlive();">-已关注</div>
            </c:if>
            <c:if test="${isgz=='0'}">
                <div class="mygz"
                     onclick="gzlive();">
                    +关注
                </div>
            </c:if>
        </div>
        <div id="myswiper" class="swiper-container">
            <div class="swiper-wrapper" id="mylogo">
            </div>
            <div class="swiper-pagination"></div>
        </div>
    </div>
    <div style="width:100%; height:45px; position:relative; overflow:hidden">
        <div class="tab_bar">
            <div id="tab1" class="tab">
                <span>简介</span>
            </div>
            <div id="tab2" class="tab">
                <span>直播</span>
            </div>

            <div id="tab4" class="tab">
                <c:if test="${model.qjurl!=null && model.qjurl!=''}">
                    <a href="${model.qjurl}" target="_blank">
                        <span>全景</span>
                    </a>
                </c:if>
                <c:if test="${model.qjurl==null || model.qjurl==''}">
                    <span>全景</span>
                </c:if>
            </div>
            <div id="tab3" class="tab">
                <span>留言</span>
                <span id="spcmtct" class="cnum vux-badge" style="height:16px;display: none;"></span>
            </div>
        </div>
    </div>
    <div>
        <div class="tab_css" style="display: block;">
            <div class="case-intruduct" style="margin: 0;border-top: none;">
                <dl>
                    <dd>
                        <strong>主办方</strong>
                    </dd>
                    <dt>
                        <p>${model.sponsor}</p>
                    </dt>
                </dl>
                <dl>
                    <dd>
                        <strong>承办方</strong>
                    </dd>
                    <dt>
                        <p>${model.cbf}</p>
                    </dt>
                </dl>
                <dl>
                    <dd>
                        <strong>支持单位</strong>
                    </dd>
                    <dt>
                        <p>${model.zcdw}</p>
                    </dt>
                </dl>
                <dl>
                    <dd>
                        <strong>时间
                        </strong>
                    </dd>
                    <dt>
                        <p>
                            <fmt:formatDate value="${model.startdate}"    pattern="yyyy-MM-dd HH:mm"/>
                            ~
                            <fmt:formatDate  value="${model.enddate}"  pattern="yyyy-MM-dd HH:mm" />
                        </p>
                    </dt>
                </dl>
                <dl>
                    <dd>
                        <strong>地点</strong>
                    </dd>
                    <dt>
                        <p>${model.place}</p>
                    </dt>
                </dl>
                <dl>
                    <dd>
                        <strong>简介</strong>
                    </dd>
                    <dt>
                        <p>${model.intro}</p>
                        <%--style="color:#1c487f"--%>
                    </dt>
                </dl>
                <dl>
                    <dd>
                        <strong>全景</strong>
                    </dd>
                    <dt style="text-align: center;">
                        <c:if test="${model.zbewm!=null && model.zbewm!=''}">
                            <a href="${model.qjurl}" target="_blank">
                                <img style="max-width:400px;" src="<%=basePath%>${model.zbewm}">
                            </a>
                        </c:if>
                    </dt>
                </dl>
                <%--<dl>--%>
                <%--<dd>--%>
                <%--<strong></strong>--%>
                <%--</dd>--%>
                <%--<dt style="text-align: center;">--%>
                <%--<c:if test="${model.ewm!=null && model.ewm!=''}">--%>
                <%--<img style="width:139px;height:139px;" src="<%=basePath%>${model.ewm}">--%>
                <%--</c:if>--%>
                <%--</dt>--%>
                <%--</dl>--%>
            </div>
        </div>
        <div class="tab_css" style="display: none">
            <div id="divbq" class="bq">

            </div>
            <div id="divdet">

            </div>
            <div id="divnodata2" class="weui-loadmore weui-loadmore_line">
                <span class="weui-loadmore__tips">暂无数据</span>
            </div>
        </div>

        <div class="tab_css" style="display: none">
            <div class="weui-loadmore weui-loadmore_line">
                <span class="weui-loadmore__tips">暂无数据</span>
            </div>
        </div>
        <div class="tab_css" style="display: none">
            <div class="liuyan"
                 style="margin-left:20px; padding-left:10px; padding-right:20px;border-left: 1px solid #CCC; ">
                <div id="divcomment">

                </div>
            </div>
            <div id="divnodata" class="weui-loadmore weui-loadmore_line">
                <span class="weui-loadmore__tips">暂无数据</span>
            </div>
        </div>
    </div>

</div>
<div class="zhibo-bottom" style="background: #fff;display: none;">
    <p id="copyright" style="text-align:center; font-size:14px;"> 江苏金茂直播平台</p>
</div>
<div class="bottomctl">
    <c:if test="${bz=='1'}">
        <div class="tool comment" style="margin: 0;margin-right: 5px;" onclick="detailadd('');">
            <i class="iconfont "><img src="<%=basePath%>images/fb.png"/></i>
        </div>
    </c:if>
    <c:if test="${model.iscomment=='1'}">
        <div class="tool comment" style="margin: 0;margin-right: 5px;" onclick="cmtadd('');">
            <i class="iconfont "><img src="<%=basePath%>images/liuyan.png"/></i>
        </div>
    </c:if>
    <div class="tool comment" style="margin: 0;margin-right: 15px;" onclick="livezan('${model.lguid}')">
        <i class="iconfont "><img src="<%=basePath%>images/star00.png" class="journal-reward"/> </i>
    </div>
</div>

<script src="<%=basePath%>js/jquery-weui/lib/fastclick.js"></script>
<script>
    $(function () {
        FastClick.attach(document.body);
    });
</script>
<script src="<%=basePath%>js/jquery-weui/js/jquery-weui.js"></script>
<script src="<%=basePath%>js/jquery-weui/js/swiper.min.js"></script>
<script src="<%=basePath%>js/jquery.form.js"></script>
<script src="<%=basePath%>js/flutter-hearts-zmt.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=basePath%>js/pj/live_detail.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=basePath%>js/pj/live_cmt.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=basePath%>js/simditor/scripts/module.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=basePath%>js/simditor/scripts/hotkeys.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=basePath%>js/simditor/scripts/simditor.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=basePath%>js/tdrag/jquery.gridly.js"></script>
<script type="text/javascript">
    layui.use(['table', 'layer', 'laydate', 'element', 'form'], function () {
        var table = layui.table, laydate = layui.laydate, element = layui.element;
    });
    var index = 1;
    var editor = null;
    // 图片地址在此处更换  可换成你的图片
    var assets = [
        '<%=basePath%>images/star01.png',
        '<%=basePath%>images/star02.png',
        '<%=basePath%>images/star03.png',
        '<%=basePath%>images/star04.png',
        '<%=basePath%>images/star05.png',
    ];
    $(function () {
        n = $('.tab_bar div').size();
        var wh = 100 / 4 * n + "%";
        $('.tab_bar').width(wh);
        var lt = (100 / n);
        var lt_li = lt + "%";
        $('.tab_bar div').width(lt_li);
        $(".tab").click(function () {
            index = $(this).index();
            //$(".tab span").eq(index).addClass("tab-current").parent().siblings().find("span").removeClass("tab-current");
            $(this).find("span:first").addClass("tab-current");
            $(this).siblings().find("span").removeClass("tab-current");
            $(".tab_css").eq(index).css("display", "block").siblings().css("display", "none");
            if (index == 1) {
                $(".spqd").removeClass("spadd").addClass("sprm");
                showbq($("#hidlguid").val());
                reloadsj("1", 1, '');
                //一分钟刷新一次
                //myinterval = setInterval("reloadsj('1', 1,'');", 10000);
            }
            else {
                if (index == 3) {
                    reloaddata("1", 1, "");
                }
                if (myinterval != null) {
                    window.clearInterval(myinterval);
                }
            }
        });
        $("#tab2").click();
    });
</script>

<script>
    function getlogo(lguid) {
        $.post("<%=basePath%>livelogo/data", {"lguid": lguid}, function (data, status) {
            if (status == "success") {
                if (data != "") {
                    var json = $.parseJSON(data);
                    if (json.length > 0) {
                        $("#mylogo").html("");
                        var str = "";
                        for (var i = 0; i < json.length; i++) {
                            str += '<div class="swiper-slide"><img  style="height:320px;"  src="<%=basePath%>' + json[i].defaultpic + '"/></div>';
                        }
                        $("#mylogo").html(str);
                        if (json.length > 1) {
                            var myswiper = new Swiper('#myswiper', {
                                pagination: '.swiper-pagination',
                            });
                        }
                    }
                    else {
                        $("#mylogo").html('<div class="swiper-slide"><img src="<%=basePath%>upload/defaultpic/default.png"/></div>');
                    }
                }
            }
        });
    }

    getlogo("${lguid}");
</script>
<script>
    var filearr = "", isxg = '0', myfj="";
    //拖动前回调
    var reordering =function($elements){
// Called before the drag and drop starts with the elements in their starting position.
//alert('start');
    };

    //拖动后回调
    var reordered =function($elements){
// Called after the drag and drop ends with the elements in their ending position.
// 当前对象
        myfj="";
        var arr = $elements;
        for (var i = 0; i <arr.length ; i++) {
            myfj+= $(arr[i]).attr("aguid")+";"+(i+1)+",";
        }
    };

    $(function () {
        editor = new Simditor({
            textarea: $('#txtdescription'),
            toolbar: ['bold', 'italic', 'underline', 'fontScale', 'color', 'link'], //工具条都包含哪些内容
            //optional options
        });
        $(".simditor-body").css("cursor", "pointer");
        var posturl = "";
        $("#afb").click(function () {
            $.confirm("确定发布吗", function () {
                if ($("#hidlguid").val() == "") {
                    $.toast("没有从直播进入发布页面，不能进行直播", "cancel");
                    return;
                }
                if ($("#hiddguid").val() != "") {
                    posturl = "<%=basePath%>applive/detail/wxupdatestart";
                }
                else {
                    posturl = "<%=basePath%>applive/detail/wxaddstart";
                }
                var e = $("#tbodypreview li");
                var dguid = $("#hiddguid").val();
                filearr = "";
                if (e.length > 0 && $("#hiddguid").val() == "") {
                    dguid = $(e[0]).attr("dguid");
                }
                var updatetime = $("#txtupdatetime").val();
                //点击确认后的回调函数
                $.ajax({
                    url: posturl,
                    type: "post",
                    data: {
                        "lguid": $("#hidlguid").val(),
                        "dguid": dguid,
                        "description": $("#txtdescription").val(),
                        "mybq": $("#txtbq").val(),
                        "mybguid": $("#txtbq").attr("data-values"),
                        "isfb": $(":radio[name='isfb']:checked").val(),
                        "iszd": $(":radio[name='iszd']:checked").val(),
                        "updatetime": updatetime,
                        "filestr": filearr,
                        "myfj":myfj
                    },
                    dataType: "text",
                    success: function (data) {
                        if (data == "1") {
                            $.toast("发布成功");
                            $.closePopup();
                            loadbzdata();
                        }
                        else {
                            $.toast(data, "cancel");
                        }
                    }
                });
            }, function () {
                //点击取消后的回调函数
            });
        });
    });

    /**
     * 加载直播详情数据
     */
    function reloadsj(bz, crp, bq) {
        var bz = "${bz}";
        var isfb = "";
        if (bz != "1") {
            isfb = "1";
        }
        var ps = 1000;
        //向服务端发送删除指令
        $.ajax({
            url: "<%=basePath%>applive/detail/datafile",
            type: "post",
            data: {"lguid": $("#hidlguid").val(), "currentPage": crp, "pagesize": ps, "isfb": isfb, "bq": bq},
            dataType: "text",
            success: function (data) {
                if (data != "") {
                    var json = $.parseJSON(data);
                    var data = json.data;
                    if (data.length > 0) {
                        $("#divnodata2").hide();
                        var str = "";
                        for (var i = 0; i < data.length; i++) {
                            str += "<div class='zhibo-live-box2'>";
                            str += "<div class='weui-cell weui-cell_swiped'>";
                            str += "<div class='weui-cell__bd' >";
                            str += "<p>";
                            str += new Date(data[i].updatetime.replace(/-/g, "/")).Format("yyyy-MM-dd hh:mm");
                            if (bz == "1") {
                                if (data[i].isfb != "1") {
                                    str += "(<span style='color:#FF0000;'>未发布</span>)";
                                }
                            }
                            str += "</p>";
                            str += "<p style='color:#999;font-size: 14px;'>";
                            str += data[i].description;
                            str += "</p>";

                            str += "</div>";
                            if (bz == "1") {
                                str += "<div class='weui-cell__ft' >";
                                str += "<a  class='weui-swiped-btn weui-swiped-btn_warn delete-swipeout'  href='javascript:' onclick='detaildel(this,\"" + data[i].dguid + "\")'>删除</a>";
                                str += "<a class='weui-swiped-btn weui-swiped-btn_default close-swipeout' href='javascript:' onclick='detailupdate(this,\"" + data[i].dguid + "\")'>编辑</a>";
                                str += "</div>";
                            }
                            str += "</div>";

                            str += "<div>";
                            if (data[i].pguid != "") {
                                var imgstr = data[i].pguid;
                                imgstr = imgstr.substring(0, imgstr.length - 1);

                                var imgjson = imgstr.split(";");
                                var imglen = imgjson.length;
                                var lenbz = imglen;
                                var varr = new Array();
                                var picarr = new Array();
                                for (var j = 0; j < imglen; j++) {
                                    var imgpath = imgjson[j].split(",");
                                    if (isvideo(imgpath[0])) {
                                        lenbz = lenbz - 1;
                                        varr.push(imgpath[0]);
                                        picarr.push(imgpath[1]);
                                    }
                                }
                                for (var t = 0; t < varr.length; t++) {
                                    str += '<video   poster="<%=basePath%>' + picarr[t] + '"  width="410" style="max-height:400px;"    src="<%=basePath%>' + varr[t] + '" controls></video>';
                                }
                                for (var j = 0; j < imglen; j++) {
                                    var imgpath = imgjson[j].split(",");
                                    if (!isvideo(imgpath[0])) {
                                        switch (lenbz) {
                                            case 1:
                                                //str += "<img style='width:410px;height:300px;margin:0;' class='img-box' d='<%=basePath%>" + imgpath[0] + "'  src='<%=basePath%>" + imgpath[1] + "' onclick='imageLook(this," + j.toString() + ")'/>";
                                                str += "<figure style='width:410px;height:300px;background-image: url(\"<%=basePath%>" + imgpath[1] + "\");' class='img-box' d='<%=basePath%>" + imgpath[0] + "'  onclick='imageLook(this," + j.toString() + ")'/>";
                                                break;
                                            case 2:
                                                //str += "<img style='width:200px;height:150px;' class='img-box' d='<%=basePath%>" + imgpath[0] + "'  src='<%=basePath%>" + imgpath[1] + "' onclick='imageLook(this," + j.toString() + ")'/>";
                                                str += "<figure style='width:200px;height:150px;background-image: url(\"<%=basePath%>" + imgpath[1] + "\");' class='img-box' d='<%=basePath%>" + imgpath[0] + "'  onclick='imageLook(this," + j.toString() + ")'/>";
                                                break;
                                            default:
                                                //str += "<img class='img-box' d='<%=basePath%>" + imgpath[0] + "'  src='<%=basePath%>" + imgpath[1] + "' onclick='imageLook(this," + j.toString() + ")'/>";
                                                str += "<figure style='background-image: url(\"<%=basePath%>" + imgpath[1] + "\");' class='img-box' d='<%=basePath%>" + imgpath[0] + "'   onclick='imageLook(this," + j.toString() + ")'/>";
                                                break;
                                        }
                                    }
                                }
                            }
                            if (i == data.length - 1) {
                                str += '<div class="weui-loadmore weui-loadmore_line">';
                                str += '<span class="weui-loadmore__tips">到底了</span>';
                                str += '</div>';
                            }
                            str += "</div>";

                            str += "</div>";
                        }

                        $("#divdet").html("");
                        $("#divdet").prepend(str);
                        if (bz == "1") {
                            $('.weui-cell_swiped').swipeout();
                        }
                    }
                }
            }
        });
    }
function loadbzdata() {
    var dom=$("#divbq").find(".spadd");
    if(dom.length>0){
        $(dom[0]).click();
    }
    else{
        $("#tab2").click();
    }
}
    function showbq(lguid) {
        //向服务端发送删除指令
        $.ajax({
            url: "<%=basePath%>applive/detail/getbqbylguid",
            type: "post",
            data: {
                "lguid": lguid, 'bz': '1'
            },
            dataType: "text",
            success: function (data) {
                if (data != "") {
                    var json = $.parseJSON(data);
                    if (json.length > 0) {
                        var bqhtml = "";
                        bqhtml += '<span class="spqd" onclick="loadLiveAtt(this,\'\')">全部</span>';
                        for (var i = 0; i < json.length; i++) {
                            bqhtml += '<span class="spqd" onclick="loadLiveAtt(this,\'' + json[i].bguid + '\')">' + json[i].bq + '</span>';
                        }
                        $("#divbq").html(bqhtml);
                    }
                    else {
                        $("#divbq").html("");
                    }
                }
            }
        });
    }


    function loadLiveAtt(e, bq) {
        reloadsj("1", 1, bq);
        $(e).removeClass("sprm").addClass("spadd");
        $(e).siblings().addClass("sprm").removeClass("spadd");
    }

    /**
     * 加载评论
     * @param bz 1：下拉刷新，加载最新的；2：滑动刷新，加载以前的
     * @param crp 当前页
     */
    function reloaddata(bz, crp, comment) {

        var bz = "${bz}";
        var status = "";
        if (bz != "1") {
            status = "0";
        }
        var cmtct = 0;
        var ps = 1000;
        //向服务端发送删除指令
        $.ajax({
            url: "<%=basePath%>applive/cmt/wxdata",
            type: "post",
            data: {
                "lguid": $("#hidlguid").val(),
                "currentPage": crp,
                "pagesize": ps,
                "comment": comment,
                "status": status
            },
            dataType: "text",
            success: function (data) {
                if (data != "") {
                    var json = $.parseJSON(data);
                    var data = json.data;
                    if (data.length > 0) {
                        $("#divnodata").hide();
                        $("#spcmtct").show();
                        var str = "";
                        cmtct += data.length;
                        var iscomment = '${model.iscomment}';
                        for (var i = 0; i < data.length; i++) {
                            str += "<div class='ly-hf'>";
                            str += "<div class='weui-cell weui-cell_swiped'>";
                            str += "<div class='weui-cell__bd' >";
                            str += "<div class='liuyan-list clearfix' >";


                            if (data[i].headurl != "") {
                                str += "<div class='admin-img'><img src='" + data[i].headurl + "'/></div>";
                            }
                            else {
                                str += "<div class='admin-img'><img src='<%=basePath%>images/cmthead.jpg'/></div>";
                            }
                            str += "<div class='ly'>";
                            str += "<p>";
                            str += data[i].nickname;
                            if (bz == "1") {
                                //str += "<img class='imgdetailcz' src='<%=basePath%>images/del.png' onclick='cmtdel(this,\"" + data[i].cguid + "\")'/>";
                                if (data[i].status != '0') {
                                    str += "<span style='color:#ff0000;'>(待审)</span>";
                                    // str += "<img  class='imgdetailcz' src='<%=basePath%>images/sh.png' onclick='cmtupdate(this,\"" + data[i].cguid + "\")'></img>";
                                }
                            }
                            str += "</p>";
                            str += "<p>" + data[i].comment + "</p>";
                            str += "<p class='myp'>";
                            str += "<span class='spcmttime'>" + new Date(data[i].createtime.replace(/-/g, "/")).Format("yyyy-MM-dd hh:mm") + "</span>";
                            str += "<img class='imgcz' src='<%=basePath%>images/czan.png' onclick='cmtzan(this,\"" + data[i].cguid + "\")'/>";
                            str += "<span class='zantext'>" + data[i].zan + "</span>";
                            if (iscomment == "1") {
                                str += "<span  class='zansx'>|</span>";
                                str += "<img  class='imgcz' src='<%=basePath%>images/ccmt.png' bz='" + data[i].cguid + "' onclick='cmtadd(\"" + data[i].cguid + "\")' />";
                            }
                            str += "</p>";
                            str += "</div>";

                            str += "</div>";
                            str += "</div>";
                            if (bz == "1") {
                                str += "<div class='weui-cell__ft'>";
                                str += "<a class='weui-swiped-btn weui-swiped-btn_warn delete-swipeout' href='javascript:'  onclick='cmtdel(this,\"" + data[i].cguid + "\")'>删除</a>";
                                if (data[i].status != '0') {
                                    str += "<a class='weui-swiped-btn weui-swiped-btn_default close-swipeout' href='javascript:' onclick='cmtupdate(this,\"" + data[i].cguid + "\")'>审核</a>";
                                }
                                str += "</div>";
                            }
                            str += "</div>";
                            if (data[i].hfguid != "") {
                                str += " <div class='huifu-nr'>";
                                var hfarr = data[i].hfguid.split(")(");
                                cmtct += (hfarr.length - 1);
                                for (var t = 0; t < hfarr.length - 1; t++) {
                                    var hfs = hfarr[t].split("^");
                                    str += "<p><span>" + hfs[1] + ":</span>" + hfs[2] + "</p>";
                                }
                                str += "</div>";
                            }
                            str += "</div>";
                        }
                        $("#divcomment").html("");
                        $("#divcomment").prepend(str);
                        $('.weui-cell_swiped').swipeout();
                        $("#spcmtct").html(cmtct);
                    }
                    else {
                        $("#divcomment").html("");
                        $("#spcmtct").hide();
                        $("#divnodata").show();
                    }

                }


            }
        });
    }

    /**
     * 图片查看
     */
    function imageLook(e, j) {
        var doms = $(e).parent().find("figure");
        var srcarr = [];
        for (var i = 0; i < doms.length; i++) {
            srcarr.push($(doms[i]).attr("d"));
        }
        var pb1 = $.photoBrowser({
            items: srcarr,
            onSlideChange: function (index) {
                console.log(this, index);
            },
            onOpen: function () {
                console.log("onOpen", this);
            },
            onClose: function () {
                console.log("onClose", this);
            },
            initIndex: j
        });
        pb1.open();
    }

    /**
     * 显示直播添加
     */
    function detailadd() {
        isxg = '0';
        $("#hiddguid").val("");
        $("#hiddguid2").val("");
        $("#txtdescription").val("");
        editor.setValue("");
        $("#txtbq").val("");
        $("#txtbq").attr("data-values", "");
        $(":radio[name='isfb'][value='1']").prop("checked", "true");
        $(":radio[name='iszd'][value='0']").prop("checked", "true");
        $("#txtupdatetime").val(new Date().Format("yyyy-MM-dd hh:mm"));
        $("#txtupdatetime").datetimePicker();
        $("#tbodypreview").html("");
        $("#tbodypreview").css("height","0");
        $("#divdetail").popup();
    }

    function getBq(dguid) {
        //向服务端发送删除指令
        $.ajax({
            url: "<%=basePath%>applive/detail/getbqbydguid",
            type: "post",
            data: {
                "dguid": dguid
            },
            dataType: "text",
            success: function (data) {
                if (data != "") {
                    var json = $.parseJSON(data);
                    var bguidstr = "", bqstr = "";
                    if (json.length > 0) {
                        for (var i = 0; i < json.length - 1; i++) {
                            bguidstr += (json[i].bguid + ",");
                            bqstr += (json[i].bq + ",");
                        }
                        bguidstr += (json[json.length - 1].bguid);
                        bqstr += (json[json.length - 1].bq);
                        $("#txtbq").val(bqstr);
                        $("#txtbq").attr("data-values", bguidstr);
                    }
                    else {
                        $("#txtbq").val("");
                        $("#txtbq").attr("data-values", "");
                    }
                }
            }
        });
    }

    /**
     * 显示修改页面
     */
    function detailupdate(e, dguid) {
        isxg = '1';
        $("#tbodypreview").html("");
        $("#tbodypreview").css("height","0");
        $("#hiddguid").val(dguid);
        $.post("<%=basePath%>applive/detail/getsingle", {"dguid": dguid}, function (data, status) {
            if (status == "success") {
                if (data != "") {
                    var json = $.parseJSON(data);
                    //$("#txtdescription").val(json.dmodel.description);//
                    editor.setValue(json.dmodel.description);
                    //$("#txtbq").val(json.dmodel.bq);//
                    getBq(dguid);
                    if (json.dmodel.isfb == "1") {
                        $(":radio[name='isfb'][value='1']").prop("checked", "true");
                    }
                    else {
                        $(":radio[name='isfb'][value='0']").prop("checked", "true");
                    }
                    if (json.dmodel.iszd == "1") {
                        $(":radio[name='iszd'][value='1']").prop("checked", "true");
                    }
                    else {
                        $(":radio[name='iszd'][value='0']").prop("checked", "true");
                    }
                    var dstr = new Date(json.dmodel.updatetime.replace(/-/g, "/")).Format("yyyy-MM-dd hh:mm");
                    $("#txtupdatetime").val(dstr);
                    var yearstr = dstr.substr(0, 4);
                    var mstr = dstr.substr(5, 2);
                    var daystr = dstr.substr(8, 2);
                    var hstr = dstr.substr(11, 2);
                    var mistr = dstr.substr(14, 2);
                    $("#txtupdatetime").datetimePicker();
                    $("#txtupdatetime").picker("setValue", [yearstr, mstr, daystr, hstr, mistr]);

                    var js = json.amodel;
                    if (js.length > 0) {
                        $("#tbodypreview").html("");
                        var str = "";
                        for (var i = 0; i < js.length; i++) {
                            str += '<li class="weui-uploader__file" aguid="'+ js[i].aguid + '"  style="background-image:url(<%=basePath%>' + js[i].zoompath + ');">';
                            str += '<img title="删除" src="<%=basePath%>images/delet.png" class="delweui" onclick="filedel(this,\'' + js[i].aguid + '\')"/>';
                            str += '</li>';

                        }
                        $("#tbodypreview").html(str);
                        $('#tbodypreview').gridly({
                            base: 40, // px
                            gutter:1, // px
                            columns: 12,
                            callbacks:{ reordering: reordering , reordered: reordered }
                        });
                    }
                }
            }
        });
        $("#divdetail").popup();
    }

    /**
     * 删除一条直播
     */
    function detaildel(e, dguid) {
        $.confirm("确定删除吗", function () {
            $.ajax({
                url: "<%=basePath%>applive/detail/delbydguid",
                type: "post",
                data: {"dguid": dguid},
                dataType: "text",
                success: function (data) {
                    if (data == "1") {
                        $.toast("删除成功");
                        ///
                        $(e).parent().parent().parent().remove();
                    }
                }
            });
        });
    }

    /**
     * 直播点赞
     */
    function livezan(lguid) {
        //点击确认后的回调函数
        $.ajax({
            url: "<%=basePath%>applive/zan",
            type: "post",
            data: {"lguid": lguid},
            dataType: "text",
            success: function (data) {
                if (data == "1") {
                    var zantct = $("#spzanct").html();
                    if (zantct == null || zantct == undefined || zantct == "" || zantct == "null") {
                        zantct = "0";
                    }
                    $("#spzanct").html(parseInt(zantct) + 1);

                }
                else {
                    $.toast("点赞失败", "cancel");
                }
            }
        });
    }

    /**
     * 删除将要上传的图片
     */
    function imgdel(e) {
        $.confirm("确定删除吗", function () {
            $(e).remove();
        });
    }

    function filedel(e, aguid) {
        $.confirm("确定删除吗", function () {
            $.ajax({
                url: "<%=basePath%>applive/detail/delfilebyaguid",
                type: "post",
                data: {"aguid": aguid},
                dataType: "text",
                success: function (data) {
                    if (data == "1") {
                        $(e).parent().remove();
                    }
                }
            });

        });
    }

    /**
     * 显示添加评论
     */
    function cmtadd(cguid) {
        if (cguid != "") {
            $("#hidhfguid").val(cguid);
        }
        else {
            $("#hidhfguid").val("");
        }
        //添加评论
        $("#divcmt").popup();
        $("#txtcmt").val("");
        $("#aaddcmt").show();
        $("#aupcmt").hide();
    }

    function cmtdel(e, cguid) {
        $.confirm("确定删除吗", function () {
            $.ajax({
                url: "<%=basePath%>applive/cmt/deletebycguid",
                type: "post",
                data: {"cguid": cguid},
                dataType: "text",
                success: function (data) {
                    if (data == "1") {
                        $.toast("删除成功");
                        reloaddata("1", 1, "");
                        ///
                        //$(e).parent().parent().parent().remove();
                    }
                }
            });
        });
    }

    /**
     * 进行评论
     */
    function cmtadd2() {
        var cmt = $("#txtcmt").val();
        if (cmt == "") {
            $.toast("评论不能为空", "cancel");
            return;
        }
        $.ajax({
            url: "<%=basePath%>applive/cmt/wxadd",
            type: "post",
            data: {"lguid": $("#hidlguid").val(), "comment": cmt, "hfguid": $("#hidhfguid").val(), "openid": openid},
            dataType: "text",
            contentType: 'application/x-www-form-urlencoded;charset=UTF-8',
            success: function (data) {
                if (data == "1") {
                    if ($("#hidhfguid").val() != "") {
                        $.toast("评论成功。");
                    }
                    else {
                        $.toast("评论成功,等待审核！");
                    }
                    $.closePopup();
                    if ($("#hidhfguid").val() != "") {
                        $.ajax({
                            async: false,
                            url: "<%=basePath%>applive/cmt/wxdatahf",
                            type: "post",
                            data: {"hfguid": $("#hidhfguid").val()},
                            dataType: "text",
                            contentType: 'application/x-www-form-urlencoded;charset=UTF-8',
                            success: function (datahf) {
                                if (datahf != "") {
                                    var hfjson = $.parseJSON(datahf).data;
                                    var strhf = "";
                                    if (hfjson.length > 0) {
                                        if (hfjson.length == 1) {
                                            strhf += "<div class='huifu-nr'><p><span>" + hfjson[0].nickname + ":</span>" + hfjson[0].comment + "</p></div>";
                                            $(".myp img[bz='" + $("#hidhfguid").val() + "']").parent().parent().parent().parent().append(strhf);
                                        }
                                        else {
                                            for (var j = 0; j < hfjson.length; j++) {
                                                strhf += "<p><span>" + hfjson[j].nickname + ":</span>" + hfjson[j].comment + "</p>";
                                            }
                                            $(".myp img[bz='" + $("#hidhfguid").val() + "']").parent().parent().parent().siblings(".huifu-nr").html("");
                                            $(".myp img[bz='" + $("#hidhfguid").val() + "']").parent().parent().parent().siblings(".huifu-nr").html(strhf);
                                        }
                                    }
                                }
                            }
                        });
                    }
                    else {
                        if (index == 3) {
                            reloaddata("1", 1, "");
                        }
                    }
                    //图片上评论数加1
                    var zanstr = $("#spcmtct").html();
                    if (zanstr == null || zanstr == undefined || zanstr == "" || zanstr == "null") {
                        zanstr = 0;
                    }
                    $("#spcmtct").html(parseInt(zanstr) + 1);
                }
                else {
                    $.toast(data, "cancel");
                }
            }
        });
    }

    /**
     * 评论点赞操作
     * @param e 当前点击元素
     * @param cguid 评论id
     */
    function cmtzan(e, cguid) {
        $.ajax({
            url: "<%=basePath%>applive/cmt/wxzan",
            type: "post",
            data: {"cguid": cguid},
            dataType: "text",
            success: function (data) {
                if (data == "1") {
                    var zanstr = $(e).parent().find(".zantext").text();
                    if (zanstr == null || zanstr == undefined || zanstr == "" || zanstr == "null") {
                        zanstr = 0;
                    }
                    $(e).parent().find(".zantext").text(parseInt(zanstr) + 1);
                }
            }
        });
    }

    function cmtupdate(e, cguid) {
        $.confirm("确定审核通过吗", function () {
            $.ajax({
                url: "<%=basePath%>applive/cmt/wxstatus",
                type: "post",
                data: {"cguid": cguid},
                dataType: "text",
                success: function (data) {
                    if (data == "1") {
                        $.toast("审核通过");
                        reloaddata("1", 1, "");
                        ///
                        //$(e).siblings("span").remove();
                        //$(e).remove();
                    }
                }
            });
        });
    }

    function isvideo(hz) {
        var fhz = hz.substring(hz.lastIndexOf(".") + 1, hz.length).toLowerCase();
        if (fhz == "mp4" || fhz == "ogg" || fhz == "mov") {
            return true;
        }
        else {
            return false;
        }
    }

    function gzlive() {
        //向服务端发送删除指令
        $.ajax({
            url: "<%=basePath%>attention/add",
            type: "post",
            data: {"lguid": $("#hidlguid").val(), "title": "${model.title}"},
            dataType: "text",
            success: function (data) {
                if (data != "") {
                    if (data == "1") {
                        $.toast("关注成功");
                        $("#mygz").html('<div class="mygz" onclick="qxgzlive();">-已关注</div>');
                    }
                    else {
                        if (data == "3") {
                            $.toast("请先登录", "cancel");
                        }
                        else {
                            $.toast("关注失败", "cancel");
                        }

                    }
                }
                else {
                    $.toast("关注失败", "cancel");
                }
            }
        });
    }

    function qxgzlive() {
        //向服务端发送删除指令
        $.ajax({
            url: "<%=basePath%>attention/delete",
            type: "post",
            data: {"lguid": $("#hidlguid").val()},
            dataType: "text",
            success: function (data) {
                if (data != "") {
                    if (data == "1") {
                        $.toast("取关成功");
                        $("#mygz").html('<div class="mygz" onclick="gzlive();">+关注</div>');
                    }
                    else {
                        $.toast("取关失败", "cancel");
                    }
                }
                else {
                    $.toast("取关失败", "cancel");
                }
            }
        });
    }

    Date.prototype.Format = function (fmt) { //author: meizz
        var o = {
            "M+": this.getMonth() + 1, //月份
            "d+": this.getDate(), //日
            "h+": this.getHours(), //小时
            "m+": this.getMinutes(), //分
            "s+": this.getSeconds(), //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds() //毫秒
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }

    $(function () {

        var json = ${select};
        $("#txtbq").select({
            title: "直播标签",
            multi: true,
            min: 0,
            items: json
        });
        $("#uploaderInput").unbind().change(function () {
            var dguid = "";
            if (isxg == '1') {
                dguid = $("#hiddguid").val();
            } else {
                dguid = $("#hiddguid2").val();
            }
            var fname = $("#uploaderInput").val();
            var fhz = fname.substring(fname.lastIndexOf(".") + 1, fname.length).toLowerCase();
            if (fhz != 'mp4' && fhz != 'ogg' && fhz != 'mov' && fhz != 'png' && fhz != 'jpg' && fhz != 'jpeg' && fhz != 'gif' && fhz != 'bmp') {
                layer.msg('上传的文件类型有误', {icon: 2, time: 2000});
                return false;
            }
            $("#fjform").ajaxForm(function () {
            });
            $("#fjform").ajaxSubmit({
                dataType: "text",
                data: {"lguid": $("#hidlguid").val(), "dguid": dguid},
                error: function (jqXHR, textStatus, errorThrown) {
                    layer.msg('网络问题导致添加信息失败', {icon: 2, time: 2000});
                },
                success: function (data) {
                    if (data != "0") {
                        var json = $.parseJSON(data);
                        if (json.bz == "1") {
                            var rst = json.rst;
                            var str = '<li  class="weui-uploader__file" aguid="'+ rst.aguid + '" dguid="' + rst.dguid + '" style="background-image:url(<%=basePath%>' + rst.zoompath + ')">';
                            str += '<img title="删除" src="<%=basePath%>images/delet.png" class="delweui"  onclick="filedel(this,\'' + rst.aguid + '\')" />';
                            str += '</li>';
                            $("#tbodypreview").append(str);
                            $('#tbodypreview').gridly({
                                base: 40, // px
                                gutter:1, // px
                                columns: 12,
                                callbacks:{ reordering: reordering , reordered: reordered }
                            });
                            $("#uploaderInput").val("");
                            $("#hiddguid2").val(rst.dguid);
                        }
                    } else {
                        layer.msg('添加失败', {icon: 2, time: 2000});
                    }
                },
                beforeSubmit: function (formData, jqForm, options) {
                    //formData: 数组对象，提交表单时，Form插件会以Ajax方式自动提交这些数据，格式如：[{name:user,value:val },{name:pwd,value:pwd}]
                    //jqForm:   jQuery对象，封装了表单的元素
                    //options:  options对象

                }
            });
            return false;
        })

    });
    $(window).on('scroll', function() {
        if ($(document).scrollTop() > 400) {
            $('#divbq ').addClass('solid').removeClass('moveDown');
        } else {
            $('#divbq ').removeClass('solid').addClass('moveDown');
        }
    });

</script>
<div id="divcmt" class="weui-popup__container popup-bottom">
    <div class="weui-popup__overlay"></div>
    <div class="weui-popup__modal">
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__bd">
                        <input type="hidden" id="hidlguid" value="${lguid}"/>
                        <input type="hidden" id="hidcguid"/>
                        <input type="hidden" id="hidhfguid"/>
                        <textarea id="txtcmt" class="weui-input" type="text" placeholder="请输入评论"
                                  style="height: 100px;"></textarea>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell" style="padding: 0;">
                    <div class="weui-cell__hd" style="text-align: center;width:100%;padding-top: 0;">
                        <a class="weui-btn weui-btn_mini weui-btn_primary" href="javascript:" id="aaddcmt"
                           onclick="cmtadd2();">发布</a>
                        <a class="weui-btn weui-btn_mini weui-btn_primary" href="javascript:" id="aupcmt">发布</a>
                        <a class="weui-btn weui-btn_mini weui-btn_primary  close-popup" data-target="#divcmt"
                           href="javascript:">取消</a>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="divdetail" class="weui-popup__container popup-bottom">
    <div class="weui-popup__overlay"></div>
    <div class="weui-popup__modal">
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__bd">
                        <input type="hidden" id="hiddguid">
                        <input type="hidden" id="hiddguid2">
                        <textarea id="txtdescription" class="weui-input" type="text"
                                  placeholder="请输入直播内容"></textarea>
                    </div>
                </div>
            </div>
        </div>

        <div class="weui-cells weui-cells_checkbox">
            <div class="weui-cell">
                <label class=" weui-check__label" for="s11">
                    <div class="weui-cell__hd">
                        <input type="radio" class="weui-check" name="isfb" id="s11" value="1" checked="checked">
                        <i class="weui-icon-checked"></i>
                        发布
                    </div>
                </label>
                <label class="weui-check__label" for="s12" style="margin-left: 50px;">
                    <div class="weui-cell__hd">
                        <input type="radio" name="isfb" class="weui-check" value="0" id="s12">
                        <i class="weui-icon-checked"></i>
                        不发布
                    </div>
                </label>
            </div>
        </div>
        <div class="weui-cells weui-cells_checkbox">
            <div class="weui-cell">
                <label class=" weui-check__label" for="iszd1">
                    <div class="weui-cell__hd">
                        <input type="radio" class="weui-check" name="iszd" id="iszd1" value="1" checked="checked">
                        <i class="weui-icon-checked"></i>
                        置顶
                    </div>
                </label>
                <label class="weui-check__label" for="iszd2" style="margin-left: 50px;">
                    <div class="weui-cell__hd">
                        <input type="radio" name="iszd" class="weui-check" value="0" id="iszd2">
                        <i class="weui-icon-checked"></i>
                        不置顶
                    </div>
                </label>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__bd">
                        <input id="txtbq" class="weui-input" type="text"
                               placeholder="请选择直播标签"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cell">
                <div class="weui-cell__hd"><label for="txtupdatetime" class="weui-label">发布时间</label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" id="txtupdatetime" type="text">
                    <script>

                    </script>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cell">
                <div class="weui-cell__bd">
                    <div class="weui-uploader">
                        <div class="weui-uploader__hd">
                            <p class="weui-uploader__title">视图上传</p>
                        </div>
                        <div class="weui-uploader__bd">
                            <div class="weui-uploader__input-box"  >
                                <form id="fjform" action="<%=basePath%>person/fileadd" method="post" enctype="multipart/form-data">
                                    <input id="uploaderInput" name="picfile" class="weui-uploader__input" type="file" accept="image/*,video/mp4,video/ogg,video/mov" multiple="" >
                                </form>
                            </div>
                            <ul class="weui-uploader__files" id="tbodypreview" style="position: relative;height: auto; float: left;"></ul>


                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell" style="padding: 0;">
                    <div class="weui-cell__hd" style="text-align: center;width:100%;padding-top: 0;">
                        <a class="weui-btn weui-btn_mini weui-btn_primary" href="javascript:" id="afb">保存</a>
                        <a class="weui-btn weui-btn_mini weui-btn_primary  close-popup" data-target="#divdetail"
                           href="javascript:">取消</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
