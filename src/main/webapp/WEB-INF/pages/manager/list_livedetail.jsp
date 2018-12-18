<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<link rel="stylesheet" href="<%=basePath%>js/simditor/styles/simditor.css"/>
<style>
    #tableax td:first-child {
        text-align: right;
        width:100px;
    }

    .layui-input {
        height: 30px;
    }
    .simditor {
        height: 200px;
    }

    .simditor .simditor-body, .editor-style {
        font-size: 14px;
    }

    .simditor .simditor-body {
        padding: 2px 2px 2px;
        min-height: 100px;
    }
</style>

<input type="hidden" id="livedetail_hidlguid" name="lguid" value="${lguid}">s
<form id="myform" class="layui-form" lay-filter="form" enctype="multipart/form-data">
    <table id="tableax" class="layui-table" style="display: none;padding: 0;margin: 0;">
        <tr>
            <td>直播内容:</td>
            <td>
                <input type="hidden" id="livedetail_hiddguid" name="dguid">
                <textarea id="livedetail_txtdescription" name="description" class="layui-textarea" lay-verify="required"
                          lay-verType="tips" style="height: 60px;"></textarea>
            </td>
        </tr>
        <tr id="livedetail_trupdatetime">
            <td>修改时间:</td>
            <td><input id="livedetail_txtupdatetime" class="layui-input" name="updatetime"></td>
        </tr>
        <tr >
            <td>是否发布:</td>
            <td>
                <input type="radio" name="isfb" value="1" title="已发布">
                <input type="radio" name="isfb" value="0" title="未发布">
            </td>
        </tr>
        <tr >
            <td>是否置顶:</td>
            <td>
                <input type="radio" name="iszd" value="0" title="不置顶">
                <input type="radio" name="iszd" value="1" title="置顶">
            </td>
        </tr>
        <tr>
            <td>标签:</td>
            <td id="tdbq">
                <c:forEach items="${bqlist}" var="item">
                    <input type="checkbox" name="${item.bguid}" lay-skin="primary" title="${item.bq}" value="${item.bguid}">
                </c:forEach>
            </td>
        </tr>
        <tr>
            <td>上传附件:</td>
            <td>
                <button type="button" class="layui-btn" id="btnupload">
                    <i class="layui-icon">&#xe67c;</i>上传图片
                </button>
            </td>
        </tr>
        <tbody id="tbodypreview">
        <tbody/>
        <tr>
            <td colspan="2" style="text-align: center;">
                <button id="livedetail_btnadd" class="layui-btn layui-btn-normal" onclick="detailadd()">保存</button>
                <button id="livedetail_btnupdate" class="layui-btn layui-btn-normal" onclick="livedetailup()">修改</button>
                <button type="button" class="layui-btn  layui-btn-normal" onclick="closeW();">取消</button>
            </td>
        </tr>
    </table>
</form>
<div class="layui-body">
    <!-- 内容主体区域 -->
    <div class="layui-card">
        <div class="layui-card-header">
            <h2>直播详情</h2>
        </div>
        <div class="layui-card-body">
                <button class="layui-btn layui-btn-normal layui-btn-sm" id="btnAdd" onclick="addData();">+ 添加信息</button>

            <div style="display: inline-block;">
                <label>内容信息</label>
                <div class="layui-input-inline">
                    <input name="txttitle" id="txttitle"
                           autocomplete="off" class="layui-input" type="text">
                </div>
            </div>
            <div style="display: inline-block;">
                <label >创建人帐号</label>
                <div class="layui-input-inline">
                    <input id="txtphone"
                           autocomplete="off" class="layui-input" type="text">
                </div>
            </div>
            <div class="layui-inline">
                <button class="layui-btn  layui-btn-normal layui-btn-sm" id="btnSearch" onclick="reloadData();">查询信息</button>
            </div>
        </div>
        <table class="layui-hide" id="test" lay-filter="test"></table>
        <script type="text/html" id="barDemo">
            <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
            <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
        </script>
    </div>
