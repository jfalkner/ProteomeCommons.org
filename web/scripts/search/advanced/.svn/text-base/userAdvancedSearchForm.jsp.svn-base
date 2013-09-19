<%-- 
    Document   : userAdvancedSearchFromPopup
    Created on : Sep 10, 2008, 4:03:38 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%>
<div class="table">
    <div class="table-row">
        <div class="table-cell">Unique Name</div>
        <div class="table-cell"><input type="text" name="unique_name"></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Email</div>
        <div class="table-cell"><input type="text" name="email"></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Prefix</div>
        <div class="table-cell">
            <select name="user_prefix">
                <option value=""></option>
                <option value="Dr.">Dr.</option>
                <option value="Mr.">Mr.</option>
                <option value="Ms.">Ms.</option>
                <option value="Mrs.">Mrs.</option>
            </select>
        </div>
    </div>
    <div class="table-row">
        <div class="table-cell">First Name</div>
        <div class="table-cell"><input type="text" name="first_name"></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Middle Name</div>
        <div class="table-cell"><input type="text" name="middle_name"></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Last Name</div>
        <div class="table-cell"><input type="text" name="last_name"></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Suffix</div>
        <div class="table-cell">
            <select name="suffix">
                <option value=""></option>
                <option value="Sr.">Sr.</option>
                <option value="Jr.">Jr.</option>
                <option value="II">II</option>
                <option value="III">III</option>
                <option value="IV">IV</option>
                <option value="V">V</option>
            </select>
        </div>
    </div>
    <div class="table-row">
        <div class="table-cell">Country</div>
        <div class="table-cell">
            <select name="countryID" id="country<%=id%>" onchange="changeRegionSet('country<%=id%>', 'region<%=id%>');">
                <%@include file="../../location/selectCountries.jsp"%>
            </select>
        </div>
    </div><div class="table-row">
        <div class="table-cell">Region/State/Province</div>
        <div class="table-cell">
            <select name="regionID" id="region<%=id%>">
                <%@include file="../../location/selectRegions.jsp"%>
            </select>
        </div>
    </div>
    <div class="table-row">
        <div class="table-cell">Organization</div>
        <div class="table-cell"><input type="text" name="organization"/></div>
    </div>
    <div class="table-row">
        <div class="table-cell">Department</div>
        <div class="table-cell"><input type="text" name="department"/></div>
    </div>
    <div class="table-row"><div class="table-cell"><input type="submit" value="Search"></div></div>
</div>