<%-- 
    Document   : toolAdvancedSearchFromPopup
    Created on : Sep 10, 2008, 5:36:03 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

String id = request.getParameter("id");
%>
<form id="<%=id%>Form" onsubmit="ajax.submit('@baseURLscripts/search/advanced/results/tool.jsp', '<%=id%>', getObj('<%=id%>Form')); return false;">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="searchType" value="search">
<div id="<%=id%>">
    <%@include file="toolAdvancedSearchForm.jsp"%>
</div>
</form>