</div>
</div>
<script src="<%=basePath%>js/jquery.form.js"></script>
<script src="<%=basePath%>js/simditor/scripts/module.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=basePath%>js/simditor/scripts/hotkeys.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=basePath%>js/simditor/scripts/simditor.js" type="text/javascript" charset="utf-8"></script>
<script>
    var editor = null;
    var tableIns = null, layer = null, form = null;
    layui.use(['table', 'layer', 'laydate', 'element', 'form', 'upload'], function () {
        var table = layui.table, laydate = layui.laydate, element = layui.element, upload = layui.upload;
        layer = layui.layer;
        form = layui.form;
        //第一个实例
        tableIns = table.render({
            elem: '#test'
            , url: '<%=basePath%>applive/detail/data',
            request: {
                pageName: 'currentPage' //页码的参数名称，默认：page
                ,
                limitName: 'pagesize' //每页数据量的参数名，默认：limit
            },
            where: {
                lguid: $('#livedetail_hidlguid').val()
            },
            method: 'post',
            page: {} //开启分页
            ,
            cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            ,
            cols: [[{
                field: 'description',
                title: '内容'
            }, {
                field: 'pguid',
                title: '创建人帐号'
            },{
                field: 'isfb',
                title: '是否发布',
                width: 100,
                templet: function (d) {
                    if (d.isfb == "1") {
                        return "已发布";
                    }
                    else {
                        return "<span style='color:red'>未发布</span>";
                    }
                }
            },{
                field: 'iszd',
                title: '是否置顶',
                width: 100,
                templet: function (d) {
                    if (d.iszd == "1") {
                        return "<span style='color:red'>已置顶</span>";
                    }
                    else {
                        return "未置顶";
                    }
                }
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
                        url: "<%=basePath%>applive/detail/delbydguid",
                        type: "post",
                        data: {"dguid": trdata.dguid},
                        dataType: "text",
                        success: function (data) {
                            if (data == "1") {
                                reloadData();
                            }
                        }
                    });
                });
            } else if (layEvent === 'edit') {
                $.post("<%=basePath%>applive/detail/getsingle", {"dguid": trdata.dguid}, function (data, status) {
                    if (status == "success") {
                        if (data != "") {
                            var json = $.parseJSON(data);
                            $("#livedetail_hiddguid").val(json.dmodel.dguid);
                            //$("#livedetail_txtdescription").val(json.dmodel.description);//
                            editor.setValue(json.dmodel.description);
                            //$("#txtbq").val(json.dmodel.bq);
                            $("#livedetail_txtupdatetime").val(json.dmodel.updatetime);
                            $("#livedetail_trupdatetime").show();
                            if (json.dmodel.isfb=="1") {
                                $(":radio[name='isfb'][value='1']").prop("checked", "true");
                            }
                            else{
                                $(":radio[name='isfb'][value='0']").prop("checked", "true");
                            }
                            if (json.dmodel.iszd=="1") {
                                $(":radio[name='iszd'][value='1']").prop("checked", "true");
                            }
                            else{
                                $(":radio[name='iszd'][value='0']").prop("checked", "true");
                            }
                            $("#livedetail_hidlguid").val(json.dmodel.lguid);
                            getBq(trdata.dguid);
                            form.render('radio');

                            var js=json.amodel;
                            $("#tbodypreview").html("");
                            for (var i = 0; i <js.length ; i++) {
                                var str = "<tr><td></td><td><span>"+js[i].filename+"</span> <a  style='float:right;'  class=\"layui-btn layui-btn-danger layui-btn-xs\"  onclick='delrowup(this,\""+js[i].aguid+"\")'>删除</a></td></tr>";
                                $("#tbodypreview").append(str);
                            }
                            $("#livedetail_btnadd").hide();
                            $("#livedetail_btnupdate").show();


                        } else {
                            layer.msg('数据库中没有这条信息', {icon: 2, time: 2000});
                        }
                        myindex = layer.open({
                            type: 1,
                            title: '信息修改',
                            zIndex: 10000,
                            area: ['600px', '550px'],
                            content: $("#tableax")
                        });
                    }
                });
            }
        });
        //日期
        laydate.render({
            elem: '#livedetail_txtupdatetime',
            type: 'datetime'
        });
        laydate.render({
            elem: '#livedetail_txtstartdate',
            type: 'datetime'
        });
        laydate.render({
            elem: '#livedetail_txtenddate',
            type: 'datetime'
        });
    });
    function getBq(dguid) {
        //向服务端发送删除指令
        $.ajax({
            url: "<%=basePath%>applive/detail/getbqbydguid",
            type: "post",
            data: {
                "dguid": dguid
            },
            dataType: "text",
            success: function (data) {
                if (data != "") {
                    var json=$.parseJSON(data);
                    $("#tdbq :checkbox").removeAttr("checked");
                    if(json.length>0) {
                        for (var i = 0; i < json.length; i++) {
                            $("#tdbq :checkbox[value='"+json[i].bguid+"']").prop("checked",true);
                        }
                    }
                }
                form.render('checkbox');
            }
        });
    }
    //表格数据重新渲染
    function reloadData() {
        var titlestr = document.getElementById("txttitle").value;
        var cr=tableIns.config.page.curr;
        if(titlestr!="")
        {
            cr=1;
        }
        tableIns.reload({
            where: { //设定异步数据接口的额外参数，任意设
                description:$("#txttitle").val(),
                pguid: $("#txtphone").val(),
                lguid: $('#livedetail_hidlguid').val()
            }
            ,page: {
                curr: 1 //重新从第 1 页开始
            }
        });
    }

    $(function () {
        editor = new Simditor({
            textarea: $('#livedetail_txtdescription'),
            placeholder: '这里输入文字...',
            toolbar: ['bold', 'italic', 'underline', 'strikethrough', 'fontScale', 'color', '|', 'link', '|', 'indent', 'outdent', 'alignment'], //工具条都包含哪些内容
            //optional options
        });
        $("#btnupload").click(function () {
            var str = "<tr><td></td><td><input type='file' name='picfile' /><a style='float:right;' class=\"layui-btn layui-btn-danger layui-btn-xs\" onclick='delrow(this)'>删除</a></td></tr>";
            $("#tbodypreview").append(str);
        });
    });

    function delrow(e) {
        $(e).parent().parent().remove();
    }
    function delrowup(e,aguid) {
        //向服务端发送删除指令
        $.ajax({
            url: "<%=basePath%>applive/detail/delfilebyaguid",
            type: "post",
            data: {"aguid": aguid},
            dataType: "text",
            success: function (data) {
                if (data == "1") {
                    $(e).parent().parent().remove();
                }
            }
        });

    }

    //弹出添加信息窗口
    function addData() {
        $("#livedetail_hiddguid").val("");
        $("#livedetail_txtdescription").val("");//
        editor.setValue("");
        $("#txtbq").val("");
        $("#livedetail_txtupdatetime").val("");//修改时间
        $("#livedetail_trupdatetime").hide();
        $("#livedetail_btnadd").show();
        $("#livedetail_btnupdate").hide();
        $("#tbodypreview").html("");

        $(":radio[name='isfb'][value='1']").prop("checked", "true");
        $(":radio[name='iszd'][value='0']").prop("checked", "true");
        $("#tdbq :checkbox").removeAttr("checked");
        form.render('radio');
        form.render('checkbox');
        myindex = layer.open({
            type: 1,
            zIndex: 10000,
            title: '信息添加',
            area: ['600px', '550px'],
            content: $("#tableax")
        });
    }

    function detailadd() {
        var e=$("#tdbq input[type='checkbox']:checked");
        var mybguid="",mybq="";
        if(e.length>0) {
            for (var i = 0; i < e.length-1; i++) {
                mybguid += ($(e[i]).val() + ",");
                mybq += ($(e[i]).attr("title")+ ",");
            }
            mybguid += $(e[e.length-1]).val();
            mybq += $(e[e.length-1]).attr("title");
        }
        $("#myform").ajaxForm(function () {
        });
        $("#myform").ajaxSubmit({
            type: "POST",
            url: "<%=basePath%>applive/detail/add",
            dataType: "text",
            data:{"lguid":$("#livedetail_hidlguid").val(),"mybguid":mybguid,"mybq":mybq},
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
            },
            beforeSubmit:function (formData, jqForm, options) {
                //formData: 数组对象，提交表单时，Form插件会以Ajax方式自动提交这些数据，格式如：[{name:user,value:val },{name:pwd,value:pwd}]
                //jqForm:   jQuery对象，封装了表单的元素
                //options:  options对象
                if ($("#livedetail_hidlguid").val() == "") {
                    layer.msg('没有指定直播', {icon: 2, time: 2000});
                    return false;
                }
                if ($("#livedetail_txtdescription").val() == "") {
                    layer.msg('请填写直播内容', {icon: 2, time: 2000});
                    return false;
                }
            }
        });
        return false;
    }

    //弹出修改信息窗口
    function livedetailup() {
        var e=$("#tdbq input[type='checkbox']:checked");
        var mybguid="",mybq="";
        if(e.length>0) {
            for (var i = 0; i < e.length-1; i++) {
                mybguid += ($(e[i]).val() + ",");
                mybq += ($(e[i]).attr("title")+ ",");
            }
            mybguid += $(e[e.length-1]).val();
            mybq += $(e[e.length-1]).attr("title");
        }
        $("#myform").ajaxForm(function () {
        });
        $("#myform").ajaxSubmit({
            type: "POST",
            url: "<%=basePath%>applive/detail/update",
            data:{"lguid":$("#livedetail_hidlguid").val(),"mybguid":mybguid,"mybq":mybq},
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
            },
            beforeSubmit:function (formData, jqForm, options) {
                //formData: 数组对象，提交表单时，Form插件会以Ajax方式自动提交这些数据，格式如：[{name:user,value:val },{name:pwd,value:pwd}]
                //jqForm:   jQuery对象，封装了表单的元素
                //options:  options对象
                if ($("#livedetail_txtdescription").val() == "") {
                    layer.msg('请填写直播内容', {icon: 2, time: 2000});
                    return false;
                }
                if ($("#livedetail_txtupdatetime").val() == "") {
                    layer.msg('修改时间不能为空', {icon: 2, time: 2000});
                    return false;
                }
            }
        });
        return false;
    }
    function closeW() {
        layer.close(myindex);
    }
    //用于生成uuid
    function S4() {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    }

    function guid() {
        return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
    }
</script>
<jsp:include page="/WEB-INF/pages/master/footerlayui.jsp"></jsp:include>