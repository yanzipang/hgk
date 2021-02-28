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
    <title>管理员登录</title>
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
    <%--离子背景特效--%>
    <link rel="stylesheet" media="screen" href="static/css/login1.css">
    <style>
    </style>
</head>
<body>
<%--离子背景--%>
<div id="particles-js" style="display: flex;align-items: center;justify-content: center">
</div>
<div class="login-page">
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <div class="container">
            <div class="navbar-header">
                <div><a class="navbar-brand" href="index.html" style="font-size:32px;">言字旁网上书城</a></div>
            </div>
        </div>
    </nav>
    <div class="login-content">
        <form action="security/do/login.html" method="post">
            <div class="login-tit">管理员登录</div>
            <p style="color: red;text-align: center;">${requestScope.exception.message}</p>
            <p style="color: red;text-align: center;">${SPRING_SECURITY_LAST_EXCEPTION.message }</p>
            <div class="login-input">
                <input type="text" name="loginAcct" class="form-control" id="inputSuccess3" placeholder="请输入登录账号" autofocus>
                <span class="glyphicon glyphicon-user form-control-feedback"></span>
            </div>
            <div class="login-input">
                <input type="text" name="userPswd" class="form-control" id="inputSuccess4" placeholder="请输入登录密码" style="margin-top:10px;">
                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
            </div>
            <div class="login-btn">
                <div class="login-btn-left">
                    <button type="submit" class="btn btn-lg btn-success btn-block">登录</button>
                </div>
            </div>
        </form>
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
