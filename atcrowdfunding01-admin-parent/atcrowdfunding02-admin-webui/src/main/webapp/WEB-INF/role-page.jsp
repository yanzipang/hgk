<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>
        角色维护
    </title>
</head>
<%@include file="/WEB-INF/include-head.jsp"%>
<%--引入分页--%>
<link rel="stylesheet" href="static/css/pagination.css"/>
<script type="text/javascript" src="static/jquery/jquery.pagination.js"></script>
<script type="text/javascript">

    //声明专门的函数，显示确认模态框
    function showConfirmModal(roleArray) {
        // 打开模态框
        $("#confirmModal").modal("show");

        // 清除旧的数据
        $("#roleNameDiv").empty();

        // 在全局变量范围内创建数组用来存放角色id
         window.roleIdArray = [];

        // 遍历roleArray数组
        for (var i = 0; i < roleArray.length; i++) {
            var role = roleArray[i];
            var roleName = role.roleName;
            $("#roleNameDiv").append(roleName+"<br/>");

            var roleId = role.roleId;

            // 调用数组对象的push()方法存入数据
            window.roleIdArray.push(roleId);
        }
    }

    // 执行分页，生成页面效果，任何时候调用这个函数都会重新加载页面
    function generatePage() {

        // 1.获取分页数据
        var pageInfo = getPageInfoRemote();

        // 2.填充表格
        fillTableBody(pageInfo);

    }


    // 远程访问服务器端程序获取 pageInfo 数据
    function getPageInfoRemote() {

        // 调用$.ajax()函数发送请求并接受$.ajax()函数的返回值
        var ajaxResult = $.ajax({
            "url": "role/get/page/info.json",
            "type":"post",
            "data": { "pageNum": window.pageNum,
                "pageSize": window.pageSize,
                "keyword": window.keyword
            },
            "async":false,
            "dataType":"json"
        });
        console.log(ajaxResult);

        // 判断当前响应状态码是否为 200
        var statusCode = ajaxResult.status;

        // 如果当前响应状态码不是 200，说明发生了错误或其他意外情况，显示提示消息，让 当前函数停止执行
        if(statusCode != 200) {
            layer.msg("失败！响应状态码="+statusCode+"说明信息="+ajaxResult.statusText);
            return null;
        }

        // 如果响应状态码是 200，说明请求处理成功，获取 pageInfo
        var resultEntity = ajaxResult.responseJSON;

        // 从 resultEntity 中获取 result 属性
        var result = resultEntity.result;

        // 判断 result 是否成功
        if(result == "FAILED") {
            layer.msg(resultEntity.message);
            return null;
        }

        // 确认 result 为成功后获取pageInfo
        var pageInfo = resultEntity.data;

        // 返回 pageInfo
        return pageInfo;
    }


    // 填充表格
    function fillTableBody(pageInfo) {

        // 清除 tbody 中的旧的内容
        $("#rolePageBody").empty();

        // 这里清空是为了让没有搜索结果时不显示页码导航条
        $("#Pagination").empty();

        // 判断 pageInfo 对象是否有效
        if(pageInfo == null || pageInfo == undefined || pageInfo.list == null || pageInfo.list.length == 0) {
            $("#rolePageBody").append("<tr><td colspan='4' align='center'>抱歉！没有查询到您搜 索的数据！</td></tr>");
            return ;
        }

        // 使用 pageInfo 的 list 属性填充 tbody
        for(var i = 0; i < pageInfo.list.length; i++) {
            var role = pageInfo.list[i];
            var roleId = role.id;
            var roleName = role.name;
            var numberTd = "<td>"+(i+1)+"</td>";
            var checkboxTd = "<td><input id='"+roleId+"' class='itemBox' type='checkbox'></td>";
            var roleNameTd = "<td>"+roleName+"</td>";
            var checkBtn = "<button type='button' class='btn btn-success btn-xs'><i class=' glyphicon glyphicon-check'></i></button>";
            // 通过button标签的id属性(别的属性其实也可以)把roleId的值传递到button按钮的单击响应函数中，在单击响应函数中使用this.id
            var pencilBtn = "<button id='"+roleId+"' type='button' class='btn btn-primary btn-xs pencilBtn'><i class=' glyphicon glyphicon-pencil'></i></button>";
            // 通过button标签的id属性(别的属性其实也可以)把roleId的值传递到button按钮的单击响应函数中，在单击响应函数中使用this.id
            var removeBtn = "<button id='"+roleId+"' type='button' class='btn btn-danger btn-xs removeBtn'><i class=' glyphicon glyphicon-remove'></i></button>";
            var buttonTd = "<td>"+checkBtn+" "+pencilBtn+" "+removeBtn+"</td>";
            var tr = "<tr>"+numberTd+checkboxTd+roleNameTd+buttonTd+"</tr>";
            $("#rolePageBody").append(tr);
        }

        // 生成分页导航条
        generateNavigator(pageInfo);
    }


    // 生成分页页码导航条
    function generateNavigator(pageInfo) {

        // 获取总记录数
        var totalRecord = pageInfo.total;

        // 声明相关属性
        var properties = {
            "num_edge_entries": 3,
            "num_display_entries": 5,
            "callback": paginationCallBack,
            "items_per_page": pageInfo.pageSize,
            "current_page": pageInfo.pageNum - 1,
            "prev_text": "上一页",
            "next_text": "下一页"
        }

        // 调用 pagination()函数
        $("#Pagination").pagination(totalRecord, properties);
    }


    // 翻页时的回调函数
    function paginationCallBack(pageIndex,JQuery) {

        // 修改 window 对象的 pageNum 属性
        window.pageNum = pageIndex + 1;

        // 调用分页函数
        generatePage();

        // 取消页码超链接的默认行为
        return false;
    }
