<%-- 
    Document   : userPopupSearch
    Created on : Sep 9, 2008, 4:51:36 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*,java.sql.*,org.proteomecommons.mysql.*,org.proteomecommons.www.user.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

String s = "";
if (request.getParameter("s") != null) {
    s = request.getParameter("s");
}
String id = "";
if (request.getParameter("id") != null) {
    id = request.getParameter("id");
}
String p = "";
if (request.getParameter("p") != null) {
    p = request.getParameter("p");
}
String prefix = "";
if (request.getParameter("prefix") != null) {
    prefix = request.getParameter("prefix");
}

List <User> users = UserUtil.getUsers(s, "unique_name", "ASC", 1, 25, true);
for (User u : users) {
    %>
    <div class="popupOption" onclick="setUser('<%=p%>', '<%=id%>', '<%=u.userID%>', '<%=prefix%>');" onmouseover="popupOptionOver(this);" onmouseout="popupOptionOut(this);">
        <table cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td valign="top">
            <strong><%=u.unique_name%></strong>
        </td><td align="right" valign="top">
            <%=u.region.regionCode%>, <%=u.country.country%>
        </td></tr></table>
    </div>
    <%
}
%>