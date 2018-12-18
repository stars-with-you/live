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
<link rel="stylesheet" href="<%=basePath%>js/jquery-weui/lib/weui.min.css">
<link rel="stylesheet" href="<%=basePath%>js/jquery-weui/css/jquery-weui.min.css">
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

    .delweui {
        width: 20px;
        height: 20px;
        float: right;
        cursor: pointer;
    }
</style>
<table id="tablesq" class="layui-table" style="display: none;padding: 0;margin: 0;">
    <tr>
        <td>手机号:</td>
        <td>
            <input type="hidden" id="txtauthlguid"/>
            <input id="txtauthtel" name="title" class="layui-input" type="text" lay-verify="required"
                   lay-verType="tips"></input>

        </td>
        <td>
            <button class="layui-btn layui-btn-normal " onclick="authadd()">授权</button>
        </td>
    </tr>
    <tbody id="tbodysq">

    </tbody>
</table>
<form id="myform" class="layui-form" lay-filter="form" enctype="multipart/form-data">
    <table id="tableax" class="layui-table" style="display: none;padding: 0;margin: 0;">
        <tr>
            <td>标题<span style="color:#FF0000;">*</span>:</td>
            <td colspan="3"><input id="listlist_hidlguid" type="hidden" name="lguid" value="${lguid}"/>
                <input id="livelist_hidcata" type="hidden" value="${cata }" name="cata"/>
                <input id="livelist_txttitle" name="title" class="layui-input" type="text" lay-verify="required"
                       lay-verType="tips"></input></td>
            <td>主办方<span style="color:#FF0000;">*</span>:</td>
            <td><input type="text" class="layui-input" id="livelist_txtsponsor" name="sponsor" lay-verify="required"
                       lay-verType="tips"></input>
            </td>
        </tr>
        <tr>
            <td>承办方:</td>
            <td colspan="3"><input id="livelist_txtcbf" name="cbf" class="layui-input"></input>
            </td>
            <td>支持单位:</td>
            <td><input type="text" class="layui-input" id="livelist_txtzcdw" name="zcdw"></input>
            </td>
        </tr>
        <tr>
            <td>简介<span style="color:#FF0000;">*</span>:</td>
            <td colspan="3"><textarea id="livelist_txtintro" name="intro" class="layui-textarea" lay-verify="required"
                                      lay-verType="tips" style="height: 60px;"></textarea>
            </td>
            <td>地点<span style="color:#FF0000;">*</span>:</td>
            <td><input type="text" class="layui-input" id="livelist_txtplace" name="place" lay-verify="required"
                       lay-verType="tips"></input>
            </td>
        </tr>
        <tr>
            <td>开始日期<span style="color:#FF0000;">*</span>:</td>
            <td><input type="text" class="layui-input" id="livelist_txtstartdate" name="startdate" lay-verify="required"
                       lay-verType="tips"></input>
            </td>
            <td>结束日期<span style="color:#FF0000;">*</span>:</td>
            <td><input type="text" class="layui-input" id="livelist_txtenddate" name="enddate" lay-verify="required"
                       lay-verType="tips"></input>
            </td>
            <%--<td>操作员授权数量:</td>--%>
            <%--<td>--%>
            <%--<input type="text" class="layui-input" id="livelist_txtauthcount" name="authcount"--%>
            <%--lay-verify="required|number"--%>
            <%--lay-verType="tips"></input>--%>
            <%--</td>--%>
        </tr>
        <tr>
            <td>访问量<span style="color:#FF0000;">*</span>:</td>
            <td><input type="text" class="layui-input" id="livelist_txtaccess" name="access" value="0"
                       lay-verify="required|number"
                       lay-verType="tips"></input>
            </td>
            <td>点赞数<span style="color:#FF0000;">*</span>:</td>
            <td><input type="text" class="layui-input" id="livelist_txtzan" name="zan" lay-verify="required|number" value="0"
                       lay-verType="tips"></input>
            </td>
            <td>直播方式:</td>
            <td>
                <input type="radio" name="zbfs" value="1" title="图文">
                <input type="radio" name="zbfs" value="2" title="图片">
                <input type="radio" name="zbfs" value="3" title="视频">
            </td>
        </tr>
        <tr>
            <td>标题图片:</td>
            <td colspan="3" style="padding: 0;">
                <%--<input id="picfile" type="file" name="picfile" style="width:180px;">--%>
                <%--<img id="imgpicfile" style="width:100px;height:100px;display: none;">--%>
                <div class="weui-uploader">
                    <div class="weui-uploader__bd">
                        <ul class="weui-uploader__files" id="uploaderFiles">
                        </ul>
                        <div id="sctp" class="weui-uploader__input-box" onclick="upload();">
                        </div>
                        <input id="uploaderInput" name="picfile" class="weui-uploader__input"
                               type="file" accept="image/*" multiple="" style="display: none;">
                    </div>
                </div>
            </td>
            <td>链接二维码:</td>
            <td style="padding: 0;">
                <img id="imgpicewm" style="width:100px;height:100px;display: none;">
            </td>
        </tr>
        <tr>
            <td>全景:</td>
            <td style="padding: 0;">
                <input id="zbewmfile" type="file" name="zbewmfile" style="width:180px;">
                <img id="imgzbewmfile" style="width:100px;height:100px;display: none;">
            </td>
            <td>全景地址:</td>
            <td colspan="3">
                <input id="txtqjurl" type="text" class="layui-input" name="qjurl">
            </td>
        </tr>
        <tr>
            <td style="width:100px;">推荐到首页:<br/>(<span style="color:red;">推荐后,系统将进行审核,审核通过后将在首页显示此条直播</span>)</td>
            <td>
                <input type="radio" name="ispublic" value="1" title="推荐">
                <input type="radio" name="ispublic" value="0" title="不推荐">
            </td>
            <%--<td>是否发布:</td>--%>
            <%--<td>--%>
            <%--<input type="radio" name="yxbz" value="1" title="发布">--%>
            <%--<input type="radio" name="yxbz" value="0" title="不发布">--%>
            <%--</td>--%>
            <td>是否可以评论:</td>
            <td>
                <input type="radio" name="iscomment" value="1" title="可以">
                <input type="radio" name="iscomment" value="0" title="不可以">
            </td>
        </tr>
        <tr id="livelist_trupdatetime">
            <td>修改时间:</td>
            <td><input id="livelist_txtupdatetime" class="layui-input" name="updatetime"></td>
        </tr>
        <tr>
            <td colspan="6" style="text-align: center;">
                <button id="livelist_btnadd" class="layui-btn layui-btn-normal" lay-submit lay-filter="liveadd">保存
                </button>
                <button id="livelist_btnupdate" class="layui-btn layui-btn-normal" lay-submit lay-filter="liveup">修改
                </button>
                <button type="button" class="layui-btn  layui-btn-normal" onclick="closeW();">取消</button>
            </td>
        </tr>
    </table>
