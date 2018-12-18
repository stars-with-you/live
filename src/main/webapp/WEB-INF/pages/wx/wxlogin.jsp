<%--
  User: fanglei
  Date: 2018-04-20
  Time: 15:41
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
    <title>用户登录</title>
    <!-- 字体编码 -->
    <meta charset="utf-8"/>
    <!-- 关键字 -->
    <meta name="keywords" content=""/>
    <!-- 说明 -->
    <meta name="description" content=""/>
    <!-- 作者 -->
    <meta name="author" content=""/>
    <!-- 设置文档宽度、是否缩放 -->
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no"/>
    <!-- 优先使用IE最新版本或chrome -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <!-- 360读取到这个标签立即钱换到极速模式 -->
    <meta name="renderer" content="webkit"/>
    <!-- 禁止百度转码 -->
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <!-- UC强制竖屏 -->
    <meta name="screen-orientation" content="portrait"/>
    <!-- QQ强制竖屏 -->
    <meta name="x5-orientation" content="portrait"/>
    <!-- UC强制全屏 -->
    <meta name="full-scerrn" content="yes"/>
    <!-- QQ强制全屏 -->
    <meta name="x5-fullscreen" content="ture"/>
    <!-- QQ应用模式 -->
    <meta name="x5-page-mode" content="app"/>
    <!-- UC应用模式 -->
    <meta name="browsermode" content="application">
    <!-- window phone 点亮无高光 -->
    <meta name="msapplication-tap-highlight" content="no"/>
    <!-- 安卓设备不自动识别邮件地址 -->
    <meta name="format-detection" name="email=no"/>
    <!-- iOS设备 -->
    <!-- 添加到主屏幕的标题 -->
    <meta name="apple-mobile-web-app-title" content="标题"/>
    <!-- 是否启用webApp全屏 -->
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <!-- 设置状态栏的背景颜色，启用webapp模式时生效 -->
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent/black/default"/>
    <!-- 半透明/黑色/默认白色 -->
    <!-- 禁止数字识别为电话号码 -->
    <meta name="format-detection" content="telephone=no"/>
    <link rel="stylesheet" href="<%=basePath%>js/jquery-weui/lib/weui.min.css">
    <link rel="stylesheet" href="<%=basePath%>js/jquery-weui/css/jquery-weui.min.css">
    <script src="<%=basePath%>js/jquery-1.12.4.js"></script>
    <script>
        function GetQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]);
            return null;
        }
        var openid = GetQueryString("openid");
        // if (openid == null || openid == "" || typeof (openid) == "undefined") {
        //     openid = "orGIBs5GACV62VlBw6QWnG0MRR3I";
        // }
        if (openid == null || openid == "" || typeof (openid) == "undefined") {
            location.href = "<%=basePath%>wx/getcode?state=" + encodeURIComponent(encodeURIComponent(location.href)) + "&scope=snsapi_userinfo";
        }
    </script>
</head>
<body ontouchstart>
<header>
    <h1 style="text-align: center;">用户登录</h1>
</header>
<div class="weui-cells weui-cells_form">
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">登录帐号</label></div>
        <div class="weui-cell__bd">
            <input id="hidtzurl" type="hidden" value="${tzurl}">
            <input id="txtloginname" type="tel" class="weui-input" placeholder="请输入手机号码">
        </div>
    </div>
    <div class="weui-cell">
        <div class="weui-cell__hd">
            <label class="weui-label">密码</label>
        </div>
        <div class="weui-cell__bd">
            <input id="txtloginpwd" type="password" class="weui-input" placeholder="请输入密码">
        </div>
    </div>
    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">验证码</label></div>
        <div class="weui-cell__bd">
            <input id="txtcode" class="weui-input" type="text" placeholder="请输入验证码">
        </div>
        <div class="weui-cell__ft">
            <img id="imgCode" class="weui-vcode-img" style="width:120px;"
                 src="<%=basePath%>imagecode/create?createTypeFlag=n" onclick="changeImg('n')">
        </div>
    </div>
</div>
<div class="weui-btn-area">
    <a id="btnLogin" class="weui-btn weui-btn_primary" href="#">用户登录</a>
</div>
<script src="<%=basePath%>js/jquery-weui/lib/fastclick.js"></script>
<script>
    $(function () {
        FastClick.attach(document.body);
    });
</script>
<script src="<%=basePath%>js/jquery-weui/js/jquery-weui.js"></script>
<script src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
<script>
    //刷新验证码
    function changeImg(createTypeFlag) {
        document.getElementById("imgCode").src = "<%=basePath%>imagecode/create?createTypeFlag=" + createTypeFlag + "&" + Math.random();
    }
    $(function () {
        $("#btnLogin").click(function () {
            if ($("#txtloginname").val() == "") {
                $.toast("请输入用户名", "cancel");
                return;
            }
            if ($("#txtloginpwd").val() == "") {
                $.toast("请输入密码", "cancel");
                return;
            }
            if ($("#txtloginpwd").val() == "") {
                $.toast("请输入验证码", "cancel");
                return;
            }
            $.post("<%=basePath%>person/startlogin", {
                "loginname": $("#txtloginname").val(),
                "loginpwd": $("#txtloginpwd").val(),
                "code": $("#txtcode").val(),
                "openid":openid
            }, function (data, status) {
                if (status == "success") {
                    if (data == "2") {
                        $.toast("验证码错误", "cancel");
                        return;
                    }
                    else {
                        if (data == "1") {
                            if($("#hidtzurl").val()=="" || typeof ($("#hidtzurl").val()) == "undefined")
                            {
                                location.href = "<%=basePath%>person/wx/detail";
                            }
                            else {
                                location.href = $("#hidtzurl").val();
                            }

                        } else {
                            if (data == "0") {
                                $.toast("登录失败，帐号或密码错误", "cancel");
                            } else {
                                $.toast("登录失败，登录出现异常", "cancel");
                            }
                        }
                    }
                } else {
                    $.toast("网络异常，登录失败", "cancel");
                }
            });
        });
    });
    document.onkeydown = function (event_e) {
        if (window.event)
            event_e = window.event;
        var int_keycode = event_e.charCode || event_e.keyCode;
        if (int_keycode == 13) {
            $('#btnLogin').click();
        }
    };
</script>
</body>
</html>
