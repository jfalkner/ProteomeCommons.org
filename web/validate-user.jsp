<%-- 
    Document   : validate-user
    Created on : Oct 22, 2008, 3:27:09 PM
    Author     : James A Hill
--%><%@page import="org.tranche.gui.pools.*, java.sql.*,org.proteomecommons.mysql.*,org.proteomecommons.tranche.*,org.proteomecommons.www.*,org.proteomecommons.www.user.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

// load Tranche configuration
ProteomeCommonsTrancheConfig.load();
ServerPool.lazyLoadServerPool();

// try to check whether a user is signed in
User user = null;
try {
    ResultSet urs = null;
    try {
        String sessionUserID = session.getAttribute("userID").toString();
        // stored in the session as an sha1
        String sessionPass = session.getAttribute("pass").toString();
        // check against the database
        urs = MySQLDatabaseUtil.executeQuery("SELECT userID FROM user WHERE userID = '"+sessionUserID+"' AND pass = '"+sessionPass+"' LIMIT 1;");
        if (urs.next()) {
            user = UserUtil.getUser(urs.getInt("userID"));
        }
        // update title
        request.setAttribute("pageTitle", request.getAttribute("pageTitle").toString().replace("@user:unique_name", user.unique_name));
    } catch (Exception e) {
        session.removeAttribute("userID");
        session.removeAttribute("pass");
    } finally {
        MySQLDatabaseUtil.safeClose(urs);
        if (user != null && !user.isSet()) {
            user = null;
        }
        // in case this wasn't done, remove any special identifiers
        request.setAttribute("pageTitle", request.getAttribute("pageTitle").toString().replace("@user:unique_name", ""));
    }
    
    // redirect?
   if (request.getAttribute("pageRedirectIfUser") != null && user != null) {
       response.sendRedirect((String)request.getAttribute("pageRedirectIfUser"));
   }
} catch (Exception e) {}
%>