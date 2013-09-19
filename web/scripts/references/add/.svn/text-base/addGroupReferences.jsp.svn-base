<%-- 
    Document   : addGroupReferences
    Created on : Oct 27, 2008, 11:47:02 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.proteomecommons.mysql.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

{
    String prefix = "";
    if (request.getAttribute("prefix") != null) {
        prefix = request.getAttribute("prefix").toString();
    }
    
    String id = "addReferences"+System.nanoTime();
    %>
    <script language="javascript">
        function changedReferences<%=id%>() {
            var addReferenceSelect = getObj('<%=id%>Select');
            var selected = addReferenceSelect.options[addReferenceSelect.selectedIndex].value;

            // do not take blank selections
            if (selected == '') {return;}

            var addReferences = getObj('<%=id%>');

            // drop in HTML depending on what is selected
            if (selected == 'group') {
                ajax.append('@baseURLscripts/references/add/items/search/addGroupReference.jsp?prefix=<%=prefix%>', addReferences);
            }

            // reset the select box
            addReferenceSelect.selectedIndex = 0;
        }
        function addReference<%=id%>(table, field, id) {
            var addReferences = getObj('<%=id%>');
            // drop in HTML depending on what is selected
            if (table == 'groups') {
                ajax.append('@baseURLscripts/references/add/items/search/addGroupReference.jsp?prefix=<%=prefix%>&i='+id, addReferences);
            }
        }
    </script>
    <div id="<%=id%>" class="box" style="height: <% if (request.getAttribute("referencesHeight") != null) { %><%=request.getAttribute("referencesHeight").toString()%><% } else { %>250px<% } %>;">
        <div style="background-color: #eee; text-align: right; border-bottom: 1px solid #333; padding: 1px 0 2px 0;">
            Add reference to 
            <select id="<%=id%>Select" onclick="changedReferences<%=id%>();">
                <option value=""></option>
                <option value="group">Group</option>
            </select>
        </div>
    </div>
    <script language="javascript">
        <%
        // same thing for attributes
        try {
            for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
                try {
                    String parameterName = (String)e.nextElement();
                    if (parameterName.startsWith(prefix + "refName")) {
                        String millisForRef = parameterName.substring(prefix.length() + 7);
                        String fieldName = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter(parameterName));
                        String fieldTable = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter(prefix + "refTable"+millisForRef));
                        String fieldID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter(prefix + "refValue"+millisForRef));
                        %>addReference<%=id%>('<%=fieldTable%>', '<%=fieldName%>', '<%=fieldID%>');
                        <%
                    }
                } catch (Exception ex) {
                }
            }
            // same thing for attributes
            for (Enumeration e = request.getAttributeNames(); e.hasMoreElements();) {
                try {
                    String parameterName = (String)e.nextElement();
                    if (parameterName.startsWith(prefix + "refName")) {
                        String millisForRef = parameterName.substring(prefix.length() + 7);
                        String fieldName = MySQLDatabaseUtil.formatTextForDatabase(request.getAttribute(parameterName).toString());
                        String fieldTable = MySQLDatabaseUtil.formatTextForDatabase(request.getAttribute(prefix + "refTable"+millisForRef).toString());
                        String fieldID = MySQLDatabaseUtil.formatTextForDatabase(request.getAttribute(prefix + "refValue"+millisForRef).toString());
                        %>addReference<%=id%>('<%=fieldTable%>', '<%=fieldName%>', '<%=fieldID%>');
                        <%
                    }
                } catch (Exception ex) {
                }
            }
        } catch (Exception e) {
            %>Error: <%=e.getMessage()%><%
        }
        %>
    </script>
<% } %>