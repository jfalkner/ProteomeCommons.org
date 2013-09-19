<%-- 
    Document   : reports
    Created on : Oct 20, 2008, 6:27:59 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, java.sql.*, org.proteomecommons.mysql.*, org.proteomecommons.www.user.*, org.proteomecommons.www.report.*, java.math.*, org.tranche.*, org.tranche.util.*, org.proteomecommons.www.news.*, org.proteomecommons.www.link.*, org.proteomecommons.www.publication.*, org.proteomecommons.www.tool.*, org.proteomecommons.www.data.*, org.proteomecommons.www.notification.*"%><%
request.setAttribute("pageTitle", "Reports");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

if (request.getParameter("action") != null) {
    try {
    String action = request.getParameter("action");
    if (action.equals("clear") || action.equals("agree")) {
        // get a set of report IDs
        Set <Integer> reportIDSet = new HashSet <Integer> ();
        for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
            String parameterName = (String)e.nextElement();
            if (parameterName.startsWith("report")) {
                try {
                    if (request.getParameter(parameterName).equals("true")) {
                        reportIDSet.add(Integer.valueOf(parameterName.substring(6)));
                    }
                } catch (Exception ex) {}
            }
        }
        // switch to report list
        List <Integer> reportIDList = new LinkedList <Integer> ();
        for (Integer reportID : reportIDSet) {
            reportIDList.add(reportID);
        }
        // get the reports
        List <Report> reports = ReportUtil.getReports(reportIDList);
        
        if (action.equals("clear")) {
            for (Report report : reports) {
                if (!MySQLDatabaseUtil.executeUpdate("UPDATE report SET status = 'Cleared' WHERE reportID = '"+report.reportID+"' LIMIT 1;")) {
                    throw new Exception("Could not update database.");
                } else {
                    report.status = "Cleared";
                    // send email and notification to person that submitted report
                    //EmailUtil.sendEmail("Bad Content Report Update", new String[] {report.getUser().email}, "ProteomeCommons.org User,\n\nYou submitted a report of bad/illegal content against " + report.link + " on " + report.date + ".\n\nThis message is to inform you that the administration team at ProteomeCommons did not agree with you, and the report has been cleared. No action will be taken.\n\nThis email is for notification only. Replies will not be read.");
                    NotificationUtil.addUserNotification(MySQLDatabaseUtil.formatTextFromDatabase("In a report you submitted against " + report.link + ", the administration team at ProteomeCommons did not agree with you, and the report has been cleared. No action will be taken.").replace("&quot;", "\""), report.userID);
                    // send email and notification to person that submitted object
                    //EmailUtil.sendEmail("Bad Content Report Update", new String[] {report.getLinkUser().email}, "ProteomeCommons.org User,\n\nA submission of bad/illegal content was made against an item that you added: " + report.link + " on " + report.date + ".\n\nThis message is to inform you that the administration team at ProteomeCommons did not agree with the complaint, and the report has been cleared. No action will be taken.\n\nThis email is for notification only. Replies will not be read.");
                    NotificationUtil.addUserNotification(MySQLDatabaseUtil.formatTextFromDatabase("In a report submitted against an item that you added: " + report.link + ", the administration team at ProteomeCommons did not agree with the complaint, and the report has been cleared. No action will be taken.").replace("&quot;", "\""), report.linkUserID);
                }
            }
        } else if (action.equals("agree")) {
            for (Report report : reports) {
                if (!MySQLDatabaseUtil.executeUpdate("UPDATE report SET status = 'Agreed' WHERE reportID = '"+report.reportID+"' LIMIT 1;")) {
                    throw new Exception("Could not update database.");
                } else {
                    if (!MySQLDatabaseUtil.executeUpdate("UPDATE " + report.fieldTable + " SET active = '0' WHERE " + report.fieldName + " = '" + report.fieldID + "' LIMIT 1;")) {
                        throw new Exception("Could not deactivate item in database.");
                    } else {
                        try {
                            if (report.fieldTable.equals("news")) {
                                NewsUtil.getNews(Integer.valueOf(report.fieldID)).active = false;
                            } else if (report.fieldTable.equals("link")) {
                                LinkUtil.getLink(Integer.valueOf(report.fieldID)).active = false;
                            } else if (report.fieldTable.equals("publication")) {
                                PublicationUtil.getPublication(Integer.valueOf(report.fieldID)).active = false;
                            } else if (report.fieldTable.equals("tool")) {
                                ToolUtil.getTool(Integer.valueOf(report.fieldID)).active = false;
                            } else if (report.fieldTable.equals("data")) {
                                DataUtil.getData(Integer.valueOf(report.fieldID)).active = false;
                            }
                        } catch (Exception e) {
                            throw new Exception("Could not deactivate item in memory.");
                        }
                        report.status = "Agreed";
                        // send email and notification to person that submitted report
                        //EmailUtil.sendEmail("Bad Content Report Update", new String[] {report.getUser().email}, "ProteomeCommons.org User,\n\nYou submitted a report of bad/illegal content against " + report.link + " on " + report.date + ".\n\nThis message is to inform you that the administration team at ProteomeCommons has agreed with you, and the item has been removed from ProteomeCommons.\n\nThis email is for notification only. Replies will not be read.");
                        NotificationUtil.addUserNotification(MySQLDatabaseUtil.formatTextFromDatabase("In a report you submitted against " + report.link + ", the administration team at ProteomeCommons has agreed with you, and the item has been removed from ProteomeCommons.").replace("&quot;", "\""), report.userID);
                        // send email and notification to person that submitted object
                        //EmailUtil.sendEmail("Bad Content Report Update", new String[] {report.getLinkUser().email}, "ProteomeCommons.org User,\n\nA submission of bad/illegal content was made against an item that you added: " + report.link + ".\n\nThis message is to inform you that the administration team at ProteomeCommons agreed with the complaint, and the item has been removed from ProteomeCommons.\n\nThis email is for notification only. Replies will not be read.");
                        NotificationUtil.addUserNotification(MySQLDatabaseUtil.formatTextFromDatabase("In a report submitted against an item that you added: " + report.link + ", the administration team at ProteomeCommons agreed with the complaint, and the item has been removed from ProteomeCommons.").replace("&quot;", "\""), report.linkUserID);
                    }
                }
            }
        }
    }
    } catch (Exception e) {
        %>Error: <%=e.getMessage()%><%
    }
}

