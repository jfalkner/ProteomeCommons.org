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
package org.proteomecommons.www.notification;

import java.sql.ResultSet;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.proteomecommons.mysql.MySQLDatabaseUtil;
import org.proteomecommons.www.user.UserUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class NotificationUtil {

    public static final int CACHE_LIMIT = 10000;
    private static Map<Integer, Notification> notifications = new HashMap<Integer, Notification>();
    private static List<Notification> notificationRecency = new LinkedList<Notification>();

    public static boolean isInCache(int notificationID) {
        return notifications.containsKey(notificationID);
    }

    public static int getCacheSize() {
        return notifications.size();
    }

    public static Notification getNotification(int notificationID) {
        return getNotification(notificationID, null);
    }

    public static synchronized Notification getNotification(int notificationID, ResultSet rs) {
        // is the news in the cache?
        Notification notification = null;
        try {
            if (notifications.containsKey(notificationID)) {
                notification = notifications.get(notificationID);
            } else {
                notification = new Notification(rs);
                if (!notification.isSet()) {
                    ResultSet rs2 = null;
                    try {
                        rs2 = MySQLDatabaseUtil.executeQuery("SELECT n.* FROM notification n WHERE n.notificationID = '" + notificationID + "' LIMIT 1;");
                        if (rs2.next()) {
                            notification = new Notification(rs2);
                        }
                    } catch (Exception e) {
                    } finally {
                        MySQLDatabaseUtil.safeClose(rs2);
                    }
                }
            }
        } finally {
            // make sure this is a news we want to cache
            if (notification != null && notification.isSet()) {
                // update the cache
                if (!notifications.containsKey(notificationID)) {
                    // remove the last news
                    while (notificationRecency.size() >= CACHE_LIMIT) {
                        notifications.remove(notificationRecency.remove(0).notificationID);
                    }
                    // this is a new one
                    notifications.put(notification.notificationID, notification);
                    notificationRecency.add(notification);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    notificationRecency.remove(notification);
                    notificationRecency.add(notification);
                }
            }
        }
        return notification;
    }

    public static synchronized List<Notification> getNotifications(List<Integer> notificationIDs) {
        List<Notification> list = new LinkedList<Notification>();
        for (int notificationID : notificationIDs) {
            list.add(getNotification(notificationID));
        }
        return Collections.unmodifiableList(list);
    }

    private static int addNotification(String notification) throws Exception {
        try {
            MySQLDatabaseUtil.executeUpdate("INSERT INTO notification (notification, date) VALUES ('" + notification + "', '" + MySQLDatabaseUtil.getTimestamp() + "');");
        } catch (Exception e) {
            throw new Exception("Could not add notification to database.");
        }
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT notificationID FROM notification WHERE notification = '" + notification + "' ORDER BY notificationID DESC LIMIT 1;");
            rs.next();
            return rs.getInt("notificationID");
        } catch (Exception e) {
            throw new Exception("Could not get notification ID.");
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }

    public static int addUserNotification(String notification, int userID) throws Exception {
        return addUserNotification(notification, userID, true);
    }
    
    public static int addUserNotification(String notification, int userID, boolean clearUserCache) throws Exception {
        int notificationID = addNotification(notification);
        try {
            MySQLDatabaseUtil.executeUpdate("INSERT INTO user_notification (userID, notificationID) VALUES ('" + userID + "', '" + notificationID + "');");
        } catch (Exception e) {
            throw new Exception("Could not add user notification to database.");
        }
        if (clearUserCache && UserUtil.isInCache(userID)) {
            UserUtil.getUser(userID).clearNotifications();
        }
        return notificationID;
    }

    public static int addGroupNotification(String notification, int groupID) throws Exception {
        int notificationID = addNotification(notification);
        try {
            MySQLDatabaseUtil.executeUpdate("INSERT INTO group_notification (groupID, notificationID) VALUES ('" + groupID + "', '" + notificationID + "');");
        } catch (Exception e) {
            throw new Exception("Could not add user notification to database.");
        }
        return notificationID;
    }
}
