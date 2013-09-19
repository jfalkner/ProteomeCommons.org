package org.proteomecommons.www.publication;

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
public class PublicationUtil {

    private static String[] quickSearchFields = new String[]{"p.title", "p.citation", "p.url"};
    public static final int CACHE_LIMIT = 1000;
    private static Map<Integer, Publication> publications = new HashMap<Integer, Publication>();
    private static List<Publication> publicationRecency = new LinkedList<Publication>();

    public static boolean isInCache(int publicationID) {
        return publications.containsKey(publicationID);
    }

    public static int getCacheSize() {
        return publications.size();
    }

    public static Publication getPublication(int publicationID) {
        return getPublication(publicationID, null);
    }

    public static synchronized Publication getPublication(int publicationID, ResultSet rs) {
        // is the publication in the cache?
        Publication publication = null;
        try {
            if (publications.containsKey(publicationID)) {
                publication = publications.get(publicationID);
            } else {
                publication = new Publication(rs);
                if (!publication.isSet()) {
                    ResultSet rs2 = null;
                    try {
                        rs2 = MySQLDatabaseUtil.executeQuery("SELECT p.* FROM publication p WHERE p.publicationID = '" + publicationID + "' LIMIT 1;");
                        if (rs2.next()) {
                            publication = new Publication(rs2);
                        }
                    } catch (Exception e) {
                    } finally {
                        MySQLDatabaseUtil.safeClose(rs2);
                    }
                }
            }
        } finally {
            // make sure this is a publication we want to cache
            if (publication != null && publication.isSet()) {
                // update the cache
                if (!publications.containsKey(publicationID)) {
                    // remove the last publication
                    while (publicationRecency.size() >= CACHE_LIMIT) {
                        publications.remove(publicationRecency.remove(0).publicationID);
                    }
                    // this is a new one
                    publications.put(publication.publicationID, publication);
                    publicationRecency.add(publication);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    publicationRecency.remove(publication);
                    publicationRecency.add(publication);
                }
            }
        }
        return publication;
    }

    public static synchronized List<Publication> getPublications(List<Integer> publicationIDs) {
        List<Publication> list = new LinkedList<Publication>();
        // get the publications that are in the cache
        List<Integer> toGetFromDatabase = new LinkedList<Integer>();
        for (int publicationID : publicationIDs) {
            if (publications.containsKey(publicationID)) {
                list.add(publications.get(publicationID));
            } else {
                toGetFromDatabase.add(publicationID);
            }
        }
        // get the remaining groups
        if (!toGetFromDatabase.isEmpty()) {
            String SQLFilter = "publicationID = '" + toGetFromDatabase.remove(0) + "'";
            for (int publicationID : toGetFromDatabase) {
                SQLFilter = SQLFilter + " OR publicationID = '" + publicationID + "'";
            }

            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM publication WHERE active = '1' AND (" + SQLFilter + ");");
                while (rs.next()) {
                    list.add(new Publication(rs));
                }
            } catch (Exception e) {
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
        // update the cache
        for (Publication publication : list) {
            if (publication != null && publication.isSet()) {
                // update the cache
                if (!publications.containsKey(publication.publicationID)) {
                    // remove the last group
                    while (publicationRecency.size() >= CACHE_LIMIT) {
                        publications.remove(publicationRecency.remove(0).publicationID);
                    }
                    // this is a new one
                    publications.put(publication.publicationID, publication);
                    publicationRecency.add(publication);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    publicationRecency.remove(publication);
                    publicationRecency.add(publication);
                }
            }
        }
        return Collections.unmodifiableList(list);
    }

    public static List<Publication> getPublications(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive) {
        return getPublications(filter, orderBy, orderByDir, page, perPage, mustBeActive, 0);
    }

    public static List<Publication> getPublications(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive, int userID) {
        String filterText = SearchUtil.makeSQLFilter(filter, quickSearchFields);
        if (mustBeActive) {
            if (!filterText.trim().equals("")) {
                filterText = filterText + " AND ";
            }
            filterText = filterText + " p.active = '1' ";
        }
        if (userID > 0) {
            if (!filterText.trim().equals("")) {
                filterText = filterText + " AND ";
            }
            filterText = filterText + " p.userID = '" + userID + "' ";
        }
        if (!filterText.trim().equals("")) {
            filterText = "WHERE " + filterText;
        }

        List<Publication> list = new ArrayList<Publication>();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT p.* FROM publication p " + filterText + " ORDER BY p." + orderBy + " " + orderByDir + " LIMIT " + (page - 1) * perPage + "," + perPage + ";");
            while (rs.next()) {
                list.add(getPublication(rs.getInt("publicationID"), rs));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        return list;
    }

    public static int getPublicationCount(String filter) {
        return getPublicationCount(filter, true);
    }

    public static int getPublicationCount(String filter, boolean mustBeActive) {
        return getPublicationCount(filter, 0, mustBeActive, 0);
    }

    public static int getPublicationCount(String filter, boolean mustBeActive, int userID) {
        return getPublicationCount(filter, 0, mustBeActive, userID);
    }

    public static int getPublicationCount(String filter, int limit, boolean mustBeActive, int userID) {
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
                filterText = filterText + " p.active = '1' ";
            }
            if (userID > 0) {
                if (!filterText.trim().equals("")) {
                    filterText = filterText + " AND ";
                }
                filterText = filterText + " p.userID = '" + userID + "' ";
            }
            if (!filterText.trim().equals("")) {
                filterText = "WHERE " + filterText;
            }

            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(p.publicationID) AS rows FROM publication p " + filterText + limitStr + ";");
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
