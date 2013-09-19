<%-- 
    Document   : linkBoxItem
    Created on : Sep 10, 2008, 5:41:02 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

ResultSet rs = null;
try {
    String linkBoxItemPrefix = "";
    if (request.getParameter("prefix") != null) {
        linkBoxItemPrefix = request.getParameter("prefix");
    }
    
    rs = MySQLDatabaseUtil.executeQuery("SELECT linkID,title FROM link WHERE linkID = '" + request.getParameter("i") + "';");
    rs.next();
    long millis = System.currentTimeMillis();
    %>
    <input type="hidden" name="<%=linkBoxItemPrefix%>refTable<%=millis%>" value="link">
    <input type="hidden" name="<%=linkBoxItemPrefix%>refName<%=millis%>" value="linkID">
    <input type="hidden" name="<%=linkBoxItemPrefix%>refValue<%=millis%>" value="<%=request.getParameter("i")%>">
    <%=rs.getString("title")%>
    <%
} catch (Exception e) {
    %>Not found<%
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}
%>