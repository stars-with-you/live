<%--
  User: fanglei
  Date: 2018-09-11
  Time: 9:43
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="renderer" content="webkit"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, minimum-scale=1, maximum-scale=1,user-scalable=no">

    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="金茂图文直播">
    <meta name="author" content="fl">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="金茂图文直播,江苏金茂图文,江苏金茂图文直播,江苏金茂图文直播系统">
    <link rel="shortcut icon" href="<%=basePath%>images/index_PC_01.png">
    <title>问卷调查</title>
    <link rel="stylesheet" href="<%=basePath%>css/Jqmobo.css"/>
    <link rel="stylesheet" href="<%=basePath%>js/jquery-weui/lib/weui.min.css">
    <link rel="stylesheet" href="<%=basePath%>js/jquery-weui/css/jquery-weui.min.css">
    <script src="<%=basePath%>js/jquery-1.12.4.js"></script>
    <script>
        function GetQueryString(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return unescape(r[2]);
            return null;
        }

        var openid = GetQueryString("openid");
        if (openid == null || openid == "" || typeof (openid) == "undefined") {
            location.href = "<%=basePath%>wx/getcode?state=" + encodeURIComponent(encodeURIComponent(location.href)) + "&scope=snsapi_userinfo";
        }
    </script>
    <style>
        .jqradiowrapper, .jqcheckwrapper {
            margin: 11px 4px 0px 11px;
        }
    </style>
</head>
<body>
<form>

    <div id="toptitle">
        <h1 class="htitle">
            <span id="Title"> ${sm.stitle}</span></h1>

    </div>
    <c:if test="${sm.sms!=''}">
        <div style="margin-left: 15px;font-size: 17px;margin-top: 15px;">${sm.sms}</div>
    </c:if>
    <div>
        <div>
            <c:forEach items="${qlist}" var="item">
                <div class='field ui-field-contain' qid="${item.getsQuestion().getQid()}">
                    <div class='field-label'>${item.getsQuestion().getQindex()}.${item.getsQuestion().getQtitle()}
                        <c:choose>
                            <c:when test="${item.getsQuestion().getQcata()=='0'}">【单选】</c:when>
                            <c:when test="${item.getsQuestion().getQcata()=='1'}">【多选】</c:when>
                            <c:when test="${item.getsQuestion().getQcata()=='2'}">【填空】</c:when>
                            <c:otherwise></c:otherwise>
                        </c:choose>:
                    </div>
                    <div class='ui-controlgroup'>
                        <div class="weui-cells weui-cells_checkbox">
                            <c:forEach items="${alist}" var="xx" varStatus="status">
                                <c:if test="${xx.getQid()==item.getsQuestion().getQid()}">
                                    <label class="weui-cell weui-check__label"
                                           for="${item.getsQuestion().getQid()}${status.index}">
                                        <div class="weui-cell__hd">

                                            <c:choose>
                                                <c:when test="${item.getsQuestion().getQcata()=='0'}"><input
                                                        type="radio" class="weui-check"
                                                        name="${item.getsQuestion().getQid()}"
                                                        id="${item.getsQuestion().getQid()}${status.index}"
                                                        value="${xx.getAid()}"></c:when>
                                                <c:when test="${item.getsQuestion().getQcata()=='1'}"><input
                                                        type="checkbox" class="weui-check"
                                                        name="${item.getsQuestion().getQid()}"
                                                        id="${item.getsQuestion().getQid()}${status.index}"
                                                        value="${xx.getAid()}"></c:when>
                                            </c:choose>
                                            <i class="weui-icon-checked"></i>
                                        </div>
                                        <div class="weui-cell__bd">
                                            <p>${xx.getAtext()}</p>
                                        </div>
                                    </label>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <div class='field'>
                <div class='field-label'>姓名：</div>
                <div class='ui-input-text' style='position:relative;'>
                    <input type='text' id='txtdisplayname' style='padding-left:15px;' maxlength='200'/>
                </div>
            </div>
            <div class='field'>
                <div class='field-label'>公司名称：</div>
                <div class='ui-input-text' style='position:relative;'>
                    <input type='text' id='txtcompany' style='padding-left:15px;' maxlength='200'/>
                </div>
            </div>
            <div class='field'>
                <div class='field-label'>联系手机(我们将在三个工作日内为前500名参与调查问卷的手机号码充值10元话费)：</div>
                <div class='ui-input-text' style='position:relative;'>
                    <input type='text' id='txttel' style='padding-left:15px;' maxlength='200'/>
                </div>
            </div>
            <div class="footer">
                <input type="hidden" value="${sm.sid}">
                <a id="ctlNext" href="javascript:;" class="button blue">提交</a>
            </div>

        </div>
        <div id="divPowerBy" style="margin: 0 auto;" class="logofooter">
            <div class='wjfooter'> 技术支持：江苏省金茂国际电子商务有限公司</div>
        </div>
    </div>
</form>
<script src="<%=basePath%>js/jquery-weui/lib/fastclick.js"></script>
<script>
    $(function () {
        FastClick.attach(document.body);
    });
</script>
<script src="<%=basePath%>js/jquery-weui/js/jquery-weui.js"></script>
<script>
    $(function () {
        $("#ctlNext").click(function () {
            var e = $(".ui-field-contain");
            if (e.length > 0) {
                var sarr = [];
                for (var i = 0; i < e.length; i++) {
                    var qid = $(e[i]).attr("qid");
                    var ck = $(e[i]).find(":checked")
                    if (ck.length < 1) {
                        $.toast("第" + (i + 1) + "个问题没有选择答案", "cancel");
                        return;
                        break;
                    }
                    for (var j = 0; j < ck.length; j++) {
                        var answer = $(ck[j]).val();
                        var json = {"qid": qid, "aid": answer};
                        sarr.push(json);
                    }
                }
                var displayname = $("#txtdisplayname").val();
                if (displayname == "") {
                    $.toast("请填写姓名", "cancel");
                    return;
                }
                var company = $("#txtcompany").val();
                if (company == "") {
                    $.toast("请填写公司名称", "cancel");
                    return;
                }
                var tel = $("#txttel").val();
                var reg = /^1\d{10}$/;
                if (!reg.test(tel)) {
                    $.toast("请填写正确的手机号", "cancel");
                    return;
                }
                openid=openid.trim();
                $.post("<%=basePath%>survey/reply/add", {
                    "sid": "${sm.sid}",
                    "tel": tel,
                    "company": company,
                    "displayname": displayname,
                    "openid": openid,
                    "rstr": JSON.stringify(sarr)

                }, function (data, status) {
                    if (status == "success") {
                        if (data == "1") {
                            $.toast("提交成功");
                            location.href="<%=basePath%>survey/answer2/message";
                        } else {
                            if (data == "3") {
                                $.toast("此手机号已经调查过了，请重填手机号！", "cancel");
                            } else {
                                if (data == "4") {
                                    $.toast("每个微信号只能填写一次调查！", "cancel");
                                } else {
                                    $.toast("提交失败", "cancel");
                                }
                            }
                        }
                    }
                    else {
                        $.toast("提交失败", "cancel");
                    }
                });
            }
        });
    });
</script>
</body>
</html>
