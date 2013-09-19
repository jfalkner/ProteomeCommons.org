<%-- 
    Document   : data
    Created on : Aug 20, 2008, 6:18:44 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.tranche.hash.*, java.util.*, org.tranche.util.*, org.proteomecommons.www.data.*, org.proteomecommons.www.reference.*, org.proteomecommons.www.report.*"%><%

Data data = null;
try {
    data = DataUtil.getData(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (data == null) {
    request.setAttribute("pageTitle", "Data Not Found");
} else {
    request.setAttribute("pageTitle", "Data - " + data.title);
}
request.setAttribute("showPageTitle", "false");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

if (data != null) {
    if (!data.active) {
        if (ReportUtil.isReportOutstandingAgainst("data", "dataID", data.dataID)) {
            %><div style="color: red; font-weight: bold; padding-bottom: 5px;">This item was removed from ProteomeCommons.org because it was found to contain bad or illegal content.</div><%
        } else {
            %><div style="color: red; font-weight: bold; padding-bottom: 5px;">This item was removed from ProteomeCommons.org.</div><%
        }
    } else {
        %>
        <div class="twoColumnLayout"><div class="twoColumnLayoutRow">
            <div class="leftColumn">
                <div class="submittedBy">
                    <div class="left-title">Submitted By:</div>
                    <div class="left-body">
                        <div class="user"><a href="member.jsp?i=<%=data.getUser().userID%>"><%=data.getUser().unique_name%></a></div>
                        <div class="date"><%=data.date_uploaded%></div>
                    </div>
                </div>
                <div class="references">
                    <div class="left-title">References:</div>
                    <div class="left-body">
                        <%
                        List <Reference> referencesFrom = data.getReferencesFrom();
                        if (referencesFrom.size() > 0) {
                            for (Reference r : referencesFrom) {
                                %><div><%=r.displayTo()%></div><%
                            }
                        } else {
                            %><div>None</div><%
                        }
                        %>
                    </div>
                </div>
                <div class="referencedFrom">
                    <div class="left-title">Referenced From:</div>
                    <div class="left-body">
                        <%
                        List <Reference> referencesTo = data.getReferencesTo();
                        if (referencesTo.size() > 0) {
                            for (Reference r : referencesTo) {
                                %><div><%=r.displayFrom()%></div><%
                            }
                        } else {
                            %><div>None</div><%
                        }
                        %>
                    </div>
                </div>
                <div class="actions">
                    <div class="left-title">Actions:</div>
                    <div class="left-body">
                        <div><a href="report.jsp?id=<%=data.dataID%>&table=data&field=dataID&linkUserID=<%=data.userID%>&link=<%=Util.getWebSafeString("<a href=\"@baseURLdata.jsp?i="+data.dataID+"\">"+data.title+"</a>")%>">Report Bad Content</a></div>
                        <div><a href="data-downloader.jsp?i=<%=data.dataID%>">Download</a></div>
                        <% if (user != null) { %>
                            <% if (data.userID == data.userID) { %>
                                <div>Annotate</div>
                                <div><a href="data-uploader.jsp?oldVersion=<%= data.hash.toWebSafeString() %>">Upload Newer Version</a></div>
                                <div><a href="data-uploader.jsp?newVersion=<%= data.hash.toWebSafeString() %>">Upload Older Version</a></div>
                                <% if (data.active) { %>
                                    <div>Hide (reversible)</div>
                                <% } else { %>
                                    <div>Un-Hide</div>
                                <% } %>
                                <div>Delete (non-reversible)</div>
                                <% if (data.encrypted) { %>
                                    <% if (data.date_published.compareTo(data.date_uploaded) < 0) { %>
                                        <div>Publish</div>
                                    <% } else { %>
                                        <div>Unpublish</div>
                                    <% } %>
                                <% } %>
                                <div>Forgot Passphrase</div>
                                <div><a href="data-edit.jsp?i=<%=data.dataID%>">Add Reference</a></div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="rightColumn">
                <% if (ReportUtil.isReportOutstandingAgainst("data", "dataID", data.dataID)) { %>
                    <div style="color: red; font-weight: bold; padding-bottom: 5px;">Warning: This item is currently under review for containing bad or illegal content.</div>
                <% } %>
                <div class="rightColumnTitle"><%=data.title%></div>
                <div class="rightColumnBody">
                    <div><%=Util.formatNumber(data.files)%> files</div>
                    <div><%=Text.getFormattedBytes(data.size)%></div>
                    <div>Tranche Hash: <span style="font-size: 8pt;"><%=data.hash.toString()%></span></div>
                    <% if (data.hasNewVersion()) {
                        BigHash newVersionHash = data.getNewVersion();
                        Data newVersion = DataUtil.getData(newVersionHash);
                        %><div>New Version: <% if (newVersion.isSet()) { %><a href="data.jsp?i=<%=newVersion.dataID%>"><%=newVersion.title%></a><% } else { %><%=newVersionHash.toString()%><% } %></div><%
                    }
                    if (data.hasOldVersion()) {
                        BigHash oldVersionHash = data.getOldVersion();
                        Data oldVersion = DataUtil.getData(oldVersionHash);
                        %><div>Old Version: <% if (oldVersion.isSet()) { %><a href="data.jsp?i=<%=oldVersion.dataID%>"><%=oldVersion.title%></a><% } else { %><%=oldVersionHash.toString()%><% } %></div><%                        
                    }%>
                    <div style="padding-top: 10px; font-size: 12pt;"><%=data.description%></div>
                </div>
            </div>
        </div></div>
        <%
    }
}
%><%@include file="footer.jsp"%>