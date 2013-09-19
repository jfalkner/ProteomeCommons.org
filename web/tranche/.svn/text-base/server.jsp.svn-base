<%-- 
    Document   : server
    Created on : Oct 22, 2008, 10:15:45 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.tranche.gui.pools.*, org.tranche.gui.*, java.security.cert.X509Certificate, org.tranche.hash.span.*, org.tranche.flatfile.*, org.tranche.util.*, org.tranche.servers.*"%><%

String server = "";
if (request.getParameter("s") != null) {
    server = request.getParameter("s");
}

ServerSummary ss = ServerPool.getServerSummary(server);

request.setAttribute("pageTitle", "Tranche Server - " + server);
request.setAttribute("showPageTitle", "false");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%><%@include file="../header.jsp"%>
<style>
#info .title {
    font-size: 14pt;
    font-weight: bold;
}
#info .table {
    font-size: 8pt;
}
</style>
<div class="twoColumnLayout"><div class="twoColumnLayoutRow">
    <div class="leftColumn">
        <div><a href="servers.jsp">Servers</a></div>
    </div>
    <div class="rightColumn">
        <div class="rightColumnTitle">Tranche Server - <%=server%></div>
        <div class="rightColumnBody" id="info">
            <div class="title">General</div>
            <div class="table">
                <div class="table-row">
                    <div class="table-cell">Server:</div>
                    <div class="table-cell"><%= ss.getName()%></div>
                </div><div class="table-row">
                    <div class="table-cell">URL:</div>
                    <div class="table-cell"><%= ss.getUrl() %></div>
                </div><div class="table-row">
                    <div class="table-cell">Group:</div>
                    <div class="table-cell"><%= ss.getGroup() %></div>
                </div><div class="table-row">
                    <div class="table-cell">Status:</div>
                    <div class="table-cell"><%= ss.getStatus() %></div>
                </div>
            </div>
            <% if (ServerUtil.isServerOnline(server)) { %>
                <div class="title">Known servers</div>
                <div class="table">
                    <% for (String url : ss.getServerInfo().getKnownServers()) {
                        String name = url;
                        try{
                            name = ServerPool.getServerSummary(url).getName();
                        } catch (Exception e) {}
                        %>
                        <div class="table-row">
                            <div class="table-cell"><a href="server.jsp?s=<%= Util.getWebSafeString(url)%>"><%=name%></a></div>
                        </div>
                    <% } %>
                </div>
                <div class="title">Hash spans</div>
                <div class="table">
                    <% for (HashSpan hashSpan : ss.getServerInfo().getConfiguration().getHashSpans()) { %>
                        <div class="table-row">
                            <div class="table-cell" style="font-size: 8pt;">
                                <div><b>From:</b> <%=hashSpan.getFirst().toString()%></div>
                                <div><b>To:</b> <%=hashSpan.getLast().toString()%></div>
                            </div>
                        </div>
                    <% } %>
                </div>
                <div class="title">Data directories</div>
                <div class="table">
                    <% for (DataDirectoryConfiguration ddc : ss.getServerInfo().getConfiguration().getDataDirectories()) { %>
                        <div class="table-row">
                            <div class="table-cell">
                                <div>Directory: <%= ddc.getDirectory()%></div>
                                <div>Actual Size: <%=  Text.getFormattedBytes(ddc.getActualSize())%></div>
                                <div>Size Limit: <%=  Text.getFormattedBytes(ddc.getSizeLimit())%></div>
                            </div>
                        </div>
                    <% } %>
                </div>
                <div class="title">Server Configurations</div>
                <div class="table">
                    <div class="table-row">
                        <div class="table-hcell">Type</div>
                        <div class="table-hcell">Host</div>
                        <div class="table-hcell">Port</div>
                    </div>
                    <% for (ServerConfiguration serverConfiguration : ss.getServerInfo().getConfiguration().getServerConfigs()) { %>
                        <div class="table-row">
                            <div class="table-cell"><%=serverConfiguration.getType()%></div>
                            <div class="table-cell"><%=serverConfiguration.getHostName()%></div>
                            <div class="table-cell"><%=serverConfiguration.getPort()%></div>
                        </div>
                    <% } %>
                </div>
                <div class="title">Attributes</div>
                <div class="table">
                    <div class="table-row">
                        <div class="table-hcell">Name</div>
                        <div class="table-hcell">Value</div>
                    </div>
                    <% for (String name : ss.getServerInfo().getConfiguration().getValueKeys()) {
                        %>
                        <div class="table-row">
                            <div class="table-cell"><%=name%></div>
                            <div class="table-cell"><%=ss.getServerInfo().getConfiguration().getValue(name)%></div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</div></div>
<%@include file="../footer.jsp"%>