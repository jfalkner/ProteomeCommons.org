<%-- 
    Document   : links-add
    Created on : Sep 5, 2008, 5:42:59 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*,java.sql.*,org.proteomecommons.mysql.*, org.proteomecommons.www.reference.*"%><%
request.setAttribute("pageTitle", "Links - Add");
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

String title = "";
String description = "";
String url = "";

String error = null;
boolean show = true;
if (request.getParameter("title") != null) {
    try {
        title = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("title"));
        description = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("description"));
        url = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("url"));
        
        if (title.equals("")) {
            throw new Exception("Title cannot be blank.");
        }
        
        if (description.equals("")) {
            throw new Exception("Description cannot be blank.");
        }
        
        if (url.equals("")) {
            throw new Exception("URL cannot be blank.");
        }
        
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT title,url FROM link WHERE title = '"+title+"' OR url = '"+url+"' LIMIT 1;");
            if (rs.next()) {
                if (rs.getString("title").equals(title)) {
                    throw new Exception("The given Title is already a link.");
                } else if (rs.getString("url").equals(url)) {
                    throw new Exception("The given URL is already a link.");
                }
            }
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        
        // add the link
        if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO link (title, description, url, userID, date, active) VALUES ('"+title+"', '"+description+"', '"+url+"', '"+user.userID+"', '"+MySQLDatabaseUtil.getTimestamp()+"', '1');")) {
            throw new Exception("Could not add record to database.");
        }
        
        // get the publication ID
        int linkID = 0;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT linkID FROM link WHERE title = '"+title+"';");
            rs.next();
            linkID = rs.getInt("linkID");
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        
        // add references
        for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
            String parameterName = (String)e.nextElement();
            if (parameterName.startsWith("refName")) {
                String millis = parameterName.substring(7);
                String fieldName = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter(parameterName));
                String fieldTable = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("refTable"+millis));
                String fieldID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("refValue"+millis));
                ReferenceUtil.addReference("link", "linkID", linkID, fieldTable, fieldName, Integer.valueOf(fieldID));
            }
        }
        
        %>
        <p>Your link has been submitted.</p>
        <script language="javascript">goTo('link.jsp?i=<%=linkID%>');</script>
        <%
        show = false;
    } catch (Exception e) {
        error = e.getMessage();
    }
}

if (error != null) { %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% }
if (show) {
    %>
    <form action="links-add.jsp" method="post">
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Title</div>
                <div class="table-cell"><input type="text" name="title" maxlength="100" value="<%=title%>"></div>
                <div class="table-cell"><div>Maximum length: 100 characters.</div></div>
            </div><div class="table-row">
                <div class="table-cell">Description</div>
                <div class="table-cell"><textarea name="description"><%=description%></textarea></div>
            </div><div class="table-row">
                <div class="table-cell">URL</div>
                <div class="table-cell"><input type="text" name="url" maxlength="255" value="<%=url%>"></div>
                <div class="table-cell"><div>Maximum length: 255 characters.</div></div>
            </div><div class="table-row">
                <div class="table-cell">References</div>
                <div class="table-cell"><%@include file="scripts/references/add/addReferences.jsp"%></div>
            </div><div class="table-row">
                <div class="table-cell"><input type="submit" value="Add Link"></div>
            </div>
        </div>
    </form>
<% } %>
<%@include file="footer.jsp"%>