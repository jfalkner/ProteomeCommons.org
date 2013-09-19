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
package org.proteomecommons.www.report;

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
public class ReportUtil {

    public static final int CACHE_LIMIT = 1000;
    private static String[] quickSearchFields = new String[]{"r.reason", "r.link"};
    private static Map<Integer, Report> reports = new HashMap<Integer, Report>();
    private static List<Report> reportRecency = new LinkedList<Report>();
    
    public static boolean isReportOutstandingAgainst(String table, String field, int id) {
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(reportID) AS rows FROM report WHERE fieldTable = '"+table+"' AND fieldName = '"+field+"' AND fieldID = '"+id+"' AND (status = 'Under Review' OR status = 'Agreed') LIMIT 1;");
            rs.next();
            return rs.getInt("rows") == 1;
        } catch (Exception e) {
            return false;
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
    
    public static Report getReport(int reportID) {
        return getReport(reportID, null);
    }
    
    public static synchronized Report getReport(int reportID, ResultSet rs) {
        // is the report in the cache?
        Report report = null;
        try {
            if (reports.containsKey(reportID)) {
                report = reports.get(reportID);
            } else {
                report = new Report(rs);
                if (!report.isSet()) {
                    ResultSet rs2 = null;
                    try {
                        rs2 = MySQLDatabaseUtil.executeQuery("SELECT * FROM report WHERE reportID = '" + reportID + "' LIMIT 1;");
                        if (rs2.next()) {
                            report = new Report(rs2);
                        }
                    } catch (Exception e) {
                    } finally {
                        MySQLDatabaseUtil.safeClose(rs2);
                    }
                }
            }
        } finally {
            // make sure this is a tool we want to cache
            if (report != null && report.isSet()) {
                // update the cache
                if (!reports.containsKey(reportID)) {
                    // remove the last report
                    while (reportRecency.size() >= CACHE_LIMIT) {
                        reports.remove(reportRecency.remove(0).reportID);
                    }
                    // this is a new one
                    reports.put(report.reportID, report);
                    reportRecency.add(report);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    reportRecency.remove(report);
                    reportRecency.add(report);
                }
            }
        }
        return report;
    }
    
    public static synchronized List <Report> getReports(List <Integer> reportIDs) {
        List <Report> list = new LinkedList <Report> ();
        // get the reports that are in the cache
        List <Integer> toGetFromDatabase = new LinkedList <Integer> ();
        for (int reportID : reportIDs) {
            if (reports.containsKey(reportID)) {
                list.add(reports.get(reportID));
            } else {
                toGetFromDatabase.add(reportID);
            }
        }
        // get the remaining groups
        if (!toGetFromDatabase.isEmpty()) {
            String SQLFilter = "reportID = '"+toGetFromDatabase.remove(0)+"'";
            for (int reportID : toGetFromDatabase) {
                SQLFilter = SQLFilter + " OR reportID = '"+reportID+"'";
            }
            
            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM report WHERE "+SQLFilter+";");
                while (rs.next()) {
                    list.add(new Report(rs));
                }
            } catch (Exception e) {
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
        // update the cache
        for (Report report : list) {
            if (report != null && report.isSet()) {
                // update the cache
                if (!reports.containsKey(report.reportID)) {
                    // remove the last group
                    while (reportRecency.size() >= CACHE_LIMIT) {
                        reports.remove(reportRecency.remove(0).reportID);
                    }
                    // this is a new one
                    reports.put(report.reportID, report);
                    reportRecency.add(report);
                } else {
                    // remove from the middle of the line and add as most recently accessed
                    reportRecency.remove(report);
                    reportRecency.add(report);
                }
            }
        }
        return Collections.unmodifiableList(list);
    }
    
    public static List<Report> getReports(String filter, String orderBy, String orderByDir, int page, int perPage) {
        String filterText = SearchUtil.makeSQLFilter(filter, quickSearchFields);
        
        List <Report> list = new ArrayList<Report>();
        ResultSet rs = null;
        try {
            if (!filterText.equals("")) {
                filterText = "WHERE " + filterText;
            }
            rs = MySQLDatabaseUtil.executeQuery("SELECT r.* FROM report r " + filterText + " ORDER BY r." + orderBy + " " + orderByDir + " LIMIT " + (page - 1) * perPage + "," + perPage + ";");
            while (rs.next()) {
                list.add(getReport(rs.getInt("reportID"), rs));
            }
        } catch (Exception e) { 
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
        return Collections.unmodifiableList(list);
    }
    
    public static int getReportCount(String filter) {
        return getReportCount(filter, 0);
    }
    
    public static int getReportCount(String filter, int limit) {
        ResultSet rs = null;
        try {
            String limitStr = "";
            if (limit > 0) {
                limitStr = " LIMIT " + limit + " ";
            }
            String filterText = SearchUtil.makeSQLFilter(filter, quickSearchFields);
            if (!filterText.equals("")) {
                filterText = "WHERE " + filterText;
            }
            rs = MySQLDatabaseUtil.executeQuery("SELECT COUNT(r.reportID) AS rows FROM report r " + filterText + limitStr + ";");
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
