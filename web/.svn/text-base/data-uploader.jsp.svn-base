<%@ page contentType="application/x-java-jnlp-file" import="java.util.*, org.proteomecommons.www.data.*, org.proteomecommons.www.user.*"%><%@include file="validate-user.jsp"%><?xml version="1.0" encoding="utf-8"?>
<jnlp spec="1.0+" codebase="http://tranche.proteomecommons.org/">
  <information>
    <title>ProteomeCommons.org Tranche Upload Tool (Build: @buildNumber)</title>
    <vendor>ProteomeCommons.org</vendor>
    <homepage href="@baseURL"/>
    <description>A tool for uploading data to the ProteomeCommons.org Tranche network.</description>
    <icon href="images/icon.gif"/>
    <icon kind="splash" href="images/splash2.gif" width="400" height="80"/>
  </information>
  <security>
    <all-permissions/>
  </security>
  <resources>
    <j2se version="1.5+" max-heap-size="512m"/>
	<jar href="lib/ProteomeCommons.org-Tranche.jar"/>
	<jar href="lib/bcprov-jdk15-130.jar"/>
	<jar href="lib/mail.jar"/>
	<jar href="lib/mail-activation.jar"/>
	<jar href="lib/commons-httpclient-3.0-rc4.jar"/>
	<jar href="lib/commons-codec-1.3.jar"/>
	<jar href="lib/commons-logging.jar"/>
	<jar href="lib/ProteomeCommons.org-IO.jar"/>
      	<jar href="lib/TrancheGUI.jar"/>
      	<jar href="lib/ProteomeCommons.org-JAF.jar"/>
  </resources>
  <application-desc main-class="org.proteomecommons.tranche.AddFileToolWizard">
      <%
      // log the user in
      if (user != null) {
        %><argument>-U</argument><argument><%=user.email%></argument><%
        if (session.getAttribute("pass") != null) {
            %><argument>-P</argument><argument><%=session.getAttribute("pass").toString()%></argument><%
        }
      }
      if (request.getParameter("newVersion") != null) {
        %><argument>-n</argument><argument><%=request.getParameter("newVersion")%></argument><%
      }
      if (request.getParameter("oldVersion") != null) {
        %><argument>-o</argument><argument><%=request.getParameter("oldVersion")%></argument><%
      }
      if (request.getParameter("title") != null) {
        %><argument>-t</argument><argument><%=request.getParameter("title")%></argument><%
      }
      if (request.getParameter("description") != null) {
        %><argument>-d</argument><argument><%=request.getParameter("description")%></argument><%
      }
      for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
            String parameterName = (String)e.nextElement();
            try {
                if (parameterName.startsWith("server")) {
                    %><argument>-s</argument><argument><%=request.getParameter(request.getParameter(parameterName))%></argument><%
                }
            } catch (Exception ex) {
            }
        }
      %>
  </application-desc>
</jnlp>
