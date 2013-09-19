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
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import org.proteomecommons.mysql.MySQLDatabaseUtil;
import org.proteomecommons.www.user.User;
import org.proteomecommons.www.user.UserUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class MessageThread {

    public int threadID = -1;
    public List<Integer> messages = null;
    public List<Integer> fromUsers = null, toUsers = null;

    public MessageThread(int threadID) {
        try {
            this.threadID = threadID;
        } catch (Exception e) {
        }
    }

    public synchronized List<Message> getMessages() {
        if (messages == null) {
            reloadMessages();
        }
        return MessageUtil.getMessages(messages);
    }
    
    public synchronized Message getFirstMessage() {
        if (messages == null) {
            reloadMessages();
        }
        return MessageUtil.getMessage(messages.get(messages.size()-1));
    }
    
    public synchronized Message getLatestMessage() {
        if (messages == null) {
            reloadMessages();
        }
        return MessageUtil.getMessage(messages.get(0));
    }
    
    public synchronized void addMessage(int messageID) {
        if (messages == null) {
            reloadMessages();
        } else {
            if (!messages.contains(messageID)) {
                if (messages.isEmpty()) {
                    messages.add(messageID);
                } else {
                    messages.add(0, messageID);
                }
            } else {
                // remove from wherever it is
                messages.remove((Integer)messageID);
                // place at the top
                messages.add(0, messageID);
            }
        }
    }

    private synchronized void reloadMessages() {
        messages = new LinkedList<Integer>();
        ResultSet rs = null;
        try {
            rs = MySQLDatabaseUtil.executeQuery("SELECT messageID FROM message WHERE threadID = '" + threadID + "' ORDER BY date DESC;");
            while (rs.next()) {
                messages.add(rs.getInt("messageID"));
            }
        } catch (Exception e) {
        } finally {
            MySQLDatabaseUtil.safeClose(rs);
        }
    }
    
    public synchronized List <Integer> getFromUserIDs() {
        if (fromUsers == null) {
            reloadFromUsers();
        }
        return Collections.unmodifiableList(fromUsers);
    }
    
    public synchronized List<User> getFromUsers() {
        if (fromUsers == null) {
            reloadFromUsers();
        }
        return UserUtil.getUsers(fromUsers);
    }
    
    public synchronized void reloadFromUsers() {
        fromUsers = new LinkedList <Integer> ();
        // ensure each used is only added once
        Set <Integer> userSet = new HashSet <Integer> ();
        for (Message m : getMessages()) {
            userSet.add(m.userID);
        }
        // drop the user set into the user list
        for (Integer userID : userSet.toArray(new Integer[0])) {
            fromUsers.add(userID);
        }
    }
    
    public synchronized List <Integer> getToUserIDs() {
        if (toUsers == null) {
            reloadToUsers();
        }
        return Collections.unmodifiableList(toUsers);
    }
    
    public synchronized List<User> getToUsers() {
        if (toUsers == null) {
            reloadToUsers();
        }
        return UserUtil.getUsers(toUsers);
    }
    
    public synchronized void reloadToUsers() {
        toUsers = new LinkedList <Integer> ();
        // ensure each used is only added once
        Set <Integer> userSet = new HashSet <Integer> ();
        for (Message m : getMessages()) {
            for (MessageRecipient mr : m.getRecipients()) {
                userSet.add(mr.userID);
            }
        }
        // drop the user set into the user list
        for (Integer userID : userSet.toArray(new Integer[0])) {
            toUsers.add(userID);
        }
    }

    public boolean isSet() {
        return threadID > 0;
    }
}