</script>
<script type="text/javascript">
    $(function () {
       // 1.为分页操作准备初始化数据
       window.pageNum = 1;
       window.pageSize = 5;
       window.keyword = "";

        // 2.调用执行分页的函数，显示分页效果
        generatePage();

        // 3.给查询按钮绑定单击响应函数
        $("#searchBtn").click(function(){
            // ①获取关键词数据赋值给对应的全局变量
            window.keyword = $("#keywordInput").val();
            // ②调用分页函数刷新页面
            generatePage();
        });

        // 4.点击新增按钮打开模态框
        $("#showAddModalBtn").click(function (){
            $("#addModal").modal("show");
        });

        // 5.给新增模态框中的保存按钮绑定单击响应函数
        $("#saveRoleBtn").click(function(){
            // ①获取用户在文本框中输入的角色名称
            // #addModal 表示找到整个模态框
            // 空格表示在后代元素中继续查找
            // [name=roleName]表示匹配 name 属性等于 roleName 的元素
            var roleName = $.trim($("#addModal [name=roleName]").val());
            // ②发送 Ajax 请求
            $.ajax({
                "url": "role/save.json",
                "type":"post",
                "data": {
                    "name": roleName
                },
                "dataType": "json",
                "success":function(response){
                    var result = response.result;
                    if(result == "SUCCESS") {
                        layer.msg("操作成功！");
                        // 将页码定位到最后一页
                        window.pageNum = 99999999;
                        // 重新加载分页数据
                        generatePage();
                    }
                    if(result == "FAILED") {
                        layer.msg("操作失败！"+response.message);
                    }
                    },
                "error":function(response){
                    layer.msg(response.status+" "+response.statusText);
                }
            });
            // 关闭模态框
            $("#addModal").modal("hide");
            // 清理模态框
            $("#addModal [name=roleName]").val(""); });

        // 6.给页面上的“铅笔”按钮绑定单击响应函数，目的是打开模态框
        // 传统的事件绑定方式只能在第一个页面有效，翻页后失效了
        /*
            $(".pencilBtn").click(function(){
                alert("aaaa...");
            });
        */

        // 使用 jQuery 对象的 on()函数可以解决上面问题
        // ①首先找到所有“动态生成”的元素所附着的“静态”元素
        // ②on()函数的第一个参数是事件类型
        // ③on()函数的第二个参数是找到真正要绑定事件的元素的选择器
        // ④on()函数的第三个参数是事件的响应函数
        $("#rolePageBody").on("click",".pencilBtn",function(){
            // 打开模态框
            $("#editModal").modal("show");
            // 获取表格中当前行中的角色名称
            var roleName = $(this).parent().prev().text();
            // 获取当前角色的 id
            // 依据是：var pencilBtn = "<button id='"+roleId+"' ……这段代码中我们把 roleId 设置到 id 属性了
            // 为了让执行更新的按钮能够获取到 roleId 的值，把它放在全局变量上
            window.roleId = this.id;
            // 使用 roleName 的值设置模态框中的文本框
            $("#editModal [name=roleName]").val(roleName);
        });
        // 7.给更新模态框中的更新按钮绑定单击响应函数
        $("#updateRoleBtn").click(function(){
            // ①从文本框中获取新的角色名称
            var roleName = $("#editModal [name=roleName]").val();
            // ②发送 Ajax 请求执行更新
            $.ajax({
                "url":"role/update.json",
                "type":"post",
                "data":{
                    "id":window.roleId,
                    "name":roleName
                },
                "dataType":"json",
                "success":function(response){
                    var result = response.result;
                    if(result == "SUCCESS") {
                        layer.msg("操作成功！");
                        // 重新加载分页数据
                        generatePage();
                    }
                    if(result == "FAILED") {
                        layer.msg("操作失败！"+response.message);
                    }
                    },
                "error":function(response){
                    layer.msg(response.status+" "+response.statusText);
                }
            });
            // ③关闭模态框
            $("#editModal").modal("hide");
        });

        // 点击模态框中的确定按钮执行删除
        $("#removeRoleBtn").click(function () {
            var requestBody = JSON.stringify(window.roleIdArray);

            $.ajax({
                "url":"role/remove/by/role/id/array.json",
                "type":"post",
                "data":requestBody,
                "contentType":"application/json;charset=UTF-8",
                "dataType":"json",
                "success":function(response){
                    var result = response.result;
                    if(result == "SUCCESS") {
                        layer.msg("操作成功！");
                        // 重新加载分页数据
                        generatePage();
                    }
                    if(result == "FAILED") {
                        layer.msg("操作失败！"+response.message);
                    }
                },
                "error":function(response){
                    layer.msg(response.status+" "+response.statusText);
                }
            });
            // 关闭模态框
            $("#confirmModal").modal("hide");
        });

        // 给单条删除按钮绑定单击响应函数
        $("#rolePageBody").on("click",".removeBtn",function(){

            // 从当前按钮出发获取角色名称
            var roleName = $(this).parent().prev().text();

            // 创建role对象存入数组
            var roleArray = [{
                roleId:this.id,
                roleName:roleName
            }];

            // 调用专门的函数打开模态框
            showConfirmModal(roleArray);
        });

        // 给总的checkbox绑定单击响应函数
        $("#summaryBox").click(function () {
            // 获取当前多选框自身的状态
            var currentStatus = this.checked;
            // ①用当前多选框的状态设置其他的多选框
            $(".itemBox").prop("checked",currentStatus);
        });

        // 全选、全不选的反向操作
        $("#rolePageBody").on("click",".itemBox",function(){
            // 获取当前已经选中的itemBox的数量
            var checkedBoxCount = $(".itemBox:checked").length;

            // 获取全部.itemBox的数量
            var totalBoxCount = $(".itemBox").length;

            // 使用二者的比较结果设置总的checkbox
            $("#summaryBox").prop("checked",checkedBoxCount == totalBoxCount);
        });

        // 给批量删除的按钮绑定单击响应函数
        $("#batchRemoveBtn").click(function () {
            // 创建一个数组对象，用来存放后面的到的数组对象
            var roleArray = [];
            // 遍历当前选中的多选框
            $(".itemBox:checked").each(function () {
                // 使用this引用当前遍历得到的多选框
                var roleId = this.id;

                // 通过DOM操作获取角色名称
                var roleName = $(this).parent().next().text();
                roleArray.push({
                    "roleId":roleId,
                    "roleName":roleName
                });
            });

            // 检查roleArray的长度是否为0
            if (roleArray.length == 0) {
                layer.msg("请至少选择一个执行删除");
                return ;
            }

            // 调用专门的函数打开模态框
            showConfirmModal(roleArray);
        });
    });
