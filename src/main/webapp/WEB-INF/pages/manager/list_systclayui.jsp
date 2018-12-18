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
    #tableax td:first-child {
        text-align: right;
        width: 150px;
    }
</style>

<form class="layui-form" lay-filter="form">
    <table id="tableax" class="layui-table" style="display: none;">
        <tr>
            <td>套餐说明：</td>
            <td>
                <input id="tc_hidtguid" type="hidden"/>
                <textarea id="tc_txtDescription" class="layui-textarea" lay-verify="required"
                          lay-verType="tips"></textarea></td>
        </tr>
        <tr>
            <td>直播总场数(场)：</td>
            <td><input id="tc_txtCount" class="layui-input" type="text" lay-verify="number"
                       lay-verType="tips"></input></td>
        </tr>
        <tr>
            <td>有效天数(天)：</td>
            <td><input id="tc_txtYxq" class="layui-input" type="text" lay-verify="number"
                       lay-verType="tips"></input></td>
        </tr>
        <tr>
            <td>每场直播时长(天)：</td>
            <td><input id="tc_txtCttime" class="layui-input" type="text" lay-verify="number"
                       lay-verType="tips"></input>
            </td>
        </tr>
        <tr>
            <td>授权价格(元)：</td>
            <td><input id="tc_txtPrice" class="layui-input" type="text" lay-verify="decimal|required" lay-verType="tips"></input>
            </td>
        </tr>
        <tr>
            <td>是否有效：</td>
            <td>
                <input type="radio" name="yxbz" value="1" title="有效">
                <input type="radio" name="yxbz" value="0" title="无效">
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center;">
                <button id="tclist_btnadd" class="layui-btn" lay-submit lay-filter="systcadd">保存</button>
                <button id="tclist_btnupdate" class="layui-btn" lay-submit lay-filter="tcup">修改</button>
            </td>
        </tr>
    </table>
</form>
<div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding:15px;">
        <div class="layui-form-item">
            <div class="layui-inline">
                <button class="layui-btn" id="btnAdd" onclick="addData();">+ 添加信息</button>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">套餐描述：</label>
                <div class="layui-input-inline">
                    <input id="tc_txtDescriptionsea" class="layui-input" type="text">
                </div>
            </div>
            <div class="layui-inline">
                <button class="layui-btn" id="btnSearch" onclick="reloadData();">查询信息</button>
            </div>
        </div>
        <table class="layui-hide" id="test" lay-filter="test"></table>
        <script type="text/html" id="barDemo">
            <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
        </script>
        <script type="text/html" id="indexTpl">
            {{d.LAY_TABLE_INDEX+1}}
        </script>
    </div>
