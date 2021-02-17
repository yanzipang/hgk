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
            var checkboxTd = "<td><input type='checkbox'></td>";
            var roleNameTd = "<td>"+roleName+"</td>";
            var checkBtn = "<button type='button' class='btn btn-success btn-xs'><i class=' glyphicon glyphicon-check'></i></button>";
            var pencilBtn = "<button type='button' class='btn btn-primary btn-xs'><i class=' glyphicon glyphicon-pencil'></i></button>";
            var removeBtn = "<button type='button' class='btn btn-danger btn-xs'><i class=' glyphicon glyphicon-remove'></i></button>";
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
                    <button type="button" class="btn btn-danger" style="float:right;margin-left:10px;">
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
                                <th width="30"><input type="checkbox"></th>
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
</body>
</html>