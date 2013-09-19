<%-- 
    Document   : signup
    Created on : Aug 20, 2008, 6:49:28 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*,org.tranche.util.*"%><%
request.setAttribute("pageTitle", "Sign Up");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

boolean show = true;

String unique_name = "";
String email = "";
String vemail = "";
String prefix = "";
String first_name = "";
String middle_name = "";
String last_name = "";
String suffix = "";
String phone = "";
String organization = "";
String department = "";
String countryID = "";
String regionID = "";
boolean updates = false;
boolean legal = false;

if (request.getParameter("unique_name") != null) {
    ResultSet rs = null;
    try {
        unique_name = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("unique_name"));
        email = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("email"));
        vemail = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("vemail"));
        String pass = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("pass"));
        String vpass = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("vpass"));
        prefix = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("prefix"));
        first_name = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("first_name"));
        middle_name = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("middle_name"));
        last_name = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("last_name"));
        suffix = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("suffix"));
        phone = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("phone"));
        organization = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("organization"));
        department = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("department"));
        countryID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("countryID"));
        request.setAttribute("countryID", countryID);
        regionID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("regionID"));
        request.setAttribute("regionID", regionID);
        updates = request.getParameter("updates") != null && request.getParameter("updates").equals("1");
        String updatesStr = "0";
        if (updates) {
            updatesStr = "1";
        }
        legal = request.getParameter("legal") != null && request.getParameter("legal").equals("1");
        
        // check display name
        if (unique_name.equals("")) {
            throw new Exception("Unique name cannot be blank.");
        }
        
        // check email
        if (email.equals("")) {
            throw new Exception("Email cannot be blank.");
        }
        
        // check vemail
        if (vemail.equals("")) {
            throw new Exception("Verify Email cannot be blank.");
        }
        
        // check emails
        if (!email.equals(vemail)) {
            throw new Exception("Email and Verify Email fields are not the same.");
        }
        
        // check pass
        if (pass.equals("")) {
            throw new Exception("Password cannot be blank.");
        }
        
        // check vpass
        if (vpass.equals("")) {
            throw new Exception("Verify Password cannot be blank.");
        }
        
        // check passwords
        if (!pass.equals(vpass)) {
            throw new Exception("Password and Verify Password fields are not the same.");
        }
        
        // check first name
        if (first_name.equals("")) {
            throw new Exception("First name cannot be blank.");
        }
        
        // check last name
        if (last_name.equals("")) {
            throw new Exception("Last name cannot be blank.");
        }
        
        // check countryID
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
        
        // make sure they agreed to the legal terms
        if (!legal) {
            throw new Exception("You must agree to the terms of service.");
        }
        
        // email address and unique name must be unique
        ResultSet rs2 = null;
        try {
            rs2 = MySQLDatabaseUtil.executeQuery("SELECT unique_name,email FROM user WHERE unique_name = '"+unique_name+"' OR email = '"+email+"' LIMIT 1;");
            if (rs2.next()) {
                if (rs2.getString("email").equals(email)) {
                    throw new Exception("Email is already in use by a registered user.");
                } else if (rs2.getString("unique_name").equals(unique_name)) {
                    throw new Exception("Unique Name is already in use by a registered user.");
                }
            }
        } finally {
          MySQLDatabaseUtil.safeClose(rs2);  
        }
        
        if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO user (unique_name, email, pass, prefix, first_name, middle_name, last_name, suffix, phone, organization, department, countryID, regionID, date_created, date_signed_in, email_update, active) VALUES ('"+unique_name+"', '"+email+"', SHA1('"+pass+"'), '"+prefix+"', '"+first_name+"', '"+middle_name+"', '"+last_name+"', '"+suffix+"', '"+phone+"', '"+organization+"', '"+department+"', '"+countryID+"', '"+regionID+"', '"+MySQLDatabaseUtil.getTimestamp()+"', '', '"+updatesStr+"', '1');")) {
            throw new Exception("Could not add record to database.");
        }
        
        show = false;
        
        // notify the user with an email
        //EmailUtil.sendEmail("ProteomeCommons.org: Your Account", new String[]{email}, "Dear new ProteomeCommons.org user,"+Text.getNewLine()+Text.getNewLine()+"You have successfully signed up to be a member of the ProteomeCommons.org Science Community. Keep this email for your records."+Text.getNewLine()+Text.getNewLine()+"Your password: " + pass);
        %>
        <p>You have signed up. You can now <a href="signin.jsp">sign in</a> and start using ProteomeCommons.org.</p>
        <script language="javascript">goTo('signin.jsp');</script>
        <%
    } catch (Exception e) {
        %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(e.getMessage())%><%
    } finally {
        MySQLDatabaseUtil.safeClose(rs);
    }
}

