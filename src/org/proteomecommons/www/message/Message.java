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
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.proteomecommons.mysql.MySQLDatabaseUtil;
import org.proteomecommons.www.reference.Reference;
import org.proteomecommons.www.reference.ReferenceUtil;
import org.proteomecommons.www.user.User;
import org.proteomecommons.www.user.UserUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class Message {

    public int messageID = -1, threadID = -1, userID = -1;
    public String subject = null, message = null, date = null;
    public List <MessageRecipient> recipients = null;
    public Map <Integer, MessageRecipient> recipientsMap = null;
    public List <Integer> references = null;
    
    public Message(ResultSet rs) {
        try {
            messageID = rs.getInt("messageID");
            threadID = rs.getInt("threadID");
            userID = rs.getInt("userID");
            subject = rs.getString("subject");
            message = rs.getString("message");
            date = rs.getString("date");
        } catch (Exception e) {
        }
    }
    
    public synchronized List <MessageRecipient> getRecipients() {
        if (recipients == null || recipientsMap == null) {
            reloadRecipients();
        }
        return Collections.unmodifiableList(recipients);
    }
    
    public synchronized MessageRecipient getRecipient(int userID) {
        if (recipients == null || recipientsMap == null) {
            reloadRecipients();
        }
        try {
            return recipientsMap.get(userID);
        } catch (Exception e) {
            return null;
        }
    }
    
    public synchronized boolean isRecipient(int userID) {
        if (recipients == null || recipientsMap == null) {
            reloadRecipients();
        }
        return recipientsMap.containsKey(userID);
    }
    
    public synchronized void reloadRecipients() {
        recipients = new LinkedList <MessageRecipient> ();
        recipientsMap = new HashMap <Integer, MessageRecipient> ();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT * FROM message_recipient WHERE messageID = '"+messageID+"';");
            while (rs.next()) {
                MessageRecipient mr = new MessageRecipient(rs);
                recipients.add(mr);
                recipientsMap.put(mr.userID, mr);
            }
        } catch (Exception e) { 
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
    
    public User getUser() {
        return UserUtil.getUser(userID);
    }
    
    public synchronized List<Reference> getReferences() {
        if (references == null) {
            reloadReferences();
        }
        return ReferenceUtil.getReferences(references);
    }
    
    public synchronized void reloadReferences() {
        references = ReferenceUtil.getReferenceIDsFrom("message", "messageID", messageID, false);
    }
    
    public boolean isSet() {
        return message != null;
    }
    
}
