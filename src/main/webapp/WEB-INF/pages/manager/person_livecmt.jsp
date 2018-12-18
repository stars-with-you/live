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

    .layuiadmin-card-status {
        padding: 0 10px 10px;
    }

    #cmtlist .nokg {
        margin: 0;
        padding: 0;
    }

    #cmtlist .cmthead {
        width: 79px;
        height: 79px;
        margin-left: 20px;
        vertical-align: text-bottom;
    }

    #cmtlist .cmtms {
        display: inline-block;
        width: 570px;
        height: 79px;
        overflow:auto;
    }

    .time {
        float: right;
    }
</style>
<svg aria-hidden="true" style="position: absolute; width: 0px; height: 0px; overflow: hidden;">
</svg>
<div class="layui-body">

    <div class="layui-card">
    <div class="layui-card-header">
        <h2>评论列表</h2>
    </div>
        <div class="layui-card-body" style="width:700px;padding: 15px 20px">
            <ul id="cmtlist">

            </ul>
            <div id="divepage"></div>
        </div>
    </div>
</div>
<script src="<%=basePath%>js/jquery.form.js"></script>
<script>
    var cur = 1, ps =4, totalcount = 0;
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
            url: "<%=basePath%>applive/cmt/persondata",
            type: "post",
            data: {"currentPage": crp, "pagesize": ps},
            dataType: "text",
            success: function (data) {
                var json = $.parseJSON(data).data;
                totalcount = parseInt($.parseJSON(data).count);
                var str = "";
                for (var i = 0; i < json.length; i++) {
                    str += "<li>";
                    str += "<p>"+((crp-1)*ps+i+1)+"、"+json[i].comment+"</p>";
                    str += "<span style='padding-left: 20px;'>"+json[i].createtime+"<a href='javascript:;' class='layui-btn layui-btn-danger layui-btn-xs time' onclick='del(\""+json[i].cguid+"\")'>删除</a></span>";
                    str += "<div class='nokg'>";
                    if(json[i].openid==null ||json[i].openid==""){
                        str += "<img src='<%=basePath%>upload/defaultpic/default.png' class='cmthead'>";
                    }
                    else {
                        str += "<img src='<%=basePath%>"+json[i].openid+"' class='cmthead'>";
                    }

                    str += "<div class='cmtms'>";
                    str += json[i].ip;
                    str += "</div>";
                    str += "</div>";
                    str += "</li>";
                }
                $("#cmtlist").html(str);
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


    function del(cguid) {
        layer.confirm('确定删除吗?', {icon: 3, title: '提示'}, function (index) {
            //do something
            $.ajax({
                url: "<%=basePath%>applive/cmt/deletebycguid",
                type: "post",
                data: {"cguid": cguid},
                dataType: "text",
                success: function (data) {
                    if (data == "1") {
                        layer.msg('删除成功', {icon: 1, time: 2000});
                        loaddata(cur, ps);
                    }
                    else {
                        layer.msg('删除失败', {icon: 2, time: 2000});
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
