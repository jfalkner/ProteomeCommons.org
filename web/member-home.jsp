<%-- 
    Document   : member-home
    Created on : Sep 6, 2008, 2:10:56 AM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, java.sql.*, org.proteomecommons.mysql.*, org.proteomecommons.www.notification.*, org.proteomecommons.www.message.*, org.proteomecommons.www.group.*"%><%
request.setAttribute("pageTitle", "Home - @user:unique_name");
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%>
<% if (user != null) { %>
    <div class="table"><div class="table-row"><div class="table-cell">
        <div>Notifications</div>
        <% 
        List <Notification> notifications = user.getNotifications(0, 10);
        for (Notification n : notifications) {
            %><div><span style="font-size: 7pt;"><%=n.date%></span> - <%=n.notification%></div><%
        }
        %>
    </div><div class="table-cell">
        <div>Actionables</div>
        <% if (user.hasNewMessages()) {%><div><a href="messages.jsp">You have unread messages.</a></div><% }%>
        <% 
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM group_join WHERE userID = '"+user.userID+"' AND requestUserID != '"+user.userID+"';");
            while (rs.next()) {
                Group g = GroupUtil.getGroup(rs.getInt("groupID"));
                User u = UserUtil.getUser(rs.getInt("requestUserID"));
                %><div>You have been invited to join <a href="group.jsp?i=<%=g.groupID%>"><%=g.name%></a> by <a href="member.jsp?i=<%=u.userID%>"><%=u.unique_name%></a>. <a href="group-accept.jsp?i=<%=g.groupID%>&accept=true">Accept</a> - <a href="group-accept.jsp?i=<%=g.groupID%>&accept=false">Decline</a></div><%
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        %>
    </div></div></div>
<% } %>
<%@include file="footer.jsp"%>