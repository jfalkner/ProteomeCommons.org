<%-- 
    Document   : groupBoxItem
    Created on : Sep 10, 2008, 5:41:32 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

ResultSet rs = null;
try {
    String groupBoxItemPrefix = "";
    if (request.getParameter("prefix") != null) {
        groupBoxItemPrefix = request.getParameter("prefix");
    }
    
    rs = MySQLDatabaseUtil.executeQuery("SELECT groupID,name FROM groups WHERE groupID = '" + request.getParameter("i") + "';");
    rs.next();
    long millis = System.currentTimeMillis();
    %>
    <input type="hidden" name="<%=groupBoxItemPrefix%>refTable<%=millis%>" value="groups">
    <input type="hidden" name="<%=groupBoxItemPrefix%>refName<%=millis%>" value="groupID">
    <input type="hidden" name="<%=groupBoxItemPrefix%>refValue<%=millis%>" value="<%=request.getParameter("i")%>">
    <%=rs.getString("name")%>
    <%
} catch (Exception e) {
    %>Not found<%
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}
%>