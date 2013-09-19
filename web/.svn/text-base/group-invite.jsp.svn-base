<%-- 
    Document   : group-invite
    Created on : Oct 3, 2008, 3:31:15 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.mysql.*, java.sql.*, java.util.*, org.tranche.util.*, org.proteomecommons.www.user.*, org.proteomecommons.www.group.*, org.proteomecommons.www.notification.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("groupPageTitle", "Invite");
request.setAttribute("pageUsersOnly", "true");

%><%@include file="group-header.jsp"%><%

if (group != null) {
    try {
        // person must be a member
        if (!group.isMember(user.userID)) {
            throw new Exception("You are not a member of <a href=\"group.jsp?i="+group.groupID+"\">"+group.name+"</a>.");
        }
        // person must be able to invite users
        if (!group.getMember(user.userID).canInviteUser()) {
            throw new Exception("You are not allowed to invite users to <a href=\"group.jsp?i="+group.groupID+"\">"+group.name+"</a>.");
        }
        // execute the invite
        if (request.getParameter("action") != null) {
            // add references
            List <Integer> alreadyMembers = new LinkedList <Integer> ();
            List <Integer> alreadyInvited = new LinkedList <Integer> ();
            List <Integer> couldNotInvite = new LinkedList <Integer> ();
            List <Integer> invited = new LinkedList <Integer> ();
            for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
                String parameterName = (String)e.nextElement();
                if (parameterName.startsWith("refName")) {
                    String millis = parameterName.substring(7);
                    String fieldID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("refValue"+millis));
                    int userID = Integer.valueOf(fieldID);
                    if (group.isMember(userID)) {
                        alreadyMembers.add(userID);
                    } else {
                        int rows = 0;
                        ResultSet rs = null;
                        try {
                            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(groupID) AS rows FROM group_join WHERE groupID = '"+group.groupID+"' AND userID = '"+userID+"' LIMIT 1;");
                            rs.next();
                            rows = rs.getInt("rows");
                        } finally {
                            MySQLDatabaseUtil.safeClose(rs);
                        }
                        
                        if (rows > 0) {
                            alreadyInvited.add(userID);
                        } else if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO group_join (groupID, userID, requestUserID, date) VALUES ('"+group.groupID+"', '"+userID+"', '"+user.userID+"', '"+MySQLDatabaseUtil.getTimestamp()+"');")) {
                            couldNotInvite.add(userID);
                        } else {
                            invited.add(userID);
                        }
                    }
                }
            }
            if (!alreadyMembers.isEmpty()) {
                %><div><b><%=alreadyMembers.size()%></b> people are already members.</div><%
            }
            if (!alreadyInvited.isEmpty()) {
                %><div><b><%=alreadyInvited.size()%></b> people were already invited.</div><%
            }
            if (!couldNotInvite.isEmpty()) {
                %><div><b><%=couldNotInvite.size()%></b> people could not be invited.</div><%
            }
            if (!invited.isEmpty()) {
                group.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> invited " + invited.size() + " people to join.");
                %><div><b><%=invited.size()%></b> people were invited.</div><%
            }
        } else {
            %>
            <form action="group-invite.jsp" method="post">
                <input type="hidden" name="action" value="invite"/>
                <input type="hidden" name="i" value="<%=group.groupID%>"/>
                <div class="table">
                    <div class="table-row">
                        <div class="table-cell"><%@include file="scripts/references/add/addUserReferences.jsp"%></div>
                    </div><div class="table-row">
                        <div class="table-cell"><input type="submit" value="Send Invitations"></div>
                    </div>
                </div>
            </form>
            <%
        }
    } catch (Exception e) {
        %>Error: <%=e.getMessage()%><%
    }
}

%><%@include file="group-footer.jsp"%>