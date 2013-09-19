<%-- 
    Document   : join
    Created on : Oct 3, 2008, 1:16:06 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.tranche.util.*, org.proteomecommons.www.user.*, org.proteomecommons.www.group.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

Group group = null;
try {
    group = GroupUtil.getGroup(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (group == null) {
    request.setAttribute("pageTitle", "Group Not Found");
} else {
    request.setAttribute("pageTitle", "Group - " + group.name + " - Join");
}
request.setAttribute("pageUsersOnly", "true");

%><%@include file="header.jsp"%><%

if (group != null) {
    if (group.isMember(user.userID)) {
        %>You are already a member of this group.<%
    } else {
        %>You are about to request to join the group <a href="group.jsp?i=<%=group.groupID%>"><%=group.name%></a>. Do you want to continue?<%
    }
}

%><%@include file="footer.jsp"%>