<%-- 
    Document   : userAdvancedSearchFromPopup
    Created on : Sep 10, 2008, 4:03:38 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, java.sql.*, org.proteomecommons.mysql.*, org.proteomecommons.www.user.*"%><%

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

// set up sql filter
String SQLFilter = "unique_name LIKE '%";
if (request.getParameter("unique_name") != null) { 
    SQLFilter = SQLFilter + request.getParameter("unique_name");
}
SQLFilter = SQLFilter + "%' AND email LIKE '%";
if (request.getParameter("email") != null) { 
    SQLFilter = SQLFilter + request.getParameter("email");
}
SQLFilter = SQLFilter + "%'";
if (request.getParameter("user_prefix") != null) { 
    if (!request.getParameter("user_prefix").equals("")) {
        SQLFilter = SQLFilter + " AND prefix = '" + request.getParameter("user_prefix") + "'";
    }
}
SQLFilter = SQLFilter + " AND first_name LIKE '%";
if (request.getParameter("first_name") != null) { 
    SQLFilter = SQLFilter + request.getParameter("first_name");
}
SQLFilter = SQLFilter + "%' AND middle_name LIKE '%";
if (request.getParameter("middle_name") != null) { 
    SQLFilter = SQLFilter + request.getParameter("middle_name");
}
SQLFilter = SQLFilter + "%' AND last_name LIKE '%";
if (request.getParameter("last_name") != null) { 
    SQLFilter = SQLFilter + request.getParameter("last_name");
}
SQLFilter = SQLFilter + "%' AND organization LIKE '%";
if (request.getParameter("organization") != null) { 
    SQLFilter = SQLFilter + request.getParameter("organization");
}
SQLFilter = SQLFilter + "%' AND department LIKE '%";
if (request.getParameter("department") != null) { 
    SQLFilter = SQLFilter + request.getParameter("department");
}
SQLFilter = SQLFilter + "%'";
if (request.getParameter("suffix") != null) { 
    if (!request.getParameter("suffix").equals("")) { 
        SQLFilter = SQLFilter + " AND suffix = '" + request.getParameter("suffix") + "'";
    }
}
if (request.getParameter("countryID") != null) { 
    if (!request.getParameter("countryID").equals("")) { 
        SQLFilter = SQLFilter + " AND countryID = '" + request.getParameter("countryID") + "'";
    }
}
if (request.getParameter("regionID") != null) { 
    if (!request.getParameter("regionID").equals("")) { 
        SQLFilter = SQLFilter + " AND regionID = '" + request.getParameter("regionID") + "'";
    }
}
SQLFilter = SQLFilter + " AND active = '1'";

String orderBy = "unique_name";
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

List <User> users = new ArrayList<User> ();
ResultSet rs = null;
try {
    rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(userID) AS rows FROM user WHERE " + SQLFilter + ";");
    rs.next();
    searchCount = rs.getInt("rows");
    pages = (int) Math.ceil((double)searchCount/(double)perPage);
} catch (Exception e) {
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}

try {
    rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM user WHERE " + SQLFilter + " ORDER BY " + orderBy + " " + orderByDir + " LIMIT " + (pageNum-1)*perPage + "," + perPage + ";");
    while (rs.next()) {
        users.add(UserUtil.getUser(rs.getInt("userID"), rs));
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
<input type="hidden" name="unique_name" value="<%=request.getParameter("unique_name")%>"/>
<input type="hidden" name="email" value="<%=request.getParameter("email")%>"/>
<input type="hidden" name="user_prefix" value="<%=request.getParameter("user_prefix")%>"/>
<input type="hidden" name="first_name" value="<%=request.getParameter("first_name")%>"/>
<input type="hidden" name="middle_name" value="<%=request.getParameter("middle_name")%>"/>
<input type="hidden" name="last_name" value="<%=request.getParameter("last_name")%>"/>
<input type="hidden" name="suffix" value="<%=request.getParameter("suffix")%>"/>
<input type="hidden" name="countryID" value="<%=request.getParameter("countryID")%>"/>
<input type="hidden" name="regionID" value="<%=request.getParameter("regionID")%>"/>
<input type="hidden" name="organization" value="<%=request.getParameter("organization")%>"/>
<input type="hidden" name="department" value="<%=request.getParameter("department")%>"/>
<div class="table" style="border-bottom: 1px solid #333;"><div class="table-row"><div class="table-cell">
    <input type="button" onclick="userAdvancedSearch();" value="Search Again">
</div><div class="table-cell" style="text-align: right;">
    <% if (searchCount > 0) { %>Showing <%=((pageNum - 1) * perPage) + 1%> - <%=max%> of <%=searchCount%>.<% } else { %>No entries found.<% } %>
    <select name="orderBy" onchange="ajax.submit('@baseURLscripts/search/advanced/results/user.jsp', '<%=id%>', getObj('<%=id%>Form'));">
        <option value="unique_name"<% if (orderBy.equals("unique_name")) { %> selected<% } %>>Sort By Unique Name</option>
        <option value="first_name"<% if (orderBy.equals("first_name")) { %> selected<% } %>>Sort By First Name</option>
        <option value="last_name"<% if (orderBy.equals("last_name")) { %> selected<% } %>>Sort By Last Name</option>
        <option value="organization"<% if (orderBy.equals("organization")) { %> selected<% } %>>Sort By Organization</option>
        <option value="department"<% if (orderBy.equals("department")) { %> selected<% } %>>Sort By Department</option>
        <option value="regionID"<% if (orderBy.equals("regionID")) { %> selected<% } %>>Sort By Region</option>
        <option value="countryID"<% if (orderBy.equals("countryID")) { %> selected<% } %>>Sort By Country</option>
    </select>
    <select name="pageNum" onchange="ajax.submit('@baseURLscripts/search/advanced/results/user.jsp', '<%=id%>', getObj('<%=id%>Form'));">
        <% for (int pageNumber = 1; pageNumber <= pages; pageNumber++) { %>
            <option value="<%=pageNumber%>"<% if (pageNumber == pageNum) { %> selected<% } %>>Page <%=pageNumber%></option>
        <% } %>
    </select>
</div></div></div>
<div class="table">
    <% 
    String color1 = "#fff", color2 = "#eee";
    String color = color1;
    for (User u : users) { 
        String link = "";
        if (fromPopup) {
            link = "javascript:setUser('"+p+"', '"+i+"', '"+u.userID+"', '"+prefix+"');";
        } else {
            link = "@baseURLmember.jsp?i=" + u.userID;
        }
        %>
        <div class="table-row" style="background-color: <%=color%>; padding: 10px;"><div class="table-cell">
            <div class="table"><div class="table-row"><div class="table-cell">
                <div style="font-size: 14pt;"><a href="<%=link%>"><%=u.unique_name%></a></div>
                <div><%=u.organization%> - <%=u.department%></div>
                <div><%=u.region.region%><% if (u.region.regionID != -1) { %>, <% } %><%=u.country.country%></div>
            </div><div class="table-cell" style="text-align: right;">
                <div><%=u.prefix%> <%=u.first_name%> <%=u.middle_name%> <%=u.last_name%> <%=u.suffix%></div>
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
</div>