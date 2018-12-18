<%--
  User: fanglei
  Date: 2018-08-08
  Time: 16:11
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
<!-- Head -->
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>金茂图文直播</title>
    <meta name="renderer" content="webkit">
    <link rel="shortcut icon" href="<%=basePath%>images/index_PC_01.png">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta charset="gb2312">
    <meta name="keywords" content=""/>
    <link href="<%=basePath%>images/style.css" rel="stylesheet">
    <link href="<%=basePath%>images/animate.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/alert/dialog.css" />

    <style>
        .pic {
            width: 266px;
            height: 199.5px;
        }

        .case-status span {
            width: 20%;
        }


        .con .active {
            color: #ffffff;
            background-color: #999999;
            border-radius: 5px;
        }
        .top_login_dl,.top_login_zc{
            cursor: pointer;
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
<svg aria-hidden="true" style="position: absolute; width: 0px; height: 0px; overflow: hidden;">
    <symbol id="icon-canyurenshu" viewBox="0 0 1024 1024">
        <path d="M79.211565 1023.320448c0-177.898401 0-355.718156 246.556803-449.228855a346.201929 346.201929 0 0 0 371.447458 0c246.556803 93.510698 246.556803 271.330453 246.556803 449.228855H79.211565z m432.241209-464.87951A278.408639 278.408639 0 0 1 233.594661 279.481774 278.408639 278.408639 0 0 1 511.452774 0.52261 278.408639 278.408639 0 0 1 789.389533 279.481774a278.408639 278.408639 0 0 1-277.936759 278.959164z"></path>
    </symbol>
    <symbol id="icon-dianzanshu" viewBox="0 0 1024 1024">
        <path d="M984.252117 484.716849c0-59.526655-35.983706-109.447157-84.565645-123.620171a12.598234 12.598234 0 0 0-3.621992-0.314956H648.272966c-1.023607 0-1.574779-4.803077-1.338562-5.669205a537.787111 537.787111 0 0 0 17.558788-227.083167l-0.078739-0.236216c0-70.628849-50.392936-127.793335-112.596715-127.793336-57.715659 0-105.037775 49.054373-111.888066 112.28176h-0.078738c-22.75556 214.169977-168.028945 278.106014-200.705615 289.916858H238.594146c-1.968474-0.393695-3.936948 0-5.984161 0H80.171355c-22.519343 0-40.786782 20.393391-40.786783 45.904815v531.173039c0 25.590163 18.267439 44.172558 40.786783 44.172557h702.351542c4.015687 0.393695 8.031374 0 12.047061 0 74.32958 0 99.998482-69.526504 99.998482-69.526503 8.110113-17.637528 84.723123-431.961946 84.723123-431.961946 1.49604-5.590466 2.598386-11.41715 3.307036-17.165094l0.314956-1.889735V502.748071c0.78739-5.905422 1.338562-11.889583 1.338562-18.031222zM184.736696 926.836121a24.881512 24.881512 0 0 1-49.763024 0V498.889862a24.881512 24.881512 0 0 1 49.763024 0v427.946259"></path>
    </symbol>
    <symbol id="icon-pinglunshu" viewBox="0 0 1211 1024">
        <path d="M999.598027 880.996925H843.19758l1.860803 1.209521c-381.371464 0-661.050074 141.048826-661.050074 141.048827V882.206446l0.4652-3.721605C80.826812 865.738344 0.440146 780.699672 0.440146 676.494734V204.967391C0.440146 92.016682 94.596751 0.465201 210.803864 0.465201h788.794163C1115.805141 0.465201 1209.961745 92.016682 1209.961745 204.967391v471.527343c0 112.950709-94.156604 204.50219-210.363718 204.502191zM352.131811 379.231541c-43.542778 0-78.898024 33.587484-78.898024 75.08338 0 41.495895 35.355247 75.083379 78.898024 75.083379 43.542778 0 78.898024-33.587484 78.898024-75.083379 0-41.495895-35.355247-75.083379-78.898024-75.08338z m272.793641 0a76.106821 76.106821 0 0 0-77.223302 75.08338c0 41.495895 34.517886 75.083379 77.223302 75.083379 42.612376 0 77.223302-33.587484 77.223302-75.083379a76.199861 76.199861 0 0 0-77.223302-75.08338z m272.79364 0c-43.542778 0-78.898024 33.587484-78.898024 75.08338 0 41.495895 35.355247 75.083379 78.898024 75.083379 43.542778 0 78.898024-33.587484 78.898025-75.083379 0-41.495895-35.355247-75.083379-78.898025-75.08338z"></path>
    </symbol>
</svg>
<!-- top -->
<div id="top">
    <!-- top_logo -->
    <div id="top_logo">
        <div class="top_logo_img"><img src="<%=basePath%>images/index_PC_01.jpg"></div>
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
    <div id="top_login">
        <input name="登录" type="button" class="top_login_dl" value="立即登录" onclick="login()" />
        <input name="注册" type="button" class="top_login_zc" value="免费注册" onclick="reg();">
    </div>
    <!-- //top_login -->
</div>
<!-- //top -->

<!-- banenr -->
<div class="page_banenr">
    <div class="page_banenr_title01 wow fadeInLeft"> / 直 / 播 /</div>
    <div class="page_banenr_title02 wow fadeInLeft">专注为用户打造最优质的直播体验</div>
</div>
<!-- //banenr -->

<!-- page_zhibo_al -->
<div class="page_zhibo_al wow fadeInUp">
    <div class="page_zhibo_al_title">直播</div>
    <div class="page_zhibo_al_wrap" id="divzb">

    </div>

    <div class="Page_turning">
        <ul class="con" id="ul">

        </ul>
    </div>

</div>
<!-- //page_zhibo_al -->

<!-- bottom -->
<div id="page_bottom">
    <div class="page_bottom_on">
        <div class="page_bottom_code">
            <div><img src="<%=basePath%>images/1534389060.png"></div>
            <div style="font-size:16px; line-height:40px; color:#333333;">扫一扫关注我们</div>
        </div>
        <div class="page_bottom_contact_us">
            <div class="page_bottom_contact_us_title">联系我们</div>
            <div class="page_bottom_contact_us_phone">电话：025-52856433</div>
            <div class="page_bottom_contact_us_address">地址：南京市中华路50号江苏国际经贸大厦</div>
        </div>
    </div>
    <div class="page_bottom_under">Copyright&nbsp;&copy;&nbsp;2018&nbsp;&nbsp;&nbsp;&nbsp;版权所有：江苏金茂国际电子商务有限公司</div>
</div>
<!-- //bottom -->
<!-- jQuery -->
<script src="<%=basePath%>js/jquery-1.12.4.js"></script>
<!-- Custom Theme JavaScript -->
<script src="<%=basePath%>js/theme.js"></script>
<!-- Wow Animation -->
<script type="text/javascript" src="<%=basePath%>js/wow.min.js"></script>
<script>
    var currrent = 1;
    ps = 8;

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
        currrent = crp;
        $.ajax({
            url: "<%=basePath%>applive/showdata",
            type: "post",
            data: {"currentPage": crp, "pagesize": ps},
            dataType: "text",
            success: function (data) {
                var json = $.parseJSON(data).data;
                totalcount = parseInt($.parseJSON(data).count);
                var str = "";
                for (var i = 0; i < json.length; i++) {
                    str += "<div class='page_zhibo_al_container'>";
                    str += "<div class='page_zhibo_al_container_img'>";
                    str += "<a  href='<%=basePath%>show/zhibo/detail?lguid=" + json[i].lguid + "'>";
                    if(json[i].defaultpic==null || json[i].defaultpic==""){
                        str += "<img class='pic' src='<%=basePath%>upload/defaultpic/default.png'>";
                    }
                    else {
                        str += "<img class='pic' src='<%=basePath%>" + json[i].defaultpic + "'>";
                    }
                    str += "</a>";
                    str += "</div>";
                    str += "<div class='page_zhibo_al_container_font'>";
                    str += "<div class='page_zhibo_al_container_title'>" + json[i].title + "</div>";
                    str += "<div class='case-status'>";
                    str += "<span><svg class='icon' aria-hidden='true'><use xlink:href='#icon-canyurenshu'></use></svg>" + json[i].access + "</span>";
                    str += "<span><svg class='icon' aria-hidden='true'><use xlink:href='#icon-dianzanshu'></use></svg>" + json[i].zan + "</span>";
                    str += "</div>";
                    str += "</div>";
                    str += "</div>";
                }
                $("#divzb").html(str);
                var pagecount = Math.ceil(totalcount / ps);
                if (pagecount > 10) {
                    pagecount = 10;
                }
                var ulstr = "";
                if (crp <= 1) {
                    ulstr += "<li><a href='javascript:;' disabled>上一页</a></li>";
                }
                else {

                    ulstr += "<li><a href='javascript:;' onclick='loaddata(" + (crp - 1) + "," + ps + ")'>上一页</a></li>";
                }
                for (var i = 1; i <= pagecount; i++) {
                    if (i == crp) {
                        ulstr += "<li><a  href='javascript:;'  onclick='loaddata(" + (i) + "," + ps + ")' class='active'>" + i + "</a></li>";
                    }
                    else {
                        ulstr += "<li><a href='javascript:;'  onclick='loaddata(" + (i) + "," + ps + ")'>" + i + "</a></li>";
                    }

                }
                if (crp >= pagecount) {
                    ulstr += "<li><a href='javascript:;' disabled>下一页</a></li>";
                }
                else {

                    ulstr += "<li><a href='javascript:;' onclick='loaddata(" + (crp + 1) + "," + ps + ")'>下一页</a></li>";
                }
                $("#ul").html(ulstr);
            }
        });
    }
    loaddata(currrent, ps);
</script>
</body>

</html>
