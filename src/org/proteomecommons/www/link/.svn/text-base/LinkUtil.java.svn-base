package org.proteomecommons.www.link;

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
public class LinkUtil {

    private static String[] quickSearchFields = new String[]{"l.title"};
    public static final int CACHE_LIMIT = 1000;
    private static Map<Integer, Link> links = new HashMap<Integer, Link>();
    private static List<Link> linkRecency = new LinkedList<Link>();

    public static boolean isInCache(int linkID) {
        return links.containsKey(linkID);
    }
    
    public static int getCacheSize() {
        return links.size();
    }
    
    public static Link getLink(int linkID) {
        return getLink(linkID, null);
    }
    
    public static synchronized Link getLink(int linkID, ResultSet rs) {
        // is the link in the cache?
        Link link = null;
        try {
            if (links.containsKey(linkID)) {
                link = links.get(linkID);
            } else {
                link = new Link(rs);
                if (!link.isSet()) {
                    ResultSet rs2 = null;
                    try {
                        rs2 = MySQLDatabaseUtil.executeQuery("SELECT l.* FROM link l WHERE l.linkID = '" + linkID + "' LIMIT 1;");
                        if (rs2.next()) {
                            link = new Link(rs2);
                        }
                    } catch (Exception e) {
                    } finally {
                        MySQLDatabaseUtil.safeClose(rs2);
                    }
                }
            }
        } finally {
            // make sure this is a link we want to cache
            if (link != null && link.isSet()) {
                // update the cache
                if (!links.containsKey(linkID)) {
                    // remove the last link
                    while (linkRecency.size() >= CACHE_LIMIT) {
                        links.remove(linkRecency.remove(0).linkID);
                    }
                    // this is a new one
                    links.put(link.linkID, link);
                    linkRecency.add(link);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    linkRecency.remove(link);
                    linkRecency.add(link);
                }
            }
        }
        return link;
    }
    
    public static synchronized List <Link> getLinks(List <Integer> linkIDs) {
        List <Link> list = new LinkedList <Link> ();
        // get the links that are in the cache
        List <Integer> toGetFromDatabase = new LinkedList <Integer> ();
        for (int linkID : linkIDs) {
            if (links.containsKey(linkID)) {
                list.add(links.get(linkID));
            } else {
                toGetFromDatabase.add(linkID);
            }
        }
        // get the remaining groups
        if (!toGetFromDatabase.isEmpty()) {
            String SQLFilter = "linkID = '"+toGetFromDatabase.remove(0)+"'";
            for (int linkID : toGetFromDatabase) {
                SQLFilter = SQLFilter + " OR linkID = '"+linkID+"'";
            }
            
            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM link WHERE active = '1' AND ("+SQLFilter+");");
                while (rs.next()) {
                    list.add(new Link(rs));
                }
            } catch (Exception e) {
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
        // update the cache
        for (Link link : list) {
            if (link != null && link.isSet()) {
                // update the cache
                if (!links.containsKey(link.linkID)) {
                    // remove the last group
                    while (linkRecency.size() >= CACHE_LIMIT) {
                        links.remove(linkRecency.remove(0).linkID);
                    }
                    // this is a new one
                    links.put(link.linkID, link);
                    linkRecency.add(link);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    linkRecency.remove(link);
                    linkRecency.add(link);
                }
            }
        }
        return Collections.unmodifiableList(list);
    }

    public static List<Link> getLinks(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive) {
        return getLinks(filter, orderBy, orderByDir, page, perPage, mustBeActive, 0);
    }
    
    public static List<Link> getLinks(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive, int userID) {
        String filterText = SearchUtil.makeSQLFilter(filter, quickSearchFields);
        if (mustBeActive) {
            if (!filterText.trim().equals("")) {
                filterText = filterText + " AND ";
            }
            filterText = filterText + " l.active = '1' ";
        }
        if (userID > 0) {
            if (!filterText.trim().equals("")) {
                filterText = filterText + " AND ";
            }
            filterText = filterText + " l.userID = '" + userID + "' ";
        }
        if (!filterText.trim().equals("")) {
            filterText = "WHERE " + filterText;
        }

        List<Link> list = new ArrayList<Link>();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT l.* FROM link l " + filterText + " ORDER BY l." + orderBy + " " + orderByDir + " LIMIT " + (page - 1) * perPage + "," + perPage + ";");
            while (rs.next()) {
                list.add(getLink(rs.getInt("linkID"), rs));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        return list;
    }

    public static int getLinksCount(String filter) {
        return getLinksCount(filter, 0, true, 0);
    }

    public static int getLinksCount(String filter, boolean mustBeActive) {
        return getLinksCount(filter, 0, mustBeActive, 0);
    }
    
    public static int getLinksCount(String filter, boolean mustBeActive, int userID) {
        return getLinksCount(filter, 0, mustBeActive, userID);
    }

    public static int getLinksCount(String filter, int limit, boolean mustBeActive, int userID) {
        ResultSet rs = null;
        try {
            String limitStr = "";
            if (limit > 0) {
                limitStr = " LIMIT " + limit + " ";
            }
            String filterText = SearchUtil.makeSQLFilter(filter, quickSearchFields);
            if (mustBeActive) {
                if (!filterText.trim().equals("")) {
                    filterText = filterText + " AND ";
                }
                filterText = filterText + " l.active = '1' ";
            }
            if (userID > 0) {
                if (!filterText.trim().equals("")) {
                    filterText = filterText + " AND ";
                }
                filterText = filterText + " l.userID = '" + userID + "' ";
            }
            if (!filterText.trim().equals("")) {
                filterText = "WHERE " + filterText;
            }
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(l.linkID) AS rows FROM link l " + filterText + limitStr + ";");
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
}
