<%-- 
    Document   : messages-compose
    Created on : Sep 5, 2008, 3:23:47 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.proteomecommons.www.group.*, org.proteomecommons.www.user.*, org.proteomecommons.www.message.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

request.setAttribute("messagesPageTitle", "Compose a Message");

%><%@include file="messages-header.jsp"%>
<%
int threadID = -1;
String subject = "";
String message = "";
boolean show = true;
if (request.getParameter("message") != null) {
    try {
        try {
            threadID = Integer.valueOf(MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("threadID")));
        } catch (Exception e) {
            throw new Exception("Bad thread ID.");
        }
        subject = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("subject"));
        message = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("message"));
        
        if (threadID < 0) {
            throw new Exception("Invalid thread ID.");
        }
        
        if (subject.equals("")) {
            throw new Exception("Subject cannot be blank.");
        }
        
        if (message.equals("")) {
            throw new Exception("Message cannot be blank.");
        }
        
        // get who we're sending to
        Set <Integer> toSend = new HashSet <Integer> ();
        for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
            String parameterName = (String)e.nextElement();
            if (parameterName.startsWith("torefName")) {

                String millis = parameterName.substring(9);
                String fieldTable = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("torefTable"+millis));
                String fieldID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("torefValue"+millis));

                if (fieldTable.equals("user")) {
                    try {
                        int userID = Integer.valueOf(fieldID);
                        // do not send to self
                        if (userID == user.userID) {
                            %>Warning: cannot send message to yourself.<%
                            continue;
                        }
                        toSend.add(userID);
                    } catch (Exception ex) {
                        %><div>Warning: possible bad parameter.</div><%
                    }
                } else if (fieldTable.equals("groups")) {
                    try {
                        List <GroupMember> groupmembers = GroupUtil.getGroup(Integer.valueOf(fieldID)).getGroupMembers();
                        for (GroupMember gm : groupmembers) {
                            // do not send to self
                            if (gm.userID == user.userID) {
                                continue;
                            }
                            toSend.add(gm.userID);
                        }
                    } catch (Exception ex) {
                        %><div>Warning: possible bad parameter.</div><%
                    }
                }
            }
        }
        
        if (toSend.size() == 0) {
            throw new Exception("Must select at least one person to send to, not including yourself.");
        }

        // create the message
        if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO message (threadID, message, date, userID, subject) VALUES ('"+threadID+"', '"+message+"', '"+MySQLDatabaseUtil.getTimestamp()+"', '"+user.userID+"', '"+subject+"');")) {
            throw new Exception("Could not add message to database.");
        }

        // make sure the update is made in memory
        user.addSentMessageThread(threadID);

        // consider send a success
        show = false;

        // get the messageID
        int messageID = -1;
        {
            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT messageID FROM message WHERE userID = '"+user.userID+"' ORDER BY messageID DESC LIMIT 1;");
                rs.next();
                messageID = rs.getInt("messageID");
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }

        // add the message to the thread in memory
        if (MessageUtil.isMessageThreadInCache(threadID)) {
            MessageUtil.getMessageThread(threadID).addMessage(messageID);
        }
        
        // add references
        for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
            String parameterName = (String)e.nextElement();
            if (parameterName.startsWith("refName")) {
                String millis = parameterName.substring(7);
                String fieldName = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter(parameterName));
                String fieldTable = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("refTable"+millis));
                String fieldID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("refValue"+millis));
                if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO reference (fromTable, fromField, fromID, toTable, toField, toID) VALUES ('message', 'messageID', '"+messageID+"', '"+fieldTable+"', '"+fieldName+"', '"+fieldID+"');")) {
                    %>Warning: could not add a reference.<%
                }
            }
        }

        // actually send
        Set <Integer> sentTo = new HashSet <Integer> (), notSentTo = new HashSet <Integer> ();
        for (Integer userID : toSend) {
            if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO message_recipient (messageID, userID, isRead, active) VALUES ('"+messageID+"', '"+userID+"', '0', '1');")) {
                notSentTo.add(userID);
            } else {
                sentTo.add(userID);
                if (UserUtil.isInCache(userID)) {
                    UserUtil.getUser(userID).addReceivedMessageThread(threadID);
                }
            }
        }

        // update the message thread's to and from lists
        if (MessageUtil.isMessageThreadInCache(threadID)) {
            MessageUtil.getMessageThread(threadID).reloadFromUsers();
            MessageUtil.getMessageThread(threadID).reloadToUsers();
        }

        // results
        if (!notSentTo.isEmpty()) { 
            %>Warning: your message was not sent to <b><%=notSentTo.size()%></b> people.<%
        }
        if (!sentTo.isEmpty()) {
            %>Your message has been sent to <b><%=Util.formatNumber(sentTo.size())%></b> people.<%
        }
        %>
        <script language="javascript">goTo('messages-sent.jsp');</script>
        <%
    } catch (Exception e) {
        %>Error: <%=e.getMessage()%><%
    }
}

