<%-- 
    Document   : news-edit
    Created on : Oct 6, 2008, 2:12:51 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.tranche.util.*, org.proteomecommons.www.news.*, org.proteomecommons.www.reference.*"%><%

News news = null;
try {
    news = NewsUtil.getNews(Integer.valueOf(request.getParameter("i")));
} catch (Exception e) {}

if (news == null) {
    request.setAttribute("pageTitle", "News Not Found");
} else {
    request.setAttribute("pageTitle", "News - " + news.title + " - Edit");
}
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%><%

if (news != null) {
    if (news.newsID != news.newsID) {
        %>You do not have the right to add references to this news item.<%
        news = null;
    }
}

if (news != null) {
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
                    ReferenceUtil.addReference("news", "newsID", news.newsID, fieldTable, fieldName, Integer.valueOf(fieldID));
                }
            }
            %>
            <script language="javascript">
                document.location.href = 'news.jsp?i='+<%=news.newsID%>;
            </script>
            <%
        } catch (Exception e) {
            error = e.getMessage();
        }
    }

    if (error != null) { %>Error message: <%=MySQLDatabaseUtil.formatTextForDatabase(error)%><% }
    %>
    <form action="news-edit.jsp" method="post">
        <input type="hidden" name="i" value="<%=news.newsID%>"/>
        <input type="hidden" name="action" value="edit"/>
        <div class="table">
            <div class="table-row">
                <div class="table-cell">Title</div>
                <div class="table-cell"><%=news.title%></div>
                <div class="table-cell">
                    <div>Maximum length: 100 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">Description</div>
                <div class="table-cell"><%=news.description%></div>
            </div><div class="table-row">
                <div class="table-cell">URL</div>
                <div class="table-cell"><%=news.url%></div>
                <div class="table-cell">
                    <div>Maximum length: 255 characters.</div>
                </div>
            </div><div class="table-row">
                <div class="table-cell">References</div>
                <div class="table-cell">
                    <%
                    List <Reference> referencesFrom = ReferenceUtil.getReferencesFrom("news", "newsID", news.newsID);
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
                <div class="table-cell"><input type="submit" value="Edit News"></div>
            </div>
        </div>
    </form>
    <%
}
%><%@include file="footer.jsp"%>