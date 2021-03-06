<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>

<!DOCTYPE HTML>
<html>
  <head>
    <title>添加员工</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<%@ include file="/common/header.jsp"%>
	<style type="text/css">
	
	/* title 居中 */
       .panel-title {
          text-align: center;
     	 }
		.trreDiv {
			float: left;
			width: 23%;
			height: 100%;
			font-size: 15px;
			border: 1px solid #6699FF;
		}
		#treeDept {
			float: left;
			width: 95%;
			height: 90%;
			overflow: auto;
		}
	</style>
	<script type="text/javascript">
		$(document).ready(function(){
			limit_textarea_input();//统计文本域输入字数
		});
		
		//选择部门
		var deptDialog = null;
		function selectDept(){
			deptDialog = $('#deptDialog').dialog({  
				top:100,
				title: "选择部门",   
				width: 450,   
				height: 320,  
				closed: false,   
				cache: false,   
				href: "${app}/department/toSelectDept?deptId=" + $("#deptId").val(),   
				modal: true,
				buttons:[{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						$("#deptId").val($("#selectDeptId").val());//选择部门赋值
						deptDialog.dialog('close');
						getLevelDeptInfo();
					}
				},{
					text:'取消',
					iconCls:'icon-cancel',
					handler:function(){
						deptDialog.dialog('close');
					}
				}]
			}); 
		}
		
		//获得层级部门信息
		function getLevelDeptInfo(){
			$.ajax({
				async:false,
				type:'post',
				url:"${app}/department/getLevelDeptInfo/" + $("#deptId").val(),
				dataType:'html',
				success:function(msg){
					$("#deptName").html(msg);
				}
			});
		}
		
		
		//提交
		function submitForm(){
			var empAddForm = $("#empAddForm");
			empAddForm.form('submit',{
				url:'${app}/employee/doAddEmp',
				onSubmit:function(){
					if(empAddForm.form("validate")){
						
						var employeeNo = $("#employeeNo").textbox("getValue")
						if (employeeNo == "" || typeof (employeeNo) == "undefined") {
							$.messager.alert('提示信息', '请输入员工编号', 'info');
							return false;
						} 
							
						if($("#deptId").val() == ""){
							$.messager.alert('提示信息','请选择所属部门团队','info');
							return false;
						}
						return true;
					}else{
						return false;
					}
				},
				success:function(data){
					closeMask();
					var obj = eval("(" + data + ")");
					parent.refreshTab("${app}/employee/toEmpList?messageCode=" + obj.messageCode,"员工管理");
					parent.closeTab("添加员工");
				}
			});
		}
		
		//取消
		function resetForm(){
			parent.closeTab("添加员工");
			$('#searchPrincipal').dialog('close');
		}
		
		//查找员工编号
		function openSearch(){
			document.getElementById("searchPrincipal").style.display = "block";
			$('#searchPrincipal').dialog({
				title:'查找员工编号',
				width: 540,    
			    height: 250,    
			    closed: false,    
			    left: 600,
			    top:200
			});
		}
		
		
		//员工详细信息列表
		function searchPrincipal(){
			var name = $("#principalName").textbox("getValue");
			var datagrid2
			datagrid2 = $('#principalTable').datagrid({
				url : '${app}/risk/findPrincipalName?name='+encodeURI(encodeURI(name)),
				title : '',
				pagination : false,
				fit : true,
				singleSelect : true,
				border : false,
				idField : 'id',
				columns : [[
				  {
					field : 'name',
					title : '姓名',
					width : 120
					
				},{
					field : 'workCode',
					title : '员工编号',
					width : 120
				},{
					field : 'jobTitle',
					title : '职务',
					width : 120
				},{
					field : 'depName',
					title : '部门',
					width : 120
				},
				{
					field : 'status',
					title : '状态',
					width : 60,
					formatter:function(value,rowData,rowIndex){
						var retStr = "";
						if(value == 1){
							retStr = "在职";
						}else{
							retStr = "离职";
						}
						return retStr;
					}
				}]],
				onClickRow: function (index, row) { 
					var orgNo = row["workCode"]; 
					var status = row["status"];
					//员工编号
					$("#employeeNo").textbox("setValue",orgNo);
					//是否离职
					$("#status").val(status);
					$('#searchPrincipal').dialog('close');
	            }  
			});
		}	
		
		//选择权限
		var deptDialog = null;
		function selectPermission(){
			str = $("#permissionIds").val();
			deptDialog = $('#deptDialog').dialog({  
				top:100,
				title: "选择权限",   
				width: 450,   
				height: 320,  
				closed: false,   
				cache: false,   
				href: "${app}/employee/toSelectPermission",   
				modal: true,
				 buttons:[{
					text:'确定',
					iconCls:'icon-ok',
					handler:function(){
						var treeObj = $.fn.zTree.getZTreeObj("treePermission");
						var nodes = treeObj.getCheckedNodes(true);
						var ids = "";
						var names = "";
						for(var i in nodes){
							names+=nodes[i].name+","
							ids+=nodes[i].id+","
						}
						var node = treeObj.getNodeByParam("id", 3, null); 
						var flag =false;
						/* flag = getAllChildrenNodes(node,flag);
						if(flag){
							ids+=3;
							ids+=",";
						} */
						var ids=ids.substring(0,ids.length-1);
						var names=names.substring(0,names.length-1);
						initParamsInfo(names);
						$("#permissionIds").val('');
						$("#permissionIds").val(ids);
					}
				},{
					text:'取消',
					iconCls:'icon-cancel',
					handler:function(){
						deptDialog.dialog('close');
					}
				}] ,
				 onLoad: function () {
					 //得到所有的节点
					 var treeObj = $.fn.zTree.getZTreeObj("treePermission");
					 var nodes = treeObj.getNodes();
					 var act=treeObj.transformToArray(nodes);
					 if(str != null && str != ''){
						 var array = str.split(",");
						 //遍历所有选中的节点
						 for(var i=0;i<array.length;i++){
							//遍历所有的节点
							  for(var j=0;j<act.length;j++){
								   if(array[i] == act[j].id){
									   //回显
									   treeObj.checkNode(act[j],true,true);
								  } 
						 	}  
						 }
						
					 }
					 
                 }
			}); 
		}
		
		 //赋值
		function initParamsInfo(names){
			$("#permissionName").html(names);
			$('#deptDialog').dialog('close');
		}

	</script>
  </head>
  
  <body style="background: white;">
  	<form id="empAddForm" class="easyui-form" method="post" modelAttribute="employee">
		<table class="tableForm" border="1" width="100%" >
			<tr>
				<td width="15%" class="tdR"><span style="color: red">*</span>姓名:</td>
				<td width="35%">
					<input type="text" id="name" name="name" class="easyui-textbox" data-options="required:true,validType:['length[0,10]']" style="width: 175px;height: 24px;"/>
				</td>
				<td width="15%" class="tdR"><span style="color: red">*</span>性别:</td>
				<td width="35%">
					<input type="radio" id="sex_1" name="sex" value="0" checked="checked"/><label for="sex_1">男</label>
					<input type="radio" id="sex_2" name="sex" value="1"/><label for="sex_2">女</label>
				</td>
			</tr>
			<tr>
				<td class="tdR"><span style="color: red">*</span>邮箱:</td>
				<td>
					<input type="text" id="email" name="email" class="easyui-textbox" data-options="required:true,validType:['length[0,30]','email']" style="width: 175px;height: 24px;"/>
				</td>
				<td class="tdR">员工编号:</td>
				<td>
				   <input type="text" data-options="events:{focus:openSearch}"  id="employeeNo" name="employeeNo" class="easyui-textbox"  style="width: 175px;height: 24px;"  />
				</td>
			</tr>
			<tr>
				<td class="tdR">移动电话:</td>
				<td>
					<input type="text" id="mobile" name="mobile" class="easyui-numberbox" data-options="validType:['length[0,11]','mobileIsValid']" style="width: 175px;height: 24px;"/>
				</td>
				<td class="tdR">固定电话:</td>
				<td>
					<input type="text" id="telephone" name="telephone" class="easyui-textbox" data-options="validType:['length[0,13]','telephoneIsValid']" style="width: 175px;height: 24px;"/>
					<label style="color: red;">格式：010-56408888</label>
				</td>
			</tr>
			<tr>
				<td class="tdR"><span style="color: red">*</span>所属部门团队:</td>
				<td >
					<input type="hidden" id="deptId" name="deptId"/>
					<span id="deptName" style="padding-left: 5px;"></span>
					<a class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="selectDept();">选择部门</a>
				</td>
				<td class="tdR"><span style="color: red">*</span>特殊用户:</td>
				<td >
					<input type="radio" id="isSpecialUsers" name="accountType" value="1" /><label >是</label>
					<input type="radio" id="noSpecialUsers" name="accountType" value="0" checked="checked"/><label >否</label>
				</td>
			</tr>
			<tr>
				<td class="tdR"><span style="color: red">*</span>开启状态:</td>
				<td >
					<input type="radio" id="activatedState_1" name="activatedState" value="1" checked="checked"/><label for="activatedState_1">开启</label>
					<input type="radio" id="activatedState_2" name="activatedState" value="0"/><label for="activatedState_2">停用</label>
				</td>
				
				<td class="tdR"><span style="color: red">*</span>默认密码:</td>
				<td>
					<input type="text"  value="123@abc" class='easyui-textbox'  style="width: 175px;height: 24px;" readonly="readonly"/>
				</td>
			</tr>
			<!-- 2018-03-08版本 -->
			<tr>
				<td class="tdR"><span style="color: red">*</span>设置权限:</td>
				<td>
				    <!-- 添加页面 再次选择用于回显 -->
					<input type="hidden" name="oauth"  id="permissionIds">
					<span id="permissionName" style="padding-left: 5px;"></span>
					<a class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="selectPermission();">选择权限</a>
				</td>
			</tr> 
			<tr>
				<td class="tdR">备注:</td>
				<td colspan="3">
					<input id="remark" name="remark" class='easyui-textbox' data-options="multiline:true,validType:['length[0,50]']" style="width:330px;height:60px"/>
					<label style="color: red;" >运营管理部最好写备注，管理哪个城市。</label>
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
					<a class="easyui-linkbutton" id="submitButton"  iconCls="icon-ok" onclick="submitForm();">提交</a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:resetForm();">取消</a>
				</td>
			</tr>
		</table>
		<div id="deptDialog"></div>
	</form>
	<!-- 查找员工编号-->	
  	<div id="searchPrincipal"  style="display: none;overflow: hidden;" >
  			<div class="easyui-layout" data-options="fit:true" style="width: 100%;height: 100%;" >
	  			<div data-options="region:'north',split:false" style="width: 100%;height:14%">
		 			<input type="text" id="principalName"  class="easyui-textbox"  style="width: 200px;height: 24px;"/>
	  				<a class="easyui-linkbutton" iconCls="icon-search" onclick="searchPrincipal()">查询</a>
		 		</div>
		 		
		 		<div data-options="region:'center',split:false" style="width: 100%;height:86%">
		 			<table id="principalTable"></table>
		 		</div>
	 		</div>
  		</div>
  </body>
</html>
