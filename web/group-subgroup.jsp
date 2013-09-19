<%-- 
    Document   : group-subgroup
    Created on : Oct 23, 2008, 6:27:52 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*, java.util.*, org.proteomecommons.www.group.*, org.proteomecommons.www.user.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("pageUsersOnly", "true");
request.setAttribute("groupPageTitle", "Import Group");

%><%@include file="group-header.jsp"%><%

if (group != null && user != null) {
    try {
        // person must be a member
        if (!group.isMember(user.userID)) {
            throw new Exception("You are not a member of <a href=\"group.jsp?i="+group.groupID+"\">"+group.name+"</a>.");
        }
        // person must be able to invite users
        if (!group.getMember(user.userID).canImportGroup()) {
            throw new Exception("You are not allowed to add subgroups to <a href=\"group.jsp?i="+group.groupID+"\">"+group.name+"</a>.");
        }
        // execute the invite
        if (request.getParameter("action") != null) {
            // add references
            List <Integer> alreadySubgroups = new LinkedList <Integer> ();
            List <Integer> alreadyInvited = new LinkedList <Integer> ();
            List <Integer> couldNotInvite = new LinkedList <Integer> ();
            List <Integer> invited = new LinkedList <Integer> ();
            for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
                String parameterName = (String)e.nextElement();
                if (parameterName.startsWith("refName")) {
                    String millis = parameterName.substring(7);
                    String fieldID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("refValue"+millis));
                    int groupID = Integer.valueOf(fieldID);
                    if (group.isSubGroup(groupID)) {
                        alreadySubgroups.add(groupID);
                    } else if (groupID == group.groupID) {
                        couldNotInvite.add(groupID);
                    } else {
                        int rows = 0;
                        ResultSet rs = null;
                        try {
                            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(groupID) AS rows FROM subgroup_join WHERE groupID = '"+group.groupID+"' AND subgroupID = '"+groupID+"' LIMIT 1;");
                            rs.next();
                            rows = rs.getInt("rows");
                        } finally {
                            MySQLDatabaseUtil.safeClose(rs);
                        }
                        
                        if (rows > 0) {
                            alreadyInvited.add(groupID);
                        } else if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO subgroup_join (groupID, subgroupID, requestGroupID, date) VALUES ('"+group.groupID+"', '"+groupID+"', '"+group.groupID+"', '"+MySQLDatabaseUtil.getTimestamp()+"');")) {
                            couldNotInvite.add(groupID);
                        } else {
                            invited.add(groupID);
                        }
                    }
                }
            }
            if (!alreadySubgroups.isEmpty()) {
                %><div><b><%=alreadySubgroups.size()%></b> groups are already subgroups.</div><%
            }
            if (!alreadyInvited.isEmpty()) {
                %><div><b><%=alreadyInvited.size()%></b> groups were already invited.</div><%
            }
            if (!couldNotInvite.isEmpty()) {
                %><div><b><%=couldNotInvite.size()%></b> groups could not be invited.</div><%
            }
            if (!invited.isEmpty()) {
                %><div><b><%=invited.size()%></b> groups were invited.</div><%
            }
            if (alreadySubgroups.isEmpty() && alreadyInvited.isEmpty() && couldNotInvite.isEmpty() && invited.isEmpty()) {
                %><div>No action taken.</div><%
            }
        } else {
            %>
            <form action="group-subgroup.jsp" method="post">
                <input type="hidden" name="action" value="invite"/>
                <input type="hidden" name="i" value="<%=group.groupID%>"/>
                <div class="table">
                    <div class="table-row">
                        <div class="table-cell"><%@include file="scripts/references/add/addGroupReferences.jsp"%></div>
                    </div><div class="table-row">
                        <div class="table-cell"><input type="submit" value="Invite Groups"></div>
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