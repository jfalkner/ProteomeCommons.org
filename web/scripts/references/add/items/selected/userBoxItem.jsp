<%-- 
    Document   : userBoxItem
    Created on : Sep 9, 2008, 8:49:57 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

ResultSet rs = null;
try {
    String userBoxItemPrefix = "";
    if (request.getParameter("prefix") != null) {
        userBoxItemPrefix = request.getParameter("prefix");
    }
    
    rs = MySQLDatabaseUtil.executeQuery("SELECT userID,unique_name FROM user WHERE userID = '" + request.getParameter("i") + "';");
    rs.next();
    long millis = System.currentTimeMillis();
    %>
    <input type="hidden" name="<%=userBoxItemPrefix%>refTable<%=millis%>" value="user">
    <input type="hidden" name="<%=userBoxItemPrefix%>refName<%=millis%>" value="userID">
    <input type="hidden" name="<%=userBoxItemPrefix%>refValue<%=millis%>" value="<%=request.getParameter("i")%>">
    <%=rs.getString("unique_name")%>
    <%
} catch (Exception e) {
    %>Not found<%
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}
%>