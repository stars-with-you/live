<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
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
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/alert/dialog.css"/>
    <style>
        .login {
            width: 400px;
            height: auto;
            background: #fff;
            padding: 40px 50px;
            border-radius: 5px;
            position: absolute;
            top: 18%;
            left: 50%;
            margin: 0px 0px 0px -250px;
        }

        .login-logo {
            width: 400px;
            height: 40px;
            margin: 0px auto 20px auto;
            font-size: 30px;
            line-height: 40px;
            text-align: center;
            color: #1e9fff;
        }

        .login-box input {
            height: 40px;
            margin: 10px 0;
        }
    </style>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.12.4.min.js"></script>
    <script>
        //刷新验证码
        function changeImg(createTypeFlag) {
            document.getElementById("imgCode").src = "<%=basePath%>yzm/create?createTypeFlag=" + createTypeFlag + "&" + Math.random();
        }
        $(function () {
            $("#btnLogin").click(function () {
                if($("#txtloginname").val()==""){
                    alert("请输入用户名");
                    return ;
                }
                if($("#txtloginpwd").val()==""){
                    alert("请输入密码");
                    return ;
                }
                $.post("<%=basePath%>manager/startlogin", {
                    "loginname": $("#txtloginname").val(),
                    "loginpwd": $("#txtloginpwd").val(),
                    "code": $("#txtcode").val()
                }, function (data, status) {
                    if (status == "success") {
                        if (data == "2") {
                            alert("验证码错误");
                            return;
                        }
                        else {
                            if (data == "1") {
                                location.href = "<%=basePath%>person/detail";
                            } else {
                                if (data == "0") {
                                    alert("登录失败，帐号或密码错误");
                                } else {
                                    alert(data);
                                    alert("登录失败，登录出现异常");
                                }
                            }
                        }
                    } else {
                        alert("网络异常，登录失败");
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
        function reg() {
            var popUp = document.getElementById("popupcontent");
            popUp.style.visibility = "visible";
        }
        function closeReg() {
            document.getElementById('popupcontent').style.visibility='hidden';
        }
    </script>
</head>

<body style="background:url(<%=basePath%>images/400095057.jpg) no-repeat; background-size:cover;">
<div id="popupcontent" class="c_alert_dialog" >
    <div class="c_alert_mask" onclick="closeReg();"></div>
    <div class="c_alert_width">
        <div class="c_alert_con"><img src="<%=basePath%>images/reg.png" width="100%">
        </div>
        <div class="c_alert_btn"><a href="javascript:;" data-name="关闭" onclick="closeReg();">关闭</a></div>
    </div>
</div>
<div class="login">
    <%--科美智能科技管理系统--%>
    <div class="login-logo" ><img src="<%=basePath%>images/index_PC_01.png" style="vertical-align:middle;border: none;margin: 0;"/>&nbsp;&nbsp;金茂图文直播会员登录</div>
    <div class="login-box">
        <input id="txtloginname" type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入手机号"
               class="layui-input"
               style="float:left; background:url(<%=basePath%>images/icon1.png) 10px 10px no-repeat #fff; text-indent:30px;">
        <input id="txtloginpwd" type="password" name="title" lay-verify="title" autocomplete="off" placeholder="请输入密码"
               class="layui-input"
               style="float:left; background:url(<%=basePath%>images/icon2.png) 10px 10px no-repeat #fff; text-indent:30px;">
        <input id="txtcode" type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入验证码"
               class="layui-input"
               style="width:238px; float:left; margin-right:20px; background:url(<%=basePath%>images/icon3.png) 10px 10px no-repeat #fff; text-indent:30px;">
        <img id="imgCode" style="vertical-align: text-top;width:100px;height:50px;line-height:50px;cursor:pointer;border: none;"
            src="<%=basePath%>yzm/create?createTypeFlag=n" onclick="changeImg('n')" title="点击刷新验证码"></img>
        <button id="btnLogin" class="layui-btn  layui-btn-normal"
                style="width:100%; height:40px;  margin-top:10px; font-size:16px; ">登 录
        </button>
        <a style="float: right;cursor: pointer;text-decoration: underline;" href="javascript:;"  onclick="reg();">会员注册</a>
    </div>
</div>
</body>
</html>

