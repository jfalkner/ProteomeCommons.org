<%-- 
    Document   : publications-add
    Created on : Sep 5, 2008, 3:02:32 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*,java.sql.*,org.proteomecommons.mysql.*, org.proteomecommons.www.reference.*"%><%
request.setAttribute("pageTitle", "Publications - Add");
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

String title = "";
String description = "";
String citation = "";
String url = "";

String error = null;
boolean show = true;
if (request.getParameter("title") != null) {
    try {
        title = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("title"));
        description = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("description"));
        citation = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("citation"));
        url = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("url"));
        
        if (title.equals("")) {
            throw new Exception("Title cannot be blank.");
        }
        
        if (description.equals("")) {
            throw new Exception("Description cannot be blank.");
        }
        
        if (citation.equals("")) {
            throw new Exception("Citation cannot be blank.");
        }
        
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT title,url FROM publication WHERE title = '"+title+"' OR url = '"+url+"' LIMIT 1;");
            if (rs.next()) {
                if (rs.getString("title").equals(title)) {
                    throw new Exception("The given Title is already taken.");
                } else if (!url.equals("") && rs.getString("url").equals(url)) {
                    throw new Exception("The given URL is already a publication.");
                }
            }
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        
        // add the publication
        if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO publication (title, description, citation, url, userID, date, active) VALUES ('"+title+"', '"+description+"', '"+citation+"', '"+url+"', '"+user.userID+"', '"+MySQLDatabaseUtil.getTimestamp()+"', '1');")) {
            throw new Exception("Could not add record to database.");
        }
        
        // get the publication ID
        int publicationID = 0;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT publicationID FROM publication WHERE title = '"+title+"';");
            rs.next();
            publicationID = rs.getInt("publicationID");
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
                ReferenceUtil.addReference("publication", "publicationID", publicationID, fieldTable, fieldName, Integer.valueOf(fieldID));
            }
        }        
        %>
        <p>Your publication has been submitted.</p>
        <script language="javascript">goTo('publication.jsp?i=<%=publicationID%>');</script>
        <%
        show = false;
    } catch (Exception e) {
        error = e.getMessage();
    }
}

if (error != null) { %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% }
if (show) {
    %>
    <form action="publications-add.jsp" method="post">
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Title</div>
                <div class="table-cell"><input type="text" name="title" maxlength="100" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(title)%>"></div>
                <div class="table-cell">
                    <div>Maximum length: 100 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">Description</div>
                <div class="table-cell"><textarea name="description"><%=MySQLDatabaseUtil.formatTextFromDatabase(description)%></textarea></div>
            </div><div class="table-row">
                <div class="table-cell">Citation</div>
                <div class="table-cell"><textarea name="citation"><%=MySQLDatabaseUtil.formatTextFromDatabase(citation)%></textarea></div>
            </div><div class="table-row">
                <div class="table-cell">URL</div>
                <div class="table-cell"><input type="text" name="url" maxlength="255" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(url)%>"></div>
                <div class="table-cell">
                    <div>Maximum length: 255 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">
                    References
                    <div><a href="help/references.jsp">What are references?</a></div>
                </div>
                <div class="table-cell"><%@include file="scripts/references/add/addReferences.jsp"%></div>
            </div><div class="table-row">
                <div class="table-cell"><input type="submit" value="Add Publication"></div>
            </div>
        </div>
    </form>
<% } %>
<%@include file="footer.jsp"%>