<%-- 
    Document   : group-leave
    Created on : Oct 30, 2008, 12:54:04 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.mysql.*, java.sql.*, java.util.*, org.tranche.util.*, org.proteomecommons.www.user.*, org.proteomecommons.www.group.*, org.proteomecommons.www.notification.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("groupPageTitle", "Leave");
request.setAttribute("pageUsersOnly", "true");

%><%@include file="group-header.jsp"%><%

if (group != null && user != null) {
    try {
        if (!group.isMember(user.userID)) {
            throw new Exception("You are not a member of this group.");
        } else if (request.getParameter("action") != null) {
            if (request.getParameter("action").equals("yes")) {

                // count admins
                int adminCount = 0;
                for (GroupMember gm : group.getGroupMembers()) {
                    if (gm.isStrictlyAdmin()) {
                        adminCount++;
                    }
                }

                // get member and check admin status
                if (group.getMember(user.userID).isStrictlyAdmin() && adminCount == 1) {
                    throw new Exception("You cannot leave the group because you are the only director.");
                }

                if (!MySQLDatabaseUtil.executeUpdate("DELETE FROM group_user WHERE groupID = '"+group.groupID+"' AND userID = '"+user.userID+"';")) {
                    throw new Exception("There was a problem leaving the group.");
                } else {
                    group.removeGroupMember(user.userID);
                    user.removeGroup(group.groupID);
                    group.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> left.");
                    %>You have left the group.<%
                }
            }
        } else {
            %>
            Are you about to leave the group. Do you want to continue? 
            <form action="group-leave.jsp" method="post" id="leaveForm">
                <input type="hidden" name="i" value="<%=group.groupID%>"/>
                <input type="hidden" id="action" name="action" value=""/>
                <input type="button" value="No" onclick="goTo('group.jsp?i=<%=group.groupID%>');">&nbsp;<input type="button" value="Yes" onclick="getObj('action').value = 'yes'; getObj('leaveForm').submit();">
            </form>
            <%
        }
    } catch (Exception e) {
        %>Error: <%=e.getMessage()%><%
    }
} else {
    if (group == null) {
        %><div>Group is null.</div><%
    }
    if (user == null) {
        %><div>User is null.</div><%
    }
}

%><%@include file="group-footer.jsp"%>