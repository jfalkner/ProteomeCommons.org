<%-- 
    Document   : messages-inbox
    Created on : Sep 5, 2008, 3:23:33 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.proteomecommons.www.message.*, org.proteomecommons.www.user.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("messagesPageTitle", "Received");

%><%@include file="messages-header.jsp"%><%

if (user != null) {
    
    // handle possible submission
    if (request.getParameter("action") != null) {
        String action = request.getParameter("action");
        
        List <Integer> threadIDs = new LinkedList <Integer> ();
        for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
            String parameterName = (String)e.nextElement();
            if (parameterName.startsWith("thread")) {
                try {
                    if (request.getParameter(parameterName).equals("true")) {
                        threadIDs.add(Integer.valueOf(parameterName.substring(6)));
                    }
                } catch (Exception ex) {
                }
            }
        }
        
        if (action.equals("unread")) { 
            for (Integer threadID : threadIDs) {
                if (MessageUtil.getMessageThread(threadID).getLatestMessage().isRecipient(user.userID)) {
                    MessageUtil.getMessageThread(threadID).getLatestMessage().getRecipient(user.userID).markAsRead(false);
                }
            }
        } else if (action.equals("read")) {
            for (Integer threadID : threadIDs) {
                for (Message m : MessageUtil.getMessageThread(threadID).getMessages()) {
                    if (m.isRecipient(user.userID)) {
                        m.getRecipient(user.userID).markAsRead(true);
                    }
                }
            }
        }
    }
    
    int count = user.getReceivedMessageThreads().size();
    int pageNum = 1;
    if (request.getParameter("pageNum") != null) {
        try {
            pageNum = Integer.valueOf(request.getParameter("pageNum"));
        } catch (Exception e) {}
    }
    int perPage = 10;
    int pages = (int) Math.ceil((double)count/(double)perPage);
    if (pages == 0) {
        pages = 1;
    }
    
    List <MessageThread> threads = user.getReceivedMessageThreads((pageNum-1)*perPage, pageNum*perPage);
    %>
    <script language="javascript">

        var checkBoxCount = 0;
        var lastChecked;

        function clickCheckBox(c) {
            if (getObj('thread'+c).checked) {
                checkBoxCount++;
            } else {
                checkBoxCount--;
                if (checkBoxCount < 0) {
                    checkBoxCount = 0;
                }
            }
            lastChecked = c;

            if (checkBoxCount == 1) {
                getObj('reply').removeAttribute('disabled');
                getObj('action').removeAttribute('disabled');
            } else if (checkBoxCount > 1) {
                getObj('reply').setAttribute('disabled', 'disabled');
                getObj('action').removeAttribute('disabled');
            } else {
                getObj('reply').setAttribute('disabled', 'disabled');
                getObj('action').setAttribute('disabled', 'disabled');
            }
        }

    </script>
    <form action="messages.jsp" method="get" id="browseMessagesForm">
        <div class="table" style="padding-bottom: 10px;">
            <div class="table-row"><div class="table-cell">
                <input type="button" name="reply" id="reply" value="Reply" onclick="goTo('messages-compose.jsp?i='+lastChecked);" disabled />
                <select name="action" id="action" onchange="getObj('browseMessagesForm').submit();" disabled>
                    <option value=""></option>
                    <option value="read">Mark As Read</option>
                    <option value="unread">Mark As Unread</option>
                </select>
            </div><div class="table-cell" style="text-align: right;">
                <select name="pageNum" onchange="getObj('browseMessagesForm').submit();">
                    <% for (int i = 1; i <= pages; i++) { %>
                        <option value="<%=i%>"<% if (pageNum == i) { %> selected<% } %>>Page <%=i%></option>
                    <% } %>
                </select>
            </div></div>
        </div>
        <% 
        if (!threads.isEmpty()) { %>
            <div class="table">
            <% 
            String color1 = "#fff", color2 = "#eee";
            String color = color1;
            for (MessageThread mt : threads) { 
                String from = "";
                if (mt.getFromUsers().size() < 5) {
                    for (User u : mt.getFromUsers()) {
                        from = from + "<a href=\"member.jsp?i="+u.userID+"\">";
                        if (u.userID != user.userID) {
                            from = from + u.unique_name;
                        } else {
                            from = from + "You";
                        }
                        from = from + "</a>, ";
                    }
                    from = from.substring(0, from.length()-2);
                } else {
                    from = mt.getFromUsers().size() + " people";
                }

                String to = "";
                if (mt.getToUsers().size() < 5) {
                    for (User u : mt.getToUsers()) {
                        to = to + "<a href=\"member.jsp?i="+u.userID+"\">";
                        if (u.userID != user.userID) {
                            to = to + u.unique_name;
                        } else {
                            to = to + "You";
                        }
                        to = to + "</a>, ";
                    }
                    to = to.substring(0, to.length()-2);
                } else {
                    to = mt.getToUsers().size() + " people";
                }

                Message latestMessage = mt.getLatestMessage();

                String displayColor = color;
                if (latestMessage.isRecipient(user.userID)) { 
                    if (!latestMessage.getRecipient(user.userID).isRead) {
                        displayColor = "#ccf";
                    }
                }
                %>
                <div class="table-row" style="padding: 5px; background-color: <%=displayColor%>;">
                    <div class="table-cell" style="width: 25px;">
                        <input type="checkbox" name="thread<%=mt.threadID%>" id="thread<%=mt.threadID%>" value="true" onclick="clickCheckBox('<%=mt.threadID%>');" />
                    </div>
                    <div class="table-cell" style="width: 150px;">
                        <div>From: <%=from%></div>
                        <div>To: <%=to%></div>
                        <div style="padding-top: 2px; font-size: 7pt; color: #666;"><%=latestMessage.date%></div>
                    </div>
                    <div class="table-cell">
                        <div style="font-weight: bold; font-size: 11pt;"><a href="message-thread.jsp?i=<%=mt.threadID%>"><%=Util.shorten(latestMessage.subject, 30)%></a></div>
                        <div style="font-size: 8pt; padding-top: 3px;"><%=Util.shorten(latestMessage.message, 50)%></div>
                    </div>
                </div>
                <% 
                if (color.equals(color1)) {
                    color = color2;
                } else {
                    color = color1;
                }
            } %>
            </div>
        </form>
    <% } %>
<% } %>
<%@include file="messages-footer.jsp"%>