<%-- 
    Document   : publication
    Created on : Aug 20, 2008, 6:44:31 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.tranche.util.*, org.proteomecommons.www.publication.*, org.proteomecommons.www.reference.*, org.proteomecommons.www.report.*"%><%

Publication publication = null;
try {
    publication = PublicationUtil.getPublication(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (publication == null) {
    request.setAttribute("pageTitle", "Publication Not Found");
} else {
    request.setAttribute("pageTitle", "Publication - " + publication.title);
}
request.setAttribute("showPageTitle", "false");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

if (publication != null) {
    if (!publication.active) {
        if (ReportUtil.isReportOutstandingAgainst("publication", "publicationID", publication.publicationID)) {
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
                        <div class="user"><a href="member.jsp?i=<%=publication.getUser().userID%>"><%=publication.getUser().unique_name%></a></div>
                        <div class="date"><%=publication.date%></div>
                    </div>
                </div>
                <div class="references">
                    <div class="left-title">References:</div>
                    <div class="left-body">
                        <%
                        List <Reference> referencesFrom = publication.getReferencesFrom();
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
                        List <Reference> referencesTo = publication.getReferencesTo();
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
                        <div><a href="report.jsp?id=<%=publication.publicationID%>&table=publication&field=publicationID&linkUserID=<%=publication.userID%>&link=<%=Util.getWebSafeString("<a href=\"@baseURLpublication.jsp?i="+publication.publicationID+"\">"+publication.title+"</a>")%>">Report Bad Content</a></div>
                        <% if (user != null) { %>
                            <% if (publication.userID == publication.userID) { %>
                                <div><a href="publication-edit.jsp?i=<%=publication.publicationID%>">Add Reference</a></div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="rightColumn">
                <% if (ReportUtil.isReportOutstandingAgainst("publication", "publicationID", publication.publicationID)) { %>
                    <div style="color: red; font-weight: bold;">Warning: This item is currently under review for containing bad or illegal content.</div>
                <% } %>
                <div class="rightColumnTitle"><%=publication.title%></div>
                <div class="rightColumnBody">
                    <div class="table"><div class="table-row">
                        <div class="table-cell">Citation:</div>
                        <div class="table-cell"><%=publication.citation%></div>
                    </div></div>
                    <% if (publication.url != null && !publication.url.equals("")) { %>
                        <div style="">External URL: <a href="<%=publication.url%>" target="_blank"><%=publication.url%></a></div>
                    <% } %>
                    <div style="padding-top: 10px; font-size: 12pt;"><%=publication.description%></div>
                </div>
            </div>
        </div></div>
        <%
    }
}
%><%@include file="footer.jsp"%>