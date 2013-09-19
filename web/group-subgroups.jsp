<%-- 
    Document   : group-subgroups
    Created on : Oct 27, 2008, 5:26:33 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("pageUsersOnly", "true");
request.setAttribute("groupPageTitle", "Browse Subgroups");

%><%@include file="group-header.jsp"%><%

if (group != null && user != null) {

}

%><%@include file="group-footer.jsp"%>