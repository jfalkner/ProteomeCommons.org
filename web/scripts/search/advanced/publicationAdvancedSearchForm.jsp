<%-- 
    Document   : publicationAdvancedSearchForm
    Created on : Sep 22, 2008, 3:50:55 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%>
<div class="table">
    <div class="table-row">
        <div class="table-cell">Title</div>
        <div class="table-cell"><input type="text" name="title"></div>
    </div><div class="table-row">
        <div class="table-cell">Description</div>
        <div class="table-cell"><input type="text" name="description"></div>
    </div><div class="table-row">
        <div class="table-cell">Citation</div>
        <div class="table-cell"><input type="text" name="citation"></div>
    </div><div class="table-row">
        <div class="table-cell">URL</div>
        <div class="table-cell"><input type="text" name="url"></div>
    </div>
    <div class="table-row"><div class="table-cell"><input type="submit" value="Search"></div></div>
</div>