<%-- 
    Document   : publicationBoxItem
    Created on : Sep 10, 2008, 5:39:27 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

ResultSet rs = null;
try {
    String publicationBoxItemPrefix = "";
    if (request.getParameter("prefix") != null) {
        publicationBoxItemPrefix = request.getParameter("prefix");
    }
    
    rs = MySQLDatabaseUtil.executeQuery("SELECT publicationID,title FROM publication WHERE publicationID = '" + request.getParameter("i") + "';");
    rs.next();
    long millis = System.currentTimeMillis();
    %>
    <input type="hidden" name="<%=publicationBoxItemPrefix%>refTable<%=millis%>" value="publication">
    <input type="hidden" name="<%=publicationBoxItemPrefix%>refName<%=millis%>" value="publicationID">
    <input type="hidden" name="<%=publicationBoxItemPrefix%>refValue<%=millis%>" value="<%=request.getParameter("i")%>">
    <%=rs.getString("title")%>
    <%
} catch (Exception e) {
    %>Not found<%
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}
%>