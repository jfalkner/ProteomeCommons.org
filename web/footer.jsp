<%-- 
    Document   : footer
    Created on : Aug 20, 2008, 6:03:15 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%>
    </div>
    <div id="pageFooter"><a href="@baseURLstatistics.jsp">Statistics</a>&bull;<a href="@baseURLcontact.jsp">Contact Us</a>&bull;<a href="@baseURLabout/faq.jsp">FAQ</a>&bull;<a href="@baseURLabout/index.jsp">About</a></div>
    <div id="pagePopupContainer"><div id="pagePopup"></div></div>
</body>
</html>
<%
    if (request.getAttribute("user") != null) {
        MySQLDatabaseUtil.safeClose((ResultSet)request.getAttribute("user"));
    }
%>