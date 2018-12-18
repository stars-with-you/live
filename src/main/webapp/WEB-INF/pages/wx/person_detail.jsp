<%--
  User: fanglei
  Date: 2018-04-20
  Time: 15:41
--%>
<%@ page import="com.fl.common.CommonHelpConstants" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    String mybasePath = request.getScheme() + "://"
            + request.getServerName()
            + path + "/";
%>
<html>
<head>
    <title>个人中心</title>
    <meta charset="utf-8"/>
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
    <style>
        .div {
            vertical-align: middle;
            text-align: center;
        }

        .arrow {
            padding-right: 13px;
            position: relative;
            text-align: right;
            color: #999;
            cursor: pointer;
        }

        .arrow:after {
            content: " ";
            display: inline-block;
            height: 6px;
            width: 6px;
            border-width: 2px 2px 0 0;
            border-color: #c8c8cd;
            border-style: solid;
            -webkit-transform: matrix(.71, .71, -.71, .71, 0, 0);
            transform: matrix(.71, .71, -.71, .71, 0, 0);
            position: relative;
            top: -2px;
            position: absolute;
            top: 50%;
            margin-top: -4px;
            right: 2px;
        }

        .weui-form-preview__item {
            border-bottom: #ddd 1px solid;
            line-height: 40px;
            height: 40px;
        }

        .weui-form-preview__label {
            color: #000;
        }

        .weui-cells {
            font-size: 14px;
        }
    </style>
</head>
<body ontouchstart>
<div class="weui-form-preview">
    <%--<div class="weui-form-preview__hd">--%>
    <%--<label class="weui-form-preview__label">付款金额</label>--%>
    <%--<em class="weui-form-preview__value">¥2400.00</em>--%>
    <%--</div>--%>
    <div class="weui-form-preview__bd">
        <div class="weui-form-preview__item" style="line-height: 79px;height: 79px;">
            <label class="weui-form-preview__label">头像</label>
            <span class="weui-form-preview__value"> <img id="imglogo"
                                                         style="height: 79px;width:79px; vertical-align: middle;"
                                                         src="${user.logo}"></span>
        </div>
        <div class="weui-form-preview__item">
            <label class="weui-form-preview__label">昵称</label>
            <span id="spdisplayname" class="weui-form-preview__value">${user.displayname}</span>
        </div>
        <div class="weui-form-preview__item">
            <label class="weui-form-preview__label">手机号</label>
            <span id="sploginname" class="weui-form-preview__value">${user.loginname}</span>
        </div>
        <div class="weui-form-preview__item">
            <label class="weui-form-preview__label">邮箱</label>
            <span id="spemail" class="weui-form-preview__value">${user.email}</span>
        </div>
        <div class="weui-form-preview__item">
            <label class="weui-form-preview__label">身份证号</label>
            <span id="spsfz" class="weui-form-preview__value">${user.sfz}</span>
        </div>
        <div class="weui-form-preview__item">
            <label class="weui-form-preview__label">单位名称</label>
            <span id="spcompany" class="weui-form-preview__value">${user.company}</span>
        </div>
        <div class="weui-form-preview__item" onclick="gotolive()">
            <label class="weui-form-preview__label">我的直播</label>
            <span class="weui-form-preview__value">
<a href="#" class="arrow"></a>
            </span>
        </div>
        <div class="weui-form-preview__item" onclick="gotolivesq()">
            <label class="weui-form-preview__label">被授权直播</label>
            <span class="weui-form-preview__value">
<a href="#" class="arrow"></a>
            </span>
        </div>
        <div class="weui-form-preview__item" onclick="gotolivegz()">
            <label class="weui-form-preview__label">我的关注</label>
            <span class="weui-form-preview__value">
