<%--
  User: fanglei
  Date: 2018-06-13
  Time: 17:15
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<html>
<head>
    <title>我的直播</title>
    <meta name="renderer" content="webkit">
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
        .weui-media-box__thumb {
            width: 60px;
            height: 60px;
        }

        .weui-swiped-btn {
            padding: 30px 10px;
        }

        .weui-cells {
            font-size: 14px;
        }

        .weui-btn-area {
            margin: 0;
            background-color: #fff;
            padding: 0;
        }

        .delweui {
            width: 20px;
            height: 20px;
            float: right;
            cursor: pointer;
            position: relative;
            top: -79px;
        }

        .delweui2 {
            width: 20px;
            height: 20px;
            float: right;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="page__bd">
    <div class="weui-panel weui-panel_access">
        <%--<div class="weui-panel__hd"><span>我的直播&nbsp;&nbsp;</span>|<span>&nbsp;&nbsp;被授权直播</span></div>--%>
        <div class="weui-panel__bd" id="divlist">
        </div>
        <div id="divloadmore" class="weui-loadmore">
            <i class="weui-loading"></i>
            <span class="weui-loadmore__tips">正在加载</span>
        </div>
        <c:choose>
            <c:when test="${sessionScope.auth=='1'}">
                <div id="divmore" class="weui-panel__ft"
                     style="color:#999;font-size: 13px;text-align: center;padding-bottom: 10px;">
                    <div class="button_sp_area">
                        <a href="javascript:;" class="weui-btn weui-btn_mini weui-btn_primary">查看更多</a>
                    </div>
                </div>
            </c:when>
        </c:choose>
    </div>
    <div class="weui-btn-area">
        <c:choose>
            <c:when test="${sessionScope.auth=='1'}">
                <a onclick="addlive();" class="weui-btn weui-btn_primary open-popup" href="javascript:">发布新直播</a>
            </c:when>
            <c:otherwise>
                <a class="weui-btn weui-btn_warn open-popup" href="javascript:">您没有发布直播的权限</a>
            </c:otherwise>
        </c:choose>
    </div>
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
        jsApiList: ['chooseImage', 'previewImage', 'uploadImage', 'downloadImage', 'getLocalImgData', 'hideMenuItems'] // 必填，需要使用的JS接口列表
    });
    wx.ready(function () {
        // config信息验证后会执行ready方法，所有接口调用都必须在config接口获得结果之后，config是一个客户端的异步操作，所以如果需要在页面加载时就调用相关接口，则须把相关接口放在ready函数中调用来确保正确执行。对于用户触发时才调用的接口，则可以直接调用，不需要放在ready函数中。
        // alert("success");
        wx.hideMenuItems({
            menuList: ['menuItem:share:appMessage', 'menuItem:share:timeline', 'menuItem:share:qq', 'menuItem:share:weiboApp', 'menuItem:share:facebook', 'menuItem:share:QZone', 'menuItem:copyUrl', 'menuItem:originPage', 'menuItem:openWithQQBrowser', 'menuItem:openWithSafari', 'menuItem:share:email'] // 要隐藏的菜单项，只能隐藏“传播类”和“保护类”按钮，所有menu项见附录3
        });
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

    function wxchooseImage2() {
        wx.chooseImage({
            count: 1, // 默认9
            sizeType: ['original', 'compressed'], // 可以指定是原图还是压缩图，默认二者都有
            sourceType: ['album', 'camera'], // 可以指定来源是相册还是相机，默认二者都有
            success: function (res) {
                // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
                asyncUpload2(res.localIds);
            }
        });
    }

    function asyncUpload(localIds) {
        var localId = localIds.pop();
        wx.uploadImage({
            localId: localId, // 需要上传的图片的本地ID，由chooseImage接口获得
            isShowProgressTips: 1, // 默认为1，显示进度提示
            success: function (resup) {
                var serverId = resup.serverId; // 返回图片的服务器端ID
                if (isAndroid()) {
                    var str = '<li class="weui-uploader__file" localId="' + localId + '"  serverId="' + serverId + '"  onclick="deladd(this)"  >';
                    str += '<img style="width:79px;height:79px;" src="' + localId + '"/>';
                    str += '<img title="删除" src="<%=basePath%>images/delet.png" class="delweui"/>';
                    str += '</li>';
                    $("#uploaderFiles").append(str);
                    if ($("#uploaderFiles li").length < 3) {
                        $("#sctp").show();
                    }
                    else {
                        $("#sctp").hide();
                    }
                }
                else {
                    wx.getLocalImgData({
                        localId: localId, // 图片的localID
                        success: function (reslocal) {
                            var localData = reslocal.localData; // localData是图片的base64数据，可以用img标签显示
                            var str = '<li class="weui-uploader__file"   localId="' + localData + '"   serverId="' + serverId + '"     style="background-image:url(' + localId + ')">';
                            str += '<img title="删除" src="<%=basePath%>images/delet.png" class="delweui"/>';
                            str += '</li>';
                            $("#uploaderFiles").append(str);
                        }
                    });
                }
                // if (localIds.length > 0) {
                //     asyncUpload(localIds);
                // }
            }
        });
    }

    function asyncUpload2(localIds) {
        var localId = localIds.pop();
        wx.uploadImage({
            localId: localId, // 需要上传的图片的本地ID，由chooseImage接口获得
            isShowProgressTips: 1, // 默认为1，显示进度提示
            success: function (resup) {
                var serverId = resup.serverId; // 返回图片的服务器端ID
                if (isAndroid()) {
                    var str = '<li class="weui-uploader__file" localId="' + localId + '"  serverId="' + serverId + '"  onclick="deladd(this)"  >';
                    str += '<img style="width:79px;height:79px;" src="' + localId + '"/>';
                    str += '</li>';
                    $("#uploaderqj").html(str);
                }
                else {
                }
            }
        });
    }

    //如果返回true 则说明是Android
    function isAndroid() {
        var ua = window.navigator.userAgent.toLowerCase();
        if (ua.match(/MicroMessenger/i) == 'micromessenger') {
            return true;
        } else {
            if (window.wxjs_is_wkwebview || window.wxjs_is_wkwebview == 'true') {
                return false;
            }
            else {
                return true;
            }
        }
    }
</script>
<script>
    var cur = 1, ps = 5;

    function loaddata(crp, ps) {
        $.ajax({
            url: "<%=basePath%>applive/dataperson",
            type: "post",
            data: {"currentPage": crp, "pagesize": ps},
            dataType: "text",
            success: function (data) {
                $("#divloadmore").hide();
                if (data != "") {
                    var d = $.parseJSON(data);
                    var json = d.data;
                    var count = d.count;
                    if (count > crp * ps) {
                        $("#divmore").show();
                    }
                    else {
                        $("#divmore").hide();
                    }
                    if (json.length > 0 && cur == 1) {
                        $("#divlist").html("");
                    }
                    for (var i = 0; i < json.length; i++) {
                        var str = "";
                        str += "<div class='weui-cell weui-cell_swiped'>";
                        str += "<div class='weui-cell__bd' >";
                        str += "<a href='<%=basePath%>applive/wxlive?lguid=" + json[i].lguid + "' class='weui-media-box weui-media-box_appmsg'>";
                        str += "<div class='weui-media-box__hd'>";
                        if (json[i].defaultpic == null || json[i].defaultpic == "") {
                            str += "<img class='weui-media-box__thumb' src='<%=basePath%>upload/defaultpic/default.png' alt=''>";
                        }
                        else {
                            str += "<img class='weui-media-box__thumb' src='<%=basePath%>" + json[i].defaultpic + "' alt=''>";
                        }
                        str += "</div>";
                        str += "<div class='weui-media-box__bd'>";
                        str += "<h4 class='weui-media-box__title'>";
                        str += json[i].title;
                        // str+="<span style='float:right;color:#999;font-size:13px;'>";
                        // str+=new Date(json[i].updatetime).Format("yyyy-MM-dd");
                        // str+="</span>";
                        str += "</h4>";
                        str += "<p class='weui-media-box__desc'>" + json[i].intro + "</p>";
                        str += "</div>";
                        str += "</a>";
                        str += "</div>";
                        str += "<div class='weui-cell__ft'>";
                        str += "<a class='weui-swiped-btn weui-swiped-btn_warn delete-swipeout' href='javascript:' onclick='dellive(\"" + json[i].lguid + "\")'>删除</a>";
                        str += "<a class='weui-swiped-btn weui-swiped-btn_default close-swipeout' href='javascript:' onclick='editlive(\"" + json[i].lguid + "\")'>编辑</a>";
                        str += "</div>";
                        str += "</div>";
                        $("#divlist").append(str);
                    }
                    $('.weui-cell_swiped').swipeout();
                    if (json.length < 1) {
                        $("#divlist").html('<div id="divnodata2" class="weui-loadmore weui-loadmore_line"><span class="weui-loadmore__tips">暂无数据</span></div>');
                    }
                }
                else {
                    $("#divlist").html('<div id="divnodata2" class="weui-loadmore weui-loadmore_line"><span class="weui-loadmore__tips">暂无数据</span></div>');
                    $("#divmore").hide();
                }
            }
        });
    }

    /**
     * 删除一条直播信息
     * @param lguid
     */
    function dellive(lguid) {
        $.confirm("确定删除吗", function () {
            $.ajax({
                url: "<%=basePath%>applive/delbylguid",
                type: "post",
                data: {"lguid": lguid},
                dataType: "text",
                success: function (data) {
                    if (data == "1") {
                        $.toast("删除成功");
                        ///
                        cur = 1;
                        loaddata(cur, ps);
                    }
                    else {
                        $.toast("删除失败", "cancel");
                    }
                }
            });
        });
    }

    /**
     *显示直播添加页面
     */
    function addlive() {
        $("#hidlguid").val("");

        $("#uploaderFiles").html("");
        $('#txttitle').val("");
        $("#txtsponsor").val("");
        $("#txtcbf").val("");
        $("#txtzcdw").val("");
        $('#txtplace').val("");
        $('#txtdescription').val("");
        $("#txtkstime").val("");
        $("#txtjstime").val("");
        $("#txtaccess").val("0");
        $("#txtzan").val("0");
        $("#txtqjurl").val("");
        $("#uploaderqj").html("");
        $("#iscomment").prop("checked", true);
        $("#ispublic").prop("checked", true);
        $("#sctp").show();
        $("#divlive").popup();
    }

    /**
     * 显示直播修改页面
     * @param lguid
     */
    function editlive(lguid) {

        $.post("<%=basePath%>applive/getsingle", {"lguid": lguid}, function (data, status) {
                if (status == "success") {
                    if (data != "") {
                        var json = $.parseJSON(data);
                        $("#hidlguid").val(json.lguid);

                        $('#txttitle').val(json.title);
                        $("#txtsponsor").val(json.sponsor);
                        $("#txtcbf").val(json.cbf);
                        $("#txtzcdw").val(json.zcdw);
                        $('#txtplace').val(json.place);
                        $('#txtdescription').val(json.intro);
                        $('#txtqjurl').val(json.qjurl);
                        //
                        var str = '<li class="weui-uploader__file" onclick="deladd(this)"  style="background-image:url(<%=basePath%>' + json.zbewm + ')">';
                        str += '</li>';
                        $("#uploaderqj").html(str);
                        $("#txtkstime").val(new Date(json.startdate.replace(/-/g, "/")).Format("yyyy-MM-dd hh:mm"));
                        $("#txtjstime").val(new Date(json.enddate.replace(/-/g, "/")).Format("yyyy-MM-dd hh:mm"));
                        if (json.access != null && json.access != "") {
                            $("#txtaccess").val(json.access);
                        }
                        else {
                            $("#txtaccess").val("0");
                        }
                        if (json.zan != null && json.zan != "") {
                            $("#txtzan").val(json.zan);
                        }
                        else {
                            $("#txtzan").val("0");
                        }

                        if (json.iscomment == "1") {
                            $("#iscomment").prop("checked", true);
                        }
                        else {
                            $("#iscomment").prop("checked", false);
                        }
                        if (json.ispublic == "1") {
                            $("#ispublic").prop("checked", true);
                        }
                        else {
                            $("#ispublic").prop("checked", false);
                        }
                        getlogo(lguid);
                        $("#divlive").popup();
                    }
                }
            }
        );
    }

    function getlogo(lguid) {
        $.post("<%=basePath%>livelogo/data", {"lguid": lguid}, function (data, status) {
            if (status == "success") {
                if (data != "") {
                    var json = $.parseJSON(data);
                    if (json.length > 0) {
                        $("#uploaderFiles").html("");
                        var str = "";
                        for (var i = 0; i < json.length; i++) {
                            str += '<li class="weui-uploader__file" logoid="' + json[i].logoid + '"  onclick="filedel(this,\'' + json[i].logoid + '\')" style="background-image:url(<%=basePath%>' + json[i].defaultpic + ')">';
                            str += '<img title="删除" src="<%=basePath%>images/delet.png" class="delweui2"/>';
                            str += '</li>';
                        }
                        $("#uploaderFiles").html(str);
                        if ($("#uploaderFiles li").length < 3) {
                            $("#sctp").show();
                        }
                        else {
                            $("#sctp").hide();
                        }
                    }
                    else {
                    }
                }
                else {
                    $("#sctp").show();
                }
            }
        });
    }

    function filedel(e, logoid) {
        $.confirm("确定删除吗", function () {
            $.ajax({
                url: "<%=basePath%>livelogo/delbylogoid",
                type: "post",
                data: {"logoid": logoid},
                dataType: "text",
                success: function (data) {
                    if (data == "1") {
                        $(e).remove();
                        if ($("#uploaderFiles li").length < 3) {
                            $("#sctp").show();
                        }
                        else {
                            $("#sctp").hide();
                        }
                    }
                    else {
                        $.toast('删除失败', "cancel");
                    }
                }
            });
        });
    }

    function deladd(e) {
        $.confirm("确定删除吗", function () {
            $(e).remove();
        });
    }

    $(function () {
        //初始化直播列表
        loaddata(cur, ps);
        $("#txtkstime").datetimePicker();
        $("#txtjstime").datetimePicker();
        //加载更多直播信息
        $("#divmore").click(function () {
            $("#divloadmore").show();
            cur = cur + 1;
            loaddata(cur, ps);
        });
        //发布直播
        $("#afb").click(function () {
            var e = $("#uploaderFiles li");
            var localid = "";
            if (e.length > 0) {
                for (var i = 0; i < e.length; i++) {
                    if (typeof ($(e[i]).attr("serverId")) == "undefined" || $(e[i]).attr("serverId") == null || $(e[i]).attr("serverId") == "") {
                    }
                    else {
                        localid += ($(e[i]).attr("serverId") + ";");
                    }
                }
            }
            var zbewmstr = "";
            var up = $("#uploaderqj li");
            if (up.length > 0) {
                zbewmstr = $(up[0]).attr("serverId");
            }
            var posturl = "<%=basePath%>applive/wx/add";
            if ($("#hidlguid").val() != "") {
                posturl = "<%=basePath%>applive/wx/update";
            }

            if ($("#txttitle").val() == "") {
                $.toast("标题不能为空", "cancel");
                return;
            }
            if ($("#txtsponsor").val() == "") {
                $.toast("主办方不能为空", "cancel");
                return;
            }

            if ($("#txtplace").val() == "") {
                $.toast("地点不能为空", "cancel");
                return;
            }
            if ($("#txtkstime").val() == "") {
                $.toast("开始时间不能为空", "cancel");
                return;
            }
            if ($("#txtjstime").val() == "") {
                $.toast("结束时间不能为空", "cancel");
                return;
            }
            if ($("#txtdescription").val() == "") {
                $.toast("简介不能为空", "cancel");
                return;
            }
            var sz = /^[0-9]*$/;
            if (!sz.test($("#txtaccess").val())) {
                $.toast("访问量格式不对", "cancel");
                return;
            }
            if (!sz.test($("#txtzan").val())) {
                $.toast("点赞数格式不正对", "cancel");
                return;
            }
            var iscomment = "0";
            if ($("#iscomment").is(":checked")) {
                iscomment = "1";
            }
            var ispublic = "0";
            if ($("#ispublic").is(":checked")) {
                ispublic = "1";
            }
            $.ajax({
                url: posturl,
                type: "post",
                data: {
                    "lguid": $("#hidlguid").val(),
                    "title": $("#txttitle").val(),
                    "sponsor": $("#txtsponsor").val(),
                    "cbf": $("#txtcbf").val(),
                    "zcdw": $("#txtzcdw").val(),
                    "startdate": $("#txtkstime").val(),
                    "enddate": $("#txtjstime").val(),
                    "place": $("#txtplace").val(),
                    "intro": $("#txtdescription").val(),
                    "access": $("#txtaccess").val(),
                    "zan": $("#txtzan").val(),
                    "iscomment": iscomment,
                    "ispublic": ispublic,
                    "localid": localid,
                    "zbewmstr": zbewmstr,
                    "qjurl": $("#txtqjurl").val()
                },
                dataType: "text",
                success: function (data) {
                    if (data == "1") {
                        $.toast("保存成功");
                        cur = 1;
                        loaddata(cur, ps);
                        $.closePopup();
                    }
                    else {
                        if (data == "3") {
                            $.toast("您没有发布直播的权限!", "cancel");
                        }
                        else {
                            $.toast("保存失败", "cancel");
                        }
                    }

                }
            });
        });
    });
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
</script>
<div id="divlive" class="weui-popup__container " style="overflow: auto;">
    <div class="weui-popup__overlay"></div>
    <div class="weui-popup__modal">
        <div class="weui-cells weui-cells_form">
            <div class="weui-cell">
                <div class="weui-cell__hd">
                    <label class="weui-label">宣传图片</label>
                </div>
                <div class="weui-cell__bd">
                    <div class="weui-uploader">
                        <div class="weui-uploader__bd">
                            <ul class="weui-uploader__files" id="uploaderFiles">
                            </ul>
                            <div id="sctp" class="weui-uploader__input-box" onclick="wxchooseImage()">
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
                        <label class="weui-label">直播标题<span
                                style="color:#f43530;vertical-align: middle;">*</span></label>
                    </div>
                    <div class="weui-cell__bd">
                        <input type="hidden" id="hidlguid">
                        <input id="txttitle" class="weui-input" type="text"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">主办方<span
                                style="color:#f43530;vertical-align: middle;">*</span></label>
                    </div>
                    <div class="weui-cell__bd">
                        <input id="txtsponsor" class="weui-input" type="text"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">活动地点<span
                                style="color:#f43530;vertical-align: middle;">*</span></label>
                    </div>
                    <div class="weui-cell__bd">
                        <input id="txtplace" class="weui-input" type="text"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">简介<span
                                style="color:#f43530;vertical-align: middle;">*</span></label>
                    </div>
                    <div class="weui-cell__bd">
                        <textarea id="txtdescription" class="weui-input" style="height: 80px;"
                        ></textarea>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cell">
                <div class="weui-cell__hd"><label for="txtkstime" class="weui-label">开始时间<span
                        style="color:#f43530;vertical-align: middle;">*</span></label></div>
                <div class="weui-cell__bd">
                    <input class="weui-input" id="txtkstime" type="text">
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cell">
                <div class="weui-cell__hd">
                    <label for="txtjstime" class="weui-label">结束时间<span
                            style="color:#f43530;vertical-align: middle;">*</span></label>
                </div>
                <div class="weui-cell__bd">
                    <input class="weui-input" id="txtjstime" type="text">
                </div>
            </div>
        </div>

        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">承办方</label>
                    </div>
                    <div class="weui-cell__bd">
                        <input id="txtcbf" class="weui-input" type="text"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">支持单位</label>
                    </div>
                    <div class="weui-cell__bd">
                        <input id="txtzcdw" class="weui-input" type="text"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">访问量</label>
                    </div>
                    <div class="weui-cell__bd">
                        <input id="txtaccess" class="weui-input" type="text" value="0"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">720全景</label>
                    </div>
                    <div class="weui-cell__bd">
                        <div class="weui-uploader">
                            <div class="weui-uploader__bd">
                                <ul class="weui-uploader__files" id="uploaderqj">
                                </ul>
                                <div class="weui-uploader__input-box" onclick="wxchooseImage2()">
                                </div>
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
                        <label class="weui-label">全景地址</label>
                    </div>
                    <div class="weui-cell__bd">
                        <input id="txtqjurl" class="weui-input" type="text"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">点赞量</label>
                    </div>
                    <div class="weui-cell__bd">
                        <input id="txtzan" class="weui-input" type="text" value="0"></input>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell weui-cell_switch">
                    <div class="weui-cell__bd">是否可以评论</div>
                    <div class="weui-cell__ft">
                        <label for="iscomment" class="weui-switch-cp">
                            <input id="iscomment" class="weui-switch-cp__input" type="checkbox" checked="checked">
                            <div class="weui-switch-cp__box"></div>
                        </label>
                    </div>
                </div>
            </div>
        </div>
        <div class="weui-cells weui-cells_form">
            <div class="weui-cells">
                <div class="weui-cell weui-cell_switch">
                    <div class="weui-cell__bd">推荐到首页</div>
                    <div class="weui-cell__ft">
                        <label for="ispublic" class="weui-switch-cp">
                            <input id="ispublic" class="weui-switch-cp__input" type="checkbox" checked="checked">
                            <div class="weui-switch-cp__box"></div>
                        </label>
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
