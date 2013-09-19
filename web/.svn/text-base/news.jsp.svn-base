<%-- 
    Document   : news
    Created on : Aug 20, 2008, 6:18:08 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.tranche.util.*, org.proteomecommons.www.news.*, org.proteomecommons.www.reference.*, org.proteomecommons.www.report.*"%><%

News news = null;
try {
    news = NewsUtil.getNews(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (news == null) {
    request.setAttribute("pageTitle", "News Not Found");
} else {
    request.setAttribute("pageTitle", "News - " + news.title);
}
request.setAttribute("showPageTitle", "false");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

if (news != null) {
    if (!news.active) {
        if (ReportUtil.isReportOutstandingAgainst("news", "newsID", news.newsID)) {
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
                        <div class="user"><a href="member.jsp?i=<%=news.getUser().userID%>"><%=news.getUser().unique_name%></a></div>
                        <div class="date"><%=news.date%></div>
                    </div>
                </div>
                <div class="references">
                    <div class="left-title">References:</div>
                    <div class="left-body">
                        <%
                        List <Reference> referencesFrom = news.getReferencesFrom();
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
                        List <Reference> referencesTo = news.getReferencesTo();
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
                        <div><a href="report.jsp?id=<%=news.newsID%>&table=news&field=newsID&linkUserID=<%=news.userID%>&link=<%=Util.getWebSafeString("<a href=\"@baseURLnews.jsp?i="+news.newsID+"\">"+news.title+"</a>")%>">Report Bad Content</a></div>
                        <% if (user != null) { %>
                            <% if (news.userID == news.userID) { %>
                                <div><a href="news-edit.jsp?i=<%=news.newsID%>">Add Reference</a></div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="rightColumn">
                <% if (ReportUtil.isReportOutstandingAgainst("news", "newsID", news.newsID)) { %>
                    <div style="color: red; font-weight: bold;">Warning: This item is currently under review for containing bad or illegal content.</div>
                <% } %>
                <div class="rightColumnTitle"><%=news.title%></div>
                <div class="rightColumnBody">
                    <div style="">External URL: <a href="<%=news.url%>" target="_blank"><%=news.url%></a></div>
                    <div style="padding-top: 10px; font-size: 12pt;"><%=news.description%></div>
                </div>
            </div>
        </div></div>
        <%
    }
}
%><%@include file="footer.jsp"%>