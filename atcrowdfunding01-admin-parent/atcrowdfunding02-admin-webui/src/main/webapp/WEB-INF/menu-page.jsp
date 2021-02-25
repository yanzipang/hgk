<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<title>菜单维护</title>
<%@include file="/WEB-INF/include-head.jsp"%>
<%--引入ztree插件--%>
<link rel="stylesheet" href="static/ztree/zTreeStyle.css" />
<script type="text/javascript" src="static/ztree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript">
    // 生成树形结构的函数
    function generateTree() {
        // 1.准备生成树形结构的 JSON 数据，数据的来源是发送 Ajax 请求得到
        $.ajax({
            "url": "menu/get/whole/tree.json",
            "type":"post",
            "dataType":"json",
            "success":function(response) {
                var result = response.result;
                if(result == "SUCCESS") {

                    // 2.创建 JSON 对象用于存储对 zTree 所做的设置
                    var setting = {
                        "view": {
                            "addDiyDom": myAddDiyDom,
                            "addHoverDom": myAddHoverDom,
                            "removeHoverDom": myRemoveHoverDom
                        },
                        "data": {
                            "key": {
                                "url": "maomi"
                            }
                        }
                    };

                    // 3.从响应体中获取用来生成树形结构的 JSON 数据
                    var zNodes = response.data;

                    // 4.初始化树形结构
                    $.fn.zTree.init($("#treeDemo"), setting, zNodes);
                }
                if(result == "FAILED") {
                    layer.msg(response.message);
                }
            }
        });
    }

    // 在鼠标离开节点范围时删除按钮组
    function myRemoveHoverDom(treeId, treeNode) {

        // 拼接按钮组的 id
        var btnGroupId = treeNode.tId + "_btnGrp";

        // 移除对应的元素
        $("#"+btnGroupId).remove();
    }

    // 在鼠标移入节点范围时添加按钮组
    function myAddHoverDom(treeId, treeNode) {

        // 按钮组的标签结构：<span><a><i></i></a><a><i></i></a></span>
        // 按钮组出现的位置：节点中 treeDemo_n_a 超链接的后面
        // 为了在需要移除按钮组的时候能够精确定位到按钮组所在 span，需要给 span 设置有 规律的 id
        var btnGroupId = treeNode.tId + "_btnGrp";

        // 判断一下以前是否已经添加了按钮组
        if($("#"+btnGroupId).length > 0) {
            return ;
        }

        // 准备各个按钮的 HTML 标签
        var addBtn = "<a id='"+treeNode.id+"' class='addBtn btn btn-info dropdown-toggle btn-xs' style='margin-left:10px;padding-top:0px;' href='#' title='添加子节点'>&nbsp;&nbsp;<i class='fa fa-fw fa-plus rbg '></i></a>";
        var removeBtn = "<a id='"+treeNode.id+"' class='removeBtn btn btn-info dropdown-toggle btn-xs' style='margin-left:10px;padding-top:0px;' href='#' title='删除节点'>&nbsp;&nbsp;<i class='fa fa-fw fa-times rbg '></i></a>";
        var editBtn = "<a id='"+treeNode.id+"' class='editBtn btn btn-info dropdown-toggle btn-xs' style='margin-left:10px;padding-top:0px;' href='#' title='修改节点'>&nbsp;&nbsp;<i class='fafa-fw fa-edit rbg '></i></a>";

        // 获取当前节点的级别数据
        var level = treeNode.level;

        // 声明变量存储拼装好的按钮代码
        var btnHTML = "";

        // 判断当前节点的级别
        if(level == 0) {

            // 级别为 0 时是根节点，只能添加子节点
            btnHTML = addBtn;
        }
        if(level == 1) {

            // 级别为 1 时是分支节点，可以添加子节点、修改
            btnHTML = addBtn + " " + editBtn;

            // 获取当前节点的子节点数量
            var length = treeNode.children.length;

            // 如果没有子节点，可以删除
            if(length == 0) {
                btnHTML = btnHTML + " " + removeBtn;
            }
        }
        if(level == 2) {

            // 级别为 2 时是叶子节点，可以修改、删除
            btnHTML = editBtn + " " + removeBtn;
        }

        // 找到附着按钮组的超链接
        var anchorId = treeNode.tId + "_a";

        // 执行在超链接后面附加 span 元素的操作
        $("#"+anchorId).after("<span id='"+btnGroupId+"'>"+btnHTML+"</span>");
    }

    // 修改默认的图标
    function myAddDiyDom(treeId, treeNode) {

        // treeId 是整个树形结构附着的 ul 标签的 id
        console.log("treeId="+treeId);

        // 当前树形节点的全部的数据，包括从后端查询得到的 Menu 对象的全部属性
        console.log(treeNode);

        // zTree 生成 id 的规则
        // 例子：treeDemo_7_ico
        // 解析：ul 标签的 id_当前节点的序号_功能
        // 提示：“ul 标签的 id_当前节点的序号”部分可以通过访问 treeNode 的 tId 属性得到
        // 根据 id 的生成规则拼接出来 span 标签的 id
        var spanId = treeNode.tId + "_ico";

        // 根据控制图标的 span 标签的 id 找到这个 span 标签
        // 删除旧的 class
        // 添加新的 class
        $("#"+spanId)
            .removeClass()
            .addClass(treeNode.icon);
    }
