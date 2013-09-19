<%-- 
    Document   : group-add
    Created on : Sep 10, 2008, 10:33:03 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*"%><%
request.setAttribute("pageTitle", "Group - Add");
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

String name = "";
String description = "";
String privacy = "";

boolean show = true;
if (request.getParameter("name") != null) {
    try {
        name = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("name"));
        description = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("description"));
        privacy = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("privacy"));
        
        if (name.equals("")) {
            throw new Exception("Name cannot be blank.");
        }
        
        if (description.equals("")) {
            throw new Exception("Description cannot be blank.");
        }
        
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT groupID FROM groups WHERE name = '"+name+"';");
            if (rs.next()) {
                throw new Exception("The given Nsme is already a group name.");
            }
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        
        // derive privacy flags
        int private_group = 0, private_name = 0;
        if (privacy.equals("private_group")) {
            private_group = 1;
        } else if (privacy.equals("private_name")) {
            private_group = 1;
            private_name = 1;
        }
        
        // add the group
        if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO groups (name, description, date_created, created_userID, active, private_group, private_name) VALUES ('"+name+"', '"+description+"', '"+MySQLDatabaseUtil.getTimestamp()+"', '"+user.userID+"', '1', '"+private_group+"', '"+private_name+"');")) {
            throw new Exception("Could not add record to database.");
        }

        // get the gorup ID
        int groupID = 0;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT groupID FROM groups WHERE name = '"+name+"';");
            rs.next();
            groupID = rs.getInt("groupID");
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
                      
        // add the creating user to the group with all permissions
        if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO group_user (groupID, userID, permission_edit, permission_invite_user, permission_remove_user, permission_modify_permissions, permission_remove_group, permission_import_group, permission_see_subgroups, permission_see_news, permission_see_tools, permission_see_links, permission_see_publications, permission_see_data, permission_see_users, permission_see_group, permission_annotate_data, permission_import_data, permission_import_publication, permission_import_tool, permission_import_news, permission_import_link, date_created) VALUES ('"+groupID+"', '"+user.userID+"', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '"+MySQLDatabaseUtil.getTimestamp()+"');")) {
            throw new Exception("Could not add user record to database.");
        }
        
        %>
        <p>Your group has been created.</p>
        <script language="javascript">goTo('group.jsp?i=<%=groupID%>');</script>
        <%
        show = false;
    } catch (Exception e) {
        %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(e.getMessage())%><%
    }
}

if (show) {
    %>
    <form action="group-add.jsp" method="post">
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Name</div>
                <div class="table-cell"><input type="text" name="name" maxlength="100" value="<%=name%>"></div>
                <div class="table-cell"><div>Maximum length: 100 characters.</div></div>
            </div><div class="table-row">
                <div class="table-cell">Description</div>
                <div class="table-cell"><textarea name="description"><%=description%></textarea></div>    
                <div class="table-cell"></div>
            </div><div class="table-row">
                <div class="table-cell">Privacy</div>
                <div class="table-cell">
                    <select name="privacy">
                        <option value="public"<% if (privacy.equals("public")) { %> selected<% } %>>Public</option>
                        <option value="private_group"<% if (privacy.equals("private_group")) { %> selected<% } %>>Private Group, Public Name</option>
                        <option value="private_name"<% if (privacy.equals("private_name")) { %> selected<% } %>>Private Group, Private Name</option>
                    </select>
                </div>
                <div class="table-cell">
                    <div>A <b>public</b> group has no restrictions on who can see the information. Any anonymous person can see all group activities, but only members with appropriate permissions can participate.</div>
                    <div>A <b>private group, public name</b> group keeps all group information except name and description to the members of the group.</div>
                    <div>A <b>private group, private name</b> group keeps the group completely hidden to anonymous users.</div>
                </div>
            </div>
        </div>
        <div><input type="submit" value="Add Group"></div>
    </form>
<% } %>
<%@include file="footer.jsp"%>