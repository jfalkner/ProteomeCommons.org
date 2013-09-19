<%-- 
    Document   : my-links
    Created on : Oct 21, 2008, 3:47:28 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.proteomecommons.www.link.*, org.tranche.util.*"%><%
request.setAttribute("pageTitle", "My Links");
request.setAttribute("showPageTitle", "false");
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

if (user != null) {
    String filter = "";
    if (request.getParameter("filter") != null) {
        try {
            filter = request.getParameter("filter");
        } catch (Exception e) {}
    }
    int count = LinkUtil.getLinksCount(filter, true, user.userID);
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
                <div class="table" style="vertical-align: top; border-bottom: 1px solid #333;">
                    <div class="table-row">
                        <div class="table-cell" style="font-size: 15pt; font-weight: bold;">My Links</div><div class="table-cell" style="text-align: right">
                            <form action="my-links.jsp" method="get" id="browseLinkForm">
                                <div>
                                    <input type="text" name="filter" value="<%=filter%>"/><input type="submit" value="Search"/>
                                    <select name="orderBy" onchange="getObj('browseLinkForm').submit();">
                                        <option value="title"<% if (orderBy.equals("title")) { %> selected<% } %>>Sort By Title</option>
                                        <option value="date"<% if (orderBy.equals("date")) { %> selected<% } %>>Sort By Date</option>
                                    </select>
                                    <select name="pageNum" onchange="getObj('browseLinkForm').submit();">
                                        <% for (int i = 1; i <= pages; i++) { %>
                                            <option value="<%=i%>"<% if (pageNum == i) { %> selected<% } %>>Page <%=i%></option>
                                        <% } %>
                                    </select>
                                </div><div>
                                    <b><%=count%></b> links found that match "<%=MySQLDatabaseUtil.formatTextForDatabase(filter)%>".
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%
        List<Link> links = LinkUtil.getLinks(filter, orderBy, "ASC", pageNum, perPage, true, user.userID);
        String color1 = "#fff", color2 = "#eee";
        String color = color1;
        for (Link link : links) {
            %>
            <div class="table-row" style="background-color: <%=color%>; padding: 10px;"><div class="table-cell">
                <div class="table"><div class="table-row"><div class="table-cell">
                    <div style="font-size: 14pt;"><a href="link.jsp?i=<%=link.linkID%>"><%=link.title%></a></div>
                    <div>External URL: <a href="<%=link.url%>" target="_blank"><%=link.url%></a></div>
                </div><div class="table-cell" style="text-align: right;">
                    <div><%=link.description%></div>
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
<% } %><%@include file="footer.jsp"%>