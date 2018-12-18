<%--
  User: fanglei
  Date: 2018-04-09
  Time: 13:47
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<jsp:include page="/WEB-INF/pages/master/headlayui.jsp"></jsp:include>
<div id="tableax" class="layui-collapse " style="display: none;text-align: center;">
    <textarea id="template_content" style="width:980px;height: 600px;"></textarea>
    <input type="hidden" id="template_hidpath"/>
    <button href='#' class='layui-btn'  onclick='writejsp();'>修改文件</button>
</div>
<div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
        <table class="layui-hide" id="test" lay-filter="test"></table>
        <script type="text/html" id="barDemo">
            {{#  if(d.cata=="0"){ }}
            <a class="layui-btn layui-btn-xs" lay-event="edit">查看文件</a>
            {{#  } }}
            {{#  if(d.cata=="1"){ }}
            <a class="layui-btn layui-btn-xs" lay-event="lookdir">浏览文件夹</a>
            {{#  } }}
        </script>
    </div>
</div>
<script>
    var tableIns = null, layer = null, $ = null;
    layui.use(['table', 'layer',  'element'], function () {
        var table = layui.table, element = layui.element;
        layer = layui.layer;
        $ = layui.jquery;
        $("[href='" + window.location.href + "']").addClass("layui-this");
        //$("[href='" + window.location.href + "']").parent().parent().parent().addClass("layui-nav-itemed").siblings().removeClass("layui-nav-itemed");
        //第一个实例
        tableIns = table.render({
            elem: '#test'
            , url: '<%=basePath%>template/data',
            method: 'post',
            page: false //开启分页
            ,
            where:{
                path:'${gml}'
            },
            cols: [[{
                field: 'cata',
                title: '类型',
                width:80,
                templet: function(d){
                    if (d.cata=="0") {
                        return "文件";
                    }
                    else {
                        return "文件夹";
                    }
                }
            },{
                field: 'abpath',
                title: '文件(夹)路径'
            }, {
                field: 'filename',
                title: '文件(夹)名称',
                width:200
            }, {
                fixed: 'right',
                align: 'center',
                width: 150,
                toolbar: '#barDemo',
                title: '操作'
            }]]
        });
        //监听工具条
        table.on('tool(test)', function (obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
            var trdata = obj.data //获得当前行数据
                , layEvent = obj.event; //获得 lay-event 对应的值
            var tr = obj.tr; //获得当前行 tr 的DOM对象

            if (layEvent === 'lookdir') {
                reloaddata(trdata.path);
            } else if (layEvent === 'edit') {
                readjsp(trdata.path,trdata.filename);
            }
        });
    });
    function  reloaddata(pathstr) {
        tableIns.reload({
            where: { //设定异步数据接口的额外参数，任意设
                path: pathstr
            }
        });
    }
    function readjsp(path,filename)
    {
        $("#template_hidpath").val(path);
        filename=filename+"查看";
        $("#template_content").val("");
        $.post("<%=basePath%>template/readjsp",{"path":path},function(data,status){
            if (status=="success") {
                $("#template_content").val(data);
                layer.open({
                    type: 1,
                    title: filename,
                    zIndex: 10000,
                    area: ['1000px', '700px'],
                    content: $("#tableax"), //这里content是一个普通的String
                    cancel: function (index, layero) {
                    },
                    success: function (layero, index) {
                    }
                });
            }
            else {
                layer.msg("文件读取失败",{icon:2});
            }
        });
    }
    function writejsp()
    {
        $.ajax({
            method: 'POST',
            url: "<%=basePath%>template/writejsp",
            data: {"path":$("#template_hidpath").val(),"content":$("#template_content").val()},
            contentType: 'application/x-www-form-urlencoded; charset=utf-8',
            success: function(data) {
                if (data=="1") {
                    layer.msg("文件修改成功",{icon:1});
                }
                else {
                    layer.msg("文件修改失败",{icon:2});
                }
            }
        });
    }

</script>
<jsp:include page="/WEB-INF/pages/master/footerlayui.jsp"></jsp:include>

