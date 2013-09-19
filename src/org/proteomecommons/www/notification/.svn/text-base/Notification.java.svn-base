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
package org.proteomecommons.www.notification;

import java.sql.ResultSet;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class Notification {

    public int notificationID = -1;
    public String date = null, notification = null;
    
    public Notification(ResultSet rs) {
        try {
            notificationID = rs.getInt("notificationID");
            date = rs.getString("date");
            notification = rs.getString("notification");
        } catch (Exception e) {
        }
    }
    
    public boolean isSet() {
        return notification != null;
    }
}
