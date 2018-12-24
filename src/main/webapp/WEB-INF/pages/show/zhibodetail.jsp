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
    <link rel="shortcut icon" href="<%=basePath%>images/index_PC_01.png">
    <meta charset="utf-8"/>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <script src="<%=basePath%>js/jquery-1.12.4.js"></script>
    <link href="<%=basePath%>images/layout.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="<%=basePath%>js/jquery-weui/lib/weui.min.css">
    <link rel="stylesheet" href="<%=basePath%>js/jquery-weui/css/jquery-weui.min.css">
    <link href="<%=basePath%>images/style.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/alert/dialog.css"/>
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
            margin: 0px 35px;
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
            left: 38%;
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
            bottom: 100px;
            right: 0px;
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
            margin-top:0;
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
            z-index: 9999;
            width:420px;
            background-color: #eee;
            -webkit-box-shadow: 0 5px 5px rgba(0, 0, 0, 0.1);
            shadow: 0 5px 5px rgba(0, 0, 0, 0.1);
            -webkit-transition: all 0.25s ease-in-out;
            -moz-transition: all 0.25s ease-in-out;
            -o-transition: all 0.25s ease-in-out;
        }
        #top{ width:92%;margin:0 auto; position:absolute; top:0; height:100px;padding:0 4%; overflow:hidden; z-index:100; background-color:#ffffff; }
    </style>
</head>

<body style="background-color:#2a3156;">
<div id="popupcontent" class="c_alert_dialog">
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
<div style="width:480px; border:none;position: absolute;left: 50%;top:100px; margin-left: -250px;height:99%; background-color:#ffffff;">
    <div class="zhibo">
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
                    <span> 留言</span>
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
                            <strong>支持<br/>单位</strong>
                        </dd>
                        <dt>
                            <p>${model.zcdw}</p>
                        </dt>
                    </dl>
                    <dl>
                        <dd>
                            <strong>时间</strong>
                        </dd>
                        <dt>
                            <p><fmt:formatDate value="${model.startdate}" pattern="yyyy-MM-dd HH:mm"/>
                                ~
                                <fmt:formatDate value="${model.enddate}" pattern="yyyy-MM-dd HH:mm"/></p>
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
                <div id="divdet" style="background-color:#ffffff;">

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
        <%--<c:if test="${model.iscomment=='1'}">--%>
        <%--<div class="tool comment" style="margin: 0;margin-right: 5px;" onclick="cmtadd('');">--%>
        <%--<i class="iconfont "><img src="<%=basePath%>images/liuyan.png"/></i>--%>
        <%--</div>--%>
        <%--</c:if>--%>
        <%--<div class="tool comment" style="margin: 0;margin-right: 15px;" onclick="livezan('${model.lguid}')">--%>
        <%--<i class="iconfont "><img src="<%=basePath%>images/star00.png" class="journal-reward"/> </i>--%>
        <%--</div>--%>
    </div>
</div>
<script src="<%=basePath%>js/jquery-weui/lib/fastclick.js"></script>
<script>
    $(function () {
        FastClick.attach(document.body);
    });
