<%-- 
    Document   : tool
    Created on : Aug 20, 2008, 6:48:36 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.tranche.util.*, org.proteomecommons.www.tool.*, org.proteomecommons.www.reference.*, org.proteomecommons.www.report.*"%><%

Tool tool = null;
try {
    tool = ToolUtil.getTool(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (tool == null) {
    request.setAttribute("pageTitle", "Tool Not Found");
} else {
    request.setAttribute("pageTitle", "Tool - " + tool.name);
}
request.setAttribute("showPageTitle", "false");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

if (tool != null) {
    if (!tool.active) {
        if (ReportUtil.isReportOutstandingAgainst("tool", "toolID", tool.toolID)) {
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
                        <div class="user"><a href="member.jsp?i=<%=tool.getUser().userID%>"><%=tool.getUser().unique_name%></a></div>
                        <div class="date"><%=tool.date%></div>
                    </div>
                </div>
                <div class="references">
                    <div class="left-title">References:</div>
                    <div class="left-body">
                        <%
                        List <Reference> referencesFrom = tool.getReferencesFrom();
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
                        List <Reference> referencesTo = tool.getReferencesTo();
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
                        <div><a href="report.jsp?id=<%=tool.toolID%>&table=tool&field=toolID&linkUserID=<%=tool.userID%>&link=<%=Util.getWebSafeString("<a href=\"@baseURLtool.jsp?i="+tool.toolID+"\">"+tool.name+"</a>")%>">Report Bad Content</a></div>
                        <% if (user != null) { %>
                            <% if (tool.userID == user.userID) { %>
                                <div><a href="tool-edit.jsp?i=<%=tool.toolID%>">Add Reference</a></div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="rightColumn">
                <% if (ReportUtil.isReportOutstandingAgainst("tool", "toolID", tool.toolID)) { %>
                    <div style="color: red; font-weight: bold;">Warning: This item is currently under review for containing bad or illegal content.</div>
                <% } %>
                <div class="rightColumnTitle"><%=tool.name%></div>
                <div class="rightColumnBody">
                    <div style="">External URL: <a href="<%=tool.url%>" target="_blank"><%=tool.url%></a></div>
                    <div style="padding-top: 10px; font-size: 12pt;"><%=tool.description%></div>
                </div>
            </div>
        </div></div>
        <%
    }
}
%><%@include file="footer.jsp"%>