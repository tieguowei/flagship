<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ include file="/common/header.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>阈值设置列表</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0"> 
	<script type="text/javascript">
	
	$(function() {
		//提交
		$("#saveButton").click(function() {	
			$.ajax({
				url:"${app}/financeThreshold/doUpdate",
				data:$("form").serialize(),
				type:"post",
				dataType:"json",
				success:function(data){
					if(data){
						$.messager.show({
		                    title:'信息提示',
		                    msg:"修改成功！",
		                    timeout:5000,
		                    showType:'slide'
		                });
						//关闭form表单
						$("#formDiv").dialog("close");
					    //返回列表页面
					    setTimeout(function(){
						    location.href="${app}/financeThreshold/set";
               			  },1000);

					}else{
						$.messager.show({
		                    title:'信息提示',
		                    msg:"系统异常！",
		                    timeout:5000,
		                    showType:'slide'
		                });
					}
				}
			})
		})
		
		//取消
		$("#cancelButton").click(function() {	
			   location.href="${app}/financeThreshold/set";
		})
	})
	
	function onBlur1(){
		var value= $("#beginValueOne").val();
		document.getElementById("beginValueTwo").value=value;
	}
	function onBlur2(){
		var value= $("#beginValueTwo").val();
		document.getElementById("beginValueOne").value=value;
	}
	function onBlur3(){
		var value= $("#endValueOne").val();
		document.getElementById("endValueTwo").value=value;
	}
	function onBlur4(){
		var value= $("#endValueTwo").val();
		document.getElementById("endValueOne").value=value;
	}
	
	</script>
  </head>
  
 <body class="easyui-layout">
 
 <div id="formDiv"  class="easyui-dialog" closable="false" title="融资阈值设置" style="width:500px;height:250px;"   
        data-options="iconCls:'icon-save',modal:true,buttons:'#formButtons'">   
  
  <form  id="ff" style="margin: 30px;">
		<table>
		<!-- C-M1回款率 年化新增损失率  有最小值 最大值 这一列-->
		<tr>
			<c:if test="${threeValue != 'null'}">
			    <td>
			    	最小值
			     <input type="hidden" name=threeCodeName value="${threeCodeName}" />
				 <input  name="threeValue" value="${threeValue}" size="5" />
			    </td>	
			</c:if>
			</tr>
			<tr>
				<c:if test="${fourValue != 'null'}">
			    <td>
			    	最大值
			    <input type="hidden" name=fourCodeName value="${fourCodeName}" />
				<input  name="fourValue" value="${fourValue}" size="5" />
			    </td>
			</c:if>
			</tr>
			<tr>
				<td>
				 ${redMath}
				<input name="beginCodeName" value="${beginCodeName}" type="hidden">
				<input  id="beginValueOne" name="beginValue" value="${beginValue}" size="5" onBlur="onBlur1()" />
				</td>
			</tr>
			<tr>
			<!-- 年化新增损失率 两个值位置和其他列不同  beginCodeName = financeMgr_month_lossRate_warning -->
			<c:choose>
		   		<c:when test="${beginCodeName == 'financeMgr_month_lossRate_warning'}"> 
					<td>
					${yellowMathOne }
					<input id="endValueOne"   size="5" value="${endValue}"  onblur="onBlur3()"/>
					${yellowMathTwo }
					<input  id="beginValueTwo"    size="5" value="${beginValue }" onblur="onBlur2()"/>
					</td>
		   		</c:when>
		   
		   		<c:otherwise>
			   		<td>
					${yellowMathOne }
					<input id="beginValueTwo"  size="5" value="${beginValue}" onblur="onBlur2()" />
					${yellowMathTwo }
					<input   id="endValueOne"  size="5" value="${endValue }" onblur="onBlur3()" />
					</td>
		   		</c:otherwise>
			</c:choose>
			</tr>
			<tr>
				<td>
				${blueMath}
				<input name="endCodeName" value="${endCodeName}" type="hidden">
				<input id="endValueTwo" name="endValue" size="5" value="${endValue}" onBlur="onBlur4()"/>
				</td>
			</tr>
		</table>
	</form>
  
     
</div>  
<div id="formButtons">
	<a id="saveButton" class="easyui-linkbutton"
		data-options="iconCls :'icon-edit'">提交</a>
	 <a
		class="easyui-linkbutton" data-options="iconCls :'icon-cancel'"
		id="cancelButton">取消</a>
</div>

  </body>
</html>
