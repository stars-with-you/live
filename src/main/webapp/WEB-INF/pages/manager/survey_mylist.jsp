<%--
  User: fanglei
  Date: 2018-09-06
  Time: 14:48
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<jsp:include page="/WEB-INF/pages/master/headlayui.jsp"></jsp:include>
<div class="layui-body">
    <div class="layui-card">
        <div class="layui-card-body">
            <div style="display: inline-block;">
                <div class="layui-input-inline">
                    <input name="txttitle" id="txttitle"
                           autocomplete="off" class="layui-input" type="text" placeholder="调查标题">
                </div>
            </div>

            <div class="layui-inline">
                <button class="layui-btn layui-btn-normal layui-btn-sm" id="btnSearch" onclick="reloadData();">查询信息
                </button>
            </div>
        </div>
        <table class="layui-hide" id="test" lay-filter="test"></table>

    </div>
</div>

<script>
    var tableIns = null, layer = null;
    layui.use(['table', 'layer', 'laydate', 'element', 'form'], function () {
        var table = layui.table, laydate = layui.laydate, element = layui.element, form = layui.form;
        layer = layui.layer;
        //第一个实例
        tableIns = table.render({
            elem: '#test'
            , url: '<%=basePath%>survey/getList',
            request: {
                pageName: 'currentPage' //页码的参数名称，默认：page
                ,
                limitName: 'pagesize' //每页数据量的参数名，默认：limit

            },
            // where: {
            //     menucode: $('#newslist_hidmenucode').val()
            // },
            method: 'post',
            page: {} //开启分页
            ,
            cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            ,
            cols: [[{
                field: 'stitle',
                title: '标题'
            }, {
                field: 'createtime',
                title: '创建时间'
            }, {
                field: 'displayname',
                title: '添加人'
            }, {
                fixed: 'right',
                align: 'center',
                title: '操作',
                templet: function (d) {
                    var str = "";
                    str += '<a class="layui-btn layui-btn-normal layui-btn-xs" target="_blank" href="<%=basePath%>survey/answer?sid=' + d.sid + '">答题</a><a class="layui-btn layui-btn-danger layui-btn-xs"  href="<%=basePath%>survey/tj?sid=' + d.sid + '"  target="_blank" >统计</a>';
                    return str;
                }
            }]]
        });
        //监听工具条
        table.on('tool(test)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var trdata = obj.data //获得当前行数据
                , layEvent = obj.event; //获得 lay-event 对应的值
            if (layEvent === 'detail') {
            } else if (layEvent === 'del') {
                layer.confirm('真的删除行么', function (index) {
                    //obj.del(); //删除对应行（tr）的DOM结构
                    layer.close(index);
                    //向服务端发送删除指令
                    $.ajax({
                        url: "<%=basePath%>survey/delbysid",
                        type: "post",
                        data: {"sid": trdata.sid},
                        dataType: "text",
                        success: function (data) {
                            if (data == "1") {
                                reloadData();
                            }
                        }
                    });
                });
            } else if (layEvent === 'edit') {
                location.href = "<%=basePath%>survey/update?sid=" + trdata.sid;
            }
        });
    });

    //表格数据重新渲染
    function reloadData() {
        var titlestr = document.getElementById("txttitle").value;
        //这里以搜索为例
        tableIns.reload({
            where: { //设定异步数据接口的额外参数，任意设
                stitle: titlestr
            }
        });
    }

    function closeW() {
        layer.close(myindex);
    }
</script>

<jsp:include page="/WEB-INF/pages/master/footerlayui.jsp"></jsp:include>
