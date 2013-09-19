<%-- 
    Document   : registerPageView
    Created on : Sep 8, 2008, 12:28:04 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

try {
    // register this page view
    MySQLDatabaseUtil.executeUpdate("INSERT INTO page_view (ip, date, time, page, query) VALUES ('"+request.getParameter("i")+"', '"+MySQLDatabaseUtil.getTimestamp()+"', '"+System.currentTimeMillis()+"', '"+request.getParameter("p")+"', '"+request.getParameter("q")+"');");
} catch (Exception e) {
    e.printStackTrace();
}
%>