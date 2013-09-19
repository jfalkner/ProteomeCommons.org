<%-- 
    Document   : members-browse
    Created on : Sep 5, 2008, 3:19:47 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.proteomecommons.www.user.*"%><%
request.setAttribute("pageTitle", "Members - Browse");
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
int count = UserUtil.getUserCount(filter, true);
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
String orderBy = "unique_name";
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
                    <div class="table-cell" style="font-size: 15pt; font-weight: bold;">Browse Members</div><div class="table-cell" style="text-align: right">
                        <form action="members-browse.jsp" method="get" id="browseMembersForm">
                            <div>
                                <input type="text" name="filter" value="<%=filter%>"/><input type="submit" value="Search"/>
                                <select name="orderBy" onchange="getObj('browseMembersForm').submit();">
                                    <option value="unique_name"<% if (orderBy.equals("unique_name")) { %> selected<% } %>>Sort By Unique Name</option>
                                    <option value="first_name"<% if (orderBy.equals("first_name")) { %> selected<% } %>>Sort By First Name</option>
                                    <option value="last_name"<% if (orderBy.equals("last_name")) { %> selected<% } %>>Sort By Last Name</option>
                                    <option value="organization"<% if (orderBy.equals("organization")) { %> selected<% } %>>Sort By Organization</option>
                                    <option value="department"<% if (orderBy.equals("department")) { %> selected<% } %>>Sort By Department</option>
                                    <option value="regionID"<% if (orderBy.equals("regionID")) { %> selected<% } %>>Sort By Region</option>
                                    <option value="countryID"<% if (orderBy.equals("countryID")) { %> selected<% } %>>Sort By Country</option>
                                </select>
                                <select name="pageNum" onchange="getObj('browseMembersForm').submit();">
                                    <% for (int i = 1; i <= pages; i++) { %>
                                        <option value="<%=i%>"<% if (pageNum == i) { %> selected<% } %>>Page <%=i%></option>
                                    <% } %>
                                </select>
                            </div><div>
                                <b><%=count%></b> members found that match "<%=MySQLDatabaseUtil.formatTextForDatabase(filter)%>".
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
    List<User> users = UserUtil.getUsers(filter, orderBy, "ASC", pageNum, perPage, true);
    String color1 = "#fff", color2 = "#eee";
    String color = color1;
    for (User u : users) {
        %>
        <div class="table-row" style="background-color: <%=color%>; padding: 10px;"><div class="table-cell">
            <div class="table"><div class="table-row"><div class="table-cell">
                <div style="font-size: 14pt;"><a href="member.jsp?i=<%=u.userID%>"><%=u.unique_name%></a></div>
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
</div><%@include file="footer.jsp"%>