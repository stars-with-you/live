<%--
  User: fanglei
  Date: 2018-09-30
  Time: 9:53
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<html>
<head>
    <title>Title</title>
    <style>
        .figure-list {
            margin: 0;
            padding: 0;
        }
        .figure-list:after{
            content: "";
            display: block;
            clear: both;
            height: 0;
            overflow: hidden;
            visibility: hidden;
        }
        .figure-list li {
            list-style: none;
            float: left;
            width: 31.33%;
            margin: 0 1% 1% 1%;
            padding: 0;
        }

        .figure-list figure {
            border: none;
            width: 100%;
            height: 0;
            overflow: hidden;
            margin: 0;
            padding-bottom: 100%; /* 关键就在这里 */
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
        }
    </style>
</head>
<body>

<div style="width: 400px;margin: 0 auto;border: 1px solid #d98102;">

            <div style="background-image: url('<%=basePath%>images/test/33.jpg');background-size: auto 100%;padding-bottom: 100%;background-position: center; background-repeat: no-repeat;max-height: 100px;width: auto"></div>
    <ul class="figure-list">
        <li style="width: 100%;margin: 0;">
            <figure style="background-image: url('<%=basePath%>images/test/66.jpg');background-size: 100% auto ;width: auto;" ></figure>
        </li>
    </ul>
    <ul class="figure-list">
        <li>
            <figure style="background-image: url('<%=basePath%>images/test/11.jpg');"></figure>
        </li>
        <li>
            <figure style="background-image: url('<%=basePath%>images/test/22.jpg');" ></figure>
        </li>
        <li>
            <figure style="background-image: url('<%=basePath%>images/test/33.jpg');" ></figure>
        </li>
        <li>
            <figure style="background-image: url('<%=basePath%>images/test/44.jpg');" ></figure>
        </li>
        <li>
            <figure style="background-image: url('<%=basePath%>images/test/55.jpg');" ></figure>
        </li>
        <li>
            <figure style="background-image: url('<%=basePath%>images/test/66.jpg');" ></figure>
        </li>
        <li>
            <figure style="background-image: url('<%=basePath%>images/test/77.jpg');" ></figure>
        </li>
        <li>
            <figure style="background-image: url('<%=basePath%>images/test/88.jpg');" ></figure>
        </li>
        <li>
            <figure style="background-image: url('<%=basePath%>images/test/99.jpg');" ></figure>
        </li>
        <li>
            <figure style="background-image: url('<%=basePath%>images/test/1010.jpg');" ></figure>
        </li>
    </ul>
</div>

</body>
</html>