<a href="#" class="arrow"></a>
            </span>
        </div>
    </div>
    <div class="weui-btn-area">
        <a id="areg" class="weui-btn weui-btn_primary open-popup" data-target="#divlive" href="javascript:">编辑个人资料</a>
    </div>
    <%--<div class="weui-form-preview__ft">--%>
    <%--<a class="weui-form-preview__btn weui-form-preview__btn_default" href="javascript:">辅助操作</a>--%>
    <%--<button type="submit" class="weui-form-preview__btn weui-form-preview__btn_primary" href="javascript:">操作--%>
    <%--</button>--%>
    <%--</div>--%>
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
    wx.config({
        debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
        appId: '${appid}', // 必填，公众号的唯一标识
        timestamp: '${timestamp}', // 必填，生成签名的时间戳
        nonceStr: '${noncestr}', // 必填，生成签名的随机串
        signature: '${signature}',// 必填，签名
        jsApiList: ['chooseImage', 'previewImage', 'uploadImage', 'downloadImage', 'getLocalImgData','hideMenuItems'] // 必填，需要使用的JS接口列表
    });
    wx.ready(function () {
        // config信息验证后会执行ready方法，所有接口调用都必须在config接口获得结果之后，config是一个客户端的异步操作，所以如果需要在页面加载时就调用相关接口，则须把相关接口放在ready函数中调用来确保正确执行。对于用户触发时才调用的接口，则可以直接调用，不需要放在ready函数中。
        // alert("success");
        wx.hideMenuItems({
            menuList: ['menuItem:share:appMessage','menuItem:share:timeline','menuItem:share:qq','menuItem:share:weiboApp','menuItem:share:facebook','menuItem:share:QZone','menuItem:copyUrl','menuItem:originPage','menuItem:openWithQQBrowser','menuItem:openWithSafari','menuItem:share:email'] // 要隐藏的菜单项，只能隐藏“传播类”和“保护类”按钮，所有menu项见附录3
        });
        //
    });
    wx.error(function (res) {
        // config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
        alert("微信接口调用失败");
    });

    function wxchooseImage() {
        wx.chooseImage({
            count: 1, // 默认9
            sizeType: ['original', 'compressed'], // 可以指定是原图还是压缩图，默认二者都有
            sourceType: ['album', 'camera'], // 可以指定来源是相册还是相机，默认二者都有
            success: function (res) {
                // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
                asyncUpload(res.localIds);
            }
        });
    }

    function asyncUpload(localIds) {
        var localId = localIds.pop();
        wx.uploadImage({
            localId: localId, // 需要上传的图片的本地ID，由chooseImage接口获得
            isShowProgressTips: 1, // 默认为1，显示进度提示
            success: function (resup) {
                $("#tbodypreview").hide();

                var serverId = resup.serverId; // 返回图片的服务器端ID
                if (isAndroid()) {
                    var str = '<li class="weui-uploader__file" localId="' + localId + '"  serverId="' + serverId + '"   >';
                    //style="background-image:url(' + localId + ')"
                    str+='<img style="width:79px;height:79px;" src="' + localId + '"/>';
                    str+='</li>';
                    $("#uploaderFiles").html(str);
                }
                else {
                    wx.getLocalImgData({
                        localId: localId, // 图片的localID
                        success: function (reslocal) {
                            var localData = reslocal.localData; // localData是图片的base64数据，可以用img标签显示
                            var str = '<li class="weui-uploader__file"  localId="' + localData + '"   serverId="' + serverId + '"     style="background-image:url(' + localData + ')"></li>';
                            $("#uploaderFiles").html(str);
                        }
                    });
                }
                // if (localIds.length > 0) {
                //     asyncUpload(localIds);
                // }
            }
        });
    }

    //如果返回true 则说明是Android
    function isAndroid() {
        var ua = window.navigator.userAgent.toLowerCase();
        if (ua.match(/MicroMessenger/i) == 'micromessenger') {
            return true;
        } else {
            if (window.wxjs_is_wkwebview || window.wxjs_is_wkwebview=='true') {
                return false;
            }
            else {
                return true;
            }
        }
    }
