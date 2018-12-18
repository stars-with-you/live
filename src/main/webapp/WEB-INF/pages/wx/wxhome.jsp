<%--
  User: fanglei
  Date: 2018-06-13
  Time: 9:51
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="x5-fullscreen" content="true">
    <meta name="full-screen" content="yes">
    <meta name="browsermode" content="application">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <title>图文直播平台</title>
    <link href="css/style.css" rel="stylesheet" type="text/css">
    <link href="css/style_ym.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="<%=basePath%>js/jquery-weui/lib/weui.min.css">
    <link rel="stylesheet" href="<%=basePath%>js/jquery-weui/css/jquery-weui.min.css">
</head>
<body>
<!--top-->
<div id="top">
    <div id="search_war">
        <div class="top_search">
            <div class="search">
                <a href="#" class="big-link" data-reveal-id="myModal" data-animation="fade"><img src="images/search.png"></a>
                <div id="myModal" class="reveal-modal">
                    <div class="sousuok">
                        <input class="search-input" type="text" placeholder="输入关键词搜索...">
                        <button class="search-btn">搜索</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--导航-->
    <div class="mainbav">
        <ul>
            <li class="xians"><a href="#">首页</a></li>
            <li class="xians"><a href="#">国内</a></li>
            <li class="xians"><a href="#">国际</a></li>
            <li class="xians"><a href="#">社会</a></li>
            <li class="xians"><a href="#">军事</a></li>
            <li class="xians more subNav currentDd currentDt "><a href="#">&nbsp;</a></li>
            <ul class="navContent">
                <li><a href="#">财经</a></li>
                <li><a href="#">娱乐</a></li>
                <li><a href="#">体育</a></li>
                <li><a href="#">科技</a></li>
                <li><a href="#">教育</a></li>
                <li><a href="#">健康</a></li>
                <li><a href="#">女性</a></li>
                <li><a href="#">汽车</a></li>
            </ul>
        </ul>
    </div>
</div>
<!--导航 end-->
</div>
<!--top end-->

<!-- banner begin -->
<div id="banner">
    <div class="swiper-container">
        <!-- Additional required wrapper -->
        <div class="swiper-wrapper">
            <!-- Slides -->
            <div class="swiper-slide"><img src="./images/swiper-1.png" /></div>
            <div class="swiper-slide"><img src="./images/swiper-2.jpg" /></div>
            <div class="swiper-slide"><img src="./images/swiper-3.jpg" /></div>
        </div>
        <!-- If we need pagination -->
        <div class="swiper-pagination"></div>
    </div>
</div>
<!-- banner end -->
<!-- main begin -->
<div id="main">
    <div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
            <a href="javascript:void(0);" class="weui-media-box weui-media-box_appmsg">
                <div class="weui-media-box__hd">
                    <img src="images/IMG_1752.JPG" class="weui-media-box__thumb">
                </div>
                <div class="weui-media-box__bd">
                    <div class="live-status locate colorB"><span data-v-afeee504="">直播</span></div>
                    <h4 class="weui-media-box__title">2018济南韩国商品博览会</h4>
                    <p class="weui-media-box__desc">2018-6-5</p>
                </div>
            </a>
            <a href="javascript:void(0);" class="weui-media-box weui-media-box_appmsg">
                <div class="weui-media-box__hd">
                    <img src="images/IMG_1754.JPG" class="weui-media-box__thumb">
                </div>
                <div class="weui-media-box__bd">
                    <div class="live-status locate colorA"><span data-v-afeee504="">预告</span></div>
                    <h4 class="weui-media-box__title">东南亚投资机遇与风险防范研讨会</h4>
                    <p class="weui-media-box__desc">2018-6-4</p>
                </div>
            </a>

            <a href="javascript:void(0);" class="weui-media-box weui-media-box_appmsg">
                <div class="weui-media-box__hd">
                    <img src="images/IMG_1754.JPG" class="weui-media-box__thumb">
                </div>
                <div class="weui-media-box__bd">
                    <div class="live-status locate colorC"><span data-v-afeee504="">回顾</span></div>
                    <h4 class="weui-media-box__title">东南亚投资机遇与风险防范研讨会</h4>
                    <p class="weui-media-box__desc">2018-6-3</p>
                </div>
            </a>

        </div>
        <div class="weui-panel__ft">
            <a href="javascript:void(0);" class="weui-cell weui-cell_access weui-cell_link">
                <div class="weui-cell__bd">查看更多</div>
                <span class="weui-cell__ft"></span>
            </a>
        </div>
    </div>
</div>
<!-- main end -->
<!-- bottom begin -->
<!-- bottom end -->
<script src="<%=basePath%>js/jquery-1.12.4.js"></script>
<script src="<%=basePath%>js/jquery-weui/lib/fastclick.js"></script>
<script>
    $(function () {
        FastClick.attach(document.body);
    });
</script>
<script src="<%=basePath%>js/jquery-weui/js/jquery-weui.js"></script>
<script src="<%=basePath%>js/jquery-weui/js/swiper.js"></script>
<script>
    $(function(){
        $(".subNav").click(function(){
            $(this).toggleClass("currentDd").siblings(".subNav").removeClass("currentDd")
            $(this).toggleClass("currentDt").siblings(".subNav").removeClass("currentDt")
            $(this).next(".navContent").slideToggle(300).siblings(".navContent").slideUp(500)
        });
        $(".swiper-container").swiper({
            loop: true,
            autoplay: 3000
        });
    });
</script>
</body>
</html>
