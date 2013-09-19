<%-- 
    Document   : group-header
    Created on : Oct 27, 2008, 7:24:00 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.tranche.util.*, org.proteomecommons.www.user.*, org.proteomecommons.www.group.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

Group group = null;
try {
    group = GroupUtil.getGroup(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (group == null) {
    request.setAttribute("pageTitle", "Group Not Found");
} else {
    if (group.isNamePrivate()) {
        request.setAttribute("pageTitle", "Group");
    } else {
        request.setAttribute("pageTitle", "Group - " + group.name);
    }
    if (request.getAttribute("groupPageTitle") != null) {
        request.setAttribute("pageTitle", request.getAttribute("pageTitle").toString() + " - " + request.getAttribute("groupPageTitle").toString());
    }
}
request.setAttribute("showPageTitle", "false");

%><%@include file="header.jsp"%><%

// check for access rights - is this a private group?
if (group != null && group.isPrivate() && (user == null || !group.isMember(user.userID))) {
    %>This is a private group<%
    if (user != null && !group.isNamePrivate()) {
        %> - <a href="group-join.jsp?i=<%=group.groupID%>">request to join</a><%
    }
    %>.<%
    group = null;
}

if (group != null) { %>
    <div class="twoColumnLayout"><div class="twoColumnLayoutRow">
        <div class="leftColumn">
            <div style="font-size: 13pt; font-weight: bold; padding-bottom: 10px;"><%=group.name%></div>
            <div style="padding-bottom: 10px;">
                <div><a href="group.jsp?i=<%=group.groupID%>">Home</a></div>
                <div>Data</div>
                <div>News</div>
                <div>Publications</div>
                <div>Tools</div>
                <div>Links</div>
                <div>Members</div>
                <div>Subgroups</div>
            </div>
            <div class="actions">
                <div class="left-title">Actions:</div>
                <div class="left-body">
                    <%
                    if (user != null) {
                        %><div><a href="messages-compose.jsp?tog=<%=group.groupID%>">Send message</a></div><%
                        if (group.isMember(user.userID)) {
                            
                            %><div><a href="group-leave.jsp?i=<%=group.groupID%>">Leave</a></div><%
                            
                            GroupMember groupMember = group.getMember(user.userID);
                            if (groupMember.canEditGroup()) {
                                %><div><a href="group-edit.jsp?i=<%=group.groupID%>">Edit</a></div><%
                            }
                            if (groupMember.canModifyPermissions()) {
                                %><div><a href="group-permissions.jsp?i=<%=group.groupID%>">Modify permissions</a></div><%
                            }
                            if (groupMember.canInviteUser()) {
                                %><div><a href="group-invite.jsp?i=<%=group.groupID%>">Invite a user</a></div><%
                            }
                            if (groupMember.canRemoveUser()) {
                                %><div><a href="group-manage.jsp?i=<%=group.groupID%>">Manage users</a></div><%
                            }
                            if (groupMember.canImportData()) {
                                %><div><a href="data-add.jsp?g=<%=group.groupID%>">Add data</a></div><%
                                %><div><a href="group-import.jsp?i=<%=group.groupID%>&type=data">Import data</a></div><%
                            }
                            if (groupMember.canImportNews()) {
                                %><div><a href="news-add.jsp?g=<%=group.groupID%>">Add news</a></div><%
                                %><div><a href="group-import.jsp?i=<%=group.groupID%>&type=news">Import news</a></div><%
                            }
                            if (groupMember.canImportPublication()) {
                                %><div><a href="publications-add.jsp?g=<%=group.groupID%>">Add publication</a></div><%
                                %><div><a href="group-import.jsp?i=<%=group.groupID%>&type=publication">Import publication</a></div><%
                            }
                            if (groupMember.canImportLink()) {
                                %><div><a href="links-add.jsp?g=<%=group.groupID%>">Add link</a></div><%
                                %><div><a href="group-import.jsp?i=<%=group.groupID%>&type=link">Import link</a></div><%
                            }
                            if (groupMember.canImportTool()) {
                                %><div><a href="tools-add.jsp?g=<%=group.groupID%>">Add tool</a></div><%
                                %><div><a href="group-import.jsp?i=<%=group.groupID%>&type=tool">Import tool</a></div><%
                            }
                            if (groupMember.canImportGroup()) {
                                %><div><a href="group-subgroup.jsp?i=<%=group.groupID%>">Import subgroup</a></div><%
                            }
                            if (groupMember.canRemoveGroup()) {
                                %><div><a href="group-manage-subgroups.jsp?i=<%=group.groupID%>">Manage subgroups</a></div><%
                            }
                        } else {
                            %><div><a href="group-join.jsp?i=<%=group.groupID%>">Join group</a></div><%
                        }
                    }
                    %>
                </div>
            </div>
            <div class="users" style="padding-top: 10px;">
                <div class="left-title">Users:</div>
                <div class="left-body">
                    <ul>
                        <% for (GroupMember gm : group.getGroupMembers(10)) { %>
                            <li><a href="member.jsp?i=<%=gm.userID%>"><%=gm.getUser().unique_name%></a><% if (gm.isStrictlyAdmin()) { %> (Director)<% } %></li>
                        <% } %>
                    </ul>
                    <% if (group.countGroupMembers() > 10) { %>
                        <div><a href="group-members.jsp">Browse all <%=Util.formatNumber(group.countGroupMembers())%> members.</a></div>
                    <% } %>
                </div>
            </div>
            <div class="subgroups" style="padding-top: 10px;">
                <div class="left-title">Subgroups:</div>
                <div class="left-body">
                    <ul>
                        <% for (Group g : group.getSubGroups(10)) { %>
                            <li><a href="group.jsp?i=<%=g.groupID%>"><%=g.name%></a></li>
                        <% } %>
                    </ul>
                    <% if (group.countSubGroups() > 10) { %>
                        <div><a href="group-subgroups.jsp">Browse all <%=Util.formatNumber(group.countSubGroups())%> subgroups.</a></div>
                    <% } %>
                </div>
            </div>
        </div>
        <div class="rightColumn">
            <% if (request.getAttribute("groupPageTitle") != null) { %><div class="rightColumnTitle"><%=request.getAttribute("groupPageTitle").toString()%></div><% } %>
            <div class="rightColumnBody">
<% } %>