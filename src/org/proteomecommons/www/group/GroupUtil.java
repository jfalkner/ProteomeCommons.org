package org.proteomecommons.www.group;

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
 * @author James A Hill
 */
public class GroupUtil {

    private static String[] quickSearchFields = new String[]{"g.name"};
    public static final int CACHE_LIMIT = 1000;
    private static Map<Integer, Group> groups = new HashMap<Integer, Group>();
    private static List<Group> groupRecency = new LinkedList<Group>();

    public static boolean isInCache(int groupID) {
        return groups.containsKey(groupID);
    }
    
    public static int getCacheSize() {
        return groups.size();
    }
    
    public static Group getGroup(int groupID) {
        return getGroup(groupID, null);
    }

    public static synchronized Group getGroup(int groupID, ResultSet rs) {
        // is the group in the cache?
        Group group = null;
        try {
            if (groups.containsKey(groupID)) {
                group = groups.get(groupID);
            } else {
                group = new Group(rs);
                if (!group.isSet()) {
                    ResultSet rs2 = null;
                    try {
                        rs2 = MySQLDatabaseUtil.executeQuery("SELECT g.* FROM groups g WHERE g.groupID = '" + groupID + "' LIMIT 1;");
                        if (rs2.next()) {
                            group = new Group(rs2);
                        }
                    } catch (Exception e) {
                    } finally {
                        MySQLDatabaseUtil.safeClose(rs2);
                    }
                }
            }
        } finally {
            // make sure this is a group we want to cache
            if (group != null && group.isSet()) {
                // update the cache
                if (!groups.containsKey(groupID)) {
                    // remove the last group
                    while (groupRecency.size() >= CACHE_LIMIT) {
                        groups.remove(groupRecency.remove(0).groupID);
                    }
                    // this is a new one
                    groups.put(group.groupID, group);
                    groupRecency.add(group);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    groupRecency.remove(group);
                    groupRecency.add(group);
                }
            }
        }
        return group;
    }
    
    public static synchronized List <Group> getGroups(List <Integer> groupIDs) {
        List <Group> list = new LinkedList <Group> ();
        // get the groups that are in the cache
        List <Integer> toGetFromDatabase = new LinkedList <Integer> ();
        for (int groupID : groupIDs) {
            if (groups.containsKey(groupID)) {
                list.add(groups.get(groupID));
            } else {
                toGetFromDatabase.add(groupID);
            }
        }
        // get the remaining groups
        if (!toGetFromDatabase.isEmpty()) {
            String SQLFilter = "groupID = '"+toGetFromDatabase.remove(0)+"'";
            for (int groupID : toGetFromDatabase) {
                SQLFilter = SQLFilter + " OR groupID = '"+groupID+"'";
            }
            
            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM groups WHERE active = '1' AND ("+SQLFilter+");");
                while (rs.next()) {
                    list.add(new Group(rs));
                }
            } catch (Exception e) {
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
        // update the cache
        for (Group group : list) {
            if (group != null && group.isSet()) {
                // update the cache
                if (!groups.containsKey(group.groupID)) {
                    // remove the last group
                    while (groupRecency.size() >= CACHE_LIMIT) {
                        groups.remove(groupRecency.remove(0).groupID);
                    }
                    // this is a new one
                    groups.put(group.groupID, group);
                    groupRecency.add(group);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    groupRecency.remove(group);
                    groupRecency.add(group);
                }
            }
        }
        return Collections.unmodifiableList(list);
    }

    public static List<Group> getGroups(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive) {
        String filterText = "WHERE private_name = '0'";
        String SQLFilter = SearchUtil.makeSQLFilter(filter, quickSearchFields);
        if (!SQLFilter.trim().equals("")) {
            filterText = filterText + " AND " + SQLFilter;
        }
        if (mustBeActive) {
            if (!filterText.equals("")) {
                filterText = filterText + " AND";
            }
            filterText = filterText + " g.active = '1' ";
        }

        List<Group> list = new ArrayList<Group>();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT g.* FROM groups g " + filterText + " ORDER BY g." + orderBy + " " + orderByDir + " LIMIT " + (page - 1) * perPage + "," + perPage + ";");
            while (rs.next()) {
                list.add(getGroup(rs.getInt("groupID"), rs));
            }
        } catch (Exception e) { 
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        return Collections.unmodifiableList(list);
    }

    public static int getNumGroupsInDB() {
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(g.groupID) AS rows FROM groups g;");
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
    
    public static int getGroupsCount(String filter) {
        return getGroupsCount(filter, true);
    }

    public static int getGroupsCount(String filter, boolean mustBeActive) {
        return getGroupsCount(filter, 0, mustBeActive);
    }

    public static int getGroupsCount(String filter, int limit, boolean mustBeActive) {
        ResultSet rs = null;
        try {
            String limitStr = "";
            if (limit > 0) {
                limitStr = " LIMIT " + limit + " ";
            }
            
            String filterText = "WHERE private_name = '0'";
            String SQLFilter = SearchUtil.makeSQLFilter(filter, quickSearchFields);
            if (!SQLFilter.trim().equals("")) {
                filterText = filterText + " AND " + SQLFilter;
            }
            if (mustBeActive) {
                if (!filterText.equals("")) {
                    filterText = filterText + " AND";
                }
                filterText = filterText + " g.active = '1' ";
            }
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(g.groupID) AS rows FROM groups g " + filterText + limitStr + ";");
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
     * <p>Call this when you are changing the information about a group. It will remove the group from the cache, so when the group is called for next time, the data about that group will be taken from the database.</p>
     * @param groupID
     */
    public static synchronized void groupChanged(int groupID) {
        groupRecency.remove(groups.remove(groupID));
    }
}
