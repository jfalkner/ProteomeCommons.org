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
package org.proteomecommons.www.group;

import java.sql.ResultSet;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.proteomecommons.mysql.MySQLDatabaseUtil;
import org.proteomecommons.www.notification.Notification;
import org.proteomecommons.www.notification.NotificationUtil;
import org.proteomecommons.www.reference.Reference;
import org.proteomecommons.www.reference.ReferenceUtil;
import org.proteomecommons.www.user.User;
import org.proteomecommons.www.user.UserUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class Group {

    public int groupID = -1,  created_userID = -1;
    public String name = null,  description = null,  date_created = null;
    public boolean active = false, private_group = false, private_name = false;
    private List<Integer> subgroups = null;
    private List<GroupMember> users = null;
    private Map<Integer, GroupMember> userMap = null;
    private List<Integer> references = null;
    private List<Integer> notifications = null;

    public Group(ResultSet rs) {
        try {
            this.groupID = rs.getInt("groupID");
            this.name = rs.getString("name");
            this.description = rs.getString("description");
            this.date_created = rs.getString("date_created");
            this.created_userID = rs.getInt("created_userID");
            this.active = rs.getBoolean("active");
            this.private_group = rs.getBoolean("private_group");
            this.private_name = rs.getBoolean("private_name");
        } catch (Exception e) {
        }
    }

    public boolean isSet() {
        return name != null;
    }
    
    public boolean isPrivate() {
        return isSet() && private_group;
    }
    
    public boolean isNamePrivate() {
        return isPrivate() && private_name;
    }

    public User getCreatedByUser() {
        return UserUtil.getUser(created_userID);
    }
    
    public synchronized int countSubGroups() {
        // need to load the sub-groups
        if (subgroups == null) {
            reloadSubGroups();
        }
        return subgroups.size();
    }
    
    public synchronized boolean isSubGroup(int groupID) {
        // need to load the sub-groups
        if (subgroups == null) {
            reloadSubGroups();
        }
        return subgroups.contains(groupID);
    }
    
    public synchronized List<Group> getSubGroups(int limit) {
        // need to load the sub-groups
        if (subgroups == null) {
            reloadSubGroups();
        }
        LinkedList <Integer> list = new LinkedList <Integer> ();
        for (int i = 0; i < limit && i < subgroups.size(); i++) {
            list.add(subgroups.get(i));
        }
        return GroupUtil.getGroups(list);
    }

    public synchronized List<Group> getSubGroups() {
        // need to load the sub-groups
        if (subgroups == null) {
            reloadSubGroups();
        }
        return GroupUtil.getGroups(subgroups);
    }
    
    public synchronized void clearSubGroups() {
        subgroups = null;
    }

    public synchronized void reloadSubGroups() {
        subgroups = new LinkedList<Integer>();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT subgroupID FROM subgroup WHERE groupID = '" + groupID + "';");
            while (rs.next()) {
                subgroups.add(rs.getInt("subgroupID"));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
    
    public synchronized void removeGroupMember(int userID) {
        if (users != null && userMap != null) {
            users.remove(userMap.remove((Integer)userID));
        }
    }
    
    public synchronized int countGroupMembers() {
        // need to load the group members
        if (users == null || userMap == null) {
            reloadGroupMembers();
        }
        return users.size();
    }
    
    public synchronized List<GroupMember> getGroupMembers(int limit) {
        // need to load the group members
        if (users == null || userMap == null) {
            reloadGroupMembers();
        }
        LinkedList <GroupMember> list = new LinkedList <GroupMember> ();
        for (int i = 0; i < limit && i < users.size(); i++) {
            list.add(users.get(i));
        }
        return Collections.unmodifiableList(list);
    }

    public synchronized List<GroupMember> getGroupMembers() {
        // need to load the group members
        if (users == null || userMap == null) {
            reloadGroupMembers();
        }
        return Collections.unmodifiableList(users);
    }
    
    public synchronized void clearGroupMembers() {
        users = null;
        userMap = null;
    }

    private synchronized void reloadGroupMembers() {
        users = new LinkedList<GroupMember>();
        userMap = new HashMap<Integer, GroupMember>();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM group_user WHERE groupID = '" + groupID + "';");
            while (rs.next()) {
                GroupMember groupMember = new GroupMember(rs);
                users.add(groupMember);
                userMap.put(groupMember.userID, groupMember);
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
    
    public synchronized boolean isMember(int userID) {
        // need to load the group members
        if (users == null || userMap == null) {
            reloadGroupMembers();
        }
        return userMap.containsKey(userID);
    }
    
    public synchronized GroupMember getMember(int userID) {
        // need to load the group members
        if (users == null || userMap == null) {
            reloadGroupMembers();
        }
        return userMap.get(userID);
    }
    
    public synchronized List <Reference> getReferences() {
        if (references == null) {
            reloadReferences();
        }
        return ReferenceUtil.getReferences(references);
    }
    
    public synchronized void clearReferences() {
        references = null;
    }
    
    public synchronized void reloadReferences() {
        references = ReferenceUtil.getReferenceIDsTo("groups", "groupID", groupID);
    }
    
    public synchronized void addNotification(String notification) {
        try {
            int notificationID = NotificationUtil.addGroupNotification(notification, groupID);
            if (notifications != null) {
                // put at the top of the list
                if (notifications.isEmpty()) {
                    notifications.add(notificationID);
                } else {
                    notifications.add(0, notificationID);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public synchronized int getNotificationCount() {
        if (notifications == null) {
            reloadNotifications();
        }
        return notifications.size();
    }
    
    public synchronized List <Notification> getNotifications() {
        if (notifications == null) {
            reloadNotifications();
        }
        return NotificationUtil.getNotifications(notifications);
    }
    
    public synchronized List <Notification> getNotifications(int start, int count) {
        if (notifications == null) {
            reloadNotifications();
        }
        List <Integer> list = new LinkedList <Integer> ();
        for (int i = start; i < (start+count) && i < notifications.size(); i++) {
            list.add(notifications.get(i));
        }
        return NotificationUtil.getNotifications(list);
    }
    
    public synchronized void clearNotifications() {
        notifications = null;
    }
    
    public synchronized void reloadNotifications() {
        notifications = new LinkedList <Integer> ();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT notificationID FROM group_notification WHERE groupID = '"+groupID+"' ORDER BY notificationID DESC;");
            while (rs.next()) {
                notifications.add(rs.getInt("notificationID"));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
}
