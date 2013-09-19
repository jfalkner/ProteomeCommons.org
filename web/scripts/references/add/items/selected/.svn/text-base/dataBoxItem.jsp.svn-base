<%-- 
    Document   : dataBoxItem
    Created on : Sep 11, 2008, 3:17:45 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

ResultSet rs = null;
try {
    String dataBoxItemPrefix = "";
    if (request.getParameter("prefix") != null) {
        dataBoxItemPrefix = request.getParameter("prefix");
    }
    
    rs = MySQLDatabaseUtil.executeQuery("SELECT dataID,title,hash FROM data WHERE dataID = '" + request.getParameter("i") + "';");
    rs.next();
    long millis = System.currentTimeMillis();
    %>
    <input type="hidden" name="<%=dataBoxItemPrefix%>refTable<%=millis%>" value="data">
    <input type="hidden" name="<%=dataBoxItemPrefix%>refName<%=millis%>" value="dataID">
    <input type="hidden" name="<%=dataBoxItemPrefix%>refValue<%=millis%>" value="<%=request.getParameter("i")%>">
    <div><%=rs.getString("title")%></div>
    <div><%=rs.getString("hash")%></div>
    <%
} catch (Exception e) {
    %>Not found<%
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}
%>