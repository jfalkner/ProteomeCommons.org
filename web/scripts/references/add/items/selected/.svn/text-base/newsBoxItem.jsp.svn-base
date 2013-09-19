<%-- 
    Document   : newsBoxItem
    Created on : Sep 10, 2008, 5:40:15 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

ResultSet rs = null;
try {
    String newsBoxItemPrefix = "";
    if (request.getParameter("prefix") != null) {
        newsBoxItemPrefix = request.getParameter("prefix");
    }
    
    rs = MySQLDatabaseUtil.executeQuery("SELECT newsID,title FROM news WHERE newsID = '" + request.getParameter("i") + "';");
    rs.next();
    long millis = System.currentTimeMillis();
    %>
    <input type="hidden" name="<%=newsBoxItemPrefix%>refTable<%=millis%>" value="news">
    <input type="hidden" name="<%=newsBoxItemPrefix%>refName<%=millis%>" value="newsID">
    <input type="hidden" name="<%=newsBoxItemPrefix%>refValue<%=millis%>" value="<%=request.getParameter("i")%>">
    <%=rs.getString("title")%>
    <%
} catch (Exception e) {
    %>Not found<%
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}
%>