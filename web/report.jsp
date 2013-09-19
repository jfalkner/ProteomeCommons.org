<%-- 
    Document   : report
    Created on : Oct 3, 2008, 4:48:47 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*, org.proteomecommons.mysql.*, java.util.*, org.tranche.util.*, org.tranche.*, org.proteomecommons.www.notification.*"%><%
request.setAttribute("pageTitle", "Report");
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

if (user != null) {
    boolean show = true;
    if (request.getParameter("reason") != null) {
        try {
            String reason = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("reason"));
            String table = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("table"));
            String field = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("field"));
            String id = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("id"));
            String link = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("link"));
            String linkUserID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("linkUserID"));

            if (reason.equals("")) {
                throw new Exception("Reason cannot be blank.");
            }
            if (table.equals("") || field.equals("") || id.equals("")) {
                throw new Exception("There was a programming problem.");
            }

            // check for duplicate
            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT reportID FROM report WHERE fieldTable = '"+table+"' AND fieldName = '"+field+"' AND fieldID = '"+id+"' AND userID = '"+user.userID+"';");
                if (rs.next()) {
                    throw new Exception("Duplicate report submission.");
                }
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }

            // submit
            if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO report (fieldTable, fieldName, fieldID, link, linkUserID, userID, reason, date, status) VALUES ('"+table+"', '"+field+"', '"+id+"', '"+link+"', '"+linkUserID+"', '"+user.userID+"', '"+reason+"', '"+MySQLDatabaseUtil.getTimestamp()+"', 'Under Review');")) {
                throw new Exception("Could not submit report.");
            } else {
                // send to admins
                //EmailUtil.sendEmail("Bad Content Report", ConfigureTranche.getAdminEmailAccounts(), "A report was filed by <a href=\"@baseURLmember.jsp?i="+user.userID+"\">"+user.unique_name+"</a> against "+link+"\n\nThis email is for notification only. Replies will not be read.");
                user.addNotification(MySQLDatabaseUtil.formatTextFromDatabase("You submitted that an item contains bad/illegal content: " + link + ".").replace("&quot;", "\""));
                // send email and notification to person to whom the report is directed
                //EmailUtil.sendEmail("Bad Content Report", new String[] {UserUtil.getUser(Integer.valueOf(linkUserID)).email}, "ProteomeCommons.org User,\n\nA submission of bad/illegal content was made against an item that you added: " + link + ".\n\nThe reason given is as follows: \""+ reason +"\"\n\nThis report will be reviewed by the ProteomeCommons.org administration team.\n\nThis email is for notification only. Replies will not be read.");
                NotificationUtil.addUserNotification(MySQLDatabaseUtil.formatTextFromDatabase("A submission of bad/illegal content was made against an item that you added: " + link + ".").replace("&quot;", "\""), Integer.valueOf(linkUserID));
                %>Thank you for bringing that to our attention. We will review the matter and make a decision shortly.<br/>Back to <%=request.getParameter("link")%><%
                show = false;
            }
        } catch (Exception e) {
            %>Error: <%=e.getMessage()%><%
        }
    }

    if (show) {
        %>
        <form action="report.jsp" method="post">
            <textarea name="link" style="display: none;"><%=request.getParameter("link")%></textarea>
            <input type="hidden" name="linkUserID" value="<%=request.getParameter("linkUserID")%>"/>
            <input type="hidden" name="table" value="<%=request.getParameter("table")%>"/>
            <input type="hidden" name="field" value="<%=request.getParameter("field")%>"/>
            <input type="hidden" name="id" value="<%=request.getParameter("id")%>"/>
            <div>Report Bad/Illegal Content of <%=request.getParameter("link")%></div>
            <div class="table">
                <div class="table-row">
                    <div class="table-cell">Reason:</div>
                    <div class="table-cell"><textarea name="reason"></textarea></div>
                </div>
            </div>
            <div><input type="submit" value="Report"/></div>
        </form>
        <%
    }
}

%><%@include file="footer.jsp"%>