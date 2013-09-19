<%-- 
    Document   : group-remove
    Created on : Oct 6, 2008, 10:58:37 AM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.mysql.*, java.sql.*, java.util.*, org.tranche.util.*, org.proteomecommons.www.user.*, org.proteomecommons.www.group.*, org.proteomecommons.www.notification.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("groupPageTitle", "Manage Users");
request.setAttribute("pageUsersOnly", "true");

%><%@include file="group-header.jsp"%><%

if (group != null && user != null) {
    try {
        // person must be a member
        if (!group.isMember(user.userID)) {
            throw new Exception("You are not a member of <a href=\"group.jsp?i="+group.groupID+"\">"+group.name+"</a>.");
        }
        if (request.getParameter("pending") != null) {
            
            // person must be able to invite users
            if (!group.getMember(user.userID).canInviteUser()) {
                throw new Exception("You are not allowed to invite users in <a href=\"group.jsp?i="+group.groupID+"\">"+group.name+"</a>.");
            }
            
            if (request.getParameter("action") != null) {
                String action = request.getParameter("action");
                if (action.equals("accept")) {
                    try {
                        List <Integer> couldNotAcceptUsers = new LinkedList <Integer> ();
                        List <Integer> acceptedUsers = new LinkedList <Integer> (); 
                        for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
                            String parameterName = (String)e.nextElement();
                            if (parameterName.startsWith("user")) {
                                int userID = Integer.valueOf(parameterName.substring(4));
                                if (request.getParameter(parameterName).equals("true")) {
                                    try {
                                        User u = UserUtil.getUser(userID);
                                        if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO group_user (groupID, userID, date_created) VALUES ('"+group.groupID+"', '"+userID+"', '"+MySQLDatabaseUtil.getTimestamp()+"');")) {
                                            throw new Exception("Coudl not add user to group.");
                                        }
                                        MySQLDatabaseUtil.executeUpdate("DELETE FROM group_join WHERE groupID = '"+group.groupID+"' AND userID = '"+userID+"';");
                                        acceptedUsers.add(userID);
                                        group.addNotification("<a href=\"@baseURLmember.jsp?i="+userID+"\">"+u.unique_name+"</a> joined.");
                                        u.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> accepted your request to join <a href=\"@baseURLgroup.jsp?i="+group.groupID+"\">"+group.name+"</a>.");
                                    } catch (Exception ex) {
                                        couldNotAcceptUsers.add(userID);
                                    }
                                }
                            }
                        }

                        if (!couldNotAcceptUsers.isEmpty()) {
                            %><div><b><%=couldNotAcceptUsers.size()%></b> people could not be accepted.</div><%
                        }
                        if (!acceptedUsers.isEmpty()) {
                            group.clearGroupMembers();
                            group.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> accepted " + acceptedUsers.size() + " new members.");                            
                            %><div><b><%=acceptedUsers.size()%></b> people were accepted into the group.</div><%
                        }
                    } catch (Exception e) {
                        %>Error: <%=e.getMessage()%><%
                    }
                } else if (action.equals("reject")) {
                    try {
                        List <Integer> couldNotRejectUsers = new LinkedList <Integer> ();
                        List <Integer> rejectedUsers = new LinkedList <Integer> (); 
                        for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
                            String parameterName = (String)e.nextElement();
                            if (parameterName.startsWith("user")) {
                                int userID = Integer.valueOf(parameterName.substring(4));
                                if (request.getParameter(parameterName).equals("true")) {
                                    try {
                                        User u = UserUtil.getUser(userID);
                                        MySQLDatabaseUtil.executeUpdate("DELETE FROM group_join WHERE groupID = '"+group.groupID+"' AND userID = '"+userID+"';");
                                        rejectedUsers.add(userID);
                                        u.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> rejected your request to join <a href=\"@baseURLgroup.jsp?i="+group.groupID+"\">"+group.name+"</a>.");
                                    } catch (Exception ex) {
                                        couldNotRejectUsers.add(userID);
                                    }
                                }
                            }
                        }

                        if (!couldNotRejectUsers.isEmpty()) {
                            %><div><b><%=couldNotRejectUsers.size()%></b> people could not be rejected.</div><%
                        }
                        if (!rejectedUsers.isEmpty()) {
                            group.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> rejected " + rejectedUsers.size() + " potential members.");                            
                            %><div><b><%=rejectedUsers.size()%></b> people were rejected from joining the group.</div><%
                        }
                    } catch (Exception e) {
                        %>Error: <%=e.getMessage()%><%
                    }
                }
            }
        } else {
            // person must be able to remove users
            if (!group.getMember(user.userID).canRemoveUser()) {
                throw new Exception("You are not allowed to manage users in <a href=\"group.jsp?i="+group.groupID+"\">"+group.name+"</a>.");
            }
            // execute the invite
            if (request.getParameter("action") != null) {
                String action = request.getParameter("action");
                if (action.equals("remove")) {
                    try {
                        int numAdmins = 0;
                        for (GroupMember gm : group.getGroupMembers()) {
                            if (gm.isStrictlyAdmin()) {
                                numAdmins++;
                            }
                        }

                        List <Integer> couldNotRemoveUsers = new LinkedList <Integer> ();
                        List <Integer> removedUsers = new LinkedList <Integer> (); 
                        for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
                            String parameterName = (String)e.nextElement();
                            if (parameterName.startsWith("user")) {
                                int userID = Integer.valueOf(parameterName.substring(4));
                                GroupMember gm = group.getMember(userID);
                                if (request.getParameter(parameterName).equals("true")) {
                                    if (gm.isStrictlyAdmin() && numAdmins == 1) {
                                        couldNotRemoveUsers.add(userID);
                                    } else {
                                        if (!MySQLDatabaseUtil.executeUpdate("DELETE FROM group_user WHERE userID = '"+userID+"' AND groupID = '"+group.groupID+"';")) {
                                            couldNotRemoveUsers.add(userID);
                                        } else {
                                            removedUsers.add(userID);
                                            // update in memory if applicable
                                            if (UserUtil.isInCache(userID)) {
                                                UserUtil.getUser(userID).clearGroups();
                                            }
                                            if (gm.isStrictlyAdmin()) {
                                                numAdmins--;
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        if (!couldNotRemoveUsers.isEmpty()) {
                            %><div><b><%=couldNotRemoveUsers.size()%></b> people could not be removed.</div><%
                        }
                        if (!removedUsers.isEmpty()) {
                            group.clearGroupMembers();
                            group.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> removed " + removedUsers.size() + " members.");
                            %><div><b><%=removedUsers.size()%></b> people were removed from the group.</div><%
                        }
                    } catch (Exception e) {
                        %>Error: <%=e.getMessage()%><%
                    }
                }
            }
        }
        %>
        <div class="table"><div class="table-row"><div class="table-cell">
            <div>Current Members:</div>
            <form action="group-manage.jsp" method="post" id="manageUsersForm">
                <input type="hidden" name="i" value="<%=group.groupID%>"/>
                <div class="table">
                    <div class="table-row">
                        <div class="table-cell">
                            <% for (GroupMember gm : group.getGroupMembers()) { %>
                                <div><input type="checkbox" name="user<%=gm.userID%>" value="true">&nbsp;<%=gm.getUser().unique_name%><% if (gm.isStrictlyAdmin()) { %> (Director)<% } %></div>
                            <% } %>
                        </div>
                    </div><div class="table-row">
                        <div class="table-cell"><select name="action" onchange="getObj('manageUsersForm').submit();"><option value="" selected></option><option value="remove">Remove Users</option></select></div>
                    </div>
                </div>
            </form>
        </div><div class="table-cell">
            <div>Join Requests:</div>
            <form action="group-manage.jsp" method="post" id="managePendingUsersForm">
                <input type="hidden" name="i" value="<%=group.groupID%>"/>
                <input type="hidden" name="pending" value="true"/>
                <div class="table">
                    <div class="table-row">
                        <div class="table-cell">
                            <% 
                            ResultSet rs = null;
                            try {
                                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM group_join WHERE groupID = '"+group.groupID+"' AND userID = requestUserID;");
                                while (rs.next()) {
                                    User u = UserUtil.getUser(rs.getInt("userID"));
                                    %><div><input type="checkbox" name="user<%=u.userID%>" value="true">&nbsp;<%=u.unique_name%> (pending)</div><%
                                }
                            } catch (Exception e) {
                            } finally {
                                MySQLDatabaseUtil.safeClose(rs);
                            }
                            %>
                        </div>
                    </div><div class="table-row">
                        <div class="table-cell"><select name="action" onchange="getObj('managePendingUsersForm').submit();"><option value="" selected></option><option value="accept">Accept Join Request</option><option value="reject">Reject Join Request</option></select></div>
                    </div>
                </div>
            </form>
        </div></div></div>
        <%
    } catch (Exception e) {
        %>Error: <%=e.getMessage()%><%
    }
}

%><%@include file="group-footer.jsp"%>