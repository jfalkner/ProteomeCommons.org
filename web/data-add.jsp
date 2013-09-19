<%-- 
    Document   : data-add
    Created on : Sep 10, 2008, 10:33:03 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server


ResultSet rs = null;
try {
    /*
    if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO data (hash, userID, encrypted, files, size, date_published, date_uploaded, title, description, active) VALUES ('XwbcF3t+z2OcWbcWSON7wF3kTZY65CrEHVq/KxH9kc6ZN/cnnOdq44/KyZxI66N3lDxczaxylwSU65kyDzlf4am76TAAAAAAAAABRg==', '1', '0', '2', '53338754', '"+MySQLDatabaseUtil.getTimestamp(Long.valueOf("1222801106341"))+"', '"+MySQLDatabaseUtil.getTimestamp(Long.valueOf("1222801106341"))+"', 'Protein Pilot Viewer 2.0', 'Protein Pilot Viewer 2.0', '1');")) {
        throw new Exception("Could not add data to database.");
    }
    */
} catch (Exception e) {
    %>Error: <%=e.getMessage()%><%
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}

%>