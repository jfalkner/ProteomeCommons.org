<%-- 
    Document   : publicationPopupSearch
    Created on : Sep 10, 2008, 5:50:22 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*,org.proteomecommons.www.publication.*"%><%

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

List <Publication> list = PublicationUtil.getPublications(s, "title", "ASC", 1, 25, true);
for (Publication publication : list) {
    %>
    <div class="popupOption" onclick="setPublication('<%=p%>', '<%=id%>', '<%=publication.publicationID%>', '<%=prefix%>');" onmouseover="popupOptionOver(this);" onmouseout="popupOptionOut(this);">
        <table cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td valign="top">
            <strong><%=publication.title%></strong>
        </tr></table>
    </div>
    <%
}
%>