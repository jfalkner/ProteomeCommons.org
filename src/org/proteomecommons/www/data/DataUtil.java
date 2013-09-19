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
package org.proteomecommons.www.data;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.proteomecommons.mysql.MySQLDatabaseUtil;
import org.proteomecommons.www.SearchUtil;
import org.tranche.hash.BigHash;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class DataUtil {

    private static String[] quickSearchFields = new String[]{"d.hash", "d.title"};
    public static final int CACHE_LIMIT = 1000;
    private static Map<Integer, Data> data = new HashMap<Integer, Data>();
    private static Map<String, Data> dataByHash = new HashMap<String, Data>();
    private static List<Data> dataRecency = new LinkedList<Data>();

    public static boolean isInCache(int dataID) {
        return data.containsKey(dataID);
    }

    public static int getCacheSize() {
        return data.size();
    }

    public static Data getData(BigHash hash) {
        // is the data in the cache?
        Data dataItem = null;
        try {
            if (dataByHash.containsKey(hash.toString())) {
                dataItem = dataByHash.get(hash.toString());
            } else {
                ResultSet rs = null;
                try {
                    rs = MySQLDatabaseUtil.executeQuery("SELECT d.* FROM data d WHERE d.hash = '" + hash.toString() + "' LIMIT 1;");
                    if (rs.next()) {
                        dataItem = new Data(rs);
                    }
                } catch (Exception e) {
                } finally {
                    MySQLDatabaseUtil.safeClose(rs);
                }
            }
        } finally {
            // make sure this is a data we want to cache
            if (dataItem != null && dataItem.isSet()) {
                // update the cache
                if (!data.containsKey(dataItem.dataID)) {
                    // remove the last data
                    while (dataRecency.size() >= CACHE_LIMIT) {
                        Data dataRemoved = data.remove(dataRecency.remove(0).dataID);
                        dataByHash.remove(dataRemoved.hash.toString());
                    }
                    // this is a new one
                    data.put(dataItem.dataID, dataItem);
                    dataRecency.add(dataItem);
                    dataByHash.put(dataItem.hash.toString(), dataItem);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    dataRecency.remove(dataItem);
                    dataRecency.add(dataItem);
                }
            }
        }
        return dataItem;
    }
    
    public static Data getData(int dataID) {
        return getData(dataID, null);
    }

    public static synchronized Data getData(int dataID, ResultSet rs) {
        // is the data in the cache?
        Data dataItem = null;
        try {
            if (data.containsKey(dataID)) {
                dataItem = data.get(dataID);
            } else {
                dataItem = new Data(rs);
                if (!dataItem.isSet()) {
                    ResultSet rs2 = null;
                    try {
                        rs2 = MySQLDatabaseUtil.executeQuery("SELECT d.* FROM data d WHERE d.dataID = '" + dataID + "' LIMIT 1;");
                        if (rs2.next()) {
                            dataItem = new Data(rs2);
                        }
                    } catch (Exception e) {
                    } finally {
                        MySQLDatabaseUtil.safeClose(rs2);
                    }
                }
            }
        } finally {
            // make sure this is a data we want to cache
            if (dataItem != null && dataItem.isSet()) {
                // update the cache
                if (!data.containsKey(dataID)) {
                    // remove the last data
                    while (dataRecency.size() >= CACHE_LIMIT) {
                        data.remove(dataRecency.remove(0).dataID);
                    }
                    // this is a new one
                    data.put(dataItem.dataID, dataItem);
                    dataRecency.add(dataItem);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    dataRecency.remove(dataItem);
                    dataRecency.add(dataItem);
                }
            }
        }
        return dataItem;
    }

    public static synchronized List<Data> getData(List<Integer> dataIDs) {
        List<Data> list = new LinkedList<Data>();
        // get the groups that are in the cache
        List<Integer> toGetFromDatabase = new LinkedList<Integer>();
        for (int dataID : dataIDs) {
            if (data.containsKey(dataID)) {
                list.add(data.get(dataID));
            } else {
                toGetFromDatabase.add(dataID);
            }
        }
        // get the remaining groups
        if (!toGetFromDatabase.isEmpty()) {
            String SQLFilter = "dataID = '" + toGetFromDatabase.remove(0) + "'";
            for (int dataID : toGetFromDatabase) {
                SQLFilter = SQLFilter + " OR dataID = '" + dataID + "'";
            }

            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM data WHERE active = '1' AND (" + SQLFilter + ");");
                while (rs.next()) {
                    list.add(new Data(rs));
                }
            } catch (Exception e) {
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
        // update the cache
        for (Data d : list) {
            if (d != null && d.isSet()) {
                // update the cache
                if (!data.containsKey(d.dataID)) {
                    // remove the last group
                    while (dataRecency.size() >= CACHE_LIMIT) {
                        data.remove(dataRecency.remove(0).dataID);
                    }
                    // this is a new one
                    data.put(d.dataID, d);
                    dataRecency.add(d);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    dataRecency.remove(d);
                    dataRecency.add(d);
                }
            }
        }
        return Collections.unmodifiableList(list);
    }

    public static List<Data> getData(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive) {
        return getData(filter, orderBy, orderByDir, page, perPage, mustBeActive, 0);
    }

    public static List<Data> getData(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive, int userID) {
        String filterText = SearchUtil.makeSQLFilter(filter, quickSearchFields);
        if (mustBeActive) {
            if (!filterText.trim().equals("")) {
                filterText = filterText + " AND ";
            }
            filterText = filterText + " d.active = '1' ";
        }
        if (userID > 0) {
            if (!filterText.trim().equals("")) {
                filterText = filterText + " AND ";
            }
            filterText = filterText + " d.userID = '" + userID + "' ";
        }
        if (!filterText.trim().equals("")) {
            filterText = "WHERE " + filterText;
        }

        List<Data> list = new ArrayList<Data>();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT d.* FROM data d " + filterText + " ORDER BY d." + orderBy + " " + orderByDir + " LIMIT " + (page - 1) * perPage + "," + perPage + ";");
            while (rs.next()) {
                list.add(getData(rs.getInt("dataID"), rs));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        return list;
    }

    public static int getDataCount(String filter) {
        return getDataCount(filter, true, 0);
    }

    public static int getDataCount(String filter, boolean mustBeActive) {
        return getDataCount(filter, 0, mustBeActive, 0);
    }

    public static int getDataCount(String filter, boolean mustBeActive, int userID) {
        return getDataCount(filter, 0, mustBeActive, userID);
    }

    public static int getDataCount(String filter, int limit, boolean mustBeActive, int userID) {
        ResultSet rs = null;
        try {
            String filterText = SearchUtil.makeSQLFilter(filter, quickSearchFields);
            if (mustBeActive) {
                if (!filterText.trim().equals("")) {
                    filterText = filterText + " AND ";
                }
                filterText = filterText + " d.active = '1' ";
            }
            if (userID > 0) {
                if (!filterText.trim().equals("")) {
                    filterText = filterText + " AND ";
                }
                filterText = filterText + " d.userID = '" + userID + "' ";
            }
            if (!filterText.trim().equals("")) {
                filterText = "WHERE " + filterText;
            }
            String limitStr = "";
            if (limit > 0) {
                limitStr = " LIMIT " + limit + " ";
            }
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(d.dataID) AS rows FROM data d " + filterText + limitStr + ";");
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
