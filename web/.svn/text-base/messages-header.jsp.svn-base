<%-- 
    Document   : messages-header
    Created on : Oct 29, 2008, 12:28:52 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("pageTitle", "Messages");
request.setAttribute("pageUsersOnly", "true");
request.setAttribute("showPageTitle", "false");
if (request.getAttribute("messagesPageTitle") != null) {
    request.setAttribute("pageTitle", request.getAttribute("pageTitle").toString() + " - " + request.getAttribute("messagesPageTitle").toString());
}

%><%@include file="header.jsp"%>
<div class="twoColumnLayout"><div class="twoColumnLayoutRow">
    <div class="leftColumn">
        <div class="actions" style="padding-top: 10px;">
            <div class="left-title">Actions:</div>
            <div class="left-body">
                <div><a href="messages.jsp">Received</a></div>
                <div><a href="messages-sent.jsp">Sent</a></div>
                <div><a href="messages-compose.jsp">Compose a Message</a></div>
            </div>
        </div>
    </div>
    <div class="rightColumn">
        <% if (request.getAttribute("messagesPageTitle") != null) { %><div class="rightColumnTitle"><%=request.getAttribute("messagesPageTitle").toString()%></div><% } %>
        <div class="rightColumnBody">