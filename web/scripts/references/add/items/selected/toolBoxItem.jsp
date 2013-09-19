<%-- 
    Document   : toolBoxItem
    Created on : Sep 10, 2008, 5:38:36 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

ResultSet rs = null;
try {
    String toolBoxItemPrefix = "";
    if (request.getParameter("prefix") != null) {
        toolBoxItemPrefix = request.getParameter("prefix");
    }
    
    rs = MySQLDatabaseUtil.executeQuery("SELECT toolID,name FROM tool WHERE toolID = '" + request.getParameter("i") + "';");
    rs.next();
    long millis = System.currentTimeMillis();
    %>
    <input type="hidden" name="<%=toolBoxItemPrefix%>refTable<%=millis%>" value="tool">
    <input type="hidden" name="<%=toolBoxItemPrefix%>refName<%=millis%>" value="toolID">
    <input type="hidden" name="<%=toolBoxItemPrefix%>refValue<%=millis%>" value="<%=request.getParameter("i")%>">
    <%=rs.getString("name")%>
    <%
} catch (Exception e) {
    %>Not found<%
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}
%>