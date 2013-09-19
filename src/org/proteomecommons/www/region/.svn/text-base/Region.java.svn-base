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
import org.proteomecommons.www.country.Country;
import org.proteomecommons.www.country.CountryUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class Region {

    public int regionID = -1;
    public String region = null,  regionCode = null;
    public Country country = null;

    public Region(ResultSet rs) {
        try {
            this.regionID = rs.getInt("regionID");
            this.region = rs.getString("region");
            this.regionCode = rs.getString("regionCode");
            this.country = CountryUtil.getCountry(rs.getInt("countryID"));
        } catch (Exception e) {
        }

    }

    public Region(int regionID, String region, String regionCode, int countryID) {
        this.regionID = regionID;
        this.region = region;
        this.regionCode = regionCode;
        this.country = CountryUtil.getCountry(countryID);
    }
}
