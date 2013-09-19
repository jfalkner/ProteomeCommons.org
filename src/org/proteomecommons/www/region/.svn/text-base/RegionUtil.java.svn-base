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
package org.proteomecommons.www.region;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import org.proteomecommons.mysql.MySQLDatabaseUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class RegionUtil {

    private static HashMap<Integer, Region> regions = new HashMap<Integer, Region>();
    private static HashMap<Integer, ArrayList<Region>> countryRegions = new HashMap<Integer, ArrayList<Region>>();
    private static Thread lazyLoadThread = new Thread("Region Lazy Load Thread") {

        @Override
        public void run() {
            lazyLoadStarted = true;
            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM region WHERE countryID >= 0 AND regionID >= 0 ORDER BY region ASC;");
                while (rs.next()) {
                    try {
                        int regionID = rs.getInt("regionID"), countryID = rs.getInt("countryID");
                        Region region = new Region(rs);

                        regions.put(regionID, region);

                        if (!countryRegions.containsKey(countryID)) {
                            countryRegions.put(countryID, new ArrayList<Region>());
                        }
                        countryRegions.get(countryID).add(region);
                    } catch (Exception e) {
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                MySQLDatabaseUtil.safeClose(rs);
            }
        }
    };
    private static boolean lazyLoaded = false,  lazyLoadStarted = false;

    private static void lazyLoad() {
        if (!lazyLoaded) {
            lazyLoaded = true;
            lazyLoadThread.start();
        }
        while (lazyLoadThread.isAlive() || !lazyLoadStarted) {
            try {
                lazyLoadThread.join();
            } catch (Exception e) {
            }
        }
    }

    public static Region getRegion(int regionID) {
        lazyLoad();
        return regions.get(regionID);
    }

    public static List<Region> getRegionsInCountry(int countryID) {
        lazyLoad();
        ArrayList<Region> list = countryRegions.get(countryID);
        if (list == null) {
            return Collections.unmodifiableList(new ArrayList<Region>());
        } else {
            return Collections.unmodifiableList(list);
        }
    }
}