</script>
<script src="<%=basePath%>js/jquery-weui/js/jquery-weui.js"></script>
<script src="<%=basePath%>js/jquery-weui/js/swiper.js"></script>
<script type="text/javascript">
    var index = 1;
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
                reloadsj("1", 1, "");
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
<script src="<%=basePath%>js/flutter-hearts-zmt.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=basePath%>js/pj/live_detail.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=basePath%>js/pj/live_cmt.js" type="text/javascript" charset="utf-8"></script>
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
                            str += '<div class="swiper-slide"><img style="height:320px;" src="<%=basePath%>' + json[i].defaultpic + '"/></div>';
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
    /**
     * 加载直播详情数据
     */
    function reloadsj(bz, crp, bq) {
        var ps = 1000;
        //向服务端发送删除指令
        $.ajax({
            url: "<%=basePath%>applive/detail/datafile",
            type: "post",
            data: {"lguid": $("#hidlguid").val(), "currentPage": crp, "pagesize": ps, "isfb": '1', "bq": bq},
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
                            str += "<p>";
                            str += new Date(data[i].updatetime.replace("-", "/")).Format("yyyy-MM-dd hh:mm");
                            str += "</p>";
                            str += "<p style='color:#999;font-size: 14px;'>";
                            str += data[i].description;
                            str += "</p>";
                            str += "<div>";
                            if (data[i].pguid != "") {
                                var imgstr = data[i].pguid;
                                imgstr = imgstr.substring(0, imgstr.length - 1);
                                var imgjson = imgstr.split(";");
                                var imglen = imgjson.length;
                                var lenbz=imglen;
                                var varr=new Array();
                                for (var j = 0; j < imglen; j++) {
                                    var imgpath = imgjson[j].split(",");
                                    if (isvideo(imgpath[0])) {
                                        lenbz = lenbz - 1;
                                        varr.push(imgpath[0]);
                                    }
                                }
                                for (var t = 0; t < varr.length; t++) {
                                    str+='<video  width="410"   src="<%=basePath%>'+varr[t]+'" controls></video>';
                                }
                                for (var j = 0; j < imglen; j++) {
                                    var imgpath = imgjson[j].split(",");
                                    if(!isvideo(imgpath[0])) {
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
                            if(i==data.length-1){
                                str += '<div class="weui-loadmore weui-loadmore_line">';
                                str += '<span class="weui-loadmore__tips">到底了</span>';
                                str += '</div>';
                            }
                            str += "</div>";
                            str += "</div>";
                        }


                        $("#divdet").html("");
                        $("#divdet").prepend(str);
                    }
                }
            }
        });
    }
    function showbq(lguid) {
        //向服务端发送删除指令
        $.ajax({
            url: "<%=basePath%>applive/detail/getbqbylguid",
            type: "post",
            data: {
                "lguid": lguid,'bz':'0'
            },
            dataType: "text",
            success: function (data) {
                if (data != "") {
                    var json=$.parseJSON(data);
                    if(json.length>0) {
                        var bqhtml = "";
                        bqhtml += '<span class="spqd" onclick="loadLiveAtt(this,\'\')">全部</span>';
                        for (var i = 0; i < json.length; i++) {
                            bqhtml += '<span class="spqd" onclick="loadLiveAtt(this,\'' + json[i].bguid + '\')">' + json[i].bq + '</span>';
                        }
                        $("#divbq").html(bqhtml);
                    }
                }
            }
        });
    }
    showbq("${lguid}");
    function loadLiveAtt(e, bq) {
        reloadsj("1", 1, bq);
        $(e).removeClass("sprm").addClass("spadd");
        $(e).siblings().addClass("sprm").removeClass("spadd");
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
    /**
     * 加载评论
     * @param bz 1：下拉刷新，加载最新的；2：滑动刷新，加载以前的
     * @param crp 当前页
     */
    function reloaddata(bz, crp, comment) {

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
                "status": '0'
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
                            str += "</p>";
                            str += "<p>" + data[i].comment + "</p>";
                            str += "<p class='myp'>";
                            str += "<span class='spcmttime'>" + new Date(data[i].createtime.replace("-", "/")).Format("yyyy-MM-dd hh:mm") + "</span>";
                            str += "<img class='imgcz' src='<%=basePath%>images/czan.png' onclick='cmtzan(this,\"" + data[i].cguid + "\")'/>";
                            str += "<span class='zantext'>" + data[i].zan + "</span>";
                            if (iscomment == "1") {
                                str += "<span  class='zansx'>|</span>";
                                str += "<img  class='imgcz' src='<%=basePath%>images/ccmt.png' bz='" + data[i].cguid + "' onclick='cmtadd(\"" + data[i].cguid + "\")' />";
                            }
                            str += "</p>";
                            str += "</div>";


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
                    }
                }
                $("#spcmtct").html(cmtct);
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
                    $.toast("评论成功,请等待审核！");
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
                        if (index == 2) {
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
    function login() {
        location.href = "<%=basePath%>manager/login";
    }

    function reg() {
        var popUp = document.getElementById("popupcontent");
        popUp.style.visibility = "visible";
    }

    function closeReg() {
        document.getElementById('popupcontent').style.visibility = 'hidden';
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
</body>
</html>
