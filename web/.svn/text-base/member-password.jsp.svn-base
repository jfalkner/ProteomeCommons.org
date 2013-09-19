<%-- 
    Document   : member-password
    Created on : Sep 7, 2008, 9:24:30 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.tranche.util.*,java.sql.*,org.proteomecommons.mysql.*"%><%
request.setAttribute("pageTitle", "My Account - Edit Password");
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

String error = null;
boolean show = true;
if (request.getParameter("old_pass") != null) {
    ResultSet rs = null, rs2 = null;
    try {
        String old_pass = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("old_pass"));
        String pass = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("pass"));
        String vpass = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("vpass"));
        
        rs = MySQLDatabaseUtil.executeQuery("SELECT email FROM user WHERE userID = '"+user.userID+"' AND pass = SHA1('"+old_pass+"') LIMIT 1;");
        if (!rs.next() || rs.wasNull()) {
            throw new Exception("Could not verify your old password.");
        }
        
        // make sure the user set the same password twice
        if (!pass.equals(vpass)) {
            throw new Exception("Password and Verify Password fields must match.");
        }
        
        // update the database
        if (!MySQLDatabaseUtil.executeUpdate("UPDATE user SET pass = SHA1('"+pass+"') WHERE userID = '"+user.userID+"';")) {
            throw new Exception("Could not update password.");
        }
        
        // get the new password
        rs2 = MySQLDatabaseUtil.executeQuery("SELECT pass FROM user WHERE userID = '"+user.userID+"' LIMIT 1;");
        rs2.next();
        
        // update the user session
        session.setAttribute("pass", rs2.getString("pass"));
        
        // notify the user with an email
        EmailUtil.sendEmail("ProteomeCommons.org: Your New Password", new String[]{rs.getString("email")}, "Dear ProteomeCommons.org user,"+Text.getNewLine()+Text.getNewLine()+"Your password has been changed. Save this emali for your records."+Text.getNewLine()+Text.getNewLine()+"Your new password: " + pass + Text.getNewLine() + Text.getNewLine() + "If you did not request that your password be changed, please contact the ProteomeCommons.org administration team.");
        
        show = false;
        
        %><p>Your password has been changed. You have been sent an email to remind you of this change.</p><%
    } catch (Exception e) {
        error = e.getMessage();
    } finally {
        MySQLDatabaseUtil.safeClose(rs);
        MySQLDatabaseUtil.safeClose(rs2);
    }
}

if (error != null) { 
    %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% 
}

if (show) {
    %>
    <form action="member-password.jsp" method="post">
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Old Password</div>
                <div class="table-cell"><input type="password" name="old_pass"></div>
            </div><div class="table-row">
                <div class="table-cell">New Password</div>
                <div class="table-cell"><input type="password" name="pass"></div>
            </div><div class="table-row">
                <div class="table-cell">Verify New Password</div>
                <div class="table-cell"><input type="password" name="vpass"></div>
            </div><div class="table-row">
                <div class="table-cell">
                    <input type="button" value="Cancel" onclick="goTo('member-home.jsp');">
                    <input type="submit" value="Change Password">
                </div>
            </div>
        </div>
    </form>
<% } %>
<%@include file="footer.jsp"%>