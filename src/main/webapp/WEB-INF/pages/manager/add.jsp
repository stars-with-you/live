<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<form id="manager_ff">
	<table>
		<tr>
			<td>用户名:</td>
			<td><input id="manager_txtLoginname" class="easyui-textbox"
				type="text" name="manager_txtLoginname"
				data-options="required:true,missingMessage:'请填写用户名名'"
				validtype="remote['<%=basePath%>manager/validate','loginname']"
				invalidMessage="用户名已存在"></input></td>
		</tr>
		<tr>
			<td>密码:</td>
			<td><input id="manager_txtLoginpwd" class="easyui-textbox"
				type="password" name="manager_txtLoginpwd"
				data-options="required:true,missingMessage:'请填写密码'"></input></td>
		</tr>
		<tr>
			<td>确认密码:</td>
			<td><input id="manager_txtConfirm" class="easyui-textbox"
				type="password" name="manager_txtConfirm"
				data-options="required:true,missingMessage:'请填写确认密码'"
				validType="equalTo['#manager_txtLoginpwd']" invalidMessage="两次密码不同"></input>
			</td>
		</tr>
		<tr>
			<td>昵称:</td>
			<td><input id="manager_txtdisplayname" class="easyui-textbox"
				type="text" name="manager_txtdisplayname"
				data-options="required:true,missingMessage:'请填写昵称'"></input></td>
		</tr>
		<tr>
			<td>电话:</td>
			<td><input id="manager_txttel" class="easyui-textbox"
				type="text" name="manager_txttel"
				data-options="required:true,missingMessage:'请填写电话'"></input></td>
		</tr>
		<tr>
			<td>邮箱:</td>
			<td><input id="manager_txtemail" class="easyui-textbox"
				type="text" name="manager_txtemail"
				data-options="required:true,missingMessage:'请填写邮箱'"></input></td>
		</tr>
		<tr>
			<td>所属机构:</td>
			<td><select id="manager_slssjg" class="easyui-combobox"
				name="manager_slssjg"
				data-options="editable:false,required:true,missingMessage:'请选择所属机构'">
					<option value=""></option>
					<option value="320000">江苏局本部</option>
					<option value="320100">南京局本部</option>
					<option value="320110">南京局南京机场办事处</option>
			</select></td>
		</tr>

		<tr>
			<td>管理员类型：</td>
			<td><select id="manager_slcata" class="easyui-combobox"
				name="cata" data-options="editable:false" style="width: 200px;">
					<option value="0">超级管理员</option>
					<option value="1">贸促会管理员</option>
					<option value="2">国检管理员</option>
			</select></td>
		</tr>
		<tr>
			<td colspan="2" style="text-align: center;"><a
				href="javascript:void(0)" class="easyui-linkbutton"
				onclick="submitForm()">保存</a></td>
		</tr>
	</table>
</form>