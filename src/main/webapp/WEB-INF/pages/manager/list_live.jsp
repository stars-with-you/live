<%--
  Created: 方磊
  Date: 2018年3月16日  下午3:14:18
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<jsp:include page="/WEB-INF/pages/master/headlayui.jsp"></jsp:include>
<link rel="stylesheet" href="<%=basePath%>js/jquery-weui/lib/weui.min.css">
<link rel="stylesheet" href="<%=basePath%>js/jquery-weui/css/jquery-weui.min.css">
<style>
    #tableax td:first-child {
        text-align: right;
    }

    .layui-input {
        height: 30px;
    }
    .delweui{
        width: 20px; height: 20px; float:right;cursor:pointer;
    }
</style>
<table id="tablesq" class="layui-table" style="display: none;padding: 0;margin: 0;">
    <tr>
        <td>手机号:</td>
        <td>
            <input type="hidden" id="txtauthlguid" />
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
            <td>标题:</td>
            <td colspan="3"><input id="listlist_hidlguid" type="hidden" name="lguid"/>
                <input id="livelist_hidcata" type="hidden" value="${cata }" name="cata"/>
                <input id="livelist_txttitle" name="title" class="layui-input" type="text" lay-verify="required"
                       lay-verType="tips"></input></td>
            <td>主办方:</td>
            <td><input type="text" class="layui-input" id="livelist_txtsponsor" name="sponsor" lay-verify="required"
                       lay-verType="tips"></input>
            </td>
        </tr>
        <tr>
            <td>承办方:</td>
            <td colspan="3"><input id="livelist_txtcbf" name="cbf" class="layui-input"  ></input>
            </td>
            <td>支持单位:</td>
            <td><input type="text" class="layui-input" id="livelist_txtzcdw" name="zcdw" ></input>
            </td>
        </tr>
        <tr>
            <td>简介:</td>
            <td colspan="3"><textarea id="livelist_txtintro" name="intro" class="layui-textarea" lay-verify="required"
                                      lay-verType="tips" style="height: 60px;"></textarea>
            </td>
            <td>地点:</td>
            <td><input type="text" class="layui-input" id="livelist_txtplace" name="place" lay-verify="required"
                       lay-verType="tips"></input>
            </td>
        </tr>
        <tr>
            <td>开始日期:</td>
            <td><input type="text" class="layui-input" id="livelist_txtstartdate" name="startdate" lay-verify="required"
                       lay-verType="tips"></input>
            </td>
            <td>结束日期:</td>
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
            <td>访问量:</td>
            <td><input type="text" class="layui-input" id="livelist_txtaccess" name="access"
                       lay-verify="required|number"
                       lay-verType="tips"></input>
            </td>
            <td>点赞数:</td>
            <td><input type="text" class="layui-input" id="livelist_txtzan" name="zan" lay-verify="required|number"
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
                        <div  id="sctp" class="weui-uploader__input-box" onclick="upload();">
                        </div>
                        <input id="uploaderInput" name="picfile" class="weui-uploader__input"
                               type="file" accept="image/*" multiple="" style="display: none;">
                    </div>
                </div>
            </td>

            <td>直播链接地址二维码:</td>
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
                <input id="txtqjurl" type="text"  class="layui-input"  name="qjurl" >
            </td>
        </tr>
        <tr>
            <td style="width:100px;">推荐到首页:<br/>(<span style="color:red;">推荐后,系统将进行审核,审核通过后将在首页显示此条直播</span>)</td>
            <td>
                <input type="radio" name="ispublic" value="1" title="推荐">
                <input type="radio" name="ispublic" value="0" title="不推荐">
            </td>
            <td>首页推荐审核:</td>
            <td>
                <input type="radio" name="ishome" value="1" title="通过">
                <input type="radio" name="ishome" value="0" title="不通过">
            </td>
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
                <button id="livelist_btnadd" class="layui-btn layui-btn-normal" lay-submit lay-filter="liveadd">保存</button>
                <button id="livelist_btnupdate" class="layui-btn layui-btn-normal" lay-submit lay-filter="liveup">修改</button>
                <button type="button" class="layui-btn  layui-btn-normal" onclick="closeW();">取消</button>
            </td>
        </tr>
    </table>
