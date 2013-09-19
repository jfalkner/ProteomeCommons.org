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
import org.proteomecommons.www.user.User;
import org.proteomecommons.www.user.UserUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class Report {

    public int reportID = -1, userID = -1, linkUserID = -1;
    public String fieldTable = null, fieldName = null, fieldID = null, reason = null, date = null, link = null, status = null;
    
    public Report(ResultSet rs) {
        try {
            reportID = rs.getInt("reportID");
            userID = rs.getInt("userID");
            fieldTable = rs.getString("fieldTable");
            fieldName = rs.getString("fieldName");
            fieldID = rs.getString("fieldID");
            reason = rs.getString("reason");
            date = rs.getString("date");
            link = rs.getString("link");
            linkUserID = rs.getInt("linkUserID");
            status = rs.getString("status");
        } catch (Exception e) {
        }
    }
    
    public User getUser() {
        return UserUtil.getUser(userID);
    }
    
    public User getLinkUser() {
        return UserUtil.getUser(linkUserID);
    }
    
    public boolean isSet() {
        return status != null;
    }
    
}
