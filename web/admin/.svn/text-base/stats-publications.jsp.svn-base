<%-- 
    Document   : stats-publications
    Created on : Oct 20, 2008, 1:19:20 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.www.publication.*"%><%
request.setAttribute("pageTitle", "Statistics - Publications");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%>
<div class="table">
    <div class="table-row">
        <div class="table-cell">Cache Size:</div>
        <div class="table-cell"><%=PublicationUtil.getCacheSize()%></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Cache Capacity:</div>
        <div class="table-cell"><%=PublicationUtil.CACHE_LIMIT%></div>
    </div>
    <div class="table-row">
        <div class="table-cell">References in DB:</div>
        <div class="table-cell"><%=PublicationUtil.getPublicationCount("")%></div>
    </div>
</div>
<%@include file="footer.jsp"%>