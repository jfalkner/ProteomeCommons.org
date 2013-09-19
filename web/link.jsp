<%-- 
    Document   : link
    Created on : Sep 19, 2008, 12:47:36 AM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.tranche.util.*, org.proteomecommons.www.link.*, org.proteomecommons.www.reference.*, org.proteomecommons.www.report.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

Link link = null;
try {
    link = LinkUtil.getLink(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (link == null) {
    request.setAttribute("pageTitle", "Link Not Found");
} else {
    request.setAttribute("pageTitle", "Link - " + link.title);
}
request.setAttribute("showPageTitle", "false");

%><%@include file="header.jsp"%><%

if (link != null) {
    if (!link.active) {
        if (ReportUtil.isReportOutstandingAgainst("link", "linkID", link.linkID)) {
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
                        <div class="user"><a href="member.jsp?i=<%=link.getUser().userID%>"><%=link.getUser().unique_name%></a></div>
                        <div class="date"><%=link.date%></div>
                    </div>
                </div>
                <div class="references">
                    <div class="left-title">References:</div>
                    <div class="left-body">
                        <%
                        List <Reference> referencesFrom = link.getReferencesFrom();
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
                        List <Reference> referencesTo = link.getReferencesTo();
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
                        <div><a href="report.jsp?id=<%=link.linkID%>&table=link&field=linkID&linkUserID=<%=link.userID%>&link=<%=Util.getWebSafeString("<a href=\"@baseURLlink.jsp?i="+link.linkID+"\">"+link.title+"</a>")%>">Report Bad Content</a></div>
                        <% if (user != null) { %>
                            <% if (link.userID == link.userID) { %>
                                <div><a href="link-edit.jsp?i=<%=link.linkID%>">Add Reference</a></div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="rightColumn">
                <% if (ReportUtil.isReportOutstandingAgainst("link", "linkID", link.linkID)) { %>
                    <div style="color: red; font-weight: bold;">Warning: This item is currently under review for containing bad or illegal content.</div>
                <% } %>
                <div class="rightColumnTitle"><%=link.title%></div>
                <div class="rightColumnBody">
                    <div style="">External URL: <a href="<%=link.url%>" target="_blank"><%=link.url%></a></div>
                    <div style="padding-top: 10px; font-size: 12pt;"><%=link.description%></div>
                </div>
            </div>
        </div></div>
        <%
    }
}
%><%@include file="footer.jsp"%>