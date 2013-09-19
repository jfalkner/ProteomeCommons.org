<%-- 
    Document   : stats-data
    Created on : Oct 20, 2008, 1:19:27 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.www.data.*"%><%
request.setAttribute("pageTitle", "Statistics - Data");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%>
<div class="table">
    <div class="table-row">
        <div class="table-cell">Cache Size:</div>
        <div class="table-cell"><%=DataUtil.getCacheSize()%></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Cache Capacity:</div>
        <div class="table-cell"><%=DataUtil.CACHE_LIMIT%></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Data in DB:</div>
        <div class="table-cell"><%=DataUtil.getDataCount("")%></div>
    </div>
</div>
<%@include file="footer.jsp"%>