</form>
<div class="layui-body">
    <!-- 内容主体区域 -->
    <div class="layui-card">
        <div class="layui-card-header">
            <h2>直播列表</h2>
        </div>
        <div class="layui-card-body">
                <button class="layui-btn layui-btn-normal  layui-btn-sm" id="btnAdd" onclick="addData();">+ 添加信息</button>
            <div style="display: inline-block;">
                <label>标题</label>
                <div class="layui-input-inline">
                    <input name="txttitle" id="txttitle"
                           autocomplete="off" class="layui-input" type="text">
                </div>
            </div>
            <div style="display: inline-block;">
                <label>创建人帐号</label>
                <div class="layui-input-inline">
                    <input id="txtphone" autocomplete="off" class="layui-input" type="text">
                </div>
            </div>
            <div style="display: inline-block;">
                <button class="layui-btn layui-btn-normal  layui-btn-sm" id="btnSearch" onclick="reloadData();">查询信息</button>
            </div>
        <table class="layui-hide" id="test" lay-filter="test"></table>
        <script type="text/html" id="barDemo">
            <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
            <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
            <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="auth">授权</a>
            <a class="layui-btn layui-btn-normal layui-btn-xs"
               href="<%=basePath%>applive/cmt/list?lguid={{d.lguid}}">评论管理</a>
            <a class="layui-btn layui-btn-normal layui-btn-xs"
               href="<%=basePath%>applive/detail/list?lguid={{d.lguid}}">详情管理</a>
        </script>
    </div>
