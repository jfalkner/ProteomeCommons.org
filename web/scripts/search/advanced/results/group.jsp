<%-- 
    Document   : group
    Created on : Sep 22, 2008, 3:15:58 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, java.sql.*, org.proteomecommons.mysql.*, org.proteomecommons.www.group.*"%><%

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

String SQLFilter = "name LIKE '%";
if (request.getParameter("name") != null) { 
    SQLFilter = SQLFilter + request.getParameter("name");
}
SQLFilter = SQLFilter + "%' AND description LIKE '%";
if (request.getParameter("description") != null) { 
    SQLFilter = SQLFilter + request.getParameter("description");
}
SQLFilter = SQLFilter + "%' AND active = '1' AND private_name = '0'";

String orderBy = "name";
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

List <Group> groups = new ArrayList<Group> ();
ResultSet rs = null;

try {
    rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(groupID) AS rows FROM groups WHERE " + SQLFilter + ";");
    rs.next();
    searchCount = rs.getInt("rows");
    pages = (int) Math.ceil((double)searchCount/(double)perPage);
} catch (Exception e) {
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}

try {
    rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM groups WHERE " + SQLFilter + " ORDER BY " + orderBy + " " + orderByDir + " LIMIT " + (pageNum-1)*perPage + "," + perPage + ";");
    while (rs.next()) {
        groups.add(GroupUtil.getGroup(rs.getInt("groupID"), rs));
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
<input type="hidden" name="name" value="<%=request.getParameter("name")%>"/>
<input type="hidden" name="description" value="<%=request.getParameter("description")%>"/>
<input type="hidden" name="url" value="<%=request.getParameter("url")%>"/>
<div class="table" style="border-bottom: 1px solid #333;"><div class="table-row"><div class="table-cell">
    <input type="button" onclick="groupAdvancedSearch();" value="Search Again">
</div><div class="table-cell" style="text-align: right;">
    <% if (searchCount > 0) { %>Showing <%=((pageNum - 1) * perPage) + 1%> - <%=max%> of <%=searchCount%>.<% } else { %>No entries found.<% } %>
    <select name="orderBy" onchange="ajax.submit('@baseURLscripts/search/advanced/results/group.jsp', '<%=id%>', getObj('<%=id%>Form'));">
        <option value="name"<% if (orderBy.equals("name")) { %> selected<% } %>>Sort By Name</option>
    </select>
    <select name="pageNum" onchange="ajax.submit('@baseURLscripts/search/advanced/results/group.jsp', '<%=id%>', getObj('<%=id%>Form'));">
        <% for (int pageNumber = 1; pageNumber <= pages; pageNumber++) { %>
            <option value="<%=pageNumber%>"<% if (pageNumber == pageNum) { %> selected<% } %>>Page <%=pageNumber%></option>
        <% } %>
    </select>
</div></div></div>
<div class="table">
    <%
    String color1 = "#fff", color2 = "#eee";
    String color = color1;
    for (Group group : groups) {
        String link = "";
        if (fromPopup) {
            link = "javascript:setGroup('"+p+"', '"+i+"', '"+group.groupID+"', '"+prefix+"');";
        } else {
            link = "@baseURLgroup.jsp?i=" + group.groupID;
        }
        %>
        <div class="table-row" style="background-color: <%=color%>; padding: 10px;"><div class="table-cell">
            <div class="table"><div class="table-row"><div class="table-cell">
                <div style="font-size: 14pt;"><a href="<%=link%>"><%=group.name%></a><% if (group.isPrivate()) { %> (private)<% } %></div>
            </div><div class="table-cell" style="text-align: right;">
                <div><%=group.description%></div>
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