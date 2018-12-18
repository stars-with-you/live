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
    <title>用户注册</title>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="format-detection" content="telephone=no" />
    <!-- iOS 图标 begin -->
    <link rel="apple-touch-icon-precomposed" href="/apple-touch-icon-57x57-precomposed.png" /> <!-- iPhone 和 iTouch，默认 57x57 像素，必须有 -->
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/apple-touch-icon-114x114-precomposed.png" /> <!-- Retina iPhone 和 Retina iTouch，114x114 像素，可以没有，但推荐有 -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/apple-touch-icon-144x144-precomposed.png" /> <!-- Retina iPad，144x144 像素，可以没有，但推荐有 -->
    <!-- iOS 图标 end -->
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

        if (openid == null || openid == "" || typeof (openid) == "undefined") {
            location.href = "<%=basePath%>wx/getcode?state=" + encodeURIComponent(encodeURIComponent(location.href)) + "&scope=snsapi_userinfo";
        }
    </script>
</head>
<body ontouchstart>
<div class="weui-cells weui-cells_form">

    <div class="weui-cell">
        <div class="weui-cell__hd"><label class="weui-label">登录帐号</label></div>
        <div class="weui-cell__bd">
            <input id="hidtzurl" type="hidden" value="${tzurl}">
            <input id="loginname" type="tel" class="weui-input" placeholder="请输入手机号">
        </div>
    </div>
    <div class="weui-cell">
        <div class="weui-cell__hd">
            <label class="weui-label">密码</label>
        </div>
        <div class="weui-cell__bd">
            <input id="loginpwd" type="password" class="weui-input" placeholder="请输入密码">
        </div>
    </div>
    <div class="weui-cell">
        <div class="weui-cell__hd">
            <label class="weui-label">公司名称</label>
        </div>
        <div class="weui-cell__bd">
            <input id="company" type="text" class="weui-input" placeholder="请输入公司名称">
        </div>
    </div>
    <%--<div class="weui-cell">--%>
        <%--<div class="weui-cell__hd"><label class="weui-label">验证码</label></div>--%>
        <%--<div class="weui-cell__bd">--%>
            <%--<input id="yzm" class="weui-input" type="text" placeholder="请输入验证码">--%>
        <%--</div>--%>
        <%--<div class="weui-cell__ft">--%>
            <%--<img id="imgCode" class="weui-vcode-img" style="width:120px;"--%>
                 <%--src="<%=basePath%>imagecode/create?createTypeFlag=n" onclick="changeImg('n')">--%>
        <%--</div>--%>
    <%--</div>--%>
</div>
<div class="weui-btn-area">
    <a id="areg" class="weui-btn weui-btn_primary" href="javascript:">注册</a>
</div>
<script src="<%=basePath%>js/jquery-weui/lib/fastclick.js"></script>
<script>
    $(function () {
        FastClick.attach(document.body);
    });

    //刷新验证码
    function changeImg(createTypeFlag) {
        document.getElementById("imgCode").src = "<%=basePath%>imagecode/create?createTypeFlag=" + createTypeFlag + "&" + Math.random();
    }
</script>
<script src="<%=basePath%>js/jquery-weui/js/jquery-weui.js"></script>
<script>
    $("#areg").click(function () {

        var p = /^1[34578]\d{9}$/;
        if (!p.test($("#loginname").val())) {
            $.toast("手机号不正确", "cancel");
            return;
        }
        if ($("#loginpwd").val() == "") {
            $.toast("请输入密码", "cancel");
            return;
        }
        if ($("#company").val() == "") {
            $.toast("请输入公司名称", "cancel");
            return;
        }
        // if ($("#yzm").val() == "") {
        //     $.toast("请输入验证码", "cancel");
        //     return;
        // }
        $.post("<%=basePath%>person/wx/add", {
            "loginname": $("#loginname").val(),
            "loginpwd": $("#loginpwd").val(),
            // "code": $("#txtcode").val(),
            "company":$("#company").val(),
            "openid": openid
        }, function (data, status) {
            if (status == "success") {
                if (data == "2") {
                    $.toast("验证码错误", "cancel");
                    return;
                }
                else {
                    if (data == "1") {
                        if ($("#hidtzurl").val() == "" || typeof ($("#hidtzurl").val()) == "undefined") {
                            location.href = "<%=basePath%>person/wx/detail";
                        }
                        else {
                            location.href = $("#hidtzurl").val();
                        }

                    } else {
                        $.toast("注册失败，登录出现异常", "cancel");
                    }
                }
            } else {
                    $.toast("网络异常，注册失败", "cancel");
            }
        });

    });
</script>
</body>
</html>
