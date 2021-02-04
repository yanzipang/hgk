<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 2021/2/3
  Time: 19:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <base href="http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/"/>
    <script type="text/javascript" src="jquery/jquery-2.1.1.min.js"></script>
    <script type="text/javascript" src="layer/layer.js"></script>
    <script type="text/javascript">
        $(function(){
            //方案一
            $("#btn1").click(function(){
                $.ajax({
                    "url":"send/array/one.html",            //请求目标资源的地址
                    "type":"post",                      //请求方式
                    "data":{
                        "array":[5,8,12]
                    },                                  //要发送的请求参数
                    "dataType":"text",                  //如何对待服务器端返回的数据格式
                    "success":function(response){       //服务器端处理请求成功执行回调函数
                        alert(response);
                    },
                    "error":function(response){         //服务器端处理请求失败执行回调函数
                        alert(response);
                    }
                });
            });
            //方案三
            $("#btn2").click(function(){
                //准备好要发送到服务端的数组
                var array = [5,8,12];
                //将JSON数组转换成JSON字符串
                var requestBody = JSON.stringify(array);
                $.ajax({
                    "url":"send/array/three.json",      //请求目标资源的地址
                    "type":"post",                      //请求方式
                    "data":requestBody,                 //请求体
                    "contentType":"application/json;charset=UTF-8",     //请求体的内容类型，告诉服务器端本次请求的请求体是JSON类型
                    "dataType":"json",                  //如何对待服务器端返回的数据格式
                    "success":function(response){       //服务器端处理请求成功执行回调函数
                        console.log(response);
                    },
                    "error":function(response){         //服务器端处理请求失败执行回调函数
                        console.log(response);
                    }
                });
            });
            //弹框
            $("#btn5").click(function (){
                layer.msg("layer弹框")
            });
        });

    </script>
</head>
<body>
<%--${pageContext.request.contextPath}获取项目绝对路径--%>
<a href="test/ssm.html">测试SSM整合环境</a>
<br/>
<br/>
<button id="btn1">send 【5,8,12】 one</button>
<br/>
<br/>
<button id="btn2">send 【5,8,12】 three</button>
<br/>
<br/>
<button id="btn5">点我弹框</button>
</body>
</html>
