
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
<link rel="stylesheet"
      href="<%=basePath%>js/kindeditor/themes/default/default.css"/>
<script charset="utf-8"
        src="<%=basePath%>js/kindeditor/kindeditor-min.js"></script>
<script charset="utf-8" src="<%=basePath%>js/kindeditor/lang/zh-CN.js"></script>

<table id="tableax" class="layui-table" style="display: none;">
    <tr>
        <td>发布标题:</td>
        <td><input id="newslist_hidpid" type="hidden"/>
            <input id="newslist_hidmenucode" type="hidden" value="${menucode }"/>
            <input id="newslist_txttitle" class="layui-input" type="text" style="width:500px;"></input></td>
    </tr>
    <tr>
        <td>发布内容:</td>
        <td><textarea id="newslist_txtcontent" name="content" placeholder="请在这里输入信息"></textarea>
        </td>
    </tr>
    <tr id="newslist_trupdatetime">
        <td>修改时间:</td>
        <td><input id="newslist_txtupdatetime" class="layui-input" name="birthday"></td>
    </tr>
    <tr style="display: none;">
        <td>发布内容:</td>
        <td><input type="checkbox" id="rdwb"><label for="rdwb">推送到微博</label>
            <input type="checkbox" id="rdwx"><label for="rdwx">推送到微信</label>
            <input type="checkbox" id="rdapp"><label for="rdapp">推送到app</label>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="text-align: center;">
            <button id="newslist_btnadd" class="layui-btn   layui-btn-normal" onclick="newsadd()" >保存</button>
            <button id="newslist_btnupdate" class="layui-btn   layui-btn-normal" onclick="newsup()">修改</button>
            <button type="button" class="layui-btn  layui-btn-normal" onclick="closeW();">取消</button>
        </td>
    </tr>
</table>

