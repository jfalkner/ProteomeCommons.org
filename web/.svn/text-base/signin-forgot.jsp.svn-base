<%-- 
    Document   : signin-forgot
    Created on : Sep 5, 2008, 8:42:44 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.Random,java.sql.*,org.proteomecommons.mysql.*,org.tranche.util.*"%><%
request.setAttribute("pageTitle", "Sign In - Forgot Password");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

    boolean show = true;
    String error = null;
    if (request.getParameter("email") != null) {
        ResultSet rs = null;
        try {
            String email = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("email"));

            rs = MySQLDatabaseUtil.executeQuery("SELECT userID FROM user WHERE email = '" + email + "';");
            if (!rs.next()) {
                throw new Exception("Matching email address could not be found.");
            }
            String userID = rs.getString("userID");

            // reset the password
            String newPassword = "";
            char[] chars = new char[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
            Random random = new Random();
            for (int i = 0; i < 10; i++) {
                newPassword = newPassword + chars[random.nextInt(chars.length)];
            }
            if (!MySQLDatabaseUtil.executeUpdate("UPDATE user SET pass = SHA1('" + newPassword + "') WHERE userID = '" + userID + "';")) {
                throw new Exception("Could not reset password.");
            }

            // notify the user with an email
            EmailUtil.sendEmail("ProteomeCommons.org: Your New Password", new String[]{email}, "Dear ProteomeCommons.org user,"+Text.getNewLine()+Text.getNewLine()+"You have requested that your password be reset and emailed to you."+Text.getNewLine()+Text.getNewLine()+"Your new password: " + newPassword + Text.getNewLine() + Text.getNewLine() + "If you did not request that your password be reset and emailed to you, please contact the ProteomeCommons.org administration team.");

            // success
            %><p>Your new password has been emailed to you.</p><%
            show = false;
        } catch (Exception e) {
            error = e.getMessage();
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }    
    }
if (error != null) {%>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% }%>
<% if (show) {%>
    <p>By submitting this form, your password will be reset and sent to your email address.</p>
    <form action="signin-forgot.jsp" method="post">
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Email</div>
                <div class="table-cell"><input type="text" name="email" size="20" maxlength="100"></div>
            </div><div class="table-row">
                <div class="table-cell">
                    <input type="button" value="Cancel" onclick="goTo('signin.jsp');">
                    <input type="submit" value="Submit">
                </div>
            </div>
        </div>
    </form>
<% }%>
<%@include file="footer.jsp"%>