<%--
  Created: 方磊
  Date: 2017年8月18日  上午10:34:27
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html  style="overflow: hidden; height: 100%;">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>金茂图文直播</title>
    <meta name="renderer" content="webkit">
    <link rel="shortcut icon" href="<%=basePath%>images/favicon.png">
    <link href="<%=basePath%>images/style.css" rel="stylesheet">
    <link href="<%=basePath%>images/animate.css" rel="stylesheet">
    <style>
        #top_login {
            width: 10%;
        }
        .top_login_dl {
            width: 100%;
        }
    </style>
</head>
<body onLoad="load()" style="overflow: hidden; height: 100%;">
<div id="first" style="overflow: hidden; height: 100%;">
    <!-- top -->
    <div id="top">
        <!-- top_logo -->
        <div id="top_logo" class="wow fadeInLeft">
            <div class="top_logo_img"><img src="images/index_PC_01.jpg"></div>
            <div class="top_logo_title">金茂图文直播</div>
        </div>
        <!-- //top_logo -->
        <!-- top_menu -->
        <div id="top_menu">
            <ul>
                <li><a href="<%=basePath%>show">首页</a></li>
                <li><a href="<%=basePath%>show/zhibo">直播</a></li>
                <li><a target="_blank" href="<%=basePath%>person/detail">个人中心</a></li>
            </ul>
        </div>
        <!-- //top_menu -->
        <!-- top_login -->
        <div id="top_login" class="wow fadeInRight">
            <input name="登录" type="button" class="top_login_dl" value="立即登录" onclick="login()" />
        </div>
        <!-- //top_login -->
    </div>
    <!-- //top -->
    <!-- banenr -->
    <div id="banenr">
        <h1 class="wow slideInLeft">专 属 定 制</h1>
        <h2 class="wow slideInRight">免费使用为企业量身定制，服务不断升级</h2>
        <div class="button wow fadeInUp" data-wow-delay="0.4s"><a target="_blank" href="<%=basePath%>person/livelist">现在直播</a></div>
    </div>
    <!-- //banenr -->
</div>
<!-- second_container -->
<div id="second_container" style="display: none;">
    <div class="second_container_img wow fadeInLeft"><img src="<%=basePath%>images/index_PC_07.jpg"></div>
    <div class="second_container_content">
        <h1 class="wow slideInRight">丰富的插件功能</h1>
        <h2 class="wow slideInLeft">功能强大，满足用户不同需求</h2>
        <div class="button_orange wow fadeInUp" data-wow-delay="0.5s"><a  target="_blank" href="<%=basePath%>person/livelist">现在直播</a></div>
    </div>
</div>
<!-- //second_container -->
<!-- three_container -->
<div id="three_container" style="display: none;">
    <h1 class="wow slideInDown" data-wow-delay="0s">直播案例</h1>
    <div class="three_container_case" id="divzb">


    </div>
    <div class="three_container_more wow fadeInLeft"><a href="<%=basePath%>show/zhibo">查看更多</a></div>
</div>
<!-- //three_container -->
<!-- bottom -->
<div id="bottom" style="display: none;">
    <div class="bottom_on">
        <div class="bottom_code wow slideInLeft">
            <div><img src="<%=basePath%>images/index_PC_10.jpg"></div>
            <div style="font-size:18px; line-height:50px; color:#666666;">扫一扫关注我们</div>
        </div>
        <div class="bottom_contact_us wow slideInRight">
            <div class="bottom_contact_us_title">联系我们</div>
            <div class="bottom_contact_us_phone">电话：<span class="font_number">025-52856433</span></div>
            <div class="bottom_contact_us_address">地址：南京市中华路50号江苏国际经贸大厦</div>
        </div>
    </div>
    <div class="bottom_under wow fadeInUp" data-wow-delay=".1s">Copyright&nbsp;&copy;&nbsp;2018&nbsp;&nbsp;&nbsp;&nbsp;版权所有：江苏金茂国际电子商务有限公司</div>
</div>
<!-- //bottom -->
<div id="fullPage-nav" class="right" style="color: rgb(7, 141, 251); margin-top: -92.5px;">
    <ul>
        <li data-id="#first"><a href="javascript:;" class="active"><span></span></a></li>
        <li data-id="#second_container"><a href="javascript:;"><span></span></a></li>
        <li data-id="#three_container"><a href="javascript:;"><span></span></a></li>
        <li data-id="#bottom"><a href="javascript:;"><span></span></a></li>
    </ul>
</div>
<script src="<%=basePath%>js/jquery-1.12.4.min.js"></script>

<script>
    $(function () {
        $("#fullPage-nav li").each(function () {
            $(this).click(function () {
                var self=this;
                $(self).find("a").attr("class","active");
                var id=$(self).attr("data-id");
                $(""+id+"").show();
                $(self).siblings().each(function () {
                    $(this).find("a").removeAttr("class");
                    $(""+$(this).attr("data-id")+"").hide();
                });
            });
        });
    });
    function login() {
        location.href="<%=basePath%>manager/login";
    }
    function loaddata(crp, ps) {
        $.ajax({
            url: "<%=basePath%>applive/showdata",
            type: "post",
            data: {"currentPage": crp, "pagesize": ps},
            dataType: "text",
            success: function (data) {
                var json = $.parseJSON(data).data;
                var str = "";
                for (var i = 0; i < json.length; i++) {
                    str += "<div class='three_container_case_al wow fadeInUp' data-wow-delay='0.6s'>";

                    if(json[i].defaultpic==null || json[i].defaultpic==""){
                        str += "<a  href='<%=basePath%>show/zhibo/detail?lguid=" + json[i].lguid + "'><img  src='<%=basePath%>upload/defaultpic/default.png'></a>";
                    }
                    else {
                        str += "<a  href='<%=basePath%>show/zhibo/detail?lguid=" + json[i].lguid + "'><img  src='<%=basePath%>" + json[i].defaultpic + "'></a>";
                    }
                    str += "<p><a href='javascript:;'>"+json[i].title+"</a></p>";
                    str += "</div>";
                }
                $("#divzb").html(str);
            }
        });
    }
    loaddata(1,4);
</script>
<!-- Custom Theme JavaScript -->
<script src="<%=basePath%>js/theme.js"></script>
<!-- Wow Animation -->
<script type="text/javascript" src="<%=basePath%>js/wow.min.js"></script>
</body>

</html>
