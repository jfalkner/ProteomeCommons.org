<%-- 
    Document   : group-manage-subgroups
    Created on : Oct 23, 2008, 6:34:01 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("pageUsersOnly", "true");
request.setAttribute("groupPageTitle", "Manage Subgroups");

%><%@include file="group-header.jsp"%><%

if (group != null && user != null) {

}

%><%@include file="group-footer.jsp"%>