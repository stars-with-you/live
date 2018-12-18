<%--
  User: fanglei
  Date: 2018-04-04
  Time: 14:12
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<jsp:include page="/WEB-INF/pages/master/headlayui.jsp"></jsp:include>
<table id="tableax" class="layui-table layui-form" style="display: none;">
    <tr>
        <td>权限名称:</td>
        <td>
            <input id="perm_hidpid" type="hidden" />
            <input id="perm_txtpname" class="layui-input" type="text"></input>
        </td>
    </tr>
    <tr>
        <td>权限url:</td>
        <td><input id="perm_txtpurl" class="layui-input" type="text" ></input>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="text-align: center;">
            <a id="perm_btnadd" href="javascript:void(0)" class="layui-btn layui-btn-normal" onclick="permadd()">保存</a>
            <a id="perm_btnupdate" href="javascript:void(0)" class="layui-btn layui-btn-normal" onclick="permup()">修改</a>
            <button type="button" class="layui-btn  layui-btn-normal" onclick="closeW();">取消</button>
        </td>
    </tr>
</table>
<div class="layui-body">
    <!-- 内容主体区域 -->
    <div class="layui-card">
        <div class="layui-card-header">
            <h2>权限列表</h2>
        </div>
        <div class="layui-card-body">
                <button class="layui-btn layui-btn-normal  layui-btn-sm" id="btnAdd" onclick="addData();">+ 添加信息</button>

            <div  style="display: inline-block;">
                <label>权限名称：</label>
                <div class="layui-input-inline">
                    <input id="perm_txtSearch" class="layui-input" type="text">
                </div>
            </div>
            <div class="layui-inline">
                <button class="layui-btn layui-btn-normal  layui-btn-sm" id="btnSearch" onclick="reloadData();">查询信息</button>
            </div>
        </div>
        <table class="layui-hide" id="test" lay-filter="test"></table>
        <script type="text/html" id="barDemo">
            <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
            <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
        </script>
    </div>
</div>
<script>
    var tableIns = null, layer = null;
    layui.use(['table', 'layer', 'laydate', 'element'], function () {
        var table = layui.table, laydate = layui.laydate, element = layui.element;
        layer = layui.layer;
        //第一个实例
        tableIns = table.render({
            elem: '#test'
            , url: '<%=basePath%>perm/getlist',
            request: {
                pageName: 'pn' //页码的参数名称，默认：page
                , limitName: 'ps' //每页数据量的参数名，默认：limit
            },
            method: 'post',
            page: true //开启分页
            ,
            cols: [[{
                field: 'pname',
                title: '权限名称'
            }, {
                field: 'purl',
                title: '权限url'
            }, {
                fixed: 'right',
                align: 'center',
                width: 120,
                toolbar: '#barDemo',
                title: '操作'
            }]]
        });
        //监听工具条
        table.on('tool(test)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var trdata = obj.data //获得当前行数据
                , layEvent = obj.event; //获得 lay-event 对应的值
            if (layEvent === 'del') {
                layer.confirm('确定删除？', function (index) {
                    //obj.del(); //删除对应行（tr）的DOM结构
                    layer.close(index);
                    //向服务端发送删除指令
                    $.ajax({
                        url: "<%=basePath%>perm/delbypid",
                        type: "post",
                        data: {"pid": trdata.pid},
                        dataType: "text",
                        success: function (data) {
                            if (data == "1") {
                                reloadData();
                            }
                        }
                    });
                });
            } else if (layEvent === 'edit') {
                $.post("<%=basePath%>perm/getsingle", {"pid": trdata.pid}, function (data, status) {
                    if (status == "success") {
                        if (data != "") {
                            var json = $.parseJSON(data);
                            $("#perm_hidpid").val(json.pid);
                            $("#perm_txtpname").val(json.pname);//
                            $("#perm_txtpurl").val(json.purl);//
                            $("#perm_btnadd").hide();
                            $("#perm_btnupdate").show();
                        } else {
                            layer.msg('数据库中没有这条信息', {icon: 2});
                        }
                      myindex=  layer.open({
                            type: 1,
                            title: '信息修改',
                            zIndex: 10000,
                            area: ['400px', '300px'],
                            content: $("#tableax"), //这里content是一个普通的String
                            cancel: function (index, layero) {
                                reloadData();
                            },
                            success: function (layero, index) {
                            }
                        });
                    }
                });
            }
        });
    });

    function reloadData() {
        var pnamestr = document.getElementById("perm_txtSearch").value;
        //这里以搜索为例
        tableIns.reload({
            where: { //设定异步数据接口的额外参数，任意设
                pname: pnamestr
            }
        });
    }
    function addData() {
        $("#perm_txtpname").val("");//
        $("#perm_txtpurl").val("");//
        $("#perm_btnadd").show();
        $("#perm_btnupdate").hide();
       myindex= layer.open({
            type: 1,
            zIndex: 10000,
            title: '信息添加',
            area: ['400px', '300px'],
            content: $("#tableax"), //这里content是一个普通的String
            cancel: function (index, layero) {
                reloadData();
            },
            success: function (layero, index) {
            }
        });
    }
    //增加一条信息
    function permadd()
    {
        if($("#perm_txtpname").val()==""){
            layer.msg('请填写权限描述', {icon: 2});
            return;
        }
        if($("#perm_txtpurl").val()==""){
            layer.msg('请填写权限url', {icon: 2});
            return;
        }
        $.post("<%=basePath%>perm/add",{"pname":$("#perm_txtpname").val(),"purl":$("#perm_txtpurl").val()},function(data,status){
            if (status=="success") {
                if (data=="1") {
                    layer.msg('信息添加成功', {icon: 1});
                } else {
                    layer.msg('信息添加失败', {icon: 2});
                }
            }
            else {
                layer.msg('网络问题导致添加信息失败', {icon: 2});
            }
        });
    }
    function permup()
    {
        if($("#perm_txtpname").val()==""){
            layer.msg('请填写权限描述', {icon: 2});
            return;
        }
        if($("#perm_txtpurl").val()==""){
            layer.msg('请填写权限url', {icon: 2});
            return;
        }
        $.post("<%=basePath%>perm/updatebypid",{"pid":$("#perm_hidpid").val(),"pname":$("#perm_txtpname").val(),"purl":$("#perm_txtpurl").val()},function(data,status){
            if (status=="success") {
                if (data=="1") {
                    layer.msg('信息修改成功', {icon: 1});
                } else {
                    layer.msg('信息修改失败', {icon: 2});
                }
            }
            else {
                layer.msg('网络问题导致修改信息失败', {icon: 2});
            }
        });
    }
    function closeW() {
        layer.close(myindex);
    }
</script>
<jsp:include page="/WEB-INF/pages/master/footerlayui.jsp"></jsp:include>

