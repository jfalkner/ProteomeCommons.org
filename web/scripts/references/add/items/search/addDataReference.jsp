<%-- 
    Document   : addDataReference
    Created on : Sep 9, 2008, 1:33:11 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

String prefix = "";
if (request.getParameter("prefix") != null) {
    prefix = request.getParameter("prefix");
}

String id = "data"+System.currentTimeMillis();
String bodyId = "body" + id;
String searchBoxId = "search" + id;
String popupId = "popup" + id;
%>
<div id="<%=id%>" class="boxItem">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr><td width="50">
    Data
</td><td>
    <div id="<%=bodyId%>">
        <% if (request.getParameter("i") == null) { %>
            <div><input type="text" class="searchBox" id="<%=searchBoxId%>" onkeyup="if (getObj('<%=searchBoxId%>').value != '') { dataSuggestion('<%=bodyId%>', '<%=searchBoxId%>', '<%=popupId%>', '<%=prefix%>'); } else { hide('<%=popupId%>'); }"></div>
            <div><span style="cursor: pointer;" onclick="dataAdvancedSearchFromPopup('<%=popupId%>', '<%=bodyId%>', '<%=prefix%>');">Advanced Search</span></div>
        <% } else { %>
            <%@include file="../selected/dataBoxItem.jsp"%>
        <% } %>
    </div>
</td><td width="50">
    <div style="cursor: pointer;" onclick="hide('<%=id%>'); getObj('<%=id%>').innerHTML = '';">Remove</div>
</td></tr>
</table>
<% if (request.getParameter("i") == null) { %>
    <div id="<%=popupId%>" class="frame" style="overflow: auto; height: 200px;"></div>
<% } %>
</div>