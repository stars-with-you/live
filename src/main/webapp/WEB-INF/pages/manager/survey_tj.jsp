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
            <span id="Title"> ${sm.stitle}统计</span></h1>

    </div>
    <c:if test="${sm.sms!=''}">
        <div style="margin-left: 15px;font-size: 12px;">${sm.sms}</div>
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
                                        <div class="weui-cell__bd">
                                            <p>${xx.getAtext()}</p>

                                            <div class="weui-progress" style="width: 98%; ">
                                                <div class="weui-progress__bar">
                                                    <div class="weui-progress__inner-bar js_progress"
                                                         style="width:${xx.avalue/xx.asort*100}%;"></div>
                                                </div>

                                                    ${xx.avalue}/${xx.asort}(<fmt:formatNumber type="number"  maxFractionDigits="2" value="${xx.avalue/xx.asort*100}" pattern="0.00" />%)
                                            </div>
                                        </div>
                                    </label>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div id="divPowerBy" style="margin: 0 auto;" class="logofooter">
            <div class='wjfooter'> 技术支持：江苏省金茂国际电子商务有限公司</div>
        </div>
    </div>
</form>
</body>
</html>