</script>
<script>
    function gotolive() {
        location.href = "<%=mybasePath%>person/wx/livelist";
    }
    function gotolivesq() {
        location.href = "<%=mybasePath%>person/wx/livelistsq";
    }
    function gotolivegz() {
        location.href = "<%=mybasePath%>person/wx/livelistgz";
    }
    $(function () {
        $("#afb").click(function () {
            var e = $("#uploaderFiles li");
            var localid = "";
            var imgurl = "";
            if (e.length > 0) {
                localid = $(e[0]).attr("serverId");
                imgurl = $(e[0]).attr("localId");
            }
            if ($("#txtdisplayname").val() != "") {
                if ($("#txtdisplayname").val().length > 15) {
                    $.toast("昵称应小于15个字符", "cancel");
                    return;
                }
            }
            else {
                $.toast("请填写昵称", "cancel");
                return;
            }
            if ($("#txtloginname").val() != "") {
                var p = /^1[34578]\d{9}$/;
                if (!p.test($("#txtloginname").val())) {
                    $.toast("手机号不正确", "cancel");
                    return;
                }
            }
            else {
                $.toast("请填写手机号", "cancel");
                return;
            }
            if ($("#txtemail").val() != "") {
                //Email正则
                var p = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
                if (!p.test($("#txtemail").val())) {
                    $.toast("邮箱不正确", "cancel");
                    return;
                }
            }
            if ($("#txtsfz").val() != "") {
                var p = /^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/;
                if (!p.test($("#txtsfz").val())) {
                    $.toast("身份证不正确", "cancel");
                    return;
                }
            }
            $.ajax({
                url: "<%=basePath%>person/wx/update",
                type: "post",
                data: {
                    "pguid": $("#hidpguid").val(),
                    "loginname": $("#txtloginname").val(),
                    "displayname": $("#txtdisplayname").val(),
                    "email": $("#txtemail").val(),
                    "sfz": $("#txtsfz").val(),
                    "company": $("#txtcompany").val(),
                    "localid": localid
                },
                dataType: "text",
                success: function (data) {
                    if (data == "1") {
                        $.toast("保存成功");
                        $("#sploginname").text($("#txtloginname").val());
                        $("#spdisplayname").text($("#txtdisplayname").val());
                        $("#spemail").text($("#txtemail").val());
                        $("#spsfz").text($("#txtsfz").val());
                        $("#spcompany").text($("#txtcompany").val());
                        if (imgurl != "") {
                            $("#imglogo").attr("src", imgurl);
                        }
                        $.closePopup();
                    }
                    else {
                        $.toast("保存失败", "cancel");
                    }
                }
            });
        });
    });
</script>

<div id="divlive" class="weui-popup__container popup-bottom">
    <div class="weui-popup__overlay"></div>
    <div class="weui-popup__modal">
        <div class="weui-cells weui-cells_form">
            <div class="weui-cell">
                <div class="weui-cell__hd">
                    <label class="weui-label">头像<span style="color:#f43530;vertical-align: middle;">*</span></label>
                </div>
                <div class="weui-cell__bd">
                    <div class="weui-uploader">
                        <div class="weui-uploader__bd">
                            <ul class="weui-uploader__files" id="tbodypreview">
                                <li class="weui-uploader__file">
                                    <img style="height: 79px;width:79px; vertical-align: middle;"
                                         src="${user.logo}">
                                </li>
                            </ul>
                            <ul class="weui-uploader__files" id="uploaderFiles">
                            </ul>
                            <div class="weui-uploader__input-box" onclick="wxchooseImage()">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">昵称(姓名)<span
                                style="color:#f43530;vertical-align: middle;">*</span></label>
                    </div>
                    <div class="weui-cell__bd">
                        <input type="hidden" id="hidpguid" value="${user.pguid}">
                        <input id="txtdisplayname" class="weui-input" type="text"
                               value="${user.displayname}"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">手机号<span
                                style="color:#f43530;vertical-align: middle;">*</span></label>
                    </div>
                    <div class="weui-cell__bd">
                        <input id="txtloginname" class="weui-input" type="text"
                               value="${user.loginname}"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">邮箱</label>
                    </div>
                    <div class="weui-cell__bd">
                        <input id="txtemail" class="weui-input" type="text" value="${user.email}"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">身份证号</label>
                    </div>
                    <div class="weui-cell__bd">
                        <input id="txtsfz" class="weui-input" type="text" value="${user.sfz}"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">单位名称</label>
                    </div>
                    <div class="weui-cell__bd">
                        <input id="txtcompany" class="weui-input" type="text" value="${user.company}"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell" style="padding: 0;">
                    <div class="weui-cell__hd" style="text-align: center;width:100%;padding-top: 0;">
                        <a class="weui-btn weui-btn_mini weui-btn_primary" href="javascript:" id="afb">保存</a>
                        <a class="weui-btn weui-btn_mini weui-btn_primary  close-popup" data-target="#divlive"
                           href="javascript:">取消</a>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
