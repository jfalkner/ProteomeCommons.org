package org.proteomecommons.www.news;

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
public class NewsUtil {

    private static String[] quickSearchFields = new String[]{"n.title"};
    public static final int CACHE_LIMIT = 1000;
    private static Map<Integer, News> news = new HashMap<Integer, News>();
    private static List<News> newsRecency = new LinkedList<News>();

    public static boolean isInCache(int newsID) {
        return news.containsKey(newsID);
    }

    public static int getCacheSize() {
        return news.size();
    }

    public static News getNews(int newsID) {
        return getNews(newsID, null);
    }

    public static synchronized News getNews(int newsID, ResultSet rs) {
        // is the news in the cache?
        News newsItem = null;
        try {
            if (news.containsKey(newsID)) {
                newsItem = news.get(newsID);
            } else {
                newsItem = new News(rs);
                if (!newsItem.isSet()) {
                    ResultSet rs2 = null;
                    try {
                        rs2 = MySQLDatabaseUtil.executeQuery("SELECT n.* FROM news n WHERE n.newsID = '" + newsID + "' LIMIT 1;");
                        if (rs2.next()) {
                            newsItem = new News(rs2);
                        }
                    } catch (Exception e) {
                    } finally {
                        MySQLDatabaseUtil.safeClose(rs2);
                    }
                }
            }
        } finally {
            // make sure this is a news we want to cache
            if (newsItem != null && newsItem.isSet()) {
                // update the cache
                if (!news.containsKey(newsID)) {
                    // remove the last news
                    while (newsRecency.size() >= CACHE_LIMIT) {
                        news.remove(newsRecency.remove(0).newsID);
                    }
                    // this is a new one
                    news.put(newsItem.newsID, newsItem);
                    newsRecency.add(newsItem);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    newsRecency.remove(newsItem);
                    newsRecency.add(newsItem);
                }
            }
        }
        return newsItem;
    }

    public static synchronized List<News> getNews(List<Integer> newsIDs) {
        List<News> list = new LinkedList<News>();
        // get the links that are in the cache
        List<Integer> toGetFromDatabase = new LinkedList<Integer>();
        for (int newsID : newsIDs) {
            if (news.containsKey(newsID)) {
                list.add(news.get(newsID));
            } else {
                toGetFromDatabase.add(newsID);
            }
        }
        // get the remaining groups
        if (!toGetFromDatabase.isEmpty()) {
            String SQLFilter = "newsID = '" + toGetFromDatabase.remove(0) + "'";
            for (int newsID : toGetFromDatabase) {
                SQLFilter = SQLFilter + " OR newsID = '" + newsID + "'";
            }

            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM news WHERE active = '1' AND (" + SQLFilter + ");");
                while (rs.next()) {
                    list.add(new News(rs));
                }
            } catch (Exception e) {
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
        // update the cache
        for (News n : list) {
            if (n != null && n.isSet()) {
                // update the cache
                if (!news.containsKey(n.newsID)) {
                    // remove the last group
                    while (newsRecency.size() >= CACHE_LIMIT) {
                        news.remove(newsRecency.remove(0).newsID);
                    }
                    // this is a new one
                    news.put(n.newsID, n);
                    newsRecency.add(n);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    newsRecency.remove(n);
                    newsRecency.add(n);
                }
            }
        }
        return Collections.unmodifiableList(list);
    }

    public static List<News> getNews(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive) {
        return getNews(filter, orderBy, orderByDir, page, perPage, mustBeActive, 0);
    }

    public static List<News> getNews(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive, int userID) {
        String filterText = SearchUtil.makeSQLFilter(filter, quickSearchFields);
        if (mustBeActive) {
            if (!filterText.trim().equals("")) {
                filterText = filterText + " AND ";
            }
            filterText = filterText + " n.active = '1' ";
        }
        if (userID > 0) {
            if (!filterText.trim().equals("")) {
                filterText = filterText + " AND ";
            }
            filterText = filterText + " n.userID = '" + userID + "' ";
        }
        if (!filterText.trim().equals("")) {
            filterText = "WHERE " + filterText;
        }

        List<News> list = new ArrayList<News>();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT n.* FROM news n " + filterText + " ORDER BY n." + orderBy + " " + orderByDir + " LIMIT " + (page - 1) * perPage + "," + perPage + ";");
            while (rs.next()) {
                list.add(getNews(rs.getInt("newsID"), rs));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        return list;
    }

    public static int getNewsCount(String filter) {
        return getNewsCount(filter, true);
    }

    public static int getNewsCount(String filter, boolean mustBeActive) {
        return getNewsCount(filter, 0, mustBeActive);
    }
    
    public static int getNewsCount(String filter, boolean mustBeActive, int userID) {
        return getNewsCount(filter, 0, mustBeActive, userID);
    }

    public static int getNewsCount(String filter, int limit, boolean mustBeActive) {
        return getNewsCount(filter, limit, mustBeActive, 0);
    }

    public static int getNewsCount(String filter, int limit, boolean mustBeActive, int userID) {
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
                filterText = filterText + " n.active = '1' ";
            }
            if (userID > 0) {
                if (!filterText.trim().equals("")) {
                    filterText = filterText + " AND ";
                }
                filterText = filterText + " n.userID = '" + userID + "' ";
            }
            if (!filterText.trim().equals("")) {
                filterText = "WHERE " + filterText;
            }
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(n.newsID) AS rows FROM news n " + filterText + limitStr + ";");
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
