<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	//从cookies中读取主题名称  
	String easyuiThemeName = "default";
	Cookie cookies[] = request.getCookies();
	if (cookies != null && cookies.length > 0) {
		for (int i = 0; i < cookies.length; i++) {
			if (cookies[i].getName().equals("easyuiThemeName")) {
				easyuiThemeName = cookies[i].getValue();
				break;
			}
		}
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>科美（南京）智能科技有限公司</title>
<meta name="renderer" content="webkit" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<link id="master_easyuiTheme" rel="stylesheet"
	href="<%=path%>/js/myui/themes/<%=easyuiThemeName%>/easyui.css"
	type="text/css"></link>
<link rel="stylesheet" href="<%=path%>/js/myui/themes/icon.css"
	type="text/css"></link>
<script type="text/javascript" src="<%=path%>/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript"
	src="<%=path%>/js/myui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="<%=path%>/js/myui/validate.js"></script>
<script type="text/javascript" src="<%=path%>/js/jquery.cookie.js"></script>
<style>
.pagination-info {
	float: left;
}
td:nth-child(odd) {
text-align: right;
} 
.datebox-button td:nth-child(odd) {
text-align: center;
}
.datebox-button td:nth-child(even) {
text-align: center;
}
</style>
<script>

    function myformatter(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			var hour = date.getHours();
            var minutes = date.getMinutes();
            var seconds = date.getSeconds();
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+ " " +( hour<10?('0'+hour):hour)+ ":" + (minutes<10?('0'+minutes):minutes) + ":" + (seconds<10?('0'+secondes):seconds);
		}
		function myparser(s){
			if (!s) return new Date();
			var index=s.indexOf(" ");
			var pre=s.substring(0,index);
			var lat=s.substring(index+1,s.length);
			
			var ss = (pre.split('-'));
			var y = parseInt(ss[0],10);
			var m = parseInt(ss[1],10);
			var d = parseInt(ss[2],10);
			
			var dd=lat.split(':');
			var h=parseInt(dd[0],10);
			var mi=parseInt(dd[1],10);
			var s=parseInt(dd[2],10);
			if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
				return new Date(y,m-1,d,h,mi,s);
			} else {
				return new Date();
			}
		}
  $(function(){
    $('#master_btnPwd').bind('click', function(){
		$("#master_divpwd").window('open');
    });
       //窗口插件window
         $("#master_divpwd").window({
         minimizable:false,
         maximizable:false,
         collapsible:false,
         modal:true,
         closed:true,
         width:400
         });
         //主题样式
  var $easyuiTheme = $('#master_easyuiTheme');   
  var url1=   $easyuiTheme.attr('href'); 
  var theme=url1.substring(url1.indexOf('themes')+7,url1.lastIndexOf('/'));
  $('#master_cc').combobox({
    value:theme,
	onChange: function(newValue, oldValue){
    var url = $easyuiTheme.attr('href');  
    var v=newValue;
    var href = url.substring(0, url.indexOf('myui'))+ 'myui/themes/' + v + '/easyui.css';  
    $easyuiTheme.attr('href',href); 
    $.cookie('easyuiThemeName',v, {  
        expires : 7  
    }); 
	}});
	    $('.easyui-tree').tree({
    	onClick: function(node){   	
    		if (node.url=="" || node.url=="#" ||node.url=="<%=basePath%>" ||node.url=="<%=basePath%>#" ) {
    			$.messager.alert('', '此功能尚未开发', 'warning');
			}
    		else
    			{
                addTab(node.text,node.url);
    		   } 
			}
			
		});
		//
		$("#master_divaccordion").accordion('getSelected').panel('collapse');
	});
	function sbpwd() {
		if (!$('#master_fpwd').form('validate')) {
			return;
		}
		$.post("<%=basePath%>manager/upwd", {
			"loginname" : $("#master_hidloginname").val(),
			"loginpwd" : $("#master_txtNewpwd").val()
		}, function(data, status) {
			if (status == "success") {
				if (data == "1") {
					$.messager.alert('密码修改', '修改成功');
				} else {
					$.messager.alert('修改失败', data, 'error');
				}
			} else {
				$.messager.alert('', '信息发送失败', 'warning');
			}

		});
	}
	function refreshtab(){
	            var tab = $('#master_divtabs').tabs('getSelected'); // get selected panel
                tab.panel('refresh');
	}
    // 添加一个新的标签页面板（tab panel）
    function addTab(title,href)
    {
    	var tab = $('#master_divtabs').tabs('getTab',0); // get selected panel
		$('#master_divtabs').tabs('update', {
			tab : tab,
			options : {
				title : title,
				href:href,
				tools:'#master_tabstools'
			}
		});
		tab.panel('refresh');
    	/* $('#master_divtabs').tabs('add',{
            title:title,
            //content:content,
            href:href,
            closable:false,
            tools:'#master_tabstools'
        }); */
    }

