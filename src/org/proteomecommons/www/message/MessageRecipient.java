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
package org.proteomecommons.www.message;

import java.sql.ResultSet;
import org.proteomecommons.mysql.MySQLDatabaseUtil;
import org.proteomecommons.www.user.User;
import org.proteomecommons.www.user.UserUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class MessageRecipient {

    public int messageID = -1, userID = -1;
    public boolean isRead = false, active = false;
    
    public MessageRecipient(ResultSet rs) {
        try {
            messageID = rs.getInt("messageID");
            userID = rs.getInt("userID");
            isRead = rs.getBoolean("isRead");
            active = rs.getBoolean("active");
        } catch (Exception e) {
        }
    }
    
    public void markAsRead(boolean value) throws Exception {
        if (value) {
            if (!isRead) {
                if (!MySQLDatabaseUtil.executeUpdate("UPDATE message_recipient SET isRead = '1' WHERE messageID = '"+messageID+"' AND userID = '"+userID+"';")) {
                    throw new Exception("Could not mark as read.");
                } else {
                    isRead = true;
                }
            }
        } else {
            if (isRead) {
                if (!MySQLDatabaseUtil.executeUpdate("UPDATE message_recipient SET isRead = '0' WHERE messageID = '"+messageID+"' AND userID = '"+userID+"';")) {
                    throw new Exception("Could not mark as unread.");
                } else {
                    isRead = false;
                }
            }
        }
    }
    
    public Message getMessage() {
        return MessageUtil.getMessage(messageID);
    }
    
    public User getUser() {
        return UserUtil.getUser(userID);
    }
    
    public boolean isSet() {
        return messageID > 0 && userID > 0;
    }
    
}
