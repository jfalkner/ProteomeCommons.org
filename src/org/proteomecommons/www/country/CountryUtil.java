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
package org.proteomecommons.www.country;

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
public class CountryUtil {

    private static HashMap<Integer, Country> countriesByID = new HashMap<Integer, Country>();
    private static HashMap<String, Country> countriesByName = new HashMap<String, Country>();
    private static ArrayList<Country> sortedCountries = new ArrayList<Country>();
    private static Thread lazyLoadThread = new Thread("Country Lazy Load Thread") {

        @Override
        public void run() {
            lazyLoadStarted = true;
            ResultSet rs = null;
            try {
                rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM country WHERE countryID >= 0 ORDER BY country ASC;");
                while (rs.next()) {
                    try {
                        Country c = new Country(rs);
                        countriesByID.put(rs.getInt("countryID"), c);
                        countriesByName.put(rs.getString("country"), c);
                        sortedCountries.add(c);
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

    public static Country getCountry(int countryID) {
        lazyLoad();
        return countriesByID.get(countryID);
    }

    public static Country getCountry(String country) {
        lazyLoad();
        return countriesByName.get(country);
    }

    public static List<Country> getCountries() {
        lazyLoad();
        return Collections.unmodifiableList(sortedCountries);
    }
}
