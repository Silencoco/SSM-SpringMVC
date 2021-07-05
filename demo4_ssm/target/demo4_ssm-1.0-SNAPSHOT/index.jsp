<%--
  Created by IntelliJ IDEA.
  User: 11877
  Date: 2021/7/6
  Time: 2:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()+"://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<html>
<head>
    <title>功能入口</title>
    <base href="<%=basePath%>"/>
</head>
<body>
    <div align="center">
        <p>SSM 整合例子</p>
        <img src="images/preview.jpg"/>
        <table>
            <tr>
                <td><a href="addStudent.jsp"> 注册学生</a></td>
            </tr>
            <tr>
                <td>浏览学生</td>
            </tr>
        </table>
    </div>
</body>
</html>