if (show) {  %>
    <form action="messages-compose.jsp" method="post">
        <%
        // reply
        if (request.getParameter("i") != null) {
            %><input type="hidden" name="threadID" value="<%=request.getParameter("i")%>" /><%
        } else {
            // get the next threadID
            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT threadID FROM message ORDER BY threadID DESC LIMIT 1;");
                rs.next();
                int t = rs.getInt("threadID");
                %><input type="hidden" name="threadID" value="<%=(t+1)%>" /><%
            } catch (Exception e) {
                %><input type="hidden" name="threadID" value="0" /><%
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
        %>
        <div style="font-weight: bold;">Items with an asterisk (*) are required.</div>
        <div class="table">
            <div class="table-row">
                <div class="table-cell">*To</div>
                <div class="table-cell">
                    <% 
                    try {
                        List <Integer> toUsers = new LinkedList <Integer> (), toGroups = new LinkedList <Integer> ();
                        if (request.getParameter("i") != null) {
                            try {
                                MessageThread thread = MessageUtil.getMessageThread(Integer.valueOf(request.getParameter("i")));
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
                                    toUsers.add(i);
                                }
                            } catch (Exception e) {
                            }
                        } else if (request.getMethod().equals("GET")) {
                            Set <Integer> userIDSet = new HashSet <Integer> (), groupIDSet = new HashSet <Integer> ();
                            for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
                                String parameterName = (String)e.nextElement();
                                if (parameterName.startsWith("tou")) {
                                    try {
                                       userIDSet.add(Integer.valueOf(request.getParameter(parameterName)));
                                    } catch (Exception ex) {
                                    }
                                } else if (parameterName.startsWith("tog")) {
                                    try {
                                       groupIDSet.add(Integer.valueOf(request.getParameter(parameterName)));
                                    } catch (Exception ex) {
                                    }
                                }
                            }
                            for (Integer userID : userIDSet) {
                                toUsers.add(userID);
                            }
                            for (Integer groupID : groupIDSet) {
                                toGroups.add(groupID);
                            }
                        }

                        int toUsersCount = 0;
                        for (Integer userID : toUsers) {
                            request.setAttribute("torefName" + toUsersCount, "userID");
                            request.setAttribute("torefTable" + toUsersCount, "user");
                            request.setAttribute("torefValue" + toUsersCount, userID);
                            toUsersCount++;
                        }

                        int toGroupsCount = 0;
                        for (Integer groupID : toGroups) {
                            request.setAttribute("torefName" + toGroupsCount, "groupID");
                            request.setAttribute("torefTable" + toGroupsCount, "groups");
                            request.setAttribute("torefValue" + toGroupsCount, groupID);
                            toGroupsCount++;
                        }
                    } catch (Exception ex) {
                        %>Error: <%=ex.getMessage()%><%
                    }
                    
                    request.setAttribute("prefix", "to");
                    request.setAttribute("referencesHeight", "150px");
                    %><%@include file="scripts/references/add/addUserOrGroupReferences.jsp"%><% 
                    request.removeAttribute("referencesHeight");
                    request.removeAttribute("prefix");
                    %>
                </div>
            </div><div class="table-row">
                <div class="table-cell">*Subject</div>
                <%
                if (request.getParameter("i") != null) { 
                    try {
                        subject = MessageUtil.getMessageThread(Integer.valueOf(request.getParameter("i"))).getLatestMessage().subject;
                        if (!subject.startsWith("re: ")) {
                            subject = "re: " + subject;
                        }
                    } catch (Exception e) {
                    }
                } else if (request.getParameter("s") != null && request.getMethod().equals("GET")) {
                    subject = request.getParameter("s");
                    if (!subject.startsWith("re: ")) {
                        subject = "re: " + subject;
                    }
                }
                %>
                <div class="table-cell"><input type="text" name="subject" value="<%=subject%>" style="width: 100%;" maxlength="150"></div>
            </div><div class="table-row">
                <div class="table-cell">*Message</div>
                <div class="table-cell"><textarea name="message" rows="15" style="width: 100%;"><%=MySQLDatabaseUtil.formatTextFromDatabase(message)%></textarea></div>
            </div><div class="table-row">
                <div class="table-cell">References</div>
                <div class="table-cell">
                    <script language="javascript">
                        function toggleReferences() {
                            hide('composeMessageShowReferences');
                            show('composeMessageAddReferences');
                        }
                    </script>
                    <div id="composeMessageShowReferences"><a href="javascript:toggleReferences();">+ Add references</a></div>
                    <div id="composeMessageAddReferences" style="display: none;">
                        <%
                        request.setAttribute("referencesHeight", "150px");
                        %>
                        <%@include file="scripts/references/add/addReferences.jsp"%>
                        <%
                        request.removeAttribute("referencesHeight");
                        %>
                    </div>
                </div>
            </div><div class="table-row">
                <div class="table-cell"><input type="submit" value="Send"></div>
            </div>
        </div>
    </form>
<% } %>
<%@include file="messages-footer.jsp"%>