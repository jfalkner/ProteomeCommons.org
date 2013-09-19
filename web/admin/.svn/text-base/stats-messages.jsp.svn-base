<%-- 
    Document   : stats-messages
    Created on : Oct 20, 2008, 1:19:50 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.www.message.*"%><%
request.setAttribute("pageTitle", "Statistics - Messages");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%>
<div class="table">
    <div class="table-row">
        <div class="table-cell">Message Cache Size:</div>
        <div class="table-cell"><%=MessageUtil.getMessageCacheSize()%></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Message Cache Capacity:</div>
        <div class="table-cell"><%=MessageUtil.CACHE_LIMIT%></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Message Thread Cache Size:</div>
        <div class="table-cell"><%=MessageUtil.getMessageThreadCacheSize()%></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Message Thread Cache Capacity:</div>
        <div class="table-cell"><%=MessageUtil.CACHE_LIMIT%></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Messages in DB:</div>
        <div class="table-cell"><%=MessageUtil.getMessageCount()%></div>
    </div>
</div>
<%@include file="footer.jsp"%>