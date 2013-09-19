<%-- 
    Document   : member.jsp
    Created on : Aug 20, 2008, 6:59:04 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.www.news.*, java.util.*, org.tranche.util.*, org.proteomecommons.www.user.*, org.proteomecommons.www.group.*, org.proteomecommons.www.reference.*, org.proteomecommons.www.data.*, org.proteomecommons.www.publication.*, org.proteomecommons.www.tool.*, org.proteomecommons.www.link.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

User member = null;
try {
    member = UserUtil.getUser(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (member == null) {
    request.setAttribute("pageTitle", "Member Not Found");
} else {
    request.setAttribute("pageTitle", "Member - " + member.unique_name);
}
request.setAttribute("showPageTitle", "false");

%><%@include file="header.jsp"%><%

if (member != null) {
    %>
    <div class="twoColumnLayout"><div class="twoColumnLayoutRow">
        <div class="leftColumn">
            <% if (member != null) { %>
                <div class="actions">
                    <div class="left-title">Actions:</div>
                    <div class="left-body">
                        <% if (user != null && member.userID == user.userID) { %>
                            <div><a href="member-edit.jsp">Edit</a></div>
                            <div><a href="member-password.jsp">Change Password</a></div>
                            <div><a href="member-email.jsp">Change Email</a></div>
                        <% } else { %>
                            <div><a href="messages-compose.jsp?to=<%=member.userID%>">Send Message</a></div>
                        <% } %>
                    </div>
                </div>
            <% } %>
            <div class="groups" style="padding-top: 10px;">
                <div class="left-title">Groups:</div>
                <div class="left-body">
                    <% for (Group group : member.getGroups()) { 
                        if (group.isNamePrivate() && (user == null || (user != null && !group.isMember(user.userID)))) { continue; }
                        %>
                        <div><a href="group.jsp?i=<%=group.groupID%>"><%=group.name%></a><% if (group.getMember(member.userID).isStrictlyAdmin()) { %> (Director)<% } %></div>
                    <% } %>
                </div>
            </div>
        </div>
        <div class="rightColumn">
            <div class="rightColumnTitle"><%=member.unique_name%></div>
            <div class="rightColumnBody">
                <div class="table" style="padding-top: 10px;">
                    <div class="table-row">
                        <div class="table-cell">
                            <div><%=member.prefix%> <%=member.first_name%> <%=member.middle_name%> <%=member.last_name%> <%=member.suffix %></div>
                            <div>Phone: <%=member.phone%></div>
                            <div><%=member.email%></div>
                        </div><div class="table-cell">
                            <div><%=member.organization%></div>
                            <div><%=member.department%></div>
                            <div><% if (member.region != null && !member.region.region.equals("")) { %><%=member.region.region%>, <% } %><%=member.country.country%></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div></div>
    <%   
}
%><%@include file="footer.jsp"%>