<%-- 
    Document   : news-browse
    Created on : Sep 5, 2008, 3:08:23 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*,org.tranche.util.*,org.proteomecommons.www.news.*"%><%
request.setAttribute("pageTitle", "News - Browse");
request.setAttribute("showPageTitle", "false");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

String filter = "";
if (request.getParameter("filter") != null) {
    try {
        filter = request.getParameter("filter");
    } catch (Exception e) {}
}
int count = NewsUtil.getNewsCount(filter, true);
int pageNum = 1;
if (request.getParameter("pageNum") != null) {
    try {
        pageNum = Integer.valueOf(request.getParameter("pageNum"));
    } catch (Exception e) {}
}
int perPage = 10;
int pages = (int) Math.ceil((double)count/(double)perPage);
if (pages == 0) {
    pages = 1;
}
String orderBy = "title";
if (request.getParameter("orderBy") != null) {
    try {
        orderBy = request.getParameter("orderBy");
    } catch (Exception e) {}
}
%>
<div class="table">
    <div class="table-row">
        <div class="table-cell">
            <div class="table" style="vertical-align: top;">
                <div class="table-row">
                    <div class="table-cell" style="font-size: 15pt; font-weight: bold;">Browse News</div><div class="table-cell" style="text-align: right">
                        <form action="news-browse.jsp" method="get" id="browseNewsForm">
                            <div>
                                <input type="text" name="filter" value="<%=filter%>"/><input type="submit" value="Search"/>
                                <select name="orderBy" onchange="getObj('browseNewsForm').submit();">
                                    <option value="title"<% if (orderBy.equals("title")) { %> selected<% } %>>Sort By Title</option>
                                    <option value="date"<% if (orderBy.equals("date")) { %> selected<% } %>>Sort By Date</option>
                                </select>
                                <select name="pageNum" onchange="getObj('browseNewsForm').submit();">
                                    <% for (int i = 1; i <= pages; i++) { %>
                                        <option value="<%=i%>"<% if (pageNum == i) { %> selected<% } %>>Page <%=i%></option>
                                    <% } %>
                                </select>
                            </div><div>
                                <b><%=count%></b> news articles found that match "<%=MySQLDatabaseUtil.formatTextForDatabase(filter)%>".
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
    List<News> news = NewsUtil.getNews(filter, orderBy, "ASC", pageNum, perPage, true);
    String color1 = "#fff", color2 = "#d2e4e7";
    String color = color1;
    for (News n : news) {
        %>
        <div class="table-row" style="background-color: <%=color%>; padding: 10px;"><div class="table-cell">
            <div class="table"><div class="table-row"><div class="table-cell">
                <div style="font-size: 14pt;"><a href="news.jsp?i=<%=n.newsID%>"><%=n.title%></a></div>
                <div>External URL: <a href="<%=n.url%>" target="_blank"><%=n.url%></a></div>
            </div><div class="table-cell" style="text-align: right;">
                <div><%=n.description%></div>
            </div></div></div>
        </div></div>
        <%
        if (color.equals(color1)) {
            color = color2;
        } else {
            color = color1;
        }
    }
    %>
</div><%@include file="footer.jsp"%>