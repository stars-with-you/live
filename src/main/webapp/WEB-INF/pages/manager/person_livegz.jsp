<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  User: fanglei
  Date: 2018-04-03
  Time: 11:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<jsp:include page="/WEB-INF/pages/master/headlayui.jsp"></jsp:include>
<style>
    .layui-card-body {
        padding: 5px 10px;
    }

    .cmdlist-container {
        background: rgb(255, 255, 255);
        border-width: 1px;
        border-style: solid;
        border-color: transparent;
        border-image: initial;
    }

    .cmdlist-text {
        padding: 5px;
    }

    .cmdlist-text .info {
        height: 40px;
        font-size: 14px;
        line-height: 20px;
        width: 100%;
        color: rgb(102, 102, 102);
        margin-bottom: 10px;
        overflow: hidden;
    }

    .cmdlist-text .time {
        height: auto;
        font-size: 14px;
        width: 100%;
        color: #c0c0c0;
    }

    .time span {
        padding-right: 20px;
    }

    .cmdlist-text .price {
        font-size: 14px;
    }

    .cmdlist-text .flow {
        text-align: right;
        float: right;
    }

    .listimg {
        width: 100%;
        height: 150px;
    }

    .icon {
        font-size: 14px;
        color: #c0c0c0;
        cursor: pointer;
    }

    .icon {
        width: 14px;
        height: 14px;
        vertical-align: -0.15em;
        fill: currentColor;
        overflow: hidden;
    }
</style>
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
<div class="layui-body">
    <div class="layui-card">
        <div class="layui-card-body">
            <div style="display: inline-block;">
                <div class="layui-input-inline">
                    <input name="txttitle" id="txttitle"
                           autocomplete="off" class="layui-input" type="text" placeholder="标题">
                </div>
            </div>

            <div class="layui-inline">
                <button class="layui-btn layui-btn-normal layui-btn-sm" id="btnSearch" onclick="reloadData();">查询信息
                </button>
            </div>
        </div>
    </div>
    <div class="layui-fluid layadmin-cmdlist-fluid">
        <%--layui-col-space30--%>
        <div class="layui-row layui-col-space18" id="divlist">

        </div>
    </div>
    <div class="layui-card" style="padding: 0;">
        <div class="layui-card-body" style="padding: 0;margin: 0;">
            <div id="divepage"></div>
        </div>
    </div>
</div>
<script src="<%=basePath%>js/jquery.form.js"></script>
<script>
    var cur = 1, ps = 8, totalcount = 0;
    var layer = null, myindex = 0, form = null, laypage = null;
    layui.use(['layer', 'laydate', 'element', 'form', 'laypage'], function () {
        var element = layui.element;
        layer = layui.layer;
        form = layui.form;
        laydate = layui.laydate;
        laypage = layui.laypage;
        //执行一个laypage实例
        laypage.render({
            elem: 'divepage' //注意，这里的 test1 是 ID，不用加 # 号
            , count: totalcount //数据总数，从服务端得到
            , limit: ps
            , prev: '上一页'
            , next: '下一页'
            , layout: ['prev', 'page', 'next', 'skip', 'count']
            , jump: function (obj, first) {
                //obj包含了当前分页的所有参数，比如：
                console.log(obj.curr); //得到当前页，以便向服务端请求对应页的数据。
                console.log(obj.limit); //得到每页显示的条数
                cur = obj.curr;
                //首次不执行
                if (!first) {
                    loaddata(obj.curr, ps);
                }
            }
        });

    });

    function reloadData() {
        loaddata(1, ps);
    }

    function loaddata(crp, ps) {
        $.ajax({
            url: "<%=basePath%>applive/datapersongz",
            type: "post",
            data: {"currentPage": crp, "pagesize": ps, "title": $("#txttitle").val()},
            dataType: "text",
            success: function (data) {
                var json = $.parseJSON(data).data;
                totalcount = parseInt($.parseJSON(data).count);
                var str = "";
                for (var i = 0; i < json.length; i++) {
                    str += '<div class="layui-col-xs6 layui-col-sm6 layui-col-md3">';
                    str += "<div class='cmdlist-container'>";
                    str += "<a target='_blank' href='<%=basePath%>show/zhibo/detail?lguid=" + json[i].lguid + "'>";
                    if(json[i].defaultpic==null ||json[i].defaultpic==""){
                        str += "<img class='listimg' src='<%=basePath%>upload/defaultpic/default.png'>";
                    }
                    else {
                        str += "<img class='listimg' src='<%=basePath%>" + json[i].defaultpic + "'>";
                    }
                    str += "</a>";
                    str += "<div class='cmdlist-text'>";
                    str += "<p class='info'>" + json[i].title + "</p>";
                    str += "<p class='time'>";
                    str += "<span  style='float:right;padding-right: 0;'><svg class=\"icon\" aria-hidden=\"true\"><use xlink:href=\"#icon-canyurenshu\"></use></svg>" +
                        "                    " + json[i].access + "";
                    str += "&nbsp;&nbsp;<svg class=\"icon\" aria-hidden=\"true\"><use xlink:href=\"#icon-dianzanshu\"></use></svg>" +
                        "                    " + json[i].zan + "</span>";
                    //str += "<span><svg class=\"icon\" aria-hidden=\"true\"><use xlink:href=\"#icon-pinglunshu\"></use></svg>" +
                    "                    1111";
                    str += "</span>";
                    str += "<span>" + new Date(json[i].updatetime.replace(/-/g,"/")).Format("yyyy-MM-dd hh:mm") + "</span></p>";
                    str += "<div class='price'><input type='button' onclick='qxgz(\"" + json[i].lguid + "\")' class='layui-btn layui-btn-normal layui-btn-sm' value='取消关注'/> ";
                    str += "</div>";
                    str += "</div>";

                    str += "</div>";
                    str += '</div>';
                }
                $("#divlist").html(str);
                laypage.render({
                    elem: 'divepage' //注意，这里的 test1 是 ID，不用加 # 号
                    , count: totalcount //数据总数，从服务端得到
                    , limit: ps
                    , curr: crp
                    , prev: '上一页'
                    , next: '下一页'
                    , layout: ['prev', 'page', 'next', 'skip', 'count']
                    , jump: function (obj, first) {
                        //obj包含了当前分页的所有参数，比如：
                        console.log(obj.curr); //得到当前页，以便向服务端请求对应页的数据。
                        console.log(obj.limit); //得到每页显示的条数
                        cur = obj.curr;
                        //首次不执行
                        if (!first) {
                            loaddata(obj.curr, ps);
                        }
                    }
                });

            }
        });

    }
    function  qxgz(lguid){
        layer.confirm('确定取消关注吗？', {icon: 3, title: '提示'}, function (index) {
            $.ajax({
                url: "<%=basePath%>attention/delete",
                type: "post",
                data: {"lguid": lguid},
                dataType: "text",
                success: function (data) {
                    if (data == "1") {
                        layer.msg('取消成功', {icon: 1, time: 2000});
                        loaddata(cur, ps);
                    }
                }
            });
            layer.close(index);
        });
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
    loaddata(cur, ps);
</script>
<jsp:include page="/WEB-INF/pages/master/footerlayui.jsp"></jsp:include>
