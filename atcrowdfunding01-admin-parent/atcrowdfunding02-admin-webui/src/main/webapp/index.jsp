<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 2021/2/3
  Time: 14:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <base href="http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/"/>
</head>
<body>
    <%--${pageContext.request.contextPath}获取项目绝对路径--%>
    <a href="test/ssm.html">测试SSM整合环境</a>
</body>
</html>
