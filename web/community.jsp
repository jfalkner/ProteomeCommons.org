<%-- 
    Document   : community.jsp
    Created on : Sep 5, 2008, 3:18:41 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
request.setAttribute("pageTitle", "Community");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%>
<%@include file="footer.jsp"%>