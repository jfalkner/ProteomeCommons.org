<%-- 
    Document   : selectCountries
    Created on : Sep 7, 2008, 3:12:43 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*,org.proteomecommons.www.user.*,org.proteomecommons.www.country.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

List<Country> countries = CountryUtil.getCountries();
for (Country c : countries) {
    %><option value="<%=c.countryID%>"<%
    if (user.country.countryID == c.countryID) {
        %> selected<%
    }
    %>><%=c.country%></option><%
}
%>