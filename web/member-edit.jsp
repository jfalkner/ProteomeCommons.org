<%-- 
    Document   : member-edit
    Created on : Sep 7, 2008, 3:04:23 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*,org.tranche.util.*"%><%
request.setAttribute("pageTitle", "My Account");
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%><%@include file="header.jsp"%><%

// was the form submitted?
String error = null;
if (request.getParameter("prefix") != null) {
    
    try {
        String prefix = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("prefix"));
        String first_name = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("first_name"));
        String middle_name = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("middle_name"));
        String last_name= MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("last_name"));
        String suffix = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("suffix"));
        String phone = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("phone"));
        String organization = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("organization"));
        String department = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("department"));
        String countryID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("countryID"));
        String regionID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("regionID"));
        
        if (first_name.equals("")) {
            throw new Exception("First name cannot be blank.");
        }
        
        if (last_name.equals("")) {
            throw new Exception("Last name cannot be blank.");
        }
        
        if (countryID.equals("")) {
            throw new Exception("Country cannot be blank.");
        }
        
        // check organization
        if (organization.equals("")) {
            throw new Exception("Organization cannot be blank.");
        }
        
        // check department
        if (department.equals("")) {
            throw new Exception("Department cannot be blank.");
        }
        
        if (!MySQLDatabaseUtil.executeUpdate("UPDATE user SET prefix = '"+prefix+"', first_name = '"+first_name+"', middle_name = '"+middle_name+"', last_name = '"+last_name+"', suffix = '"+suffix+"', phone = '"+phone+"', organization = '"+organization+"', department = '"+department+"', countryID = '"+countryID+"', regionID = '"+regionID+"' WHERE userID = '"+user.userID+"';")) {
            throw new Exception("Could not update record.");
        }
        // force a cache updater for this user
        UserUtil.userChanged(user.userID);
        user = UserUtil.getUser(user.userID);
        
        response.sendRedirect("member-home.jsp");
    } catch (Exception e) {
        error = e.getMessage();
    }
}

if (error != null) { %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% } %>
<form action="member-edit.jsp" method="post">
    <div class="table">
        <div class="table-row">
            <div class="table-cell">Unique Name</div>
            <div class="table-cell"><b><%=user.unique_name%></b></div>
            <div class="table-cell">
                <div><b>Cannot be changed.</b></div>
            </div>
        </div>
        <div class="table-row">
            <div class="table-cell">Prefix</div>
            <div class="table-cell">
                <select name="prefix">
                    <option value=""></option>
                    <option value="Dr."<% if (user.prefix.equals("Dr.")) { %> selected<% } %>>Dr.</option>
                    <option value="Mr."<% if (user.prefix.equals("Mr.")) { %> selected<% } %>>Mr.</option>
                    <option value="Ms."<% if (user.prefix.equals("Ms.")) { %> selected<% } %>>Ms.</option>
                    <option value="Mrs."<% if (user.prefix.equals("Mrs.")) { %> selected<% } %>>Mrs.</option>
                </select>
            </div>
            <div class="table-cell">
                <div>Optional.</div>
            </div>
        </div>
        <div class="table-row">
            <div class="table-cell">First Name</div>
            <div class="table-cell"><input type="text" name="first_name" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(user.first_name)%>" maxlength="100"></div>
            <div class="table-cell">
                <div>Maximum length: 100 characters.</div>
            </div>
        </div>
        <div class="table-row">
            <div class="table-cell">Middle Name(s)</div>
            <div class="table-cell"><input type="text" name="middle_name" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(user.middle_name)%>" maxlength="100"></div>
            <div class="table-cell">
                <div>Maximum length: 100 characters.</div>
            </div>
        </div>
        <div class="table-row">
            <div class="table-cell">Last Name</div>
            <div class="table-cell"><input type="text" name="last_name" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(user.last_name)%>" maxlength="100"></div>
            <div class="table-cell">
                <div>Maximum length: 100 characters.</div>
            </div>
        </div>
        <div class="table-row">
            <div class="table-cell">Suffix</div>
            <div class="table-cell">
                <select name="suffix">
                    <option value=""></option>
                    <option value="Sr."<% if (user.suffix.equals("Sr.")) { %> selected<% } %>>Sr.</option>
                    <option value="Jr."<% if (user.suffix.equals("Jr.")) { %> selected<% } %>>Jr.</option>
                    <option value="II"<% if (user.suffix.equals("II")) { %> selected<% } %>>II</option>
                    <option value="III"<% if (user.suffix.equals("III")) { %> selected<% } %>>III</option>
                    <option value="IV"<% if (user.suffix.equals("IV")) { %> selected<% } %>>IV</option>
                    <option value="V"<% if (user.suffix.equals("V")) { %> selected<% } %>>V</option>
                </select>
            </div>
            <div class="table-cell">
                <div>Optional.</div>
            </div>
        </div>
        <div class="table-row">
            <div class="table-cell">Phone Number</div>
            <div class="table-cell"><input type="text" name="phone" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(user.phone)%>" maxlength="20"></div>
            <div class="table-cell">
                <div>Maximum length: 20 characters.</div>
            </div>
        </div>
        <div class="table-row">
            <div class="table-cell">Country</div>
            <div class="table-cell">
                <select name="countryID" id="country" onchange="changeRegionSet('country', 'region');">
                    <%@include file="scripts/location/userSelectCountries.jsp"%>
                </select>
            </div>
            <div class="table-cell"></div>
        </div>
        <div class="table-row">
            <div class="table-cell">Region/State/Province</div>
            <div class="table-cell">
                <select name="regionID" id="region">
                    <%@include file="scripts/location/userSelectRegions.jsp"%>
                </select>
            </div>
            <div class="table-cell"></div>
        </div>
        <div class="table-row">
            <div class="table-cell">Organization</div>
            <div class="table-cell"><input type="text" name="organization" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(user.organization)%>" maxlength="200"></div>
            <div class="table-cell">
                <div>Maximum length: 200 characters.</div>
            </div>
        </div>
        <div class="table-row">
            <div class="table-cell">Department</div>
            <div class="table-cell"><input type="text" name="department" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(user.department)%>" maxlength="200"></div>
            <div class="table-cell">
                <div>Maximum length: 200 characters.</div>
            </div>
        </div>
        <div class="table-row"><div class="table-cell"><input type="button" value="Cancel" onclick="goTo('member-home.jsp');"><input type="submit" value="Make Changes"></div></div>
    </div>
</form>
<%@include file="footer.jsp"%>
