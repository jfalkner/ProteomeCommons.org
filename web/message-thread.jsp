<%-- 
    Document   : message-thread
    Created on : Oct 16, 2008, 4:17:14 AM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.proteomecommons.www.group.*, org.proteomecommons.www.user.*, org.proteomecommons.www.message.*, org.proteomecommons.mysql.*, org.proteomecommons.www.reference.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

MessageThread thread = null;
try {
    thread = MessageUtil.getMessageThread(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (thread == null) {
    request.setAttribute("messagesPageTitle", "Message Thread Not Found");
} else {
    request.setAttribute("messagesPageTitle", "Message Thread");
}

%><%@include file="messages-header.jsp"%><%

if (thread != null && user != null) {
    Set <Integer> userIDSet = new HashSet <Integer> ();
    for (Integer userID : thread.getFromUserIDs()) {
        if (userID != user.userID) {
            userIDSet.add(userID);
        }
    }
    for (Integer userID : thread.getToUserIDs()) {
        if (userID != user.userID) {
            userIDSet.add(userID);
        }
    }
    List <Integer> userIDList = new LinkedList <Integer> ();
    for (Integer i : userIDSet) {
        userIDList.add(i);
    }
    %>
    <div style="margin-bottom: 5px; padding-bottom: 5px; border-bottom: 1px solid #333;">
        <% try { %>
            Between <a href="member.jsp?i=<%=user.userID%>">You</a><% for (int i = 0; i < userIDList.size()-1; i++) { %>, <a href="member.jsp?i=<%=UserUtil.getUser(userIDList.get(i)).userID%>"><%=UserUtil.getUser(userIDList.get(i)).unique_name%></a><% } %> and <a href="member.jsp?i=<%=UserUtil.getUser(userIDList.get(userIDList.size()-1)).userID%>"><%=UserUtil.getUser(userIDList.get(userIDList.size()-1)).unique_name%></a>.
        <% } catch (Exception e) {} %>
    </div>
    <div style="padding-bottom: 10px;">
        <input type="button" onclick="goTo('messages-compose.jsp?i=<%=thread.threadID%>');" value="Reply<% if (userIDList.size() > 1) {%> To All<% }%>" /><%
        %><input type="button" onclick="goTo('messages.jsp?thread<%=thread.threadID%>=true&action=unread');" value="Mark as Unread" />
    </div>
    <div class="table">
        <%
        String color1 = "#fff", color2 = "#eee";
        String color = color1;
        for (Message message : thread.getMessages()) {
            List <Reference> references = message.getReferences();
            String displayColor = color;
            if (message.isRecipient(user.userID)) { 
                if (!message.getRecipient(user.userID).isRead) {
                    displayColor = "#ccf";
                }
            }
            %>
            <div class="table-row" style="padding: 5px; background-color: <%=displayColor%>;">
                <div class="table-cell" style="width: 150px;">
                    <div><a href="member.jsp?i=<%=message.getUser().userID%>"><% if (message.getUser().userID != user.userID) { %><%=message.getUser().unique_name%><% } else { %>You<% } %></a></div>
                    <div style="padding-top: 2px; font-size: 7pt; color: #666;"><%=message.date%></div>
                    <% if (message.getUser().userID != user.userID && userIDList.size() > 1) { %>
                        <div><a href="messages-compose.jsp?tou=<%=message.getUser().userID%>&s=<%=Util.getWebSafeString(MySQLDatabaseUtil.formatTextFromDatabase(thread.getFirstMessage().subject))%>">Reply</a></div>
                    <% } %>
                </div>
                <div class="table-cell">
                    <div>
                        <%
                        // try to set all the messages in this thread as read
                        if (user.userID != message.userID) {
                            message.getRecipient(user.userID).markAsRead(true);
                        }
                        %>
                    </div>
                    <div style="font-weight: bold; font-size: 10pt;"><%=message.subject%></div>
                    <div style="font-size: 10pt; padding: 5px 0 5px 0; font-family: monospaced;"><%=message.message%></div>
                    <% if (!references.isEmpty()) { %>
                        <div class="table"><div class="table-row">
                            <div class="table-cell" style="font-weight: bold; width: 100px;">References:</div>
                            <div class="table-cell"><% for (Reference r : references) {%><div><%=r.displayTo()%></div><% }%></div>
                        </div></div>
                    <% } %>
                </div>
            </div>
            <%
            if (color.equals(color1)) {
                color = color2;
            } else {
                color = color1;
            }
        }
        %>
    </div>
    <%
}

%><%@include file="messages-footer.jsp"%>