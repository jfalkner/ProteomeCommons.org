<%-- 
    Document   : getSubgroups
    Created on : Oct 2, 2008, 12:09:37 AM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, java.sql.*, org.proteomecommons.mysql.*, org.proteomecommons.www.group.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

int i = Integer.valueOf(request.getParameter("i"));
List <Group> groups = GroupUtil.getGroup(i).getSubGroups();
for (Group g : groups) {
%><div id="group<%=i%>subgroup<%=g.groupID%>" style="padding-left: 10px;"><span id="plusGroup<%=i%>subgroup<%=g.groupID%>"><a href="javascript:plus('<%=g.groupID%>', 'group<%=i%>subgroup<%=g.groupID%>', 'plusGroup<%=i%>subgroup<%=g.groupID%>');">+</a></span> <a href="group.jsp?i=<%=g.groupID%>"><%=g.name%></a></div><%
}
%>