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
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.proteomecommons.mysql.MySQLDatabaseUtil;
import org.proteomecommons.www.SearchUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class UserUtil {

    public static final int CACHE_LIMIT = 500;
    private static String[] quickSearchFields = new String[]{"u.unique_name", "u.prefix", "u.first_name", "u.middle_name", "u.last_name", "u.suffix", "u.organization"};
    private static Map<Integer, User> users = new HashMap<Integer, User>();
    private static List<User> userRecency = new LinkedList<User>();

    public static boolean isInCache(int userID) {
        return users.containsKey(userID);
    }
    
    public static int getCacheSize() {
        return users.size();
    }
    
    public static User getUser(int userID) {
        return getUser(userID, null);
    }

    public static void loadUser(ResultSet rs) {
        try {
            getUser(rs.getInt("userID"), rs);
        } catch (Exception e) {
        }
    }

    public static synchronized User getUser(int userID, ResultSet rs) {
        // is the user in the cache?
        User user = null;
        try {
            if (users.containsKey(userID)) {
                user = users.get(userID);
            } else {
                user = new User(rs);
                if (!user.isSet()) {
                    ResultSet rs2 = null;
                    try {
                        rs2 = MySQLDatabaseUtil.executeQuery("SELECT * FROM user WHERE userID = '" + userID + "' LIMIT 1;");
                        if (rs2.next()) {
                            user = new User(rs2);
                        }
                    } catch (Exception e) {
                    } finally {
                        MySQLDatabaseUtil.safeClose(rs2);
                    }
                }
            }
        } finally {
            // make sure this is a user we want to cache
            if (user != null && user.isSet()) {
                // update the cache
                if (!users.containsKey(userID)) {
                    // remove the last user
                    while (userRecency.size() >= CACHE_LIMIT) {
                        users.remove(userRecency.remove(0).userID);
                    }
                    // this is a new one
                    users.put(user.userID, user);
                    userRecency.add(user);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    userRecency.remove(user);
                    userRecency.add(user);
                }
            }
        }
        return user;
    }
    
    public static synchronized List <User> getUsers(List <Integer> userIDs) {
        List <User> list = new LinkedList <User> ();
        // get the users that are in the cache
        List <Integer> toGetFromDatabase = new LinkedList <Integer> ();
        for (int userID : userIDs) {
            if (users.containsKey(userID)) {
                list.add(users.get(userID));
            } else {
                toGetFromDatabase.add(userID);
            }
        }
        // get the remaining groups
        if (!toGetFromDatabase.isEmpty()) {
            String SQLFilter = "userID = '"+toGetFromDatabase.remove(0)+"'";
            for (int userID : toGetFromDatabase) {
                SQLFilter = SQLFilter + " OR userID = '"+userID+"'";
            }
            
            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM user WHERE active = '1' AND ("+SQLFilter+");");
                while (rs.next()) {
                    list.add(new User(rs));
                }
            } catch (Exception e) {
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
        // update the cache
        for (User user : list) {
            if (user != null && user.isSet()) {
                // update the cache
                if (!users.containsKey(user.userID)) {
                    // remove the last group
                    while (userRecency.size() >= CACHE_LIMIT) {
                        users.remove(userRecency.remove(0).userID);
                    }
                    // this is a new one
                    users.put(user.userID, user);
                    userRecency.add(user);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    userRecency.remove(user);
                    userRecency.add(user);
                }
            }
        }
        return Collections.unmodifiableList(list);
    }

    public static List<User> getUsers(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive) {

        String filterText = SearchUtil.makeSQLFilter(filter, quickSearchFields);
        String activeText = " ";
        if (mustBeActive) {
            if (!filterText.equals("")) {
                activeText = " AND ";
            }
            activeText = activeText + "u.active = '1'";
        }

        ArrayList<User> users = new ArrayList<User>();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT u.* FROM user u WHERE " + filterText + activeText + " ORDER BY u." + orderBy + " " + orderByDir + " LIMIT " + (page - 1) * perPage + "," + perPage + ";");
            while (rs.next()) {
                users.add(getUser(rs.getInt("userID"), rs));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        return users;
    }

    public static int getUserCount(String filter) {
        return getUserCount(filter, true);
    }

    public static int getUserCount(String filter, boolean mustBeActive) {
        return getUserCount(filter, 0, mustBeActive);
    }

    public static int getUserCount(String filter, int limit, boolean mustBeActive) {
        ResultSet rs = null;
        try {
            String limitStr = "";
            if (limit > 0) {
                limitStr = " LIMIT " + limit + " ";
            }
            String filterText = SearchUtil.makeSQLFilter(filter, quickSearchFields);
            String activeText = " ";
            if (mustBeActive) {
                if (!filterText.equals("")) {
                    activeText = " AND ";
                }
                activeText = activeText + "u.active = '1'";
            }
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(u.userID) AS rows FROM user u WHERE " + filterText + activeText + limitStr + ";");
            if (rs.next()) {
                return rs.getInt("rows");
            } else {
                return 0;
            }
        } catch (Exception e) {
            return 0;
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
    
    /**
     * <p>Call this when you are changing the information about a user. It will remove the user from the cache, so when the user is called for next time, the data about that user will be taken from the database.</p>
     * @param userID
     */
    public static synchronized void userChanged(int userID) {
        userRecency.remove(users.remove(userID));
    }
}
