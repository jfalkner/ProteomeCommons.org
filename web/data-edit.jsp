<%-- 
    Document   : data-edit
    Created on : Oct 6, 2008, 2:12:32 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.tranche.util.*, org.proteomecommons.www.data.*, org.proteomecommons.www.reference.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

Data data = null;
try {
    data = DataUtil.getData(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (data == null) {
    request.setAttribute("pageTitle", "Data Not Found");
} else {
    request.setAttribute("pageTitle", "Data - " + data.title + " - Edit");
}
request.setAttribute("pageUsersOnly", "true");

%><%@include file="header.jsp"%><%

if (data != null) {
    if (data.dataID != data.dataID) {
        %>You do not have the right to add references to this data.<%
        data = null;
    }
}

if (data != null) {
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
                    ReferenceUtil.addReference("data", "dataID", data.dataID, fieldTable, fieldName, Integer.valueOf(fieldID));
                }
            }
            %>
            <script language="javascript">
                document.location.href = 'data.jsp?i='+<%=data.dataID%>;
            </script>
            <%
        } catch (Exception e) {
            error = e.getMessage();
        }
    }

    if (error != null) { %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% }
    %>
    <form action="data-edit.jsp" method="post">
        <input type="hidden" name="i" value="<%=data.dataID%>"/>
        <input type="hidden" name="action" value="edit"/>
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Title</div>
                <div class="table-cell"><%=data.title%></div>
                <div class="table-cell"></div>
            </div><div class="table-row">
                <div class="table-cell">References</div>
                <div class="table-cell">
                    <%
                    List <Reference> referencesFrom = ReferenceUtil.getReferencesFrom("data", "dataID", data.dataID);
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
                <div class="table-cell"><input type="submit" value="Edit Data"></div>
            </div>
        </div>
    </form>
    <%
}
%><%@include file="footer.jsp"%>