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

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class Country {

    public int countryID = -1;
    public String country = null,  countryCode = null,  countryCode3 = null;

    public Country(ResultSet rs) {
        try {
            this.countryID = rs.getInt("countryID");
            this.country = rs.getString("country");
            this.countryCode = rs.getString("countryCode");
            this.countryCode3 = rs.getString("countryCode3");
        } catch (Exception e) {
        }
    }

    public Country(int countryID, String country, String countryCode, String countryCode3) {
        this.countryID = countryID;
        this.country = country;
        this.countryCode = countryCode;
        this.countryCode3 = countryCode3;
    }
}
