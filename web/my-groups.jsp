<%-- 
    Document   : my-groups
    Created on : Sep 5, 2008, 3:26:10 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.*, java.sql.*, org.proteomecommons.www.group.*, org.proteomecommons.www.user.*"%><%
request.setAttribute("pageTitle", "My Groups");
request.setAttribute("pageUsersOnly", "true");

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

%><%@include file="header.jsp"%>
<script language="javascript">
    function plus(groupID, containerID, plusID) {
        getObj(plusID).innerHTML = '-';
        ajax.append('@baseURLscripts/groups/tree/getSubgroups.jsp?i='+groupID, getObj(containerID));
    }
</script>
<%
ResultSet rs = null;
try {
    // get the signed in user's groups
    List <Integer> groupIDs = new LinkedList<Integer>();
    rs = MySQLDatabaseUtil.executeQuery("SELECT groupID FROM group_user WHERE userID = '" + user.userID + "' ORDER BY date_created DESC;");
    while (rs.next()) {
        groupIDs.add(rs.getInt("groupID"));
    }
    List <Group> groups = GroupUtil.getGroups(groupIDs);
    for (Group group : groups) {
        %><div id="group<%=group.groupID%>"><span id="plusGroup<%=group.groupID%>"><a href="javascript:plus('<%=group.groupID%>', 'group<%=group.groupID%>', 'plusGroup<%=group.groupID%>');">+</a></span> <a href="group.jsp?i=<%=group.groupID%>"><%=group.name%></a></div><%
    }
} catch (Exception e) {
} finally {
    MySQLDatabaseUtil.safeClose(rs);
}

%><%@include file="footer.jsp"%>