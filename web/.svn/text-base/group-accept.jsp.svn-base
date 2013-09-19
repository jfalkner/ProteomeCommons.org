<%-- 
    Document   : group-accept
    Created on : Oct 26, 2008, 2:44:13 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.mysql.*, java.sql.*, java.util.*, org.tranche.util.*, org.proteomecommons.www.user.*, org.proteomecommons.www.group.*, org.proteomecommons.www.notification.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("pageUsersOnly", "true");
request.setAttribute("groupPageTitle", "Accept Invitation");

%><%@include file="group-header.jsp"%><%

if (group != null && user != null) {
    try {
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(groupID) AS rows FROM group_join WHERE groupID = '"+group.groupID+"' AND userID = '"+user.userID+"' AND requestUserID != '"+user.userID+"';");
            rs.next();
            if (rs.getInt("rows") == 0) {
                throw new Exception("You have not been invited to join this group.");
            }
            
            if (request.getParameter("accept") == null) {
                throw new Exception("Missing accept parameter.");
            }
            
            String accept = request.getParameter("accept").trim().toLowerCase();
            if (accept.equals("true")) {
                if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO group_user (groupID, userID, date_created) VALUES ('"+group.groupID+"', '"+user.userID+"', '"+MySQLDatabaseUtil.getTimestamp()+"');")) {
                    throw new Exception("Could not add user to group.");
                }
                if (!MySQLDatabaseUtil.executeUpdate("DELETE FROM group_join WHERE groupID = '"+group.groupID+"' AND userID = '"+user.userID+"' LIMIT 1;")) {
                    throw new Exception("Could not remove invitation from database.");
                }
                // new member - reload in memory!
                group.clearGroupMembers();
                // new group - reload in memory!
                user.clearGroups();
                group.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> joined.");
                %><script language="javascript">goTo('group.jsp?i=<%=group.groupID%>');</script><%
            } else if (accept.equals("false")) {
                if (!MySQLDatabaseUtil.executeUpdate("DELETE FROM group_join WHERE groupID = '"+group.groupID+"' AND userID = '"+user.userID+"' LIMIT 1;")) {
                    throw new Exception("Could not decline invitation.");
                }
                group.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> declined an invitation to join.");
                %><script language="javascript">goTo('member-home.jsp');</script><%
            } else {
                throw new Exception("Unknown accept parameter.");
            }
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    } catch (Exception e) {
        %>Error: <%=e.getMessage()%><%
    }
}

%><%@include file="group-footer.jsp"%>