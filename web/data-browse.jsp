<%-- 
    Document   : data-browse
    Created on : Sep 5, 2008, 3:19:22 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.proteomecommons.www.data.*, org.tranche.util.*"%><%
request.setAttribute("pageTitle", "Data - Browse");
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
int count = DataUtil.getDataCount(filter, true);
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
                    <div class="table-cell" style="font-size: 15pt; font-weight: bold;">Browse Data</div><div class="table-cell" style="text-align: right">
                        <form action="data-browse.jsp" method="get" id="browseDataForm">
                            <div>
                                <input type="text" name="filter" value="<%=filter%>"/><input type="submit" value="Search"/>
                                <select name="orderBy" onchange="getObj('browseDataForm').submit();">
                                    <option value="title"<% if (orderBy.equals("title")) { %> selected<% } %>>Sort By Title</option>
                                    <option value="date_uploaded"<% if (orderBy.equals("date_uploaded")) { %> selected<% } %>>Sort By Date</option>
                                </select>
                                <select name="pageNum" onchange="getObj('browseDataForm').submit();">
                                    <% for (int i = 1; i <= pages; i++) { %>
                                        <option value="<%=i%>"<% if (pageNum == i) { %> selected<% } %>>Page <%=i%></option>
                                    <% } %>
                                </select>
                            </div><div>
                                <b><%=count%></b> data found that match "<%=MySQLDatabaseUtil.formatTextForDatabase(filter)%>".
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
    List<Data> data = DataUtil.getData(filter, orderBy, "ASC", pageNum, perPage, true);
    String color1 = "#fff", color2 = "#eee";
    String color = color1;
    for (Data d : data) {
        %>
        <div class="table-row" style="background-color: <%=color%>; padding: 10px;"><div class="table-cell">
            <div class="table"><div class="table-row"><div class="table-cell">
                <div style="font-size: 14pt;"><a href="data.jsp?i=<%=d.dataID%>"><%=d.title%></a></div>
                <div><%=Util.formatNumber(d.files)%> files, <%=Text.getFormattedBytes(d.size)%></div>
                <div><%=d.date_uploaded%></div>
            </div><div class="table-cell" style="text-align: right;">
                <div><%=d.description%></div>
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