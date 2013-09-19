<%-- 
    Document   : userSelectRegions
    Created on : Sep 7, 2008, 3:25:08 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,java.util.*,org.proteomecommons.www.country.*,org.proteomecommons.www.user.*,org.proteomecommons.www.region.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

List <Region> regions = RegionUtil.getRegionsInCountry(user.country.countryID);
if (regions.isEmpty()) {
    %><option value="-1"></option><%
} else {
    for (Region r : regions) {
        %><option value="<%=r.regionID%>"<%
        if (user.region.regionID == r.regionID) {
            %> selected<%
        }
        %>><%=r.region%></option><%
    }
}
%>