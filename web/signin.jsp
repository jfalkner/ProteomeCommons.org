<%-- 
    Document   : signin
    Created on : Aug 20, 2008, 6:49:14 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%
request.setAttribute("pageTitle", "Sign In");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

// validate the inputs
String error = null;
if (request.getParameter("email") != null) {
    ResultSet rs = null;
    try {
        String email = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("email"));
        String pass = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("pass"));
        rs = MySQLDatabaseUtil.executeQuery("SELECT userID,pass FROM user WHERE email = '"+email+"' AND pass = SHA1('"+pass+"') LIMIT 1;");
        rs.next();
        session.setAttribute("userID", rs.getString("userID"));
        session.setAttribute("pass", rs.getString("pass"));
        // sign in was a success - update the user account, noting the last sign in date
        MySQLDatabaseUtil.executeUpdate("UPDATE user SET active = '1', date_signed_in = '"+MySQLDatabaseUtil.getTimestamp()+"' WHERE userID = '"+session.getAttribute("userID")+"';");
    } catch (Exception e) {
        error = "That email/password combination could not be found.";
    } finally {
        MySQLDatabaseUtil.safeClose(rs);
    }
}

%><%@include file="header.jsp"%>
<% if (error != null) { %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% } %>
<% if (user == null) { %>
    <form action="@baseURLsignin.jsp" method="post">
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Email</div>
                <div class="table-cell"><input type="text" size="20" name="email"></div>
            </div><div class="table-row">
                <div class="table-cell">Password</div>
                <div class="table-cell"><input type="password" size="20" name="pass"></div>
            </div><div class="table-row">
                <div class="table-cell">
                    <a href="@baseURLsignin-forgot.jsp">Forgot Password</a><br/>
                    <a href="@baseURLsignup.jsp">Sign Up</a>
                </div>
                <div class="table-cell" style="text-align: right;">
                    <input type="submit" value="Sign In">
                </div>
            </div>
        </div>
    <% if (request.getParameter("goto") != null) { %>
        <input type="hidden" name="goto" value="<%=request.getParameter("goto")%>">
    <% } if (request.getParameter("gotoq") != null) { %>
        <input type="hidden" name="gotoq" value="<%=request.getParameter("gotoq")%>">
    <% } %>
    </form>
<% } else { 
    String redirectURL = "member-home.jsp";
    if (request.getParameter("goto") != null) {
        redirectURL = request.getParameter("goto");
        if (request.getParameter("gotoq") != null) {
            redirectURL = redirectURL + "?" + request.getParameter("gotoq");
        }
    }
    %>
    <p>You have successfully signed in as <strong><%=user.unique_name%></strong>.</p>
    <p>You are now being redirected. If this redirect does not occur, you can <a href="<%=redirectURL%>">click here</a> instead.</p>
    <script language="javascript">goTo('<%=redirectURL%>');</script>
<% } %>
<%@include file="footer.jsp"%>