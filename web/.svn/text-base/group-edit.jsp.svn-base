<%-- 
    Document   : group-edit
    Created on : Oct 6, 2008, 12:04:00 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.mysql.*, java.sql.*, java.util.*, org.tranche.util.*, org.proteomecommons.www.user.*, org.proteomecommons.www.group.*, org.proteomecommons.www.notification.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("groupPageTitle", "Edit Group");
request.setAttribute("pageUsersOnly", "true");

%><%@include file="group-header.jsp"%><%

if (user != null) {
    if (group != null) {
        try {
            // person must be a member
            if (!group.isMember(user.userID)) {
                throw new Exception("You are not a member of <a href=\"group.jsp?i="+group.groupID+"\">"+group.name+"</a>.");
            }
            // person must be able to edit the group
            if (!group.getMember(user.userID).canEditGroup()) {
                throw new Exception("You are not allowed to edit <a href=\"group.jsp?i="+group.groupID+"\">"+group.name+"</a>.");
            }
        } catch (Exception e) {
            group = null;
            %>Error: <%=e.getMessage()%><%
        }
    }

    if (group != null) {
        boolean show = true;
        if (request.getParameter("name") != null) {
            try {
                String name = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("name"));
                String description = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("description"));
                String privacy = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("privacy"));

                if (name.equals("")) {
                    throw new Exception("Name cannot be blank.");
                }

                if (description.equals("")) {
                    throw new Exception("Description cannot be blank.");
                }

                // derive privacy flags
                int private_group = 0, private_name = 0;
                if (privacy.equals("private_group")) {
                    private_group = 1;
                } else if (privacy.equals("private_name")) {
                    private_group = 1;
                    private_name = 1;
                }

                ResultSet rs = null;
                try {
                    rs = MySQLDatabaseUtil.executeQuery("SELECT groupID FROM groups WHERE name = '"+name+"' AND groupID != '"+group.groupID+"';");
                    if (rs.next()) {
                        throw new Exception("The given Nsme is already a group name.");
                    }
                } finally {
                    MySQLDatabaseUtil.safeClose(rs);
                }

                // update the group
                if (!MySQLDatabaseUtil.executeUpdate("UPDATE groups SET name = '"+name+"', description = '"+description+"', private_group = '"+private_group+"', private_name = '"+private_name+"' WHERE groupID = '"+group.groupID+"';")) {
                    throw new Exception("Could not update the group information.");
                } else {
                    group.private_group = private_group == 1;
                    group.private_name = private_name == 1;
                    group.name = name;
                    group.description = description;
                    show = false;
                    group.addNotification("<a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> edited the group&rsquo;s basic information.");
                    %>
                    Changes made.
                    <script language="javascript">
                        goTo('@baseURLgroup.jsp?i=<%=group.groupID%>');
                    </script>
                    <%
                }
            } catch (Exception e) {
                %>Error: <%=e.getMessage()%><%
            }
        }
        if (show) {
            %>
            <form action="group-edit.jsp" method="post">
                <input type="hidden" name="i" value="<%=group.groupID%>"/>
                <div class="table">
                    <div class="table-row">
                        <div class="table-cell">Name</div>
                        <div class="table-cell"><input type="text" name="name" maxlength="100" value="<%=group.name%>"></div>
                        <div class="table-cell"><div>Maximum length: 100 characters.</div></div>
                    </div><div class="table-row">
                        <div class="table-cell">Description</div>
                        <div class="table-cell"><textarea name="description"><%=group.description%></textarea></div>                
                        <div class="table-cell"></div>
                    </div><div class="table-row">
                        <div class="table-cell">Privacy</div>
                        <div class="table-cell">
                            <% 
                            String privacy = "public";
                            if (group.isNamePrivate()) {
                                privacy = "private_name";
                            } else if (group.isPrivate()) {
                                privacy = "private_group";
                            }
                            %>
                            <select name="privacy">
                                <option value="public"<% if (privacy.equals("public")) { %> selected<% } %>>Public</option>
                                <option value="private_group"<% if (privacy.equals("private_group")) { %> selected<% } %>>Private Group, Public Name</option>
                                <option value="private_name"<% if (privacy.equals("private_name")) { %> selected<% } %>>Private Group, Private Name</option>
                            </select>
                        </div>
                        <div class="table-cell">
                            <div>A <b>public</b> group has no restrictions on who can see the information. Any anonymous person can see all group activities, but only members with appropriate permissions can participate.</div>
                            <div>A <b>private group, public name</b> group keeps all group information except name and description to the members.</div>
                            <div>A <b>private group, private name</b> group keeps the group completely hidden to anonymous users.</div>
                        </div>
                    </div>
                </div>
                <div><input type="submit" value="Make Changes"></div>
            </form>
            <%
        }
    }
}

%><%@include file="group-footer.jsp"%>