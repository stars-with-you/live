<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
  User: fanglei
  Date: 2018-09-06
  Time: 15:13
--%>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<jsp:include page="/WEB-INF/pages/master/headlayui.jsp"></jsp:include>
<link rel="stylesheet" href="<%=basePath%>js/survey/css/wenjuan_ht.css">
<style>
    .tmtool {
        width: 200px;
        float: left;
    }

    .tmtool p {
        line-height: 30px;
        font-size: 14px;
        letter-spacing: 5px;
        cursor: pointer;
        padding: 4px 20px;
    }

    .tmtool p:hover {
        background-color: #5f646e;
        color: #fff;
    }

    .movie_box {
        border-bottom: 1px solid #ccc;
    }
</style>
<div class="layui-body">
    <div class="tmtool">
        <div class="layui-card">
            <div class="layui-card-header">
                <h2>创建题目</h2>
            </div>
            <div class="layui-card-body" style="padding: 0">
                <p onclick="addtm('0')">>单选题+</p>
                <p onclick="addtm('1')">>多选题+</p>
                <%--<p onclick="addtmx('2')">>填空题+</p>--%>
            </div>
        </div>
    </div>
    <div class="all_660" style="padding-top: 10px;height: auto;border: 1px solid #1E9FFF;border-radius: 4px 3px;">
        <div style="text-align:center;">
            <c:if test="${bz=='1'}">
                <div><h2>创建调查</h2></div>
            </c:if>
            <c:if test="${bz=='0'}">
                <div><h2>修改调查</h2>
                    <input type="hidden" id="txtsid" value="${sm.sid}"/>
                </div>
            </c:if>
            <label style="margin-left: 10px;float: left;font-size: 16px;">调查标题:</label>
            <input type="text" id="txtbt" placeholder="调查标题" value="${sm.stitle}" class="layui-input">
            <label style="margin-left: 10px;float: left;font-size: 16px;margin-top: 15px;">调查说明:</label>
            <textarea id="txtms" placeholder="调查说明" class="layui-textarea">${sm.sms}</textarea>
        </div>
        <div class="yd_box" style="overflow: auto;height: auto;">
            <c:forEach items="${qlist}" var="item">
                <div class="movie_box">
                    <ul class="wjdc_list">
                        <li>
                            <div class="tm_btitlt"><i class="nmb">${item.getsQuestion().getQindex()}</i>. <i
                                    class="btwenzi">${item.getsQuestion().getQtitle()}</i><span class="tip_wz">
                                <c:choose>
                                    <c:when test="${item.getsQuestion().getQcata()=='0'}">【单选】</c:when>
                                    <c:when test="${item.getsQuestion().getQcata()=='1'}">【多选】</c:when>
                                    <c:when test="${item.getsQuestion().getQcata()=='2'}">【填空】</c:when>
                                </c:choose>
                            </span>
                            </div>
                        </li>
                        <c:if test="${item.getsQuestion().getQcata()=='2'}">
                            <textarea name="" cols="" rows="" class="input_wenbk btwen_text btwen_text_dx"></textarea>
                        </c:if>
                        <c:forEach items="${item.getXx()}" var="xx">
                            <li><label>
                                <c:choose>
                                    <c:when test="${item.getsQuestion().getQcata()=='0'}"><input name="${item.getsQuestion().getQid()}" type="radio" /><span>${xx}</span></c:when>
                                    <c:when test="${item.getsQuestion().getQcata()=='1'}"><input name="${item.getsQuestion().getQid()}" type="checkbox" /><span>${xx}</span></c:when>
                                </c:choose>

                                </label></li>
                        </c:forEach>
                    </ul>
                    <div class="dx_box" data-t="${item.getsQuestion().getQcata()}" style="display: none;"></div>
                </div>
            </c:forEach>

        </div>
        <div style="margin: 0 auto;text-align: center;padding: 0;">
            <c:if test="${bz=='1'}">
                <a class="layui-btn  layui-btn-normal layui-btn-sm" onclick="save()" style="margin: 0 auto;">保存</a>
            </c:if>
            <c:if test="${bz=='0'}">
                <a class="layui-btn  layui-btn-normal layui-btn-sm" onclick="update()" style="margin: 0 auto;">修改</a>
            </c:if>
            <a class="layui-btn  layui-btn-normal layui-btn-sm" href="<%=basePath%>survey/list" style="margin: 0 auto;">返回</a>
        </div>
        <!--选项卡区域  模板区域------------------------------------------------------------------------------->
        <div class="xxk_box">
            <div class="xxk_conn hide">
                <!--单选----------------------------------------------------------------------------------------------->
                <div class="xxk_xzqh_box dxuan ">
                    <textarea name="" cols="" rows="" class="input_wenbk btwen_text btwen_text_dx"
                              placeholder="单选题目"></textarea>
                    <div class="title_itram">
                        <div class="kzjxx_iteam">
                            <input type="text" class="input_wenbk" placeholder="选项">
                            <a href="javascript:void(0);" class="del_xm" onclick="delrow(this)">删除</a>
                        </div>
                    </div>
                    <a href="javascript:void(0)" class="zjxx" onclick="addxx(this)">增加选项</a>
                    <!--完成编辑-->
                    <div class="bjqxwc_box">
                        <a href="javascript:void(0);" class="qxbj_but" onclick="qxbj(this)">取消编辑</a>
                        <a href="javascript:void(0);" class="swcbj_but" onclick="wcbj(this)"> 完成编辑</a>
                    </div>
                </div>
                <!--多选-------------------------------------------------------------------------------------->
                <div class="xxk_xzqh_box duoxuan hide">
                    <textarea name="" cols="" rows="" class="input_wenbk btwen_text btwen_text_duox"
                              placeholder="多选题目"></textarea>
                    <div class="title_itram">
                        <div class="kzjxx_iteam">
                            <input type="text" class="input_wenbk" placeholder="选项">
                            <a href="javascript:void(0);" class="del_xm" onclick="delrow(this)">删除</a>
                        </div>
                    </div>
                    <a href="javascript:void(0)" class="zjxx"  onclick="addxx(this)">增加选项</a>
                    <!--完成编辑-->
                    <div class="bjqxwc_box">
                        <a href="javascript:void(0);" class="qxbj_but"  onclick="qxbj(this)">取消编辑</a>
                        <a href="javascript:void(0);" class="swcbj_but"  onclick="wcbj(this)"> 完成编辑</a>
                    </div>
                </div>
                <!-- 填空------------------------------------------------------------------------------------>
                <div class="xxk_xzqh_box tktm hide">
                    <textarea name="" cols="" rows="" class="input_wenbk btwen_text btwen_text_tk"
                              placeholder="答题区"></textarea>
                    <!--完成编辑-->
                    <div class="bjqxwc_box">
                        <a href="javascript:void(0);" class="qxbj_but"  onclick="qxbj(this)">取消编辑</a>
                        <a href="javascript:void(0);" class="swcbj_but"  onclick="wcbj(this)"> 完成编辑</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var layer = null;
        layui.use(['table', 'layer', 'laydate', 'element', 'form'], function () {
            var table = layui.table, laydate = layui.laydate, element = layui.element, form = layui.form;
            layer = layui.layer;
        });

        function addtmx(index) {
            switch (index) {
                case "1":
                    layer.msg('暂不支持多选题！', {icon: 2});
                    break;
                case "2":
                    layer.msg('暂不支持填空题！', {icon: 2});
                    break;
            }
        }

        function save() {
            if ($("#txtbt").val() == "") {
                layer.msg('请填写调查标题！', {icon: 2});
                return;
            }
            var tm = $(".wjdc_list");
            if (tm.length < 1) {
                layer.msg('您还没有添加调查问题！', {icon: 2});
                return;
            }
            var sarr = [];
            for (var i = 0; i < tm.length; i++) {
                var nmb = $(tm[i]).find(".tm_btitlt .nmb").text();
                var btwenzi = $(tm[i]).find(".tm_btitlt .btwenzi").text();
                btwenzi = btwenzi.replace(",", "，").trim();
                var tip_wz = $(tm[i]).find(".tm_btitlt .tip_wz").text().trim();

                var qcata = "";
                switch (tip_wz) {
                    case "【单选】":
                        qcata = "0";
                        break;
                    case "【多选】":
                        qcata = "1";
                        break;
                    case "【填空】":
                        qcata = "2";
                        break;
                    default:
                        qcata = "0";
                        break;
                }

                var aarr = $(tm[i]).find("li label span");
                if(qcata=="1" || qcata=="0") {
                    if (aarr.length < 1) {
                        layer.msg('第' + (i + 1) + '个问题没有答案选项！', {icon: 2});
                        return;
                    }
                }
                var xx = [];
                if(qcata=="1" || qcata=="0") {
                    for (var j = 0; j < aarr.length; j++) {
                        var xxstr = $(aarr[j]).text().trim();
                        if (xxstr == "") {
                            layer.msg('第' + (i + 1) + '个问题第' + (j + 1) + '个答案选项不能为空！', {icon: 2});
                            return;
                        }
                        else {
                            xx.push(xxstr);
                        }
                    }
                }
                var json = {"qindex": nmb, "qtitle": btwenzi, "qcata": qcata, "xx": xx};
                sarr.push(json);
            }
            $.post("<%=basePath%>survey/add", {
                "stitle": $('#txtbt').val(),
                "sms": $('#txtms').val(),
                "qstr": JSON.stringify(sarr),
            }, function (data, status) {
                if (status == "success") {
                    if (data == "1") {
                        layer.msg('添加成功', {icon: 1});
                    } else {
                        if (data == "2") {
                            layer.msg('添加失败', {icon: 2});
                        } else {
                            layer.msg('添加失败', {icon: 2});
                        }
                    }
                }
                else {
                    layer.msg('网络问题导致添加信息失败', {icon: 2});
                }
            });
        }

        function update() {
            if ($("#txtbt").val() == "") {
                layer.msg('请填写调查标题！', {icon: 2});
                return;
            }
            var tm = $(".wjdc_list");
            if (tm.length < 1) {
                layer.msg('您还没有添加调查问题！', {icon: 2});
                return;
            }
            var sarr = [];
            for (var i = 0; i < tm.length; i++) {
                var nmb = $(tm[i]).find(".tm_btitlt .nmb").text();
                var btwenzi = $(tm[i]).find(".tm_btitlt .btwenzi").text();
                btwenzi = btwenzi.replace(",", "，").trim();
                var tip_wz = $(tm[i]).find(".tm_btitlt .tip_wz").text().trim();

                var qcata = "";
                switch (tip_wz) {
                    case "【单选】":
                        qcata = "0";
                        break;
                    case "【多选】":
                        qcata = "1";
                        break;
                    case "【填空】":
                        qcata = "2";
                        break;
                    default:
                        qcata = "0";
                        break;
                }
                if(qcata=="1" || qcata=="0") {
                var aarr = $(tm[i]).find("li label span");
                    if (aarr.length < 1) {
                        layer.msg('第' + (i + 1) + '个问题没有答案选项！', {icon: 2});
                        return;
                    }
                var xx = [];
                    for (var j = 0; j < aarr.length; j++) {
                        var xxstr = $(aarr[j]).text().trim();
                        if (xxstr == "") {
                            layer.msg('第' + (i + 1) + '个问题第' + (j + 1) + '个答案选项不能为空！', {icon: 2});
                            return;
                        }
                        else {
                            xx.push(xxstr);
                        }
                    }
                }
                var json = {"qindex": nmb, "qtitle": btwenzi, "qcata": qcata, "xx": xx};
                sarr.push(json);
            }
            $.post("<%=basePath%>survey/startupdate", {
                "sid": $("#txtsid").val(),
                "stitle": $('#txtbt').val(),
                "sms": $('#txtms').val(),
                "qstr": JSON.stringify(sarr),
            }, function (data, status) {
                if (status == "success") {
                    if (data == "1") {
                        layer.msg('修改成功', {icon: 1});
                    } else {
                        if (data == "2") {
                            layer.msg('修改失败', {icon: 2});
                        } else {
                            layer.msg('修改失败', {icon: 2});
                        }
                    }
                }
                else {
                    layer.msg('网络问题导致添加信息失败', {icon: 2});
                }
            });
        }
    </script>
    <script>
        function addtm(index) {
            var movie_box = '<div class="movie_box"></div>';
            var Grade = $(".yd_box").find(".movie_box").length + 1;
            switch (index) {
                case "0": //单选
                case "1": //多选
                case "2": //填空
                    var wjdc_list = '<ul class="wjdc_list"></ul>'; //填空 单选 多选
                    var danxuan = "";
                    if (index == "0") {
                        danxuan = '【单选】';
                    } else if (index == "1") {
                        danxuan = '【多选】';
                    } else if (index == "2") {
                        danxuan = '【填空】';
                    }
                    wjdc_list = $(wjdc_list).append(' <li><div class="tm_btitlt"><i class="nmb">' + Grade + '</i>. <i class="btwenzi">请编辑问题？</i><span class="tip_wz">' + danxuan + '</span></div></li>');
                    if (index == "2") {
                        wjdc_list = $(wjdc_list).append('<li>  <label> <textarea name="" cols="" rows="" class="input_wenbk btwen_text btwen_text_dx" ></textarea></label> </li>');
                    }
                    movie_box = $(movie_box).append(wjdc_list);
                    movie_box = $(movie_box).append('<div class="dx_box" data-t="' + index + '"></div>');
                    break;
            }
            $(movie_box).hover(function () {
                var html_cz = "<div class='kzqy_czbut'><a href='javascript:void(0)' class='sy' onclick='sy(this)'>上移</a><a href='javascript:void(0)'  class='xy' onclick='xy(this)'>下移</a><a href='javascript:void(0)'  class='bianji' onclick='surveybj(this)'>编辑</a><a href='javascript:void(0)' class='del' onclick='deltm(this)' >删除</a></div>";
                $(this).children(".wjdc_list").after(html_cz);
            }, function () {
                $(this).children(".kzqy_czbut").remove();
            });
            $(".yd_box").append(movie_box);
        }

        $(function () {
            $(".movie_box").each(function () {
                var e = this;
                $(e).hover(function () {
                    var html_cz = "<div class='kzqy_czbut'><a href='javascript:void(0)' class='sy' onclick='sy(this)'>上移</a><a href='javascript:void(0)'  class='xy' onclick='xy(this)'>下移</a><a href='javascript:void(0)'  class='bianji' onclick='surveybj(this)'>编辑</a><a href='javascript:void(0)' class='del' onclick='deltm(this)' >删除</a></div>";
                    $(e).children(".wjdc_list").after(html_cz);
                }, function () {
                    $(e).children(".kzqy_czbut").remove();
                })
            });
        });

        function xy(e) {
            //文字的长度
            var leng = $(".yd_box").children(".movie_box").length;
            var dqgs = $(e).parent(".kzqy_czbut").parent(".movie_box").index();

            if (dqgs < leng - 1) {
                var czxx = $(e).parent(".kzqy_czbut").parent(".movie_box");
                var xyghtml = czxx.next().html();
                var syghtml = czxx.html();
                czxx.next().html(syghtml);
                czxx.html(xyghtml);
                //序号
                czxx.children(".wjdc_list").find(".nmb").text(dqgs + 1);
                czxx.next().children(".wjdc_list").find(".nmb").text(dqgs + 2);
            } else {
                alert("到底了");
            }
        }

        function sy(e) {
            //文字的长度
            var leng = $(".yd_box").children(".movie_box").length;
            var dqgs = $(e).parent(".kzqy_czbut").parent(".movie_box").index();
            if (dqgs > 0) {
                var czxx = $(e).parent(".kzqy_czbut").parent(".movie_box");
                var xyghtml = czxx.prev().html();
                var syghtml = czxx.html();
                czxx.prev().html(syghtml);
                czxx.html(xyghtml);
                //序号
                czxx.children(".wjdc_list").find(".nmb").text(dqgs + 1);
                czxx.prev().children(".wjdc_list").find(".nmb").text(dqgs);

            } else {
                alert("到头了");
            }
        }

        //删除一道题目
        function deltm(e) {
            var czxx = $(e).parent(".kzqy_czbut").parent(".movie_box");
            var par = czxx.parent(".yd_box");
            var xh_num = 1;
            czxx.remove();
            //重新编号
            par.find(".movie_box").each(function () {
                par.children(".movie_box").eq(xh_num - 1).find(".nmb").text(xh_num);
                xh_num++;
            });
        }

        //编辑
        function surveybj(e) {
            //编辑的时候禁止其他操作
            //$(e).siblings().hide();
            //$(this).parent(".kzqy_czbut").parent(".movie_box").unbind("hover");
            var dxtm = $(".dxuan").html();
            var duoxtm = $(".duoxuan").html();
            var tktm = $(".tktm").html();
            var jztm = $(".jztm").html();
            //接受编辑内容的容器
            var dx_rq = $(e).parent(".kzqy_czbut").parent(".movie_box").find(".dx_box");
            var title = dx_rq.attr("data-t");
            //alert(title);
            //题目选项的个数
            var timlrxm = $(e).parent(".kzqy_czbut").parent(".movie_box").children(".wjdc_list").children("li").length;

            //单选题目
            if (title == 0) {
                dx_rq.show().html(dxtm);
                //模具题目选项的个数
                var bjxm_length = dx_rq.find(".title_itram").children(".kzjxx_iteam").length;
                var dxtxx_html = dx_rq.find(".title_itram").children(".kzjxx_iteam").html();
                //添加选项题目
                for (var i_tmxx = bjxm_length; i_tmxx < timlrxm - 1; i_tmxx++) {
                    dx_rq.find(".title_itram").append("<div class='kzjxx_iteam'>" + dxtxx_html + "</div>");
                }
                //赋值文本框
                //题目标题
                var texte_bt_val = $(e).parent(".kzqy_czbut").parent(".movie_box").find(".wjdc_list").children("li").eq(0).find(".tm_btitlt").children(".btwenzi").text();
                dx_rq.find(".btwen_text").val(texte_bt_val);
                //遍历题目项目的文字
                var bjjs = 0;
                $(e).parent(".kzqy_czbut").parent(".movie_box").find(".wjdc_list").children("li").each(function () {
                    //可选框框
                    var ktksfcz = $(this).find("input").hasClass("wenb_input");
                    if (ktksfcz) {
                        var jsxz_kk = $(this).index();
                        dx_rq.find(".title_itram").children(".kzjxx_iteam").eq(jsxz_kk - 1).find("label").remove();
                    }
                    //题目选项
                    var texte_val = $(this).find("span").text();
                    dx_rq.find(".title_itram").children(".kzjxx_iteam").eq(bjjs - 1).find(".input_wenbk").val(texte_val);
                    bjjs++

                });
            }
            //多选题目
            if (title == 1) {
                dx_rq.show().html(duoxtm);
                //模具题目选项的个数
                var bjxm_length = dx_rq.find(".title_itram").children(".kzjxx_iteam").length;
                var dxtxx_html = dx_rq.find(".title_itram").children(".kzjxx_iteam").html();
                //添加选项题目
                for (var i_tmxx = bjxm_length; i_tmxx < timlrxm - 1; i_tmxx++) {
                    dx_rq.find(".title_itram").append("<div class='kzjxx_iteam'>" + dxtxx_html + "</div>");
                    //alert(i_tmxx);
                }
                //赋值文本框
                //题目标题
                var texte_bt_val = $(e).parent(".kzqy_czbut").parent(".movie_box").find(".wjdc_list").children("li").eq(0).find(".tm_btitlt").children(".btwenzi").text();
                dx_rq.find(".btwen_text").val(texte_bt_val);
                //遍历题目项目的文字
                var bjjs = 0;
                $(e).parent(".kzqy_czbut").parent(".movie_box").find(".wjdc_list").children("li").each(function () {
                    //可选框框
                    var ktksfcz = $(this).find("input").hasClass("wenb_input");
                    if (ktksfcz) {
                        var jsxz_kk = $(this).index();
                        dx_rq.find(".title_itram").children(".kzjxx_iteam").eq(jsxz_kk - 1).find("label").remove();
                    }
                    //题目选项
                    var texte_val = $(this).find("span").text();
                    dx_rq.find(".title_itram").children(".kzjxx_iteam").eq(bjjs - 1).find(".input_wenbk").val(texte_val);
                    bjjs++

                });
            }
            //填空题目
            if (title == 2) {
                dx_rq.show().html(tktm);
                //赋值文本框
                //题目标题
                var texte_bt_val = $(e).parent(".kzqy_czbut").parent(".movie_box").find(".wjdc_list").children("li").eq(0).find(".tm_btitlt").children(".btwenzi").text();
                dx_rq.find(".btwen_text").val(texte_bt_val);
            }
            //矩阵题目
            if (title == 3) {
                dx_rq.show().html(jztm);
            }
        }

        function addxx(e) {
            var zjxx_html = $(e).prev(".title_itram").children(".kzjxx_iteam").html();
            $(e).prev(".title_itram").append("<div class='kzjxx_iteam'>" + zjxx_html + "</div>");
        }

        function delrow(e) {
            //获取编辑题目的个数
            var zuxxs_num = $(e).parent(".kzjxx_iteam").parent(".title_itram").children(".kzjxx_iteam").length;
            if (zuxxs_num > 1) {
                $(e).parent(".kzjxx_iteam").remove();
            } else {
                alert("手下留情");
            }
        }

        //取消编辑
        function qxbj(e) {
            $(e).parent(".bjqxwc_box").parent(".dx_box").empty().hide();
            $(".kzqy_czbut").remove();
            //
        }

        //完成编辑（编辑）
        function wcbj(e) {
            var jcxxxx = $(e).parent(".bjqxwc_box").parent(".dx_box"); //编辑题目区
            var querstionType = jcxxxx.attr("data-t"); //获取题目类型
            switch (querstionType) {
                case "0": //单选
                case "1": //多选
                    //编辑题目选项的个数
                    var bjtm_xm_length = jcxxxx.find(".title_itram").children(".kzjxx_iteam").length; //编辑选项的 选项个数
                    var xmtit_length = jcxxxx.parent(".movie_box").children(".wjdc_list").children("li").length - 1; //题目选择的个数
                    //赋值文本框
                    //题目标题
                    var texte_bt_val_bj = jcxxxx.find(".btwen_text").val(); //获取问题题目
                    jcxxxx.parent(".movie_box").children(".wjdc_list").children("li").eq(0).find(".tm_btitlt").children(".btwenzi").text(texte_bt_val_bj); //将修改过的问题题目展示

                    //删除选项
                    for (var toljs = xmtit_length; toljs > 0; toljs--) {
                        jcxxxx.parent(".movie_box").children(".wjdc_list").children("li").eq(toljs).remove();
                    }
                    //遍历题目项目的文字
                    var bjjs_bj = 0;
                    jcxxxx.children(".title_itram").children(".kzjxx_iteam").each(function () {
                        //题目选项
                        var texte_val_bj = $(this).find(".input_wenbk").val(); //获取填写信息
                        var inputType = 'radio';
                        //jcxxxx.parent(".movie_box").children(".wjdc_list").children("li").eq(bjjs_bj + 1).find("span").text(texte_val_bj);
                        if (querstionType == "1") {
                            inputType = 'checkbox';
                        }
                        var li = '<li><label><input name="a" type="' + inputType + '" value=""><span>' + texte_val_bj + '</span></label></li>';
                        jcxxxx.parent(".movie_box").children(".wjdc_list").append(li);

                        bjjs_bj++
                        //可填空
                        var kxtk_yf = $(this).find(".fxk").is(':checked');
                        if (kxtk_yf) {
                            //第几个被勾选
                            var jsxz = $(this).index();
                            //alert(jsxz);
                            jcxxxx.parent(".movie_box").children(".wjdc_list").children("li").eq(jsxz + 1).find("span").after("<input name='' type='text' class='wenb_input'>");
                        }
                    });

                    break;
                case "2":
                    var texte_bt_val_bj = jcxxxx.find(".btwen_text").val(); //获取问题题目
                    jcxxxx.parent(".movie_box").children(".wjdc_list").children("li").eq(0).find(".tm_btitlt").children(".btwenzi").text(texte_bt_val_bj); //将修改过的问题题目展示
                    break;
            }
            //清除
            $(e).parent(".bjqxwc_box").parent(".dx_box").empty().hide();
        }
    </script>
</div>
<jsp:include page="/WEB-INF/pages/master/footerlayui.jsp"></jsp:include>