</form>
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
            <c:if test="${sessionScope.auth=='1'}">
                <button type="button" class="layui-btn  layui-btn-normal  layui-btn-sm" onclick="addData();"
                        style="margin-right: 20px;">+ 新增
                </button>
            </c:if>

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
        form.on('submit(liveadd)', function (data) {
            liveadd();
            return false;
        });
        form.on('submit(liveup)', function (data) {
            liveup();
            return false;
        });
        //日期
        laydate.render({
            elem: '#livelist_txtupdatetime',
            type: 'datetime'
        });
        laydate.render({
            elem: '#livelist_txtstartdate',
            type: 'datetime'
        });
        laydate.render({
            elem: '#livelist_txtenddate',
            type: 'datetime'
        });
    });

    function reloadData() {
        loaddata(1, ps);
    }

    function loaddata(crp, ps) {
        $.ajax({
            url: "<%=basePath%>applive/dataperson",
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
                    str += "<a target='_blank' href='<%=basePath%>person/livedetail?lguid=" + json[i].lguid + "'>";
                    if (json[i].defaultpic == null || json[i].defaultpic == "") {
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
                    str += "<span>" + new Date(json[i].updatetime.replace(/-/g, "/")).Format("yyyy-MM-dd hh:mm") + "</span></p>";
                    str += "<div class='price'><input type='button' onclick='edit(\"" + json[i].lguid + "\")' class='layui-btn layui-btn-normal layui-btn-sm' value='编辑'/> ";
                    str += "<input type='button' onclick='authshow(\"" + json[i].lguid + "\")' class='layui-btn layui-btn-normal layui-btn-sm' value='授权'/> ";
                    str += "<input type='button' onclick='exportWord(\"" + json[i].lguid + "\")' class='layui-btn layui-btn-normal layui-btn-sm' value='导出'/> ";
                    str += "<span class='flow'><input type='button'  onclick='del(\"" + json[i].lguid + "\")' class='layui-btn layui-btn-danger layui-btn-sm' value='删除'/></span>";
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

    //弹出添加信息窗口
    function addData() {
        $("#listlist_hidlguid").val(guid());
        $("#livelist_txttitle").val("");//标题
        $("#livelist_txtsponsor").val("");//主办方
        $("#livelist_txtcbf").val("");
        $("#livelist_txtzcdw").val("");
        $("#livelist_txtplace").val("");//地点
        $("#livelist_txtintro").val("");//简介
        $("#livelist_txtstartdate").val("");//开始日期
        $("#livelist_txtenddate").val("");//结束日期
        $("#livelist_txtaccess").val("0");//访问量
        $("#livelist_txtzan").val("0");//点赞数
        //$("#picfile").val("");//直播题图
        $("#zbewmfile").val("");//
        // $("#imgpicfile").hide();
        $("#uploaderFiles").html("");
        $("#sctp").show();
        $("#imgpicewm").hide();
        $("#imgzbewmfile").hide();
        $("#txtqjurl").val("");//主办方
        $("#livelist_txtauthcount").val("");//操作员数量
        $("#livelist_txtupdatetime").val("");//修改时间
        $("#livelist_trupdatetime").hide();
        $(":radio[name='ispublic'][value='0']").prop("checked", "true");
        $(":radio[name='yxbz'][value='1']").prop("checked", "true");
        $(":radio[name='zbfs'][value='1']").prop("checked", "true");
        $(":radio[name='iscomment'][value='1']").prop("checked", "true");
        $("#livelist_btnadd").show();
        $("#livelist_btnupdate").hide();
        form.render('radio');
        myindex = layer.open({
            type: 1,
            zIndex: 10000,
            title: '信息添加',
            area: ['1200px', '700px'],
            content: $("#tableax")
        });
    }

    //增加一条信息
    function liveadd() {
        $("#myform").ajaxForm(function () {
        });
        $("#myform").ajaxSubmit({
            type: "POST",
            url: "<%=basePath%>applive/add",
            dataType: "text",
            error: function (jqXHR, textStatus, errorThrown) {
                layer.msg('网络问题导致添加信息失败', {icon: 2, time: 2000});
            },
            success: function (data) {
                if (data == "1") {
                    layer.msg('添加成功', {icon: 1, time: 2000});
                    loaddata(1, ps);
                    layer.close(myindex);
                } else {
                    if (data == "2") {
                        layer.msg('添加失败', {icon: 2, time: 2000});
                    } else {
                        layer.msg(data, {icon: 2, time: 20000});
                    }
                }
            }
        });
        return false;
    }

    function edit(lguid) {
        $.post("<%=basePath%>applive/getsingle", {"lguid": lguid}, function (data, status) {
            if (status == "success") {
                if (data != "") {
                    var json = $.parseJSON(data);
                    $("#listlist_hidlguid").val(json.lguid);
                    $('#livelist_txttitle').val(json.title);
                    $("#livelist_txtsponsor").val(json.sponsor);
                    $('#livelist_txtcbf').val(json.cbf);
                    $('#livelist_txtzcdw').val(json.zcdw);
                    $('#livelist_txtplace').val(json.place);
                    $('#livelist_txtintro').val(json.intro);
                    $("#livelist_txtstartdate").val(json.startdate);
                    $("#livelist_txtenddate").val(json.enddate);
                    $("#livelist_txtaccess").val(json.access);
                    $("#livelist_txtzan").val(json.zan);
                    $("#livelist_txtauthcount").val(json.authcount);
                    $("#txtqjurl").val(json.qjurl);
                    $(":radio[name='ispublic'][value='" + json.ispublic + "']").prop("checked", "true");
                    $(":radio[name='yxbz'][value='" + json.yxbz + "']").prop("checked", "true");
                    $("#livelist_txtupdatetime").val(json.updatetime);
                    $("#livelist_trupdatetime").show();
                    $(":radio[name='zbfs'][value='" + json.zbfs + "']").prop("checked", "true");
                    $(":radio[name='iscomment'][value='" + json.iscomment + "']").prop("checked", "true");
                    form.render('radio');
                    //$("#picfile").val("");//直播题图
                    $("#zbewmfile").val("");//直播
                    <%--if (typeof (json.defaultpic) != 'undefined' && json.defaultpic != null && json.defaultpic != "") {--%>
                    <%--$("#imgpicfile").prop("src", "<%=basePath%>" + json.defaultpic);--%>
                    <%--$("#imgpicfile").show();--%>
                    <%--}--%>
                    getlogo(lguid);
                    if (typeof(json.zbewm) != 'undefined' && json.zbewm != null && json.zbewm != "") {
                        $("#imgzbewmfile").prop("src", "<%=basePath%>" + json.zbewm);
                        $("#imgzbewmfile").show();
                    }
                    else {
                        $("#imgzbewmfile").hide();
                    }
                    if (json.ewm == null || json.ewm == "") {
                        $("#imgpicewm").hide();
                    }
                    else {
                        $("#imgpicewm").show();
                        $("#imgpicewm").prop("src", "<%=basePath%>" + json.ewm);
                    }
                    $("#livelist_btnadd").hide();
                    $("#livelist_btnupdate").show();

                } else {
                    layer.msg('数据库中没有这条信息', {icon: 2, time: 2000});
                }
                myindex = layer.open({
                    type: 1,
                    title: '信息修改',
                    zIndex: 10000,
                    area: ['1200px', '750px'],
                    content: $("#tableax")
                });
            }
        });
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
                            str += '<img title="删除" src="<%=basePath%>images/delet.png" class="delweui"/>';
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
                        $("#uploaderFiles").html("");
                    }
                }
                else {
                    $("#sctp").show();
                }
            }
        });
    }

    //弹出修改信息窗口
    function liveup() {
        if ($("#livelist_txtupdatetime").val() == "") {
            layer.tips('修改时间不能为空', '#livelist_txtupdatetime', {
                tips: 1
            });
            return;
        }
        $("#myform").ajaxForm(function () {
        });
        $("#myform").ajaxSubmit({
            type: "POST",
            url: "<%=basePath%>applive/update",
            dataType: "text",
            error: function (jqXHR, textStatus, errorThrown) {
                layer.msg('网络问题导致添加信息失败', {icon: 2, time: 2000});
            },
            success: function (data) {
                if (data == "1") {
                    layer.msg('修改成功', {icon: 1, time: 2000});
                    loaddata(cur, ps);
                    layer.close(myindex);
                } else {
                    if (data == "2") {
                        layer.msg('修改失败', {icon: 2, time: 2000});
                    } else {
                        layer.msg(data, {icon: 2, time: 20000});
                    }
                }
            }
        });
        return false;
    }

    function del(lguid) {
        layer.confirm('确定删除吗?', {icon: 3, title: '提示'}, function (index) {
            //do something
            $.ajax({
                url: "<%=basePath%>applive/delbylguid",
                type: "post",
                data: {"lguid": lguid},
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

    function exportWord(lguid) {
        layer.confirm('确定导出吗?', {icon: 3, title: '提示'}, function (index) {

            location.href = "<%=basePath%>applive/wordexport?lguid=" + lguid;
            layer.close(index);
        });

    }

    function authshow(lguid) {
        $.post("<%=basePath%>applive/auth/data", {
            "lguid": lguid,
            "currentPage": 1,
            "pagesize": 100
        }, function (data, status) {
            if (status == "success") {
                if (data != "") {
                    var json = $.parseJSON(data);
                    var jd = json.data;
                    $("#tbodysq").html("");
                    if (jd.length > 0) {
                        var jdstr = "";
                        for (var i = 0; i < jd.length; i++) {
                            jdstr += "<tr><td>已授权帐号</td><td>";
                            jdstr += jd[i].pguid;
                            jdstr += "</td><td>";
                            jdstr += "<a class=\"layui-btn layui-btn-danger layui-btn-xs\" onclick='authdelete(this,\"" + jd[i].auguid + "\")'>删除</a>";
                            jdstr += "</td></tr>";
                        }
                        $("#tbodysq").html(jdstr);
                    }

                }
                $("#txtauthtel").val("");
                $("#txtauthlguid").val(lguid);
                myindex = layer.open({
                    type: 1,
                    title: '信息授权',
                    zIndex: 10000,
                    area: ['600px', '600px'],
                    content: $("#tablesq")
                });
            }
        });
    }

    /**
     * 增加一条授权信息
     */
    function authadd() {
        if ($("#txtauthtel").val() == "") {
            layer.msg('授权手机号不能为空', {icon: 2, time: 2000});
            return;
        }
        $.ajax({
            url: "<%=basePath%>applive/auth/add",
            type: "post",
            data: {"lguid": $("#txtauthlguid").val(), "pguid": $("#txtauthtel").val()},
            dataType: "text",
            success: function (data) {
                if (data == "1") {
                    layer.msg('添加成功', {icon: 1, time: 2000});
                    layer.close(myindex);
                }
                else {
                    layer.msg('添加失败', {icon: 2, time: 2000});
                }
            }
        });
    }

    /**
     * 删除一条授权信息
     */
    function authdelete(e, auguid) {
        layer.confirm('确定删除？', function (index) {
            //obj.del(); //删除对应行（tr）的DOM结构
            layer.close(index);
            //向服务端发送删除指令
            $.ajax({
                url: "<%=basePath%>applive/auth/deletebyauguid",
                type: "post",
                data: {"auguid": auguid},
                dataType: "text",
                success: function (data) {
                    if (data == "1") {
                        $(e).parent().parent().remove();
                        layer.msg('删除成功', {icon: 1, time: 2000});
                    }
                    else {
                        layer.msg('删除失败', {icon: 2, time: 2000});
                    }
                }
            });
        });

    }

    function upload() {
        $("#uploaderInput").click();
        $("#uploaderInput").unbind().change(function () {
            $("#myform").ajaxForm({url: '<%=basePath%>livelogo/fileadd'}, function () {
            });
            $("#myform").ajaxSubmit({
                url: '<%=basePath%>livelogo/fileadd',
                dataType: "text",
                method: 'POST',
                data: {},
                error: function (jqXHR, textStatus, errorThrown) {
                    layer.msg('网络问题导致添加信息失败' + errorThrown, {icon: 2, time: 2000});
                },
                success: function (data) {
                    if (data != "0") {
                        var json = $.parseJSON(data);
                        if (json.bz == "1") {
                            var rst = json.rst;
                            var str = '<li class="weui-uploader__file" logoid="' + rst.logoid + '"  onclick="filedel(this,\'' + rst.logoid + '\')" style="background-image:url(<%=basePath%>' + rst.defaultpic + ')">';
                            str += '<img title="删除" src="<%=basePath%>images/delet.png" class="delweui"/>';
                            str += '</li>';
                            $("#uploaderFiles").append(str);
                            $("#uploaderInput").val("");
                            if ($("#uploaderFiles li").length < 3) {
                                $("#sctp").show();
                            }
                            else {
                                $("#sctp").hide();
                            }
                        }
                    } else {
                        layer.msg('添加失败', {icon: 2, time: 2000});
                    }
                },
                beforeSubmit: function (formData, jqForm, options) {
                    //formData: 数组对象，提交表单时，Form插件会以Ajax方式自动提交这些数据，格式如：[{name:user,value:val },{name:pwd,value:pwd}]
                    //jqForm:   jQuery对象，封装了表单的元素
                    //options:  options对象

                }
            });
            return false;
        })
    }

    function filedel(e, logoid) {
        layer.confirm('确定删除？', function (index) {
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
                        layer.msg('删除失败', {icon: 2, time: 2000});
                    }
                }
            });
            layer.close(index);
        });
    }

    function guid() {
        function S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }

        return (S4() + S4() + S4() + S4() + S4() + S4() + S4() + S4());
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

    function closeW() {
        layer.close(myindex);
    }

    loaddata(cur, ps);
</script>
<jsp:include page="/WEB-INF/pages/master/footerlayui.jsp"></jsp:include>
