<%-- 
    Document   : selectCountries
    Created on : Sep 7, 2008, 9:58:04 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.www.country.*, java.util.*,java.sql.*,org.proteomecommons.mysql.*,org.proteomecommons.www.*,org.proteomecommons.www.country.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

List<Country> countries = CountryUtil.getCountries();
if (countries.isEmpty()) {
    %><option value="-1"></option><%
} else {
    String userCountry = Util.getCountry(request.getRemoteAddr());
    if (request.getAttribute("countryID") != null) {
        try {
            userCountry = CountryUtil.getCountry(Integer.valueOf(request.getAttribute("countryID").toString())).country;
        } catch (Exception e) {
        }
    }
    %><option value=""></option><%
    for (Country c : countries) {
        try {
            %><option value="<%=c.countryID%>"<%
            if (userCountry.equals(c.country)) {
                %> selected<%
            }
            %>><%=c.country%></option><%
        } catch (Exception e) {
        }
    }
}
%>