<div class="layui-body">
    <!-- 内容主体区域 -->

     <%--   <div class="layui-form-item" style="text-align:center;padding: 0;margin: 0;">
            <h1 >
            <c:choose>
                <c:when test="${menucode=='003001'}">
                    图文直播
                </c:when>
                <c:when test="${menucode=='003002'}">
                    图片直播
                </c:when>
                <c:when test="${menucode=='003003'}">
                    视频直播
                </c:when>
                <c:otherwise>
                    ${menucode}
                </c:otherwise>
            </c:choose>
            </h1>
        </div>--%>
    <div class="layui-card">
        <div class="layui-card-header">
            <h2>新闻动态管理</h2>
        </div>
        <div class="layui-card-body">
                <button class="layui-btn  layui-btn-normal  layui-btn-sm" id="btnAdd" onclick="addData();">+ 添加信息</button>

            <div class="layui-inline">
                <label>标题</label>
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
<script>
    var tableIns = null, layer = null;
    layui.use(['table', 'layer', 'laydate', 'element','form'], function () {
        var table = layui.table, laydate = layui.laydate, element = layui.element,form = layui.form;
        layer = layui.layer;
        //第一个实例
        tableIns = table.render({
            elem: '#test'
            , url: '<%=basePath%>news/data',
            request: {
                pageName: 'currentPage' //页码的参数名称，默认：page
                ,
                limitName: 'pagesize' //每页数据量的参数名，默认：limit

            },
            where: {
                menucode: $('#newslist_hidmenucode').val()
            },
            method: 'post',
            page: {
            } //开启分页
            ,
            cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
            ,
            cols: [[{
                field: 'title',
                title: '标题'
            }, {
                field: 'updatetime',
                title: '修改时间'
            }, {
                field: 'adddispname',
                title: '添加人'
            }, {
                fixed: 'right',
                width: 165,
                align: 'center',
                toolbar: '#barDemo',
                title: '操作'
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
                        url: "<%=basePath%>news/delbynid",
                        type: "post",
                        data: {"nid": trdata.nid},
                        dataType: "text",
                        success: function (data) {
                            if (data == "1") {
                                reloadData();
                            }
                        }
                    });
                });
            } else if (layEvent === 'edit') {
                $.post("<%=basePath%>news/getsingle", {"nid": trdata.nid}, function (data, status) {
                    if (status == "success") {
                        if (data != "") {
                            var json = $.parseJSON(data);

                            $("#newslist_txttitle").val(json.title);

                            $("#newslist_txtcontent").val(json.content);

                            $("#newslist_hidpid").val(json.nid);

                            $("#newslist_trupdatetime").show();

                            $("#newslist_txtupdatetime").val(json.updatetime);
                            if (json.iswb == "1") {
                                $("#rdwb").attr("checked", true);
                            }
                            if (json.iswx == "1") {
                                $("#rdwx").attr("checked", true);
                            }
                            if (json.isapp == "1") {
                                $("#rdapp").attr("checked", true);
                            }
                            $("#newslist_btnadd").hide();
                            $("#newslist_btnupdate").show();
                        } else {
                            layer.msg('数据库中没有这条信息', {icon: 2});
                        }
                       myindex= layer.open({
                            type: 1,
                            title: '信息修改',
                            zIndex: 10000,
                            area: ['1000px', '600px'],
                            content: $("#tableax"), //这里content是一个普通的String
                            cancel: function (index, layero) {
                                KindEditor.remove('#newslist_txtcontent');
                                reloadData();
                            },
                            success: function (layero, index) {
                                window.editor = KindEditor.create('#newslist_txtcontent', {
                                    height: '300px',
                                    width: '840px',
                                    allowImageUpload: true,
                                    uploadJson: '<%=basePath%>newsupload/uploadjson',
                                    allowFileManager: false,
                                    items: ['fontname', 'fontsize', '|', 'forecolor', 'hilitecolor',
                                        'bold', 'italic', 'underline', 'removeformat', '|',
                                        'justifyleft', 'justifycenter', 'justifyright',
                                        'insertorderedlist', 'insertunorderedlist', '|', 'emoticons',
                                        'image', 'insertfile', 'link']
                                });
                            }
                        });
                    }

                });
            }
        });
        //日期
        laydate.render({
            elem: '#newslist_txtupdatetime',
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
                menucode: $('#newslist_hidmenucode').val()
            }
        });
    }
    //弹出添加信息窗口
    function addData() {
        $("#newslist_txttitle").val("");//标题
        $("#newslist_txtcontent").val("");//内容
        $("#newslist_hidpid").val("");//id
        $("#newslist_trupdatetime").hide();
        $("#rdwb").removeAttr("checked");//取消
        $("#rdwx").removeAttr("checked");
        $("#rdapp").removeAttr("checked");
        $("#newslist_btnadd").show();
        $("#newslist_btnupdate").hide();
         myindex= layer.open({
            type: 1,
            zIndex: 10000,
            title: '信息添加',
            area: ['1000px', '600px'],
            content: $("#tableax"), //这里content是一个普通的String
            cancel: function (index, layero) {
                KindEditor.remove('#newslist_txtcontent');
                reloadData();
            },
            success: function (layero, index) {
                window.editor = KindEditor.create('#newslist_txtcontent', {
                    height: '300px',
                    width: '840px',
                    allowImageUpload: true,
                    uploadJson: '<%=basePath%>newsupload/uploadjson',
                    allowFileManager: false,
                    items: ['fontname', 'fontsize', '|', 'forecolor', 'hilitecolor',
                        'bold', 'italic', 'underline', 'removeformat', '|',
                        'justifyleft', 'justifycenter', 'justifyright',
                        'insertorderedlist', 'insertunorderedlist', '|', 'emoticons',
                        'image', 'insertfile', 'link']
                });
            }
        });
    }
    //增加一条信息
    function newsadd() {
        editor.sync();//把editor内容赋值给textarea
        if($('#newslist_txttitle').val()==""){
            layer.msg("信息标题不能为空", {icon: 2});
            $('#newslist_txttitle').focus();
            return false;
        }
        if($('#newslist_txtcontent').val()==""){
            layer.msg("信息内容不能为空", {icon: 2});
            $('#newslist_txtcontent').focus();
            return false;
        }
        var iswb = "0", iswx = "0", isapp = "0";
        if ($("#rdwb").is(":checked")) {
            iswb = "1";
        }
        if ($("#rdwx").is(":checked")) {
            iswx = "1";
        }
        if ($("#rdapp").is(":checked")) {
            isapp = "1";
        }
        $.post("<%=basePath%>news/add", {
            "title": $('#newslist_txttitle').val(),
            "content": $('#newslist_txtcontent').val(),
            "menucode": $('#newslist_hidmenucode').val(),
            "iswb": iswb,
            "iswx": iswx,
            "isapp": isapp
        }, function (data, status) {
            if (status == "success") {
                if (data == "1") {
                    layer.msg('添加成功', {icon: 1});
                } else {
                    if (data == "2") {
                        layer.msg('添加失败：菜单代码已经存在', {icon: 2});
                    } else {
                        layer.msg(data, {icon: 2});
                    }
                }
            }
            else {
                layer.msg('网络问题导致添加信息失败', {icon: 2});
            }
        });
    }
    //弹出修改信息窗口
    function newsup() {
        editor.sync();
        if($('#newslist_txttitle').val()==""){
            layer.msg("信息标题不能为空", {icon: 2});
            $('#newslist_txttitle').focus();
            return false;
        }
        if($('#newslist_txtcontent').val()==""){
            layer.msg("信息内容不能为空", {icon: 2});
            $('#newslist_txtcontent').focus();
            return false;
        }
        var uptime = $("#newslist_txtupdatetime").val();
        if($('#newslist_txtupdatetime').val()==""){
            layer.msg("信息修改时间不能为空", {icon: 2});
            $('#newslist_txtupdatetime').focus();
            return false;
        }
        var iswb = "0", iswx = "0", isapp = "0";
        if ($("#rdwb").is(":checked")) {
            iswb = "1";
        }
        if ($("#rdwx").is(":checked")) {
            iswx = "1";
        }
        if ($("#rdapp").is(":checked")) {
            isapp = "1";
        }
        //
        $.post("<%=basePath%>news/updatebynid", {
            "nid": $("#newslist_hidpid").val(),
            "title": $('#newslist_txttitle').val(),
            "content": $('#newslist_txtcontent').val(),
            "menucode": $('#newslist_hidmenucode').val(),
            "iswb": iswb,
            "iswx": iswx,
            "isapp": isapp,
            "uptime": uptime
        }, function (data, status) {
            if (status == "success") {
                if (data == "1") {
                    layer.msg('修改成功', {icon: 1});
                } else {
                    layer.msg(data, {icon: 2});
                }
            }
            else {
                layer.msg('网络问题导致添加信息失败', {icon: 2});
            }
        });
    }
    function closeW() {
        layer.close(myindex);
    }
</script>
<jsp:include page="/WEB-INF/pages/master/footerlayui.jsp"></jsp:include>