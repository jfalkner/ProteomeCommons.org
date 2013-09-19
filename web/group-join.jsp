<%-- 
    Document   : group-join
    Created on : Oct 3, 2008, 12:51:15 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.mysql.*, java.sql.*, java.util.*, org.tranche.util.*, org.proteomecommons.www.user.*, org.proteomecommons.www.group.*, org.proteomecommons.www.notification.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("groupPageTitle", "Join");
request.setAttribute("pageUsersOnly", "true");

%><%@include file="group-header.jsp"%><%

if (group != null && user != null) {
    if (group.isMember(user.userID)) {
        %>You are already a member of this group.<%
    } else if (group.isNamePrivate()) { 
        %>You cannot request to join this group.<%
    } else {
        if (request.getParameter("action") != null) {
            String action = request.getParameter("action");
            if (action.equals("yes")) {
                if (group.isPrivate()) {
                    if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO group_join (groupID, userID, requestUserID, date) VALUES ('"+group.groupID+"', '"+user.userID+"', '"+user.userID+"', '"+MySQLDatabaseUtil.getTimestamp()+"');")) {
                        %>There was a problem submitting your request to join <a href="group.jsp?i=<%=group.groupID%>"><%=group.name%></a>.<%
                    } else {
                        group.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> requested to join.");
                        %>Your request to join <a href="group.jsp?i=<%=group.groupID%>"><%=group.name%></a> has been submitted.<%
                    }
                } else {
                    if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO group_user (groupID, userID, date_created) VALUES ('"+group.groupID+"', '"+user.userID+"', '"+MySQLDatabaseUtil.getTimestamp()+"');")) {
                        %>There was a problem joining the group <a href="group.jsp?i=<%=group.groupID%>"><%=group.name%></a>.<%
                    } else {
                        group.clearGroupMembers();
                        user.clearGroups();
                        group.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> joined.");
                        %>You are now a member of <a href="group.jsp?i=<%=group.groupID%>"><%=group.name%></a>.<%
                        // remove from group join no matter what
                        MySQLDatabaseUtil.executeUpdate("DELETE FROM group_join WHERE groupID = '"+group.groupID+"' AND userID = '"+user.userID+"';");
                    }
                }
            }
        } else {
            %>
            You are about to <% if (group.isPrivate()) { %>request to <% } %>join the group <a href="group.jsp?i=<%=group.groupID%>"><%=group.name%></a>. Do you want to continue? 
            <form action="group-join.jsp" method="post" id="joinForm">
                <input type="hidden" name="i" value="<%=group.groupID%>"/>
                <input type="hidden" id="action" name="action" value=""/>
                <input type="button" value="No" onclick="goTo('group.jsp?i=<%=group.groupID%>');">&nbsp;<input type="button" value="Yes" onclick="getObj('action').value = 'yes'; getObj('joinForm').submit();">
            </form>
            <%
        }
    }
}

%><%@include file="group-footer.jsp"%>