<%-- 
    Document   : header
    Created on : Aug 20, 2008, 6:02:52 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,org.proteomecommons.mysql.*,org.proteomecommons.tranche.*,org.proteomecommons.www.*,org.proteomecommons.www.user.*"%><%
// do not cache!
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); //prevents caching at the proxy server
%><%@include file="validate-user.jsp"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
    <title>ProteomeCommons - ${pageTitle}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>
    <meta name="keywords" content=""/>
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
            <div style="display: table; width: 100%;"><div style="display: table-row;">
                <div style="display: table-cell;"><a href="@baseURL"><img src="" alt="ProteomeCommons.org Science Community" title="ProteomeCommons.org Science Community" border="0"></a></div>
                <div id="rightLinks"><span onclick="goTo('@baseURLindex.jsp');" class="right">Home</span>|<span onclick="showFrameTopRight('searchFrame', this, -250, 0);" class="right">Search</span>|<% if (user == null) {%><span onclick="showFrameTopRight('signInFrame', this, -300, 0);" class="right">Sign In</span>|<span onclick="goTo('@baseURLsignup.jsp');" class="right">Sign Up</span><% } else {%><span onclick="goTo('@baseURLmember.jsp?i=<%=session.getAttribute("userID")%>');" class="right">Your Account</span>|<span onclick="goTo('@baseURLsignout.jsp');" class="right">Sign Out</span><% }%></div>
            </div></div>
            <div id="searchFrame" class="frame">
                <form action="search.jsp" id="cse-search-box">
                    <div>
                    <input type="hidden" name="cx" value="008840402475713285167:6a1eleoehly" />
                    <input type="hidden" name="cof" value="FORID:9" />
                    <input type="hidden" name="ie" value="UTF-8" />
                    <div style="display: table; width: 100%;"><div style="display: table-row;">
                        <div style="display: table-cell; text-align: center;"><input type="text" name="q" size="30" /></div>
                    </div><div style="display: table-row; text-align: right;">
                        <div style="display: table-cell; padding-top: 2px;"><input type="button" onclick="hide('searchFrame');" value="Cancel" />&nbsp;<input type="submit" name="sa" value="Search" /></div>
                    </div></div>
                  </div>
                </form>
                <script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=cse-search-box&lang=en"></script>
            </div>
            <div id="signInFrame" class="frame">
                <form action="@baseURLsignin.jsp" method="post">
                    <table cellpadding="0" cellspacing="5" border="0" width="100%">
                        <tr><td>Email</td><td align="right"><input type="text" size="20" name="email"></td></tr>
                        <tr><td>Password</td><td align="right"><input type="password" size="20" name="pass"></td></tr>
                        <tr>
                            <td>
                                <a href="@baseURLsignin-forgot.jsp">Forgot Password</a><br/>
                                <a href="@baseURLsignup.jsp">Sign Up</a>
                            </td><td valign="top" align="right">
                                <input type="button" value="Cancel" onclick="hide('signInFrame');">&nbsp;<input type="submit" value="Sign In">
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </div>
        <div id="menuBar">
            <table cellpadding="0" cellspacing="0" border="0" width="100%" height="33">
                <tr>
                    <td width="17"><img src="@baseURLimages/menu-left.gif" border="0"></td>
                    <td>
                        <div style="height: 33px; background-image: url('@baseURLimages/menu-middle.gif'); background-repeat: repeat-x;">
                            <span id="newsMenuBarOption" class="menuBarOption" onclick="goTo('@baseURLnews-browse.jsp');" onmouseover="showMenu('newsMenu',this);" onmouseout="hideMenu('newsMenu', 'newsMenuBarOption');">News</span><%
                            %><span id="dataMenuBarOption" class="menuBarOption" onclick="goTo('@baseURLdata-browse.jsp');" onmouseover="showMenu('dataMenu',this);" onmouseout="hideMenu('dataMenu', 'dataMenuBarOption');">Data</span><%
                            %><span id="toolsMenuBarOption" class="menuBarOption" onclick="goTo('@baseURLtools-browse.jsp');" onmouseover="showMenu('toolsMenu',this);" onmouseout="hideMenu('toolsMenu', 'toolsMenuBarOption');">Tools</span><%
                            %><span id="pubMenuBarOption" class="menuBarOption" onclick="goTo('@baseURLpublications-browse.jsp');" onmouseover="showMenu('pubMenu',this);" onmouseout="hideMenu('pubMenu', 'pubMenuBarOption');">Publications</span><%
                            %><span id="linksMenuBarOption" class="menuBarOption" onclick="goTo('@baseURLlinks-browse.jsp');" onmouseover="showMenu('linksMenu',this);" onmouseout="hideMenu('linksMenu', 'linksMenuBarOption');">Links</span><%
                            %><span id="communityMenuBarOption" class="menuBarOption" onclick="goTo('@baseURLcommunity.jsp');" onmouseover="showMenu('communityMenu',this);" onmouseout="hideMenu('communityMenu', 'communityMenuBarOption');">Community</span><%
                            %><span id="helpMenuBarOption" class="menuBarOption" onclick="goTo('@baseURLhelp/');" onmouseover="menuBarOptionOver(getObj('helpMenuBarOption'));" onmouseout="menuBarOptionOut(getObj('helpMenuBarOption'));">Help</span><%
                            %><span id="memberMenuBarOption" class="menuBarOption" onclick="goTo('@baseURLmember-home.jsp');" onmouseover="showMenu('memberMenu',this);" onmouseout="hideMenu('memberMenu', 'memberMenuBarOption');">Member Links</span>
                            <div id="newsMenu" class="menu" onmouseover="keepMenuOpen('newsMenu');" onmouseout="hideMenu('newsMenu', 'newsMenuBarOption');">
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="newsAdvancedSearch();" class="menuOption">Advanced Search</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLnews-add.jsp');" class="menuOption">Add News</div>
                            </div>
                            <div id="dataMenu" class="menu" onmouseover="keepMenuOpen('dataMenu');" onmouseout="hideMenu('dataMenu', 'dataMenuBarOption');">
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="dataAdvancedSearch();" class="menuOption">Advanced Search</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLdata-uploader.jsp');" class="menuOption">Upload Data</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLtranche/');" class="menuOption">Our Tranche Network</div>
                            </div>
                            <div id="toolsMenu" class="menu" onmouseover="keepMenuOpen('toolsMenu');" onmouseout="hideMenu('toolsMenu', 'toolsMenuBarOption');">
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="toolAdvancedSearch();" class="menuOption">Advanced Search</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLtools-add.jsp');" class="menuOption">Add Tool</div>
                            </div>
                            <div id="pubMenu" class="menu" onmouseover="keepMenuOpen('pubMenu');" onmouseout="hideMenu('pubMenu', 'pubMenuBarOption');">
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="publicationAdvancedSearch();" class="menuOption">Advanced Search</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLpublications-add.jsp');" class="menuOption">Add Publication</div>
                            </div>
                            <div id="linksMenu" class="menu" onmouseover="keepMenuOpen('linksMenu');" onmouseout="hideMenu('linksMenu', 'linksMenuBarOption');">
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="linkAdvancedSearch();" class="menuOption">Advanced Search</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLlinks-add.jsp');" class="menuOption">Add Link</div>
                            </div>
                            <div id="communityMenu" class="menu" onmouseover="keepMenuOpen('communityMenu');" onmouseout="hideMenu('communityMenu', 'communityMenuBarOption');">
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLforum/');" class="menuOption">Forum</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLmembers-browse.jsp');" class="menuOption">Members</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="userAdvancedSearch();" class="menuSubOption">Advanced Search</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLsignup.jsp');" class="menuSubOption">Sign Up</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLgroups-browse.jsp');" class="menuOption">Groups</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="groupAdvancedSearch();" class="menuSubOption">Advanced Search</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLgroup-add.jsp');" class="menuSubOption">Add Group</div>
                            </div>
                            <div id="memberMenu" class="menu" onmouseover="keepMenuOpen('memberMenu');" onmouseout="hideMenu('memberMenu', 'memberMenuBarOption');">
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLmessages.jsp');" class="menuOption"<% if (user != null && user.hasNewMessages()) { %> style="font-weight: bold;"<% } %>>Messages<% if (user != null && user.hasNewMessages()) { %> (new)<% } %></div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLmy-groups.jsp');" class="menuOption">Groups</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLmy-data.jsp');" class="menuOption">Data</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLmy-news.jsp');" class="menuOption">News</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLmy-links.jsp');" class="menuOption">Links</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLmy-publications.jsp');" class="menuOption">Publications</div>
                                <div onmouseover="menuOptionOver(this);" onmouseout="menuOptionOut(this);" onclick="goTo('@baseURLmy-tools.jsp');" class="menuOption">Tools</div>
                            </div>
                        </div>
                    </td>
                    <td width="17"><img src="@baseURLimages/menu-right.gif" border="0"></td>
                </tr>
            </table>            
        </div>
    </div>
    <div id="pageBody">
        <% if (request.getAttribute("showPageTitle") == null || !request.getAttribute("showPageTitle").toString().toLowerCase().equals("false")) { %>
            <div id="pageTitle">${pageTitle}</div>
        <% } %>
        <% if (request.getAttribute("pageUsersOnly") != null) { %>
            <% if (Boolean.valueOf(request.getAttribute("pageUsersOnly").toString()) && user == null) { %>
                <p>Only signed-in users can access this page.</p>
                <script language="javascript">goTo('@baseURLsignin.jsp?goto=<%=Util.getWebSafeString(request.getRequestURI())%>&gotoq=<%=Util.getWebSafeString(request.getQueryString())%>');</script>
            <% } %>
        <% } %>
        <script language="javascript">ajax.getnf('@baseURLscripts/stats/registerPageView.jsp?i=<%=Util.getWebSafeString(request.getRemoteAddr())%>&p=<%=Util.getWebSafeString(request.getRequestURI())%>&q=<%=Util.getWebSafeString(request.getQueryString())%>');</script>