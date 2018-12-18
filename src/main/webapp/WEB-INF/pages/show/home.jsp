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
<html>
<!-- Head -->
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>金茂图文直播</title>
    <meta name="renderer" content="webkit">
    <link rel="shortcut icon" href="<%=basePath%>images/index_PC_01.png">
    <link href="<%=basePath%>images/style.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/alert/dialog.css"/>
    <link href="<%=basePath%>images/animate.css" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="<%=basePath%>images/0814_jquery.pagepiling.css"/>

    <script src="<%=basePath%>js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/0814_jquery.pagepiling.min.js"></script>
    <script type="text/javascript">
        var deleteLog = false;

        $(document).ready(function () {
            $('#pagepiling').pagepiling({
                menu: '#menu',
                anchors: ['page1', 'page2', 'page3', 'page4']
            });
        });

    </script>
    <style>
        .section {
            text-align: center;
        }

        #section1, #section2, #section3 {
            background-size: cover;
        }

        #section1 {
            background-image: url(<%=basePath%>images/bg1.jpg);
        }

        #section2 {
            background-color: #ffffff;
        }

        #section3 {
            background-image: url(<%=basePath%>images/bg3.jpg);
        }

        #section4 {
            background-image: url(<%=basePath%>images/bottom_bj.jpg);
        }

        .top_login_dl, .top_login_zc {
            cursor: pointer;
            border: none;
        }

    </style>
</head>
<body>
<div id="popupcontent" class="c_alert_dialog" >
    <div class="c_alert_mask" onclick="closeReg();"></div>
    <div class="c_alert_width">
        <div class="c_alert_con"><img src="<%=basePath%>images/reg.png" width="100%">
        </div>
        <div class="c_alert_btn"><a href="javascript:;" data-name="关闭" onclick="closeReg();">关闭</a></div>
    </div>
</div>
<!-- top -->
<div id="top">
    <!-- top_logo -->
    <div id="top_logo" class="wow fadeInLeft">
        <div class="top_logo_img"><img src="<%=basePath%>images/index_PC_01.png"></div>
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
        <input name="登录" type="button" class="top_login_dl" value="立即登录" onclick="login()"/>
        <input name="注册" type="button" class="top_login_zc" value="免费注册" onclick="reg();">

    </div>
    <!-- //top_login -->
</div>
<!-- //top -->

<div style="position:fixed;top:50px;left:50px;color:white;z-index:999;" id="callbacksDiv"></div>
<!-- pagepiling -->
<div id="pagepiling">
    <!-- section1 -->
    <div class="section" id="section1">
        <div class="intro">

            <!-- banenr -->
            <div id="banenr">
                <h1 class="wow slideInLeft">专 属 定 制</h1>
                <h2 class="wow slideInRight">免费使用为企业量身定制，服务不断升级</h2>
                <div class="button wow fadeInUp" data-wow-delay="0.4s"><a target="_blank"
                                                                          href="<%=basePath%>person/livelist">现在直播</a>
                </div>
            </div>
            <!-- //banenr -->
        </div>
    </div>
    <!-- //section1 -->
    <!-- section2 -->
    <div class="section" id="section2">
        <div class="intro">
            <!-- second_container -->
            <div id="second_container">
                <div class="second_container_img wow fadeInLeft"><img src="<%=basePath%>images/index_PC_07.jpg"></div>
                <div class="second_container_content">
                    <h1 class="wow slideInRight">丰富的插件功能</h1>
                    <h2 class="wow slideInLeft">功能强大，满足用户不同需求</h2>
                    <div class="button_orange wow fadeInUp" data-wow-delay="0.5s"><a target="_blank"
                                                                                     href="<%=basePath%>person/livelist">现在直播</a>
                    </div>
                </div>
            </div>
            <!-- //second_container -->
        </div>
    </div>
    <!-- //section2 -->
    <!-- section3 -->
    <div class="section" id="section3">
        <div class="intro">

            <!-- three_container -->
            <div id="three_container">
                <h1 class="wow slideInDown" data-wow-delay="0s">直播案例</h1>
                <div class="three_container_case" id="divzb">


                </div>
                <div class="three_container_more wow fadeInLeft"><a href="<%=basePath%>show/zhibo">查看更多</a></div>
            </div>
            <!-- //three_container -->

        </div>
    </div>
    <!-- //section3 -->
    <!-- section4 -->
    <div class="section" id="section4">
        <div class="intro">
            <!-- bottom -->
            <div id="bottom">
                <div class="bottom_on">
                    <div class="bottom_code wow slideInLeft">
                        <div><img src="<%=basePath%>images/1534389060.png"></div>
                        <div style="font-size:18px; line-height:50px; color:#666666;">扫一扫关注我们</div>
                    </div>
                    <div class="bottom_contact_us wow slideInRight">
                        <div class="bottom_contact_us_title">联系我们</div>
                        <div class="bottom_contact_us_phone">电话：<span class="font_number">025-52856433</span></div>
                        <div class="bottom_contact_us_address">地址：南京市中华路50号江苏国际经贸大厦</div>
                    </div>
                </div>
                <div class="bottom_under wow fadeInUp" data-wow-delay=".1s">
                    Copyright&nbsp;&copy;&nbsp;2018&nbsp;&nbsp;&nbsp;&nbsp;版权所有：江苏金茂国际电子商务有限公司
                </div>
            </div>
            <!-- //bottom -->
        </div>
    </div>
    <!-- //section4 -->
</div>
<script>
    function login() {
        location.href = "<%=basePath%>manager/login";
    }
    function reg() {
        var popUp = document.getElementById("popupcontent");
        popUp.style.visibility = "visible";
    }
    function closeReg() {
        document.getElementById('popupcontent').style.visibility='hidden';
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
                    str += "<div class='three_container_case_al'>";
                    if(json[i].defaultpic==null|| json[i].defaultpic==""){
                        str += "<a  href='<%=basePath%>show/zhibo/detail?lguid=" + json[i].lguid + "'><img  src='<%=basePath%>upload/defaultpic/default.png'></a>";
                    }
                    else {
                        str += "<a  href='<%=basePath%>show/zhibo/detail?lguid=" + json[i].lguid + "'><img  src='<%=basePath%>" + json[i].defaultpic + "'></a>";
                    }
                    str += "<p><a href='javascript:;'>" + json[i].title + "</a></p>";
                    str += "</div>";
                }
                $("#divzb").html(str);
            }
        });
    }

    loaddata(1,4);
</script>
<!-- //pagepiling -->
<script src="<%=basePath%>js/theme.js"></script>
<!-- Wow Animation -->
<script type="text/javascript" src="<%=basePath%>js/wow.min.js"></script>
</body>
</html>
