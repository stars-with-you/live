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
<style>
    #tableax td:first-child {
        text-align: right;
        width:100px;
    }

    .layui-input {
        height: 30px;
    }
</style>
<form id="myform" class="layui-form" lay-filter="form" enctype="multipart/form-data">
    <table id="tableax" class="layui-table" style="display: none;padding: 0;margin: 0;">
        <tr>
            <td>评论内容:</td>
            <td>
                <input type="hidden" id="livecmt_hidcguid" name="cguid">
                <input type="hidden" id="livecmt_hidlguid" name="lguid" value="${lguid}">
                <textarea id="livecmt_txtcomment" name="comment" class="layui-textarea" lay-verify="required"
                          lay-verType="tips" style="height: 60px;"></textarea>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center;">
                <button id="livecmt_btnadd" class="layui-btn   layui-btn-normal " onclick="cmtadd()">保存</button>
                <button id="livecmt_btnupdate" class="layui-btn  layui-btn-normal " onclick="livecmtup()">修改</button>
                <button type="button" class="layui-btn  layui-btn-normal" onclick="closeW();">取消</button>
            </td>
        </tr>
    </table>
</form>
<div class="layui-body">
    <!-- 内容主体区域 -->
    <div class="layui-card">
        <div class="layui-card-header">
            <h2>评论管理</h2>
        </div>
        <div class="layui-card-body">
                <button class="layui-btn  layui-btn-normal  layui-btn-sm" id="btnAdd" onclick="addData();">+ 添加信息</button>

            <div style="display: inline-block;">
                <label>内容信息</label>
                <div class="layui-input-inline">
                    <input name="txttitle" id="txttitle"
                           autocomplete="off" class="layui-input" type="text">
                </div>
            </div>
            <div class="layui-inline">
                <button class="layui-btn  layui-btn-normal  layui-btn-sm" id="btnSearch" onclick="reloadData();">查询信息</button>
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
<script>
    var tableIns = null, layer = null, form = null;
    layui.use(['table', 'layer', 'laydate', 'element', 'form'], function () {
        var table = layui.table, laydate = layui.laydate, element = layui.element;
        layer = layui.layer;
        form = layui.form;
        //第一个实例
        tableIns = table.render({
            elem: '#test'
            , url: '<%=basePath%>applive/cmt/data',
            request: {
                pageName: 'currentPage' //页码的参数名称，默认：page
                ,
                limitName: 'pagesize' //每页数据量的参数名，默认：limit
            },
            where: {
                lguid: $('#livecmt_hidlguid').val()
            },
            method: 'post',
            page: {} //开启分页
            ,
            cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            ,
            cols: [[{
                field: 'comment',
                title: '内容'
            }, {
                field: 'nickname',
                title: '评论人'
            }, {
                field: 'createtime',
                title: '创建时间'
            },  {
                field: 'status',
                title: '审核状态',
                templet: function (d) {
                    if (d.status == "0") {
                        return "审核通过";
                    }
                    else {
                        if (d.status == "1") {
                            return "待审";
                        }
                        else {
                            return "审核不通过";
                        }
                    }
                }
            },
                {
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
                        url: "<%=basePath%>applive/cmt/deletebycguid",
                        type: "post",
                        data: {"cguid": trdata.cguid},
                        dataType: "text",
                        success: function (data) {
                            if (data == "1") {
                                reloadData();
                            }
                        }
                    });
                });
            } else if (layEvent === 'edit') {
                $.post("<%=basePath%>applive/cmt/getsingle", {"cguid": trdata.cguid}, function (data, status) {
                    if (status == "success") {
                        if (data != "") {
                            var json = $.parseJSON(data);
                            $("#livecmt_hidcguid").val(json.cguid);
                            $("#livecmt_txtcomment").val(json.comment);//
                            $("#livecmt_btnadd").hide();
                            $("#livecmt_btnupdate").show();
                        } else {
                            layer.msg('数据库中没有这条信息', {icon: 2, time: 2000});
                        }
                        myindex = layer.open({
                            type: 1,
                            title: '信息修改',
                            zIndex: 10000,
                            area: ['600px', '400px'],
                            content: $("#tableax")
                        });
                    }
                });
            }
        });
        //日期
        laydate.render({
            elem: '#livecmt_txtupdatetime',
            type: 'datetime'
        });
        laydate.render({
            elem: '#livecmt_txtstartdate',
            type: 'datetime'
        });
        laydate.render({
            elem: '#livecmt_txtenddate',
            type: 'datetime'
        });
    });

    //表格数据重新渲染
    function reloadData() {
        var titlestr = document.getElementById("txttitle").value;
        //这里以搜索为例
        tableIns.reload({
            where: { //设定异步数据接口的额外参数，任意设
                comment:$("#txttitle").val()
            }
        });
    }

    //弹出添加信息窗口
    function addData() {
        $("#livecmt_hidcguid").val("");
        $("#livecmt_txtcomment").val("");//
        $("#livecmt_btnadd").show();
        $("#livecmt_btnupdate").hide();
        myindex = layer.open({
            type: 1,
            zIndex: 10000,
            title: '信息添加',
            area: ['600px', '300px'],
            content: $("#tableax")
        });
    }

    function cmtadd() {
        $("#myform").ajaxForm(function () {
        });
        $("#myform").ajaxSubmit({
            type: "POST",
            url: "<%=basePath%>applive/cmt/add",
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
            },
            beforeSubmit:function (formData, jqForm, options) {
                //formData: 数组对象，提交表单时，Form插件会以Ajax方式自动提交这些数据，格式如：[{name:user,value:val },{name:pwd,value:pwd}]
                //jqForm:   jQuery对象，封装了表单的元素
                //options:  options对象
                if ($("#livecmt_hidlguid").val() == "") {
                    layer.msg('没有指定直播', {icon: 2, time: 2000});
                    return false;
                }
                if ($("#livecmt_txtcomment").val() == "") {
                    layer.msg('请填写评论内容', {icon: 2, time: 2000});
                    return false;
                }
            }
        });
        return false;
    }

    //弹出修改信息窗口
    function livecmtup() {
        $("#myform").ajaxForm(function () {
        });
        $("#myform").ajaxSubmit({
            type: "POST",
            url: "<%=basePath%>applive/cmt/update",
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
                if ($("#livecmt_hidlguid").val() == "") {
                    layer.msg('没有指定直播', {icon: 2, time: 2000});
                    return false;
                }
                if ($("#livecmt_txtcomment").val() == "") {
                    layer.msg('请填写评论内容', {icon: 2, time: 2000});
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