<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 2021/2/4
  Time: 11:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="keys" content="">
    <meta name="author" content="">
    <base href="http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/"/>
    <link rel="stylesheet" href="static/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="static/css/font-awesome.min.css">
    <link rel="stylesheet" href="static/css/login.css">
    <script src="static/jquery/jquery-2.1.1.min.js"></script>
    <script src="static/bootstrap/js/bootstrap.min.js"></script>
    <%--离子背景--%>
    <link rel="stylesheet" media="screen" href="static/css/login1.css">
    <script type="text/javascript">
        $(function (){
            $("button").click(function (){
                //相当于浏览器的后退按钮
                window.history.back();
            });
        });
    </script>
    <style>
    </style>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container">
        <div class="navbar-header">
            <div><a class="navbar-brand" href="index.html" style="font-size:32px;">言字旁网上书城</a></div>
        </div>
    </div>
</nav>

<div id="particles-js" style="display: flex;align-items: center;justify-content: center">
</div>
<div class="login-page">
    <div class="login-content">

        <div class="login-tit">
            <h2 class="form-signin-heading" style="text-align: center;">
                <i class="glyphicon glyphicon-log-in"></i>
                言字旁书城系统消息
            </h2>
        </div>
            <%--
                requestScope:对应的是村方request域数据的Map
                requestScope.exception:相当于request.getAttribut("exception")
                requestScope.exception.message:相当于exception.getMessage()
            --%>
            <h3 style="text-align: center;color: darkred;font-size: 30px;">${requestScope.exception.message}</h3>
            <button style="width: 150px;margin: 50px auto 0px auto;" class="btn btn-lg btn-success btn-block">点我返回上一步</button>


    </div>
</div>
<script src="static/js/particles.js"></script>
<script src="static/js/app.js"></script>
<script>
    function changeImg(){
        let pic = document.getElementById('picture');
        console.log(pic.src)
        if(pic.getAttribute("src",2) =="static/img/check.png"){
            pic.src ="static/img/checked.png"
        }else{
            pic.src ="static/img/check.png"
        }
    }
</script>

</body>
</html>
