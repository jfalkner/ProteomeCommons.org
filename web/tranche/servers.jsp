<%-- 
    Document   : servers
    Created on : Oct 22, 2008, 9:45:00 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.tranche.gui.pools.*, org.tranche.gui.*"%><%
request.setAttribute("pageTitle", "Tranche Servers");
request.setAttribute("showPageTitle", "false");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="../header.jsp"%>
<div class="twoColumnLayout"><div class="twoColumnLayoutRow">
    <div class="leftColumn">
        <div><a href="servers.jsp">Servers</a></div>
    </div>
    <div class="rightColumn">
        <div class="rightColumnTitle">Tranche Servers</div>
        <div class="rightColumnBody">
            <div class="table">
                <div class="table-row">
                    <div class="table-hcell">Server</div>
                    <div class="table-hcell">Status</div>
                    <div class="table-hcell">Latency</div>
                </div>
            <% for (ServerSummary ss : ServerPool.getServerSummaries()) { %>
                <div class="table-row">
                    <div class="table-cell"><a href="server.jsp?s=<%=Util.getWebSafeString(ss.getUrl())%>"><%=ss.getName()%></a></div>
                    <div class="table-cell"><%=ss.getStatus()%></div>
                    <div class="table-cell"><% if (ss.getLatency() > 0) { %><%=ss.getLatency()%> ms<% } %></div>
                </div>
            <% } %>
            </div>
        </div>
    </div>
</div></div>
<%@include file="../footer.jsp"%>