String filter = "";
if (request.getParameter("filter") != null) {
    try {
        filter = request.getParameter("filter");
    } catch (Exception e) {}
}
int count = ReportUtil.getReportCount(filter);
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
String orderBy = "date";
if (request.getParameter("orderBy") != null) {
    try {
        orderBy = request.getParameter("orderBy");
    } catch (Exception e) {}
}
%>
<form action="reports.jsp" method="post" id="reportsForm">
<div class="table">
    <div class="table-row">
        <div class="table-cell">
            <input type="text" name="filter" value="<%=filter%>"/><input type="submit" value="Search"/>
            <select name="pageNum" onchange="getObj('reportsForm').submit();">
                <% for (int i = 1; i <= pages; i++) { %>
                    <option value="<%=i%>">Page <%=i%></option>
                <% } %>
            </select>
            <select name="orderBy" onchange="getObj('reportsForm').submit();">
                <option value="date"<% if (orderBy.equals("date")) { %> selected<% } %>>Sort By Date</option>
                <option value="status"<% if (orderBy.equals("status")) { %> selected<% } %>>Sort By Status</option>
                <option value="link"<% if (orderBy.equals("link")) { %> selected<% } %>>Sort By Item</option>
            </select>
        </div><div class="table-cell">
            <div>To <b>clear</b> a report is to say that you do not agree that the item in question needs to be removed from the site.</div>
            <div>To <b>agree</b> with a report is to say that you agree with the user and the item in question should be removed from the site.</div>
        </div>
    </div>
</div>
<div class="table">
    <div class="table-row">
        <div class="table-hcell"></div>
        <div class="table-hcell">Status</div>
        <div class="table-hcell">Subject</div>
        <div class="table-hcell">Submitted By</div>
        <div class="table-hcell">Reason</div>
        <div class="table-hcell">Date</div>
    </div>
    <%
    for (Report r : ReportUtil.getReports(filter, orderBy, "DESC", pageNum, perPage)) {
        %>
        <div class="table-row">
            <div class="table-cell" style="text-align: center;"><% if (r.status.equals("Under Review")) { %><input type="checkbox" name="report<%=r.reportID%>" value="true"/><% } %></div>
            <div class="table-cell" style="text-align: center;"><%=r.status%></div>
            <div class="table-cell" style="text-align: center;"><%=MySQLDatabaseUtil.formatTextFromDatabase(r.link).replace("&quot;", "\"")%></div>
            <div class="table-cell" style="text-align: center;"><a href="@baseURLmember.jsp?i=<%=r.userID%>"><%=r.getUser().unique_name%></a></div>
            <div class="table-cell" style="text-align: center;"><%=r.reason%></div>
            <div class="table-cell" style="text-align: center;"><%=r.date%></div>
        </div>
        <%
    }
    %>
</div>
<select name="action" onchange="getObj('reportsForm').submit();">
    <option value="">[ Select an Action ]</option>
    <option value="clear">Clear Selected</option>
    <option value="agree">Agree With Selected</option>
</select>
</form>
<%@include file="footer.jsp"%>