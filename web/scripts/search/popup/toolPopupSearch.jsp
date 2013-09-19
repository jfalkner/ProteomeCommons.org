<%-- 
    Document   : toolPopupSearch
    Created on : Sep 10, 2008, 5:49:07 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*,org.proteomecommons.www.tool.*"%><%

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

List <Tool> list = ToolUtil.getTools(s, "name", "ASC", 1, 25, true);
for (Tool tool : list) {
    %>
    <div class="popupOption" onclick="setTool('<%=p%>', '<%=id%>', '<%=tool.toolID%>', '<%=prefix%>');" onmouseover="popupOptionOver(this);" onmouseout="popupOptionOut(this);">
        <table cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td valign="top">
            <strong><%=tool.name%></strong>
        </td></tr></table>
    </div>
    <%
}
%>