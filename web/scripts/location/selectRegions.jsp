<%-- 
    Document   : selectRegions
    Created on : Sep 7, 2008, 4:23:11 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*,org.proteomecommons.www.*, org.proteomecommons.www.region.*, org.proteomecommons.www.country.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

List <Region> regions = new ArrayList<Region>();
int selectCountryID = -1;
if (request.getParameter("c") != null) {
    // get the desired country ID
    try {
        selectCountryID = Integer.valueOf(request.getParameter("c"));
    } catch (Exception e) {}
} else if (request.getAttribute("countryID") != null) {
    try {
        selectCountryID = Integer.valueOf(request.getAttribute("countryID").toString());
    } catch (Exception e) {}
}else {
    try {
        selectCountryID = CountryUtil.getCountry(Util.getCountry(request.getRemoteAddr())).countryID;
    } catch (Exception e) {
        selectCountryID = CountryUtil.getCountries().get(0).countryID;
    }
}
regions = RegionUtil.getRegionsInCountry(selectCountryID);

if (regions.isEmpty()) {
    %><option value="-1"></option><%
} else {
    String userRegionLocation = Util.getRegion(request.getRemoteAddr());
    if (request.getAttribute("regionID") != null) {
        try {
            userRegionLocation = RegionUtil.getRegion(Integer.valueOf(request.getAttribute("regionID").toString())).regionCode;
        } catch (Exception e) {
        }
    }
    %><option value=""></option><%
    for (Region r : regions) {
        try {
            %><option value="<%=r.regionID%>"<% 
            if (userRegionLocation.equals(r.regionCode)) {
                %> selected<%
            }
            %>><%=r.region%></option><%
        } catch (Exception e) {
        }
    }
}
%>