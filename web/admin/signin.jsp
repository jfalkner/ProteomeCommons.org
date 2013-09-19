<%-- 
    Document   : signin.jsp
    Created on : Oct 20, 2008, 6:57:28 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
request.setAttribute("pageTitle", "Sign In");
request.setAttribute("suppressAdminRequirement", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%>
<form action="index.jsp" method="post">
<div class="table">
    <div class="table-row">
        <div class="table-cell">User Name:</div>
        <div class="table-cell"><input type="text" name="username"/></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Password:</div>
        <div class="table-cell"><input type="password" name="pass"/></div>
    </div>
</div>
<input type="submit" value="Sign In"/>
</form>
<%@include file="footer.jsp"%>