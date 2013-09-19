<%-- 
    Document   : groupSearchCount
    Created on : Sep 10, 2008, 5:57:22 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*,org.proteomecommons.www.group.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

ResultSet rs = null;
try {
    if (request.getParameter("s") == null || request.getParameter("s").toString().trim().equals("")) {
        %><%=MySQLDatabaseUtil.getRowCount("groups")%><%
    } else {
        String s = request.getParameter("s");
        int limit = 0;
        try {
            limit = Integer.valueOf(request.getParameter("l"));
        } catch (Exception e) {
        }
        %><%=GroupUtil.getGroupsCount(s, limit, true)%><%
    }
} catch (Exception e) {
    %>0<%
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}
%>