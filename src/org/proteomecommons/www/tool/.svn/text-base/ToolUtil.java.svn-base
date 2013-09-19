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
package org.proteomecommons.www.tool;

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
public class ToolUtil {

    private static String[] quickSearchFields = new String[]{"t.name"};
    public static final int CACHE_LIMIT = 1000;
    private static Map<Integer, Tool> tools = new HashMap<Integer, Tool>();
    private static List<Tool> toolRecency = new LinkedList<Tool>();

    public static boolean isInCache(int toolID) {
        return tools.containsKey(toolID);
    }

    public static int getCacheSize() {
        return tools.size();
    }

    public static Tool getTool(int toolID) {
        return getTool(toolID, null);
    }

    public static synchronized Tool getTool(int toolID, ResultSet rs) {
        // is the tool in the cache?
        Tool tool = null;
        try {
            if (tools.containsKey(toolID)) {
                tool = tools.get(toolID);
            } else {
                tool = new Tool(rs);
                if (!tool.isSet()) {
                    ResultSet rs2 = null;
                    try {
                        rs2 = MySQLDatabaseUtil.executeQuery("SELECT t.* FROM tool t WHERE t.toolID = '" + toolID + "' LIMIT 1;");
                        if (rs2.next()) {
                            tool = new Tool(rs2);
                        }
                    } catch (Exception e) {
                    } finally {
                        MySQLDatabaseUtil.safeClose(rs2);
                    }
                }
            }
        } finally {
            // make sure this is a tool we want to cache
            if (tool != null && tool.isSet()) {
                // update the cache
                if (!tools.containsKey(toolID)) {
                    // remove the last tool
                    while (toolRecency.size() >= CACHE_LIMIT) {
                        tools.remove(toolRecency.remove(0).toolID);
                    }
                    // this is a new one
                    tools.put(tool.toolID, tool);
                    toolRecency.add(tool);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    toolRecency.remove(tool);
                    toolRecency.add(tool);
                }
            }
        }
        return tool;
    }

    public static synchronized List<Tool> getTools(List<Integer> toolIDs) {
        List<Tool> list = new LinkedList<Tool>();
        // get the tools that are in the cache
        List<Integer> toGetFromDatabase = new LinkedList<Integer>();
        for (int toolID : toolIDs) {
            if (tools.containsKey(toolID)) {
                list.add(tools.get(toolID));
            } else {
                toGetFromDatabase.add(toolID);
            }
        }
        // get the remaining groups
        if (!toGetFromDatabase.isEmpty()) {
            String SQLFilter = "toolID = '" + toGetFromDatabase.remove(0) + "'";
            for (int toolID : toGetFromDatabase) {
                SQLFilter = SQLFilter + " OR toolID = '" + toolID + "'";
            }

            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM tool WHERE active = '1' AND (" + SQLFilter + ");");
                while (rs.next()) {
                    list.add(new Tool(rs));
                }
            } catch (Exception e) {
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
        // update the cache
        for (Tool tool : list) {
            if (tool != null && tool.isSet()) {
                // update the cache
                if (!tools.containsKey(tool.toolID)) {
                    // remove the last group
                    while (toolRecency.size() >= CACHE_LIMIT) {
                        tools.remove(toolRecency.remove(0).toolID);
                    }
                    // this is a new one
                    tools.put(tool.toolID, tool);
                    toolRecency.add(tool);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    toolRecency.remove(tool);
                    toolRecency.add(tool);
                }
            }
        }
        return Collections.unmodifiableList(list);
    }

    public static List<Tool> getTools(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive) {
        return getTools(filter, orderBy, orderByDir, page, perPage, mustBeActive, 0);
    }

    public static List<Tool> getTools(String filter, String orderBy, String orderByDir, int page, int perPage, boolean mustBeActive, int userID) {
        String filterText = SearchUtil.makeSQLFilter(filter, quickSearchFields);
        if (mustBeActive) {
            if (!filterText.trim().equals("")) {
                filterText = filterText + " AND ";
            }
            filterText = filterText + " t.active = '1' ";
        }
        if (userID > 0) {
            if (!filterText.trim().equals("")) {
                filterText = filterText + " AND ";
            }
            filterText = filterText + " t.userID = '" + userID + "' ";
        }
        if (!filterText.trim().equals("")) {
            filterText = "WHERE " + filterText;
        }

        List<Tool> list = new ArrayList<Tool>();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT t.* FROM tool t " + filterText + " ORDER BY t." + orderBy + " " + orderByDir + " LIMIT " + (page - 1) * perPage + "," + perPage + ";");
            while (rs.next()) {
                list.add(getTool(rs.getInt("toolID"), rs));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        return list;
    }

    public static int getToolCount(String filter) {
        return getToolCount(filter, true);
    }

    public static int getToolCount(String filter, boolean mustBeActive) {
        return getToolCount(filter, 0, mustBeActive, 0);
    }
    
    public static int getToolCount(String filter, boolean mustBeActive, int userID) {
        return getToolCount(filter, 0, mustBeActive, userID);
    }

    public static int getToolCount(String filter, int limit, boolean mustBeActive, int userID) {
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
                filterText = filterText + " t.active = '1' ";
            }
            if (userID > 0) {
                if (!filterText.trim().equals("")) {
                    filterText = filterText + " AND ";
                }
                filterText = filterText + " t.userID = '" + userID + "' ";
            }
            if (!filterText.trim().equals("")) {
                filterText = "WHERE " + filterText;
            }
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(t.toolID) AS rows FROM tool t " + filterText + limitStr + ";");
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
