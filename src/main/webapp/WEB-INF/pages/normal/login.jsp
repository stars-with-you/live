<%--
  Created: 方磊
  Date: 2017年8月18日  下午3:27:51
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="<%=basePath%>xx/xx.css" rel="stylesheet">
    <title>Insert title here</title>
    <style>
.login_bg{
	text-align:center;
	background: url(<%=basePath%>images/bgs/body_bg2.png) no-repeat top center #ebf3f8; 
}
.login-wrapper{ 
	margin-top:100px;
}
.reg_index{
	 width:520px;
	 height:350px; 
	 border-radius:20px; 
	 background: #f1f4f8; 
	 margin:30px auto 20px auto; 
	 border:10px solid #fff;
	}
.login-wrapper .box .content-wrap {
    width: 400px;
    margin: 0 auto;
}
.login-wrapper .box {
    margin: 0 auto;
    padding: 35px 0 30px;
    float: none;
    width: 400px;
}
.login-wrapper .box h6 {
    text-transform: uppercase;
    margin: 0 0 30px 0;
    font-size: 18px;
    font-weight: 600;
}
ul, ol {
    padding: 0;
    margin: 0 0 10px 5px;
}
li {
    line-height: 20px;
    list-style: none;
}
.login-wrapper .box input[type="text"], .login-wrapper .box input[type="password"] {
    font-size: 15px;
	border-radius:5px;
	border:1px solid #000;
    /* padding-left: 12px; */
    padding: 5px 0px 5px 12px;
	    height: 40px;
    float: left;
    font-family: 'Microsoft YaHei';
    margin-bottom: 15px;
}
.row-fluid .span12 {
    width: 100%;
}
.primary {
    height: 36px;
    color: #a23200;
	font-weight:800;
    border:1px solid #ebaf49;
    border-radius: 5px;
    cursor: pointer;
	padding:5px 50px;
	background-image: -moz-linear-gradient(top, #ffd92d, #ffd212); /* Firefox */
    background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0, #ffd92d), color-stop(1, #ffd212)); /* Saf4+, Chrome */
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffd92d', endColorstr='#ffd212', GradientType='0'); /* IE*/
}  
.primary:hover{ background:#ffe7a8;border:1px solid #C90;}
.reg_index tr:hover{
	 background:#fff;
}
h3{ 
	width:100%; 
	height:80px; 
	line-height:80px; 
	font-weight:900; 
	margin-top:20px;  
	color:#0f3f85;
}

</style>
<script type="text/javascript" src="<%=basePath %>js/jquery-1.9.1.min.js"></script>
<script>
//刷新验证码
  function changeImg(createTypeFlag){
      document.getElementById("imgCode").src="<%=basePath%>imagecode/create?createTypeFlag="+createTypeFlag+"&"+Math.random();
 }
  $(function(){
    $("#btnLogin").click(function(){
      $.post("<%=basePath%>show/normal/startlogin",{"loginname":$("#txtloginname").val(),"loginpwd":$("#txtloginpwd").val(),"code":$("#txtcode").val()},function(data,status){
        if(status=="success"){
          if(data=="2"){
            alert("验证码错误");
            return;
          }
          else
          {
            if(data=="1"){
              location.href="<%=basePath%>show/home";
            }
            else{
              if(data=="0"){
                 alert("登录失败，帐号或密码错误");
               }
               else{
                 alert("登录失败，登录出现异常");
               }
            }
          }
        }
        else
        {
          alert("网络异常，登录失败");
        }
        
      });
    });
  });
    document.onkeydown = function(event_e){    
        if(window.event)    
         event_e = window.event;    
         var int_keycode = event_e.charCode||event_e.keyCode;    
         if(int_keycode ==13){   
          $('#btnLogin').click();  
        }  
    };
</script>
</head>

<body class="login_bg">
    <div class="row-fluid login-wrapper">
        <a href="index.html">
            <img border="0" class="logo" src="<%=basePath %>images/logo-white.png" />
 
        </a>
       <div class="reg_index">
        <div class="span4 box">
                <div class="content-wrap">
                    <h6 style="color:#3f86c9; font-size:20px;">管理员登录</h6>
                    <ul>
                        <li>
                            <input name="loginname" type="text"  id="txtloginname" class="span12" placeholder='用户名'></li>
                        <li>
                            <input name="loginpwd" type="password"  id="txtloginpwd" class="span12"  placeholder="输入密码"></li>
                        <li style="margin-top: 10px;">
                            <input name="code" type="text" maxlength="4" id="txtcode" class="span12" placeholder="输入验证码" style="width: 275px; height: 40px; float: left;">
                            <img id="imgCode" style="width: 90px; height: 38px; float: left; margin-left: 10px; cursor: pointer" src="<%=basePath %>imagecode/create?createTypeFlag=n" onclick="changeImg('n')"  title="点击刷新验证码"></li>
                        <li style="  text-align:center;" >
                            <input type="button" name="btnLogin" value="登录" id="btnLogin" class="btn-glow primary login" style=" width:150px; height:40px; margin:15px auto;font-size:16px;">
							 
							 </li>
                    </ul>
                </div>
            </div>
       </div>    
    </div>

</body>
</html>