</script>
<body>
<%@include file="/WEB-INF/include-nav.jsp"%>
<div class="container-fluid">
    <div class="row">
        <%@include file="/WEB-INF/include-siderbar.jsp"%>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input id="keywordInput" class="form-control has-success" type="text" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="searchBtn" type="button" class="btn btn-warning">
                            <i class="glyphicon glyphicon-search"></i> 查询
                        </button>
                    </form>
                    <button id="batchRemoveBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;">
                        <i class=" glyphicon glyphicon-remove"></i> 删除
                    </button>
                    <button type="button" id="showAddModalBtn" class="btn btn-primary" style="float:right;">
                        <i class="glyphicon glyphicon-plus"></i> 新增
                    </button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr>
                                <th width="30">#</th>
                                <th width="30"><input id="summaryBox" type="checkbox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody id="rolePageBody"></tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="6" align="center">
                                        <div id="Pagination" class="pagination"><!-- 这里显示分页 --></div>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
    <%--添加角色模态框:模态框默认情况下是隐藏的--%>
    <%@include file="/WEB-INF/modal-role-add.jsp" %>
    <%--更新角色模态框--%>
    <%@include file="/WEB-INF/modal-role-edit.jsp" %>
    <%--删除角色模态框--%>
    <%@include file="/WEB-INF/modal-role-confirm.jsp" %>
</body>
</html>