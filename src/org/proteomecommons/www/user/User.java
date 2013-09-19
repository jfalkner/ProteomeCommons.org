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
package org.proteomecommons.www.user;

import java.sql.ResultSet;
import java.util.LinkedList;
import java.util.List;
import org.proteomecommons.mysql.MySQLDatabaseUtil;
import org.proteomecommons.www.country.Country;
import org.proteomecommons.www.country.CountryUtil;
import org.proteomecommons.www.group.Group;
import org.proteomecommons.www.group.GroupUtil;
import org.proteomecommons.www.message.MessageThread;
import org.proteomecommons.www.message.MessageUtil;
import org.proteomecommons.www.notification.Notification;
import org.proteomecommons.www.notification.NotificationUtil;
import org.proteomecommons.www.reference.Reference;
import org.proteomecommons.www.reference.ReferenceUtil;
import org.proteomecommons.www.region.Region;
import org.proteomecommons.www.region.RegionUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class User {

    public int userID = -1;
    public String email = null,  unique_name = null,  prefix = null,  first_name = null,  middle_name = null,  last_name = null,  suffix = null,  date_created = null,  date_signed_in = null,  phone = null,  organization = null,  department = null;
    public Country country = null;
    public Region region = null;
    public boolean active = false,  email_update = false;
    private List<Integer> groups = null,  references = null,  receivedMessageThreads = null, sentMessageThreads = null, notifications = null;

    public User(ResultSet rs) {
        try {
            this.userID = rs.getInt("userID");
            this.email = rs.getString("email");
            this.unique_name = rs.getString("unique_name");
            this.prefix = rs.getString("prefix");
            this.first_name = rs.getString("first_name");
            this.middle_name = rs.getString("middle_name");
            this.last_name = rs.getString("last_name");
            this.suffix = rs.getString("suffix");
            this.date_created = rs.getString("date_created");
            this.date_signed_in = rs.getString("date_signed_in");
            this.phone = rs.getString("phone");
            this.organization = rs.getString("organization");
            this.department = rs.getString("department");
            this.country = CountryUtil.getCountry(rs.getInt("countryID"));
            this.region = RegionUtil.getRegion(rs.getInt("regionID"));
            this.email_update = rs.getBoolean("email_update");
            this.active = rs.getBoolean("active");
        } catch (Exception e) {
        }
    }

    public boolean isSet() {
        return unique_name != null;
    }

    public List<Group> getGroups() {
        if (groups == null) {
            reloadGroups();
        }
        return GroupUtil.getGroups(groups);
    }
    
    public synchronized void removeGroup(int groupID) {
        if (groups != null) {
            groups.remove((Integer)groupID);
        }
    }
    
    public synchronized void clearGroups() {
        groups = null;
    }

    private synchronized void reloadGroups() {
        groups = new LinkedList<Integer>();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT groupID FROM group_user WHERE userID = '" + userID + "';");
            while (rs.next()) {
                groups.add(rs.getInt("groupID"));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
    
    public void addReceivedMessageThread(int threadID) {
        if (receivedMessageThreads == null) {
            reloadReceivedMessageThreads();
        } else {
            if (!receivedMessageThreads.contains(threadID)) {
                if (receivedMessageThreads.isEmpty()) {
                    receivedMessageThreads.add(threadID);
                } else {
                    receivedMessageThreads.add(0, threadID);
                }
            } else {
                // remove from wherever it is
                receivedMessageThreads.remove((Integer)threadID);
                // place at the top
                receivedMessageThreads.add(0, threadID);
            }
        }
    }
    
    public void addSentMessageThread(int threadID) {
        if (sentMessageThreads == null) {
            reloadReceivedMessageThreads();
        } else {
            if (!sentMessageThreads.contains(threadID)) {
                if (sentMessageThreads.isEmpty()) {
                    sentMessageThreads.add(threadID);
                } else {
                    sentMessageThreads.add(0, threadID);
                }
            } else {
                // remove from wherever it is
                sentMessageThreads.remove((Integer)threadID);
                // place at the top
                sentMessageThreads.add(0, threadID);
            }
        }
    }

    public List<MessageThread> getReceivedMessageThreads() {
        if (receivedMessageThreads == null) {
            reloadReceivedMessageThreads();
        }
        return MessageUtil.getMessageThreads(receivedMessageThreads);
    }
    
    public List<MessageThread> getSentMessageThreads() {
        if (sentMessageThreads == null) {
            reloadSentMessageThreads();
        }
        return MessageUtil.getMessageThreads(sentMessageThreads);
    }
    
    public List<MessageThread> getReceivedMessageThreads(int start, int end) {
        if (receivedMessageThreads == null) {
            reloadReceivedMessageThreads();
        }
        List <Integer> list = new LinkedList <Integer> ();
        for (int i = start; i < receivedMessageThreads.size() && i < end; i++) {
            list.add(receivedMessageThreads.get(i));
        }
        return MessageUtil.getMessageThreads(list);
    }
    
    public List<MessageThread> getSentMessageThreads(int start, int end) {
        if (sentMessageThreads == null) {
            reloadSentMessageThreads();
        }
        List <Integer> list = new LinkedList <Integer> ();
        for (int i = start; i < sentMessageThreads.size() && i < end; i++) {
            list.add(sentMessageThreads.get(i));
        }
        return MessageUtil.getMessageThreads(list);
    }

    private synchronized void reloadReceivedMessageThreads() {
        receivedMessageThreads = new LinkedList <Integer> ();
        // load up the threads that the user received
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT m.threadID FROM message_recipient mr INNER JOIN message m ON m.messageID = mr.messageID WHERE mr.userID = '" + userID + "' GROUP BY m.threadID ORDER BY m.date DESC;");
            while (rs.next()) {
                receivedMessageThreads.add(rs.getInt("threadID"));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
    
    private synchronized void reloadSentMessageThreads() {
        sentMessageThreads = new LinkedList <Integer> ();
        // load up the threads that the user received
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT m.threadID FROM message m WHERE m.userID = '" + userID + "' GROUP BY m.threadID ORDER BY m.date DESC;");
            while (rs.next()) {
                sentMessageThreads.add(rs.getInt("threadID"));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
    
    public boolean hasNewMessages() {
        for (MessageThread mt : getReceivedMessageThreads()) {
            try {
                if (!mt.getLatestMessage().getRecipient(userID).isRead) {
                    return true;
                }
            } catch (Exception e) {
            }
        }
        return false;
    }

    public synchronized List<Reference> getReferences() {
        if (references == null) {
            reloadReferences();
        }
        return ReferenceUtil.getReferences(references);
    }

    public synchronized void clearReferences() {
        references = null;
    }

    public synchronized void reloadReferences() {
        references = ReferenceUtil.getReferenceIDsTo("user", "userID", userID);
    }
    
    public synchronized void addNotification(String notification) {
        try {
            int notificationID = NotificationUtil.addUserNotification(notification, userID, false);
            // putg at the top of the list
            if (notifications != null) {
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
            rs = MySQLDatabaseUtil.executeQuery("SELECT notificationID FROM user_notification WHERE userID = '"+userID+"' ORDER BY notificationID DESC;");
            while (rs.next()) {
                notifications.add(rs.getInt("notificationID"));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
}
