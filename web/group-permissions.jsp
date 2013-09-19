<%-- 
    Document   : group-permissions
    Created on : Oct 2, 2008, 4:59:40 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.tranche.util.*, org.proteomecommons.www.user.*, org.proteomecommons.www.group.*, org.proteomecommons.www.reference.*, org.proteomecommons.www.notification.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("groupPageTitle", "Manage Permissions");
request.setAttribute("pageUsersOnly", "true");

%><%@include file="group-header.jsp"%><%

if (group != null && user != null) {
    if (group.isMember(user.userID)) {
        GroupMember groupMember = group.getMember(user.userID);
        if (!groupMember.canModifyPermissions()) {
            %>You do not have the authority to modify the permissions for this group.<%
        } else {
            // handle submitted modifications
            if (request.getParameter("modify") != null) {
                try {
                    boolean isAtLeastOneAdmin = false;
                    for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                        String param = (String) params.nextElement();
                        if (param.startsWith("radio")) {
                            if (request.getParameter(param).equals("admin")) {
                                isAtLeastOneAdmin = true;
                                break;
                            }
                        }
                    }
                    if (!isAtLeastOneAdmin) {
                        throw new Exception("There must be at least one admin for the group.");
                    }
                    
                    boolean anyPermissionsChanged = false;
                    for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                        try {
                            String param = (String) params.nextElement();
                            if (param.startsWith("radio")) {
                                int userID = Integer.valueOf(param.substring(5));
                                GroupMember thisGroupMember = group.getMember(userID);
                                try {
                                    // get the permissions
                                    boolean permissionsChanged = false;
                                    boolean permission_edit = false;
                                    if (request.getParameter("permission_edit"+userID) != null) {
                                        try {
                                            permission_edit = Boolean.valueOf(request.getParameter("permission_edit"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_edit != thisGroupMember.canEditGroup();
                                    boolean permission_invite_user = false;
                                    if (request.getParameter("permission_invite_user"+userID) != null) {
                                        try {
                                            permission_invite_user = Boolean.valueOf(request.getParameter("permission_invite_user"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_invite_user != thisGroupMember.canInviteUser();
                                    boolean permission_remove_user = false;
                                    if (request.getParameter("permission_remove_user"+userID) != null) {
                                        try {
                                            permission_remove_user = Boolean.valueOf(request.getParameter("permission_remove_user"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_remove_user != thisGroupMember.canRemoveUser();
                                    boolean permission_modify_permissions = false;
                                    if (request.getParameter("permission_modify_permissions"+userID) != null) {
                                        try {
                                            permission_modify_permissions = Boolean.valueOf(request.getParameter("permission_modify_permissions"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_modify_permissions != thisGroupMember.canModifyPermissions();
                                    boolean permission_import_group = false;
                                    if (request.getParameter("permission_import_group"+userID) != null) {
                                        try {
                                            permission_import_group = Boolean.valueOf(request.getParameter("permission_import_group"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_import_group != thisGroupMember.canImportGroup();
                                    boolean permission_remove_group = false;
                                    if (request.getParameter("permission_remove_group"+userID) != null) {
                                        try {
                                            permission_remove_group = Boolean.valueOf(request.getParameter("permission_remove_group"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_remove_group != thisGroupMember.canRemoveGroup();
                                    boolean permission_import_link = false;
                                    if (request.getParameter("permission_import_link"+userID) != null) {
                                        try {
                                            permission_import_link = Boolean.valueOf(request.getParameter("permission_import_link"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_import_link != thisGroupMember.canImportLink();
                                    boolean permission_import_news = false;
                                    if (request.getParameter("permission_import_news"+userID) != null) {
                                        try {
                                            permission_import_news = Boolean.valueOf(request.getParameter("permission_import_news"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_import_news != thisGroupMember.canImportNews();
                                    boolean permission_import_tool = false;
                                    if (request.getParameter("permission_import_tool"+userID) != null) {
                                        try {
                                            permission_import_tool = Boolean.valueOf(request.getParameter("permission_import_tool"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_import_tool != thisGroupMember.canImportTool();
                                    boolean permission_import_publication = false;
                                    if (request.getParameter("permission_import_publication"+userID) != null) {
                                        try {
                                            permission_import_publication = Boolean.valueOf(request.getParameter("permission_import_publication"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_import_publication != thisGroupMember.canImportPublication();
                                    boolean permission_import_data = false;
                                    if (request.getParameter("permission_import_data"+userID) != null) {
                                        try {
                                            permission_import_data = Boolean.valueOf(request.getParameter("permission_import_data"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_import_data != thisGroupMember.canImportData();
                                    boolean permission_annotate_data = false;
                                    if (request.getParameter("permission_annotate_data"+userID) != null) {
                                        try {
                                            permission_annotate_data = Boolean.valueOf(request.getParameter("permission_annotate_data"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_annotate_data != thisGroupMember.canAnnotateData();
                                    boolean permission_see_group = false;
                                    if (request.getParameter("permission_see_group"+userID) != null) {
                                        try {
                                            permission_see_group = Boolean.valueOf(request.getParameter("permission_see_group"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_see_group != thisGroupMember.canSeeGroup();
                                    boolean permission_see_users = false;
                                    if (request.getParameter("permission_see_users"+userID) != null) {
                                        try {
                                            permission_see_users = Boolean.valueOf(request.getParameter("permission_see_users"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_see_users != thisGroupMember.canSeeUsers();
                                    boolean permission_see_data = false;
                                    if (request.getParameter("permission_see_data"+userID) != null) {
                                        try {
                                            permission_see_data = Boolean.valueOf(request.getParameter("permission_see_data"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_see_data != thisGroupMember.canSeeData();
                                    boolean permission_see_publications = false;
                                    if (request.getParameter("permission_see_publications"+userID) != null) {
                                        try {
                                            permission_see_publications = Boolean.valueOf(request.getParameter("permission_see_publications"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_see_publications != thisGroupMember.canSeePublications();
                                    boolean permission_see_links = false;
                                    if (request.getParameter("permission_see_links"+userID) != null) {
                                        try {
                                            permission_see_links = Boolean.valueOf(request.getParameter("permission_see_links"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_see_links != thisGroupMember.canSeeLinks();
                                    boolean permission_see_tools = false;
                                    if (request.getParameter("permission_see_tools"+userID) != null) {
                                        try {
                                            permission_see_tools = Boolean.valueOf(request.getParameter("permission_see_tools"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_see_tools != thisGroupMember.canSeeTools();
                                    boolean permission_see_news = false;
                                    if (request.getParameter("permission_see_news"+userID) != null) {
                                        try {
                                            permission_see_news = Boolean.valueOf(request.getParameter("permission_see_news"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_see_news != thisGroupMember.canSeeNews();
                                    boolean permission_see_subgroups = false;
                                    if (request.getParameter("permission_see_subgroups"+userID) != null) {
                                        try {
                                            permission_see_subgroups = Boolean.valueOf(request.getParameter("permission_see_subgroups"+userID));
                                        } catch (Exception e) {
                                        }
                                    }
                                    permissionsChanged = permissionsChanged || permission_see_subgroups != thisGroupMember.canSeeSubgroups();
                                    
                                    // make sure there is a change before committing back to the database
                                    if (permissionsChanged) {
                                        int i_permission_edit = 0;
                                        if (permission_edit) {
                                            i_permission_edit = 1;
                                        }
                                        int i_permission_invite_user = 0;
                                        if (permission_invite_user) {
                                            i_permission_invite_user = 1;
                                        }
                                        int i_permission_remove_user = 0;
                                        if (permission_remove_user) {
                                            i_permission_remove_user = 1;
                                        }
                                        int i_permission_modify_permissions = 0;
                                        if (permission_modify_permissions) {
                                            i_permission_modify_permissions = 1;
                                        }
                                        int i_permission_import_group = 0;
                                        if (permission_import_group) {
                                            i_permission_import_group = 1;
                                        }
                                        int i_permission_remove_group = 0;
                                        if (permission_remove_group) {
                                            i_permission_remove_group = 1;
                                        }
                                        int i_permission_import_link = 0;
                                        if (permission_import_link) {
                                            i_permission_import_link = 1;
                                        }
                                        int i_permission_import_news = 0;
                                        if (permission_import_news) {
                                            i_permission_import_news = 1;
                                        }
                                        int i_permission_import_publication = 0;
                                        if (permission_import_publication) {
                                            i_permission_import_publication = 1;
                                        }
                                        int i_permission_import_tool = 0;
                                        if (permission_import_tool) {
                                            i_permission_import_tool = 1;
                                        }
                                        int i_permission_import_data = 0;
                                        if (permission_import_data) {
                                            i_permission_import_data = 1;
                                        }
                                        int i_permission_annotate_data = 0;
                                        if (permission_annotate_data) {
                                            i_permission_annotate_data = 1;
                                        }
                                        int i_permission_see_group = 0;
                                        if (permission_see_group) {
                                            i_permission_see_group = 1;
                                        }
                                        int i_permission_see_users = 0;
                                        if (permission_see_users) {
                                            i_permission_see_users = 1;
                                        }
                                        int i_permission_see_data = 0;
                                        if (permission_see_data) {
                                            i_permission_see_data = 1;
                                        }
                                        int i_permission_see_publications = 0;
                                        if (permission_see_publications) {
                                            i_permission_see_publications = 1;
                                        }
                                        int i_permission_see_links = 0;
                                        if (permission_see_links) {
                                            i_permission_see_links = 1;
                                        }
                                        int i_permission_see_tools = 0;
                                        if (permission_see_tools) {
                                            i_permission_see_tools = 1;
                                        }
                                        int i_permission_see_news = 0;
                                        if (permission_see_news) {
                                            i_permission_see_news = 1;
                                        }
                                        int i_permission_see_subgroups = 0;
                                        if (permission_see_subgroups) {
                                            i_permission_see_subgroups = 1;
                                        }
                                        if (!MySQLDatabaseUtil.executeUpdate("UPDATE group_user SET permission_edit = '"+i_permission_edit+"', permission_invite_user = '"+i_permission_invite_user+"', permission_remove_user = '"+i_permission_remove_user+"', permission_modify_permissions = '"+i_permission_modify_permissions+"', permission_import_group = '"+i_permission_import_group+"', permission_remove_group = '"+i_permission_remove_group+"', permission_import_link = '"+i_permission_import_link+"', permission_import_news = '"+i_permission_import_news+"', permission_import_tool = '"+i_permission_import_tool+"', permission_import_publication = '"+i_permission_import_publication+"', permission_import_data = '"+i_permission_import_data+"', permission_annotate_data = '"+i_permission_annotate_data+"', permission_see_group = '"+i_permission_see_group+"', permission_see_users = '"+i_permission_see_users+"', permission_see_data = '"+i_permission_see_data+"', permission_see_publications = '"+i_permission_see_publications+"', permission_see_links = '"+i_permission_see_links+"', permission_see_tools = '"+i_permission_see_tools+"', permission_see_news = '"+i_permission_see_news+"', permission_see_subgroups = '"+i_permission_see_subgroups+"' WHERE groupID = '"+thisGroupMember.groupID+"' AND userID = '"+thisGroupMember.userID+"';")) {
                                            throw new Exception("Could not update database.");
                                        } else {
                                            anyPermissionsChanged = true;
                                        }
                                    }
                                } catch (Exception e) {
                                    %>A problem occurred updating permissions for <a href="member.jsp?i=<%=thisGroupMember.userID%>"><%=thisGroupMember.getUser().unique_name%></a>: <%=MySQLDatabaseUtil.formatTextForDatabase(e.getMessage())%><%
                                }
                            }
                        } catch (Exception e) {
                        }
                    }
                    // reload the group member objects in memory
                    if (anyPermissionsChanged) {
                        group.clearGroupMembers();
                        group.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> modified permissions.");
                        %>Changes made.<%
                    } else {
                        %>No changes made.<%
                    }
                    %><script language="javascript">goTo('group.jsp?i=<%=group.groupID%>');</script><%
                } catch (Exception e) {
                    %>A problem occurred: <%=MySQLDatabaseUtil.formatTextForDatabase(e.getMessage())%><%
                }
            }
            %>
            <script language="javascript">
                function resetCheckboxes(userID, status) {
                    // enable the checkboxes
                    if (status == 'custom') {
                        getObj('permission_edit'+userID).style.display = 'inline';
                        getObj('permission_invite_user'+userID).style.display = 'inline';
                        getObj('permission_remove_user'+userID).style.display = 'inline';
                        getObj('permission_modify_permissions'+userID).style.display = 'inline';
                        getObj('permission_import_group'+userID).style.display = 'inline';
                        getObj('permission_remove_group'+userID).style.display = 'inline';
                        getObj('permission_import_link'+userID).style.display = 'inline';
                        getObj('permission_import_news'+userID).style.display = 'inline';
                        getObj('permission_import_tool'+userID).style.display = 'inline';
                        getObj('permission_import_publication'+userID).style.display = 'inline';
                        getObj('permission_import_data'+userID).style.display = 'inline';
                        getObj('permission_annotate_data'+userID).style.display = 'inline'; 
                        getObj('permission_see_group'+userID).style.display = 'inline';
                        getObj('permission_see_users'+userID).style.display = 'inline';
                        getObj('permission_see_data'+userID).style.display = 'inline';
                        getObj('permission_see_publications'+userID).style.display = 'inline';
                        getObj('permission_see_links'+userID).style.display = 'inline';
                        getObj('permission_see_tools'+userID).style.display = 'inline';
                        getObj('permission_see_news'+userID).style.display = 'inline';
                        getObj('permission_see_subgroups'+userID).style.display = 'inline';
                    } // disable the checkboxes
                    else {
                        getObj('permission_edit'+userID).style.display = 'none';
                        getObj('permission_invite_user'+userID).style.display = 'none';
                        getObj('permission_remove_user'+userID).style.display = 'none';
                        getObj('permission_modify_permissions'+userID).style.display = 'none';
                        getObj('permission_import_group'+userID).style.display = 'none';
                        getObj('permission_remove_group'+userID).style.display = 'none';
                        getObj('permission_import_link'+userID).style.display = 'none';
                        getObj('permission_import_news'+userID).style.display = 'none';
                        getObj('permission_import_tool'+userID).style.display = 'none';
                        getObj('permission_import_publication'+userID).style.display = 'none';
                        getObj('permission_import_data'+userID).style.display = 'none';
                        getObj('permission_annotate_data'+userID).style.display = 'none';
                        getObj('permission_see_group'+userID).style.display = 'none';
                        getObj('permission_see_users'+userID).style.display = 'none';
                        getObj('permission_see_data'+userID).style.display = 'none';
                        getObj('permission_see_publications'+userID).style.display = 'none';
                        getObj('permission_see_links'+userID).style.display = 'none';
                        getObj('permission_see_tools'+userID).style.display = 'none';
                        getObj('permission_see_news'+userID).style.display = 'none';
                        getObj('permission_see_subgroups'+userID).style.display = 'none';
                    }
                    // update the check boxes
                    if (status == 'admin') {
                        getObj('permission_edit'+userID).setAttribute('checked', 'checked');
                        getObj('permission_invite_user'+userID).setAttribute('checked', 'checked');
                        getObj('permission_remove_user'+userID).setAttribute('checked', 'checked');
                        getObj('permission_modify_permissions'+userID).setAttribute('checked', 'checked');
                        getObj('permission_import_group'+userID).setAttribute('checked', 'checked');
                        getObj('permission_remove_group'+userID).setAttribute('checked', 'checked');
                        getObj('permission_import_link'+userID).setAttribute('checked', 'checked');
                        getObj('permission_import_news'+userID).setAttribute('checked', 'checked');
                        getObj('permission_import_tool'+userID).setAttribute('checked', 'checked');
                        getObj('permission_import_publication'+userID).setAttribute('checked', 'checked');
                        getObj('permission_import_data'+userID).setAttribute('checked', 'checked');
                        getObj('permission_annotate_data'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_group'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_users'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_data'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_publications'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_links'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_tools'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_news'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_subgroups'+userID).setAttribute('checked', 'checked');
                        
                        getObj('permission_edit'+userID+'text').innerHTML = 'yes';
                        getObj('permission_invite_user'+userID+'text').innerHTML = 'yes';
                        getObj('permission_remove_user'+userID+'text').innerHTML = 'yes';
                        getObj('permission_modify_permissions'+userID+'text').innerHTML = 'yes';
                        getObj('permission_import_group'+userID+'text').innerHTML = 'yes';
                        getObj('permission_remove_group'+userID+'text').innerHTML = 'yes';
                        getObj('permission_import_link'+userID+'text').innerHTML = 'yes';
                        getObj('permission_import_news'+userID+'text').innerHTML = 'yes';
                        getObj('permission_import_tool'+userID+'text').innerHTML = 'yes';
                        getObj('permission_import_publication'+userID+'text').innerHTML = 'yes';
                        getObj('permission_import_data'+userID+'text').innerHTML = 'yes';
                        getObj('permission_annotate_data'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_group'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_users'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_data'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_publications'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_links'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_tools'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_news'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_subgroups'+userID+'text').innerHTML = 'yes';
                    } else if (status == 'user') {
                        getObj('permission_edit'+userID).removeAttribute('checked');
                        getObj('permission_invite_user'+userID).removeAttribute('checked');
                        getObj('permission_remove_user'+userID).removeAttribute('checked');
                        getObj('permission_modify_permissions'+userID).removeAttribute('checked');
                        getObj('permission_import_group'+userID).removeAttribute('checked');
                        getObj('permission_remove_group'+userID).removeAttribute('checked');
                        getObj('permission_import_link'+userID).setAttribute('checked', 'checked');
                        getObj('permission_import_news'+userID).setAttribute('checked', 'checked');
                        getObj('permission_import_tool'+userID).setAttribute('checked', 'checked');
                        getObj('permission_import_publication'+userID).setAttribute('checked', 'checked');
                        getObj('permission_import_data'+userID).setAttribute('checked', 'checked');
                        getObj('permission_annotate_data'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_group'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_users'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_data'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_publications'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_links'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_tools'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_news'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_subgroups'+userID).setAttribute('checked', 'checked');
                        
                        getObj('permission_edit'+userID+'text').innerHTML = 'no';
                        getObj('permission_invite_user'+userID+'text').innerHTML = 'no';
                        getObj('permission_remove_user'+userID+'text').innerHTML = 'no';
                        getObj('permission_modify_permissions'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_group'+userID+'text').innerHTML = 'no';
                        getObj('permission_remove_group'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_link'+userID+'text').innerHTML = 'yes';
                        getObj('permission_import_news'+userID+'text').innerHTML = 'yes';
                        getObj('permission_import_tool'+userID+'text').innerHTML = 'yes';
                        getObj('permission_import_publication'+userID+'text').innerHTML = 'yes';
                        getObj('permission_import_data'+userID+'text').innerHTML = 'yes';
                        getObj('permission_annotate_data'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_group'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_users'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_data'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_publications'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_links'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_tools'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_news'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_subgroups'+userID+'text').innerHTML = 'yes';
                    } else if (status == 'viewer') {
                        getObj('permission_edit'+userID).removeAttribute('checked');
                        getObj('permission_invite_user'+userID).removeAttribute('checked');
                        getObj('permission_remove_user'+userID).removeAttribute('checked');
                        getObj('permission_modify_permissions'+userID).removeAttribute('checked');
                        getObj('permission_import_group'+userID).removeAttribute('checked');
                        getObj('permission_remove_group'+userID).removeAttribute('checked');
                        getObj('permission_import_link'+userID).removeAttribute('checked');
                        getObj('permission_import_news'+userID).removeAttribute('checked');
                        getObj('permission_import_tool'+userID).removeAttribute('checked');
                        getObj('permission_import_publication'+userID).removeAttribute('checked');
                        getObj('permission_import_data'+userID).removeAttribute('checked');
                        getObj('permission_annotate_data'+userID).removeAttribute('checked');
                        getObj('permission_see_group'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_users'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_data'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_publications'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_links'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_tools'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_news'+userID).setAttribute('checked', 'checked');
                        getObj('permission_see_subgroups'+userID).setAttribute('checked', 'checked');
                        
                        getObj('permission_edit'+userID+'text').innerHTML = 'no';
                        getObj('permission_invite_user'+userID+'text').innerHTML = 'no';
                        getObj('permission_remove_user'+userID+'text').innerHTML = 'no';
                        getObj('permission_modify_permissions'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_group'+userID+'text').innerHTML = 'no';
                        getObj('permission_remove_group'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_link'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_news'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_tool'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_publication'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_data'+userID+'text').innerHTML = 'no';
                        getObj('permission_annotate_data'+userID+'text').innerHTML = 'no';
                        getObj('permission_see_group'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_users'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_data'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_publications'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_links'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_tools'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_news'+userID+'text').innerHTML = 'yes';
                        getObj('permission_see_subgroups'+userID+'text').innerHTML = 'yes';
                    } else if (status == 'none') {
                        getObj('permission_edit'+userID).removeAttribute('checked');
                        getObj('permission_invite_user'+userID).removeAttribute('checked');
                        getObj('permission_remove_user'+userID).removeAttribute('checked');
                        getObj('permission_modify_permissions'+userID).removeAttribute('checked');
                        getObj('permission_import_group'+userID).removeAttribute('checked');
                        getObj('permission_remove_group'+userID).removeAttribute('checked');
                        getObj('permission_import_link'+userID).removeAttribute('checked');
                        getObj('permission_import_news'+userID).removeAttribute('checked');
                        getObj('permission_import_tool'+userID).removeAttribute('checked');
                        getObj('permission_import_publication'+userID).removeAttribute('checked');
                        getObj('permission_import_data'+userID).removeAttribute('checked');
                        getObj('permission_annotate_data'+userID).removeAttribute('checked');
                        getObj('permission_see_group'+userID).removeAttribute('checked');
                        getObj('permission_see_users'+userID).removeAttribute('checked');
                        getObj('permission_see_data'+userID).removeAttribute('checked');
                        getObj('permission_see_publications'+userID).removeAttribute('checked');
                        getObj('permission_see_links'+userID).removeAttribute('checked');
                        getObj('permission_see_tools'+userID).removeAttribute('checked');
                        getObj('permission_see_news'+userID).removeAttribute('checked');
                        getObj('permission_see_subgroups'+userID).removeAttribute('checked');
                        
                        getObj('permission_edit'+userID+'text').innerHTML = 'no';
                        getObj('permission_invite_user'+userID+'text').innerHTML = 'no';
                        getObj('permission_remove_user'+userID+'text').innerHTML = 'no';
                        getObj('permission_modify_permissions'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_group'+userID+'text').innerHTML = 'no';
                        getObj('permission_remove_group'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_link'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_news'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_tool'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_publication'+userID+'text').innerHTML = 'no';
                        getObj('permission_import_data'+userID+'text').innerHTML = 'no';
                        getObj('permission_annotate_data'+userID+'text').innerHTML = 'no';
                        getObj('permission_see_group'+userID+'text').innerHTML = 'no';
                        getObj('permission_see_users'+userID+'text').innerHTML = 'no';
                        getObj('permission_see_data'+userID+'text').innerHTML = 'no';
                        getObj('permission_see_publications'+userID+'text').innerHTML = 'no';
                        getObj('permission_see_links'+userID+'text').innerHTML = 'no';
                        getObj('permission_see_tools'+userID+'text').innerHTML = 'no';
                        getObj('permission_see_news'+userID+'text').innerHTML = 'no';
                        getObj('permission_see_subgroups'+userID+'text').innerHTML = 'no';
                    }
                    
                    if (status == 'admin' || status == 'user' || status == 'viewer' || status == 'none') {
                        getObj('permission_edit'+userID+'text').style.display = 'inline';
                        getObj('permission_invite_user'+userID+'text').style.display = 'inline';
                        getObj('permission_remove_user'+userID+'text').style.display = 'inline';
                        getObj('permission_modify_permissions'+userID+'text').style.display = 'inline';
                        getObj('permission_import_group'+userID+'text').style.display = 'inline';
                        getObj('permission_remove_group'+userID+'text').style.display = 'inline';
                        getObj('permission_import_link'+userID+'text').style.display = 'inline';
                        getObj('permission_import_news'+userID+'text').style.display = 'inline';
                        getObj('permission_import_tool'+userID+'text').style.display = 'inline';
                        getObj('permission_import_publication'+userID+'text').style.display = 'inline';
                        getObj('permission_import_data'+userID+'text').style.display = 'inline';
                        getObj('permission_annotate_data'+userID+'text').style.display = 'inline';
                        getObj('permission_see_group'+userID+'text').style.display = 'inline';
                        getObj('permission_see_users'+userID+'text').style.display = 'inline';
                        getObj('permission_see_data'+userID+'text').style.display = 'inline';
                        getObj('permission_see_publications'+userID+'text').style.display = 'inline';
                        getObj('permission_see_links'+userID+'text').style.display = 'inline';
                        getObj('permission_see_tools'+userID+'text').style.display = 'inline';
                        getObj('permission_see_news'+userID+'text').style.display = 'inline';
                        getObj('permission_see_subgroups'+userID+'text').style.display = 'inline';
                    } else {
                        getObj('permission_edit'+userID+'text').style.display = 'none';
                        getObj('permission_invite_user'+userID+'text').style.display = 'none';
                        getObj('permission_remove_user'+userID+'text').style.display = 'none';
                        getObj('permission_modify_permissions'+userID+'text').style.display = 'none';
                        getObj('permission_import_group'+userID+'text').style.display = 'none';
                        getObj('permission_remove_group'+userID+'text').style.display = 'none';
                        getObj('permission_import_link'+userID+'text').style.display = 'none';
                        getObj('permission_import_news'+userID+'text').style.display = 'none';
                        getObj('permission_import_tool'+userID+'text').style.display = 'none';
                        getObj('permission_import_publication'+userID+'text').style.display = 'none';
                        getObj('permission_import_data'+userID+'text').style.display = 'none';
                        getObj('permission_annotate_data'+userID+'text').style.display = 'none';
                        getObj('permission_see_group'+userID+'text').style.display = 'none';
                        getObj('permission_see_users'+userID+'text').style.display = 'none';
                        getObj('permission_see_data'+userID+'text').style.display = 'none';
                        getObj('permission_see_publications'+userID+'text').style.display = 'none';
                        getObj('permission_see_links'+userID+'text').style.display = 'none';
                        getObj('permission_see_tools'+userID+'text').style.display = 'none';
                        getObj('permission_see_news'+userID+'text').style.display = 'none';
                        getObj('permission_see_subgroups'+userID+'text').style.display = 'none';
                    }
                    
                }
            </script>
            <form action="group-permissions.jsp" method="post" id="groupPermissionsForm">
                <input type="hidden" name="i" value="<%=group.groupID%>"/>
                <input type="hidden" name="modify" value="1"/>
                <div class="table">
                    <div class="table-row">
                        <div class="table-hcell">Member</div>
                        <div class="table-hcell">Class</div>
                        <div class="table-hcell">Permissions</div>
                    </div>
                    <% for (GroupMember gm : group.getGroupMembers()) { %>
                        <div class="table-row">
                            <div class="table-cell"><a href="member.jsp?i=<%=gm.userID%>"><%=gm.getUser().unique_name%></a></div>
                            <div class="table-hcell">
                                <select name="radio<%=gm.userID%>" id="user<%=gm.userID%>Status" onchange="resetCheckboxes('<%=gm.userID%>', getObj('user<%=gm.userID%>Status').options[getObj('user<%=gm.userID%>Status').selectedIndex].value);">
                                    <option value="admin"<% if (gm.isStrictlyAdmin()) { %> selected<% } %>>Director</option>
                                    <option value="user"<% if (gm.isStrictlyUser()) { %> selected<% } %>>User</option>
                                    <option value="viewer"<% if (gm.isStrictlyViewer()) { %> selected<% } %>>Viewer</option>
                                    <option value="none"<% if (gm.hasNoPermissions()) { %> selected<% } %>>None</option>
                                    <option value="custom"<% if (gm.isCustom()) { %> selected<% } %>>Custom</option>
                                </select>
                            </div>
                            <div class="table-cell">
                                <div style="display: table; width: 100%;">
                                    <div style="display: table-row;">
                                        <div style="display: table-cell;">Edit Group Info:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_edit<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canEditGroup()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_edit<%=gm.userID%>" name="permission_edit<%=gm.userID%>" value="true"<% if (gm.canEditGroup()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                        <div style="display: table-cell;">Invite Users:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_invite_user<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canInviteUser()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_invite_user<%=gm.userID%>" name="permission_invite_user<%=gm.userID%>" value="true"<% if (gm.canInviteUser()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                        <div style="display: table-cell;">Remove Users:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_remove_user<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% } %>><% if (gm.canRemoveUser()) { %>yes<% } else { %>no<% } %></span><input type="checkbox" id="permission_remove_user<%=gm.userID%>" name="permission_remove_user<%=gm.userID%>" value="true"<% if (gm.canRemoveUser()) { %> checked<% } %><% if (!gm.isCustom()) { %> style="display: none;"<% } %>/></div>
                                    </div><div style="display: table-row;">
                                        <div style="display: table-cell;">Modify Permissions:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_modify_permissions<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canModifyPermissions()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_modify_permissions<%=gm.userID%>" name="permission_modify_permissions<%=gm.userID%>" value="true"<% if (gm.canModifyPermissions()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                        <div style="display: table-cell;">Import Groups:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_import_group<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canImportGroup()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_import_group<%=gm.userID%>" name="permission_import_group<%=gm.userID%>" value="true"<% if (gm.canImportGroup()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                        <div style="display: table-cell;">Remove Groups:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_remove_group<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canRemoveGroup()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_remove_group<%=gm.userID%>" name="permission_remove_group<%=gm.userID%>" value="true"<% if (gm.canRemoveGroup()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                    </div><div style="display: table-row;">
                                        <div style="display: table-cell;">Import Links:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_import_link<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% } %>><% if (gm.canImportLink()) { %>yes<% } else { %>no<% } %></span><input type="checkbox" id="permission_import_link<%=gm.userID%>" name="permission_import_link<%=gm.userID%>" value="true"<% if (gm.canImportLink()) { %> checked<% } %><% if (!gm.isCustom()) { %> style="display: none;"<% } %>/></div>
                                        <div style="display: table-cell;">Import News:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_import_news<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canImportNews()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_import_news<%=gm.userID%>" name="permission_import_news<%=gm.userID%>" value="true"<% if (gm.canImportNews()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                        <div style="display: table-cell;">Import Tools:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_import_tool<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canImportTool()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_import_tool<%=gm.userID%>" name="permission_import_tool<%=gm.userID%>" value="true"<% if (gm.canImportTool()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                    </div><div style="display: table-row;">
                                        <div style="display: table-cell;">Import Publications:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_import_publication<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canImportPublication()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_import_publication<%=gm.userID%>" name="permission_import_publication<%=gm.userID%>" value="true"<% if (gm.canImportPublication()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                        <div style="display: table-cell;">Import Data:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_import_data<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% } %>><% if (gm.canImportData()) { %>yes<% } else { %>no<% } %></span><input type="checkbox" id="permission_import_data<%=gm.userID%>" name="permission_import_data<%=gm.userID%>" value="true"<% if (gm.canImportData()) { %> checked<% } %><% if (!gm.isCustom()) { %> style="display: none;"<% } %>/></div>
                                        <div style="display: table-cell;">Annotate Data</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_annotate_data<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% } %>><% if (gm.canAnnotateData()) { %>yes<% } else { %>no<% } %></span><input type="checkbox" id="permission_annotate_data<%=gm.userID%>" name="permission_annotate_data<%=gm.userID%>" value="true"<% if (gm.canAnnotateData()) { %> checked<% } %><% if (!gm.isCustom()) { %> style="display: none;"<% } %>/></div>
                                    </div><div style="display: table-row;">
                                        <div style="display: table-cell;">See Group Info:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_see_group<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canSeeGroup()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_see_group<%=gm.userID%>" name="permission_see_group<%=gm.userID%>" value="true"<% if (gm.canSeeGroup()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                        <div style="display: table-cell;">See Users:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_see_users<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canSeeUsers()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_see_users<%=gm.userID%>" name="permission_see_users<%=gm.userID%>" value="true"<% if (gm.canSeeUsers()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                        <div style="display: table-cell;">See Data:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_see_data<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% } %>><% if (gm.canSeeData()) { %>yes<% } else { %>no<% } %></span><input type="checkbox" id="permission_see_data<%=gm.userID%>" name="permission_see_data<%=gm.userID%>" value="true"<% if (gm.canSeeData()) { %> checked<% } %><% if (!gm.isCustom()) { %> style="display: none;"<% } %>/></div>
                                    </div><div style="display: table-row;">
                                        <div style="display: table-cell;">See Publications:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_see_publications<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canSeePublications()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_see_publications<%=gm.userID%>" name="permission_see_publications<%=gm.userID%>" value="true"<% if (gm.canSeePublications()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                        <div style="display: table-cell;">See Links:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_see_links<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canSeeLinks()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_see_links<%=gm.userID%>" name="permission_see_links<%=gm.userID%>" value="true"<% if (gm.canSeeLinks()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                        <div style="display: table-cell;">See Tools:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_see_tools<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canSeeTools()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_see_tools<%=gm.userID%>" name="permission_see_tools<%=gm.userID%>" value="true"<% if (gm.canSeeTools()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                    </div><div style="display: table-row;">
                                        <div style="display: table-cell;">See News:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_see_news<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% } %>><% if (gm.canSeeNews()) { %>yes<% } else { %>no<% } %></span><input type="checkbox" id="permission_see_news<%=gm.userID%>" name="permission_see_news<%=gm.userID%>" value="true"<% if (gm.canSeeNews()) { %> checked<% } %><% if (!gm.isCustom()) { %> style="display: none;"<% } %>/></div>
                                        <div style="display: table-cell;">See Subgroups:</div>
                                        <div style="display: table-cell; font-weight: bold;"><span id="permission_see_subgroups<%=gm.userID%>text"<% if (gm.isCustom()) {%> style="display: none;"<% }%>><% if (gm.canSeeSubgroups()) {%>yes<% } else {%>no<% }%></span><input type="checkbox" id="permission_see_subgroups<%=gm.userID%>" name="permission_see_subgroups<%=gm.userID%>" value="true"<% if (gm.canSeeSubgroups()) {%> checked<% }%><% if (!gm.isCustom()) {%> style="display: none;"<% }%>/></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                    <div class="table-row">
                        <div class="table-cell"><input type="submit" value="Make Changes"></div>
                    </div>
                </div>
            </form>
            <%
        }
    }
}

%><%@include file="group-footer.jsp"%>