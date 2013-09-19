<%-- 
    Document   : groups-browse
    Created on : Sep 5, 2008, 3:19:53 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.proteomecommons.www.group.*"%><%
request.setAttribute("pageTitle", "Groups - Browse");
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
int count = GroupUtil.getGroupsCount(filter, true);
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
String orderBy = "name";
if (request.getParameter("orderBy") != null) {
    try {
        orderBy = request.getParameter("orderBy");
    } catch (Exception e) {}
}
%>
<div class="table">
    <div class="table-row">
        <div class="table-cell">
            <div class="table" style="vertical-align: top; border-bottom: 1px solid #333;">
                <div class="table-row">
                    <div class="table-cell" style="font-size: 15pt; font-weight: bold;">Browse Groups</div><div class="table-cell" style="text-align: right">
                        <form action="groups-browse.jsp" method="get" id="browseGroupsForm">
                            <div>
                                <input type="text" name="filter" value="<%=filter%>"/><input type="submit" value="Search"/>
                                <select name="orderBy" onchange="getObj('browseGroupsForm').submit();">
                                    <option value="name"<% if (orderBy.equals("name")) { %> selected<% } %>>Sort By Name</option>
                                </select>
                                <select name="pageNum" onchange="getObj('browseGroupsForm').submit();">
                                    <% for (int i = 1; i <= pages; i++) { %>
                                        <option value="<%=i%>"<% if (pageNum == i) { %> selected<% } %>>Page <%=i%></option>
                                    <% } %>
                                </select>
                            </div><div>
                                <b><%=count%></b> groups found that match "<%=MySQLDatabaseUtil.formatTextForDatabase(filter)%>".
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
    List<Group> groups = GroupUtil.getGroups(filter, orderBy, "ASC", pageNum, perPage, true);
    String color1 = "#fff", color2 = "#eee";
    String color = color1;
    for (Group group : groups) {
        %>
        <div class="table-row" style="background-color: <%=color%>; padding: 10px;"><div class="table-cell">
            <div class="table"><div class="table-row"><div class="table-cell">
                <div style="font-size: 14pt;"><a href="group.jsp?i=<%=group.groupID%>"><%=group.name%></a><% if (group.isPrivate()) { %> (private)<% } %></div>
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
    }
    %>
</div><%@include file="footer.jsp"%>