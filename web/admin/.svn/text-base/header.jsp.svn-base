<%-- 
    Document   : header
    Created on : Oct 20, 2008, 12:27:24 PM
    Author     : James A Hill
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="org.proteomecommons.tranche.*"%><%

// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server

// load Tranche configuration
ProteomeCommonsTrancheConfig.load();

// turn the request parameters into session params
if (request.getParameter("username") != null) {
    session.setAttribute("adminusername", request.getParameter("username"));
}
if (request.getParameter("pass") != null) {
    session.setAttribute("adminpass", request.getParameter("pass"));
}

// only admin signed-in persons can access these pages
if (!(request.getAttribute("suppressAdminRequirement") != null && request.getAttribute("suppressAdminRequirement").toString().equals("true"))) {
    try {
        if (!(session.getAttribute("adminusername").equals("Tranche") && session.getAttribute("adminpass").equals("ireallyliketranche"))) {
            throw new Exception("Bad login.");
        }
    } catch (Exception e) {
        session.removeAttribute("adminusername");
        session.removeAttribute("adminpass");
        response.sendRedirect("signin.jsp");
    }
}
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!--
/**
 *    Copyright 2005 The Regents of the University of Michigan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 Authors: James "Augie" Hill - augman85@gmail.com, Mark Gjukich  - markgj@umich.edu
-->
<html>
<head>
    <title>ProteomeCommons Admin - ${pageTitle}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
    <link rel="stylesheet" type="text/css" href="@baseURLstyle.css"/>
    <script type="text/javascript" src="@baseURLjs/google_mini_ajax.js"></script>
    <script type="text/javascript" src="@baseURLjs/general.js"></script>
    <script type="text/javascript" src="@baseURLjs/menu.js"></script>
    <script type="text/javascript" src="@baseURLjs/suggestions.js"></script>
    <script type="text/javascript" src="@baseURLjs/search.js"></script>
</head>
<body>
    <div id="pageHeader">
        <div id="top">
            <a href="@baseURL"><img src="" alt="ProteomeCommons.org Science Community" title="ProteomeCommons.org Science Community" border="0"></a>
        </div>
        <div id="menuBar">
            <table cellpadding="0" cellspacing="0" border="0" width="100%" height="33">
                <tr>
                    <td width="17"><img src="@baseURLimages/menu-left.gif" border="0"></td>
                    <td>
                        <div style="height: 33px; background-image: url('@baseURLimages/menu-middle.gif'); background-repeat: repeat-x;">
                            <span id="statsMenuBarOption" class="menuBarOption" onclick="goTo('@baseURLadmin/stats.jsp');" onmouseover="showMenu('statsMenu',this);" onmouseout="hideMenu('statsMenu', 'statsMenuBarOption');">Statistics</span><%
                            %><span id="reportsMenuBarOption" class="menuBarOption" onclick="goTo('@baseURLadmin/reports.jsp');" onmouseover="menuBarOptionOver(getObj('reportsMenuBarOption'));" onmouseout="menuBarOptionOut(getObj('reportsMenuBarOption'));">Reports</span>
                            <div id="statsMenu" class="menu" onmouseover="keepMenuOpen('statsMenu');" onmouseout="hideMenu('statsMenu', 'statsMenuBarOption');">
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLadmin/stats-members.jsp');" class="menuOption">Members</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLadmin/stats-groups.jsp');" class="menuOption">Groups</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLadmin/stats-data.jsp');" class="menuOption">Data</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLadmin/stats-publications.jsp');" class="menuOption">Publications</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLadmin/stats-news.jsp');" class="menuOption">News</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLadmin/stats-links.jsp');" class="menuOption">Links</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLadmin/stats-references.jsp');" class="menuOption">References</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLadmin/stats-messages.jsp');" class="menuOption">Messages</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLadmin/stats-views.jsp');" class="menuOption">Page Views</div>
                            </div>
                        </div>
                    </td>
                    <td width="17"><img src="@baseURLimages/menu-right.gif" border="0"></td>
                </tr>
            </table>
        </div>
    </div>
    <div id="pageBody">