</div>
<script>
    var tableIns = null, layer = null, myindex = 0, form = null;
    layui.use(['table', 'layer', 'laydate', 'element', 'form'], function () {
        var table = layui.table, laydate = layui.laydate, element = layui.element;
        layer = layui.layer;form = layui.form;
        //第一个实例
        tableIns = table.render({
            elem: '#test'
            , url: '<%=basePath%>systc/data',
            request: {
                pageName: 'currentPage' //页码的参数名称，默认：page
                , limitName: 'pagesize' //每页数据量的参数名，默认：limit
            },
            method: 'post',
            page: true //开启分页
            ,
            cols: [[{
                title: '序号',
                templet: '#indexTpl',
                width: 60
            }, {
                field: 'description',
                title: '套餐说明'
            },
                {
                    field: 'count',
                    title: '可直播总场数'
                }, {
                    field: 'yxq',
                    title: '套餐有效天数'
                }, {
                    field: 'cttime',
                    title: '每场直播时长(天)'
                }, {
                    field: 'price',
                    title: '授权价格'
                },{
                field:'yxbz',
                    title:'是否有效',
                    templet: function (d) {
                        if (d.yxbz == "1") {
                            return "有效";
                        }
                        else {
                            return "无效";
                        }
                    }
                }, {
                    field: 'ctime',
                    title: '创建时间'
                }, {
                    fixed: 'right',
                    align: 'center',
                    width:100,
                    toolbar: '#barDemo',
                    title: '操作'
                }]]
        });
        //监听工具条
        table.on('tool(test)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var trdata = obj.data //获得当前行数据
                , layEvent = obj.event; //获得 lay-event 对应的值
            if (layEvent === 'edit') {
                $.post("<%=basePath%>systc/getsingle", {"tguid": trdata.tguid}, function (data, status) {
                    if (status == "success") {
                        if (data != "") {
                            var json = $.parseJSON(data);
                            $("#tc_hidtguid").val(json.tguid);
                            $("#tc_txtDescription").val(json.description);//
                            $("#tc_txtYxq").val(json.yxq);
                            $("#tc_txtCttime").val(json.cttime)
                            $("#tc_txtCount").val(json.count);//
                            $("#tc_txtPrice").val(json.price);//
                            $("#tclist_btnadd").hide();
                            $("#tclist_btnupdate").show();
                            $(":radio[name='yxbz'][value='" + json.yxbz + "']").prop("checked", "true");
                            form.render("radio");
                        } else {
                            layer.msg('数据库中没有这条信息', {icon: 2, time: 2000});
                        }
                        myindex = layer.open({
                            type: 1,
                            title: '套餐信息修改',
                            zIndex: 10000,
                            area: ['600px', '500px'],
                            content: $("#tableax")
                        });
                    }
                });
            }
        });

        form.on('submit(systcadd)', function (data) {
            tcadd();
            return false;
        });
        form.on('submit(tcup)', function (data) {
            tcup();
            return false;
        });
        form.verify({
            decimal: function (value, item) { //value：表单的值、item：表单的DOM对象
                if (!new RegExp("^\\d{1,18}(\\.\\d{1,2})?$").test(value)) {
                    return '价格格式不正确';
                }
            }
        });
    });
    function reloadData() {
        var description = document.getElementById("tc_txtDescriptionsea").value;
        //这里以搜索为例
        tableIns.reload({
            where: { //设定异步数据接口的额外参数，任意设
                description: description
            }
        });
    }

    function addData() {
        $("#tc_hidtguid").val("");
        $("#tc_txtDescription").val("");//
        $("#tc_txtYxq").val("");//
        $("#tc_txtCttime").val("");//
        $("#tc_txtCount").val("");//
        $("#tc_txtPrice").val("");//
        $(":radio[name='yxbz'][value='1']").prop("checked", true);
        form.render("radio");
        $("#tclist_btnadd").show();
        $("#tclist_btnupdate").hide();
        myindex = layer.open({
            type: 1,
            zIndex: 10000,
            title: '套餐信息添加',
            area: ['600px', '500px'],
            content: $("#tableax"), //这里content是一个普通的String
        });
    }

    //执行添加
    function tcadd() {
        var opt = {
            "description": $("#tc_txtDescription").val(),
            "yxq": $("#tc_txtYxq").val(),
            "count": $("#tc_txtCount").val(),
            "cttime": $("#tc_txtCttime").val(),
            "price": $("#tc_txtPrice").val(),
            "yxbz": $(":radio[name='yxbz']:checked").val()
        };

        $.post("<%=basePath%>systc/add", opt, function (data, status) {
            if (status == "success") {
                if (data == "1") {
                    layer.msg('信息添加成功',
                        {
                            icon: 1,
                            time: 2000 //2秒关闭（如果不配置，默认是3秒）
                        });
                    reloadData();
                    layer.close(myindex);
                } else {
                    layer.msg('信息保存失败', {icon: 2, time: 2000});
                }
            } else {
                layer.msg('信息保存失败', {icon: 2, time: 2000});
            }
        });
    }

    //执行修改
    function tcup() {
        var opt = {
            "description": $("#tc_txtDescription").val(),
            "yxq": $("#tc_txtYxq").val(),
            "count": $("#tc_txtCount").val(),
            "cttime": $("#tc_txtCttime").val(),
            "price": $("#tc_txtPrice").val(),
            "yxbz": $(":radio[name='yxbz']:checked").val(),
            "tguid": $("#tc_hidtguid").val()
        };
        $.post("<%=basePath%>systc/update", opt, function (data, status) {
            if (status == "success") {
                if (data == "1") {
                    layer.msg('信息修改成功', {icon: 1, time: 2000});
                    reloadData();
                    layer.close(myindex);

                } else {
                    layer.msg('信息修改失败', {icon: 2, time: 2000});
                }
            } else {
                layer.msg('信息修改失败', {icon: 2, time: 2000});
            }
        });
    }
</script>
<jsp:include page="/WEB-INF/pages/master/footerlayui.jsp"></jsp:include>
