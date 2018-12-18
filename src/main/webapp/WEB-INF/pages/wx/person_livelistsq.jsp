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
    <title>被授权的直播</title>
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
</div>
<script src="<%=basePath%>js/jquery-weui/lib/fastclick.js"></script>
<script>
    $(function () {
        FastClick.attach(document.body);
    });
</script>
<script src="<%=basePath%>js/jquery-weui/js/jquery-weui.js"></script>
<script>
    var cur = 1, ps = 5;
    function loaddata(crp, ps) {
        $.ajax({
            url: "<%=basePath%>applive/datapersonsq",
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
                        str += "<div class='weui-cell'>";
                        str += "<div class='weui-cell__bd' >";
                        str += "<a href='<%=basePath%>applive/wxlive?lguid=" + json[i].lguid + "' class='weui-media-box weui-media-box_appmsg'>";
                        str += "<div class='weui-media-box__hd'>";
                        str += "<img class='weui-media-box__thumb' src='<%=basePath%>" + json[i].defaultpic + "' alt=''>";
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
                        str += "</div>";
                        $("#divlist").append(str);
                    }
                    if (json.length < 1) {
                        $("#divlist").html('<div id="divnodata2" class="weui-loadmore weui-loadmore_line"><span class="weui-loadmore__tips">暂无数据</span></div>');
                    }
                }
                else{
                    $("#divmore").hide();
                    $("#divlist").html('<div id="divnodata2" class="weui-loadmore weui-loadmore_line"><span class="weui-loadmore__tips">暂无数据</span></div>');
                }
            }
        });
    }




    $(function () {
        //初始化直播列表
        loaddata(cur, ps);
        //加载更多直播信息
        $("#divmore").click(function () {
            $("#divloadmore").show();
            cur = cur + 1;
            loaddata(cur, ps);
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
</body>
</html>
