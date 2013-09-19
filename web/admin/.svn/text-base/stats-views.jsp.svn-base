<%-- 
    Document   : stats-views
    Created on : Oct 20, 2008, 2:17:46 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*, org.proteomecommons.mysql.*"%><%
request.setAttribute("pageTitle", "Statistics - Groups");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%>
<div class="table">
    <div class="table-row">
        <div class="table-cell"># Views:</div>
        <div class="table-cell">
            <%
            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(pageViewID) AS rows FROM page_view;");
                rs.next();
                %><%=rs.getInt("rows")%><%
            } catch (Exception e) {
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
            %>
        </div>
    </div>
</div>
<%@include file="footer.jsp"%>