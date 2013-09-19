<%-- 
    Document   : publication-edit
    Created on : Oct 6, 2008, 2:12:11 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.tranche.util.*, org.proteomecommons.www.publication.*, org.proteomecommons.www.reference.*"%><%

Publication publication = null;
try {
    publication = PublicationUtil.getPublication(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (publication == null) {
    request.setAttribute("pageTitle", "Publication Not Found");
} else {
    request.setAttribute("pageTitle", "Publication - " + publication.title + " - Edit");
}
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

if (publication != null) {
    if (publication.publicationID != publication.publicationID) {
        %>You do not have the right to add references to this publication.<%
        publication = null;
    }
}

if (publication != null) {
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
                    ReferenceUtil.addReference("publication", "publicationID", publication.publicationID, fieldTable, fieldName, Integer.valueOf(fieldID));
                }
            }
            %>
            <script language="javascript">
                document.location.href = 'publication.jsp?i='+<%=publication.publicationID%>;
            </script>
            <%
        } catch (Exception e) {
            error = e.getMessage();
        }
    }

    if (error != null) { %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% }
    %>
    <form action="publication-edit.jsp" method="post">
        <input type="hidden" name="i" value="<%=publication.publicationID%>"/>
        <input type="hidden" name="action" value="edit"/>
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Title</div>
                <div class="table-cell"><%=publication.title%></div>
                <div class="table-cell">
                    <div>Maximum length: 100 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">Description</div>
                <div class="table-cell"><%=publication.description%></div>
            </div><div class="table-row">
                <div class="table-cell">Citation</div>
                <div class="table-cell"><%=publication.citation%></div>
            </div><div class="table-row">
                <div class="table-cell">References</div>
                <div class="table-cell">
                    <%
                    List <Reference> referencesFrom = ReferenceUtil.getReferencesFrom("publication", "publicationID", publication.publicationID);
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
                <div class="table-cell"><input type="submit" value="Edit Publication"></div>
            </div>
        </div>
    </form>
    <%
}
%><%@include file="footer.jsp"%>