</script>
</head>
<body>
	<div id="cc" class="easyui-layout" style="width:100%;height: 100%;" >
		<div data-options="region:'north',border:false"
			style="height:50px;overflow: hidden;">
			<h2 style="display:inline-block;">科美（南京）智能科技有限公司门户系统后台管理</h2>
			<div
				style="display:inline-block;float:right;height:50px;line-height:50px;">
				更换皮肤 <select id="master_cc" class="easyui-combobox" name="state"
					style="width:100px;height:20px;">
					<option value="material">material</option>
					<option value="metro">metro</option>
					<option value="pepper-grinder">pepper-grinder</option>
					<option value="bootstrap">bootstrap</option>
					<option value="default">默认</option>
					<option value="black">黑色</option>
					<option value="cupertino">深海蓝</option>
					<option value="sunny">阳光色</option>
				</select> 欢迎您：${sessionScope.displayname}
				<a id="master_btnPwd" href="#" class="easyui-linkbutton">修改密码</a>
				<a href="<%=basePath%>manager/exit" class="easyui-linkbutton">退出</a>
			</div>
		</div>
		<div data-options="region:'center',border:false">
			<div id="master_divtabs" class="easyui-tabs" style="height:100%;">
				  <div title="首页">
				    <div style="width:auto;text-align: center;background-color: #fff;">
				       <img src="<%=basePath %>images/welcom2.jpg" >
				      </div>
				</div>
			</div>
			<div id="master_tabstools">
				<a href="javascript:void(0)" class="icon-reload" onclick="refreshtab();"></a>
			</div>
		</div>
		<div data-options="region:'west'" title="系统菜单"
			style="width:250px;">
			<div id="master_divaccordion" class="easyui-accordion easyui-tree"
				data-options="fit:true,border:false,lines:true">
								
 					<c:forEach items="${menu }" var="item">
					<c:if test="${item.cata=='1' }">
						<div title="${item.menuname }" style="padding: 10px;">
							<ul class="easyui-tree" data-options="animate:true,lines:true">
								<c:forEach items="${menu }" var="itemsec">
									<c:if test="${item.menucode==itemsec.parentcode }">
										<li data-options="iconCls:'${itemsec.iconname}',url:'<%=basePath%>${itemsec.url}'">${itemsec.menuname }</li>
									</c:if>
								</c:forEach>
							</ul>
						</div>
					</c:if>
				</c:forEach>				
			</div>
		</div>
		
	    <div id="master_divpwd" class="easyui-window" title="密码修改"
			style="padding:20px;">
			<form id="master_fpwd">
				<table style="min-height:150px;">
					<tr>
						<td>新密码:</td>
						<td>
						<input type="hidden" id="master_hidloginname" value="${sessionScope.loginname}"/>
						<input id="master_txtNewpwd" class="easyui-textbox"
							type="password" name="newpwd"
							data-options="required:true,missingMessage:'请填写密码'"></input>
						</td>
					</tr>
					<tr>
						<td>确认密码:</td>
						<td><input id="master_txtSamepwd" class="easyui-textbox"
							type="password" name="samepwd"
							data-options="required:true,missingMessage:'请填写确认密码'"
							validType="equalTo['#master_txtNewpwd']" invalidMessage="两次密码不同"></input>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="text-align: center;"><a
							href="javascript:void(0)" class="easyui-linkbutton"
							onclick="sbpwd()">保存</a></td>
					</tr>
				</table>
			</form>
		</div>    
	</div>
</body>
</html>