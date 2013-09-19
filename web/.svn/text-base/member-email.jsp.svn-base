<%-- 
    Document   : member-email
    Created on : Sep 30, 2008, 1:46:15 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.tranche.util.*,java.sql.*,org.proteomecommons.mysql.*"%><%
request.setAttribute("pageTitle", "My Account - Edit Email");
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

String error = null;
boolean show = true;
if (request.getParameter("pass") != null) {
    try {
        String pass = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("pass"));
        String email = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("email"));
        String vemail = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("vemail"));
        
        // check the given passphrase
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT email FROM user WHERE userID = '"+user.userID+"' AND pass = SHA1('"+pass+"') LIMIT 1;");
            if (!rs.next() || rs.wasNull()) {
                throw new Exception("Could not verify your password.");
            }
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        
        // make sure the user set the same email twice
        if (!email.equals(vemail)) {
            throw new Exception("Email and Verify Email fields must match.");
        }
                
        // make sure this email is actually different
        if (!user.email.equals(email)) {
            // new email address must be unique
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT userID FROM user WHERE email = '"+email+"' AND userID != '"+user.userID+"' LIMIT 1;");
                if (rs.next()) {
                    throw new Exception("Email is already in use by a registered user.");
                }
            } finally {
              MySQLDatabaseUtil.safeClose(rs);  
            }
            
            // make the change
            if (!MySQLDatabaseUtil.executeUpdate("UPDATE user SET email = '"+email+"' WHERE userID = '"+user.userID+"';")) {
                throw new Exception("Changes could not be made.");
            }
            
            // inform
            EmailUtil.sendEmail("ProteomeCommons.org: Your Account", new String[]{user.email,email}, "Dear new ProteomeCommons.org user,"+Text.getNewLine()+Text.getNewLine()+"This is a notification that your email address has been changed from "+user.email+" to "+email+". If you did not request that your email be changed, please contact the ProteomeCommons.org administration team.");
            // update the cache
            user.email = email;
            UserUtil.userChanged(user.userID);
        } else {
            throw new Exception("Email unchanged.");
        }
 
        show = false;
        
        %><p>Your email has been changed. An email has been sent to both your new and old email addresses to remind you of this change.</p><%
    } catch (Exception e) {
        error = e.getMessage();
    }
}

if (error != null) { 
    %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% 
}

if (show) {
    %>
    <form action="member-email.jsp" method="post">
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Password</div>
                <div class="table-cell"><input type="password" name="pass"></div>
            </div><div class="table-row">
                <div class="table-cell">New Email</div>
                <div class="table-cell"><input type="text" name="email" maxlength="100"></div>
                <div class="table-cell">
                    <div>Must be a valid email.</div>
                    <div>Maximum length: 100 characters</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">Verify New Email</div>
                <div class="table-cell"><input type="text" name="vemail" maxlength="100"></div>
                <div class="table-cell">
                    <div>Must be the same as <b>New Email</b></div>
                    <div>Maximum length: 100 characters</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">
                    <input type="button" value="Cancel" onclick="goTo('member-home.jsp');">
                    <input type="submit" value="Change Email">
                </div>
            </div>
        </div>
    </form>
<% } %>
<%@include file="footer.jsp"%>