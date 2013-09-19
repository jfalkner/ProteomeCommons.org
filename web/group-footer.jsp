<%-- 
    Document   : group-footer
    Created on : Oct 27, 2008, 7:24:07 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%>
</div></div></div></div><%@include file="footer.jsp"%>