<%@page contentType="application/x-java-jnlp-file" import="java.util.*, org.proteomecommons.www.data.*" %><?xml version="1.0" encoding="utf-8"?>
<jnlp spec="1.0+" codebase="http://tranche.proteomecommons.org/">
  <information>
    <title>ProteomeCommons.org Tranche Download Tool (Build: @buildNumber)</title>
    <vendor>ProteomeCommons.org</vendor>
    <homepage href="@baseURL"/>
    <description>A tool for getting data from the ProteomeCommons.org Tranche Network.</description>
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
  <resources os="Windows" arch="x86">
  	<jar href="lib/swt-win32-win32-x86.jar"/>
  </resources>
  <resources os="Linux" arch="ppc">
  	<jar href="lib/swt-gtk-linux-ppc.jar"/>
  </resources>
  <resources os="Linux" arch="x86_64">
  	<jar href="lib/swt-gtk-linux-x86_64.jar"/>
  </resources>
  <resources os="Linux" arch="amd64">
  	<jar href="lib/swt-gtk-linux-x86_64.jar"/>
  </resources>
  <resources os="Linux">
  	<jar href="lib/swt-motif-linux-x86.jar"/>
  </resources>
  <resources os="SunOS" arch="sparc">
  	<jar href="lib/swt-gtk-solaris-sparc.jar"/>
  </resources>
  <application-desc main-class="org.proteomecommons.tranche.GetFileToolWizard">
    <% 
    if (request.getParameter("i") != null) {
        try {
            Data data = DataUtil.getData(Integer.valueOf(request.getParameter("i")));
            if (data != null && data.isSet()) {
                %><argument>-h</argument><argument><%=data.hash.toString()%></argument><%
            }
        } catch (Exception e) {}
    } else if (request.getParameter("hash") != null) {
        %><argument>-h</argument><argument><%=request.getParameter("hash")%></argument><%
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
    if (request.getParameter("passphrase") != null) {
        %><argument>-p</argument><argument><%=request.getParameter("passphrase")%></argument><%
    }
    if (request.getParameter("regex") != null) {
        %><argument>-r</argument><argument><%=request.getParameter("regex")%></argument><% 
    }
    if (request.getParameter("validate") != null) {
        %><argument>-v</argument><argument><%=Boolean.valueOf(request.getParameter("validate"))%></argument><% 
    }
    %>
  </application-desc>
</jnlp>
