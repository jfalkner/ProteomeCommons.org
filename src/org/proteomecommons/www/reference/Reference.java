/*
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
package org.proteomecommons.www.reference;

import java.sql.ResultSet;
import org.proteomecommons.www.data.Data;
import org.proteomecommons.www.data.DataUtil;
import org.proteomecommons.www.group.Group;
import org.proteomecommons.www.group.GroupUtil;
import org.proteomecommons.www.link.Link;
import org.proteomecommons.www.link.LinkUtil;
import org.proteomecommons.www.message.Message;
import org.proteomecommons.www.message.MessageUtil;
import org.proteomecommons.www.news.News;
import org.proteomecommons.www.news.NewsUtil;
import org.proteomecommons.www.publication.Publication;
import org.proteomecommons.www.publication.PublicationUtil;
import org.proteomecommons.www.tool.Tool;
import org.proteomecommons.www.tool.ToolUtil;
import org.proteomecommons.www.user.User;
import org.proteomecommons.www.user.UserUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class Reference {

    public int referenceID = -1;
    public Class fromClass = null,  toClass = null;
    public Integer fromID = null,  toID = null;

    public Reference(ResultSet rs) {
        try {
            referenceID = rs.getInt("referenceID");
            fromClass = getClass(rs.getString("fromTable"));
            toClass = getClass(rs.getString("toTable"));
            fromID = rs.getInt("fromID");
            toID = rs.getInt("toID");
        } catch (Exception e) {
        }
    }
    
    public Object getTo() {
        return getObject(toClass, toID);
    }
    
    public String displayTo() {
        return display(toClass, getObject(toClass, toID));
    }
    
    public Object getFrom() {
        return getObject(fromClass, fromID);
    }
    
    public String displayFrom() {
        return display(fromClass, getObject(fromClass, fromID));
    }
    
    public String display(Class c, Object o) {
        try {
            if (c.equals(Data.class)) {
                Data d = (Data) o;
                return "Data: <a href=\"data.jsp?i=" + d.dataID + "\">" + d.title + "</a>";
            } else if (c.equals(Group.class)) {
                Group g = (Group) o;
                return "Group: <a href=\"group.jsp?i=" + g.groupID + "\">" + g.name + "</a>";
            } else if (c.equals(Link.class)) {
                Link l = (Link) o;
                return "Link: <a href=\"link.jsp?i=" + l.linkID + "\">" + l.title + "</a>";
            } else if (c.equals(News.class)) {
                News n = (News) o;
                return "News: <a href=\"news.jsp?i=" + n.newsID + "\">" + n.title + "</a>";
            } else if (c.equals(Publication.class)) {
                Publication p = (Publication) o;
                return "Publication: <a href=\"publication.jsp?i=" + p.publicationID + "\">" + p.title + "</a>";
            } else if (c.equals(Tool.class)) {
                Tool t = (Tool) o;
                return "Tool: <a href=\"tool.jsp?i=" + t.toolID + "\">" + t.name + "</a>";
            } else if (c.equals(User.class)) {
                User u = (User) o;
                return "User: <a href=\"member.jsp?i=" + u.userID + "\">" + u.unique_name + "</a>";
            } else if (c.equals(Message.class)) {
                Message m = (Message) o;
                // do not show messages!
                return "";
            } else {
                return "";
            }
        } catch (Exception e) {
            return "";
        }
    }
    
    public boolean isSet() {
        return fromClass != null;
    }

    private static Class getClass(String table) {
        if (table.equals("data")) {
            return Data.class;
        } else if (table.equals("groups")) {
            return Group.class;
        } else if (table.equals("link")) {
            return Link.class;
        } else if (table.equals("news")) {
            return News.class;
        } else if (table.equals("publication")) {
            return Publication.class;
        } else if (table.equals("tool")) {
            return Tool.class;
        } else if (table.equals("user")) {
            return User.class;
        } else if (table.equals("message")) { 
            return Message.class;
        } else {
            return null;
        }
    }
    
    private static Object getObject(Class c, int ID) {
        if (c.equals(Data.class)) {
            return DataUtil.getData(ID);
        } else if (c.equals(Group.class)) { 
            return GroupUtil.getGroup(ID);
        } else if (c.equals(Link.class)) { 
            return LinkUtil.getLink(ID);
        } else if (c.equals(News.class)) { 
            return NewsUtil.getNews(ID);
        } else if (c.equals(Publication.class)) { 
            return PublicationUtil.getPublication(ID);
        } else if (c.equals(Tool.class)) { 
            return ToolUtil.getTool(ID);
        } else if (c.equals(User.class)) { 
            return UserUtil.getUser(ID);
        } else if (c.equals(Message.class)) { 
            return MessageUtil.getMessage(ID);
        } else {
            return null;
        }
    }
}
