<%-- 
    Document   : link
    Created on : Sep 22, 2008, 3:16:07 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, java.sql.*, org.proteomecommons.mysql.*, org.proteomecommons.www.link.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

// get possible reference 
String id = "";
if (request.getParameter("id") != null) {
    id = request.getParameter("id");
}
String i = "";
if (request.getParameter("i") != null) {
    i = request.getParameter("i");
}
String p = "";
if (request.getParameter("p") != null) {
    p = request.getParameter("p");
}
String prefix = "";
if (request.getParameter("prefix") != null) {
    prefix = request.getParameter("prefix");
}
boolean fromPopup = false;
if (request.getParameter("searchType") != null) {
    try {
        fromPopup = request.getParameter("searchType").equals("popup");
    } catch (Exception e) {}
}

String SQLFilter = "title LIKE '%";
if (request.getParameter("title") != null) { 
    SQLFilter = SQLFilter + request.getParameter("title");
}
SQLFilter = SQLFilter + "%' AND description LIKE '%";
if (request.getParameter("description") != null) { 
    SQLFilter = SQLFilter + request.getParameter("description");
}
SQLFilter = SQLFilter + "%' AND url LIKE '%";
if (request.getParameter("url") != null) { 
    SQLFilter = SQLFilter + request.getParameter("url");
}
SQLFilter = SQLFilter + "%' AND active = '1'";

String orderBy = "title";
if (request.getParameter("orderBy") != null) {
    orderBy = request.getParameter("orderBy");
}

String orderByDir = "ASC";
if (request.getParameter("orderByDir") != null) {
    orderByDir = request.getParameter("orderByDir");
}

int pageNum = 1;
if (request.getParameter("pageNum") != null) {
    try {
        pageNum = Integer.valueOf(request.getParameter("pageNum"));
    } catch (Exception e) {
    }
    if (pageNum < 1) {
        pageNum = 1;
    }
}

int perPage = 10, searchCount = 0, pages = 1;

List <Link> links = new ArrayList<Link> ();
ResultSet rs = null;

try {
    rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(linkID) AS rows FROM link WHERE " + SQLFilter + ";");
    rs.next();
    searchCount = rs.getInt("rows");
    pages = (int) Math.ceil((double)searchCount/(double)perPage);
} catch (Exception e) {
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}

try {
    rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM link WHERE " + SQLFilter + " ORDER BY " + orderBy + " " + orderByDir + " LIMIT " + (pageNum-1)*perPage + "," + perPage + ";");
    while (rs.next()) {
        links.add(LinkUtil.getLink(rs.getInt("linkID"), rs));
    }
} catch (Exception e) {
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}

int max = pageNum*perPage;
if (max > searchCount) {
    max = searchCount;
}

long timeMillis = System.currentTimeMillis();
%>
<input type="hidden" name="orderByDir" id="orderByDir<%=timeMillis%>" value="<%=orderByDir%>"/>
<input type="hidden" name="title" value="<%=request.getParameter("title")%>"/>
<input type="hidden" name="description" value="<%=request.getParameter("description")%>"/>
<input type="hidden" name="url" value="<%=request.getParameter("url")%>"/>
<div class="table" style="border-bottom: 1px solid #333;"><div class="table-row"><div class="table-cell">
    <input type="button" onclick="linkAdvancedSearch();" value="Search Again">
</div><div class="table-cell" style="text-align: right;">
    <% if (searchCount > 0) { %>Showing <%=((pageNum - 1) * perPage) + 1%> - <%=max%> of <%=searchCount%>.<% } else { %>No entries found.<% } %>
    <select name="orderBy" onchange="ajax.submit('@baseURLscripts/search/advanced/results/link.jsp', '<%=id%>', getObj('<%=id%>Form'));">
        <option value="title"<% if (orderBy.equals("title")) { %> selected<% } %>>Sort By Title</option>
        <option value="date"<% if (orderBy.equals("date")) { %> selected<% } %>>Sort By Date</option>
    </select>
    <select name="pageNum" onchange="ajax.submit('@baseURLscripts/search/advanced/results/link.jsp', '<%=id%>', getObj('<%=id%>Form'));">
        <% for (int pageNumber = 1; pageNumber <= pages; pageNumber++) { %>
            <option value="<%=pageNumber%>"<% if (pageNumber == pageNum) { %> selected<% } %>>Page <%=pageNumber%></option>
        <% } %>
    </select>
</div></div></div>
<div class="table">
    <% 
    String color1 = "#fff", color2 = "#eee";
    String color = color1;
    for (Link l : links) {
        String link = "";
        if (fromPopup) {
            link = "javascript:setLink('"+p+"', '"+i+"', '"+l.linkID+"', '"+prefix+"');";
        } else {
            link = "@baseURLlink.jsp?i=" + l.linkID;
        }
        %>
        <div class="table-row" style="background-color: <%=color%>; padding: 5px;"><div class="table-cell">
            <div class="table"><div class="table-row"><div class="table-cell">
                <div style="font-size: 14pt;"><a href="<%=link%>"><%=l.title%></a></div>
                <div>External URL: <a href="<%=l.url%>" target="_blank"><%=l.url%></a></div>
            </div><div class="table-cell" style="text-align: right;">
                <div><%=l.description%></div>
            </div></div></div>
        </div></div>
        <%
        if (color.equals(color1)) {
            color = color2;
        } else {
            color = color1;
        }
    } %>
</div>