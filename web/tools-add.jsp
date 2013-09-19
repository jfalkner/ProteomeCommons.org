<%-- 
    Document   : tools-add
    Created on : Sep 5, 2008, 2:58:59 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*,java.sql.*,org.proteomecommons.mysql.*, org.proteomecommons.www.reference.*"%><%
request.setAttribute("pageTitle", "Tools - Add");
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

String name = "";
String description = "";
String url = "";

String error = null;
boolean show = true;
if (request.getParameter("name") != null) {
    try {
        name = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("name"));
        description = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("description"));
        url = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("url"));
        
        if (name.equals("")) {
            throw new Exception("Name cannot be blank.");
        }
        
        if (description.equals("")) {
            throw new Exception("Description cannot be blank.");
        }
        
        if (url.equals("")) {
            throw new Exception("URL cannot be blank.");
        }
        
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT name,url FROM tool WHERE name = '"+name+"' OR url = '"+url+"' LIMIT 1;");
            if (rs.next()) {
                if (rs.getString("name").equals(name)) {
                    throw new Exception("The given Name is already taken.");
                } else if (rs.getString("url").equals(url)) {
                    throw new Exception("The given URL is already a tool.");
                }
            }
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        
        // add the tool
        if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO tool (name, description, url, userID, date, active) VALUES ('"+name+"', '"+description+"', '"+url+"', '"+user.userID+"', '"+MySQLDatabaseUtil.getTimestamp()+"', '1');")) {
            throw new Exception("Could not add record to database.");
        }
        
        // get the tool ID
        int toolID = 0;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT toolID FROM tool WHERE name = '"+name+"';");
            rs.next();
            toolID = rs.getInt("toolID");
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
                ReferenceUtil.addReference("tool", "toolID", toolID, fieldTable, fieldName, Integer.valueOf(fieldID));
            }
        }
        
        %>
        <p>Your tool has been submitted.</p>
        <script language="javascript">goTo('tool.jsp?i=<%=toolID%>');</script>
        <%
        show = false;
    } catch (Exception e) {
        error = e.getMessage();
    }
}

if (error != null) { %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% }
if (show) {
    %>
    <form action="tools-add.jsp" method="post">
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Name</div>
                <div class="table-cell"><input type="text" name="name" maxlength="100" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(name)%>"></div>
                <div class="table-cell">
                    <div>Maximum Length: 100 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">Description</div>
                <div class="table-cell"><textarea name="description"><%=MySQLDatabaseUtil.formatTextFromDatabase(description)%></textarea></div>
            </div><div class="table-row">
                <div class="table-cell">URL</div>
                <div class="table-cell"><input type="text" name="url" maxlength="255" value="<%=MySQLDatabaseUtil.formatTextFromDatabase(url)%>"></div>
                <div class="table-cell">
                    <div>Maximum Length: 255 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">References</div>
                <div class="table-cell"><%@include file="scripts/references/add/addReferences.jsp"%></div>
            </div><div class="table-row">
                <div class="table-cell"><input type="submit" value="Add Tool"></div>
            </div>
        </div>
    </form>
<% } %>
<%@include file="footer.jsp"%>