</div>
</div>
<script src="<%=basePath%>js/jquery.form.js"></script>
<script>
    var tableIns = null, layer = null, form = null;
    layui.use(['table', 'layer', 'laydate', 'element', 'form'], function () {
        var table = layui.table, laydate = layui.laydate, element = layui.element;
        layer = layui.layer;
        form = layui.form;
        //第一个实例
        tableIns = table.render({
            elem: '#test'
            , url: '<%=basePath%>applive/data',
            request: {
                pageName: 'currentPage' //页码的参数名称，默认：page
                ,
                limitName: 'pagesize' //每页数据量的参数名，默认：limit
            },
            where: {
                cata: $('#livelist_hidcata').val()
            },
            method: 'post',
            page: {} //开启分页
            ,
            cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            ,
            cols: [[{
                field: 'title',
                title: '标题'
            }, {
                field: 'sponsor',
                title: '主办方'
            }
            , {
                field: 'ispublic',
                title: '推荐到首页',
                width: 100,
                templet: function (d) {
                    if (d.ispublic == "1" && d.ishome == "1" ) {
                        return "<span style='color:red;'>已推荐</span>";
                    }
                    else {
                        return "未推荐";
                    }
                }
            }
            , {
                field: 'pguid',
                title: '创建人帐号'
            }, {
                field: 'updatetime',
                title: '操作时间'
            }, {
                fixed: 'right',
                width: 300,
                align: 'center',
                toolbar: '#barDemo',
                title: '操作'
            }]]
        });
        //监听工具条
        table.on('tool(test)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
                var trdata = obj.data //获得当前行数据
                    , layEvent = obj.event; //获得 lay-event 对应的值
                if (layEvent === 'del') {
                    layer.confirm('真的删除行么', function (index) {
                        //obj.del(); //删除对应行（tr）的DOM结构
                        layer.close(index);
                        //向服务端发送删除指令
                        $.ajax({
                            url: "<%=basePath%>applive/delbylguid",
                            type: "post",
                            data: {"lguid": trdata.lguid},
                            dataType: "text",
                            success: function (data) {
                                if (data == "1") {
                                    reloadData();
                                }
                            }
                        });
                    });
                } else {
                    if (layEvent === 'edit') {
                        $.post("<%=basePath%>applive/getsingle", {"lguid": trdata.lguid}, function (data, status) {
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
                                    if(json.ishome=="1") {
                                        $(":radio[name='ishome'][value='1']").prop("checked", "true");
                                    }
                                    else{
                                        $(":radio[name='ishome'][value='0']").prop("checked", "true");
                                    }
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
                                    getlogo(trdata.lguid);
                                    if (typeof(json.zbewm) != 'undefined' && json.zbewm != null && json.zbewm != "") {
                                        $("#imgzbewmfile").prop("src", "<%=basePath%>" + json.zbewm);
                                        $("#imgzbewmfile").show();
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
                    else {
                        if (layEvent === 'auth') {
                            $.post("<%=basePath%>applive/auth/data", {"lguid": trdata.lguid,"currentPage":1, "pagesize":100}, function (data, status) {
                                if (status == "success") {
                                    if (data != "") {
                                        var json = $.parseJSON(data);
                                        var jd=json.data;
                                        $("#tbodysq").html("");
                                        if(jd.length>0){
                                            var jdstr="";
                                            for (var i = 0; i <jd.length ; i++) {
                                                jdstr+="<tr><td>已授权帐号</td><td>";
                                                jdstr+=jd[i].pguid;
                                                jdstr+="</td><td>";
                                                jdstr+="<a class=\"layui-btn layui-btn-danger layui-btn-xs\" onclick='authdelete(this,\""+jd[i].auguid+"\")'>删除</a>";
                                                jdstr+="</td></tr>";
                                            }
                                            $("#tbodysq").html(jdstr);
                                        }

                                    }
                                    $("#txtauthtel").val("");
                                    $("#txtauthlguid").val(trdata.lguid);
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
                    }
                }
            }
        );
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

    //表格数据重新渲染
    function reloadData() {
        var titlestr = document.getElementById("txttitle").value;

        //这里以搜索为例
        tableIns.reload({
            where: { //设定异步数据接口的额外参数，任意设
                title: titlestr,
                cata: $('#livelist_hidcata').val(),
                pguid: $("#txtphone").val()
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
        $("#livelist_txtaccess").val("");//访问量
        $("#livelist_txtzan").val("");//点赞数
        //$("#picfile").val("");//直播题图
        $("#zbewmfile").val("");//
        // $("#imgpicfile").hide();
        $("#uploaderFiles").html("");
        $("#sctp").show();
        $("#imgpicewm").hide();
        $("#imgzbewmfile").hide();
        $("#txtqjurl").val("");//
        $("#livelist_txtauthcount").val("");//操作员数量
        $("#livelist_txtupdatetime").val("");//修改时间
        $("#livelist_trupdatetime").hide();
        $(":radio[name='ispublic'][value='0']").prop("checked", "true");
        $(":radio[name='yxbz'][value='1']").prop("checked", "true");
        $(":radio[name='ishome'][value='0']").prop("checked", "true");
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
    function getlogo(lguid) {
        $.post("<%=basePath%>livelogo/data", {"lguid": lguid}, function (data, status) {
            if (status == "success") {
                if (data != "") {
                    var json = $.parseJSON(data);
                    if (json.length > 0) {
                        $("#uploaderFiles").html("");
                        var str="";
                        for (var i = 0; i < json.length; i++) {
                            str+= '<li class="weui-uploader__file" logoid="' + json[i].logoid + '"  onclick="filedel(this,\'' + json[i].logoid+ '\')" style="background-image:url(<%=basePath%>' +json[i].defaultpic + ')">';
                            str+='<img title="删除" src="<%=basePath%>images/delet.png" class="delweui"/>';
                            str+='</li>';
                        }
                        $("#uploaderFiles").html(str);
                        if($("#uploaderFiles li").length<3){
                            $("#sctp").show();
                        }
                        else {
                            $("#sctp").hide();
                        }
                    }
                    else{
                        $("#uploaderFiles").html("");
                    }
                }
                else {
                    $("#sctp").show();
                }
            }
        });
    }

    function upload() {
        $("#uploaderInput").click();
        $("#uploaderInput").unbind().change(function () {
            $("#myform").ajaxForm({url:'<%=basePath%>livelogo/fileadd'},function () {
            });
            $("#myform").ajaxSubmit({
                url:'<%=basePath%>livelogo/fileadd',
                dataType: "text",
                method:'POST',
                data: {},
                error: function (jqXHR, textStatus, errorThrown) {
                    layer.msg('网络问题导致添加信息失败'+errorThrown, {icon: 2, time: 2000});
                },
                success: function (data) {
                    if (data != "0") {
                        var json = $.parseJSON(data);
                        if (json.bz == "1") {
                            var rst = json.rst;
                            var str = '<li class="weui-uploader__file" logoid="' + rst.logoid + '"  onclick="filedel(this,\'' + rst.logoid + '\')" style="background-image:url(<%=basePath%>' + rst.defaultpic + ')">';
                            str+='<img title="删除" src="<%=basePath%>images/delet.png" class="delweui"/>';
                            str+='</li>';
                            $("#uploaderFiles").append(str);
                            $("#uploaderInput").val("");
                            if($("#uploaderFiles li").length<3){
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
                        if($("#uploaderFiles li").length<3){
                            $("#sctp").show();
                        }
                        else {
                            $("#sctp").hide();
                        }
                    }
                    else{
                        layer.msg('删除失败', {icon: 2, time: 2000});
                    }
                }
            });
            layer.close(index);
        });
    }
    function guid() {
        function S4() {
            return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
        }
        return (S4()+S4()+S4()+S4()+S4()+S4()+S4()+S4());
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
                    reloadData();
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
                    reloadData();
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
    /**
     * 增加一条授权信息
     */
    function authadd() {
        if($("#txtauthtel").val()==""){
            layer.msg('授权手机号不能为空', {icon: 2, time: 2000});
            return ;
        }
        $.ajax({
            url: "<%=basePath%>applive/auth/add",
            type: "post",
            data: {"lguid": $("#txtauthlguid").val(),"pguid":$("#txtauthtel").val()},
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
    function  authdelete(e,auguid) {
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
    function closeW() {
        layer.close(myindex);
    }
</script>
<jsp:include page="/WEB-INF/pages/master/footerlayui.jsp"></jsp:include>