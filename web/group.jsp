<%-- 
    Document   : group
    Created on : Aug 20, 2008, 6:40:38 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.www.news.*, java.util.*, org.tranche.util.*, org.proteomecommons.www.user.*, org.proteomecommons.www.group.*, org.proteomecommons.www.reference.*, org.proteomecommons.www.data.*, org.proteomecommons.www.publication.*, org.proteomecommons.www.tool.*, org.proteomecommons.www.link.*, org.proteomecommons.www.notification.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="group-header.jsp"%><%

if (group != null) { 
    %><div class="table"><%
    if (user != null && group.isMember(user.userID)) {
        %>
        <div class="table-row"><div class="table-cell">
            <div>Notifications</div>
            <% 
            List <Notification> notifications = group.getNotifications(0, 10);
            for (Notification n : notifications) {
                %><div style="font-size: 8pt;"><span style="font-size: 7pt;"><%=n.date%></span> - <%=n.notification%></div><%
            }
            %>
        </div>
            <% if (group.getMember(user.userID).isStrictlyAdmin()) { %>
                <div class="table-cell">
                    <div>Actionables</div>
                </div>
            <% } %>
        </div>
        <%
    }
    %>
    <div class="table-row"><div class="table-cell">
        
    </div><div class="table-cell">
        
    </div></div><div class="table-row"><div class="table-cell">
        
    </div><div class="table-cell">
        
    </div></div>
    <%
}

%><%@include file="group-footer.jsp"%>