if (show) {
    %>
    <div style="font-weight: bold;">Items with an asterisk (*) are required.</div>
    <form action="signup.jsp" method="post">
        <div class="table">
            <div class="table-row">
                <div class="table-cell"><b>*</b>Unique Name</div>
                <div class="table-cell">
                    <input type="text" name="unique_name" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(unique_name)%>" maxlength="50">
                </div>
                <div class="table-cell">
                    <div><b>Cannot be changed.</b></div>
                    <div>This is the name that will be used to refer to you in most places in this web site. Also, it will be the name that is associated with your data uploads.</div>
                    <div>A good choice for a unique name might be the first letter of your first name plus your last name. Examples: <i>ahill</i> or <i>bsmith</i>.</div>
                    <div>Maximum length: 50 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell"><b>*</b>Email</div>
                <div class="table-cell"><input type="text" name="email" maxlength="100" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(email)%>"></div>
                <div class="table-cell">
                    <div>Must be a valid email.</div>
                    <div>Maximum length: 100 characters</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell"><b>*</b>Verify Email</div>
                <div class="table-cell"><input type="text" name="vemail" maxlength="100" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(vemail)%>"></div>
                <div class="table-cell">
                    <div>Must be the same as <b>Email</b></div>
                    <div>Maximum length: 100 characters</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell"><b>*</b>Password</div>
                <div class="table-cell"><input type="password" name="pass"></div>
                <div class="table-cell">
                    <div>We recommend choosing a password with a combination of uppercase characters, lowercase characters, and numbers.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell"><b>*</b>Verify Password</div>
                <div class="table-cell"><input type="password" name="vpass"></div>
                <div class="table-cell">
                    <div>Must be the same as <b>Password</b></div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">Prefix</div>
                <div class="table-cell">
                    <select name="prefix">
                        <option value=""></option>
                        <option value="Dr."<% if (MySQLDatabaseUtil.formatTextFromDatabase(prefix).equals("Dr.")) { %> selected<% } %>>Dr.</option>
                        <option value="Mr."<% if (MySQLDatabaseUtil.formatTextFromDatabase(prefix).equals("Mr.")) { %> selected<% } %>>Mr.</option>
                        <option value="Ms."<% if (MySQLDatabaseUtil.formatTextFromDatabase(prefix).equals("Ms.")) { %> selected<% } %>>Ms.</option>
                        <option value="Mrs."<% if (MySQLDatabaseUtil.formatTextFromDatabase(prefix).equals("Mrs.")) { %> selected<% } %>>Mrs.</option>
                    </select>
                </div>
                <div class="table-cell"></div>
            </div><div class="table-row">
                <div class="table-cell"><b>*</b>First Name</div>
                <div class="table-cell"><input type="text" name="first_name" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(first_name)%>" maxlength="100"></div>
                <div class="table-cell">
                    <div>Maximum length: 100 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">Middle Name(s)</div>
                <div class="table-cell"><input type="text" name="middle_name" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(middle_name)%>" maxlength="100"></div>
                <div class="table-cell">
                    <div>Maximum length: 100 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell"><b>*</b>Last Name</div>
                <div class="table-cell"><input type="text" name="last_name" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(last_name)%>" maxlength="100"></div>
                <div class="table-cell">
                    <div>Maximum length: 100 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">Suffix</div>
                <div class="table-cell">
                    <select name="suffix">
                        <option value=""></option>
                        <option value="Sr."<% if (MySQLDatabaseUtil.formatTextFromDatabase(suffix).equals("Sr.")) { %> selected<% } %>>Sr.</option>
                        <option value="Jr."<% if (MySQLDatabaseUtil.formatTextFromDatabase(suffix).equals("Jr.")) { %> selected<% } %>>Jr.</option>
                        <option value="II"<% if (MySQLDatabaseUtil.formatTextFromDatabase(suffix).equals("II")) { %> selected<% } %>>II</option>
                        <option value="III"<% if (MySQLDatabaseUtil.formatTextFromDatabase(suffix).equals("III")) { %> selected<% } %>>III</option>
                        <option value="IV"<% if (MySQLDatabaseUtil.formatTextFromDatabase(suffix).equals("IV")) { %> selected<% } %>>IV</option>
                        <option value="V"<% if (MySQLDatabaseUtil.formatTextFromDatabase(suffix).equals("V")) { %> selected<% } %>>V</option>
                    </select>
                </div>
                <div class="table-cell"></div>
            </div><div class="table-row">
                <div class="table-cell">Phone Number</div>
                <div class="table-cell"><input type="text" name="phone" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(phone)%>" maxlength="20"></div>
                <div class="table-cell">
                    <div>Maximum length: 20 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell"><b>*</b>Country</div>
                <div class="table-cell">
                    <select name="countryID" id="country" onchange="changeRegionSet('country', 'region');">
                        <%@include file="scripts/location/selectCountries.jsp"%>
                    </select>
                </div>
                <div class="table-cell"></div>
            </div><div class="table-row">
                <div class="table-cell">Region/State/Province</div>
                <div class="table-cell">
                    <select name="regionID" id="region">
                        <%@include file="scripts/location/selectRegions.jsp"%>
                    </select>
                </div>
                <div class="table-cell"></div>
            </div><div class="table-row">
                <div class="table-cell"><b>*</b>Organization/Institution</div>
                <div class="table-cell"><input type="text" name="organization" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(organization)%>" maxlength="200"></div>
                <div class="table-cell">
                    <div>Maximum length: 200 characters.</div>
                    <div>No abbreviations.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell"><b>*</b>Department</div>
                <div class="table-cell"><input type="text" name="department" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(department)%>" maxlength="200"></div>
                <div class="table-cell">
                    <div>Maximum length: 200 characters.</div>
                    <div>No abbreviations.</div>
                </div>
            </div>
            <div class="table-row">
                <div class="table-cell">Updates</div>
                <div class="table-cell">
                    <div><input type="checkbox" name="updates" value="1"<% if (updates) { %> checked<% } %>/> I would like to occasionally receive critical information via email.</div>
                </div>
                <div class="table-cell"></div>
            </div>
            <div class="table-row">
                <div class="table-cell"><b>*</b>Terms of Use</div>
                <div class="table-cell">
                    <div><input type="checkbox" name="legal" value="1"<% if (legal) { %> checked<% } %>/> I agree to the terms of service:</div>
                    <div style="font-family: monospaced; font-size: 8pt; height: 200px; overflow: auto; padding: 10px; border: 1px solid #333;">These are the terms of service.</div>
                </div>
                <div class="table-cell"></div>
            </div>
            <div class="table-row">
                <div class="table-cell">
                    <input type="button" value="Cancel" onclick="goTo('index.jsp');"><input type="submit" value="Sign Up">
                </div>
            </div>
        </div>
    </form>
    <% 
} 
%>
<%@include file="footer.jsp"%>