</script>
<script type="text/javascript">
    $(function () {

        // 调用专门封装好的函数初始化树形结构
        generateTree();

        // 给添加子节点按钮绑定单击响应函数
        $("#treeDemo").on("click",".addBtn",function() {

            // 将当前节点的 id，作为新节点的 pid 保存到全局变量
             window.pid = this.id;

            // 打开模态框
            $("#menuAddModal").modal("show");

            return false;
        });

        $("#menuSaveBtn").click(function(){

            // 收集表单项中用户输入的数据
            var name = $.trim($("#menuAddModal [name=name]").val());
            var url = $.trim($("#menuAddModal [name=url]").val());

            // 单选按钮要定位到“被选中”的那一个
            var icon = $("#menuAddModal [name=icon]:checked").val();

            // 发送 Ajax 请求
            $.ajax({
                "url":"menu/save.json",
                "type":"post",
                "data":{
                    "pid": window.pid,
                    "name":name,
                    "url":url,
                    "icon":icon
                },
                "dataType":"json",
                "success":function(response){
                    var result = response.result;
                    if(result == "SUCCESS") {
                        layer.msg("操作成功！");

                        // 重新加载树形结构，注意：要在确认服务器端完成保存操作后再刷新
                        // 否则有可能刷新不到最新的数据，因为这里是异步的
                        generateTree();
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
            $("#menuAddModal").modal("hide");

            // 清空表单
            // jQuery 对象调用 click()函数，里面不传任何参数，相当于用户点击了一下
            $("#menuResetBtn").click();
        });

        // 给编辑按钮绑定单击响应函数
        $("#treeDemo").on("click",".editBtn",function(){

            // 将当前节点的 id 保存到全局变量
            window.id = this.id;

            // 打开模态框
            $("#menuEditModal").modal("show");

            // 获取 zTreeObj 对象
            var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");

            // 根据 id 属性查询节点对象
            // 用来搜索节点的属性名
            var key = "id";

            // 用来搜索节点的属性值
            var value = window.id;
            var currentNode = zTreeObj.getNodeByParam(key, value);

            // 回显表单数据
            $("#menuEditModal [name=name]").val(currentNode.name);
            $("#menuEditModal [name=url]").val(currentNode.url);

            // 回显 radio 可以这样理解：被选中的 radio 的 value 属性可以组成一个数组，
            // 然后再用这个数组设置回 radio，就能够把对应的值选中
            $("#menuEditModal [name=icon]").val([currentNode.icon]);

            return false;
        });

        // 给更新模态框中的更新按钮绑定单击响应函数
        $("#menuEditBtn").click(function(){

            // 收集表单数据
            var name = $("#menuEditModal [name=name]").val();
            var url = $("#menuEditModal [name=url]").val();
            var icon = $("#menuEditModal [name=icon]:checked").val();

            // 发送 Ajax 请求
            $.ajax({
                "url":"menu/update.json",
                "type":"post",
                "data":{
                    "id": window.id,
                    "name":name,
                    "url":url,
                    "icon":icon
                },
                "dataType":"json",
                "success":function(response){
                    var result = response.result;
                    if(result == "SUCCESS") {

                        layer.msg("操作成功！");
                        // 重新加载树形结构，注意：要在确认服务器端完成保存操作后再刷新
                        // 否则有可能刷新不到最新的数据，因为这里是异步的
                        generateTree();
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
            $("#menuEditModal").modal("hide");
        });

        // 给“×”按钮绑定单击响应函数
        $("#treeDemo").on("click",".removeBtn",function(){

            // 将当前节点的 id 保存到全局变量
            window.id = this.id;

            // 打开模态框
            $("#menuConfirmModal").modal("show");

            // 获取 zTreeObj 对象
            var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");

            // 根据 id 属性查询节点对象
            // 用来搜索节点的属性名
            var key = "id";

            // 用来搜索节点的属性值
            var value = window.id;
            var currentNode = zTreeObj.getNodeByParam(key, value);
            $("#removeNodeSpan").html(" 【 <i class='"+currentNode.icon+"'></i>"+currentNode.name+"】");

            return false;
        });

        $("#confirmBtn").click(function(){
            $.ajax({
                "url":"menu/remove.json",
                "type":"post",
                "data":{
                    "id":window.id
                },
                "dataType":"json",
                "success":function(response){
                    var result = response.result;
                    if(result == "SUCCESS") {
                        layer.msg("操作成功！");

                        // 重新加载树形结构，注意：要在确认服务器端完成保存操作后再刷新
                        // 否则有可能刷新不到最新的数据，因为这里是异步的
                        generateTree();
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
            $("#menuConfirmModal").modal("hide");
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
                    <i class="glyphicon glyphicon-th-list"></i> 权限菜单列表
                    <div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal">
                        <i class="glyphicon glyphicon-question-sign"></i>
                    </div>
                </div>
                <div class="panel-body">
                    <%--这个ul标签是在Tree动态生成的节点所依附的静态节点--%>
                    <ul id="treeDemo" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>

    <%@include file="/WEB-INF/modal-menu-add.jsp"%>
    <%@include file="/WEB-INF/modal-menu-confirm.jsp"%>
    <%@include file="/WEB-INF/modal-menu-edit.jsp"%>

</body>
</html>