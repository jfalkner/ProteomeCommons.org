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
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.proteomecommons.mysql.MySQLDatabaseUtil;
import org.proteomecommons.www.data.DataUtil;
import org.proteomecommons.www.group.GroupUtil;
import org.proteomecommons.www.link.LinkUtil;
import org.proteomecommons.www.news.NewsUtil;
import org.proteomecommons.www.notification.NotificationUtil;
import org.proteomecommons.www.publication.PublicationUtil;
import org.proteomecommons.www.tool.ToolUtil;
import org.proteomecommons.www.user.User;
import org.proteomecommons.www.user.UserUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class ReferenceUtil {

    public static final int CACHE_LIMIT = 10000;
    private static Map<Integer, Reference> references = new HashMap<Integer, Reference>();
    private static List<Reference> referenceRecency = new LinkedList<Reference>();

    public static int getCacheSize() {
        return references.size();
    }
    
    public static void addReference(String fromTable, String fromField, int fromID, String toTable, String toField, int toID) throws Exception {
        if (!MySQLDatabaseUtil.executeUpdate("INSERT INTO reference (fromTable, fromField, fromID, toTable, toField, toID) VALUES ('" + fromTable + "', '" + fromField + "', '" + fromID + "', '" + toTable + "', '" + toField + "', '" + toID + "');")) {
            throw new Exception("Could not add reference record to database.");
        } else {
            // reload the object that is newly referenced into its respective cache if it is already loaded
            if (toTable.equals("data")) {
                if (DataUtil.isInCache(toID)) {
                    DataUtil.getData(toID).clearReferencesTo();
                }
            } else if (toTable.equals("groups")) {
                if (GroupUtil.isInCache(toID)) {
                    GroupUtil.getGroup(toID).clearReferences();
                }
            } else if (toTable.equals("link")) {
                if (LinkUtil.isInCache(toID)) {
                    LinkUtil.getLink(toID).clearReferencesTo();
                }
            } else if (toTable.equals("news")) {
                if (NewsUtil.isInCache(toID)) {
                    NewsUtil.getNews(toID).clearReferencesTo();
                }
            } else if (toTable.equals("publication")) {
                if (PublicationUtil.isInCache(toID)) {
                    PublicationUtil.getPublication(toID).clearReferencesTo();
                }
            } else if (toTable.equals("tool")) {
                if (ToolUtil.isInCache(toID)) {
                    ToolUtil.getTool(toID).clearReferencesTo();
                }
            } else if (toTable.equals("user")) {
                if (UserUtil.isInCache(toID)) {
                    User user = UserUtil.getUser(toID);
                    user.clearReferences();
                    user.addNotification("You have been referenced from " + getLinkTo(fromTable, fromField, fromID));
                } else {
                    // add a notification to the user to let them know they've been referenced
                    NotificationUtil.addUserNotification("You have been referenced from " + getLinkTo(fromTable, fromField, fromID), toID);
                }
            }
            
            // reload the object that is referencing the new object
            if (fromTable.equals("data")) {
                if (DataUtil.isInCache(fromID)) {
                    DataUtil.getData(fromID).clearReferencesFrom();
                }
            } else if (fromTable.equals("link")) {
                if (LinkUtil.isInCache(fromID)) {
                    LinkUtil.getLink(fromID).clearReferencesFrom();
                }
            } else if (fromTable.equals("news")) {
                if (NewsUtil.isInCache(fromID)) {
                    NewsUtil.getNews(fromID).clearReferencesFrom();
                }
            } else if (fromTable.equals("publication")) {
                if (PublicationUtil.isInCache(fromID)) {
                    PublicationUtil.getPublication(fromID).clearReferencesFrom();
                }
            } else if (fromTable.equals("tool")) {
                if (ToolUtil.isInCache(fromID)) {
                    ToolUtil.getTool(fromID).clearReferencesFrom();
                }
            }
        }
    }
    
    public static String getLinkTo(String table, String field, int ID) {
        if (table.equals("data") && field.equals("dataID")) {
            return "<a href=\"@baseURLdata.jsp?i=" + ID + "\">" + DataUtil.getData(ID).title + "</a>";
        } else if (table.equals("groups") && field.equals("groupID")) {
            return "<a href=\"@baseURLgroup.jsp?i=" + ID + "\">" + GroupUtil.getGroup(ID).name + "</a>";
        } else if (table.equals("link") && field.equals("linkID")) {
            return "<a href=\"@baseURLlink.jsp?i=" + ID + "\">" + LinkUtil.getLink(ID).title + "</a>";
        } else if (table.equals("news") && field.equals("newsID")) {
            return "<a href=\"@baseURLnews.jsp?i=" + ID + "\">" + NewsUtil.getNews(ID).title + "</a>";
        } else if (table.equals("publication") && field.equals("publicationID")) {
            return "<a href=\"@baseURLpublication.jsp?i=" + ID + "\">" + PublicationUtil.getPublication(ID).title + "</a>";
        } else if (table.equals("tool") && field.equals("toolID")) {
            return "<a href=\"@baseURLtool.jsp?i=" + ID + "\">" + ToolUtil.getTool(ID).name + "</a>";
        } else if (table.equals("user") && field.equals("userID")) {
            return "<a href=\"@baseURLmember.jsp?i=" + ID + "\">" + UserUtil.getUser(ID).unique_name + "</a>";
        } else {
            return "";
        }
    }

    public static Reference getReference(int referenceID) {
        return getReference(referenceID, null);
    }

    public static synchronized Reference getReference(int referenceID, ResultSet rs) {
        // is the reference in the cache?
        Reference reference = null;
        try {
            if (references.containsKey(referenceID)) {
                reference = references.get(referenceID);
            } else {
                reference = new Reference(rs);
                if (!reference.isSet()) {
                    ResultSet rs2 = null;
                    try {
                        rs2 = MySQLDatabaseUtil.executeQuery("SELECT * FROM reference WHERE referenceID = '" + referenceID + "' LIMIT 1;");
                        if (rs2.next()) {
                            reference = new Reference(rs2);
                        }
                    } catch (Exception e) {
                    } finally {
                        MySQLDatabaseUtil.safeClose(rs2);
                    }
                }
            }
        } finally {
            // make sure this is a link we want to cache
            if (reference != null && reference.isSet()) {
                // update the cache
                if (!references.containsKey(referenceID)) {
                    // remove the last link
                    while (referenceRecency.size() >= CACHE_LIMIT) {
                        references.remove(referenceRecency.remove(0).referenceID);
                    }
                    // this is a new one
                    references.put(reference.referenceID, reference);
                    referenceRecency.add(reference);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    referenceRecency.remove(reference);
                    referenceRecency.add(reference);
                }
            }
        }
        return reference;
    }

    public static synchronized List<Reference> getReferences(List<Integer> referenceIDs) {
        List<Reference> list = new LinkedList<Reference>();
        // get the items that are in the cache
        List<Integer> toGetFromDatabase = new LinkedList<Integer>();
        for (int referenceID : referenceIDs) {
            if (references.containsKey(referenceID)) {
                list.add(references.get(referenceID));
            } else {
                toGetFromDatabase.add(referenceID);
            }
        }
        // get the remaining groups
        if (!toGetFromDatabase.isEmpty()) {
            String SQLFilter = "referenceID = '" + toGetFromDatabase.remove(0) + "'";
            for (int referenceID : toGetFromDatabase) {
                SQLFilter = SQLFilter + " OR referenceID = '" + referenceID + "'";
            }

            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM reference WHERE " + SQLFilter + ";");
                while (rs.next()) {
                    list.add(new Reference(rs));
                }
            } catch (Exception e) {
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
        // update the cache
        for (Reference reference : list) {
            if (reference != null && reference.isSet()) {
                // update the cache
                if (!references.containsKey(reference.referenceID)) {
                    // remove the last group
                    while (referenceRecency.size() >= CACHE_LIMIT) {
                        references.remove(referenceRecency.remove(0).referenceID);
                    }
                    // this is a new one
                    references.put(reference.referenceID, reference);
                    referenceRecency.add(reference);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    referenceRecency.remove(reference);
                    referenceRecency.add(reference);
                }
            }
        }
        return Collections.unmodifiableList(list);
    }

    public static List<Integer> getReferenceIDsTo(String table, String field, int ID) {
        return getReferenceIDs(table, field, ID, false, true);
    }

    public static List<Integer> getReferenceIDsTo(String table, String field, int ID, boolean ignoreMessageReferences) {
        return getReferenceIDs(table, field, ID, false, ignoreMessageReferences);
    }

    public static List<Integer> getReferenceIDsFrom(String table, String field, int ID) {
        return getReferenceIDs(table, field, ID, true, true);
    }

    public static List<Integer> getReferenceIDsFrom(String table, String field, int ID, boolean ignoreMessageReferences) {
        return getReferenceIDs(table, field, ID, true, ignoreMessageReferences);
    }

    public static List<Integer> getReferenceIDs(String table, String field, int ID, boolean from, boolean ignoreMessageReferences) {
        List<Integer> list = new LinkedList<Integer>();
        ResultSet rs = null;
        try {
            String ignore = "";
            if (ignoreMessageReferences) {
                ignore = "AND fromTable != 'message'";
            }
            if (from) {
                rs = MySQLDatabaseUtil.executeQuery("SELECT referenceID FROM reference WHERE fromTable = '" + table + "' AND fromField = '" + field + "' AND fromID = '" + ID + "' " + ignore + " ORDER BY referenceID ASC;");
            } else {
                rs = MySQLDatabaseUtil.executeQuery("SELECT referenceID FROM reference WHERE toTable = '" + table + "' AND toField = '" + field + "' AND toID = '" + ID + "' " + ignore + " ORDER BY referenceID ASC;");
            }
            while (rs.next()) {
                list.add(rs.getInt("referenceID"));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        return Collections.unmodifiableList(list);
    }

    public static List<Reference> getReferencesTo(String table, String field, int ID) {
        return getReferences(table, field, ID, false, true);
    }

    public static List<Reference> getReferencesTo(String table, String field, int ID, boolean ignoreMessageReferences) {
        return getReferences(table, field, ID, false, ignoreMessageReferences);
    }

    public static List<Reference> getReferencesFrom(String table, String field, int ID) {
        return getReferences(table, field, ID, true, true);
    }

    public static List<Reference> getReferencesFrom(String table, String field, int ID, boolean ignoreMessageReferences) {
        return getReferences(table, field, ID, true, ignoreMessageReferences);
    }

    public static List<Reference> getReferences(String table, String field, int ID, boolean from, boolean ignoreMessageReferences) {
        List<Reference> list = new LinkedList<Reference>();
        ResultSet rs = null;
        try {
            String ignore = "";
            if (ignoreMessageReferences) {
                ignore = "AND fromTable != 'message'";
            }
            if (from) {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM reference WHERE fromTable = '" + table + "' AND fromField = '" + field + "' AND fromID = '" + ID + "' " + ignore + " ORDER BY referenceID ASC;");
            } else {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM reference WHERE toTable = '" + table + "' AND toField = '" + field + "' AND toID = '" + ID + "' " + ignore + " ORDER BY referenceID ASC;");
            }
            while (rs.next()) {
                list.add(getReference(rs.getInt("referenceID"), rs));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        return Collections.unmodifiableList(list);
    }
    
    public static int getReferencesCount() {
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(referenceID) AS rows FROM reference;");
            rs.next();
            return rs.getInt("rows");
        } catch (Exception e) {
            return -1;
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
}

