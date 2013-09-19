<%-- 
    Document   : index
    Created on : Aug 20, 2008, 6:02:13 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, org.proteomecommons.www.publication.*, org.proteomecommons.www.tool.*, org.proteomecommons.www.news.*, org.proteomecommons.www.data.*"%><%
request.setAttribute("pageTitle", "Home");
request.setAttribute("showPageTitle", "false");
request.setAttribute("pageRedirectIfUser", "member-home.jsp");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%>
<div class="table"><div class="table-row"><div class="table-cell">
    <div>
        <div>About ProteomeCommons.org</div>
        <div></div>
    </div><div>
        <div>Publications</div>
        <div>
            <%
            List <Publication> publications = PublicationUtil.getPublications("", "date", "DESC", 1, 5, true);
            for (Publication p : publications) {
                %><div><a href="publication.jsp?i=<%=p.publicationID%>"><%=p.title%></a></div><%
            }
            %>
        </div>
    </div><div>
        <div>Tools</div>
        <div>
            <%
            List <Tool> tools = ToolUtil.getTools("", "date", "DESC", 1, 5, true);
            for (Tool t : tools) {
                %><div><a href="tool.jsp?i=<%=t.toolID%>"><%=t.name%></a></div><%
            }
            %>
        </div>
    </div>
</div><div class="table-cell">
    <div>
        <div>News</div>
        <div>
            <%
            List <News> news = NewsUtil.getNews("", "date", "DESC", 1, 5, true);
            for (News n : news) {
                %><div><a href="news.jsp?i=<%=n.newsID%>"><%=n.title%></a></div><%
            }
            %>
        </div>
    </div>
</div><div class="table-cell">
    <div>
        <% if (user != null) { %>
            You are signed in as <a href="member.jsp?i=<%=user.userID%>"><%=user.unique_name%></a>.
        <% } else { %>
            <form action="@baseURLsignin.jsp" method="post">
                <div class="table">
                    <div class="table-row">
                        <div class="table-cell">Email</div>
                        <div class="table-cell"><input type="text" size="20" name="email"></div>
                    </div><div class="table-row">
                        <div class="table-cell">Password</div>
                        <div class="table-cell"><input type="password" size="20" name="pass"></div>
                    </div><div class="table-row">
                        <div class="table-cell">
                            <a href="@baseURLsignin-forgot.jsp">Forgot Password</a><br/>
                            <a href="@baseURLsignup.jsp">Sign Up</a>
                        </div>
                        <div class="table-cell" style="text-align: right;">
                            <input type="submit" value="Sign In">
                        </div>
                    </div>
                </div>
            </form>
        <% } %>
    </div><div>
        <div>Data</div>
        <div style="text-align: left;">
            <%
            List <Data> data = DataUtil.getData("", "date_uploaded", "DESC", 1, 5, true);
            for (Data d : data) {
                %><div><a href="data.jsp?i=<%=d.dataID%>"><%=d.title%></a></div><%
            }
            %>
        </div>
    </div>
</div></div></div>
<%@include file="footer.jsp"%>