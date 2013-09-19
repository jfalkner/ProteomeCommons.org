<%-- 
    Document   : tool-edit
    Created on : Oct 6, 2008, 1:48:29 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.tranche.util.*, org.proteomecommons.www.tool.*, org.proteomecommons.www.reference.*"%><%

Tool tool = null;
try {
    tool = ToolUtil.getTool(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (tool == null) {
    request.setAttribute("pageTitle", "Tool Not Found");
} else {
    request.setAttribute("pageTitle", "Tool - " + tool.name + " - Edit");
}
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

if (tool != null) {
    if (tool.userID != user.userID) {
        %>You do not have the right to add references to this tool.<%
        tool = null;
    }
}

if (tool != null) {
    String error = null;
    if (request.getParameter("action") != null) {
        try {
            // add references
            for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
                String parameterName = (String)e.nextElement();
                if (parameterName.startsWith("refName")) {
                    String millis = parameterName.substring(7);
                    String fieldName = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter(parameterName));
                    String fieldTable = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("refTable"+millis));
                    String fieldID = MySQLDatabaseUtil.formatTextForDatabase(request.getParameter("refValue"+millis));
                    ReferenceUtil.addReference("tool", "toolID", tool.toolID, fieldTable, fieldName, Integer.valueOf(fieldID));
                }
            }
            %>
            <script language="javascript">
                document.location.href = 'tool.jsp?i='+<%=tool.toolID%>;
            </script>
            <%
        } catch (Exception e) {
            error = e.getMessage();
        }
    }

    if (error != null) { %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% }
    %>
    <form action="tool-edit.jsp" method="post">
        <input type="hidden" name="i" value="<%=tool.toolID%>"/>
        <input type="hidden" name="action" value="edit"/>
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Name</div>
                <div class="table-cell"><%=tool.name%></div>
                <div class="table-cell">
                    <div>Maximum Length: 100 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">Description</div>
                <div class="table-cell"><%=tool.description%></div>
            </div><div class="table-row">
                <div class="table-cell">URL</div>
                <div class="table-cell"><%=tool.url%></div>
                <div class="table-cell">
                    <div>Maximum Length: 255 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">References</div>
                <div class="table-cell">
                    <%
                    List <Reference> referencesFrom = ReferenceUtil.getReferencesFrom("tool", "toolID", tool.toolID);
                    if (referencesFrom.size() > 0) {
                        for (Reference r : referencesFrom) {
                            %><div><%=r.displayTo()%></div><%
                        }
                    } else {
                        %><div>None</div><%
                    }
                    %>
                </div>
                <div class="table-cell"></div>
            </div><div class="table-row">
                <div class="table-cell">New References:</div>
                <div class="table-cell"><%@include file="scripts/references/add/addReferences.jsp"%></div>
            </div><div class="table-row">
                <div class="table-cell"><input type="submit" value="Edit Tool"></div>
            </div>
        </div>
    </form>
    <%
}
%><%@include file="footer.jsp"%>